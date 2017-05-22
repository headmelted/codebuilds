#!/bin/bash
set -e;
chmod 600 deploy-key;
mv deploy-key ~/.ssh/merge_rsa;
git remote add master git@github.com:headmelted/codebuilds.git;
git remote add upstream https://github.com/Microsoft/vscode.git;
. ./push.sh;
