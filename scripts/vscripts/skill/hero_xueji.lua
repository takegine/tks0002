--[[
	Author: 西索酱
	Date: 30.04.2020
	每有一名友军蜀国武将存在时，可增加周围友军单位5 %近战攻击
	参考黑弓 的 射手天赋
]]

LinkLuaModifier( "modifier_skill_hero_xueji" , "skill/hero_wuji.lua" , LUA_MODIFIER_MOTION_NONE )

--[[
    Author: Bude
    Date: 30.09.2015
    Simply applies the lua modifier
--]]
function xuejicreate( keys )
    keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_skill_hero_xueji", {})
end



if modifier_skill_hero_xueji == nil then
    modifier_skill_hero_xueji = class({})
end

--[[Author: Bude
	Date: 30.09.2015.
	Grants magical resistance and attackspeed and increases model size per modifier stack
	TODO: Particles and status effects need to be implemented correctly
	NOTE: Model size increase is probably inaccurate and also awfully jumpy
]]--

function modifier_skill_hero_xueji:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

--As described: Could not get the particles to work ...
--[[
function modifier_skill_hero_xueji:GetStatusEffectName()
	return "particles/units/heroes/hero_huskar/huskar_berserker_blood_hero_effect.vpcf"
end

function modifier_skill_hero_xueji:GetStatusEffectPriority()
	return 16
end
]]--

function modifier_skill_hero_xueji:OnCreated()
	-- Variables
	self.xueji_attack_time	= self:GetAbility():GetSpecialValueFor( "attack_time_per_stack" )
	self.xueji_vamp_bonus	= self:GetAbility():GetSpecialValueFor( "vamp_bonus_per_stack" )
	self.xueji_model_size	= self:GetAbility():GetSpecialValueFor( "model_size_per_stack")
	self.xueji_hurt_ceiling 	= self:GetAbility():GetSpecialValueFor( "hurt_health_ceiling")
	self.xueji_hurt_floor	= self:GetAbility():GetSpecialValueFor( "hurt_health_floor")
	self.xueji_hurt_step		= self:GetAbility():GetSpecialValueFor( "hurt_health_step")


    if IsServer() then
        --print("Created")
        self:SetStackCount( 1 )
		self:GetParent():CalculateStatBonus()

		self:StartIntervalThink(0.1) 
    end
end

function modifier_skill_hero_xueji:OnIntervalThink()
	if IsServer() then
		--print("Thinking")

		-- Variables
		local caster = self:GetParent()
		local oldStackCount = self:GetStackCount()
		local health_perc = caster:GetHealthPercent()/100
		local newStackCount = 1

		local model_size = self.xueji_model_size
		local hurt_health_ceiling = self.xueji_hurt_ceiling
		local hurt_health_floor = self.xueji_hurt_floor
		local hurt_health_step = self.xueji_hurt_step


	    for current_health=hurt_health_ceiling, hurt_health_floor, -hurt_health_step do
	        if health_perc <= current_health then

	            newStackCount = newStackCount+1
	        else
	        	break
	        end
	    end
	   
    	local difference = newStackCount - oldStackCount

    	-- set stackcount
    	if difference ~= 0 then
    		caster:SetModelScale(caster:GetModelScale()+difference*model_size)
    		self:SetStackCount( newStackCount )
    		self:ForceRefresh()
    	end
		
	end
end

function modifier_skill_hero_xueji:OnRefresh()
	self.xueji_attack_time = self:GetAbility():GetSpecialValueFor( "attack_time_per_stack" )
	self.xueji_vamp_bonus = self:GetAbility():GetSpecialValueFor( "vamp_bonus_per_stack" )
	local StackCount = self:GetStackCount()
	local caster = self:GetParent()

    if IsServer() then
        self:GetParent():CalculateStatBonus()
    end
end

function modifier_skill_hero_xueji:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE 
	}

	return funcs
end

function modifier_skill_hero_xueji:GetModifierBaseAttackTimeConstant( params )
	return self:GetStackCount() * self.xueji_attack_time
end

function modifier_skill_hero_xueji:GetModifierLifestealRegenAmplify_Percentage ( params )
	return self:GetStackCount() * self.xueji_vamp_bonus
end