-- 不用linkluamodifier 也不是多次执行脚本的技能，可以把脚本都放在这里
-- 这个文件是给 白喵 放置脚本的

--[[
* @Description: 
* @Author: 白喵
* @Date: 2020-07-21 22:49:01
* @LastEditors: 白喵
* @LastEditTime: 2020-09-17 22:30:41
--]]

--[[
* @description: 缔盟
* @return: 
* @param {type} 
* @author: chriscp_cat
--]]
function Dimeng(keys)
    local ability = keys.ability
    local level = ability:GetLevel()
    local target = keys.target
    if ability:IsCooldownReady() then
        local GiveMana = ability:GetSpecialValueFor("reduce")
        --local pfxname = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf"
        --local pfx = ParticleManager:CreateParticle( pfxname, PATTACH_ABSORIGIN_FOLLOW, target)
        --ParticleManager:SetParticleControl(pfx, 0, Vector(0, 0, 0))
        --ParticleManager:ReleaseParticleIndex(pfx)
        target:ReduceMana(GiveMana)--减少目标蓝量
        ability:StartCooldown(5.0)--使技能进入冷却
    end
end


function fenwei(keys)
    local target_list = keys.target_entities
    for _,unit in ipairs(target_list) do
        --unit:Purge(true, false, false, false, true)
        print(unit:GetUnitName())
        if unit:IsSummoned() then
            unit:Kill(keys.ability,keys.caster)
        end
        if unit:IsIllusion() then
            unit:Kill(keys.ability,keys.caster)
        end
    end
end

function add_quhu(keys)
    local unit = keys.target
    local ability = keys.ability
    if unit:IsHero() then
        ability:ApplyDataDrivenModifier(keys.caster, unit, "modifier_hero_quhu", {duration = ability:GetSpecialValueFor("duration")})
    else
        ability:ApplyDataDrivenModifier(keys.caster, unit, "modifier_hero_quhu", nil)
    end
end

function quhu(keys)
    local owner = keys.caster:GetOwner() or {ship={}}
    if not owner.ship['quhu'] then
        return
    end
    local unitlist = keys.target_entities
    local ability = keys.ability
    local dummy = CreateUnitByName( "npc_damage_dummy", Vector(0,0,0), false, keys.caster, keys.caster, keys.caster:GetTeamNumber() )
    dummy.attack_type  = "water"
    for _,unit in ipairs(unitlist) do
        local info ={
            attacker     = dummy,
            victim       = unit,
            damage_type  = DAMAGE_TYPE_MAGICAL,
            damage       = ability:GetSpecialValueFor("damage")
        }
        ApplyDamage(info)
    end
    dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )
end


--治疗波
--[[Author: YOLOSPAGHETTI
	Date: March 24, 2016
	Finds the next unit to jump to and deals the damage]]
    function LightningJump(keys)
        local caster = keys.caster
        local target = keys.target
        local ability = keys.ability
        local jump_delay = ability:GetLevelSpecialValueFor("jump_delay", (ability:GetLevel() -1))
        local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() -1))
        
        -- Applies damage to the current target
        --ApplyDamage({victim = target, attacker = caster, damage = ability:GetAbilityDamage(), damage_type = ability:GetAbilityDamageType()})
        if not ability.effect then
            ability.effect = 1
        end
        --print(ability:GetSpecialValueFor("heal")*ability.effect)
        target:Heal(ability:GetSpecialValueFor("heal")*ability.effect,caster)
        -- Removes the hidden modifier
        target:RemoveModifierByName("modifier_hero_qingnang")
        
        -- Waits on the jump delay
        Timer(jump_delay,
        function()
            -- Finds the current instance of the ability by ensuring both current targets are the same
            local current
            for i=0,ability.instance do
                if ability.target[i] ~= nil then
                    if ability.target[i] == target then
                        current = i
                    end
                end
            end
        
            -- Adds a global array to the target, so we can check later if it has already been hit in this instance
            if target.hit == nil then
                target.hit = {}
            end
            -- Sets it to true for this instance
            target.hit[current] = true
        
            -- Decrements our jump count for this instance
            ability.jump_count[current] = ability.jump_count[current] - 1
            ability.effect = ability.effect*(1-0.25)
            -- Checks if there are jumps left
            if ability.jump_count[current] > 0 then
                -- Finds units in the radius to jump to
                local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
                local closest = radius
                local new_target
                for i,unit in ipairs(units) do
                    -- Positioning and distance variables
                    local unit_location = unit:GetAbsOrigin()
                    local vector_distance = target:GetAbsOrigin() - unit_location
                    local distance = (vector_distance):Length2D()
                    -- Checks if the unit is closer than the closest checked so far
                    if distance < closest then
                        --满血则下一个
                        if unit:GetHealthPercent() == 100 then
                            goto continue
                        end
                        -- If the unit has not been hit yet, we set its distance as the new closest distance and it as the new target
                        if unit.hit == nil then
                            new_target = unit
                            closest = distance
                        elseif unit.hit[current] == nil then
                            new_target = unit
                            closest = distance
                        end
                        ::continue::
                    end
                end
                -- Checks if there is a new target
                if new_target ~= nil then
                    -- Creates the particle between the new target and the last target
                    local lightningBolt = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, target)
                    ParticleManager:SetParticleControl(lightningBolt,0,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))   
                    ParticleManager:SetParticleControl(lightningBolt,1,Vector(new_target:GetAbsOrigin().x,new_target:GetAbsOrigin().y,new_target:GetAbsOrigin().z + new_target:GetBoundingMaxs().z ))
                    -- Sets the new target as the current target for this instance
                    ability.target[current] = new_target
                    -- Applies the modifer to the new target, which runs this function on it
                    ability:ApplyDataDrivenModifier(caster, new_target, "modifier_hero_qingnang", {})
                else
                    -- If there are no new targets, we set the current target to nil to indicate this instance is over
                    ability.target[current] = nil
                end
            else
                -- If there are no more jumps, we set the current target to nil to indicate this instance is over
                ability.target[current] = nil
            end
        end)
    end
    
    --[[Author: YOLOSPAGHETTI
        Date: March 24, 2016
        Keeps track of all instances of the spell (since more than one can be active at once)]]
    function NewInstance(keys)
        local caster = keys.caster
        local ability = keys.ability
        local target = keys.target
        
        -- Keeps track of the total number of instances of the ability (increments on cast)
        if ability.instance == nil then
            ability.instance = 0
            ability.jump_count = {}
            ability.target = {}
        else
            ability.instance = ability.instance + 1
        end
        
        -- Sets the total number of jumps for this instance (to be decremented later)
        ability.jump_count[ability.instance] = ability:GetLevelSpecialValueFor("jump_count", (ability:GetLevel() -1))
        -- Sets the first target as the current target for this instance
        ability.target[ability.instance] = target
        ability.effect = 1
        -- Creates the particle between the caster and the first target
        local lightningBolt = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, caster)
        ParticleManager:SetParticleControl(lightningBolt,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))   
        ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))   
    end
--治疗波结束    

function mingce(keys)
    local ability = keys.ability
    local caster = ability:GetCaster()
    local owner = caster:GetOwner() or {ship={}}
    if owner.ship["mingzhu"] then
        local summoned_list = {"npc_unit_huoyuansu","npc_unit_shuiyuansu","npc_unit_tuyuansu"}
        local unit_name = summoned_list[RandomInt(1, 3)]
        local summoned = CreateUnitByName( unit_name, caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
        summoned:CreatureLevelUp(ability:GetLevel()-1)
        summoned:GetAbilityByIndex(0):ToggleAbility()--激活多重射
        if not ability.summoned then
            ability.summoned = {}
        end
        table.insert(ability.summoned,summoned)
    else
        local summoned = CreateUnitByName( "npc_unit_huoyuansu", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
        summoned:CreatureLevelUp(ability:GetLevel()-1)
        if not ability.summoned then
            ability.summoned = {}
        end
        table.insert(ability.summoned,summoned)
    end
end

function mingce_on_death(keys)
    local ability = keys.ability
    local caster = ability:GetCaster()
    local summoned = ability.summoned or {}
    for _,unit in ipairs(summoned) do
        if not unit:IsNull() then
            unit:ForceKill(false)
        end
    end
    ability.summoned = nil
end

function guidao(keys)
    local ability = keys.ability
    local caster = ability:GetCaster()
    local huangjin = CreateUnitByName( "npc_unit_huangjinbing", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
    local duration = ability:GetSpecialValueFor("duration")
    huangjin:CreatureLevelUp(ability:GetLevel()-1)
    huangjin:AddNewModifier(tmp_unit, nil, 'modifier_kill', {duration = duration} )
    local tmp_unit
    --if true then
    if caster:GetItemInSlot(5) and caster:GetItemInSlot(5):GetName()=='item_format_036' then
        guidao_huanyin(huangjin)
        for _ = 1,8 do
            tmp_unit = CreateUnitByName( "npc_unit_huangjinbing", huangjin:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
            tmp_unit:CreatureLevelUp(ability:GetLevel()-1)
            guidao_huanyin(tmp_unit)
            tmp_unit:AddNewModifier(tmp_unit, nil, 'modifier_kill', {duration = duration} )
        end
    else
        for _ = 1,8 do
            tmp_unit = CreateUnitByName( "npc_unit_huangjinbing", huangjin:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
            tmp_unit:CreatureLevelUp(ability:GetLevel()-1)
            tmp_unit:AddNewModifier(tmp_unit, nil, 'modifier_kill', {duration = duration} )
        end
    end

end
function guidao_huanyin(unit)
    local owner = unit:GetOwner()
    unit:SetBaseDamageMax(unit:GetBaseDamageMax()*2)
    unit:SetBaseDamageMin(unit:GetBaseDamageMin()*2)
    --攻击力翻倍
    for q=0,5 do
        local oitem = owner:GetItemInSlot(q)
        local vitem = unit:GetItemInSlot(q)
        if    oitem 
        and ( not vitem  or vitem:GetName() ~= oitem:GetName() ) 
        then local additem = CreateItem( oitem:GetName(), unit, unit )
            additem:SetLevel(oitem:GetCurrentCharges())
            unit:RemoveItem(vitem )
            unit:AddItem( additem )
            if    additem 
            and   additem.needwaveup 
            then  additem:needwaveup()
            end
        end
    end
    --添加宝物效果
end