LinkLuaModifier( "modifier_skill_hero_wuqian", "skill/hero_wuqian", 0 )
LinkLuaModifier( "modifier_item_weapon_008_hero", "skill/hero_wuqian", 0 )


skill_hero_wuqian = class({})

function skill_hero_wuqian:GetIntrinsicModifierName()
	return "modifier_skill_hero_wuqian"
end

modifier_skill_hero_wuqian = class({})

function modifier_skill_hero_wuqian:IsHidden()
    return true
end

function modifier_skill_hero_wuqian:DeclareFunctions()
    if IsServer() then
        local caster=self:GetCaster()
        local ability = self:GetAbility()
        local parent  = self:GetParent()

        if not caster:HasItemInInventory("item_weapon_008" ) then 
            caster:AddNewModifier(caster, ability, "modifier_item_weapon_008_hero", {})
        end
    end
end 

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
        local cleave  = 90
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
