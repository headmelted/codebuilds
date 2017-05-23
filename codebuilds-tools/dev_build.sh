#!/bin/bash
set -e;

command_list="export LABEL=amd64_linux ARCH=amd64 GPP_COMPILER=g++ GCC_COMPILER=gcc VSCODE_ELECTRON_PLATFORM=x64 PACKAGE_ARCH=x64"

for var in "$@"
do
    command_list="$command_list && . /workspace/codebuilds-tools/$var.sh";
done

echo "Executing command as sudo:";
echo "$command_list";

sudo bash -c "$command_list";
