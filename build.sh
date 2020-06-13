#!/bin/bash
yellow='\033[0;33m'
white='\033[0m'
red='\033[0;31m'
green='\e[0;32m'

echo -e "$green << cleanup bish >> \n $white"

rm -rf out
rm -rf zip

echo -e "$green << clonng toolchain bish >> \n $white"
git clone https://github.com/ItsVixano/aarch64-elf-9.3.0 /root/itsvixano/toolchain_64

export LOCALVERSION=-r2.0-nightly-nonoc

export ARCH=arm64
export SUBARCH=arm64
export HEADER_ARCH=arm64
export CROSS_COMPILE=/root/itsvixano/toolchain_64/bin/aarch64-elf-

export KBUILD_BUILD_HOST="Beta"
export KBUILD_BUILD_USER="ItsVixano"

mkdir -p out

echo -e "$green << doing pre-compiling process bish >> \n $white"

make O=out clean && make O=out mrproper
make ysl_defconfig O=out

echo -e "$yellow << compiling kranul bish >> \n $white"

Start=$(date +"%s")
make -j$(nproc --all) O=out
exit_code=$?
End=$(date +"%s")
Diff=$(($End - $Start))

        if [ $exit_code -eq 0 ]; then
                echo -e "$green << Build completed in $(($Diff / 60)) minutes and $(($Diff % 60)) seconds >> \n $white"
        else
                echo -e "$red << Failed to compile kranul bish , WEN PHIX SAR ??? >>$white"
                exit
        fi

        if [ $exit_code -eq 0 ]; then
                echo -e "$green << cloning anykranul bish >> \n $white"
                git clone https://github.com/ItsVixano/AnyKernel3 --single-branch -b ysl-aosp zip
                echo -e "$yellow << making kranul zip bish >> \n $white"
                cp -r out/arch/arm64/boot/Image.gz-dtb zip/
                cd zip
                mv Image.gz-dtb zImage
                zip -r Test-kernel_ysl-gcc9.zip *
                echo -e "$green << done bish  >> \n $white"
        fi

        if [ $exit_code -eq 0 ]; then
               echo -e "$yellow << pushing kranul on sarbur bish >> \n $white"
               cp Test-kernel_ysl-gcc9.zip /var/www/html
               echo -e "$green << done bish >> \n $white"
               exit
	fi
