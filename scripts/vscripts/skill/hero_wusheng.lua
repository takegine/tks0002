-- 西索
-- 2020/06/17
-- 关羽的武圣，带羁绊加强

LinkLuaModifier( "modifier_skill_hero_wusheng_abivam", "skill/hero_wusheng.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skill_hero_wusheng_armor", "skill/hero_wusheng.lua", LUA_MODIFIER_MOTION_NONE )

function wusheng(keys)
  
	local caster  = keys.caster     --施法者，这里是关羽
    local target  = keys.target     --目标，这里应该是空值
    local ability = keys.ability    --技能，这里是武圣
    local attacker= keys.attacker   --攻击，触发这个脚本的攻击单位，攻击了关羽的单位
    local owner   = caster:GetOwner() or {ship={}}--关羽的持有者，即 玩家操作的信使

--技能KV中的参数
    local chance  = ability:GetLevelSpecialValueFor("chance", (ability:GetLevel()-1) )
    local damage  = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel()-1) )
    local radius  = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel()-1) )
    local damage_type  = ability:GetAbilityDamageType()
	local target_team  = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
    local target_flags = ability:GetAbilityTargetFlags()
    
    --判断物品：第一个格子（武器栏）是不是青龙偃月刀
    if caster:GetItemInSlot(0) and caster:GetItemInSlot(0):GetName()=='item_weapon_qinglongyanyuedao' then
        chance = chance * 2
    end

    --随机1-100，如果大于 触发概率，结束这个脚本
    if not RollPercentage(chance) then return end

    --判断羁绊：虎父无犬女生效，那么添加一个技能吸血效果。
    if owner.ship['hufu'] then
        caster:AddNewModifier( caster, ability , "modifier_skill_hero_wusheng_abivam", {duration=0.1} )
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





------------------------------
if modifier_skill_hero_wusheng_abivam == nil then modifier_skill_hero_wusheng_abivam = class({}) end

function modifier_skill_hero_wusheng_abivam:IsHidden()		return false end
function modifier_skill_hero_wusheng_abivam:IsPurgable()	return false end
function modifier_skill_hero_wusheng_abivam:RemoveOnDeath()	return true end
function modifier_skill_hero_wusheng_abivam:GetAttributes()	    return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_skill_hero_wusheng_abivam:DeclareFunctions()	return { MODIFIER_EVENT_ON_TAKEDAMAGE } end

function modifier_skill_hero_wusheng_abivam:OnCreated()
	if IsServer() and not self:GetAbility() then self:Destroy() end
end
--- Enum DamageCategory_t
-- DOTA_DAMAGE_CATEGORY_ATTACK = 1
-- DOTA_DAMAGE_CATEGORY_SPELL = 0
function modifier_skill_hero_wusheng_abivam:OnTakeDamage( keys )
	if keys.attacker ~= self:GetParent() or keys.unit:IsBuilding() or keys.unit:IsOther() then	return end
		-- Spell lifesteal handler
	if self:GetParent():FindAllModifiersByName(self:GetName())[1] == self 
	and keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL 
	and keys.inflictor 
	and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
		-- Particle effect
		self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
		ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)

		-- Fire sound
		self:GetParent():EmitSound("Hero_Zuus.StaticField")

		-- "However, when attacking illusions, the heal is not affected by the illusion's changed incoming damage values."
		-- This is EXTREMELY rough because I am not aware of any functions that can explicitly give you the incoming/outgoing damage of an illusion, or to give you the "displayed" damage when you're hitting illusions, which show numbers as if you were hitting a non-illusion.
		if keys.unit:IsIllusion() then
			if keys.damage_type == DAMAGE_TYPE_PHYSICAL and keys.unit.GetPhysicalArmorValue and GetReductionFromArmor then
				keys.damage = keys.original_damage * (1 - GetReductionFromArmor(keys.unit:GetPhysicalArmorValue(false)))
			elseif keys.damage_type == DAMAGE_TYPE_MAGICAL and keys.unit.GetMagicalArmorValue then
				keys.damage = keys.original_damage * (1 - GetReductionFromArmor(keys.unit:GetMagicalArmorValue()))
			elseif keys.damage_type == DAMAGE_TYPE_PURE then
				keys.damage = keys.original_damage
			end
		end
		local backheal =math.max(keys.damage, 0) * self:GetAbility():GetSpecialValueFor("abi_vam") * 0.01
		keys.attacker:Heal(backheal, self:GetParent())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), backheal, nil)
	end
	
end


---------------------------------------------------------

if modifier_skill_hero_wusheng_armor == nil then modifier_skill_hero_wusheng_armor = class({}) end

function modifier_skill_hero_wusheng_armor:IsHidden()		return false end -- 如果应该在增益栏上显示此修饰符 buff图标
function modifier_skill_hero_wusheng_armor:IsPurgable() 	return false end -- 如果可以清除此修饰符 可不可以被净化
function modifier_skill_hero_wusheng_armor:RemoveOnDeath()	return true end  -- 如果父项死亡时删除了此修饰符  单位死亡删除这个技能（否）
function modifier_skill_hero_wusheng_armor:DeclareFunctions()	return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE_ACTIVE } end --运行所有关联的destroy函数 
function modifier_skill_hero_wusheng_armor:GetModifierPhysicalArmorBonusUniqueActive()	return 10*self:GetStackCount() end --获取唯一的护甲加成，获取层数
