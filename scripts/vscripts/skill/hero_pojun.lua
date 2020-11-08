-- LinkLuaModifier('modifier_pojun', 'skill/hero_pojun.lua', 0)
LinkLuaModifier('modifier_pojun_jiangong', 'skill/hero_pojun.lua', 0)
LinkLuaModifier('modifier_pojun_baoji', 'skill/hero_pojun.lua', 0)


skill_hero_pojun=class({})

-- modifier_skill_hero_pojun = class({})
modifier_pojun_jiangong = modifier_pojun_jiangong or {}
modifier_pojun_baoji = modifier_pojun_baoji or {}


function skill_hero_pojun:OnSpellStart()
    if IsServer() and self:GetAbility() then
        local caster = self:GetCaster()
        local ability = self  -- local ability = skill_hero_pojun
        local owner   = caster:GetOwner() or {ship={}}
        --local target = self:GetCursorTarget()
        local radius = self:GetLevelSpecialValueFor("radius", self:GetLevel()-1)
        local duration = ability:GetSpecialValueFor("duration")

        local target_team  = self:GetAbilityTargetTeam()
        local target_types = self:GetAbilityTargetType()
        local target_flags = self:GetAbilityTargetFlags()

        local pfx = ParticleManager:CreateParticle("particles/econ/items/sven/sven_cyclopean_marauder/sven_cyclopean_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(pfx)

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
    end
end


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

