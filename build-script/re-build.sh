#!/bin/bash

CPU=4
KERNEL_VERSION="6.1.58"

case $KERNEL_VERSION in
    "6.1.58")
      KERNEL_COMMIT="7b859959a6642aff44acdfd957d6d66f6756021e"
      PATCH="ili9881c-6.1.x.patch"
      ;;
    "5.10.92")
      KERNEL_COMMIT="ea9e10e531a301b3df568dccb3c931d52a469106"
      PATCH="ili9881c-5.10.x.patch"
      ;;
    "5.10.90")
      KERNEL_COMMIT="9a09c1dcd4fae55422085ab6a87cc650e68c4181"
      PATCH="ili9881c-5.10.x.patch"
      ;;
esac

echo "!!!  Build modules for kernel ${KERNEL_VERSION}  !!!"

echo "!!!  Build CM4 32-bit kernel and modules  !!!"
cd linux-${KERNEL_VERSION}-v7l+/
KERNEL=kernel7l
make -j${CPU} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2711_defconfig
make -j${CPU} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs
cd ..
echo "!!!  CM4 32-bit build done  !!!"
echo "-------------------------"

echo "!!!  Creating archive  !!!"
rm -rf modules-rpi-${KERNEL_VERSION}-ili9881c/
mkdir -p modules-rpi-${KERNEL_VERSION}-ili9881c/boot/overlays
mkdir -p modules-rpi-${KERNEL_VERSION}-ili9881c/lib/modules/${KERNEL_VERSION}-v7l+/kernel/drivers/gpu/drm/panel/
cp linux-${KERNEL_VERSION}-v7l+/arch/arm/boot/dts/overlays/motivo*.dtbo modules-rpi-${KERNEL_VERSION}-ili9881c/boot/overlays
cp linux-${KERNEL_VERSION}-v7l+/drivers/gpu/drm/panel/panel-ilitek-ili9881c.ko modules-rpi-${KERNEL_VERSION}-ili9881c/lib/modules/${KERNEL_VERSION}-v7l+/kernel/drivers/gpu/drm/panel/
tar -czvf modules-rpi-${KERNEL_VERSION}-ili9881c.tar.gz modules-rpi-${KERNEL_VERSION}-ili9881c/ --owner=0 --group=0
md5sum modules-rpi-${KERNEL_VERSION}-ili9881c.tar.gz > modules-rpi-${KERNEL_VERSION}-ili9881c.md5sum.txt
sha1sum modules-rpi-${KERNEL_VERSION}-ili9881c.tar.gz > modules-rpi-${KERNEL_VERSION}-ili9881c.sha1sum.txt
rm -rf modules-rpi-${KERNEL_VERSION}-ili9881c/
mkdir -p ../output
mv modules-rpi-${KERNEL_VERSION}-ili9881c* ../output/

echo "!!!  Done  !!!"
