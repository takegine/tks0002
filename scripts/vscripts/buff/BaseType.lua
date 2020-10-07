modifier_baseType = modifier_baseType or class({
    GetTexture = function(self)
        local  name = self:GetName()
        local  text = "basetype/type"..string.sub(name,16)
        return text
    end,

    RemoveOnDeath = function()
        return false
    end
})

modifier_attack_none = class(modifier_baseType)
modifier_defend_none = class(modifier_baseType)
--------------------------------------------------------------------------------

modifier_attack_tree = class(modifier_baseType)
modifier_defend_tree = class(modifier_baseType)
--------------------------------------------------------------------------------

modifier_attack_fire = class(modifier_baseType)
modifier_defend_fire = class(modifier_baseType)
--------------------------------------------------------------------------------

modifier_attack_electrical = class(modifier_baseType)
modifier_defend_electrical = class(modifier_baseType)
--------------------------------------------------------------------------------

modifier_attack_water = class(modifier_baseType)
modifier_defend_water = class(modifier_baseType)
--------------------------------------------------------------------------------

modifier_attack_land = class(modifier_baseType)
modifier_defend_land = class(modifier_baseType)
--------------------------------------------------------------------------------

modifier_attack_god = class(modifier_baseType)
modifier_defend_god = class(modifier_baseType)
--------------------------------------------------------------------------------

modifier_defend_big = modifier_defend_big or class({
    IsHidden      = function(self) return true  end,
    IsPurgable    = function(self) return false end,
    IsDebuff      = function(self) return false end,
    IsBuff        = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    GetAttributes = function(  ) return MODIFIER_ATTRIBUTE_MULTIPLE end
})


function modifier_defend_big:OnCreated( params )
    if not IsServer() then
        return
    end

    self.none      = params.none or 0
    self.god       = params.god or 0
    self.tree      = params.tree or 0
    self.fire      = params.fire or 0
    self.water     = params.water or 0
    self.land      = params.land or 0
    self.electrical= params.electrical or 0

end
--------------------------------------------------------------------------------
modifier_shield = class({
    IsHidden      = function(self) return true  end,
    IsPurgable    = function(self) return false end,
    IsDebuff      = function(self) return false end,
    IsBuff        = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    GetAttributes = function(  ) return MODIFIER_ATTRIBUTE_MULTIPLE end
})

function modifier_shield:OnCreated( params )
    if not IsServer() then
        return
    end
    --self.shield_type  = params.shield_type
    self.shield_value = params.shield_value
    self.none         = params.none
    self.god          = params.god
    self.tree         = params.tree
    self.fire         = params.fire
    self.water        = params.water
    self.land         = params.land
    self.electrical   = params.electrical
end
--------------------------------------------------------------------------------
