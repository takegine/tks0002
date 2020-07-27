-- 不用linkluamodifier 也不是多次执行脚本的技能，可以把脚本都放在这里
-- 这个文件是给 白喵 放置脚本的

--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-07-21 22:49:01
* @LastEditors: 白喵
* @LastEditTime: 2020-07-28 00:24:12
--]]

--[[
* @description: 缔盟
* @return: 
* @param {type} 
* @author: chriscp_cat
--]]
function Dimeng(keys)
    local ability = keys.ability
    local level = ability:GetLevel()
    local target = keys.target
    if ability:IsCooldownReady() then
        local GiveMana = ability:GetSpecialValueFor("reduce")
        target:ReduceMana(GiveMana)--减少目标蓝量
        ability:StartCooldown(5.0)--使技能进入冷却
    end
end


