--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-07-24 01:16:38
* @LastEditors: 白喵
* @LastEditTime: 2020-08-28 17:32:37
--]]
skill_hero_qixi = {}


function skill_hero_qixi:needwaveup()
    local caster = self:GetCaster()
    local radius = self:GetSpecialValueFor("radius")
    local Origin = caster:GetAbsOrigin()
    local unitlist = FindUnitsInRadius(
                caster:GetTeamNumber(),
                Origin,
                nil,
                radius,
                DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                DOTA_UNIT_TARGET_HERO,
                DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_MELEE_ONLY,
                FIND_ANY_ORDER,
                false
            )
    for _,unit in pairs(unitlist) do
        local unit_Position = unit:GetAbsOrigin()
        local forward = unit:GetForwardVector()
        unit:MoveToPosition(unit_Position + forward * 1000)--若move在添加modifier后面 可能会位移失败
        unit:AddNewModifier(caster, self, "modifier_hero_qixi", {duration = 2})
    end
end


LinkLuaModifier("modifier_hero_qixi", "skill/hero_qixi", LUA_MODIFIER_MOTION_NONE)
modifier_hero_qixi = modifier_hero_qixi or {}
function modifier_hero_qixi:OnDestroy()
    if not IsServer() then
        return
    end
    local unit = self:GetParent()
    local unit_Position =  unit:GetAbsOrigin()
    unit:MoveToPositionAggressive(unit_Position)--销毁时下达攻击指令
end
function modifier_hero_qixi:CheckState()
    return{
        [MODIFIER_STATE_INVISIBLE] = true
    }
end
function modifier_hero_qixi:GetEffectName()
    return "particles/units/heroes/hero_mirana/mirana_moonlight_recipient.vpcf"
end
