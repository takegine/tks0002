-- LinkLuaModifier('modifier_pojun', 'skill/hero_pojun.lua', 0)
LinkLuaModifier('modifier_pojun_jiangong', 'skill/hero_pojun.lua', 0)
LinkLuaModifier('modifier_pojun_baoji', 'skill/hero_pojun.lua', 0)


skill_hero_pojun=class({})

-- modifier_skill_hero_pojun = class({})
modifier_pojun_jiangong = modifier_pojun_jiangong or {}
modifier_pojun_baoji = modifier_pojun_baoji or {}


function skill_hero_pojun:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self  -- local ability = skill_hero_pojun
    local owner   = caster:GetOwner() or {ship={}}
    --local target = self:GetCursorTarget()
    local radius = self:GetLevelSpecialValueFor("radius", self:GetLevel()-1)
    local duration = ability:GetSpecialValueFor("duration")

    local target_team  = self:GetAbilityTargetTeam()
	local target_types = self:GetAbilityTargetType()
    local target_flags = self:GetAbilityTargetFlags()

    local units = FindUnitsInRadius(caster:GetTeamNumber(),
                                    caster:GetOrigin(),
                                    nil,
                                    radius,
                                    target_team,
                                    target_types,
                                    target_flags,
                                    0,
                                    true)

    for key,unit in pairs(units) do
        if  unit:IsOpposingTeam(caster:GetTeamNumber()) then
            unit:AddNewModifier(caster, self, "modifier_pojun_jiangong", {duration=duration})
        elseif owner.ship['moni'] then
            unit:AddNewModifier(caster, self, "modifier_pojun_baoji", {duration=duration})
        end
    end 
print(duration)
-- if 条件 then
--     满足条件的行为
-- elseif 条件2 then
--     不满足条件 但满足条件2 的行为
-- else
--     不满足条件也不 满足 条件2 的行为

-- end


    -- -- else
    -- --     target:AddNewModifier(caster, self, "modifier_pojun_jiangong", {duration=duration})
    -- -- end

    -- if owner.ship['moni'] then
    --     -- caster:AddNewModifier(caster,ability,'modifier_pojun_baoji', {})

    
    --     -- local radius = self:GetLevelSpecialValueFor("radius", self:GetLevel()-1)
    --     -- local target_team  = self:GetAbilityTargetTeam()
    --     -- local target_types = self:GetAbilityTargetType()
    --     -- local target_flags = self:GetAbilityTargetFlags()

    --     local friend = FindUnitsInRadius(caster:GetTeamNumber(),
    --                                     caster:GetOrigin(),
    --                                     nil,
    --                                     radius,
    --                                     DOTA_UNIT_TARGET_TEAM_FRIENDLY,
    --                                     target_types,
    --                                     target_flags,
    --                                     0,
    --                                     true)

    --     for key,unit in pairs(friend) do
    --         unit:AddNewModifier(caster, self, "modifier_pojun_baoji", {duration=duration})
    --     end
    -- end
    -- else
    --     target:AddNewModifier(caster, self, "modifier_pojun_baoji", {duration=duration})
    -- end
end

-- function modifier_skill_hero_pojun:OnCreated(keys)
--     local caster = keys.caster
--     local ability = keys.ability
--     local parent = self:GetParent()
-- end

function modifier_pojun_jiangong:IsDebuff()
    return true
end

function modifier_pojun_jiangong:DeclareFunctions()
    return  {   MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE 
    }
end

function modifier_pojun_jiangong:GetModifierDamageOutgoing_Percentage()
    local ability=self:GetAbility()
    local jiangong = ability:GetSpecialValueFor('jiangong')
    return  -jiangong
    
end



function modifier_pojun_baoji:DeclareFunctions()
    return  {   MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
                MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE              
    }
end

function modifier_pojun_baoji:GetModifierPhysicalArmorBonus()
    local ability=self:GetAbility()
    local addarmor = ability:GetSpecialValueFor('addarmor')
    return  addarmor
    
end

function modifier_pojun_baoji:GetModifierPreAttack_CriticalStrike()
    local ability = self:GetAbility()
    local chance = ability:GetSpecialValueFor('chance')
    return RollPercentage(chance) and 200 or 0
    
end
