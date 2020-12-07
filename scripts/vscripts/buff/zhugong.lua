modifier_player_zhugong_aura = modifier_player_zhugong_aura or {
    IsDebuff = off,
    IsHidden = on,
    IsPurgable = off,
    RemoveOnDeath = on,
    IsAura = on,
    IsAuraActiveOnDeath = off,
    GetAuraRadius  = function () return 470 end,
    GetModifierAura= function () return "modifier_player_zhugong" end,
    GetAuraSearchTeam   = function () return DOTA_UNIT_TARGET_TEAM_ENEMY end,
    GetAuraSearchType   = function () return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end,
    CheckState = function (self)
        return {
            [MODIFIER_STATE_UNSELECTABLE]	=true,	--14不可选择
            [MODIFIER_STATE_NO_HEALTH_BAR]	=true,	--22没有生命条
            [MODIFIER_STATE_NO_UNIT_COLLISION]	=true,	--24没有碰撞体积
            [MODIFIER_STATE_ATTACK_IMMUNE]	=true,	--02攻击免疫
            [MODIFIER_STATE_MAGIC_IMMUNE]	=true,	--09魔法免疫
            [MODIFIER_STATE_INVULNERABLE]	=true,	--08无敌

        }
    end,
}

modifier_player_zhugong = modifier_player_zhugong or {
    OnCreated = function (self)
        if not IsServer() then return end
        local caster = self:GetCaster():XinShi()
        local team   = caster:GetTeamNumber()
        local parent = self:GetParent()
        local weapon = not parent:IsOpposingSelf() and parent:XinShi():GetItemInSlot(0)
        local defend = caster:GetItemInSlot(1)
        local damage = 2

        if _G.StageTable.round >14 then 
            damage = 2^( math.modf(_G.StageTable.round/5) - 2)
        end

        if weapon and weapon:GetName() == "item_weapon_011" then
            damage = damage+ weapon:GetSpecialValueFor('p2')
        end

        if defend then
            if weapon and weapon:GetName() == "item_weapon_001" then
            else
                if defend:GetName() == "item_defend_030" then
                    if ( weapon and weapon:GetName() == "item_weapon_010" )
                    or parent.attack_type == "fire" 
                    then
                        damage = damage * 2
                    elseif parent.attack_type ~= "electrical" then
                        damage = 0
                    end
                elseif defend:GetName() == "item_defend_028" then
                    if weapon and weapon:GetName() == "item_weapon_004" then
                    elseif RollPercentage(defend:GetSpecialValueFor('p2')) then
                        EmitSoundOnClient("DOTA_Item.BladeMail.Damage", caster)
                        damage = 0
                    end
                elseif defend:GetName() == "item_defend_029" and RollPercentage(defend:GetSpecialValueFor('p1')) then
                        damage = 1
                elseif defend:GetName() == "item_defend_027" and parent:IsRangedAttacker() then
                    damage = damage / 2
                end
            end
        end

        if not parent:IsRealHero() then
            damage = math.ceil( damage / 2 )
        end

        parent:remove(false)

        if damage == 0 then
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_EVADE, caster, damage, nil)
            return
        end

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, caster, damage, nil)
        caster:SetHealth( Clamp(caster:GetHealth()-damage ,0,caster:GetMaxHealth()))

        if caster:GetHealth()<=0 and PLAYER_LIST[team-5] then
            table.foreach(UNITS_LIST.defend,function (_,v)
                if not v:IsNull()
                and not v:IsOpposingTeam(team)
                and v.bench then
                    UTIL_Remove( v )
                end
            end)

            -- GameRules:MakeTeamLose( team )
            PLAYER_LIST[team-5] = nil
            
            local cur ={}
            for k in pairs(PLAYER_LIST) do
                tabke.insert(cur,k)
            end
            if #cur == 1 then
                GameRules:SetGameWinner(cur[1])
            elseif #cur <=4 then
                for i in ipairs(cur) do
                    PLAYER_LIST[i]=i
                end
            end
        end
    end
}