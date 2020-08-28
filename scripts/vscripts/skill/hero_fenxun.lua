--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-08-04 11:19:20
* @LastEditors: 白喵
* @LastEditTime: 2020-08-28 18:21:59
--]]
skill_hero_fenxun = {}
function skill_hero_fenxun:needwaveup()
    local caster = self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_hero_fenxun2", {duration = -1})
end



LinkLuaModifier("modifier_hero_fenxun", "skill/hero_fenxun.lua", LUA_MODIFIER_MOTION_BOTH)


modifier_hero_fenxun = {}


function modifier_hero_fenxun:IsHidden()
    return true
end

function modifier_hero_fenxun:IsPurgable()
    return false
end

function modifier_hero_fenxun:RemoveOnDeath()
    return false
end



function modifier_hero_fenxun:OnCreated()
    if IsServer() then
        if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then
            self:Destroy()
            return
        end
    end
end

function modifier_hero_fenxun:OnDestroy()
    if IsServer() then
        local ability = self:GetAbility()
        self:GetParent():RemoveHorizontalMotionController(self)
        self:GetParent():RemoveVerticalMotionController(self)
        self:GetParent():AddNewModifier(self:GetParent(),ability, "modifier_hero_fenxun3", {duration = ability:GetSpecialValueFor("duration_speed")})
        self:GetParent():MoveToTargetToAttack(ability.attacker)
    end
end

function modifier_hero_fenxun:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }
    return funcs
end
function modifier_hero_fenxun:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED]  = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true
    }

    return state
end

function modifier_hero_fenxun:GetOverrideAnimation()
    return ACT_DOTA_LEAP_STUN--跳跃眩晕
end

function modifier_hero_fenxun:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        local ability = self:GetAbility()
        -- 根据距离判断是否能进行下一次速度位移
        if (me:GetAbsOrigin()-ability.vTargetPosition):Length2D() > ability.flHorizontalSpeed then
            me:SetAbsOrigin(me:GetAbsOrigin() + ability.vDirection * ability.flHorizontalSpeed)
            ability.leap_traveled = ability.leap_traveled + ability.flHorizontalSpeed -- 跳跃水平距离
        else
            --到终点了
            me:SetAbsOrigin(ability.vTargetPosition)
            me:InterruptMotionControllers(true)
            self:Destroy()
        end
    end
end

function modifier_hero_fenxun:UpdateVerticalMotion(me, dt)
    if IsServer() then
        local ability = self:GetAbility()
        if ability.flDistance > 300 then
            local z = math.sin(ability.leap_traveled/ability.flDistance*math.pi)*ability.flDistance/4 --跳跃曲线  sinΘ*r/w w为常量对z进行缩放
            me:SetAbsOrigin(GetGroundPosition(me:GetAbsOrigin(), me) + Vector(0,0,z))
        end
    end
end



LinkLuaModifier("modifier_hero_fenxun2", "skill/hero_fenxun.lua", LUA_MODIFIER_MOTION_NONE)


modifier_hero_fenxun2 = {}

function modifier_hero_fenxun2:IsHidden()
    return true
end
function modifier_hero_fenxun2:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED
    }
    return funcs
end
function modifier_hero_fenxun2:OnAttacked(keys)
    if keys.target ~= self:GetParent() then
        return
    end
    if not keys.attacker:IsRangedAttacker() then
        return
    end
    local attacker = keys.attacker
    local ability = self:GetAbility()
    if not ability:IsCooldownReady() then
        return
    end
    ability.vStartPosition    = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
    --ability.vTargetPosition   = GetGroundPosition(attacker:GetOrigin(),slef:GetParent())
    ability.vTargetPosition   = GetGroundPosition(attacker:GetOrigin(),self:GetParent())
    ability.flHorizontalSpeed = 1800/30--一秒位移30次
    ability.vDirection        = (ability.vTargetPosition - ability.vStartPosition):Normalized()
    ability.flDistance        = (ability.vTargetPosition - ability.vStartPosition):Length2D() + ability.flHorizontalSpeed
    ability.leap_traveled = 0
    ability.attacker = attacker
    keys.target:SetForwardVector(ability.vDirection)
    keys.target:AddNewModifier(keys.target, ability, "modifier_hero_fenxun", {duration = -1})
    ability:StartCooldown(ability:GetSpecialValueFor("duration_jump"))
end

LinkLuaModifier("modifier_hero_fenxun3", "skill/hero_fenxun.lua", LUA_MODIFIER_MOTION_NONE)


modifier_hero_fenxun3 = {}
function modifier_hero_fenxun3:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
    return funcs
end
function modifier_hero_fenxun3:GetModifierAttackSpeedBonus_Constant()
    local ability = self:GetAbility()
    return ability:GetSpecialValueFor("speed")
end

function modifier_hero_fenxun3:GetEffectName()
    return "particles/units/heroes/hero_legion_commander/legion_commander_press_owner.vpcf"
end