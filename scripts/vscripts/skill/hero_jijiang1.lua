--[[
	Author: 西索酱
	Date: 26.04.2020
	每有一名友军蜀国武将存在时，可增加周围友军单位5 %近战攻击
]]

--[[预期思路：

激将 LUA 参考拍拍
建立一个实体表单，值为所有含参数 蜀的单位
遍历表单，回调为叠加激将buff 层数

建立一个实体表单，值为所有友军 单位
获得激将BUFF

激将buff
判断近战，每层 增加5%白字伤害

]]

jijiang = class({})
--------------------------------------------------------------------------------

function jijiang:IsHidden()      return false end

--------------------------------------------------------------------------------

function jijiang:IsPurgable()	return false end

function jijiang:GetTexture ()   return "custom/relic_damage" end

----------------------------------------

function jijiang:OnCreated( kv )
    self.needupwawe = true
    if  self:GetAbility() ~= nil then
        self.bonus_damage_for_wawe = self:GetAbility():GetSpecialValueFor( "damagebase" )
    end
	if  IsServer() then
        self:OnWaweChange(5)--蜀国势力人数
    end
end

----------------------------------------

function jijiang:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

----------------------------------------

function jijiang:OnWaweChange( wawe )
	if  IsServer() then
        self.wave = wawe
        local damag = 0
        if  self:GetCaster():IsRangedAttacker() ~= true then
            damag = math.ceil((1+self.bonus_damage_for_wawe/100) * self.wave )
            
            if  damag ~= self:GetStackCount() then
                self:SetStackCount(damag)
            end
        end
    end
end

function jijiang:GetModifierPreAttack_BonusDamage( params )
	if IsServer() then
        local damag = 0
        if  self:GetCaster():IsRangedAttacker() ~= true then
            damag = math.ceil((1+self.bonus_damage_for_wawe/100) * self.wave )
            
            if  damag ~= self:GetStackCount() then
                self:SetStackCount(damag)
            end

        end
    end
    return self:GetStackCount()
end

