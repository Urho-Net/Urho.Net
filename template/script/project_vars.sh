#!/usr/bin/env bash

# Copyright (c) 2020-2021 Eli Aloni a.k.a elix22.
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

export PROJECT_UUID='TEMPLATE_PROJECT_UUID'
export PROJECT_NAME='TEMPLATE_PROJECT_NAME' 
export JAVA_PACKAGE_PATH='TEMPLATE_JAVA_PACKAGE_PATH' 

#  This should be increased for evry new submission to Google Play store
export VERSION_CODE=1
export VERSION_NAME='1.0.0'



# Add the plugins that you want to include 
# The plugins must reside in the Plugins folder and the plugin name must match the plugin folder name , the syntax is :
# export PLUGINS=('plugin-1' 'plugin-2' 'plugin-3' ... )

#  Application  ID
# export GAD_APPLICATION_ID=''

# Add Android permissions
# export ANDROID_PERMISSIONS=('permission 1' 'permission 2' 'permission 3' ... )

# Add dependcies for Android
# export ANDROID_DEPENDENCIES=('dependency 1' 'dependency 2' 'dependency 3' ... )

# add external reference dll's that should be part of the build , the dll's must be present in the References folder
# export DOTNET_REFERENCE_DLL=('')
# export DOTNET_BCL_REFERENCE=('')

# Supported Android architectures  , remove any architecture that is not needed inorder to reduce the apk size.
# The minimal ABI on ARM devices is armeabi-v7a , that's the minimal one  to make is work on ARM based devices
# In case of an Intel based processor (x86/x86_64) , one must add 'x86' or and 'x86_64' to make it work on such device
# if this variable is not defined then armeabi-v7a will be added by default.
# x86 is not supported  on Android NativeAOT
export ANDROID_ARCHITECTURE=('arm64-v8a' 'armeabi-v7a'  'x86_64')