#!/bin/sh

echo "Installing bintray GPG key..."
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61;
echo "Done!"

echo "Installing headmelted GPG key..."
wget -qO - https://bintray.com/user/downloadSubjectPublicKey?username=headmelted | apt-key add -;
echo "Done!"

echo "Installing headmelted repository...";
echo "deb https://dl.bintray.com/headmelted/deb-code-oss wheezy main" > /etc/apt/sources.list.d/headmelted.list;
if [ $? -eq 0 ]; then
  echo "Repository install complete.";
else
  echo "Repository install failed.";
  exit 1;
fi;

echo "Updating APT cache..."
apt-get update;
echo "Done!"

echo "Installing Visual Studio Code...";
apt-get install -y code-oss;
if [ $? -eq 0 ]; then
  echo "Visual Studio Code install complete.";
else
  echo "Visual Studio Code install failed.";
  exit 1;
fi;

echo "Installing git...";
apt-get install -y git;
if [ $? -eq 0 ]; then
  echo "git install complete.";
else
  echo "git install failed.";
  exit 1;
fi;

echo "Installing any dependencies that may have been missed...";
apt-get install -y -f;
if [ $? -eq 0 ]; then
  echo "Missed dependency install complete.";
else
  echo "Missed dependency install failed.";
  exit 1;
fi;

echo "

Installation complete!

You can start code at any time by calling \"code-oss\" within a terminal.

A shortcut should also now be available in your desktop menus (depending on your distribution).

";

