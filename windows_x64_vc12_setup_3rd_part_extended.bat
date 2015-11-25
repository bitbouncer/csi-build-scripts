set VISUALSTUDIO_VERSION=12.0
set VISUALSTUDIO_VERSION_MAJOR=12


set PROTOBUF_VERSION=3.0.0-beta-1
set LIBXML2_VER=2.9.3
SET KERBEROS5_VER=1.14
SET LIBICONV_VER=1.14

call "C:\Program Files (x86)\Microsoft Visual Studio %VISUALSTUDIO_VERSION%\VC\vcvarsall.bat" amd64

wget --no-check-certificate https://github.com/google/protobuf/releases/download/v%PROTOBUF_VERSION%/protobuf-cpp-%PROTOBUF_VERSION%.tar.gz -Oprotobuf-cpp-%PROTOBUF_VERSION%.tar.gz 
gunzip protobuf-cpp-%PROTOBUF_VERSION%.tar.gz 
tar xf protobuf-cpp-%PROTOBUF_VERSION%.tar 
del protobuf-cpp-%PROTOBUF_VERSION%.tar


cd protobuf-%PROTOBUF_VERSION%
mkdir install
mkdir include
mkdir lib
mkdir lib\x64
mkdir lib\x64\Release
mkdir lib\x64\Debug

cd cmake

mkdir winbuild & cd winbuild
mkdir release & cd release
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../../../install ../..
nmake
nmake install
copy ..\..\..\install\lib\*.lib ..\..\..\lib\x64\Release
cd ..



mkdir debug & cd debug
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=../../../install ../..
nmake
nmake install
copy ..\..\..\install\lib\*.lib ..\..\..\lib\x64\Debug
cd ..\..\..

xcopy /e/s install\include include 
cd ..


#http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz
wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-%LIBICONV_VER%.tar.gz -Olibiconv-%LIBICONV_VER%.tar.gz 
gunzip libiconv-%LIBICONV_VER%.tar.gz
tar xf libiconv-%LIBICONV_VER%.tar
del libiconv-%LIBICONV_VER%.tar


wget ftp://xmlsoft.org/libxml2/libxml2-%LIBXML2_VER%.tar.gz
gunzip libxml2-%LIBXML2_VER%.tar.gz
tar xf libxml2-%LIBXML2_VER%.tar
del libxml2-%LIBXML2_VER%.tar

cd libxml2-%LIBXML2_VER%
cd win32
cscript configure.js compiler=msvc prefix=..\out include=..\..\libiconv-%LIBICONV_VER%\include libdir=..\lib\x64\Debug static=yes debug=yes cruntime=/MDd


cscript configure.js compiler=msvc prefix=..\out include=..\..\libiconv-%LIBICONV_VER%\include libdir=..\lib\x64\Release static=yes debug=no cruntime=/MD


# http://web.mit.edu/kerberos/

wget http://web.mit.edu/kerberos/dist/krb5/%KERBEROS5_VER%/krb5-%KERBEROS5_VER%.tar.gz -Okrb5-%KERBEROS5_VER%.tar.gz
gunzip krb5-%KERBEROS5_VER%.tar.gz
tar xf krb5-%KERBEROS5_VER%.tar
del krb5-%KERBEROS5_VER%.tar




http://sourceforge.net/projects/libuuid/
http://www.gnu.org/software/gsasl/




