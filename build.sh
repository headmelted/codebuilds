#!/bin/bash
set -e;

echo "/usr/lib/${ARCHIE_GNU_TRIPLET} ------------------";
ls /usr/lib/${ARCHIE_GNU_TRIPLET};
echo "/usr/lib/${ARCHIE_GNU_TRIPLET}/pkgconfig --------";
ls /usr/lib/${ARCHIE_GNU_TRIPLET}/pkgconfig;
echo "pkg-config search path --------------------------";
pkg-config --variable pc_path pkg-config;

echo "Reading pkgconfig"
pkg-config --libs-only-l libsecret-1;

echo "Current directory is:";
pwd;

echo "Directory contents:";
echo "-------------------";
ls;
echo "-------------------";

echo "Retrieving latest Visual Studio Code sources into [code]";
git clone "https://github.com/Microsoft/vscode.git" code;
  
echo "Setting current owner as owner of code folder";
chown ${USER:=$(/usr/bin/id -run)}:$USER -R code;

echo "Synchronizing overlays folder";
rsync -avh ./overlays/ ./code/;

echo "Installing NVM and dependencies";
. /root/kitchen/tools/setup_nvm.sh;

echo "Entering code directory";
cd code;

echo "Executing yarn"
yarn

echo "Executing electron-$ARCHIE_ELECTRON_ARCH"
yarn --verbose gulp electron-${ARCHIE_ELECTRON_ARCH}

echo "Executing monaco-compile-check"
yarn --verbose monaco-compile-check

echo "Executing strict-null-check"
yarn --verbose strict-null-check

echo "Executing compile"
yarn --verbose compile

echo "Executing download-builtin-extensions"
yarn --verbose download-builtin-extensions

echo "Compiling VS Code for $npm_config_arch";
yarn run gulp vscode-linux-$npm_config_arch-min;

echo "Starting vscode-linux-$npm_config_arch-build-deb";
yarn run gulp vscode-linux-$npm_config_arch-build-deb;

echo "Leaving code directory";
cd ..;

echo "Creating output directory";
mkdir output;

echo "Moving deb packages for release";
mv ./code/.build/linux/deb/$ARCHIE_ARCH/deb/*.deb /root/output;

echo "Extracting deb archive";
dpkg -x /root/output/*.deb output/extracted;

cd output/extracted;

echo "Binary components of output --------------------------------------------------"
find . -type f -exec file {} ";" | grep ELF
echo "------------------------------------------------------------------------------"
