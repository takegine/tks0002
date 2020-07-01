--[[
	Author: 西索酱
	Date: 30.06.2020
	每有一名友军蜀国武将存在时，可增加周围友军单位5 %近战攻击
]]

skill_hero_jijiang = skill_hero_jijiang or {}

function skill_hero_jijiang:needwaveup()
    
	local caster  = self:GetCaster()
    local owner   = caster:GetOwner() or {ship={}}
    
    local modifierName ="modifier_jijiang"
    local radius = self:GetSpecialValueFor("radius")
    local damagebase   = self:GetSpecialValueFor( "damagebase" ) / 100
	local target_team  = self:GetAbilityTargetTeam()
	local target_types = self:GetAbilityTargetType()
    local target_flags = self:GetAbilityTargetFlags()

    if caster:GetAbsOrigin().z ~=owner:GetAbsOrigin().z then print(caster:GetAbsOrigin().z) return end

    local units = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetAbsOrigin(),nil,radius,target_team,target_types,target_flags,0,true)
    
    local count = 0
    local namelist = {}
    for k,v in pairs(units) do
        if v:GetUnitLabel()=="shuguo" 
        and not namelist[v:GetUnitName()] then
            namelist[v:GetUnitName()]=true
            count = count + 1
        end
    end

    for _,v in pairs(units) do
        if  v:GetName() ~= "npc_dota_hero_phoenix" then
            v:AddNewModifier(caster, self, modifierName, {})
            v:SetModifierStackCount( modifierName, caster ,
            v:IsRangedAttacker() and math.ceil(count * v:GetAttackDamage() * damagebase) or 0 )
            print(math.ceil(count * v:GetAttackDamage() * damagebase))
        end
    end
end


LinkLuaModifier( "modifier_jijiang", "skill/hero_jijiang", LUA_MODIFIER_MOTION_NONE )
modifier_jijiang = modifier_jijiang or {}
--------------------------------------------------------------------------------

function modifier_jijiang:IsHidden()      return false end
function modifier_jijiang:IsPurgable()	  return false end
function modifier_jijiang:GetTexture ()   return "ursa_fury_swipes" end
function modifier_jijiang:RemoveOnDeath() return true end

----------------------------------------

function modifier_jijiang:OnCreated( data )
    self:StartIntervalThink(0.5)
end

function modifier_jijiang:OnIntervalThink(keys)
    if IsServer() then
        local parent = self:GetParent()
        if self:GetCaster() then
            local caster = self:GetCaster()
            if not caster:IsAlive()
            or not parent:IsAlive() then
                parent:RemoveModifierByNameAndCaster(self:GetName(),caster)
                end
        else self:Destroy()
        end
    end
end
----------------------------------------

function modifier_jijiang:DeclareFunctions()
    return { MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE  }
end

----------------------------------------

function modifier_jijiang:GetModifierPreAttack_BonusDamage( data )
    return self:GetStackCount()
end