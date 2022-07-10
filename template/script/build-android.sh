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

. script/project_vars.sh

ANDROID_APP_UUID=${PROJECT_UUID}

while getopts b:d:g:k:i:o:n: option
do
case "${option}"
in
b) BUILD=${OPTARG};;
d) DEPLOY=${OPTARG};;
g) GENERATE_KEY=${OPTARG};;
k) KEY_STORE=${OPTARG};;
i) APK_INPUT_PATH=${OPTARG};;
o) APK_OUTPUT_PATH=${OPTARG};;
n) APK_NAME=${OPTARG};;
esac
done

CWD=$(pwd)
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


verify_dir_exist_or_exit()
{
    if [ ! -d $1 ] ; then
        echo "$1 not found , are you sure that URHONET_HOME_ROOT=${URHONET_HOME_ROOT} is pointing to the right place ? "
        exit 1
    fi
}

if [ ! -f ~/.urhonet_config/urhonethome ]; then
	echo  "1 Urho.Net is not configured , please  run configure.sh (configure.bat on Windows) from  the Urho.Net installation folder  "
	exit -1
fi

URHONET_HOME_ROOT=$(cat ~/.urhonet_config/urhonethome)

if [ ! -d "$URHONET_HOME_ROOT" ]; then
	echo  "Urho.Net is not configured , please  run configure.sh (configure.bat on Windows) from the Urho.Net installation folder  "
	exit -1
else
	echo  "URHONET_HOME_ROOT=$URHONET_HOME_ROOT"

    
    if [ ! -d libs/dotnet/urho/mobile/android ] ; then
        verify_dir_exist_or_exit "${URHONET_HOME_ROOT}/template/libs/dotnet/urho/mobile/android" 
        mkdir -p libs/dotnet/urho/mobile/android
        cp "-r"  ${URHONET_HOME_ROOT}/template/libs/dotnet/urho//mobile/android/*  libs/dotnet/urho//mobile/android/
    fi

    nfiles=$(ls "Android"* | wc -l)
    if [ $nfiles = 1 ]; then
        if [ -f "Android/app/src/main/assets/Data/DotNet/Game.dll" ]; then
            echo "only Game.dll in Android folder , deleting Android folder"
            rm -Rf "Android"
        fi
    fi
    
    if [ ! -d Android ] ; then
        verify_dir_exist_or_exit "${URHONET_HOME_ROOT}/template/Android" 

        cp "-r" "${URHONET_HOME_ROOT}/template/Android" .
        mkdir "-p" "Android/app/src/main/${JAVA_PACKAGE_PATH}"
        mkdir "-p" "Android/app/src/androidTest/${JAVA_PACKAGE_PATH}"
        mkdir "-p" "Android/app/src/test/${JAVA_PACKAGE_PATH}"

        mv "Android/app/src/main/MainActivity.kt" "Android/app/src/main/${JAVA_PACKAGE_PATH}"
        mv "Android/app/src/main/UrhoMainActivity.kt" "Android/app/src/main/${JAVA_PACKAGE_PATH}"
        mv "Android/app/src/androidTest/ExampleInstrumentedTest.kt" "Android/app/src/androidTest/${JAVA_PACKAGE_PATH}"
        mv "Android/app/src/test/ExampleUnitTest.kt" "Android/app/src/test/${JAVA_PACKAGE_PATH}"

        aliassedinplace "s*TEMPLATE_UUID*$PROJECT_UUID*g" "Android/app/src/main/AndroidManifest.xml"
        aliassedinplace "s*TEMPLATE_UUID*$PROJECT_UUID*g" "Android/app/build.gradle"
        aliassedinplace "s*TEMPLATE_UUID*$PROJECT_UUID*g" "Android/app/src/main/${JAVA_PACKAGE_PATH}/MainActivity.kt"
        aliassedinplace "s*TEMPLATE_UUID*$PROJECT_UUID*g" "Android/app/src/main/${JAVA_PACKAGE_PATH}/UrhoMainActivity.kt"

        aliassedinplace "s*TEMPLATE_UUID*$PROJECT_UUID*g" "Android/app/src/androidTest/${JAVA_PACKAGE_PATH}/ExampleInstrumentedTest.kt"
        aliassedinplace "s*TEMPLATE_UUID*$PROJECT_UUID*g" "Android/app/src/test/${JAVA_PACKAGE_PATH}/ExampleUnitTest.kt"

        aliassedinplace "s*TEMPLATE_PROJECT_NAME*$PROJECT_NAME*g" "Android/settings.gradle"
        aliassedinplace "s*TEMPLATE_PROJECT_NAME*$PROJECT_NAME*g" "Android/app/src/main/res/values/strings.xml"
        
        if [ -n "$ANDROID_DEPENDENCIES" ] ; then
            echo " " >> "Android/app/build.gradle"
            echo " " >> "Android/app/build.gradle"
            echo "dependencies {" >> "Android/app/build.gradle"
            for i in "${ANDROID_DEPENDENCIES[@]}"
            do
                echo "implementation ('${i}')" >> "Android/app/build.gradle"
            done
            echo "}" >> "Android/app/build.gradle"
        fi

        if [ -n "$ANDROID_NDK_VERSION" ] ; then
            echo " " >> "Android/app/build.gradle"
            echo " " >> "Android/app/build.gradle"
            echo "android  {" >> "Android/app/build.gradle"
            echo "ndkVersion  \"$ANDROID_NDK_VERSION\"" >> "Android/app/build.gradle"
            echo "}" >> "Android/app/build.gradle"
        fi 
        
        if [ -n "$DOTNET_REFERENCE_DLL" ] ; then
            for i in "${DOTNET_REFERENCE_DLL[@]}"
            do
                if [ -f ./References/${i} ]; then
                    cp -f ./References/${i} ./libs/dotnet/urho/mobile/android
                else 
                    echo "${i} not found !!"
                fi
            done
        fi               
    fi

    rm -rf Android/app/src/main/jniLibs
    mkdir -p Android/app/src/main/jniLibs

    if [ -n "$PLUGINS" ] ; then
        rm "${CWD}/Assets/Data/plugins.cfg"
        touch "${CWD}/Assets/Data/plugins.cfg"
        mkdir "-p" "Android/app/src/main/java/com/urho3d/plugin"
        for i in "${PLUGINS[@]}"
        do
            verify_dir_exist_or_exit "${URHONET_HOME_ROOT}/template/Plugins/${i}/android"
            cp -R ${URHONET_HOME_ROOT}/template/Plugins/${i}/android/java/ "Android/app/src/main/java/com/urho3d/plugin/${i}"
            cp -R ${URHONET_HOME_ROOT}/template/Plugins/${i}/android/lib/* "Android/app/src/main/jniLibs"
            aliassedinplace "s*TEMPLATE_UUID*$PROJECT_UUID*g" "Android/app/src/main/java/com/urho3d/plugin/${i}/${i}.java"
            echo ${i} >> "${CWD}/Assets/Data/plugins.cfg"
        done
    fi

    verify_dir_exist_or_exit "${URHONET_HOME_ROOT}/template/libs/dotnet/bcl/android" 
    mkdir -p libs/dotnet/bcl/android
    if [ -n "$ANDROID_ARCHITECTURE" ] ; then
        for i in "${ANDROID_ARCHITECTURE[@]}"
            do
                if [ ! -d libs/dotnet/bcl/android/${i} ] ; then
                    mkdir -p libs/dotnet/bcl/android/${i}
                    cp "-r"  ${URHONET_HOME_ROOT}/template/libs/dotnet/bcl/android/${i}/*  libs/dotnet/bcl/android/${i}/
                fi
                    mkdir -p Android/app/src/main/jniLibs/${i}
                    cp -R ${URHONET_HOME_ROOT}/template/libs/android/${i}/* Android/app/src/main/jniLibs/${i}/
            done
        ANDROID_ALL_ARCHITECTURES=('arm64-v8a' 'armeabi-v7a' 'x86' 'x86_64')
        Arraydiff=(`echo ${ANDROID_ALL_ARCHITECTURES[@]} ${ANDROID_ARCHITECTURE[@]} | tr ' ' '\n' | sort | uniq -u `)
        for j in "${Arraydiff[@]}"
            do
                rm -rf libs/dotnet/bcl/android/${j}/
                rm -rf Android/app/src/main/assets/Data/DotNet/android/${j}/
                rm -rf Android/app/src/main/jniLibs/${j}/
            done
    else
        ANDROID_REMOVE_ARCHITECTURES=('arm64-v8a' 'x86' 'x86_64')
        for j in "${ANDROID_REMOVE_ARCHITECTURES[@]}"
            do
                rm -rf libs/dotnet/bcl/android/${j}/
                rm -rf Android/app/src/main/assets/Data/DotNet/android/${j}/
                rm -rf Android/app/src/main/jniLibs/${j}/
            done
        if [ ! -d libs/dotnet/bcl/android/armeabi-v7a ] ; then
            mkdir -p libs/dotnet/bcl/android/armeabi-v7a
            cp "-r"  ${URHONET_HOME_ROOT}/template/libs/dotnet/bcl/android/armeabi-v7a/*  libs/dotnet/bcl/android/armeabi-v7a/
        fi
        if [ ! -d Android/app/src/main/jniLibs/armeabi-v7a ] ; then
                mkdir -p Android/app/src/main/jniLibs/armeabi-v7a
                cp -R ${URHONET_HOME_ROOT}/template/libs/android/armeabi-v7a/* Android/app/src/main/jniLibs/armeabi-v7a/
        fi
    fi

    #Create AndroidManifest.xml based upon the project configuration variables in project_vars.sh
    ./script/create-android-manifest.sh
fi

if [[ "$BUILD" == "debug" ]]; then
    cd Android
    ./gradlew dotnetDebug -PskipDotnetRelease=true
    cd ..
    if [ -n "$ANDROID_ARCHITECTURE" ] ; then
        ANDROID_ALL_ARCHITECTURES=('arm64-v8a' 'armeabi-v7a' 'x86' 'x86_64')
        Arraydiff=(`echo ${ANDROID_ALL_ARCHITECTURES[@]} ${ANDROID_ARCHITECTURE[@]} | tr ' ' '\n' | sort | uniq -u `)
        for j in "${Arraydiff[@]}"
            do
                rm -rf Android/app/src/main/assets/Data/DotNet/android/${j}/
            done
    fi
    mkdir -p output/Android
    cp Android/app/build/outputs/apk/debug/app-debug.apk output/Android
    if [[ "$DEPLOY" == "1" ]]; then
        adb shell am force-stop ${ANDROID_APP_UUID}
        adb uninstall ${ANDROID_APP_UUID}
        adb install -r output/Android/app-debug.apk
        adb shell am start -n ${ANDROID_APP_UUID}/.MainActivity
    fi
elif [[ "$BUILD" == "release" ]]; then
    cd Android
    ./gradlew dotnetRelease -PskipDotnetDebug=true
    cd ..
    if [ -n "$ANDROID_ARCHITECTURE" ] ; then
        ANDROID_ALL_ARCHITECTURES=('arm64-v8a' 'armeabi-v7a' 'x86' 'x86_64')
        Arraydiff=(`echo ${ANDROID_ALL_ARCHITECTURES[@]} ${ANDROID_ARCHITECTURE[@]} | tr ' ' '\n' | sort | uniq -u `)
        for j in "${Arraydiff[@]}"
            do
                rm -rf Android/app/src/main/assets/Data/DotNet/android/${j}/
            done
    fi
    mkdir -p output/Android
    cp Android/app/build/outputs/apk/release/app-release-unsigned.apk output/Android
    KEY_STORE=$(echo "$KEY_STORE" | tr -d ' ')
    ./script/apk-sign.sh "-k "${KEY_STORE}"" "-i output/Android"  "-o output/Android"
    if [[ "$DEPLOY" == "1" ]]; then
        adb shell am force-stop ${ANDROID_APP_UUID}
        adb uninstall ${ANDROID_APP_UUID}
        adb install -r output/Android/app-release-signed.apk
        adb shell am start -n ${ANDROID_APP_UUID}/.MainActivity
    fi
fi

cd ${CWD}

#read -p "getk: " getk


