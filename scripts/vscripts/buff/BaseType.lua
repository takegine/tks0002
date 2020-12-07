modifier_baseType = modifier_baseType or class({
    RemoveOnDeath = off,
    GetTexture = function(self)
        local  name = self:GetName()
        local  text = "basetype/type"..string.sub(name,16)
        return text
    end,
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