
LinkLuaModifier("modifier_jieming_arua",'skill/hero_jieming.lua',0)
LinkLuaModifier("modifier_jieming_buff",'skill/hero_jieming.lua',0)

skill_hero_jieming=class({})

function skill_hero_jieming:needwaveup()

local caster=self:GetCaster()

caster:AddNewModifier(caster, self, 'modifier_jieming_arua', {})

end

 modifier_jieming_arua=class({})

function modifier_jieming_arua:IsHidden()
    return true
end

function modifier_jieming_arua:IsAura()
    return true
end 

function modifier_jieming_arua:IsAuraActiveOnDeath()
    return false 
end 

function modifier_jieming_arua:IsDebuff()
    return false
end

function modifier_jieming_arua:GetAuraRadius()
    return 360
end

function modifier_jieming_arua:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY 
end

function modifier_jieming_arua:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end 

function modifier_jieming_arua:GetModifierAura()
    return 'modifier_jieming_buff'
end


modifier_jieming_buff=class({})

function modifier_jieming_buff:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }
end

function modifier_jieming_buff:GetModifierConstantHealthRegen()

    local ability=self:GetAbility()
    local heal =ability:GetSpecialValueFor('heal')
   -- print(heal)
    return heal
end

function modifier_jieming_buff:OnAttackLanded(keys)
    local parent =self:GetParent()
    local caster=self:GetCaster()
    local chance=10
    local owner  = caster:GetOwner() or {ship={}}  
    local heal=parent:GetMaxHealth()/100*7

    if not IsServer() then return end
    if keys.target~=parent  then  return end

    if owner.ship['konghe']  then 
    if RollPercentage(15)  then
	parent:Heal(parent:GetMaxHealth()/10,caster)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, heal, nil)
    end
   else
    if RollPercentage(10)  then
        parent:Heal(parent:GetMaxHealth()/10,caster)
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, heal, nil)
        end
end
end








