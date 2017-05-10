#!/bin/bash

DOCKER_IMAGE=debian:latest;
docker pull ${DOCKER_IMAGE};
docker images;

echo "Exporting environment variables...";
echo $(printenv) > env.list;

echo "Binding workspace...";
docker run -it -v /worspace:/workspace --env-file ./env.list ${DOCKER_IMAGE} /bin/bash -c /workspace/codebuilds-tools/build.sh;
