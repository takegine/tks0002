

LinkLuaModifier("modifier_skill_hero_keji",'skill/hero_keji.lua',0)
LinkLuaModifier("modifier_skill_hero_keji_wudi",'skill/hero_keji.lua',0)

skill_hero_keji=class({})

function skill_hero_keji:OnSpellStart()
local caster=self:GetCaster()
local ability=self
local owner  = caster:GetOwner() or {ship={}}  


if not IsServer() then return end

if caster:HasAbility('skill_hero_saoshe') then 
caster:AddNewModifier(caster, ability, 'modifier_skill_hero_keji', {duration=1.5})

else
caster:AddNewModifier(caster, ability, 'modifier_skill_hero_keji', {duration=1.5})
local saoshe=caster:AddAbility("skill_hero_saoshe")
saoshe:SetLevel(caster:GetLevel())

return end

if owner.ship['siying']  then

caster:AddNewModifier(caster,ability,"modifier_skill_hero_keji_wudi",{Duration=1.5})

end 

end


modifier_skill_hero_keji=class({})

function modifier_skill_hero_keji:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED
    }
end

function modifier_skill_hero_keji:GetModifierMoveSpeedBonus_Constant()
    return 400
end

function modifier_skill_hero_keji:CheckState()
    local state = {
    [MODIFIER_STATE_INVISIBLE]=true,
}      return state
end

function modifier_skill_hero_keji:OnAttackStart(keys)

    local parent=self:GetParent()
    local caster=self:GetCaster()
    if keys.attacker~=caster then return end
    parent:RemoveModifierByName("modifier_skill_hero_keji")
    parent:RemoveModifierByName("modifier_skill_hero_keji_wudi")
end

function modifier_skill_hero_keji:OnAbilityExecuted(keys)
    local caster=self:GetCaster()
    local parent=self:GetParent()
    if keys.caster~=caster then return end
    parent:RemoveModifierByName("modifier_skill_hero_keji")
    parent:RemoveModifierByName("modifier_skill_hero_keji_wudi")
 end

function modifier_skill_hero_keji:GetEffectName()
    return
        'particles/generic_hero_status/status_invisibility_start.vpcf'  
end

function modifier_skill_hero_keji:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


modifier_skill_hero_keji_wudi=class({})

function modifier_skill_hero_keji_wudi:CheckState()
    local state = {
    [MODIFIER_STATE_INVULNERABLE]=true,
}   return state
end

