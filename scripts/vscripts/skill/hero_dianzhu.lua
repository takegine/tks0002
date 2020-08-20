
LinkLuaModifier( "modifier_skill_hero_dianzhu", "skill/hero_dianzhu", 0 )

skill_hero_dianzhu = class({})
modifier_skill_hero_dianzhu = class({})

function skill_hero_dianzhu:needwaveup()  
    local caster=self:GetCaster()

    local owner = caster:GetOwner() or {ship={}}   --判断是否有组合
    if owner.ship['huzhu'] then
      caster:AddNewModifier(caster, self ,'modifier_skill_hero_dianzhu', {})
    end
end

function modifier_skill_hero_dianzhu:DeclareFunctions()
    local ability = self:GetAbility()
    local parent  = self:GetParent()
  
        local dianfan = parent:AddAbility("skill_hero_dianfan")
        local lvl = ability:GetLevel()
        dianfan:SetLevel(lvl)
        parent:RemoveModifierByName("modifier_skill_hero_dianzhu")
        parent:RemoveAbility("skill_hero_dianzhu")
end 

function modifier_skill_hero_dianzhu:IsHidden()
    return true
end
