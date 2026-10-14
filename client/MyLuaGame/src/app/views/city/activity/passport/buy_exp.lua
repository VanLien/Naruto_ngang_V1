local var_0_0 = {
	[0] = {
		logo = "common/icon/sign_blue.png",
		name = gLanguageCsv.discount
	},
	{
		logo = "common/icon/sign_orange.png",
		name = gLanguageCsv.hotness
	},
	{
		logo = "common/icon/sign_purple.png",
		name = gLanguageCsv.limit
	},
	{
		logo = "common/icon/sign_green.png",
		name = gLanguageCsv.new
	}
}
local var_0_1 = class("ActivityPassportBuyExpView", Dialog)

var_0_1.RESOURCE_FILENAME = "activity_passport_buy_exp.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	itemList = "itemList",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["item.btnBuy.txtNode"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	expList = {
		varname = "expList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 2,
				asyncPreload = 6,
				backupCached = false,
				data = bindHelper.self("expDatas"),
				item = bindHelper.self("itemList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_3.cfg
					local var_1_1 = arg_1_1:multiget("btnBuy", "txtExp", "imgState", "txtDiscount", "txtNode")

					var_1_1.txtExp:text("+" .. var_1_0.exp)

					if var_1_0.logo then
						var_1_1.imgState:texture(var_0_0[var_1_0.logo].logo)

						if var_1_0.logo == 0 then
							local var_1_2 = string.format(gLanguageCsv.discount, var_1_0.discountValue)

							var_1_1.txtDiscount:text(var_1_2)
						else
							var_1_1.txtDiscount:text(var_0_0[var_1_0.logo].name)
						end
					else
						var_1_1.imgState:visible(false)
						var_1_1.txtDiscount:visible(false)
					end

					for iter_1_0, iter_1_1 in orderCsvPairs(csv.recharges) do
						if iter_1_0 == var_1_0.rechargeID then
							var_1_1.btnBuy:getChildByName("txtNode"):text(string.format(gLanguageCsv.symbolMoney, iter_1_1.rmbDisplay))

							break
						end
					end

					local var_1_3 = 0
					local var_1_4 = 1
					local var_1_5 = csv.yunying.yyhuodong[arg_1_0.activityId()].huodongID

					for iter_1_2, iter_1_3 in orderCsvPairs(csv.yunying.passport_award) do
						if iter_1_3.huodongID == var_1_5 then
							var_1_3 = var_1_3 + iter_1_3.needExp
							var_1_4 = iter_1_3.level

							if var_1_3 > arg_1_3.currentExp + var_1_0.exp then
								break
							end
						end
					end

					var_1_1.txtNode:text(string.format(gLanguageCsv.buyToLevel, var_1_4))
					bind.touch(arg_1_0, var_1_1.btnBuy, {
						clicksafe = true,
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_3, arg_1_3.currentExp + var_1_0.exp)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBuyClick"),
				activityId = bindHelper.self("activityId")
			}
		}
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1)
	arg_2_0:initModel()

	arg_2_0.activityId = arg_2_1
	arg_2_0.expDatas = idlers.newWithMap({})

	idlereasy.when(arg_2_0.passport, function(arg_3_0, arg_3_1)
		local var_3_0 = {}

		for iter_3_0, iter_3_1 in orderCsvPairs(csv.yunying.passport_recharge) do
			if iter_3_1.type == 2 then
				table.insert(var_3_0, {
					cfg = iter_3_1,
					currentExp = arg_3_1.exp,
					csvId = iter_3_0
				})
			end
		end

		arg_2_0.expDatas:update(var_3_0)
	end)
	Dialog.onCreate(arg_2_0, {
		blackType = 1
	})
end

function var_0_1.initModel(arg_4_0)
	arg_4_0.passport = gGameModel.role:getIdler("passport")
end

function var_0_1.onBuyClick(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = 0
	local var_5_1 = csv.yunying.yyhuodong[arg_5_0.activityId].huodongID

	for iter_5_0, iter_5_1 in orderCsvPairs(csv.yunying.passport_award) do
		if iter_5_1.huodongID == var_5_1 then
			var_5_0 = var_5_0 + iter_5_1.needExp
		end
	end

	local function var_5_2()
		gGameApp:payCustom(arg_5_0):params({
			rechargeId = arg_5_2.cfg.rechargeID,
			yyID = arg_5_0.activityId,
			csvID = arg_5_2.csvId,
			name = arg_5_2.cfg.name
		}):serverCb(function()
			arg_5_0:onClose()
		end):doit(function(arg_8_0)
			if arg_8_0 and arg_8_0.ret then
				arg_5_0:onClose()
			end
		end)
	end

	if var_5_0 < arg_5_3 then
		gGameUI:showDialog({
			title = "",
			btnType = 2,
			content = gLanguageCsv.passportBuyExpOverflow,
			cb = var_5_2
		})
	else
		var_5_2()
	end
end

function var_0_1.onClose(arg_9_0)
	Dialog.onClose(arg_9_0)
end

return var_0_1
