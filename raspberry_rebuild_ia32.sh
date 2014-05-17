sudo apt-get install cmake wget unzip cmake wget wput libpcre3 libpcre3-dev build-essential git subversion 

mkdir -p ~/xtools
cd ~/xtools

git clone https://github.com/raspberrypi/tools.git --depth 1
cd ..

echo "export PATH=~/xtools/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin:\$PATH" >> ~/.bashrc

source ~/.bashrc



export BOOST_VERSION=1_55_0
export BOOST_VERSION_DOTTED=1.55.0
export AVRO_VERSION=1.7.6
export CURL_VERSION=7.35.0
export ZLIB_VERSION=1.2.8
export BZLIB2_VERSION=1.0.6
export OPEN_SSL_VERSION=1.0.1g
export JOYENT_HTTP_VERSION=2.3

mkdir raspberry
cd raspberry

svn checkout http://v8.googlecode.com/svn/trunk/ v8
cd v8

svn co https://src.chromium.org/chrome/trunk/deps/third_party/icu46 third_party/icu
svn co http://gyp.googlecode.com/svn/trunk build/gyp
build/gyp_v8

export AR=arm-linux-gnueabihf-ar
export CXX=arm-linux-gnueabihf-g++
export CC=arm-linux-gnueabihf-gcc
export LINK=arm-linux-gnueabihf-g++
export CFLAGS='-O2 -march=armv6j -mfpu=vfp -mfloat-abi=hard'

make armv7=false armfloatabi=hard arm
cd ..


mkdir -p ~/source/raspberrypi
cd ~/source/raspberrypi

git clone https://github.com/bitbouncer/csi-http
git clone https://github.com/bitbouncer/json-spirit

wget http://curl.haxx.se/download/curl-$CURL_VERSION.tar.bz2 -Ocurl-$CURL_VERSION.tar.bz2
tar xvf curl-$CURL_VERSION.tar.bz2

wget http://sourceforge.net/projects/boost/files/boost/$BOOST_VERSION_DOTTED/boost_$BOOST_VERSION.tar.gz/download -Oboost_$BOOST_VERSION.tar.gz
tar xvf boost_$BOOST_VERSION.tar.gz

wget http://zlib.net/zlib-$ZLIB_VERSION.tar.gz
tar xvf zlib-$ZLIB_VERSION.tar.gz

wget http://www.bzip.org/$BZLIB2_VERSION/bzip2-$BZLIB2_VERSION.tar.gz
tar xvf bzip2-$BZLIB2_VERSION.tar.gz

wget  http://www.openssl.org/source/openssl-$OPEN_SSL_VERSION.tar.gz -Oopenssl-$OPEN_SSL_VERSION.tar.gz
gzip -d openssl-$OPEN_SSL_VERSION.tar.gz
tar -xvf openssl-$OPEN_SSL_VERSION.tar

wget ftp://ftp.sunet.se/pub/www/servers/apache/dist/avro/avro-$AVRO_VERSION/cpp/avro-cpp-$AVRO_VERSION.tar.gz
tar xvf avro-cpp-$AVRO_VERSION.tar.gz

wget https://github.com/joyent/http-parser/archive/v$JOYENT_HTTP_VERSION.tar.gz -Ohttp_parser-v$JOYENT_HTTP_VERSION.tar.gz
gzip -d http_parser-v$JOYENT_HTTP_VERSION.tar.gz
tar -xvf http_parser-v$JOYENT_HTTP_VERSION.tar

cd boost_$BOOST_VERSION
echo "using gcc : arm : arm-linux-gnueabihf-g++ ;" >> tools/build/v2/user-config.jam
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
cmake -DCMAKE_TOOLCHAIN_FILE=../csi-http/toolchains/raspberrypi.toolchain.ia32.cmake ..
make
cd ..
mkdir avro
cp -r api/*.* avro
cd ..

cd json-spirit
export BOOST_ROOT=$PWD/../boost_$BOOST_VERSION 
export Boost_INCLUDE_DIR=$PWD/../boost_$BOOST_VERSION/boost
export PI_TOOLS_HOME=~/xtools/tools
rm -rf avro
rm -rf build
mkdir build
cd build
cmake -DCMAKE_TOOLCHAIN_FILE=../csi-http/toolchains/raspberrypi.toolchain.ia32.cmake ..
make
cd ..
cd ..

#zlib & bzip2 needs to be there for boost iostreams to compile but since were not using it at the moment - skip this

cd zlib-$ZLIB_VERSION
./configure --static
cd ..


# not sure that the below lines actually builds arm version...
cd bzip2-$BZLIB2_VERSION
make 
cd ..


cd csi-http
bash build_raspberrypi_ia32.sh
cd ..

