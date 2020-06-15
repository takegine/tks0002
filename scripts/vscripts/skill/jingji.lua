
function spiked_carapace_init( keys )
keys.caster.carapaced_units = {}
end


function spiked_carapace_reflect( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local zongshanghai = keys.DamageTaken
	local dengji = keys.ability:GetLevel()
	local baifenbi = {5,10,15,20,25}
	local baifenbijihe = baifenbi[dengji]


	if  attacker:IsRangedAttacker() == true
		then
			attacker:SetHealth( attacker:GetHealth() - zongshanghai * baifenbijihe )
			--被打的效果是什么keys.ability:ApplyDataDrivenModifier( caster, attacker, "modifier_skill_hero_jingji", { } )
			caster:SetHealth( caster:GetHealth() + zongshanghai )

	end
end