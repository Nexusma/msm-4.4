!/bin/bash 


#    Configuration files can be found in arch/arm64/configs.
#    defconfig using in common:
#    diffconfigs for each product:
#    Xperia XZ Premium G8141       => maple_diffconfig
#    Xperia XZ Premium Dual G8142  => maple_dsds_diffconfig
#    Xperia XZ1 G8341/G8343        => poplar_diffconfig
#    Xperia XZ1 G8342              => poplar_dsds_diffconfig
#    Xperia XZ1 Compact G8441      => lilac_diffconfig


rm .version
# Bash Color
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# Resources
THREAD="-j$(grep -c ^processor /proc/cpuinfo)"
KERNEL="Image"
DTBIMAGE="dtb"
export PATH=~/aarch64-linux-android-aosp/bin/:$PATH
export CROSS_COMPILE=aarch64-linux-android-
export KBUILD_DIFFCONFIG=device_diffconfig

# Kernel Details
BASEVER="v1"
VER=".${BASEVER}"
ZIPNAME="DEVICE_KERNEL_${BASEVER}AK"

# Paths
KERNEL_DIR=`pwd`
TOOLS_DIR=/mnt/home/android/yoshino/final_files
REPACK_DIR=${TOOLS_DIR}/AnyKernel2
PATCH_DIR=${REPACK_DIR}/patch
MODULES_DIR=${REPACK_DIR}/modules/system/lib/modules
ZIP_MOVE=${TOOLS_DIR} O=./out
ZIMAGE_DIR=${KERNEL_DIR}/out/arch/arm64/boot


# Functions
function clean_all {
		rm -rf $MODULES_DIR/*
		cd $KERNEL_DIR/out/kernel
		rm -rf $DTBIMAGE
		git reset --hard > /dev/null 2>&1
		git clean -f -d > /dev/null 2>&1
		cd $KERNEL_DIR
		echo
		make clean && make mrproper
}

function make_kernel {
		echo
		make $DEFCONFIG O=./out
		make $THREAD O=./out

}

function make_modules {
		rm `echo $MODULES_DIR"/*"`
		find $KERNEL_DIR -name '*.ko' -exec cp -v {} $MODULES_DIR \;
}

function make_dtb {
		$TOOLS_DIR/dtbToolCM -2 -o $REPACK_DIR/$DTBIMAGE -s 2048 -p scripts/dtc/ arch/arm64/boot/
}

function make_boot {
		cp -vr $ZIMAGE_DIR/Image.gz-dtb ${REPACK_DIR}/zImage
}



DATE_START=$(date +"%s")


echo -e "${green}"
echo "-----------------"
echo "Making:"
echo "-----------------"
echo -e "${restore}"


echo -e "${green}"
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo






















