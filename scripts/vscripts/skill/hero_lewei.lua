LinkLuaModifier("modifier_skill_hero_lewei",'skill/hero_lewei.lua',0)

skill_hero_lewei=class({})

function skill_hero_lewei:GetIntrinsicModifierName()
	return "modifier_skill_hero_lewei"
end


modifier_skill_hero_lewei=class({})  

function modifier_skill_hero_lewei:DeclareFunctions()    
    return 
    {
    MODIFIER_EVENT_ON_ATTACK_LANDED
}
end 

function modifier_skill_hero_lewei:OnAttackLanded(data)
    
    if not IsServer() then return end
        local parent  = self:GetParent()
        local ability = self:GetAbility()

        local attacker = data.attacker
        local target   = data.target

        local lifesteal_pct = ability:GetSpecialValueFor("lifesteal_pct") / 100
        if parent == attacker then
        
            local damage = data.damage
            parent:Heal( lifesteal_pct * damage, parent)
            
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), lifesteal_pct * damage, nil)
        end

end