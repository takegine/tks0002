LinkLuaModifier( "modifier_skill_hero_zhiba", "skill/hero_zhiba", 0 )
LinkLuaModifier('modifier_zhiba_baoji', 'skill/hero_zhiba.lua', 0)

skill_hero_zhiba = class({})

modifier_skill_hero_zhiba = class({})
modifier_zhiba_baoji = modifier_zhiba_baoji or ({})


function skill_hero_zhiba:needwaveup()
    local caster = self:GetCaster()
    local ability = self
    local modifierName ="modifier_zhiba_baoji"
    local radius = 2000
    local owner   = caster:XinShi()
    local target_team  = self:GetAbilityTargetTeam()
	local target_types = self:GetAbilityTargetType()
    local target_flags = self:GetAbilityTargetFlags()
    if caster:GetAbsOrigin().z ~=owner:GetAbsOrigin().z then 

        return 
    end

    local mod   = caster:AddNewModifier(caster, self, modifierName, {})
    local units = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetAbsOrigin(),nil,radius,target_team,target_types,target_flags,0,true)
    local namelist = {}

    for k,v in pairs(units) do
        if v:GetUnitLabel()=="wuguo"
        and not namelist[v:GetUnitName()] then
            namelist[v:GetUnitName()]=true
            mod:IncrementStackCount()
        end 
    end  
end 

function modifier_skill_hero_zhiba:IsHidden()
    return true
end

function modifier_skill_hero_zhiba:OnCreated( data )
    self:StartIntervalThink(0.5)
end

function modifier_skill_hero_zhiba:OnInterlThink(keys)
    if IsServer() then
        local parent = self:GetParent()
        if self:GetCaster() then
            local caster = self:GetCaster()
            if not caster:IsAlive()
            or not parent:IsAlive() then
                parent:RemoveModifierByNameAndCaster(self:GetName(),caster)
            end
        else self:Destroy()
        end
    end
end

function modifier_zhiba_baoji:DeclareFunctions()
    return  {  MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE              
    }
end

function modifier_zhiba_baoji:GetModifierPreAttack_CriticalStrike(data)
    local ability = self:GetAbility()
    local chance  = ability:GetSpecialValueFor('chance')
    local count   = self:GetStackCount()  
    return RollPercentage(chance*count) and 200 or 0
end

function modifier_zhiba_baoji:IsHidden()
    return true
end




