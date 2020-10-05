item_jewelry_020 = item_jewelry_020 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_jewelry_020_owner","items/2/020", 0 )
LinkLuaModifier( "modifier_item_jewelry_020_hero","items/2/020", 0 )
LinkLuaModifier( "modifier_item_jewelry_020_unit","items/2/020", 0 )
modifier_item_jewelry_020_owner = modifier_item_jewelry_020_owner or {IsHidden = on}--给主公（信使）的效果
modifier_item_jewelry_020_hero = modifier_item_jewelry_020_hero or {IsHidden = on}--给武将的效果
modifier_item_jewelry_020_unit = modifier_item_jewelry_020_unit or {IsHidden = on}--给民兵的效果
function modifier_item_jewelry_020_hero:IsAura()
	return true
end

function modifier_item_jewelry_020_hero:IsAuraActiveOnDeath()
	return false
end

function modifier_item_jewelry_020_hero:IsDebuff()
    return true
end

function modifier_item_jewelry_020_hero:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("p1")
end

function modifier_item_jewelry_020_hero:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_jewelry_020_hero:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
end

function modifier_item_jewelry_020_hero:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_jewelry_020_hero:GetModifierAura()
	return "modifier_item_jewelry_020_debuff"
end


LinkLuaModifier( "modifier_item_jewelry_020_debuff","items/2/020", LUA_MODIFIER_MOTION_NONE )
modifier_item_jewelry_020_debuff = modifier_item_jewelry_020_debuff or {}
function modifier_item_jewelry_020_debuff:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
end

function modifier_item_jewelry_020_debuff:GetTexture()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_jewelry_020_debuff:OnIntervalThink()
    local parent = self:GetParent()
    local hpreduce = parent:GetMaxHealth()/100*self:GetAbility():GetSpecialValueFor("p2")
    local curheal = parent:GetHealth()
    if curheal > hpreduce then
        parent:SetHealth(curheal - hpreduce)
    else
        parent:SetHealth(1)
    end
end