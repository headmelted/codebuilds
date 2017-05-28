#!/bin/bash
set -e;

echo "Setting environment for $1...";
. ./codebuilds-tools/$1/env.sh;

if [ "${LABEL}" == "" ]; then
  echo "Failed to load environment: '$1'.  Check it exists.";
  return -1;
else
  echo "Environment [$1] loaded succesfully.";
fi;

. ./codebuilds-tools/environment.sh;
. ./codebuilds-tools/setup_nvm.sh;
. ./codebuilds-tools/build.sh;
. ./codebuilds-tools/startxvfb.sh;

if [ "${CROSS_TOOLCHAIN}" == "true" ]; then
  echo "Testing with emulation, using xvfb-run...";
  . ./codebuilds-tools/qemu.sh "scripts/test.sh";
else
  echo "Testing without emulation, using xvfb-run...";
  xvfb-run -a -e xvfb_log.txt .build/electron/code-oss ./test/index.js 
fi;

. ./codebuilds-tools/package.sh;


  # - if [ "${QEMU_ARCH}" != "" ]; then
  #     echo "Installing QEMU...";
  #     sudo apt-get install -y qemu-system-${QEMU_ARCH};
  #     . /workspace/codebuilds-tools/prepare_virtual_device.sh;
  #     . /workspace/codebuilds-tools/emulate.sh '/workspace/codebuilds-tools/install_package_and_test.sh';
  #   else
  #     . /workspace/codebuilds-tools/install_package_and_test.sh;
  #   fi

echo "Starting integration tests...";
./scripts/test-integration.sh;

# . /workspace/codebuilds-tools/flatpak/build.sh;
