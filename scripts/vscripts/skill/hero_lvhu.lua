LinkLuaModifier('modifier_skill_hero_lvhu', 'skill/hero_lvhu.lua', 0)


skill_hero_lvhu=class({})

-- function skill_hero_lvhu:GetIntrinsicModifierName()
-- 	return "modifier_skill_hero_lvhu"
-- end

function skill_hero_lvhu:needwaveup()  
    local caster=self:GetCaster()

    local owner = caster:GetOwner() or {ship={}}   --判断是否有组合

    if owner.ship['quhu'] then
      caster:AddNewModifier(caster, self ,'modifier_skill_hero_lvhu', {})
    end
end

modifier_skill_hero_lvhu=class({})

function modifier_skill_hero_lvhu:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_skill_hero_lvhu:OnTakeDamage(keys)
    if IsServer() and self:GetAbility() then
        local caster = self:GetCaster()
        local parent = self:GetParent()
        local ability = self:GetAbility()
        local attacker = keys.attacker
        local target = keys.unit

        -- Ability specials
        local injury = ability:GetSpecialValueFor("injury")/100
        local damage = keys.damage * injury

        if attacker:GetTeamNumber() ~= parent:GetTeamNumber() and parent == target and not attacker:IsOther() then 

            local dummy = CreateUnitByName( "npc_damage_dummy",OUT_SIDE_VECTOR, false, parent, parent, parent:GetTeamNumber() )  --火伤马甲
            dummy.attack_type  = "fire"
            dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

            local damage_table = {
                attacker = dummy,
                victim = attacker,                
                damage = damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
                ability = ability
            }
            ApplyDamage(damage_table)
        end        
    end 
end

function modifier_skill_hero_lvhu:IsHidden()
    return true
end