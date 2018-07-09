npm install --target_arch=arm
yarn run gulp vscode-linux-arm-min
yarn run gulp vscode-linux-arm-build-deb
cd ..
cp -v vscode/.build/linux/deb/armhf/deb/*.deb .
