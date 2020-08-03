item_queue_baguazhen = item_queue_baguazhen or class(item_class)

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_baguazhen","items/5/baguazhen", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_baguazhen = modifier_item_queue_baguazhen or {}


function modifier_item_queue_baguazhen:GetTexture ()
    return "queue/八卦"
end

function modifier_item_queue_baguazhen:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2
    }
end

function modifier_item_queue_baguazhen:OnTooltip()
    local ability  = self:GetAbility()
    local parent   = self:GetParent()
    local p1       = ability:GetSpecialValueFor("p1")
    local p2       = ability:GetSpecialValueFor("p2")
    return  p1
end

function modifier_item_queue_baguazhen:OnTooltip2()
    local ability  = self:GetAbility()
    local parent   = self:GetParent()
    local p1       = ability:GetSpecialValueFor("p1")
    local p2       = ability:GetSpecialValueFor("p2")
    return  p2
end

function modifier_item_queue_baguazhen:OnTakeDamage(keys)

	if not IsServer() then return end

    local caster   = self:GetCaster()
    local parent   = self:GetParent()
    local ability  = self:GetAbility()
    local attacker = keys.attacker
    local target   = keys.unit
    local ranger   = attacker:IsRangedAttacker()
    local p1       = ability:GetSpecialValueFor("p1")
    local p2       = ability:GetSpecialValueFor("p2")

	local damage   = keys.original_damage * ( ranger and p2 or p1 ) /100
	local damage_type  = keys.damage_type
	local damage_flags = keys.damage_flags

    if target == parent
    and not attacker:IsBuilding()
    and attacker:IsOpposingTeam(parent:GetTeamNumber() )
    and bit.band(damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS
    and bit.band(damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
        EmitSoundOnClient("DOTA_Item.BladeMail.Damage", attacker:GetPlayerOwner())

        local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, parent, parent, parent:GetTeamNumber() )
        dummy.attack_type  = "electrical"
        dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

        local damage_table = {}

        damage_table.attacker     = dummy
        damage_table.victim       = attacker
        damage_table.damage_type  = DAMAGE_TYPE_MAGICAL
        damage_table.ability      = ability
        damage_table.damage       = damage
        damage_table.damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION

        local reflectDamage = ApplyDamage(damage_table)
	end
end