export BOOST_VERSION=1_59_0
export BOOST_VERSION_DOTTED=1.59.0
export JOYENT_HTTP_VERSION=2.3
export SQLPP11_VERSION=0.33
export C_ARES_VERSION=1.10.0
export CURL_VERSION=7.42.1

export ZLIB_VERSION=1.2.8
export BZLIB2_VERSION=1.0.6
export OPEN_SSL_VERSION=1.0.1j

wget http://c-ares.haxx.se/download/c-ares-$C_ARES_VERSION.tar.gz
tar xf c-ares-$C_ARES_VERSION.tar.gz
rm -f c-ares-$C_ARES_VERSION.tar.gz

wget http://curl.haxx.se/download/curl-$CURL_VERSION.tar.bz2 -Ocurl-$CURL_VERSION.tar.bz2
tar xf curl-$CURL_VERSION.tar.bz2
rm  curl-$CURL_VERSION.tar.bz2

wget http://sourceforge.net/projects/boost/files/boost/$BOOST_VERSION_DOTTED/boost_$BOOST_VERSION.tar.gz/download -Oboost_$BOOST_VERSION.tar.gz
tar xf boost_$BOOST_VERSION.tar.gz
rm boost_$BOOST_VERSION.tar.gz

wget http://zlib.net/zlib-$ZLIB_VERSION.tar.gz
tar xf zlib-$ZLIB_VERSION.tar.gz
rm zlib-$ZLIB_VERSION.tar.gz

wget http://www.bzip.org/$BZLIB2_VERSION/bzip2-$BZLIB2_VERSION.tar.gz
tar xvf bzip2-$BZLIB2_VERSION.tar.gz
rm bzip2-$BZLIB2_VERSION.tar.gz

wget  http://www.openssl.org/source/openssl-$OPEN_SSL_VERSION.tar.gz -Oopenssl-$OPEN_SSL_VERSION.tar.gz
tar xf openssl-$OPEN_SSL_VERSION.tar.gz
rm openssl-$OPEN_SSL_VERSION.tar.gz

#wget ftp://ftp.sunet.se/pub/www/servers/apache/dist/avro/avro-$AVRO_VERSION/cpp/avro-cpp-$AVRO_VERSION.tar.gz
#tar xf avro-cpp-$AVRO_VERSION.tar.gz
#rm avro-cpp-$AVRO_VERSION.tar.gz

wget --no-check-certificate https://github.com/joyent/http-parser/archive/v$JOYENT_HTTP_VERSION.tar.gz -Ohttp_parser-v$JOYENT_HTTP_VERSION.tar.gz
tar xf http_parser-v$JOYENT_HTTP_VERSION.tar.gz
rm http_parser-v$JOYENT_HTTP_VERSION.tar.gz

cd boost_$BOOST_VERSION
echo "using gcc : arm : arm-linux-gnueabihf-g++ ;" > ~/user-config.jam
./bootstrap.sh
./b2 -j 5 -s ZLIB_SOURCE=$PWD/../zlib-$ZLIB_VERSION  -s BZIP2_SOURCE=$PWD/../bzip2-$BZLIB2_VERSION toolset=gcc-arm
cd ..

#cares
export CFLAGS='-O2 -march=armv6j -mfpu=vfp -mfloat-abi=hard'
export CC=arm-linux-gnueabihf-gcc
cd c-ares-$C_ARES_VERSION
./configure --host=arm-linux-gnueabihf --disable-shared
make
cd ..

#curl
export CFLAGS='-O2 -march=armv6j -mfpu=vfp -mfloat-abi=hard'
export CC=arm-linux-gnueabihf-gcc
cd curl-$CURL_VERSION
#get c-ares library inside curl tree for ./configure to work
cp -r ../c-ares-$C_ARES_VERSION ares
./configure --host=arm-linux-gnueabihf --disable-shared --enable-ares
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

#cd avro-cpp-$AVRO_VERSION
#export BOOST_ROOT=$PWD/../boost_$BOOST_VERSION 
#export Boost_INCLUDE_DIR=$PWD/../boost_$BOOST_VERSION/boost
#export PI_TOOLS_HOME=~/xtools/tools
#rm -rf avro
#rm -rf build
#mkdir build
#cd build
#cmake -DCMAKE_TOOLCHAIN_FILE=../csi-build-scripts/toolchains/raspberry.ia32.cmake ..
#make -j4
#cd ..
#mkdir avro
#cp -r api/*.* avro
#cd ..


#zlib & bzip2 needs to be there for boost iostreams to compile but since were not using it at the moment - could be skipped

cd zlib-$ZLIB_VERSION
./configure --static
make
cd ..

#the test fails here but we do not care...
cd bzip2-$BZLIB2_VERSION
make CC=$CC AR=arm-linux-gnueabihf-ar
cd ..

