#!/bin/bash
set -e;

. ./codebuilds-tools/environment.sh;
. ./codebuilds-tools/build.sh
if [[ "${LABEL}" == "amd64_linux" ]]; then
  . ./codebuilds-tools/prepare_tests.sh;
  echo "Starting test...";
  ./scripts/test.sh;
fi;

# echo "Starting integration tests...";
# ./scripts/test-integration.sh;

. ./codebuilds-tools/package.sh;
