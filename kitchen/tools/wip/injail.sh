#!/bin/bash

if [ ! -d ./.work/jails/$LABEL/dev ]; then
  echo "Removing existing /dev links";
  rm -rf ./.work/jails/$LABEL/dev;
  echo "Hard-linking /dev for jail $LABEL";
  cp -alf /dev ./.work/jails/$LABEL/dev;
fi;

if [ ! -d ./.work/jails/$LABEL/proc ]; then
  echo "Removing existing /proc links";
  rm -rf ./.work/jails/$LABEL/proc;
  echo "Hard-linking /proc for jail $LABEL";
  cp -alf /proc ./.work/jails/$LABEL/proc;
  read -p "Press enter to continue";
fi;

echo "Entering jail ./.work/jails/$LABEL";
chroot ./.work/jails/$LABEL /bin/bash -c "
  
  echo 'Switching into home directory';
  cd /home/root;
  
  echo 'Setting environment to $LABEL';
  . ./tools/$LABEL/env.sh;
  
  $1

";

if [ ! -d ./.work/jails/$LABEL/dev ]; then
  echo "Removing /dev links";
  rm -rf ./.work/jails/$LABEL/dev
fi;

if [ ! -d ./.work/jails/$LABEL/proc ]; then
  echo "Removing /proc links";
  rm -rf ./.work/jails/$LABEL/proc
fi;
