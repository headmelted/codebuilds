#!/bin/sh

echo "Detecting architecture...";
MACHINE_MTYPE="$(uname -m)";
ARCH="${MACHINE_MTYPE}";
REPOSITORY_NAME="headmelted";

echo "Ensuring curl is installed";
apt-get install -y curl;

if [ "$COBBLER_ARCH" = "amd64" ]; then REPOSITORY_NAME="microsoft"; fi;

echo "Architecture detected as $COBBLER_ARCH...";

if [ "${REPOSITORY_NAME}" = "headmelted" ]; then

  curl -s https://packagecloud.io/install/repositories/headmelted/codebuilds/script.deb.sh | sudo bash;
  
else

  gpg_key=https://packages.microsoft.com/keys/microsoft.asc;
  
  echo "Retrieving GPG key [${REPOSITORY_NAME}] ($gpg_key)...";
  curl $gpg_key | gpg --dearmor > ${REPOSITORY_NAME}.gpg;
  
  echo "Installing $REPOSITORY_NAME GPG key...";
  mv ${REPOSITORY_NAME}.gpg /etc/apt/trusted.gpg.d/${REPOSITORY_NAME}.gpg;
  
  echo "Installing ${REPOSITORY_NAME} repository...";
  echo "deb https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list;
  
  echo "Updating APT cache..."
  apt-get update -yq;
  echo "Done!"

fi;

if [ $? -eq 0 ]; then
  echo "Repository install complete.";
else
  echo "Repository install failed.";
  exit 1;
fi;

echo "Installing Visual Studio Code...";

CODE_EXECUTABLE_NAME="";
if [ "${REPOSITORY_NAME}" = "headmelted" ]; then
  CODE_EXECUTABLE_NAME="code-oss";
else
  CODE_EXECUTABLE_NAME="code-insiders";
fi;

apt-get install -y libxss1 ${CODE_EXECUTABLE_NAME};

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

You can start code at any time by calling \"${CODE_EXECUTABLE_NAME}\" within a terminal.

A shortcut should also now be available in your desktop menus (depending on your distribution).

";

