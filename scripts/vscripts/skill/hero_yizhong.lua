--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-08-16 19:53:49
* @LastEditors: 白喵
* @LastEditTime: 2020-08-17 00:04:11
--]]


--减少于禁所受的90%木系伤害，同时受到的火焰与闪电伤害也将降低3%X等级。

skill_hero_yizhong = {}

function skill_hero_yizhong:needwaveip()
    local level = self:GetLevel()
    local caster = self:GetCaster()
    local hModifierTable =
    {
        tree = self:GetSpecialValueFor("tree"),
        fire = self:GetSpecialValueFor("fire"),
        electrical = self:GetSpecialValueFor("electrical")
    }
    caster:AddNewModifier(caster, self, "modifier_defend_big", hModifierTable)--添加伤害减免buff
end


