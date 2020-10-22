--源自imba的术士致命链接
-- Editors:
--     Shush, 25.04.2017
--     naowin, 11.07.2018

-----------------------------
--      FATAL BONDS        --
-----------------------------
skill_hero_liansuo = class({})
LinkLuaModifier("modifier_imba_fatal_bonds", "skill/hero_liansuo.lua", LUA_MODIFIER_MOTION_NONE)

function skill_hero_liansuo:GetAbilityTextureName() return "warlock_fatal_bonds" end

function skill_hero_liansuo:IsHiddenWhenStolen() return false end

function skill_hero_liansuo:OnSpellStart()
	-- Ability properties
	local caster 	= self:GetCaster()
	local ability	= self
	local target 	= self:GetCursorTarget()
	local sound_cast= "Hero_Warlock.FatalBonds"
	local particle_base	 = "particles/units/heroes/hero_warlock/warlock_fatal_bonds_base.vpcf"
	local particle_hit 	 = "particles/units/heroes/hero_warlock/warlock_fatal_bonds_hit.vpcf"
	local modifier_bonds = "modifier_imba_fatal_bonds"

	-- Ability specials
	local max_targets 	 = ability:GetSpecialValueFor("max_targets")
	local duration		 = ability:GetSpecialValueFor("duration")
	local link_in_radius = ability:GetSpecialValueFor("link_in_radius")

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)
	
	-- Initialize variables
	local targets_linked= 0
	local linked_units 	= {}
	local bond_table 	= {}
	local modifier_table= {}

	-- If target has Linken's Sphere off cooldown, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	local bond_target = target

	for link = 1, max_targets do
		-- Find enemies and apply it on them as well, up to the maximum
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			bond_target:GetAbsOrigin(), nil,
			link_in_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NO_INVIS,
			FIND_CLOSEST,
			false)
			
		for _,enemy in pairs(enemies) do
			if  not linked_units[enemy:GetEntityIndex()] then
				local bond_modifier = enemy:AddNewModifier(caster, ability, modifier_bonds, {duration = duration * (1 - enemy:GetStatusResistance())})
				table.insert(modifier_table, bond_modifier)
				
				table.insert(bond_table, enemy)
				linked_units[enemy:GetEntityIndex()] = true

				-- If it was the main target, link from Warlock to it - otherwise, link from the target to them
				local particle_hit_fx = ParticleManager:CreateParticle(particle_hit, PATTACH_CUSTOMORIGIN_FOLLOW, caster)

				if enemy == target then 
					 ParticleManager:SetParticleControlEnt(particle_hit_fx, 0, caster     , PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
				else ParticleManager:SetParticleControlEnt(particle_hit_fx, 0, bond_target, PATTACH_POINT_FOLLOW, "attach_hitloc", bond_target:GetAbsOrigin(), true)
					
				end
				ParticleManager:SetParticleControlEnt(particle_hit_fx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(particle_hit_fx)
				bond_target	= enemy
				
				break
			end
		end
		--print(link,#modifier_table)
		-- Break out of outer loop early if last loop iteration didn't successfully apply another modifier
		if link > #modifier_table then break end
	end

	-- Put the bond table on all enemies' debuff modifiers
	for _, modifiers in pairs(modifier_table) do
		modifiers.bond_table = bond_table
	end
	
end

modifier_imba_fatal_bonds = class({})

function modifier_imba_fatal_bonds:IsHidden() return false end
function modifier_imba_fatal_bonds:IsPurgable() return true end
function modifier_imba_fatal_bonds:IsDebuff() return true end
function modifier_imba_fatal_bonds:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_fatal_bonds:GetEffectName() return "particles/units/heroes/hero_warlock/warlock_fatal_bonds_icon.vpcf" end
function modifier_imba_fatal_bonds:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_fatal_bonds:ShouldUseOverheadOffset() return true end

function modifier_imba_fatal_bonds:OnCreated()
	-- Ability properties
	self.caster  = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent  = self:GetParent()
	self.sound_damage = "Hero_Warlock.FatalBondsDamage" 
	self.particle_hit = "particles/units/heroes/hero_warlock/warlock_fatal_bonds_hit.vpcf" 

	-- Ability specials
	self.link_damage_share_pct	= self.ability:GetSpecialValueFor("link_damage_share_pct")
	self.golem_link_radius		= self.ability:GetSpecialValueFor("golem_link_radius")
	self.golem_link_damage_pct	= self.ability:GetSpecialValueFor("golem_link_damage_pct")
 
end

function modifier_imba_fatal_bonds:OnDestroy()
	if not IsServer() or self:GetParent():IsAlive() then return end

	-- Check every unit that was linked by this modifier
	for _, enemy in pairs(self.bond_table) do
		if not enemy:IsNull() then--enemy ~= self:GetParent()
			for _, modifier in pairs(enemy:FindAllModifiersByName(self:GetName())) do  -- For each link modifier, check its own bond table
				for num,unit in pairs(modifier.bond_table) do-- Do it in descending order so there aren't weird indexing issues when removing entries
					if unit == self:GetParent() or unit:IsNull() then-- If the parent is found in that table, remove it so they don't keep taking damage after respawning
						table.remove(modifier.bond_table, num) --break
					end
				end
			end
		end
	end
end

function modifier_imba_fatal_bonds:DeclareFunctions() return { MODIFIER_EVENT_ON_TAKEDAMAGE } end

function modifier_imba_fatal_bonds:OnTakeDamage(keys)
	if not IsServer() or bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then return end
	--除了reflection都通过,因为flag有可能不止一个 不能直接比 就是判断有没有不能反弹的伤害标记 有就不通过
	if keys.unit ~= self.parent or not self.bond_table then return end-- Only apply if the unit taking damage is the parent 

	local unit    = keys.unit
	local target  = keys.target
	local attacker= keys.attacker
	local ori_dam = keys.original_damage
	local damage_type = keys.damage_type
	local inflictor   = keys.inflictor
	
	for _, bonded_enemy in pairs(self.bond_table) do
		if not bonded_enemy:IsNull() and bonded_enemy ~= self.parent then

			local particle_hit_fx = ParticleManager:CreateParticle(self.particle_hit, PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
			ParticleManager:SetParticleControlEnt(particle_hit_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle_hit_fx, 1, bonded_enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", bonded_enemy:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle_hit_fx)

			EmitSoundOn(self.sound_damage, bonded_enemy)

			local damageTable = {
				victim			= bonded_enemy,
				damage			= ori_dam * self.link_damage_share_pct * 0.01,
				damage_type		= damage_type,
				attacker		= self.caster,
				ability			= self.ability,
				damage_flags	= DOTA_DAMAGE_FLAG_REFLECTION
			} 
			ApplyDamage(damageTable)
		end
	end
end