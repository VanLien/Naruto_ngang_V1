local function var_0_0(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.cost:text(arg_1_2)

	local var_1_0 = arg_1_2 <= arg_1_1 and ui.NEWCOLORS.BROWN1 or ui.NEWCOLORS.REDLIGHT

	text.addEffect(arg_1_0.cost, {
		color = var_1_0
	})
	adapt.oneLinePos(arg_1_0.cost, arg_1_0.costNote, cc.p(8, 0), "right")
	adapt.oneLinePos(arg_1_0.cost, arg_1_0.costIcon, cc.p(18, 0))
end

local function var_0_1(arg_2_0, arg_2_1)
	arg_2_1:removeAllChildren()

	return rich.createByStr(arg_2_0, 40):anchorPoint(0, 0.5):addTo(arg_2_1, 6)
end

local var_0_2 = class("UnionSkillView", Dialog)

var_0_2.RESOURCE_FILENAME = "union_skill.json"
var_0_2.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
	maskPanel = "maskPanel",
	rightPanel = "rightPanel",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	title1 = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	title2 = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				margin = 0,
				asyncPreload = 12,
				columnSize = 3,
				data = bindHelper.self("skillDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					arg_3_1:get("name"):text(arg_3_3.name)
					arg_3_1:get("select"):visible(arg_3_3.select == true)
					arg_3_1:get("level"):text("Lv" .. arg_3_3.level):visible(arg_3_3.unlocked == 1)
					text.addEffect(arg_3_1:get("level"), {
						outline = {
							color = ui.NEWCOLORS.OUTLINE.BLACK
						}
					})
					arg_3_1:get("mask"):visible(arg_3_3.unlocked == 2)
					arg_3_1:get("icon"):texture(arg_3_3.icon)
					bind.touch(arg_3_0, arg_3_1, {
						methods = {
							ended = functools.partial(arg_3_0.itemClick, arg_3_0:getIdx(arg_3_2), arg_3_3)
						}
					})
				end,
				onAfterBuild = function(arg_4_0)
					arg_4_0.afterBuild()
				end
			},
			handlers = {
				itemClick = bindHelper.self("onFrameItemClick"),
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	},
	["rightPanel.btnPractice"] = {
		varname = "btnPractice",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnPractice")
			}
		}
	}
}

function var_0_2.onCreate(arg_5_0, arg_5_1)
	arg_5_0:initModel()

	arg_5_0.selectSkill = idler.new(1)
	arg_5_0.skillDatas = idlers.new()

	idlereasy.when(arg_5_0.unionSkills, function(arg_6_0, arg_6_1)
		local var_6_0 = {}

		for iter_6_0, iter_6_1 in csvPairs(csv.union.union_skill) do
			local var_6_1 = arg_6_1[iter_6_0] and 1 or 2

			if arg_5_0.unionLevel:read() < iter_6_1.needGuildLv then
				var_6_1 = 2
			end

			table.insert(var_6_0, {
				id = iter_6_0,
				unlocked = var_6_1,
				name = iter_6_1.name,
				icon = iter_6_1.icon,
				level = arg_6_1[iter_6_0] or 0,
				sort = iter_6_1.sort
			})
		end

		table.sort(var_6_0, function(arg_7_0, arg_7_1)
			if arg_7_0.sort == arg_7_1.sort then
				return arg_7_0.id < arg_7_1.id
			end

			return arg_7_0.sort < arg_7_1.sort
		end)
		dataEasy.tryCallFunc(arg_5_0.list, "updatePreloadCenterIndex")
		arg_5_0.skillDatas:update(var_6_0)
		arg_5_0.selectSkill:set(arg_5_0.selectSkill:read(), true)
	end)
	idlereasy.any({
		arg_5_0.coin3,
		arg_5_0.selectSkill
	}, function(arg_8_0, arg_8_1, arg_8_2)
		arg_5_0:setRightPanel(arg_8_2, arg_8_1)
	end)
	arg_5_0.selectSkill:addListener(function(arg_9_0, arg_9_1, arg_9_2)
		if arg_5_0.skillDatas:atproxy(arg_9_1) then
			arg_5_0.skillDatas:atproxy(arg_9_1).select = false
		end

		arg_5_0.skillDatas:atproxy(arg_9_0).select = true
	end)

	arg_5_0.playAnimation = idler.new(2)

	idlereasy.when(arg_5_0.playAnimation, function(arg_10_0, arg_10_1)
		local var_10_0 = arg_5_0.rightPanel:get("effectPanel")

		var_10_0:removeAllChildren()

		if arg_10_1 == 1 then
			local var_10_1 = var_10_0:getContentSize()

			widget.addAnimationByKey(var_10_0, "effect/jineng.skel", nil, "effect", 555):xy(var_10_1.width / 2, var_10_1.height / 2):scale(1.4)
		end
	end)
	Dialog.onCreate(arg_5_0)
end

function var_0_2.initModel(arg_11_0)
	arg_11_0.unionSkills = gGameModel.role:getIdler("union_skills")
	arg_11_0.unionLevel = gGameModel.union:getIdler("level")
	arg_11_0.coin3 = gGameModel.role:getIdler("coin3")
end

function var_0_2.onBtnPractice(arg_12_0)
	if arg_12_0.lackCoin3 == true then
		gGameUI:showTip(gLanguageCsv.cuildCurrencyNotEnough)

		return
	end

	gGameApp:requestServer("/game/union/skill", function()
		arg_12_0.playAnimation:set(1, true)
		audio.playEffectWithWeekBGM("square.mp3")
	end, arg_12_0.skillDatas:atproxy(arg_12_0.selectSkill:read()).id)
end

function var_0_2.onFrameItemClick(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	arg_14_0.selectSkill:set(arg_14_2.k)
end

function var_0_2.setRightPanel(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0.rightPanel:multiget("title", "pos", "icon", "level", "mask", "levelOld", "levelNew", "addOld", "addNew", "limit", "cost", "costNote", "costIcon", "condition", "coin", "coinBg", "coinIcon", "btnPractice", "limitNote")

	var_15_0.coin:text(arg_15_2)

	local var_15_1 = arg_15_2 < 100000 and 264 or (90 + var_15_0.coin:size().width) * 1.33

	var_15_0.coinIcon:x(var_15_0.coinBg:x() - var_15_1 * 0.75 + 20)
	var_15_0.coinBg:size(var_15_1, 80)

	local var_15_2 = arg_15_0.skillDatas:atproxy(arg_15_1)
	local var_15_3 = gUnionSkillCsv[arg_15_1]
	local var_15_4 = csv.union.union_skill[arg_15_1]

	var_15_0.level:text("Lv" .. var_15_2.level):visible(var_15_2.unlocked == 1)
	text.addEffect(var_15_0.level, {
		outline = {
			color = ui.NEWCOLORS.OUTLINE.BLACK
		}
	})

	local var_15_5 = csv.union.union_level
	local var_15_6 = csvSize(var_15_5)
	local var_15_7 = var_15_5[arg_15_0.unionLevel:read()].skillLvMax
	local var_15_8 = var_15_2.level >= var_15_5[var_15_6].skillLvMax
	local var_15_9 = var_15_8 and var_15_2.level or var_15_2.level + 1

	var_15_0.title:text(var_15_2.name)
	var_15_0.icon:texture(var_15_2.icon)
	var_15_0.mask:visible(var_15_2.unlocked == 2)
	var_15_0.levelOld:text(var_15_2.level)
	var_15_0.levelNew:text(var_15_9)
	var_15_0.addOld:text(dataEasy.getAttrValueString(var_15_4.attrType, var_15_3[var_15_2.level].attrValue))
	var_15_0.addNew:text(dataEasy.getAttrValueString(var_15_4.attrType, var_15_3[var_15_9].attrValue))

	local var_15_10 = var_15_3[var_15_2.level].cost.coin3

	arg_15_0.lackCoin3 = arg_15_2 < var_15_10

	local var_15_11 = var_15_7 <= var_15_2.level
	local var_15_12 = ""

	if not var_15_8 then
		var_15_12 = "  " .. gLanguageCsv.unionSkillLimitTip
	end

	var_15_0.limit:text(var_15_7 .. var_15_12)
	nodetools.invoke(arg_15_0.rightPanel, {
		"levelNew",
		"addNew",
		"addArrow",
		"levelArrow"
	}, var_15_8 and "hide" or "show")

	local var_15_13 = var_15_2.unlocked == 2 or var_15_8 or var_15_11

	uiEasy.setBtnShader(var_15_0.btnPractice, var_15_0.btnPractice:get("title"), var_15_13 and 2 or 1)

	if not var_15_13 then
		text.addEffect(var_15_0.btnPractice:get("title"), {
			outline = {
				size = 4,
				color = ui.NEWCOLORS.OUTLINE.YELLOW1
			}
		})
	else
		text.deleteAllEffect(var_15_0.btnPractice:get("title"))
	end

	var_0_0(var_15_0, arg_15_2, var_15_10)
	arg_15_0:setUnlockTxt(var_15_0, arg_15_1)
end

function var_0_2.setUnlockTxt(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0.skillDatas:atproxy(arg_16_2)
	local var_16_1 = csv.union.union_skill[var_16_0.id]
	local var_16_2 = var_16_1.attrNatureType
	local var_16_3 = var_16_2 == 0 and gLanguageCsv.allSprite or string.format(gLanguageCsv.someSprite, gLanguageCsv[game.NATURE_TABLE[var_16_2]])

	var_0_1(string.format(gLanguageCsv.toProvideAddition, var_16_3, getLanguageAttr(var_16_1.attrType)), arg_16_1.pos)

	local var_16_4 = ""

	if var_16_1.needGuildLv > 0 then
		var_16_4 = string.format(gLanguageCsv.guildReachLevelUnlock, var_16_1.needGuildLv)
	end

	if var_16_1.preSkill[1] ~= nil and arg_16_0.skillDatas:atproxy(var_16_1.preSkill[1]).level < var_16_1.preSkill[2] then
		var_16_4 = string.format(gLanguageCsv.skillReachedLevelUnlock, arg_16_0.skillDatas:atproxy(var_16_1.preSkill[1]).name, var_16_1.preSkill[2])
	end

	arg_16_1.condition:text(var_16_4):visible(var_16_0.unlocked == 2):x(arg_16_1.limitNote:x())
end

function var_0_2.onAfterBuild(arg_17_0)
	uiEasy.setBottomMask(arg_17_0.list, arg_17_0.maskPanel)
end

return var_0_2
