#!/bin/bash
set -e;

cd build;

echo "Starting vscode-linux-${PACKAGE_ARCH}...";
gulp "vscode-linux-${PACKAGE_ARCH}" | tee -a ../buildlog_${LABEL}.txt;

echo "Starting vscode-linux-${PACKAGE_ARCH}-build-deb...";
gulp "vscode-linux-${PACKAGE_ARCH}-build-deb" | tee -a ../buildlog_${LABEL}.txt;

echo "Starting vscode-linux-${PACKAGE_ARCH}-build-rpm...";
gulp "vscode-linux-${PACKAGE_ARCH}-build-rpm" | tee -a ../buildlog_${LABEL}.txt;

echo "Starting vscode-linux-${PACKAGE_ARCH}-build-flatpak...";
gulp "vscode-linux-${PACKAGE_ARCH}-build-flatpak" | tee -a ../buildlog_${LABEL}.txt;

echo "Tarring build folder for release...";
tar -zcvf "archive_${LABEL}.tar.gz" .build | tee -a ../buildlog_${LABEL}.txt;
