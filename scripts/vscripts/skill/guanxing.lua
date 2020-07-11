    --首先判断是不是拥有诸葛连弩 如果有，则添加modifier_skill_hero_guanxing_3修饰器
    function guanxing(keys)
        local ability  = keys.ability     --技能观星
        local caster  = keys.caster     --目标，这里是自己本身
    --判断物品：第一个格子（武器栏）是不是诸葛连弩
    if caster:GetItemInSlot(0) and caster:GetItemInSlot(0):GetName()=='item_weapon_zhugeliannu' then

   ability:ApplyDataDrivenModifier( caster, caster , "modifier_skill_hero_guanxing_3", nil )

    end

end

