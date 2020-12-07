modifier_cast_auto = modifier_cast_auto or {
    IsHidden=on,
    IsPurgable=off,
    RemoveOnDeath=off,
    OnCreated = function (self, data)
        self.caster  = self:GetParent()
        self.ability = self:GetAbility()
        self.modName = data.modName--"modifier_skill_hero_tiandu_buff"
        self.autocast_radius = data.autocast_radius--self.ability:GetSpecialValueFor("autocast_radius")

        self.ability:ToggleAutoCast()
    end,

    DeclareFunctions = function (self )
        return
        {
            MODIFIER_EVENT_ON_ATTACK,
            MODIFIER_EVENT_ON_RESPAWN
        }
    end,

    OnRespawn = function (self, keys)
        -- 只适用于施法者本身的单位
        if keys.unit == self.caster then
            self.caster:AddNewModifier(self.caster, self.ability, self.modName, {})
        end
    end,

    OnAttack = function (self, keys)
        local target = keys.target

        if not self.ability:GetAutoCastState()
        or not self.ability:IsCooldownReady()
        or self.caster:IsChanneling()
        or target:IsOpposingTeam(self.caster:GetTeamNumber())
        or target:HasModifier( self.modName )
        or (self.caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > self.autocast_radius then
            return
        end

        self.caster:CastAbilityOnTarget(target, self.ability, self.caster:GetPlayerID())
    end,

}