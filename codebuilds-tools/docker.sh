#!/bin/bash

DOCKER_IMAGE=debian:latest;
docker pull ${DOCKER_IMAGE};
docker images;
chmod +x ${TRAVIS_BUILD_DIR}/codebuilds-tools/build.sh;
echo "Binding [${TRAVIS_BUILD_DIR}]...";
docker run -it -v ${TRAVIS_BUILD_DIR}:/workspace ${DOCKER_IMAGE} /bin/bash -c /workspace/codebuilds-tools/build.sh;
