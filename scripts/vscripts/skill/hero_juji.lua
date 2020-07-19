--   施法

--   目标身上增加debuff  减甲 并且获得视野  持续三秒  


LinkLuaModifier("skill_hero_juji",'skill/hero_juji.lua',0)
LinkLuaModifier("modifier_skill_hero_juji",'skill/hero_juji.lua',0)



skill_hero_juji = class({})   -- 声明一个技能 狙击

function skill_hero_juji:OnSpellStart()

    local caster=self:GetCaster()  --获取施法着
    local target=self:GetCursorTarget() --获取施法目标
    local duration=self:GetLevelSpecialValueFor('duration', self:GetLevel()-1)

    if target:HasModifier( "modifier_item_sphere_target" ) then
        return
    end

target:AddNewModifier(caster, self, 'modifier_skill_hero_juji', {duration=duration})  -- 添加减甲buff
-- target:AddNewModifier(caster, self, 'modifier_skill_hero_juji2', {duration=duration})  --获得单位视野

caster.juji_amountlist = caster.juji_amountlist or {}
table.insert(caster.juji_amountlist , target)

end

modifier_skill_hero_juji=class({})  --狙击的修饰器  这个修饰器减少护甲5+等级*4

function modifier_skill_hero_juji:DeclareFunctions()   
  return {
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
  }
end

function modifier_skill_hero_juji:GetModifierPhysicalArmorBonus()
    local caster=self:GetCaster() 
    return   -(5+caster:GetLevel()*4)
end

-- modifier_skill_hero_juji2=class({})  --  修饰器状态 获得视野

-- function modifier_skill_hero_juji2:IsDebuff()
-- 	return  true
-- end

-- function modifier_skill_hero_juji2:MODIFIER_STATE_PROVIDES_VISION()
-- 	return  true
-- end

function modifier_skill_hero_juji:CheckState()
    local state = {
    [MODIFIER_STATE_PROVIDES_VISION]=true,     --MODIFIER_STATE_PROVIDES_VISION
}      
    return state
end