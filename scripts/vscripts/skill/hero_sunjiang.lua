


LinkLuaModifier("modifier_skill_hero_sunjiang",'skill/hero_sunjiang',0)

skill_hero_sunjiang = skill_hero_sunjiang or class({})

function skill_hero_sunjiang:needwaveup()
    
    local caster = self:GetCaster()
    local owner = caster:GetOwner() or (ship{})
    if owner.ship['jiangdong'] then
        caster:AddNewModifier( caster, self, 'modifier_skill_hero_sunjiang',{})
    end
end

---------------------------------------------------------------------------------------------
modifier_skill_hero_sunjiang = modifier_skill_hero_sunjiang or {}

function modifier_skill_hero_sunjiang:DeclareFunctions()
    return { 
        MODIFIER_EVENT_ON_ATTACK_LANDED 
    }  
end

function modifier_skill_hero_sunjiang:OnAttackLanded(keys)
    if IsServer() then
        
        local target  = keys.target
        local ability = self:GetAbility()
        local parent  = self:GetParent()
        local cleave  = ability:GetSpecialValueFor( "skill_hero_sunjiang_damage" )
        local radius  = ability:GetSpecialValueFor( "skill_hero_sunjiang_radius" )
        if keys.attacker == parent and ( not parent:IsIllusion() ) then 
            if parent:PassivesDisabled() then
                return 
            end
            
            if target ~= nil and target:GetTeamNumber() ~= parent:GetTeamNumber() then
                local cleaveDamage =  cleave *keys.damage 
                
                DoCleaveAttack( parent, target, ability, cleaveDamage /100 , radius, radius, radius, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf")
            end
        end
    end        
end


function modifier_skill_hero_sunjiang:IsHidden()
    return true
end