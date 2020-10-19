item_weapon_003 = item_weapon_003 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_weapon_003_owner","items/0/003", 0 )
LinkLuaModifier( "modifier_item_weapon_003_hero","items/0/003", 0 )
LinkLuaModifier( "modifier_item_weapon_003_unit","items/0/003", 0 )
modifier_item_weapon_003_owner = modifier_item_weapon_003_owner or {}--给主公（信使）的效果
modifier_item_weapon_003_hero = modifier_item_weapon_003_hero or {}--给武将的效果
modifier_item_weapon_003_unit = class(modifier_item_weapon_003_hero) or class({})--给民兵的效果

function modifier_item_weapon_003_hero:DeclareFunctions()	
    return 
    { 
        MODIFIER_EVENT_ON_DEATH
    } 
end

function modifier_item_weapon_003_hero:OnDeath( keys)
    local owner   = self:GetParent()
    local ability  = self:GetAbility()
    local gold    	= ability:GetSpecialValueFor("p1")
    if  keys.attacker == owner and keys.unit:IsRealHero() or keys.unit:IsBoss() or keys.unit:IsCreep() then 
        owner:ModifyGold(gold, true, DOTA_ModifyGold_HeroKill)
        SendOverheadEventMessage(owner:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, owner, gold, owner:GetPlayerOwner())
    end
end

function modifier_item_weapon_003_hero:IsDebuff()			        return false end
function modifier_item_weapon_003_hero:IsHidden() 		            return true end
function modifier_item_weapon_003_hero:IsPurgable() 		        return false end
function modifier_item_weapon_003_hero:AllowIllusionDuplicate() 	return false end
function modifier_item_weapon_003_hero:RemoveOnDeath()	            return false end


