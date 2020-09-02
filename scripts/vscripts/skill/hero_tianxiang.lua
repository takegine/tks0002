LinkLuaModifier('modifier_skill_hero_tianxiang', 'skill/hero_tianxiang.lua', 0)

skill_hero_tianxiang=class({})


function skill_hero_tianxiang:OnSpellStart()
    local caster = self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_skill_hero_tianxiang", {duration = 4})
end

------------------------------------------------------------------------------------------------------
modifier_skill_hero_tianxiang=class({})
function modifier_skill_hero_tianxiang:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end



function modifier_skill_hero_tianxiang:OnTakeDamage(keys)

    local caster = self:GetCaster()
    local target = keys.unit
    local parent  = self:GetParent()

    if target == parent  
    and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then

        local ability         = self:GetAbility()
        local damage_type     = ability:GetAbilityDamageType()   
        local target_team     = ability:GetAbilityTargetTeam()
        local target_types    = ability:GetAbilityTargetType()
        local target_flags    = ability:GetAbilityTargetFlags() 
        local redirect_pct	  =	ability:GetLevelSpecialValueFor("redirect", (ability:GetLevel()-1))
        local redirect_damage =	keys.damage * (redirect_pct/100)

        local enemy = FindUnitsInRadius(caster:GetTeamNumber(), 
                                    caster:GetOrigin(), 
                                    nil, 
                                    400,
                                    target_team, 
                                    target_types, 
                                    target_flags, 
                                    0, 
                                    true)
        if #enemy ~= 0 then

            parent:Heal(redirect_damage, parent)
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, redirect_damage, nil)

            local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, parent, parent, parent:GetTeamNumber() )  --水伤马甲
            dummy.attack_type  = "water"
            dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

            for key,unit in pairs(enemy) do
                local  damage_table = {
                                    attacker     = dummy,
                                    victim       = unit,
                                    damage_type  = damage_type,
                                    damage       = redirect_damage,
                                    damage_flags = DOTA_DAMAGE_FLAG_NONE,
                                    ability      = ability
                }
                ApplyDamage(damage_table)
            end
        end
    end
end

function modifier_skill_hero_tianxiang:GetEffectName()
    return "particles/econ/items/medusa/medusa_daughters/medusa_daughters_mana_shield.vpcf"
end