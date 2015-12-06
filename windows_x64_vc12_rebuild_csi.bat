REM need separate installation of git, nasm, active perl & visual studio
REM make sure that active perl is before any other perl - git's for example in PATH

set VISUALSTUDIO_VERSION=12.0
set VISUALSTUDIO_VERSION_MAJOR=12
set BOOST_VERSION=1_59_0
set BOOST_VERSION_DOTTED=1.59.0
set OPEN_SSL_VERSION=openssl-1.0.1j

REM set C_ARES_VERSION=1.10.0
REM set CARES_DIR=c-ares-%C_ARES_VERSION%
set CARES_DIR=c-ares-master

set CURL_VERSION=7.42.1
set ZLIB_VERSION=1.2.8

REM set AVRO_VERSION=1.7.7
REM set AVRO_DIR=avro-cpp-%AVRO_VERSION%
set AVRO_DIR=avro\lang\c++ 

set LIBEVENT_VERSION=2.0.21
set PTHREAD_VERSION=2-9-1
set JOYENT_HTTP_VERSION=2.3

call "C:\Program Files (x86)\Microsoft Visual Studio %VISUALSTUDIO_VERSION%\VC\vcvarsall.bat" amd64

cd json-spirit
git pull
rmdir /S /Q bin\x64
rmdir /S /Q lib\x64
rmdir /S /Q win_build64
mkdir win_build64 
cd win_build64
cmake -G "Visual Studio 12 Win64" ..
msbuild ALL_BUILD.vcxproj /p:Configuration=Debug /p:Platform=x64
msbuild ALL_BUILD.vcxproj /p:Configuration=Release /p:Platform=x64
cd ..
cd ..

cd csi-http
git pull
rmdir /S /Q bin\x64
rmdir /S /Q lib\x64
rmdir /S /Q win_build64
mkdir win_build64 
cd win_build64
cmake -D__CSI_HAS_OPENSSL__=1  -G "Visual Studio 12 Win64" ..
msbuild ALL_BUILD.vcxproj /p:Configuration=Debug /p:Platform=x64
msbuild ALL_BUILD.vcxproj /p:Configuration=Release /p:Platform=x64
cd ..
cd ..

cd csi-avro-utils
git pull
rmdir /S /Q bin\x64
rmdir /S /Q lib\x64
rmdir /S /Q win_build64
mkdir win_build64 
cd win_build64
cmake -D__CSI_HAS_OPENSSL__=1  -G "Visual Studio 12 Win64" ..
msbuild ALL_BUILD.vcxproj /p:Configuration=Debug /p:Platform=x64
msbuild ALL_BUILD.vcxproj /p:Configuration=Release /p:Platform=x64
cd ..
cd ..

cd postgres-asio
git pull
rmdir /S /Q bin\x64
rmdir /S /Q lib\x64
rmdir /S /Q win_build64
mkdir win_build64 
cd win_build64
cmake -D__CSI_HAS_OPENSSL__=1  -G "Visual Studio 12 Win64" ..
msbuild ALL_BUILD.vcxproj /p:Configuration=Debug /p:Platform=x64
msbuild ALL_BUILD.vcxproj /p:Configuration=Release /p:Platform=x64
cd ..
cd ..


cd csi-kafka
git pull
rmdir /S /Q bin\x64
rmdir /S /Q lib\x64
rmdir /S /Q win_build64
mkdir win_build64 
cd win_build64
cmake  -G "Visual Studio 12 Win64" ..
msbuild ALL_BUILD.vcxproj /p:Configuration=Debug /p:Platform=x64
msbuild ALL_BUILD.vcxproj /p:Configuration=Release /p:Platform=x64
cd ..
cd ..

cd csi-samples
git pull
rmdir /S /Q bin\x64
rmdir /S /Q lib\x64
rmdir /S /Q win_build64
mkdir win_build64 
cd win_build64
cmake  -G "Visual Studio 12 Win64" ..
msbuild ALL_BUILD.vcxproj /p:Configuration=Debug /p:Platform=x64
msbuild ALL_BUILD.vcxproj /p:Configuration=Release /p:Platform=x64
cd ..
cd ..

cd kafka2influx
git pull
rmdir /S /Q bin\x64
rmdir /S /Q lib\x64
rmdir /S /Q win_build64
mkdir win_build64 
cd win_build64
cmake  -G "Visual Studio 12 Win64" ..
msbuild ALL_BUILD.vcxproj /p:Configuration=Debug /p:Platform=x64
msbuild ALL_BUILD.vcxproj /p:Configuration=Release /p:Platform=x64
cd ..
cd ..

cd phoebe
git pull
rmdir /S /Q bin\x64
rmdir /S /Q lib\x64
rmdir /S /Q win_build64
mkdir win_build64 
cd win_build64
cmake  -G "Visual Studio 12 Win64" ..
msbuild ALL_BUILD.vcxproj /p:Configuration=Debug /p:Platform=x64
msbuild ALL_BUILD.vcxproj /p:Configuration=Release /p:Platform=x64
cd ..
cd ..
