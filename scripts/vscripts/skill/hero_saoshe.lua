--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-08-04 15:02:47
* @LastEditors: 白喵
* @LastEditTime: 2020-08-28 17:41:29
--]]
skill_hero_saoshe = {}

function skill_hero_saoshe:OnSpellStart()
    if not IsServer() then
        return
    end
    local forward = self:GetCaster():GetForwardVector()
    local info = {
        Ability = self,
        EffectName = "particles/units/heroes/hero_drow/drow_multishot_proj_linear_proj.vpcf",
        vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
        fDistance = 1000,
        fStartRadius = 64,
        fEndRadius = 64,
        Source = self:GetCaster(),
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 2,
        vVelocity = forward * 1000,
    }
    local angle = 0
    local func = function()
        info.vVelocity = self:revolve(forward,angle)*1000
        ProjectileManager:CreateLinearProjectile(info)
        for var = 1,5 do
            info.vVelocity = self:revolve(info.vVelocity,60)
            ProjectileManager:CreateLinearProjectile(info)
        end
        angle = angle - 15
        if angle < -45 then
            return
        end
        return 1/3
    end
    Timer(1/3,func)
end


function skill_hero_saoshe:OnProjectileHit(hTarget,vLocation)
    if not IsServer() then
        return
    end
    local owner = self:GetCaster():GetOwner() or {ship={}}
    if hTarget then
        ApplyDamage({
            damage_type = DAMAGE_TYPE_PHYSICAL,  -- 伤害类型，参考常量DAMAGE_TYPES
            damage = self:GetSpecialValueFor("damage"),             -- 伤害值
            attacker = self:GetCaster(),   -- 攻击者
            victim = hTarget,     -- 目标
            ability = self,   -- 技能
        })
        if owner.ship['siying'] then
            hTarget:AddNewModifier(self:GetCaster(), self, "modifier_hero_saoshe", {duration = 2.0})
        end
        return true
    end
end




function skill_hero_saoshe:revolve(vector,angle)--向量平面逆时针旋转
    local x = vector.x*math.cos(math.rad(angle))-vector.y*math.sin(math.rad(angle))
    local y = vector.x*math.sin(math.rad(angle))+vector.y*math.cos(math.rad(angle))
    local z = vector.z
    return Vector(x,y,z)
end


LinkLuaModifier("modifier_hero_saoshe", "skill/hero_saoshe.lua", 0)
modifier_hero_saoshe = {}


function modifier_hero_saoshe:CheckState()
    return {[MODIFIER_STATE_STUNNED] = true}
end


function modifier_hero_saoshe:IsHidden()
    return true
end
