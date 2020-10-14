item_weapon_002 = item_weapon_002 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_weapon_002_owner","items/0/002", 0 )
LinkLuaModifier( "modifier_item_weapon_002_hero","items/0/002", 0 )
LinkLuaModifier( "modifier_item_weapon_002_unit","items/0/002", 0 )
modifier_item_weapon_002_owner = modifier_item_weapon_002_owner or {}--给主公（信使）的效果
modifier_item_weapon_002_hero = modifier_item_weapon_002_hero or {}--给武将的效果
modifier_item_weapon_002_unit = modifier_item_weapon_002_unit or {}--给民兵的效果


function item_weapon_002:GetIntrinsicModifierName()
	return "modifier_item_weapon_002_hero"
end

function modifier_item_weapon_002_hero:OnCreated()
	local ability = self:GetAbility()
    local arrow_count = 2
	local split_radius = ability:GetSpecialValueFor("p1")
    local owner = self:GetParent()
    if  not owner:IsRealHero() then
        owner:AddNewModifier(owner, ability, "modifier_item_weapon_002_unit", {}) 
    end
end

function modifier_item_weapon_002_hero:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_item_weapon_002_hero:OnAttack(keys)
	if IsServer() then	
		local target = keys.target
        local attacker = keys.attacker
        local owner = self:GetParent()
        local ability = self:GetAbility()
        local caster = self:GetCaster()

        if caster:IsNull() then return end

        if attacker:IsRangedAttacker() and keys.attacker == owner and keys.target and keys.target:GetTeamNumber() ~= owner:GetTeamNumber() and not keys.no_attack_cooldown and not owner:IsIllusion() then
            if caster == attacker then
            
                local enemies = FindUnitsInRadius(owner:GetTeamNumber(), 
                                                attacker:GetAbsOrigin(), 
                                                nil, 
                                                ability:GetSpecialValueFor("p1"),
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

                            if target_number >= 2 then
                                break
                            end
                        end
                    end
                end
            end
		end
	end
end

function modifier_item_weapon_002_hero:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end
	
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end

function modifier_item_weapon_002_hero:IsPurgable() return false end
function modifier_item_weapon_002_hero:IsHidden()   return true  end
function modifier_item_weapon_002_hero:IsDebuff()   return false end

function modifier_item_weapon_002_unit:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_item_weapon_002_unit:GetModifierAttackSpeedBonus_Constant()	
    local ability = self:GetAbility()
    local attack_speed  = ability:GetSpecialValueFor("p2")
        return attack_speed        
end

function modifier_item_weapon_002_unit:IsPurgable() return false end
function modifier_item_weapon_002_unit:IsHidden()   return true  end
function modifier_item_weapon_002_unit:IsDebuff()   return false end

