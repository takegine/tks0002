
LinkLuaModifier( "modifier_skill_hero_hunzi", "skill/hero_hunzi", 0 )

skill_hero_hunzi = class({})

function skill_hero_hunzi:GetIntrinsicModifierName()
	return "modifier_skill_hero_hunzi"
end

modifier_skill_hero_hunzi = class({})

function modifier_skill_hero_hunzi:IsHidden()
    return true
end

function modifier_skill_hero_hunzi:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end 

function modifier_skill_hero_hunzi:OnTakeDamage(keys)
    local ability = self:GetAbility()
    local parent  = self:GetParent()
    local health_perc   = parent:GetHealthPercent()
    if keys.unit:GetUnitName()=='孙策' then
        if health_perc <= 75 then
            local yingzi = parent:AddAbility("skill_hero_yingzi")
            local yinghun= parent:AddAbility("skill_hero_yinghun")
            local lvl = ability:GetLevel()
            yingzi:SetLevel(lvl)
            yinghun:SetLevel(lvl)
            yingzi:needwaveup()
            yinghun:needwaveup()
            parent:RemoveModifierByName("modifier_skill_hero_hunzi")
            parent:RemoveAbility("skill_hero_hunzi")
            
            local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_inner_fire.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
        end
    end
end

