item_weapon_008 = item_weapon_008 or class(item_class)
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_weapon_008_owner","items/0/008", 0 )
LinkLuaModifier( "modifier_item_weapon_008_hero","items/0/008", 0 )
LinkLuaModifier( "modifier_item_weapon_008_unit","items/0/008", 0 )
modifier_item_weapon_008_owner = modifier_item_weapon_008_owner or {}--给主公（信使）的效果
modifier_item_weapon_008_hero = modifier_item_weapon_008_hero or {}--给武将的效果
modifier_item_weapon_008_unit = class(modifier_item_weapon_008_hero) or class({})--给民兵的效果


function modifier_item_weapon_008_hero:DeclareFunctions()
    return { 
        MODIFIER_EVENT_ON_ATTACK_LANDED 
    }  
end

function modifier_item_weapon_008_hero:OnAttackLanded(keys)
    if IsServer() then
        
        local target  = keys.target
        local ability = self:GetAbility()
        local owner  = self:GetParent()
        local cleave  = ability:GetSpecialValueFor( "p1" )
        local radius  = 300
        if keys.attacker == owner and ( not owner:IsIllusion() ) then 
            if owner:IsRangedAttacker()then
                return 
            end
            
            if target ~= nil and target:GetTeamNumber() ~= owner:GetTeamNumber() then
                local cleaveDamage =  cleave *keys.damage 
                
                DoCleaveAttack( owner, target, ability, cleaveDamage /100 , radius, radius, radius, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf")
            end
        end
    end        
end


function modifier_item_weapon_008_hero:IsHidden()
    return true
end