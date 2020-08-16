--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-08-16 20:03:05
* @LastEditors: 白喵
* @LastEditTime: 2020-08-17 00:06:20
--]]
skill_hero_yuwu = {}

function skill_hero_yuwu:needwaveup()
    local caster = self:GetCaster()
    local owner = caster:GetOwner()
    if not owner then
        return
    end
    --获取所有武将添加 减伤buff
    local unitlist = FindUnitsInRadius(
        caster:GetTeamNumber(),
        Vector(0,0,0),
        nil,
        FIND_UNITS_EVERYWHERE,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
        FIND_ANY_ORDER,
        false
    )
    for _,unit in pairs(unitlist) do
        if unit:GetUnitLabel() ~= "weiguo" then
            return
        end
        if unit == caster then
            return
        end
        print(unit:GetUnitName())
        local u_lv = unit:GetLevel()
        local hModifierTable =
        {
            tree = self:GetSpecialValueFor("tree")*u_lv,
            electrical = self:GetSpecialValueFor("electrical")*u_lv
        }
        unit:AddNewModifier(caster, self, "modifier_defend_big", hModifierTable)
    end
end