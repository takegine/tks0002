--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-09-05 23:43:42
* @LastEditors: 白喵
* @LastEditTime: 2020-09-06 01:03:23
--]]
skill_hero_zhangsi = {}
function skill_hero_zhangsi:needwaveup()
    local caster = self:GetCaster()
    local owner = caster:XinShi()
    if owner.ship['sitingzhu'] then
        caster:AddNewModifier(caster, self, "modifier_hero_zhangsi", nil)
    end
end

function skill_hero_zhangsi:OnProjectileHit(hTarget,vLocation)
    if not IsServer() then
        return
    end
    if hTarget then
        local caster = self:GetCaster()
        local dummy = CreateUnitByName( "npc_damage_dummy",OUT_SIDE_VECTOR, false, caster, caster, caster:GetTeamNumber() )
        dummy.attack_type  = "electrical"
        dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )
        local damage = self:GetLevel() * 300
        local  damage_table = 
        {
        attacker     = dummy,
        victim       = hTarget,
        damage_type  = DAMAGE_TYPE_MAGICAL,
        damage       = damage,
        damage_flags = DOTA_DAMAGE_FLAG_NONE
        }
        ApplyDamage(damage_table)
        return true
    end
end

LinkLuaModifier("modifier_hero_zhangsi", "skill/hero_zhangsi.lua", 0)
modifier_hero_zhangsi = {}

function modifier_hero_zhangsi:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.5)
end

function modifier_hero_zhangsi:IsHidden()
    return true
end

function modifier_hero_zhangsi:OnIntervalThink()
    if not IsServer() then
        return
    end
    local parent = self:GetParent()
    local Origin = parent:GetAbsOrigin()
    local radius = 1000
    local target = FindUnitsInRadius(
        parent:GetTeamNumber(),
        Origin,
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
        FIND_ANY_ORDER,
        false
    )
    if #target >= 1 then--如果存在敌对单位
        local random = RandomInt(1, #target)
        local info = {
            EffectName = "particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile_initial.vpcf",
            Ability = self:GetAbility(),
            iMoveSpeed = 1000,
            Source = parent,
            Target = target[random],
            bDodgeable = false,
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
            bProvidesVision = true,
            iVisionTeamNumber = parent:GetTeamNumber(),
            iVisionRadius = 300
        }
        ProjectileManager:CreateTrackingProjectile(info)
    end
end


