#!/bin/bash
set -e;

echo "Listing workspace...";
ls .

. /workspace/codebuilds-tools/environment.sh;
. /workspace/codebuilds-tools/build.sh;
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

. /workspace/codebuilds-tools/package.sh;

# . /workspace/codebuilds-tools/flatpak/build.sh;
