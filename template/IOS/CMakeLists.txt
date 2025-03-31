#
# Copyright (c) 2008-2025 the Urho3D project.
# Copyright (c) 2008-2025 Eli Aloni a.k.a elix22.
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
 
# Override FindUrho3D.cmake behavior
macro(find_package)
  if(${ARGV0} STREQUAL "Urho3D")
    # Skip the actual find_package for Urho3D
    return()
  endif()
  _find_package(${ARGV})
endmacro()

# Define target name
set (TARGET_NAME TEMPLATE_PROJECT_NAME)

set(FRAMEWORK_SEARCH_PATHS "${FRAMEWORK_SEARCH_PATHS}" "${CMAKE_SOURCE_DIR}/Frameworks")
set(CMAKE_XCODE_ATTRIBUTE_FRAMEWORK_SEARCH_PATHS "${FRAMEWORK_SEARCH_PATHS}")

set (MONO_LIBPATH  ../libs/ios)  
set (LIBS 
    "-framework Security"
    "-framework GSS"
    "-framework CFNetwork"
    "-framework SystemConfiguration"
    "-framework Metal"
    "-framework Urho3D"
    "-framework Game"
)
set(BITCODE "")
set(CMAKE_XCODE_ATTRIBUTE_ENABLE_BITCODE "NO" CACHE INTERNAL "")
file (GLOB S_FILES *.s)
file (GLOB EXTRA_MM_FILES *.mm)
file (GLOB EXTRA_PLATFORM_M_FILES ../platform/ios/*.m)
file (GLOB EXTRA_PLATFORM_MM_FILES ../platform/ios/*.mm)
file (GLOB EXTRA_PLATFORM_CPP_FILES ../platform/ios/*.cpp)

# Set the runpath search path
set(CMAKE_XCODE_ATTRIBUTE_LD_RUNPATH_SEARCH_PATHS "@executable_path/Frameworks")

set(CMAKE_XCODE_ATTRIBUTE_EMBED_FRAMEWORKS "${CMAKE_SOURCE_DIR}/Frameworks/Urho3D.framework;${CMAKE_SOURCE_DIR}/Frameworks/Game.framework")

if(APPLE)
set (LIBS  ${LIBS}  z ncurses)
endif()



link_directories(. ${MONO_LIBPATH})

set (INCLUDE_DIRS ${INCLUDE_DIRS}  include include/Urho3D include/Urho3D/ThirdParty include/Urho3D/ThirdParty/Bullet include/mono-2.0 Plugins)

file(GLOB_RECURSE cmakeFiles ${CMAKE_SOURCE_DIR}/Plugins/CMakeLists.txt)
foreach(cmakeFile ${cmakeFiles})
    message("INCLUDE ${cmakeFile}")
    include(${cmakeFile})
endforeach(cmakeFile)

file(GLOB_RECURSE cmakeFiles ${CMAKE_SOURCE_DIR}/../platform/ios/CMakeLists.txt)
foreach(cmakeFile ${cmakeFiles})
    message("INCLUDE ${cmakeFile}")
    include(${cmakeFile})
endforeach(cmakeFile)

# Define source files
define_source_files (EXTRA_H_FILES ${COMMON_SAMPLE_H_FILES} ${S_FILES} ${EXTRA_MM_FILES} ${MACOS_FILES} ${PLUGIN_FILES} ${EXTRA_PLATFORM_M_FILES} ${EXTRA_PLATFORM_MM_FILES} ${EXTRA_PLATFORM_CPP_FILES})

# Setup target with resource copying
setup_main_executable (NODEPS)


# set_property(TARGET ${TARGET_NAME} PROPERTY XCODE_ATTRIBUTE_EMBED_FRAMEWORKS "${CMAKE_SOURCE_DIR}/Frameworks/Urho3D.framework;${CMAKE_SOURCE_DIR}/Frameworks/Game.framework")
set_target_properties(${TARGET_NAME} PROPERTIES
    XCODE_EMBED_FRAMEWORKS "${CMAKE_SOURCE_DIR}/Frameworks/Urho3D.framework;${CMAKE_SOURCE_DIR}/Frameworks/Game.framework"
    XCODE_EMBED_FRAMEWORKS_CODE_SIGN_ON_COPY ON
)
# Set runpath
set_target_properties(${TARGET_NAME} PROPERTIES 
    XCODE_ATTRIBUTE_LD_RUNPATH_SEARCH_PATHS "@executable_path/Frameworks"
)

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -F${CMAKE_SOURCE_DIR}/Frameworks")
target_link_libraries(${TARGET_NAME} "-framework Urho3D" "-framework Game")

set_property (TARGET ${TARGET_NAME} PROPERTY XCODE_ATTRIBUTE_FRAMEWORK_SEARCH_PATHS ${FRAMEWORK_SEARCH_PATHS})
set_target_properties(${TARGET_NAME} PROPERTIES XCODE_ATTRIBUTE_DEVELOPMENT_TEAM ${DEVELOPMENT_TEAM})
set_property (TARGET ${TARGET_NAME} PROPERTY XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY  ${CODE_SIGN_IDENTITY})
set_property (TARGET ${TARGET_NAME} PROPERTY XCODE_ATTRIBUTE_PROVISIONING_PROFILE_SPECIFIER  ${PROVISIONING_PROFILE_SPECIFIER})



endif() # IOS

