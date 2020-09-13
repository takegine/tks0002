
LinkLuaModifier("modifier_attack", "skill/hero_qianxi.lua",LUA_MODIFIER_MOTION_NONE)

skill_hero_qianxi = class({})  --声明技能

function skill_hero_qianxi:GetIntrinsicModifierName()  --声明技能实践  技能释放
return "modifier_attack"
end


modifier_attack=class({})

function modifier_attack:DeclareFunctions()
	return {
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_attack:OnAttackLanded(keys)   
	
	local  parent  =self:GetParent()  
	local  target  =keys.target  
    local  owner   =parent:GetOwner() or {ship={}}
	local  ability =self:GetAbility()
    local  chance  =ability:GetLevelSpecialValueFor("chance", (ability:GetLevel()-1) )
	
if not IsServer()  then  return end
if keys.attacker ~= parent then return end

if  owner.ship['shuigan'] and target:GetHealthPercent()>75 then
    chance = 100
end    


if RollPercentage(chance) then

	local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, parent, parent, parent:GetTeamNumber() )
	dummy.attack_type  = "tree"
	dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

	local   damagetable={     
		    victim=target,    
		    attacker=dummy,  
		    damage=target:GetHealth()*0.17,    
		    damage_type=DAMAGE_TYPE_PHYSICAL
		} 
		ApplyDamage(damagetable)  	
	 end
	
end






