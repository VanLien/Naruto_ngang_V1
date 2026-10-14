local function var_0_0(arg_1_0, arg_1_1)
	local var_1_0 = {}

	for iter_1_0, iter_1_1 in ipairs(arg_1_0) do
		local var_1_1 = csv.unit[iter_1_1.unitId]

		table.insert(var_1_0, {
			unitId = iter_1_1.unitId,
			level = iter_1_1.level,
			advance = iter_1_1.advance,
			rarity = var_1_1.rarity,
			attr1 = var_1_1.natureType,
			attr2 = var_1_1.natureType2,
			isBoss = arg_1_1
		})
	end

	table.sort(var_1_0, function(arg_2_0, arg_2_1)
		return arg_2_0.advance > arg_2_1.advance
	end)

	return var_1_0
end

local function var_0_1(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	return rich.createByStr(arg_3_0, 40):anchorPoint(0, 0.5):xy(arg_3_1, arg_3_2):addTo(arg_3_3, 6)
end

local function var_0_2(arg_4_0, arg_4_1)
	local var_4_0 = -50
	local var_4_1 = 50
	local var_4_2 = false

	for iter_4_0, iter_4_1 in csvPairs(arg_4_0.specialEff) do
		var_4_2 = true
		var_4_1 = var_4_1 - 50

		local var_4_3 = "#C0x57472e#"

		for iter_4_2, iter_4_3 in csvPairs(iter_4_1[1]) do
			local var_4_4 = gLanguageCsv[game.NATURE_TABLE[iter_4_3]] .. gLanguageCsv.xi

			var_4_3 = var_4_3 .. var_4_4
		end

		local var_4_5 = var_4_3 .. gLanguageCsv.card
		local var_4_6 = getLanguageAttr(iter_4_1[2])
		local var_4_7 = var_4_5 .. var_4_6

		if iter_4_1[3] == 0 then
			var_4_7 = var_4_7 .. gLanguageCsv.improve .. "#C0xFF60C456#"
		else
			var_4_7 = var_4_7 .. gLanguageCsv.reduce .. "#C0x57472e#"
		end

		local var_4_8 = var_4_7 .. dataEasy.getAttrValueString(var_4_6, iter_4_1[4])
		local var_4_9 = iter_4_1[3] == 0 and "#Icommon/icon/logo_arrow_green.png-30-45#" or "#Icommon/icon/logo_arrow_red.png-30-45#"
		local var_4_10 = var_4_8 .. var_4_9

		var_0_1(var_4_10, var_4_0, var_4_1, arg_4_1)
	end

		-- NOTE:
		-- specialEffDesc can be nil when the csv row does not have this field or the value is empty.
		-- In Lua, '..' has higher precedence than 'or', so "a" .. nil or "" will still crash.
		local var_4_desc = arg_4_0.specialEffDesc or ""
		if var_4_desc ~= "" then
			local var_4_11 = rich.createWithWidth("#C0x57472e#" .. var_4_desc, 40, nil, 960):anchorPoint(0, 1):xy(0, var_4_1 + 25 - 50):addTo(arg_4_1)

			var_4_1 = var_4_1 + 25 - 50 - var_4_11:height()

			return var_4_1
		end

		if var_4_2 == false and var_4_desc == "" then
		var_4_1 = var_4_1 - 50
	end

	return var_4_1 - 20
end

local var_0_3 = cc.load("mvc").ViewBase
local var_0_4 = class("EndlessTowerGateDetail", Dialog)

var_0_4.RESOURCE_FILENAME = "gym_gate_detail.json"
var_0_4.RESOURCE_BINDING = {
	roleItem = "roleItem",
	["infoPanel.textNote4"] = "textNote4",
	["title.textGate"] = "textGate",
	["infoPanel.awardList"] = "awardList",
	iconItem = "iconItem",
	["infoPanel.textNote3"] = "textNote3",
	["infoPanel.text3"] = "text3",
	["infoPanel.text2"] = "text2",
	["infoPanel.text1"] = "text1",
	["infoPanel.text4"] = "text4",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["infoPanel.enemyList"] = {
		varname = "enemyList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				padding = 10,
				data = bindHelper.self("monsterDatas"),
				item = bindHelper.self("roleItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					bind.extend(arg_5_0, arg_5_1, {
						class = "card_icon",
						props = {
							showAttribute = true,
							unitId = arg_5_3.unitId,
							advance = arg_5_3.advance,
							levelProps = {
								data = arg_5_3.level
							},
							isBoss = arg_5_3.isBoss,
							rarity = arg_5_3.rarity,
							onNode = function(arg_6_0)
								local var_6_0, var_6_1 = arg_6_0:xy()

								arg_5_1:scale(arg_5_3.isBoss and 1.1 or 1)
							end
						}
					})
				end
			}
		}
	},
	["infoPanel.btnChallenge"] = {
		varname = "btnChallenge",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnChallenge")
			}
		}
	},
	["infoPanel.btnChallenge.textNote"] = {
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
	["title.textGym"] = {
		varname = "textGym",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	["title.textDiff"] = {
		varname = "textDiff",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	}
}

function var_0_4.initText(arg_7_0)
	local var_7_0 = csv.gym.gate[arg_7_0.gateId]
	local var_7_1 = csv.scene_conf[arg_7_0.gateId]

	arg_7_0.textGym:text(csv.gym.gym[var_7_0.gymID].name)
	arg_7_0.textDiff:text(gLanguageCsv["gymDifficulty" .. arg_7_0.k])
	adapt.oneLinePos(arg_7_0.textGym, arg_7_0.textDiff, cc.p(5, 0))

	if var_7_0.deployType == 1 then
		arg_7_0.text1:text(gLanguageCsv["embattleType" .. var_7_0.deployType])
	else
		arg_7_0.text1:text(string.format(gLanguageCsv["embattleType" .. var_7_0.deployType], var_7_0.deployCardNumLimit))
	end

	local var_7_2 = csv.gym.gate[arg_7_0.gateId]
	local var_7_3 = var_0_2(var_7_2, arg_7_0.text2)

	if var_7_0.weatherDesc ~= "" then
		arg_7_0.textNote3:y(arg_7_0.text2:y() + var_7_3 - 50)
		arg_7_0.text3:text(""):y(arg_7_0.text2:y() + var_7_3 - 50)

		local var_7_4 = "#C0x5b545b#" .. var_7_0.weatherDesc
		local var_7_5 = rich.createWithWidth(var_7_4, 40, nil, 960):anchorPoint(0, 1):xy(0, 20):addTo(arg_7_0.text3)

		var_7_3 = arg_7_0.text2:y() + var_7_3 - var_7_5:height() + 30 - 50
	else
		arg_7_0.textNote3:hide()
		arg_7_0.text3:hide()

		var_7_3 = arg_7_0.text2:y() + var_7_3 + 40 - 50
	end

	if var_7_0.placeDesc ~= "" then
		arg_7_0.textNote4:y(var_7_3 - 50)
		arg_7_0.textNote4:text(var_7_2.palce)
		arg_7_0.text4:text(""):y(var_7_3 - 50)

		local var_7_6 = "#C0x5b545b#" .. var_7_0.placeDesc
		local var_7_7 = rich.createWithWidth(var_7_6, 40, nil, 1000):anchorPoint(0, 1):xy(0, 20):addTo(arg_7_0.text4)
	else
		arg_7_0.textNote4:hide()
		arg_7_0.text4:hide()
	end
end

function var_0_4.onCreate(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	arg_8_0.gateId = arg_8_1
	arg_8_0.id = arg_8_3
	arg_8_0.k = arg_8_2

	arg_8_0:initText()

	local var_8_0 = csv.gym.gate[arg_8_0.gateId]
	local var_8_1 = csv.scene_conf[arg_8_0.gateId]
	local var_8_2 = var_0_0(var_8_1.boss, true)
	local var_8_3 = var_0_0(var_8_1.monsters, false)

	arg_8_0.monsterDatas = arraytools.merge({
		var_8_2,
		var_8_3
	})

	arg_8_0.btnChallenge:visible(arg_8_4)
	uiEasy.createItemsToList(arg_8_0, arg_8_0.awardList, var_8_1.dropIds, {
		margin = 20,
		onNode = function(arg_9_0, arg_9_1)
			if arg_9_1.key ~= "gold" then
				ccui.ImageView:create("city/adventure/endless_tower/icon_gl.png"):anchorPoint(1, 0.5):xy(arg_9_0:width() - 5, arg_9_0:height() - 25):addTo(arg_9_0, 15)
			end
		end
	})
	Dialog.onCreate(arg_8_0)
end

function var_0_4.onBtnChallenge(arg_10_0)
	if arg_10_0:getChallengeState() == false then
		gGameUI:showTip(gLanguageCsv.gymTimeOut)

		return
	end

	local var_10_0 = gGameModel.daily_record:read("gym_battle_buy_times")

	if gCommonConfigCsv.gymBattleTimes - gGameModel.daily_record:read("gym_battle_times") + var_10_0 <= 0 then
		gGameUI:showTip(gLanguageCsv.timesLimit2048)

		return
	end

	local var_10_1 = csv.gym.gate[arg_10_0.gateId].deployNatureLimit or {}

	if #dataEasy.getNatureSprite(var_10_1) == 0 then
		gGameUI:showTip(gLanguageCsv.gymNoSptire1)

		return
	end

	local var_10_2 = arg_10_0.gateId
	local var_10_3 = csv.gym.gate[var_10_2].deployType
	local var_10_4 = arg_10_0.id

	local function var_10_5(arg_11_0, arg_11_1)
		local var_11_0 = arg_11_1:read()

		battleEntrance.battleRequest("/game/gym/gate/start", var_10_2, var_10_4, var_11_0):onStartOK(function(arg_12_0)
			arg_11_0:onClose(false)
		end):show()
	end

	if var_10_3 == 1 then
		local var_10_6 = csv.gym.gate[var_10_2].deployNatureLimit
		local var_10_7 = csv.gym.gate[var_10_2].deployCardNumLimit
		local var_10_8 = game.EMBATTLE_FROM_TABLE.gymChallenge

		if itertools.size(var_10_6) ~= 0 or var_10_7 ~= 6 then
			var_10_8 = game.EMBATTLE_FROM_TABLE.onekey
		end

		gGameUI:stackUI("city.adventure.gym_challenge.embattle1", nil, {
			full = true
		}, {
			fightCb = var_10_5,
			gateId = var_10_2,
			gymId = var_10_4,
			from = var_10_8
		})
	elseif var_10_3 == 2 then
		gGameUI:stackUI("city.adventure.gym_challenge.embattle2", nil, {
			full = true
		}, {
			fightCb = var_10_5,
			gateId = var_10_2,
			gymId = var_10_4
		})
	else
		gGameUI:stackUI("city.adventure.gym_challenge.embattle3", nil, {
			full = true
		}, {
			fightCb = var_10_5,
			gateId = var_10_2,
			gymId = var_10_4
		})
	end

	arg_10_0:onClose()
end

function var_0_4.getChallengeState(arg_13_0)
	if gGameModel.gym:read("round") == "closed" then
		return false
	end

	return time.getNumTimestamp(gGameModel.gym:read("date"), 21, 45) + 518400 > time.getTime()
end

return var_0_4
