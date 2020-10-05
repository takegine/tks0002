

item_class = {}

function item_class:lvlup()
    -- print( self:GetName())
    -- local parent = self:GetParent()
    local level  = Clamp(1 + self:GetCurrentCharges(), 0 ,10)
    -- print("lvlup", self:GetLevel())
    self:SetLevel( level )

end

function item_class:OnUpgrade()
    -- local parent = self:GetParent()
    local level  = self:GetLevel()
    
    self:SetCurrentCharges(level)

    -- print("OnUpgrade", self:GetLevel())
    -- if  string.find(self:GetAbilityName(), 'queue' ) then
    --         parent.lvl_queue = level
    -- end
end

function item_class:OnEquip()
    
    local parent = self:GetParent()
    local level  = self:GetLevel()
    
    print("OnEquip", self:GetLevel())
end


function item_class:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_PASSIVE
end


function item_class:GetIntrinsicModifierName()
    local parent = self:GetParent()
    local name = "modifier_"..self:GetName()
    if parent:GetName() == "npc_dota_hero_phoenix" then
        return name.."_owner"
    elseif parent:IsHero() then
        return name.."_hero"
    else
        return name.."_unit"
    end
end


on = function ( self ) return true end
off= function ( self ) return false end