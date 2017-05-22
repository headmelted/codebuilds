dpkg -i $(find .build/linux -type f -name "*.deb");
echo "Detecting code-oss...";
which code-oss;
test/electron/index.js $(which code-oss);
