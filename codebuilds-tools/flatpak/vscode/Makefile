all:
	# Install dependencies
	./scripts/npm.sh install --arch ${VSCODE_ELECTRON_PLATFORM}
	./scripts/npm.sh install --arch ${VSCODE_ELECTRON_PLATFORM} gm
	
	# build vscode
	./node_modules/.bin/gulp vscode-linux-${VSCODE_ELECTRON_PLATFORM} --max_old_space_size=4096
	./node_modules/.bin/gulp vscode-linux-${VSCODE_ELECTRON_PLATFORM}-prepare-flatpak --max_old_space_size=4096

install:
	cp -ar .build/linux/flatpak/${VSCODE_ELECTRON_PLATFORM}/* /app/
	ln -sf /app/share/code-oss/bin/code-oss /app/bin/code-oss

.PHONY: all install
