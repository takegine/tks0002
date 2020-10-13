--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-10-05 08:49:38
* @LastEditors: 白喵
* @LastEditTime: 2020-10-06 16:16:25
--]]
item_jewelry_026 = item_jewelry_026 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_jewelry_026_owner","items/2/026", 0 )
LinkLuaModifier( "modifier_item_jewelry_026_hero","items/2/026", 0 )
LinkLuaModifier( "modifier_item_jewelry_026_unit","items/2/026", 0 )
modifier_item_jewelry_026_owner = modifier_item_jewelry_026_owner or {IsHidden = on}--给主公（信使）的效果
modifier_item_jewelry_026_hero = modifier_item_jewelry_026_hero or {IsHidden = off}--给武将的效果
modifier_item_jewelry_026_unit = modifier_item_jewelry_026_hero or {IsHidden = on}--给民兵的效果


function modifier_item_jewelry_026_hero:DeclareFunctions()
    return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_item_jewelry_026_hero:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("p1")
end

function modifier_item_jewelry_026_hero:OnTakeDamage(keys)
    local parent = self:GetParent()
    if not keys.attacker:IsRangedAttacker() then
        return
    end
    if parent ~= keys.unit then
        return
    end
    local dummy = CreateUnitByName( "npc_damage_dummy", OUT_SIDE_VECTOR, false, parent, parent, parent:GetTeamNumber() )
    dummy.attack_type  = "land"
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )
    local info = {
        victim = keys.attacker,
        attacker = dummy,
        damage = keys.attacker.damage_deal/100*self:GetAbility():GetSpecialValueFor("p2"),
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flag = nil,
        ability = self:GetAbility()
    }
    ApplyDamage(info)
end

function modifier_item_jewelry_026_hero:GetTexture()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()    
end