export AVRO_VERSION=1.7.7
export JOYENT_HTTP_VERSION=2.3

wget ftp://ftp.sunet.se/pub/www/servers/apache/dist/avro/avro-$AVRO_VERSION/cpp/avro-cpp-$AVRO_VERSION.tar.gz
tar xvf avro-cpp-$AVRO_VERSION.tar.gz
rm avro-cpp-$AVRO_VERSION.tar.gz

wget --no-check-certificate  https://github.com/joyent/http-parser/archive/v$JOYENT_HTTP_VERSION.tar.gz -Ohttp_parser-v$JOYENT_HTTP_VERSION.tar.gz
tar -xvf http_parser-v$JOYENT_HTTP_VERSION.tar.gz
rm http_parser-v$JOYENT_HTTP_VERSION.tar.gz

#until boost 1.58? when this is supposed to be included
git clone https://github.com/boostorg/endian.git
#back some things out of trunk to compile under boost < 1.57
sed -i "s:<boost/predef/detail/endian_compat.h>:<boost/detail/endian.hpp>:" endian/include/boost/endian/arithmetic.hpp
sed -i "s:<boost/predef/detail/endian_compat.h>:<boost/detail/endian.hpp>:" endian/include/boost/endian/conversion.hpp
sed -i "s:<boost/core/scoped_enum.hpp>:<boost/detail/scoped_enum_emulation.hpp>:" endian/include/boost/endian/conversion.hpp


git clone https://github.com/bitbouncer/csi-http.git
git clone https://github.com/bitbouncer/csi-kafka.git
git clone https://github.com/bitbouncer/json-spirit

#build stuff
cd avro-cpp-$AVRO_VERSION
mkdir build
cd build
cmake ..
make -j4
sudo make install
cd ..
cd ..

cd json-spirit
mkdir build
cd build
cmake ..
make -j4
sudo make install
cd ..
cd ..

cd csi-http
mkdir build
cd build
cmake -D__CSI_HAS_OPENSSL__=1  -D__LINUX__=1 ..
make -j4
cd ..
cd ..

cd csi-kafka
mkdir build
cd build
cmake -D__LINUX__=1 ..
make -j4
cd ..
cd ..



