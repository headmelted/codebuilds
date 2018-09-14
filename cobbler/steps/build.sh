#!/bin/bash
set -e;

echo "VS Code electron platform: $VSCODE_ELECTRON_PLATFORM";

echo "Current directory is [$(pwd)]";

yarn run gulp vscode-linux-${NPM_ARCH}-min;
