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
	end
end

local var_0_2 = class("SkyScraperRewardView", Dialog)

var_0_2.RESOURCE_FILENAME = "sky_scraper_reward.json"
var_0_2.RESOURCE_BINDING = {
	["rightPanel.centerItem"] = "centerItem",
	["leftPanel.barPanel"] = "barPanel",
	leftPanel = "leftPanel",
	["rightPanel.tabItem"] = "tabItem",
	["leftPanel.max"] = "max",
	["leftPanel.icon"] = "icon",
	["leftPanel.barPanel.txt"] = "barTxt",
	["topPanel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["leftPanel.bar"] = {
		varname = "bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				data = bindHelper.self("curPagePro")
			}
		}
	},
	["leftPanel.box"] = {
		varname = "box",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBoxClick")
			}
		}
	},
	["rightPanel.tabList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				padding = 5,
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
									arg_3_0:xy(arg_2_1:width() + 5, arg_2_1:height() + 5)
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
	["rightPanel.centerList"] = {
		varname = "centerList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				padding = 5,
				data = bindHelper.self("centerData"),
				item = bindHelper.self("centerItem"),
				itemAction = {
					isAction = true
				},
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("icon", "taskName", "taskNumTxt", "btnGet", "itemList", "got")

					if next(arg_4_3.award) ~= nil then
						uiEasy.createItemsToList(arg_4_0, var_4_0.itemList, arg_4_3.award, {
							scale = 0.7,
							margin = 20
						})
					end

					var_4_0.taskName:text(arg_4_3.label)
					var_4_0.icon:get("txt"):text(arg_4_3.points)

					local var_4_1 = arg_4_3.had or 0

					var_4_0.taskNumTxt:text(var_4_1 .. "/" .. arg_4_3.params)
					bind.touch(arg_4_0, var_4_0.btnGet, {
						methods = {
							ended = functools.partial(arg_4_0.clickCell, arg_4_3.csvId)
						}
					})

					if arg_4_3.get == var_0_0.GOTTEN then
						var_4_0.btnGet:visible(false)
						var_4_0.got:visible(true)
						var_4_0.taskNumTxt:visible(false)
					else
						var_0_1(var_4_0.btnGet, arg_4_3.get == var_0_0.CAN_GOTTEN)
						text.addEffect(var_4_0.taskNumTxt, {
							color = var_4_1 >= arg_4_3.params and cc.c4b(96, 196, 86, 255) or cc.c4b(247, 107, 67, 255)
						})
						var_4_0.btnGet:visible(true)
						var_4_0.got:visible(false)
						var_4_0.taskNumTxt:visible(true)
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onGetBtn")
			}
		}
	},
	["rightPanel.btnOneKey"] = {
		varname = "getBtn1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onOneKey")
			}
		}
	},
	["rightPanel.btnOneKey.txt"] = {
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

function var_0_2.onCreate(arg_5_0, arg_5_1)
	arg_5_0.activityId = arg_5_1
	arg_5_0.showTab = idler.new(1)

	arg_5_0:initModel()
	idlereasy.when(arg_5_0.yyhuodongs, function(arg_6_0, arg_6_1)
		local var_6_0 = arg_6_1[arg_5_0.activityId] or {}

		arg_5_0.yydata = var_6_0

		arg_5_0:initLeft()
		arg_5_0:initRight(arg_5_0.activityId)
	end)
	arg_5_0.showTab:addListener(function(arg_7_0, arg_7_1)
		arg_5_0.tabDatas:atproxy(arg_7_1).select = false
		arg_5_0.tabDatas:atproxy(arg_7_0).select = true

		arg_5_0:initRight(arg_5_0.activityId)
	end)
	Dialog.onCreate(arg_5_0)
end

function var_0_2.initModel(arg_8_0)
	arg_8_0.centerData = idlers.newWithMap({})
	arg_8_0.curPagePro = idler.new(0)
	arg_8_0.tabDatas = idlers.newWithMap({
		{
			redHint = "skyScraperSetTask",
			name = gLanguageCsv.skyScraperS,
			id = arg_8_0.activityId
		},
		{
			redHint = "skyScraperScoreTask",
			name = gLanguageCsv.skyScraperScoreTask,
			id = arg_8_0.activityId
		},
		{
			redHint = "skyScraperPerfectStructures",
			name = gLanguageCsv.skyScraperPerfectStructures,
			id = arg_8_0.activityId
		}
	})
	arg_8_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
end

function var_0_2.onTabClick(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0.showTab:set(arg_9_2)
end

function var_0_2.onGetBtn(arg_10_0, arg_10_1, arg_10_2)
	gGameApp:requestServer("/game/yy/skyscraper/awards", function(arg_11_0)
		gGameUI:showGainDisplay(arg_11_0)
	end, arg_10_0.activityId, arg_10_2, 0)
end

function var_0_2.initLeft(arg_12_0)
	arg_12_0.huodongId = csv.yunying.yyhuodong[arg_12_0.activityId].huodongID

	local var_12_0 = csv.yunying.skyscraper_medals
	local var_12_1 = (arg_12_0.yydata.info or {}).task_points or 0
	local var_12_2 = 0
	local var_12_3 = arg_12_0.yydata.stamps1 or {}
	local var_12_4 = 0
	local var_12_5 = 1
	local var_12_6 = 0

	for iter_12_0, iter_12_1 in orderCsvPairs(var_12_0) do
		var_12_5 = iter_12_1.huodongID == arg_12_0.huodongId and iter_12_1.medalLevel > var_12_0[var_12_5].medalLevel and iter_12_0 or var_12_5
	end

	for iter_12_2, iter_12_3 in orderCsvPairs(var_12_0) do
		if iter_12_3.huodongID == arg_12_0.huodongId then
			var_12_4 = var_12_4 + iter_12_3.points

			if var_12_1 < var_12_4 then
				var_12_6 = iter_12_2
				var_12_2 = var_12_1 - (var_12_4 - iter_12_3.points)

				break
			end
		end
	end

	if var_12_6 == 0 then
		var_12_6 = var_12_5

		arg_12_0.curPagePro:set(100)
		arg_12_0.max:visible(true)
		arg_12_0.barPanel:visible(false)
	else
		arg_12_0.curPagePro:set(math.min(100, var_12_2 / var_12_0[var_12_6].points * 100))
		arg_12_0.max:visible(false)
		arg_12_0.barPanel:visible(true)
		arg_12_0.barTxt:text(var_12_2 .. "/" .. var_12_0[var_12_6].points)
	end

	arg_12_0.icon:texture(var_12_0[var_12_6].resource)
	arg_12_0.icon:get("imgRank"):texture(var_12_0[var_12_6].resourceNum)
	arg_12_0.icon:get("textRank"):text(gLanguageCsv[var_12_0[var_12_6].medalsName])
	arg_12_0.icon:get("textRank"):setTextColor(cc.c3b(unpack(var_12_0[var_12_6].color)))

	local var_12_7 = false

	for iter_12_4, iter_12_5 in pairs(var_12_3) do
		if iter_12_5 == 1 then
			var_12_7 = true

			break
		end
	end

	arg_12_0.box:visible(true)

	if var_12_7 then
		local var_12_8 = widget.addAnimationByKey(arg_12_0.leftPanel, "effect/jiedianjiangli.skel", "effect", "effect_loop", 1):xy(arg_12_0.box:x(), arg_12_0.box:y() - 50)
	else
		arg_12_0.leftPanel:removeChildByName("effect")

		if curMedal == var_12_0[var_12_5].medalLevel + 1 then
			arg_12_0.box:visible(false)
			arg_12_0.leftPanel:removeChildByName("effect")
		end
	end
end

function var_0_2.initRight(arg_13_0, arg_13_1)
	local var_13_0 = {}
	local var_13_1 = {}
	local var_13_2 = {}
	local var_13_3 = false
	local var_13_4 = csv.yunying.yyhuodong[arg_13_1].huodongID
	local var_13_5 = arg_13_0.yydata.info or {}

	for iter_13_0, iter_13_1 in csvPairs(csv.yunying.skyscraper_tasks) do
		if iter_13_1.huodongID == var_13_4 then
			local var_13_6 = table.shallowcopy(iter_13_1)

			var_13_6.csvId = iter_13_0
			var_13_6.get = (arg_13_0.yydata.stamps or {})[iter_13_0]

			if var_13_6.get == 1 and iter_13_1.type == 1 then
				var_13_3 = true
			elseif var_13_6.get == 1 and iter_13_1.type == 2 then
				var_13_3 = true
			elseif var_13_6.get == 1 and iter_13_1.type == 3 then
				var_13_3 = true
			end

			if iter_13_1.type == 1 then
				var_13_6.had = var_13_5.floors

				table.insert(var_13_0, var_13_6)
			elseif iter_13_1.type == 2 then
				var_13_6.had = var_13_5.points

				table.insert(var_13_1, var_13_6)
			elseif iter_13_1.type == 3 then
				var_13_6.had = var_13_5.perfections

				table.insert(var_13_2, var_13_6)
			end
		end
	end

	if arg_13_0.showTab:read() == 1 then
		arg_13_0.centerData:update(var_13_0)
	elseif arg_13_0.showTab:read() == 2 then
		arg_13_0.centerData:update(var_13_1)
	else
		arg_13_0.centerData:update(var_13_2)
	end

	var_0_1(arg_13_0.getBtn1, var_13_3)
end

function var_0_2.onBoxClick(arg_14_0)
	arg_14_0.huodongId = csv.yunying.yyhuodong[arg_14_0.activityId].huodongID

	local var_14_0 = arg_14_0.yydata.stamps1 or {}
	local var_14_1 = (arg_14_0.yydata.info or {}).task_points or 0
	local var_14_2 = {}
	local var_14_3 = 0

	for iter_14_0, iter_14_1 in orderCsvPairs(csv.yunying.skyscraper_medals) do
		if iter_14_1.huodongID == arg_14_0.huodongId then
			var_14_3 = var_14_3 + iter_14_1.points

			if var_14_1 < var_14_3 then
				var_14_2 = iter_14_1.award

				break
			end
		end
	end

	local var_14_4 = false
	local var_14_5

	for iter_14_2, iter_14_3 in pairs(var_14_0) do
		if iter_14_3 == 1 then
			var_14_4 = true

			if var_14_5 == nil then
				var_14_5 = iter_14_2
			elseif iter_14_2 < var_14_5 then
				var_14_5 = iter_14_2
			end
		end
	end

	if var_14_4 then
		gGameApp:requestServer("/game/yy/skyscraper/awards", function(arg_15_0)
			gGameUI:showGainDisplay(arg_15_0)
		end, arg_14_0.activityId, var_14_5, 1)
	elseif itertools.size(var_14_2) ~= 0 then
		local var_14_6 = gLanguageCsv.skyScraperBoxTip

		gGameUI:showBoxDetail({
			state = 1,
			data = var_14_2,
			content = var_14_6
		})
	end
end

function var_0_2.onSortCards(arg_16_0, arg_16_1)
	return function(arg_17_0, arg_17_1)
		local var_17_0 = arg_17_0.get or 0.5
		local var_17_1 = arg_17_1.get or 0.5

		if var_17_0 ~= var_17_1 then
			return var_17_1 < var_17_0
		end

		return arg_17_0.csvId < arg_17_1.csvId
	end
end

function var_0_2.onOneKey(arg_18_0)
	gGameApp:requestServer("/game/yy/award/get/onekey", function(arg_19_0)
		gGameUI:showGainDisplay(arg_19_0)
	end, arg_18_0.activityId)
end

return var_0_2
