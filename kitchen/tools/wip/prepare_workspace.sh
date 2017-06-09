#!/bin/bash

echo "Passed label [$1]";
if [ "$1" == "" ]; then LABEL="amd64_linux"; else LABEL=$1; fi;

echo "Setting environment for $LABEL";
. ./tools/env/$LABEL.sh;

export CXX="${GPP_COMPILER}" CC="${GCC_COMPILER}" DEBIAN_FRONTEND="noninteractive";
echo "C compiler is ${CC}, C++ compiler is ${CXX}."
    
echo "Installing dependencies";
. ./tools/environment.sh;

if [ "${LABEL}" == "" ]; then
  echo "Failed to load environment: '$1'.  Check it exists.";
  return -1;
else
  echo "Environment [$1] loaded succesfully.";
fi;

echo "Installing nvm for user";
. ./tools/setup_nvm.sh;
