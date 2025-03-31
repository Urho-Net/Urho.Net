//
// Copyright (c) 2008-2020 the Urho3D project.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#ifndef URHO3D_API_H
#define URHO3D_API_H

#ifdef URHO3D_STATIC_DEFINE
#  define URHO3D_API
#  define URHO3D_NO_EXPORT
#else
#  ifndef URHO3D_API
#    ifdef Urho3D_EXPORTS
        /* We are building this library */
#      define URHO3D_API __attribute__((visibility("default")))
#    else
        /* We are using this library */
#      define URHO3D_API __attribute__((visibility("default")))
#    endif
#  endif

#  ifndef URHO3D_NO_EXPORT
#    define URHO3D_NO_EXPORT __attribute__((visibility("hidden")))
#  endif
#endif

#ifndef URHO3D_DEPRECATED
#  define URHO3D_DEPRECATED __attribute__ ((__deprecated__))
#endif

#ifndef URHO3D_DEPRECATED_EXPORT
#  define URHO3D_DEPRECATED_EXPORT URHO3D_API URHO3D_DEPRECATED
#endif

#ifndef URHO3D_DEPRECATED_NO_EXPORT
#  define URHO3D_DEPRECATED_NO_EXPORT URHO3D_NO_EXPORT URHO3D_DEPRECATED
#endif

#if 0 /* DEFINE_NO_DEPRECATED */
#  ifndef URHO3D_NO_DEPRECATED
#    define URHO3D_NO_DEPRECATED
#  endif
#endif

#define NONSCRIPTABLE 

#define URHO3D_OPENGL
#define URHO3D_DATABASE_SQLITE

#ifdef __APPLE__
#include <TargetConditionals.h>
#if defined(TARGET_OS_OSX) && defined(TARGET_CPU_ARM64)
#define APPLE_SILICON
#endif
#if defined(APPLE_SILICON) && defined(URHO3D_SSE)
#undef URHO3D_SSE
#endif
#endif

#endif /* URHO3D_API_H */
