

LinkLuaModifier( "modifier_skill_hero_xiaobawang", "skill/hero_xiaobawang", 0 )

skill_hero_xiaobawang = class({})
modifier_skill_hero_xiaobawang = class({})

function skill_hero_xiaobawang:GetIntrinsicModifierName()
	return "modifier_skill_hero_xiaobawang"
end

function modifier_skill_hero_xiaobawang:DeclareFunctions()
    local ability = self:GetAbility()
    local parent  = self:GetParent()
  
        local sunjun = parent:AddAbility("skill_hero_sunjun")
        local sunjiang  = parent:AddAbility("skill_hero_sunjiang")
        local sunchuan = parent:AddAbility("skill_hero_sunchuan")
        local lvl = ability:GetLevel()
        sunjun:SetLevel(lvl)
        sunjiang:SetLevel(lvl)
        sunchuan:SetLevel(lvl)
        parent:RemoveModifierByName("modifier_skill_hero_xiaobawang")
        parent:RemoveAbility("skill_hero_xiaobawang")
end 

function modifier_skill_hero_xiaobawang:IsHidden()
    return true
end




-- -------------------------------------------------------------------------------孙君

-- LinkLuaModifier("modifier_skill_hero_sunjun",'skill/hero_sunjun.lua',0)

-- skill_hero_sunjun=class({})

-- function skill_hero_sunjun:needwaveup()

--     local ability=self
-- 	local caster=self:GetCaster()
--     local owner =caster:GetOwner() or {ship={}}
--     if owner.ship['junzi'] then
--     caster:AddNewModifier(caster,ability,'modifier_skill_hero_sunjun', {})
--     end
-- end


-- modifier_skill_hero_sunjun=class({})   --减免伤害

-- function modifier_skill_hero_sunjun:DeclareFunctions()
--     return 
--     {
--     MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK_SPECIAL
-- }
-- end 


-- function modifier_skill_hero_sunjun:GetModifierPhysical_ConstantBlockSpecial()
--     local ability=self:GetAbility()
--     return  ability:GetLevel()*130
-- end

-- function modifier_skill_hero_sunjun:IsHidden()
--     return true
-- end

-- ----------------------------------------------------------------------------------孙江

-- LinkLuaModifier("modifier_skill_hero_sunjiang",'skill/hero_sunjiang',0)

-- skill_hero_sunjiang = skill_hero_sunjiang or class({})

-- function skill_hero_sunjiang:needwaveup()
    
--     local caster = self:GetCaster()
--     local owner = caster:GetOwner() or (ship{})
--     if owner.ship['jiangdong'] then
--         caster:AddNewModifier( caster, self, 'modifier_skill_hero_sunjiang',{})
--     end
-- end

-- modifier_skill_hero_sunjiang = modifier_skill_hero_sunjiang or {}

-- function modifier_skill_hero_sunjiang:DeclareFunctions()
--     return { 
--         MODIFIER_EVENT_ON_ATTACK_LANDED 
--     }  
-- end

-- function modifier_skill_hero_sunjiang:OnAttackLanded(keys)
--     if IsServer() then
        
--         local target  = keys.target
--         local ability = self:GetAbility()
--         local parent  = self:GetParent()
--         local cleave  = ability:GetSpecialValueFor( "skill_hero_sunjiang_damage" )
--         local radius  = ability:GetSpecialValueFor( "skill_hero_sunjiang_radius" )
--         if keys.attacker == parent and ( not parent:IsIllusion() ) then 
--             if parent:PassivesDisabled() then
--                 return 
--             end
            
--             if target ~= nil and target:GetTeamNumber() ~= parent:GetTeamNumber() then
--                 local cleaveDamage =  cleave *keys.damage 
                
--                 DoCleaveAttack( parent, target, ability, cleaveDamage /100 , radius, radius, radius, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf")
--             end
--         end
--     end        
-- end


-- function modifier_skill_hero_sunjiang:IsHidden()
--     return true
-- end


-- -----------------------------------------------------------------------------------孙传

-- LinkLuaModifier('modifier_skill_hero_sunchuan', 'skill/hero_sunchuan.lua', 0)


-- skill_hero_sunchuan=class({})

-- function skill_hero_sunchuan:needwaveup()  
--     local caster=self:GetCaster()

--     local owner = caster:GetOwner() or {ship={}}   --判断是否有组合

--     if owner.ship['chuanshi'] then
--       caster:AddNewModifier(caster, self ,'modifier_skill_hero_sunchuan', {})
--     end
-- end

-- modifier_skill_hero_sunchuan=class({})

-- function modifier_skill_hero_sunchuan:DeclareFunctions()
--     return{
--         MODIFIER_EVENT_ON_ATTACK_LANDED
--     }
-- end

-- function modifier_skill_hero_sunchuan:OnAttackLanded(keys)
--     local parent    = self:GetParent()
--     local ability   = self:GetAbility()
--     local target    = keys.target
--     local damage_type  = ability:GetAbilityDamageType()   --这个是技能用的
-- 	local target_team  = ability:GetAbilityTargetTeam()
-- 	local target_types = ability:GetAbilityTargetType()
--     local target_flags = ability:GetAbilityTargetFlags()
--     local damage  = parent:GetHealth() *ability:GetSpecialValueFor("damage" ) /100
--     local pfxname = "particles/units/heroes/hero_phoenix/phoenix_fire_spirits_launch_bird.vpcf"
  
--     --判断是否暴击
--     if keys.attacker == parent   
--     and keys.original_damage/parent:GetAverageTrueAttackDamage(target)>1.05 then 

--         local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, parent, parent, parent:GetTeamNumber() )  --火伤马甲
--         dummy.attack_type  = "fire"
--         dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )

--         local enemy = FindUnitsInRadius(parent:GetTeamNumber(),   --查找自身范围160的敌人
--         target:GetOrigin(), 
--         nil, 
--         160,
--         target_team, 
--         target_types, 
--         target_flags, 
--         0, 
--         true)

--         for key,unit in pairs(enemy) do   --找到敌人输出伤害
--             local  damage_table = {

--                 attacker     = dummy,
--                 victim       = unit,
--                 damage_type  = damage_type,
--                 damage       = damage, --unit:GetHealth()*0.1,
--                 damage_flags = DOTA_DAMAGE_FLAG_NONE
--             }
--                 ApplyDamage(damage_table)
--                 local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
--                 ParticleManager:SetParticleControl(pfx, 0, Vector(160, 160, 160))
--                 ParticleManager:ReleaseParticleIndex(pfx)
--         end
--     end
-- end

-- function modifier_skill_hero_sunchuan:IsHidden()
--     return true
-- end