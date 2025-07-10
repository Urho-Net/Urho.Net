using System;
using Urho;

public static class UrhoPlayerExtentions
{
       public static void InvokeOnMainDelayed(this Application application, float seconds, Action action)
        {
            application.Delay(seconds).GetAwaiter().OnCompleted(() =>
            {
                Application.InvokeOnMain(action);
            });
        }
}