git pull origin master;
git fetch upstream master;
git merge upstream/master -s recursive -X ours;
git add .;
git commit -m "$1";
git tag -a `date +%Y%m%d%H%M%S` -m "Merging for +%Y%m%d%H%M%S";
git push origin master;
git push origin master --tags;
