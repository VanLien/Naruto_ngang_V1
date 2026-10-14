local var_0_0 = {
	null = 0,
	buy = 1,
	max = 2
}
local var_0_1 = class("ActivityPrivilegeView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "activity_tequanka.json"
var_0_1.RESOURCE_BINDING = {
	list = "list",
	labelItem = "labelItem",
	btn = {
		varname = "btn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_1_0)
					return arg_1_0:onBtnClick(1)
				end)
			}
		}
	},
	labelList = {
		varname = "labelList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("datas"),
				item = bindHelper.self("labelItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("desc", "value")

					if arg_2_3.typ == "attr" then
						local var_2_1 = arg_2_3.attrNatureType == 0 and gLanguageCsv.allSprite or string.format(gLanguageCsv.someSprite, gLanguageCsv[game.NATURE_TABLE[arg_2_3.attrNatureType]])
						local var_2_2 = getLanguageAttr(arg_2_3.attrType)
						local var_2_3 = dataEasy.getAttrValueString(arg_2_3.attrType, arg_2_3.attrValue)
						local var_2_4 = cc.Label:createWithTTF(string.format("%d.%s %s ", arg_2_2, var_2_1, var_2_2), ui.FONT_PATH, 40):align(cc.p(0, 0.5), 2, 15):addTo(var_2_0.desc, 4, "num")

						text.addEffect(var_2_4, {
							color = cc.c4b(255, 253, 218, 255)
						})

						local var_2_5 = cc.Label:createWithTTF(string.format("+%s", var_2_3), ui.FONT_PATH, 42):align(cc.p(0, 0.5), 2, 15):addTo(var_2_0.value, 4, "val")

						text.addEffect(var_2_5, {
							color = cc.c4b(148, 241, 28, 255)
						})
						adapt.oneLinePos(var_2_4, var_2_5, cc.p(0, 0), "left")
					else
						local var_2_6 = arg_2_1:size()
						local var_2_7 = string.format("%d.%s", arg_2_2, arg_2_3.str)
						local var_2_8 = ""

						if arg_2_3.typ == "normal" then
							var_2_8 = arg_2_3.val
						elseif arg_2_3.typ == "percent" then
							var_2_8 = arg_2_3.val * 100 .. "%"
						end

						var_2_0.desc:text(var_2_7)
						text.addEffect(var_2_0.desc, {
							color = cc.c4b(255, 253, 218, 255)
						})
						var_2_0.value:text(var_2_8)
						text.addEffect(var_2_0.value, {
							color = cc.c4b(148, 241, 28, 255)
						})
						adapt.oneLinePos(var_2_0.desc, var_2_0.value, cc.p(0, 0), "left")
					end
				end
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	userDefault.setCurrDayKey("notShowMonthCardRedhint", true)
	arg_3_0:initModel(arg_3_1)

	local var_3_0 = var_0_1.getActivityIds()

	arg_3_0.data = {}

	for iter_3_0, iter_3_1 in ipairs(var_3_0) do
		local var_3_1 = iter_3_1.rechargeId
		local var_3_2 = iter_3_1.activityId
		local var_3_3 = {
			rechargeId = var_3_1,
			activityId = var_3_2,
			state = idler.new(var_0_0.null),
			day = idler.new(0)
		}

		arg_3_0.data[iter_3_0] = var_3_3

		local var_3_4 = csv.recharges[var_3_1]
		local var_3_5 = csv.yunying.yyhuodong[var_3_2]
		local var_3_6 = arg_3_0.list
		local var_3_7 = var_3_5.paramMap.award
		local var_3_8 = var_3_5.paramMap.most
		local var_3_9 = {
			{
				key = "rmb",
				num = var_3_7.rmb
			}
		}

		for iter_3_2, iter_3_3 in csvMapPairs(var_3_7) do
			if iter_3_2 ~= "rmb" then
				table.insert(var_3_9, {
					key = iter_3_2,
					num = iter_3_3
				})
			end
		end

		var_3_3.privilegeId = var_3_5.paramMap.privilege
		var_3_3.list = var_3_6

		uiEasy.createItemsToList(arg_3_0, var_3_6, var_3_9, {
			scale = 0.85
		})
		idlereasy.any({
			var_3_3.state,
			var_3_3.day
		}, function(arg_4_0, arg_4_1, arg_4_2)
			local var_4_0 = arg_3_0.btn
			local var_4_1 = var_4_0:get("label")

			cache.setShader(var_4_0, false, "normal")
			var_4_0:setTouchEnabled(true)
			var_4_1:alignCenter(var_4_0:size())

			if arg_4_1 == var_0_0.buy then
				var_4_1:text(gLanguageCsv.hasBuy)
				var_4_0:setTouchEnabled(false)
				cache.setShader(var_4_0, false, "hsl_gray")
			else
				var_4_1:text(string.format(gLanguageCsv.symbolMoney, var_3_4.rmbDisplay))
			end
		end)
	end

	idlereasy.when(arg_3_0.yyhuodongs, function(arg_5_0, arg_5_1)
		for iter_5_0, iter_5_1 in ipairs(arg_3_0.data) do
			if arg_5_1[iter_5_1.activityId] then
				iter_5_1.state:set(var_0_0.buy)
			else
				iter_5_1.state:set(var_0_0.null)
			end
		end
	end)
end

function var_0_1.initModel(arg_6_0, arg_6_1)
	arg_6_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")

	local var_6_0 = {
		{
			name = "lianjinRate",
			typ = "percent",
			str = gLanguageCsv.monthCardPrivilege1
		},
		{
			name = "staminaExtraMax",
			typ = "normal",
			str = gLanguageCsv.monthCardPrivilege2
		},
		{
			name = "skillPointExtraMax",
			typ = "normal",
			str = gLanguageCsv.monthCardPrivilege3
		},
		{
			name = "pwNoCD",
			str = gLanguageCsv.monthCardPrivilege4
		},
		{
			name = "lianjinFreeTimes",
			typ = "normal",
			str = gLanguageCsv.monthCardPrivilege5
		},
		{
			name = "staminaBuyFreeTimes",
			typ = "normal",
			str = gLanguageCsv.monthCardPrivilege6
		},
		{
			name = "lianJinUpstart",
			str = gLanguageCsv.monthCardPrivilege7
		},
		{
			name = "huodongFragTimes",
			typ = "normal",
			str = gLanguageCsv.monthCardPrivilege8
		},
		{
			name = "huodongFragDropRate",
			typ = "percent",
			str = gLanguageCsv.monthCardPrivilege9
		},
		{
			name = "huodongGiftTimes",
			typ = "normal",
			str = gLanguageCsv.monthCardPrivilege10
		},
		{
			name = "huodongGiftDropRate",
			typ = "percent",
			str = gLanguageCsv.monthCardPrivilege11
		},
		{
			name = "fragShopRefreshLimit",
			typ = "normal",
			str = gLanguageCsv.monthCardPrivilege12
		},
		{
			name = "mysteryShopDiscount",
			typ = "percent",
			str = gLanguageCsv.monthCardPrivilege13
		},
		{
			name = "fixShopDiscount",
			typ = "percent",
			str = gLanguageCsv.monthCardPrivilege14
		},
		{
			name = "huodongGoldTimes",
			typ = "percent",
			str = gLanguageCsv.monthCardPrivilege15
		},
		{
			name = "huodongGoldDropRate",
			typ = "percent",
			str = gLanguageCsv.monthCardPrivilege16
		},
		{
			name = "huodongExpTimes",
			typ = "percent",
			str = gLanguageCsv.monthCardPrivilege17
		},
		{
			name = "huodongExpDropRate",
			typ = "percent",
			str = gLanguageCsv.monthCardPrivilege18
		}
	}

	arg_6_0.datas = {}

	local var_6_1 = csv.yunying.yyhuodong[arg_6_1]
	local var_6_2 = var_6_1.paramMap.title

	if var_6_2 then
		local var_6_3 = gTitleCsv[var_6_2].title

		table.insert(arg_6_0.datas, {
			typ = "normal",
			str = gLanguageCsv.monthCardPrivilege19,
			val = var_6_3
		})
	end

	local var_6_4 = csv.month_card_privilege[var_6_1.paramMap.privilege]

	for iter_6_0, iter_6_1 in ipairs(var_6_0) do
		local var_6_5 = var_6_4[iter_6_1.name]

		if var_6_5 then
			iter_6_1.val = var_6_5

			table.insert(arg_6_0.datas, iter_6_1)
		end
	end

	for iter_6_2, iter_6_3 in pairs(game.ATTRDEF_ENUM_TABLE) do
		local var_6_6 = "attrNatureType" .. iter_6_3
		local var_6_7 = "attrType" .. iter_6_3
		local var_6_8 = "attrValue" .. iter_6_3

		if var_6_4[var_6_7] then
			local var_6_9 = {
				attrNatureType = var_6_4[var_6_6],
				attrType = var_6_4[var_6_7],
				attrValue = var_6_4[var_6_8]
			}

			var_6_9.typ = "attr"

			table.insert(arg_6_0.datas, var_6_9)
		end
	end

	arg_6_0.clientBuyTimes = idler.new(true)
end

function var_0_1.onBtnClick(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.data[arg_7_1]
	local var_7_1 = var_7_0.state:read()
	local var_7_2 = csv.yunying.yyhuodong[var_7_0.activityId]
	local var_7_3 = csv.recharges[var_7_0.rechargeId]

	if var_7_1 == var_0_0.null then
		gGameApp:payDirect(arg_7_0, {
			buyTimes = 0,
			rechargeId = var_7_0.rechargeId,
			yyID = var_7_0.activityId,
			csvID = arg_7_1,
			name = var_7_3.name
		}, arg_7_0.clientBuyTimes):serverCb(function()
			gGameUI:showGainDisplay({
				rmb = var_7_3.rmb
			}, {
				raw = false
			})
			gGameUI:showTip(gLanguageCsv.monthCardBuySuccess)
		end):doit()
	end
end

function var_0_1.getActivityIds()
	local var_9_0 = gGameModel.role:read("yy_open")
	local var_9_1 = {}

	for iter_9_0, iter_9_1 in ipairs(var_9_0) do
		local var_9_2 = csv.yunying.yyhuodong[iter_9_1]

		if var_9_2.type == game.YYHUODONG_TYPE_ENUM_TABLE.monthlyCard and var_9_2.clientParam.type == "tq" then
			table.insert(var_9_1, {
				rechargeId = var_9_2.paramMap.rechargeID,
				activityId = iter_9_1
			})
		end
	end

	table.sort(var_9_1, function(arg_10_0, arg_10_1)
		return arg_10_0.rechargeId < arg_10_1.rechargeId
	end)

	return var_9_1
end

return var_0_1
