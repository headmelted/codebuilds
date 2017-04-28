#!/bin/sh

clear;
echo "
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
                          _   __ _             _             ___          _
 /\   /(_)___ _   _  __ _| | / _\ |_ _   _  __| (_) ___     / __\___   __| | ___ 
 \ \ / / / __| | | |/ _\` | | \ \| __| | | |/ _\` | |/ _ \   / /  / _ \ / _\` |/ _ \\
  \ V /| \__ \ |_| | (_| | | _\ \ |_| |_| | (_| | | (_) | / /__| (_) | (_| |  __/
   \_/ |_|___/\__,_|\__,_|_| \__/\__|\__,_|\__,_|_|\___/  \____/\___/ \__,_|\___|
                                               
                                  for Linux (YUM)          
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

                       PLEASE READ THIS INFORMATION CAREFULLY           

This tool will guide you through setting up Visual Studio Code on your device.

During this process we'll add the repositories to your new environment to ensure
you receive updates as they are published.

Then we'll install the most recent version of Visual Studio Code onto your device
(along with git).

DISCLAIMER:

THIS SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THIS 
SOFTWARE OR THE USE OR OTHER DEALINGS IN THIS SOFTWARE.

";

printf "Install now? (y/n): ";
read install_now;
if [ $install_now != "y" ]; then
  echo "No problem!  Please just run me again whenever you wish to install Visual Studio Code.";
  exit;
fi;

echo "Installing headmelted repository..."
. <( wget -O - "https://packagecloud.io/install/repositories/headmelted/code-oss/script.rpm.sh" );
if (($? == 0)); then
  echo "Repository install complete.";
else
  echo "Repository install failed.";
  exit 1;
fi;

echo "Installing Visual Studio Code..."
yum install -y code-oss;
if [ $? -eq 0 ]; then
  echo "Visual Studio Code install complete.";
else
  echo "Visual Studio Code install failed.";
  exit 1;
fi;

echo "Installing git...";
yum install -y git;
echo "git installed.";

echo "Cleaning YUM caches ahead of update...";
yum clean all;
echo "Done!";

echo "Installing any dependencies that may have been missed...";
yum update;
echo "Done!";

echo "

Installation complete!

You can start code at any time by calling \"code-oss\" from with a terminal.

A shortcut should also be available in your desktop menus in Linux.

";

