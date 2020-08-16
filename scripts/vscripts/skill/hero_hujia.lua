--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-08-16 16:33:57
* @LastEditors: 白喵
* @LastEditTime: 2020-08-16 17:16:25
--]]
skill_hero_hujia = {}

function skill_hero_hujia:needwaveup()
    local caster = self:GetCaster()
    local radius = self:GetSpecialValueFor("radius")

    local Origin = caster:GetAbsOrigin()
    local count = 0
    local unitlist = FindUnitsInRadius(
                caster:GetTeamNumber(),
                Origin,
                nil,
                radius,
                DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                DOTA_UNIT_TARGET_HERO,
                DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
                FIND_ANY_ORDER,
                false
            )

    for _,unit in pairs(unitlist) do
        if unit:GetUnitLabel() == "weiguo" then
            count = count+1
        end
    end
    for _,unit in pairs(unitlist) do
        if unit:GetUnitLabel() == "weiguo" then
            unit:AddNewModifier(caster, self, "modifier_hero_hujia",nil)
            unit:SetModifierStackCount("modifier_hero_hujia", caster, count)
        end
    end
end


LinkLuaModifier("modifier_hero_hujia", "skill/hero_hujia.lua", 0)



modifier_hero_hujia = {}


function modifier_hero_hujia:DeclareFunctions()
    return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

function modifier_hero_hujia:GetModifierPhysicalArmorBonus()
    local armor = self:GetAbility():GetSpecialValueFor("Armor")
    return armor*self:GetStackCount()
end