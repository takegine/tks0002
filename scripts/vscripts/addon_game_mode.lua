
require('core/ToolsFromX')
require('core/Game_Event')
require('core/Expand_API')

-- Create the game mode when we activate
function Activate()
	local mapname = GetMapName()
	if mapname == "map8" then
		require("game/Supple_API")
		require("game/Game_Think")
		Game_Think.count =8
	elseif  mapname == "map1" then
		require("test/Game_Think")
		require("test/Supple_API")
		Game_Think.count =1
	end
	GameRules.CAddonGameMode = Game_Think()
	GameRules.CAddonGameMode:init()
	Game_Event:init()
	require("core/Game_Rules")
	LinkLuaS()
    print( "Template addon is loaded." )
end


function Precache( context )
	--[[
		预缓存我们知道将使用的东西。 可能的文件类型包括（但不限于）：
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )

			PrecacheEntityFromTable( string_1, handle_2, handle_3 )
			PrecacheEntityListFromTable( handle_1, handle_2 )
			PrecacheItemByNameSync( string_1, handle_2 )
			PrecacheModel( modelName, context )
			PrecacheResource( 类型, 目录, context )
			PrecacheUnitByNameSync( string_1, handle_2, int_3 )
			PrecacheUnitFromTableSync( handle_1, handle_2 )
	]]
	PrecacheResource( "model", "models/props_generic/fence_str_wood_01a.vmdl", context )
	PrecacheResource( "model", "models/props_generic/fence_str_wood_01b.vmdl", context )
	PrecacheResource( "model", "models/props_generic/fence_str_wood_01c.vmdl", context )

	PrecacheUnitByNameSync( SET_FORCE_HERO, context )

	for _, k in pairs(tkUnitInfo) do
		for _, v in pairs(k) do
			PrecacheUnitByNameSync(v.name, context)
		end
	end

	-- for item,_ in pairs(tkItemInfo) do
	-- 	print(item)
	-- 	PrecacheItemByNameSync( item, context )
	-- end
end