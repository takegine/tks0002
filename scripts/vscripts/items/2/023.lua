--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-10-05 08:49:38
* @LastEditors: 白喵
* @LastEditTime: 2020-10-05 16:32:20
--]]
item_jewelry_023 = item_jewelry_023 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_jewelry_023_owner","items/2/023", 0 )
LinkLuaModifier( "modifier_item_jewelry_023_hero","items/2/023", 0 )
LinkLuaModifier( "modifier_item_jewelry_023_unit","items/2/023", 0 )
modifier_item_jewelry_023_owner = modifier_item_jewelry_023_owner or {IsHidden = on}--给主公（信使）的效果
modifier_item_jewelry_023_hero = modifier_item_jewelry_023_hero or {IsHidden = on}--给武将的效果
modifier_item_jewelry_023_unit = modifier_item_jewelry_023_hero or {IsHidden = on}--给民兵的效果


function modifier_item_jewelry_023_hero:DeclareFunctions()
    return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_item_jewelry_023_hero:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("p1")
end

function modifier_item_jewelry_023_hero:OnTakeDamage(keys)
    local parent = self:GetParent()
    if parent:IsRangedAttacker() then
        return
    end
    if self.flag then
        return
    end
    if parent ~= keys.unit then
        return
    end
    if (parent:GetHealth() - keys.damage) < (parent:GetMaxHealth()*0.35) then
        parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_jewelry_023_buff", {duration = self:GetAbility():GetSpecialValueFor("p2")})
        self.flag = true
    end
end


LinkLuaModifier( "modifier_item_jewelry_023_buff","items/2/023", 0 )
modifier_item_jewelry_023_buff = modifier_item_jewelry_023_buff or {}
function modifier_item_jewelry_023_buff:DeclareFunctions()
    return {MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL}
end

function modifier_item_jewelry_023_buff:GetAbsoluteNoDamagePhysical()
    return 1
end

function modifier_item_jewelry_023_buff:GetTexture()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()    
end