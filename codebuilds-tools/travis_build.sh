#!/bin/bash
set -e;

cd /;

echo "Listing workspace...";
ls .

. /workspace/codebuilds-tools/environment.sh;
. /workspace/codebuilds-tools/build.sh
if [[ "${LABEL}" == "amd64_linux" ]]; then
  . /workspace/codebuilds-tools/prepare_tests.sh;
  echo "Starting test...";
  /workspace/scripts/test.sh;
fi;

# echo "Starting integration tests...";
# ./scripts/test-integration.sh;

. /workspace/codebuilds-tools/package.sh;
