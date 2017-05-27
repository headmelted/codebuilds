#!/bin/bash
set -e;

. ./codebuilds-tools/environment.sh $1;
. ./codebuilds-tools/setup_nvm.sh;
. ./codebuilds-tools/build.sh;
. ./codebuilds-tools/startxvfb.sh;

if [ "${CROSS_TOOLCHAIN}" == "true" ]; then
  ./codebuilds-tools/qemu.sh "codebuilds-tools/test-in-qemu.sh";
else
  sudo bash -c ". /workspace/codebuilds-tools/install_package_and_test.sh";
fi;

. ./codebuilds-tools/package.sh;

# . /workspace/codebuilds-tools/startxvfb.sh;


  # - if [ "${QEMU_ARCH}" != "" ]; then
  #     echo "Installing QEMU...";
  #     sudo apt-get install -y qemu-system-${QEMU_ARCH};
  #     . /workspace/codebuilds-tools/prepare_virtual_device.sh;
  #     . /workspace/codebuilds-tools/emulate.sh '/workspace/codebuilds-tools/install_package_and_test.sh';
  #   else
  #     . /workspace/codebuilds-tools/install_package_and_test.sh;
  #   fi

# echo "Starting integration tests...";
# ./scripts/test-integration.sh;

# . /workspace/codebuilds-tools/flatpak/build.sh;
