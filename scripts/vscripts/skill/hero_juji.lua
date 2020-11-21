
LinkLuaModifier("modifier_skill_hero_juji",'skill/hero_juji.lua',0)

skill_hero_juji = class({})  

function skill_hero_juji:OnSpellStart()

    local caster=self:GetCaster()  
    local target=self:GetCursorTarget() 
    local duration=self:GetLevelSpecialValueFor('duration', self:GetLevel()-1)

    if target:HasModifier( "modifier_item_sphere_target" ) then
        return
    end

target:AddNewModifier(caster, self, 'modifier_skill_hero_juji', {duration=duration})  


caster.juji_amountlist = caster.juji_amountlist or {}
table.insert(caster.juji_amountlist , target)

caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
end

modifier_skill_hero_juji=class({})  
        
function modifier_skill_hero_juji:DeclareFunctions()   
  return {
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
  }
end

function modifier_skill_hero_juji:GetModifierPhysicalArmorBonus()
    local caster=self:GetCaster() 
    return   -(5+caster:GetLevel()*4)
end

function modifier_skill_hero_juji:CheckState()
    local state = {
    [MODIFIER_STATE_PROVIDES_VISION]=true,     
}      
    return state
end

function modifier_skill_hero_juji:GetEffectName()
    return
        'particles/units/heroes/hero_sniper/sniper_crosshair.vpcf'     
end

function modifier_skill_hero_juji:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end
