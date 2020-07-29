item_queue_fengshizhen = item_queue_fengshizhen or class(item_class)

function item_queue_fengshizhen:needwaveup()
    
    local v = self:GetCaster()  
    if  v:GetName() ~= "npc_dota_hero_phoenix" then
        v:SetModifierStackCount( self:GetIntrinsicModifierName(), caster ,
        v:GetAttackDamage() * self:GetSpecialValueFor("p1")/-100  )
    end
end

-- function item_queue_fengshizhen:GetIntrinsicModifierName()
-- 	return "modifier_item_queue_fengshizhen"
-- end
------------------------------------------------------------------
LinkLuaModifier( "modifier_item_queue_fengshizhen","items/5/fengshizhen", LUA_MODIFIER_MOTION_NONE )
modifier_item_queue_fengshizhen = modifier_item_queue_fengshizhen or {}


function modifier_item_queue_fengshizhen:GetTexture ()
    return "queue/锋矢"
end

function modifier_item_queue_fengshizhen:DeclareFunctions()	
    return 
    { 
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    } 
end

function modifier_item_queue_fengshizhen:GetModifierPreAttack_BonusDamage( params )
    return -self:GetStackCount() 
end