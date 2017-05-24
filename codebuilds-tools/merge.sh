#!/bin/bash
set -e;
cd /workspace;
openssl aes-256-cbc -K $encrypted_26b4962af0e7_key -iv $encrypted_26b4962af0e7_iv -in merger_rsa.enc -out merger_rsa -d;
chmod 600 merger_rsa;
mv merger_rsa ~/.ssh/merge_rsa;
git remote add master git@github.com:headmelted/codebuilds.git;
git remote add upstream https://github.com/Microsoft/vscode.git;
merge_tag_id=$(date +%Y%m%d%H%M%S);
git pull origin master;
git fetch upstream master;
git merge upstream/master -s recursive -X ours;
git add .;
git commit -m "Merging for $merge_tag_id";
git tag -a "$merge_tag_id" -m "Merging for $merge_tag_id";
git push origin master;
git push origin master --tags;

