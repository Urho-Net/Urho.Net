
using Urho;
using Urho.Gui;
using System;
using Urho.IO;

namespace UrhoPlayer
{
    public class DragDropFinishEventArgs
    {
        public DragDropFinishEventArgs()
        {

        }
        public EventDataContainer EventData;
        public UIElement Source => EventData.get_UIElement(unchecked((int)537141339) /* Source (P_SOURCE) */);
        public UIElement Target => EventData.get_UIElement(unchecked((int)3997578065) /* Target (P_TARGET) */);

        private Dynamic _accept;
        public bool Accept
        {
            get
            {
                return EventData.get_bool(unchecked((int)368861736) /* Accept (P_ACCEPT) */);
            }

            set
            {
                _accept = value;
                Variant v = _accept.variant;
                EventDataContainer.urho_map_set_value(EventData.Handle, (int)368861736, ref v);
            }
        }
    }

    public class DragDropTestEventArgs
    {
        public EventDataContainer EventData;
        public UIElement Source => EventData.get_UIElement(unchecked((int)537141339) /* Source (P_SOURCE) */);
        public UIElement Target => EventData.get_UIElement(unchecked((int)3997578065) /* Target (P_TARGET) */);
        private Dynamic _accept;
        public bool Accept
        {
            get
            {
                return EventData.get_bool(unchecked((int)368861736) /* Accept (P_ACCEPT) */);
            }

            set
            {
                _accept = value;
                Variant v = _accept.variant;
                EventDataContainer.urho_map_set_value(EventData.Handle, (int)368861736, ref v);
            }
        }
    } /* struct DragDropTestEventArgs */


    public  class Events
    {
        public static Engine Engine = null;

        public static event Action<BeginViewUpdateEventArgs> BeginViewUpdate;
        public static event Action<UIMouseClickEventArgs> UIMouseClick;
        public static event Action<UIMouseClickEndEventArgs> UIMouseClickEnd;

        public static event Action<EndViewUpdateEventArgs> EndViewUpdate;

        public static event Action<BeginViewRenderEventArgs> BeginViewRender;

        public static event Action<EndViewRenderEventArgs> EndViewRender;

        public static event Action<LogMessageEventArgs> LogMessage;

        public static event Action<DragDropTestEventArgs> DragDropTest;

        public static event Action<DragDropFinishEventArgs> DragDropFinish;

        public static event Action<NodeAddedEventArgs> NodeAdded;

        public static event Action<NodeRemovedEventArgs> NodeRemoved;

        public static event Action<ComponentAddedEventArgs> ComponentAdded;

        public static event Action<ComponentRemovedEventArgs> ComponentRemoved;

        public static event Action<NodeNameChangedEventArgs> NodeNameChanged;

        public static event Action<NodeEnabledChangedEventArgs> NodeEnabledChanged;

        public static event Action<ComponentEnabledChangedEventArgs> ComponentEnabledChanged;

        public static event Action<MenuSelectedEventArgs> MenuSelected;

        public static event Action<Scene> SceneLoaded;

        public static Action<DragMoveEventArgs> DragMove;

        public static Action<DragEndEventArgs> DragEnd;


        public static Action<ElementAddedEventArgs> ElementAdded;
        
        public static Action<ElementRemovedEventArgs> ElementRemoved;
        

        public static event Action<UIElement, IntVector2, IntVector2> EventDockResized;
 
        public static void SendEventDockResized(UIElement element, IntVector2 newSize, IntVector2 delta)
        {
            EventDockResized?.Invoke(element, newSize, delta);
        }

  
        public Events(Engine engine)
        {
            Engine = engine;
            Engine.SubscribeToEvent(new StringHash("BeginViewUpdate"), (urhoEventArgs) =>
            {
                BeginViewUpdateEventArgs args = new BeginViewUpdateEventArgs() { EventData = urhoEventArgs.EventData };
                HandleBeginViewUpdate(args);
            });

            Engine.SubscribeToEvent(new StringHash("UIMouseClick"), (urhoEventArgs) =>
            {
                UIMouseClickEventArgs args = new UIMouseClickEventArgs() { EventData = urhoEventArgs.EventData };
                HandleMouseClick(args);
            });

            Engine.SubscribeToEvent(new StringHash("UIMouseClickEnd"), (urhoEventArgs) =>
             {
                 UIMouseClickEndEventArgs args = new UIMouseClickEndEventArgs() { EventData = urhoEventArgs.EventData };
                 HandleMouseClickEnd(args);
             });

            Engine.SubscribeToEvent(new StringHash("EndViewUpdate"), (urhoEventArgs) =>
            {
                EndViewUpdateEventArgs args = new EndViewUpdateEventArgs() { EventData = urhoEventArgs.EventData };
                HandleEndViewUpdate(args);
            });

            Engine.SubscribeToEvent(new StringHash("BeginViewRender"), (urhoEventArgs) =>
            {
                BeginViewRenderEventArgs args = new BeginViewRenderEventArgs() { EventData = urhoEventArgs.EventData };
                HandleBeginViewRender(args);
            });

            Engine.SubscribeToEvent(new StringHash("EndViewRender"), (urhoEventArgs) =>
            {
                EndViewRenderEventArgs args = new EndViewRenderEventArgs() { EventData = urhoEventArgs.EventData };
                HandleEndViewRender(args);
            });

            Engine.SubscribeToEvent(new StringHash("LogMessage"), (urhoEventArgs) =>
            {
                LogMessageEventArgs args = new LogMessageEventArgs() { EventData = urhoEventArgs.EventData };
                HandleLogMessage(args);
            });

            Engine.SubscribeToEvent(new StringHash("DragDropTest"), (urhoEventArgs) =>
            {
                DragDropTestEventArgs args = new DragDropTestEventArgs() { EventData = urhoEventArgs.EventData };
                HandleDragDropTest(args);
            });

            Engine.SubscribeToEvent(new StringHash("DragDropFinish"), (urhoEventArgs) =>
            {
                DragDropFinishEventArgs args = new DragDropFinishEventArgs() { EventData = urhoEventArgs.EventData };
                HandleDragDropFinish(args);
            });

            Engine.SubscribeToEvent(new StringHash("NodeAdded"), (urhoEventArgs) =>
            {
                NodeAddedEventArgs args = new NodeAddedEventArgs() { EventData = urhoEventArgs.EventData };
                HandleNodeAdded(args);
            });

            Engine.SubscribeToEvent(new StringHash("NodeRemoved"), (urhoEventArgs) =>
            {
                NodeRemovedEventArgs args = new NodeRemovedEventArgs() { EventData = urhoEventArgs.EventData };
                HandleNodeRemoved(args);
            });

            Engine.SubscribeToEvent(new StringHash("ComponentAdded"), (urhoEventArgs) =>
            {
                ComponentAddedEventArgs args = new ComponentAddedEventArgs() { EventData = urhoEventArgs.EventData };
                HandleComponentAdded(args);
            });

            Engine.SubscribeToEvent(new StringHash("ComponentRemoved"), (urhoEventArgs) =>
            {
                ComponentRemovedEventArgs args = new ComponentRemovedEventArgs() { EventData = urhoEventArgs.EventData };
                HandleComponentRemoved(args);
            });

            Engine.SubscribeToEvent(new StringHash("NodeNameChanged"), (urhoEventArgs) =>
            {
                NodeNameChangedEventArgs args = new NodeNameChangedEventArgs() { EventData = urhoEventArgs.EventData };
                HandleNodeNameChanged(args);
            });

            Engine.SubscribeToEvent(new StringHash("NodeEnabledChanged"), (urhoEventArgs) =>
            {
                NodeEnabledChangedEventArgs args = new NodeEnabledChangedEventArgs() { EventData = urhoEventArgs.EventData };
                HandleNodeEnabledChanged(args);
            });

            Engine.SubscribeToEvent(new StringHash("ComponentEnabledChanged"), (urhoEventArgs) =>
            {
                ComponentEnabledChangedEventArgs args = new ComponentEnabledChangedEventArgs() { EventData = urhoEventArgs.EventData };
                HandleComponentEnabledChanged(args);
            });

            Engine.SubscribeToEvent(new StringHash("MenuSelected"), (arg) =>
            {
                MenuSelectedEventArgs args = new MenuSelectedEventArgs() { EventData = arg.EventData };
                HandleMenuSelected(args);
            });

            Engine.SubscribeToEvent(new StringHash("DragMove"), (arg) =>
            {
                DragMoveEventArgs args = new DragMoveEventArgs() { EventData = arg.EventData };
                HandleDragMove(args);
            });

            Engine.SubscribeToEvent(new StringHash("DragEnd"), (arg) =>
            {
                DragEndEventArgs args = new DragEndEventArgs() { EventData = arg.EventData };
                HandleDragEnd(args);
            });

            
            Engine.SubscribeToEvent(new StringHash("ElementAdded"), (arg) =>
            {
                ElementAddedEventArgs args = new ElementAddedEventArgs() { EventData = arg.EventData };
                HandleElementAdded(args);
            });

            //
                Engine.SubscribeToEvent(new StringHash("ElementRemoved"), (arg) =>
            {
                ElementRemovedEventArgs args = new ElementRemovedEventArgs() { EventData = arg.EventData };
                HandleElementRemoved(args);
            });

        }


        private static void HandleElementRemoved(ElementRemovedEventArgs args)
        {
            ElementRemoved?.Invoke(args);
        }

        private static void HandleElementAdded(ElementAddedEventArgs args)
        {
            ElementAdded?.Invoke(args);
        }

        private static void HandleDragEnd(DragEndEventArgs args)
        {
            DragEnd?.Invoke(args);
        }

        private static void HandleDragMove(DragMoveEventArgs args)
        {
            DragMove?.Invoke(args);
        }

        private static void HandleMenuSelected(MenuSelectedEventArgs args)
        {
            MenuSelected?.Invoke(args);
        }

        private static void HandleComponentEnabledChanged(ComponentEnabledChangedEventArgs args)
        {
            ComponentEnabledChanged?.Invoke(args);
        }

        private static void HandleNodeEnabledChanged(NodeEnabledChangedEventArgs args)
        {
            NodeEnabledChanged?.Invoke(args);
        }

        private static void HandleNodeNameChanged(NodeNameChangedEventArgs args)
        {
            NodeNameChanged?.Invoke(args);
        }

        private static void HandleComponentRemoved(ComponentRemovedEventArgs args)
        {
            ComponentRemoved?.Invoke(args);
        }

        private static void HandleComponentAdded(ComponentAddedEventArgs args)
        {
            ComponentAdded?.Invoke(args);
        }

        private static void HandleNodeRemoved(NodeRemovedEventArgs args)
        {
            NodeRemoved?.Invoke(args);
        }

        private static void HandleNodeAdded(NodeAddedEventArgs args)
        {
            NodeAdded?.Invoke(args);
        }

        private static void HandleDragDropFinish(DragDropFinishEventArgs args)
        {
            DragDropFinish?.Invoke(args);
        }

        private static void HandleDragDropTest(DragDropTestEventArgs args)
        {
            DragDropTest?.Invoke(args);
        }

        private static void HandleLogMessage(LogMessageEventArgs args)
        {
            LogMessage?.Invoke(args);
        }

        private static void HandleEndViewRender(EndViewRenderEventArgs args)
        {
            EndViewRender?.Invoke(args);
        }

        private static void HandleBeginViewRender(BeginViewRenderEventArgs args)
        {
            BeginViewRender?.Invoke(args);
        }

        private static void HandleEndViewUpdate(EndViewUpdateEventArgs args)
        {
            EndViewUpdate?.Invoke(args);
        }

        private static void HandleMouseClickEnd(UIMouseClickEndEventArgs args)
        {
            UIMouseClickEnd?.Invoke(args);
        }

        private static void HandleMouseClick(UIMouseClickEventArgs args)
        {
            UIMouseClick?.Invoke(args);
        }

        private static void HandleBeginViewUpdate(BeginViewUpdateEventArgs args)
        {
            BeginViewUpdate?.Invoke(args);
        }

        public static void HandleSceneLoaded(Scene scene)
        {
            SceneLoaded?.Invoke(scene);
        }
    }

}