modifier_defend_big = modifier_defend_big or class({
    IsHidden      = on,
    IsPurgable    = off,
    IsDebuff      = off,
    IsBuff        = off,
    RemoveOnDeath = off,
    GetAttributes = function(  ) return MODIFIER_ATTRIBUTE_MULTIPLE end,
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


modifier_custom_shield = class(modifier_defend_big)

function modifier_custom_shield:OnCreated( params )
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