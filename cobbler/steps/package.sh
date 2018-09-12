#!/bin/bash
set -e;

echo "Starting vscode-linux-${NPM_ARCH}";
gulp "vscode-linux-${NPM_ARCH}";

echo "Starting vscode-linux-${NPM_ARCH}-build-deb";
yarn run gulp vscode-linux-${NPM_ARCH}-build-deb;

echo "Moving deb packages for release";
mv /kitchen/.builds/${ARCH}/.code/.build/linux/deb/${ARCH}/deb/*.deb /cooked;

echo "Starting vscode-linux-${NPM_ARCH}-build-rpm";
yarn run gulp "vscode-linux-${NPM_ARCH}-build-rpm";

echo "Moving rpm packages for release";
mv /kitchen/.builds/${ARCH}/.code/.build/linux/rpm/${RPM_ARCH}/rpmbuild/RPMS/${RPM_ARCH}/*.rpm /cooked;

# echo "Tarring build folder for release";
# tar -zcvf "/cobbler/.output/code-oss_${LABEL}.tar.gz" /kitchen/.builds/VSCode-linux-${NPM_ARCH};

echo "Listing output packages";
ls /cooked;
