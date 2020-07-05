-- 西索
-- 2020/07/5
-- 关银屏的武姬

LinkLuaModifier( "modifier_skill_hero_wuji_armor", "skill/hero_wusheng.lua", LUA_MODIFIER_MOTION_NONE )

function wuji(keys)
  
	local caster  = keys.caster
    local target  = keys.target
    local ability = keys.ability
    local attacker= keys.attacker
    local owner   = caster:GetOwner() or {ship={}}
    
    local chance  = ability:GetLevelSpecialValueFor("chance", (ability:GetLevel()-1) )
    local damage  = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel()-1) )
    local radius  = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel()-1) )
    local damage_type  = ability:GetAbilityDamageType()
	local target_team  = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
    local target_flags = ability:GetAbilityTargetFlags()
    
    if   caster:GetItemInSlot(0) 
    and  caster:GetItemInSlot(0):GetName()=='item_weapon_qinglongyanyuedao' 
    then chance = chance * 2
    end

    if not owner.ship['hufu'] 
    or not RollPercentage( chance ) 
    then return 
    end
    
    local pfxName = "particles/econ/items/axe/axe_cinder/axe_cinder_battle_hunger_start.vpcf"
    local zhuan = ParticleManager:CreateParticle( pfxName, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(zhuan, 0, keys.attacker:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(zhuan)

    
	local damage_table = {}

	damage_table.attacker     = caster
    damage_table.victim       = attacker
	damage_table.damage_type  = damage_type
	damage_table.ability      = ability
	damage_table.damage       = damage
	damage_table.damage_flags = DOTA_DAMAGE_FLAG_NONE

    local enemy = FindUnitsInRadius(caster:GetTeamNumber(), 
                                    caster:GetOrigin(), 
                                    nil, 
                                    radius,
                                    target_team,
                                    target_types, 
                                    target_flags, 
                                    0, 
                                    true)

    for k,v in pairs(enemy) do
        damage_table.victim = v
        ApplyDamage(damage_table)
    end

end