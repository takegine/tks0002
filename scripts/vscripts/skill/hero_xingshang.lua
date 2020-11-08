

LinkLuaModifier("modifier_xingshang",'skill/hero_xingshang.lua',0)
LinkLuaModifier("modifier_xingshang_buff",'skill/hero_xingshang.lua',0)
LinkLuaModifier("modifier_xingshang_armor",'skill/hero_xingshang.lua',0)
LinkLuaModifier("modifier_xingshang_mana",'skill/hero_xingshang.lua',0)
LinkLuaModifier("modifier_xingshang_damage",'skill/hero_xingshang.lua',0)

skill_hero_xingshang=class({})

function skill_hero_xingshang:GetIntrinsicModifierName()
    return "modifier_xingshang"
end

modifier_xingshang=class({})

function modifier_xingshang:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_xingshang:OnTakeDamage(keys)
  
local caster=self:GetCaster()
local parent=self:GetParent()
local ability = self:GetAbility()
local owner  = caster:XinShi()
local heal=caster:GetMaxHealth()*4/100  
local dur=caster:GetLevel()+2
local target_flags=ability:GetAbilityTargetFlags()

if owner.ship['jianxiong']  then 
    heal=caster:GetMaxHealth()*49/100  
    caster:AddNewModifier(caster,ability,"modifier_xingshang_mana",{})
end 
if not IsServer() then  return end

if caster ~= keys.unit then return end

if keys.damage>=caster:GetHealth()   and ability:IsCooldownReady()   then
    caster:SetHealth(1)
    caster:AddNewModifier(caster,ability,"modifier_xingshang_buff",{Duration=3})

    if owner.ship['dushi']  then
    caster:AddNewModifier(caster,ability,"modifier_xingshang_damage",{Duration=dur})
    end

    ability:StartCooldown( 50 )

    Timer(0.01 , function()              
    caster:SetHealth(0) 
end )
    Timer(3 , function()              
    caster:SetHealth(heal) 
    caster:AddNewModifier(caster,ability,"modifier_xingshang_armor",{})
end )

else if keys.damage>=caster:GetHealth() and not ability:IsCooldownReady()   then
    --print(caster:GetUnitName())

    local enemy = FindUnitsInRadius(caster:GetTeamNumber(), 
    caster:GetOrigin(), 
    nil, 
    2000,
    DOTA_UNIT_TARGET_TEAM_ENEMY, 
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
    target_flags, 
    0, 
    true)
    for k,v in pairs(enemy) do
    v:RemoveModifierByName('modifier_songwei')
    end
end
end
end


modifier_xingshang_buff=class({})

function modifier_xingshang_buff:IsHidden()
    return true
end

function modifier_xingshang_buff:CheckState()
    local state = {
    [MODIFIER_STATE_INVULNERABLE]=true,
}   return state
end

modifier_xingshang_armor=class({})

function modifier_xingshang_armor:IsHidden()
    return true
end

function modifier_xingshang_armor:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

function modifier_xingshang_armor:GetModifierPhysicalArmorBonus()
    local caster=self:GetCaster()
    return caster:GetLevel()*6
end


modifier_xingshang_mana=class({})

function modifier_xingshang_mana:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ATTACK
    }
end

function modifier_xingshang_mana:OnAttack(keys)
    local caster=self:GetCaster()
    local ability=self:GetAbility()
 --if not IsServer() then  return end
 if caster ~= keys.target then return end

keys.attacker:SetMana(keys.attacker:GetMana()-5)   --(keys.target:GetMana()-5)
caster:SetMana(caster:GetMana()+5)      --   caster:GetMana()+5

end


modifier_xingshang_damage=class({})

function modifier_xingshang_damage:GetEffectName()
    return
        'particles/units/heroes/hero_enigma/enigma_ambient_stars_b.vpcf'     
end

function modifier_xingshang_damage:GetEffectAttachType()
    return PATTACH_ABSORIGIN
end

function modifier_xingshang_damage:OnCreated()
self:StartIntervalThink(1)
end


function modifier_xingshang_damage:OnIntervalThink(keys)

    local ability=self:GetAbility()
    local caster=self:GetCaster()
    local point=caster:GetOrigin()
	local target_types = ability:GetAbilityTargetType()
    local target_flags = ability:GetAbilityTargetFlags()

    if not IsServer() then return end

    local ability=self:GetAbility()
    local parent = self:GetParent()
    local caster=self:GetCaster()
    local enemy = FindUnitsInRadius(parent:GetTeamNumber(), 
    point, 
    nil, 
    350,
    DOTA_UNIT_TARGET_TEAM_ENEMY, 
    target_types, 
    target_flags, 
    0, 
    true)

    local dummy = CreateUnitByName( "npc_damage_dummy",OUT_SIDE_VECTOR, false, parent, parent, parent:GetTeamNumber() )
    dummy.attack_type  = "electrical"
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

    for key,unit in pairs(enemy) do

    local  damage_table = {    
        attacker     = dummy,
        ability      = ability,
        victim       = unit,
        damage_type  = DAMAGE_TYPE_PURE,
        damage       = unit:GetMaxHealth()*4/100
    }
        ApplyDamage(damage_table)
end

end


