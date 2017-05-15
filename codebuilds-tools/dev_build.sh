#!/bin/bash
set -e;

sudo bash -c "export GPP_COMPILER=\"g++-4.9\" GCC_COMPILER=\"gcc-4.9\" && . ./codebuilds-tools/environment.sh && . ./codebuilds-tools/build.sh;";
