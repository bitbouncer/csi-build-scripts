export BOOST_VERSION=1_57_0
export BOOST_VERSION_DOTTED=1.57.0
export AVRO_VERSION=1.7.7
export CURL_VERSION=7.39.0
export ZLIB_VERSION=1.2.8
export BZLIB2_VERSION=1.0.6
export OPEN_SSL_VERSION=1.0.1j
export JOYENT_HTTP_VERSION=2.3

#svn checkout http://v8.googlecode.com/svn/trunk/ v8
#cd v8
#svn co https://src.chromium.org/chrome/trunk/deps/third_party/icu46 third_party/icu
#svn co http://gyp.googlecode.com/svn/trunk build/gyp
#cd ..

git clone https://github.com/bitbouncer/csi-http
git clone https://github.com/bitbouncer/json-spirit

#until boost 1.57 when this was supposed to be included
git clone https://github.com/boostorg/endian.git
#back two thing out of trunk to compile under boost < 1.57
sed -i "s:<boost/predef/detail/endian_compat.h>:<boost/detail/endian.hpp>:" endian/include/boost/endian/types.hpp
sed -i "s:<boost/predef/detail/endian_compat.h>:<boost/detail/endian.hpp>:" endian/include/boost/endian/conversion.hpp


wget http://curl.haxx.se/download/curl-$CURL_VERSION.tar.bz2 -Ocurl-$CURL_VERSION.tar.bz2
tar xvf curl-$CURL_VERSION.tar.bz2
rm  curl-$CURL_VERSION.tar.bz2

wget http://sourceforge.net/projects/boost/files/boost/$BOOST_VERSION_DOTTED/boost_$BOOST_VERSION.tar.gz/download -Oboost_$BOOST_VERSION.tar.gz
tar xf boost_$BOOST_VERSION.tar.gz
rm boost_$BOOST_VERSION.tar.gz

wget http://zlib.net/zlib-$ZLIB_VERSION.tar.gz
tar xvf zlib-$ZLIB_VERSION.tar.gz
rm zlib-$ZLIB_VERSION.tar.gz

wget http://www.bzip.org/$BZLIB2_VERSION/bzip2-$BZLIB2_VERSION.tar.gz
tar xvf bzip2-$BZLIB2_VERSION.tar.gz
rm bzip2-$BZLIB2_VERSION.tar.gz

wget  http://www.openssl.org/source/openssl-$OPEN_SSL_VERSION.tar.gz -Oopenssl-$OPEN_SSL_VERSION.tar.gz
tar xvf openssl-$OPEN_SSL_VERSION.tar.gz
rm openssl-$OPEN_SSL_VERSION.tar.gz

wget ftp://ftp.sunet.se/pub/www/servers/apache/dist/avro/avro-$AVRO_VERSION/cpp/avro-cpp-$AVRO_VERSION.tar.gz
tar xvf avro-cpp-$AVRO_VERSION.tar.gz
rm avro-cpp-$AVRO_VERSION.tar.gz

wget https://github.com/joyent/http-parser/archive/v$JOYENT_HTTP_VERSION.tar.gz -Ohttp_parser-v$JOYENT_HTTP_VERSION.tar.gz
tar xvf http_parser-v$JOYENT_HTTP_VERSION.tar.gz
rm http_parser-v$JOYENT_HTTP_VERSION.tar.gz

cd boost_$BOOST_VERSION
#echo "using gcc : arm : arm-linux-gnueabihf-g++ ;" >> tools/build/v2/user-config.jam move <=1.55
#echo "using gcc : arm : arm-linux-gnueabihf-g++ ;" >> tools/build/user-config.jam should work >=1.56 - but I had to use home dir for now
echo "using gcc : arm : arm-linux-gnueabihf-g++ ;" >> ~/user-config.jam
./bootstrap.sh
./b2 -j 5 -s ZLIB_SOURCE=$PWD/../zlib-$ZLIB_VERSION  -s BZIP2_SOURCE=$PWD/../bzip2-$BZLIB2_VERSION toolset=gcc-arm
cd ..

#build curl
export CFLAGS='-O2 -march=armv6j -mfpu=vfp -mfloat-abi=hard'
export CC=arm-linux-gnueabihf-gcc

cd curl-$CURL_VERSION
./configure --host=arm-linux-gnueabihf --disable-shared
make
cd ..

#build openssl
cd openssl-$OPEN_SSL_VERSION
export CFLAGS='-Os -march=armv6j -mfpu=vfp -mfloat-abi=hard'
export CC=arm-linux-gnueabihf-gcc
./Configure dist threads -D_REENTRANT no-shared
sed -i 's/ -O/ -Os/g' Makefile
make
cd ..

cd avro-cpp-$AVRO_VERSION
export BOOST_ROOT=$PWD/../boost_$BOOST_VERSION 
export Boost_INCLUDE_DIR=$PWD/../boost_$BOOST_VERSION/boost
export PI_TOOLS_HOME=~/xtools/tools
rm -rf avro
rm -rf build
mkdir build
cd build
cmake -DCMAKE_TOOLCHAIN_FILE=../csi-build-scripts/toolchains/raspberry.ia32.cmake ..
make -j4
cd ..
mkdir avro
cp -r api/*.* avro
cd ..

cd json-spirit
#export BOOST_ROOT=$PWD/../boost_$BOOST_VERSION 
#export Boost_INCLUDE_DIR=$PWD/../boost_$BOOST_VERSION/boost
export PI_TOOLS_HOME=~/xtools/tools
rm -rf build
mkdir build
cd build
cmake -D__LINUX__=1 -DCMAKE_TOOLCHAIN_FILE=../csi-build-scripts/toolchains/raspberry.ia32.cmake ..
make -j4
cd ..
cd ..

#zlib & bzip2 needs to be there for boost iostreams to compile but since were not using it at the moment - clould be skipped

cd zlib-$ZLIB_VERSION
./configure --static
make
cd ..

cd bzip2-$BZLIB2_VERSION
make CC=$CC AR=arm-linux-gnueabihf-ar
cd ..

#cd v8
#export AR=arm-linux-gnueabihf-ar
#export CXX=arm-linux-gnueabihf-g++
#export CC=arm-linux-gnueabihf-gcc
#export LINK=arm-linux-gnueabihf-g++
#export CFLAGS='-O2 -march=armv6j -mfpu=vfp -mfloat-abi=hard'
#make -j 4 armv7=false armfloatabi=hard arm
#cd ..


cd csi-http
rm -rf build
rm -rf lib
mkdir build
cd build
cmake -D__CSI_HAS_OPENSSL__=1 -D__LINUX__=1 -DCMAKE_TOOLCHAIN_FILE=../csi-build-scripts/toolchains/raspberry.ia32.cmake ..
make -j4
cd ..
cd ..





