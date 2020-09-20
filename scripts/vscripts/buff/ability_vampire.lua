
modifier_abi_vam = modifier_abi_vam or class({
    IsHidden=false,
    IsPurgable=false,
    RemoveOnDeath=true,
    GetAttributes=MODIFIER_ATTRIBUTE_MULTIPLE,
    DeclareFunctions=function() return { MODIFIER_EVENT_ON_TAKEDAMAGE } end,
    OnCreated=function (self, kv)
        if IsServer() then
            if not self:GetAbility() then self:Destroy() end
            self.count =kv.count /100
        end
    end,
    OnTakeDamage = function ( self,keys )
        if keys.attacker ~= self:GetParent() or keys.unit:IsBuilding() or keys.unit:IsOther() then	return end
            -- Spell lifesteal handler
        if self:GetParent():FindAllModifiersByName(self:GetName())[1] == self 
        and keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL 
        and keys.inflictor 
        and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
            -- Particle effect
            self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
            ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)

            -- Fire sound
            self:GetParent():EmitSound("Hero_Zuus.StaticField")

            -- "However, when attacking illusions, the heal is not affected by the illusion's changed incoming damage values."
            -- This is EXTREMELY rough because I am not aware of any functions that can explicitly give you the incoming/outgoing damage of an illusion, or to give you the "displayed" damage when you're hitting illusions, which show numbers as if you were hitting a non-illusion.
            if keys.unit:IsIllusion() then
                if keys.damage_type == DAMAGE_TYPE_PHYSICAL and keys.unit.GetPhysicalArmorValue and GetReductionFromArmor then
                    keys.damage = keys.original_damage * (1 - GetReductionFromArmor(keys.unit:GetPhysicalArmorValue(false)))
                elseif keys.damage_type == DAMAGE_TYPE_MAGICAL and keys.unit.GetMagicalArmorValue then
                    keys.damage = keys.original_damage * (1 - GetReductionFromArmor(keys.unit:GetMagicalArmorValue()))
                elseif keys.damage_type == DAMAGE_TYPE_PURE then
                    keys.damage = keys.original_damage
                end
            end
            local backheal =math.max(keys.damage, 0) * self:GetAbility():GetSpecialValueFor("abi_vam") * self.count
            keys.attacker:Heal(backheal, self:GetParent())
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), backheal, nil)
        end
        
    end
})