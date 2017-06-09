#!/bin/bash
set -e;

echo "Creating .cache folder if it does not exist";
if [[ ! -d ../.cache ]]; then mkdir ../.cache; fi

echo "Setting environment for $1";
. ./tools/env/$1.sh;

echo "Checking presence of NVM";
. ./tools/env/setup_nvm.sh;

export BUILDS=.builds/$1;
export ROOT_DIRECTORY=$(pwd);
export VSCODE_DIRECTORY=$ROOT_DIRECTORY/$BUILDS/.vscode;

echo "Creating .builds folders if they do not exist";
if [[ ! -d .builds ]]; then mkdir .builds; fi;
if [[ ! -d $BUILDS ]]; then mkdir $BUILDS; fi;
if [[ ! -d $VSCODE_DIRECTORY ]]; then mkdir $VSCODE_DIRECTORY; fi;

echo "Preparing recipe";
for i in "${@:2}"; do
  echo "Entering vscode directory [$VSCODE_DIRECTORY]";
  cd $VSCODE_DIRECTORY;
  echo "Executing step [$i]";
  . ../../../tools/$i.sh;
  echo "Returning to root directory [$ROOT_DIRECTORY]";
  cd $ROOT_DIRECTORY;
done

echo "All steps complete";
