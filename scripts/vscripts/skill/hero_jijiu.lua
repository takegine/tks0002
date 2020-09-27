--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-09-16 12:57:44
* @LastEditors: 白喵
* @LastEditTime: 2020-09-28 05:56:55
--]]
skill_hero_jijiu = {}
function skill_hero_jijiu:needwaveup()
    local caster = self:GetCaster()
    self.qingnang = nil
    if caster:HasItemInInventory('item_format_031') then
        self.qingnang = true
    end
    caster:AddNewModifier(caster, self, "modifier_hero_jijiu", nil)
end


LinkLuaModifier("modifier_hero_jijiu", "skill/hero_jijiu.lua", 0)
modifier_hero_jijiu = {}
function modifier_hero_jijiu:IsHidden()
    return true
end

function modifier_hero_jijiu:IsAura()
    return true
end

function modifier_hero_jijiu:GetAuraRadius()
    local ability = self:GetAbility()
    --print(ability:GetSpecialValueFor("radius"))
    return ability:GetSpecialValueFor("radius")
end

function modifier_hero_jijiu:GetModifierAura()
	return  "modifier_hero_jijiu2"
end


function modifier_hero_jijiu:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end


function modifier_hero_jijiu:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_hero_jijiu:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
end

function modifier_hero_jijiu:GetAuraEntityReject(unit)
    if unit == self:GetParent() then--自身无光环效果
        return true
    end
    if unit.jijiu then
        return true
    end
    --print("active")
    return false
end

modifier_hero_jijiu2 = {}
LinkLuaModifier("modifier_hero_jijiu2", "skill/hero_jijiu.lua", 0)

function modifier_hero_jijiu2:DeclareFunctions()
    return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_hero_jijiu2:OnTakeDamage(keys)
    local parent = self:GetParent()
    if keys.unit ~= parent then
        return
    end
    if parent:GetHealth() <= keys.damage then
        parent:SetHealth(1)
        parent:AddNewModifier(parent, self:GetAbility(), "modifier_hero_jijiu3", {duration = self:GetAbility():GetSpecialValueFor("duration")})
        parent.jijiu = true
    end
end

modifier_hero_jijiu3 = {}
LinkLuaModifier("modifier_hero_jijiu3", "skill/hero_jijiu.lua", 0)


function modifier_hero_jijiu3:DeclareFunctions()
    return {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_hero_jijiu3:IsHidden()
    return true
end

function modifier_hero_jijiu3:GetOverrideAnimation()
    return ACT_DOTA_DIE
end

function modifier_hero_jijiu3:GetModifierHealthRegenPercentage()
    local ability = self:GetAbility()
    local Percentage = ability:GetSpecialValueFor("recovery")/ability:GetSpecialValueFor("duration")
    return Percentage
end

function modifier_hero_jijiu3:CheckState()
    --print(IsServer())  测试结果只在服务端
    if self:GetAbility().qingnang then
        return {[MODIFIER_STATE_INVULNERABLE] = true}
    else
        return {}
    end
end