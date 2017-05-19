# Community builds of Visual Studio Code for Chromebooks and Raspberry Pi

[![Build Status](https://travis-ci.org/headmelted/codebuilds.svg?branch=master)](https://travis-ci.org/headmelted/codebuilds)
[![Download](https://api.bintray.com/packages/headmelted/deb-code-oss/code-oss/images/download.svg) ](https://bintray.com/headmelted/deb-code-oss/code-oss/_latestVersion)

**APRIL 2017 UPDATE**: The necessary changes for ARM builds have been contributed upstream.  I'm hoping
these will be included in the official packages but for now the intention is to keep the builds running here.

THESE SCRIPTS SHOULD BE CONSIDERED UNSTABLE FOR NOW.  I'VE BEEN CHANGING AROUND QUITE A FEW THINGS TO MAKE THESE BUILDS
RUN ON TRAVIS CI, PLEASE LET ME KNOW IF YOU EXPERIENCE ANY ISSUES.

Now that Microsoft has official, signed APT repos, I have altered the scripts to detect if the user is on 
an amd64 system and, if so, use the official Microsoft insiders builds instead.  If you experience any
difficulty with this change, please raise an issue and provide the full error log.

This repository hosts a soft fork of [VS Code](https://code.visualstudio.com) that has been modified 
to produce cross-compiled packages for ARM architectures.

These packages can be found under the [Releases](https://github.com/headmelted/codebuilds/releases) section.

In addition, the **docs** directory contains a series of scripts to help users to install VS Code onto 
Chromebooks, by using Crouton to establish a **chroot** environment and display the window on Chrome OS.

More information about these builds and how they work is available on [the dedicated website](https://code.headmelted.com).

---

Please let me know of any issues you find with these builds, but please first check to see if the issue 
has been reported on the main [VS Code](https://github.com/Microsoft/vscode) repository, to ensure that
only ARM-specific and/or Chromebook-specific issues are raised here.
