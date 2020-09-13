

LinkLuaModifier("modifier_skill_hero_feihuo_unstun",'skill/hero_liegong.lua',0)
LinkLuaModifier("modifier_skill_hero_liegong",'skill/hero_liegong.lua',0)
LinkLuaModifier("modifier_skill_hero_baoji",'skill/hero_liegong.lua',0)


skill_hero_liegong=class({})  

function skill_hero_liegong:GetIntrinsicModifierName()  
    return "modifier_skill_hero_liegong"
end

modifier_skill_hero_liegong = {}

function modifier_skill_hero_liegong:IsHidden()
    return true
end

function modifier_skill_hero_liegong:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START
    }
end

function modifier_skill_hero_liegong:OnAttackStart(keys)
    local ability=self:GetAbility()
    local caster=self:GetCaster()
    local chance=33
    local owner  = caster:GetOwner() or {ship={}}

    if keys.attacker~=caster  or not IsServer()  then return   end

    if  owner.ship['wuhu'] then
        chance = chance * 2
    end    
 
    if RollPercentage(chance) then
    caster:AddNewModifier(caster, ability , 'modifier_skill_hero_baoji', {})  -- 添加修饰器的目标：add（施法着，技能，修饰器名称，持续时间）
    end
    
    if owner.ship['feihuo'] then 

        local damage_type  = ability:GetAbilityDamageType()
        local target_team  = ability:GetAbilityTargetTeam()
        local target_types = ability:GetAbilityTargetType()
        local target_flags = ability:GetAbilityTargetFlags()
         
        local list = caster.juji_amountlist
        if list and #list ~= 0 then       
            local rollenemyint = RandomInt(1, #list)  --随机一个数 在1到地方数量之间  
            local rollenmey = list[rollenemyint]

            local  damage_table = {
            attacker     = caster,
            victim       = rollenmey,
            damage_type  = DAMAGE_TYPE_MAGICAL,
            damage       = 128*ability:GetLevel()
            }
            ApplyDamage(damage_table)
            rollenmey:AddNewModifier(caster, ability , 'modifier_skill_hero_feihuo_unstun', {duration=0.5}) 
     
        end
    end
    
end


modifier_skill_hero_baoji=class({})

function modifier_skill_hero_baoji:IsHidden()
    return true
end

function modifier_skill_hero_baoji:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_skill_hero_baoji:GetModifierPreAttack_CriticalStrike()
    local caster=self:GetCaster()
    local ability=self:GetAbility()
    local level=ability:GetLevel()
    local owner  = caster:GetOwner() or {ship={}}

    if owner.ship['wuhu']  then 
        return  200+level*15
    else 
        return  200+level*10
    end
end

function modifier_skill_hero_baoji:OnAttackLanded()
    local ability=self:GetAbility()
    local caster=self:GetCaster()
caster:RemoveModifierByName('modifier_skill_hero_baoji')
end



modifier_skill_hero_feihuo_unstun=class({})  ---眩晕buff

function modifier_skill_hero_feihuo_unstun:IsHidden()
    return true
end

function modifier_skill_hero_feihuo_unstun:IsDebuff()
	return  true
end

function modifier_skill_hero_feihuo_unstun:IsStunDebuff()
	return  true
end
function modifier_skill_hero_feihuo_unstun:CheckState()
    local state = {
    [MODIFIER_STATE_STUNNED]=true,
}      return state
end