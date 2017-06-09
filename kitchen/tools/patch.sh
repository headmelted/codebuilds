#!/bin/bash
    
echo "Applying patches";
for patch_script in ../../../tools/patches/*.sh
do
  echo "Executing patch [${patch_script}]";
  . ./${patch_script};
done
    
echo "Applying overlays";
/bin/cp --verbose -rf ../../../tools/overlays/* ./;
