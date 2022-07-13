#
# Copyright (c) 2008-2020 the Urho3D project.
# Copyright (c) 2008-2021 Eli Aloni a.k.a elix22.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

if (IOS)

# Set CMake minimum version
cmake_minimum_required (VERSION 3.10.2)

project (TEMPLATE_PROJECT_NAME)


# Set CMake modules search path
set (CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/CMake/Modules)
 
# Include UrhoCommon.cmake module after setting project name
include (UrhoCommon)
 

# Define target name
set (TARGET_NAME TEMPLATE_PROJECT_NAME)


set (MONO_LIBPATH  ../libs/ios)  
set (LIBS 
    lib-urho3d-mono-aot.a
    libSystem.IO.Compression.Native.a		
    libicudata.a					
    libSystem.Native.a				
    libicui18n.a					
    libSystem.Net.Security.Native.a			
    libicuuc.a					
    libSystem.Security.Cryptography.Native.Apple.a			
    libmonosgen-2.0.a
    libmono-component-debugger-stub-static.a
    libmono-component-hot_reload-stub-static.a
    libmono-component-diagnostics_tracing-stub-static.a
    "-framework Security"
    "-framework GSS"
    "-framework CFNetwork"
    "-framework SystemConfiguration"
    "-framework Metal"
)
set(BITCODE "")
set(CMAKE_XCODE_ATTRIBUTE_ENABLE_BITCODE "NO" CACHE INTERNAL "")
file (GLOB S_FILES *.s)
file (GLOB EXTRA_MM_FILES *.mm)

file (GLOB EXTRA_PLATFORM_M_FILES ../platform/ios/*.m)
file (GLOB EXTRA_PLATFORM_MM_FILES ../platform/ios/*.mm)
file (GLOB EXTRA_PLATFORM_CPP_FILES ../platform/ios/*.cpp)

if(APPLE)
set (LIBS  ${LIBS}  z ncurses)
endif()



link_directories(. ${MONO_LIBPATH})

set (INCLUDE_DIRS ${INCLUDE_DIRS} include/mono-2.0 Plugins)

file(GLOB_RECURSE cmakeFiles ${CMAKE_SOURCE_DIR}/Plugins/CMakeLists.txt)
foreach(cmakeFile ${cmakeFiles})
    message("INCLUDE ${cmakeFile}")
    include(${cmakeFile})
endforeach(cmakeFile)

# Define source files
define_source_files (EXTRA_H_FILES ${COMMON_SAMPLE_H_FILES} ${S_FILES} ${EXTRA_MM_FILES} ${MACOS_FILES} ${PLUGIN_FILES} ${EXTRA_PLATFORM_M_FILES} ${EXTRA_PLATFORM_MM_FILES} ${EXTRA_PLATFORM_CPP_FILES})

# Setup target with resource copying
setup_main_executable ()


set_property (TARGET ${TARGET_NAME} PROPERTY XCODE_ATTRIBUTE_FRAMEWORK_SEARCH_PATHS ${FRAMEWORK_SEARCH_PATHS})
set_target_properties(${TARGET_NAME} PROPERTIES XCODE_ATTRIBUTE_DEVELOPMENT_TEAM ${DEVELOPMENT_TEAM})
set_property (TARGET ${TARGET_NAME} PROPERTY XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY  ${CODE_SIGN_IDENTITY})
set_property (TARGET ${TARGET_NAME} PROPERTY XCODE_ATTRIBUTE_PROVISIONING_PROFILE_SPECIFIER  ${PROVISIONING_PROFILE_SPECIFIER})



endif() # IOS

