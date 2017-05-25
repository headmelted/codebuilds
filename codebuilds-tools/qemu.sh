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
  sudo debootstrap --foreign --no-check-gpg --include=fakeroot,build-essential --arch=${ARCH} jessie /workspace/.jail ${QEMU_ARCHIVE}

  echo "Copying static qemu into jail...";
  sudo cp /usr/bin/qemu-${QEMU_ARCH}-static /workspace/.jail/usr/bin/

  echo "Switching into jail...";
  sudo chroot /workspace/.jail ./debootstrap/debootstrap --second-stage;
  
  echo "Creating workspace...";
  sudo mkdir -p /workspace/.jail/workspace;

  echo "Copying files into jail...";
  sudo rsync -av /workspace /workspace/.jail/workspace;

  echo "Updating jail APT...";  
  sudo chroot /workspace/.jail apt-get update;
  
else

  echo "Jail for ${QEMU_ARCH} has already been created.";
  
fi;

echo "Setting environment variables...";
echo "export LABEL=${LABEL}" >> /workspace/.jail/workspace/.env.sh;
echo "export CROSS_TOOLCHAIN=${CROSS_TOOLCHAIN}" >> /workspace/.jail/workspace/.env.sh;
echo "export ARCH=${ARCH}" >> /workspace/.jail/workspace/.env.sh;
echo "export NPM_ARCH=${NPM_ARCH}" >> /workspace/.jail/workspace/.env.sh;
echo "export GNU_TRIPLET=${GNU_TRIPLET}" >> /workspace/.jail/workspace/.env.sh;
echo "export GNU_MULTILIB_TRIPLET=${GNU_MULTILIB_TRIPLET}" >> /workspace/.jail/workspace/.env.sh;
echo "export GPP_COMPILER=${GPP_COMPILER}" >> /workspace/.jail/workspace/.env.sh;
echo "export GCC_COMPILER=${GCC_COMPILER}" >> /workspace/.jail/workspace/.env.sh;
echo "export VSCODE_ELECTRON_PLATFORM=${VSCODE_ELECTRON_PLATFORM}" >> /workspace/.jail/workspace/.env.sh;
echo "export PACKAGE_ARCH=${PACKAGE_ARCH}" >> /workspace/.jail/workspace/.env.sh;
echo "export QEMU_ARCH=${QEMU_ARCH}" >> /workspace/.jail/workspace/.env.sh;
echo "export UBUNTU_VERSION=${UBUNTU_VERSION}" >> /workspace/.jail/workspace/.env.sh;
echo "export HOME=/workspace" >> /workspace/.jail/workspace/.env.sh;
chmod a+x /workspace/.jail/workspace/.env.sh;

echo "Executing script ($1) in jail...";
sudo chroot /workspace/.jail bash -c "cd /workspace && . ./.env.sh && $1";

# echo "Mounting binfmt_misc...";
# mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc;
  
# echo "Enabling binfmt_misc...";
# echo 1 > /proc/sys/fs/binfmt_misc/status;

# echo "Enabling ${QEMU_ARCH} emulator...";
# update-binfmts --enable qemu-${QEMU_ARCH};

