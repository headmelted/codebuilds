#!/bin/bash
set -e;
git pull origin master;
git fetch upstream master;
git merge upstream/master -s recursive -X ours;
git add .;
git commit -m "$1";
git push origin master;
git push origin master --tags;
