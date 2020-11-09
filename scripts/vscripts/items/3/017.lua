item_horses_017 = item_horses_017 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_horses_017_owner","items/3/017", 0 )
LinkLuaModifier( "modifier_item_horses_017_hero","items/3/017", 0 )
LinkLuaModifier( "modifier_item_horses_017_unit","items/3/017", 0 )
LinkLuaModifier( "modifier_jiaoxie","items/3/017", 0 )

modifier_item_horses_017_owner = modifier_item_horses_017_owner or {}--给主公（信使）的效果
modifier_item_horses_017_hero = modifier_item_horses_017_hero or {}--给武将的效果
modifier_item_horses_017_unit = modifier_item_horses_017_unit or {}--给民兵的效果

function item_horses_017:GetBehavior()

    local caster = self:GetCaster()
    return caster:GetName() == SET_FORCE_HERO and DOTA_ABILITY_BEHAVIOR_POINT or  DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function item_horses_017:OnSpellStart()

    local caster  =self:GetCaster()
    local point   =self:GetCursorPosition()

    local duration=self:GetSpecialValueFor("p1")
    local raduis  =self:GetSpecialValueFor("p2")

    local target_team  = self:GetAbilityTargetTeam()
	local target_types = self:GetAbilityTargetType()
    local target_flags = self:GetAbilityTargetFlags()
     
    local enemy = FindUnitsInRadius(caster:GetTeamNumber(), 
                                    point, 
                                    nil, 
                                    raduis,
                                    target_team, 
                                    target_types, 
                                    target_flags, 
                                    0, 
                                    true)
    for key,unit in pairs(enemy) do
    unit:AddNewModifier(caster, self, "modifier_jiaoxie", {duration=duration})
    end 
 
end

modifier_jiaoxie=class({})

function modifier_jiaoxie:CheckState()
    local state = {
    [MODIFIER_STATE_DISARMED]=true
}      return state
end

