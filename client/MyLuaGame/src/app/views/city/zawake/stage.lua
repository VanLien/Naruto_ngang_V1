local var_0_0 = require("app.views.city.zawake.tools")
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("ZawakeStageView", var_0_1)

var_0_2.RESOURCE_FILENAME = "zawake_stage.json"
var_0_2.RESOURCE_BINDING = {
	["rightPanel.infoPanel.downPanel"] = "downPanel",
	["rightPanel.costPanel"] = "costPanel",
	["rightPanel.skillPanel"] = "skillPanel",
	["rightPanel.activateItem"] = "activateItem",
	["rightPanel.costItem"] = "costItem",
	["rightPanel.effectPanel"] = "effectPanel",
	["rightPanel.infoPanel.list"] = "list",
	["rightPanel.infoPanel.bg"] = "bg",
	leftPanel = "leftPanel",
	["rightPanel.infoPanel.downPanel.awakeImg"] = "awakeImg",
	["rightPanel.infoPanel"] = "infoPanel",
	["rightPanel.infoPanel.titlePanel"] = "titlePanel",
	["rightPanel.effectItem"] = "effectItem",
	["rightPanel.infoPanel.downPanel.txt"] = "awakeTxt",
	["rightPanel.effectInnerList"] = "effectInnerList",
	["rightPanel.activatePanel"] = "activatePanel",
	rightPanel = "rightPanel",
	["rightPanel.infoPanel.downPanel.awakeBtn"] = {
		varname = "awakeBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAwakeClick")
			}
		}
	}
}

function var_0_2.onCreate(arg_1_0, arg_1_1)
	gGameUI.topuiManager:createView("default", arg_1_0, {
		onClose = arg_1_0:createHandler("onClose")
	}):init({
		subTitle = "AWAKENING TRAINING",
		title = gLanguageCsv.zawakeDevelop
	})
	arg_1_0:initModel()

	arg_1_0.zawakeID = arg_1_1.zawakeID
	arg_1_0.stageID = arg_1_1.stage
	arg_1_0.levelCfg = {}

	for iter_1_0 = 1, var_0_0.MAXSTAGE do
		local var_1_0 = arg_1_0.leftPanel:get("stage" .. iter_1_0)

		if arg_1_0.stageID == iter_1_0 then
			var_1_0:show()

			arg_1_0.stagePanel = var_1_0

			for iter_1_1 = 1, var_0_0.MAXLEVEL do
				local var_1_1 = var_1_0:get("level" .. iter_1_1):get("item")

				var_1_1:get("select"):hide()
				var_1_1:get("icon"):texture(string.format("city/zawake/machine/icon_0%s_machine%s.png", iter_1_1, iter_1_0))
				var_1_1:get("icon"):scale(1.6)
				label.create(iter_1_1, {
					fontSize = 38,
					fontPath = "font/youmi.ttf",
					color = ui.COLORS.NORMAL.WHITE,
					effect = {
						outline = {
							size = 3,
							color = ui.COLORS.NORMAL.DEFAULT
						}
					}
				}):addTo(var_1_1, 15, "num"):xy(var_1_1:width() / 2, 30)
				bind.click(arg_1_0, var_1_1, {
					method = function()
						arg_1_0:onSelectClick(iter_1_1)
					end
				})

				arg_1_0.levelCfg[iter_1_1] = var_0_0.getLevelCfg(arg_1_0.zawakeID, arg_1_0.stageID, iter_1_1)
			end
		else
			var_1_0:hide()
		end
	end

	arg_1_0.list:setScrollBarEnabled(false)
	idlereasy.when(arg_1_0.zawake, function(arg_3_0, arg_3_1)
		arg_3_1 = arg_3_1 or {}

		local var_3_0 = (arg_3_1[arg_1_0.zawakeID] or {})[arg_1_0.stageID] or 0

		arg_1_0.level = var_3_0

		arg_1_0:updateSpine(arg_1_0.stagePanel:get("pos"), var_3_0)

		for iter_3_0 = 1, var_0_0.MAXLEVEL do
			arg_1_0:updateLevelPanel(iter_3_0)
		end

		if arg_1_0.selectLevel:read() == 0 then
			arg_1_0:onSelectClick(var_0_0.MAXLEVEL)
		end
	end)
	arg_1_0.selectLevel:addListener(function(arg_4_0, arg_4_1)
		if arg_4_1 > 0 then
			arg_1_0.stagePanel:get("level" .. arg_4_1):get("item.select"):hide()
		end

		if arg_4_0 > 0 then
			arg_1_0.stagePanel:get("level" .. arg_4_0):get("item.select"):show()
		end
	end)
end

function var_0_2.updateLevelPanel(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.level
	local var_5_1 = arg_5_0.stagePanel:get("level" .. arg_5_1)

	var_5_1:get("line1"):visible(arg_5_1 <= var_5_0)

	local var_5_2 = var_5_1:get("item")
	local var_5_3 = var_5_2:get("nextDi1")

	var_5_2:get("nextDi"):visible(arg_5_1 <= var_5_0)
	var_5_2:get("mask"):visible(var_5_0 < arg_5_1)
	var_5_3:stopAllActions()

	local var_5_4 = var_5_2:get("awakenable")

	var_5_4:hide()
	var_5_4:removeChildByName("effect")

	if arg_5_1 == var_5_0 + 1 then
		if arg_5_0.selectLevel:read() == 0 then
			arg_5_0:onSelectClick(arg_5_1)
		end

		var_5_3:show()

		local var_5_5 = transition.sequence({
			cc.FadeTo:create(1, 50),
			cc.FadeTo:create(1, 255)
		})
		local var_5_6 = cc.RepeatForever:create(var_5_5)

		var_5_3:runAction(var_5_6)

		if var_0_0.canAwake(arg_5_0.zawakeID, arg_5_0.stageID, arg_5_1) then
			var_5_4:show()
			arg_5_0:createAwakenabelSpine(var_5_4)
		end
	else
		var_5_3:hide()
	end
end

function var_0_2.initModel(arg_6_0)
	arg_6_0.zawake = gGameModel.role:getIdler("zawake")
	arg_6_0.items = gGameModel.role:getIdler("items")
	arg_6_0.frags = gGameModel.role:getIdler("frags")
	arg_6_0.zfrags = gGameModel.role:getIdler("zfrags")
	arg_6_0.listHeight = idler.new(0)
	arg_6_0.selectLevel = idler.new(0)
	arg_6_0.level = 0
end

function var_0_2.onUpdateLevelInfo(arg_7_0, arg_7_1)
	local var_7_0 = (arg_7_0.zawake:read() or {})[arg_7_0.zawakeID] or {}

	arg_7_0.infoPanel:get("titlePanel.txt"):text(gLanguageCsv["symbolRome" .. arg_7_0.stageID])
	arg_7_0.infoPanel:get("titlePanel.txtLevel"):text(string.format("- %s", arg_7_1))
	adapt.oneLinePos(arg_7_0.infoPanel:get("titlePanel.txt"), arg_7_0.infoPanel:get("titlePanel.txtLevel"), cc.p(-7, 0))

	local var_7_1

	if arg_7_0.stageID ~= 1 or arg_7_1 ~= 1 then
		local var_7_2 = arg_7_0.stageID
		local var_7_3 = arg_7_1 - 1

		if var_7_3 == 0 then
			var_7_2 = var_7_2 - 1
			var_7_3 = var_0_0.MAXLEVEL
		end

		if var_7_3 > (var_7_0[var_7_2] or 0) then
			var_7_1 = string.format("%s- %s", gLanguageCsv["symbolRome" .. var_7_2], var_7_3)
		end
	end

	itertools.invoke({
		arg_7_0.awakeImg,
		arg_7_0.awakeBtn,
		arg_7_0.awakeTxt
	}, "hide")

	if var_7_1 then
		arg_7_0.awakeTxt:show():text(string.format(gLanguageCsv.zawakeLevelCondition, var_7_1))
	elseif arg_7_1 <= (var_7_0[arg_7_0.stageID] or 0) then
		arg_7_0.awakeImg:show()
	else
		arg_7_0.awakeBtn:show()
	end

	arg_7_0.list:removeAllItems()
	arg_7_0:updateListHeight(0, true)
	arg_7_0:updateEffectPanel(arg_7_1)
	arg_7_0:updateSkillAttrPanel(arg_7_1)
	arg_7_0:updateActivatePanel(arg_7_1)
	arg_7_0:updateCostPanel(arg_7_1)
	arg_7_0:adaptBgPanel()
end

function var_0_2.updateListHeight(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_2 then
		arg_8_0.listHeight:set(arg_8_1, true)
	else
		arg_8_0.listHeight:modify(function(arg_9_0)
			return true, arg_9_0 + arg_8_1
		end)
	end
end

function var_0_2.adaptBgPanel(arg_10_0)
	local var_10_0 = arg_10_0.listHeight:read()
	local var_10_1 = arg_10_0.downPanel:height() + arg_10_0.titlePanel:height() + 20
	local var_10_2 = math.min(var_10_0 + var_10_1, 1250)
	local var_10_3 = var_10_2 - var_10_1

	arg_10_0.list:height(var_10_3)
	arg_10_0.bg:height(var_10_2)
	arg_10_0.infoPanel:height(var_10_2)
	arg_10_0.infoPanel:y(50 + (1250 - var_10_2) / 2)
	arg_10_0.titlePanel:y(1155 - (1250 - var_10_2))
end

function var_0_2.updateEffectPanel(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.effectPanel:clone():show()

	var_11_0:get("titlePanel.txt"):text(var_0_0.getAttrAddTypeStr(arg_11_0.levelCfg[arg_11_1].attrAddType, arg_11_0.levelCfg[arg_11_1].natureType))

	local var_11_1 = {}

	for iter_11_0 = 1, math.huge do
		local var_11_2 = arg_11_0.levelCfg[arg_11_1]["attrType" .. iter_11_0]
		local var_11_3 = arg_11_0.levelCfg[arg_11_1]["attrNum" .. iter_11_0]

		if var_11_2 == nil or var_11_2 == 0 then
			break
		end

		table.insert(var_11_1, {
			key = getLanguageAttr(var_11_2),
			val = "+" .. dataEasy.getAttrValueString(var_11_2, var_11_3)
		})
	end

	local var_11_4 = math.ceil(#var_11_1 / 2) * arg_11_0.effectInnerList:height()
	local var_11_5 = var_11_0:get("list")
	local var_11_6 = var_11_0:get("titlePanel")
	local var_11_7 = var_11_6:height()

	var_11_5:height(var_11_4)
	var_11_6:y(var_11_4 + var_11_7)
	var_11_0:height(var_11_4 + var_11_7 + 20)
	bind.extend(arg_11_0, var_11_0:get("list"), {
		class = "tableview",
		props = {
			columnSize = 2,
			data = var_11_1,
			item = bindHelper.self("effectInnerList"),
			cell = bindHelper.self("effectItem"),
			onCell = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				local var_12_0 = arg_12_1:get("keyText")

				var_12_0:text(arg_12_3.key)

				local var_12_1 = arg_12_1:get("valText")

				var_12_1:text(arg_12_3.val)
				adapt.oneLinePos(var_12_0, var_12_1, cc.p(10, 0))
			end
		}
	})
	arg_11_0.list:pushBackCustomItem(var_11_0)
	arg_11_0:updateListHeight(var_11_0:height())
end

function var_0_2.updateSkillAttrPanel(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.levelCfg[arg_13_1]
	local var_13_1 = var_0_0.getSkillCfg(arg_13_0.zawakeID, var_13_0.skillID)

	if var_13_1 then
		for iter_13_0, iter_13_1 in ipairs(var_13_1) do
			local var_13_2 = arg_13_0.skillPanel:clone():show()

			arg_13_0.list:pushBackCustomItem(var_13_2)

			local var_13_3 = var_13_2:multiget("title", "skill", "skillText", "name", "iconUp", "infoBtn")

			uiEasy.setSkillInfoToItems({
				name = var_13_3.name,
				icon = var_13_3.skill,
				type1 = var_13_3.skillText
			}, iter_13_1.cfg)
			var_13_3.name:text(csv.skill[var_13_0.skillID].skillName .. var_13_3.name:text())
			adapt.setTextScaleWithWidth(var_13_3.name, nil, 230)
			adapt.oneLinePos(var_13_3.title, var_13_3.skill, cc.p(5, 0))
			adapt.oneLinePos(var_13_3.skill, var_13_3.skillText, cc.p(60, 0))
			adapt.oneLinePos(var_13_3.skillText, var_13_3.name, cc.p(20, 0))
			adapt.oneLinePos(var_13_3.name, var_13_3.infoBtn, cc.p(10, 0))
			var_13_3.iconUp:x(var_13_3.skill:x() + 60)
			arg_13_0:updateListHeight(var_13_2:height())
			bind.touch(arg_13_0, var_13_3.infoBtn, {
				methods = {
					ended = function()
						local var_14_0 = gGameUI:stackUI("common.skill_detail", nil, {
							clickClose = true,
							dispatchNodes = list
						}, {
							isZawake = true,
							star = 12,
							skillLevel = 1,
							skillId = iter_13_1.id,
							cardId = iter_13_1.cardId
						}):getResourceNode()
						local var_14_1, var_14_2 = var_14_0:xy()

						var_14_0:xy(var_14_1 + 1020, var_14_2)
					end
				}
			})
		end
	end

	if csvSize(var_13_0.extraAttrs) > 0 then
		local var_13_4 = arg_13_0.effectPanel:clone():show()

		var_13_4:get("titlePanel.txt"):hide()

		local var_13_5 = ""

		if var_13_0.extraScene[1] == 0 then
			var_13_4:get("titlePanel.title"):text(gLanguageCsv.zawakeExtraAttr)
		else
			var_13_4:get("titlePanel.title"):text(gLanguageCsv.zawakeExtraScene)

			local var_13_6 = {}

			for iter_13_2, iter_13_3 in ipairs(var_13_0.extraScene) do
				table.insert(var_13_6, gLanguageCsv[game.SCENE_TYPE_STRING_TABLE[iter_13_3]])
			end

			var_13_5 = table.concat(var_13_6, gLanguageCsv.symbolComma) .. "\n"
		end

		local var_13_7 = {}

		for iter_13_4, iter_13_5 in csvMapPairs(var_13_0.extraAttrs) do
			table.insert(var_13_7, getLanguageAttr(iter_13_4) .. "+" .. dataEasy.getAttrValueString(iter_13_4, iter_13_5))
		end

		local var_13_8 = string.format("#C0xF76B45#\t%s\t%s", var_13_5, table.concat(var_13_7, "  "))
		local var_13_9 = var_13_4:get("list")
		local var_13_10 = var_13_4:get("titlePanel")
		local var_13_11 = var_13_10:height()
		local var_13_12, var_13_13 = beauty.textScroll({
			isRich = true,
			fontSize = 40,
			list = var_13_9,
			strs = var_13_8
		})

		var_13_9:setTouchEnabled(false)
		var_13_9:height(var_13_13)
		var_13_10:y(var_13_13 + var_13_11)
		var_13_4:height(var_13_13 + var_13_11 + 20)
		arg_13_0.list:pushBackCustomItem(var_13_4)
		arg_13_0:updateListHeight(var_13_4:height())
	end
end

function var_0_2.updateActivatePanel(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.levelCfg[arg_15_1]
	local var_15_1, var_15_2 = var_0_0.getActiveCondition(arg_15_0.zawakeID, arg_15_0.stageID, var_15_0)

	if itertools.isempty(var_15_2) then
		return
	end

	local var_15_3 = gLanguageCsv.zawakeActivateAttrs

	if var_15_0.skillID > 0 then
		var_15_3 = gLanguageCsv.zawakeActivateSkillID
	elseif var_15_0.extraScene[1] ~= 0 then
		var_15_3 = gLanguageCsv.zawakeActivateScene
	end

	local var_15_4 = arg_15_0.activatePanel:clone():show()

	var_15_4:get("titlePanel.title"):text(var_15_3)

	local var_15_5 = var_15_4:get("titlePanel")
	local var_15_6 = var_15_5:height()
	local var_15_7 = 0

	bind.extend(arg_15_0, var_15_4:get("list"), {
		class = "listview",
		props = {
			data = var_15_2,
			item = bindHelper.self("activateItem"),
			onItem = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				local var_16_0 = rich.createWithWidth(arg_16_3, 42, nil, 920):anchorPoint(0, 0.5):x(0):addTo(arg_16_1)
				local var_16_1 = var_16_0:height() + 8

				arg_16_1:height(var_16_1)
				var_16_0:y(arg_16_1:height() / 2)

				var_15_7 = var_15_7 + arg_16_1:height()
			end,
			onAfterBuild = function(arg_17_0)
				arg_17_0:height(var_15_7)
				var_15_5:y(var_15_7 + var_15_6)
				var_15_4:height(var_15_7 + var_15_6 + 20)
				arg_15_0:updateListHeight(var_15_4:height())
				arg_15_0:adaptBgPanel()
			end
		}
	})
	arg_15_0.list:pushBackCustomItem(var_15_4)
end

function var_0_2.updateCostPanel(arg_18_0, arg_18_1)
	if arg_18_1 <= arg_18_0.level then
		return
	end

	local var_18_0 = arg_18_0.costPanel:clone():show()

	arg_18_0.list:pushBackCustomItem(var_18_0)
	arg_18_0:updateListHeight(var_18_0:height())
	idlereasy.any({
		arg_18_0.zfrags,
		arg_18_0.items,
		arg_18_0.frags
	}, function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
		local var_19_0 = {}

		for iter_19_0, iter_19_1 in csvMapPairs(arg_18_0.levelCfg[arg_18_1].costItemMap) do
			table.insert(var_19_0, {
				key = iter_19_0,
				needVal = iter_19_1,
				val = dataEasy.getNumByKey(iter_19_0),
				showBtn = dataEasy.isZawakeFragment(iter_19_0)
			})
		end

		table.sort(var_19_0, function(arg_20_0, arg_20_1)
			if arg_20_0.showBtn ~= arg_20_1.showBtn then
				return arg_20_0.showBtn
			end

			return dataEasy.sortItemCmp(arg_20_0, arg_20_1)
		end)
		bind.extend(arg_18_0, var_18_0:get("list"), {
			class = "listview",
			props = {
				data = var_19_0,
				item = bindHelper.self("costItem"),
				onItem = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
					local var_21_0 = arg_21_1:multiget("icon", "addPanel", "exchangeBtn")
					local var_21_1 = arg_21_3.val < arg_21_3.needVal

					var_21_0.addPanel:visible(var_21_1)
					var_21_0.exchangeBtn:visible(arg_21_3.showBtn)
					bind.extend(arg_21_0, var_21_0.icon, {
						class = "icon_key",
						props = {
							noListener = true,
							data = {
								key = arg_21_3.key,
								num = arg_21_3.val,
								targetNum = arg_21_3.needVal
							},
							grayState = var_21_1 and 1 or 0,
							onNode = function(arg_22_0)
								arg_22_0:setTouchEnabled(false)
							end
						}
					})
					var_21_0.icon:setTouchEnabled(true)
					bind.click(arg_21_0, var_21_0.icon, {
						method = function(arg_23_0, arg_23_1, arg_23_2)
							gGameUI:stackUI("common.gain_way", nil, nil, arg_21_3.key, nil, arg_21_3.needVal)
						end
					})
					bind.touch(arg_21_0, var_21_0.exchangeBtn, {
						methods = {
							ended = function(arg_24_0, arg_24_1, arg_24_2)
								gGameUI:stackUI("city.zawake.debris", nil, nil, {
									fragID = arg_21_3.key,
									needNum = arg_21_3.needVal
								})
							end
						}
					})
				end
			}
		})
		arg_18_0:updateLevelPanel(math.min(arg_18_0.level + 1, var_0_0.MAXLEVEL))
	end):anonyOnly(arg_18_0)
end

function var_0_2.createAwakenabelSpine(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_1:size()
	local var_25_1 = widget.addAnimationByKey(arg_25_1, "zawake/zujian.skel", "effect", "effect_loop", 2)

	var_25_1:play("effect_loop")
	var_25_1:xy(var_25_0.width / 2, var_25_0.height / 2)
end

function var_0_2.updateSpine(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = {
		2.35,
		1.7,
		2.2,
		2.1,
		2,
		2,
		2,
		1.7
	}
	local var_26_1 = {
		0,
		100,
		0,
		100,
		90,
		110,
		100,
		0
	}
	local var_26_2 = string.format("zawake/jiqi_%s.skel", arg_26_0.stageID)
	local var_26_3 = "effect_posun_loop"

	if arg_26_2 > 0 then
		var_26_3 = "effect_xiufu_loop" .. arg_26_2
	end

	local var_26_4 = widget.addAnimationByKey(arg_26_1, var_26_2, "effect", var_26_3, 5)

	var_26_4:scale(var_26_0[arg_26_0.stageID])
	var_26_4:play(var_26_3)
	var_26_4:xy(0, var_26_1[arg_26_0.stageID])

	if arg_26_0.stageID == 4 then
		local var_26_5 = widget.addAnimationByKey(arg_26_1, var_26_2, "houEffect", "effect_hou_loop", 2)

		var_26_5:scale(var_26_0[arg_26_0.stageID])
		var_26_5:play("effect_hou_loop")
		var_26_5:xy(0, var_26_1[arg_26_0.stageID])
	elseif arg_26_0.stageID == 7 then
		local var_26_6 = widget.addAnimationByKey(arg_26_1, "zawake/jiqi_7_hou.skel", "houEffect", var_26_3, 2)

		var_26_6:scale(var_26_0[arg_26_0.stageID])
		var_26_6:play(var_26_3)
		var_26_6:xy(0, var_26_1[arg_26_0.stageID])
	end
end

function var_0_2.onSelectClick(arg_27_0, arg_27_1)
	arg_27_0.selectLevel:set(arg_27_1)
	arg_27_0:onUpdateLevelInfo(arg_27_1)
end

function var_0_2.onAwakeClick(arg_28_0)
	if not var_0_0.canAwake(arg_28_0.zawakeID, arg_28_0.stageID, arg_28_0.selectLevel:read()) then
		gGameUI:showTip(gLanguageCsv.zawakeItemsLess)

		return
	end

	local var_28_0 = arg_28_0.level
	local var_28_1 = math.min(var_28_0 + 1, var_0_0.MAXLEVEL)
	local var_28_2 = math.min(var_28_0 + 2, var_0_0.MAXLEVEL)

	gGameApp:requestServer("/game/card/zawake/strength", function(arg_29_0)
		local var_29_0 = {
			zawakeID = arg_28_0.zawakeID,
			level = var_28_0,
			stageID = arg_28_0.stageID,
			cfg = arg_28_0.levelCfg[var_28_1],
			cb = function()
				arg_28_0:onSelectClick(var_28_2)
			end
		}

		gGameUI:stackUI("city.zawake.awake_success", nil, {
			blackLayer = true
		}, var_29_0)
	end, arg_28_0.zawakeID, arg_28_0.stageID, var_28_1)
end

return var_0_2
