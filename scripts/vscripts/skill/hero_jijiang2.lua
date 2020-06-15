--[[
	Author: 西索酱
	Date: 30.04.2020
	每有一名友军蜀国武将存在时，可增加周围友军单位5 %近战攻击
	参考黑弓 的 射手天赋
]]

function jijiangCreate( keys )
    --通过参数keys获得这个回调中要用到的参数
	local caster = keys.caster  
	--local target = keys.target
	local ability = keys.ability
	local damagebase = ability:GetLevelSpecialValueFor("damagebase",(ability:GetLevel()-1))
	local radius = ability:GetLevelSpecialValueFor("radius",(ability:GetLevel()-1))   --ability:GetLevelSpecialValueFor("radius",(ability:GetLevel()-1)) 按照技能中的特殊值检索
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local modifierName = "modifier_skill_hero_jijiang_aura"  --计数的光环
	local modifierTrue = "modifier_skill_hero_jijiang_2"     --实际的光环

	--local ShuguotabB = Entities:FindAllByName("npc_dota_creature")--建立一个带所有小怪的   建立表单
	--local ShuguotabA = HeroList:GetAllHeroes()
    
    --计算光环范围内的单位数量
    local units = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetAbsOrigin(),caster,radius,DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL,0,0,false)
                                 --参数分别是释放技能人的队伍编号，释放人的世界坐标，圆心，检索半径，目标队伍，目标单位类型，0,0，false
    table.insert( units, caster) --手动添加施法人自己

    local count = 0--初始化层数
    for k,v in pairs(units) do
    	--print(k,v)
    	if v:GetUnitLabel()=="shuguo" then --每多一个蜀国单位，层数+1
    		count = count + 1
    	end
    end
    --print(count)--打印检测

    
	--
	for i = 1,#units do --给全队加上激将
						--如果不是远程单位
		if  units[i]:IsRangedAttacker() == false then
			local damage = units[i]:GetAttackDamage() * damagebase / 100 
			ability:ApplyDataDrivenModifier( caster, units[i], modifierName, nil )
			units[i]:SetModifierStackCount( modifierName, ability ,count) 
			ability:ApplyDataDrivenModifier( caster, units[i], modifierTrue,nil )
			units[i]:SetModifierStackCount( modifierTrue, ability ,count*damage) 
    	end
	end
end

