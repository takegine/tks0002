


LinkLuaModifier("modifier_skill_hero_taijun",'skill/hero_taijun.lua',0)


function skill_hero_taijun:GetIntrinsicModifierName()  --声明技能实践  技能释放
    return "skill_hero_taijun"
end

skill_hero_taijun=class({})

function skill_hero_taijun:GetIntrinsicModifierName()  --声明技能实践  技能释放
    return "skill_hero_taijun"
end


function skill_hero_taijun_onattack:DeclareFunctions()
    return {
    MODIFIER_EVENT_ON_ATTACK_LANDED
}
end 

function skill_hero_taijun_onattack:OnAttackLanded(keys)

    local ability=self:GetAbility()
	local caster=self:GetCaster()
    local owner =caster:GetOwner() or {ship{}}
    
    if keys.target~=caster 
	then return
    end
 print('onattack')
   -- if  owner.ship['junzi']  then 
    caster:AddNewModifier(caster, self, 'modifier_skill_hero_taijun', {})
  --  end

end



modifier_skill_hero_taijun=class({})   --减免伤害

function modifier_skill_hero_taijun:DeclareFunctions()
    return 
    {
    MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
}
end 

function modifier_skill_hero_taijun:GetModifierPhysical_ConstantBlock()
    local ability=self:GetAbility()
	local caster=self:GetCaster()
    return  1000   --ability:GetLevel()*130
end
