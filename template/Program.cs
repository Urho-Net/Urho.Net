using System.Runtime.InteropServices;
using Urho;

namespace TEMPLATE_PROJECT_NAME
{
    class Program
    {
        static void Main(string[] args)
        {
#if _DESKTOP_PUBLISHED_BINARY_
            var applicationPath = System.IO.Path.GetDirectoryName(System.Diagnostics.Process.GetCurrentProcess().MainModule.FileName);
            System.IO.Directory.SetCurrentDirectory(applicationPath);
#endif          
             RunGame();
        }

        // This method is called when the application is run as a DLL .i.e. when it is called from a C++ application.
        [UnmanagedCallersOnly(EntryPoint = "UrhoMain")]
        static void UrhoMain()
        {
            RunGame();
        }

        static void RunGame()
        {
             new TEMPLATE_CLASS_NAME().Run();
        }
    
    }
}

