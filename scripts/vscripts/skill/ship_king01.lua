--[[
	Author: 西索酱
	Date: 12.05.2020
	羁绊区分每个人时调用
]]
function Moban(data)--模版
	--[[
	local ability	=data.ability --这个羁绊
	local caster 	=data.caster  --施法者实体table
	local target 	=data.target  --施法者实体table
	local Target	=data.Target  --KV传过来的目标
	local Function	=data.Function--本回调：self
	local ScriptFile 	  =data.ScriptFile 	   --本回调所在文件地址
	local target_points	  =data.target_points  --目标位置
	local target_entities =data.target_entities--目标实体int
	local caster_entindex =data.caster_entindex--施法者实体int
	]]

	local hero = data.caster
	local name = hero:GetUnitName()

	if name == "npc_hero_zhaoyun" then
		--如果是赵云
		hero:ApplyDataDrivenModifier( caster, caster, "Modifier_skill_ship_NAME_for_zhaoyun", nil )--加一个写在KV里面的修饰器
		
		LinkLuaModifier( "修饰器名字", "修饰器锁在文件地址", 0 )
		hero:AddNewModifier( hero, self, "修饰器名字", {"补充参数，没有就空着"} )--加一个写在LUA里面的修饰器

		hero:AddAbility( "技能名字" )--加一个技能，要考虑什么时候删技能

	elseif name == "npc_hero_guanyu" then
		--如果是关羽
	elseif name == "npc_hero_zhangfei" then
		--如果是张飞
	end 
end

function tigerfather( data )--虎父无犬女
	local hero = data.caster
	local name = hero:GetUnitName()

	if name == "npc_hero_guanyu" then--如果是关羽
		LinkLuaModifier( "modifier_skill_hero_wusheng_for_guanyu", "buff/modifier_wusheng_for_guanyu.lua", LUA_MODIFIER_MOTION_NONE )
		hero:AddNewModifier( hero, hero:FindAbilityByName("skill_hero_wusheng"), "modifier_skill_hero_wusheng_for_guanyu", {} )
				
	elseif name == "npc_hero_guanyinping" then--如果是关银屏，加个武圣
		local fir=FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(),nil, -1, 1, DOTA_UNIT_TARGET_HERO, 0, 1, true)
		for k,v in pairs(fir)do
			if  v:GetUnitName()== "npc_hero_guanyu" then
				v:FindAbilityByName("skill_hero_wusheng"):ApplyDataDrivenModifier( hero, hero, "modifier_skill_hero_wusheng", nil)
			break
			end
		end
	 end
end

