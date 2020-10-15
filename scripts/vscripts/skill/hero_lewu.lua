LinkLuaModifier("modifier_skill_hero_lewu",'skill/hero_lewu.lua',0)

skill_hero_lewu=class({})

function skill_hero_lewu:GetIntrinsicModifierName()  --声明技能实践  技能释放
    return "modifier_skill_hero_lewu"
end

modifier_skill_hero_lewu=class({})  

function modifier_skill_hero_lewu:DeclareFunctions()
    return 
    {
    MODIFIER_EVENT_ON_ATTACK_LANDED
}
end 

function modifier_skill_hero_lewu:OnAttackLanded(keys)   

    local  parent = self:GetParent()  
    local  caster = self:GetCaster()
    local  attacker  = keys.attacker
	local  target = keys.target  
    local ability = self:GetAbility()
    local damage  = target:GetHealth() *ability:GetSpecialValueFor("damage" ) /100
    self.hp_pct = ability:GetSpecialValueFor("hp_pct" ) /100

    local damage_type  =ability:GetAbilityDamageType()
    local target_types =ability:GetAbilityTargetType()
    local target_flags =ability:GetAbilityTargetFlags()  

    if keys.attacker == self:GetParent() and not self:GetParent():IsIllusion() then

        local  damage_table = {
            attacker     = caster,
            victim       = target,
            damage_type  = damage_type,
            damage       = damage, 
            damage_flags = DOTA_DAMAGE_FLAG_NONE
        }
        ApplyDamage(damage_table)

        if (target:GetHealth()/target:GetMaxHealth() <= self.hp_pct ) then

            local weapon_008 = flase 
            if target:HasItemInInventory('item_weapon_008') then
                weapon_008 = true
            end 

            target:RemoveItem(target:GetItemInSlot(0))
            target:RemoveItem(target:GetItemInSlot(1))
            target:RemoveItem(target:GetItemInSlot(2))
            target:RemoveItem(target:GetItemInSlot(3))
            target:RemoveItem(target:GetItemInSlot(4))

            if weapon_008 then 
                target:AddItemByName('item_weapon_008') 
            end
        end 

        if target:IsBoss() then 
            Clamp((target:GetHealth()*0.08),0,(100*ability:GetLevel()))
        end
    end
end

function modifier_skill_hero_lewu:IsHidden()
    return true
end