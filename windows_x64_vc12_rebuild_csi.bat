set VISUALSTUDIO_VERSION=12.0
set VISUALSTUDIO_VERSION_MAJOR=12

call "C:\Program Files (x86)\Microsoft Visual Studio %VISUALSTUDIO_VERSION%\VC\vcvarsall.bat" amd64

cd json-spirit
git pull
rmdir /S /Q bin\x64
rmdir /S /Q lib\x64
rmdir /S /Q win_build64
mkdir win_build64 
cd win_build64
cmake -G "Visual Studio 12 Win64" ..
msbuild ALL_BUILD.vcxproj /p:Configuration=Debug /p:Platform=x64
msbuild ALL_BUILD.vcxproj /p:Configuration=Release /p:Platform=x64
cd ..
cd ..

cd csi-http
git pull
rmdir /S /Q bin\x64
rmdir /S /Q lib\x64
rmdir /S /Q win_build64
mkdir win_build64 
cd win_build64
cmake -D__CSI_HAS_OPENSSL__=1  -G "Visual Studio 12 Win64" ..
msbuild ALL_BUILD.vcxproj /p:Configuration=Debug /p:Platform=x64
msbuild ALL_BUILD.vcxproj /p:Configuration=Release /p:Platform=x64
cd ..
cd ..

cd csi-avro-utils
git pull
rmdir /S /Q bin\x64
rmdir /S /Q lib\x64
rmdir /S /Q win_build64
mkdir win_build64 
cd win_build64
cmake -D__CSI_HAS_OPENSSL__=1  -G "Visual Studio 12 Win64" ..
msbuild ALL_BUILD.vcxproj /p:Configuration=Debug /p:Platform=x64
msbuild ALL_BUILD.vcxproj /p:Configuration=Release /p:Platform=x64
cd ..
cd ..

cd postgres-asio
git pull
rmdir /S /Q bin\x64
rmdir /S /Q lib\x64
rmdir /S /Q win_build64
mkdir win_build64 
cd win_build64
cmake -D__CSI_HAS_OPENSSL__=1  -G "Visual Studio 12 Win64" ..
msbuild ALL_BUILD.vcxproj /p:Configuration=Debug /p:Platform=x64
msbuild ALL_BUILD.vcxproj /p:Configuration=Release /p:Platform=x64
cd ..
cd ..


cd csi-kafka
git pull
rmdir /S /Q bin\x64
rmdir /S /Q lib\x64
rmdir /S /Q win_build64
mkdir win_build64 
cd win_build64
cmake  -G "Visual Studio 12 Win64" ..
msbuild ALL_BUILD.vcxproj /p:Configuration=Debug /p:Platform=x64
msbuild ALL_BUILD.vcxproj /p:Configuration=Release /p:Platform=x64
cd ..
cd ..

cd csi-samples
git pull
rmdir /S /Q bin\x64
rmdir /S /Q lib\x64
rmdir /S /Q win_build64
mkdir win_build64 
cd win_build64
cmake  -G "Visual Studio 12 Win64" ..
msbuild ALL_BUILD.vcxproj /p:Configuration=Debug /p:Platform=x64
msbuild ALL_BUILD.vcxproj /p:Configuration=Release /p:Platform=x64
cd ..
cd ..

cd kafka2influx
git pull
rmdir /S /Q bin\x64
rmdir /S /Q lib\x64
rmdir /S /Q win_build64
mkdir win_build64 
cd win_build64
cmake  -G "Visual Studio 12 Win64" ..
msbuild ALL_BUILD.vcxproj /p:Configuration=Debug /p:Platform=x64
msbuild ALL_BUILD.vcxproj /p:Configuration=Release /p:Platform=x64
cd ..
cd ..

cd phoebe
git pull
rmdir /S /Q bin\x64
rmdir /S /Q lib\x64
rmdir /S /Q win_build64
mkdir win_build64 
cd win_build64
cmake  -G "Visual Studio 12 Win64" ..
msbuild ALL_BUILD.vcxproj /p:Configuration=Debug /p:Platform=x64
msbuild ALL_BUILD.vcxproj /p:Configuration=Release /p:Platform=x64
cd ..
cd ..
