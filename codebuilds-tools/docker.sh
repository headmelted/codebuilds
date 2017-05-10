#!/bin/bash

DOCKER_IMAGE=debian:latest;
docker pull ${DOCKER_IMAGE};
docker images;
chmod +x /workspace/codebuilds-tools/build.sh;

echo "Exporting environment variables...";
echo $(printenv) > env.list;

echo "Binding workspace...";
docker run -it -v /worspace:/workspace --env-file ./env.list ${DOCKER_IMAGE} /bin/bash "cd /workspace; ./codebuilds-tools/build.sh";
