#!/bin/bash

echo "Retrieving proot";
wget https://github.com/proot-me/proot-static-build/raw/master/static/proot-x86_64;

echo "Marking proot as executable";
chmod +x proot-x86_64;

echo "Moving proot to local usr bin";
mv proot-x86_64 /usr/local/bin/proot;
