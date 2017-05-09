#!/bin/bash

DOCKER_IMAGE=debian;
docker pull ${DOCKER_IMAGE};
docker run -d -v $(pwd)/build.sh:/build.sh -p 127.0.0.1:80:4567 ${DOCKER_IMAGE} /bin/bash -c "${TRAVIS_BUILD_DIR}/codebuilds-tools/build.sh"
