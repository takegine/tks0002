GameRules:SetPreGameTime(SET_PREGAME_TIME)
GameRules:SetStartingGold(SET_STARTING_GOLD)
-- GameRules:SetGoldPerTick(1) 
-- GameRules:SetGoldTickTime(1)
-- GameRules:SetStrategyTime( 0 )
-- GameRules:SetHeroSelectionTime(0)
-- GameRules:SetHeroSelectPenaltyTime(0)
GameRules:SetHeroRespawnEnabled( false )
GameRules:SetCustomGameSetupAutoLaunchDelay(SET_UP_AUTO_LAUNCH_DELAY)
GameRules:EnableCustomGameSetupAutoLaunch(true)

SendToServerConsole("snd_musicvolume 0")
SendToServerConsole("dota_hud_healthbars 1") 
SendToServerConsole("dota_hero_overhead_names 0")

GameRules:SetFirstBloodActive(false)            -- 是否开启第一滴血
GameRules:SetHideKillMessageHeaders(true)       -- 是否隐藏击杀提示
GameRules:SetPostGameTime(300)                  -- 设置游戏结束后停留的时间
GameRules:SetUseBaseGoldBountyOnHeroes(false)   -- 是否使用默认的击杀奖励

GameRules:SetCustomGameTeamMaxPlayers( 2, 0 )
GameRules:SetCustomGameTeamMaxPlayers( 3, 0 )
YOUR_RE_IN_TEST    = false



-- PLAYER_ARR      = {}--所有人是否选好主公
--GAME_STATS   = 1--0准备，1倒计时，2对战
_G.GAME_ROUND   = 0--初始化轮数
_G.buildpostab  = {}--所有单位位置
    tkShipList  = {}
    PLAYER_LIST = {}--随机进攻方的表
    UNITS_LIST  = {enemy={} ,defend={}} --场地实体清单

Custom_XP_Required ={
    100000
}
