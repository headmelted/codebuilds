#!/bin/bash
set -e;

echo "Backing up TRAVIS_BUILD_DIR...";
BACKUP_TRAVIS_BUILD_DIR=${TRAVIS_BUILD_DIR};

echo "Overwriting TRAVIS_BUILD_DIR...";
TRAVIS_BUILD_DIR=/workspace;

echo "Calling script...";
. ${TRAVIS_BUILD_DIR}/codebuilds-tools/install_package_and_test.sh;

echo "Restoring TRAVIS_BUILD_DIR...";
TRAVIS_BUILD_DIR=${BACKUP_TRAVIS_BUILD_DIR};
