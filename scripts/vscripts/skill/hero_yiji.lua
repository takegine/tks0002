LinkLuaModifier('modifier_skill_hero_yiji', 'skill/hero_yiji.lua', 0)
LinkLuaModifier('modifier_skill_hero_yiji_debuff', 'skill/hero_yiji.lua', 0)
LinkLuaModifier('modifier_skill_hero_yiji_blizzard', 'skill/hero_yiji.lua', 0)


skill_hero_yiji=class({})

function skill_hero_yiji:GetIntrinsicModifierName()  --声明技能实践  技能释放
    return "modifier_skill_hero_yiji"
end


modifier_skill_hero_yiji = class({})

function modifier_skill_hero_yiji:IsHidden()
    return true
end

function modifier_skill_hero_yiji:DeclareFunctions()
return {
    MODIFIER_EVENT_ON_DEATH
}
end

function modifier_skill_hero_yiji:OnDeath(keys)
    local parent  = self:GetParent()
    if keys.unit~= parent then
        return
    end
    -- local duration = self:GetSpecialValueFor("duration") - self:GetSpecialValueFor("pulse_interval")
    local ability = self:GetAbility()
    local point   = self:GetCaster():GetAbsOrigin()
    local duration = 3

    local dummy = CreateUnitByName( "npc_damage_dummy",OUT_SIDE_VECTOR, false, parent, parent, parent:GetTeamNumber() )--
    dummy.attack_type   = "electrical"
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = duration} )

    CreateModifierThinker(dummy, ability, "modifier_skill_hero_yiji_blizzard",{duration = duration} , point, parent:GetTeam(), false)
end



modifier_skill_hero_yiji_blizzard = class({})
function modifier_skill_hero_yiji_blizzard:OnCreated()
    if IsServer() then
        
    local parent = self:GetParent()
    local ability= self:GetAbility()
    self.radius = ability:GetSpecialValueFor("radius")
    self.damage = ability:GetSpecialValueFor("damage")

    -- self.dummy  = dummy
    self.point  = parent:GetAbsOrigin()
    self.team   = parent:GetTeamNumber()
    self.target_team  = ability:GetAbilityTargetTeam()
    self.target_types = ability:GetAbilityTargetType()
    self.target_flags = ability:GetAbilityTargetFlags()
    self:OnIntervalThink()
    self:StartIntervalThink(1)
    end
end

function modifier_skill_hero_yiji_blizzard:OnIntervalThink()

    local caster = self:GetCaster()
    local ability= self:GetAbility()
    local parent = self:GetParent()
    local point  = self.point
    local dummy  = self.dummy
    local radius = self.radius
    local damage = self.damage
    local duration = 3
    local modifier_slow ="modifier_skill_hero_yiji_debuff"

    local nfx_name = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_snow_arcana1.vpcf"
	local nfx = ParticleManager:CreateParticle( nfx_name, PATTACH_POINT, parent)
                ParticleManager:SetParticleControl(nfx, 0, point)
                ParticleManager:SetParticleControl(nfx, 4, Vector(radius, radius, radius))
                ParticleManager:ReleaseParticleIndex(nfx)
            
                local enemies = FindUnitsInRadius(self.team,
                                                point,
                                                nil,
                                                radius,
                                                self.target_team,
                                                self.target_types,
                                                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                                                0,
                                                true)

    for _,enemy in pairs(enemies) do
    local debuff = enemy:AddNewModifier(self, ability, modifier_slow, {duration = duration})
        if  enemy:IsMagicImmune() then
            return 
        end
			local  damage_table = {

                attacker     = caster,
                victim       = enemy,
                ability      = ability,
                damage_type  = DAMAGE_TYPE_MAGICAL,
                damage       = damage, 
                damage_flags = DOTA_DAMAGE_FLAG_NONE
            }
                ApplyDamage(damage_table)
    end
end


modifier_skill_hero_yiji_debuff = class({})
function modifier_skill_hero_yiji_debuff:OnCreated()

	local caster = self:GetCaster()
    local parent = self:GetParent()
    local ability = self:GetAbility()
    self.ms_slow_pct = -60
    self.as_slow = -30
end

function modifier_skill_hero_yiji_debuff:IsHidden() return false end
function modifier_skill_hero_yiji_debuff:IsPurgable() return true end
function modifier_skill_hero_yiji_debuff:IsDebuff() return true end

function modifier_skill_hero_yiji_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end


function modifier_skill_hero_yiji_debuff:DeclareFunctions()
    local decFuncs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
    return decFuncs
end

function modifier_skill_hero_yiji_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.ms_slow_pct
end

function modifier_skill_hero_yiji_debuff:GetModifierAttackSpeedBonus_Constant()
    return self.as_slow
end


