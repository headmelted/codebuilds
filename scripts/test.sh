#!/bin/bash

echo "Executing test script...";

if [[ "$OSTYPE" == "darwin"* ]]; then
	realpath() { [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"; }
	ROOT=$(dirname $(dirname $(realpath "$0")))
else
	ROOT=$(dirname $(dirname $(readlink -f $0)))
fi

cd $ROOT

echo "Root directory set to $ROOT.";

if [[ "$OSTYPE" == "darwin"* ]]; then
	NAME=`node -p "require('./product.json').nameLong"`
else
	NAME=`node -p "require('./product.json').applicationName"`
fi

CODE=$(which $NAME);

echo "CODE is set to $CODE.";

INTENDED_VERSION="v`node -p "require('./package.json').electronVersion"`"
INSTALLED_VERSION=$(cat .build/electron/version 2> /dev/null)

# Node modules
test -d node_modules || ./scripts/npm.sh install

# Get electron
(test -f "$CODE" && [ $INTENDED_VERSION == $INSTALLED_VERSION ]) || ./node_modules/.bin/gulp electron

# Unit Tests
if [[ "$1" == "--xvfb" ]]; then
    echo "Running tests for xvfb-run...";
	cd $ROOT ; \
		xvfb-run -a "$CODE" test/electron/index.js "$@"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Running tests for Darwin...";
	cd $ROOT ; ulimit -n 4096 ; \
		"$CODE" \
		test/electron/index.js "$@"
else
    echo "Running tests for Linux...";
	cd $ROOT ; \
		"$CODE" \
		test/electron/index.js "$@"
fi
