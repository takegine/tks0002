--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-09-03 04:50:40
* @LastEditors: 白喵
* @LastEditTime: 2020-09-03 18:40:49
--]]
skill_hero_caokong = {}

function skill_hero_caokong:needwaveup()
    local caster = self:GetCaster()
    local owner = caster:XinShi()
    if owner.ship["konghe"] then 
        caster:AddNewModifier(caster, self, "modifier_hero_caokong", nil)
    end
end

LinkLuaModifier("modifier_hero_caokong", "skill/hero_caokong.lua", 0)

modifier_hero_caokong = {}

function modifier_hero_caokong:DeclareFunctions()
    return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_hero_caokong:IsHidden()
    return true
end


function modifier_hero_caokong:OnTakeDamage(keys)
    local parent = self:GetParent()
    if keys.unit ~= parent then
        return
    end
    if parent:GetHealth() <= keys.damage then
        for k,v in ipairs(parent.illusions) do
            if v:IsAlive() then
                parent:SetHealth(parent:GetMaxHealth()*v:GetHealthPercent())
                v:ForceKill(false)
                return
            else
                table.remove(parent.illusions,k)
            end
        end
    end
end

