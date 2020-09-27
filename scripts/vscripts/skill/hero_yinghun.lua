--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-07-21 21:48:10
* @LastEditors: 白喵
* @LastEditTime: 2020-09-28 05:59:27
--]]
skill_hero_yinghun = {}
--定义技能类


--[[
* @description: 开局获得英魂buff
* @return: 
* @param {type} 
* @author: 白喵
--]]
function skill_hero_yinghun:needwaveup()
    self.caster = self:GetCaster()
    self.level = self:GetLevel()
    self.caster:AddNewModifier(self.caster, self, "modifier_hero_yinghun", nil)--添加英魂buff
end

LinkLuaModifier("modifier_hero_yinghun", "skill/hero_yinghun.lua", LUA_MODIFIER_MOTION_NONE)
--链接buff

modifier_hero_yinghun = {}
--[[
* @description: 注册攻击到事件
* @return: 
* @param {type} 
* @author: 白喵
--]]
function modifier_hero_yinghun:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end
--[[
* @description: 攻击到增加损失生命值百分比伤害
* @return: 
* @param {type} 
* @author: 白喵
--]]
function modifier_hero_yinghun:OnAttackLanded(keys)
    local ability = self:GetAbility()
    local target = keys.target
    if ability.caster ~= keys.attacker then
        return
    end
    local HealthDeficit = ability.caster:GetHealthDeficit()--获取损失生命值
    local damage = HealthDeficit*ability:GetLevelSpecialValueFor("damage", ability:GetLevel()-1)/100
    if  caster:HasItemInInventory('item_weapon_011') then
        damage = damage*(100+50)/100--持有古淀刀伤害提升百分之50
    end
ApplyDamage({
    attacker     = ability.caster,
    victim       = target,
    damage_type  = DAMAGE_TYPE_MAGICAL,
    damage       = damage
})
end
