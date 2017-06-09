export LABEL=armhf_linux;
export CROSS_TOOLCHAIN=true;
export ARCH=armhf;
export RPM_ARCH=armhf;
export NPM_ARCH=arm;
export GNU_TRIPLET=arm-linux-gnueabihf;
export GNU_MULTILIB_TRIPLET=;
export CXX=arm-linux-gnueabihf-g++;
export CC=arm-linux-gnueabihf-gcc;
export VSCODE_ELECTRON_PLATFORM=arm;
export PACKAGE_ARCH=arm;
export QEMU_ARCH=arm;
export QEMU_ELECTRON_ARCH=arm;
# export JAIL_ROOTFS="http://cdimage.ubuntu.com/ubuntu-base/releases/16.04.2/release/ubuntu-base-16.04.2-base-${ARCH}.tar.gz";
export QEMU_ARCHIVE="http://archive.raspbian.org/raspbian";
export QEMU_IMAGE="https://downloads.raspberrypi.org/raspbian/images/raspbian-2016-11-29/2016-11-25-raspbian-jessie.zip";

# # Raspberry Pi B
# export QEMU_KERNEL="kernel.img";
# export QEMU_DTB="bcm2708-rpi-b.dtb";
# export QEMU_OPTS="-cpu arm1176 -m 256 -machine versatilepb";

#Raspberry Pi 2B
export QEMU_KERNEL="kernel7.img";
export QEMU_DTB="bcm2709-rpi-2-b.dtb";
export QEMU_OPTS="-machine versatilepb";
