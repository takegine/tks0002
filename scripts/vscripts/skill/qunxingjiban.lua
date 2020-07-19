--LinkLuaModifier("qunxingyunluo", "scripts/vscripts/skill/qunxingjiban.lua", LUA_MODIFIER_MOTION_NONE)
--if modifier_skill_hero_wusheng_armor == nil then modifier_skill_hero_wusheng_armor = class({}) end
--function qunxingyunluo:RemoveOnDeath()	return true end
function guanxingjiban(keys)
    local caster  = keys.caster    
    local ability = keys.ability
	ability.count = 1 + ( ability.count or 0)
	print(ability.count)
	
    if ability.count > 3 then 
        ability.count=0
        --hero:AddNewModifier( hero, self, "修饰器名字", {"补充参数，没有就空着"} )
		print("yes")
	end
end