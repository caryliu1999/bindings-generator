@echo off

:: This script is used to generate jsbinding glue codes.
:: You should modify PYTHON_ROOT and NDK_ROOT to work under your environment.
:: Android ndk version must be at least ndk-r9b.

set PYTHON_ROOT=C:/Python27
set NDK_ROOT=G:/android/android-ndk-r9b
set CLANG_ROOT=%NDK_ROOT%/toolchains/llvm-3.3/prebuilt/windows-x86_64

set CXX_GENERATOR_ROOT=%cd%/..
set "CXX_GENERATOR_ROOT=%CXX_GENERATOR_ROOT:\=/%"
set OUTPUT_DIR=%CXX_GENERATOR_ROOT%/test/simple_test_bindings
set "OUTPUT_DIR=%OUTPUT_DIR:/=\%"

:: set the tools path into PATH
set PATH=%PATH%;%CXX_GENERATOR_ROOT%/libclang;%CXX_GENERATOR_ROOT%/tools/win32;%PYTHON_ROOT%

:: write userconf.ini
set _CONF_INI_FILE=%cd%\userconf.ini
if exist %_CONF_INI_FILE% del /Q %_CONF_INI_FILE%


echo
echo generating userconf.ini...
echo ---
echo [DEFAULT] > %_CONF_INI_FILE%
echo androidndkdir=%NDK_ROOT% >> %_CONF_INI_FILE%
echo clangllvmdir=%CLANG_ROOT% >> %_CONF_INI_FILE%
echo cxxgeneratordir=%CXX_GENERATOR_ROOT% >> %_CONF_INI_FILE%
:: fixme: to fix parse error, we must difine __WCHAR_MAX__ here.
echo extra_flags=-D__WCHAR_MAX__=0x7fffffff >> %_CONF_INI_FILE%
echo ---



:: Generate bindings for cocos2dx
echo "Generating bindings for simpletest with Android headers..."
python %CXX_GENERATOR_ROOT%/generator.py %CXX_GENERATOR_ROOT%/test/test.ini -t spidermonkey -s testandroid -o %OUTPUT_DIR%
if %errorlevel% neq 0 goto ERROR

:: Change the generated file format from DOS to UNIX.
pushd "%OUTPUT_DIR%"
dos2unix *
popd

echo ---------------------------------
echo Generating bindings succeeds.
echo ---------------------------------

goto QUIT

:ERROR
echo ---------------------------------
echo Generating bindings fails.
echo ---------------------------------

:QUIT

pause

