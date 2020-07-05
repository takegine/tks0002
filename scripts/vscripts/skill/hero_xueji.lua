
-- Author: 西索酱
-- Date: 04.07.2020
-- 狂战士核心技：卖血，增加属性

skill_hero_xueji = skill_hero_xueji or {}


function skill_hero_xueji:GetIntrinsicModifierName()
    return "modifier_skill_hero_xueji"
end

-- Author: 西索酱
-- Date: 04.07.2020
-- evasion and crit

LinkLuaModifier( "modifier_skill_hero_xueji" , "skill/hero_xueji.lua" , LUA_MODIFIER_MOTION_NONE )
modifier_skill_hero_xueji = modifier_skill_hero_xueji or {}

--[[Author: 西索酱
    Date: 30.09.2015.
    Grants magical resistance and attackspeed and increases model size per modifier stack
    TODO: Particles and status effects need to be implemented correctly
    NOTE: Model size increase is probably inaccurate and also awfully jumpy
]]--

-- -- function modifier_skill_hero_xueji:GetAttributes()
-- --     return MODIFIER_ATTRIBUTE_PERMANENT
-- -- end

--As described: Could not get the particles to work ...

function modifier_skill_hero_xueji:GetStatusEffectName()
    return "particles/units/heroes/hero_huskar/huskar_berserker_blood_hero_effect.vpcf"
end

function modifier_skill_hero_xueji:GetStatusEffectPriority()
    return 16
end

function modifier_skill_hero_xueji:OnCreated()
    -- Variables
    local caster  = self:GetCaster()
    local ability = self:GetAbility()
    
    self.attack_time =  ability:GetLevelSpecialValueFor( "attack_time_per_stack" ,0)
    self.vamp_bonus  =  ability:GetLevelSpecialValueFor( "vamp_bonus_per_stack" ,0)
    self.reduce_dam  =  ability:GetLevelSpecialValueFor( "reduce_dam_per_stack" ,0)
    self.baseatttime = caster:GetBaseAttackTime()
    self:StartIntervalThink(0.1)

    if IsServer() then
    --     --print("Created")
    --     self:SetStackCount( 1 )
    self:GetParent():CalculateStatBonus()
    end
end

function modifier_skill_hero_xueji:OnIntervalThink()
        -- Variables
        local caster        = self:GetParent()
        local ability       = self:GetAbility()
        local oldStackCount = self:GetStackCount()
        local health_perc   = caster:GetHealthPercent()
        local newStackCount = 1

        self:SetStackCount( 100-health_perc )
        -- self:ForceRefresh()

        if IsServer() then
            caster:CalculateStatBonus()
        end
end

function modifier_skill_hero_xueji:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
        -- MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }

    return funcs
end

function modifier_skill_hero_xueji:GetModifierBaseAttackTimeConstant( params )
    local ability = self:GetAbility()
    local speed   = self.baseatttime or 0
    return speed - self:GetStackCount() * ability:GetLevel() *self.attack_time
end

-- function modifier_skill_hero_xueji:GetModifierLifestealRegenAmplify_Percentage ( params )
--     local ability = self:GetAbility()

--     return self:GetStackCount() * ability:GetLevel() * self.vamp_bonus
-- end

function modifier_skill_hero_xueji:GetModifierIncomingDamage_Percentage ( params )
    local ability = self:GetAbility()
    local change  = self:GetStackCount() * ability:GetLevel() * self.reduce_dam
    return - change 
end

function modifier_skill_hero_xueji:OnAttackLanded ( data )
    
    if not IsServer() then return end
        local parent  = self:GetParent()
        local ability = self:GetAbility()

        local attacker = data.attacker
        local target   = data.target

        if parent == attacker then
        
            local damage = data.damage
            local change = self:GetStackCount() * ability:GetLevel() * self.vamp_bonus / 100
            parent:Heal( change * damage, parent)
            
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), change * damage, nil)
        end
end