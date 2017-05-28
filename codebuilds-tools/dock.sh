#!/bin/bash

# dock.sh
#
# Run the given script in the given container, passing in our
# environment variables.  THE BASH SCRIPT MUST BE A RELATIVE
# PATH.
#
# usage: dock.sh <docker_hub_image> <bash_script_to_run_in_container>

docker pull "$1";
docker images;

echo "Binding workspace...";
docker run -it --cap-add SYS_ADMIN -v /workspace:/workspace 
    -e "HOME=/workspace" \
     $1 /bin/bash -c "cd /workspace && ${2}";
