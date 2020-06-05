--[[
	Author: 西索酱
	Date: 30.04.2020
	每有一名友军蜀国武将存在时，可增加周围友军单位5 %近战攻击
]]

--[[预期思路：
激将 LUA 参考小黑的
建立一个实体表单，值为所有含参数 蜀的单位
遍历表单，回调为叠加激将buff 层数

建立一个实体表单，值为所有友军 单位
获得激将BUFF

激将buff
判断近战，每层 增加5%白字伤害
]]


LinkLuaModifier( "modifier_jijiang", "skill/hero_jijiang", LUA_MODIFIER_MOTION_NONE )

function jijiangaura( keys )
    --通过参数keys获得这个回调中要用到的参数
    local caster = keys.caster  
    --local target = keys.target
    local ability = keys.ability
    local radius = ability:GetLevelSpecialValueFor("radius",(ability:GetLevel()-1)) --按照技能中的特殊值检索
    local modifierName ="modifier_jijiang"
    --计算光环范围内的单位数量
    local units = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetAbsOrigin(),nil,radius,DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL,0,0,false)
                                 --参数分别是释放技能人的队伍编号，释放人的世界坐标，不统计的单位，检索半径，目标队伍，目标单位类型，0,0，false
    --table.insert( units, caster) --手动添加施法人自己

    --ability.needupwawe = true--给技能加一个参数[needupwawe],会在准备回合调用，刷新该技能。

    local count = 0--初始化层数
    for k,v in pairs(units) do
        --print(k,v)
        if v:GetUnitLabel()=="shuguo" then --每多一个蜀国单位，层数+1
            count = count + 1
        end
    end
    --print(count)--打印检测

    for _,v in pairs(units) do --给全队加上激将
        if caster:IsAlive() and v:GetName() ~="npc_dota_hero_phoenix" then
                v:AddNewModifier(caster, ability, modifierName, {})
                v:SetModifierStackCount( modifierName, caster ,count) 
        elseif  v:HasModifier(modifierName) then
            v:RemoveModifierByNameAndCaster(modifierName,caster)
        end
    end
end

modifier_jijiang = class({})
--------------------------------------------------------------------------------

function modifier_jijiang:IsHidden()      return false end
function modifier_jijiang:IsPurgable()	  return false end
function modifier_jijiang:GetTexture ()   return "ursa_fury_swipes" end
function modifier_jijiang:RemoveOnDeath() return true end    --死亡掉落

----------------------------------------

function modifier_jijiang:OnCreated( data )
    print("modifier_jijiang:OnCreated")
    if  self:GetAbility() ~= nil then
        self.bonus_damage_for_base = self:GetAbility():GetSpecialValueFor( "damagebase" )

    end
    self:StartIntervalThink(0.5)
    self.AttackDamage=100
	if  IsServer() then
        --self:OnWaweChange(5)--蜀国势力人数
    end
end

function modifier_jijiang:OnIntervalThink(keys)
    if IsServer() then
        self.AttackDamage=self:GetParent():GetAttackDamage()
        -- Calculate current regen before this modifier
        local parent = self:GetParent()
        if self:GetCaster() then
            local caster = self:GetCaster()
            if  caster:IsAlive()~=true or parent:IsAlive()~=true then
                parent:RemoveModifierByNameAndCaster(self:GetName(),caster)
                --self:Destroy()
                end
        else self:Destroy()
        end
    end
end
----------------------------------------

function modifier_jijiang:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE  }
    --print("modifier_jijiang:DeclareFunctions")
    return funcs
end

----------------------------------------

function modifier_jijiang:GetModifierPreAttack_BonusDamage( data )--data= parent
    --if IsServer() then
        local damag = 0
        --DeepPrintTable(data)
        local parent = self:GetParent()
        if  parent:IsRangedAttacker() ~= true then--不是远程
            damag = math.ceil(self.bonus_damage_for_base * self.AttackDamage * self:GetStackCount())
        end
        --print("modifier_jijiang:",1,parent:GetUnitName(),damag)        
        return damag--这里可以返回数字 int，可以self:GetStackCount()
    --end
end