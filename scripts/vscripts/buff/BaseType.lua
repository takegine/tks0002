modifier_baseType = modifier_baseType or class({
    GetTexture = function(self)
        local  name = self:GetName()
        local  text = "basetype/type"..string.sub(name,16)
        return text
    end,

    RemoveOnDeath = function()
        return false
    end
})

modifier_attack_none = class(modifier_baseType)
modifier_defend_none = class(modifier_baseType)
--------------------------------------------------------------------------------

modifier_attack_tree = class(modifier_baseType)
modifier_defend_tree = class(modifier_baseType)
--------------------------------------------------------------------------------

modifier_attack_fire = class(modifier_baseType)
modifier_defend_fire = class(modifier_baseType)
--------------------------------------------------------------------------------

modifier_attack_electrical = class(modifier_baseType)
modifier_defend_electrical = class(modifier_baseType)
--------------------------------------------------------------------------------

modifier_attack_water = class(modifier_baseType)
modifier_defend_water = class(modifier_baseType)
--------------------------------------------------------------------------------

modifier_attack_land = class(modifier_baseType)
modifier_defend_land = class(modifier_baseType)
--------------------------------------------------------------------------------

modifier_attack_god = class(modifier_baseType)
modifier_defend_god = class(modifier_baseType)
--------------------------------------------------------------------------------

modifier_defend_big = modifier_defend_big or class({
    IsHidden      = function(self) return true  end,
    IsPurgable    = function(self) return false end,
    IsDebuff      = function(self) return false end,
    IsBuff        = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    GetAttributes = function(  ) return MODIFIER_ATTRIBUTE_MULTIPLE end
})


function modifier_defend_big:OnCreated( params )
    if not IsServer() then
        return
    end

    self.none      = params.none or 0
    self.god       = params.god or 0
    self.tree      = params.tree or 0
    self.fire      = params.fire or 0
    self.water     = params.water or 0
    self.land      = params.land or 0
    self.electrical= params.electrical or 0

end
--------------------------------------------------------------------------------
modifier_shield = class({
    IsHidden      = function(self) return true  end,
    IsPurgable    = function(self) return false end,
    IsDebuff      = function(self) return false end,
    IsBuff        = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    GetAttributes = function(  ) return MODIFIER_ATTRIBUTE_MULTIPLE end
})

function modifier_shield:OnCreated( params )
    if not IsServer() then
        return
    end
    --self.shield_type  = params.shield_type
    self.shield_value = params.shield_value
    self.none         = params.none
    self.god          = params.god
    self.tree         = params.tree
    self.fire         = params.fire
    self.water        = params.water
    self.land         = params.land
    self.electrical   = params.electrical
end
--------------------------------------------------------------------------------

modifier_player_lock=modifier_player_lock or {
    IsHidden = on,
    CheckState = function (self)
        -- if not IsServer() then return end
        local parent = self:GetParent()
        local stage  = CustomNetTables:GetStage( "stage" )
        local bench = parent.plan and parent.bench
        local ready = stage == "GAME_STAT_READY"
        local fight = parent.plan and stage == "GAME_STAT_FINGHT"
        -- if parent.plan then
        --     print("wwww",bench,ready,fight,parent:GetTeamNumber())
        -- else
        --     print("qqqq",bench,ready,fight,parent:GetTeamNumber(),parent.enemy)
        -- end
        return {
            [MODIFIER_STATE_ROOTED]	=ready or bench,	--00缠绕，头上有缠绕进度条
            [MODIFIER_STATE_DISARMED]	=ready,	--01缴械
            [MODIFIER_STATE_ATTACK_IMMUNE]	=ready or bench,	--02攻击免疫
            [MODIFIER_STATE_SILENCED]	=ready,	--03沉默，头上有沉默进度条
            [MODIFIER_STATE_MUTED]	=ready or bench,	--04锁闭，禁用物品，头上有锁闭进度条
            [MODIFIER_STATE_STUNNED]	=false,	--05晕眩，头上有晕眩进度条
            [MODIFIER_STATE_HEXED]	=false,	--06妖术，头顶会有妖术进度条
            [MODIFIER_STATE_INVISIBLE]	=fight,	--07隐身
            [MODIFIER_STATE_INVULNERABLE]	=fight,	--08无敌
            [MODIFIER_STATE_MAGIC_IMMUNE]	=false,	--09魔法免疫
            [MODIFIER_STATE_PROVIDES_VISION]	=false,	--10提供视野
            [MODIFIER_STATE_NIGHTMARED]	=fight,	--11睡眠，头上会有睡眠进度条
            [MODIFIER_STATE_BLOCK_DISABLED]	=false,	--12禁用格挡
            [MODIFIER_STATE_EVADE_DISABLED]	=false,	--13无法闪避
            [MODIFIER_STATE_UNSELECTABLE]	=ready,	--14不可选择
            [MODIFIER_STATE_CANNOT_TARGET_ENEMIES]	=false,	--15禁用单位目标命令
            [MODIFIER_STATE_CANNOT_MISS]	=false,	--16不会丢失，无视闪避
            [MODIFIER_STATE_SPECIALLY_DENIABLE]	=false,	--17可被反补
            [MODIFIER_STATE_FROZEN]	=false,	--18冰冻，动作会暂停
            [MODIFIER_STATE_COMMAND_RESTRICTED]	=fight,	--19无法执行命令
            [MODIFIER_STATE_NOT_ON_MINIMAP]	= fight or ready or bench,	--20没有小地图图标
            [MODIFIER_STATE_LOW_ATTACK_PRIORITY]	=false,	--21低攻击优先级
            [MODIFIER_STATE_NO_HEALTH_BAR]	=ready or fight,	--22没有生命条
            [MODIFIER_STATE_FLYING]	=false,	--23飞行
            [MODIFIER_STATE_NO_UNIT_COLLISION]	=fight,	--24没有碰撞体积
            [MODIFIER_STATE_NO_TEAM_MOVE_TO]	=false,	--25No Description Set
            [MODIFIER_STATE_NO_TEAM_SELECT]	=false,	--26No Description Set
            [MODIFIER_STATE_PASSIVES_DISABLED]	=ready or bench,	--27破坏，禁用被动，头上有破坏进度条
            [MODIFIER_STATE_DOMINATED]	=false,	--28支配，可用于过滤是否是支配单位
            [MODIFIER_STATE_BLIND]	=false,	--29致盲，完全失去视野
            [MODIFIER_STATE_OUT_OF_GAME]	=fight or bench,	--30离开游戏
            [MODIFIER_STATE_FAKE_ALLY]	=false,	--31No Description Set
            [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY]	=false,	--32贴地飞行
            [MODIFIER_STATE_TRUESIGHT_IMMUNE]	=false,	--33真视免疫
            [MODIFIER_STATE_UNTARGETABLE]	=false,	--34无法作为目标
            [MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS]	=ready,	--35禁用移动与攻击指令
            [MODIFIER_STATE_ALLOW_PATHING_TROUGH_TREES]	=false,	--36允许在树木中通行
            [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES]	=false,	--37对敌人没有小地图图标
            [MODIFIER_STATE_UNSLOWABLE]	=false,	--38无法减速
            [MODIFIER_STATE_TETHERED]	=false,	--39束缚，头上有束缚进度条
            [MODIFIER_STATE_IGNORING_STOP_ORDERS]	=false,	--40禁用停止指令
            [MODIFIER_STATE_FEARED]	=false,	--41No Description Set
            [MODIFIER_STATE_TAUNTED]	=false,	--42No Description Set
            [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED]	=false,	--43No Description Set
            [MODIFIER_STATE_LAST]	=false,	--44No Description Set
            -- [MODIFIER_STATE_SOFT_DISARMED]  =fight or bench,
        }
    end,
}
