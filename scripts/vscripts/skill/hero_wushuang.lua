LinkLuaModifier('modifier_skill_hero_wushuang', 'skill/hero_wushuang.lua', 0)

skill_hero_wushuang=class({})

function skill_hero_wushuang:GetIntrinsicModifierName()
	return "modifier_skill_hero_wushuang"
end

modifier_skill_hero_wushuang = class({})

function modifier_skill_hero_wushuang:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_skill_hero_wushuang:OnAttackLanded(keys)
    local caster = self:GetCaster()
    local parent = self:GetParent()
    local ability= self:GetAbility()
    local target = keys.target 
    local owner = caster:GetOwner() or {ship={}} 
    local chance = ability:GetSpecialValueFor("chance")
    local damage = target:GetMaxHealth()*33/100 
    local damage_type = ability:GetAbilityDamageType()
    local target_team = ability:GetAbilityTargetTeam()
    local target_types = ability:GetAbilityTargetType()
    local target_flags = ability:GetAbilityTargetFlags()
    local max_hp_pct = ability:GetSpecialValueFor("max_hp_pct")/100

    if keys.attacker == self:GetParent()
    and not self:GetParent():IsIllusion()
    and not self:GetParent():PassivesDisabled()
    then 

        if owner.ship['zhanchang'] then
            chance = chance * 2
        end 

        if 
    if caster:HasItemInInventory( "item_weapon_008" ) and (keys.target:GetHealth()/keys.target:GetMaxHealth()) <= max_hp_pct then
            chance = 100 
        end

        if not RollPercentage(chance) then return end

        local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, parent, parent, parent:GetTeamNumber() )  --火伤马甲
        dummy.attack_type  = "fire"
        dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

        if RollPercentage(chance) then
            if target:IsHero() then 
                local  damage_table = {

                    attacker     = dummy,
                    victim       = target,
                    damage_type  = damage_type,
                    damage       = damage, 
                    damage_flags = DOTA_DAMAGE_FLAG_NONE
                }
                ApplyDamage(damage_table)
            end 

            if (target:IsCreep()) then
                target:Kill(ability, caster)
            end

            if (target:IsBoss()) then
                target:Kill(ability, caster)
            end

            if (target:IsIllusion()) then
                target:Kill(ability, caster)
            end

            if owner.ship['zhanluan'] then 
                local enemy = FindUnitsInRadius(parent:GetTeamNumber(), 
                                                caster:GetOrigin(), 
                                                nil, 
                                                200,
                                                target_team, 
                                                target_types, 
                                                target_flags, 
                                                0, 
                                                true)

                for key,unit in pairs(enemy) do  
                    if unit:IsHero() then 

                    local  damage_table = {

                        attacker     = dummy,
                        victim       = unit,
                        damage_type  = damage_type,
                        damage       = damage, 
                        damage_flags = DOTA_DAMAGE_FLAG_NONE
                    }
                        ApplyDamage(damage_table)
                    end    

                    if (unit:IsCreep()) then
                        unit:Kill(ability, caster)
                    end
            
                    if (unit:IsBoss()) then
                        unit:Kill(ability, caster)
                    end
            
                    if (unit:IsIllusion()) then
                        unit:Kill(ability, caster)
                    end
                end    
            end
        end 
    end 
end

function modifier_skill_hero_wushuang:IsHidden() 			return true end