-- 西索
-- 2020/06/17
-- 关羽的武圣，带羁绊加强

LinkLuaModifier( "modifier_skill_hero_wusheng_armor", "skill/hero_wusheng.lua", LUA_MODIFIER_MOTION_NONE )

function wusheng(keys)

	local caster  = keys.caster     --施法者，这里是关羽
    local target  = keys.target     --目标，这里应该是空值
    local ability = keys.ability    --技能，这里是武圣
    local attacker= keys.attacker   --攻击，触发这个脚本的攻击单位，攻击了关羽的单位
    local owner   = caster:GetOwner() or {ship={}}--关羽的持有者，即 玩家操作的信使

--技能KV中的参数
    local chance  = ability:GetSpecialValueFor("chance" )
    local damage  = ability:GetSpecialValueFor("damage" )
    local radius  = ability:GetSpecialValueFor("radius" )
    local damage_type  = ability:GetAbilityDamageType()
	local target_team  = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
    local target_flags = ability:GetAbilityTargetFlags()
    
    --判断物品：第一个格子（武器栏）是不是青龙偃月刀
    if caster:GetItemInSlot(0) and caster:GetItemInSlot(0):GetName()=='item_weapon_009' then
        chance = chance * 2
    end

    --随机1-100，如果大于 触发概率，结束这个脚本
    if not RollPercentage(chance) then return end

    --判断羁绊：虎父无犬女生效，那么添加一个技能吸血效果。
    if owner.ship['hufu'] then
        local abi_vam = ability:GetSpecialValueFor("abi_vam" )
        caster:AddNewModifier( caster, ability , "modifier_abi_vam", { duration=0.1, count=abi_vam } )
    end

    --判断羁绊：桃园结义生效，那么添加一个护甲效果。
    if owner.ship['taoyuan'] then
    local modifierName="modifier_skill_hero_wusheng_armor"
        if caster:HasModifier( modifierName ) then
            caster:SetModifierStackCount( modifierName, caster , caster:GetModifierStackCount( modifierName, caster )+1) 
        else
            caster:AddNewModifier( caster, ability , modifierName , {duration= 5} )
            caster:SetModifierStackCount( modifierName, caster ,1) 
        end
    end

    --判断羁绊：五虎上将生效，那么伤害和范围提升50%。
    if owner.ship['wuhu'] then
        damage = damage *1.5
        radius = radius *1.5

    end

    local zhuan = ParticleManager:CreateParticle("particles/econ/items/axe/axe_cinder/axe_cinder_battle_hunger_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(zhuan, 0, keys.attacker:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(zhuan)

    caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)

    --范围伤害
	local damage_table = {}

	damage_table.attacker     = caster
    damage_table.victim       = attacker
	damage_table.damage_type  = damage_type
	damage_table.ability      = ability
	damage_table.damage       = damage
	damage_table.damage_flags = DOTA_DAMAGE_FLAG_NONE

    local enemy = FindUnitsInRadius(caster:GetTeamNumber(), 
                                    caster:GetOrigin(), 
                                    nil, 
                                    radius,
                                    target_team, --这个值在13行
                                    target_types, 
                                    target_flags, 
                                    0, 
                                    true)

    for k,v in pairs(enemy) do
        damage_table.victim = v
        ApplyDamage(damage_table)
    end

end

---------------------------------------------------------

if modifier_skill_hero_wusheng_armor == nil then modifier_skill_hero_wusheng_armor = class({}) end

function modifier_skill_hero_wusheng_armor:IsHidden()		return false end
function modifier_skill_hero_wusheng_armor:IsPurgable() 	return false end
function modifier_skill_hero_wusheng_armor:RemoveOnDeath()	return true end
function modifier_skill_hero_wusheng_armor:DeclareFunctions()	return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE_ACTIVE } end
function modifier_skill_hero_wusheng_armor:GetModifierPhysicalArmorBonusUniqueActive()	return 10*self:GetStackCount() end
