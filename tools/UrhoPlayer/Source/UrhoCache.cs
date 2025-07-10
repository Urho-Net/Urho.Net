using Urho;
using System;
using System.Runtime.Loader;
using System.Reflection;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Threading;
using Urho.IO;
using System.Collections.Generic;

namespace UrhoPlayer
{
    public static class UrhoCache
    {

        public static Scene currentScene { get; private set; } = null;

        public static Dictionary<uint, Node> nodesById { get; private set; } = new Dictionary<uint, Node>();

        public static Dictionary<Node,Matrix3x4> nodesTransform { get; set; } = new Dictionary<Node, Matrix3x4>();

        public static HashSet<Node> nodes { get; private set; } = new HashSet<Node>();
        public static HashSet<Component> components { get; private set; }= new HashSet<Component>();

        public static void Initialize()
        {
            nodesById.Clear();
            nodes.Clear();
            components.Clear();
        }
        public static void SetCurrentScene(Scene scene)
        {
            if (scene == null)
                throw new ArgumentNullException(nameof(scene));

            currentScene = scene;
        }

        public static Node GetNodeById(uint id)
        {
            if (nodesById.TryGetValue(id, out var node))
                return node;
            return null;
        }

        public static Component GetComponentById(uint id)
        {
            return components.FirstOrDefault(c => c.ID == id);
        }

        public static List<Component> GetComponentsByNodeId(uint nodeId)
        {
            return components.Where(c => c.Node?.ID == nodeId).ToList();
        }
        public static List<Node> GetNodesByComponentId(uint componentId)
        {
            return nodes.Where(n => n.Components.Any(c => c.ID == componentId)).ToList();
        }
        public static List<Node> GetAllNodes()
        {
            return nodes.ToList();
        }               
        public static List<Component> GetAllComponents()
        {
            return components.ToList();
        }
        public static void AddNode(Node node)
        {
            if (node == null || nodes.Contains(node))
                return;

            nodes.Add(node);
            nodesById[node.ID] = node;
            nodesTransform[node] = node.WorldTransform; 
        }
        public static void RemoveNode(Node node)
        {
            if (node == null || !nodes.Contains(node))
                return;

            nodes.Remove(node);
            nodesById.Remove(node.ID);

            ClearComponentsByNodeId(node.ID);
        }

        public static void AddComponent(Component component)
        {
            if (component == null || components.Contains(component))
                return;

            components.Add(component);
        }
        public static void RemoveComponent(Component component)
        {
            if (component == null || !components.Contains(component))
                return;

            components.Remove(component);
        }
        public static void Clear()
        {
            nodesById.Clear();
            nodes.Clear();
            components.Clear();
        }
        public static void ClearNodes()
        {
            nodesById.Clear();
            nodes.Clear();
        }
        public static void ClearComponents()
        {
            components.Clear();
        }
        public static void ClearNodeById(uint id)
        {
            if (nodesById.TryGetValue(id, out var node))
            {
                nodesById.Remove(id);
                nodes.Remove(node);
            }
        }
        public static void ClearComponentById(uint id)
        {
            var component = components.FirstOrDefault(c => c.ID == id);
            if (component != null)
            {
                components.Remove(component);
            }
        }
        public static void ClearComponentsByNodeId(uint nodeId)
        {
            foreach (var component in components.Where(c => c.Node?.ID == nodeId).ToList())
            {
                components.Remove(component);
            }
        }
        public static void ClearNodesByComponentId(uint componentId)
        {
            foreach (var node in nodes.Where(n => n.Components.Any(c => c.ID == componentId)).ToList())
            {
                nodes.Remove(node);
                nodesById.Remove(node.ID);
                foreach (var comp in node.Components.ToList())
                {
                    components.Remove(comp);
                }
            }
        }

    }

}