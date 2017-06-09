#!/bin/bash

echo "Temporarily exiting vscode directory to replace it";
cd ..;

echo "Remove .vscode folder if it exists"
rm -rf $VSCODE_DIRECTORY;

echo "Creating .vscode folder";
mkdir $VSCODE_DIRECTORY;

echo "Retrieving vscode from Github";
git clone https://github.com/Microsoft/vscode.git $VSCODE_DIRECTORY;
  
echo "Setting current owner as owner of vscode folder";
chown ${USER:=$(/usr/bin/id -run)}:$USER -R $VSCODE_DIRECTORY;

echo "Entering vscode directory";
cd $VSCODE_DIRECTORY;