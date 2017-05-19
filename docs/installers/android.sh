#!/bin/sh

clear;
echo "
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
                          _   __ _             _             ___          _
 /\   /(_)___ _   _  __ _| | / _\ |_ _   _  __| (_) ___     / __\___   __| | ___ 
 \ \ / / / __| | | |/ _\` | | \ \| __| | | |/ _\` | |/ _ \   / /  / _ \ / _\` |/ _ \\
  \ V /| \__ \ |_| | (_| | | _\ \ |_| |_| | (_| | | (_) | / /__| (_) | (_| |  __/
   \_/ |_|___/\__,_|\__,_|_| \__/\__|\__,_|\__,_|_|\___/  \____/\___/ \__,_|\___|
                                               
                                  for Android          
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

                       PLEASE READ THIS INFORMATION CAREFULLY           

This tool will guide you through setting up your Android phone for Visual Studio Code.

During this process we'll add the repositories to your new environment to ensure
you receive updates as they are published.

Then we'll install the most recent version of Visual Studio Code onto your Android
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

echo "Great! Let's get to it then.";

echo "Updating APT cache..."
apt-get update;
echo "Done!"

echo "Running install script for APT...";
. <( wget -O - "https://codebuilds.org/installers/apt.sh" );
if [ $? -eq 0 ]; then
  echo "APT install script complete.";
else
  echo "APT install script failed.";
  exit 1;
fi;

