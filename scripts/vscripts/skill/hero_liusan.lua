skill_hero_liusan = skill_hero_liusan or {}

--------------------------------------------------------------------------------

function skill_hero_liusan:needwaveup()
    
	local caster  = self:GetCaster()
    local owner   = caster:XinShi()

    if owner.ship['dingli'] then
        caster:AddNewModifier( caster, self, "modifier_skill_hero_liusan", nil )
    end
end

------------------------------------------------------------------------

LinkLuaModifier( "modifier_skill_hero_liusan", "skill/hero_liusan", LUA_MODIFIER_MOTION_NONE )
modifier_skill_hero_liusan = modifier_skill_hero_liusan or {}
--------------------------------------------------------------------------------

function modifier_skill_hero_liusan:IsHidden()      return false end
function modifier_skill_hero_liusan:IsPurgable()	return false end
function modifier_skill_hero_liusan:GetTexture ()   return "" end

----------------------------------------

function modifier_skill_hero_liusan:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

function modifier_skill_hero_liusan:GetModifierBonusStats_Strength( ... )
    return self:GetAbility():GetSpecialValueFor( "bonus_status" )
end

function modifier_skill_hero_liusan:GetModifierBonusStats_Agility( ... )
    return self:GetAbility():GetSpecialValueFor( "bonus_status" )
end

function modifier_skill_hero_liusan:GetModifierBonusStats_Intellect( ... )
    return self:GetAbility():GetSpecialValueFor( "bonus_status" )
end