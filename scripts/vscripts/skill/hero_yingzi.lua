LinkLuaModifier("modifier_skill_hero_yingzi",'skill/hero_yingzi.lua',0)

skill_hero_yingzi=class({})

function skill_hero_yingzi:needwaveup()

    local caster=self:GetCaster()
    local ability=self
    local add= 10 +ability:GetLevel() *6.5
    local owner =caster:XinShi()

    if  owner.ship['xiaoniao']    and caster:GetUnitName()=='npc_dota_hero_vengefulspirit'
    then  add=add+30 end

    local intintellent = caster:GetIntellect() *add /100
    local intAgility   = caster:GetAgility() *add /100 
    local intStrength  = caster:GetStrength()*add  /100

    local mod = caster:AddNewModifier(caster,ability, "modifier_skill_hero_yingzi", {})   
    mod.intellect   = mod.intellect   or intintellent
    mod.intAgility  = mod.intAgility  or intAgility
    mod.intStrength = mod.intStrength or intStrength 
end


modifier_skill_hero_yingzi =class({})

function modifier_skill_hero_yingzi:DeclareFunctions()
     return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }
end

function modifier_skill_hero_yingzi:GetModifierBonusStats_Strength()
    return self.intStrength or 0  
end

function modifier_skill_hero_yingzi:GetModifierBonusStats_Agility()
    return self.intAgility or 0 
end

function modifier_skill_hero_yingzi:GetModifierBonusStats_Intellect()
   return   self.intellect or 0  
end


