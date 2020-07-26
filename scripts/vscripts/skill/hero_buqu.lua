--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-07-23 00:48:22
* @LastEditors: 白喵
* @LastEditTime: 2020-07-24 22:09:12
--]]



skill_hero_buqu = {}
function skill_hero_buqu:needwaveup()
    self.flag = false
    self.caster = self:GetCaster()
    self.level = self:GetLevel()
    self.owner = self.caster:GetOwner() or {ship = {}}
    self.caster:AddNewModifier(self.caster, self, "modifier_skill_hero_buqu", nil)
end


LinkLuaModifier("modifier_skill_hero_buqu", "skill/hero_buqu.lua", LUA_MODIFIER_MOTION_NONE)
modifier_skill_hero_buqu = {}

function modifier_skill_hero_buqu:IsHidden()
    return true
end

function modifier_skill_hero_buqu:DeclareFunctions()
    return {MODIFIER_EVENT_ON_TAKEDAMAGE,MODIFIER_EVENT_ON_ATTACKED}
end

--[[
* @description: 给单位添加不死buff隐藏起来,等触发不死效果后,显示出buff.
* @return: 
* @param {type} 
* @author: chriscp_cat
--]]
-- function modifier_skill_hero_buqu:OnTakeDamage(keys)
--     if caster ~= keys.unit then
--         return
--     end
--     if unit:IsSilenced() then
--         return
--     end
--     local duration = --2+0.3*level
--     if owner.ship['chusheng'] then
--         duration = duration*(100+50)/100
--     end
--     if not keys.unit:HasModifier("modifier_skill_hero_buqu2") then
--         keys.unit:AddNewModifier(keys.unit, keys.ability, "modifier_skill_hero_buqu2", nil)
--         keys.unit:SetModifierStackCount("modifier_skill_hero_buqu2", keys.unit, 1)--变量无法在IsHideen里使用 不知道为何,故使用层数
--     end
--     if keys.unit:GetHealth() == 1 then
--         if keys.unit:HasModifier("modifier_skill_hero_buqu2") and flag == true then
--             return
--         end
--         keys.unit:AddNewModifier(keys.unit, keys.ability, "modifier_skill_hero_buqu2", {duration = duration}) 
--         keys.unit:SetModifierStackCount("modifier_skill_hero_buqu2", keys.unit, 0)--变量无法在IsHideen里使用 不知道为何,故使用层数
--         flag = true
--     end
-- end

function modifier_skill_hero_buqu:OnTakeDamage(keys)
    local ability = self:GetAbility()
    if ability.caster ~= keys.unit then
        return
    end
    if keys.unit:IsSilenced() then
        return
    end
    local duration = 2+0.3*ability.level
    if ability.owner.ship['chusheng'] then
        duration = duration*(100+50)/100
    end
    if ability.caster:GetHealth() <= keys.damage and not ability.flag then
        ability.caster:SetHealth(1)
        ability.caster:AddNewModifier(keys.unit, keys.ability, "modifier_skill_hero_buqu2", {duration = duration})
        ability.flag = true
    end
end



function modifier_skill_hero_buqu:OnAttacked(keys)
    local ability = self:GetAbility()
    if ability.caster ~= keys.target then
        return
    end
    if ability.caster:HasModifier("modifier_skill_hero_buqu2") and ability.flag == true then
        if ability.owner.ship["chusheng"] then
            if not keys.attacker:IsRangedAttacker() then
                local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, ability.caster, ability.caster, ability.caster:GetTeamNumber() )
                dummy.attack_type  = "electrical"
                ApplyDamage({
                    victim = keys.attacker,
                    attacker = dummy,
                    damage = keys.damage*0.6,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    damage_flags = nil,
                    ability = keys.ability
                })
                dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )
            end
        end
    end
end



LinkLuaModifier("modifier_skill_hero_buqu2", "skill/hero_buqu.lua", LUA_MODIFIER_MOTION_NONE)
modifier_skill_hero_buqu2 = {}


function modifier_skill_hero_buqu2:IsHidden()
        return false
end


function modifier_skill_hero_buqu2:IsDebuff()
    return false
end

function modifier_skill_hero_buqu2:DeclareFunctions()
    return {MODIFIER_PROPERTY_MIN_HEALTH}
end

function modifier_skill_hero_buqu2:GetMinHealth()
    return 1
end