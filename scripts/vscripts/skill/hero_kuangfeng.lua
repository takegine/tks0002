--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-11-17 14:02:43
* @LastEditors: 白喵
* @LastEditTime: 2020-11-17 19:19:36
--]]
skill_hero_kuangfeng = {}
function skill_hero_kuangfeng:OnSpellStart()
    local caster = self:GetCaster()
    local loc = caster:GetAbsOrigin()
    local duration = self:GetSpecialValueFor("duration")
    local unitlist = FindUnitsInRadius(
        caster:GetTeam(),
        loc, 
        nil, 
        1200, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, 
        FIND_CLOSEST, 
        false
    )
    local max = #unitlist > 7 and 7 or #unitlist
    local hp_reduce = self:GetSpecialValueFor("hp_reduce")
    local qixing = caster:FindModifierByName("modifier_hero_qixing")
    if qixing then
        if qixing:GetStackCount() >= 2 then
            qixing:DecrementStackCount()
            qixing:DecrementStackCount()
            hp_reduce = hp_reduce*1.5
        end
    end
    for i = 1,max do
        local unit = unitlist[i]
        local heal_parcent = unit:GetHealthPercent()
        local heal_max = unit:GetMaxHealth()
        local damage = heal_max*self:GetSpecialValueFor("damage")/100
        local info = {
            victim = unit,
            attacker = caster,
            damage = heal_max*hp_reduce/100,
            damage_type = DAMAGE_TYPE_PURE,
            damage_flags = DOTA_DAMAGE_FLAG_HPLOSS,
            ability = self
        }
        ApplyDamage(info)
        info.damage = damage
        info.damage_type = DAMAGE_TYPE_MAGICAL
        info.damage_flags = DOTA_DAMAGE_FLAG_NONE
        ApplyDamage(info)
        unit:AddNewModifier(caster, self, "modifier_kuangfeng", {duration = duration})
    end
end

LinkLuaModifier("modifier_kuangfeng", "skill/hero_kuangfeng.lua", 0)
modifier_kuangfeng = {IsHidden = on}

function modifier_kuangfeng:OnCreated(keys)
    if not IsServer() then
        return
    end
    local parent = self:GetParent()
    local vec = parent:GetAbsOrigin()
    self.z = vec.z
    self.yaw = 0
    self:StartIntervalThink(0.1)
end

function modifier_kuangfeng:OnIntervalThink(keys)
    local parent = self:GetParent()
    local vec = parent:GetAbsOrigin()
    local z = vec.z
    local max_z = self.z+270
    local speed = 90
    if self:GetRemainingTime() <= 0.3 then
        if z - self.z <= speed then
            z = self.z
        else
            z = z - speed
        end
        parent:SetAbsOrigin(Vector(vec.x,vec.y,z))
        goto angle
    end

    if z <= max_z then
        if max_z - z < speed then
            z = max_z
        else
            z = z + speed
        end
        parent:SetAbsOrigin(Vector(vec.x,vec.y,z))
    end
    ::angle::
    self.yaw = self.yaw + 20
    parent:SetAbsAngles(0, self.yaw, 0)
end

function modifier_kuangfeng:GetEffectName()
    return "particles/econ/events/fall_major_2016/cyclone_fm06.vpcf"
end

function modifier_kuangfeng:GetEffectAttachType()
    return PATTACH_POINT
end

function modifier_kuangfeng:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true
    }
    return state
end