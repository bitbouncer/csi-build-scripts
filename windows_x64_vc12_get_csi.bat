git clone https://github.com/bitbouncer/avro.git
mkdir avro\lang\c++\avro
xcopy /s /y avro\lang\c++\api\* avro\lang\c++\avro

REM wget --no-check-certificate https://dist.apache.org/repos/dist/dev/avro/avro-1.8.0-rc1/avro-src-1.8.0.tar.gz -Oavro-src-1.8.0.tar.gz
REM gunzip avro-src-1.8.0.tar.gz
REM tar xf avro-src-1.8.0.tar
REM del avro-src-1.8.0.tar
REM mkdir avro-src-1.8.0\lang\c++\avro
REM xcopy /s /y avro-src-1.8.0\lang\c++\api\* avro-src-1.8.0\lang\c++\avro

git clone https://github.com/bitbouncer/postgres-asio.git
git clone https://github.com/bitbouncer/csi-kafka.git
git clone https://github.com/bitbouncer/csi-http.git
git clone https://github.com/bitbouncer/csi-avro-utils.git
git clone https://github.com/bitbouncer/json-spirit
git clone https://github.com/bitbouncer/csi-samples
git clone https://github.com/bitbouncer/kafka2influx
git clone https://github.com/bitbouncer/phoebe

