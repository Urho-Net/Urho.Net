using System;
using System.IO;
using System.Linq;
using System.Text;
using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;
using Task = Microsoft.Build.Utilities.Task;

namespace UrhoCooker
{
    public class DesktopBuildTask : Task
    {
        Options opts;
        Dictionary<string, string> envVars = new();

        string PROJECT_UUID = string.Empty;
        string PROJECT_NAME = string.Empty;
        string JAVA_PACKAGE_PATH = string.Empty;
        string VERSION_CODE = string.Empty;
        string VERSION_NAME = string.Empty;

        string URHONET_HOME_PATH = string.Empty;

        string DEVELOPMENT_TEAM = string.Empty;

        public DesktopBuildTask(Options opts)
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
            string buildType = "Debug";

            if (opts.Type == "release")
            {
                buildType = "Release";
            }
            string targetFramework = (opts.Framework != "") ? opts.Framework : "net9.0";



            if (opts.OutputPath != "")
            {
                opts.OutputPath = Path.Combine(opts.OutputPath, opts.RID);
            }

            string dotnet_build_command = $"dotnet publish -f {targetFramework} -r  {opts.RID} -c {buildType}   -p:PublishAot=true -p:TrimmerRemoveSymbols=false -p:TrimMode=partial -p:DisableUnsupportedError=true -p:PublishAotUsingRuntimePack=true -p:StripSymbols=true   -p:DefineConstants=\"_DESKTOP_PUBLISHED_BINARY_\" -o {opts.OutputPath}";

            (int exitCode, string output) = Utils.RunShellCommand(Log,
                dotnet_build_command,
                envVars,
                workingDir: opts.ProjectPath,
                logStdErrAsMessage: true,
                debugMessageImportance: MessageImportance.High,
                label: "dotnet-build");

            if (exitCode != 0)
            {
                Log.LogError("dotnet publish error");
                return false;
            }

            Path.Combine(opts.ProjectPath, "Assets").CopyDirectoryIfDifferent(Path.Combine(opts.OutputPath, ""), true);

            return true;
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