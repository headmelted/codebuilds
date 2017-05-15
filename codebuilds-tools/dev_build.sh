#!/bin/bash
set -e;

sudo bash -c "export LABEL=amd64_linux ARCH=amd64 GPP_COMPILER=g++-4.9 GCC_COMPILER=gcc-4.9 VSCODE_ELECTRON_PLATFORM=x64 PACKAGE_ARCH=x64 && . ./codebuilds-tools/environment.sh && . ./codebuilds-tools/build.sh && . ./codebuilds-tools/package.sh && . ./codebuilds-tools/test.sh";
