LinkLuaModifier('modifier_skill_hero_guishen', 'skill/hero_guishen.lua', 0)
LinkLuaModifier('modifier_skill_hero_guishen_wraith', 'skill/hero_guishen.lua', 0)


skill_hero_guishen=class({})

function skill_hero_guishen:needwaveup()  
    local caster=self:GetCaster()

    local owner = caster:GetOwner() or {ship={}}   

    if owner.ship['guishen'] then
      caster:AddNewModifier(caster, self ,'modifier_skill_hero_guishen', {})
    end
end

function skill_hero_guishen:OnAbilityPhaseStart()
	return false 
end

modifier_skill_hero_guishen = class({})

function modifier_skill_hero_guishen:IsDebuff()			return false end
function modifier_skill_hero_guishen:IsHidden() 			return true end
function modifier_skill_hero_guishen:IsPurgable() 			return false end
function modifier_skill_hero_guishen:DeclareFunctions() 
  return {
    MODIFIER_PROPERTY_MIN_HEALTH, 
    MODIFIER_EVENT_ON_TAKEDAMAGE, 
  } 
end

function modifier_skill_hero_guishen:GetMinHealth() return 1 end

function modifier_skill_hero_guishen:OnCreated()
  local parent = self:GetParent()
	if IsServer() then
		self.hp = parent:GetHealth()
	end
end

function modifier_skill_hero_guishen:OnTakeDamage(keys)
	if not IsServer() then
		return
  end

  local duration = 4 
  local parent = self:GetParent()
  local caster = self:GetCaster() 
  local ability = self:GetAbility()
  local owner = caster:GetOwner() or {ship={}}
  if keys.unit == parent and self.hp <= keys.damage and parent:IsRealHero() and not parent:HasModifier("modifier_skill_hero_guishen_wraith")then
    
    parent:EmitSound("Hero_SkeletonKing.Reincarnate.Ghost")

    if caster:HasItemInInventory("item_horses_016")  then
      local duration = duration * 1.5
    end  

    if owner.ship['quanqing'] then
      local duration = duration * 1.5
    end
    
    parent:AddNewModifier(caster,ability, "modifier_skill_hero_guishen_wraith", {duration = duration, attacker = keys.attacker:entindex()})
    parent:RemoveModifierByName("modifier_skill_hero_guishen")
	else
		self.hp = parent:GetHealth()
	end
end

function modifier_skill_hero_guishen:OnDestroy()
	if IsServer() then
		self.hp = nil
	end
end

modifier_skill_hero_guishen_wraith = class({})

function modifier_skill_hero_guishen_wraith:IsDebuff()			return false end
function modifier_skill_hero_guishen_wraith:IsHidden() 			return false end
function modifier_skill_hero_guishen_wraith:IsPurgable() 		return false end
function modifier_skill_hero_guishen_wraith:GetStatusEffectName() return "particles/status_fx/status_effect_wraithking_ghosts.vpcf" end
function modifier_skill_hero_guishen_wraith:StatusEffectPriority() return 16 end


function modifier_skill_hero_guishen_wraith:CheckState() 
  local caster = self:GetCaster() 
  local owner = caster:GetOwner() or {ship={}}
  return {
    [MODIFIER_STATE_MAGIC_IMMUNE] = owner.ship['mingzhu'],
    [MODIFIER_STATE_NO_HEALTH_BAR]= true, 
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
  } 
end

function modifier_skill_hero_guishen_wraith:DeclareFunctions() 
  return {
    MODIFIER_PROPERTY_MIN_HEALTH, 
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
    MODIFIER_PROPERTY_DISABLE_HEALING
  } 
end

function modifier_skill_hero_guishen_wraith:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_skill_hero_guishen_wraith:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_skill_hero_guishen_wraith:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_skill_hero_guishen_wraith:GetDisableHealing()
	return 1
end

function modifier_skill_hero_guishen_wraith:GetMinHealth() 
  return 1 
end

function modifier_skill_hero_guishen_wraith:GetModifierAttackSpeedBonus_Constant()
  local ability = self:GetAbility()
  local atk_speed = ability:GetSpecialValueFor("atk_speed")
    return atk_speed
end

function modifier_skill_hero_guishen_wraith:OnCreated(keys)
	if IsServer() then
    self.attacker = EntIndexToHScript(keys.attacker)
    self.parent = self:GetParent()
	end
end

function modifier_skill_hero_guishen_wraith:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
end

function modifier_skill_hero_guishen_wraith:OnDestroy()
  -- local parent = self:GetParent()
  local caster = self:GetCaster()
  local ability = self:GetAbility()
	if IsServer() then
    self.attacker = ((self.attacker and not self.attacker:IsNull()) and self.attacker or self:GetParent())
  
			local damageTable = {
			victim = self.parent,
			attacker = self.attacker,
			damage = 100000000,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility(),
			damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_REFLECTION,
			}
			ApplyDamage(damageTable)
    -- TrueKill(self.attacker, self:GetParent(), self:GetAbility())
    self.parent:Kill(self:GetAbility(), self.attacker)
    self.attacker = nil
  end
  
end