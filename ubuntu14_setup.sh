export AVRO_VERSION=1.7.7
export JOYENT_HTTP_VERSION=2.3
export SQLPP11_VERSION=0.33
export C_ARES_VERSION=1.10.0
export CURL_VERSION=7.42.1

wget http://c-ares.haxx.se/download/c-ares-$C_ARES_VERSION.tar.gz
tar xvf c-ares-$C_ARES_VERSION.tar.gz
rm c-ares-$C_ARES_VERSION.tar.gz

wget http://curl.haxx.se/download/curl-$CURL_VERSION.tar.gz
tar xvf curl-$CURL_VERSION.tar.gz
rm curl-$CURL_VERSION.tar.gz

wget ftp://ftp.sunet.se/pub/www/servers/apache/dist/avro/avro-$AVRO_VERSION/cpp/avro-cpp-$AVRO_VERSION.tar.gz
tar xvf avro-cpp-$AVRO_VERSION.tar.gz
rm avro-cpp-$AVRO_VERSION.tar.gz

wget --no-check-certificate  https://github.com/joyent/http-parser/archive/v$JOYENT_HTTP_VERSION.tar.gz -Ohttp_parser-v$JOYENT_HTTP_VERSION.tar.gz
tar -xvf http_parser-v$JOYENT_HTTP_VERSION.tar.gz
rm http_parser-v$JOYENT_HTTP_VERSION.tar.gz

wget --no-check-certificate https://github.com/rbock/sqlpp11/archive/$SQLPP11_VERSION.tar.gz -Osqlpp11-v$SQLPP11_VERSION.tar.gz
tar -xvf sqlpp11-v$SQLPP11_VERSION.tar.gz
rm sqlpp11-v$SQLPP11_VERSION.tar.gz

#until boost 1.58? when this is supposed to be included
git clone https://github.com/boostorg/endian.git
#back some things out of trunk to compile under boost 1.54 
sed -i "s:<boost/predef/detail/endian_compat.h>:<boost/detail/endian.hpp>:" endian/include/boost/endian/arithmetic.hpp
sed -i "s:<boost/predef/detail/endian_compat.h>:<boost/detail/endian.hpp>:" endian/include/boost/endian/conversion.hpp
sed -i "s:<boost/predef/detail/endian_compat.h>:<boost/detail/endian.hpp>:" endian/include/boost/endian/buffers.hpp

sed -i "s:<boost/core/scoped_enum.hpp>:<boost/detail/scoped_enum_emulation.hpp>:" endian/include/boost/endian/arithmetic.hpp
sed -i "s:<boost/core/scoped_enum.hpp>:<boost/detail/scoped_enum_emulation.hpp>:" endian/include/boost/endian/conversion.hpp
sed -i "s:<boost/core/scoped_enum.hpp>:<boost/detail/scoped_enum_emulation.hpp>:" endian/include/boost/endian/buffers.hpp

git clone https://github.com/google/snappy.git
git clone https://github.com/bitbouncer/csi-avro-cpp.git
git clone https://github.com/bitbouncer/csi-http.git
git clone https://github.com/bitbouncer/csi-kafka.git
git clone https://github.com/bitbouncer/json-spirit

export CFLAGS='-O2'
echo building c-ares
cd c-ares-$C_ARES_VERSION
./configure 
make
sudo make install
cd ..
echo done with building c-ares

cd curl-$CURL_VERSION
echo building curl
./configure --disable-shared --enable-ares
make
echo done building curl
cd ..

#build stuff
cd snappy
./autogen.sh
./configure
make all
cd ..

#not used yet...
cd sqlpp11-$SQLPP11_VERSION
mkdir build
cd build
cmake ..
make -j4
sudo make install
cd ..
cd ..

cd avro-cpp-$AVRO_VERSION
mkdir build
cd build
cmake ..
make -j4
sudo make install
cd ..
cd ..

cd csi-avro-cpp
bash -e build_linux.sh
cd ..

cd json-spirit
bash -e build_linux.sh
cd ..

cd csi-http
bash -e build_linux.sh
cd ..

cd csi-kafka
bash -e build_linux.sh
cd ..
