local var_0_0 = class("CardEquipSignetView", cc.load("mvc").ViewBase)
local var_0_1 = require("app.views.city.card.equip.view")
local var_0_2 = {
	AWAKE = 2,
	STAR = 1
}
local var_0_3 = 5
local var_0_4 = {
	[0] = "city/card/equip/icon_hui.png",
	"city/card/equip/icon_lv.png",
	"city/card/equip/icon_qianlan.png",
	"city/card/equip/icon_lan.png",
	"city/card/equip/icon_qianzi.png",
	"city/card/equip/icon_zi.png",
	"city/card/equip/icon_huang.png",
	"city/card/equip/icon_cheng.png",
	"city/card/equip/icon_hong.png",
	"city/card/equip/icon_shenhong.png"
}
local var_0_5 = {
	[0] = "city/card/equip/bar_hui.png",
	"city/card/equip/bar_lv.png",
	"city/card/equip/bar_qianlan.png",
	"city/card/equip/bar_lan.png",
	"city/card/equip/bar_qianzi.png",
	"city/card/equip/bar_zi.png",
	"city/card/equip/bar_huang.png",
	"city/card/equip/bar_cheng.png",
	"city/card/equip/bar_hong.png",
	"city/card/equip/bar_shenhong.png"
}

var_0_0.RESOURCE_FILENAME = "card_equip_signet.json"
var_0_0.RESOURCE_BINDING = {
	["panel.bottomPanel.list"] = "list",
	["panel.qualityItem.leftQuality"] = "leftQuality",
	["panel.passiveDetail"] = "passiveDetail",
	panel = "panel",
	["panel.bottomPanel.icon"] = "icon",
	["panel.circle"] = "circle",
	["panel.pos"] = "pos",
	["panel.bottomPanel.cost"] = "cost",
	["panel.bottomPanel.itemPanel"] = "itemPanel",
	item = "item",
	["panel.qualityItem"] = "qualityItem",
	["panel.bottomPanel.txt"] = "txt",
	["panel.bottomPanel.panel"] = "iconPanel",
	["panel.max"] = "max",
	["panel.bottomPanel"] = "bottomPanel",
	["panel.qualityItem.rightQuality"] = "rightQuality",
	["panel.btnDown"] = {
		varname = "btnDown",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDown")
			}
		}
	},
	["panel.listAttr"] = {
		varname = "listAttr",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("item"),
				levelItem = bindHelper.self("levelItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("name", "left", "right", "arrow")

					var_1_0.name:text(arg_1_3.name .. ":")
					var_1_0.left:text("+" .. arg_1_3.num)
					var_1_0.arrow:visible(not arg_1_3.isAdvance)
					var_1_0.right:visible(not arg_1_3.isAdvance)
					var_1_0.right:text("+" .. arg_1_3.nextNum):visible(not arg_1_3.isMax)
					var_1_0.arrow:visible(not arg_1_3.isMax)
					adapt.oneLinePos(var_1_0.name, {
						var_1_0.left,
						var_1_0.arrow,
						var_1_0.right
					}, cc.p(30, 0))
				end
			}
		}
	},
	["panel.bottomPanel.btnUpgrade"] = {
		varname = "btnUpgrade",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSignet")
			}
		}
	},
	["panel.bottomPanel.onekeyUpgrade"] = {
		varname = "onekeyUpgrade",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onSignetOneKey")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("oneKeyVisible")
			}
		}
	},
	["panel.bottomPanel.btnUpgrade.textNote"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["panel.bottomPanel.onekeyUpgrade.textNote"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["panel.btnInfo"] = {
		varname = "btnInfo",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnDetailClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1)
	arg_2_0.selectDbId, arg_2_0.equipIndex = arg_2_1()

	arg_2_0:initModel()

	arg_2_0.spine = widget.addAnimation(arg_2_0.pos, "effect/shipinfaguang.skel", "effect_loop", 20):scale(0.75):xy(-55, 50)
	arg_2_0.attrDatas = idlers.newWithMap({})
	arg_2_0.csvSignetAdvance = {}

	arg_2_0:initCsvSignet()

	arg_2_0.callBackSign = false
	arg_2_0.refreshDelayNums = 0

	local var_2_0 = arg_2_0.btnUpgrade:x()

	arg_2_0.oneKeyUnlock = false
	arg_2_0.oneKeyVisible = idler.new()

	dataEasy.getListenUnlock(gUnlockCsv.oneKeySignet, function(arg_3_0)
		arg_2_0.oneKeyUnlock = arg_3_0

		arg_2_0.oneKeyVisible:set(arg_3_0)
	end)
	idlereasy.when(arg_2_0.oneKeyVisible, function(arg_4_0, arg_4_1)
		if arg_2_0.oneKeyUnlock then
			local var_4_0 = arg_4_1 and var_2_0 or arg_2_0.iconPanel:x()

			arg_2_0.btnUpgrade:x(var_4_0)
		else
			arg_2_0.btnUpgrade:x(arg_2_0.iconPanel:x())
		end
	end)
	idlereasy.any({
		arg_2_0.equips,
		arg_2_0.equipIndex,
		arg_2_0.gold
	}, function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		arg_2_0.speedBtn = true

		local function var_5_0()
			arg_2_0:refreshData()

			if arg_2_0.callBackSign then
				arg_2_0.callBackSign = false

				for iter_6_0, iter_6_1 in pairs(arg_2_0.listAttr:getChildren()) do
					local var_6_0 = iter_6_1:get("spine")

					if not var_6_0 then
						var_6_0 = widget.addAnimationByKey(iter_6_1, "effect/shuzisaoguang.skel", "spine", "effect", 122):xy(iter_6_1:size().width / 2, iter_6_1:size().height / 2 + 5):scale(0.5)
					else
						var_6_0:play("effect")
					end
				end

				arg_2_0:playSpine(1)
			end
		end

		if not arg_2_0.callBackSign then
			arg_2_0:refreshData()
		else
			if arg_2_0.refreshDelayNums == 0 then
				performWithDelay(arg_2_0, function()
					var_5_0()
				end, 0.016666666666666666)
			end

			arg_2_0.refreshDelayNums = arg_2_0.refreshDelayNums + 1
		end
	end)
end

function var_0_0.initModel(arg_8_0)
	idlereasy.when(arg_8_0.selectDbId, function(arg_9_0, arg_9_1)
		local var_9_0 = gGameModel.cards:find(arg_9_1)

		arg_8_0.equips = idlereasy.assign(var_9_0:getIdler("equips"), arg_8_0.equips)
		arg_8_0.fight = idlereasy.assign(var_9_0:getIdler("fighting_point"), arg_8_0.fight)
	end)

	arg_8_0.level = gGameModel.role:getIdler("level")
	arg_8_0.gold = gGameModel.role:getIdler("gold")
	arg_8_0.rmb = gGameModel.role:getIdler("rmb")
end

function var_0_0.initCsvSignet(arg_10_0)
	for iter_10_0, iter_10_1 in csvPairs(csv.base_attribute.equip_signet_advance) do
		if arg_10_0.csvSignetAdvance[iter_10_1.advanceIndex] == nil then
			arg_10_0.csvSignetAdvance[iter_10_1.advanceIndex] = {}
		end

		arg_10_0.csvSignetAdvance[iter_10_1.advanceIndex][iter_10_1.advanceLevel] = iter_10_1
	end
end

function var_0_0.refreshData(arg_11_0)
	local var_11_0 = arg_11_0.equips:read()
	local var_11_1 = arg_11_0.equipIndex:read()
	local var_11_2 = arg_11_0.gold:read()
	local var_11_3 = var_11_0[var_11_1]
	local var_11_4 = csv.equips[var_11_3.equip_id]
	local var_11_5 = var_11_3.signet or 0
	local var_11_6 = var_11_3.signet_advance or 0
	local var_11_7 = 0
	local var_11_8 = 0
	local var_11_9 = 0
	local var_11_10 = var_11_5 - var_11_6 * var_0_3

	arg_11_0.refreshDelayNums = 0
	arg_11_0.data = var_11_3
	arg_11_0.isEnoughItem = true
	arg_11_0.signetMax = var_0_3 * var_11_4.signetAdvanceMax or 0

	if var_11_5 > 0 then
		arg_11_0.btnDown:texture("city/card/equip/icon_kyjj.png")
	else
		arg_11_0.btnDown:texture("city/card/equip/icon_kyjj1.png")
	end

	arg_11_0.passiveDetail:visible(var_11_10 == var_0_3)
	arg_11_0.bottomPanel:visible(var_11_6 < var_11_4.signetAdvanceMax)
	arg_11_0.max:visible(var_11_6 == var_11_4.signetAdvanceMax)
	arg_11_0:refreshCircle(var_11_6, var_11_10)
	itertools.invoke({
		arg_11_0.cost,
		arg_11_0.icon,
		arg_11_0.txt
	}, "hide")
	text.addEffect(arg_11_0.cost, {
		color = ui.COLORS.NORMAL.WHITE
	})

	local var_11_11 = arg_11_0.csvSignetAdvance[var_11_4.advanceIndex][var_11_6]
	local var_11_12 = arg_11_0.csvSignetAdvance[var_11_4.advanceIndex][var_11_6 + 1]
	local var_11_13 = var_11_11.advanceName
	local var_11_14 = var_11_11.advanceName
	local var_11_15 = var_11_10 + 1

	if var_11_10 == var_0_3 then
		var_11_14 = var_11_12.advanceName
		var_11_15 = 0
	end

	local var_11_16 = arg_11_0.qualityItem:multiget("leftQuality", "rightQuality", "arrow")

	var_11_16.leftQuality:text(var_11_13 .. " " .. var_11_10 .. gLanguageCsv.signetLevel)
	var_11_16.rightQuality:text(var_11_14 .. " " .. var_11_15 .. gLanguageCsv.signetLevel)
	var_11_16.arrow:visible(var_11_5 < arg_11_0.signetMax)
	var_11_16.rightQuality:visible(var_11_5 < arg_11_0.signetMax)

	if matchLanguage({
		"kr"
	}) then
		adapt.oneLinePos(var_11_16.leftQuality, {
			var_11_16.arrow,
			var_11_16.rightQuality
		}, cc.p(20, 0))
	else
		adapt.oneLinePos(var_11_16.leftQuality, {
			var_11_16.arrow,
			var_11_16.rightQuality
		}, cc.p(30, 0))
	end

	if var_11_5 == arg_11_0.signetMax then
		adapt.oneLinePos(var_11_16.leftQuality, arg_11_0.btnInfo, cc.p(520, 0))
	else
		adapt.oneLinePos(var_11_16.leftQuality, arg_11_0.btnInfo, cc.p(750, 0))
	end

	arg_11_0:initAttr(var_11_5, var_11_6, var_11_4)

	local var_11_17 = 0

	if var_11_6 == var_11_4.signetAdvanceMax then
		arg_11_0:refreshCircle(var_11_6 - 1, var_0_3)

		local var_11_18 = arg_11_0.csvSignetAdvance[var_11_4.advanceIndex][var_11_6 - 1].advanceName

		var_11_16.leftQuality:text(var_11_18 .. " " .. var_0_3 .. gLanguageCsv.signetLevel)
	else
		local var_11_19 = csv.base_attribute.equip_signet[var_11_5]["costItemMap" .. var_11_4.signetStrengthSeqID]

		arg_11_0.btnUpgrade:get("textNote"):text(gLanguageCsv.signet)

		if arg_11_0.oneKeyUnlock then
			arg_11_0.oneKeyVisible:set(true)
		end

		arg_11_0.list:visible(true)
		arg_11_0.itemPanel:visible(false)

		if var_11_10 == var_0_3 then
			arg_11_0:setPassiveDetail(var_11_6, var_11_4)

			if var_11_12.advanceLimitType == var_0_2.STAR then
				if var_11_3.star < var_11_12.advanceLimitNum then
					arg_11_0.limitTip = string.format(gLanguageCsv.needEquipStar, var_11_12.advanceLimitNum)
				end
			elseif var_11_12.advanceLimitType == var_0_2.AWAKE then
				if var_11_3.awake < var_11_12.advanceLimitNum then
					arg_11_0.limitTip = gLanguageCsv.needEquipAwake .. gLanguageCsv["symbolRome" .. var_11_12.advanceLimitNum]
				end
			else
				arg_11_0.limitTip = 0
			end

			arg_11_0.btnUpgrade:get("textNote"):text(gLanguageCsv.advance)
			arg_11_0.oneKeyVisible:set(false)

			var_11_19 = csv.base_attribute.equip_signet_advance_cost[var_11_6]["costItemMap" .. var_11_12.advanceSeqID]
		end

		local var_11_20 = {}

		for iter_11_0, iter_11_1 in csvMapPairs(var_11_19) do
			if iter_11_0 ~= "gold" then
				local var_11_21 = dataEasy.getNumByKey(iter_11_0)

				if var_11_21 < iter_11_1 and arg_11_0.isEnoughItem then
					arg_11_0.isEnoughItem = false
				end

				table.insert(var_11_20, {
					key = iter_11_0,
					targetNum = iter_11_1,
					num = var_11_21,
					grayState = var_11_21 < iter_11_1 and 1 or 0
				})
				arg_11_0.itemPanel:get("btnAdd"):visible(false)
			else
				arg_11_0.isEnoughGold = iter_11_1 <= var_11_2

				arg_11_0.cost:text(iter_11_1)
				itertools.invoke({
					arg_11_0.cost,
					arg_11_0.icon,
					arg_11_0.txt
				}, "show")
				text.addEffect(arg_11_0.cost, {
					color = arg_11_0.isEnoughGold and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.ALERT_ORANGE
				})
				adapt.oneLineCenterPos(cc.p(arg_11_0.btnUpgrade:x(), arg_11_0.btnUpgrade:y() + 90), {
					arg_11_0.txt,
					arg_11_0.cost,
					arg_11_0.icon
				})
			end
		end

		var_11_17 = #var_11_20 or 0

		uiEasy.createItemsToList(arg_11_0, arg_11_0.list, var_11_20, {
			margin = 20,
			scale = 0.9,
			onAfterBuild = function(arg_12_0)
				arg_12_0:setItemAlignCenter()
				arg_12_0:setClippingEnabled(false)
			end,
			onNode = function(arg_13_0, arg_13_1)
				bind.click(arg_11_0.list, arg_13_0, {
					method = function()
						jumpEasy.jumpTo("gainWay", arg_13_1.key, nil, arg_13_1.targetNum)
					end
				})

				local var_13_0 = arg_13_0:size()
				local var_13_1 = arg_13_0:get("addIcon")

				if arg_13_1.targetNum > arg_13_1.num then
					if not var_13_1 then
						ccui.ImageView:create("common/btn/btn_add_icon.png"):xy(var_13_0.width / 2, var_13_0.height / 2):addTo(arg_13_0, 60, "addIcon")
					else
						var_13_1:show()
					end
				elseif var_13_1 then
					var_13_1:hide()
				end
			end
		})
		arg_11_0.list:y(180)
	end

	if var_11_5 == arg_11_0.signetMax then
		arg_11_0.btnDown:xy(arg_11_0.max:x() + 330, 350)
	else
		arg_11_0.btnDown:xy(arg_11_0.iconPanel:x() + var_11_17 * (180 - var_11_17 * 8), 310)
	end
end

function var_0_0.refreshCircle(arg_15_0, arg_15_1, arg_15_2)
	for iter_15_0 = 1, var_0_3 do
		local var_15_0 = arg_15_0.circle:get("dot" .. iter_15_0)

		if arg_15_2 < iter_15_0 then
			var_15_0:visible(false)
		else
			var_15_0:texture(var_0_4[arg_15_1])
			var_15_0:visible(true)
		end
	end

	local var_15_1 = arg_15_0.circle:multiget("circleColor", "circlePos")

	var_15_1.circleColor:visible(false)
	var_15_1.circlePos:removeAllChildren()

	if arg_15_2 ~= 0 then
		arg_15_0:setProgress(var_15_1.circlePos, cc.p(195, 193), arg_15_2 - 1)
		var_15_1.circlePos:rotate(216)
	end
end

function var_0_0.setPassiveDetail(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0.csvSignetAdvance[arg_16_2.advanceIndex][arg_16_1 + 1]
	local var_16_1 = {}

	for iter_16_0 = 1, math.huge do
		local var_16_2 = var_16_0["attrType" .. iter_16_0]

		if not var_16_2 or var_16_2 == 0 then
			break
		end

		local var_16_3 = game.ATTRDEF_TABLE[var_16_2]
		local var_16_4 = "attr" .. string.caption(var_16_3)

		table.insert(var_16_1, {
			name = gLanguageCsv[var_16_4],
			num = dataEasy.getAttrValueString(var_16_2, var_16_0["attrNum" .. iter_16_0])
		})
	end

	local var_16_5 = ""

	for iter_16_1 = 1, #var_16_1 do
		var_16_5 = var_16_5 .. var_16_1[iter_16_1].name .. "+" .. var_16_1[iter_16_1].num .. "  "
	end

	local var_16_6 = ""

	for iter_16_2, iter_16_3 in csvMapPairs(var_16_0.sceneType) do
		local var_16_7 = iter_16_3
		local var_16_8 = game.SCENE_TYPE_STRING_TABLE[var_16_7]

		var_16_6 = var_16_6 .. gLanguageCsv[var_16_8]

		if iter_16_2 < table.getn(var_16_0.sceneType) then
			var_16_6 = var_16_6 .. gLanguageCsv.signetAnd
		end
	end

	local var_16_9 = string.format(gLanguageCsv.signetBeiDong, var_16_0.advanceLevel, var_16_6)

	if matchLanguage({
		"kr"
	}) then
		var_16_5 = var_16_9 .. " " .. var_16_5
	else
		var_16_5 = var_16_9 .. var_16_5
	end

	arg_16_0.passiveDetail:text(var_16_5)
end

function var_0_0.initAttr(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	arg_17_0.signetAdvanceData = {}

	local var_17_0 = {}

	for iter_17_0 = 1, math.huge do
		local var_17_1 = arg_17_3["signetAttrType" .. iter_17_0]

		if not var_17_1 or var_17_1 == 0 then
			break
		end

		local var_17_2 = game.ATTRDEF_TABLE[var_17_1]
		local var_17_3 = "attr" .. string.caption(var_17_2)
		local var_17_4, var_17_5 = dataEasy.getAttrValueAndNextValue(var_17_1, arg_17_3["signetAttrNum" .. iter_17_0][arg_17_1] or 0, arg_17_3["signetAttrNum" .. iter_17_0][arg_17_1 + 1] or 0)

		if (arg_17_2 + 1) * var_0_3 == arg_17_1 then
			var_17_5 = var_17_4
		end

		table.insert(var_17_0, {
			name = gLanguageCsv[var_17_3],
			num = math.floor(var_17_4),
			nextNum = math.floor(var_17_5),
			isMax = arg_17_1 >= arg_17_0.signetMax,
			isAdvance = arg_17_1 == (arg_17_2 + 1) * var_0_3 or arg_17_2 == arg_17_3.signetAdvanceMax
		})

		if not arg_17_0.signetAdvanceData[iter_17_0] then
			arg_17_0.signetAdvanceData[iter_17_0] = {
				num1 = var_17_4,
				num2 = var_17_5
			}
		end
	end

	arg_17_0.listAttr:setAnchorPoint(cc.p(0, 1))
	arg_17_0.listAttr:size(516, #var_17_0 * 60)
	arg_17_0.listAttr:y(arg_17_0.qualityItem:y() - 30)
	arg_17_0.attrDatas:update(var_17_0)
	arg_17_0.passiveDetail:y(arg_17_0.listAttr:y() - 10 - arg_17_0.passiveDetail:height() / 2 - #var_17_0 * 60)
end

function var_0_0.onSignet(arg_18_0)
	if not arg_18_0.speedBtn then
		return
	end

	arg_18_0.speedBtn = false

	local var_18_0 = arg_18_0.fight:read()
	local var_18_1 = arg_18_0.equips:read()[arg_18_0.equipIndex:read()]
	local var_18_2 = csv.equips[var_18_1.equip_id]
	local var_18_3 = var_18_1.signet or 0
	local var_18_4 = var_18_1.signet_advance or 0
	local var_18_5 = arg_18_0.limitTip or 0

	if not arg_18_0.isEnoughItem then
		arg_18_0.speedBtn = true

		gGameUI:showTip(gLanguageCsv.equipNotEnoughSignetItems)

		return
	end

	if arg_18_0.isEnoughGold == false then
		arg_18_0.speedBtn = true

		gGameUI:showTip(gLanguageCsv.cardSignetGoldNotEnough)

		return
	end

	local var_18_6 = {
		false
	}
	local var_18_7 = matchLanguage({
		"kr"
	}) and arg_18_0.passiveDetail:text() or string.sub(arg_18_0.passiveDetail:text(), 10)

	if var_18_3 == (var_18_4 + 1) * var_0_3 then
		gGameApp:requestServerCustom("/game/equip/signet/advance"):onErrCall(function()
			arg_18_0.speedBtn = true
		end):params(arg_18_0.selectDbId, var_18_2.part):onResponse(function(arg_20_0)
			idlereasy.do_(function(arg_21_0, arg_21_1)
				arg_18_0:playSpine(1, function()
					gGameUI:stackUI("city.card.equip.success", nil, {
						blackLayer = true
					}, {
						type = "signetAdvance",
						leftItem = var_18_1,
						rightItem = arg_21_0[arg_21_1],
						fight = var_18_0,
						cardDbid = arg_18_0.selectDbId:read(),
						leftQuality = arg_18_0.leftQuality:text(),
						rightQuality = arg_18_0.rightQuality:text(),
						textBD = var_18_7,
						limitTip = var_18_5,
						isMax = var_18_4 == var_18_2.signetAdvanceMax - 1,
						signetAdvanceData = arg_18_0.signetAdvanceData
					})

					var_18_6[1] = true
				end)
			end, arg_18_0.equips, arg_18_0.equipIndex)
		end):wait(var_18_6):doit(function()
			return
		end)

		return
	end

	arg_18_0.callBackSign = true

	gGameApp:requestServer("/game/equip/signet", function(arg_24_0)
		return
	end, arg_18_0.selectDbId, var_18_2.part)
end

function var_0_0.onSignetOneKey(arg_25_0)
	if not arg_25_0.isEnoughItem then
		gGameUI:showTip(gLanguageCsv.equipNotEnoughSignetItems)

		return
	end

	if arg_25_0.isEnoughGold == false then
		gGameUI:showTip(gLanguageCsv.cardSignetGoldNotEnough)

		return
	end

	gGameUI:stackUI("city.card.equip.fast_signet", nil, nil, arg_25_0.selectDbId:read(), arg_25_0.data.equip_id, arg_25_0:createHandler("playSpine"))
end

function var_0_0.playSpine(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_0.pos:get("effect")

	if var_26_0 then
		var_26_0:setTimeScale(arg_26_1 or 1)
		var_26_0:play("fangguang2")
	else
		var_26_0 = widget.addAnimationByKey(arg_26_0.pos, "koudai_gonghuixunlian/gonghuixunlian.skel", "effect", "fangguang2", 10000)

		var_26_0:xy(arg_26_0.pos:size().width / 2, 0)
	end

	var_26_0:setSpriteEventHandler(function(arg_27_0, arg_27_1)
		if arg_26_2 then
			arg_26_2()
		end
	end, sp.EventType.ANIMATION_COMPLETE)
end

function var_0_0.onDown(arg_28_0)
	local var_28_0 = arg_28_0.data.signet or 0
	local var_28_1 = arg_28_0.data.signet_advance or 0

	if var_28_0 <= 0 then
		gGameUI:showTip(gLanguageCsv.currentSignetCannotReduced)

		return
	end

	local var_28_2 = csv.equips[arg_28_0.data.equip_id]
	local var_28_3 = gCostCsv.equip_drop_cost
	local var_28_4 = var_28_3[math.min(var_28_0, table.length(var_28_3))]

	gGameUI:showDialog({
		isRich = true,
		clearFast = true,
		btnType = 1,
		align = "left",
		strs = {
			string.format(gLanguageCsv.equipStarDownCost, var_28_4),
			string.format(gLanguageCsv.equipStarDownReturn, gLanguageCsv.signet)
		},
		cb = function()
			if var_28_4 > arg_28_0.rmb:read() then
				gGameUI:showTip(gLanguageCsv.rmbNotEnough)

				return
			end

			gGameApp:requestServer("/game/equip/signet/drop", function(arg_30_0)
				local var_30_0 = {}

				for iter_30_0 = 0, var_28_0 - 1 do
					for iter_30_1, iter_30_2 in csvMapPairs(csv.base_attribute.equip_signet[iter_30_0]["costItemMap" .. var_28_2.signetStrengthSeqID]) do
						if not var_30_0[iter_30_1] then
							var_30_0[iter_30_1] = 0
						end

						var_30_0[iter_30_1] = var_30_0[iter_30_1] + iter_30_2
					end
				end

				for iter_30_3 = 0, var_28_1 - 1 do
					for iter_30_4, iter_30_5 in csvPairs(csv.base_attribute.equip_signet_advance) do
						if var_28_1 == var_28_2.signetAdvanceMax then
							var_28_1 = var_28_1 - 1
						end

						if iter_30_5.advanceIndex == var_28_2.advanceIndex and iter_30_5.advanceLevel == var_28_1 + 1 then
							for iter_30_6, iter_30_7 in csvMapPairs(csv.base_attribute.equip_signet_advance_cost[iter_30_3]["costItemMap" .. iter_30_5.advanceSeqID]) do
								if not var_30_0[iter_30_6] then
									var_30_0[iter_30_6] = 0
								end

								var_30_0[iter_30_6] = var_30_0[iter_30_6] + iter_30_7
							end
						end
					end
				end

				gGameUI:showGainDisplay(var_30_0)
			end, arg_28_0.selectDbId, var_28_2.part)
		end,
		dialogParams = {
			clickClose = false
		}
	})
end

function var_0_0.setProgress(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	arg_31_3 = arg_31_3 or 0

	local var_31_0 = arg_31_3 * 100 / var_0_3
	local var_31_1 = arg_31_0.data.signet_advance or 0
	local var_31_2 = var_0_5[var_31_1]

	if arg_31_0.signetMax == var_0_3 * var_31_1 then
		var_31_2 = var_0_5[var_31_1 - 1]
	end

	local var_31_3 = cc.ProgressTimer:create(cc.Sprite:create(var_31_2))

	var_31_3:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
	arg_31_1:addChild(var_31_3)
	var_31_3:setPosition(arg_31_2)
	var_31_3:setPercentage(var_31_0)
end

function var_0_0.onBtnDetailClick(arg_32_0)
	local var_32_0 = clone(arg_32_0.data)

	gGameUI:stackUI("city.card.equip.singnet_info", nil, nil, var_32_0)
end

return var_0_0
