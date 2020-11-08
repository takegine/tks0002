
LinkLuaModifier("modifier_skill_hero_zhousi",'skill/hero_zhousi.lua',0)


skill_hero_zhousi=class({})

function skill_hero_zhousi:needwaveup()


    local caster=self:GetCaster()
    local ability=self
    local owner =caster:XinShi()
    local target_team  = self:GetAbilityTargetTeam()
    local target_types = self:GetAbilityTargetType()
    local target_flags = self:GetAbilityTargetFlags()

    if  owner.ship['siying'] 

    then 

        caster:AddNewModifier(caster, self, "modifier_skill_hero_zhousi", {})

        local friend = FindUnitsInRadius(caster:GetTeamNumber(), 
        caster:GetOrigin(), 
        nil, 
        2000,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
        target_types, 
        target_flags, 
        0, 
        true)


    for i=1,#friend  do
        
     unit=friend[i]

    unit:AddNewModifier(caster, self, "modifier_skill_hero_zhousi", {})
    end


end

end


modifier_skill_hero_zhousi=class({})


function modifier_skill_hero_zhousi:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
    }
end

function modifier_skill_hero_zhousi:GetModifierSpellAmplify_Percentage()
    return 15
end