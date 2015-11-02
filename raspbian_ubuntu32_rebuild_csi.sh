export BOOST_VERSION=1_59_0
export BOOST_VERSION_DOTTED=1.59.0
export CURL_VERSION=7.42.1
export ZLIB_VERSION=1.2.8
export BZLIB2_VERSION=1.0.6
export OPEN_SSL_VERSION=1.0.1j
export JOYENT_HTTP_VERSION=2.3
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


cd json-spirit
#export PI_TOOLS_HOME=~/xtools/tools
#rm -rf build
#mkdir build
#cd build
#cmake -D__LINUX__=1 -DCMAKE_TOOLCHAIN_FILE=../csi-build-scripts/toolchains/raspberry.ia32.cmake ..
#make -j4
#cd ..
bash ./build_cross_raspbian.sh
cd ..

cd csi-http
bash ./build_cross_raspbian.sh
#rm -rf build
#rm -rf lib
#mkdir build
#cd build
#cmake -D__CSI_HAS_OPENSSL__=1 -D__LINUX__=1 -DCMAKE_TOOLCHAIN_FILE=../csi-build-scripts/toolchains/raspberry.ia32.cmake ..
#make -j4
#cd ..
cd ..





