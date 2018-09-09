#!/bin/bash
set -e;

echo "Starting vscode-linux-${NPM_ARCH}";
gulp "vscode-linux-${NPM_ARCH}";

echo "Starting vscode-linux-${NPM_ARCH}-build-deb";
yarn run gulp vscode-linux-${NPM_ARCH}-build-deb

echo "Starting vscode-linux-${NPM_ARCH}-build-rpm";
yarn run gulp "vscode-linux-${NPM_ARCH}-build-rpm";

echo "Starting vscode-linux-${NPM_ARCH}-flatpak";
yarn run gulp --verbose "vscode-linux-${NPM_ARCH}-flatpak";

echo "Tarring build folder for release";
tar -zcvf "../code-oss_${LABEL}.tar.gz" ../VSCode-linux-${NPM_ARCH};
