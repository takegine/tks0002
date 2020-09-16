LinkLuaModifier("modifier_hero_xiaoguo", 'skill/hero_xiaoguo.lua', 0)

skill_hero_xiaoguo = skill_hero_xiaoguo or class({})

function skill_hero_xiaoguo:GetIntrinsicModifierName()
	return "modifier_hero_xiaoguo"
end

modifier_hero_xiaoguo = modifier_hero_xiaoguo or class({})


function modifier_hero_xiaoguo:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
    self.arrow_count = self.ability:GetSpecialValueFor("arrow_count")
	self.split_radius = self.ability:GetSpecialValueFor("split_radius")

end


function modifier_hero_xiaoguo:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_hero_xiaoguo:OnAttack(keys)
	if IsServer() then
		if self.caster:IsNull() then return end
	
		local target = keys.target
        local attacker = keys.attacker
        local parent = self:GetParent()


        if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown and not self:GetParent():PassivesDisabled() and self:GetAbility():IsTrained() then
            if self.caster == attacker then
            
                local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), 
                                                attacker:GetAbsOrigin(), 
                                                nil, 
                                                self:GetAbility():GetSpecialValueFor("split_radius"),
                                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                                                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, 
                                                FIND_ANY_ORDER,
                                                false)
                local target_number = 0

                if #enemies > 0 then
                    for _,enemy in pairs(enemies) do
                        if enemy ~= keys.target then

                            self.split_shot_target = true

                            self:GetParent():PerformAttack(enemy, false, RollPercentage(30), true, true, true, false, false)
                            target_number = target_number + 1

                            if target_number >= self:GetAbility():GetSpecialValueFor("arrow_count") then
                                break
                            end
                        end
                    end
                end
            end
		end
	end
end

function modifier_hero_xiaoguo:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end
	
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end

function modifier_hero_xiaoguo:IsPurgable()
	return false
end

function modifier_hero_xiaoguo:IsHidden()
	return true
end

function modifier_hero_xiaoguo:IsDebuff()
	return false
end

