@echo off
path %path%;%programfiles(x86)%\Steam\SteamApps\common\GarrysMod\bin
mkdir tmp
robocopy . tmp *.json *.lua *.wav *.mp3 *.jpg *.png *.txt /E /XD tmp /XF LICENSE.txt
gmad create -folder "tmp" -out "prophunt.gma"
rmdir /q /s tmp
pause