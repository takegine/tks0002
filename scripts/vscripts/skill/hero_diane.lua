
LinkLuaModifier('modifier_skill_hero_diane', 'skill/hero_diane.lua', 0)


skill_hero_diane=class({})
modifier_skill_hero_diane = class({})

function skill_hero_diane:needwaveup()  

    local caster=self:GetCaster()
    local ability =self
    local add = 30
    local owner = caster:GetOwner() or {ship={}}   

    if owner.ship['elai'] and caster:GetUnitName()=="npc_dota_hero_kunkka" then 
        add=add
    end
    local intStrength  = caster:GetStrength()*add  /100
   
    local mod = caster:AddNewModifier(caster,ability, "modifier_skill_hero_diane", {})

    mod.intStrength = mod.intStrength or intStrength


end



function modifier_skill_hero_diane:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_EVENT_ON_DEATH
    }
end

function modifier_skill_hero_diane:GetModifierBonusStats_Strength()
    return self.intStrength or 0  
end

function modifier_skill_hero_diane:OnDeath(params)
    local caster = self:GetCaster()
    local target = params.unit
    if self:GetCaster():IsRealHero() and target:IsRealHero() and caster:GetTeamNumber() ~= target:GetTeamNumber() and (not params.unit.IsReincarnating or not params.unit:IsReincarnating()) then
        local diane_range = self:GetAbility():GetSpecialValueFor("range")
		if diane_range == 0 then
			diane_range = 500
		end

		if (self:GetAbility():GetCaster():GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= diane_range then
            local current_ability = caster:FindAbilityByName("skill_hero_qiangxi")
            if current_ability then
                current_ability:EndCooldown()
            end
        end 
    end 
end


function modifier_skill_hero_diane:IsHidden ()
    return true
end

function modifier_skill_hero_diane:IsDebuff()
	return  false
end