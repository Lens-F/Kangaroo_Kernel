#!/bin/bash

# Get Build Startup Time
if [ -z "$OUT_TARGET_HOST" ]
then
   res1=$(date +%s.%N)
else
   res1=$(gdate +%s.%N)
fi

# Path to build your kernel
  k=~/kangaroo
# Directory for the any kernel updater
  t=$k/packages

# Kernel Version
VER="KANGAROO.M7.v060"
VERSION=$VER

# localversion
export LOCALVERSION=""`echo $VER`

# Clean
     make clean
     rm -rf $k/out

# Setup the build
 cd $k/arch/arm/configs/m7configs
    for c in *
      do
        cd $k
# Setup output directory
       mkdir -p "out/$c"
          cp -R "$t/system" out/$c
          cp -R "$t/META-INF" out/$c
	  cp -R "$t/kernel" out/$c
       mkdir -p "out/$c/system/lib/modules/"

  m=$k/out/$c/system/lib/modules


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

# Grab modules & zImage
   cp $k/arch/arm/boot/zImage out/$c/kernel/zImage
   for mo in $(find . -name "*.ko"); do
		cp "${mo}" $m
   done

# Version Number to add to zip
  z="${VERSION}"
     cd $k/out/$c/
       7z a "$z.zip"
         mv $z.zip $k/out/$z.zip

# cp $k/out/$z.zip $db/$z.zip
#           rm -rf $k/out/$c
# Line below for debugging purposes,  uncomment to stop script after each config is run
#read this
      done

# Get Build Time
if [ -z "$OUT_TARGET_HOST" ]
then
   res2=$(date +%s.%N)
else
   res2=$(gdate +%s.%N)
fi

echo "Total time elapsed: $(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds)"
echo
