

LinkLuaModifier("modifier_skill_hero_yingzi",'skill/hero_yingzi.lua',0)




skill_hero_yingzi=class({})

function skill_hero_yingzi:needwaveup()
  
    print('123')
    local caster=self:GetCaster()
    
    caster:AddNewModifier(caster, self, "modifier_skill_hero_yingzi", {})
end




modifier_skill_hero_yingzi = {}

function modifier_skill_hero_yingzi:DeclareFunctions()

    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }
end

function modifier_skill_hero_yingzi:GetModifierBonusStats_Strength()

    local caster=self:GetCaster()
    local owner =caster:GetOwner() or {ship{}}
    local ability=self:GetAgility()
   if  owner.ship['xiaoniao']  then  
   return caster:GetStrength()*(140+ability:GetLevel()*6.5)/100
   else
    return   100-- caster:GetStrength()*(110+ability:GetLevel()*6.5)/100    
end
end


function modifier_skill_hero_yingzi:GetModifierBonusStats_Agility()

    local caster=self:GetCaster()
    local owner =caster:GetOwner() or {ship{}}

    if  owner.ship['xiaoniao']  then  
   return caster:GetAgility()()*(140+ability:GetLevel()*6.5)/100
    else
    return caster:GetAgility()*(110+ability:GetLevel()*6.5)/100    
end
end


function modifier_skill_hero_yingzi:GetModifierBonusStats_Intellect()

    local caster=self:GetCaster()
    local owner =caster:GetOwner() or {ship{}}

  if  owner.ship['xiaoniao']  then   
   return caster:GetIntellect()()*(140+ability:GetLevel()*6.5)/100
    else
    return caster:GetIntellect()*(110+ability:GetLevel()*6.5)/100    
end
end


