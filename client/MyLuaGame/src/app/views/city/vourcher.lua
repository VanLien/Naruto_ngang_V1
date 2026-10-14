local var_0_0 = class("VourcherView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "daijinquan.json"
var_0_0.RESOURCE_BINDING = {
	rechargePanel = "rechargePanel",
	["rechargePanel.item"] = "rechargeItem",
	["rechargePanel.list"] = {
		varname = "rechargeList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				backupCached = false,
				data = bindHelper.self("rechargeDatas"),
				item = bindHelper.self("rechargeItem"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_1_0, arg_1_1)
					if arg_1_0.sortValue ~= arg_1_1.sortValue then
						return arg_1_0.sortValue > arg_1_1.sortValue
					end

					return arg_1_0.csvId < arg_1_1.csvId
				end,
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_3.cfg

					arg_2_1:get("icon"):texture(var_2_0.icon)
					arg_2_1:get("price"):text(string.format(gLanguageCsv.symbolMoney, var_2_0.rmbDisplay))
					text.addEffect(arg_2_1:get("price"), {
						outline = {
							size = 1,
							color = ui.NEWCOLORS.OUTLINE.YELLOW1
						}
					})
					arg_2_1:get("gain"):text(var_2_0.rmb)
					text.addEffect(arg_2_1:get("gain"), {
						outline = {
							size = 1,
							color = ui.NEWCOLORS.OUTLINE.WHITE1
						}
					})
					arg_2_1:get("extraInfo"):text(string.format(gLanguageCsv.voucherFirstExtra, var_2_0.firstPresent))
					arg_2_1:get("extraInfo"):visible(arg_2_3.rechargeBuyTimes == 0 and var_2_0.firstPresent ~= 0)
					bind.touch(arg_2_0, arg_2_1, {
						clicksafe = true,
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onRechargeClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_3_0, arg_3_1)
	arg_3_0:enableSchedule()

	arg_3_1 = arg_3_1 or {}

	arg_3_0:initModel()
	gGameUI.topuiManager:createView("recharge", arg_3_0, {
		onClose = arg_3_0:createHandler("onClose")
	}):init({
		title = "common/txt/txt_bt_daijinquan.png"
	})

	arg_3_0.selectRecharge = idler.new(not arg_3_1.showPrivilege and not arg_3_1.privilegeIndex)

	local var_3_0 = {}

	for iter_3_0, iter_3_1 in orderCsvPairs(csv.recharges) do
		if matchLanguage(iter_3_1.languages) and iter_3_1.type == 4 then
			var_3_0[iter_3_0] = {
				rechargeBuyTimes = 0,
				csvId = iter_3_0,
				cfg = iter_3_1
			}
		end
	end

	arg_3_0.rechargeDatas = idlers.newWithMap(var_3_0)

	idlereasy.when(arg_3_0.recharges, function(arg_4_0, arg_4_1)
		for iter_4_0, iter_4_1 in arg_3_0.rechargeDatas:pairs() do
			local var_4_0 = iter_4_1:proxy()

			var_4_0.rechargeBuyTimes = arg_3_0:getRechargeBuyTimes(iter_4_0)
			var_4_0.sortValue = var_4_0.cfg.sortValue
		end

		if arg_3_0.rechargeList.sortItems then
			arg_3_0.rechargeList:sortItems()
		end
	end)
end

function var_0_0.initModel(arg_5_0)
	arg_5_0.recharges = gGameModel.role:getIdler("recharges")
end

function var_0_0.getRechargeBuyTimes(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.recharges:read()[arg_6_1]

	if var_6_0 then
		if (var_6_0.reset or 0) > 0 then
			return 0
		end

		return var_6_0.cnt
	end

	return 0
end

function var_0_0.onRechargeClick(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	gGameApp:payCustom(arg_7_0):params({
		yyID = -1,
		rechargeId = arg_7_2,
		csvID = arg_7_3.csvId,
		name = arg_7_3.cfg.name
	}):wait(5):doit(function(arg_8_0)
		if arg_8_0 and arg_8_0.ret then
			gGameUI:showGainDisplay(arg_8_0, {
				raw = false
			})
		end
	end)
end

return var_0_0
