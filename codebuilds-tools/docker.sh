#!/bin/bash

docker pull debian/sid;
docker run -d -v $(pwd)/build.sh:/build.sh -p 127.0.0.1:80:4567 debian/sid /bin/bash -c "/build.sh;"