item_queue_037 = item_queue_037 or class(item_class)
modifier_item_queue_037 = modifier_item_queue_037 or {
    GetTexture = function (self) return "items/"..self:GetAbility():GetAbilityTextureName() end,
    OnCreated = function (self) self:SetStackCount(1) end,
    DeclareFunctions = function () return { MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_PROPERTY_TOOLTIP } end
}
LinkLuaModifier( "modifier_item_queue_037_hero","items/5/037", 0 )
LinkLuaModifier( "modifier_item_queue_037_unit","items/5/037", 0 )
modifier_item_queue_037_hero = modifier_item_queue_037
modifier_item_queue_037_unit = modifier_item_queue_037
------------------------------------------------------------------

function modifier_item_queue_037:OnAttackLanded( params)
    local attacker= params.attacker
    local parent  = self:GetParent()
    if not IsServer()
    or parent ~= attacker then
        return
    end

    local target  = params.target
    local ability = self:GetAbility()
    local p1      = ability:GetSpecialValueFor('p1')
    local modName = "modifier_item_queue_037_debuff"
    local count   = self:GetStackCount() <6 and self:GetStackCount() or 1
    local dummy   = CreateUnitByName( "npc_damage_dummy", OUT_SIDE_VECTOR, false, parent, parent, parent:GetTeamNumber() )
    dummy.attack_type  = "fire"
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )
    local damage_table = {}

    damage_table.attacker     = dummy
    damage_table.victim       = target
    damage_table.damage_type  = DAMAGE_TYPE_MAGICAL
    damage_table.ability      = ability
    damage_table.damage       = self:OnTooltip()
    -- damage_table.damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION

    if not target:HasModifier(modName) then
        target:AddNewModifier( parent, ability, modName , nil )
    end

    ApplyDamage( damage_table )
    self:SetStackCount( count%5 +1 )

end

function modifier_item_queue_037:OnTooltip( params)
    local ability = self:GetAbility()
    local p1      = ability:GetSpecialValueFor('p1')
    return self:GetStackCount() * p1
end

LinkLuaModifier( "modifier_item_queue_037_debuff","items/5/037", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_037_debuff = modifier_item_queue_037_debuff or {
    IsHidden = off,
    IsDebuff = on,
    IsPurgable = on,
    DeclareFunctions = function () return { MODIFIER_PROPERTY_TOOLTIP } end,
    GetTexture = function (self) return "items/"..self:GetAbility():GetAbilityTextureName() end,
}
-------------------------------------------------------------------------------

function modifier_item_queue_037_debuff:OnCreated()
    
    if IsServer() then

        self.caster  = self:GetCaster()
        self.ability = self:GetAbility()
        self.parent  = self:GetParent()
        self.team    = self.caster:GetTeamNumber()
        self.sound_explode    = "Ability.SandKing_CausticFinale"
        self.particle_explode = "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf"
        self.particle_debuff  = "particles/units/heroes/hero_sandking/sandking_caustic_finale_debuff.vpcf"
        self.modifier_poison  = "modifier_item_queue_037_debuff"
        self.modifier_slow    = "modifier_imba_caustic_finale_debuff"

        -- Ability specials
        self.damage = self.ability:GetSpecialValueFor("p2") * self.parent:GetMaxHealth() /100
        self.radius = 200

        -- Add particle effects repeatedly
        Timer(0.3, function()
            if not self:IsNull() then
                self.particle_debuff_fx = ParticleManager:CreateParticle(self.particle_debuff, PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                ParticleManager:SetParticleControlEnt(self.particle_debuff_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
                self:AddParticle(self.particle_debuff_fx, false, false, -1, false, false)

                return 0.3
            end
        end)
    end
end

function modifier_item_queue_037_debuff:OnDestroy()
    if IsServer() then

        EmitSoundOn(self.sound_explode, self.parent)

        self.particle_explode_fx = ParticleManager:CreateParticle(self.particle_explode, PATTACH_ABSORIGIN, self.parent)
        ParticleManager:SetParticleControl(self.particle_explode_fx, 0, self.parent:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(self.particle_explode_fx)

        local slow_modifier = nil
        local dummy         = CreateUnitByName( "npc_damage_dummy", OUT_SIDE_VECTOR, false, self.caster, self.caster, self.team )
        dummy.attack_type   = "fire"
        dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

        local damage_table = {}

        damage_table.attacker     = dummy
        damage_table.damage_type  = DAMAGE_TYPE_MAGICAL
        damage_table.ability      = self.ability
        damage_table.damage       = self.damage
        damage_table.damage_flags = DOTA_DAMAGE_FLAG_NONE

        local enemies = FindUnitsInRadius(self.team,
        self.parent:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false)

        for _,enemy in pairs(enemies) do
            damage_table.victim = enemy
            ApplyDamage(damage_table)
        end
    end
end

function modifier_item_queue_037_debuff:OnTooltip( params)
    local ability = self:GetAbility()
    local p2      = ability:GetSpecialValueFor('p2')
    return p2
end