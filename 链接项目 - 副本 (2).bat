@echo off

echo 输入指向的项目名，项目库名，进行链接
echo 这个快捷方式只链接game\...\scripts和content\...\panorama
echo 感谢群友BreezeU提供的方法
echo.

echo 输入steam目录地址：
echo ( C:\Program Files (x86)\Steam   通常是这里，steam后面不带反斜杠)
SET /p FileSteam="目录地址:"

echo 输入导入的项目的文件夹名：
echo (Steam\steamapps\common\dota 2 beta\game\dota_addons\***\   通常是这个***)
SET /p FileName="项目名:"

echo 输入github的库的文件夹名：
SET /p FileItem="库名:"


mklink /J  "D:\Users\ace\Documents\GitHub\%FileItem%\scripts" "D:\PLAY\Steam\steamapps\common\dota 2 beta\game\dota_addons\%FileName%\scripts"

mklink /J  "D:\Users\ace\Documents\GitHub\%FileItem%\resource" "D:\PLAY\Steam\steamapps\common\dota 2 beta\game\dota_addons\%FileName%\resource"

mklink /J  "D:\Users\ace\Documents\GitHub\%FileItem%\maps" "D:\PLAY\Steam\steamapps\common\dota 2 beta\game\dota_addons\%FileName%\maps"
pause