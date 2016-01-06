export SNAPPY_VERSION=1.1.3
export BOOST_VERSION=1_59_0
export BOOST_VERSION_DOTTED=1.59.0
export JOYENT_HTTP_VERSION=2.3
export SQLPP11_VERSION=0.33
export C_ARES_VERSION=1.10.0
export CURL_VERSION=7.42.1

wget http://c-ares.haxx.se/download/c-ares-$C_ARES_VERSION.tar.gz
tar xvf c-ares-$C_ARES_VERSION.tar.gz
rm -f c-ares-$C_ARES_VERSION.tar.gz

wget http://curl.haxx.se/download/curl-$CURL_VERSION.tar.gz
tar xvf curl-$CURL_VERSION.tar.gz
rm -f curl-$CURL_VERSION.tar.gz

wget --no-check-certificate https://github.com/google/snappy/releases/download/$SNAPPY_VERSION/snappy-$SNAPPY_VERSION.tar.gz  -Osnappy-$SNAPPY_VERSION.tar.gz
tar xvf snappy-$SNAPPY_VERSION.tar.gz
rm -f snappy-$SNAPPY_VERSION.tar.gz

#RIGHT NOW WE ARE USING OWN AVRO BRANCH
#wget ftp://ftp.sunet.se/pub/www/servers/apache/dist/avro/avro-$AVRO_VERSION/cpp/avro-cpp-$AVRO_VERSION.tar.gz
#tar xvf avro-cpp-$AVRO_VERSION.tar.gz
#rm avro-cpp-$AVRO_VERSION.tar.gz

wget --no-check-certificate  https://github.com/joyent/http-parser/archive/v$JOYENT_HTTP_VERSION.tar.gz -Ohttp_parser-v$JOYENT_HTTP_VERSION.tar.gz
tar -xvf http_parser-v$JOYENT_HTTP_VERSION.tar.gz
rm -f http_parser-v$JOYENT_HTTP_VERSION.tar.gz

wget --no-check-certificate https://github.com/rbock/sqlpp11/archive/$SQLPP11_VERSION.tar.gz -Osqlpp11-v$SQLPP11_VERSION.tar.gz
tar -xvf sqlpp11-v$SQLPP11_VERSION.tar.gz
rm -f sqlpp11-v$SQLPP11_VERSION.tar.gz

wget http://sourceforge.net/projects/boost/files/boost/$BOOST_VERSION_DOTTED/boost_$BOOST_VERSION.tar.gz/download -Oboost_$BOOST_VERSION.tar.gz
tar xf boost_$BOOST_VERSION.tar.gz
rm -f boost_$BOOST_VERSION.tar.gz

cd boost_$BOOST_VERSION
./bootstrap.sh
./b2 -j 4 b2 link=static --with-boost_log_setup --with-boost_log --with-boost_date_time --with-boost_timer --with-boost_thread --with-boost_system --with-boost_program_options --with-boost_filesystem --with-boost_regex --with-boost_chrono --with-boost_iostreams  
cd ..

export CFLAGS='-O2'
echo building c-ares
cd c-ares-$C_ARES_VERSION
./configure --disable-shared
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
cd snappy-$SNAPPY_VERSION
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

