#!/bin/bash

echo "Checking if jail exists for $LABEL";
if [ ! -d "./.work/jails/$LABEL" ]; then

  echo "Jail does NOT exist for $LABEL";
  
  if [ ! -d ".work" ]; then
    echo "Working folder does not exist, creating";
    mkdir .work;
  fi;
  
  if [ ! -d ".work/jails" ]; then
    echo "Jails folder does not exist, creating";
    mkdir .work/jails;
  fi;

  echo "Creating $LABEL jail"
  mkdir ./.work/jails/$LABEL;

  echo "Downloading $JAIL_ROOTFS";
  wget -qO- "$JAIL_ROOTFS" | (tar xz -C ./.work/jails/$LABEL || true);
  
  echo "Creating home directory for root user";
  mkdir ./.work/jails/$LABEL/home/root;
  
  echo 'Setting /tmp permissions for jail';
  chmod 1777 ./.work/jails/$LABEL/tmp;
  
  echo "Inserting custom xvfb into /etc/init.d";
  cp -f ./tools/xvfb ./.work/jails/$LABEL/etc/init.d/xvfb;

  echo "Remove tools from jail if they exist (so we are using the latest version)";
  rm -rf ./.work/jails/$LABEL/home/root/tools;
  
  echo "Copying latest tools into jail"
  cp -avr ./tools ./.work/jails/$LABEL/home/root;
  
  echo "Removing old nvm if it exists";
  rm -rf ./.work/jails/$LABEL/home/root/.nvm;
  
  echo "Retrieving vscode from Github";
  git clone https://github.com/Microsoft/vscode.git ./.work/jails/$LABEL/home/root/vscode;

  echo "Installing nvm into vscode";
  git clone --depth 1 https://github.com/creationix/nvm.git ./.work/jails/$LABEL/home/root/vscode/.nvm;
  
  echo "Checking if cross-toolchain";
  if [ "${CROSS_TOOLCHAIN}" == "true" ]; then
  
      echo "Copying static qemu into jail";
      cp /usr/bin/qemu-${QEMU_ARCH}-static ./.work/jails/$LABEL/usr/bin/;
      
      echo "Enabling ${QEMU_ARCH} binfmt support";
      chroot ./.work/jails/$LABEL /usr/bin/qemu-${QEMU_ARCH}-static update-binfmts --enable qemu-${QEMU_ARCH};
      
  fi;
  
  . ./tools/injail.sh '
  
    echo "Setting public DNS for jail (8.8.4.4)";
    echo "nameserver 8.8.4.4" > /etc/resolv.conf;
  
    echo "Installing dependencies into jail";
    . ./tools/environment.sh;
  
  ';
  
else

  echo "Jail exists already for $LABEL";

  echo "Remove tools from jail (so we can use the latest version)";
  rm -rf ./.work/jails/$LABEL/home/root/tools;
  
  echo "Copying latest tools into jail"
  cp -avr ./tools ./.work/jails/$LABEL/home/root;

fi;
