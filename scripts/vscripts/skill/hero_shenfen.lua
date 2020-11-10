LinkLuaModifier('modifier_skill_hero_shenfen', 'skill/hero_shenfen.lua', 0)


skill_hero_shenfen=class({})

-- function skill_hero_shenfen:GetIntrinsicModifierName()
-- 	return "modifier_skill_hero_shenfen"
-- end

function skill_hero_shenfen:needwaveup()
    local caster = self:GetCaster()
    local ability = self
	caster:AddNewModifier(caster, ability, "modifier_skill_hero_shenfen", {0.01})
	caster:RemoveModifierByName("modifier_skill_hero_shenfen")
	caster:RemoveAbility("skill_hero_shenfen")
	
end


modifier_skill_hero_shenfen=class({})

function modifier_skill_hero_shenfen:DeclareFunctions()
return {
	MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_skill_hero_shenfen:Ondeath(keys)
    local caster = self:GetCaster()
    local parent = self:GetParent()
	local ability= self:GetAbility()
	
	if parent == keys.attacker and parent:GetName() == "npc_dota_hero_riki" then
		local damage_type = ability:GetAbilityDamageType()
		local target_team = ability:GetAbilityTargetTeam()
		local target_types = ability:GetAbilityTargetType()
		local target_flags = ability:GetAbilityTargetFlags()

		local dummy = CreateUnitByName( "npc_damage_dummy",OUT_SIDE_VECTOR, false, parent, parent, parent:GetTeamNumber() )  
		dummy.attack_type  = "god"
		dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

		local enemy = FindUnitsInRadius(parent:GetTeamNumber(), 
													caster:GetOrigin(), 
													nil, 
													1600,
													target_team, 
													target_types, 
													DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
													0, 
													true)

		for key,unit in pairs(enemy) do  
			if unit:IsHero() then 

			local damage = unit:GetMaxHealth()*33/100 

			local  damage_table = {

				attacker     = dummy,
				victim       = unit,
				damage_type  = damage_type,
				damage       = damage, 
				damage_flags = DOTA_DAMAGE_FLAG_NONE
			}
				ApplyDamage(damage_table)
			end  

			if (unit:IsCreep()) then
				unit:Kill(ability, caster)
			end

			if (unit:IsBoss()) then
				unit:Kill(ability, caster)
			end

			if (unit:IsIllusion()) then
				unit:Kill(ability, caster)
			end
		end
	end
    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
end                
