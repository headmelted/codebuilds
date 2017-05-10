#!/bin/bash

DOCKER_IMAGE=debian:latest;
docker pull ${DOCKER_IMAGE};
docker images;

echo "Exporting environment variables...";
echo $(printenv) > env.list;

echo "Making build script executable...";
chmod +x ./build.sh;

echo "Binding workspace...";
docker run -it -v ${TRAVIS_BUILD_DIR}:/workspace --env-file ./env.list ${DOCKER_IMAGE} /bin/bash -c /workspace/codebuilds-tools/build.sh;
