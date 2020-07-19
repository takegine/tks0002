function weixing(keys)
    local ability = keys.ability    --技能魏星
    local caster  = keys.caster     --施法者，这里是魏延
    local target  = keys.target     --目标，这里应该是空值
    
    --给这个技能后置生效，这个needwaveup会在游戏中，所有羁绊添加完成，所有物品添加完成后执行。
    ability.needwaveup = function ( ability)
        local caster   = ability:GetCaster()
        local owner   = caster:GetOwner() or {ship={}}--魏延的持有者，即 玩家操作的信使

        --判断是否拥有对应的羁绊
        if owner.ship['feihuo'] then
            ability:ApplyDataDrivenModifier( caster, caster , "modifier_skill_hero_weixing", nil  )
        end

    end
end