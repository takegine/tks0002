

LinkLuaModifier('modifier_skill_hero_sunchuan', 'skill/hero_sunchuan.lua', 0)


skill_hero_sunchuan=class({})

function skill_hero_sunchuan:needwaveup()  
    local caster=self:GetCaster()

    local owner = caster:GetOwner() or {ship={}}   --判断是否有组合

    if owner.ship['chuanshi'] then
      caster:AddNewModifier(caster, self ,'modifier_skill_hero_sunchuan', {})
    end
end

modifier_skill_hero_sunchuan=class({})

function modifier_skill_hero_sunchuan:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_skill_hero_sunchuan:OnAttackLanded(keys)
    local parent    = self:GetParent()
    local ability   = self:GetAbility()
    local target    = keys.target
    local damage_type  = ability:GetAbilityDamageType()   --这个是技能用的
	local target_team  = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
    local target_flags = ability:GetAbilityTargetFlags()
    local damage  = parent:GetHealth() *ability:GetSpecialValueFor("damage" ) /100

    print(target:GetUnitName())
    
    --判断是否暴击
    if keys.attacker == parent   
    and keys.original_damage/parent:GetAverageTrueAttackDamage(target)>1.05 then 

        local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, parent, parent, parent:GetTeamNumber() )  --火伤马甲
        dummy.attack_type  = "fire"
        dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

        local enemy = FindUnitsInRadius(parent:GetTeamNumber(),   --查找自身范围160的敌人
        target:GetOrigin(), 
        nil, 
        160,
        target_team, 
        target_types, 
        target_flags, 
        0, 
        true)

        for key,unit in pairs(enemy) do   --找到敌人输出伤害
            print("dddd",damage)
            local  damage_table = {

                attacker     = dummy,
                victim       = unit,
                damage_type  = damage_type,
                damage       = damage, --unit:GetHealth()*0.1,
                damage_flags = DOTA_DAMAGE_FLAG_NONE
            }
                ApplyDamage(damage_table)
        end
    end
end



-- LinkLuaModifier('modifier_skill_hero_longdan_baoji', 'skill/hero_sunchuan.lua', 0)
-- function skill_hero_sunchuan:GetIntrinsicModifierName()
-- 	return "modifier_skill_hero_longdan_baoji"
-- end


-- modifier_skill_hero_longdan_baoji=class({}) --暴击伤害

-- function modifier_skill_hero_longdan_baoji:DeclareFunctions()
-- 	return{
-- 	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
-- 	-- MODIFIER_EVENT_ON_ATTACK_LANDED
-- }
-- end

-- function modifier_skill_hero_longdan_baoji:GetModifierPreAttack_CriticalStrike()
-- 	return RollPercentage(50) and  200 or 0
-- end

-- function modifier_skill_hero_longdan_baoji:OnAttackLanded() --攻击命中  移除修饰器

-- 	local caster=self:GetCaster()
-- 	local parent=self:GetParent()
	
-- 	parent:RemoveModifierByName("modifier_skill_hero_longdan_baoji")

-- end