skill_player_queue = skill_player_queue or {}
--------------------------------------------------------------------------------

function skill_player_queue:OnSpellStart(  )
    local caster = self:GetCaster()
    local queue  = caster:GetItemInSlot(5)
    local level  = Clamp( self:GetLevel() + 1, 1, 10)
    local cost   = self:GetSpecialValueFor("basecost")
    local player = caster:GetPlayerOwnerID()

    if self:GetLevel() >= level then 
        return
    elseif caster:GetGold() < cost then 
        return
    elseif not queue then 
        return
    else
        queue:lvlup(level)
        self:SetLevel(level)
        caster:SpendGold( cost, DOTA_ModifyGold_PurchaseConsumable)
        CustomNetTables:OverData( "player_info", player, "quelvl" , level )
    end
end



skill_player_sell = skill_player_sell or {}
--------------------------------------------------------------------------------

function skill_player_sell:OnSpellStart()
    local target   = self:GetCursorTarget()
    local caster   = self:GetCaster()
    local plid     = caster:GetPlayerOwnerID()

    target:ForceKill(true)
    
end

--------------------------------------------------------------------------------
skill_player_lvlup = skill_player_lvlup or {
    CastFilterResult = function (self) 
        if not IsServer() then return end
        
        local stage =CustomNetTables:GetStage( "stage" )
        if stage ~= "GAME_STAT_PLAN" then
            self.result = stage
            return UF_FAIL_CUSTOM
        end

        local caster   = self:GetCaster()
        local hero     = caster:XinShi()
        local plid     = hero:GetPlayerOwnerID()
        local basecost = self:GetLevelSpecialValueFor("basecost", self:GetLevel() )
        local vipcost  = self:GetLevelSpecialValueFor("vipcost", self:GetLevel() )
        self.findcost  = VipList[caster:GetName()] and vipcost or basecost

        if caster:GetLevel()==10 then
            self.result = "满级"
            return UF_FAIL_CUSTOM
        end

        if hero:GetGold()<self.findcost then
            self.result = "poor_gold"
            return UF_FAIL_CUSTOM
        end
        
        return 0
    end,
    
    GetCustomCastError = function (self) 
        return self.result
    end,

    OnSpellStart = function (self)
        
        local caster   = self:GetCaster()
        local hero     = caster:GetOwner()
        local plid     = hero:GetPlayerOwnerID()

        if PlayerResource:Pay( plid, self.findcost ) then 
            caster:CheckLevel()
        end
    end
}
