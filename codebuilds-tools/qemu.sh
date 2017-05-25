#!/bin/bash
set -e;

if [ ! -d "/workspace/.jail" ]; then

  echo "Installing QEMU and dependencies...";
  apt-get install -y debootstrap qemu-user-static binfmt-support sbuild;

  echo "Reading proc...";
  ls /proc/sys/fs/;

  echo "Creating ${ARCH} jail...";
  mkdir /workspace/.jail;

  echo "Creating debootstrap...";
  sudo debootstrap --foreign --no-check-gpg --include=fakeroot,build-essential --arch=${ARCH} ${UBUNTU_VERSION} /workspace/.jail ${QEMU_ARCHIVE}

  echo "Copying static qemu into jail...";
  sudo cp /usr/bin/qemu-${QEMU_ARCH}-static /workspace/.jail/usr/bin/

  echo "Switching into jail...";
  sudo chroot /workspace/.jail ./debootstrap/debootstrap --second-stage;

  echo "Setting environment variables...";
  echo "export LABEL=${LABEL}" >> env.sh;
  echo "export CROSS_TOOLCHAIN=${CROSS_TOOLCHAIN}" >> env.sh;
  echo "export ARCH=${ARCH}" >> env.sh;
  echo "export NPM_ARCH=${NPM_ARCH}" >> env.sh;
  echo "export GNU_TRIPLET=${GNU_TRIPLET}" >> env.sh;
  echo "export GNU_MULTILIB_TRIPLET=${GNU_MULTILIB_TRIPLET}" >> env.sh;
  echo "export GPP_COMPILER=${GPP_COMPILER}" >> env.sh;
  echo "export GCC_COMPILER=${GCC_COMPILER}" >> env.sh;
  echo "export VSCODE_ELECTRON_PLATFORM=${VSCODE_ELECTRON_PLATFORM}" >> env.sh;
  echo "export PACKAGE_ARCH=${PACKAGE_ARCH}" >> env.sh;
  echo "export QEMU_ARCH=${QEMU_ARCH}" >> env.sh;
  echo "export UBUNTU_VERSION=${UBUNTU_VERSION}" >> env.sh;
  echo "export HOME=/workspace" >> env.sh;

  echo "Updating jail APT...";  
  sudo chroot /workspace/.jail apt-get update;
  
  echo "Creating workspace...";
  sudo mkdir -p ${CHROOT_DIR}/workspace;

  echo "Copying files into jail...";
  sudo rsync -av ${TRAVIS_BUILD_DIR}/ ${CHROOT_DIR}/workspace;
  
else

  echo "Jail for ${QEMU_ARCH} has already been created.";
  
fi;

echo "Executing script ($1) in jail...";
sudo chroot /workspace/.jail bash -c "cd /workspace && $1";

# echo "Mounting binfmt_misc...";
# mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc;
  
# echo "Enabling binfmt_misc...";
# echo 1 > /proc/sys/fs/binfmt_misc/status;

# echo "Enabling ${QEMU_ARCH} emulator...";
# update-binfmts --enable qemu-${QEMU_ARCH};

