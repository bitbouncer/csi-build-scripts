csi-build-scripts
=================
Common buildscripts for bitbouncer repos. 

Downloads and build all required libs. The purpose is to have a common build system to make it trivial to use Visual Studio during development and deploy production code on Linux

Downloads and builds (where needed)
  * Boost              1.59
  * OpenSSL            1.0.1j
  * libcurl            7.0.39
  * zlib               1.2.8
  * avro_cpp           1.7.7
  * libevent           2.0.21
  * pthread            2.9.1
  * joyent_http_parser 2.3
  * snappy (master)
  * boost_endian (master)

## Ubuntu 14 x64:

Install build tools
```
sudo apt-get update
sudo apt-get install -y automake autogen shtool libtool git wget cmake unzip build-essential g++ python-dev autotools-dev libicu-dev zlib1g-dev openssl libssl-dev libcurl4-openssl-dev libbz2-dev libcurl3 libboost-all-dev libpq-dev

```

Get and build necessary dependencies
```
mkdir source
cd source
git clone https://github.com/bitbouncer/csi-build-scripts.git
bash csi-build-scripts/linux_setup_3rd_part.sh
bash csi-build-scripts/linux_get_csi.sh
bash csi-build-scripts/linux_rebuild_csi.sh
```
## Ubuntu 12 x64:

Install build tools
```
sudo apt-get install -y software-properties-common python-software-properties
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install -y automake autogen shtool libtool git wget cmake unzip build-essential g++ python-dev autotools-dev libicu-dev zlib1g-dev openssl libssl-dev libcurl4-openssl-dev libbz2-dev libcurl3 libboost-all-dev libpq-dev
sudo apt-get install -y gcc-4.8 g++-4.8

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 10 --slave /usr/bin/g++ g++ /usr/bin/g++-4.6
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 90 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8

```
see for changing between compilers
http://charette.no-ip.com:81/programming/2011-12-24_GCCv47/


Get and build nessessary dependencies
```
mkdir source
cd source
git clone https://github.com/bitbouncer/csi-build-scripts.git
bash csi-build-scripts/ubuntu12_setup.sh
```

## Centos 7 x64:

Install build tools (as root)
```
yum -y update
yum -y groupinstall 'Development Tools'
yum -y install automake autogen libtool git wget cmake unzip openssl redhat-lsb-core postgresql-devel openssl-devel
```

Get and build necessary dependencies (as root)
```
mkdir source
cd source
git clone https://github.com/bitbouncer/csi-build-scripts.git
bash csi-build-scripts/linux_setup_3rd_part.sh
bash csi-build-scripts/linux_get_csi.sh
bash csi-build-scripts/linux_rebuild_csi.sh
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



