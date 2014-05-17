sudo apt-get install cmake wget unzip cmake wget wput libpcre3 libpcre3-dev build-essential git subversion 

mkdir -p ~/xtools
cd ~/xtools

git clone https://github.com/raspberrypi/tools.git --depth 1
cd ..

echo "export PATH=~/xtools/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin:\$PATH" >> ~/.bashrc

source ~/.bashrc
