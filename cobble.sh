#!/bin/bash

cobbler_cross_architectures="${ARCH}"
cobbler_foreign_architectures="${ARCH}"
cobbler_foreign_triplets="${GNU_TRIPLET}"
cobbler_architectures_ports_list=""

if ["${ARCH}" != "amd64"] && ["${ARCH}" != "i386"]; then
  cobbler_architectures_ports_list="${ARCH}";
fi;

cobbler_packages_to_install=""
for triplet in $cobbler_foreign_triplets; do cobbler_packages_to_install="$cobbler_packages_to_install \
gcc-$triplet \
g++-$triplet"; done

# libc6-$arch-cross \
# libstdc++6-$arch-cross \

for arch in $cobbler_cross_architectures; do cobbler_packages_to_install="$cobbler_packages_to_install \
crossbuild-essential-$arch"; done
#  libjpeg-turbo:$arch \
for arch in $cobbler_foreign_architectures; do cobbler_packages_to_install="$cobbler_packages_to_install libgtk2.0-0:$arch libxkbfile-dev:$arch \
libx11-dev:$arch libxdmcp-dev:$arch libdbus-1-3:$arch libpcre3:$arch libselinux1:$arch libp11-kit0:$arch libcomerr2:$arch libk5crypto3:$arch \
libkrb5-3:$arch libpango-1.0-0:$arch libpangocairo-1.0-0:$arch libpangoft2-1.0-0:$arch libxcursor1:$arch libxfixes3:$arch libfreetype6:$arch libavahi-client3:$arch \
libgssapi-krb5-2:$arch libtiff5:$arch fontconfig-config libgdk-pixbuf2.0-common libgdk-pixbuf2.0-0:$arch libfontconfig1:$arch libcups2:$arch \
libcairo2:$arch libc6-dev:$arch libatk1.0-0:$arch libx11-xcb-dev:$arch libxtst6:$arch libxss-dev:$arch libxss1:$arch libgconf-2-4:$arch \
libasound2:$arch libnss3:$arch zlib1g:$arch"; done

echo "Package install list: ${cobbler_packages_to_install}"

echo "Building cobbler image for ${cobbler_ports_architectures_list}"

echo "Adding architectures supported by cobbler"
for arch in $cobbler_foreign_architectures; do dpkg --add-architecture $arch; done

#echo "Adding yarn signing key"
#curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

#echo "Adding yarn repository"
#echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

#echo "Adding emdebian signing key"
#curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add -

echo "Resetting ubuntu package lists"
#echo "deb http://emdebian.org/tools/debian/ unstable main" | tee /etc/apt/sources.list.d/cobbler.list;
echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ cosmic main universe multiverse restricted" | tee /etc/apt/sources.list.d/cobbler.list;
echo "deb [arch=amd64,i386] http://security.ubuntu.com/ubuntu/ cosmic-security main universe multiverse restricted" | tee -a /etc/apt/sources.list.d/cobbler.list;
echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ cosmic-updates main universe multiverse restricted" | tee -a /etc/apt/sources.list.d/cobbler.list;
