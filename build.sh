#!/bin/bash

# Get Build Startup Time
if [ -z "$OUT_TARGET_HOST" ]
then
   res1=$(date +%s.%N)
else
   res1=$(gdate +%s.%N)
fi

# Kernel Version
BASE_VER=".KANGAROO"
VER=".M7.v060"
VER=$BASE_VER$VER

# localversion
export LOCALVERSION=""`echo $VER`

# toolchain
TOOLCHAIN=${HOME}/linaro-toolchains/arm-cortex_a15/arm-cortex_a15-linux-gnueabihf-linaro_4.9.1-2014.05/bin/arm-cortex_a15-linux-gnueabihf-
export ARCH=arm
export SUBARCH=arm

# make mrproper
#make CROSS_COMPILE=$TOOLCHAIN -j`grep 'processor' /proc/cpuinfo | wc -l` mrproper
 
# remove backup files
find ./ -name '*~' | xargs rm
# rm compile.log

# build the kernel
make 'm7_defconfig'
make -j`grep 'processor' /proc/cpuinfo | wc -l` CROSS_COMPILE=$TOOLCHAIN #>> compile.log 2>&1 || exit -1

# Get Build Time
if [ -z "$OUT_TARGET_HOST" ]
then
   res2=$(date +%s.%N)
else
   res2=$(gdate +%s.%N)
fi

echo "Total time elapsed: $(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds)"
echo
