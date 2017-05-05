#!/bin/bash

echo "Installing pre-requisites...";
sudo apt-get install -y xvfb yum;

echo "Inserting custom xvfb into /etc/init.d...";
sudo mv -f /codebuilds-tools/xvfb /etc/init.d/xvfb;
echo "Starting xvfb...";
sh -e /etc/init.d/xvfb start;
echo "Waiting 10 seconds for xvfb to start up...";
sleep 10;
echo "Exporting display :99...";
DISPLAY=:99;
echo "Launcing dbus...";
dbus-launch;

# Code to install, test and then remove debian package.
echo "Retrieving deb package...";
DEB_PACKAGE=${/deb/*.deb};
echo "Using dpkg to install ${DEB_PACKAGE}...";
sudo dpkg -i ${DEB_PACKAGE};
#echo "Installing missing dependencies for ${DEB_PACKAGE}...";
#sudo apt-get -f install;
echo "Listing contents of proot \/...";
ls /;
echo "Running tests...";
/scripts/test.sh;
echo "Removing deb package...";
dpkg --remove code-oss;

# # Code to install, test and then remove rpm package.
# echo "Retrieving rpm package...";
# DEB_PACKAGE=${/rpm/*.rpm};
# echo "Using yum to install ${RPM_PACKAGE}...";
# sudo dpkg -i ${DEB_PACKAGE};
# #echo "Installing missing dependencies for ${DEB_PACKAGE}...";
# #sudo apt-get -f install;
# echo "Listing contents of proot \/...";
# ls /;
# echo "Running tests...";
# /scripts/test.sh;
# echo "Removing rpm package...";
# yum remove code-oss;

