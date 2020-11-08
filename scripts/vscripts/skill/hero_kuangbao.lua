LinkLuaModifier('modifier_skill_hero_kuangbao', 'skill/hero_kuangbao.lua', 0)
LinkLuaModifier('modifier_skill_hero_shenfen1', 'skill/hero_kuangbao.lua', 0)

skill_hero_kuangbao=class({})

function skill_hero_kuangbao:GetIntrinsicModifierName()
	return "modifier_skill_hero_kuangbao"
end

modifier_skill_hero_kuangbao=class({})
modifier_skill_hero_shenfen1=class({})

function modifier_skill_hero_kuangbao:OnCreated()
	self:SetStackCount(0)
	local baolv = 30
    local max_stacks = 15
    self.used = false
end

function modifier_skill_hero_kuangbao:OnRefresh()
	local baolv = 30
	local max_stacks = 15
end

function modifier_skill_hero_kuangbao:DeclareFunctions()
	return  {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}
end

function modifier_skill_hero_kuangbao:OnTakeDamage( keys )
    if IsServer() and self:GetAbility() then
        local parent = self:GetParent()
        local caster = self:GetCaster()
		if keys.attacker == parent and not parent:IsIllusion() and not parent:PassivesDisabled() then
            if self:GetStackCount() < 15 then
				self:IncrementStackCount()
            end
            
            -- local shenfen = FindModifierByNameAndCaster("modifier_skill_hero_shenfen1", parent)
            -- if  self:GetStackCount() == 15  and not self.used then
            --     self.used = true
            --     parent:AddNewModifier(caster, self ,"modifier_skill_hero_shenfen1", {})
            --     parent:FindModifierByName("modifier_skill_hero_shenfen1").used = false
            --     self:ResetStack()
            -- end
		end
	end
end

function modifier_skill_hero_kuangbao:GetModifierPreAttack_CriticalStrike(keys)
    local chance = 30 * self:GetStackCount() 
    local baoshang = (self:GetStackCount()* 30)+100   
    if chance<100 then 
        baoshang = 200
    else   
        chance = 100  
    end
    return RollPercentage(chance) and baoshang or 0
end

-- function modifier_skill_hero_shenfen1:OnCreated()
--     local ability = self
--     local parent  = self:GetParent()
--     local shenfen = parent:AddAbility("skill_hero_shenfen")
--     local lvl = self:GetLevel()
--     shenfen:SetLevel(lvl)
--     parent:RemoveModifierByName("modifier_skill_hero_shenfen1")

-- end 

-- function modifier_skill_hero_kuangbao:ResetStack()
-- 	if not self:GetParent():PassivesDisabled() then
-- 		self:SetStackCount(0)
-- 	end
-- end



-- particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf
