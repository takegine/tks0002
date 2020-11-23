function LightningJump(keys)
		local caster = keys.caster
		local target = keys.target
		local ability = keys.ability
		local level=ability:GetLevel()
		local jump_delay = ability:GetLevelSpecialValueFor("jump_delay", (ability:GetLevel() -1))
		local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() -1))
        if not ability.effect  then
            ability.effect = 1
		end
		print(ability.effect)
		
		local dummy = CreateUnitByName( "npc_damage_dummy",OUT_SIDE_VECTOR, false, caster, caster, caster:GetTeamNumber() )
		dummy.attack_type  = "god"
		dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )
		-- Applies damage to the current target
		ApplyDamage({victim = target, attacker = dummy, damage =0.2*target:GetMaxHealth(), damage_type = ability:GetAbilityDamageType()})
		-- Removes the hidden modifier
		target:RemoveModifierByName("modifier_lianying")
		
		-- Waits on the jump delay
		Timer(jump_delay,
		function()
			local current
			for i=0,ability.instance do
				if ability.target[i] ~= nil then
					if ability.target[i] == target then
						current = i
					end
				end
			end
		
			if target.hit == nil then
				target.hit = {}
			end
			target.hit[current] = true

			ability.jump_count[current] = ability.jump_count[current] - 1
			ability.effect=ability.effect-0.1
			if ability.jump_count[current] > 0 then
				local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
				local closest = radius
				local new_target
				for i,unit in ipairs(units) do
					local unit_location = unit:GetAbsOrigin()
					local vector_distance = target:GetAbsOrigin() - unit_location
					local distance = (vector_distance):Length2D()
					if distance < closest then
						if unit.hit == nil then
							new_target = unit
							closest = distance
						elseif unit.hit[current] == nil then
							new_target = unit
							closest = distance
						end
					end
				end
				if new_target ~= nil then
					local lightningBolt = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, target)
					ParticleManager:SetParticleControl(lightningBolt,0,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))   
					ParticleManager:SetParticleControl(lightningBolt,1,Vector(new_target:GetAbsOrigin().x,new_target:GetAbsOrigin().y,new_target:GetAbsOrigin().z + new_target:GetBoundingMaxs().z ))
					ability.target[current] = new_target
					ability:ApplyDataDrivenModifier(caster, new_target, "modifier_lianying", {})
				else
					ability.target[current] = nil
				end
			else
				ability.target[current] = nil
			end
		end)
	end
	

	function NewInstance(keys)
		local caster = keys.caster
		local ability = keys.ability
		local target = keys.target
		
		if ability.instance == nil then
			ability.instance = 0
			ability.jump_count = {}
			ability.target = {}
		else
			ability.instance = ability.instance + 1
		end
		
		-- Sets the total number of jumps for this instance (to be decremented later)
		ability.jump_count[ability.instance] = ability:GetLevelSpecialValueFor("jump_count", (ability:GetLevel() -1))
		-- Sets the first target as the current target for this instance
		ability.target[ability.instance] = target
	--	ability.effect = 1
		-- Creates the particle between the caster and the first target
		local lightningBolt = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(lightningBolt,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))   
		ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))   
	end
	