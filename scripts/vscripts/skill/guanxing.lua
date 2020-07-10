    --首先判断是不是拥有诸葛连弩 如果有，结束这个脚本，如果没有，则删除modifier_skill_hero_guanxing_3修饰器
    function guanxing(keys)
        local caster  = keys.caster     --施法者，这里是诸葛
    --判断物品：第一个格子（武器栏）是不是诸葛连弩
    if caster:GetItemInSlot(0) and caster:GetItemInSlot(0):GetName()<'item_weapon_zhugeliannu' then

        caster:RemoveModifierByName("modifier_skill_hero_guanxing_3")

    end

    --随机1-100，如果大于 触发概率，结束这个脚本
    if caster:GetItemInSlot(0) and caster:GetItemInSlot(0):GetName()=='item_weapon_zhugeliannu' then 

        return
        
     end
