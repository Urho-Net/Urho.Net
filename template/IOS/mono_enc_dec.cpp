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

extern unsigned char  mono_decryption_key[] ;

int decryption_key_size();

void urho3d_mono_decrypt(unsigned char * in , int c ,unsigned char *out)
{
    int ks = decryption_key_size();
    int j = 0;
    for( int i = 0 ; i < c ; i++)
    {
          int eb = in[i] ^ mono_decryption_key[j];
          out[i] = eb;
          j++;
          j = j % ks;
    }
}
