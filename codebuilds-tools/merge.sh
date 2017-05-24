#!/bin/bash
set -e;

cd /workspace;

echo "Decrypting merger_rsa.enc...";
openssl aes-256-cbc -K $encrypted_26b4962af0e7_key -iv $encrypted_26b4962af0e7_iv -in merger_rsa.enc -out merger_rsa -d;

echo "Changing permissions of merger_rsa...";
chmod 600 merger_rsa;

echo "Moving merger_rsa to ~/.ssh/merger_rsa...";
mv merger_rsa ~/.ssh/merger_rsa;

# echo "Adding origin...";
# git remote add origin git@github.com:headmelted/codebuilds.git;

echo "Adding upstream...";
git remote add upstream https://github.com/Microsoft/vscode.git;

merge_tag_id=$(date +%Y%m%d%H%M%S);
echo "Merge tag is $merge_tag_id.";

echo "Pulling from origin...";
git pull origin master;

echo "Fetching upstream...";
git fetch upstream master;

echo "Merging upstream onto origin with a preference of ours...";
git merge upstream/master -s recursive -X ours -m "Merging for $merge_tag_id.";

echo "Staging packaging changes...";
git add /workspace/docs/packages;

echo "Committing changes...";
git commit -m "Committing merge for $merge_tag_id.";

echo "Tagging changes with $merge_tag_id...";
git tag -a "$merge_tag_id" -m "Tagging merge for $merge_tag_id.";

echo "Pushing changes back to origin...";
git push origin master;

echo "Pushing tags to origin...";
git push origin master --tags;

