# tks0002 快速查看
[减免伤害的写法](##减免伤害)

[后置生效方法](##后置生效方法)

[改变伤害类型](##改变伤害的马甲单位)

[常用参数](##参数)

[获取实际的伤害值](##属性过滤后的伤害值)


## 注意事项

`2020-11-27` 更新 添加了两个修报错的脚本

    Script Runtime Error: ...ame\dota_addons\tks0002\scripts\vscripts\items\5\045.lua:27: attempt to index local 'ability' (a nil value)
    stack traceback:
- 类似于这种报错，若是只有返回一个技能的特殊值的话，可以用`self:GetAbilitySpecialValueFor( string )` ,
- 如果是修改器中的效果可以用`IsNUll(entity)`来判断，`ability` `caster` `parent`

- 使用参考 装备040 八卦阵法。

`2020-11-11` 更新 直接让信使买东西即可，已生成的友军会加上相应的效果。

`2020-10-10` 更新 有三个可以使用的自定义修改器
1. `modifier_abi_vam` 技能吸血，
2. `modifier_defend_big` 属性伤害抗性（百分比减伤）
3. `modifier_custom_shield` 属性伤害护盾 （有伤害抵扣上限）

`2020-09-15` 更新 整理矩阵的文件夹
1. 在这个文件上面有 `ability.conf`和`item.conf` 两个文件，把他们复制到`steamapps\common\dota 2 beta\game\dota_addons\tks0002\.dota2editor\`里面，替换原本的，就可以使用整理好的文件夹了。
2. 修改了同步的命令

如果更改区有文件就输入

        git stash --all; git fetch; git checkout 仓库/技能 ; git branch -D 技能; git checkout -b 技能; git stash pop -q

如果更改区没有文件就输入

        git fetch; git checkout 仓库/技能 ; git branch -D 技能; git checkout -b 技能

`2020-08-14` 更新 使用git上传的方法
1. 整理 更改区的文件，如果更改区没有文件 可以整句执行`git fetch; git branch -D 技能;git checkout 仓库/技能 ;git checkout -b 技能` 来更新本地的进度
2. 同步到最新，在命令行中输入 `git stash --all; git fetch; git checkout 仓库/技能 ; git branch -D 技能; git checkout -b 技能; git stash pop -q ` 也可以在vscode的终端中输入。
3. 把更改区的文件 勾选`暂存` 填写`消息`，点`提交`（尽量一个技能提交一行，一个围绕一个内容的修改提交一行）
4. 上传到仓库：在命令行中输入 `git push 仓库 技能 ` 也可以在vscode的终端中输入。


`2020-07-23` 更新 技能上传的时候检查内容
1. `npc_abilities_custom` 只改动了自己写的技能部分，尤其是用了矩阵编辑器，只上传自己更改的部分。
2. `resource/addon_schinese.txt` 写了这个技能 `名字` `说明` 涉及到的`参数`，修改器的`名字` `说明`。
3. 上传的时候把该改为隐藏的技能和修饰器改为隐藏，这个更新的UI，可以展示这个单位应该具备的技能。

`2020-07-19` 更新
1. lua类的技能单独起一个文件，名为`skill_hero_example`的技能`路径`为`skill/hero_example.lua`
2. 不需要`LinkLuaModifier`的技能，如果不是多次调用就统一放到`skill/total`下，比如 先生的就放到 `skill/total_xian.lua`。（这个文件已经新建好了。）
3. 技能的KV里面一定要写上基类和最大等级。
4. 测试指令中`ship` 更改羁绊状态后会执行后置生效方法 `needwaveup`。
5. 技能的`名字、说明、参数说明`都写在本地话中，路径是`resource/addon_schinese.txt`。可以借助矩阵编辑器。但注意把自己写的技能放到自己的对应的注释那行下面。
6. `接口`和`常数`可以按`F1`或者`Ctrl+Shfit+P` 然后输入`api`选择`DOTA2:lua server api`检索。
7. ~~后面提供了功能性的修改，我会写在`root`分支上，添加了的话我会告知大家，大家手动拉取`pull`合并`merge`一下。~~
8. 所有对友军的光环，对友军的治疗 其中flags要排除 `DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE` 不要给信使加状态。

# 框架
## 参数
### 攻击类型/防守类型

|	说明	|	普通	|	木	|	火	|	电	|	水	|	地	|	神	|
|	:----:	|	:----:	|	:----:	|	:----:	|	:----:	|	:----:	|	:----:	|	:----:	|
|	字段	|	none	|	tree	|	fire	|	electrical	|	water	|	land	|	god	|

### 国家
|	说明	|	吴国	|	蜀国	|	魏国	|	群雄	|
|	:----:	|	:----:	|	:----:	|	:----:	|	:----:	|
|	字段	|	wuguo	|	shuguo	|	weiguo	|	qunxiong	|

### 装备
|	说明	|	武器	|	防具	|	饰品	|	坐骑	|	书籍	|	兵书	|
|	:----:	|	:----:	|	:----:	|	:----:	|	:----:	|	:----:	|	:----:	|
|	字段	|	weapon	|	defend	|	jewelry	|	horses	|	format	|	queue	|
|	slot	|	0	|	1	|	2	|	3	|	4	|	5	|
|	装备栏位置	|	左上	|	中上	|	右上	|	左下	|	中下	|	右下	|

## 对话框指令

|	指令	|	用途	|	例子	|	备注	|
|	---	|	---	|	---	|	---	|
| -wtf | 无冷却无耗蓝
| -unwtf | 取消wtf模式
| -refresh | 刷新冷却和单位状态
|	myid	|	在控制台打印出自己steamID，方便复制	|	myid	|		|
|	ship NAME true	|	使关键词NAME的羁绊生效。	|	ship wuhu true	|	NAME的列表在“羁绊判断的关键词”中	|
|	ship NAME	|	使关键词NAME的羁绊失效。	|	ship wuhu	|	NAME的列表在“羁绊判断的关键词”中	|
|   hero lvlup  |   全场单位升1级   | hero lvlup | |
|   hero waveup  |   触发技能中的needwaveup   | hero waveup | |

# 轮子

### 锁定值范围的小技巧
`Clamp`也是很好用的方法，( 浮动值, 最小值 , 最大值 )
```lua
Clamp( 2, 0, 10) == 2
Clamp(12, 0, 10) == 10
Clamp(-5, 0, 10) == 0
```

### 打印变动部分

在一个修改器中的参数 `params` 实际是一个键值对的数组。因为他们是不断循环触发的，我们可以通过下面这个段代码来只打印其中变动的部分。
```lua
function modifier_example:OnTakeDamage( params)
    self.paramstable = self.paramstable or {}
    for k,v in pairs(params) do
        if  self.paramstable[k] ~= v then
            self.paramstable[k]  = v
            print("OnHealReceived", k, v, IsServer())
        end
    end
end
```

## 改变伤害的马甲单位
比如我们需要释放电属性的伤害，但是单位本身的攻击属性不是电属性，那么我们可以创建一个马甲单位制造这个伤害。
```lua
local dummy = CreateUnitByName( "npc_damage_dummy", OUT_SIDE_VECTOR, false, parent, parent, parent:GetTeamNumber() )
dummy.attack_type  = "electrical"
dummy:AddNewModifier(dummy, nil, 'modifier_kill', {duration = 0.1} )
```
- 注意在 `ApplyDamage` 的时候，attacker不再是 `caster` 或者 `parent` ,而是我们上面创建的 `dummy` 。
- `dummy` . `attack_type` 要赋值为实际需要的伤害属性。
- 第三行添加的修改器是在`0.1`秒后自杀。如果是个由他发出的持续伤害，那么就吧`0.1`改为实际的持续时间。



## 后置生效方法

有的羁绊或者装备只需要判断一次，又没有合适触发事件时，我们写成后置生效的方法 `needwaveup`。
游戏中运行的顺序是 
1. 生成战斗单位
2. 添加技能 （所有的Oncreate会在这里执行）
3. 判断羁绊，为owner.ship赋值
4. 添加装备，依照玩家信使来复制装备
5. 执行后置生效方法

如果是 `ability_lua` 类的技能就非常直接，下方是一个参考。更多实例可以参考技能：激将，狂骨，刘桃

```lua
function skill_hero_example:needwaveup()
    local caster  = self:GetCaster()
    local owner   = caster:XinShi()

    if  owner.ship['temp'] then
        print("waveup is working")
    end
end
```

如果是 `ability_datadriven` 类的技能,就相对复杂一点点。我们给技能一个默认拥有的修改器，或者已有的修改器中，写当`修改器创建`的事件，然后在里面执行脚本。
下方是一个参考。更多实例可以参考技能：超骑，刘桃，观星

```
"Modifiers"
    {
        "modifier_skill_hero_abiname_needwaveup"
        {
            "Passive"	"1"
            "OnCreated"
            {
                "RunScript"
                {
                    "ScriptFile"  "skill/example.lua"
                    "Function"	  "addwaveup"
                }
            }
        }
    }
```

```lua
function addwaveup ( params )
    local ability = params.ability

	ability.needwaveup = function ( ability)
		local caster   = ability:GetCaster()
        local owner    = caster:XinShi()

        if  owner.ship['temp'] then
            print("waveup is working")
        end
    end
end
```

## 减免伤害
减免伤害可以用添加 `modifier_defend_big` 这个修饰器来做。

举例一个持续7秒的减免`火`系伤害`40%` 和 `地`系伤害`10%` 的写法。
```lua
    local hModiferTable = {
        fire     = 40,
        land     = 10，
        duration = 7
    }
    hCaster:AddNewModifier( hCaster, hAbility , "modifier_defend_big", hModiferTable )
```
注意：
1. 通常不要在受到伤害后添加，那样不能减免这次伤害，只能减免之后受到的伤害。
2. 不同的系使用的参数可以参考上方的[攻防类型](###攻击类型/防守类型)。
3. 传参所用到的`hModiferTable`里面可以写多个减免类型。


## 属性过滤后的伤害值
最后一次造成的伤害是`battleinfo.damage_deal`
最后一次受到的伤害是`battleinfo.damage_take`
```lua
function modifier_example:OnTakeDamge(keys)
    local attacker = keys.attacker
    local damage   = attacker.battleinfo.damage_deal
end
```