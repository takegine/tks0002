--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-11-23 12:55:40
* @LastEditors: 白喵
* @LastEditTime: 2020-11-23 13:43:13
--]]
skill_hero_wuhun = {}

function skill_hero_wuhun:needwaveup()
    local caster = self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_wuhun", nil)
end

LinkLuaModifier("modifier_wuhun", "skill/hero_wuhun.lua", 0)

modifier_wuhun = {IsHidden = on}


function modifier_wuhun:DeclareFunctions()
    return {MODIFIER_EVENT_ON_TAKEDAMAGE,MODIFIER_EVENT_ON_DEATH}
end

function modifier_wuhun:OnTakeDamage(keys)
    local parent = self:GetParent()
    if parent ~= keys.unit then
        return
    end
    local attacker = keys.attacker
    if not self.wuhun then
        self.wuhun = {}
    end
    local flag = self.wuhun[attacker]
    if not flag then
        self.wuhun[attacker] = 1
    else
        self.wuhun[attacker] = flag >= 20 and 20 or flag + 1
    end
end

function modifier_wuhun:OnDeath(keys)
    local parent = self:GetParent()
    if parent ~= keys.unit or not self.wuhun then
        return
    end
    local dummy = CreateUnitByName( "npc_damage_dummy", OUT_SIDE_VECTOR, false, parent, parent, parent:GetTeamNumber())
    dummy.attack_type  = "god"
    local ability = self:GetAbility()
    local  info
    for u,i in pairs(self.wuhun) do
        if u:IsNull() then
            goto continue
        end
        local damage = u:GetMaxHealth()*ability:GetSpecialValueFor("damage")/100
        damage = damage*(1+ability:GetSpecialValueFor("flag")*i/100)
        
        info = {
            attacker     = dummy,
            victim       = u,
            damage_type  = DAMAGE_TYPE_MAGICAL,
            damage       = damage, 
            damage_flags = DOTA_DAMAGE_FLAG_NONE
        }
        ApplyDamage(info)
        ::continue::
    end
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )
end