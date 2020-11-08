


LinkLuaModifier('modifier_aura_feiying_jueying', 'skill/hero_feiying.lua', 0)
LinkLuaModifier('modifier_feiying_jueying', 'skill/hero_feiying.lua', 0)
LinkLuaModifier('modifier_feiying_zhuahuang', 'skill/hero_feiying.lua', 0)
LinkLuaModifier('modifier_feiying_qilin', 'skill/hero_feiying.lua', 0)
LinkLuaModifier('modifier_aura_feiying_qilin', 'skill/hero_feiying.lua', 0)

skill_hero_feiying=class({})

function skill_hero_feiying:needwaveup()

local caster=self:GetCaster()
caster:AddNewModifier(caster, self, "modifier_aura_feiying_jueying", {})  
caster:AddNewModifier(caster, self, "modifier_aura_feiying_qilin", {})  

if caster:HasModifier('modifier_item_horses_013_hero')   
then caster:RemoveModifierByName('modifier_item_horses_013_hero')
end

local damage_type  = self:GetAbilityDamageType()
local target_team  = self:GetAbilityTargetTeam()
local target_types = self:GetAbilityTargetType()
local target_flags = self:GetAbilityTargetFlags()
    
local friend = FindUnitsInRadius(caster:GetTeamNumber(), 
                            caster:GetOrigin(), 
                            nil, 
                            2000,
                            target_team, 
                            target_types, 
                            target_flags, 
                            0, 
                            true)

for key,unit in pairs(friend) do
unit:AddNewModifier(caster, self, "modifier_feiying_zhuahuang", {})
unit:AddNewModifier(caster, self, "modifier_feiying_qilin", {})
if unit:HasModifier('modifier_item_horses_015_hero') 
then unit:RemoveModifierByName('modifier_item_horses_015_hero')
end
end
caster:RemoveModifierByName('modifier_feiying_zhuahuang')
end


modifier_aura_feiying_jueying=class({})  --绝影光环

function modifier_aura_feiying_jueying:IsAura()
    return true
end 

function modifier_aura_feiying_jueying:IsAuraActiveOnDeath()
    return false 
end 

function modifier_aura_feiying_jueying:IsDebuff()
    return true
end

function modifier_aura_feiying_jueying:GetAuraRadius()
    return 1600
end

function modifier_aura_feiying_jueying:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_aura_feiying_jueying:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end 

function modifier_aura_feiying_jueying:GetModifierAura()
    return 'modifier_feiying_jueying'
end

function modifier_aura_feiying_jueying:IsHidden()
    return true
end
 

modifier_feiying_jueying=class({})  --5级绝影减攻速

function modifier_feiying_jueying:IsHidden()
    return true
end
 

function modifier_feiying_jueying:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end 

function modifier_feiying_jueying:GetModifierAttackSpeedBonus_Constant()
    return  -50
end


modifier_feiying_zhuahuang=class({})  --5级爪黄效果

function modifier_feiying_zhuahuang:IsHidden()
    return true
end
 
function modifier_feiying_zhuahuang:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_feiying_zhuahuang:GetModifierMoveSpeedBonus_Percentage()
    return  15
end

function modifier_feiying_zhuahuang:OnAttackLanded(keys)
    
    local parent =self:GetParent()
    local percent=250 
    local movespeed=keys.attacker:GetMoveSpeedModifier(keys.attacker:GetBaseMoveSpeed(),true)  --获取当前的移速，包括buff加长或减速

    if not IsServer() then  return end
    if keys.attacker~=parent then  return end
    if movespeed>=520 then  movespeed=520 end

    local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, parent, parent, parent:GetTeamNumber() )
    dummy.attack_type  = "land"
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )
    local  damage_table = {
        attacker     = dummy,
        victim       = keys.target,
        damage_type  = DAMAGE_TYPE_PHYSICAL,
        damage       = movespeed*percent/100,
        damage_flags = DOTA_DAMAGE_FLAG_NONE
    }
        ApplyDamage(damage_table)

end

modifier_aura_feiying_qilin=class({})  --免疫麒麟弓光环

function modifier_aura_feiying_qilin:IsAura()
    return true
end 

function modifier_aura_feiying_qilin:IsAuraActiveOnDeath()
    return false 
end 

function modifier_aura_feiying_qilin:IsDebuff()
    return true
end

function modifier_aura_feiying_qilin:GetAuraRadius()
    return 2000
end

function modifier_aura_feiying_qilin:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_aura_feiying_qilin:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end 

function modifier_aura_feiying_qilin:GetModifierAura()
    return 'modifier_feiying_qilin'
end

function modifier_aura_feiying_qilin:IsHidden()
    return true
end
 

modifier_feiying_qilin=class({})

function modifier_feiying_qilin:IsHidden()
    return true
end