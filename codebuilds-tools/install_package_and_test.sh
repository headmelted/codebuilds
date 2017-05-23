#!/bin/bash
set -e;

export TRAVIS_BUILD_DIR=/workspace;

echo "Installing deb...";
sudo dpkg -i $(find .build/linux -type f -name '*.deb');
    
echo "Detecting code-oss...";
which code-oss;

echo "Calling startxvfb.sh...";
sudo bash -c "${TRAVIS_BUILD_DIR}/codebuilds-tools/startxvfb.sh";

echo "Calling test script...";
bash -c "${TRAVIS_BUILD_DIR}/scripts/test.sh";
