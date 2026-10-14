local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("ActivityPassportBuyView", Dialog)
local var_0_2 = {
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

var_0_1.RESOURCE_FILENAME = "activity_passport_buy.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	bg4 = "bg4",
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
	itemList = {
		varname = "itemList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				backupCached = false,
				data = bindHelper.self("itemDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_3.cfg
					local var_1_1 = arg_1_1:multiget("imgTitle", "btnBuy", "txtList", "imgState", "txtDiscount", "line", "originalPrice", "icon")

					var_1_1.imgTitle:texture(var_1_0.res)

					if matchLanguage({
						"kr"
					}) then
						var_1_1.imgTitle:scale(1.9)
					end

					var_1_1.icon:texture(var_1_0.icon)

					local var_1_2 = csv.recharges
					local var_1_3 = 0

					for iter_1_0, iter_1_1 in orderCsvPairs(var_1_2) do
						if iter_1_0 == var_1_0.rechargeID then
							var_1_3 = iter_1_1.rmbDisplay

							var_1_1.btnBuy:getChildByName("txtNode"):text(string.format(gLanguageCsv.symbolMoney, iter_1_1.rmbDisplay))

							break
						end
					end

					var_1_1.originalPrice:visible(var_1_0.logo == 0)
					var_1_1.line:visible(var_1_0.logo == 0)

					if var_1_0.logo then
						var_1_1.imgState:texture(var_0_2[var_1_0.logo].logo)

						if var_1_0.logo == 0 then
							local var_1_4 = string.format(gLanguageCsv.discount, var_1_0.discountValue)

							var_1_1.txtDiscount:text(var_1_4)
							var_1_1.originalPrice:text(string.format(gLanguageCsv.symbolMoney, var_1_3 / var_1_0.discountValue * 10))
							var_1_1.line:width(var_1_1.originalPrice:width() + 20)
						else
							var_1_1.txtDiscount:text(var_0_2[var_1_0.logo].name)
						end
					else
						var_1_1.imgState:hide()
						var_1_1.txtDiscount:hide()
					end

					beauty.textScroll({
						verticalSpace = 20,
						isRich = true,
						align = "left",
						list = var_1_1.txtList,
						strs = var_1_0.desc
					})
					bind.touch(arg_1_0, var_1_1.btnBuy, {
						clicksafe = true,
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBuyClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0:initModel()

	arg_2_0.cb = arg_2_2
	arg_2_0.endDate = csv.yunying.yyhuodong[arg_2_1].endDate
	arg_2_0.activityId = arg_2_1
	arg_2_0.itemDatas = idlers.newWithMap({})

	local var_2_0 = csv.yunying.passport_recharge
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in orderCsvPairs(var_2_0) do
		if iter_2_1.type == 1 then
			table.insert(var_2_1, {
				cfg = iter_2_1,
				csvId = iter_2_0
			})
		end
	end

	arg_2_0.itemDatas:update(var_2_1)

	local var_2_2 = rich.createWithWidth(gLanguageCsv.passportBuyText, 35, nil, 1250):addTo(arg_2_0.bg4, 10):anchorPoint(0.5, 0.5):xy(345, 48):scale(0.5):formatText()

	if matchLanguage({
		"kr"
	}) then
		var_2_2:scale(0.44)
		var_2_2:xy(290, 48)
	end

	Dialog.onCreate(arg_2_0, {
		blackType = 1
	})
end

function var_0_1.initModel(arg_3_0)
	return
end

function var_0_1.onBuyClick(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = time.getNumTimestamp(arg_4_0.endDate) - time.getTime()
	local var_4_1, var_4_2 = math.modf(var_4_0 / 86400)
	local var_4_3 = gLanguageCsv.passwordTitleTip
	local var_4_4 = gLanguageCsv.passwordBuyVipNote

	local function var_4_5()
		gGameApp:payDirect(arg_4_0, {
			buyTimes = 0,
			rechargeId = arg_4_2.cfg.rechargeID,
			yyID = arg_4_0.activityId,
			csvID = arg_4_2.csvId,
			name = arg_4_2.cfg.name
		}):sdkLongTimeCb():serverCb(function()
			arg_4_0:onClose()
		end):doit()
	end

	if var_4_0 < 1209600 then
		local var_4_6 = string.format(gLanguageCsv.passwordBuyVipTips, var_4_1)

		if var_4_1 < 1 then
			var_4_6 = gLanguageCsv.passwordLastdayNote
		end

		local var_4_7 = {
			isRich = false,
			btnType = 2,
			title = var_4_3,
			cb = var_4_5,
			content = var_4_6,
			dialogParams = {
				clickClose = false
			}
		}

		gGameUI:showDialog(var_4_7)
	else
		var_4_5()
	end
end

function var_0_1.onClose(arg_7_0)
	arg_7_0:addCallbackOnExit(arg_7_0.cb)
	var_0_0.onClose(arg_7_0)
end

return var_0_1
