#!/bin/bash

DOCKER_IMAGE=debian;
docker pull ${DOCKER_IMAGE}:latest;
docker images;
chmod +x ${TRAVIS_BUILD_DIR}/codebuilds-tools/build.sh;
docker run -v ${TRAVIS_BUILD_DIR} -d ${DOCKER_IMAGE} echo "yo";
