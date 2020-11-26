LinkLuaModifier("modifier_skill_hero_hongyan", "skill/hero_hongyan.lua", 0)

skill_hero_hongyan = class({})

function skill_hero_hongyan:GetIntrinsicModifierName()
	return "modifier_skill_hero_hongyan"
end

modifier_skill_hero_hongyan = class({})

function modifier_skill_hero_hongyan:OnCreated(table)
    if not IsServer() then
        return
    end

	local caster = self:GetCaster()
    local kv = {
        electrical=100,
        duration=-1
    }
    caster:AddNewModifier( caster, self , "modifier_defend_big", kv )
end 

function modifier_skill_hero_hongyan:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end 

function modifier_skill_hero_hongyan:OnTakeDamage(keys)
    if IsServer() then
        local attacker = keys.attacker 
        local parent  = self:GetParent()

        if keys.unit == parent and attacker.attack_type == "electrical" then 
            local caster = self:GetCaster()
            local ability = self:GetAbility()
            local damage  = keys.damage *1.575
            local owner   = caster:XinShi()
            local healre  =  keys.damage_type == DAMAGE_TYPE_PHYSICAL and damage *2 or damage

            if owner.ship["xiaoniao"] then 
                local healre = healre* 35 /100
                local radius = 400
                local target_team     = ability:GetAbilityTargetTeam()
                local target_types    = ability:GetAbilityTargetType()
                local target_flags    = ability:GetAbilityTargetFlags() 
                local units           = FindUnitsInRadius(caster:GetTeamNumber(), 
                                                        caster:GetOrigin(), 
                                                        nil, 
                                                        400,
                                                        target_team, 
                                                        target_types, 
                                                        target_flags, 
                                                        0, 
                                                        true)

                for key,unit in pairs(units) do
                    if unit ~= caster then
                    unit:Heal(healre, parent)
                    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, healre, nil) 

                    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", PATTACH_POINT_FOLLOW,caster)
                    ParticleManager:SetParticleControlEnt(pfx, 0,caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
                    ParticleManager:SetParticleControl(pfx, 1, unit:GetAbsOrigin())
                    ParticleManager:ReleaseParticleIndex(pfx)
                    end
                end 
            end 
        end 
    end
end    

