set dotaFile=D:\\PLAY\\Steam\\steamapps\\common\\dota 2 beta\\game\\dota_addons
set gitFile=D:\\Users\\ace\\Documents\\GitHub
set addonName=tks0002


if not exist "%dotaFile%\%addonName%" (
md %dotaFile%\%addonName%
)
mklink /J  "%dotaFile%\%addonName%\scripts" "%gitFile%\%addonName%\scripts"
mklink /J  "%dotaFile%\%addonName%\resource" "%gitFile%\%addonName%\resource"
mklink /J  "%dotaFile%\%addonName%\panorama" "%gitFile%\%addonName%\panorama"
mklink /J  "%dotaFile%\%addonName%\maps" "%gitFile%\%addonName%\maps"
mklink /J  "%dotaFile%\%addonName%\particles" "%gitFile%\%addonName%\特效"
mklink /J  "%dotaFile%\%addonName%\models" "%gitFile%\%addonName%\模型"