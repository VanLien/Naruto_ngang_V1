local var_0_0 = require("app.views.city.pvp.cross_craft.view")
local var_0_1 = class("CrossCraftArrayInfoView", Dialog)
local var_0_2 = 12

local function var_0_3(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_1:multiget("head", "level", "txt", "fightPoint", "attr1", "attr2")

	var_1_0.level:text("Lv" .. arg_1_2.level)
	var_1_0.fightPoint:text(arg_1_2.fighting_point)
	adapt.oneLinePos(var_1_0.txt, var_1_0.fightPoint, cc.p(5, 0))
	var_1_0.attr1:texture(ui.ATTR_ICON[arg_1_2.attr1])
	var_1_0.attr2:visible(arg_1_2.attr2 and true or false)

	if arg_1_2.attr2 then
		var_1_0.attr2:texture(ui.ATTR_ICON[arg_1_2.attr2])
	end

	bind.extend(arg_1_0, var_1_0.head, {
		class = "card_icon",
		props = {
			unitId = arg_1_2.unit_id,
			rarity = arg_1_2.rarity,
			advance = arg_1_2.advance,
			onNode = function(arg_2_0)
				arg_2_0:xy(-4, -4)
			end
		}
	})
end

var_0_1.RESOURCE_FILENAME = "cross_craft_array_info.json"
var_0_1.RESOURCE_BINDING = {
	["rolePanel.server"] = "roleServer",
	["finalPanel.group"] = "finalGroup",
	["rolePanel.state"] = "roleState",
	["rolePanel.level"] = "roleLevel",
	prePanel = "prePanel",
	["finalPanel.backup.item"] = "finalBackupItem",
	["rolePanel.record"] = "roleRecord",
	finalPanel = "finalPanel",
	["rolePanel.txt"] = "roleTxt",
	["prePanel.group"] = "preGroup",
	["rolePanel.name"] = "roleName",
	["topPanel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["rolePanel.icon"] = {
		binds = {
			event = "extend",
			class = "role_logo",
			props = {
				vip = false,
				level = false,
				logoId = bindHelper.self("logoId"),
				frameId = bindHelper.self("frameId"),
				onNode = function(arg_3_0)
					arg_3_0:xy(104, 95):z(6):scale(0.9)
				end
			}
		}
	},
	["finalPanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("finalData"),
				item = bindHelper.self("finalGroup"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("title", "bg", "state", "list", "item")

					if arg_4_3.result == "inBattle" then
						var_4_0.bg:texture("city/pvp/craft/box_bs.png")
						var_4_0.state:text(gLanguageCsv.zhandou)
					elseif arg_4_3.result == "inPrepare" then
						var_4_0.bg:texture("city/pvp/craft/box_bs.png")
						var_4_0.state:text(gLanguageCsv.beisai)
					elseif arg_4_3.result == "win" then
						var_4_0.bg:texture("city/pvp/craft/box_jj.png")

						if arg_4_2 == 1 and arg_4_3.isFinal then
							var_4_0.state:text(gLanguageCsv.huosheng)
						else
							var_4_0.state:text(gLanguageCsv.jinji)
						end
					elseif arg_4_3.result == "fail" then
						var_4_0.bg:texture("city/pvp/craft/box_lb.png")
						var_4_0.state:text(gLanguageCsv.xibai)
					elseif arg_4_3.result == "isOut" then
						var_4_0.bg:texture("city/pvp/craft/box_lb.png")
						var_4_0.state:text(gLanguageCsv.yitaotai)
					else
						var_4_0.bg:texture("city/pvp/craft/box_lb.png")
						var_4_0.state:text(gLanguageCsv.weikaisai)
					end

					var_4_0.title:texture(arg_4_3.res)
					bind.extend(arg_4_0, var_4_0.list, {
						class = "listview",
						props = {
							data = arg_4_3.data,
							item = var_4_0.item,
							onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
								var_0_3(arg_5_0, arg_5_1, arg_5_3)
								uiEasy.getStarPanel(arg_5_3.star, {
									interval = -5,
									align = "left"
								}):scale(0.35):xy(230, 120):addTo(arg_5_1, 2)
							end
						}
					})
				end
			}
		}
	},
	["finalPanel.backup.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("finalBackupData"),
				item = bindHelper.self("finalBackupItem"),
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					local var_6_0 = arg_6_1:multiget("head", "txt", "fightPoint")

					var_6_0.fightPoint:text(arg_6_3.fighting_point)
					adapt.oneLineCenterPos(cc.p(140, 30), {
						var_6_0.txt,
						var_6_0.fightPoint
					}, cc.p(5, 0))
					bind.extend(arg_6_0, var_6_0.head, {
						class = "card_icon",
						props = {
							unitId = arg_6_3.unit_id,
							rarity = arg_6_3.rarity,
							advance = arg_6_3.advance,
							star = arg_6_3.star,
							levelProps = {
								data = arg_6_3.level
							},
							onNode = function(arg_7_0)
								arg_7_0:xy(-4, -4)
							end
						}
					})
				end
			}
		}
	}
}

local function var_0_4()
	return {
		online = true,
		role_logo = gGameModel.role:read("logo"),
		role_frame = gGameModel.role:read("frame"),
		role_level = gGameModel.role:read("level"),
		role_name = gGameModel.role:read("name"),
		game_key = userDefault.getForeverLocalKey("serverKey", nil, {
			rawKey = true
		}),
		history = gGameModel.cross_craft:read("history"),
		card_attrs = gGameModel.cross_craft:read("card_attrs"),
		cards = gGameModel.cross_craft:read("cards")
	}
end

function var_0_1.onCreate(arg_9_0, arg_9_1, arg_9_2)
	arg_9_1 = arg_9_1 or var_0_4()
	arg_9_0.data = arg_9_1
	arg_9_0.logoId = arg_9_1.role_logo
	arg_9_0.frameId = arg_9_1.role_frame

	arg_9_0.roleLevel:text("Lv" .. arg_9_1.role_level)
	arg_9_0.roleName:text(arg_9_1.role_name)
	arg_9_0.roleServer:text(getServerArea(arg_9_1.game_key, true))

	if not arg_9_1.online then
		arg_9_0.roleState:text(gLanguageCsv.symbolBracketLeft .. gLanguageCsv.offLine .. gLanguageCsv.symbolBracketRight)
		text.addEffect(arg_9_0.roleState, {
			color = ui.NEWCOLORS.GRAY
		})
	end

	adapt.oneLinePos(arg_9_0.roleLevel, arg_9_0.roleName, cc.p(15, 0))
	adapt.oneLinePos(arg_9_0.roleName, arg_9_0.roleState, cc.p(5, 0))

	arg_9_0.round = gGameModel.cross_craft:read("round")
	arg_9_0.showResult = false

	if arg_9_2 and (string.find(arg_9_2, "^pre1") and not string.find(arg_9_0.round, "^pre1") or string.find(arg_9_2, "^pre2") and not string.find(arg_9_0.round, "^pre2") or string.find(arg_9_2, "^pre3") and not string.find(arg_9_0.round, "^pre3") or string.find(arg_9_2, "^top") and not string.find(arg_9_0.round, "^top") or string.find(arg_9_2, "^final") and not string.find(arg_9_0.round, "^final")) then
		arg_9_0.showResult = true
		arg_9_0.round = arg_9_2
	end

	if arg_9_0.round == "closed" or arg_9_0.round == "signup" or arg_9_2 == "final" then
		arg_9_0.showResult = true
		arg_9_0.round = "final3"
	elseif arg_9_0.round == "halftime" then
		arg_9_0.showResult = true
		arg_9_0.round = "pre24"
	elseif arg_9_2 == "top" then
		arg_9_0.showResult = true
		arg_9_0.round = "top16"
	end

	local var_9_0 = string.find(arg_9_0.round, "_lock$")
	local var_9_1 = arg_9_0.round

	if var_9_0 then
		var_9_1 = string.sub(arg_9_0.round, 1, var_9_0 - 1)
	end

	local var_9_2 = 0
	local var_9_3 = 0

	for iter_9_0, iter_9_1 in pairs(arg_9_1.history) do
		if arg_9_0.showResult or arg_9_1.round ~= var_9_1 then
			if iter_9_1.result == "win" then
				var_9_2 = var_9_2 + 1
			elseif iter_9_1.result == "fail" then
				var_9_3 = var_9_3 + 1
			end
		end
	end

	arg_9_0.roleRecord:text(string.format(gLanguageCsv.winAndLoseNum, var_9_2, var_9_3))

	arg_9_0.cardAttrs = {}

	for iter_9_2, iter_9_3 in pairs(arg_9_1.card_attrs) do
		arg_9_0.cardAttrs[iter_9_3.id] = iter_9_3
	end

	arg_9_0.finalData = {}
	arg_9_0.finalBackupData = {}
	arg_9_0.isShowFinal = false

	if arg_9_0.round == "closed" or string.find(arg_9_0.round, "^top") or string.find(arg_9_0.round, "^final") then
		arg_9_0.isShowFinal = true

		arg_9_0:showFinalPanel()
	else
		arg_9_0:showPrePanel()
	end

	Dialog.onCreate(arg_9_0)
end

function var_0_1.showPrePanel(arg_10_0)
	arg_10_0.prePanel:show()
	arg_10_0.finalPanel:hide()
	arg_10_0.preGroup:get("list"):setScrollBarEnabled(false)

	if string.find(arg_10_0.round, "^pre%d") then
		local var_10_0 = string.sub(arg_10_0.round, 4, 4)

		arg_10_0.prePanel:get("round"):texture("city/pvp/cross_craft/txt/txt_d" .. var_10_0 .. "l.png")
	end

	for iter_10_0 = 1, 4 do
		local var_10_1 = var_0_0.getRoundHistory(iter_10_0, arg_10_0.round, arg_10_0.data.history)
		local var_10_2 = arg_10_0:getArrayRoundResult(iter_10_0, arg_10_0.round, arg_10_0.data.history)
		local var_10_3 = arg_10_0.preGroup:clone()

		var_10_3:get("result"):hide()

		if var_10_2 == "win" then
			var_10_3:get("result"):texture("city/pvp/craft/icon_win.png"):show()
		elseif var_10_2 == "fail" then
			var_10_3:get("result"):texture("city/pvp/craft/icon_lose.png"):show()
		end

		local var_10_4 = var_0_0.getArrayRoundRes(iter_10_0, arg_10_0.round, arg_10_0.data.history)

		var_10_3:get("title"):texture(var_10_4)
		var_10_3:xy(arg_10_0.prePanel:get("bg" .. iter_10_0):xy()):z(5):show()
		arg_10_0.prePanel:addChild(var_10_3)

		for iter_10_1 = 1, 3 do
			local var_10_5 = iter_10_1 + (iter_10_0 - 1) * 3
			local var_10_6 = var_10_1 and var_10_1.cards[iter_10_1][1] or arg_10_0.data.cards[var_10_5]
			local var_10_7 = arg_10_0.cardAttrs[var_10_6]
			local var_10_8 = arg_10_0.preGroup:get("item"):clone():show()
			local var_10_9 = csv.cards[var_10_7.card_id]
			local var_10_10 = csv.unit[var_10_9.unitID]
			local var_10_11 = dataEasy.getUnitId(var_10_7.card_id, var_10_7.skin_id)
			local var_10_12 = {
				id = var_10_7.id,
				card_id = var_10_7.card_id,
				unit_id = var_10_11,
				fighting_point = var_10_7.fighting_point,
				level = var_10_7.level,
				star = var_10_7.star,
				advance = var_10_7.advance,
				rarity = var_10_10.rarity,
				attr1 = var_10_10.natureType,
				attr2 = var_10_10.natureType2
			}

			var_0_3(arg_10_0, var_10_8, var_10_12)

			local var_10_13 = var_10_8:multiget("txt", "fightPoint")

			adapt.oneLineCenterPos(cc.p(140, 40), {
				var_10_13.txt,
				var_10_13.fightPoint
			}, cc.p(5, 0))
			uiEasy.getStarPanel(var_10_12.star, {
				interval = -5,
				align = "center"
			}):scale(0.35):xy(var_10_8:width() / 2, 90):addTo(var_10_8, 2)
			var_10_3:get("list"):pushBackCustomItem(var_10_8)
		end
	end
end

function var_0_1.showFinalPanel(arg_11_0)
	arg_11_0.prePanel:hide()
	arg_11_0.finalPanel:show()
	arg_11_0.preGroup:get("list"):setScrollBarEnabled(false)

	for iter_11_0 = 1, 3 do
		local var_11_0 = var_0_0.getRoundHistory(4 - iter_11_0, arg_11_0.round, arg_11_0.data.history)
		local var_11_1 = arg_11_0:getArrayRoundResult(4 - iter_11_0, arg_11_0.round, arg_11_0.data.history)
		local var_11_2 = var_0_0.getArrayRoundRes(4 - iter_11_0, arg_11_0.round, arg_11_0.data.history)
		local var_11_3 = {}

		for iter_11_1 = 1, 3 do
			local var_11_4 = iter_11_1 + (3 - iter_11_0) * 3
			local var_11_5 = var_11_0 and var_11_0.cards[iter_11_1][1] or arg_11_0.data.cards[var_11_4]
			local var_11_6 = arg_11_0.cardAttrs[var_11_5]
			local var_11_7 = arg_11_0.preGroup:get("item"):clone()
			local var_11_8 = csv.cards[var_11_6.card_id]
			local var_11_9 = csv.unit[var_11_8.unitID]
			local var_11_10 = dataEasy.getUnitId(var_11_6.card_id, var_11_6.skin_id)

			var_11_3[iter_11_1] = {
				id = var_11_6.id,
				card_id = var_11_6.card_id,
				unit_id = var_11_10,
				fighting_point = var_11_6.fighting_point,
				level = var_11_6.level,
				star = var_11_6.star,
				advance = var_11_6.advance,
				rarity = var_11_9.rarity,
				attr1 = var_11_9.natureType,
				attr2 = var_11_9.natureType2
			}
		end

		arg_11_0.finalData[iter_11_0] = {
			result = var_11_1,
			res = var_11_2,
			data = var_11_3,
			isFinal = not string.find(arg_11_0.round, "^top")
		}
	end

	for iter_11_2 = 1, 3 do
		local var_11_11 = arg_11_0.cardAttrs[arg_11_0.data.cards[9 + iter_11_2]]
		local var_11_12 = arg_11_0.preGroup:get("item"):clone()
		local var_11_13 = csv.cards[var_11_11.card_id]
		local var_11_14 = csv.unit[var_11_13.unitID]
		local var_11_15 = dataEasy.getUnitId(var_11_11.card_id, var_11_11.skin_id)

		arg_11_0.finalBackupData[iter_11_2] = {
			id = var_11_11.id,
			unit_id = var_11_15,
			card_id = var_11_11.card_id,
			fighting_point = var_11_11.fighting_point,
			level = var_11_11.level,
			star = var_11_11.star,
			advance = var_11_11.advance,
			rarity = var_11_14.rarity,
			attr1 = var_11_14.natureType,
			attr2 = var_11_14.natureType2
		}
	end
end

function var_0_1.getArrayRoundResult(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	if arg_12_0.showResult then
		local var_12_0 = var_0_0.getRoundHistory(arg_12_1, arg_12_2, arg_12_3)

		if var_12_0 then
			return var_12_0.result
		end

		return "isOut"
	end

	if arg_12_0.isShowFinal then
		for iter_12_0 = 1, arg_12_1 - 1 do
			local var_12_1 = var_0_0.getRoundHistory(iter_12_0, arg_12_2, arg_12_3)

			if var_12_1 and var_12_1.result == "fail" and var_12_1.round ~= "final2" then
				return "isOut"
			end
		end
	end

	return var_0_0.getArrayRoundResult(arg_12_1, arg_12_2, arg_12_3)
end

return var_0_1
