local function var_0_0(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_0:size()

	ccui.Layout:create():size(var_1_0.width, 70):align(cc.p(0, 0), 0, 0):addTo(arg_1_0, 5, "star")
	arg_1_0:get("star"):removeAllChildren()

	if tonumber(arg_1_1) then
		local var_1_1 = arg_1_2.starInterval or 15
		local var_1_2 = arg_1_1 > 6 and 6 or arg_1_1

		for iter_1_0 = 1, var_1_2 do
			local var_1_3 = arg_1_1 - 6
			local var_1_4 = dataEasy.getStarRes(arg_1_1, iter_1_0)

			ccui.ImageView:create(var_1_4):xy(130 - var_1_1 * (var_1_2 + 1 - 2 * iter_1_0), 65):addTo(arg_1_0, 400, "star"):scale(0.37)
		end
	end
end

local var_0_1 = class("UpStarGiftView", Dialog)

var_0_1.RESOURCE_FILENAME = "activity_sxlb.json"
var_0_1.RESOURCE_BINDING = {
	tip_2 = "tip",
	box = "box",
	Item_star = "star",
	Item = "item",
	items = "items",
	btn_go = {
		varname = "btnBuy",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBuy")
			}
		}
	},
	close = {
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
			class = "listview",
			props = {
				data = bindHelper.self("upStarDatas"),
				item = bindHelper.self("item"),
				showTab = bindHelper.self("showTab"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:get("normal")
					local var_2_1 = arg_2_1:get("selected")
					local var_2_2

					if arg_2_3.select then
						var_2_0:hide()

						var_2_2 = var_2_1:show()

						var_2_2:setTouchEnabled(false)
					else
						var_2_1:hide()

						var_2_2 = var_2_0:show()

						var_2_2:setTouchEnabled(true)
					end

					var_2_2:get("txt"):text(string.format(gLanguageCsv.recordPassportDay, arg_2_3.day or 1))
					var_0_0(var_2_2, arg_2_3.star, {})
					bind.touch(arg_2_0, var_2_0, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onIndex")
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	arg_3_0.activityId = arg_3_1

	arg_3_0:initModel()

	local var_3_0 = arg_3_0.yyhuodongs:read()[arg_3_0.activityId] or {}
	local var_3_1 = var_3_0.info and var_3_0.info.day or 1

	arg_3_0.showTab = idler.new(var_3_1)

	local var_3_2 = csv.yunying.yyhuodong[arg_3_0.activityId].huodongID
	local var_3_3 = {}

	for iter_3_0, iter_3_1 in orderCsvPairs(csv.yunying.upstargift) do
		if iter_3_1.huodongID == var_3_2 then
			table.insert(var_3_3, iter_3_1)
		end
	end

	arg_3_0.upStarDatas:update(var_3_3)

	arg_3_0.datas = var_3_3

	arg_3_0.showTab:addListener(function(arg_4_0, arg_4_1)
		for iter_4_0, iter_4_1 in ipairs(var_3_3) do
			arg_3_0.upStarDatas:atproxy(iter_4_0).select = false
		end

		arg_3_0.upStarDatas:atproxy(arg_4_0).select = true
	end)
	arg_3_0:updateBuyInfo(var_3_1)
	Dialog.onCreate(arg_3_0, {
		blackType = 1
	})
end

function var_0_1.onClose(arg_5_0)
	Dialog.onClose(arg_5_0)
end

function var_0_1.initModel(arg_6_0)
	arg_6_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_6_0.upStarDatas = idlers.new()
end

function var_0_1.onIndex(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0.showTab:set(arg_7_2)
	arg_7_0:updateBuyInfo(arg_7_2)
end

function var_0_1.updateBuyInfo(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.datas[arg_8_1]

	arg_8_0.tip:text(string.format(gLanguageCsv.recordPassportDay, arg_8_1) .. gLanguageCsv.homeJieSuo)

	local var_8_1 = csv.recharges[var_8_0.rechargeID]

	arg_8_0.items:removeAllChildren()
	uiEasy.createItemsToList(arg_8_0, arg_8_0.items, var_8_0.award, {
		onAfterBuild = function()
			arg_8_0.items:setItemAlignCenter()
		end
	})

	local var_8_2 = (arg_8_0.yyhuodongs:read()[arg_8_0.activityId] or {}).stamps or {}

	if var_8_2[arg_8_1] == 1 then
		arg_8_0.btnBuy:setTouchEnabled(true)
		cache.setShader(arg_8_0.btnBuy, false, "normal")
		arg_8_0.btnBuy:get("label"):text(string.format(gLanguageCsv.symbolMoney, var_8_1.rmbDisplay))
	else
		arg_8_0.btnBuy:setTouchEnabled(false)
		cache.setShader(arg_8_0.btnBuy, false, "hsl_gray")

		if var_8_2[arg_8_1] == 2 then
			arg_8_0.btnBuy:get("label"):text(gLanguageCsv.hasBuy)
		else
			arg_8_0.btnBuy:get("label"):text(gLanguageCsv.notReach)
		end
	end
end

function var_0_1.onBuy(arg_10_0)
	local var_10_0 = arg_10_0.datas[arg_10_0.showTab:read()]

	gGameApp:payDirect(arg_10_0, {
		buyTimes = 0,
		rechargeId = var_10_0.rechargeID,
		yyID = arg_10_0.activityId,
		csvID = arg_10_0.showTab:read(),
		name = var_10_0.desc
	}):serverCb(function(arg_11_0)
		gGameUI:showGainDisplay(var_10_0.award, {
			raw = false
		})
		arg_10_0.btnBuy:setTouchEnabled(false)
		cache.setShader(arg_10_0.btnBuy, false, "hsl_gray")
		arg_10_0.btnBuy:get("label"):text(gLanguageCsv.hasBuy)
	end):doit(function(arg_12_0)
		if arg_12_0 and arg_12_0.ret then
			gGameUI:showGainDisplay(var_10_0.award, {
				raw = false
			})
			arg_10_0.btnBuy:setTouchEnabled(false)
			cache.setShader(arg_10_0.btnBuy, false, "hsl_gray")
			arg_10_0.btnBuy:get("label"):text(gLanguageCsv.hasBuy)
		end
	end)
end

return var_0_1
