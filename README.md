# Urho.Net
Multi-Platform C# .NET 6.x Game development framework based upon the Urho3D game engine .\
Currently supports :  Windows , Linux , OSX , iOS , Android.\
Web support will be added in the future.

This dotnet-6.x branch is still in a development phase so expect to encounter some issues.


First class Visual Studio Code support as the main IDE on all 3 major platforms , Windows , MacOS and Linux .
### Check the Wiki for quick start
[Wiki](https://github.com/Urho-Net/Urho.Net/wiki)

# <u> Common Dependencies </u>
- **Visual Studio Code** \
  https://code.visualstudio.com/download

- NET 6.x SDK  \
  https://dotnet.microsoft.com/en-us/download/dotnet/6.0

- **C# for Visual Studio Code (powered by OmniSharp)**.\
  - https://channel9.msdn.com/Blogs/dotnet/Get-started-VSCode-Csharp-NET-Core-Windows
  - https://www.youtube.com/watch?v=WeTesTCzep0
  - https://www.youtube.com/watch?v=LXxjCNfd5b4

# <u> iOS Dependencies </u>
- CMake
- XCode
- Valid Apple developer account
- ios-deploy , `brew install ios-deploy`

# <u> Android Dependencies </u>
- Android SDK https://developer.android.com/studio

# <u> Getting Started </u>
- General (updated on 31/01/2021)
  - https://youtu.be/LR4M4RMc1qI
- iOS development
  - https://youtu.be/6YZC6N9cIGk
- Android development
  - https://youtu.be/ElMs_jkcLxo


# Samples 
The samples repo contains several samples with the dotnet-6.x branch\
Not all  samples were converted to .Net 6.x  , mostly due to my laziness , the plan is to convert them over time.\
https://github.com/Urho-Net/Samples

## <u> Urho.Net uses the following third-party libraries: </u>

- The Mono runtime used in Android and iOS binaries are compiled from https://github.com/dotnet/runtime/tree/v6.0.5
  
- Urho3D game engine, special customized version , this is the main development link of this framework. \
  It contains the entire source code , tools and scripts that allow proper development of this C# Multiplatform game framework.\
 [Urho3D dotnet-6.x](https://github.com/elix22/Urho3D/tree/dotnet-6.x)

- ReferenceAssemblyResolver , written from scratch, tool that resolves all the reference assembly dependencies that are part of the main Game.dll\
  https://github.com/elix22/ReferenceAssemblyResolver

- [UrhoCooker](https://github.com/Urho-Net/UrhoCooker) , All purpose utility tool for Urho.Net  , currently supports iOS and Android deployment
