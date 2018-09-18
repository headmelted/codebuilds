#!/bin/bash

# dock.sh
#
# Run the given script in the given container, passing in our
# environment variables.  THE BASH SCRIPT MUST BE A RELATIVE
# PATH.
#
# usage: dock.sh <docker_hub_image> <bash_script_to_run_in_container>

docker_image="headmelted/cobbler:$COBBLER_ARCH"

echo "Checking if $docker_image exists locally"
if [[ "$(docker images -q $docker_image 2> /dev/null)" != "" ]]; then
  echo "$docker_image does not exist locally, retrieving from hub"
  docker pull $docker_image;
fi

docker images; 

echo "Current directory is [$(pwd)]"

echo "Directory list:"
ls;

echo "Creating output directory (./output)";
mkdir output;

echo "------ HOST DETAILS ------";
lsb_release -a;
echo "--------------------------";

echo "Binding workspace and executing script";
docker run -it --security-opt apparmor:unconfined --cap-add SYS_ADMIN \
-e COBBLER_ARCH=$COBBLER_ARCH \
-e COBBLER_PACKAGES=$COBBLER_PACKAGES \
-e GITHUB_TOKEN=$GITHUB_TOKEN \
-e COBBLER_GIT_ENDPOINT=$COBBLER_GIT_ENDPOINT \
-e COBBLER_DEPENDENCY_PACKAGES=$COBBLER_DEPENDENCY_PACKAGES \
-e COBBLER_COMPILATION_METHOD="cross" \
-v $(pwd)/cobbler:/root/kitchen/cobbler \
-v $(pwd)/output:/root/kitchen/output \
headmelted/cobbler:$COBBLER_ARCH;
