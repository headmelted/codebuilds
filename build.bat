docker pull headmelted/cobbler
docker run -it --security-opt apparmor:unconfined --cap-add SYS_ADMIN -v %cd%/cobbler:/cobbler headmelted/cobbler /bin/bash -c "cd /kitchen && export COBBLER_GIT_ENDPOINT=""https://github.com/Microsoft/vscode.git\""; steps/cook.sh armhf get patch build package";
