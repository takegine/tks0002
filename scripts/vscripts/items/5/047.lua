item_queue_047 = item_queue_047 or class(item_class)

function item_queue_047:Precache()
    PrecacheResource("particle", "particles/generic_gameplay/generic_lifesteal.vpcf", context)
end

------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_047","items/5/047", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_047 = modifier_item_queue_047 or {}


function modifier_item_queue_047:GetTexture ()
    local ability = self:GetAbility()
    return "items/"..ability:GetAbilityTextureName()
end

function modifier_item_queue_047:DeclareFunctions()
    return  
    {   
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_item_queue_047:OnTooltip()
    local ability= self:GetAbility()
    local p1  = ability:GetSpecialValueFor('p1')
    local p2  = ability:GetSpecialValueFor('p2')
    local parent = self:GetParent()
    local chance = parent:IsRangedAttacker() and p2 or p1
    return  chance
end

function modifier_item_queue_047:OnAttackLanded( keys )
	if IsServer() then
		local parent = self:GetParent()
		local target = keys.target

        if parent ~= keys.attacker
        or target:IsBuilding() 
        or target:IsIllusion() 
        or target:GetTeam() == parent:GetTeam()
        then return 
        end

        local lifesteal_amount = self:OnTooltip()
        local ability = self:GetAbility()
		local damage  = keys.damage
		--local target_armor = 0.06 *target:GetPhysicalArmorValue(false)
		local healre  = damage * lifesteal_amount * 0.01 --* (1 - target_armor/(1+math.abs( target_armor)))

        parent:Heal(healre, parent)

		local lifesteal_particle = "particles/generic_gameplay/generic_lifesteal.vpcf"
		local lifesteal_pfx = ParticleManager:CreateParticle(lifesteal_particle, PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControl(lifesteal_pfx, 0, parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
	end
end