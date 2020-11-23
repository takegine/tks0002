

LinkLuaModifier("modifier_skill_hero_roulin",'skill/hero_roulin.lua',0)
LinkLuaModifier("modifier_skill_hero_shanbi",'skill/hero_roulin.lua',0)
skill_hero_roulin=class({})

function skill_hero_roulin:needwaveup()  
    local caster=self:GetCaster()
    caster:AddNewModifier(caster, self, "skill_hero_roulin", {})
 end


modifier_skill_hero_roulin=class({})

function modifier_skill_hero_roulin:IsHidden()
    return true 
end

function modifier_skill_hero_roulin:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_skill_hero_roulin:OnAttackLanded(keys)

local caster=self:GetCaster()
local modifierName = "modifier_skill_hero_shanbi"
local ability=self:GetAbility()
local current_stack=caster:GetModifierStackCount(modifierName, ability)
if keys.attacker~= caster then  return end
if not IsServer() then  return end


if caster:HasModifier(modifierName)  and current_stack<=9  then

local mod=caster:AddNewModifier(caster, self, 'modifier_skill_hero_shanbi', {duration=5})
mod:SetStackCount(current_stack+1) 

elseif caster:HasModifier(modifierName)  and current_stack==10  then

local mod=caster:AddNewModifier(caster, self, 'modifier_skill_hero_shanbi', {duration=5})
mod:SetStackCount(10)   

else 

local mod=caster:AddNewModifier(caster, self, 'modifier_skill_hero_shanbi', {duration=5})
mod:SetStackCount(1)   

end

end

modifier_skill_hero_shanbi=class({})

function modifier_skill_hero_shanbi:GetTexture()
    return 'qunxiong/ability_roulin'
end

function modifier_skill_hero_shanbi:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_EVASION_CONSTANT
    }
end

function modifier_skill_hero_shanbi:GetModifierEvasion_Constant()
    return self:GetStackCount()*5
end


