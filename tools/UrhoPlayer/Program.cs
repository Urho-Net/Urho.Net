using Urho;
using System;
using System.Runtime.Loader;
using System.Reflection;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Threading;

namespace UrhoPlayer
{
    class Program
    {

#if _ENABLE_MAIN_
        static void Main(string[] args)
        {   
        //    Console.WriteLine($"Eli args.Length ={args.Length} ");

           if(args.Length == 1)
           {
            // project path
            new UrhoPlayer(args[0]).Run();
           }
           else  if(args.Length == 2)
           {
            // project path , options
            new UrhoPlayer(args[0],args[1]).Run();
           }
           else  if(args.Length == 3)
           {
            // project path , options
            new UrhoPlayer(args[0],args[1],args[2]).Run();
           }
        }
#endif
    }
}

