local var_0_0 = {
	received = 3,
	noReach = 2,
	canReceive = 1
}
local var_0_1 = class("ActivityLevelFund", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "activity_level_fund.json"
var_0_1.RESOURCE_BINDING = {
	["buyBtn.label"] = "buyLabel",
	item = "item",
	tipsPanel = "tipsPanel",
	tipsBg1 = "tipsBg1",
	tipsBg2 = "tipsBg2",
	buyBtn = {
		varname = "buyBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBuyFundClick")
			}
		}
	},
	diamondNum = {
		varname = "diamondNum"
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
				level = bindHelper.self("level"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_1_0, arg_1_1)
					if arg_1_0.state ~= arg_1_1.state then
						return arg_1_0.state < arg_1_1.state
					end

					return arg_1_0.csvId < arg_1_1.csvId
				end,
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_3.cfg
					local var_2_1 = arg_2_1:multiget("list", "num", "receivebtn", "received", "desc")

					uiEasy.createItemsToList(arg_2_0, var_2_1.list, var_2_0.award)
					var_2_1.desc:text(var_2_0.desc)
					text.addEffect(var_2_1.num, {
						color = ui.COLORS.NORMAL.FRIEND_GREEN
					})
					var_2_1.num:text(string.format("%d/%d", arg_2_0.level, var_2_0.needLevel))
					var_2_1.receivebtn:visible(arg_2_3.state ~= var_0_0.received)
					var_2_1.received:visible(arg_2_3.state == var_0_0.received)
					var_2_1.receivebtn:setTouchEnabled(false)
					cache.setShader(var_2_1.receivebtn, false, "normal")

					local var_2_2 = var_2_1.receivebtn:get("label")

					if arg_2_3.state == var_0_0.canReceive then
						var_2_1.receivebtn:setTouchEnabled(true)
						text.addEffect(var_2_2, {
							outline = {
								size = 4,
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
						bind.touch(arg_2_0, var_2_1.receivebtn, {
							methods = {
								ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
							}
						})
					elseif arg_2_3.state == var_0_0.noReach then
						text.addEffect(var_2_1.num, {
							color = ui.COLORS.NORMAL.ALERT_ORANGE
						})
						cache.setShader(var_2_1.receivebtn, false, "hsl_gray")
						text.deleteAllEffect(var_2_2)
						text.addEffect(var_2_2, {
							color = ui.COLORS.DISABLED.WHITE
						})
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onReceiveClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	arg_3_0.activityId = arg_3_1

	arg_3_0:initModel()

	local var_3_0 = csv.yunying.yyhuodong[arg_3_1]
	local var_3_1 = var_3_0.huodongID

	arg_3_0.diamondNum:text(var_3_0.paramMap.rmb)

	local var_3_2 = 0

	for iter_3_0, iter_3_1 in csvPairs(csv.yunying.levelfund) do
		if iter_3_1.huodongID == var_3_1 and iter_3_1.award.rmb then
			var_3_2 = var_3_2 + iter_3_1.award.rmb
		end
	end

	local var_3_3 = rich.createByStr(string.format(gLanguageCsv.levelFundTitle1, var_3_0.paramMap.rmb, var_3_2), 40):anchorPoint(0, 0.5):xy(arg_3_0.tipsBg1:x() + 20, arg_3_0.tipsBg1:y()):addTo(arg_3_0:getResourceNode()):z(10)
	local var_3_4 = rich.createByStr(string.format(gLanguageCsv.levelFundTitle2, ui.VIP_ICON[var_3_0.paramMap.vip]), 40):anchorPoint(0, 0.5):xy(arg_3_0.tipsBg2:x() + 20, arg_3_0.tipsBg2:y()):addTo(arg_3_0:getResourceNode()):z(10)

	var_3_3:formatText()
	var_3_4:formatText()
	arg_3_0.tipsBg1:width(var_3_3:width() + 40)
	arg_3_0.tipsBg2:width(var_3_4:width() + 40)

	arg_3_0.datas = idlers.new()

	idlereasy.when(arg_3_0.yyhuodongs, function(arg_4_0, arg_4_1)
		local var_4_0 = arg_4_1[arg_3_1] or {}

		if not var_4_0.buy then
			arg_3_0.buyBtn:setTouchEnabled(true)
			arg_3_0.buyLabel:text(gLanguageCsv.buy)
			text.addEffect(arg_3_0.buyLabel, {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		else
			arg_3_0.buyBtn:setTouchEnabled(false)
			cache.setShader(arg_3_0.buyBtn, false, "hsl_gray")
			text.deleteAllEffect(arg_3_0.buyLabel)
			arg_3_0.buyLabel:text(gLanguageCsv.hasBuy)
			text.addEffect(arg_3_0.buyLabel, {
				color = ui.COLORS.DISABLED.WHITE
			})
		end

		local var_4_1 = var_4_0.stamps or {}
		local var_4_2 = gGameModel.role:getYYHuoDongTasksProgress(arg_3_1) or {}
		local var_4_3 = {}

		for iter_4_0, iter_4_1 in csvPairs(csv.yunying.levelfund) do
			if iter_4_1.huodongID == var_3_1 then
				local var_4_4 = var_0_0.noReach

				if var_4_1[iter_4_0] == 1 then
					var_4_4 = var_0_0.canReceive
				elseif var_4_1[iter_4_0] == 0 then
					var_4_4 = var_0_0.received
				end

				table.insert(var_4_3, {
					csvId = iter_4_0,
					cfg = iter_4_1,
					state = var_4_4,
					progress = var_4_2[iter_4_0]
				})
			end
		end

		dataEasy.tryCallFunc(arg_3_0.list, "updatePreloadCenterIndex")
		arg_3_0.datas:update(var_4_3)
	end)
end

function var_0_1.initModel(arg_5_0)
	arg_5_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_5_0.level = gGameModel.role:read("level")
end

function var_0_1.onReceiveClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_3.state == var_0_0.canReceive then
		gGameApp:requestServer("/game/yy/award/get", function(arg_7_0)
			gGameUI:showGainDisplay(arg_7_0)
		end, arg_6_0.activityId, arg_6_3.csvId)
	elseif arg_6_3.state == var_0_0.noReach then
		gGameUI:showTip(gLanguageCsv.notReachedCannotGet)
	end
end

function var_0_1.onBuyFundClick(arg_8_0)
	local var_8_0 = csv.yunying.yyhuodong[arg_8_0.activityId]
	local var_8_1 = gGameModel.role:read("rmb")

	if gGameModel.role:read("vip_level") < var_8_0.paramMap.vip then
		gGameUI:showDialog({
			clearFast = true,
			isRich = true,
			btnType = 2,
			title = "",
			content = gLanguageCsv.fundVipNotEnough,
			cb = function()
				gGameUI:stackUI("city.recharge", nil)
			end,
			btnStr = gLanguageCsv.showVip,
			dialogParams = {
				clickClose = false
			}
		})

		return
	elseif var_8_1 < var_8_0.paramMap.rmb then
		uiEasy.showDialog("rmb")

		return
	end

	gGameUI:showDialog({
		isRich = true,
		btnType = 2,
		title = "",
		content = gLanguageCsv.fundBuyConfirm,
		cb = function()
			gGameApp:requestServer("/game/yy/levelfund/buy", function(arg_11_0)
				gGameUI:showTip(gLanguageCsv.buySuccess)
			end, arg_8_0.activityId)
		end,
		dialogParams = {
			clickClose = false
		}
	})
end

return var_0_1
