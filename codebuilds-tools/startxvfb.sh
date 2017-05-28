#!/bin/bash
set -e;

# echo "Inserting custom xvfb into /etc/init.d...";
# sudo mv -f ./codebuilds-tools/xvfb /etc/init.d/xvfb;

echo "Exporting display :99.0...";
export DISPLAY=:99.0;

echo "Starting xvfb...";
sudo sh -e /etc/init.d/xvfb start;

echo "Waiting 10 seconds for xvfb to start up...";
sleep 10;
