#!/bin/bash
set -e;

#echo "/usr/lib/${ARCHIE_GNU_TRIPLET} ------------------";
#ls /usr/lib/${ARCHIE_GNU_TRIPLET};
#echo "/usr/lib/${ARCHIE_GNU_TRIPLET}/pkgconfig --------";
#ls /usr/lib/${ARCHIE_GNU_TRIPLET}/pkgconfig;

echo "PKG_CONFIG --------------------------------------";
echo $PKG_CONFIG_PATH;
echo "pkg-config search path --------------------------";
pkg-config --variable pc_path pkg-config;

. ./setup_nvm.sh;

echo "Current directory is:";
pwd;

echo "Directory contents:";
echo "-------------------";
ls;
echo "-------------------";

echo "Retrieving latest Visual Studio Code sources into [code]";
git clone "https://github.com/Microsoft/vscode.git" code;
  
echo "Setting current owner as owner of code folder";
chown ${USER:=$(/usr/bin/id -run)}:$USER -R code;

echo "Synchronizing overlays folder";
rsync -avh ./overlays/ ./code/;

echo "Entering code directory";
cd code;

#if [ "${ARCHIE_ELECTRON_ARCH}" == "arm" ]; then 
#  echo "Patching electron install for arm";
#  sed -i -e 's/process.env.npm_config_arch/"armv7l"/g' ./test/smoke/node_modules/electron/install.js
#  echo "---------------------------------------------------"
#  cat ./test/smoke/node_modules/electron/install.js
#  echo "---------------------------------------------------"
#fi;

extra_links="-I$compiler_root_directory/usr/include/libsecret-1 -I$compiler_root_directory/usr/include/glib-2.0 -I$compiler_root_directory/usr/lib/${ARCHIE_HEADERS_GNU_TRIPLET}/glib-2.0/include";
export CC="$CC $extra_links"
export CXX="$CXX $extra_links"

CHILD_CONCURRENCY=1 yarn;

echo "Running hygiene";
npm run gulp -- hygiene;

echo "Running monaco-compile-check";
npm run monaco-compile-check;

#echo "Running strict-null-check";
#npm run strict-null-check;

#echo "Installing distro";
#node build/azure-pipelines/common/installDistro.js;

echo "Installing built-in extensions";
node build/lib/builtInExtensions.js;

echo "Compiling VS Code for $VSCODE_ELECTRON_PLATFORM";
npm run gulp -- vscode-linux-$VSCODE_ELECTRON_PLATFORM-min --unsafe-perm;

#echo "Executing yarn (ignoring scripts)";
#yarn install --unsafe-perm --ignore-scripts;

#echo "Copying vscode-sqlite.gyp";
#mv vscode-sqlite.gyp ./node_modules/vscode-sqlite/binding.gyp;

#echo "Executing yarn";
#yarn install --unsafe-perm;

echo "Executing electron-$ARCHIE_ELECTRON_ARCH";
yarn --verbose gulp electron-${ARCHIE_ELECTRON_ARCH};

#echo "Executing monaco-compile-check";
#yarn --verbose monaco-compile-check;

#echo "Executing strict-null-check";
#yarn --verbose strict-null-check;

#echo "Executing compile";
#yarn --verbose compile;

#echo "Executing download-builtin-extensions";
#yarn --verbose download-builtin-extensions;

#echo "Compiling VS Code for $VSCODE_ELECTRON_PLATFORM";
#yarn run gulp vscode-linux-$VSCODE_ELECTRON_PLATFORM;

echo "Starting vscode-linux-$VSCODE_ELECTRON_PLATFORM-build-deb";
yarn run gulp vscode-linux-$VSCODE_ELECTRON_PLATFORM-build-deb;

echo "Leaving code directory";
cd ..;

echo "Creating output directory";
mkdir output;

echo "Moving deb packages for release";
mv ./code/.build/linux/deb/$ARCHIE_ARCH/deb/*.deb /root/output;

echo "Extracting deb archive";
dpkg -x /root/output/*.deb output/extracted;

cd output/extracted;

echo "Binary components of output --------------------------------------------------"
find . -type f -exec file {} ";" | grep ELF
echo "------------------------------------------------------------------------------"
