@echo off

if not "%~1" == "" goto intemp
  mkdir "%temp%\IceUI-Updater\Profiles" > NUL 2> NUL
  copy "%~dp0*" "%temp%\IceUI-Updater" > NUL 2> NUL
  copy "%~dp0..\Profiles\*" "%temp%\IceUI-Updater\Profiles" > NUL 2> NUL
  "%temp%\IceUI-Updater\%~nx0" "%~dp0"
  goto end
:intemp

set Revision=83
set ServerProtocol=https://
set ServerURL=meltrax.homeip.net
set SpringURL=%ServerProtocol%%ServerURL%/projects/other/spring/IceUI
set ChillerURL=%ServerProtocol%%ServerURL%/projects/other/chiller/files

pushd %~dp0
cls
color 2
title Updating IceUI
echo.


wget --version > NUL 2> NUL && goto wgetinstalled
  echo  - Downloading Wget (only the first time)
  echo.
  echo    * Wget is distributed under the terms of the GNU GPL.
  echo    * See http://www.gnu.org/software/wget/wget.html for details.
  echo.
  REG ADD HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List /V "%systemroot%\system32\ftp.exe" /D "%systemroot%\system32\ftp.exe:*:Enabled:Programm zur Datenübertragung" /F > NUL 2> NUL
  echo chiller> chiller.ftp
  echo chiller>> chiller.ftp
  echo binary>> chiller.ftp
  echo get wget.exe>> chiller.ftp
  echo quit>> chiller.ftp
  ftp -s:chiller.ftp %ServerURL% > NUL 2> NUL && goto ftpsuccess
    title Update failed!
    color C
    echo    * You don't seem to have ftp.exe on your system.
    echo      While this is good in terms of security, you have to download wget
    echo      manually from this URL in order to use this Updater:
    echo    * %ChillerURL%/wget.exe
    echo    * Just put it into this directory (Spring\LuaUI\Widgets\IceUI\Accessories)
    echo      or another directory in your PATH.
    echo.
    goto end
  :ftpsuccess
  REG DELETE HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List /V "%systemroot%\system32\ftp.exe" /F > NUL 2> NUL
:wgetinstalled


7za > NUL 2> NUL && goto 7zinstalled
  echo  - Downloading 7-Zip (only the first time)
  echo.
  echo    * 7-Zip is distributed under the terms of the GNU LGPL.
  echo    * See http://www.7-zip.org/ for details.
  echo.
  wget.exe -q --no-check-certificate %ChillerURL%/7za.exe
:7zinstalled


echo  - Downloading new IceUI version
wget.exe -O IceUI.7z -q --no-check-certificate %SpringURL%/Snapshots/IceUI%%20for%%20current%%20Spring%%20(latest).7z && goto downloadsuccess
  title Update failed!
  color C
  echo    * I'm sorry but my server seems to be offline at the moment.
  echo      Please try again later.
  goto end
:downloadsuccess


echo  - Extracting new IceUI version
rd /S /Q "%~dp1.." > NUL 2> NUL
7za.exe x -y -o"%~dp1..\.." IceUI.7z > NUL 2> NUL
del IceUI.7z


echo  - Showing changes
wget.exe -q -O - --no-check-certificate "%SpringURL%/changelog.php?path=/branches/forCurrentSpring&from=%Revision%"


echo  - Moving back saved files
copy "%temp%\IceUI-Updater\*.exe" "%~dp1" > NUL 2> NUL
copy "%temp%\IceUI-Updater\Profiles\*" "%~dp1..\Profiles" > NUL 2> NUL

title Update complete!
:end
echo.
popd
pause
rd /S /Q "%~dp0" > NUL 2> NUL
