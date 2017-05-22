#!/bin/bash
set -e;

echo "Listing workspace...";
ls .

. ./codebuilds-tools/environment.sh;
. ./codebuilds-tools/build.sh;
# . /workspace/codebuilds-tools/startxvfb.sh;

# if [ "${LABEL}" == "amd64_linux" ]; then
#   echo "Starting test...";
#   /workspace/scripts/test.sh;
# else
#   if [ "${LABEL}" == "armhf_linux" ]; then
#     echo "Starting emulated test...";
#     . /workspace/codebuilds-tools/emulate.sh "scripts/test.sh";
#   fi;
# fi;

# echo "Starting integration tests...";
# ./scripts/test-integration.sh;

. ./codebuilds-tools/package.sh;

# . /workspace/codebuilds-tools/flatpak/build.sh;

if [ "${LABEL}" == "armhf_linux" ]; then
  echo "Starting emulation for Raspberry Pi 2...";
  . /workspace/codebuilds-tools/emulate.sh "install_package_and_test.sh"; 
fi;
