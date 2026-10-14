local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("SpeedFabricationView", var_0_0)

local function var_0_2(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	if math.min(arg_1_3.num1, arg_1_3.num2) == 0 then
		arg_1_1:get("add"):setTouchEnabled(false)
		arg_1_1:get("sub"):setTouchEnabled(false)
		cache.setShader(arg_1_1:get("add"), false, "hsl_gray")
		cache.setShader(arg_1_1:get("sub"), false, "hsl_gray")
	end

	arg_1_1:get("sub"):setTouchEnabled(arg_1_3.number > 0)
	cache.setShader(arg_1_1:get("sub"), false, arg_1_3.number > 0 and "normal" or "hsl_gray")
	arg_1_1:get("add"):onTouch(functools.partial(arg_1_0.itemAddClick, arg_1_1, arg_1_3))
	arg_1_1:get("sub"):onTouch(functools.partial(arg_1_0.itemSubClick, arg_1_1, arg_1_3))
	arg_1_1:get("select"):onTouch(functools.partial(arg_1_0.itemClick, arg_1_1, arg_1_2, arg_1_3))
end

var_0_1.RESOURCE_FILENAME = "activity_duanwu_fabrication.json"
var_0_1.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
	down = "down",
	panel = "panel",
	list = {
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 3,
				asyncPreload = 9,
				data = bindHelper.self("showData"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					arg_2_1:get("name"):text(arg_2_3.name)
					arg_2_1:get("describe"):text(arg_2_3.desc)
					arg_2_1:get("item1"):texture(arg_2_3.icon1)
					arg_2_1:get("item2"):texture(arg_2_3.icon2)
					arg_2_1:get("select.select.icon"):visible(arg_2_3.itemSelect)
					arg_2_1:get("select.num"):text(arg_2_3.number)
					bind.extend(arg_2_0, arg_2_1:get("icon"), {
						class = "icon_key",
						props = {
							data = {
								key = arg_2_3.key
							}
						}
					})
					var_0_2(arg_2_0, arg_2_1:get("select"), arg_2_2, arg_2_3)
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick"),
				itemAddClick = bindHelper.self("onItemAddClick"),
				itemSubClick = bindHelper.self("onItemSubClick")
			}
		}
	},
	btn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("btnClick")
			}
		}
	},
	["btn.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1, arg_3_2)
	gGameUI.topuiManager:createView("title", arg_3_0, {
		onClose = arg_3_0:createHandler("onClose")
	}):init({
		subTitle = "ACTIVITY",
		title = gLanguageCsv.speedabrication
	})

	local var_3_0 = widget.addAnimation(arg_3_0.panel, "duanwuzongzi/dwj_bzz.skel", "effect_loop", 1):alignCenter(arg_3_0.panel:size()):scale(2)

	arg_3_0.zongziData = {}
	arg_3_0.zongziTab = {}

	arg_3_0:enableSchedule()

	local var_3_1 = csv.yunying.yyhuodong[arg_3_1].huodongID

	for iter_3_0, iter_3_1 in orderCsvPairs(csv.yunying.bao_zongzi_recipe) do
		if iter_3_1.huodongID == var_3_1 then
			local var_3_2, var_3_3 = csvNext(iter_3_1.mainItem)
			local var_3_4, var_3_5 = csvNext(iter_3_1.minorItem)

			if not arg_3_0.zongziTab[var_3_2] then
				arg_3_0.zongziTab[var_3_2] = {}
			end

			arg_3_0.zongziTab[var_3_2][var_3_4] = 0
		end
	end

	arg_3_0.cb = arg_3_2

	local var_3_6 = {
		6352,
		6353,
		6354
	}
	local var_3_7 = {
		6355,
		6356,
		6357
	}

	arg_3_0.item:visible(false)

	arg_3_0.activityID = arg_3_1
	arg_3_0.select = idler.new(false)
	arg_3_0.showData = idlers.newWithMap({})

	local var_3_8 = csv.items

	arg_3_0.itemSelectZ = {}
	arg_3_0.itemSelectF = {}

	for iter_3_2 = 1, 3 do
		arg_3_0.down:get("icon" .. iter_3_2):texture(var_3_8[var_3_6[iter_3_2]].icon)
		arg_3_0.down:get("item" .. iter_3_2):texture(var_3_8[var_3_7[iter_3_2]].icon)

		arg_3_0.itemSelectZ[var_3_6[iter_3_2]] = 0
		arg_3_0.itemSelectF[var_3_7[iter_3_2]] = 0
	end

	arg_3_0.itemDuanwuData = {
		{},
		{},
		{},
		{},
		{},
		{},
		{},
		{},
		{}
	}

	local var_3_9 = ui.NEWCOLORS.REDLIGHT

	idlereasy.any({
		gGameModel.role:getIdler("items"),
		arg_3_0.select
	}, function(arg_4_0, arg_4_1)
		local var_4_0 = {}

		for iter_4_0 = 1, 3 do
			local var_4_1 = 0
			local var_4_2 = 0

			if arg_4_1[var_3_6[iter_4_0]] then
				var_4_1 = arg_4_1[var_3_6[iter_4_0]] - arg_3_0.itemSelectZ[var_3_6[iter_4_0]]
			end

			if arg_4_1[var_3_7[iter_4_0]] then
				var_4_2 = arg_4_1[var_3_7[iter_4_0]] - arg_3_0.itemSelectF[var_3_7[iter_4_0]]
			end

			arg_3_0.down:get("icon" .. iter_4_0):get("num"):text(var_4_1)
			arg_3_0.down:get("icon" .. iter_4_0):get("num"):color(var_4_1 >= 1 and ui.COLORS.NORMAL.WHITE or var_3_9)
			arg_3_0.down:get("item" .. iter_4_0):get("num"):text(var_4_2)
			arg_3_0.down:get("item" .. iter_4_0):get("num"):color(var_4_2 >= 1 and ui.COLORS.NORMAL.WHITE or var_3_9)
		end

		for iter_4_1, iter_4_2 in orderCsvPairs(csv.yunying.bao_zongzi_recipe) do
			if iter_4_2.huodongID == var_3_1 then
				local var_4_3, var_4_4 = csvNext(iter_4_2.mainItem)
				local var_4_5, var_4_6 = csvNext(iter_4_2.minorItem)
				local var_4_7 = arg_4_1[var_4_3] or 0
				local var_4_8 = arg_4_1[var_4_5] or 0
				local var_4_9 = var_3_8[var_4_3].icon
				local var_4_10 = var_3_8[var_4_5].icon
				local var_4_11, var_4_12 = csvNext(iter_4_2.compoundItem)
				local var_4_13 = var_3_8[var_4_11].name
				local var_4_14 = iter_4_2.desc
				local var_4_15 = arg_3_0.itemDuanwuData[iter_4_1] and arg_3_0.itemDuanwuData[iter_4_1].itemSelect or false
				local var_4_16 = arg_3_0.itemDuanwuData[iter_4_1] and arg_3_0.itemDuanwuData[iter_4_1].number or 0
				local var_4_17 = {
					csvId = iter_4_1,
					icon1 = var_4_9,
					icon2 = var_4_10,
					id1 = var_4_3,
					id2 = var_4_5,
					key = var_4_11,
					name = var_4_13,
					num1 = var_4_7,
					num2 = var_4_8,
					desc = var_4_14,
					number = var_4_16,
					itemSelect = var_4_15
				}

				table.insert(var_4_0, var_4_17)

				arg_3_0.itemDuanwuData[iter_4_1] = var_4_17
			end
		end

		arg_3_0.showData:update(var_4_0)
	end)
end

function var_0_1.onItemClick(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	if arg_5_5.name == "ended" or arg_5_5.name == "cancelled" then
		if math.min(arg_5_4.num1, arg_5_4.num2) == 0 then
			local var_5_0

			if arg_5_4.num1 == 0 and arg_5_4.num2 == 0 then
				var_5_0 = csv.items[arg_5_4.id1].name .. "," .. csv.items[arg_5_4.id2].name
			elseif arg_5_4.num1 == 0 then
				var_5_0 = csv.items[arg_5_4.id1].name
			else
				var_5_0 = csv.items[arg_5_4.id2].name
			end

			gGameUI:showTip(string.format(gLanguageCsv.ingredientInsufficient, var_5_0))

			return
		elseif arg_5_4.number == 0 then
			gGameUI:showTip(gLanguageCsv.selectMaterials)

			return
		elseif arg_5_0.zongziData[arg_5_4.csvId] then
			arg_5_2:get("select.icon"):visible(false)

			arg_5_0.zongziData[arg_5_4.csvId] = nil
			arg_5_0.itemDuanwuData[arg_5_4.csvId].itemSelect = false
		else
			arg_5_2:get("select.icon"):visible(true)

			arg_5_0.zongziData[arg_5_4.csvId] = arg_5_0.zongziTab[arg_5_4.id1][arg_5_4.id2]
			arg_5_0.itemDuanwuData[arg_5_4.csvId].itemSelect = true
		end
	end
end

function var_0_1.addItemFunc(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_3.name == "began" then
		if arg_6_0.itemSelectZ[arg_6_2.id1] >= arg_6_2.num1 and arg_6_0.itemSelectF[arg_6_2.id2] >= arg_6_2.num2 then
			local var_6_0 = csv.items[arg_6_2.id1].name .. "," .. csv.items[arg_6_2.id2].name

			gGameUI:showTip(string.format(gLanguageCsv.ingredientInsufficient, var_6_0))

			return
		end

		if arg_6_0.itemSelectZ[arg_6_2.id1] >= arg_6_2.num1 then
			local var_6_1 = csv.items[arg_6_2.id1].name

			gGameUI:showTip(string.format(gLanguageCsv.ingredientInsufficient, var_6_1))

			return
		end

		if arg_6_0.itemSelectF[arg_6_2.id2] >= arg_6_2.num2 then
			local var_6_2 = csv.items[arg_6_2.id2].name

			gGameUI:showTip(string.format(gLanguageCsv.ingredientInsufficient, var_6_2))

			return
		end

		if math.min(arg_6_2.num1 - arg_6_0.itemSelectZ[arg_6_2.id1], arg_6_2.num2 - arg_6_0.itemSelectF[arg_6_2.id2]) >= 1 then
			arg_6_0.itemSelectZ[arg_6_2.id1] = arg_6_0.itemSelectZ[arg_6_2.id1] + 1
			arg_6_0.itemSelectF[arg_6_2.id2] = arg_6_0.itemSelectF[arg_6_2.id2] + 1
			arg_6_0.zongziTab[arg_6_2.id1][arg_6_2.id2] = arg_6_0.zongziTab[arg_6_2.id1][arg_6_2.id2] + 1
			arg_6_0.itemDuanwuData[arg_6_2.csvId].number = arg_6_0.zongziTab[arg_6_2.id1][arg_6_2.id2]
			arg_6_2.number = arg_6_0.zongziTab[arg_6_2.id1][arg_6_2.id2]

			arg_6_1:get("num"):text(arg_6_0.zongziTab[arg_6_2.id1][arg_6_2.id2])

			if arg_6_0.itemDuanwuData[arg_6_2.csvId].number >= 1 and not arg_6_0.zongziData[arg_6_2.csvId] then
				arg_6_1:get("select"):get("icon"):visible(true)

				arg_6_0.zongziData[arg_6_2.csvId] = arg_6_0.zongziTab[arg_6_2.id1][arg_6_2.id2]
				arg_6_0.itemDuanwuData[arg_6_2.csvId].itemSelect = true
			end

			if arg_6_0.zongziData[arg_6_2.csvId] then
				arg_6_0.zongziData[arg_6_2.csvId] = arg_6_0.zongziTab[arg_6_2.id1][arg_6_2.id2]
			end
		end
	elseif arg_6_3.name == "ended" or arg_6_3.name == "cancelled" then
		arg_6_0.select:set(true, true)
	end
end

function var_0_1.onItemAddClick(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	if arg_7_4.name == "click" then
		arg_7_0:unScheduleAll()
		arg_7_0:addItemFunc(arg_7_2, arg_7_3, arg_7_4)
	elseif arg_7_4.name == "began" then
		arg_7_0:schedule(function()
			arg_7_0:addItemFunc(arg_7_2, arg_7_3, arg_7_4)
		end, 0.1, 0, 1)
	elseif arg_7_4.name == "ended" or arg_7_4.name == "cancelled" then
		arg_7_0:unScheduleAll()
		arg_7_0:addItemFunc(arg_7_2, arg_7_3, arg_7_4)
	end
end

function var_0_1.subItemFunc(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if arg_9_3.name == "began" then
		if arg_9_2.number == 1 then
			if arg_9_0.zongziData[arg_9_2.csvId] then
				arg_9_1:get("select.icon"):visible(false)

				arg_9_0.zongziData[arg_9_2.csvId] = nil
				arg_9_0.itemDuanwuData[arg_9_2.csvId].itemSelect = false
			end
		elseif arg_9_2.number == 0 then
			return
		end

		arg_9_0.itemSelectZ[arg_9_2.id1] = arg_9_0.itemSelectZ[arg_9_2.id1] - 1
		arg_9_0.itemSelectF[arg_9_2.id2] = arg_9_0.itemSelectF[arg_9_2.id2] - 1
		arg_9_0.zongziTab[arg_9_2.id1][arg_9_2.id2] = arg_9_0.zongziTab[arg_9_2.id1][arg_9_2.id2] - 1
		arg_9_0.itemDuanwuData[arg_9_2.csvId].number = arg_9_0.zongziTab[arg_9_2.id1][arg_9_2.id2]

		arg_9_1:get("num"):text(arg_9_0.zongziTab[arg_9_2.id1][arg_9_2.id2])

		arg_9_2.number = arg_9_0.zongziTab[arg_9_2.id1][arg_9_2.id2]

		if arg_9_0.zongziData[arg_9_2.csvId] then
			arg_9_0.zongziData[arg_9_2.csvId] = arg_9_0.zongziTab[arg_9_2.id1][arg_9_2.id2]
		end
	elseif arg_9_3.name == "ended" or arg_9_3.name == "cancelled" then
		arg_9_0.select:set(true, true)
	end
end

function var_0_1.onItemSubClick(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	if arg_10_4.name == "click" then
		arg_10_0:unScheduleAll()
		arg_10_0:subItemFunc(arg_10_2, arg_10_3, arg_10_4)
	elseif arg_10_4.name == "began" then
		arg_10_0:schedule(function()
			arg_10_0:subItemFunc(arg_10_2, arg_10_3, arg_10_4)
		end, 0.1, 0, 1)
	elseif arg_10_4.name == "ended" or arg_10_4.name == "cancelled" then
		arg_10_0:unScheduleAll()
		arg_10_0:subItemFunc(arg_10_2, arg_10_3, arg_10_4)
	end
end

function var_0_1.btnClick(arg_12_0)
	if csvSize(arg_12_0.zongziData) == 0 then
		gGameUI:showTip(gLanguageCsv.noSelectZongZi)

		return
	end

	if arg_12_0.cb then
		arg_12_0.cb("speedMake", arg_12_0.zongziData)

		arg_12_0.zongziData = {}
		arg_12_0.zongziTab = {}
	end
end

return var_0_1
