--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-10-16 14:21:36
* @LastEditors: 白喵
* @LastEditTime: 2020-10-24 23:27:11
--]]
item_format_035 = item_format_035 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_format_035_owner","items/4/035", 0 )
LinkLuaModifier( "modifier_item_format_035_hero","items/4/035", 0 )
LinkLuaModifier( "modifier_item_format_035_unit","items/4/035", 0 )
modifier_item_format_035_owner = modifier_item_format_035_owner or {IsHidden = on}--给主公（信使）的效果
modifier_item_format_035_hero = modifier_item_format_035_hero or {IsHidden = on}--给武将的效果
modifier_item_format_035_unit = modifier_item_format_035_hero or {IsHidden = on}--给民兵的效果

function modifier_item_format_035_hero:OnCreated(keys)
    if not IsServer() then
        return
    end
    local parent = self:GetParent()
    local ability =  self:GetAbility()
    local p1 = ability:GetSpecialValueFor("p1")
    parent:AddNewModifier( parent, ability, "modifier_defend_big", {fire = p1,electrical = p1})
end

function modifier_item_format_035_hero:DeclareFunctions()
    return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_item_format_035_hero:OnTakeDamage(keys)
    if self.flag then
        return
    end
    local parent = self:GetParent()
    if parent ~= keys.unit then
        return
    end
    if (parent:GetHealth()-damage_fix(keys.attacker,keys.unit,keys.damage))/parent:GetMaxHealth() <= 0.35 then
        parent:AddNewModifier(parent, self:GetAbility(), "modifier_custom_shield", {shield_value = self:GetAbility():GetSpecialValueFor("p2"),fire = true,electrical = true})
        self.flag = true
    end
end



