
require("core/constants")

item_class = {
    lvlup = function (self)
        -- print( self:GetName())
        -- local parent = self:GetParent()
        local level  = Clamp(1 + self:GetCurrentCharges(), 0 ,10)
        -- print("lvlup", self:GetLevel())
        self:SetLevel( level )

    end,
    OnUpgrade = function (self)
        -- local parent = self:GetParent()
        local level  = self:GetLevel()
        
        self:SetCurrentCharges(level)

        -- print("OnUpgrade", self:GetLevel())
        -- if  string.find(self:GetAbilityName(), 'queue' ) then
        --         parent.lvl_queue = level
        -- end
    end,

    OnEquip = function (self)
        
        local parent = self:GetParent()
        local level  = self:GetLevel()
        
        print("OnEquip", self:GetLevel())
    end,


    GetBehavior = function (self)
        return DOTA_ABILITY_BEHAVIOR_PASSIVE
    end,


    GetIntrinsicModifierName = function (self)
        local parent = self:GetParent()
        local name = "modifier_"..self:GetName()
        if parent:GetName() == "npc_dota_hero_phoenix" then
            return name.."_owner"
        elseif parent:IsHero() then
            return name.."_hero"
        else
            return name.."_unit"
        end
    end,
}


on = function ( self ) return true end
off= function ( self ) return false end