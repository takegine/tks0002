LinkLuaModifier( "modifier_skill_hero_weimu", "skill/hero_weimu", 0 )

skill_hero_weimu = class({})
modifier_skill_hero_weimu = class({})

function skill_hero_weimu:GetIntrinsicModifierName()
	return "modifier_skill_hero_weimu"
end


function modifier_skill_hero_weimu:CheckState()
    -- local caster=self:GetCaster()
    -- if caster:GetUnitName()=='贾诩' then 
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
    }
    -- end
end

function modifier_skill_hero_weimu:IsHidden()
    return true
end