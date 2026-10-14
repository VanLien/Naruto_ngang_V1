local var_0_0 = {
	reunion = 1,
	senior = 2
}
local var_0_1 = {
	gift = {
		specialTag = "reunionGift",
		onNode = function(arg_1_0)
			arg_1_0:xy(425, 154)
		end
	},
	sign = {
		specialTag = "reunionSign",
		onNode = function(arg_2_0)
			arg_2_0:xy(425, 154)
		end
	},
	reunion = {
		specialTag = "reunionTask",
		onNode = function(arg_3_0)
			arg_3_0:xy(425, 154)
		end
	},
	bindPlayer = {
		specialTag = "reunionBindGift",
		onNode = function(arg_4_0)
			arg_4_0:xy(425, 154)
		end
	}
}
local var_0_2 = {
	gift = {
		viewName = "city.activity.reunion.gift",
		sortWeight = 1,
		name = gLanguageCsv.reunionGift
	},
	sign = {
		viewName = "city.activity.reunion.sign",
		sortWeight = 2,
		name = gLanguageCsv.reunionSign
	},
	catch = {
		viewName = "city.activity.reunion.catchup",
		sortWeight = 3,
		name = gLanguageCsv.reunionCatchUp
	},
	reunion = {
		viewName = "city.activity.reunion.reunion",
		sortWeight = 4,
		name = gLanguageCsv.reunionActivity
	},
	recharge = {
		viewName = "city.activity.reunion.recharge",
		sortWeight = 5,
		name = gLanguageCsv.reunionRecharge
	},
	bindPlayer = {
		viewName = "city.activity.reunion.bind_player",
		sortWeight = 3,
		name = gLanguageCsv.reunionBind
	}
}
local var_0_3 = cc.load("mvc").ViewBase
local var_0_4 = class("ReunionView", var_0_3)

var_0_4.RESOURCE_FILENAME = "reunion.json"
var_0_4.RESOURCE_BINDING = {
	["leftPanel.item"] = "tabItem",
	leftPanel = "leftPanel",
	["leftPanel.leftTime"] = {
		varname = "leftTime"
	},
	["leftPanel.timeLabel"] = {
		varname = "timeLabel"
	},
	["leftPanel.list"] = {
		varname = "tabList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("tabItem"),
				dataOrderCmp = function(arg_5_0, arg_5_1)
					return arg_5_0.sortWeight < arg_5_1.sortWeight
				end,
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					local var_6_0 = csv.yunying.yyhuodong[id]

					adapt.setTextScaleWithWidth(arg_6_1:get("name"), var_0_2[arg_6_2].name, arg_6_1:width() - 40)
					arg_6_1:get("line"):texture("login/box_tagline.png"):visible(not arg_6_3.isLast)

					if var_0_1[arg_6_2] then
						local var_6_1 = var_0_1[arg_6_2]

						var_6_1.state = not arg_6_3.selected

						bind.extend(arg_6_0, arg_6_1, {
							class = "red_hint",
							props = var_6_1
						})
					end

					arg_6_1:get("selected"):visible(arg_6_3.selected)
					arg_6_1:get("noselected"):visible(not arg_6_3.selected)

					if arg_6_3.selected then
						text.deleteAllEffect(arg_6_1:get("name"))
						text.addEffect(arg_6_1:get("name"), {
							color = ui.NEWCOLORS.BLACK
						})
					else
						text.deleteAllEffect(arg_6_1:get("name"))
						text.addEffect(arg_6_1:get("name"), {
							color = ui.NEWCOLORS.WHITE
						})
					end

					bind.click(arg_6_0, arg_6_1, {
						method = functools.partial(arg_6_0.clickCell, arg_6_2, arg_6_3)
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	}
}

function var_0_4.onCreate(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.info
	local var_7_1 = arg_7_1.reunionRecord

	arg_7_0.reunion = gGameModel.role:getIdler("reunion")

	gGameUI.topuiManager:createView("default", arg_7_0, {
		onClose = arg_7_0:createHandler("onClose")
	}):init({
		subTitle = "ACTIVITY",
		title = gLanguageCsv.reunion
	})

	arg_7_0.subViews = {}
	arg_7_0.activityName = idler.new(arg_7_0.activityName or nil)
	arg_7_0.tabDatas = idlers.new()
	arg_7_0.yyID = arg_7_0.reunion:read().info.yyID

	local var_7_2 = csv.yunying.yyhuodong[arg_7_0.yyID].paramMap.huodong

	arg_7_0.role_type = arg_7_0.reunion:read().role_type

	local var_7_3 = not arg_7_0.activityName:read() and var_7_2[1] or arg_7_0.activityName:read()

	if arg_7_0.role_type == var_0_0.reunion and var_7_2[1] then
		arg_7_0:onTabData(var_7_3)
	elseif arg_7_0.role_type == var_0_0.senior then
		var_7_3 = ""

		for iter_7_0, iter_7_1 in pairs(var_7_2) do
			if iter_7_1 == "reunion" then
				arg_7_0:onTabData(iter_7_1)

				var_7_3 = iter_7_1
			end
		end
	end

	arg_7_0.activityName:addListener(function(arg_8_0, arg_8_1)
		if arg_8_1 then
			arg_7_0.tabDatas:atproxy(arg_8_1).selected = false
		end

		if arg_8_0 then
			arg_7_0.tabDatas:atproxy(arg_8_0).selected = true
		end

		if arg_7_0.subViews[arg_8_1] then
			arg_7_0.subViews[arg_8_1]:hide()
		end

		local var_8_0 = csv.yunying.yyhuodong[arg_7_0.yyID]

		if var_8_0 then
			local var_8_1 = var_0_2[arg_8_0]

			if var_8_1 then
				if not arg_7_0.subViews[arg_8_0] then
					local var_8_2 = {
						bindInfo = var_7_0,
						reunionRecord = var_7_1
					}

					arg_7_0.subViews[arg_8_0] = gGameUI:createView(var_8_1.viewName, arg_7_0):init(arg_7_0.yyID, var_8_2)
				else
					arg_7_0.subViews[arg_8_0]:show()
				end
			else
				printWarn("activityType(%d) was not define", var_8_0.type)
			end
		end
	end)

	if var_7_3 ~= "" then
		arg_7_0.activityName:set(var_7_3)

		if arg_7_0.role_type == var_0_0.senior then
			arg_7_0.activityName:set("bindPlayer")
		end
	end

	idlereasy.when(arg_7_0.reunion, function(arg_9_0, arg_9_1)
		local var_9_0 = arg_9_1.info.end_time - time.getTime()

		arg_7_0:setCountdown(var_9_0, arg_7_0.timeLabel, arg_7_0.leftTime)
	end)
end

function var_0_4.onTabClick(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	arg_10_0.activityName:set(arg_10_2)
end

function var_0_4.onTabData(arg_11_0, arg_11_1)
	local var_11_0 = 1
	local var_11_1 = {}
	local var_11_2 = {}
	local var_11_3 = false
	local var_11_4 = csv.yunying.yyhuodong[arg_11_0.yyID].paramMap.huodong

	for iter_11_0, iter_11_1 in ipairs(var_11_4) do
		local function var_11_5(arg_12_0)
			var_11_1[arg_12_0] = {
				selected = false,
				name = arg_12_0,
				sortWeight = var_0_2[arg_12_0].sortWeight
			}

			table.insert(var_11_2, var_11_1[arg_12_0])

			if arg_11_1 and (arg_11_1 == arg_12_0 or arg_12_0 == "bindPlayer") then
				var_11_1[arg_12_0].selected = true
				var_11_3 = true
			end
		end

		if arg_11_0.role_type == var_0_0.reunion then
			var_11_5(iter_11_1)
		elseif arg_11_0.role_type == var_0_0.senior and iter_11_1 == arg_11_1 then
			var_11_5("bindPlayer")
			var_11_5(iter_11_1)
		end
	end

	table.sort(var_11_2, function(arg_13_0, arg_13_1)
		return arg_13_0.sortWeight < arg_13_1.sortWeight
	end)

	if #var_11_2 >= 1 then
		var_11_1[var_11_2[#var_11_2].name].isLast = true
	end

	if not var_11_3 then
		local var_11_6 = math.min(var_11_0, #var_11_2)

		if var_11_6 <= 0 then
			arg_11_1 = nil

			printWarn("no open activity!!!")
		else
			local var_11_7 = var_11_1[var_11_2[var_11_6].name]

			var_11_7.selected = true
			arg_11_1 = var_11_7.name
		end
	end

	arg_11_0.tabDatas:update(var_11_1)
end

function var_0_4.setCountdown(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	arg_14_0:enableSchedule():unSchedule(1)

	arg_14_1 = arg_14_1 > 0 and arg_14_1 or 0

	if arg_14_1 == 0 then
		return
	end

	bind.extend(arg_14_0, arg_14_3, {
		class = "cutdown_label",
		props = {
			tag = 1,
			time = arg_14_1,
			strFunc = function(arg_15_0)
				return arg_15_0.str
			end,
			callFunc = function()
				return
			end,
			endFunc = function()
				arg_14_1 = arg_14_0.reunion:read().info.end_time - time.getTime()

				if arg_14_1 > 0 then
					performWithDelay(arg_14_0, function()
						arg_14_0:setCountdown(arg_14_1, arg_14_2, arg_14_3)
					end, 1)
				else
					arg_14_2:text(gLanguageCsv.activityOver)
				end
			end
		}
	})
end

function var_0_4.onCleanup(arg_19_0)
	arg_19_0.activityName = arg_19_0.activityName:read()

	var_0_3.onCleanup(arg_19_0)
end

return var_0_4
