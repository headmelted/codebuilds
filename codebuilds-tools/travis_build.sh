#!/bin/bash
set -e;

. ./environment.sh;
. ./build.sh
if [[ "${LABEL}" == "amd64_linux" ]]; then
  . ./prepare_tests.sh;
  echo "Starting test...";
  ../scripts/test.sh;
fi;

# echo "Starting integration tests...";
# ./scripts/test-integration.sh;

. ./package.sh;
