LinkLuaModifier( "modifier_skill_hero_wuqian", "skill/hero_wuqian", 0 )
LinkLuaModifier( "modifier_fthj", "skill/hero_wuqian", 0 )


skill_hero_wuqian = class({})

-- function skill_hero_wuqian:GetIntrinsicModifierName()
-- 	return "modifier_skill_hero_wuqian"
-- end

function skill_hero_wuqian:needwaveup()
    local caster = self:GetCaster()
    local ability = self
    caster:AddNewModifier(caster, ability, "modifier_skill_hero_wuqian", {})
end


modifier_skill_hero_wuqian = class({})
modifier_fthj = class({})

function modifier_skill_hero_wuqian:IsHidden()
    return true
end

function modifier_skill_hero_wuqian:DeclareFunctions()
    if IsServer() then
        local ability = self:GetAbility()
        local parent  = self:GetParent()

        if parent:GetName() == "npc_dota_hero_riki" then
            if not parent:HasItemInInventory("item_weapon_008" ) then 
                parent:AddNewModifier(parent, ability, "modifier_fthj", {})
            end
            local wushuang = parent:AddAbility("skill_hero_wushuang")
            Timer(0.01,function()
                wushuang:SetLevel(10)
            end)
            parent:RemoveModifierByName("modifier_skill_hero_wuqian")
            -- parent:RemoveAbility("skill_hero_wuqian")
        end
    end
end 

function modifier_fthj:DeclareFunctions()
    return { 
        MODIFIER_EVENT_ON_ATTACK_LANDED 
    }  
end

function modifier_fthj:OnAttackLanded(keys)
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


function modifier_fthj:IsHidden()
    return true
end
