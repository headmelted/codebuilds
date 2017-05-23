#!/bin/bash
set -e;

echo "Installing deb...";
sudo dpkg -i $(find .build/linux -type f -name '*.deb');
    
echo "Detecting code-oss...";
which code-oss;

echo "Calling startxvfb.sh...";
sudo bash -c "${TRAVIS_BUILD_DIR}/codebuilds-tools/startxvfb.sh";
$(which code-oss) test/electron/index.js $@;
