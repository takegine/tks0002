
-- Author: 西索酱
-- Date: 04.07.2020
-- evasion and crit


skill_hero_fengdan = class({})

function skill_hero_fengdan:needwaveup()

    local caster  = self:GetCaster()
    local owner   = caster:XinShi()
    local modname = "modifier_skill_hero_fengdan"
    if  owner.ship['longyue'] then
        caster:AddNewModifier(caster, self, modname, {})
    end
end

----------------------------------------
LinkLuaModifier( "modifier_skill_hero_fengdan", "skill/hero_fengdan", LUA_MODIFIER_MOTION_NONE )
modifier_skill_hero_fengdan = class({})
function modifier_skill_hero_fengdan:IsHidden() return false end
function modifier_skill_hero_fengdan:GetTexture () return "phantom_assassin_coup_de_grace" end

function modifier_skill_hero_fengdan:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_START
	}
end

function modifier_skill_hero_fengdan:GetModifierEvasion_Constant()
    -- if IsServer() then
        local caster  = self:GetCaster()
        local ability = self:GetAbility()
        -- local owner   = caster:XinShi()
        caster:GetPlayerOwnerID()
        local crit_chance = ability:GetLevelSpecialValueFor("crit_chance", ability:GetLevel()-1)
        -- return owner.ship['longyue'] and crit_chance or 0
        -- end

        return crit_chance
end

function modifier_skill_hero_fengdan:OnAttackStart()
    -- if IsServer() then
        local caster  = self:GetCaster()
        local ability = self:GetAbility()
        local owner   = caster:XinShi()
        local crit_chance = ability:GetLevelSpecialValueFor("crit_chance", ability:GetLevel()-1)
        if RollPercentage(crit_chance) then
            caster:AddNewModifier(caster, ability, "modifier_skill_hero_fengdan_crit", {})
        end
    -- end
end

--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_skill_hero_fengdan_crit","skill/hero_fengdan", LUA_MODIFIER_MOTION_NONE )
modifier_skill_hero_fengdan_crit = class({})
--------------------------------------------------------------------------------

function modifier_skill_hero_fengdan_crit:IsHidden() return true end
function modifier_skill_hero_fengdan_crit:IsPurgable()	return false end
function modifier_skill_hero_fengdan_crit:GetTexture () return "phantom_assassin_coup_de_grace" end

----------------------------------------

function modifier_skill_hero_fengdan_crit:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}
end

----------------------------------------

function modifier_skill_hero_fengdan_crit:OnAttackLanded( params )
    local caster  = self:GetCaster()
    local target  = params.target
    local ability = self:GetAbility()
    local prxname = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
    local prx = ParticleManager:CreateParticle( prxname, PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(prx, 0, target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(prx)
    target:EmitSound(  "Hero_PhantomAssassin.CoupDeGrace" )
    caster:RemoveModifierByName("modifier_skill_hero_fengdan_crit")

    local crit_chance = ability:GetLevelSpecialValueFor("crit_chance", ability:GetLevel()-1)
    --print(crit_chance, ability:GetLevel())
end


function modifier_skill_hero_fengdan_crit:GetModifierPreAttack_CriticalStrike( params )

    local caster  = self:GetCaster()
    local ability = self:GetAbility()
    local crit_chance = ability:GetLevelSpecialValueFor("crit_chance", ability:GetLevel()-1)
    return crit_chance
end

------------下方KV，在注册闪避的时候会是叠加态，原因未知，即前三级闪避变成了13 26 40---------------------
-- "Modifiers"
-- 		{
-- 			"modifier_skill_hero_fengdan"
-- 			{
-- 				"Passive"	"1"
-- 				"IsHidden"	"1"
-- 				"OnAttackStart"
-- 				{
-- 					"RemoveModifier"
-- 					{
-- 						"ModifierName"	"modifier_skill_hero_fengdan_crit"
-- 						"Target"	"CASTER"
-- 					}
-- 					"Random"
-- 					{
-- 						"Chance"	"%crit_chance"
-- 						"PseudoRandom"	"DOTA_PSEUDO_RANDOM_PHANTOMASSASSIN_CRIT"
-- 						"OnSuccess"
-- 						{
-- 							"ApplyModifier"
-- 							{
-- 								"ModifierName"	"modifier_skill_hero_fengdan_crit"
-- 								"Target"	"CASTER"
-- 							}
-- 						}
-- 					}
-- 				}
-- 				"Properties"
-- 				{
-- 					"MODIFIER_PROPERTY_EVASION_CONSTANT"	"%crit_chance"
-- 				}
-- 			}
-- 			"modifier_skill_hero_fengdan_crit"
-- 			{
-- 				"IsHidden"	"0"
-- 				"Properties"
-- 				{
-- 					"MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE"	"%crit_bonus"
-- 				}
-- 				"OnAttackLanded"
-- 				{
-- 					"RemoveModifier"
-- 					{
-- 						"ModifierName"	"modifier_skill_hero_fengdan_crit"
-- 						"Target"	"CASTER"
-- 					}
-- 					"FireEffect"
-- 					{
-- 						"EffectName"	"particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
-- 						"EffectAttachType"	"follow_origin"
-- 						"ControlPointEntities"
-- 						{
-- 							"TARGET"	"follow_origin"
-- 							"TARGET"	"follow_origin"
-- 						}
-- 					}
-- 					"FireSound"
-- 					{
-- 						"EffectName"	"Hero_PhantomAssassin.CoupDeGrace"
-- 						"Target"	"TARGET"
-- 					}
-- 				}
-- 			}
-- 		}