local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("ActivityGamePassportBuyView", Dialog)

var_0_1.RESOURCE_FILENAME = "activity_game_passport_buy.json"
var_0_1.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				xMargin = 0,
				yMargin = 0,
				data = bindHelper.self("itemDatas1"),
				columnSize = bindHelper.self("midColumnSize"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1, {
						class = "icon_key",
						props = {
							data = {
								key = arg_1_3.key,
								num = arg_1_3.num
							}
						}
					})
				end
			}
		}
	},
	list1 = {
		varname = "list1",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				xMargin = 0,
				yMargin = 0,
				data = bindHelper.self("itemDatas2"),
				columnSize = bindHelper.self("midColumnSize"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					bind.extend(arg_2_0, arg_2_1, {
						class = "icon_key",
						props = {
							data = {
								key = arg_2_3.key,
								num = arg_2_3.num
							},
							onNode = function(arg_3_0)
								local var_3_0 = ccui.ImageView:create("common/btn/btn_lock1.png"):addTo(arg_3_0, 1000, "img"):xy(160, 160)
							end
						}
					})
				end
			}
		}
	},
	btn = {
		varname = "btn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBuyClick")
			}
		}
	},
	["btn.txt"] = {
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
	text = {
		varname = "text1",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 6,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	text1 = {
		varname = "text2"
	},
	text2 = {
		varname = "text3"
	},
	text3 = {
		varname = "text4"
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:initModel()

	arg_4_0.cb = arg_4_2

	local var_4_0 = csv.yunying.yyhuodong[arg_4_1]

	arg_4_0.endDate = var_4_0.endDate
	arg_4_0.activityId = arg_4_1
	arg_4_0.itemDatas1 = idlers.newWithMap({})
	arg_4_0.itemDatas2 = idlers.newWithMap({})
	arg_4_0.midColumnSize = 4

	local var_4_1 = {}
	local var_4_2 = {}
	local var_4_3 = csv.yunying.playpassport_recharge

	for iter_4_0, iter_4_1 in csvMapPairs(var_4_3) do
		if iter_4_1.huodongID == var_4_0.huodongID then
			arg_4_0.csvId = iter_4_0
		end
	end

	arg_4_0.btn:get("txt"):text(string.format(gLanguageCsv.symbolMoney, csv.recharges[var_4_3[arg_4_0.csvId].rechargeID].rmbDisplay))

	local var_4_4 = arg_4_0.yyhuodongs:read()[arg_4_0.activityId].info.level
	local var_4_5 = false

	for iter_4_2, iter_4_3 in csvPairs(csv.yunying.playpassport_award) do
		if iter_4_3.huodongID == var_4_0.huodongID and var_4_4 >= iter_4_3.level then
			for iter_4_4, iter_4_5 in csvMapPairs(iter_4_3.eliteAward) do
				for iter_4_6, iter_4_7 in ipairs(var_4_1) do
					if iter_4_7.key == iter_4_4 then
						iter_4_7.num = iter_4_7.num + iter_4_5
						var_4_5 = true

						break
					end
				end

				if var_4_5 == false then
					table.insert(var_4_1, {
						key = iter_4_4,
						num = iter_4_5
					})
				else
					var_4_5 = false
				end
			end
		end
	end

	arg_4_0.itemDatas1:update(var_4_1)

	for iter_4_8, iter_4_9 in csvPairs(csv.yunying.playpassport_award) do
		if iter_4_9.huodongID == var_4_0.huodongID and var_4_4 < iter_4_9.level then
			for iter_4_10, iter_4_11 in csvMapPairs(iter_4_9.eliteAward) do
				for iter_4_12, iter_4_13 in ipairs(var_4_2) do
					if iter_4_13.key == iter_4_10 then
						iter_4_13.num = iter_4_13.num + iter_4_11
						var_4_5 = true

						break
					end
				end

				if var_4_5 == false then
					table.insert(var_4_2, {
						key = iter_4_10,
						num = iter_4_11
					})
				else
					var_4_5 = false
				end
			end
		end
	end

	arg_4_0.itemDatas2:update(var_4_2)

	if itertools.isempty(var_4_2) then
		arg_4_0.list1:hide()
		arg_4_0.text4:show()
		arg_4_0.text4:text(gLanguageCsv.gamePassportBuyText)
	else
		arg_4_0.list1:show()
		arg_4_0.text4:hide()
	end

	Dialog.onCreate(arg_4_0)
end

function var_0_1.initModel(arg_5_0)
	arg_5_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
end

function var_0_1.onBuyClick(arg_6_0)
	local var_6_0 = time.getNumTimestamp(arg_6_0.endDate) - time.getTime()
	local var_6_1, var_6_2 = math.modf(var_6_0 / 86400)
	local var_6_3 = gLanguageCsv.passwordTitleTip
	local var_6_4 = gLanguageCsv.passwordBuyVipNote
	local var_6_5 = 7

	local function var_6_6()
		local var_7_0 = csv.yunying.playpassport_recharge

		gGameApp:payDirect(arg_6_0, {
			buyTimes = 0,
			rechargeId = var_7_0[arg_6_0.csvId].rechargeID,
			yyID = arg_6_0.activityId,
			csvID = arg_6_0.csvId,
			name = var_7_0[arg_6_0.csvId].name
		}):sdkLongTimeCb():serverCb(function()
			arg_6_0:onClose()
		end):doit()
	end

	if var_6_0 < var_6_5 * 24 * 3600 then
		local var_6_7 = string.format(gLanguageCsv.playPasswordBuyVipTips, var_6_1)

		if var_6_1 < 1 then
			var_6_7 = gLanguageCsv.passwordLastdayNote
		end

		local var_6_8 = {
			isRich = false,
			btnType = 2,
			title = var_6_3,
			cb = var_6_6,
			content = var_6_7,
			dialogParams = {
				clickClose = false
			}
		}

		gGameUI:showDialog(var_6_8)
	else
		var_6_6()
	end
end

function var_0_1.onClose(arg_9_0)
	arg_9_0:addCallbackOnExit(arg_9_0.cb)
	var_0_0.onClose(arg_9_0)
end

return var_0_1
