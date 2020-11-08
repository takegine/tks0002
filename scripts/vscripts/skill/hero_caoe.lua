--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-09-05 16:13:02
* @LastEditors: 白喵
* @LastEditTime: 2020-09-05 18:24:40
--]]
skill_hero_caoe = {}
function skill_hero_caoe:needwaveup()
    local caster = self:GetCaster()
    local owner = caster:XinShi()
    if owner.ship['huzhu'] then
        caster:AddNewModifier(caster, self, "modifier_hero_caoe", nil)
    end

end



LinkLuaModifier("modifier_hero_caoe", "skill/hero_caoe.lua",0)
modifier_hero_caoe = {}
function modifier_hero_caoe:DeclareFunctions()
    return {MODIFIER_EVENT_ON_ATTACKED}
end

function modifier_hero_caoe:IsHidden()
    return true
end

function modifier_hero_caoe:OnAttacked(keys)
    local ability = self:GetAbility()
    if not ability:IsCooldownReady() then
        return
    end
    local parent = self:GetParent()
    if parent ~= keys.target then
        return
    end
    local attacker = keys.attacker
    local Origin = parent:GetAbsOrigin()
    local radius = 800
    local unitlist = FindUnitsInRadius(
        parent:GetTeamNumber(),
        Origin,
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
        FIND_ANY_ORDER,
        false
    )
    ability.Targetvec = GetGroundPosition(attacker:GetAbsOrigin(),attacker)
    ability.speed = 800/30
    ability.flag = false
    for _,unit in ipairs(unitlist) do--性能原因,使用ipairs
        if unit:GetUnitName() == "npc_dota_hero_kunkka" then
            ability.Direction = (ability.Targetvec - unit:GetAbsOrigin()):Normalized()
            unit:SetForwardVector(ability.Direction)
            unit:AddNewModifier(parent,ability,"modifier_hero_caoe2",nil)
            ability.flag = true
        end
    end
    if ability.flag then
        ability:StartCooldown(12.0)
    end
end






LinkLuaModifier("modifier_hero_caoe2", "skill/hero_caoe.lua",LUA_MODIFIER_MOTION_HORIZONTAL)--注册水平移动修改器
modifier_hero_caoe2 = {}

function modifier_hero_caoe2:DeclareFunctions()
    return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION,MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE}
end

function modifier_hero_caoe2:GetOverrideAnimation()
    return ACT_DOTA_RUN
end

function modifier_hero_caoe2:GetOverrideAnimationRate()
    return 3
end

function modifier_hero_caoe2:OnCreated()
    if IsServer() then
        if not self:ApplyHorizontalMotionController() then
            self:Destroy()
            return
        end
    end
end

function modifier_hero_caoe2:OnDestroy()
    if IsServer() then
        local parent = self:GetParent()
        local Origin = parent:GetAbsOrigin()
        local radius = 300
        parent:RemoveHorizontalMotionController(self)--移除水平移动控制器
        local unitlist = FindUnitsInRadius(
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
        for _,unit in ipairs(unitlist) do
            unit:MoveToTargetToAttack(parent)
        end
    end
end

function modifier_hero_caoe2:CheckState()
    return {
        [MODIFIER_STATE_UNSELECTABLE] = true
}
end

function modifier_hero_caoe2:IsHidden()
    return true
end

function modifier_hero_caoe2:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        local ability = self:GetAbility()
        -- 根据距离判断是否能进行下一次速度位移
        if (me:GetAbsOrigin()-ability.Targetvec):Length2D() > ability.speed then
            me:SetAbsOrigin(me:GetAbsOrigin() + ability.Direction * ability.speed)
        else
            --到终点了
            me:SetAbsOrigin(ability.Targetvec)
            me:InterruptMotionControllers(true)
            self:Destroy()
        end
    end
end
