
LinkLuaModifier('modifier_lijian_damage', 'skill/hero_lijian.lua', 0)
LinkLuaModifier('modifier_lijian_speed', 'skill/hero_lijian.lua', 0)

skill_hero_lijian=class({})

function  skill_hero_lijian:OnSpellStart()

    local  caster=self:GetCaster()
    local  target=self:GetCursorTarget()
    local  owner =caster:XinShi()

if not  IsServer() then  return end

target:AddNewModifier(caster, self, 'modifier_lijian_damage', {duration=60})
if  owner.ship['meiren'] then
target:AddNewModifier(caster, self, 'modifier_lijian_speed', {duration=60})
end
end

modifier_lijian_damage=class({})

function modifier_lijian_damage:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
    }
end

function modifier_lijian_damage:GetModifierBaseDamageOutgoing_Percentage()
    local caster=self:GetCaster()
    return 20+caster:GetLevel()*3
end


modifier_lijian_speed=class({})

function modifier_lijian_speed:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end

function modifier_lijian_speed:GetModifierAttackSpeedBonus_Constant()
    local caster=self:GetCaster()
    return caster:GetLevel()*5
end