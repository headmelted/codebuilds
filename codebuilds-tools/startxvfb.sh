#!/bin/bash
set -e;

# echo "Inserting custom xvfb into /etc/init.d...";
# mv -f /workspace/codebuilds-tools/xvfb /etc/init.d/xvfb;

echo "Exporting display :99.0...";
export DISPLAY=:99.0;

echo "Starting xvfb...";
sh -e /etc/init.d/xvfb start;

echo "Waiting 10 seconds for xvfb to start up...";
sleep 10;
