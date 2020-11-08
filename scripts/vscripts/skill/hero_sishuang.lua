


LinkLuaModifier("modifier_sishuang_aura",'skill/hero_sishuang.lua',0)
LinkLuaModifier("modifier_sishuang_buff",'skill/hero_sishuang.lua',0)

skill_hero_sishuang=class({})

function skill_hero_sishuang:GetIntrinsicModifierName()  
    return "modifier_sishuang_aura"
end



modifier_sishuang_aura=class({})


function modifier_sishuang_aura:IsAura()
    return true
end 

function modifier_sishuang_aura:IsAuraActiveOnDeath()
    return false 
end 

function modifier_sishuang_aura:IsDebuff()
    return false
end

function modifier_sishuang_aura:GetAuraRadius()
    return 1500
end

function modifier_sishuang_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY 
end

function modifier_sishuang_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end 

function modifier_sishuang_aura:GetModifierAura()
    return 'modifier_sishuang_buff'
end

function modifier_sishuang_aura:IsHidden()
    return false
end

modifier_sishuang_buff=class({})

function modifier_sishuang_buff:IsHidden()
    return  true
end

function modifier_sishuang_buff:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_ATTACK  
    }
end

function modifier_sishuang_buff:OnAttack(keys)
    local ability=self:GetAbility()
    local parent=self:GetParent()
    local target=keys.attacker
    local caster=self:GetCaster()
    local owner =caster:XinShi()
 if not IsServer() then  return  end
 if keys.target~=parent then return end
 if owner.ship['sishuang']  then 
 local dummy = CreateUnitByName( "npc_damage_dummy",OUT_SIDE_VECTOR, false, parent, parent, parent:GetTeamNumber() )
 dummy.attack_type  = "fire"
 dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

 
 local  damage_table = {
    attacker     = dummy,
    victim       = target,
    damage_type  = DAMAGE_TYPE_MAGICAL,
    damage       = target:GetHealth()*3/100,
    damage_flags = DOTA_DAMAGE_FLAG_NONE
}
    ApplyDamage(damage_table)
else return end
end


