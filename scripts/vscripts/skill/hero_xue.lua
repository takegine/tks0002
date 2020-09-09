--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-09-08 23:59:45
* @LastEditors: 白喵
* @LastEditTime: 2020-09-09 09:32:14
--]]
skill_hero_xue ={}


function skill_hero_xue:needwaveup()
    local caster = self:GetCaster()
    caster.reSpawn = true
    caster:AddNewModifier(caster, self, "modifier_hero_xue", nil)
end

LinkLuaModifier("modifier_hero_xue", "skill/hero_xue.lua", 0)


modifier_hero_xue = {}
function modifier_hero_xue:IsHidden() return true end
function modifier_hero_xue:RemoveOnDeath() return false end

function modifier_hero_xue:DeclareFunctions()
    --return {MODIFIER_EVENT_ON_DEATH}
    return {MODIFIER_PROPERTY_REINCARNATION,MODIFIER_EVENT_ON_RESPAWN}
end

function modifier_hero_xue:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end



function modifier_hero_xue:ReincarnateTime()
    return 6.0
end

function modifier_hero_xue:OnRespawn(keys)
    local parent = self:GetParent()
    if parent ~= keys.unit then
        return
    end
    if parent:HasModifier("modifier_hero_xue") then
        parent:RemoveModifierByName("modifier_hero_xue")
    end
end



-- function modifier_hero_xue:OnDeath(keys)
--     local parent = self:GetParent()
--     if parent ~= keys.unit then
--         return
--     end
    
--     Timer(6.0,function() parent:RespawnUnit() end)  --单位被释放
-- end