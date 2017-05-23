#!/bin/bash
set -e;

echo "Installing deb...";
sudo dpkg -i $(find .build/linux -type f -name '*.deb');
    
echo "Detecting code-oss...";
which code-oss;
. ./codebuilds-tools/startxvfb.sh;
$(which code-oss) test/electron/index.js $@;
