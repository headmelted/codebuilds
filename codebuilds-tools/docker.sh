#!/bin/bash

DOCKER_IMAGE=debian;
docker pull ${DOCKER_IMAGE};
docker ps;
docker run -d -v ${TRAVIS_BUILD_DIR}/codebuilds-tools/build.sh:/build.sh -p 127.0.0.1:80:4567 ${DOCKER_IMAGE} /bin/bash -c "/build.sh";

