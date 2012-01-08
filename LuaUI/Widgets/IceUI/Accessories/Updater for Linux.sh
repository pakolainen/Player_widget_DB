#!/bin/sh

Revision=83
ServerProtocol=https://
ServerURL=meltrax.homeip.net
SpringURL=$ServerProtocol$ServerURL/projects/other/spring/IceUI

clear
echo
cd `dirname "$0"`"/../.."

serverOffline() {
  echo "   * I'm sorry but my server seems to be offline at the moment."
  echo "     Please try again later."
  exit 1
}

echo " - Downloading new IceUI version"
wget -qO IceUI.tgz --no-check-certificate "$SpringURL/Snapshots/IceUI%20for%20current%20Spring%20(latest).tgz" || serverOffline


echo " - Extracting new IceUI version"
mv IceUI/Profiles Profiles
tar --exclude=Profiles --recursive-unlink -xzf IceUI.tgz
rm IceUI.tgz


echo " - Showing changes"
wget -qO - --no-check-certificate "$SpringURL/changelog.php?path=/branches/forCurrentSpring&from=$Revision"


echo  - Moving back saved files
mv Profiles IceUI/Profiles

echo
exit 0
