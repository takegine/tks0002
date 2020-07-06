LinkLuaModifier( "modifier_buqu_grave", "skill/hero_buqu", LUA_MODIFIER_MOTION_NONE )
skill_hero_buqu = class({})
function skill_hero_buqu:IsHidden() return true end
function skill_hero_buqu:IsDebuff() return false end
function skill_hero_buqu:IsPurgable() return false end
function skill_hero_buqu:RemoveOnDeath() return false end

function skill_hero_buqu:DeclareFunctions() return { MODIFIER_EVENT_ON_TAKEDAMAGE, } end

function skill_hero_buqu:OnTakeDamage(event)
    if IsServer() then
        if event.unit == self:GetCaster() then
            if  self:GetCaster():GetHealth() <= 0 then
                self:GetCaster():SetHealth(1)
                self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_buqu_grave", {duration = 1})
            end
        end
    end
end

modifier_buqu_grave = class({})
function modifier_buqu_grave:IsHidden() return false end
function modifier_buqu_grave:IsDebuff() return false end
function modifier_buqu_grave:IsPurgable() return true end
function modifier_buqu_grave:DeclareFunctions() return { MODIFIER_PROPERTY_MIN_HEALTH, } end
function modifier_buqu_grave:GetMinHealth(event)  return 1 end

function modifier_buqu_grave:GetEffectName()
	return "particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold.vpcf"
end