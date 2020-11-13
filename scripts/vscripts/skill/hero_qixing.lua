--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-11-13 18:05:15
* @LastEditors: 白喵
* @LastEditTime: 2020-11-13 18:18:12
--]]
skill_hero_qixing = {}
function skill_hero_qixing:needwaveup()
    local caster = self:GetCaster()
    local mod = caster:AddNewModifier(caster, self, "modifier_hero_qixing", nil)
    mod:SetStackCount(self:GetSpecialValueFor("count"))
end


LinkLuaModifier("modifier_hero_qixing", "skill/hero_qixing.lua", 0)
modifier_hero_qixing = {}
function modifier_hero_qixing:DeclareFunctions()
    return {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE}
end


function modifier_hero_qixing:GetModifierHealthRegenPercentage()
    local ability = self:GetAbility()
    local count = self:GetStackCount()
    local heal = ability:GetSpecialValueFor("heal")
    return heal*count
end