
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
    return heal
end


function modifier_jieming_buff:OnAttackLanded(keys)
    local parent =self:GetParent()
    local caster=self:GetCaster()
    local chance=10
    local owner  = caster:XinShi()  
    local heal=parent:GetMaxHealth()/100*7

    if not IsServer() then return end
    if keys.target~=parent  then  return end

    if owner.ship['konghe']  then  chance=15 end

    if RollPercentage(chance)  then
	parent:Heal(parent:GetMaxHealth()/10,caster)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, heal, nil)
    local pfxname = "particles/econ/items/kunkka/kunkka_weapon_whaleblade_retro/kunkka_spell_torrent_retro_whaleblade_water5.vpcf"
    local pfx = ParticleManager:CreateParticle( pfxname, PATTACH_ABSORIGIN_FOLLOW, parent)
    ParticleManager:SetParticleControl(pfx, 1, Vector(50, 50, 50))
    ParticleManager:ReleaseParticleIndex(pfx)
    end
end








