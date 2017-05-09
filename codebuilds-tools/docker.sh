#!/bin/bash

DOCKER_IMAGE=debian:latest;
docker pull ${DOCKER_IMAGE};
docker images;
chmod +x ${TRAVIS_BUILD_DIR}/codebuilds-tools/build.sh;
docker cp ${TRAVIS_BUILD_DIR}/codebuilds ${DOCKER_IMAGE}:/codebuilds;
docker run -i -t ${DOCKER_IMAGE} ls /codebuilds;
