--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-10-05 08:49:38
* @LastEditors: 白喵
* @LastEditTime: 2020-10-06 14:56:28
--]]
item_jewelry_025 = item_jewelry_025 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_jewelry_025_owner","items/2/025", 0 )
LinkLuaModifier( "modifier_item_jewelry_025_hero","items/2/025", 0 )
LinkLuaModifier( "modifier_item_jewelry_025_unit","items/2/025", 0 )
modifier_item_jewelry_025_owner = modifier_item_jewelry_025_owner or {IsHidden = on}--给主公（信使）的效果
modifier_item_jewelry_025_hero = modifier_item_jewelry_025_hero or {IsHidden = on,IsDebuff = on}--给武将的效果
modifier_item_jewelry_025_unit = modifier_item_jewelry_025_hero or {IsHidden = on}--给民兵的效果

function modifier_item_jewelry_025_hero:DeclareFunctions()
    return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_item_jewelry_025_hero:OnAttackLanded(keys)
    local parent = self:GetParent()
    if parent ~= keys.attacker then
        return
    end
    if keys.target:IsIllusion() or keys.target:IsSummoned() then
        local dummy = CreateUnitByName( "npc_damage_dummy", OUT_SIDE_VECTOR, false, parent, parent, parent:GetTeamNumber() )
        dummy.attack_type  = "god"
        dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )
        local info = {
            victim = keys.target,
            attacker = dummy,
            damage = self:GetAbility():GetSpecialValueFor("p3"),
            damage_type = DAMAGE_TYPE_PHYSICAL,
            damage_flag = nil,
            ability = self:GetAbility()
        }
        ApplyDamage(info)
    end
    --石兵八阵modifier移除  还未添加
end

function modifier_item_jewelry_025_hero:IsAura()
	return true
end

function modifier_item_jewelry_025_hero:IsAuraActiveOnDeath()
	return false
end

function modifier_item_jewelry_025_hero:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("p1")
end

function modifier_item_jewelry_025_hero:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_jewelry_025_hero:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
end

function modifier_item_jewelry_025_hero:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_jewelry_025_hero:GetModifierAura()
	return "modifier_item_jewelry_025_debuff"
end


LinkLuaModifier( "modifier_item_jewelry_025_debuff","items/2/025", LUA_MODIFIER_MOTION_NONE )
modifier_item_jewelry_025_debuff = modifier_item_jewelry_025_debuff or {}

function modifier_item_jewelry_025_debuff:DeclareFunctions()
    return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end


function modifier_item_jewelry_025_debuff:GetModifierPhysicalArmorBonus()
    return -(self:GetAbility():GetSpecialValueFor("p2"))
    --return 0
end

function modifier_item_jewelry_025_debuff:GetTexture()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()    
end