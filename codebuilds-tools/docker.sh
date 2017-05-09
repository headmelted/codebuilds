#!/bin/bash

DOCKER_IMAGE=debian/sid;
docker pull ${DOCKER_IMAGE};
docker run -d -v $(pwd)/build.sh:/build.sh -p 127.0.0.1:80:4567 ${DOCKER_IMAGE} /bin/bash -c "/build.sh;"
