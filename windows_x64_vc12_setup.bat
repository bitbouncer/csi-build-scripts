REM need separate installation of git, nasm, active perl & visual studio
REM make sure that active perl is before any other perl - git's for example in PATH

set VISUALSTUDIO_VERSION=12.0
set VISUALSTUDIO_VERSION_MAJOR=12
set BOOST_VERSION=1_57_0
set BOOST_VERSION_DOTTED=1.57.0
set OPEN_SSL_VERSION=openssl-1.0.1j
set CURL_VERSION=7.39.0
set ZLIB_VERSION=1.2.8
set AVRO_VERSION=1.7.7
set LIBEVENT_VERSION=2.0.21
set PTHREAD_VERSION=2-9-1
set JOYENT_HTTP_VERSION=2.3

call "C:\Program Files (x86)\Microsoft Visual Studio %VISUALSTUDIO_VERSION%\VC\vcvarsall.bat" amd64

wget ftp://ftp.sunet.se/pub/www/servers/apache/dist/avro/avro-%AVRO_VERSION%/cpp/avro-cpp-%AVRO_VERSION%.tar.gz
tar xvf avro-cpp-%AVRO_VERSION%.tar.gz
del avro-cpp-%AVRO_VERSION%.tar.gz

wget http://zlib.net/zlib-%ZLIB_VERSION%.tar.gz
tar xvf zlib-%ZLIB_VERSION%.tar.gz
del zlib-%ZLIB_VERSION%.tar.gz

wget http://sourceforge.net/projects/boost/files/boost/%BOOST_VERSION_DOTTED%/boost_%BOOST_VERSION%.tar.gz/download -Oboost_%BOOST_VERSION%.tar.gz
tar xf boost_%BOOST_VERSION%.tar.gz
del boost_%BOOST_VERSION%.tar.gz

#until boost 1.57 when this was supposed to be included
git clone https://github.com/boostorg/endian.git
#back two thing out of trunk to compile under boost < 1.57
sed -i "s:<boost/predef/detail/endian_compat.h>:<boost/detail/endian.hpp>:" endian/include/boost/endian/types.hpp
sed -i "s:<boost/predef/detail/endian_compat.h>:<boost/detail/endian.hpp>:" endian/include/boost/endian/conversion.hpp


git clone https://github.com/bitbouncer/csi-build-scripts.git
git clone https://github.com/bitbouncer/csi-http.git
git clone https://github.com/bitbouncer/json-spirit
wget --no-check-certificate https://github.com/joyent/http-parser/archive/v%JOYENT_HTTP_VERSION%.tar.gz -Ohttp_parser-v%JOYENT_HTTP_VERSION%.tar.gz
tar -xvf http_parser-v%JOYENT_HTTP_VERSION%.tar.gz
del http_parser-v%JOYENT_HTTP_VERSION%.tar.gz


wget  http://www.openssl.org/source/%OPEN_SSL_VERSION%.tar.gz 
tar xvf %OPEN_SSL_VERSION%.tar.gz
del %OPEN_SSL_VERSION%.tar.gz

wget http://curl.haxx.se/download/curl-%CURL_VERSION%.tar.gz
tar xvf curl-%CURL_VERSION%.tar.gz
del curl-%CURL_VERSION%.tar.gz


wget --no-check-certificate https://github.com/libevent/libevent/archive/release-%LIBEVENT_VERSION%-stable.tar.gz -Olibevent-%LIBEVENT_VERSION%-stable.tar.gz
tar xvf libevent-%LIBEVENT_VERSION%-stable.tar.gz
del libevent-%LIBEVENT_VERSION%-stable.tar.gz

wget ftp://sourceware.org/pub/pthreads-win32/pthreads-w32-%PTHREAD_VERSION%-release.tar.gz
tar xvf pthreads-w32-%PTHREAD_VERSION%-release.tar.gz
del pthreads-w32-%PTHREAD_VERSION%-release.tar.gz


@ECHO BUILDING OPEN_SSL
cd %OPEN_SSL_VERSION%
start /WAIT perl Configure VC-WIN64A --prefix=/OpenSSL-Win64
call ms\do_win64a
nmake -f ms\nt.mak
cd ..


@ECHO BUILDING LIBCURL
cd curl-%CURL_VERSION%

rmdir /s /q builds
rmdir /s /q libs

mkdir libs
mkdir libs\x64
mkdir libs\x64\Debug
mkdir libs\x64\Release
mkdir libs\win32
mkdir libs\win32\Debug
mkdir libs\win32\Release

cd winbuild
SET INCLUDE=%INCLUDE%;..\..\%OPEN_SSL_VERSION%\include;..\include;..\..\%OPEN_SSL_VERSION%\include\openssl
nmake /f makefile.vc mode=static VC=12 WITH_SSL=no ENABLE_SSPI=no ENABLE_WINSSL=no ENABLE_IDN=no DEBUG=yes MACHINE=x64
nmake /f makefile.vc mode=static VC=12 WITH_SSL=no ENABLE_SSPI=no ENABLE_WINSSL=no ENABLE_IDN=no DEBUG=no MACHINE=x64
cd ..

copy builds\libcurl-vc%VISUALSTUDIO_VERSION_MAJOR%-x64-debug-static-ipv6\lib\libcurl_a_debug.lib libs\x64\Debug\libcurl.lib 
copy builds\libcurl-vc%VISUALSTUDIO_VERSION_MAJOR%-x64-release-static-ipv6\lib\libcurl_a.lib libs\x64\Release\libcurl.lib 
cd ..
@ECHO DONE WITH CURL


@ECHO BUILDING ZLIB
cd zlib-%ZLIB_VERSION%
nmake -f win32/Makefile.msc
cd ..


@ECHO BUILDING LIBEVENT
cd libevent-%LIBEVENT_VERSION%-stable
#./configure --disable-shared
#./configure
#make
#cd ..

@ECHO BUILDING PTHREADS
cd pthreads-w32-%PTHREAD_VERSION%-release
#nmake clean VC-static-debug
#nmake clean VC-static
#test
nmake clean VC
nmake clean VC-debug
cd ..

@ECHO BUILDING BOOST
cd boost_%BOOST_VERSION%
rmdir /s /q bin.v2
call "C:\Program Files (x86)\Microsoft Visual Studio %VISUALSTUDIO_VERSION%\VC\vcvarsall.bat" amd64
call bootstrap.bat
b2 -j 4 -toolset=msvc-%VISUALSTUDIO_VERSION% address-model=64 --build-type=complete --stagedir=lib\x64 stage -s ZLIB_SOURCE=%CD%\..\zlib-%ZLIB_VERSION%
rmdir /s /q bin.v2

call "C:\Program Files (x86)\Microsoft Visual Studio %VISUALSTUDIO_VERSION%\VC\vcvarsall.bat" x86
call bootstrap.bat
b2 -j 4 -toolset=msvc-%VISUALSTUDIO_VERSION% address-model=32 --build-type=complete --stagedir=lib\win32 stage -s ZLIB_SOURCE=%CD%\..\zlib-%ZLIB_VERSION%
rmdir /s /q bin.v2
call "C:\Program Files (x86)\Microsoft Visual Studio %VISUALSTUDIO_VERSION%\VC\vcvarsall.bat" amd64
cd ..


@ECHO BUILDING AVRO
cd avro-cpp-%AVRO_VERSION%
SET BOOST_LIBRARYDIR=%CD%/../boost_%BOOST_VERSION%/lib/x64/lib
SET BOOST_ROOT=%CD%/../boost_%BOOST_VERSION%
SET Boost_INCLUDE_DIR=%CD%/../boost_%BOOST_VERSION%/boost
rmdir /s /q avro
rmdir /s /q build64
mkdir build64
cd build64
cmake -G "Visual Studio 12 Win64" ..
msbuild ALL_BUILD.vcxproj /p:Configuration=Debug /p:Platform=x64
msbuild ALL_BUILD.vcxproj /p:Configuration=Release /p:Platform=x64
cd ..
mkdir avro
cp -r api/*.* avro
cd ..

cd json-spirit
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




