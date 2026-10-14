local var_0_0 = {
	CAN_NOT_GOTTEN = 2,
	CAN_GOTTEN = 1,
	GOTTEN = 0
}

local function var_0_1(arg_1_0, arg_1_1)
	arg_1_0:setTouchEnabled(arg_1_1)
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

local var_0_2 = class("SnowBallRewardView", Dialog)

var_0_2.RESOURCE_FILENAME = "snow_ball_reward.json"
var_0_2.RESOURCE_BINDING = {
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
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:get("normal")
					local var_2_1 = arg_2_1:get("selected")
					local var_2_2

					if arg_2_3.select then
						var_2_0:hide()

						var_2_2 = var_2_1:show()
					else
						var_2_1:hide()

						var_2_2 = var_2_0:show()
					end

					if arg_2_3.redHint then
						bind.extend(arg_2_0, arg_2_1, {
							class = "red_hint",
							props = {
								state = arg_2_0.showTab:read() ~= arg_2_2,
								specialTag = arg_2_3.redHint,
								listenData = {
									id = arg_2_3.id
								},
								onNode = function(arg_3_0)
									arg_3_0:xy(arg_2_1:width() - 10, arg_2_1:height() - 5)
								end
							}
						})
					end

					var_2_2:get("txt"):text(arg_2_3.name)
					var_2_1:setTouchEnabled(false)
					bind.touch(arg_2_0, var_2_0, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2)
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
				ended = bindHelper.defer(function(arg_4_0)
					gGameApp:requestServer("/game/yy/award/get", function(arg_5_0)
						gGameUI:showGainDisplay(arg_5_0)
					end, arg_4_0.activityId, -1)
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
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					local var_6_0 = arg_6_1:multiget("txtRank", "btnGet", "list")

					var_6_0.txtRank:text(arg_6_3.num)

					if next(arg_6_3.award) ~= nil then
						uiEasy.createItemsToList(arg_6_0, var_6_0.list, arg_6_3.award, {
							scale = 0.9,
							margin = 20
						})
					end

					bind.touch(arg_6_0, var_6_0.btnGet, {
						methods = {
							ended = functools.partial(arg_6_0.clickCell, arg_6_3.csvId)
						}
					})
					var_6_0.btnGet:get("txt"):text(arg_6_3.get == var_0_0.GOTTEN and gLanguageCsv.received or gLanguageCsv.spaceReceive)
					var_0_1(var_6_0.btnGet, arg_6_3.get == var_0_0.CAN_GOTTEN)
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
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = arg_7_1:multiget("txtRank", "btnGet", "list")

					var_7_0.txtRank:text(arg_7_3.num)

					if next(arg_7_3.award) ~= nil then
						uiEasy.createItemsToList(arg_7_0, var_7_0.list, arg_7_3.award, {
							scale = 0.9,
							margin = 20
						})
					end

					bind.touch(arg_7_0, var_7_0.btnGet, {
						methods = {
							ended = functools.partial(arg_7_0.clickCell, arg_7_3.csvId)
						}
					})
					var_7_0.btnGet:get("txt"):text(arg_7_3.get == var_0_0.GOTTEN and gLanguageCsv.received or gLanguageCsv.spaceReceive)
					var_0_1(var_7_0.btnGet, arg_7_3.get == var_0_0.CAN_GOTTEN)
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
				ended = bindHelper.defer(function(arg_8_0)
					gGameApp:requestServer("/game/yy/award/get", function(arg_9_0)
						gGameUI:showGainDisplay(arg_9_0)
					end, arg_8_0.activityId, -2)
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

function var_0_2.onCreate(arg_10_0, arg_10_1)
	arg_10_0.activityId = arg_10_1

	arg_10_0.rewardPanel1:show()
	arg_10_0.rewardPanel2:hide()
	arg_10_0:initModel()

	arg_10_0.showTab = idler.new(1)

	arg_10_0.showTab:addListener(function(arg_11_0, arg_11_1)
		arg_10_0.tabDatas:atproxy(arg_11_1).select = false
		arg_10_0.tabDatas:atproxy(arg_11_0).select = true

		if arg_10_0["rewardPanel" .. arg_11_1] then
			arg_10_0["rewardPanel" .. arg_11_1]:hide()
		end

		arg_10_0["rewardPanel" .. arg_11_0]:show()
	end)
	Dialog.onCreate(arg_10_0)
end

function var_0_2.initModel(arg_12_0)
	arg_12_0.pointDatas1 = idlers.new()
	arg_12_0.pointDatas2 = idlers.new()
	arg_12_0.days = idler.new(0)
	arg_12_0.point = idler.new(0)
	arg_12_0.tabDatas = idlers.newWithMap({
		{
			redHint = "snowballDailyCheck",
			name = gLanguageCsv.snowBallGameSignin,
			id = arg_12_0.activityId
		},
		{
			redHint = "snowballAwarding",
			name = gLanguageCsv.snowBallGameScoreAward,
			id = arg_12_0.activityId
		}
	})
	arg_12_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")

	idlereasy.when(arg_12_0.yyhuodongs, function(arg_13_0, arg_13_1)
		local var_13_0 = arg_13_1[arg_12_0.activityId] or {}

		arg_12_0.point:set(var_13_0.info.total_point)
		arg_12_0.days:set(var_13_0.info.days)

		local var_13_1 = {}
		local var_13_2 = {}
		local var_13_3 = false
		local var_13_4 = false
		local var_13_5 = csv.yunying.yyhuodong[arg_12_0.activityId].huodongID

		for iter_13_0, iter_13_1 in csvPairs(csv.yunying.snowball_award) do
			if iter_13_1.huodongID == var_13_5 then
				local var_13_6 = table.shallowcopy(iter_13_1)

				var_13_6.csvId = iter_13_0
				var_13_6.get = (var_13_0.stamps or {})[iter_13_0]

				if var_13_6.get == 1 and iter_13_1.type == 1 then
					var_13_3 = true
				elseif var_13_6.get == 1 and iter_13_1.type == 2 then
					var_13_4 = true
				end

				if iter_13_1.type == 1 then
					table.insert(var_13_1, var_13_6)
				else
					table.insert(var_13_2, var_13_6)
				end
			end
		end

		arg_12_0.pointDatas1:update(var_13_1)
		arg_12_0.pointDatas2:update(var_13_2)
		var_0_1(arg_12_0.getBtn1, var_13_3)
		var_0_1(arg_12_0.getBtn2, var_13_4)

		local var_13_7 = arg_12_0.rewardPanel2:get("textNote1")
		local var_13_8 = arg_12_0.rewardPanel2:get("textNote2")
		local var_13_9 = arg_12_0.rewardPanel2:get("textScore"):text(var_13_0.info.total_point)

		adapt.oneLinePos(var_13_7, {
			var_13_9,
			var_13_8
		}, nil, "left")
	end)
end

function var_0_2.onTabClick(arg_14_0, arg_14_1, arg_14_2)
	arg_14_0.showTab:set(arg_14_2)
end

function var_0_2.onGetBtn(arg_15_0, arg_15_1, arg_15_2)
	gGameApp:requestServer("/game/yy/award/get", function(arg_16_0)
		gGameUI:showGainDisplay(arg_16_0)
	end, arg_15_0.activityId, arg_15_2)
end

function var_0_2.onSortCards(arg_17_0, arg_17_1)
	return function(arg_18_0, arg_18_1)
		local var_18_0 = arg_18_0.get or 0.5
		local var_18_1 = arg_18_1.get or 0.5

		if var_18_0 ~= var_18_1 then
			return var_18_1 < var_18_0
		end

		return arg_18_0.csvId < arg_18_1.csvId
	end
end

return var_0_2
