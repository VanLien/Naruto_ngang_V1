local var_0_0 = class("ActivityQualityExchangeHelditemView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "activity_quality_exchange_helditem.json"
var_0_0.RESOURCE_BINDING = {
	costPanel = "costPanel",
	rightItem = "rightItem",
	numList = "numList",
	btn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnClick")
			}
		}
	},
	["btn.label"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	leftItem = {
		varname = "leftItem",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onLeftItemClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1)
	arg_1_0.activityId = arg_1_1
	arg_1_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_1_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_1_0.rmb = gGameModel.role:getIdler("rmb")

	local var_1_0 = csv.yunying.yyhuodong[arg_1_1]
	local var_1_1 = var_1_0.huodongID

	arg_1_0.datas = {}

	local var_1_2

	for iter_1_0, iter_1_1 in orderCsvPairs(csv.yunying.qualityexchange) do
		if iter_1_1.huodongID == var_1_1 then
			local var_1_3, var_1_4 = next(iter_1_1.items[1])

			arg_1_0.datas[iter_1_1.quality] = {
				csvId = iter_1_0,
				cfg = iter_1_1,
				key = var_1_3,
				num = var_1_4,
				rmb = iter_1_1.costMap.rmb or 0
			}
			var_1_2 = var_1_2 or var_1_3
		end
	end

	local var_1_5 = idlereasy.new({
		key = var_1_2
	})

	bind.extend(arg_1_0, arg_1_0.rightItem, {
		class = "icon_key",
		props = {
			data = var_1_5
		}
	})
	idlereasy.any({
		arg_1_0.yyhuodongs,
		arg_1_0.vipLevel
	}, function(arg_2_0, arg_2_1, arg_2_2)
		local var_2_0 = (arg_2_1[arg_1_1] or {}).stamps or {}
		local var_2_1 = gVipCsv[arg_2_2]
		local var_2_2 = {}

		for iter_2_0, iter_2_1 in csvPairs(var_1_0.paramMap.quality) do
			table.insert(var_2_2, {
				quality = iter_2_0,
				leftTimes = iter_2_1 + (var_2_1.heldItemExchangeTimes[iter_2_0] or 0) - (var_2_0[iter_2_0] or 0)
			})
		end

		table.sort(var_2_2, function(arg_3_0, arg_3_1)
			return arg_3_0.quality < arg_3_1.quality
		end)

		local var_2_3 = {}

		for iter_2_2, iter_2_3 in ipairs(var_2_2) do
			if arg_1_0.datas[iter_2_3.quality] then
				arg_1_0.datas[iter_2_3.quality].leftTimes = iter_2_3.leftTimes
			end

			table.insert(var_2_3, {
				str = string.format(gLanguageCsv.qualityExchangeHelditemDesc, ui.QUALITYCOLOR[iter_2_3.quality], gLanguageCsv[ui.QUALITY_COLOR_TEXT[iter_2_3.quality]], iter_2_3.leftTimes > 0 and "#C0x60C456#" or "#C0xF13B54#", iter_2_3.leftTimes)
			})
		end

		beauty.textScroll({
			isRich = true,
			margin = 10,
			list = arg_1_0.numList,
			strs = var_2_3
		})
	end)

	arg_1_0.selectId = idler.new()

	idlereasy.any({
		arg_1_0.selectId,
		arg_1_0.rmb
	}, function(arg_4_0, arg_4_1, arg_4_2)
		arg_1_0.costPanel:hide()

		arg_1_0.selectData = nil

		if not arg_4_1 then
			arg_1_0.leftItem:get("icon"):show()
			arg_1_0.leftItem:get("add"):show()
			var_1_5:set({
				key = var_1_2
			})
		else
			local var_4_0 = gGameModel.held_items:find(arg_4_1)

			if var_4_0 then
				local var_4_1 = var_4_0:read("held_item_id", "advance", "card_db_id", "level")
				local var_4_2 = dataEasy.getCfgByKey(var_4_1.held_item_id).quality

				arg_1_0.leftItem:get("icon"):hide()
				arg_1_0.leftItem:get("add"):hide()
				bind.extend(arg_1_0, arg_1_0.leftItem, {
					class = "icon_key",
					props = {
						noListener = true,
						data = {
							num = 1,
							key = var_4_1.held_item_id
						},
						specialKey = {
							lv = var_4_1.level
						},
						onNode = function(arg_5_0)
							arg_5_0:setTouchEnabled(false)
						end
					}
				})

				local var_4_3 = dataEasy.getCfgByKey(var_4_1.held_item_id).quality

				arg_1_0.selectData = arg_1_0.datas[var_4_3]

				if arg_1_0.selectData then
					var_1_5:set({
						key = arg_1_0.selectData.key,
						num = arg_1_0.selectData.num
					})

					local var_4_4 = arg_1_0.costPanel:multiget("txt", "num", "icon")

					var_4_4.num:text(arg_1_0.selectData.rmb)
					text.addEffect(var_4_4.num, {
						color = arg_4_2 >= arg_1_0.selectData.rmb and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.RED
					})
					adapt.oneLineCenterPos(cc.p(200, 30), {
						var_4_4.txt,
						var_4_4.num,
						var_4_4.icon
					}, cc.p(10, 0))
					arg_1_0.costPanel:show()
				end
			end
		end
	end)
end

function var_0_0.onInit(arg_6_0)
	arg_6_0.selectId:set()
end

function var_0_0.getQualities(arg_7_0)
	local var_7_0 = {}

	for iter_7_0, iter_7_1 in pairs(arg_7_0.datas) do
		if iter_7_1.leftTimes and iter_7_1.leftTimes > 0 then
			var_7_0[iter_7_0] = iter_7_1.leftTimes
		end
	end

	return var_7_0
end

function var_0_0.onLeftItemClick(arg_8_0)
	local var_8_0 = arg_8_0:getQualities()

	if itertools.isempty(var_8_0) then
		gGameUI:showTip(gLanguageCsv.qualityExchangeHelditemTimes)

		return
	end

	gGameUI:stackUI("city.activity.quality_exchange_helditem_select", nil, nil, var_8_0, arg_8_0:createHandler("onChooseItem"))
end

function var_0_0.onChooseItem(arg_9_0, arg_9_1)
	arg_9_0.selectId:set(arg_9_1)
end

function var_0_0.onBtnClick(arg_10_0)
	if itertools.isempty(arg_10_0:getQualities()) then
		gGameUI:showTip(gLanguageCsv.qualityExchangeHelditemTimes)

		return
	end

	if not arg_10_0.selectData then
		gGameUI:showTip(gLanguageCsv.qualityExchangeFragmentChooseTip)

		return
	end

	if arg_10_0.rmb:read() < arg_10_0.selectData.rmb then
		uiEasy.showDialog("rmb")

		return
	end

	gGameUI:showDialog({
		btnType = 2,
		isRich = true,
		cb = function()
			local var_11_0 = arg_10_0.selectId:read()
			local var_11_1 = arg_10_0.selectData.csvId

			gGameApp:requestServer("/game/yy/award/exchange", function(arg_12_0)
				arg_10_0.selectId:set(nil)
				gGameUI:showGainDisplay(arg_12_0)
			end, arg_10_0.activityId, var_11_1, var_11_0, 1, 1)
		end,
		content = "#C0x57472E#" .. gLanguageCsv.qualityExchangeHelditemExchangeTip
	})
end

return var_0_0
