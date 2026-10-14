local var_0_0 = {}
local var_0_1 = require("app.views.city.drawcard.tools")

function var_0_0.initPageItemFunc(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	arg_1_0.isLimitDraw:set(true)
	arg_1_0.isCutDown:set(false)
	arg_1_0.isFree:set(false)
	arg_1_0.isCost:set(true)

	local var_1_0 = csv.yunying.yyhuodong[arg_1_0.limitDataId].paramMap
	local var_1_1 = csv.yunying.yyhuodong[arg_1_0.limitDataId].clientParam
	local var_1_2 = "common/icon/icon_diamond.png"
	local var_1_3 = "common/icon/icon_diamond.png"
	local var_1_4 = var_1_0.RMB1
	local var_1_5 = var_1_0.RMB10
	local var_1_6 = dataEasy.getNumByKey(game.ITEM_TICKET.limitCard)
	local var_1_7 = dataEasy.getIconResByKey(game.ITEM_TICKET.limitCard)
	local var_1_8 = string.format("%s/%s", var_1_6, 1)
	local var_1_9 = dataEasy.getIconResByKey(game.ITEM_TICKET.limitCard)
	local var_1_10 = string.format("%s/%s", var_1_6, 10)

	arg_1_0.oneIconPath:set(var_1_7)
	arg_1_0.tenIconPath:set(var_1_9)
	arg_1_0.drawOnceCost:set(var_1_8)
	arg_1_0.drawTenCost:set(var_1_10)

	local var_1_11 = arg_1_0.limitPanel

	var_1_11:removeChildByName("richText")
	arg_1_0:initCountDown(var_1_11)

	local var_1_12 = csv.yunying.draw_limit[var_1_1.limitId]
	local var_1_13 = true

	if var_1_12.card2 or var_1_12.res2 then
		var_1_13 = false
	end

	local var_1_14 = {}

	arg_1_0.cardsInfo = {}

	var_1_11:get("single"):visible(var_1_13)
	var_1_11:get("double"):visible(not var_1_13)

	if var_1_13 then
		arg_1_0:initCardData(var_1_12, var_1_11:get("single"), 1, var_1_14)
	else
		local var_1_15 = {
			"left",
			"right"
		}

		for iter_1_0 = 1, #var_1_15 do
			local var_1_16 = var_1_11:get("double"):get(var_1_15[iter_1_0])

			arg_1_0:initCardData(var_1_12, var_1_16, iter_1_0, var_1_14)

			if var_1_15[iter_1_0] == "right" then
				adapt.oneLinePos(var_1_16:get("info.img2"), var_1_16:get("info.img1"), cc.p(25, 0), "right")
			end

			adapt.oneLinePos(var_1_16:get("info.img2"), var_1_16:get("info.btnJump"), cc.p(10, 0))
		end
	end

	local var_1_17 = {}
	local var_1_18 = csv.cards

	for iter_1_1, iter_1_2 in ipairs(var_1_14) do
		table.insert(var_1_17, var_1_18[iter_1_2].name)
	end

	var_1_11:get("title.textNote2"):text(table.concat(var_1_17, gLanguageCsv.symbolComma))

	local var_1_19 = var_1_11:get("title")

	adapt.oneLineCenterPos(cc.p(var_1_19:get("imgBg"):xy()), {
		var_1_19:get("textNote1"),
		var_1_19:get("textNote2")
	})
	var_1_19:get("imgBg"):width(var_1_19:get("textNote1"):width() + var_1_19:get("textNote2"):width() + 40)
end

function var_0_0.initCountDown(arg_2_0, arg_2_1)
	local var_2_0 = gGameModel.role:read("yy_endtime")
	local var_2_1 = csv.yunying.yyhuodong[arg_2_0.limitDataId]
	local var_2_2, var_2_3 = time.getHourAndMin(var_2_1.endTime)
	local var_2_4 = time.getNumTimestamp(var_2_1.endDate, var_2_2, var_2_3)

	if var_2_0[arg_2_0.limitDataId] then
		var_2_4 = var_2_0[arg_2_0.limitDataId]
	end

	local var_2_5 = arg_2_1:get("time")

	bind.extend(arg_2_0, var_2_5:get("textTime"), {
		class = "cutdown_label",
		props = {
			tag = 1,
			endTime = var_2_4 + 1,
			callFunc = function()
				adapt.oneLineCenterPos(cc.p(var_2_5:get("imgBg"):xy()), {
					var_2_5:get("textNote"),
					var_2_5:get("textTime")
				})
				var_2_5:get("imgBg"):width(var_2_5:get("textNote"):width() + var_2_5:get("textTime"):width() + 40)
			end,
			endFunc = function()
				arg_2_0.limitId:set(nil)
			end,
			onNode = function(arg_5_0)
				return
			end
		}
	})
end

function var_0_0.isEnoughToDrawFunc(arg_6_0, arg_6_1)
	local var_6_0 = 1
	local var_6_1 = 10
	local var_6_2 = dataEasy.getNumByKey(game.ITEM_TICKET.limitCard)
	local var_6_3 = var_6_2

	if arg_6_1 then
		return var_6_1 <= var_6_3
	else
		return var_6_0 <= var_6_2
	end
end

function var_0_0.drawOneClickFunc(arg_7_0)
	local var_7_0 = dataEasy.getNumByKey(game.ITEM_TICKET.limitCard)

	local function var_7_1()
		gGameApp:requestServer("/game/yy/award/draw", function(arg_9_0)
			arg_7_0.topView:hide()
			audio.pauseMusic()
			arg_7_0.isShowEffect:set(true)
			arg_7_0.effectView:removeAllChildren()

			local var_9_0 = widget.addAnimationByKey(arg_7_0.effectView, "effect/CJhamawu.skel", "effect", "call", 10):scale(2.2):alignCenter(arg_7_0.effectView:size())
			local var_9_1, var_9_2, var_9_3 = dataEasy.getRawTable(arg_9_0)
			local var_9_4 = dataEasy.getItems(var_9_1, var_9_2)
			local var_9_5

			var_9_5 = csv.yunying.yyhuodong[arg_7_0.limitDataId].type == game.YYHUODONG_TYPE_ENUM_TABLE.timeLimitDraw and "effect_bj_houduan" or "effect_bj_houduan2"

			local var_9_6 = {
				isFree = false,
				drawType = "limit",
				times = 1,
				items = var_9_4,
				yyId = arg_7_0.limitDataId,
				cardsInfo = arg_7_0.cardsInfo,
				closeCb = function()
					arg_7_0.effectView:removeAllChildren()
					arg_7_0.topView:show()
				end
			}

			performWithDelay(arg_7_0.effectView, function()
				local var_11_0 = 0

				performWithDelay(arg_7_0, function()
					arg_7_0.isShowEffect:set(false)
					gGameUI:stackUI("city.drawcard.result", nil, nil, var_9_6)
				end, var_11_0)
			end, 4)
		end, arg_7_0.limitDataId, "limit_rmb1")
	end

	if var_7_0 > 0 then
		var_7_1()
	else
		local var_7_2 = dataEasy.getCfgByKey(game.ITEM_TICKET.limitCard)

		gGameUI:showDialog({
			content = string.format(gLanguageCsv.limitCardNotEnough, var_7_2.name),
			cb = function()
				arg_7_0:onXdlbClick()
			end,
			closeCb = function()
				return
			end
		})
	end
end

function var_0_0.drawTenClickFunc(arg_15_0)
	local var_15_0 = dataEasy.getNumByKey(game.ITEM_TICKET.limitCard)

	local function var_15_1()
		gGameApp:requestServer("/game/yy/award/draw", function(arg_17_0)
			arg_15_0.topView:hide()
			audio.pauseMusic()
			arg_15_0.isShowEffect:set(true)
			arg_15_0.effectView:removeAllChildren()

			local var_17_0 = widget.addAnimationByKey(arg_15_0.effectView, "effect/CJhamawu.skel", "effect", "call", 10):scale(2.2):alignCenter(arg_15_0.effectView:size())
			local var_17_1, var_17_2, var_17_3 = dataEasy.getRawTable(arg_17_0)
			local var_17_4 = dataEasy.getItems(var_17_1, var_17_2)
			local var_17_5

			var_17_5 = csv.yunying.yyhuodong[arg_15_0.limitDataId].type == game.YYHUODONG_TYPE_ENUM_TABLE.timeLimitDraw and "effect_bj_houduan" or "effect_bj_houduan2"

			local var_17_6 = {
				isFree = false,
				drawType = "limit",
				times = 10,
				items = var_17_4,
				yyId = arg_15_0.limitDataId,
				cardsInfo = arg_15_0.cardsInfo,
				closeCb = function()
					arg_15_0.topView:show()
				end
			}

			performWithDelay(arg_15_0.effectView, function()
				local var_19_0 = 0

				performWithDelay(arg_15_0, function()
					arg_15_0.isShowEffect:set(false)
					gGameUI:stackUI("city.drawcard.result", nil, nil, var_17_6)
				end, var_19_0)

				if bUseDiamond then
					userDefault.setCurrDayKey("limitDrawTip", 0)
				end
			end, 3.6666666666666665)
		end, arg_15_0.limitDataId, "limit_rmb10")
	end

	if var_15_0 >= 10 then
		var_15_1()
	else
		local var_15_2 = dataEasy.getCfgByKey(game.ITEM_TICKET.limitCard)

		gGameUI:showDialog({
			content = string.format(gLanguageCsv.limitCardNotEnough, var_15_2.name),
			cb = function()
				arg_15_0:onXdlbClick()
			end,
			closeCb = function()
				return
			end
		})
	end
end

function var_0_0.onPerviewClick(arg_23_0)
	gGameUI:stackUI("city.drawcard.preview", nil, {
		clickClose = true,
		blackLayer = true
	}, arg_23_0.curType:read(), arg_23_0.limitDataId)
end

return var_0_0
