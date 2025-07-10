using Urho;
using System;
using System.Runtime.Loader;
using System.Reflection;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Threading;
using Urho.IO;
using  H.Pipes;
namespace UrhoPlayer
{
    public partial class UrhoPlayer
    {

        public bool isParentInFocus { get; private set; } = true;

        private void RegisterEvents()
        {
            Events.NodeAdded += OnNodeAdded;
            Events.NodeRemoved += OnNodeRemoved;
            Events.ComponentAdded += OnComponentAdded;
            Events.ComponentRemoved += OnComponentRemoved;
            RemoteClientApplication.Update += HandleUpdate;
            RemoteClientApplication.Input.KeyDown += HandleKeyDown;

        }

        private void UnregisterEvents()
        {
            Events.NodeAdded -= OnNodeAdded;
            Events.NodeRemoved -= OnNodeRemoved;
            Events.ComponentAdded -= OnComponentAdded;
            Events.ComponentRemoved -= OnComponentRemoved;
            RemoteClientApplication.Update -= HandleUpdate;
            RemoteClientApplication.Input.KeyDown -= HandleKeyDown;
        }

        private void OnComponentRemoved(ComponentRemovedEventArgs args)
        {
            // Console.WriteLine($"OnComponentRemoved {args.Component.TypeName}");
            UrhoCache.RemoveComponent(args.Component);
        }

        private void OnNodeRemoved(NodeRemovedEventArgs args)
        {
            // Console.WriteLine($"OnNodeRemoved {args.Node.TypeName}");
            UrhoCache.RemoveNode(args.Node);
        }

        private void OnNodeAdded(NodeAddedEventArgs args)
        {

            if (args.Scene != null && UrhoCache.currentScene != args.Scene)
            {
                UrhoCache.SetCurrentScene(args.Scene);
                Console.WriteLine($"Current scene changed to {UrhoCache.currentScene.Name}");
            }
            UrhoCache.AddNode(args.Node);
        }


        private void OnComponentAdded(ComponentAddedEventArgs args)
        {

            // Console.WriteLine($"OnComponentAdded {args.Component.TypeName}");
            UrhoCache.AddComponent(args.Component);
        }

        private void HandleKeyDown(KeyDownEventArgs e)
        {
            // Console.WriteLine($"HandleKeyDown {e.Key}");
            switch (e.Key)
            {
                case Key.Esc:
                    {
                        UnregisterEvents();
                        // if (client?.IsConnected == true)
                        // {

                        //     var message = new HPipesMessage()
                        //     {
                        //         command = HPipesCommand.H_PIPES_TERMINATE_APP,
                        //     };

                        //     hPipesConnection.WriteAsync(message);
                        //     client?.DisconnectAsync().Wait();
                        //     client.MessageReceived -= OnMessageReceived;
                        //     hPipesConnection = null;
                        // }
                        // else
                        {
                            //    
                            client?.DisconnectAsync().Wait();
                            hPipesConnection = null;
                            RemoteClientApplication.Exit();
                        }


                    }
                    return;

                case Key.P:
                    {
                        if (RemoteClientApplication.Graphics.WindowFocused == 1)
                        {
                            TogglePause();
                        }
                    }
                    break;
            }
        }


        private void HandleUpdate(UpdateEventArgs args)
        {

        }
    }
}