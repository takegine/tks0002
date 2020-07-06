--[[
    Author: 西索酱
    Date: 30.05.2020
    转移30%的属性给随机队友
]]

function on_created(keys)
    
    self = keys.ability
    local caster   = self:GetCaster()
    local range	   = self:GetLevelSpecialValueFor("range",(self:GetLevel()-1))
    local tFriend  = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_HERO, 0, 0, false )

    for k,v in pairs(tFriend)do 
        if v==caster or v:GetName()==SET_FORCE_HERO then
            table.remove(tFriend, k)
        end
    end
    if #tFriend == 0 then return UF_FAIL_DEAD end

    local duration = self:GetLevelSpecialValueFor("duration",(self:GetLevel()-1))
    local change = self:GetLevelSpecialValueFor("change",(self:GetLevel()-1))
    self.Str     = math.ceil(caster:GetStrength()*change)
    self.Agi     = math.ceil(caster:GetAgility()*change)
    self.Int     = math.ceil(caster:GetIntellect()*change)
    local sBuff  = "modifier_skill_hero_fangquan_buff_"
    local sDebuff= "modifier_skill_hero_fangquan_debuff_"

    local target = tFriend[RandomInt(1, #tFriend)]        

    for _,v in pairs({"Str","Agi","Int"}) do
        self:ApplyDataDrivenModifier(caster, target, sBuff..v, {duration=duration})
        target:SetModifierStackCount(sBuff..v, caster, self[v])

        self:ApplyDataDrivenModifier(target, caster, sDebuff..v, nil)
        caster:SetModifierStackCount(sDebuff..v, target,self[v])
    end
    
end

function on_destroy(keys)
    local target = keys.target
    local caster = keys.caster
    local sDebuff= "modifier_skill_hero_fangquan_debuff_"

    for _,v in pairs({"Str","Agi","Int"}) do
        if target:IsAlive() and caster:HasModifier(sDebuff..v) then
            caster:RemoveModifierByNameAndCaster(sDebuff..v, target)
        end
    end
end