csi-build-scripts
=================
Common buildscripts for bitbouncer repos download and build all required libs
The purpose is to have a common build system make it trivial to use Visual Studio for C++11 development and still have the alternative to deploy on linux

Downloads and builds (where needed)
  * Boost              1.57
  * OpenSSL            1.0.1j
  * libcurl            7.0.39
  * zlib               1.2.8
  * avro_cpp           1.7.7
  * libevent           2.0.21
  * pthread            2.9.1
  * joyent_http_parser 2.3

## Ubuntu 14 x64:

Install build tools
```
sudo apt-get install -y automake autogen shtool libtool git wget cmake unzip build-essential g++ python-dev autotools-dev libicu-dev zlib1g-dev openssl libssl-dev libcurl4-openssl-dev libbz2-dev libcurl3 libboost-all-dev

```

Get and build nessessary dependencies
```
sudo ls
mkdir source
cd source
git clone https://github.com/bitbouncer/csi-build-scripts.git
bash csi-build-scripts/ubuntu14_setup.sh
```

## Raspberry Pi - cross compiling on ubuntu14 x32

Install build tools
```
sudo apt-get -y install cmake wget unzip cmake wget wput libpcre3 libpcre3-dev build-essential git subversion 
mkdir -p ~/xtools
cd ~/xtools
git clone https://github.com/raspberrypi/tools.git --depth 1
cd ..
echo "export PATH=~/xtools/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc


```
Get and build nessessary dependencies 
```
sudo ls
mkdir raspbian_bitbouncer
cd raspbian_bitbouncer
git clone https://github.com/bitbouncer/csi-build-scripts.git
bash csi-build-scripts/raspbian_ubuntu32_setup.sh
```

## Windows x64 - Visual Studio 12

Get and build nessessary dependencies
```
Install Visual Studio, cmake, nasm, git and active perl manually, make sure active perl is before git in PATH

mkdir source
cd source
git clone https://github.com/bitbouncer/csi-build-scripts.git
csi-build-scripts\windows_x64_vc12_setup.bat
```

License:
- Boost Software License, Version 1.0.



