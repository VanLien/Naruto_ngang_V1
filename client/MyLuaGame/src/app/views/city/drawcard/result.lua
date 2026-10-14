local var_0_0 = {
	[1] = 0,
	[10] = 9
}
local var_0_1 = {
	gCommonConfigCsv.drawCardUp1CostPrice,
	[10] = gCommonConfigCsv.drawCardUp10CostPrice
}
local var_0_2 = require("app.views.city.drawcard.tools")

local function var_0_3(arg_1_0, arg_1_1, arg_1_2, ...)
	gGameApp:requestServerCustom(arg_1_0):onErrClose(arg_1_2 or function()
		return
	end):params(...):doit(arg_1_1)
end

local var_0_4 = {
	diamond = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		local var_3_0 = ({
			"rmb1",
			free = "free1",
			[10] = "rmb10"
		})[arg_3_2 and "free" or arg_3_1]
		local var_3_1 = "/game/lottery/card/draw"

		var_0_3(var_3_1, arg_3_0, arg_3_4, var_3_0)
	end,
	gold = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		local var_4_0 = ({
			"gold1",
			free = "free_gold1",
			[10] = "gold10"
		})[arg_4_2 and "free" or arg_4_1]
		local var_4_1 = "/game/lottery/card/draw"

		var_0_3(var_4_1, arg_4_0, arg_4_4, var_4_0)
	end,
	equip = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		local var_5_0 = ({
			"rmb1",
			free = "free1",
			[10] = "rmb10"
		})[arg_5_2 and "free" or arg_5_1]
		local var_5_1 = "/game/lottery/equip/draw"

		var_0_3(var_5_1, arg_5_0, arg_5_4, var_5_0)
	end,
	limit_sprite = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		local var_6_0 = ({
			"limit_box_rmb1",
			free = "limit_box_free1",
			[10] = "limit_box_rmb10"
		})[arg_6_2 and "free" or arg_6_1]
		local var_6_1 = "/game/yy/limit/box/draw"

		var_0_3(var_6_1, arg_6_0, arg_6_4, arg_6_3, var_6_0)
	end,
	limit = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		local var_7_0 = ({
			[1] = "limit_rmb1",
			[10] = "limit_rmb10"
		})[arg_7_1]
		local var_7_1 = "/game/yy/award/draw"

		var_0_3(var_7_1, arg_7_0, arg_7_4, arg_7_3, var_7_0)
	end,
	diamond_up = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		local var_8_0 = ({
			[1] = "limit_up_rmb1",
			[10] = "limit_up_rmb10"
		})[arg_8_1]
		local var_8_1 = "/game/yy/award/draw"

		var_0_3(var_8_1, arg_8_0, arg_8_4, arg_8_3, var_8_0)
	end,
	lucky_egg = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		local var_9_0 = ({
			"lucky_egg_rmb1",
			free = "lucky_egg_free1",
			[10] = "lucky_egg_rmb10"
		})[arg_9_2 and "free" or arg_9_1]
		local var_9_1 = "/game/yy/lucky/egg/draw"

		var_0_3(var_9_1, arg_9_0, arg_9_4, arg_9_3, var_9_0)
	end,
	self_choose = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
		local var_10_0 = ({
			[1] = "group_up_rmb1",
			[10] = "group_up_rmb10"
		})[arg_10_1]
		local var_10_1 = "/game/lottery/card/up/draw"

		var_0_3(var_10_1, arg_10_0, arg_10_4, var_10_0, arg_10_5)
	end
}
local var_0_5 = {
	diamond = function(arg_11_0)
		local var_11_0 = arg_11_0.times
		local var_11_1 = dataEasy.getNumByKey(game.ITEM_TICKET.rmbCard)

		if (not arg_11_0.isHalf or var_11_0 == 10) and var_11_0 <= var_11_1 then
			return var_11_0, var_11_1, dataEasy.getIconResByKey(game.ITEM_TICKET.rmbCard)
		end

		local var_11_2 = ({
			gCommonConfigCsv.drawCardCostPrice,
			[10] = gCommonConfigCsv.draw10CardCostPrice
		})[var_11_0]

		if arg_11_0.isHalf then
			var_11_2 = var_11_2 / 2
		end

		return var_11_2, arg_11_0.rmb:read()
	end,
	gold = function(arg_12_0)
		local var_12_0 = arg_12_0.times
		local var_12_1 = dataEasy.getNumByKey(game.ITEM_TICKET.goldCard)

		if var_12_0 <= var_12_1 then
			return var_12_0, var_12_1, dataEasy.getIconResByKey(game.ITEM_TICKET.goldCard)
		end

		return ({
			gCommonConfigCsv.drawGoldCostPrice,
			[10] = gCommonConfigCsv.draw10GoldCostPrice
		})[var_12_0], arg_12_0.gold:read()
	end,
	equip = function(arg_13_0)
		local var_13_0 = arg_13_0.times
		local var_13_1 = dataEasy.getNumByKey(game.ITEM_TICKET.equipCard)

		if var_13_0 <= var_13_1 then
			return var_13_0, var_13_1, dataEasy.getIconResByKey(game.ITEM_TICKET.equipCard)
		end

		return ({
			gCommonConfigCsv.drawEquipCostPrice,
			[10] = gCommonConfigCsv.draw10EquipCostPrice
		})[var_13_0], arg_13_0.rmb:read()
	end,
	limit = function(arg_14_0)
		local var_14_0 = arg_14_0.times
		local var_14_1 = dataEasy.getNumByKey(game.ITEM_TICKET.limitCard)
		local var_14_2 = dataEasy.getCfgByKey(game.ITEM_TICKET.limitCard)

		return var_14_0, var_14_1, dataEasy.getIconResByKey(game.ITEM_TICKET.limitCard), var_14_2.name
	end,
	limit_sprite = function(arg_15_0)
		local var_15_0 = arg_15_0.times
		local var_15_1 = dataEasy.getNumByKey(game.ITEM_TICKET.spriteCard)
		local var_15_2 = dataEasy.getCfgByKey(game.ITEM_TICKET.spriteCard)

		return var_15_0, var_15_1, dataEasy.getIconResByKey(game.ITEM_TICKET.spriteCard), var_15_2.name
	end,
	diamond_up = function(arg_16_0)
		local var_16_0 = arg_16_0.times
		local var_16_1 = dataEasy.getNumByKey(game.ITEM_TICKET.diamondUpCard)

		if var_16_0 <= var_16_1 then
			return var_16_0, var_16_1, dataEasy.getIconResByKey(game.ITEM_TICKET.diamondUpCard)
		else
			return csv.yunying.yyhuodong[arg_16_0.yyId].paramMap["RMB" .. arg_16_0.times], arg_16_0.rmb:read()
		end
	end,
	lucky_egg = function(arg_17_0)
		local var_17_0 = arg_17_0.times
		local var_17_1 = dataEasy.getNumByKey(game.ITEM_TICKET.luckyEggCard)
		local var_17_2 = dataEasy.getCfgByKey(game.ITEM_TICKET.luckyEggCard)

		return var_17_0, var_17_1, dataEasy.getIconResByKey(game.ITEM_TICKET.luckyEggCard), var_17_2.name
	end,
	self_choose = function(arg_18_0)
		local var_18_0 = arg_18_0.times
		local var_18_1 = dataEasy.getNumByKey(game.ITEM_TICKET.diamondUpCard)

		if var_18_0 <= var_18_1 then
			return var_18_0, var_18_1, dataEasy.getIconResByKey(game.ITEM_TICKET.diamondUpCard)
		else
			return var_0_1[arg_18_0.times], arg_18_0.rmb:read()
		end
	end
}
local var_0_6 = cc.load("mvc").ViewBase
local var_0_7 = class("DrawCardResultView", var_0_6)

var_0_7.RESOURCE_FILENAME = "drawcard_result.json"
var_0_7.RESOURCE_BINDING = {
	["baseNode.costInfo"] = "costInfo",
	["baseNode.costInfo.imgIcon"] = "imgIcon",
	["baseNode.equipPanel"] = "equipPanel",
	["baseNode.list"] = "listview",
	["baseNode.equipPanel.imgIcon"] = "equipImgIcon",
	effectItem = "effectItem",
	["baseNode.privilegePanel"] = "privilegePanel",
	["baseNode.costInfo.textNote"] = "textNote",
	item = "item",
	["baseNode.costInfo.imgBg"] = "imgBg",
	["baseNode.costInfo.textCost"] = "textCost",
	["baseNode.actionPanel"] = "actionPanel",
	innerList = "innerList",
	baseNode = {
		varname = "baseNode",
		binds = {
			event = "visible",
			idler = bindHelper.self("isShowResult")
		}
	},
	["baseNode.btnOk"] = {
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("isShowBtn")
			},
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onClose")
				}
			}
		}
	},
	["baseNode.btnOk.textNote"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	["baseNode.btnAgain"] = {
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("isShowBtn")
			},
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onDrawAgain")
				}
			}
		}
	},
	["baseNode.btnAgain.textNote"] = {
		varname = "btnAgainTextNote",
		binds = {
			{
				event = "text",
				idler = bindHelper.self("btnText")
			},
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	["baseNode.freePanel"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("isFree")
		}
	},
	effect = {
		varname = "effect",
		binds = {
			{
				event = "click",
				method = bindHelper.self("onClickEffect")
			},
			{
				event = "visible",
				idler = bindHelper.self("showEffect")
			}
		}
	},
	clickPanel = {
		binds = {
			event = "click",
			method = bindHelper.self("onClickBtn")
		}
	},
	effectDown = {
		varname = "effectDown",
		binds = {
			event = "visible",
			idler = bindHelper.self("showEffectDown")
		}
	},
	["baseNode.equipPanel.textNote"] = {
		varname = "equiTextNote",
		binds = {
			{
				event = "text",
				idler = bindHelper.self("equipOtherShow")
			}
		}
	}
}
var_0_7.RESOURCE_STYLES = {
	full = true
}

local function var_0_8(arg_19_0)
	local var_19_0 = 0
	local var_19_1 = false

	for iter_19_0, iter_19_1 in ipairs(arg_19_0) do
		for iter_19_2, iter_19_3 in ipairs(iter_19_1) do
			if iter_19_3.specialFlag == "card" then
				var_19_0 = var_19_0 + 1
			end

			if var_19_0 > 1 then
				var_19_1 = true

				break
			end
		end

		if var_19_1 then
			break
		end
	end

	return var_19_1
end

function var_0_7.onCreate(arg_20_0, arg_20_1)
	arg_20_0:initModel()

	arg_20_0.originListPos = cc.p(arg_20_0.listview:xy())
	arg_20_0.hasSprite = {}
	arg_20_0.isJump = false
	arg_20_0.isHalf = false
	arg_20_0.isFirstShowCard = true
	arg_20_0.showEffect = idler.new(false)
	arg_20_0.showEffectDown = idler.new(false)
	arg_20_0.isShowResult = idler.new(false)
	arg_20_0.isShowBtn = idler.new(false)
	arg_20_0.params = arg_20_1
	arg_20_0.isCost = idler.new(true)
	arg_20_0.drawType = arg_20_1.drawType
	arg_20_0.checkCardCapacity = arg_20_1.checkCardCapacity
	arg_20_0.isFree = idler.new(arg_20_1.isFree)
	arg_20_0.times = arg_20_1.times
	arg_20_0.yyId = arg_20_1.yyId
	arg_20_0.selfChooseType = arg_20_1.selfChooseType
	arg_20_0.cb = arg_20_1.cb
	arg_20_0.closeCb = arg_20_1.closeCb
	arg_20_0.btnText = idler.new("")
	arg_20_0.equipOtherShow = idler.new("")

	arg_20_0.listview:setScrollBarEnabled(false)

	arg_20_0.drawCount = 0
	arg_20_0.initItemTime = 5
	arg_20_0.limitMax = arg_20_1.limitMax

	arg_20_0:playEffect(false, function()
		local var_21_0 = arg_20_0.params.items

		if itertools.isempty(var_21_0) then
			printWarn("抽卡返回结果为空，检查配置数据")

			return
		end

		arg_20_0.hasMore = var_0_8(var_21_0)

		arg_20_0.listview:visible(true)
		arg_20_0:onInitList(var_21_0[1])

		if arg_20_0.times == 10 and (arg_20_0.drawType == "diamond" or arg_20_0.drawType == "diamond_up" or arg_20_0.drawType == "self_choose") and matchLanguage({
			"kr"
		}) then
			local var_21_1 = userDefault.getForeverLocalKey("tenClickCount", 0) + 1

			userDefault.setForeverLocalKey("tenClickCount", var_21_1)

			if var_21_1 == 1 or var_21_1 == 3 or var_21_1 == 6 or var_21_1 == 10 then
				dataEasy.showDialogToShop()
			end
		end
	end)
	idlereasy.any({
		arg_20_0.diamondCount,
		arg_20_0.goldCount,
		arg_20_0.allCount,
		arg_20_0.halfDiamondCount,
		arg_20_0.trainerGoldCount,
		arg_20_0.equipCount,
		arg_20_0.drawEquipCount,
		arg_20_0.lastDrawTime,
		arg_20_0.items
	}, function(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8)
		arg_20_0.isHalf = false

		arg_20_0.privilegePanel:hide()
		arg_20_0.isCost:set(true)

		local var_22_0 = false
		local var_22_1 = "common/icon/icon_diamond.png"

		arg_20_0.equipPanel:hide()

		if arg_20_0.drawType == "gold" then
			var_22_1 = "common/icon/icon_gold.png"

			local var_22_2 = tonumber(gCommonConfigCsv.drawGoldFreeLimit) - arg_22_2
			local var_22_3 = gCommonConfigCsv.drawGoldFreeRefreshDuration - (time.getTime() - arg_22_8) > 0

			var_22_0 = var_22_2 > 0 and not var_22_3 and arg_20_0.times == 1

			if arg_22_5 < dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.FreeGoldDrawCardTimes) and arg_20_0.times == 1 then
				var_22_0 = true
			end
		elseif arg_20_0.drawType == "diamond" then
			var_22_0 = arg_22_1 <= 0 and arg_20_0.times == 1

			local var_22_4 = dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.FirstRMBDrawCardHalf)

			if arg_22_4 == 0 and not var_22_0 and var_22_4 ~= 0 and arg_20_0.times == 1 then
				arg_20_0.isHalf = true
			end
		elseif arg_20_0.drawType == "limit" then
			-- block empty
		elseif arg_20_0.drawType == "limit_sprite" then
			-- block empty
		elseif arg_20_0.drawType == "diamond_up" then
			-- block empty
		elseif arg_20_0.drawType == "self_choose" then
			-- block empty
		elseif arg_20_0.drawType == "equip" then
			var_22_0 = arg_22_6 < 1 and arg_20_0.times == 1
		end

		arg_20_0.isFree:set(var_22_0)

		local var_22_5, var_22_6, var_22_7 = var_0_5[arg_20_0.drawType](arg_20_0)

		if var_22_7 then
			var_22_1 = var_22_7
			var_22_5 = string.format("%s/%s", var_22_6, var_22_5)
		end

		arg_20_0.imgIcon:texture(var_22_1)
		arg_20_0.textCost:text(var_22_5)
		arg_20_0:refreshCostTextColor()

		local var_22_8 = arg_20_0.textCost:size()
		local var_22_9 = arg_20_0.textNote:size()
		local var_22_10 = arg_20_0.imgIcon:size()
		local var_22_11 = var_22_8.width + var_22_9.width + var_22_10.width + 40
		local var_22_12 = 60

		arg_20_0.imgBg:size(var_22_11, var_22_12)
		arg_20_0.imgBg:x(var_22_11 / 2)
		arg_20_0.costInfo:size(var_22_11, var_22_12)
		adapt.oneLineCenterPos(cc.p(var_22_11 / 2, 35), {
			arg_20_0.textNote,
			arg_20_0.textCost,
			arg_20_0.imgIcon
		}, cc.p(6, 0))

		local var_22_13 = arg_20_0.privilegePanel:multiget("line", "textNote", "imgIcon", "textCost", "textDiscount")

		adapt.oneLineCenterPos(cc.p(168, 35), {
			var_22_13.textNote,
			var_22_13.textCost,
			var_22_13.textDiscount,
			var_22_13.imgIcon
		}, cc.p(6, 0))
		adapt.oneLinePos(var_22_13.textNote, var_22_13.line, cc.p(6, 0), "left")
	end)
	idlereasy.when(arg_20_0.isFree, function(arg_23_0, arg_23_1)
		local var_23_0 = 1

		if not arg_23_1 then
			var_23_0 = arg_20_0.times
		end

		arg_20_0.btnText:set(string.format(gLanguageCsv.drawNum, var_23_0))
		adapt.setTextScaleWithWidth(arg_20_0.btnAgainTextNote, nil, 220)
	end)
	idlereasy.any({
		arg_20_0.isFree,
		arg_20_0.isShowBtn,
		arg_20_0.isCost
	}, function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
		arg_20_0.costInfo:visible(not arg_24_1 and arg_24_2 and arg_24_3)
	end)
	idlereasy.any({
		arg_20_0.gold,
		arg_20_0.rmb
	}, function(arg_25_0, arg_25_1, arg_25_2)
		arg_20_0:refreshCostTextColor()
	end)
end

function var_0_7.initModel(arg_26_0)
	local var_26_0 = gGameModel.daily_record

	arg_26_0.diamondCount = var_26_0:getIdler("dc1_free_count")
	arg_26_0.goldCount = var_26_0:getIdler("gold1_free_count")
	arg_26_0.lastDrawTime = var_26_0:getIdler("gold1_free_last_time")
	arg_26_0.allCount = var_26_0:getIdler("draw_card")
	arg_26_0.rmb = gGameModel.role:getIdler("rmb")
	arg_26_0.gold = gGameModel.role:getIdler("gold")
	arg_26_0.items = gGameModel.role:getIdler("items")
	arg_26_0.cardDatas = gGameModel.role:getIdler("cards")
	arg_26_0.cardCapacity = gGameModel.role:getIdler("card_capacity")
	arg_26_0.halfDiamondCount = var_26_0:getIdler("draw_card_rmb1_half")
	arg_26_0.trainerGoldCount = var_26_0:getIdler("draw_card_gold1_trainer")
	arg_26_0.equipCount = var_26_0:getIdler("eq_dc1_free_counter")
	arg_26_0.drawEquipCount = var_26_0:getIdler("draw_equip")
	arg_26_0.dcGoldCount = var_26_0:getIdler("dc_gold_count")
	arg_26_0.vip = gGameModel.role:getIdler("vip_level")
end

function var_0_7.playDownEffect(arg_27_0, arg_27_1)
	arg_27_0.showEffect:set(false)
	arg_27_0.showEffectDown:set(true)
	arg_27_0.isShowResult:set(true)

	if not arg_27_1 then
		if arg_27_0.drawType == "limit" then
			local var_27_0 = widget.addAnimationByKey(arg_27_0.effectDown, "effect/gongxihuode.skel", "efc1", "effect", 11):alignCenter(arg_27_0.effectDown:size()):addPlay("effect_loop")

			var_27_0:y(var_27_0:y() + 400)
		elseif arg_27_0.drawType == "equip" then
			local var_27_1 = arg_27_0.effectDown:size()

			widget.addAnimationByKey(arg_27_0.effectDown, "effect/gongxihuode.skel", "efc1", "effect", 11):anchorPoint(cc.p(0.5, 0.5)):xy(var_27_1.width / 2, var_27_1.height / 4 * 3 + 50):addPlay("effect_loop")
			widget.addAnimationByKey(arg_27_0.effectDown, "effect/xianshichouka.skel", "effect_bg", "effect_huode_loop", 10):scale(2):anchorPoint(cc.p(0.5, 0.5)):xy(var_27_1.width / 2, var_27_1.height / 4 * 3)
		elseif arg_27_0.drawType == "lucky_egg" then
			local var_27_2 = arg_27_0.effectDown:size()

			widget.addAnimationByKey(arg_27_0.effectDown, "effect/gongxihuode.skel", "efc1", "effect", 11):anchorPoint(cc.p(0.5, 0.5)):xy(var_27_2.width / 2, var_27_2.height / 4 * 3 + 50):addPlay("effect_loop")

			local var_27_3 = arg_27_0.effectDown:size()

			widget.addAnimationByKey(arg_27_0.effectDown, "effect/xianshichouka.skel", "effect_bg", "effect_huode_loop", 10):scale(2):anchorPoint(cc.p(0.5, 0.5)):xy(var_27_3.width / 2, var_27_3.height / 4 * 3)
		else
			local var_27_4 = arg_27_0.effectDown:size()

			widget.addAnimationByKey(arg_27_0.effectDown, "effect/gongxihuode.skel", "efc1", "effect", 11):anchorPoint(cc.p(0.5, 0.5)):xy(var_27_4.width / 2, var_27_4.height / 4 * 3 + 50):addPlay("effect_loop")

			local var_27_5 = arg_27_0.effectDown:size()

			widget.addAnimationByKey(arg_27_0.effectDown, "effect/xianshichouka.skel", "effect_bg", "effect_huode_loop", 10):scale(2):anchorPoint(cc.p(0.5, 0.5)):xy(var_27_5.width / 2, var_27_5.height / 4 * 3)
		end
	end
end

function var_0_7.playEffect(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = true
	local var_28_1 = arg_28_0.drawType == "limit"

	if arg_28_1 and not var_28_1 or not arg_28_1 and var_28_1 or arg_28_0.drawType == "equip" then
		var_28_0 = false
	end

	arg_28_0.showEffect:set(var_28_0)
	arg_28_0.isShowBtn:set(false)
	arg_28_0.effect:removeAllChildren()

	local var_28_2 = arg_28_1 and 0 or 225

	if arg_28_0.drawType == "equip" then
		var_28_2 = 0
	elseif arg_28_0.drawType == "limit" then
		if arg_28_1 then
			local var_28_3 = arg_28_0.effect:size()
			local var_28_4 = widget.addAnimationByKey(arg_28_0.effect, "effect/CJhamawu.skel", "effect", "call", 10):scale(2.2):alignCenter(arg_28_0.effect:size()):xy(var_28_3.width / 2, var_28_3.height / 2)

			var_28_2 = 128
		else
			var_28_2 = 0

			local var_28_5 = arg_28_0.effectDown:size()

			widget.addAnimationByKey(arg_28_0.effectDown, "effect/xianshichouka.skel", "effect_bg", "effect_huode_loop", 10):scale(2):anchorPoint(cc.p(0.5, 0.5)):xy(var_28_5.width / 2, var_28_5.height / 4 * 3)
		end
	elseif arg_28_0.drawType == "lucky_egg" then
		if arg_28_1 then
			local var_28_6, var_28_7, var_28_8 = dataEasy.getRawTable(arg_28_3)
			local var_28_9 = dataEasy.getItems(var_28_6, var_28_7)
			local var_28_10, var_28_11 = var_0_2.hasCard(var_28_9[1])

			if var_28_10 then
				widget.addAnimationByKey(arg_28_0.effect, "effect/xianshichouka.skel", "effect", "effect_zhanshi", 13):scale(2):alignCenter(arg_28_0.effect:size())

				var_28_2 = 70 + var_0_2.addCardImg(var_28_11, arg_28_0.effect) * 30
			end
		else
			var_28_2 = 0

			local var_28_12 = arg_28_0.effectDown:size()

			widget.addAnimationByKey(arg_28_0.effectDown, "effect/xianshichouka.skel", "effect_bg", "effect_huode_loop", 10):scale(2):anchorPoint(cc.p(0.5, 0.5)):xy(var_28_12.width / 2, var_28_12.height / 4 * 3)
		end
	elseif not arg_28_1 then
		var_28_2 = 128

		local var_28_13 = arg_28_0.effect:size()
		local var_28_14 = widget.addAnimationByKey(arg_28_0.effect, "effect/CJhamawu.skel", "effect", "call", 10):scale(2.2):alignCenter(arg_28_0.effect:size()):xy(var_28_13.width / 2, var_28_13.height / 2)
	end

	local var_28_15 = 0

	arg_28_0:enableSchedule():schedule(function(arg_29_0)
		var_28_15 = var_28_15 + arg_29_0

		if arg_28_0.isJump or var_28_15 >= var_28_2 / 30 then
			var_28_15 = 0
			arg_28_0.isJump = false

			audio.stopAllSounds()
			audio.resumeMusic()
			arg_28_0:playDownEffect(arg_28_1)
			arg_28_2()

			return false
		end
	end, 0.016666666666666666, 0, "playEffect")
end

function var_0_7.onClickEffect(arg_30_0)
	arg_30_0.showEffect:set(false)

	arg_30_0.isJump = true
end

function var_0_7.onClickBtn(arg_31_0)
	if arg_31_0.drawType == "limit_sprite" and arg_31_0.isStartItem then
		arg_31_0.initItemTime = 0
	end
end

function var_0_7.isEnough2Draw(arg_32_0)
	local var_32_0, var_32_1, var_32_2, var_32_3 = var_0_5[arg_32_0.drawType](arg_32_0)

	return var_32_0 <= var_32_1, var_32_3
end

function var_0_7.refreshCostTextColor(arg_33_0)
	local var_33_0 = arg_33_0:isEnough2Draw() and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.RED

	text.addEffect(arg_33_0.textCost, {
		color = var_33_0
	})
end

function var_0_7.onDrawAgain(arg_34_0, arg_34_1)
	arg_34_0.isJump = false

	local var_34_0, var_34_1 = arg_34_0:isEnough2Draw()

	if not var_34_0 then
		if var_34_1 then
			gGameUI:showDialog({
				content = string.format(gLanguageCsv.limitCardNotEnough, var_34_1),
				cb = function()
					if itertools.include({
						"limit",
						"limit_sprite"
					}, arg_34_0.drawType) then
						gGameUI:stackUI("city.activity.focus_buy_gift", nil, nil, arg_34_0.yyId, arg_34_0.params.cardsInfo)
					end
				end,
				closeCb = function()
					return
				end
			})
		else
			uiEasy.showDialog(itertools.include({
				"gold"
			}, arg_34_0.drawType) and "gold" or "rmb")
		end

		return
	end

	if itertools.include({
		"diamond",
		"diamond_up",
		"limit",
		"self_choose"
	}, arg_34_0.drawType) and arg_34_0.cardCapacity:read() - itertools.size(arg_34_0.cardDatas:read()) <= var_0_0[arg_34_0.times] then
		arg_34_0:showCardBagHaveBeenFullTip()

		return
	end

	if itertools.include({
		"limit_sprite"
	}, arg_34_0.drawType) and arg_34_0.checkCardCapacity == 1 and arg_34_0.cardCapacity:read() - itertools.size(arg_34_0.cardDatas:read()) <= var_0_0[arg_34_0.times] then
		arg_34_0:showCardBagHaveBeenFullTip()

		return
	end

	if itertools.include({
		"gold"
	}, arg_34_0.drawType) and not arg_34_0.isFree:read() and gVipCsv[arg_34_0.vip:read()].goldDrawCardCountLimit - (arg_34_0.dcGoldCount:read() or 0) < arg_34_0.times then
		gGameUI:showTip(string.format(gLanguageCsv.leftTimesNotEnough, arg_34_0.times))

		return
	end

	if arg_34_0.drawType == "lucky_egg" and arg_34_0.limitMax >= 0 and arg_34_0.drawCount > arg_34_0.limitMax then
		if arg_34_0.times == 1 then
			gGameUI:showTip(gLanguageCsv.luckyEggDrawOneMax)
		else
			gGameUI:showTip(gLanguageCsv.luckyEggDrawTenMax)
		end

		return
	end

	if arg_34_0.drawType ~= "limit" then
		userDefault.setForeverLocalKey("isJumpSpriteView", false)
	else
		userDefault.setForeverLocalKey("isJumpSpriteView", false)
	end

	arg_34_0.hasSprite = {}

	audio.pauseMusic()

	local var_34_2 = arg_34_0.times == 1 and "drawcard_one2.mp3" or "drawcard_ten2.mp3"

	audio.playEffectWithWeekBGM(var_34_2)

	if itertools.include({
		"diamond"
	}, arg_34_0.drawType) and arg_34_0:isTenDrawTipShow(game.ITEM_TICKET.rmbCard, "diamondDrawTips") then
		arg_34_0:showTenDrawTipAndDraw(gCommonConfigCsv.draw10CardCostPrice)

		return
	elseif itertools.include({
		"equip"
	}, arg_34_0.drawType) and arg_34_0:isTenDrawTipShow(game.ITEM_TICKET.equipCard, "equipDrawTips") then
		arg_34_0:showTenDrawTipAndDraw(gCommonConfigCsv.draw10EquipCostPrice)

		return
	end

	arg_34_0.isShowBtn:set(false)

	local var_34_3, var_34_4, var_34_5 = var_0_5[arg_34_0.drawType](arg_34_0)

	if not var_34_5 and itertools.include({
		"diamond",
		"equip",
		"diamond_up",
		"self_choose"
	}, arg_34_0.drawType) then
		dataEasy.sureUsingDiamonds(function()
			arg_34_0:drawCard()
		end, var_34_3, function()
			arg_34_0.isShowBtn:set(true)
		end)
	else
		arg_34_0:drawCard()
	end
end

function var_0_7.showCardBagHaveBeenFullTip(arg_39_0)
	gGameUI:showDialog({
		btnType = 2,
		clearFast = true,
		content = gLanguageCsv.cardBagHaveBeenFullDraw,
		cb = function()
			gGameUI:stackUI("city.card.bag", nil, {
				full = true
			})
		end
	})
end

function var_0_7.showTenDrawTipAndDraw(arg_41_0, arg_41_1)
	gGameUI:showDialog({
		isRich = true,
		clearFast = true,
		btnType = 2,
		content = string.format(gLanguageCsv.draw10CardTips, arg_41_1),
		cb = function()
			arg_41_0.isShowBtn:set(false)
			arg_41_0:drawCard()
		end
	})
end

function var_0_7.isTenDrawTipShow(arg_43_0, arg_43_1, arg_43_2)
	arg_43_0.bUseDiamond = dataEasy.getNumByKey(arg_43_1) < 10

	return arg_43_0.times == 10 and arg_43_0.bUseDiamond and (matchLanguage({
		"kr"
	}) or userDefault.getCurrDayKey("equipDrawTips", 1) == 1 and dataEasy.isUnlock("equipDrawTips"))
end

function var_0_7.drawCard(arg_44_0)
	local function var_44_0(arg_45_0)
		arg_44_0:playEffect(true, function()
			local var_46_0, var_46_1, var_46_2 = dataEasy.getRawTable(arg_45_0)
			local var_46_3 = dataEasy.getItems(var_46_0, var_46_1)

			arg_44_0.hasMore = var_0_8(var_46_3)

			if arg_44_0.drawType == "equip" then
				var_46_3[1].equip_awake_frag = arg_44_0.times
			end

			arg_44_0.listview:visible(true)
			arg_44_0:onInitList(var_46_3[1])
			arg_44_0:refreshCostTextColor()

			if arg_44_0.times == 10 and itertools.include({
				"diamond",
				"diamond_up",
				"self_choose"
			}, arg_44_0.drawType) and matchLanguage({
				"kr"
			}) then
				local var_46_4 = userDefault.getForeverLocalKey("tenClickCount", 0) + 1

				userDefault.setForeverLocalKey("tenClickCount", var_46_4)

				if var_46_4 == 1 or var_46_4 == 3 or var_46_4 == 6 or var_46_4 == 10 then
					dataEasy.showDialogToShop()
				end
			end
		end, arg_45_0)

		if arg_44_0.cb then
			arg_44_0.cb(arg_45_0)
		end

		if arg_44_0.bUseDiamond then
			if arg_44_0.drawType == "diamond" then
				userDefault.setCurrDayKey("diamondDrawTips", 0)
			elseif arg_44_0.drawType == "equip" then
				userDefault.setCurrDayKey("equipDrawTips", 0)
			end
		end
	end

	var_0_4[arg_44_0.drawType](var_44_0, arg_44_0.times, arg_44_0.isFree:read(), arg_44_0.yyId, function()
		arg_44_0.isShowBtn:set(true)
	end, arg_44_0.selfChooseType)
end

function var_0_7.onInitList(arg_48_0, arg_48_1)
	arg_48_0.listview:removeAllItems()

	local var_48_0 = #arg_48_1
	local var_48_1 = 0

	arg_48_0.isShowHero = false

	local var_48_2
	local var_48_3 = "drawCardResult"

	arg_48_0.drawCount = arg_48_0.drawCount + 1

	local var_48_4 = arg_48_0.drawCount
	local var_48_5 = 5

	arg_48_0:enableSchedule():unSchedule(var_48_3)
	arg_48_0:enableSchedule():schedule(function()
		var_48_5 = var_48_5 + 1

		if not arg_48_0.isShowHero and var_48_5 >= arg_48_0.initItemTime then
			var_48_5 = 0
			arg_48_0.isStartItem = true

			arg_48_0.listview:jumpToBottom()

			var_48_1 = var_48_1 + 1

			local var_49_0 = arg_48_1[var_48_1]
			local var_49_1 = var_49_0[1] and dataEasy.getCfgByKey(var_49_0[1]) or {}

			if arg_48_0.selectHero then
				var_49_0 = {
					new = true,
					dbid = arg_48_0.choosed_dbid
				}
			elseif arg_48_0:tryStackUI2choose1(var_49_0[1]) then
				var_48_1 = var_48_1 - 1
				arg_48_0.selectHero = true

				return
			end

			local var_49_2 = var_48_1 % 5

			if var_49_2 == 1 then
				if var_48_2 then
					local var_49_3 = ccui.Layout:create():size(10, 245)

					var_48_2:pushBackCustomItem(var_49_3)
				end

				var_48_2 = arg_48_0.innerList:clone()

				var_48_2:setScrollBarEnabled(false)
				arg_48_0.listview:pushBackCustomItem(var_48_2)

				local var_49_4 = ccui.Layout:create():size(10, 245)

				var_48_2:pushBackCustomItem(var_49_4)
				var_48_2:show()
			end

			local var_49_5 = arg_48_0.item:clone()

			arg_48_0.selectHero = false

			local var_49_6 = false
			local var_49_7 = false
			local var_49_8

			if var_49_0.new ~= nil then
				var_49_7 = var_49_0.new
				var_49_6 = true
				var_49_8 = gGameModel.cards:find(var_49_0.dbid):read("card_id")
				var_49_1 = csv.cards[var_49_8]

				local var_49_9 = userDefault.getForeverLocalKey("isJumpSpriteView", false)
				local var_49_10 = csv.unit[var_49_1.unitID].rarity

				if not var_49_9 then
					arg_48_0.isShowHero = true

					local var_49_11

					if arg_48_0.isFirstShowCard and arg_48_0.hasMore then
						var_49_11 = true
						arg_48_0.isFirstShowCard = false
					elseif arg_48_0.isFirstShowCard and not arg_48_0.hasMore then
						var_49_11 = false
						arg_48_0.isFirstShowCard = false
					elseif not arg_48_0.isFirstShowCard and arg_48_0.hasMore and var_49_9 then
						var_49_11 = false
					end

					gGameUI:stackUI("common.gain_sprite", nil, {
						full = true
					}, var_49_0, arg_48_0.hasSprite, var_49_11, arg_48_0:createHandler("changeState"))
				end
			end

			local var_49_12 = var_49_1.name
			local var_49_13 = beauty.singleTextLimitWord(var_49_12, {
				fontSize = 40
			}, {
				width = 240
			}):xy(94, -60):addTo(var_49_5:get("item"), 2)

			text.addEffect(var_49_13, {
				color = ui.COLORS.NORMAL.WHITE
			})
			var_49_5:get("item"):get("textName"):visible(false)
			var_49_5:get("item"):get("imgNew"):visible(var_49_7)
			bind.extend(arg_48_0, var_49_5:get("item"), {
				class = "icon_key",
				props = {
					effect = "drawcard",
					data = {
						key = var_49_6 and "card" or var_49_0[1],
						num = var_49_6 and var_49_8 or var_49_0[2]
					},
					onNode = function(arg_50_0)
						arg_50_0:scale(1.25)
					end
				}
			})
			var_49_5:hide()
			var_48_2:pushBackCustomItem(var_49_5)

			local var_49_14 = var_49_5:clone()

			var_49_14:xy(1258, 200)
			arg_48_0.actionPanel:add(var_49_14)
			var_49_14:show()

			var_49_2 = var_49_2 == 0 and 5 or var_49_2

			local var_49_15, var_49_16 = arg_48_0.listview:xy()
			local var_49_17 = arg_48_0.listview:getParent():convertToWorldSpace(cc.p(var_49_15, var_49_16))
			local var_49_18 = arg_48_0.actionPanel:convertToNodeSpace(var_49_17)
			local var_49_19 = arg_48_0.innerList:getItemsMargin()
			local var_49_20 = arg_48_0.listview:getItemsMargin()
			local var_49_21 = arg_48_0.item:size()
			local var_49_22 = arg_48_0.innerList:size()
			local var_49_23 = var_49_18.x + 10 + var_49_19 + var_49_21.width / 2 + (var_49_2 - 1) * (var_49_21.width + var_49_19)
			local var_49_24 = var_49_18.y + var_49_22.height / 2

			if var_48_1 <= 5 then
				var_49_24 = var_49_18.y + var_49_22.height / 2 + var_49_22.height + var_49_20
			end

			if var_48_0 == 1 then
				var_49_23, var_49_24 = 1258, 520

				var_49_14:xy(var_49_23, var_49_24)
				var_48_2:setTouchEnabled(false)
				arg_48_0.listview:setTouchEnabled(false)
				arg_48_0.listview:xy(arg_48_0.originListPos.x + 10 + var_49_19 * 2 + var_49_21.width * 2, arg_48_0.originListPos.y - var_49_22.height * 0.5)
			end

			arg_48_0:playAction(var_49_14, cc.p(var_49_23, var_49_24), function()
				var_49_14:removeFromParent()

				if var_48_4 ~= arg_48_0.drawCount then
					return
				end

				var_49_5:show()

				local var_51_0 = var_48_1 >= var_48_0

				arg_48_0.isShowBtn:set(var_51_0)

				arg_48_0.isFirstShowCard = var_48_1 >= var_48_0

				if var_48_1 >= var_48_0 then
					userDefault.setForeverLocalKey("isJumpSpriteView", false)

					if arg_48_0.drawType == "equip" then
						arg_48_0.equipOtherShow:set(string.format(gLanguageCsv.getOtherItemNum, arg_48_1.equip_awake_frag))
						adapt.oneLineCenterPos(cc.p(400, 25), {
							arg_48_0.equiTextNote,
							arg_48_0.equipImgIcon
						})
						arg_48_0.equipPanel:show()
					end
				end
			end)
		end

		return var_48_1 ~= var_48_0
	end, 0.01, 0, var_48_3)
end

function var_0_7.selectSprite(arg_52_0, arg_52_1)
	arg_52_0.choosed_dbid = arg_52_1
	arg_52_0.isShowHero = false
end

function var_0_7.changeState(arg_53_0)
	arg_53_0.isShowHero = false
end

function var_0_7.tryStackUI2choose1(arg_54_0, arg_54_1)
	if not arg_54_1 then
		return
	end

	if var_0_2.is2choose1item(arg_54_1) then
		arg_54_0.isShowHero = true

		gGameUI:stackUI("city.drawcard.choose", nil, nil, arg_54_1, arg_54_0:createHandler("selectSprite"))

		return true
	end
end

function var_0_7.playAction(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	arg_55_3 = arg_55_3 or function()
		arg_55_0.isShowBtn:set(true)
	end

	arg_55_1:scale(0)
	arg_55_1:stopAllActions()
	transition.executeSequence(arg_55_1):moveTo(0.1, arg_55_2.x, arg_55_2.y):func(arg_55_3):done()
	transition.executeSequence(arg_55_1):rotateTo(0.1, 720):done()
	transition.executeSequence(arg_55_1):scaleTo(0.1, 1):done()
end

function var_0_7.onClose(arg_57_0)
	userDefault.setForeverLocalKey("isJumpSpriteView", false)

	local var_57_0 = arg_57_0.closeCb

	var_0_6.onClose(arg_57_0)

	if var_57_0 then
		var_57_0()
	end
end

return var_0_7
