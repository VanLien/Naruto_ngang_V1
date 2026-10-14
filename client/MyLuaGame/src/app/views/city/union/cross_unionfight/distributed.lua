local var_0_0 = require("app.views.city.union.cross_unionfight.tools")
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("UnionFightDistributeView", var_0_1)

var_0_2.RESOURCE_FILENAME = "cross_union_fight_distributed.json"
var_0_2.RESOURCE_BINDING = {
	["right.title.name"] = "rightName",
	item = "item",
	item2 = "item2",
	["right.bgs"] = "bgs",
	["right.list"] = "rightList",
	item3 = "item3",
	["right.slider"] = "slider",
	list = "list",
	["right.team"] = "rightTeam",
	right = {
		varname = "right",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["right.team.team1.title.name"] = {
		varname = "team1",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c3b(216, 132, 62)
				}
			}
		}
	},
	["right.team.team3.title.name"] = {
		varname = "team3",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c3b(216, 132, 62)
				}
			}
		}
	},
	["right.team.fail.txt"] = {
		varname = "failTxt",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 7,
					color = cc.c3b(70, 79, 100)
				},
				color = cc.c3b(211, 234, 251)
			}
		}
	}
}

function var_0_2.onCreate(arg_1_0, arg_1_1)
	arg_1_0.topuiView = gGameUI.topuiManager:createView("title", arg_1_0, {
		onClose = arg_1_0:createHandler("onClose")
	}):init({
		subTitle = "Building war",
		title = gLanguageCsv.ministryHouseBattle
	})
	arg_1_0.cash = {}
	arg_1_0.beforeNode = nil

	arg_1_0:initModel()
	arg_1_0.list:setScrollBarEnabled(false)
	arg_1_0.rightList:setScrollBarEnabled(false)
	arg_1_0.item:get("list"):setScrollBarEnabled(false)

	arg_1_0.listData = idler.new(true)
	arg_1_0.localUnionData, arg_1_0.unionId, arg_1_0.allInfoData, arg_1_0.type = arg_1_1()
	arg_1_0.infoData = {}
	arg_1_0.selectIndex = 10

	for iter_1_0 = 1, 3 do
		arg_1_0.infoData[iter_1_0] = arg_1_0.allInfoData[iter_1_0] or {}

		if not itertools.isempty(arg_1_0.infoData[iter_1_0]) and iter_1_0 < arg_1_0.selectIndex then
			arg_1_0.selectIndex = iter_1_0
		end
	end

	local function var_1_0(arg_2_0)
		local var_2_0 = arg_2_0.item

		var_2_0:get("list"):show()
		var_2_0:get("bg"):show()
		var_2_0:get("item"):get("icon"):rotate(0)
		var_2_0:get("item"):y(62.5 + var_2_0:get("list"):height())
		var_2_0:height(125 + var_2_0:get("list"):height())
		arg_1_0.list:refreshView()
		arg_1_0.list:forceDoLayout()
	end

	local function var_1_1(arg_3_0)
		local var_3_0 = arg_3_0.item

		var_3_0:get("list"):hide()
		var_3_0:height(125)
		var_3_0:get("bg"):hide()
		var_3_0:get("item"):get("icon"):rotate(90)
		var_3_0:get("item"):y(62.5)
		arg_1_0.list:refreshView()
		arg_1_0.list:forceDoLayout()
	end

	arg_1_0.itemTabs = {}
	arg_1_0.itemK = false
	arg_1_0.selectPlayer = 1
	arg_1_0.beforeSelectIndex = 0
	arg_1_0.beforeSelectPlayer = 0
	arg_1_0.beforeData = {}

	idlereasy.any({
		arg_1_0.listData
	}, function(arg_4_0, arg_4_1)
		local var_4_0 = 0
		local var_4_1 = {
			gLanguageCsv.crossUnionFightEmbattle1,
			gLanguageCsv.crossUnionFightEmbattle2,
			gLanguageCsv.crossUnionFightEmbattle3
		}

		for iter_4_0, iter_4_1 in pairs(arg_1_0.infoData) do
			local var_4_2 = arg_1_0.item:clone():show()

			var_4_2:get("item"):get("name"):text(string.format(gLanguageCsv.crossUnionFightDistributed, var_4_1[iter_4_0], #iter_4_1))

			if not arg_1_0.itemTabs[iter_4_0] then
				table.insert(arg_1_0.itemTabs, {
					opened = true,
					item = var_4_2,
					list = iter_4_0,
					value = iter_4_1
				})
			else
				arg_1_0.itemTabs[iter_4_0].item = var_4_2
			end

			arg_1_0.list:pushBackCustomItem(var_4_2)
			arg_1_0:pushBackChild(arg_1_0.itemTabs[iter_4_0].item, arg_1_0.itemTabs[iter_4_0])

			if arg_1_0.itemTabs[iter_4_0].opened then
				var_1_0(arg_1_0.itemTabs[iter_4_0])
			end

			var_4_2:get("item"):onClick(function()
				if arg_1_0.itemTabs[iter_4_0].opened then
					var_1_1(arg_1_0.itemTabs[iter_4_0])

					arg_1_0.itemTabs[iter_4_0].opened = false
				else
					var_1_0(arg_1_0.itemTabs[iter_4_0])

					arg_1_0.itemTabs[iter_4_0].opened = true
				end
			end)
		end
	end)
	arg_1_0.item:hide()
	arg_1_0.item2:hide()
end

function var_0_2.initModel(arg_6_0)
	arg_6_0.status = gGameModel.cross_union_fight:getIdler("status")
	arg_6_0.userInfo = gGameModel.cross_union_fight:read("roles")
	arg_6_0.unions = gGameModel.cross_union_fight:read("unions")
end

function var_0_2.pushBackChild(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_2.value
	local var_7_1 = 0
	local var_7_2 = {}
	local var_7_3 = {}

	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		table.insert(var_7_3, arg_7_0.userInfo[iter_7_1])

		var_7_1 = var_7_1 + 1

		if var_7_1 % 6 == 0 then
			table.insert(var_7_2, var_7_3)

			var_7_3 = {}
		end
	end

	if #var_7_3 > 0 then
		table.insert(var_7_2, var_7_3)
	end

	local var_7_4 = arg_7_1:get("item")
	local var_7_5 = arg_7_0.item2:size().width
	local var_7_6 = 340 * #var_7_2

	arg_7_1:height(var_7_6 + 122)
	arg_7_1:get("list"):size(var_7_5, var_7_6)
	arg_7_1:get("list"):anchorPoint(cc.p(0, 1))
	arg_7_1:get("list"):y(var_7_6)
	var_7_4:y(var_7_6 + 61)

	local var_7_7 = arg_7_1:get("bg"):size()

	if #var_7_2 ~= 0 then
		arg_7_1:get("bg"):size(var_7_7.width, var_7_6 + 140)
		arg_7_1:get("bg"):y(var_7_6 + 105)
	end

	local var_7_8 = 1

	for iter_7_2, iter_7_3 in ipairs(var_7_2) do
		local var_7_9 = arg_7_0.item2:clone():show()

		for iter_7_4, iter_7_5 in pairs(iter_7_3) do
			local var_7_10 = arg_7_0.item3:clone():show()

			text.addEffect(var_7_10:get("numberLevel"), {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					size = 4,
					color = ui.COLORS.NORMAL.DEFAULT
				}
			})
			text.addEffect(var_7_10:get("txtLv"), {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					size = 3,
					color = ui.COLORS.NORMAL.DEFAULT
				}
			})
			var_7_10:get("name"):text(iter_7_5.role_name)
			var_7_10:get("numberLevel"):text(iter_7_5.role_level)
			var_7_10:get("number"):text(iter_7_5.fighting_point)
			adapt.oneLineCenterPos(cc.p(145, 40), {
				var_7_10:get("zhan"),
				var_7_10:get("number")
			}, cc.p(6, 0))
			bind.extend(arg_7_0, var_7_10:get("icon"), {
				event = "extend",
				class = "role_logo",
				props = {
					vip = false,
					level = false,
					logoId = iter_7_5.role_logo,
					frameId = iter_7_5.role_frame,
					onNode = function(arg_8_0)
						arg_8_0:xy(104, 95):scale(0.9)
					end
				}
			})

			if iter_7_5.role_db_id == gGameModel.role:read("id") then
				var_7_10:get("my"):show()
			else
				var_7_10:get("my"):hide()
			end

			local var_7_11 = arg_7_0.localUnionData:read()[iter_7_5.role_db_id] or {}

			if (itertools.isempty(var_7_11.troop_card_state) and 1 or arg_7_0:isPlayOut(var_7_11.troop_card_state, arg_7_2.list, var_7_11.troop)) <= 0 then
				var_7_10:get("out"):show()
			else
				var_7_10:get("out"):hide()
			end

			var_7_10:get("selected"):hide()

			if arg_7_0.selectIndex == arg_7_2.list and arg_7_0.selectPlayer == var_7_8 then
				arg_7_0.beforeNode = var_7_10

				var_7_10:get("selected"):show()

				if not arg_7_0.cash[iter_7_5.record_id] then
					gGameApp:requestServer("/game/cross/union/fight/role/info", function(arg_9_0)
						arg_7_0.cash[iter_7_5.record_id] = arg_9_0.view

						arg_7_0:rightUpdata(arg_9_0.view)
					end, iter_7_5.record_id)
				else
					arg_7_0:rightUpdata(arg_7_0.cash[iter_7_5.record_id])
				end

				arg_7_0.beforeSelectIndex = arg_7_0.selectIndex
				arg_7_0.beforeSelectPlayer = arg_7_0.selectPlayer
			end

			var_7_9:pushBackCustomItem(var_7_10)
			var_7_10:get("btn"):onClick(function()
				arg_7_0.selectIndex = arg_7_2.list
				arg_7_0.selectPlayer = 6 * (iter_7_2 - 1) + iter_7_4

				arg_7_0.beforeNode:get("selected"):hide()
				var_7_10:get("selected"):show()

				arg_7_0.beforeNode = var_7_10

				if not arg_7_0.cash[iter_7_5.record_id] then
					gGameApp:requestServer("/game/cross/union/fight/role/info", function(arg_11_0)
						arg_7_0.cash[iter_7_5.record_id] = arg_11_0.view

						arg_7_0:rightUpdata(arg_11_0.view)
					end, iter_7_5.record_id)
				else
					arg_7_0:rightUpdata(arg_7_0.cash[iter_7_5.record_id])
				end
			end)

			var_7_8 = var_7_8 + 1
		end

		var_7_9:setScrollBarEnabled(false)
		arg_7_1:get("list"):pushBackCustomItem(var_7_9)
	end
end

function var_0_2.rightUpdata(arg_12_0, arg_12_1)
	local var_12_0 = {
		"card_attrs",
		"top_card_attrs"
	}

	arg_12_0.rightList:removeAllChildren()

	if arg_12_0.selectIndex == 1 then
		arg_12_0.bgs:show()
		arg_12_0.bgs:get("bg1"):hide()
		arg_12_0.bgs:get("bg3"):hide()
	else
		arg_12_0.bgs:hide()
	end

	local var_12_1 = arg_12_0.selectIndex > 1 and {
		{},
		{},
		{}
	} or {
		{},
		{}
	}
	local var_12_2 = var_0_0.getNowMatch(arg_12_0.status:read())

	for iter_12_0, iter_12_1 in pairs(var_12_1) do
		local var_12_3 = arg_12_0.rightTeam:clone():show()

		if arg_12_0.selectIndex > 2 then
			var_12_3:get("team1"):hide()
			var_12_3:get("team3"):show()

			local var_12_4 = var_12_3:get("team3")
			local var_12_5 = var_12_4:multiget("fight", "fightNum", "title")

			var_12_5.title:get("name"):text(string.format(gLanguageCsv.crossMinePVPArmy, iter_12_0))

			local var_12_6 = arg_12_1[var_12_0[arg_12_0.type]]
			local var_12_7 = arg_12_1.cards[var_12_2] and arg_12_1.cards[var_12_2][arg_12_0.selectIndex] or {}
			local var_12_8 = 0
			local var_12_9 = true
			local var_12_10 = arg_12_0.localUnionData:read()[arg_12_1.role_db_id] or {}

			for iter_12_2 = 1, 3 do
				local var_12_11 = var_12_7[iter_12_2 + (iter_12_0 - 1) * 3]
				local var_12_12 = var_12_6[var_12_11]

				if var_12_12 then
					var_12_8 = var_12_8 + var_12_12.fighting_point

					local var_12_13 = dataEasy.getUnitId(var_12_12.card_id, var_12_12.skin_id)
					local var_12_14 = csv.unit[var_12_13]

					bind.extend(arg_12_0, var_12_4:get("icon0" .. iter_12_2), {
						class = "card_icon",
						props = {
							unitId = var_12_13,
							advance = var_12_12.advance,
							rarity = var_12_14.rarity,
							star = var_12_12.star,
							levelProps = {
								data = var_12_12.level
							},
							onNode = function(arg_13_0)
								arg_13_0:scale(0.7)
							end
						}
					})
					var_12_4:get("icon0" .. iter_12_2):get("hp"):show()

					local var_12_15 = var_12_4:get("icon0" .. iter_12_2):get("hp"):get("hp")

					var_12_15:setCapInsets(cc.rect(9, 6, 1, 1))

					local var_12_16 = 100

					if var_12_10 and var_12_10.troop_card_state and var_12_10.troop_card_state[var_12_11] then
						var_12_16 = (var_12_10.troop_card_state[var_12_11][1] or 1) * 100
					end

					if var_12_10 and var_12_10.troop and iter_12_0 < var_12_10.troop then
						var_12_16 = 0
					end

					if var_12_16 <= 0 then
						var_12_4:get("icon0" .. iter_12_2):get("end"):show()
					else
						var_12_9 = false

						var_12_4:get("icon0" .. iter_12_2):get("end"):hide()
					end

					var_12_15:setPercent(var_12_16)
				end
			end

			if var_12_9 and arg_12_0:isInBattle() then
				var_12_3:get("fail"):show()
				var_12_3:get("fail"):get("mask" .. iter_12_0):show()
			else
				var_12_3:get("fail"):hide()
			end

			var_12_5.fightNum:text(var_12_8)
			adapt.oneLinePos(var_12_5.fightNum, var_12_5.fight, cc.p(10, 0), "right")
		else
			var_12_3:get("team1"):show()
			var_12_3:get("team3"):hide()

			local var_12_17 = var_12_3:get("team1")
			local var_12_18 = var_12_17:multiget("fight", "fightNum", "title")

			var_12_18.title:get("name"):text(string.format(gLanguageCsv.crossMinePVPArmy, iter_12_0))

			local var_12_19 = arg_12_1[var_12_0[arg_12_0.type]]
			local var_12_20 = arg_12_1.cards[var_12_2] and arg_12_1.cards[var_12_2][arg_12_0.selectIndex] or {}
			local var_12_21 = 0
			local var_12_22 = true
			local var_12_23 = arg_12_0.localUnionData:read()[arg_12_1.role_db_id] or {}

			for iter_12_3 = 1, 6 do
				local var_12_24 = var_12_20[iter_12_3 + (iter_12_0 - 1) * 6]
				local var_12_25 = var_12_19[var_12_24]

				if var_12_25 then
					var_12_21 = var_12_21 + var_12_25.fighting_point

					local var_12_26 = dataEasy.getUnitId(var_12_25.card_id, var_12_25.skin_id)
					local var_12_27 = csv.unit[var_12_26]

					bind.extend(arg_12_0, var_12_17:get("icon0" .. iter_12_3), {
						class = "card_icon",
						props = {
							unitId = var_12_26,
							advance = var_12_25.advance,
							rarity = var_12_27.rarity,
							star = var_12_25.star,
							levelProps = {
								data = var_12_25.level
							},
							onNode = function(arg_14_0)
								arg_14_0:scale(0.7)
							end
						}
					})
					var_12_17:get("icon0" .. iter_12_3):get("hp"):show()

					local var_12_28 = var_12_17:get("icon0" .. iter_12_3):get("hp"):get("hp")

					var_12_28:setCapInsets(cc.rect(9, 6, 1, 1))

					local var_12_29 = 100

					if var_12_23 and var_12_23.troop_card_state and var_12_23.troop_card_state[var_12_24] then
						var_12_29 = (var_12_23.troop_card_state[var_12_24][1] or 1) * 100
					end

					if var_12_23 and var_12_23.troop and iter_12_0 < var_12_23.troop then
						var_12_29 = 0
					end

					if var_12_29 <= 0 then
						var_12_17:get("icon0" .. iter_12_3):get("end"):show()
					else
						var_12_22 = false

						var_12_17:get("icon0" .. iter_12_3):get("end"):hide()
					end

					var_12_28:setPercent(var_12_29)
				end
			end

			if var_12_22 and arg_12_0:isInBattle() then
				var_12_3:get("fail"):show()
				var_12_3:get("fail"):get("mask" .. iter_12_0):show()
			else
				var_12_3:get("fail"):hide()
			end

			var_12_18.fightNum:text(var_12_21)
			adapt.oneLinePos(var_12_18.fightNum, var_12_18.fight, cc.p(10, 0), "right")
		end

		arg_12_0.rightList:pushBackCustomItem(var_12_3)
	end
end

function var_0_2.isPlayOut(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	if arg_15_2 == 1 and arg_15_3 < 2 or arg_15_2 ~= 1 and arg_15_3 < 3 then
		return 1
	end

	for iter_15_0, iter_15_1 in pairs(arg_15_1) do
		if iter_15_1[1] and iter_15_1[1] > 0 then
			return 1
		end
	end

	return 0
end

function var_0_2.isInBattle(arg_16_0)
	local var_16_0 = arg_16_0.status:read()

	if var_16_0 == "start" or var_16_0 == "prePrepare" or var_16_0 == "preStart" or var_16_0 == "topPrepare" or var_16_0 == "topStart" then
		return false
	end

	return true
end

return var_0_2
