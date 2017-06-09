#!/bin/bash

echo "Exporting display :99.0";
export DISPLAY=:99.0;

echo "Starting xvfb";
sh -e ./tools/xvfb start;

echo "Waiting 10 seconds for xvfb to start up";
sleep 10;
    
echo "code-oss header: [$(file -h .vscode/.build/electron/code-oss)]";
    
# echo "LD_LIBRARY_PATH: ($LD_LIBRARY_PATH)";
# export LD_LIBRARY_PATH;
# ldconfig;
# echo "Searching for troublesome linked libraries";
# updatedb;
# echo "Searching for ld-linux-armhf.so.3";
# echo $(locate ld-linux-armhf.so.3);
# echo "Searching for libstdc++.so.6";
# echo $(locate libstdc++.so.6);
# echo "Searching for libpthread.so.0";
# echo $(locate libpthread.so.0);
    
echo "Running tests";
./scripts/test.sh;

echo "Running integration tests";
./scripts/test-integration.sh;
    
echo "Stopping xvfb";
sh -e ./tools/xvfb stop;
