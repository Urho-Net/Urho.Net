using System;
using System.IO;
using System.Linq;
using System.Text;
using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;
using Task = Microsoft.Build.Utilities.Task;

namespace UrhoCooker
{
    public class WebBuildTask : Task
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

        Dictionary<string, string> envVarsDict = new();

        public WebBuildTask(Options opts)
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
            URHONET_HOME_PATH = Utils.GetUrhoNetHomePath();
            if(!ParseEnvironmentVariables())
            {
                Log.LogError("Failed to parse environment variables");
                return false;
            }

            string buildType = "Debug";

            if (opts.Type == "release")
            {
                buildType = "Release";
            }

            // Net9.0 doesnt work so for now we will use Net8.0
            // sudo dotnet workload install wasm-tools-net8
            string targetFramework = (opts.Framework != "") ? opts.Framework : "net8.0";

            if (opts.OutputPath != "")
            {
                opts.OutputPath = Path.Combine(opts.OutputPath, "Web", buildType);
            }

            opts.ProjectPath = Path.Combine(opts.ProjectPath, "Web");

            string projectName = PROJECT_NAME+ "Web.csproj";


            if (!Directory.Exists(Path.Combine(opts.ProjectPath, "Web")))
            {
                Path.Combine(URHONET_HOME_PATH, "template/Web").CopyDirectory(Path.Combine(opts.ProjectPath), true);
                File.Move(Path.Combine(opts.ProjectPath,"template.csproj"), Path.Combine(opts.ProjectPath,projectName), true);
            }

            string dotnet_build_command = $"dotnet build -f {targetFramework}  {projectName} -c {buildType} -o {opts.OutputPath}";

            (int exitCode, string output) = Utils.RunShellCommand(Log,
                dotnet_build_command,
                envVars,
                workingDir: opts.ProjectPath,
                logStdErrAsMessage: true,
                debugMessageImportance: MessageImportance.High,
                label: "dotnet-web-build");

            if (exitCode != 0)
            {
                Log.LogError("dotnet publish error");
                return false;
            }

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