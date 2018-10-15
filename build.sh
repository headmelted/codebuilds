#!/bin/bash
set -e;

echo "Github token length: ${#GITHUB_TOKEN}"
echo "Github token: ${GITHUB_TOKEN}"

echo "Retrieving latest Visual Studio Code sources into [code]";
git clone "https://github.com/Microsoft/vscode.git" code;
  
echo "Setting current owner as owner of code folder";
chown ${USER:=$(/usr/bin/id -run)}:$USER -R code;

echo "Synchronizing overlays folder";
rsync -avh ./overlays/ ./code/;

echo "Installing NVM and dependencies";
. /root/kitchen/tools/setup_nvm.sh;

echo "Entering code directory";
cd code;

echo "NPM arch is [$npm_config_arch]"

#echo "Running yarn install";
#CHILD_CONCURRENCY=1 yarn;

#echo "Running gulp hygiene";
#npm run gulp -- hygiene;

#echo "Running monaco-compile-check";
#npm run monaco-compile-check;

#echo "Running strict-null-check";
#npm run strict-null-check;

#echo "Running gulp mixin"
#npm run gulp -- mixin

#echo "Running installDistro.js";
#node build/tfs/common/installDistro.js;

#echo "Running builtInExtensions.jsyarn";
#node build/lib/builtInExtensions.jsyarn;

#echo "Compiling VS Code for $npm_config_arch";
#yarn run gulp vscode-linux-$npm_config_arch-min;

#echo "Starting vscode-linux-$npm_config_arch-build-deb";
#yarn run gulp vscode-linux-$npm_config_arch-build-deb;

echo "Executing yarn"
yarn

echo "Executing electron-$ARCHIE_ELECTRON_ARCH"
yarn --verbose gulp electron-${ARCHIE_ELECTRON_ARCH}

#echo "Executing gulp hygiene"
#yarn --verbose gulp hygiene

echo "Executing monaco-compile-check"
yarn --verbose monaco-compile-check

echo "Executing strict-null-check"
yarn --verbose strict-null-check

echo "Executing compile"
yarn --verbose compile

echo "Executing download-builtin-extensions"
yarn --verbose download-builtin-extensions

echo "Compiling VS Code for $npm_config_arch";
yarn run gulp vscode-linux-$npm_config_arch-min;

echo "Starting vscode-linux-$npm_config_arch-build-deb";
yarn run gulp vscode-linux-$npm_config_arch-build-deb;

echo "Leaving code directory";
cd ..;

echo "Creating output directory";
mkdir output;

echo "Moving deb packages for release";
mv ./code/.build/linux/deb/$ARCHIE_ARCH/deb/*.deb output;

echo "Installing package_cloud"
gem install package_cloud

echo "Publishing deb file to packagecloud (MOVE THIS TO A RELEASE CONFIGURATION LATER!)"
package_cloud push headmelted/codebuilds/ubuntu/xenial output/*.deb

#package_cloud push headmelted/codebuilds/fedora/24 $TRAVIS_OUTPUT_DIRECTORY/*.rpm

echo "Extracting deb archive";
dpkg -x output/*.deb output/extracted;

cd output/extracted;

echo "Binary components of output --------------------------------------------------"
find . -type f -exec file {} ";" | grep ELF
echo "------------------------------------------------------------------------------"

#echo "Dependency tree for code-oss -------------------------------------------------"
#ldd -v usr/share/code-oss/code-oss;
#echo "------------------------------------------------------------------------------"
