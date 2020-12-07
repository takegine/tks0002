
SET_UP_AUTO_LAUNCH_DELAY = 0
SET_FIRST_HERO     ="minbing"
MAX_LEVEL          = 10
SET_PREGAME_TIME   = 0
TIME_BETWEEN_ROUND = 25
TIME_BATTER_MAX    = 40
TIME_HOLD_ON_TEST  = false
SET_STARTING_GOLD  = 80000
LOCAL_POPLATION    = 60
FOG_OF_WAR_DISABLE = true
PER_FRAME_INTERVAL = 1/30

SET_FORCE_HERO  = "npc_dota_hero_phoenix"
tkUnitInfo      = LoadKeyValues('scripts/npc/npc_info_custom.txt')
tkItemInfo      = LoadKeyValues('scripts/npc/npc_items_custom.txt')
tkRounList      = LoadKeyValues('scripts/npc/npc_round_custom.txt')
tkAutoInfo      = LoadKeyValues('scripts/npc/npc_abilities_autoinfo.txt')
DamageKV        = LoadKeyValues("scripts/npc/damage_table.kv")
VipList         = LoadKeyValues("scripts/npc/vipcost.kv")

OUT_SIDE_VECTOR = Vector(8192, -8192, 8192)

-- DAMAGE_TYPES = {
--     [0] = "DAMAGE_TYPE_NONE",
--     [1] = "DAMAGE_TYPE_PHYSICAL",
--     [2] = "DAMAGE_TYPE_MAGICAL",
--     [4] = "DAMAGE_TYPE_PURE",
--     [7] = "DAMAGE_TYPE_ALL",
--     [8] = "DAMAGE_TYPE_HP_REMOVAL"
-- }

COLOER_PLAYER = {
    0,0,255,
    255,0,0,
    0,255,0,
    0,255,255,
    255,0,255,
    255,255,0,
}