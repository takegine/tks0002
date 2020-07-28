

abi_queue = {}

function abi_queue:lvlup()
    print( self:GetName())
    local parent = self:GetParent()
    local level  = Clamp(1 + self:GetCurrentCharges(), 0 ,10)
    print("lvlup", self:GetLevel())
    self:SetLevel( level )

end

function abi_queue:OnUpgrade()
    local parent = self:GetParent()
    local level  = self:GetLevel()
    
    self:SetCurrentCharges(level)

    print("OnUpgrade", self:GetLevel())
    if  string.find(self:GetAbilityName(), 'queue' ) then
            parent.lvl_queue = level
    end
end

function abi_queue:OnEquip()
    
    local parent = self:GetParent()
    local level  = self:GetLevel()
    
    print("OnEquip", self:GetLevel())
end