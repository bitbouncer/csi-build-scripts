export AVRO_DIR=avro/lang/c++

pushd $AVRO_DIR
git pull
mkdir build
cd build
cmake ..
make -j4
sudo make install
cd ..
popd

cd postgres-asio
git pull
bash -e build_linux.sh
cd ..

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

cd csi-samples
git pull
bash -e build_linux.sh
cd ..
