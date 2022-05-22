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

. ../script/project_vars.sh

export URHO3D_HOME=$(pwd)
export LOCAL_MONO_PATH=${URHO3D_HOME}/../libs/dotnet/bcl/ios
export URHO3D_DLL_PATH=${URHO3D_HOME}/../libs/dotnet/urho/mobile/ios
export URHO3D_LIB_GLES_PATH=${URHO3D_HOME}/../libs/ios/urho3d/gles
export URHO3D_LIB_METAL_PATH=${URHO3D_HOME}/../libs/ios/urho3d/metal
export XCODE=$(xcode-select --print-path)
export CLANG=${XCODE}/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang
export AR=${XCODE}/Toolchains/XcodeDefault.xctoolchain/usr/bin/ar
export LIPO=${XCODE}/Toolchains/XcodeDefault.xctoolchain/usr/bin/lipo
export IOS_SDK_PATH=${XCODE}/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk
export MONO_IOS_AOT_CC_PATH=${URHO3D_HOME}/aot-compilers/iphone-arm64
export MONO_IOS_AOT_CC=${MONO_IOS_AOT_CC_PATH}/aarch64-apple-darwin-mono-sgen
export ASSETS_FOLDER_DOTNET_PATH=${URHO3D_HOME}/bin/Data/DotNet
export ASSETS_FOLDER_DOTNET_IOS_PATH=${URHO3D_HOME}/bin/Data/DotNet/ios
export C_SHARP_SOURCE_CODE='../../Program.cs  -recurse:'../../Source/*.cs''
export INTERMEDIATE_FOLDER=intermediate
IOS_AOT_MODULES_HEADER=${URHO3D_HOME}/ios_aot_modules.h
IOS_AOT_MODULES_MM=${URHO3D_HOME}/ios_aot_modules.mm
REGISTER_PLUGINS=${URHO3D_HOME}/register_plugins.cpp

export BUILD_DIR=build

export UUID='TEMPLATE_UUID'
export APP_NAME='TEMPLATE_PROJECT_NAME' 
export LOWER_APP_NAME=$(echo ${APP_NAME} |  tr 'A-Z' 'a-z')

if [ ! -f ~/.urhonet_config/urhonethome ]; then
	echo  "1 Urho.Net is not configured , please  run configure.sh (configure.bat on Windows) from  the Urho.Net installation folder  "
	exit -1
fi

URHONET_HOME_ROOT=$(cat ~/.urhonet_config/urhonethome)

if [ ! -d "$URHONET_HOME_ROOT" ]; then
	echo  "Urho.Net is not configured , please  run configure.sh (configure.bat on Windows) from the Urho.Net installation folder  "
	exit -1
else
    echo "URHONET_HOME_ROOT=${URHONET_HOME_ROOT}"
fi

while getopts d:r:t: option
do
case "${option}"
in
d) DEPLOY=${OPTARG};;
r) RENDERING_BACKEND=${OPTARG};;
t) DEVELOPMENT_TEAM=${OPTARG};;
esac
done

shopt -s expand_aliases
alias aliassedinplace='sed -i ""'

warn() {
    printf >&2 "$SCRIPTNAME: $*\n"
}

iscmd() {
    command -v >&- "$@"
}

checkdeps() {
    local -i not_found
    for cmd; do
        iscmd "$cmd" || { 
            warn $"$cmd is not found"
            let not_found++
        }
    done
    (( not_found == 0 )) || {
        warn $"Install dependencies listed above  $SCRIPTNAME"
        exit 1
    }
}



copy_file()
{
    if [ -f $2 ]; then
        if [[ $1/$2 -nt $2 ]]; then cp $1/$2 $3; fi
    else 
        cp $1/$2 $3
    fi
    
}

aot_compile_file()
{
    filename=$(basename -- "$1")
    if [ -f ${INTERMEDIATE_FOLDER}/${filename}.o ]; then
        if [ $1 -nt ${INTERMEDIATE_FOLDER}/${filename}.o ]; then
            ${MONO_IOS_AOT_CC}   --aot=asmonly,full,direct-icalls,direct-pinvoke,static,mtriple=arm64-ios,outfile=${INTERMEDIATE_FOLDER}/${filename}.s  -O=gsharedvt $1
            ${CLANG} -isysroot ${IOS_SDK_PATH} -Qunused-arguments -miphoneos-version-min=10.0  -arch arm64 -c -o ${INTERMEDIATE_FOLDER}/${filename}.o -x assembler ${INTERMEDIATE_FOLDER}/${filename}.s
        fi
    else
        ${MONO_IOS_AOT_CC}   --aot=asmonly,full,direct-icalls,direct-pinvoke,static,mtriple=arm64-ios,outfile=${INTERMEDIATE_FOLDER}/${filename}.s  -O=gsharedvt $1
        ${CLANG} -isysroot ${IOS_SDK_PATH} -Qunused-arguments -miphoneos-version-min=10.0  -arch arm64 -c -o ${INTERMEDIATE_FOLDER}/${filename}.o -x assembler ${INTERMEDIATE_FOLDER}/${filename}.s
    fi
}


check_ios_env_vars()
{
    if [ -f ${BUILD_DIR}/ios_env_vars.sh ]; then
        echo "ios_env_vars.sh exist"
         # setup the variables
        . ${BUILD_DIR}/ios_env_vars.sh
    else
        echo "Enter your development team."
        read -p "development team: " development_team
        if [[ "$development_team" == "" ]]; then
            echo
            echo "ERROR: No development team specified."
            echo
            exit -1;
        fi

        security find-identity -v -p codesigning

        echo "Enter your code sign identity. (press enter for default)"
        read -p "code sign identity: " code_sign_identity
        if [[ "$code_sign_identity" == "" ]]; then
            echo
            echo "No code sign identity specified , will choose default ."
            echo
        fi

        echo "Enter your provisioning profile. (press enter for default)"
        read -p "provisioning profile: " provisioning_profile
        if [[ "$provisioning_profile" == "" ]]; then
            echo
            echo "No provisioning profile specified , will choose default."
            echo
        fi

        mkdir -p ${BUILD_DIR}

        cp ./script/ios_env_vars.sh ${BUILD_DIR}
        aliassedinplace "s*T_DEVELOPMENT_TEAM*$development_team*g" "${BUILD_DIR}/ios_env_vars.sh"
        aliassedinplace "s*T_CODE_SIGN_IDENTITY*$code_sign_identity*g" "${BUILD_DIR}/ios_env_vars.sh"
        aliassedinplace "s*T_PROVISIONING_PROFILE_SPECIFIER*$provisioning_profile*g" "${BUILD_DIR}/ios_env_vars.sh"

        # setup the variables
        . ${BUILD_DIR}/ios_env_vars.sh

    fi
}


# check dependencies
checkdeps brew cmake xcodebuild ios-deploy codesign mcs plutil

if [[ "$RENDERING_BACKEND" == "gles" ]]; then
    mkdir -p ${URHO3D_HOME}/lib
    cp ${URHO3D_LIB_GLES_PATH}/libUrho3D.a ${URHO3D_HOME}/lib    
fi

if [[ "$RENDERING_BACKEND" == "metal" ]]; then
    mkdir -p ${URHO3D_HOME}/lib
    cp ${URHO3D_LIB_METAL_PATH}/libUrho3D.a ${URHO3D_HOME}/lib   
fi

if [[ "$DEVELOPMENT_TEAM" != "" && "$DEVELOPMENT_TEAM" != " " ]]; then
    echo "$DEVELOPMENT_TEAM not empty" 
    DEVELOPMENT_TEAM=$(echo "$DEVELOPMENT_TEAM" | tr -d ' ')
    mkdir -p ${BUILD_DIR}  
    cp ./script/ios_env_vars.sh ${BUILD_DIR}
    aliassedinplace "s*T_DEVELOPMENT_TEAM*$DEVELOPMENT_TEAM*g" "${BUILD_DIR}/ios_env_vars.sh"
    aliassedinplace "s*T_CODE_SIGN_IDENTITY*""*g" "${BUILD_DIR}/ios_env_vars.sh"
    aliassedinplace "s*T_PROVISIONING_PROFILE_SPECIFIER*""*g" "${BUILD_DIR}/ios_env_vars.sh"
     . ${BUILD_DIR}/ios_env_vars.sh
elif [[ "$DEVELOPMENT_TEAM" == " " ]]; then
        if [ -f ${BUILD_DIR}/ios_env_vars.sh ]; then
            echo "ios_env_vars.sh exist"
        else
            echo "ERROR : developer id was not provided , exit "
            exit -1
        fi
fi

#Configure Rendereing backend either GLES or Metal 
if [ -f ${URHO3D_HOME}/lib/libUrho3D.a ] ; then
        echo "ilibUrho3D found "
else
        echo "Enter rendering backend."
        echo "Enter 1 for GLES or 2 for Metal"
        read -p "rendering backend: " rendering_backend
        if [[ "$rendering_backend" == "" ]]; then
            echo
            echo "No rendering backend specified , configuring default GLES rendering backend."
            rendering_backend="1"
        fi

        if [[ "$rendering_backend" == "1" ]]; then
            echo "Configuring GLES rendering backend."
            mkdir -p ${URHO3D_HOME}/lib
            cp ${URHO3D_LIB_GLES_PATH}/libUrho3D.a ${URHO3D_HOME}/lib
        elif [[ "$rendering_backend" == "2" ]]; then
            echo "Configuring Metal rendering backend."
            mkdir -p ${URHO3D_HOME}/lib
            cp ${URHO3D_LIB_METAL_PATH}/libUrho3D.a ${URHO3D_HOME}/lib
        else
            echo "Invalid option  , configuring default GLES rendering backend."
            mkdir -p ${URHO3D_HOME}/lib
            cp ${URHO3D_LIB_GLES_PATH}/libUrho3D.a ${URHO3D_HOME}/lib
        fi
fi

# check/set  ios environment variables
check_ios_env_vars

mkdir -p ${ASSETS_FOLDER_DOTNET_IOS_PATH}

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
export BUILD_DIR=$(pwd) 
mkdir ${INTERMEDIATE_FOLDER}
export INTERMEDIATE_FOLDER=${BUILD_DIR}/${INTERMEDIATE_FOLDER}


cp ../script/ios.entitlements .
aliassedinplace "s*T_DEVELOPER_ID*$DEVELOPMENT_TEAM*g" "ios.entitlements"
aliassedinplace "s*T_UUID*$UUID*g" "ios.entitlements"

DLL_REFERENCES=''
if [ -n "$DOTNET_REFERENCE_DLL" ] ; then
    for i in "${DOTNET_REFERENCE_DLL[@]}"
    do
        echo "${URHO3D_DLL_PATH}/${i}"
        if [ -f ${URHO3D_DLL_PATH}/${i} ]; then
            DLL_REFERENCES="${DLL_REFERENCES} /reference:${i}"
        else 
            echo "${i} not found !!"
            exit -1
        fi
    done
fi

if [ -n "$DOTNET_BCL_REFERENCE" ] ; then
    for i in "${DOTNET_BCL_REFERENCE[@]}"
    do
        echo "adding BCL reference ${i}"
        DLL_REFERENCES="${DLL_REFERENCES} /reference:${i}"
    done
fi 

rm Game.dll
export CSPROJ=$(ls ../../*.csproj)
if [ -f ${CSPROJ} ] ; then
    dotnet build ${CSPROJ} --configuration Release -p:DefineConstants=_MOBILE_ --output:.
else
    echo "Didn't find csproj file , aborting."
    exit -1
fi
# csc  /target:exe /out:Game.dll -define:_MOBILE_ /unsafe -lib:${URHO3D_DLL_PATH},${LOCAL_MONO_PATH},${LOCAL_MONO_PATH}/Facades /reference:UrhoDotNet.dll /reference:netstandard.dll ${DLL_REFERENCES} /platform:x64 ${C_SHARP_SOURCE_CODE}
if [ -f ./Game.dll ] ; then
    mkdir -p ${ASSETS_FOLDER_DOTNET_PATH}
    cp Game.dll ${ASSETS_FOLDER_DOTNET_PATH}
else
    echo "Game.dll not found aborting"
    exit -1
fi

dotnet ../../tools/ReferenceAssemblyResolver/ReferenceAssemblyResolver.dll --assembly "${ASSETS_FOLDER_DOTNET_PATH}/Game.dll"  --output  ${ASSETS_FOLDER_DOTNET_IOS_PATH}  --search "${URHO3D_DLL_PATH},${LOCAL_MONO_PATH},${LOCAL_MONO_PATH}/Facades"


# AOT compile all relevent assemblies
export MONO_PATH=${ASSETS_FOLDER_DOTNET_IOS_PATH}
for i in ${ASSETS_FOLDER_DOTNET_IOS_PATH}/*.dll; do aot_compile_file  ${i} ${INTERMEDIATE_FOLDER}; done
aot_compile_file ${ASSETS_FOLDER_DOTNET_PATH}/Game.dll ${INTERMEDIATE_FOLDER}

${AR} cr lib-urho3d-mono-aot.a  ${INTERMEDIATE_FOLDER}/*.o
mv lib-urho3d-mono-aot.a ../../libs/ios


ios_aot_modules_header_prolog()
{
    echo "#ifndef IOS_AOT_MODULES_H" >> ${IOS_AOT_MODULES_HEADER}
    echo "#define IOS_AOT_MODULES_H" >> ${IOS_AOT_MODULES_HEADER}
    echo " " >> ${IOS_AOT_MODULES_HEADER}
    echo "extern \"C\" {" >> ${IOS_AOT_MODULES_HEADER}
}

ios_aot_modules_header_epilog()
{

    echo "} // extern "C"" >> ${IOS_AOT_MODULES_HEADER}
    echo " " >> ${IOS_AOT_MODULES_HEADER}
    echo "void ios_aot_register_modules();" >> ${IOS_AOT_MODULES_HEADER}
    echo " " >> ${IOS_AOT_MODULES_HEADER}
    echo "#endif" >> ${IOS_AOT_MODULES_HEADER}
}

iot_aot_modules_header_populate()
{
    filename=$(basename -- "$1" .dll)
    filename=$(echo "$filename" | tr '.' '_')
    echo "  extern void * mono_aot_module_"$filename"_info;">> ${IOS_AOT_MODULES_HEADER}
}


# create and fill aot modules header
rm ${IOS_AOT_MODULES_HEADER}
touch ${IOS_AOT_MODULES_HEADER}
ios_aot_modules_header_prolog
for i in ${ASSETS_FOLDER_DOTNET_IOS_PATH}/*.dll; do iot_aot_modules_header_populate  ${i}; done
iot_aot_modules_header_populate ${ASSETS_FOLDER_DOTNET_PATH}/Game.dll
ios_aot_modules_header_epilog



ios_aot_modules_mm_prolog()
{
    echo "#include <mono/jit/jit.h>" >> ${IOS_AOT_MODULES_MM}
    echo "#include \"ios_aot_modules.h\"" >> ${IOS_AOT_MODULES_MM}
    echo "void ios_aot_register_modules()" >> ${IOS_AOT_MODULES_MM}
    echo "{" >> ${IOS_AOT_MODULES_MM}
}

ios_aot_modules_mm_epilog()
{
    echo "}" >> ${IOS_AOT_MODULES_MM}
}

iot_aot_modules_mm_populate()
{
    filename=$(basename -- "$1" .dll)
    filename=$(echo "$filename" | tr '.' '_')
    echo "  mono_aot_register_module((void **)mono_aot_module_"$filename"_info);">> ${IOS_AOT_MODULES_MM}
}

# create and fill aot modules mm file
rm ${IOS_AOT_MODULES_MM}
touch ${IOS_AOT_MODULES_MM}
ios_aot_modules_mm_prolog
for i in ${ASSETS_FOLDER_DOTNET_IOS_PATH}/*.dll; do iot_aot_modules_mm_populate  ${i}; done
iot_aot_modules_mm_populate ${ASSETS_FOLDER_DOTNET_PATH}/Game.dll
ios_aot_modules_mm_epilog

rm ${REGISTER_PLUGINS}
touch ${REGISTER_PLUGINS}
echo "#include \"../Core/Context.h\"" >> ${REGISTER_PLUGINS}
echo " " >> ${REGISTER_PLUGINS}
echo "using namespace Urho3D;" >> ${REGISTER_PLUGINS}
echo " " >> ${REGISTER_PLUGINS}
for i in "${PLUGINS[@]}"
    do
        echo "void Register"${i}"(Context * context);">> ${REGISTER_PLUGINS}
    done
echo " " >> ${REGISTER_PLUGINS}
echo "void RegisterPlugins(Context * context)" >> ${REGISTER_PLUGINS}
echo "{" >> ${REGISTER_PLUGINS}
for i in "${PLUGINS[@]}"
    do
        echo "  Register"${i}"(context);">> ${REGISTER_PLUGINS}
    done
echo "}" >> ${REGISTER_PLUGINS}

# Update Info.plist if needed
plutil -remove GADIsAdManagerApp  ${URHO3D_HOME}/CMake/Modules/iOSBundleInfo.plist.template
plutil -remove GADApplicationIdentifier  ${URHO3D_HOME}/CMake/Modules/iOSBundleInfo.plist.template
if [[ "$GAD_APPLICATION_ID" != "" ]]; then
plutil -replace GADIsAdManagerApp  -bool 'true' ${URHO3D_HOME}/CMake/Modules/iOSBundleInfo.plist.template
plutil -replace GADApplicationIdentifier  -string $GAD_APPLICATION_ID ${URHO3D_HOME}/CMake/Modules/iOSBundleInfo.plist.template
fi

# first run camke
${URHO3D_HOME}/script/cmake_ios_dotnet.sh ${BUILD_DIR} -DDEVELOPMENT_TEAM=${DEVELOPMENT_TEAM} -DCODE_SIGN_IDENTITY=${CODE_SIGN_IDENTITY} -DPROVISIONING_PROFILE_SPECIFIER=${PROVISIONING_PROFILE_SPECIFIER}

xcodebuild -project ${BUILD_DIR}/${APP_NAME}.xcodeproj


if [[ "$DEPLOY" == "launch" ]]; then
    ios-deploy --justlaunch --debug --bundle  ${BUILD_DIR}/bin/${APP_NAME}.app
fi

if [[ "$DEPLOY" == "debug" ]]; then
    ios-deploy --debug --bundle  ${BUILD_DIR}/bin/${APP_NAME}.app
fi