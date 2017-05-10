#!/bin/bash

DOCKER_IMAGE=debian:unstable;
docker pull ${DOCKER_IMAGE};
docker images;

echo "Exporting environment variables...";

echo "Making build script executable...";
chmod +x ${TRAVIS_BUILD_DIR}/codebuilds-tools/build.sh;

echo "Binding workspace...";
docker run -it --cap-add SYS_ADMIN -v ${TRAVIS_BUILD_DIR}:/workspace \
    -e "LABEL=${LABEL}" \
    -e "CROSS_TOOLCHAIN=${CROSS_TOOLCHAIN}" \
    -e "ARCH=${ARCH}" \
    -e "NPM_ARCH=${NPM_ARCH}" \
    -e "GNU_TRIPLET=${GNU_TRIPLET}" \
    -e "GNU_MULTILIB_TRIPLET=${GNU_MULTILIB_TRIPLET}" \
    -e "GPP_COMPILER=${GPP_COMPILER}" \
    -e "GCC_COMPILER=${GCC_COMPILER}" \
    -e "VSCODE_ELECTRON_PLATFORM=${VSCODE_ELECTRON_PLATFORM}" \
    -e "PACKAGE_ARCH=${PACKAGE_ARCH}" \
    -e "QEMU_ARCH=${QEMU_ARCH}" \
     ${DOCKER_IMAGE} /bin/bash -c /workspace/codebuilds-tools/build.sh;
