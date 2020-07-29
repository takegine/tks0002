

LinkLuaModifier("modifier_skill_hero_keji",'skill/hero_keji.lua',0)
LinkLuaModifier("modifier_skill_hero_keji_wudi",'skill/hero_keji.lua',0)

skill_hero_keji=class({})

function skill_hero_keji:OnSpellStart()

local caster=self:GetCaster()
local ability=self
local owner  = caster:GetOwner() or {ship={}}  


caster:AddNewModifier(caster, ability, 'modifier_skill_hero_keji', {duration=1.5})

if owner.ship['siying']  then

caster:AddNewModifier(caster,ability,"modifier_skill_hero_keji_wudi",{Duration=1.5})

end 

end





modifier_skill_hero_keji=class({})

function modifier_skill_hero_keji:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
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

modifier_skill_hero_keji_wudi=class({})

function modifier_skill_hero_keji_wudi:CheckState()
    local state = {
    [MODIFIER_STATE_INVULNERABLE]=true,
}   return state
end