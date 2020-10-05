--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-10-05 08:49:38
* @LastEditors: 白喵
* @LastEditTime: 2020-10-05 13:59:10
--]]
item_jewelry_021 = item_jewelry_021 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_jewelry_021_owner","items/2/021", 0 )
LinkLuaModifier( "modifier_item_jewelry_021_hero","items/2/021", 0 )
LinkLuaModifier( "modifier_item_jewelry_021_unit","items/2/021", 0 )
modifier_item_jewelry_021_owner = modifier_item_jewelry_021_owner or {IsHidden = on}--给主公（信使）的效果
modifier_item_jewelry_021_hero = modifier_item_jewelry_021_hero or {IsHidden = off,IsDebuff = off}--给武将的效果
modifier_item_jewelry_021_unit = modifier_item_jewelry_021_unit or {IsHidden = on}--给民兵的效果

function modifier_item_jewelry_021_hero:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
end

function modifier_item_jewelry_021_hero:GetTexture()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_jewelry_021_hero:OnIntervalThink()
    local parent = self:GetParent()
    local heal = parent:GetMaxHealth()/100*self:GetAbility():GetSpecialValueFor("p1")
    --local heal = parent:GetMaxHealth()/100*20
    parent:Heal(heal,nil)
end