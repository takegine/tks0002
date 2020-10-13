
 LinkLuaModifier("modifier_skill_hero_miss",'skill/hero_chengjie.lua',0)

skill_hero_chengjie=class({})  --声明一个技能 



function skill_hero_chengjie:OnSpellStart()

    local caster=self:GetCaster()  --获取施法着
    local target=self:GetCursorTarget() --获取施法目标
    local owner  = caster:GetOwner() or {ship={}}  
    local damage = self:GetLevelSpecialValueFor("damage", self:GetLevel()-1)

    local dummy = CreateUnitByName( "npc_damage_dummy",OUT_SIDE_VECTOR, false, caster, caster, caster:GetTeamNumber() )
    dummy.attack_type  = "land"
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

    target:AddNewModifier(caster, self, 'modifier_skill_hero_miss', {duration=3})

    if  owner.ship['changqu'] then

        local knockbackModifierTable =
        {
            should_stun = 1,
            knockback_duration = 0.5,
            duration = 1,
            knockback_distance = 400,
            knockback_height = 0,
            center_x = caster:GetAbsOrigin().x,
            center_y = caster:GetAbsOrigin().y,
            center_z = caster:GetAbsOrigin().z
        }
        target:AddNewModifier( caster, nil, "modifier_knockback", knockbackModifierTable )
    

        damage = damage *2

    end

    
    local  damage_table = {
        attacker     = dummy,
        victim       = target,
        damage_type  = DAMAGE_TYPE_PHYSICAL,
        damage       = damage  
    }
        ApplyDamage(damage_table)
end



modifier_skill_hero_miss=class({})


function modifier_skill_hero_miss:DeclareFunctions()
    return{

        MODIFIER_PROPERTY_MISS_PERCENTAGE
    }
end

function modifier_skill_hero_miss:GetModifierMiss_Percentage()
 return  100
end














