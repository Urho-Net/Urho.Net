using Urho;
using System;
using System.Runtime.Loader;
using System.Reflection;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Image = Urho.Resources.Image;
using H.Pipes;
using Urho.IO;
using H.Formatters;
using H.Pipes.Args;
using Urho.Network;

namespace UrhoPlayer
{
    public partial class UrhoPlayer
    {
        AssemblyLoadContext assemblyContext = null;

        Assembly game = null;
        Application RemoteClientApplication = null;
        Engine Engine = null;
        Input input = null;

        Events events = null;

        string projectPath = string.Empty;
        string assemblyRelativePath = string.Empty;
        string projectOptions = string.Empty;


        static bool IsFirstTime = true;

        Image captureScreenImage = null;

        PipeClient<HPipesMessage>? client = null;
        PipeConnection<HPipesMessage>? hPipesConnection = null;

        // Memory sharedScreen = null;
        // bool isSharedScreenOK = false;

        int width = 0;
        int height = 0;
        bool isRequestScreenCapture;
        

		LocalConnection ?localConnection;
        
        public UrhoPlayer(string path)
        {
            projectPath = path;
        }


        public UrhoPlayer(string path, string options)
        {
            projectPath = path;
            projectOptions = options;
        }

        public UrhoPlayer(string path, string assemblyPath, string options)
        {
            projectPath = path;
            assemblyRelativePath = assemblyPath;
            projectOptions = options;
        }

        public void Run()
        {
            assemblyContext = new AssemblyLoadContext("UrhoPlayer", true);
            assemblyContext.Resolving += OnAssemblyLoadContextResolving;
            assemblyContext.EnterContextualReflection();
            if (assemblyRelativePath == string.Empty)
            {
                assemblyRelativePath = "bin/Debug/net9.0/Game.dll";
            }
            game = assemblyContext.LoadFromAssemblyPath(Path.Combine(projectPath, assemblyRelativePath));
            LocateAndStartApp();
        }

        private Assembly OnAssemblyLoadContextResolving(AssemblyLoadContext context, AssemblyName name)
        {
            throw new NotImplementedException();
        }

        bool AreEqual(ref Matrix3x4 a, ref Matrix3x4 b, float epsilon = 0.000001f)
        {
            unsafe
            {
                fixed (float* ptrA = &a.m00, ptrB = &b.m00)
                {
                    // Matrix3x4 has 12 float fields (3 rows × 4 columns)
                    for (int i = 0; i < 12; i++)
                    {
                        if (Math.Abs(ptrA[i] - ptrB[i]) > epsilon)
                            return false;
                    }
                    return true;
                }
            }
        }

        async void LocateAndStartApp()
        {
            var validApps = game.GetTypes().Where(t => t.IsSubclassOf(typeof(Application)) && t != typeof(Application)).ToArray();

            if (validApps != null && validApps.Length > 0)
            {
                Type gameClassType = validApps[0];

                if (gameClassType != null)
                {
                    Directory.SetCurrentDirectory(Path.Combine(projectPath, "Assets"));

                    Console.WriteLine($"projectOptions {projectOptions}");

                    object gameInstance = Activator.CreateInstance(gameClassType, new object[] { projectOptions });

                    RemoteClientApplication = gameInstance as Application;
                    if (RemoteClientApplication != null)
                    {
                        Engine = RemoteClientApplication.Engine;
                        events = new Events(Engine);
                        RegisterEvents();

                    }

                    RemoteClientApplication.SetupAndStart();

                    localConnection = new LocalConnection(RemoteClientApplication.Context);
                    localConnection.LocalConnectionMessage += OnLocalConnctionMessage;

                    input = RemoteClientApplication.Input;
                    input.SetMouseVisible(true);

                    RemoteClientApplication.InvokeOnMainDelayed(0.1f, async () =>
                    {
                        await RunAsyncClient("fs");
                    });

                    Engine.MaxInactiveFps = 120;
                    Engine.MaxFps = 120;

                    RemoteClientApplication?.Graphics.HideWindow();
                    // RemoteClientApplication?.Graphics.BringWindowToFront();

                    // TBD ELI , black screen  RemoteClientApplication.Input.ExternalInput = true;
                    captureScreenImage = new Image();


                    while (!Engine.Exiting)
                    {

                        var size = RemoteClientApplication.Graphics.Size;
                        if (width != size.X || height != size.Y)
                        {
                            RemoteClientApplication.Graphics.SetWindowSize(width, height);
                        }


                        RemoteClientApplication.RunOneFrame();

                        if (UrhoCache.currentScene != null && hPipesConnection != null && hPipesConnection.IsConnected)
                        {
                            if (localConnection.Scene != null && localConnection.Scene == UrhoCache.currentScene)
                            {
                                UrhoCache.currentScene.PrepareNetworkUpdate();
                                localConnection?.CreateSceneUpdate();
                                localConnection?.SendAllBuffers();
                            }
                            else
                            {
                                localConnection.Scene = UrhoCache.currentScene;
                            }
                        }

                        // if (IsFirstTime)
                        // {
                        //     IsFirstTime = false;

                        //     foreach (var node in UrhoCache.nodes)
                        //     {
                        //         Console.WriteLine($"Node: {node.Name}, ID: {node.ID}, Type: {node.TypeName}");
                        //         foreach (var component in node.Components)
                        //         {
                        //             Console.WriteLine($"  Component: {component.TypeName}, ID: {component.ID}");
                        //         }
                        //     }
                        // }


                        // if (isRequestScreenCapture)
                        // {

                        //     Application.Graphics.TakeScreenShot(captureScreenImage);
                        //     if (captureScreenImage.Width == width*2 &&
                        //     captureScreenImage.Height == height*2)
                        //     {
                        //         sendScreenShotAsync();
                        //     }

                        // }

                    }

                    // UnregisterEvents();

                
                    // RemoteClientApplication.Terminate();

                }
                else
                {
                    Console.WriteLine("Game class not found in the assembly.");
                }
            }
        }

        private void OnLocalConnctionMessage(LocalConnectionMessageEventArgs args)
        {
            byte[] data = args.Data;
            if (hPipesConnection != null && hPipesConnection.IsConnected)
            {

                var message = new HPipesMessage()
                {
                    command = HPipesCommand.H_PIPES_REMOTE_SCENE_UPDATE,
                    sceneUpdateBuffer = data,
                };
                hPipesConnection.WriteAsync(message);

            }
        }

        // public async Task sendScreenShotAsync()
        // {
        //     if (hPipesConnection != null && hPipesConnection.IsConnected)
        //     {
        //         // Application.Graphics.TakeScreenShot(captureScreenImage);

        //         if (sharedScreen == null)
        //         {
        //             Console.WriteLine($"New Memory {captureScreenImage.Width * captureScreenImage.Height * 4} ");

        //             sharedScreen = new Memory("sharedscreen", (ulong)(captureScreenImage.Width * captureScreenImage.Height * 4), true);
        //             Console.WriteLine("call sharedScreen.Open() ");
        //             if (sharedScreen.Create() == Error.kOK)
        //             {
        //                 isSharedScreenOK = true;
        //                 Console.WriteLine("sharedScreen ok");
        //             }
        //             else
        //             {
        //                 Console.WriteLine("sharedScreen open error");
        //             }
        //         }

        //         if (isSharedScreenOK)
        //         {
        //             writeSharedScreen();

        //             var message = new HPipesMessage()
        //             {
        //                 command = HPipesCommand.H_PIPES_SCREEN_CAPTURE_RESPONSE,
        //                 width = captureScreenImage.Width,
        //                 height = captureScreenImage.Height
        //             };

        //             hPipesConnection.WriteAsync(message);
        //         }
        //     }
        // }

        // private unsafe void writeSharedScreen()
        // {
        //     sharedScreen.Write(captureScreenImage.Data, (int)(captureScreenImage.Width * captureScreenImage.Height * 4));
        // }

        public async Task RunAsyncClient(string pipeName)
        {

            Console.WriteLine($"RunAsyncClient enter");

            client = new PipeClient<HPipesMessage>(pipeName, formatter: new NewtonsoftJsonFormatter());
            client.MessageReceived += OnMessageReceived;

            client.Disconnected += (o, args) => System.Console.WriteLine("Disconnected from server");
            client.Connected += (o, args) =>
            {
                hPipesConnection = args.Connection;

                System.Console.WriteLine("Connected to server");

                var response = new HPipesMessage()
                {
                    command = HPipesCommand.H_PIPE_HELLO,
                    Text = "Hello from UrhoPlayer"
                };
                hPipesConnection.WriteAsync(response);
            };

            client.ExceptionOccurred += (o, args) => System.Console.WriteLine(args.Exception);

            await client.ConnectAsync();

            Console.WriteLine($"RunAsyncClient exit");

        }

        void OnMessageReceived(Object sender, ConnectionMessageEventArgs<HPipesMessage> args)
        {

                    HPipesMessage message = args.Message;

                    if(RemoteClientApplication == null || Application.isExiting || RemoteClientApplication.IsActive == false)return;

                    Application.InvokeOnMain(() =>
                    {
                        // Console.WriteLine($"HPipesMessage : {message.command}");
                        switch (message.command)
                        {
                            case HPipesCommand.H_PIPES_UNKNOWN:
                                {

                                }
                                break;

                            case HPipesCommand.H_PIPES_SHOW_WINDOW:
                                {

                                    RemoteClientApplication?.Graphics.ShowWindow();
                                }
                                break;
                            // 
                            case HPipesCommand.H_PIPES_HIDE_WINDOW:
                                {
                                    RemoteClientApplication?.Graphics.HideWindow();
                                }
                                break;

                            case HPipesCommand.H_PIPES_SET_WINDOW_PRIORITY:
                                {
                                    RemoteClientApplication?.Graphics.SetWindowToPriority(message.WindowPriority);
                                }
                                break;
                            case HPipesCommand.H_PIPES_WINDOW_LOST_FOCUS:
                                {
                                    isParentInFocus = false;
                                    int isFocused = RemoteClientApplication.Graphics.WindowFocused;

                                    Log.Info($"H_PIPES_WINDOW_LOST_FOCUS isFocused {isFocused} ");
                                    if (isFocused ==0)
                                    {
                                        RemoteClientApplication?.Graphics.HideWindow();
                                    }
                                }
                                break;

                            case HPipesCommand.H_PIPES_WINDOW_GAIN_FOCUS:
                                {
                                    isParentInFocus = true;
                                    RemoteClientApplication?.Graphics.ShowWindow();
                                }
                                break;


                            case HPipesCommand.H_PIPES_SET_WINDOW_POSTION:
                                {
                                    // Console.WriteLine($"H_PIPES_SET_WINDOW_POSTION {message.X} {message.Y}");
                                    RemoteClientApplication.Graphics.SetWindowPosition(message.X, message.Y);
                                }
                                break;
                            case HPipesCommand.H_PIPES_SET_WINDOW_SIZE:
                                {
                                    width = message.width;
                                    height = message.height;
                                    // Console.WriteLine($"H_PIPES_SET_WINDOW_SIZE {width} {height}");
                                    RemoteClientApplication.Graphics.SetWindowSize(message.width, message.height);
                                }
                                break;
                            case HPipesCommand.H_PIPES_SCREEN_CAPTURE_REQUEST:
                                {
                                    isRequestScreenCapture = true;
                                }
                                break;
                            case HPipesCommand.H_PIPES_MOUSE_MOVE:
                                {
                                    input.SetMousePosition(new IntVector2(message.X, message.Y));
                                }
                                break;
                            case HPipesCommand.H_PIPES_MOUSE_BUTTON_DOWN:
                                {
                                    var mousePos = new IntVector2(message.X, message.Y);
                                    RemoteClientApplication.Input.SetMousePosition(mousePos);

                                    RemoteClientApplication.Input.SetMouseButton((MouseButton)message.Button, true, message.Clicks);
                                }
                                break;
                            case HPipesCommand.H_PIPES_MOUSE_BUTTON_UP:
                                {

                                    RemoteClientApplication.Input.SetMouseButton((MouseButton)message.Button, false, message.Clicks);
                                }
                                break;
                            case HPipesCommand.H_PIPES_KEY_DOWN:
                                {
                                    if (!RemoteClientApplication.Input.GetKeyPress(message.Key))
                                    {
                                        RemoteClientApplication.Input.SetKey(message.Key, (Scancode)message.Scancode, true);
                                    }
                                }
                                break;
                            case HPipesCommand.H_PIPES_KEY_UP:
                                {
                                    RemoteClientApplication.Input.SetKey(message.Key, (Scancode)message.Scancode, false);
                                }
                                break;
                        }
                    });

                    switch (message.command)
                    {
                        case HPipesCommand.H_PIPE_TOGGLE_PAUSE:
                            {
                                TogglePause();
                            }
                            break;
                    }
                
        }

        void TogglePause()
        {
            if(RemoteClientApplication == null || Application.isExiting || RemoteClientApplication.IsActive == false)return;
            Application.IsPaused = !Application.IsPaused;
            // for (uint i = 0; i < RemoteClientApplication.Renderer.NumViewports; i++)
            // {
            //     var viewport = RemoteClientApplication.Renderer.GetViewport(i);
            //     if (viewport != null)
            //     {

            //         Log.Info($"Viewport: {viewport}, Scene: {viewport.Scene}, UpdateEnabled: {viewport.Scene?.UpdateEnabled}");
            //         if (viewport.Scene != null)
            //         {
            //             viewport.Scene.UpdateEnabled = RemoteClientApplication.IsPaused;
            //         }
            //         else
            //         {
            //             Log.Error("viewport.Scene = null");
            //         }
            //     }
            // }
        }

    }

}