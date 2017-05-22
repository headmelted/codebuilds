dpkg -i $(find .build/linux -type f -name "*.deb");
echo "Detecting code-oss...";
which code-oss;
. ./codebuilds-tools/startxvfb.sh;
echo "Creating dummy user data dir...";
mkdir dummy;
$(which code-oss) --user-data-dir=./dummy test/electron/index.js $@;
