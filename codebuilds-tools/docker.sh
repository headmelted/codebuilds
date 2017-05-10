#!/bin/bash

DOCKER_IMAGE=debian:latest;
docker pull ${DOCKER_IMAGE};
docker images;
chmod +x ${TRAVIS_BUILD_DIR}/codebuilds-tools/build.sh;
echo "Exporting environment variables...";
echo $(printenv) > env.list;
echo "Binding [${TRAVIS_BUILD_DIR}]...";
docker run -it -v ${TRAVIS_BUILD_DIR}:/workspace --env-file ./env.list ${DOCKER_IMAGE} cd /workspace && /bin/bash -c /workspace/codebuilds-tools/build.sh;
