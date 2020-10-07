
LinkLuaModifier('modifier_benghuai_health', 'skill/hero_benghuai.lua', 0)
LinkLuaModifier('modifier_benghuai_damage', 'skill/hero_benghuai.lua', 0)

skill_hero_benghuai=class({})

function skill_hero_benghuai:needwaveup()

local  caster=self:GetCaster()
local owner =caster:GetOwner() or {ship={}}

caster:AddNewModifier(caster, self, 'modifier_benghuai_health', {})

if owner.ship['meiren'] then 
caster:AddNewModifier(caster, self, 'modifier_benghuai_damage', {})
end

end      


modifier_benghuai_health=class({})

function modifier_benghuai_health:OnCreated()
self:StartIntervalThink(1)
end
    
function modifier_benghuai_health:OnIntervalThink(keys)
if not IsServer() then return end
local caster=self:GetCaster()
local sethealth=caster:GetHealth()-caster:GetMaxHealth()*0.01
if  caster:GetHealthPercent()>=33 then 
caster:SetHealth(sethealth)
else  caster:RemoveModifierByName('modifier_benghuai_health') end
end

modifier_benghuai_damage=class({})

function modifier_benghuai_damage:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_benghuai_damage:OnAttackLanded(keys)
    local caster=self:GetCaster()
    local parent=self:GetParent()
    local ability=self:GetAbility()

    if not  IsServer() then  return end
    if keys.attacker~=caster then  return  end

    local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, parent, parent, parent:GetTeamNumber() )
    dummy.attack_type  = "fire"
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )
 
    local  damage_table = {
    
        attacker     = dummy,
        ability      = ability,
        victim       = keys.target,
        damage_type  = DAMAGE_TYPE_MAGICAL,
        damage       = parent:GetMaxHealth()*5/1000
    }
        ApplyDamage(damage_table)


end


   