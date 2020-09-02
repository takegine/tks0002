LinkLuaModifier('modifier_skill_hero_qiangxi', 'skill/hero_qiangxi.lua', 0)
LinkLuaModifier('modifier_skill_hero_qiangxi_stun', 'skill/hero_qiangxi.lua', 0)




skill_hero_qiangxi = class({})

modifier_skill_hero_qiangxi_stun = class({})

function skill_hero_qiangxi:GetIntrinsicModifierName()  --声明技能实践  技能释放
    return "modifier_skill_hero_qiangxi"
end

function skill_hero_qiangxi:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
        local target = self:GetCursorTarget()
        local ability = self
        local damage = self:GetSpecialValueFor("damage")
        local stun_duration = self:GetSpecialValueFor("stun_duration")
        local kill_threshold_max_hp_pct = self:GetSpecialValueFor("kill_threshold_max_hp_pct") / 100
        local projectile_speed = self:GetSpecialValueFor("projectile_speed")

        local projectile =
        {
            Target 				= target,
            Source 				= caster,
            Ability 			= self,
            EffectName 			= "particles/units/heroes/hero_beastmaster/beastmaster_wildaxe_copy.vpcf",
            iMoveSpeed			= projectile_speed,
            bDodgeable 			= true,
            bVisibleToEnemies 	= true,
            bReplaceExisting 	= false,
            iSourceAttachment   = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
            bProvidesVision 	= true,
            iVisionRadius 		= 300,
            iVisionTeamNumber 	= caster:GetTeamNumber(),
            ExtraData			= {damage = damage, stun_duration = stun_duration,kill_threshold_max_hp_pct = kill_threshold_max_hp_pct}
        }
        ProjectileManager:CreateTrackingProjectile(projectile)
    end 
end


function skill_hero_qiangxi:OnProjectileHit_ExtraData(target, location, ExtraData)
	if not target then
		return 
    end

    local caster = self:GetCaster()
    local ability = self
    local modifier_stun = "modifier_skill_hero_qiangxi_stun"
    local stun_duration = ability:GetSpecialValueFor("stun_duration")
    local damage = ability:GetSpecialValueFor("damage")
    local projectile_speed = ability:GetSpecialValueFor("projectile_speed")
    self.kill_threshold_max_hp_pct = ability:GetSpecialValueFor("kill_threshold_max_hp_pct") / 100

    local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, caster, caster, caster:GetTeamNumber() )
    dummy.attack_type  = "electrical"
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1})

    local DamageTable = {
        victim = target,
        attacker = dummy, 
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
        ability = ability
        }
    ApplyDamage(DamageTable)

    target:AddNewModifier(caster, ability, modifier_stun, {duration = 2})

    if (target:GetHealth()/target:GetMaxHealth() <= self.kill_threshold_max_hp_pct ) then
        self:GetCursorTarget():Kill(self, self.caster)
        if (target:IsHero()) then
            ability:EndCooldown()
        end
    end
end


function modifier_skill_hero_qiangxi_stun:IsHidden ()
    return true
end

function modifier_skill_hero_qiangxi_stun:IsDebuff()
	return  true
end

function modifier_skill_hero_qiangxi_stun:IsStunDebuff()
	return  true
end

function modifier_skill_hero_qiangxi_stun:CheckState()
    local state = {
    [MODIFIER_STATE_STUNNED]=true,
}      return state
end


