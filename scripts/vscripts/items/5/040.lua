item_queue_040 = item_queue_040 or class(item_class)
modifier_item_queue_040 = modifier_item_queue_040 or {
    GetTexture = function (self) return "items/"..self:GetAbility():GetAbilityTextureName() end,
    DeclareFunctions = function () return { MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_PROPERTY_TOOLTIP, MODIFIER_PROPERTY_TOOLTIP2 } end,
}
LinkLuaModifier( "modifier_item_queue_040_hero","items/5/040", 0 )
LinkLuaModifier( "modifier_item_queue_040_unit","items/5/040", 0 )
modifier_item_queue_040_hero = modifier_item_queue_040
modifier_item_queue_040_unit = modifier_item_queue_040
------------------------------------------------------------------

function modifier_item_queue_040:OnTooltip()
    return  self:GetAbilitySpecialValueFor('p1')
end

function modifier_item_queue_040:OnTooltip2()
    return  self:GetAbilitySpecialValueFor('p2')
end

function modifier_item_queue_040:OnTakeDamage(keys)

	if not IsServer() then return end

    local caster   = self:GetCaster()
    local parent   = self:GetParent()
    local ability  = self:GetAbility()
    local attacker = keys.attacker
    local target   = keys.unit

    if IsNull(parent)
    or IsNull(ability)
    then return
    end

    local ranger   = attacker:IsRangedAttacker()
    local p1       = ability:GetSpecialValueFor("p1")
    local p2       = ability:GetSpecialValueFor("p2")

	local damage   = keys.original_damage * ( ranger and p2 or p1 ) /100
	local damage_type  = keys.damage_type
	local damage_flags = keys.damage_flags

    if target == parent
    and not attacker:IsBuilding()
    and attacker:IsOpposingTeam(parent:GetTeamNumber() )
    and not Isbitband(damage_flags, DOTA_DAMAGE_FLAG_HPLOSS)
    and not Isbitband(damage_flags, DOTA_DAMAGE_FLAG_REFLECTION)
    then
        EmitSoundOnClient("DOTA_Item.BladeMail.Damage", attacker:XinShi())

        local dummy = CreateUnitByName( "npc_damage_dummy", OUT_SIDE_VECTOR, false, parent, parent, parent:GetTeamNumber() )
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