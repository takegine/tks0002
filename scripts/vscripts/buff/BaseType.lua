modifier_attack_none  = class({})
function modifier_attack_none:GetTexture()    return "attack_arcane" end
function modifier_attack_none:RemoveOnDeath() return false end
modifier_defend_none = class({})
function modifier_defend_none:GetTexture() return "defend_medium" end
function modifier_defend_none:RemoveOnDeath() return false end
--------------------------------------------------------------------------------

modifier_attack_tree  = class({})
function modifier_attack_tree:GetTexture()    return "attack_arcane" end
function modifier_attack_tree:RemoveOnDeath() return false end
modifier_defend_tree = class({})
function modifier_defend_tree:GetTexture() return "defend_medium" end
function modifier_defend_tree:RemoveOnDeath() return false end
--------------------------------------------------------------------------------

modifier_attack_fire  = class({})
function modifier_attack_fire:GetTexture() return "attack_normal" end
function modifier_attack_fire:RemoveOnDeath() return false end
modifier_defend_fire = class({})
function modifier_defend_fire:GetTexture() return "defend_medium" end
function modifier_defend_fire:RemoveOnDeath() return false end
--------------------------------------------------------------------------------

modifier_attack_electrical  = class({})
function modifier_attack_electrical:GetTexture()    return "attack_arcane" end
function modifier_attack_electrical:RemoveOnDeath() return false end
modifier_defend_electrical = class({})
function modifier_defend_electrical:GetTexture() return "defend_medium" end
function modifier_defend_electrical:RemoveOnDeath() return false end
--------------------------------------------------------------------------------

modifier_attack_water  = class({})
function modifier_attack_water:GetTexture()    return "attack_arcane" end
function modifier_attack_water:RemoveOnDeath() return false end
modifier_defend_water = class({})
function modifier_defend_water:GetTexture() return "defend_light" end
function modifier_defend_water:RemoveOnDeath() return false end
--------------------------------------------------------------------------------

modifier_attack_land  = class({})
function modifier_attack_land:GetTexture()    return "attack_arcane" end
function modifier_attack_land:RemoveOnDeath() return false end
modifier_defend_land = class({})
function modifier_defend_land:GetTexture() return "defend_medium" end
function modifier_defend_land:RemoveOnDeath() return false end
--------------------------------------------------------------------------------

modifier_attack_god  = class({})
function modifier_attack_god:GetTexture()    return "attack_arcane" end
function modifier_attack_god:RemoveOnDeath() return false end
modifier_defend_god = class({})
function modifier_defend_god:GetTexture() return "defend_medium" end
function modifier_defend_god:RemoveOnDeath() return false end
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
