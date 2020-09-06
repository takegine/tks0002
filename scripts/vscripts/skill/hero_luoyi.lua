--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-09-06 17:54:12
* @LastEditors: 白喵
* @LastEditTime: 2020-09-06 20:25:58
--]]


skill_hero_luoyi = {}


function skill_hero_luoyi:OnSpellStart()
    if not IsServer() then
        return
    end
    local caster = self:GetCaster()
    local owner = caster:GetOwner() or {ship = {}}
    caster:AddNewModifier(caster, self, "modifier_hero_luoyi", {duration = self:GetSpecialValueFor("duration")})
    if owner.ship['huben'] then
        local unistlist = FindUnitsInRadius(
            caster:GetTeamNumber(),
            caster:GetAbsOrigin(),
            nil,
            250,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO,
            DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
            FIND_ANY_ORDER,
            false
        )
        local damage = self:GetLevel()*200
        for _,unit in ipairs(unistlist) do
            local info = 
            {
                attacker     = caster,
                victim       = unit,
                damage_type  = DAMAGE_TYPE_MAGICAL,
                damage       = damage,
                damage_flags = DOTA_DAMAGE_FLAG_NONE
            }
            ApplyDamage(info)
            unit:AddNewModifier(caster,self,"modifier_hero_luoyi2",{duration = 2})
        end
    end
end

LinkLuaModifier("modifier_hero_luoyi", "skill/hero_luoyi.lua", 0)
modifier_hero_luoyi = {}

function modifier_hero_luoyi:OnCreated(table)
    local parent = self:GetParent()
    if parent:GetHealthPercent() < 60 then --modifier属性是双端运行所以要在这里赋值
        self.speed = true
    else
        self.speed = false
    end
end

function modifier_hero_luoyi:DeclareFunctions()
    return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_hero_luoyi:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("attack")
end

function modifier_hero_luoyi:GetModifierPhysicalArmorBonus()
    return -(self:GetAbility():GetSpecialValueFor("reduceDef"))
end

function modifier_hero_luoyi:GetModifierAttackSpeedBonus_Constant()
    if self.speed then
        return self:GetAbility():GetSpecialValueFor("speed")
    else
        return 0
    end
end

LinkLuaModifier("modifier_hero_luoyi2", "skill/hero_luoyi.lua", 0)
modifier_hero_luoyi2 = {}

function modifier_hero_luoyi2:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = true
    }
end


function modifier_hero_luoyi2:IsHidden()
    return true
end