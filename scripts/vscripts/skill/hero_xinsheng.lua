--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-09-16 17:19:45
* @LastEditors: 白喵
* @LastEditTime: 2020-10-21 22:46:53
--]]
skill_hero_xinsheng = {}
function skill_hero_xinsheng:needwaveup()
    local caster = self:GetCaster()
    if caster:HasItemInInventory('item_format_034') then
        self.dunjia = true
    end
    caster:AddNewModifier(caster, self, "modifier_hero_xinsheng", nil)
end


LinkLuaModifier("modifier_hero_xinsheng", "skill/hero_xinsheng.lua", 0)
modifier_hero_xinsheng = {}

function modifier_hero_xinsheng:IsHidden()
    return true
end

function modifier_hero_xinsheng:IsAura()
    return true
end

function modifier_hero_xinsheng:GetAuraRadius()
    local ability = self:GetAbility()
    return ability:GetSpecialValueFor("radius")
end

function modifier_hero_xinsheng:GetModifierAura()
	return  "modifier_hero_xinsheng2"
end


function modifier_hero_xinsheng:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end


function modifier_hero_xinsheng:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_hero_xinsheng:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
end



LinkLuaModifier("modifier_hero_xinsheng2", "skill/hero_xinsheng.lua", 0)
modifier_hero_xinsheng2 = {}
function modifier_hero_xinsheng2:DeclareFunctions()
    return {MODIFIER_EVENT_ON_ABILITY_EXECUTED,MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE}
end

function modifier_hero_xinsheng2:OnAbilityExecuted(keys)
    local parent = self:GetParent()
    if self.xinsheng then
        return
    end
    if keys.unit ~= parent then
        return
    end
    local ability = self:GetAbility()
    if not ability.dunjia then
        if not RollPercentage(ability:GetSpecialValueFor("chance"))then
            return
        end
    end
    for i=5, 15, 1 do--刷新所有技能  16个
        local current_ability = parent:GetAbilityByIndex (i)
        if current_ability ~= nil then
            --print(current_ability:GetAbilityName(),current_ability:IsRefreshable())
            if current_ability:IsRefreshable() then
                Timer(0.01,function()
                    if current_ability:IsNull() then
                        return
                    end
                    current_ability:EndCooldown()
                end)--事件在技能进入cd之前不能在此刷新
            end
        end
    end
    self.xinsheng = true
end


function modifier_hero_xinsheng2:GetModifierHealthRegenPercentage()
    return self:GetAbility():GetSpecialValueFor("health")
end


