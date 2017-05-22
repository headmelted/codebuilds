#!/bin/bash
set -e;
git pull origin master;
git fetch upstream master;
git merge upstream/master -s recursive -X ours;
git add .;
git commit -m "Merging for $merge_tag_id";
git tag -a `$merge_tag_id` -m "Merging for $merge_tag_id";
git push origin master;
git push origin master --tags;
