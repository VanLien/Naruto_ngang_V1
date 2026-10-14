local var_0_0 = {
	sellout = 3,
	refresh = 2,
	canbuy = 1
}
local var_0_1 = class("ReunionRechargeView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "reunion_recharge.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	["topPanel.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(233, 251, 229, 255)
				},
				shadow = {
					size = 6,
					color = cc.c4b(0, 0, 0, 255),
					offset = cc.size(0, -6)
				}
			}
		}
	},
	["topPanel.title_0"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(233, 251, 229, 255)
				},
				shadow = {
					size = 6,
					color = cc.c4b(0, 0, 0, 255),
					offset = cc.size(0, -6)
				}
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("datas"),
				item = bindHelper.self("item"),
				dataOrderCmp = function(arg_1_0, arg_1_1)
					if arg_1_0.state ~= arg_1_1.state then
						return arg_1_0.state < arg_1_1.state
					end

					return arg_1_0.csvId < arg_1_1.csvId
				end,
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_3.cfg
					local var_2_1 = arg_2_1:multiget("list", "times", "title", "bottomPanel", "mask", "icon", "item")

					var_2_1.title:text(var_2_0.name)
					var_2_1.icon:texture(var_2_0.res)

					if arg_2_3.status == 3 then
						var_2_1.times:visible(false)
					else
						local var_2_2 = gLanguageCsv.activityBuyLimit

						if arg_2_3.status == 1 then
							var_2_2 = gLanguageCsv.directBuyGiftDailyBuy
						end

						var_2_1.times:visible(true)
						var_2_1.times:text(string.format(var_2_2, arg_2_3.leftTimes, var_2_0.limitNum))
					end

					var_2_1.list:removeAllChildren()
					var_2_1.list:setScrollBarEnabled(false)
					var_2_1.list:setGravity(ccui.ListViewGravity.bottom)
					var_2_1.list:width(480)

					local var_2_3 = 0
					local var_2_4 = csvSize(var_2_0.item) == 1 and var_2_1.item:size().width / 2 or 0

					for iter_2_0, iter_2_1 in ipairs(dataEasy.getItemData(var_2_0.item)) do
						local var_2_5 = iter_2_1.key
						local var_2_6 = iter_2_1.num
						local var_2_7 = var_2_1.item:clone():show()
						local var_2_8 = var_2_7:size()

						bind.extend(arg_2_0, var_2_7, {
							class = "icon_key",
							props = {
								data = {
									key = var_2_5,
									num = var_2_6
								},
								onNode = function(arg_3_0)
									arg_3_0:xy(var_2_8.width / 2 + var_2_4, var_2_8.height / 2):scale(0.8)
								end
							}
						})
						var_2_1.list:pushBackCustomItem(var_2_7)
					end

					var_2_1.list:adaptTouchEnabled():setItemAlignCenter()

					local var_2_9 = var_2_1.bottomPanel:get("btn")
					local var_2_10 = var_2_1.bottomPanel:get("panel")
					local var_2_11 = var_2_1.bottomPanel:get("panel"):get("price")
					local var_2_12 = var_2_1.bottomPanel:get("panel"):get("rmb")

					var_2_9:setTouchEnabled(false)
					var_2_12:visible(false)
					cache.setShader(var_2_9, false, "normal")
					var_2_11:text(string.format(gLanguageCsv.symbolMoney, arg_2_3.price))

					if arg_2_3.state == var_0_0.canbuy then
						var_2_1.mask:hide()
						var_2_9:setTouchEnabled(true)
						bind.touch(arg_2_0, var_2_9, {
							clicksafe = true,
							methods = {
								ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
							}
						})
						text.addEffect(var_2_11, {
							color = ui.COLORS.NORMAL.WHITE,
							outline = {
								size = 4,
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
					else
						var_2_1.mask:show()
						cache.setShader(var_2_9, false, "hsl_gray")
						text.deleteAllEffect(var_2_11)
						text.addEffect(var_2_11, {
							color = ui.COLORS.DISABLED.WHITE
						})

						if arg_2_3.state == var_0_0.sellout then
							var_2_1.mask:get("label"):text(gLanguageCsv.sellout)
						else
							var_2_1.mask:get("label"):text(gLanguageCsv.nextDayRefresh5)
						end
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBuyClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1)
	arg_4_0.yyID = arg_4_1

	local var_4_0 = csv.yunying.yyhuodong[arg_4_1]

	arg_4_0:initModel()

	arg_4_0.datas = idlers.new()
	arg_4_0.clientBuyTimes = idler.new(true)

	idlereasy.any({
		arg_4_0.reunion,
		arg_4_0.clientBuyTimes
	}, function(arg_5_0, arg_5_1, arg_5_2)
		local var_5_0 = arg_5_1.recharge or {}
		local var_5_1 = {}

		for iter_5_0, iter_5_1 in csvPairs(csv.yunying.reunion_recharge) do
			if iter_5_1.huodongID == var_4_0.huodongID then
				local var_5_2 = var_0_0.canbuy
				local var_5_3 = var_5_0[iter_5_0] and var_5_0[iter_5_0][1] or 0
				local var_5_4 = dataEasy.getPayClientBuyTimes("directBuyData", arg_4_0.yyID, iter_5_0, var_5_3)
				local var_5_5 = math.max(0, iter_5_1.limitNum - var_5_4)
				local var_5_6 = iter_5_1.limitType

				if var_5_5 == 0 then
					var_5_2 = var_0_0.sellout
				end

				local var_5_7 = csv.recharges[iter_5_1.rechargeID].rmbDisplay

				table.insert(var_5_1, {
					csvId = iter_5_0,
					cfg = iter_5_1,
					state = var_5_2,
					buyTimes = var_5_4,
					leftTimes = var_5_5,
					price = var_5_7
				})
			end
		end

		dataEasy.tryCallFunc(arg_4_0.list, "updatePreloadCenterIndex")
		arg_4_0.datas:update(var_5_1)
	end)
end

function var_0_1.initModel(arg_6_0)
	arg_6_0.reunion = gGameModel.role:getIdler("reunion")
end

function var_0_1.onBuyClick(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	gGameApp:payDirect(arg_7_0, {
		rechargeId = arg_7_3.cfg.rechargeID,
		yyID = arg_7_0.yyID,
		csvID = arg_7_3.csvId,
		name = arg_7_3.cfg.name,
		buyTimes = arg_7_3.buyTimes
	}, arg_7_0.clientBuyTimes):serverCb(function()
		local var_8_0 = csv.yunying.reunion_recharge[arg_7_3.csvId]

		gGameUI:showGainDisplay(var_8_0.item, {
			raw = false
		})
	end):doit()
end

return var_0_1
