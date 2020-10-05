--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-10-05 08:49:38
* @LastEditors: 白喵
* @LastEditTime: 2020-10-05 13:47:46
--]]
item_jewelry_021 = item_jewelry_021 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_jewelry_021_owner","items/2/021", 0 )
LinkLuaModifier( "modifier_item_jewelry_021_hero","items/2/021", 0 )
LinkLuaModifier( "modifier_item_jewelry_021_unit","items/2/021", 0 )
modifier_item_jewelry_021_owner = modifier_item_jewelry_021_owner or {IsHidden = on}--给主公（信使）的效果
modifier_item_jewelry_021_hero = modifier_item_jewelry_021_hero or {IsHidden = on}--给武将的效果
modifier_item_jewelry_021_unit = modifier_item_jewelry_021_unit or {IsHidden = on}--给民兵的效果
function modifier_item_jewelry_021_hero:IsAura()
	return true
end

function modifier_item_jewelry_021_hero:IsAuraActiveOnDeath()
	return false
end

function modifier_item_jewelry_021_hero:IsDebuff()
    return false
end

function modifier_item_jewelry_021_hero:GetAuraRadius()
    return 3000
end

function modifier_item_jewelry_021_hero:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_jewelry_021_hero:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_jewelry_021_hero:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
end

function modifier_item_jewelry_021_hero:GetModifierAura()
	return "modifier_item_jewelry_021_buff"
end


LinkLuaModifier( "modifier_item_jewelry_021_buff","items/2/021", LUA_MODIFIER_MOTION_NONE )
modifier_item_jewelry_021_buff = modifier_item_jewelry_021_buff or {}
function modifier_item_jewelry_021_buff:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
end

function modifier_item_jewelry_021_buff:GetTexture()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_jewelry_021_buff:OnIntervalThink()
    local parent = self:GetParent()
    local heal = parent:GetMaxHealth()/100*self:GetAbility():GetSpecialValueFor("p1")
    parent:Heal(heal,nil)
end