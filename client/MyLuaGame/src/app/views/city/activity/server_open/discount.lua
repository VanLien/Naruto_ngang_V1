local var_0_0 = {
	received = 3,
	noReach = 2,
	canReceive = 1
}
local var_0_1 = class("ServerOpenDiscountView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "activity_server_open_discount.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	["newPrice.num"] = "newNum",
	["oldPrice.num"] = "oldNum",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 20,
				data = bindHelper.self("datas"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1, {
						class = "icon_key",
						props = {
							data = arg_1_3,
							onNode = function(arg_2_0)
								arg_2_0:y(210)
							end
						}
					})

					if matchLanguage({
						"en"
					}) then
						arg_1_1:get("name"):setContentSize(220, 130)
					end

					arg_1_1:get("name"):text(uiEasy.setIconName(arg_1_3.key))
					arg_1_1:get("name"):getVirtualRenderer():setLineSpacing(-10)
				end,
				onAfterBuild = function(arg_3_0)
					arg_3_0:setItemAlignCenter()
				end
			}
		}
	},
	buyBtn = {
		varname = "buyBtn",
		binds = {
			clicksafe = true,
			event = "touch",
			methods = {
				ended = bindHelper.self("onBuy")
			}
		}
	},
	txt = {
		varname = "txt"
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	arg_4_0.activityId = arg_4_1
	arg_4_0.currDay, arg_4_0.showTab, arg_4_0.tabIndex = arg_4_3()

	arg_4_0:initModel()

	arg_4_0.data = arg_4_2
	arg_4_0.datas = idlertable.new({})
	arg_4_0.originX = arg_4_0.list:x()

	idlereasy.any({
		arg_4_0.currDay,
		arg_4_0.showTab,
		arg_4_0.yyhuodongs,
		arg_4_0.tabIndex
	}, function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		if arg_5_4 == -1 then
			return
		end

		local var_5_0 = (arg_5_3[arg_4_0.activityId] or {}).valinfo or {}
		local var_5_1 = arg_4_0.data[arg_5_2][arg_5_4]

		if var_5_1 then
			local var_5_2, var_5_3 = csvNext(var_5_1[1].cfg.costMap)

			arg_4_0.newNum:text(var_5_3)

			local var_5_4, var_5_5 = csvNext(var_5_1[1].cfg.priceShow)

			arg_4_0.oldNum:text(var_5_5)

			local var_5_6 = {}

			for iter_5_0, iter_5_1 in csvMapPairs(var_5_1[1].cfg.award) do
				if iter_5_0 == "cards" then
					for iter_5_2, iter_5_3 in ipairs(iter_5_1) do
						table.insert(var_5_6, {
							key = "card",
							num = iter_5_3
						})
					end
				else
					table.insert(var_5_6, {
						key = iter_5_0,
						num = iter_5_1
					})
				end
			end

			arg_4_0.datas:set(var_5_6)

			local var_5_7 = var_5_1[1].cfg.countType

			arg_4_0.txt:text(string.format(gLanguageCsv.activityBuyLimit, 0, var_5_1[1].cfg.buyMax))
			text.deleteAllEffect(arg_4_0.buyBtn:get("label"))

			if var_5_0[var_5_1[1].id] and var_5_0[var_5_1[1].id].times and var_5_0[var_5_1[1].id].times > 0 then
				cache.setShader(arg_4_0.buyBtn, false, "hsl_gray")
				arg_4_0.txt:text(string.format(gLanguageCsv.activityBuyLimit, 1, var_5_1[1].cfg.buyMax))
				arg_4_0.buyBtn:get("label"):text(gLanguageCsv.sellout)
				arg_4_0.buyBtn:setTouchEnabled(false)
			elseif arg_5_1 < arg_5_2 then
				cache.setShader(arg_4_0.buyBtn, false, "hsl_gray")
				arg_4_0.buyBtn:get("label"):text(gLanguageCsv.rushToPurchase)
				arg_4_0.buyBtn:setTouchEnabled(false)
			elseif var_5_7 ~= 2 and arg_5_2 <= arg_5_1 then
				cache.setShader(arg_4_0.buyBtn, false, "normal")
				arg_4_0.buyBtn:get("label"):text(gLanguageCsv.rushToPurchase)
				arg_4_0.buyBtn:setTouchEnabled(true)
				text.addEffect(arg_4_0.buyBtn:get("label"), {
					color = ui.COLORS.NORMAL.YELLOW,
					outline = {
						size = 3,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				})
			elseif var_5_7 == 2 and arg_5_2 < arg_5_1 then
				cache.setShader(arg_4_0.buyBtn, false, "hsl_gray")
				arg_4_0.buyBtn:get("label"):text(gLanguageCsv.overdue)
				arg_4_0.buyBtn:setTouchEnabled(false)
			elseif var_5_7 == 2 and arg_5_1 == arg_5_2 then
				cache.setShader(arg_4_0.buyBtn, false, "normal")
				arg_4_0.buyBtn:get("label"):text(gLanguageCsv.rushToPurchase)
				arg_4_0.buyBtn:setTouchEnabled(true)
				text.addEffect(arg_4_0.buyBtn:get("label"), {
					color = ui.COLORS.NORMAL.YELLOW,
					outline = {
						size = 3,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				})
			end
		end
	end, "discount")
end

function var_0_1.initModel(arg_6_0)
	arg_6_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_6_0.yyEndtime = gGameModel.role:read("yy_endtime")
	arg_6_0.rmb = gGameModel.role:getIdler("rmb")
end

function var_0_1.onBuy(arg_7_0)
	local var_7_0 = arg_7_0.data[arg_7_0.showTab:read()][arg_7_0.tabIndex:read()][1]
	local var_7_1, var_7_2 = csvNext(var_7_0.cfg.costMap)

	if var_7_2 > arg_7_0.rmb:read() then
		uiEasy.showDialog("rmb")
	else
		local var_7_3 = string.format(gLanguageCsv.serverOpenDiscount, var_7_2)

		gGameUI:showDialog({
			btnType = 2,
			clearFast = true,
			isRich = true,
			content = dataEasy.getTextScrollStrs(var_7_3),
			cb = function()
				gGameApp:requestServer("/game/yy/award/get", function(arg_9_0)
					gGameUI:showGainDisplay(arg_9_0)
				end, arg_7_0.activityId, var_7_0.id)
			end,
			dialogParams = {
				clickClose = false
			}
		})
	end
end

return var_0_1
