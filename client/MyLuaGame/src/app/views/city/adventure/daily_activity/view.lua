local var_0_0 = class("DailyActivityView", cc.load("mvc").ViewBase)
local var_0_1 = {
	gLanguageCsv.doubleReward,
	gLanguageCsv.additionalNumber
}

local function var_0_2(arg_1_0)
	local var_1_0 = false
	local var_1_1 = ({
		"goldActivity",
		"expActivity",
		"giftActivity",
		"fragActivity"
	})[arg_1_0]

	if not var_1_1 then
		return false
	end

	local var_1_2, var_1_3, var_1_4 = dataEasy.isDoubleHuodong(var_1_1)

	return var_1_2, 2, var_1_3, var_1_4
end

local function var_0_3(arg_2_0)
	local var_2_0, var_2_1, var_2_2 = dataEasy.isDoubleHuodong("gateDrop")

	if not var_2_0 then
		return false
	end

	local var_2_3 = csv.scene_conf

	for iter_2_0, iter_2_1 in pairs(var_2_1) do
		local var_2_4 = var_2_3[tonumber(iter_2_1.start)].gateType

		if var_2_4 == game.GATE_TYPE.dailyGold and arg_2_0 == 1 or var_2_4 == game.GATE_TYPE.dailyExp and arg_2_0 == 2 or var_2_4 == game.GATE_TYPE.gift and arg_2_0 == 3 or var_2_4 == game.GATE_TYPE.fragment and arg_2_0 == 4 then
			return true
		end
	end

	return false
end

var_0_0.RESOURCE_FILENAME = "daily_activity.json"
var_0_0.RESOURCE_BINDING = {
	item = "item",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				padding = 70,
				data = bindHelper.self("gateDatas"),
				item = bindHelper.self("item"),
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					arg_3_1:name("item" .. arg_3_3.csvId)

					local var_3_0 = arg_3_1:multiget("imgBg", "textName", "imgIcon", "flagIcon", "black", "timeInfo", "textDesc", "leftUp", "doubleFlag")

					var_3_0.imgBg:texture(arg_3_3.background)
					var_3_0.imgIcon:texture(arg_3_3.icon)
					var_3_0.textName:text(arg_3_3.title)
					var_3_0.flagIcon:visible(arg_3_3.flagIconShow)
					var_3_0.flagIcon:get("textNote"):text(var_0_1[arg_3_3.flagIconType])
					var_3_0.black:visible(arg_3_3.notOpen)
					var_3_0.timeInfo:get("textTime"):text(arg_3_3.openTime)
					var_3_0.textDesc:text(arg_3_3.desc)
					var_3_0.leftUp:get("textTimes"):text(arg_3_3.surplusTimes .. "/" .. arg_3_3.times)
					var_3_0.doubleFlag:visible(arg_3_3.isDoubleAward)
					arg_3_1:setTouchEnabled(not arg_3_3.notOpen)

					local var_3_1 = gLanguageCsv.notOpenToday

					if arg_3_3.levelNotEnough then
						var_3_0.flagIcon:visible(false)

						var_3_1 = string.format(gLanguageCsv.arrivalLevelOpen, arg_3_3.openLevel)
					end

					var_3_0.black:get("textNote"):text(var_3_1)
					bind.touch(arg_3_0, arg_3_1, {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_2, arg_3_3)
						}
					})
				end,
				onAfterBuild = function(arg_4_0)
					arg_4_0:setItemAlignCenter()
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_5_0, arg_5_1, arg_5_2)
	adapt.centerWithScreen({
		"left",
		nil,
		false
	}, {
		"right",
		nil,
		false
	}, nil, {
		{
			arg_5_0.list,
			"width"
		},
		{
			arg_5_0.list,
			"pos",
			"left"
		}
	})
	arg_5_0:initModel()
	gGameUI.topuiManager:createView("default", arg_5_0, {
		onClose = arg_5_0:createHandler("onClose")
	}):init({
		subTitle = "TRANSCRIPT",
		title = "common/txt/txt_bt_richangfuben.png"
	})

	local var_5_0 = arg_5_2

	arg_5_0.gateDatas = idlers.new()

	local var_5_1 = {
		game.PRIVILEGE_TYPE.HuodongTypeGoldTimes,
		game.PRIVILEGE_TYPE.HuodongTypeExpTimes
	}

	idlereasy.any({
		arg_5_0.huodongs,
		arg_5_0.roleLv,
		arg_5_0.trainerLevel
	}, function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		arg_5_0.day = var_5_0.day

		local var_6_0 = {}
		local var_6_1

		for iter_6_0, iter_6_1 in orderCsvPairs(csv.huodong) do
			if iter_6_1.openType ~= 0 or var_5_0.open[iter_6_0] then
				local var_6_2 = var_5_1[iter_6_1.huodongType]
				local var_6_3 = var_6_2 and dataEasy.getPrivilegeVal(var_6_2) or 0
				local var_6_4, var_6_5, var_6_6, var_6_7 = var_0_2(iter_6_1.huodongType)

				if var_6_5 == 2 and var_6_4 then
					var_6_3 = var_6_3 + var_6_6[1].count or 0
				end

				local var_6_8 = iter_6_1.times + var_6_3
				local var_6_9 = tonumber(time.getTodayStrInClock())

				if arg_6_1[var_6_9] and arg_6_1[var_6_9][iter_6_0] then
					var_6_8 = var_6_8 - arg_6_1[var_6_9][iter_6_0].times
				end

				local var_6_10 = math.max(var_6_8, 0)

				table.insert(var_6_0, {
					csvId = iter_6_0,
					background = iter_6_1.background,
					title = iter_6_1.name,
					icon = iter_6_1.icon,
					typBg = iter_6_1.typBg,
					notOpen = var_5_0.open[iter_6_0] ~= 1,
					levelNotEnough = arg_6_2 < iter_6_1.openLevel,
					openLevel = iter_6_1.openLevel,
					openTime = iter_6_1.openTimeDesc,
					desc = iter_6_1.desc,
					times = iter_6_1.times + var_6_3,
					surplusTimes = var_6_10,
					flagIconShow = var_6_4,
					flagIconType = var_6_5,
					flagIconParamMap = var_6_4 and var_6_6[1],
					isDoubleAward = var_0_3(iter_6_1.huodongType),
					sortValue = iter_6_1.sortValue
				})

				if iter_6_1.type == arg_5_1 and arg_5_0.lastCsvId == nil then
					var_6_1 = var_6_0[#var_6_0]
				end
			end
		end

		arg_5_0.gateDatas:update(var_6_0)

		if var_6_1 then
			arg_5_0:onItemClick(nil, nil, var_6_1)
		end
	end)
end

function var_0_0.initModel(arg_7_0)
	arg_7_0.huodongs = gGameModel.role:getIdler("huodongs")
	arg_7_0.roleLv = gGameModel.role:getIdler("level")
	arg_7_0.trainerLevel = gGameModel.role:getIdler("trainer_level")
end

function var_0_0.onItemClick(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0.lastCsvId = arg_8_3.csvId

	gGameUI:stackUI("city.adventure.daily_activity.gate_select", nil, {
		full = true
	}, arg_8_3.csvId, {
		show = arg_8_3.flagIconShow,
		type = arg_8_3.flagIconType,
		paramMap = arg_8_3.flagIconParamMap,
		isDoubleAward = arg_8_3.isDoubleAward
	})
end

function var_0_0.onSortCards(arg_9_0, arg_9_1)
	return function(arg_10_0, arg_10_1)
		if arg_10_0.notOpen ~= arg_10_1.notOpen then
			return arg_10_1.notOpen
		end

		return arg_10_0.sortValue < arg_10_1.sortValue
	end
end

return var_0_0
