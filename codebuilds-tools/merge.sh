#!/bin/bash
set -e;

cd /workspace;

echo "Decrypting merger_rsa.enc...";
openssl aes-256-cbc -K $encrypted_26b4962af0e7_key -iv $encrypted_26b4962af0e7_iv -in merger_rsa.enc -out /tmp/merger_rsa -d;

echo "Changing permissions of merger_rsa...";
chmod 600 /tmp/merger_rsa;

echo "Calling ssh-agent...";
eval "$(ssh-agent -s)";

echo "Calling ssh-add on decrypted key...";
ssh-add /tmp/merger_rsa;

echo "Setting git e-mail...";
git config --global user.email "${SSH_GIT_EMAIL}";

echo "Setting git user name...";
git config --global user.name "${SSH_GIT_USER}";

echo "Re-pointing origin for push over SSH...";
git remote set-url origin git@github.com:headmelted/codebuilds.git;

echo "Adding upstream...";
git remote add upstream https://github.com/Microsoft/vscode.git;

merge_tag_id=$(date +%Y%m%d%H%M%S);
echo "Merge tag is $merge_tag_id.";

echo "Fetching from origin...";
git fetch origin;

echo "Hard resetting to origin, to ensure no detachments prior to merge...";
git reset --hard origin/master;

echo "Fetching upstream...";
git fetch upstream master;

echo "Merging upstream onto origin with a preference of ours...";
git merge upstream/master -s recursive -X ours -m "Merging for $merge_tag_id.";

echo "Staging packaging changes...";
git add .;

echo "Committing changes...";
git commit -m "Committing merge for $merge_tag_id.";

echo "Tagging changes with $merge_tag_id...";
git tag -a "$merge_tag_id" -m "Tagging merge for $merge_tag_id.";

echo "Pushing changes back to origin...";
git push origin master;

echo "Pushing tags to origin...";
git push origin master --tags;
