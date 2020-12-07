
modifier_player_lock=modifier_player_lock or {
    IsHidden = on,
    DeclareFunctions = function (self ) return { MODIFIER_EVENT_ON_ATTACK_FAIL,MODIFIER_EVENT_ON_ATTACKED } end,
    OnAttackFail = function ( self, data)
        if not IsServer() or self:GetParent()~=data.attacker then return end
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_EVADE, data.target, 0, nil)
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_MISS, data.attacker, 0, nil)
    end,
    OnAttacked = function (self ,data)
        if not IsServer() or self:GetParent()~=data.attacker then return end
        self.parent = self.parent or self:GetParent()
        if  self.parent == data.attacker then
            self.parent.battleinfo.deal = self.parent
            self.parent.battleinfo.deal_cur = Time()
        elseif   self.parent == data.target then
            self.parent.battleinfo.take = self.parent
            self.parent.battleinfo.take_cur = Time()
        end
    end,
    CheckState = function (self)
        if not IsServer() then return end
        local parent = self:GetParent()
        local stage  = _G.StageTable.stage
        local bench = parent.bench
        local ready = stage == "GAME_STAT_READY"
        local plan  = stage == "GAME_STAT_PLAN"
        local fight = stage == "GAME_STAT_FINGHT"
        return {
            [MODIFIER_STATE_ROOTED]	=ready,	--00缠绕，头上有缠绕进度条
            [MODIFIER_STATE_DISARMED]	=bench and fight,	--01缴械
            [MODIFIER_STATE_ATTACK_IMMUNE]	=bench and fight,	--02攻击免疫
            [MODIFIER_STATE_SILENCED]	=false,	--03沉默，头上有沉默进度条
            [MODIFIER_STATE_MUTED]	=false,	--04锁闭，禁用物品，头上有锁闭进度条
            [MODIFIER_STATE_STUNNED]	=ready,	--05晕眩，头上有晕眩进度条
            [MODIFIER_STATE_HEXED]	=false,	--06妖术，头顶会有妖术进度条
            [MODIFIER_STATE_INVISIBLE]	=false,	--07隐身
            [MODIFIER_STATE_INVULNERABLE]	=false,	--08无敌 --遍历失效
            [MODIFIER_STATE_MAGIC_IMMUNE]	=false,	--09魔法免疫
            [MODIFIER_STATE_PROVIDES_VISION]	=false,	--10提供视野
            [MODIFIER_STATE_NIGHTMARED]	=bench,	--11睡眠，头上会有睡眠进度条
            [MODIFIER_STATE_BLOCK_DISABLED]	=false,	--12禁用格挡
            [MODIFIER_STATE_EVADE_DISABLED]	=false,	--13无法闪避
            [MODIFIER_STATE_UNSELECTABLE]	=false,	--14不可选择
            [MODIFIER_STATE_CANNOT_TARGET_ENEMIES]	=false,	--15禁用单位目标命令
            [MODIFIER_STATE_CANNOT_MISS]	=false,	--16不会丢失，无视闪避
            [MODIFIER_STATE_SPECIALLY_DENIABLE]	=false,	--17可被反补
            [MODIFIER_STATE_FROZEN]	=false,	--18冰冻，动作会暂停
            [MODIFIER_STATE_COMMAND_RESTRICTED]	=ready or bench and fight,	--19无法执行命令
            [MODIFIER_STATE_NOT_ON_MINIMAP]	= ready or bench,	--20没有小地图图标
            [MODIFIER_STATE_LOW_ATTACK_PRIORITY]	=false,	--21低攻击优先级
            [MODIFIER_STATE_NO_HEALTH_BAR]	=ready,	--22没有生命条
            [MODIFIER_STATE_FLYING]	=false,	--23飞行
            [MODIFIER_STATE_NO_UNIT_COLLISION]	=false,	--24没有碰撞体积
            [MODIFIER_STATE_NO_TEAM_MOVE_TO]	=false,	--25No Description Set
            [MODIFIER_STATE_NO_TEAM_SELECT]	=false,	--26No Description Set
            [MODIFIER_STATE_PASSIVES_DISABLED]	=ready or bench,	--27破坏，禁用被动，头上有破坏进度条
            [MODIFIER_STATE_DOMINATED]	=false,	--28支配，可用于过滤是否是支配单位
            [MODIFIER_STATE_BLIND]	=false,	--29致盲，完全失去视野
            [MODIFIER_STATE_OUT_OF_GAME]	=false,	--30离开游戏
            [MODIFIER_STATE_FAKE_ALLY]	=false,	--31No Description Set
            [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY]	=false,	--32贴地飞行
            [MODIFIER_STATE_TRUESIGHT_IMMUNE]	=false,	--33真视免疫
            [MODIFIER_STATE_UNTARGETABLE]	=false,	--34无法作为目标
            [MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS]	=ready or fight or bench,	--35禁用移动与攻击指令
            [MODIFIER_STATE_ALLOW_PATHING_TROUGH_TREES]	=false,	--36允许在树木中通行
            [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES]	=ready,	--37对敌人没有小地图图标
            [MODIFIER_STATE_UNSLOWABLE]	=false,	--38无法减速
            [MODIFIER_STATE_TETHERED]	=false,	--39束缚，头上有束缚进度条
            [MODIFIER_STATE_IGNORING_STOP_ORDERS]	=fight,	--40禁用停止指令
            [MODIFIER_STATE_FEARED]	=false,	--41No Description Set
            [MODIFIER_STATE_TAUNTED]	=false,	--42No Description Set
            [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED]	=false,	--43No Description Set
            [MODIFIER_STATE_LAST]	=false,	--44No Description Set
            -- [MODIFIER_STATE_SOFT_DISARMED]  =bench,
        }
    end,
}

--------------------------------------------------------------------------------