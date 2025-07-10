
using Urho;
using System;
using System.Runtime.Loader;
using System.Reflection;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Threading;
using System.Drawing;

namespace H.Pipes
{
    enum HPipesCommand : uint
    {
        H_PIPES_UNKNOWN,
        H_PIPE_HELLO,
        H_PIPES_SET_WINDOW_POSTION,
        H_PIPES_SET_WINDOW_SIZE,
        H_PIPES_SCREEN_CAPTURE_REQUEST,
        H_PIPES_SCREEN_CAPTURE_RESPONSE,
        H_PIPES_MOUSE_BUTTON_DOWN,
        H_PIPES_MOUSE_BUTTON_UP,
        H_PIPES_MOUSE_MOVE,
        H_PIPES_KEY_DOWN,
        H_PIPES_KEY_UP,
        H_PIPES_SHOW_WINDOW,
        H_PIPES_HIDE_WINDOW,

        H_PIPES_SET_WINDOW_PRIORITY,
        H_PIPES_WINDOW_LOST_FOCUS,
        H_PIPES_WINDOW_GAIN_FOCUS,

        H_PIPE_TOGGLE_PAUSE,
        H_PIPES_REMOTE_SCENE_UPDATE,
        H_PIPES_TERMINATE_APP

}


[Serializable]
class HPipesMessage
{
    public HPipesCommand command = HPipesCommand.H_PIPES_UNKNOWN;
    public Guid Id { get; set; } = Guid.NewGuid();
    public string? Text { get; set; }

    public Urho.Key Key;
    public int Scancode;
    public  int Button;
    public  int Buttons;

    public int Qualifiers;
    public int Clicks;
    public bool Repeat;
    public byte[] capturedImage = new byte[10];
    public int width;
    public int height;

    public int X;
    public int Y;

    public int DX;
    public int DY;

    public int WindowPriority;

    public byte[] sceneUpdateBuffer = new byte[0];

    public override string ToString()
        {
            return $"\"{Text}\" (message ID = {Id})";
        }
}
}