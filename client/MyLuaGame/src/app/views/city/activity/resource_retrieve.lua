local var_0_0 = {
	equipItems = 5,
	energyItems = 6,
	advanceItems = 4,
	roleExp = 1,
	gold = 2,
	expItems = 3
}
local var_0_1 = {
	gold = gLanguageCsv.gold,
	roleExp = gLanguageCsv.experience,
	advanceItems = gLanguageCsv.advanceMaterial,
	expItems = gLanguageCsv.experienceMaterial,
	equipItems = gLanguageCsv.accessoriesDrawing,
	energyItems = gLanguageCsv.energyItems
}
local var_0_2 = {
	equipItems = "icon_sptz.png",
	energyItems = "icon_nlhx.png",
	advanceItems = "icon_jjcl.png",
	roleExp = "icon_wjjy.png",
	gold = "icon_jb.png",
	expItems = "icon_jlyl.png"
}
local var_0_3 = {
	FREE = 1,
	ALL = 2,
	NOT = 0
}
local var_0_4 = {
	[0] = gLanguageCsv.canRetrieve,
	gLanguageCsv.canAlsoRetrieve,
	gLanguageCsv.haveRetrieved
}
local var_0_5 = class("ActivityResourceRetrieve", cc.load("mvc").ViewBase)

var_0_5.RESOURCE_FILENAME = "activity_resource_retrieve.json"
var_0_5.RESOURCE_BINDING = {
	item = "item",
	["item.textCount1"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(178, 119, 0, 255)
				}
			}
		}
	},
	["item.textCount2"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(178, 119, 0, 255)
				}
			}
		}
	},
	["item.btnFree.price"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["item.btnBuy.textBuy"] = {
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
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("itemsData"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_0.initItem(arg_1_1, arg_1_2, arg_1_3)
				end,
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_2_0, arg_2_1)
					return arg_2_0.order < arg_2_1.order
				end
			},
			handlers = {
				initItem = bindHelper.self("initItem")
			}
		}
	}
}

function var_0_5.onCreate(arg_3_0, arg_3_1)
	arg_3_0.activityId = arg_3_1

	arg_3_0:initModel()
	arg_3_0:initData()
end

function var_0_5.initModel(arg_4_0)
	arg_4_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_4_0.yyOpen = gGameModel.role:read("yy_open")
	arg_4_0.itemsData = idlertable.new({})
	arg_4_0.roleLv = gGameModel.role:getIdler("level")
	arg_4_0.rmb = gGameModel.role:getIdler("rmb")
end

function var_0_5.initData(arg_5_0)
	local var_5_0 = csv.yunying.yyhuodong[arg_5_0.activityId]
	local var_5_1 = var_5_0.clientParam
	local var_5_2 = var_5_0.huodongID

	idlereasy.any({
		arg_5_0.yyhuodongs,
		arg_5_0.rmb
	}, function(arg_6_0, arg_6_1, arg_6_2)
		local var_6_0 = arg_6_1[arg_5_0.activityId] or {}

		if var_6_0.lastday ~= tonumber(time.getTodayStrInClock()) then
			return
		end

		local var_6_1 = var_6_0.info.level
		local var_6_2 = {}

		for iter_6_0, iter_6_1 in csvPairs(csv.yunying.retrieve) do
			if iter_6_1.huodongID == var_5_2 and var_6_1 == iter_6_1.level then
				var_6_2 = iter_6_1
			end
		end

		local var_6_3 = {}
		local var_6_4 = {}
		local var_6_5 = var_6_0.info.days > var_5_1.limit and var_5_1.limit or var_6_0.info.days
		local var_6_6 = var_5_1.dayUpd[var_6_5]

		for iter_6_2, iter_6_3 in csvMapPairs(var_6_2) do
			if iter_6_2 ~= "cost" and iter_6_2 ~= "level" and iter_6_2 ~= "huodongID" then
				local var_6_7 = {
					percent = 100,
					key = iter_6_2,
					item = {},
					retrieveState = var_0_3.NOT
				}
				local var_6_8 = {}

				for iter_6_4, iter_6_5 in csvMapPairs(iter_6_3) do
					table.insert(var_6_8, {
						item = iter_6_4,
						count = iter_6_5 * var_6_6
					})
				end

				if #var_6_8 ~= 0 then
					var_6_7.order = var_0_0[iter_6_2] or 100

					if var_6_0.retrieve_award ~= nil then
						if type(var_6_0.retrieve_award[iter_6_2]) == "table" and var_6_0.retrieve_award[iter_6_2].rmb == 1 then
							var_6_7.retrieveState = var_0_3.ALL
							var_6_7.percent = 0
						elseif type(var_6_0.retrieve_award[iter_6_2]) == "table" and var_6_0.retrieve_award[iter_6_2].free == 1 then
							var_6_7.retrieveState = var_0_3.FREE
							var_6_7.percent = 100 - var_5_1.freeProportion
						else
							var_6_7.retrieveState = var_0_3.NOT
							var_6_7.percent = 100
						end
					end

					var_6_7.item = var_6_8
					var_6_3[iter_6_2] = var_6_7
				end
			elseif iter_6_2 == "cost" then
				var_6_4 = iter_6_3
			end
		end

		for iter_6_6, iter_6_7 in csvMapPairs(var_6_4) do
			local var_6_9 = var_5_1.rmbUpd[var_6_5] * iter_6_7

			if var_6_3[iter_6_6] then
				var_6_3[iter_6_6].cost = math.ceil(var_6_9)
				var_6_3[iter_6_6].canBuy = arg_6_2 >= var_6_3[iter_6_6].cost
			end
		end

		dataEasy.tryCallFunc(arg_5_0.list, "updatePreloadCenterIndex")
		arg_5_0.itemsData:set(var_6_3)
	end)
	arg_5_0.roleLv:addListener(function(arg_7_0, arg_7_1)
		print("curval == oldval", arg_7_0, arg_7_1)

		if arg_7_0 == arg_7_1 then
			return
		end

		gGameUI:stackUI("common.upgrade_notice", nil, nil, arg_7_1)
	end, true)
end

function var_0_5.initItem(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = csv.yunying.yyhuodong[arg_8_0.activityId].clientParam.freeProportion
	local var_8_1 = arg_8_2:get("textType")
	local var_8_2 = arg_8_2:get("btnFree")
	local var_8_3 = arg_8_2:get("btnBuy")
	local var_8_4 = arg_8_2:get("imgFound")
	local var_8_5 = arg_8_2:get("imgAllFound")
	local var_8_6 = arg_8_2:get("textCount")
	local var_8_7 = 0

	if arg_8_4.retrieveState == var_0_3.NOT then
		var_8_4:hide()
		var_8_5:hide()
		var_8_2:show()
		var_8_3:show()
		arg_8_2:get("textState"):text(var_0_4[0])
	elseif arg_8_4.retrieveState == var_0_3.FREE then
		var_8_4:show()
		var_8_5:hide()
		var_8_2:hide()
		var_8_3:show()
		arg_8_2:get("textState"):text(var_0_4[1])
	elseif arg_8_4.retrieveState == var_0_3.ALL then
		var_8_4:hide()
		var_8_5:show()
		var_8_3:hide()
		var_8_2:hide()
		arg_8_2:get("textState"):text(var_0_4[2])
	else
		printWarn("retrieveState error %s ", arg_8_4.retrieveState)
	end

	if matchLanguage({
		"en"
	}) then
		arg_8_2:get("img3"):width(arg_8_2:get("textState"):width() + 40)
	end

	local var_8_8 = arg_8_2:get("textCount1")
	local var_8_9 = arg_8_2:get("textCount2")
	local var_8_10 = arg_8_2:get("imgIcon1")
	local var_8_11 = arg_8_2:get("imgIcon2")
	local var_8_12 = arg_8_4.item
	local var_8_13 = math.floor

	local function var_8_14(arg_9_0, arg_9_1)
		if arg_9_1 == 100 then
			return math.floor(arg_9_0)
		elseif arg_9_1 ~= 0 then
			return math.floor(arg_9_0 - math.floor(arg_9_0 * var_8_0 / 100))
		elseif arg_9_1 == 0 then
			return math.floor(arg_9_0)
		end
	end

	var_8_10:texture(dataEasy.getIconResByKey(var_8_12[1].item))
	var_8_8:text(var_8_14(var_8_12[1].count, arg_8_4.percent))

	if var_8_12[2] ~= nil then
		var_8_8:x(169)
		var_8_10:x(var_8_8:x() - var_8_8:size().width / 2 - 10)
		var_8_9:text(var_8_14(var_8_12[2].count, arg_8_4.percent)):show()
		var_8_9:x(394)
		var_8_11:x(var_8_9:x() - var_8_9:size().width / 2 - 10)
		var_8_11:texture(dataEasy.getIconResByKey(var_8_12[2].item))
	else
		var_8_8:x(264)
		var_8_10:x(var_8_8:x() - var_8_8:size().width / 2 - 10)
		var_8_9:hide()
		var_8_11:hide()
	end

	arg_8_2:get("imgAwardIcon"):texture("activity/resource_find/" .. var_0_2[arg_8_4.key])
	arg_8_2:get("textType"):text(var_0_1[arg_8_4.key])
	var_8_3:get("price"):text(arg_8_4.cost)

	if arg_8_4.canBuy == false then
		text.deleteAllEffect(var_8_3:get("price"))
		var_8_3:get("price"):setTextColor(ui.NEWCOLORS.REDLIGHT)
	else
		text.addEffect(var_8_3:get("price"), {
			outline = {
				size = 4,
				color = ui.NEWCOLORS.OUTLINE.YELLOW
			}
		})
	end

	arg_8_2:get("textRemainPercent"):text(arg_8_4.percent .. "%")
	bind.touch(arg_8_0, var_8_2, {
		methods = {
			ended = functools.partial(arg_8_0.sendGetAward, arg_8_0, arg_8_4.key, "free", 0)
		}
	})
	bind.touch(arg_8_0, var_8_3, {
		methods = {
			ended = functools.partial(arg_8_0.sendGetAward, arg_8_0, arg_8_4.key, "rmb", arg_8_4.cost)
		}
	})
end

function var_0_5.sendGetAward(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_3 > 0 and arg_10_3 > gGameModel.role:read("rmb") then
		uiEasy.showDialog("rmb")

		return
	end

	local function var_10_0()
		gGameApp:requestServer("/game/yy/retrieve/get", function(arg_12_0)
			gGameUI:showGainDisplay(arg_12_0)
		end, arg_10_0.activityId, arg_10_1, arg_10_2)
	end

	if arg_10_3 > 0 then
		dataEasy.sureUsingDiamonds(var_10_0, arg_10_3)
	else
		var_10_0()
	end
end

return var_0_5
