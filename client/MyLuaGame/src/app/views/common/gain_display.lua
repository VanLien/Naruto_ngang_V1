local var_0_0 = table.insert
local var_0_1 = 8
local var_0_2 = 0

local function var_0_3(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	return widget.addAnimationByKey(arg_1_0, "effect/jiesuanjiemian.skel", arg_1_1, arg_1_2, arg_1_3):xy(96, 145)
end

local var_0_4 = cc.load("mvc").ViewBase
local var_0_5 = class("GainDisplayView", var_0_4)

var_0_5.RESOURCE_FILENAME = "common_gain_display.json"
var_0_5.RESOURCE_BINDING = {
	item = "item",
	list = "list",
	innerList = "innerList",
	imgBG = {
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	},
	textNote = {
		binds = {
			event = "visible",
			idler = bindHelper.self("canClose")
		}
	}
}
var_0_5.RESOURCE_STYLES = {
	backGlass = true
}

function var_0_5.onCreate(arg_2_0, arg_2_1, arg_2_2)
	audio.playEffectWithWeekBGM("item_gain.mp3")

	arg_2_2 = arg_2_2 or {}

	if arg_2_1.view then
		if arg_2_1.view.regainD then
			for iter_2_0, iter_2_1 in pairs(arg_2_1.view.regainD) do
				gGameUI:showTip(string.format(gLanguageCsv.regainOnlyItem, uiEasy.setIconName(iter_2_0, iter_2_1)))
			end

			arg_2_1.view.regainD = {}
		end
	elseif arg_2_1.regainD then
		for iter_2_2, iter_2_3 in pairs(arg_2_1.regainD) do
			gGameUI:showTip(string.format(gLanguageCsv.regainOnlyItem, uiEasy.setIconName(iter_2_2, iter_2_3)))
		end

		arg_2_1.regainD = {}
	end

	arg_2_0.canClose = idler.new(true)
	arg_2_0.cb = arg_2_2.cb
	arg_2_0.hadSprite = {}
	arg_2_0.isDouble = arg_2_2.isDouble

	if arg_2_2.tips then
		arg_2_0:showTips(arg_2_2.tips)
	end

	if not arg_2_0.isDouble then
		arg_2_0.onlyGoldDouble = arg_2_2.onlyGoldDouble
	end

	if arg_2_2.raw == false then
		arg_2_0.data = dataEasy.getItemData(arg_2_1)
	else
		arg_2_0.data, arg_2_0.isFull, arg_2_0.isHaveTip = dataEasy.mergeRawDate(arg_2_1)
	end

	if #arg_2_0.data == 0 then
		arg_2_0:hide()
		performWithDelay(arg_2_0, handler(arg_2_0, "onClose"), 0)

		return
	end

	arg_2_0.canClose:set(false)
	idlereasy.if_(arg_2_0.canClose, function()
		if #arg_2_0.data > var_0_1 * 2 then
			arg_2_0.list:setTouchEnabled(true)
		end
	end)

	arg_2_0.intervalTime = 0.25

	arg_2_0.list:setScrollBarEnabled(false)
	arg_2_0.innerList:setScrollBarEnabled(false)
	arg_2_0.list:setTouchEnabled(false)
	arg_2_0.innerList:setTouchEnabled(false)

	local var_2_0 = arg_2_0.list:size()
	local var_2_1 = arg_2_0.innerList:size()
	local var_2_2 = arg_2_0.item:size()
	local var_2_3 = #arg_2_0.data

	arg_2_0.hasMoreCard = false
	arg_2_0.isFirstShow = true

	local var_2_4 = 0

	for iter_2_4, iter_2_5 in pairs(arg_2_0.data) do
		if iter_2_5.specialFlag == "card" then
			var_2_4 = var_2_4 + 1
		end

		if var_2_4 > 1 then
			arg_2_0.hasMoreCard = true

			break
		end
	end

	if var_2_3 <= var_0_1 then
		local var_2_5 = arg_2_0.innerList:getItemsMargin()
		local var_2_6 = arg_2_0.list:x() + (var_2_0.width - var_2_2.width * var_2_3 - var_2_3 * var_2_5 - var_0_2) / 2 - (var_0_2 + var_2_5) / 2
		local var_2_7 = arg_2_0.list:y() - 200

		arg_2_0.list:xy(var_2_6, var_2_7)
	elseif var_2_3 <= var_0_1 * 2 then
		arg_2_0.list:setTouchEnabled(false)

		local var_2_8 = arg_2_0.list:y() - 100

		arg_2_0.list:y(var_2_8)
	end

	arg_2_0:showItem(1)

	local var_2_9 = arg_2_0:getResourceNode()

	widget.addAnimationByKey(var_2_9, "effect/gongxihuode.skel", "gongxihuode", "effect", 10):anchorPoint(cc.p(0.5, 0.5)):xy(var_2_9:width() / 2, var_2_9:height() - 300):addPlay("effect_loop")
end

function var_0_5.onClose(arg_4_0)
	if arg_4_0.canClose:read() then
		arg_4_0:addCallbackOnExit(arg_4_0.cb)
		var_0_4.onClose(arg_4_0)
	else
		arg_4_0.intervalTime = 0
	end
end

function var_0_5.showTips(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1.position.x
	local var_5_1 = arg_5_1.position.y
	local var_5_2 = arg_5_1.anchorPoint.x
	local var_5_3 = arg_5_1.anchorPoint.y

	rich.createByStr(arg_5_1.str, arg_5_1.foneSize):xy(var_5_0, var_5_1):anchorPoint(var_5_2, var_5_3):addTo(arg_5_0, 5)
end

function var_0_5.showItem(arg_6_0, arg_6_1)
	if arg_6_1 > #arg_6_0.data then
		performWithDelay(arg_6_0, function()
			arg_6_0.canClose:set(true)
			userDefault.setForeverLocalKey("isJumpSpriteView", false)
		end, 0.4)

		return
	end

	if arg_6_1 % var_0_1 == 1 then
		if arg_6_0.curSubList then
			local var_6_0 = ccui.Layout:create():size(var_0_2, 245)

			arg_6_0.curSubList:pushBackCustomItem(var_6_0)
		end

		arg_6_0.curSubList = arg_6_0.innerList:clone()

		arg_6_0.curSubList:show()
		arg_6_0.list:pushBackCustomItem(arg_6_0.curSubList):refreshView():scrollToBottom(0.3, true)

		local var_6_1 = ccui.Layout:create():size(var_0_2, 245)

		arg_6_0.curSubList:pushBackCustomItem(var_6_1)
	end

	if arg_6_1 == 1 and arg_6_0.isHaveTip then
		gGameUI:showTip(gLanguageCsv.autoDecompose)
		performWithDelay(arg_6_0, function(arg_8_0)
			arg_6_0:showDetaiItem(arg_6_1)
		end, 1)
	else
		arg_6_0:showDetaiItem(arg_6_1)
	end
end

function var_0_5.showDetaiItem(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.data[arg_9_1]

	if var_9_0.specialFlag == "card" then
		local var_9_1 = gGameModel.cards:find(var_9_0.dbid):read("card_id")
		local var_9_2 = csv.cards[var_9_1]
		local var_9_3 = csv.unit[var_9_2.unitID].rarity

		if not userDefault.getForeverLocalKey("isJumpSpriteView", false) or var_9_3 >= gCommonConfigCsv.showCardRarityMin or var_9_0.new and not arg_9_0.hadSprite[var_9_1] then
			local var_9_4

			if arg_9_0.isFirstShow and arg_9_0.hasMoreCard then
				var_9_4 = true
				arg_9_0.isFirstShow = false
			elseif arg_9_0.isFirstShow and not arg_9_0.hasMoreCard then
				var_9_4 = false
			end

			gGameUI:stackUI("common.gain_sprite", {
				cb = arg_9_0:createHandler("handlerShowItem", arg_9_1, var_9_0)
			}, {
				full = true
			}, var_9_0, arg_9_0.hadSprite, var_9_4)
		else
			arg_9_0:handlerShowItem(arg_9_1, var_9_0)
		end
	else
		local var_9_5, var_9_6 = dataEasy.isSkinByKey(var_9_0.key)

		if var_9_5 then
			gGameUI:stackUI("city.card.skin.award", {
				cb = arg_9_0:createHandler("handlerShowItem", arg_9_1, var_9_0)
			}, {
				full = true
			}, var_9_6.skinID, var_9_6.days)
		else
			arg_9_0:handlerShowItem(arg_9_1, var_9_0)
		end
	end
end

function var_0_5.handlerShowItem(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.item:clone()

	var_10_0:show()

	local var_10_1 = var_10_0:size()
	local var_10_2 = arg_10_2.key
	local var_10_3 = arg_10_2.num
	local var_10_4 = arg_10_2.specialKey == "extra"
	local var_10_5 = arg_10_0.isDouble

	if not var_10_5 and var_10_2 == "gold" then
		var_10_5 = arg_10_0.onlyGoldDouble
	end

	bind.extend(arg_10_0, var_10_0, {
		class = "icon_key",
		props = {
			effect = "gain",
			data = {
				key = var_10_2,
				num = var_10_3,
				dbId = arg_10_2.dbId
			},
			isExtra = var_10_4,
			isDouble = var_10_5,
			onNode = function(arg_11_0)
				arg_11_0:xy(var_10_1.width / 2, var_10_1.height / 2 + 20):hide():z(3):scale(1.25)
				transition.executeSequence(arg_11_0, true):delay(0.5):func(function()
					arg_11_0:show()
				end):done()
			end
		}
	})

	local var_10_6 = 1

	if string.find(var_10_2, "star_skill_points_%d+") then
		local var_10_7 = tonumber(string.sub(var_10_2, string.find(var_10_2, "%d+")))
		local var_10_8 = csv.cards[var_10_7]

		var_10_6 = csv.fragments[var_10_8.fragID].quality
	elseif var_10_2 ~= "card" then
		var_10_6 = dataEasy.getCfgByKey(var_10_2).quality
	end

	widget.addAnimationByKey(var_10_0, "effect/jiesuanjiemian.skel", "djhd_hou", "djhd_hou" .. var_10_6, 2):xy(var_10_1.width / 2, var_10_1.height / 2 + 20):scale(1.25)
	widget.addAnimationByKey(var_10_0, "effect/jiesuanjiemian.skel", "djhd", "djhd" .. var_10_6, 4):xy(var_10_1.width / 2, var_10_1.height / 2 + 20):scale(1.25)

	local var_10_9, var_10_10 = uiEasy.setIconName(var_10_2, var_10_3)

	beauty.singleTextLimitWord(var_10_9, {
		fontSize = 40
	}, {
		width = 240
	}):xy(var_10_1.width / 2, 20):addTo(var_10_0, 10)
	arg_10_0.curSubList:pushBackCustomItem(var_10_0)
	audio.playEffectWithWeekBGM("iconpopup.mp3")
	transition.executeSequence(arg_10_0.list, true):delay(arg_10_0.intervalTime):func(function()
		arg_10_0:showItem(arg_10_1 + 1)
	end):done()

	if arg_10_1 == #arg_10_0.data and arg_10_0.isFull then
		gGameUI:showDialog({
			content = gLanguageCsv.cardBagHaveBeenFull
		})
	end
end

return var_0_5
