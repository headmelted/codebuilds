#!/bin/bash

DOCKER_IMAGE=debian:latest;
docker pull ${DOCKER_IMAGE};
docker images;
chmod +x ${TRAVIS_BUILD_DIR}/codebuilds-tools/build.sh;
docker run -p -v ${TRAVIS_BUILD_DIR}:/codebuilds ${DOCKER_IMAGE} ls /codebuilds;
