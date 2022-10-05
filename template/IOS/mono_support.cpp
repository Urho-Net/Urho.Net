#ifdef _WIN32
#ifndef _MSC_VER
#define _WIN32_IE 0x501
#endif
#include <direct.h>
#include <io.h>
#include <shellapi.h>
#include <shlobj.h>
#include <sys/types.h>
#include <sys/utime.h>
#include <windows.h>
#else
#include <cerrno>
#include <dirent.h>
#include <sys/wait.h>
#include <unistd.h>
#include <utime.h>
#endif

#include "MonoEmbed.h"

#ifndef _TESTCASE_
#include <mono/jit/jit.h>
#endif

#include <mono/metadata/assembly.h>
#include <mono/metadata/environment.h>
#include <mono/metadata/mono-config.h>
#include <mono/metadata/mono-debug.h>
#include <mono/utils/mono-logger.h>
#include <mono/utils/mono-publib.h>
#include <mono/jit/mono-private-unstable.h>
#include <mono/utils/mono-dl-fallback.h>
#include <stdlib.h>

#include "../Container/Str.h"
#include "../Core/Context.h"
#include "../Core/ProcessUtils.h"
#include "../IO/File.h"
#include "../IO/FileSystem.h"
#include "../IO/Log.h"
#include "../Resource/ResourceCache.h"

#include "mono_support.h"

#ifdef __ANDROID__
#include <android/log.h>
#include <jni.h>
#endif

using namespace Urho3D;

static HashMap<uint32_t, HashMap<String, MonoAssembly*>> assemblies;

MonoAssembly* urho3d_mono_assembly_preload(MonoAssemblyName* aname, char** assemblies_path, void* user_data,
                                           bool refonly);
MonoAssembly* urho3d_mono_load_assembly(Urho3D::Context* context, const String& p_path, bool p_refonly,
                                        MonoAssemblyName* p_aname);
MonoAssembly* urho3d_mono_assembly_preload_hook(MonoAssemblyName* aname, char** assemblies_path, void* user_data);
MonoAssembly* urho3d_mono_assembly_refonly_preload_hook(MonoAssemblyName* aname, char** assemblies_path,
                                                        void* user_data);
void urho3d_mono_assembly_load_hook(MonoAssembly* assembly, void* user_data);

void urho3d_mono_decrypt(unsigned char * in , int c ,unsigned char *out);

void log_message(String text)
{
#if defined(__ANDROID__)
    __android_log_print(  ANDROID_LOG_WARN , "Urho3D", "%s", text.CString());
#else
    printf("%s", text.CString());
#endif
}

unsigned char *
urho3d_load_aot_data (MonoAssembly *assembly, int size, void *user_data, void **out_handle)
{
    *out_handle = NULL;


    MonoAssemblyName *assembly_name = mono_assembly_get_name (assembly);
    const char *aname = mono_assembly_name_get_name (assembly_name);

    Urho3D::Context* context = (Urho3D::Context*)user_data;
    ResourceCache* cache = context->GetSubsystem<ResourceCache>();

    String path = fixPathString(urho3d_get_dotnet_folder() + aname+".aotdata");

    SharedPtr<File> assembly_file = cache->GetFile(path);
    if (assembly_file && assembly_file->IsOpen())
    {
        // String name = String(mono_assembly_name_get_name(p_aname));

        unsigned fileSize = assembly_file->GetSize();
        unsigned char * buffer = new unsigned char[fileSize];

        unsigned bytesRead = assembly_file->Read(buffer, fileSize);

        if (bytesRead == fileSize)
        {
            *out_handle = buffer;
            return buffer;
        }

    }

    return NULL;
}

void
urho3d_free_aot_data (MonoAssembly *assembly, int size, void *user_data, void *handle)
{
    unsigned char * buffer = (unsigned char * )handle;
    if(buffer != NULL )
    {
        delete buffer;
    }
    
}

void urho3d_add_assembly(uint32_t p_domain_id, String name, MonoAssembly* p_assembly)
{
    assemblies[p_domain_id][name] = p_assembly;
}

MonoAssembly* urho3d_get_loaded_assembly(const String& p_name)
{
    MonoDomain* domain = mono_domain_get();
    uint32_t domain_id = domain ? mono_domain_get_id(domain) : 0;
    MonoAssembly* result = assemblies[domain_id][p_name];
    return result ? result : NULL;
}


MonoAssembly* urho3d_mono_load_encrypted_assembly(Urho3D::Context* context, const String& p_path, bool p_refonly,
                                        MonoAssemblyName* p_aname)
{

    ResourceCache* cache = context->GetSubsystem<ResourceCache>();
    MonoImageOpenStatus status = MONO_IMAGE_OK;

    SharedPtr<File> assembly_file = cache->GetFile(p_path);
    if (assembly_file && assembly_file->IsOpen())
    {
        String fileName = GetFileNameAndExtension(p_path);

        unsigned fileSize = assembly_file->GetSize();
        SharedArrayPtr<unsigned char> eb(new unsigned char[fileSize]);
        SharedArrayPtr<unsigned char> db(new unsigned char[fileSize]);

        unsigned bytesRead = assembly_file->Read(eb.Get(), fileSize);
 
        if (bytesRead == fileSize)
        {
            urho3d_mono_decrypt(eb.Get() , fileSize ,db.Get());

            unsigned char* data = db.Get();

            MonoImage* image =
                mono_image_open_from_data_with_name((char*)data, bytesRead, true, &status, p_refonly, fileName.CString());

            if (status == MONO_IMAGE_OK)
            {
                if (p_aname != nullptr)
                {
                    // Check assembly version
                    const MonoTableInfo* table = mono_image_get_table_info(image, MONO_TABLE_ASSEMBLY);

                    assert(table);

                    if (mono_table_info_get_rows(table))
                    {
                        uint32_t cols[MONO_ASSEMBLY_SIZE];
                        mono_metadata_decode_row(table, 0, cols, MONO_ASSEMBLY_SIZE);

                        // Not sure about .NET's policy. We will only ensure major and minor are equal, and ignore build
                        // and revision.
                        uint16_t major = cols[MONO_ASSEMBLY_MAJOR_VERSION];
                        uint16_t minor = cols[MONO_ASSEMBLY_MINOR_VERSION];

                        uint16_t required_minor;
                        uint16_t required_major =
                            mono_assembly_name_get_version(p_aname, &required_minor, nullptr, nullptr);

                        if (required_major != 0)
                        {
                            if (major != required_major && minor != required_minor)
                            {
                                mono_image_close(image);
                                return nullptr;
                            }
                        }
                    }
                }

                status = MONO_IMAGE_OK;

                MonoAssembly* assembly = mono_assembly_load_from_full(image, fileName.CString(), &status, p_refonly);

                assert(status == MONO_IMAGE_OK && assembly && "Failed to load assembly for image");

                // Decrement refcount which was previously incremented by mono_image_open_from_data_with_name
                mono_image_close(image);

                return assembly;
            }
        }
    }

    return nullptr;


}

MonoAssembly* urho3d_mono_load_assembly(Urho3D::Context* context, const String& p_path, bool p_refonly,
                                        MonoAssemblyName* p_aname)
{
    ResourceCache* cache = context->GetSubsystem<ResourceCache>();
    MonoImageOpenStatus status = MONO_IMAGE_OK;

    SharedPtr<File> assembly_file = cache->GetFile(p_path);
    if (assembly_file && assembly_file->IsOpen())
    {

        String fileName = GetFileNameAndExtension(p_path);

        unsigned fileSize = assembly_file->GetSize();
        SharedArrayPtr<unsigned char> buffer(new unsigned char[fileSize]);

        unsigned bytesRead = assembly_file->Read(buffer.Get(), fileSize);

        if (bytesRead == fileSize)
        {
            unsigned char* data = buffer.Get();

            MonoImage* image =
                mono_image_open_from_data_with_name((char*)data, bytesRead, true, &status, p_refonly, fileName.CString());

            if (status == MONO_IMAGE_OK)
            {
                if (p_aname != nullptr)
                {
                    // Check assembly version
                    const MonoTableInfo* table = mono_image_get_table_info(image, MONO_TABLE_ASSEMBLY);

                    assert(table);

                    if (mono_table_info_get_rows(table))
                    {
                        uint32_t cols[MONO_ASSEMBLY_SIZE];
                        mono_metadata_decode_row(table, 0, cols, MONO_ASSEMBLY_SIZE);

                        // Not sure about .NET's policy. We will only ensure major and minor are equal, and ignore build
                        // and revision.
                        uint16_t major = cols[MONO_ASSEMBLY_MAJOR_VERSION];
                        uint16_t minor = cols[MONO_ASSEMBLY_MINOR_VERSION];

                        uint16_t required_minor;
                        uint16_t required_major =
                            mono_assembly_name_get_version(p_aname, &required_minor, nullptr, nullptr);

                        if (required_major != 0)
                        {
                            if (major != required_major && minor != required_minor)
                            {
                                mono_image_close(image);
                                return nullptr;
                            }
                        }
                    }
                }

                status = MONO_IMAGE_OK;

                MonoAssembly* assembly = mono_assembly_load_from_full(image, fileName.CString(), &status, p_refonly);

                assert(status == MONO_IMAGE_OK && assembly && "Failed to load assembly for image");

                // Decrement refcount which was previously incremented by mono_image_open_from_data_with_name
                mono_image_close(image);

                return assembly;
            }
        }
    }

    return nullptr;
}

MonoAssembly* urho3d_mono_assembly_preload_hook(MonoAssemblyName* aname, char** assemblies_path, void* user_data)
{
    return urho3d_mono_assembly_preload(aname, assemblies_path, user_data, false);
}

MonoAssembly* urho3d_mono_assembly_refonly_preload_hook(MonoAssemblyName* aname, char** assemblies_path,
                                                        void* user_data)
{
    return urho3d_mono_assembly_preload(aname, assemblies_path, user_data, true);
}

MonoAssembly* urho3d_mono_assembly_preload(MonoAssemblyName* aname, char** assemblies_path, void* user_data,
                                           bool refonly)
{
    Urho3D::Context* context = (Urho3D::Context*)user_data;
    String name = String(mono_assembly_name_get_name(aname));
    return urho3d_mono_load_assembly_from_cache(context, name, aname, refonly);
}

String urho3d_mono_assembly_get_full_path(Urho3D::Context* context,const String& p_name, bool &IsEncrypted)
{
    ResourceCache* cache = context->GetSubsystem<ResourceCache>();
    bool has_extension = p_name.EndsWith(".dll") || p_name.EndsWith(".exe");
    IsEncrypted = false;

    String result = "";

    List<String> paths;
    if (p_name.Contains("Game.dll") && cache->Exists(p_name + "e"))
    {
        IsEncrypted = true;
        result = p_name + "e";
    }
    else
    {
        String path = fixPathString(urho3d_get_dotnet_folder() + p_name);
        if (has_extension)
        {
            paths.Push(path);
            paths.Push(p_name);
        }
        else
        {
            paths.Push(path + ".dll");
            paths.Push(path + ".exe");
            paths.Push(p_name + ".dll");
            paths.Push(p_name + ".exe");
        }

#if defined(__ANDROID__)
        String common_path = fixPathString("DotNet/android/" + p_name);
        if (has_extension)
        {
            paths.Push(common_path);
        }
        else{
            paths.Push(common_path + ".dll");
            paths.Push(common_path + ".exe");
        }
#endif

        for (List<String>::Iterator iter = paths.Begin(); iter != paths.End(); ++iter)
        {
            if (cache->Exists(*iter))
            {
                result = *iter;
                break;
            }
        }
    }
    
    return result;
}

MonoAssembly* urho3d_mono_load_assembly_from_cache(Urho3D::Context* context, const String& p_name,
                                                   MonoAssemblyName* p_aname, bool p_refonly)
{
    MonoAssembly* res = NULL;
    bool IsEncrypted = false;
    String full_path = urho3d_mono_assembly_get_full_path(context ,p_name , IsEncrypted);
    if(full_path != "")
    {
        if(IsEncrypted)
        {
            res = urho3d_mono_load_encrypted_assembly(context, full_path, p_refonly, p_aname);
        }
        else{
            res = urho3d_mono_load_assembly(context, full_path, p_refonly, p_aname);
        }
    }

    return res;
}

MonoAssembly* urho3d_mono_assembly_search_hook(MonoAssemblyName* aname, void* user_data)
{
    String name = mono_assembly_name_get_name(aname);
    MonoAssembly* loaded_asm = urho3d_get_loaded_assembly(name);
    return loaded_asm;
}

void urho3d_mono_assembly_load_hook(MonoAssembly* assembly, void* user_data)
{

    String name = mono_assembly_name_get_name(mono_assembly_get_name(assembly));
    MonoDomain* domain = mono_domain_get();
    urho3d_add_assembly(domain ? mono_domain_get_id(domain) : 0, name, assembly);
}

void urho3d_init_mono(Urho3D::Context* context)
{
    mono_install_assembly_preload_hook(&urho3d_mono_assembly_preload_hook, (void*)context);
    mono_install_assembly_refonly_preload_hook(&urho3d_mono_assembly_refonly_preload_hook, (void*)context);
    mono_install_assembly_search_hook(&urho3d_mono_assembly_search_hook, (void*)context);
    mono_install_assembly_refonly_search_hook(&urho3d_mono_assembly_search_hook, (void*)context);
    mono_install_assembly_load_hook(&urho3d_mono_assembly_load_hook, (void*)context);
    mono_install_load_aot_data_hook (&urho3d_load_aot_data, &urho3d_free_aot_data, (void*)context);
}

static String make_text(const char* log_domain, const char* log_level, const char* message)
{
    String text(message);
    text += " (in domain ";
    text += log_domain;
    if (log_level)
    {
        text += ", ";
        text += log_level;
    }
    text += ")";
    return text;
}

void mono_log_callback(const char* log_domain, const char* log_level, const char* message, mono_bool fatal, void*)
{

    String text = make_text(log_domain, log_level, message);
    text += "\n";

#ifdef _WIN32
    // If the output stream has been redirected, use fprintf instead of WriteConsoleW,
    // though it means that proper Unicode output will not work

    HANDLE stream = GetStdHandle(STD_OUTPUT_HANDLE);
    if (stream == INVALID_HANDLE_VALUE)
        return;
    WString strW(text);
    DWORD charsWritten;
    WriteConsoleW(stream, strW.CString(), strW.Length(), &charsWritten, nullptr);

    OutputDebugStringW(strW.CString());

#elif defined(__ANDROID__)
    __android_log_print(2, "Urho3D", "%s", text.CString());
#else
    printf("%s", text.CString());
#endif
}



void fixPath(String& path)
{
    path.Replace("\\", "/");
    path.Replace("//", "/");
}

String fixPathString(String path)
{
    path.Replace("\\", "/");
    path.Replace("//", "/");
    return path;
}

bool CopyFileToDocumentsDir(Urho3D::SharedPtr<Urho3D::Context> context_, String sourceFile, bool overwrite_if_exist)
{
    FileSystem* fileSystem = context_->GetSubsystem<FileSystem>();
    ResourceCache* cache = context_->GetSubsystem<ResourceCache>();

    String DestFolder = fileSystem->GetUserDocumentsDir();
#if !defined(ANDROID)
    DestFolder += "/temp/DotNet";
    fixPath(DestFolder);
    if (!fileSystem->CreateDir(DestFolder))
    {
        return false;
    }
#endif

    String sourceFileName = GetFileNameAndExtension(sourceFile);
    String destFileName = fixPathString(DestFolder + "/" + sourceFileName);

    if (overwrite_if_exist == false && fileSystem->FileExists(destFileName))
    {
        return true;
    }

    SharedPtr<File> srcFile = cache->GetFile(sourceFile);
    if (srcFile == NULL || !srcFile->IsOpen())
        return false;

    fileSystem->Delete(destFileName);

    SharedPtr<File> destFile(new File(context_, destFileName, FILE_WRITE));
    if (!destFile->IsOpen())
        return false;

    unsigned fileSize = srcFile->GetSize();
    SharedArrayPtr<unsigned char> buffer(new unsigned char[fileSize]);

    unsigned bytesRead = srcFile->Read(buffer.Get(), fileSize);
    unsigned bytesWritten = destFile->Write(buffer.Get(), fileSize);
    return bytesRead == fileSize && bytesWritten == fileSize;
}

void CopyMonoFilesToDocumentDir(Urho3D::SharedPtr<Urho3D::Context> context, Platform platform)
{
    FileSystem* fileSystem = context->GetSubsystem<FileSystem>();
    ResourceCache* cache = context->GetSubsystem<ResourceCache>();

    CopyFileToDocumentsDir(context, String("DotNet/Game.dll"), true);

    String prefix = "";
    switch (platform)
    {

    case _ANDROID_:
        prefix = "DotNet/android/";
        break;

    case _IOS_:
    case TVOS:
        prefix = "DotNet/ios/";
        break;

    case MACOS:
        prefix = "DotNet/macos/";
        break;

    case LINUX:
        prefix = "DotNet/linux/";
        break;

    case WINDOWS:
        prefix = "DotNet/windows/";
        break;

    case WEB:
        prefix = "DotNet/web/";
        break;

    default:
        prefix = "";
        break;
    }

    CopyFileToDocumentsDir(context, String(prefix + "UrhoDotNet.dll"), true);

    CopyFileToDocumentsDir(context, String(prefix + "mscorlib.dll"));
    CopyFileToDocumentsDir(context, String(prefix + "System.dll"));
    CopyFileToDocumentsDir(context, String(prefix + "System.Xml.dll"));
    CopyFileToDocumentsDir(context, String(prefix + "System.Core.dll"));
    CopyFileToDocumentsDir(context, String(prefix + "Mono.Security.dll"));
    CopyFileToDocumentsDir(context, String(prefix + "System.Numerics.dll"));
    CopyFileToDocumentsDir(context, String(prefix + "System.Runtime.dll"));
    CopyFileToDocumentsDir(context, String(prefix + "System.Threading.Tasks.dll"));
    CopyFileToDocumentsDir(context, String(prefix + "System.Runtime.Extensions.dll"));
    CopyFileToDocumentsDir(context, String(prefix + "System.Collections.dll"));
    CopyFileToDocumentsDir(context, String(prefix + "System.Linq.dll"));

    if (platform == _ANDROID_)
    {
        CopyFileToDocumentsDir(context, String(prefix + "System.Threading.dll"));
        CopyFileToDocumentsDir(context, String(prefix + "System.Collections.Concurrent.dll"));
        CopyFileToDocumentsDir(context, String(prefix + "System.Diagnostics.Debug.dll"));
        CopyFileToDocumentsDir(context, String(prefix + "System.Runtime.InteropServices.dll"));
    }
}

String urho3d_get_dotnet_folder()
{
    String prefix = "";
#if defined(__ANDROID__)
    prefix = "DotNet/android/";
#ifdef __i386__
    prefix += "x86/";
#elif __x86_64__
    prefix += "x86_64/";
#elif __arm__
 prefix += "armeabi-v7a/";
#elif __aarch64__
prefix += "arm64-v8a/";
#else
// unknown 
#endif
#elif defined(IOS)
    prefix = "DotNet/ios/";
#elif defined(TVOS)
    prefix = "DotNet/ios/";
#elif defined(__APPLE__)
    prefix = "DotNet/macos/";
#elif defined(_WIN32)
    prefix = "DotNet/windows/";
#elif defined(RPI)
    prefix = "DotNet/rpi/";
#elif defined(__EMSCRIPTEN__)
    prefix = "DotNet/web/";
#elif defined(__linux__)
    prefix = "DotNet/linux/";
#else
    prefix = "";
#endif

    return prefix;
}
