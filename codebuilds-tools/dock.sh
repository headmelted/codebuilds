#!/bin/bash

# dock.sh
#
# Run the given script in the given container, passing in our
# environment variables.  THE BASH SCRIPT MUST BE A RELATIVE
# PATH.
#
# usage: dock.sh <docker_hub_image> <bash_script_to_run_in_container>

docker pull "$1";
docker images;

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
    -e "UBUNTU_VERSION=${UBUNTU_VERSION}" \
    -e "HOME=/workspace" \
     $1 /bin/bash -c "ls /workspace/codebuilds-tools";
