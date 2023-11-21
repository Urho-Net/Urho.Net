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
# ********************************************************************
#
# newproject.sh
#
# This script generates a set of  project files.
# The new project will be based of the template project and 
# it will be generated with the name and location that is specified
# as input parameters.
#
# IMPORTANT: This script must be run from the root of the 
# source tree.
#
# ********************************************************************

#Find out which OS we're on. 
unamestr=$(uname)

# Switch-on alias expansion within the script 
shopt -s expand_aliases

#Alias the sed in-place command for OSX and Linux - incompatibilities between BSD and Linux sed args
if [[ "$unamestr" == "Darwin" ]]; then
	alias aliassedinplace='sed -i ""'
else
	#For Linux, notice no space after the '-i' 
	alias aliassedinplace='sed -i""'
fi


if [ ! -f ~/.urhonet_config/urhonethome ]; then
	echo  "1 Urho.Net is not configured , configuring now  "
	./configure.sh
fi

URHONET_HOME_ROOT=$(cat ~/.urhonet_config/urhonethome)

if [ ! -d "$URHONET_HOME_ROOT" ]; then
	echo  "Urho.Net is not configured , please  run configure.sh (configure.bat on Windows) from Urho.Net installation folder  "
	exit -1
else
	echo  "URHONET_HOME_ROOT=$URHONET_HOME_ROOT"
fi

echo
echo "1. Enter a name for the new project."
echo
echo "   This name will be given to the project"
echo "   executable and a folder with this name"
echo "   will be created to store all project files."
echo "   Ex. foobar"
echo
read -p "Project Name: " projName 
if [[ "$projName" == "" ]]; then
	echo
	echo "ERROR: No project name specified."
	echo
	exit -1;
fi
echo

projName="$(echo -e "${projName}" | tr -d '[:space:]')"
projectNameLower=$(echo ${projName} |  tr 'A-Z' 'a-z')
title=${projName}
className=${projName}


echo
echo "2. Enter a unique identifier for your project."
echo
echo "   This should be a human readable package name,"
echo "   containing at least two words separated by a"
echo "   period."
echo "   Ex. com.example.foobar"
echo
read -p "Unique ID: " uuid
if [[ "$uuid" == "" ]]; then
	echo
	echo "ERROR: No uuid specified."
	echo
	exit -1;
fi
echo

uuid=$(echo ${uuid} |  sed 's/'${projectNameLower}'//g' )
uuid=${uuid}.${projectNameLower}
uuid=$(echo "$uuid" | tr . /) 
for i in {1..10}
do
   uuid=`echo "$uuid" | sed 's_//_/_g'`
done
uuid=$(echo "$uuid" | tr / .) 

java_package_path=$(echo "$uuid" | tr . /) 
for i in {1..10}
do
   java_package_path=`echo "$java_package_path" | sed 's_//_/_g'`
done
java_package_path=`echo "java/$java_package_path"`


echo
echo "3. Enter the project path."
echo
echo "   This can be a relative path, absolute path,"
echo "   or empty for the current folder. Note that"
echo "   a project folder named $projName will also"
echo "   be created inside this folder."
echo "   Ex. ./samples"
echo
read -p "Path: " location
if [[ "$location" == "" ]]; then
	projPath=$projName
else
	projPath="$location/$projName"
fi
echo

# Verify Path and eliminate double '//'
projPath=`echo "$projPath" | sed 's_//_/_g'`
if [ -e $projPath ]; then
	echo
	echo "ERROR: Path '$projPath' already exists, aborting."
	echo
	exit -2
fi

# Make required source folder directories
mkdir -p "$projPath"


currPwd=`pwd`
projPath=`cd $projPath; pwd`
`cd $currPwd`


mkdir "-p" "$projPath/References"
cp "-f" "template/libs/dotnet/urho/desktop/UrhoDotNet.dll" "$projPath/References/"
cp "-f" "template/libs/dotnet/urho/desktop/UrhoDotNet.xml" "$projPath/References/"

cp "-r" "template/.vscode" "$projPath"

cp "-r" "template/script" "$projPath"

aliassedinplace "s*TEMPLATE_PROJECT_UUID*$uuid*g" "$projPath/script/project_vars.sh"
aliassedinplace "s*TEMPLATE_PROJECT_NAME*$projName*g" "$projPath/script/project_vars.sh"
aliassedinplace "s*TEMPLATE_JAVA_PACKAGE_PATH*$java_package_path*g" "$projPath/script/project_vars.sh"


cp "-r" "template/Assets" "$projPath"

cp "-r" "template/Source" "$projPath"
mv "$projPath/Source/template.cs" "$projPath/Source/${projName}.cs" 

aliassedinplace "s*TEMPLATE_PROJECT_NAME*$projName*g" "$projPath/Source/${projName}.cs"
aliassedinplace "s*TEMPLATE_CLASS_NAME*$className*g" "$projPath/Source/${projName}.cs"

aliassedinplace "s*TEMPLATE_PROJECT_NAME*$projName*g" "$projPath/Source/Sample.cs"
aliassedinplace "s*TEMPLATE_PROJECT_NAME*$projName*g" "$projPath/Source/JoystickLayoutPatches.cs"

cp "template/Program.cs" "$projPath/Program.cs"
aliassedinplace "s*TEMPLATE_PROJECT_NAME*$projName*g" "$projPath/Program.cs"
aliassedinplace "s*TEMPLATE_CLASS_NAME*$className*g" "$projPath/Program.cs"

cp "template/template.csproj" "$projPath/$projName.csproj"

mkdir "-p" "$projPath/tools"
cp "-r" "tools/ReferenceAssemblyResolver" "$projPath/tools"
cp "-R" "tools/bash_mini/." "$projPath/tools/bash"
cp "-r" "tools/UrhoCooker" "$projPath/tools"


cp "template/obfuscar.xml" "$projPath/obfuscar.xml"
cp "template/global.json" "$projPath/global.json"

mkdir "-p" "$projPath/platform"
mkdir "-p" "$projPath/platform/android/java"
mkdir "-p" "$projPath/platform/ios"
mkdir "-p" "$projPath/platform/windows"
mkdir "-p" "$projPath/platform/linux"
mkdir "-p" "$projPath/platform/macos"
mkdir "-p" "$projPath/platform/web"

echo "Successful creation"
echo "Project name : '$projName'"
echo "Unique identifier : '$uuid'"
echo "Project path : '$projPath'"

code $projPath
