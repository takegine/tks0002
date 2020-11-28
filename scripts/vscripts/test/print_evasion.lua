print_evasion =print_evasion or class({

DeclareFunctions = function ()
    return
    {	
        MODIFIER_EVENT_ON_ATTACK_FAIL
    }
end,

OnAttackFail = function ( self, keys)
    if not IsServer() then
        return
    end
    --print_r(keys)
    local attacker = keys.attacker
    local target   = keys.target
    local messageT = "<font color='#DC143C'>"..(self.namelist[target:GetUnitName()] or target:GetUnitName()).."</font> 成功的闪避了 <font color='#32CD32'>"..(self.namelist[attacker:GetUnitName()] or "未知").."</font> 的伤害"
        
    GameRules:SendCustomMessage( messageT, -1, 1)

end
})