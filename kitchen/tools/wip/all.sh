#!/bin/bash

# Error trap in case of failure in this or imported scripts.
error() {
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    echo "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    echo "Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi
  
  echo "Stopping xvfb if it's running";
  sh -e ./tools/xvfb stop;
  
  exit "${code}"
}
trap 'error ${LINENO}' ERR;

echo "Current path is";
echo $(pwd);

echo "Building latest vscode";
. ./tools/get_patch_build.sh;

# echo "Current path is";
# echo $(pwd);

# echo "Preparing virtual device for testing";
# . ./tools/prepare_virtual_device.sh;

# echo "Starting emulator";
# . ./tools/emulate.sh;

# echo "Testing build";
# . ./tools/testbuild.sh;

