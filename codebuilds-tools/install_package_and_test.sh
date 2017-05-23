#!/bin/bash
set -e;

echo "Setting up nvm for tests...";
. /workspace/codebuilds-tools/setup_nvm.sh;

echo "Installing deb...";
sudo dpkg -i $(find .build/linux -type f -name '*.deb');
    
echo "Detecting code-oss...";
which code-oss;

echo "Calling startxvfb.sh...";
sudo bash -c "/workspace/codebuilds-tools/startxvfb.sh";

echo "Calling test script...";
xvfb-run /usr/bin/code-oss test/electron/index.js;
