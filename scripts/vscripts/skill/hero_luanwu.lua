LinkLuaModifier('modifier_skill_hero_luanwu', 'skill/hero_luanwu.lua', 0)
LinkLuaModifier('modifier_luanwu_debuff', 'skill/hero_luanwu.lua', 0)
LinkLuaModifier('modifier_luanwu_du', 'skill/hero_luanwu.lua', 0)
LinkLuaModifier('modifier_luanwu_du_debuff', 'skill/hero_luanwu.lua', 0)



skill_hero_luanwu=class({})

function skill_hero_luanwu:GetIntrinsicModifierName()
	return "modifier_skill_hero_luanwu"
end

function skill_hero_luanwu:GetBehavior()				
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_AUTOCAST + DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function skill_hero_luanwu:OnAbilityPhaseStart()		
    return false 
end

modifier_skill_hero_luanwu=class({})

function modifier_skill_hero_luanwu:IsHidden()	return true end

function modifier_skill_hero_luanwu:DeclareFunctions()
    return{
		MODIFIER_EVENT_ON_ATTACK
    }
end

function modifier_skill_hero_luanwu:OnAttack(keys)
    if IsServer() then
        local caster    = self:GetCaster()
        local attacker  = keys.attacker
        local parent    = self:GetParent()
        local target    = keys.target
        local point  = target:GetOrigin()
        local ability = self:GetAbility()
        local owner = caster:XinShi()  

        local particle_luanwu = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
        local modifier_luanwu_debuff = "modifier_luanwu_debuff"
        local duration = 3
        local radius = 200

        if owner.ship['dushi'] then
            CreateModifierThinker(caster, ability, "modifier_luanwu_du",{duration = 9} , point, parent:GetTeamNumber(), false)
        end

        if keys.attacker == self:GetParent() 
        and self:GetAbility():IsFullyCastable() 
        and not self:GetParent():IsIllusion() 
        and not self:GetParent():PassivesDisabled()  
        then

            local damage_type  = ability:GetAbilityDamageType()   
            local target_team  = ability:GetAbilityTargetTeam()
            local target_types = ability:GetAbilityTargetType()
            local target_flags = ability:GetAbilityTargetFlags()
            local damage       = ability:GetSpecialValueFor("aoe_damage")

            local dummy = CreateUnitByName( "npc_damage_dummy",OUT_SIDE_VECTOR, false, caster, caster, caster:GetTeamNumber() )  
            dummy.attack_type  = "electrical"
            dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

            target:EmitSound("Hero_Crystal.CrystalNova")

            local pfx = ParticleManager:CreateParticle( particle_luanwu, PATTACH_ABSORIGIN, target )
            ParticleManager:SetParticleControl( pfx, 0, target:GetOrigin() )
            ParticleManager:SetParticleControl( pfx, 1, Vector(200,200,200) )
            ParticleManager:ReleaseParticleIndex( pfx )

            local enemies = FindUnitsInRadius(parent:GetTeamNumber(), 
                                            target:GetOrigin(),
                                            nil, 
                                            200, 
                                            target_team, 
                                            target_types, 
                                            target_flags, 
                                            0,
                                            true)

            local  damage_table = {
                attacker     = dummy,
                ability      = ability,
                damage_type  = damage_type,
                damage_flags = DOTA_DAMAGE_FLAG_NONE
            }

            for key,unit in pairs(enemies) do
                local debuff = unit:AddNewModifier(caster, ability, modifier_luanwu_debuff, { duration=3})
                if unit ~= keys.target then 
                    damage_table.damage = damage
                else
                    damage_table.damage = damage*1.5
                end

                damage_table.victim = unit
                ApplyDamage(damage_table) 
            end
            
            self:GetAbility():UseResources(true, true, true)
        end
    end
end



modifier_luanwu_debuff = class({})


function modifier_luanwu_debuff:OnCreated()

	local caster = self:GetCaster()
    local parent = self:GetParent()
    local ability = self:GetAbility()
    self.ms_slow_pct = ability:GetSpecialValueFor('ms_slow')
    self.as_slow = ability:GetSpecialValueFor('as_slow')
end

function modifier_luanwu_debuff:IsHidden() return false end
function modifier_luanwu_debuff:IsPurgable() return true end
function modifier_luanwu_debuff:IsDebuff() return true end

function modifier_luanwu_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end


function modifier_luanwu_debuff:DeclareFunctions()
    local decFuncs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
    return decFuncs
end

function modifier_luanwu_debuff:GetModifierMoveSpeedBonus_Percentage()
    return -self.ms_slow_pct
end

function modifier_luanwu_debuff:GetModifierAttackSpeedBonus_Constant()
    return -self.as_slow
end

modifier_luanwu_du = class({})

function modifier_luanwu_du:OnCreated()

    local caster = self:GetCaster()
	local ability = self:GetAbility()
	local parent = self:GetParent()

    local radius = 250
    self.duration = 30

    if IsServer() then

		pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_upheaval.vpcf", PATTACH_WORLDORIGIN, parent)
		ParticleManager:SetParticleControl(pfx, 0, parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 1, 1))
		self:AddParticle(pfx, false, false, -1, false, false)

		self:StartIntervalThink(1)
	end
end  

function modifier_luanwu_du:OnIntervalThink()
    local caster = self:GetCaster()
    local ability= self:GetAbility()
    local parent = self:GetParent()

    local enemies = FindUnitsInRadius(parent:GetTeamNumber(),
                                    parent:GetAbsOrigin(),
                                    nil,
                                    250,
                                    DOTA_UNIT_TARGET_TEAM_ENEMY,
                                    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                    DOTA_UNIT_TARGET_FLAG_NONE,
                                    FIND_ANY_ORDER,
                                    false)

	for _,unit in pairs(enemies) do
	    unit:AddNewModifier(caster, ability, "modifier_luanwu_du_debuff", {duration = self.duration })
	end
end

modifier_luanwu_du_debuff = class({})

function modifier_luanwu_du_debuff:OnCreated(params)
    local ability = self:GetAbility()
    local damage = ability:GetLevel()*126
    if IsServer() then
        self:OnIntervalThink()
		self:StartIntervalThink(1)
	end
end

function modifier_luanwu_du_debuff:OnRefresh(params)
    local ability = self:GetAbility()
	local damage = ability:GetLevel()*126

	if IsServer() then 	
        self:OnIntervalThink()
    end
end

function modifier_luanwu_du_debuff:OnIntervalThink()
 
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    local damage = ability:GetLevel()*126
    local parent = self:GetParent()
    local damage_type  = ability:GetAbilityDamageType()

    local dummy = CreateUnitByName( "npc_damage_dummy",OUT_SIDE_VECTOR, false, caster, caster, caster:GetTeamNumber() )  
    dummy.attack_type  = "electrical"
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 30} )

    local  damage_table = {
        attacker     = dummy,
        victim       = parent,
        ability      = ability,
        damage_type  = damage_type,
        damage       = damage, 
        damage_flags = DOTA_DAMAGE_FLAG_NONE
    }

    if  damage_table.damage >= parent:GetHealth() then
        damage_table.damage = parent:GetHealth() -1
    end

    ApplyDamage(damage_table)

	SendOverheadEventMessage(self:GetCaster(), OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), damage, nil)
end

function modifier_luanwu_du_debuff:OnTooltip()
	return damage
end

function modifier_luanwu_du_debuff:IsDebuff() return true end
function modifier_luanwu_du_debuff:IsHidden() return false end
function modifier_luanwu_du_debuff:IsStunDebuff() return false end
function modifier_luanwu_du_debuff:RemoveOnDeath() return true end











