item_weapon_012 = item_weapon_012 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_weapon_012_owner","items/0/012", 0 )
LinkLuaModifier( "modifier_item_weapon_012_hero","items/0/012", 0 )
LinkLuaModifier( "modifier_item_weapon_012_unit","items/0/012", 0 )
modifier_item_weapon_012_owner = modifier_item_weapon_0012_owner or {}--给主公（信使）的效果
modifier_item_weapon_012_hero = modifier_item_weapon_0012_hero or {}--给武将的效果
modifier_item_weapon_012_unit = modifier_item_weapon_0012_unit or {}--给民兵的效果


function item_weapon_012:Precache( context )
    PrecacheResource("particle", "particles/econ/items/lina/lina_ti6/lina_ti6_laguna_blade.vpcf", context)
end

function item_weapon_012:CastFilterResultTarget( hTarget )
    if IsServer() then return end

    local stage =CustomNetTables:GetStage( "stage" )
    if stage ~= "GAME_STAT_FINGHT" then
        self.result = stage
        return UF_FAIL_CUSTOM
    end

    return 0 --UF_SUCCESS
end

function item_weapon_012:GetCustomCastError() 
    return self.result
end

function item_weapon_012:GetBehavior()
    local caster = self:GetCaster()
   return caster:GetName() == SET_FORCE_HERO and DOTA_ABILITY_BEHAVIOR_UNIT_TARGET or  DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function item_weapon_012:GetCooldown()
	return 60
end

function item_weapon_012:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    caster:EmitSound("Ability.LagunaBlade")

    local fx = ParticleManager:CreateParticle("particles/econ/items/lina/lina_ti6/lina_ti6_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControlEnt(fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(fx)

    if target:TriggerSpellAbsorb(self) then return end
    
    EmitSoundOn("Ability.LagunaBladeImpact", target)
    target:AddNewModifier(caster, self, "modifier_item_weapon_012_owner", {duration=0.01})
end

--------------------------------------------------------------------------------


modifier_item_weapon_012_owner = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    GetAttributes           = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
})


--------------------------------------------------------------------------------

if IsServer() then
    function modifier_item_weapon_012_owner:OnRefresh()
        self:OnCreated()
    end 

    function modifier_item_weapon_012_owner:OnCreated()
        self.damage = self:GetAbility():GetSpecialValueFor("p1") * self:GetParent():GetMaxHealth() /100 + 6000
    end

    function modifier_item_weapon_012_owner:OnDestroy()
        local parent=self:GetParent()
        local ability = self:GetAbility()
        local caster = self:GetCaster()
        if not parent:IsMagicImmune() and not parent:IsInvulnerable() and not parent:IsOutOfGame() then
            local damage_table = {
                victim = parent,
                attacker = caster,
                damage = self.damage,
                damage_type = DAMAGE_TYPE_PURE,
                ability = ability,
                damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_REFLECTION,
            }
            ApplyDamage(DamageTable)

            if (parent:GetHealth() <= self.damage ) then
                if parent:HasModifier("modifier_skill_hero_buqu") then
                    parent:RemoveModifierByName("modifier_skill_hero_buqu")
                    parent:RemoveAbility("skill_hero_buqu")
                end

            if parent:HasModifier("modifier_skill_hero_guishen") then 
                parent:RemoveModifierByName("modifier_skill_hero_guishen")
                parent:RemoveAbility("skill_hero_guishen")
            end

            if parent:HasAbility("skill_hero_sunchu") then 
                parent:RemoveAbility("skill_hero_sunchu")
            end

            if parent:HasModifier("modifier_hero_xue") then 
                parent:RemoveModifierByName("modifier_hero_xue")
                parent:RemoveAbility("skill_hero_xue")
            end

            if parent:HasModifier("modifier_xingshang") then 
                parent:RemoveModifierByName("modifier_xingshang")
                parent:RemoveAbility("skill_hero_xingshang")
            end

                parent:Kill(ability, self.caster)    
            end
           

        end
    end
end

function modifier_item_weapon_012_hero:IsHidden ()      return true end
