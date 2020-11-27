
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
}


on = function ( self ) return true end
off= function ( self ) return false end

function IsNull(entity)
    return entity ==nil or entity:IsNull()
end

function CDOTA_Buff:GetAbilitySpecialValueFor( string )
    if type(string) ~="string" then
        return error("param #2 should be string")
    end

    local ability=self:GetAbility()
    local value = IsNull(ability) and 0 or ability:GetSpecialValueFor(string)
    return  value
end