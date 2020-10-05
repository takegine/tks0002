--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-10-05 08:49:38
* @LastEditors: 白喵
* @LastEditTime: 2020-10-05 17:10:12
--]]
item_jewelry_024 = item_jewelry_024 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_jewelry_024_owner","items/2/024", 0 )
LinkLuaModifier( "modifier_item_jewelry_024_hero","items/2/024", 0 )
LinkLuaModifier( "modifier_item_jewelry_024_unit","items/2/024", 0 )
modifier_item_jewelry_024_owner = modifier_item_jewelry_024_owner or {IsHidden = on}--给主公（信使）的效果
modifier_item_jewelry_024_hero = modifier_item_jewelry_024_hero or {IsHidden = on,IsDebuff = on}--给武将的效果
modifier_item_jewelry_024_unit = modifier_item_jewelry_024_hero or {IsHidden = on}--给民兵的效果

function modifier_item_jewelry_024_hero:DeclareFunctions()
    return {MODIFIER_PROPERTY_MANA_REGEN_CONSTANT}
end

function modifier_item_jewelry_024_hero:GetModifierConstantManaRegen()
    return self:GetAbility():GetSpecialValueFor("p3")
end
function modifier_item_jewelry_024_hero:IsAura()
	return true
end

function modifier_item_jewelry_024_hero:IsAuraActiveOnDeath()
	return false
end

function modifier_item_jewelry_024_hero:GetAuraRadius()
    return 1280
end

function modifier_item_jewelry_024_hero:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_jewelry_024_hero:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
end

function modifier_item_jewelry_024_hero:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_jewelry_024_hero:GetModifierAura()
	return "modifier_item_jewelry_024_debuff"
end


LinkLuaModifier( "modifier_item_jewelry_024_debuff","items/2/024", LUA_MODIFIER_MOTION_NONE )
modifier_item_jewelry_024_debuff = modifier_item_jewelry_024_debuff or {}

function modifier_item_jewelry_024_debuff:DeclareFunctions()
    return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
end

function modifier_item_jewelry_024_debuff:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
end

function modifier_item_jewelry_024_debuff:OnIntervalThink()
    local parent = self:GetParent()
    local hpreduce = parent:GetMaxHealth()/100*3
    local curheal = parent:GetHealth()
    if curheal > hpreduce then
        parent:SetHealth(curheal - hpreduce)
    else
        parent:SetHealth(1)
    end
end

function modifier_item_jewelry_024_debuff:GetModifierMagicalResistanceBonus()
    return -(self:GetAbility():GetSpecialValueFor("p2"))
end

function modifier_item_jewelry_024_debuff:GetTexture()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()    
end