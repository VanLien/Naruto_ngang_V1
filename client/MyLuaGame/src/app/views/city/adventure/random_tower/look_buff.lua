local var_0_0 = {
	mp = 2,
	hp = 1,
	life = 3
}
local var_0_1 = {
	point = 3,
	skill = 4,
	supply = 2,
	attr = 1
}

local function var_0_2(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	for iter_1_0 = 1, math.huge do
		local var_1_0 = arg_1_1:get("item" .. iter_1_0)

		if not var_1_0 then
			break
		end

		var_1_0:removeFromParent()
	end

	local var_1_1 = arg_1_1:multiget("titlePanel", "list", "textDesc")
	local var_1_2 = arg_1_0:size().width

	var_1_1.titlePanel:visible(arg_1_3.itemType == "title")
	var_1_1.textDesc:visible(arg_1_3.itemType == "empty")
	var_1_1.list:visible(arg_1_3.itemType == "item")

	if arg_1_3.itemType == "title" then
		local var_1_3 = arg_1_1:get("titlePanel"):getBoundingBox()

		arg_1_1:size(cc.size(var_1_2, var_1_3.height))
		arg_1_1:get("titlePanel"):y(var_1_3.height / 2)
		var_1_1.titlePanel:get("textTitle"):text(arg_1_3.title)
	elseif arg_1_3.itemType == "empty" then
		local var_1_4 = arg_1_0.cloneItem:size()

		arg_1_1:size(cc.size(var_1_2, var_1_4.height + 10))
		arg_1_1:get("list"):size(cc.size(var_1_2, var_1_4.height + 10))
		var_1_1.textDesc:text(arg_1_3.desc)
	else
		local var_1_5 = arg_1_0.cloneItem:size()

		arg_1_1:size(cc.size(var_1_2, var_1_5.height + 10))
		arg_1_1:get("list"):size(cc.size(var_1_2, var_1_5.height + 10))

		local var_1_6 = {
			class = "listview",
			props = {
				data = arg_1_3.buffDatas,
				item = arg_1_0.cloneItem,
				topPadding = padding,
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					arg_2_1:get("icon"):texture(arg_2_3.icon):scale(1.5)
					arg_2_1:onClick(functools.partial(arg_1_0.clickCell, arg_1_2, arg_2_3))
				end
			}
		}

		bind.extend(arg_1_0, arg_1_1:get("list"), var_1_6)
	end
end

local var_0_3 = cc.load("mvc").ViewBase
local var_0_4 = class("RandomTowerLookBuffView", var_0_3)

var_0_4.RESOURCE_FILENAME = "random_tower_look_buff.json"
var_0_4.RESOURCE_BINDING = {
	centerItem = "centerItem",
	subList = "subList",
	rightItem = "rightItem",
	textNum = "textNum",
	buffItem = "buffItem",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	centerList = {
		varname = "centerList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				backupCached = false,
				data = bindHelper.self("centerDatas"),
				item = bindHelper.self("centerItem"),
				cloneItem = bindHelper.self("buffItem"),
				clonSubList = bindHelper.self("subList"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					var_0_2(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onClickItem")
			}
		}
	},
	rightList = {
		varname = "listview",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("rightItem"),
				dataOrderCmp = function(arg_4_0, arg_4_1)
					return arg_4_0.sortKey < arg_4_1.sortKey
				end,
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = arg_5_1:multiget("textTitle", "textNum")

					var_5_0.textTitle:text(arg_5_3.name)
					adapt.setTextScaleWithWidth(var_5_0.textTitle, nil, 240)

					local var_5_1 = "+0%"
					local var_5_2 = ui.COLORS.NORMAL.WHITE

					if tonumber(arg_5_3.num) > 0 then
						var_5_1 = "+" .. dataEasy.getAttrValueString(arg_5_2, arg_5_3.num .. arg_5_3.symbol)
					elseif tonumber(arg_5_3.num) < 0 then
						var_5_1 = dataEasy.getAttrValueString(arg_5_2, arg_5_3.num .. arg_5_3.symbol)
						var_5_2 = ui.COLORS.NORMAL.RED
					end

					text.addEffect(var_5_0.textNum, {
						color = var_5_2
					})
					var_5_0.textNum:text(var_5_1)
				end
			}
		}
	}
}

function var_0_4.onCreate(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:initModel()

	arg_6_0.cb = arg_6_2
	arg_6_0.centerDatas = idlers.new()
	arg_6_0.attrDatas = idlers.new()

	local var_6_0 = {
		[7] = {
			symbol = "",
			sortKey = 1,
			num = 0,
			name = gLanguageCsv.spaceDamage
		},
		[8] = {
			symbol = "",
			sortKey = 2,
			num = 0,
			name = gLanguageCsv.spaceSpecialDamage
		},
		[9] = {
			symbol = "",
			sortKey = 3,
			num = 0,
			name = gLanguageCsv.spaceDefence
		},
		[10] = {
			symbol = "",
			sortKey = 4,
			num = 0,
			name = gLanguageCsv.spaceSpecialDefence
		},
		[14] = {
			symbol = "",
			sortKey = 5,
			num = 0,
			name = gLanguageCsv.spaceStrike
		},
		[15] = {
			symbol = "",
			sortKey = 6,
			num = 0,
			name = gLanguageCsv.attrStrikeDamage
		},
		[17] = {
			symbol = "",
			sortKey = 7,
			num = 0,
			name = gLanguageCsv.spaceBlock
		},
		[26] = {
			symbol = "",
			sortKey = 8,
			num = 0,
			name = gLanguageCsv.spaceSuckBlood
		},
		[22] = {
			symbol = "",
			sortKey = 9,
			num = 0,
			name = gLanguageCsv.attrDamageAdd
		},
		[23] = {
			symbol = "",
			sortKey = 10,
			num = 0,
			name = gLanguageCsv.attrDamageSub
		}
	}
	local var_6_1 = {
		[var_0_1.point] = {
			title = gLanguageCsv.pointAdd
		},
		[var_0_1.skill] = {
			title = gLanguageCsv.battleAdd
		}
	}

	idlereasy.when(arg_6_0.buffs, function(arg_7_0, arg_7_1)
		local var_7_0 = {}

		for iter_7_0, iter_7_1 in ipairs(arg_7_1) do
			local var_7_1 = csv.random_tower.buffs[iter_7_1]
			local var_7_2 = var_7_1.buffType

			if var_0_1.attr == var_7_2 then
				for iter_7_2 = 1, 3 do
					local var_7_3 = var_7_1["attrNum" .. iter_7_2]
					local var_7_4 = var_7_1["attrType" .. iter_7_2]

					if var_6_0[var_7_4] ~= nil and var_7_3 ~= "" then
						if string.find(var_7_3, "%%") then
							var_7_3 = string.gsub(var_7_3, "%%", "")
							var_6_0[var_7_4].symbol = "%"
						end

						var_6_0[var_7_4].num = var_6_0[var_7_4].num + tonumber(var_7_3)
					end
				end
			end

			if var_0_1.point == var_7_2 or var_0_1.skill == var_7_2 then
				if not var_7_0[var_7_2] then
					var_7_0[var_7_2] = {}
				end

				table.insert(var_7_0[var_7_2], iter_7_1)
			end
		end

		arg_6_0.attrDatas:update(var_6_0)

		local var_7_5 = {}

		for iter_7_3, iter_7_4 in csvMapPairs(var_6_1) do
			table.insert(var_7_5, {
				itemType = "title",
				title = iter_7_4.title
			})

			if not var_7_0[iter_7_3] then
				table.insert(var_7_5, {
					itemType = "empty",
					desc = string.format(gLanguageCsv.noSomeAdd, iter_7_4.title)
				})
			else
				local var_7_6 = {}

				for iter_7_5, iter_7_6 in ipairs(var_7_0[iter_7_3]) do
					local var_7_7 = csv.random_tower.buffs[iter_7_6]

					table.insert(var_7_6, {
						icon = var_7_7.icon,
						buffId = iter_7_6
					})

					if iter_7_5 % 5 == 0 then
						table.insert(var_7_5, {
							itemType = "item",
							buffDatas = var_7_6
						})

						var_7_6 = {}
					end
				end

				if next(var_7_6) ~= nil then
					table.insert(var_7_5, {
						itemType = "item",
						buffDatas = var_7_6
					})
				end
			end
		end

		arg_6_0.centerDatas:update(var_7_5)
	end)
end

function var_0_4.initModel(arg_8_0)
	arg_8_0.cardStates = gGameModel.random_tower:getIdler("card_states")
	arg_8_0.roomInfo = gGameModel.random_tower:getIdler("room_info")
	arg_8_0.cards = gGameModel.role:getIdler("cards")
	arg_8_0.buffs = gGameModel.random_tower:getIdler("buffs")
end

function var_0_4.onitemClick(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	arg_9_0.selectIdx:set(arg_9_2.k)
end

function var_0_4.onClickItem(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = arg_10_4.target
	local var_10_1, var_10_2 = var_10_0:xy()
	local var_10_3 = var_10_0:getParent():convertToWorldSpace(cc.p(var_10_1 - 290, var_10_2 - 90))

	gGameUI:stackUI("city.adventure.random_tower.buff_detail", nil, nil, {
		buffId = arg_10_3.buffId,
		pos = var_10_3,
		target = arg_10_1.item
	})
end

return var_0_4
