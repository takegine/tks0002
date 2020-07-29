 LinkLuaModifier("modifier_ghsot_mokang",'skill/hero_zhiheng.lua',0)

skill_hero_zhiheng=class({})

function skill_hero_zhiheng:OnSpellStart()

   local caster=self:GetCaster()
   local ability=self
   local target=self:GetCursorTarget()
   local target_team  = self:GetAbilityTargetTeam()
   local target_types = self:GetAbilityTargetType()
   local target_flags = self:GetAbilityTargetFlags()
   local abilitynumber=self:GetLevelSpecialValueFor('abilitynumber', self:GetLevel()-1)
   local duration=self:GetLevelSpecialValueFor('duration',self:GetLevel()-1)
   local owner  = caster:GetOwner() or {ship={}} 

   if IsServer() then
    EmitSoundOn( "DOTA_Item.GhostScepter.Activate", self:GetCaster() )
  
   local kv={
    duration=duration,
    extra_spell_damage_percent=1300
}
   self:GetCursorTarget():AddNewModifier( self:GetCaster(), self, "modifier_ghost_state", kv )
 self:GetCursorTarget():AddNewModifier( self:GetCaster(), self, "modifier_ghsot_mokang", {Duration=duration} )




   local enemy = FindUnitsInRadius(caster:GetTeamNumber(), 
                                    caster:GetOrigin(), 
                                    nil, 
                                    2000,
                                    target_team, 
                                    target_types, 
                                    DOTA_UNIT_TARGET_FLAG_RANGED_ONLY, 
                                    0, 
                                    true)

    if owner.ship['wuzhi']  then
        abilitynumber=math.floor(abilitynumber*1.5)
    end 

    local number=RandomInt(1,abilitynumber)


    if number>=#enemy then number=#enemy end


    for i=1,number do 
    target=enemy[i]
    local kv={
        duration=duration,
        extra_spell_damage_percent=166
    }

    target:AddNewModifier( self:GetCaster(), self, "modifier_ghost_state", kv )
    target:AddNewModifier( self:GetCaster(), self, "modifier_ghsot_mokang", {duration=duration} )
    end

end

end

modifier_ghsot_mokang=class({})

function modifier_ghsot_mokang:DeclareFunctions()
return{
    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end 

function modifier_ghsot_mokang:GetModifierMagicalResistanceBonus()
return -66
end