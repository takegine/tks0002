LinkLuaModifier("modifier_hero_xiaoguo", 'skill/hero_xiaoguo.lua', 0)
-- LinkLuaModifier("modifier_special_bonus_split_shot_modifiers", 'skill/hero_xiaoguo.lua', 0)

skill_hero_xiaoguo = skill_hero_xiaoguo or class({})

function skill_hero_xiaoguo:GetIntrinsicModifierName()
	return "modifier_hero_xiaoguo"
end

modifier_hero_xiaoguo = modifier_hero_xiaoguo or class({})
-- modifier_special_bonus_split_shot_modifiers	= modifier_special_bonus_split_shot_modifiers or class({}) 
-- (攻击特效？)

-- function modifier_special_bonus_split_shot_modifiers:IsHidden() 		return true end
-- function modifier_special_bonus_split_shot_modifiers:IsPurgable() 	return false end
-- function modifier_special_bonus_split_shot_modifiers:RemoveOnDeath() 	return false end

function modifier_hero_xiaoguo:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
    self.arrow_count = self.ability:GetSpecialValueFor("arrow_count")
	self.split_radius = self.ability:GetSpecialValueFor("split_radius")

end


function modifier_hero_xiaoguo:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
		-- MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
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

                -- local apply_modifiers = self:GetParent():AddNewModifier(self:GetCaster(), self, "special_bonus_split_shot_modifiers", {})

                if #enemies > 0 then
                    for _,enemy in pairs(enemies) do
                        if enemy ~= keys.target then

                            self.split_shot_target = true

                            self:GetParent():PerformAttack(enemy, false, ture, true, true, true, false, false)

                            target_number = target_number + 1

                            if target_number >= self:GetAbility():GetSpecialValueFor("arrow_count") then
                                break
                            end
                            -- local arrow_projectile = {hTarget = enemy,
                            --                         hCaster = target,
                            --                         hAbility = self.ability,
                            --                         iMoveSpeed = self.caster:GetProjectileSpeed(),
                            --                         EffectName = self.caster:GetRangedProjectileName(),
                            --                         SoundName = "",
                            --                         flRadius = 1,
                            --                         bDodgeable = true,
                            --                         bDestroyOnDodge = true,
                            --                         iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
                            --                         OnProjectileHitUnit = function(params, projectileID)
                            --                         SplinterArrowHit(params, projectileID, self)
                            -- end
                            -- }
                            -- TrackingProjectiles:Projectile(arrow_projectile)
                        end
                    end
                end
            end
		end
	end
end

-- function SplinterArrowHit(keys, projectileID, modifier)
-- 	local caster = modifier.caster
-- 	local target = keys.hTarget

-- 	caster:PerformAttack(target, false, false, true, true, false, false, false)
-- end

-- function modifier_hero_xiaoguo:GetActivityTranslationModifiers()
-- 	return "split_shot"
-- end

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

