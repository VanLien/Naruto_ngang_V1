local var_0_0 = {
	CAN_NOT_GOTTEN = 2,
	CAN_GOTTEN = 1,
	GOTTEN = 0
}
local var_0_1 = {
	[204] = false,
	[202] = false
}

local function var_0_2(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0:setTouchEnabled(arg_1_2)
	cache.setShader(arg_1_0, false, arg_1_1 and "normal" or "hsl_gray")

	if arg_1_1 then
		text.addEffect(arg_1_0:get("txt"), {
			glow = {
				color = ui.COLORS.GLOW.WHITE
			}
		})
	else
		text.deleteAllEffect(arg_1_0:get("txt"))
		text.addEffect(arg_1_0:get("txt"), {
			color = ui.COLORS.DISABLED.WHITE
		})
	end
end

local function var_0_3(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_1:multiget("txtRank", "btnGet", "list", "achvDesc", "txt")

	var_2_0.txt:text(arg_2_3.title)
	adapt.setTextAdaptWithSize(var_2_0.txt, {
		vertical = "center",
		horizontal = "center",
		maxLine = 2,
		size = cc.size(300, 70)
	})
	var_2_0.txtRank:text(arg_2_3.targetArg)

	if next(arg_2_3.award) ~= nil then
		uiEasy.createItemsToList(arg_2_0, var_2_0.list, arg_2_3.award, {
			scale = 0.9,
			margin = 20
		})
	end

	bind.touch(arg_2_0, var_2_0.btnGet, {
		methods = {
			ended = functools.partial(arg_2_0.clickCell, arg_2_3.csvId, arg_2_3.get)
		}
	})

	local var_2_1 = arg_2_3.times < arg_2_3.targetArg and string.format("%s/%s", arg_2_3.times, arg_2_3.targetArg) or gLanguageCsv.spaceReceive

	var_2_0.btnGet:get("txt"):text(arg_2_3.get == var_0_0.GOTTEN and gLanguageCsv.received or var_2_1)
	var_0_2(var_2_0.btnGet, arg_2_3.get == var_0_0.CAN_GOTTEN, true)
end

local var_0_4 = class("VolleyballRewardView", Dialog)

var_0_4.RESOURCE_FILENAME = "volleyball_reward.json"
var_0_4.RESOURCE_BINDING = {
	["rewardPanel1.rankItem"] = "rankItem1",
	rewardPanel2 = "rewardPanel2",
	["rewardPanel2.rankItem"] = "rankItem2",
	["leftPanel.tabItem"] = "tabItem",
	rewardPanel1 = "rewardPanel1",
	["topPanel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["leftPanel.tabList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("tabItem"),
				showTab = bindHelper.self("showTab"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:get("normal")
					local var_3_1 = arg_3_1:get("selected")
					local var_3_2

					if arg_3_3.select then
						var_3_0:hide()

						var_3_2 = var_3_1:show()
					else
						var_3_1:hide()

						var_3_2 = var_3_0:show()
					end

					if arg_3_3.redHint then
						bind.extend(arg_3_0, arg_3_1, {
							class = "red_hint",
							props = {
								state = arg_3_0.showTab:read() ~= arg_3_2,
								specialTag = arg_3_3.redHint,
								listenData = {
									id = arg_3_3.id
								},
								onNode = function(arg_4_0)
									arg_4_0:xy(arg_3_1:width() - 10, arg_3_1:height() - 5)
								end
							}
						})
					end

					var_3_2:get("txt"):text(arg_3_3.name)
					var_3_1:setTouchEnabled(false)
					bind.touch(arg_3_0, var_3_0, {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	["rewardPanel1.btnAllGet"] = {
		varname = "getBtn1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_5_0)
					gGameApp:requestServer("/game/yy/award/get/onekey", function(arg_6_0)
						gGameUI:showGainDisplay(arg_6_0)
					end, arg_5_0.activityId)
				end)
			}
		}
	},
	["rewardPanel1.btnAllGet.txt"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["rewardPanel1.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				days = bindHelper.self("days"),
				data = bindHelper.self("pointDatas1"),
				item = bindHelper.self("rankItem1"),
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					var_0_3(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onGetBtn")
			}
		}
	},
	["rewardPanel2.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				points = bindHelper.self("points"),
				data = bindHelper.self("pointDatas2"),
				item = bindHelper.self("rankItem2"),
				itemAction = {
					isAction = true
				},
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					var_0_3(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onGetBtn")
			}
		}
	},
	["rewardPanel2.btnAllGet"] = {
		varname = "getBtn2",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_9_0)
					gGameApp:requestServer("/game/yy/award/get/onekey", function(arg_10_0)
						gGameUI:showGainDisplay(arg_10_0)
					end, arg_9_0.activityId)
				end)
			}
		}
	},
	["rewardPanel2.btnAllGet.txt"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	}
}

function var_0_4.onCreate(arg_11_0, arg_11_1)
	arg_11_0.activityId = arg_11_1

	arg_11_0.rewardPanel1:show()
	arg_11_0.rewardPanel2:hide()
	arg_11_0:initModel()

	arg_11_0.showTab = idler.new(1)

	arg_11_0.showTab:addListener(function(arg_12_0, arg_12_1)
		arg_11_0.tabDatas:atproxy(arg_12_1).select = false
		arg_11_0.tabDatas:atproxy(arg_12_0).select = true

		if arg_11_0["rewardPanel" .. arg_12_1] then
			arg_11_0["rewardPanel" .. arg_12_1]:hide()
		end

		arg_11_0["rewardPanel" .. arg_12_0]:show()
	end)
	Dialog.onCreate(arg_11_0)
end

function var_0_4.initModel(arg_13_0)
	arg_13_0.pointDatas1 = idlers.new()
	arg_13_0.pointDatas2 = idlers.new()
	arg_13_0.tabDatas = idlers.newWithMap({
		{
			redHint = "volleyballDailyCheck",
			name = gLanguageCsv.dailyReward,
			id = arg_13_0.activityId
		},
		{
			redHint = "volleyballAwarding",
			name = gLanguageCsv.volleyballAchievementAward,
			id = arg_13_0.activityId
		}
	})
	arg_13_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")

	idlereasy.when(arg_13_0.yyhuodongs, function(arg_14_0, arg_14_1)
		local var_14_0 = arg_14_1[arg_13_0.activityId] or {}
		local var_14_1 = {}
		local var_14_2 = {}
		local var_14_3 = false
		local var_14_4 = false
		local var_14_5 = csv.yunying.yyhuodong[arg_13_0.activityId].huodongID

		for iter_14_0, iter_14_1 in csvPairs(csv.yunying.volleyball_tasks) do
			if iter_14_1.huodongID == var_14_5 then
				local var_14_6 = table.shallowcopy(iter_14_1)

				var_14_6.csvId = iter_14_0

				local var_14_7 = var_14_0.stamps or {}
				local var_14_8 = var_14_0.valsums or {}
				local var_14_9 = var_14_0.valsums1 or {}

				var_14_6.get = var_14_7[iter_14_0]

				if var_14_6.targetArg2 ~= 0 then
					var_14_6.times = var_14_9[var_14_6.targetType] and var_14_9[var_14_6.targetType][var_14_6.targetArg2] or 0
				else
					var_14_6.times = var_14_8[var_14_6.targetType] or 0
				end

				if var_14_6.get == 1 and iter_14_1.type == 1 then
					var_14_3 = true
				elseif var_14_6.get == 1 and iter_14_1.type == 2 then
					var_14_4 = true
				end

				if iter_14_1.type == 1 then
					table.insert(var_14_1, var_14_6)
				else
					table.insert(var_14_2, var_14_6)
				end
			end
		end

		arg_13_0.pointDatas1:update(var_14_1)
		arg_13_0.pointDatas2:update(var_14_2)
		var_0_2(arg_13_0.getBtn1, var_14_3, var_14_3)
		var_0_2(arg_13_0.getBtn2, var_14_4, var_14_4)
	end)
end

function var_0_4.onTabClick(arg_15_0, arg_15_1, arg_15_2)
	arg_15_0.showTab:set(arg_15_2)
end

function var_0_4.onGetBtn(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	if arg_16_3 == var_0_0.CAN_GOTTEN then
		gGameApp:requestServer("/game/yy/award/get", function(arg_17_0)
			gGameUI:showGainDisplay(arg_17_0)
		end, arg_16_0.activityId, arg_16_2)
	elseif arg_16_3 == var_0_0.GOTTEN then
		gGameUI:showTip(gLanguageCsv.taskClosed)
	else
		gGameUI:showTip(gLanguageCsv.taskUnFinished)
	end
end

function var_0_4.onSortCards(arg_18_0, arg_18_1)
	return function(arg_19_0, arg_19_1)
		local var_19_0 = arg_19_0.get or 0.5
		local var_19_1 = arg_19_1.get or 0.5

		if var_19_0 ~= var_19_1 then
			return var_19_1 < var_19_0
		end

		return arg_19_0.csvId < arg_19_1.csvId
	end
end

return var_0_4
