--[[
	Author: 西索酱
	Date: 26.04.2020
	打印相关内容
]]

function lostHP( keys )
    --通过参数keys获得这个回调中要用到的参数
	local caster  = keys.caster  or nil
	local target  = keys.target  or nil
	local ability = keys.ability or nil
	print("caster"..".."..caster:GetUnitName())
if type(target)==table then
	for k,v in pairs(target) do
		print("target"..k..".."..target[k]:GetUnitName())
	end
else
	print("target"..".."..target:GetUnitName())
end
	print("ability"..".."..ability:GetAbilityName())
	print(".............................................")
end

