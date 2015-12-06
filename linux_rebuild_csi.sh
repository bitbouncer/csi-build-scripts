export BOOST_VERSION=1_59_0
export BOOST_VERSION_DOTTED=1.59.0
export JOYENT_HTTP_VERSION=2.3
export SQLPP11_VERSION=0.33
export C_ARES_VERSION=1.10.0
export CURL_VERSION=7.42.1
export AVRO_DIR=avro/lang/c++

pushd $AVRO_DIR
git pull
popd

rm -rf $AVRO_DIR/avro 
mkdir $AVRO_DIR/avro 
cp -r $AVRO_DIR/api/* $AVRO_DIR/avro

cd json-spirit
git pull
bash -e build_linux.sh
cd ..

cd csi-http
git pull
bash -e build_linux.sh
cd ..

cd csi-avro-utils
git pull
bash -e build_linux.sh
cd ..

cd csi-kafka
git pull
bash -e build_linux.sh
cd ..

cd postgres-asio
git pull
bash -e build_linux.sh
cd ..

cd csi-samples
git pull
bash -e build_linux.sh
cd ..

cd phoebe
git pull
bash -e build_linux.sh
cd ..

cd kafka2influx
git pull
bash -e build_linux.sh
cd ..
