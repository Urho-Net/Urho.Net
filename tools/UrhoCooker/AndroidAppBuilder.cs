// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// Copyright (c) 2022 Eli Aloni (a.k.a  elix22)
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

using System;
using System.IO;
using System.Linq;
using System.Text;
using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;
using Task = Microsoft.Build.Utilities.Task;

namespace UrhoCooker
{
    public class AndroidBuildTask : Task
    {


        Options opts;
        Dictionary<string, string> envVarsDict = new();

        string PROJECT_UUID = string.Empty;
        string PROJECT_NAME = string.Empty;
        string JAVA_PACKAGE_PATH = string.Empty;
        string VERSION_CODE = string.Empty;
        string VERSION_NAME = string.Empty;

         string URHONET_HOME_PATH = string.Empty;


        public AndroidBuildTask(Options opts)
        {
            this.opts = opts;
            Utils.opts = opts;
        }


        public override bool Equals(object? obj)
        {
            return base.Equals(obj);
        }

        public override bool Execute()
        {
            return BuildAndroidAppBundle();
        }

        bool BuildAndroidAppBundle()
        {

              FileInfo fi = new FileInfo(opts.ProjectPath);
              opts.ProjectPath = fi.FullName;
              Console.WriteLine($"Project path:{opts.ProjectPath}");

            if (opts.Type == "debug")
            {
                if (!DotNetBuildDebug())
                {
                    Log.LogError($"Compilation failed!");
                    return false;
                }
            }
            else if (opts.Type == "release")
            {
                if (!DotNetBuildRelease())
                {
                    Log.LogError($"Compilation failed!");
                    return false;
                }
            }
            else{
                 Log.LogError($"You must provide build type release/debug");
                 return false;
            }

 


            SetOutputPath();
            GetUrhoNetHomePath();
            if (URHONET_HOME_PATH == string.Empty) return false;
            ParseEnvironmentVariables();
            if(CheckvariablesValidity() == false)return false;
            CopyAndroidInitialFolder();
            CreateBuildGradle();
            HandleOverwrites();
            HandleAndroidDependencies();
            HandleAndroidNDKVersion();
            HandlePlugins();
            HandleDotnetAssembliesAndRuntime();
            CreateAndroidManifest();
            CopyPlatformJavaToAndroid();
            CopyAssetsToAndroid();
            DeleteIOSAssetFolder();
            DeleteGameDllInAndroidFolder();
            ResolveReferenceAssembliesAndCopyToAndroid();

            if (opts.Obfuscate)
            {

                string cmd = $"mono {URHONET_HOME_PATH}/tools/obfuscar/Obfuscar.Console.exe obfuscar.xml";
                (int exitCode, string output) = Utils.RunShellCommand(Log,
                             cmd,
                             null,
                             workingDir: Path.Combine(opts.ProjectPath),
                             logStdErrAsMessage: true,
                             debugMessageImportance: MessageImportance.High,
                             label: "Obfuscate Game.dll");

                if (exitCode != 0)
                {
                    Log.LogError("Obfuscate failed");
                    Log.LogError(output);
                    return false;
                }

                File.Copy(Path.Combine(opts.ProjectPath, "Obfuscator_Output/Game.dll"),Path.Combine(opts.ProjectPath, "Intermediate/Game.dll"),true);
            }

            if (opts.Encrypt)
            {
                if(!EncryptGameDLL())
                {
                    Log.LogError($"build interrupted");
                    return false;
                }
            }
            else
            {
                CopyGameDllToAndroid();
            }
            if (opts.Type == "debug")
                GradleBuildAAB("bundleDebug");
            else if (opts.Type == "release")
                GradleBuildAAB("bundleRelease");

            bool isSigned = false;
            if (opts.KeyStorePath != null && opts.KeyStorePath != string.Empty)
            {
                if (!SignAAB())
                {
                    Log.LogError($"AAB sign error");
                    return false;
                }
                isSigned = true;
            }

            if (opts.Install)
                InstallAAB(isSigned);

            return true;
        }


        bool EncryptGameDLL()
        {
            int keyIndex = 0;
            if(!File.Exists(Path.Combine(opts.ProjectPath, opts.EncryptKeyPath)))
            {
                Log.LogError($"encryption key file not found {Path.Combine(opts.ProjectPath, opts.EncryptKeyPath)}");
                return false ;
            }

            string keyStr = File.ReadAllText(Path.Combine(opts.ProjectPath, opts.EncryptKeyPath));
            byte[] encryption_key = Encoding.ASCII.GetBytes(keyStr);
            if (encryption_key.Count() == 0)
            {
                Log.LogError($"encryption key is invalid");
                return false ;
            }

            using (FileStream fs = System.IO.File.Open(Path.Combine(opts.ProjectPath, "Intermediate/Game.dll"), System.IO.FileMode.Open, FileAccess.Read, FileShare.Delete))
            {
                using (FileStream ofs = System.IO.File.Open(Path.Combine(opts.OutputPath, "Android/app/src/main/assets/Data/DotNet/Game.dlle"), System.IO.FileMode.Create, FileAccess.ReadWrite, FileShare.ReadWrite))
                {
                    fs.Seek(0, SeekOrigin.Begin);
                    int b = 0;
                    while ((b = fs.ReadByte()) != -1)
                    {
                        int eb = b ^ encryption_key[keyIndex];
                        ofs.WriteByte((byte)eb);

                        keyIndex++;
                        keyIndex = keyIndex % encryption_key.Length;

                    }
                    ofs.Close();
                }
                fs.Close();
            }
            return true;
        }

        bool CheckvariablesValidity()
        {
            if (PROJECT_UUID == string.Empty || PROJECT_NAME == string.Empty || JAVA_PACKAGE_PATH == string.Empty)
            {
                Log.LogError($"Project vars ar missing");
                return false;
            }

            if (!Directory.Exists(Path.Combine(URHONET_HOME_PATH, "template/libs/dotnet/bcl/android")))
            {
                Log.LogError(Path.Combine(URHONET_HOME_PATH, "template/libs/dotnet/bcl/android") + " not found");
                return false;
            }

            if (!Directory.Exists(Path.Combine(URHONET_HOME_PATH, "template/Android")))
            {
                Log.LogError(Path.Combine(URHONET_HOME_PATH, "template/Android") + " not found");
                return false;
            }

            return true;
        }
        private void SetOutputPath()
        {
            if (opts.OutputPath == string.Empty)
            {
                opts.OutputPath = opts.ProjectPath;
            }

            if (!Directory.Exists(opts.OutputPath))
                Directory.CreateDirectory(opts.OutputPath);
        }

        private bool ParseEnvironmentVariables()
        {

            string project_vars_path = Path.Combine(opts.ProjectPath, "script", "project_vars.sh");

            if (!File.Exists(project_vars_path))
            {
                Log.LogError($"project_vars.sh not found");
                return false;
            }
            ParseEnvironmentVars(project_vars_path);

            PROJECT_UUID = GetEnvValue("PROJECT_UUID");
            PROJECT_NAME = GetEnvValue("PROJECT_NAME");
            JAVA_PACKAGE_PATH = GetEnvValue("JAVA_PACKAGE_PATH");
            VERSION_CODE = GetEnvValue("VERSION_CODE");
            VERSION_NAME = GetEnvValue("VERSION_NAME");

            if (VERSION_CODE == string.Empty)
            {
                VERSION_CODE = "1";
            }

            if (VERSION_NAME == string.Empty)
            {
                VERSION_NAME = "1.0.0";
            }


            Console.WriteLine("UrhoNetHomePath = " + URHONET_HOME_PATH);
            Console.WriteLine("opts.OutputPath = " + opts.OutputPath);
            Console.WriteLine("OutputPath  = " + opts.OutputPath);
            Console.WriteLine("PROJECT_UUID" + "=" + PROJECT_UUID);
            Console.WriteLine("PROJECT_NAME" + "=" + PROJECT_NAME);
            Console.WriteLine("JAVA_PACKAGE_PATH" + "=" + JAVA_PACKAGE_PATH);


            return true;
        }

        private void HandleAndroidNDKVersion()
        {
            string ANDROID_NDK_VERSION = GetEnvValue("ANDROID_NDK_VERSION");
            if (ANDROID_NDK_VERSION != string.Empty)
            {
                Path.Combine(opts.OutputPath, "Android/app/build.gradle").AppendTextLine("");
                Path.Combine(opts.OutputPath, "Android/app/build.gradle").AppendTextLine("");
                Path.Combine(opts.OutputPath, "Android/app/build.gradle").AppendTextLine("android  {");
                Path.Combine(opts.OutputPath, "Android/app/build.gradle").AppendTextLine("ndkVersion  \"" + ANDROID_NDK_VERSION + "\"");
                Path.Combine(opts.OutputPath, "Android/app/build.gradle").AppendTextLine("}");
            }
        }

        private void HandleDotnetAssembliesAndRuntime()
        {
            Directory.CreateDirectory(Path.Combine(opts.ProjectPath, "libs/dotnet/bcl/android/common"));

            Path.Combine(URHONET_HOME_PATH, "template/libs/dotnet/bcl/android/common").CopyDirectory(Path.Combine(opts.ProjectPath, "libs/dotnet/bcl/android/common"), true);


            List<string> androidArchs = GetAndroidArchitectures();
            if (androidArchs.Count == 0) androidArchs.Add("armeabi-v7a");

            foreach (var i in androidArchs)
            {
                if (!Directory.Exists(Path.Combine(opts.ProjectPath, $"libs/dotnet/bcl/android/{i}")))
                {
                    Directory.CreateDirectory(Path.Combine(opts.ProjectPath, $"libs/dotnet/bcl/android/{i}"));
                    Path.Combine(URHONET_HOME_PATH, $"template/libs/dotnet/bcl/android/{i}").CopyDirectory(Path.Combine(opts.ProjectPath, $"libs/dotnet/bcl/android/{i}"), true);
                }

                Directory.CreateDirectory(Path.Combine(opts.OutputPath, $"Android/app/src/main/jniLibs/{i}"));
                Path.Combine(URHONET_HOME_PATH, $"template/libs/android/{i}").CopyDirectory(Path.Combine(opts.OutputPath, $"Android/app/src/main/jniLibs/{i}"), true);

                Directory.CreateDirectory(Path.Combine(opts.OutputPath, $"Android/app/src/main/assets/Data/DotNet/android/{i}"));
                Path.Combine(URHONET_HOME_PATH, $"template/libs/dotnet/bcl/android/{i}").CopyDirectory(Path.Combine(opts.OutputPath, $"Android/app/src/main/assets/Data/DotNet/android/{i}"), true);
            }


            List<string> ANDROID_ALL_ARCHITECTURES = new List<string> { "arm64-v8a", "armeabi-v7a", "x86", "x86_64" };
            List<string> removeArchsList = ANDROID_ALL_ARCHITECTURES.Except(androidArchs).ToList();
            foreach (var j in removeArchsList)
            {
                Path.Combine(opts.ProjectPath, $"libs/dotnet/bcl/android/{j}").DeleteDirectory();
                Path.Combine(opts.OutputPath, $"Android/app/src/main/assets/Data/DotNet/android/{j}").DeleteDirectory();
                Path.Combine(opts.OutputPath, $"Android/app/src/main/jniLibs/{j}").DeleteDirectory();
            }
        }

        private void HandlePlugins()
        {
            List<string> PLUGINS = GetPlugins();
            if (PLUGINS.Count > 0)
            {
                Path.Combine(opts.ProjectPath, "Assets/Data/plugins.cfg").DeleteFile();

                Directory.CreateDirectory(Path.Combine(opts.OutputPath, "Android/app/src/main/java/com/urho3d/plugin"));

                foreach (string plugin in PLUGINS)
                {
                    if (Directory.Exists(Path.Combine(URHONET_HOME_PATH, $"template/Plugins/{plugin}/android")))
                    {
                        Path.Combine(URHONET_HOME_PATH, $"template/Plugins/{plugin}/android/java").CopyDirectory(Path.Combine(opts.OutputPath, $"Android/app/src/main/java/com/urho3d/plugin/{plugin}"));
                        Path.Combine(URHONET_HOME_PATH, $"template/Plugins/{plugin}/android/lib").CopyDirectory(Path.Combine(opts.OutputPath, "Android/app/src/main/jniLibs"));
                        Path.Combine(opts.OutputPath, $"Android/app/src/main/java/com/urho3d/plugin/{plugin}/{plugin}.java").ReplaceInfile("TEMPLATE_UUID", PROJECT_UUID);
                        Path.Combine(opts.ProjectPath, "Assets/Data/plugins.cfg").AppendTextLine(plugin);
                    }
                }
            }
        }

        private void HandleOverwrites()
        {

            if (Directory.Exists(Path.Combine(opts.ProjectPath, "overwrite/res")))
            {
                Path.Combine(opts.ProjectPath, "overwrite/res").CopyDirectory(Path.Combine(opts.OutputPath, "Android/app/src/main/res"));
            }
        }

        private void HandleAndroidDependencies()
        {
            List<string> androidDependencies = GetAndroidDependencies();

            if (androidDependencies.Count > 0)
            {
                Path.Combine(opts.OutputPath, "Android/app/build.gradle").AppendTextLine("");
                Path.Combine(opts.OutputPath, "Android/app/build.gradle").AppendTextLine("");
                Path.Combine(opts.OutputPath, "Android/app/build.gradle").AppendTextLine("dependencies {");

                foreach (var dependency in androidDependencies)
                {
                    Path.Combine(opts.OutputPath, "Android/app/build.gradle").AppendTextLine("implementation(\'" + dependency + "\')");
                }

                Path.Combine(opts.OutputPath, "Android/app/build.gradle").AppendTextLine("}");
            }
        }

        private void CreateBuildGradle()
        {
            File.WriteAllText(Path.Combine(opts.OutputPath, "Android/app/build.gradle"),
            Utils.GetEmbeddedResource("Android.build_gradle_lean.gradle")
            .Replace("%TEMPLATE_UUID%", PROJECT_UUID)
            .Replace("%VERSION_CODE%", VERSION_CODE)
            .Replace("%VERSION_NAME%", VERSION_NAME));
        }

        private void CopyAndroidInitialFolder()
        {
            if (!Directory.Exists(Path.Combine(opts.OutputPath, "Android")))
            {

                Path.Combine(URHONET_HOME_PATH, "template/Android").CopyDirectory(Path.Combine(opts.OutputPath, "Android"), true);

                Directory.CreateDirectory(Path.Combine(opts.OutputPath, "Android/app/src/main", JAVA_PACKAGE_PATH));
                Directory.CreateDirectory(Path.Combine(opts.OutputPath, "Android/app/src/androidTest", JAVA_PACKAGE_PATH));
                Directory.CreateDirectory(Path.Combine(opts.OutputPath, "Android/app/src/test", JAVA_PACKAGE_PATH));

                File.Move(Path.Combine(opts.OutputPath, "Android/app/src/main/MainActivity.kt"), Path.Combine(opts.OutputPath, "Android/app/src/main", JAVA_PACKAGE_PATH, "MainActivity.kt"), true);
                File.Move(Path.Combine(opts.OutputPath, "Android/app/src/main/UrhoMainActivity.kt"), Path.Combine(opts.OutputPath, "Android/app/src/main", JAVA_PACKAGE_PATH, "UrhoMainActivity.kt"), true);
                File.Move(Path.Combine(opts.OutputPath, "Android/app/src/androidTest/ExampleInstrumentedTest.kt"), Path.Combine(opts.OutputPath, "Android/app/src/androidTest", JAVA_PACKAGE_PATH, "ExampleInstrumentedTest.kt"), true);
                File.Move(Path.Combine(opts.OutputPath, "Android/app/src/test/ExampleUnitTest.kt"), Path.Combine(opts.OutputPath, "Android/app/src/test", JAVA_PACKAGE_PATH, "ExampleUnitTest.kt"), true);

                Path.Combine(opts.OutputPath, "Android/app/src/main/AndroidManifest.xml").ReplaceInfile("TEMPLATE_UUID", PROJECT_UUID);
                Path.Combine(opts.OutputPath, "Android/app/build.gradle").ReplaceInfile("TEMPLATE_UUID", PROJECT_UUID);
                Path.Combine(opts.OutputPath, "Android/app/src/main", JAVA_PACKAGE_PATH, "MainActivity.kt").ReplaceInfile("TEMPLATE_UUID", PROJECT_UUID);
                Path.Combine(opts.OutputPath, "Android/app/src/main", JAVA_PACKAGE_PATH, "UrhoMainActivity.kt").ReplaceInfile("TEMPLATE_UUID", PROJECT_UUID);

                Path.Combine(opts.OutputPath, "Android/app/src/androidTest", JAVA_PACKAGE_PATH, "ExampleInstrumentedTest.kt").ReplaceInfile("TEMPLATE_UUID", PROJECT_UUID);
                Path.Combine(opts.OutputPath, "Android/app/src/test", JAVA_PACKAGE_PATH, "ExampleUnitTest.kt").ReplaceInfile("TEMPLATE_UUID", PROJECT_UUID);

                Path.Combine(opts.OutputPath, "Android/settings.gradle").ReplaceInfile("TEMPLATE_PROJECT_NAME", PROJECT_NAME);
                Path.Combine(opts.OutputPath, "Android/app/src/main/res/values/strings.xml").ReplaceInfile("TEMPLATE_PROJECT_NAME", PROJECT_NAME);
            }

            Path.Combine(opts.OutputPath, "Android/app/src/main/jniLibs").DeleteDirectory();
            Directory.CreateDirectory(Path.Combine(opts.OutputPath, "Android/app/src/main/jniLibs"));
        }

        string GetUrhoNetHomePath()
        {

            if(URHONET_HOME_PATH != string.Empty)return URHONET_HOME_PATH;

            string homeFolder = Utils.GetHomeFolder();
            string urhoNetConfigFolderPath = Path.Combine(homeFolder, ".urhonet_config");

            if (!Directory.Exists(urhoNetConfigFolderPath))
            {
                Log.LogError($".urhonet_config folder not found");
                return string.Empty;
            }

            string urhoNetHomeFilePath = Path.Combine(urhoNetConfigFolderPath, "urhonethome");
            if (!File.Exists(urhoNetHomeFilePath))
            {
                Log.LogError($"urhonethome not found");
                return string.Empty;
            }


            string[] lines = urhoNetHomeFilePath.FileReadAllLines();
            foreach (var line in lines)
            {
                if (line == string.Empty) continue;

                if (Directory.Exists(line))
                {
                    URHONET_HOME_PATH = line;
                    break;
                }
            }
      
            return URHONET_HOME_PATH;
        }

        private void DeleteIOSAssetFolder()
        {
            Path.Combine(opts.OutputPath, "Android/app/src/main/assets/Data/DotNet/ios").DeleteDirectory();
        }

        private void DeleteGameDllInAndroidFolder()
        {
            if (File.Exists(Path.Combine(opts.OutputPath, "Android/app/src/main/assets/Data/DotNet/Game.dll")))
                File.Delete(Path.Combine(opts.OutputPath, "Android/app/src/main/assets/Data/DotNet/Game.dll"));
        }

        private void CopyGameDllToAndroid()
        {
            File.Copy(Path.Combine(opts.ProjectPath, "Intermediate/Game.dll"), Path.Combine(opts.OutputPath, "Android/app/src/main/assets/Data/DotNet/Game.dll"), true);
        }
        private void CopyAssetsToAndroid()
        {
            Path.Combine(opts.ProjectPath, "Assets").CopyDirectoryIfDifferent(Path.Combine(opts.OutputPath, "Android/app/src/main/assets"), true);
        }

        private void CopyPlatformJavaToAndroid()
        {
            if (Directory.Exists(Path.Combine(opts.ProjectPath, "platform/android/java")))
                Path.Combine(opts.ProjectPath, "platform/android/java").CopyDirectory(Path.Combine(opts.OutputPath, "Android/app/src/main/java"), true);
        }


        private bool DotNetBuildDebug()
        {
            bool result = true;
            (int exitCode, string output)  = Utils.RunShellCommand(Log,
                                      "dotnet build --configuration Debug -p:DefineConstants=_ANDROID_",
                                      null,
                                      workingDir: Path.Combine(opts.ProjectPath),
                                      logStdErrAsMessage: true,
                                      debugMessageImportance: MessageImportance.High,
                                      label: "DotNetBuildDebug");

            result = (exitCode != 0)?false:true;
            return result;
        }

        private bool DotNetBuildRelease()
        {
            bool result = true;
            (int exitCode, string output)  = Utils.RunShellCommand(Log,
                                      "dotnet build --configuration Release -p:DefineConstants=_ANDROID_",
                                      null,
                                      workingDir: Path.Combine(opts.ProjectPath),
                                      logStdErrAsMessage: true,
                                      debugMessageImportance: MessageImportance.High,
                                      label: "build-apks");
            result = (exitCode != 0)?false:true;
            return result;
        }

        private void ResolveReferenceAssembliesAndCopyToAndroid()
        {
            Utils.ResolveReferenceAssemblies(Path.Combine(opts.ProjectPath, "Intermediate/Game.dll"),
            new string[]
            {
                Path.Combine(URHONET_HOME_PATH, "template/libs/dotnet/bcl/android/common"),
                Path.Combine(URHONET_HOME_PATH, "template/libs/dotnet/urho/mobile/android"),
                Path.Combine(opts.ProjectPath, "References")
            },
            out List<string> assembliesList, out List<string> assembliesFullPathList);

            // Console.WriteLine("Reference assemblies");
            // Console.WriteLine("==============================================================");
            foreach (var assemblyPath in assembliesFullPathList)
            {
                // Console.WriteLine(assemblyPath);
                Utils.CopyIfDifferent(assemblyPath, Path.Combine(opts.OutputPath, $"Android/app/src/main/assets/Data/DotNet/android/{Path.GetFileName(assemblyPath)}"), true);
            }
            // Console.WriteLine("==============================================================");
        }

        private void InstallAAB(bool signed = false)
        {
            string command = string.Empty;
             string bundleName = "";
            if (opts.Type == "debug")
            {
                string signCommand = "";
                if(signed)
                {
                    bundleName = "app-debug-signed";
                    signCommand = $"--ks={opts.KeyStorePath} --ks-pass=pass:Android --ks-key-alias=my-alias --key-pass=pass:Android";
                }
                else{
                    bundleName = "app-debug";
                }
                command =  $"java -jar {URHONET_HOME_PATH}/tools/bundletool.jar build-apks --connected-device --bundle=output/Android/{bundleName}.aab --output=output/Android/{bundleName}.apks {signCommand}";
            }
            else if (opts.Type == "release")
            {
                string signCommand = "";
                if(signed)
                {
                    bundleName = "app-release-signed";
                    signCommand = $"--ks={opts.KeyStorePath} --ks-pass=pass:Android --ks-key-alias=my-alias --key-pass=pass:Android";
                }
                else{
                    bundleName = "app-release";
                }
                command =  $"java -jar {URHONET_HOME_PATH}/tools/bundletool.jar build-apks --connected-device --bundle=output/Android/{bundleName}.aab --output=output/Android/{bundleName}.apks  {signCommand}";
            }

            if(command == string.Empty)return;


            Utils.RunShellCommand(Log,
                                      command,
                                      null,
                                      workingDir: Path.Combine(opts.ProjectPath),
                                      logStdErrAsMessage: true,
                                      debugMessageImportance: MessageImportance.High,
                                      label: "install-apks");

            Utils.RunShellCommand(Log,
                                      $"adb shell am force-stop {PROJECT_UUID}",
                                      null,
                                      workingDir: Path.Combine(opts.ProjectPath),
                                      logStdErrAsMessage: true,
                                      debugMessageImportance: MessageImportance.High,
                                      label: "install-apks");

            Utils.RunShellCommand(Log,
                                      $"adb uninstall {PROJECT_UUID}",
                                      null,
                                      workingDir: Path.Combine(opts.ProjectPath),
                                      logStdErrAsMessage: true,
                                      debugMessageImportance: MessageImportance.High,
                                      label: "install-apks");


            if (opts.Type == "debug")
            {
                command =  $"java -jar {URHONET_HOME_PATH}/tools/bundletool.jar install-apks --apks=output/Android/{bundleName}.apks";
            }
            else if (opts.Type == "release")
            {
                command =  $"java -jar {URHONET_HOME_PATH}/tools/bundletool.jar install-apks --apks=output/Android/{bundleName}.apks";
            }

            Utils.RunShellCommand(Log,
                                      command,
                                      null,
                                      workingDir: Path.Combine(opts.ProjectPath),
                                      logStdErrAsMessage: true,
                                      debugMessageImportance: MessageImportance.High,
                                      label: "install-apks");

            Utils.RunShellCommand(Log,
                                      $"adb shell am start -n {PROJECT_UUID}/.MainActivity",
                                      null,
                                      workingDir: Path.Combine(opts.ProjectPath),
                                      logStdErrAsMessage: true,
                                      debugMessageImportance: MessageImportance.High,
                                      label: "install-apks");
        }

        private void GradleBuildAAB(string command = "dotnetBundleDebug -P DotnetBundleDebug=true")
        {
            (int exitCode, string output) = Utils.RunShellCommand(
                                                    Log,
                                                    $"./gradlew {command}",
                                                    null,
                                                    workingDir: Path.Combine(opts.OutputPath, "Android"),
                                                    logStdErrAsMessage: true,
                                                    debugMessageImportance: MessageImportance.High,
                                                    label: "build-aab");

            /*=====================================================================================================================================*/
            Directory.CreateDirectory(Path.Combine(opts.ProjectPath, $"output/Android"));
            if (opts.Type == "debug")
            {
                Path.Combine(opts.ProjectPath, $"output/Android/app-debug.aab").DeleteFile();
                Path.Combine(opts.ProjectPath, $"output/Android/app-debug.apks").DeleteFile();
                Path.Combine(opts.ProjectPath, $"output/Android/app-debug-signed.aab").DeleteFile();
                Path.Combine(opts.ProjectPath, $"output/Android/app-debug-signed.apks").DeleteFile();
                File.Copy(Path.Combine(opts.OutputPath, $"Android/app/build/outputs/bundle/debug/app-debug.aab"), Path.Combine(opts.ProjectPath, $"output/Android/app-debug.aab"), true);
            }
            else if (opts.Type == "release")
            {
                Path.Combine(opts.ProjectPath, $"output/Android/app-release.aab").DeleteFile();
                Path.Combine(opts.ProjectPath, $"output/Android/app-release.apks").DeleteFile();
                Path.Combine(opts.ProjectPath, $"output/Android/app-release-signed.aab").DeleteFile();
                Path.Combine(opts.ProjectPath, $"output/Android/app-release-signed.apks").DeleteFile();
                File.Copy(Path.Combine(opts.OutputPath, $"Android/app/build/outputs/bundle/release/app-release.aab"), Path.Combine(opts.ProjectPath, $"output/Android/app-release.aab"), true);
            }
        }


        private bool SignAAB()
        {

            if (opts.KeyStorePath == ".")
            {
                opts.KeyStorePath = opts.ProjectPath;
            }

            if (opts.KeyStorePath.StartsWith("./"))
            {
                opts.KeyStorePath = opts.KeyStorePath.Remove(0,2);
                opts.KeyStorePath = Path.Combine(opts.ProjectPath,opts.KeyStorePath);
            }


            if(Path.HasExtension(opts.KeyStorePath) && !opts.KeyStorePath.EndsWith(".jks"))
            {
                Log.LogError($"Wrong {opts.KeyStorePath}");
                return false;
            }

            bool isFile = Path.HasExtension(opts.KeyStorePath) && opts.KeyStorePath.EndsWith(".jks");
            string ?keyStorePath = string.Empty;
            string keyName = string.Empty;
            if(isFile)
            {
                 keyStorePath = Path.GetDirectoryName(opts.KeyStorePath);
                 keyName = Path.GetFileName(opts.KeyStorePath);
            }
            else{
                keyStorePath = opts.KeyStorePath;
                keyName = "android-release-key.jks";
            }

            
            if(keyStorePath == null || keyStorePath == string.Empty)
            {
                keyStorePath = opts.ProjectPath;
            }

            if(keyName == null || keyName == string.Empty)
            {
                keyName = "android-release-key.jks";
            }

            Console.WriteLine($"keyStorePath: {keyStorePath}");
            Console.WriteLine($"keyName: {keyName}");

            if (!Directory.Exists(keyStorePath))
                Directory.CreateDirectory(keyStorePath);

            if (!File.Exists(Path.Combine(keyStorePath, keyName)))
            {
                (int exitCode, string output) = Utils.RunShellCommand(
                                                        Log,
                                                        $"keytool -genkey -v -storepass Android -keypass Android -keystore {keyName} -keyalg RSA -keysize 2048 -validity 10000 -alias my-alias",
                                                        null,
                                                        workingDir: keyStorePath,
                                                        logStdErrAsMessage: true,
                                                        debugMessageImportance: MessageImportance.High,
                                                        label: "generate-sign-key");

                if (exitCode != 0)
                {
                    Log.LogError($"Failed to create {Path.Combine(keyStorePath, keyName)}");
                    return false;
                }

            }

            if (File.Exists(Path.Combine(keyStorePath, keyName)))
            {
                string bundle_input_path = "";
                 string bundle_output_path = "";
                if (opts.Type == "debug")
                {
                    bundle_input_path = "output/Android/app-debug.aab";
                    bundle_output_path =  "output/Android/app-debug-signed.aab";
                }
                else
                {
                    bundle_input_path = "output/Android/app-release.aab";
                    bundle_output_path =  "output/Android/app-release-signed.aab";
                }

                (int exitCode, string output) = Utils.RunShellCommand(
                                                                    Log,
                                                                    $"jarsigner -keystore  {Path.Combine(keyStorePath, keyName)} -storepass Android {Path.Combine(opts.ProjectPath, bundle_input_path)} -signedjar {Path.Combine(opts.ProjectPath, bundle_output_path)} my-alias",
                                                                    null,
                                                                    workingDir: keyStorePath,
                                                                    logStdErrAsMessage: true,
                                                                    debugMessageImportance: MessageImportance.High,
                                                                    label: "sign-aab");
                if (exitCode != 0)
                {
                    Log.LogError($"Failed to sign {Path.Combine(opts.ProjectPath, bundle_input_path)}");
                    return false;
                }
            }
            else{
                Log.LogError($"{Path.Combine(keyStorePath, keyName)}  not found");
                return false;
            }

            opts.KeyStorePath = Path.Combine(keyStorePath,keyName);

            return true;
        }
        void ParseEnvironmentVars(string project_vars_path)
        {
            string[] project_vars = project_vars_path.FileReadAllLines();

            foreach (string v in project_vars)
            {
                if (v.Contains('#') || v == string.Empty) continue;
                string tr = v.Trim();
                if (tr.StartsWith("export"))
                {
                    tr = tr.Replace("export", "");
                    string[] vars = tr.Split('=', 2);
                    envVarsDict[vars[0].Trim()] = vars[1].Trim();
                }
            }
        }

        string GetEnvValue(string key)
        {
            string value = string.Empty;
            if (envVarsDict.TryGetValue(key, out var val))
            {
                value = val;
                value = value.Replace("\'", "");
            }
            return value.Trim();
        }

        List<string> GetAndroidDependencies()
        {
            List<string> result = new List<string>();

            string ANDROID_DEPENDENCIES = GetEnvValue("ANDROID_DEPENDENCIES");
            if (ANDROID_DEPENDENCIES != string.Empty)
            {
                result = SplitToList(ANDROID_DEPENDENCIES);
            }

            return result;
        }

        List<string> GetDotNetReferenceAssemblies()
        {
            List<string> result = new List<string>();

            string DOTNET_REFERENCE_DLL = GetEnvValue("DOTNET_REFERENCE_DLL");
            if (DOTNET_REFERENCE_DLL != string.Empty)
            {
                result = SplitToList(DOTNET_REFERENCE_DLL);
            }

            return result;
        }

        List<string> GetPlugins()
        {
            List<string> result = new List<string>();

            string PLUGINS = GetEnvValue("PLUGINS");
            if (PLUGINS != string.Empty)
            {
                result = SplitToList(PLUGINS);
            }

            return result;
        }

        //
        List<string> GetAndroidArchitectures()
        {
            List<string> result = new List<string>();

            string ANDROID_ARCHITECTURE = GetEnvValue("ANDROID_ARCHITECTURE");
            if (ANDROID_ARCHITECTURE != string.Empty)
            {
                result = SplitToList(ANDROID_ARCHITECTURE);
            }

            return result;
        }

        List<string> GetAndroidPermissions()
        {
            List<string> result = new List<string>();

            string ANDROID_PERMISSIONS = GetEnvValue("ANDROID_PERMISSIONS");
            if (ANDROID_PERMISSIONS != string.Empty)
            {
                result = SplitToList(ANDROID_PERMISSIONS);
            }

            return result;
        }


        List<string> SplitToList(string value)
        {
            List<string> result = new List<string>();
            if (value != string.Empty)
            {
                value = value.Replace("\'", "").Replace(",", "").Trim().Trim('(').Trim(')').Trim();

                string[] entries = value.Split(' ');
                foreach (var entry in entries)
                {
                    if (entry == string.Empty) continue;
                    result.Add(entry);
                }
            }
            return result;
        }

        void CreateAndroidManifest()
        {
            string AndroidManifest = Path.Combine(opts.OutputPath, "Android/app/src/main/AndroidManifest.xml");

            AndroidManifest.DeleteFile();
            AndroidManifest.AppendTextLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
            AndroidManifest.AppendTextLine($"<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\" package=\"{PROJECT_UUID}\">");

            List<string> permissions = GetAndroidPermissions();

            foreach (var i in permissions)
            {
                AndroidManifest.AppendTextLine($"   <uses-permission android:name=\"{i}\"/>");
            }
            
    
            if (File.Exists(Path.Combine(opts.ProjectPath, "platform/android/manifest/AndroidManifest.xml")))
            {
                string extra = File.ReadAllText(Path.Combine(opts.ProjectPath, "platform/android/manifest/AndroidManifest.xml"));
                AndroidManifest.AppendText(extra);
            }

            AndroidManifest.AppendTextLine("   <application android:allowBackup=\"true\" android:icon=\"@mipmap/ic_launcher\" android:label=\"@string/app_name\" android:roundIcon=\"@mipmap/ic_launcher_round\" android:supportsRtl=\"true\" android:theme=\"@style/AppTheme\">");

            string GAD_APPLICATION_ID = GetEnvValue("GAD_APPLICATION_ID");
            if (GAD_APPLICATION_ID != string.Empty)
            {
                AndroidManifest.AppendTextLine($"      <meta-data android:name=\"com.google.android.gms.ads.APPLICATION_ID\" android:value=\"{GAD_APPLICATION_ID}\"/>");
            }


            AndroidManifest.AppendTextLine($"      <activity android:name=\".MainActivity\" android:exported=\"true\">");
            AndroidManifest.AppendTextLine($"          <intent-filter>");
            AndroidManifest.AppendTextLine($"              <action android:name=\"android.intent.action.MAIN\" />");
            AndroidManifest.AppendTextLine($"              <category android:name=\"android.intent.category.LAUNCHER\" />");
            AndroidManifest.AppendTextLine($"          </intent-filter>");
            
            if (File.Exists(Path.Combine(opts.ProjectPath, "platform/android/manifest/IntentFilters.xml")))
            {
                string extra = File.ReadAllText(Path.Combine(opts.ProjectPath, "platform/android/manifest/IntentFilters.xml"));
                AndroidManifest.AppendText(extra);
            }

            AndroidManifest.AppendTextLine($"      </activity>");

            string SCREEN_ORIENTATION = GetEnvValue("SCREEN_ORIENTATION");
            if (SCREEN_ORIENTATION == string.Empty)
            {
                SCREEN_ORIENTATION = "landscape";
            }
            if(SCREEN_ORIENTATION != "landscape" && SCREEN_ORIENTATION != "portrait")
            {
                SCREEN_ORIENTATION = "landscape";
            }

            AndroidManifest.AppendTextLine($"      <activity android:name=\".UrhoMainActivity\" android:exported=\"true\" android:configChanges=\"keyboardHidden|orientation|screenSize\" android:screenOrientation=\"{SCREEN_ORIENTATION}\" android:theme=\"@android:style/Theme.NoTitleBar.Fullscreen\"/>");

            if (File.Exists(Path.Combine(opts.ProjectPath, "platform/android/manifest/Activities.xml")))
            {
                string extra = File.ReadAllText(Path.Combine(opts.ProjectPath, "platform/android/manifest/Activities.xml"));
                AndroidManifest.AppendText(extra);
            }
          
            AndroidManifest.AppendTextLine($"   </application>");
            AndroidManifest.AppendTextLine($"</manifest>");


        }


        public override int GetHashCode()
        {
            return base.GetHashCode();
        }

        public override string? ToString()
        {
            return base.ToString();
        }
    }
}

