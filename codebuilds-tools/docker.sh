#!/bin/bash

DOCKER_IMAGE=debian:latest;
docker pull ${DOCKER_IMAGE};
docker images;
chmod +x ${TRAVIS_BUILD_DIR}/codebuilds-tools/build.sh;
echo "Binding [${TRAVIS_BUILD_DIR}]...";
cd ..;
docker run -v codebuilds:/codebuilds -i -t ${DOCKER_IMAGE} /bin/bash -c "ls /codebuilds";
