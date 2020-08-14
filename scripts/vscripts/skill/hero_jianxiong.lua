skill_hero_jianxiong = {}
function skill_hero_jianxiong:needwaveup()
    local caster = self:GetCaster()
    self.unit_list = {}
    caster:AddNewModifier(caster, self, "modifier_hero_jianxiong",nil )
end


function skill_hero_jianxiong:is_include(value)
    for _,v in ipairs(self.unit_list) do
        if v == value then
            return true
        end
    end
    return false
end


modifier_hero_jianxiong = {}

LinkLuaModifier("modifier_hero_jianxiong", "skill/hero_jianxiong.lua", 0)

function modifier_hero_jianxiong:DeclareFunctions()
    return {MODIFIER_EVENT_ON_ATTACKED}
end

function modifier_hero_jianxiong:OnAttacked(keys)
    local parent = self:GetParent()
    if parent ~= keys.target then
        return
    end
    local ability = self:GetAbility()
    local attacker = keys.attacker
    if ability:is_include(attacker) then
        return
    end
    local owner = parent:GetOwner() or {ship={}}
    local incoming_damage = ability:GetSpecialValueFor("incoming_damage")
    local outgoing_damage = ability:GetSpecialValueFor("outgoing_damage")
    if owner.ship['xianying'] then
        incoming_damage = incoming_damage/2--承受伤害减半
    end
    print(parent:GetMana())
    if parent:GetMana() < 8 then--判断蓝量是否足够
        return
    end

    parent:SpendMana(ability:GetManaCost(0),ability)
    local illusions = CreateIllusions(parent, attacker, { duration = ability:GetSpecialValueFor("duration"),outgoing_damage = outgoing_damage-100 , incoming_damage = incoming_damage }, 1, 50, true, true )
    if owner.ship['jianxiong'] then
        if attacker:IsRangedAttacker() then
            local duration = RandomFloat(1.0,2.0)
            attacker:AddNewModifier(parent, ability, "modifier_hero_jianxiong2", { duration = duration })
        else
            local duration = RandomFloat(2.0,4.0)
            attacker:AddNewModifier(parent, ability, "modifier_hero_jianxiong2", { duration = duration })
        end
    end
    ability.unit_list[#ability.unit_list+1] = attacker
end



modifier_hero_jianxiong2 =  {}

LinkLuaModifier("modifier_hero_jianxiong2", "skill/hero_jianxiong.lua", 0)

function modifier_hero_jianxiong2:CheckState()
    local parent = self:GetParent()
    if parent:IsRangedAttacker() then
        return {[MODIFIER_STATE_STUNNED] = true}
    else
        return {[MODIFIER_STATE_NIGHTMARED] = true}
    end
end