#!/bin/bash

# dock.sh
#
# Run the given script in the loaded container, passing in our
# environment variables, and send any output from the step to the specified output
# directory.  THE BASH SCRIPT MUST BE IN THE /cobbler PATH.
#
# usage: dock.sh <docker_hub_image> <output_artifacts_directory>

docker_image="headmelted/cobbler:$COBBLER_STRATEGY-$COBBLER_ARCH"

echo "Checking if $docker_image exists locally"
if [[ "$(docker images -q $docker_image 2> /dev/null)" != "" ]]; then
  echo "$docker_image does not exist locally, retrieving from hub"
  docker pull $docker_image;
fi;

echo $(pwd);
tree $(pwd);

echo "Binding workspace and executing script";
docker run -it \
--security-opt apparmor:unconfined --cap-add SYS_ADMIN \ # Run the container unconfined and with CAP_SYS_ADMIN, for bind mounts
-e GITHUB_TOKEN=$GITHUB_TOKEN \
-e COBBLER_GIT_ENDPOINT=$COBBLER_GIT_ENDPOINT \
-e COBBLER_SCRIPT=$COBBLER_SCRIPT \
-v $(pwd)/cobbler:/root/cobbler \
-v $1:/root/output \
$docker_image;
