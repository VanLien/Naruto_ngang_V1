local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("GateSectionDetailView", Dialog)
local var_0_2 = {
	"city.gate.section_detail.normal",
	"city.gate.section_detail.hard",
	"city.gate.section_detail.nightmare"
}
local var_0_3 = {
	10,
	110,
	210
}

var_0_1.RESOURCE_FILENAME = "gate_section_detail.json"
var_0_1.RESOURCE_BINDING = {
	roleItem = "roleItem",
	["leftTop.lockPanel"] = "lockPanel",
	itemText = "itemText",
	["leftTop.roleNode"] = "cardIcon",
	bottomPanel = "bottomPanel",
	starItem = "starItem",
	["leftTop.textDesc"] = "textDesc",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["title.textGate"] = {
		varname = "titleNum",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	},
	["title.textGateName"] = {
		varname = "titleName",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	},
	["leftTop.btnSave.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["rightTop.starList"] = {
		varname = "starList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("starDatas"),
				item = bindHelper.self("starItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("star1"):visible(not arg_1_3.enabled):scale(0.75)
					arg_1_1:get("star2"):visible(arg_1_3.enabled):scale(0.75)
				end
			}
		}
	},
	["rightTop.list"] = {
		varname = "conditionList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("conditionDatas"),
				item = bindHelper.self("itemText"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					arg_2_1:get("textNote"):text(string.format(arg_2_2 .. ". " .. gLanguageCsv["starCondition" .. arg_2_3.key], arg_2_3.value))
				end
			}
		}
	},
	["rightTop.enemyList"] = {
		varname = "battleList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("monsterDatas"),
				item = bindHelper.self("roleItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					bind.extend(arg_3_0, arg_3_1, {
						class = "card_icon",
						props = {
							showAttribute = true,
							unitId = arg_3_3.unitId,
							rarity = arg_3_3.rarity,
							advance = arg_3_3.advance,
							isBoss = arg_3_3.isBoss,
							levelProps = {
								data = arg_3_3.level
							},
							onNode = function(arg_4_0)
								local var_4_0, var_4_1 = arg_4_0:xy()

								arg_4_0:scale(1.1)
								arg_3_1:scale(arg_3_3.isBoss and 1 or 0.9)
							end
						}
					})
				end
			}
		}
	}
}

function var_0_1.onCreate(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:initModel()

	arg_5_0.gateId = arg_5_1 or 101
	arg_5_0.pageId = arg_5_2

	arg_5_0:initTopView()
	arg_5_0:initRightTop()
	arg_5_0:initLeftTop()
	arg_5_0:initBottomView()
	arg_5_0:isPreGatePass()
	Dialog.onCreate(arg_5_0)
end

function var_0_1.isPreGatePass(arg_6_0)
	local var_6_0 = csv.scene_conf
	local var_6_1 = csv.scene_conf[arg_6_0.gateId].preGateID

	if var_6_1 and not gGameModel.role:read("gate_star")[var_6_1] then
		local var_6_2 = csv.scene_conf[var_6_1]
		local var_6_3 = csv.world_map[var_6_2.ownerId]

		arg_6_0.bottomView:setBtnFalse()
		arg_6_0.lockPanel:show()

		local var_6_4 = {
			gLanguageCsv.gateStory,
			gLanguageCsv.gateDifficult,
			gLanguageCsv.gateNightMare
		}
		local var_6_5 = var_6_2.ownerId - var_0_3[var_6_3.chapterType]
		local var_6_6 = 0

		for iter_6_0, iter_6_1 in pairs(var_6_3.seq) do
			if var_6_1 == iter_6_1 then
				var_6_6 = iter_6_0

				break
			end
		end

		local var_6_7 = var_6_5 .. "-" .. var_6_6

		arg_6_0.lockPanel:get("text"):text(string.format(gLanguageCsv.pleasePassGate, var_6_4[var_6_3.chapterType], var_6_7))
	end
end

function var_0_1.initModel(arg_7_0)
	arg_7_0.gate_star = gGameModel.role:getIdler("gate_star")
	arg_7_0.roleLv = gGameModel.role:getIdler("level")
	arg_7_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_7_0.stamina = gGameModel.role:getIdler("stamina")
	arg_7_0.buyHerogateTimes = gGameModel.daily_record:getIdler("buy_herogate_times")
	arg_7_0.gateTimes = gGameModel.daily_record:getIdler("gate_times")
end

function var_0_1.initTopView(arg_8_0)
	local var_8_0 = csv.scene_conf[arg_8_0.gateId]
	local var_8_1 = csv.world_map[var_8_0.ownerId]
	local var_8_2 = 0

	for iter_8_0, iter_8_1 in pairs(var_8_1.seq) do
		if arg_8_0.gateId == iter_8_1 then
			var_8_2 = iter_8_0

			break
		end
	end

	arg_8_0.titleNum:text(arg_8_0.pageId .. "-" .. var_8_2)
	arg_8_0.titleName:text(var_8_0.sceneName)
	adapt.oneLinePos(arg_8_0.titleNum, arg_8_0.titleName, cc.p(18, 0), "left")
end

function var_0_1.initLeftTop(arg_9_0)
	local var_9_0 = csv.scene_conf[arg_9_0.gateId]
	local var_9_1 = arg_9_0.cardIcon:size()

	ccui.ImageView:create(var_9_0.bg_boss):align(cc.p(0.5, 0.5), var_9_1.width / 2 + var_9_0.bg_boss_pos.x, var_9_1.height + var_9_0.bg_boss_pos.y + 70):scale(1.5):addTo(arg_9_0.cardIcon, 5, "icon")
	beauty.textScroll({
		align = "center",
		list = arg_9_0.textDesc,
		strs = var_9_0.desc
	})

	local var_9_2 = 0

	for iter_9_0, iter_9_1 in ipairs(arg_9_0.textDesc:getChildren()) do
		var_9_2 = var_9_2 + iter_9_1:size().height
	end

	local var_9_3 = arg_9_0.textDesc:size().height

	if var_9_2 < var_9_3 then
		local var_9_4 = -var_9_3 / 2 + var_9_2 / 2

		arg_9_0.textDesc:y(var_9_4)
	end
end

function var_0_1.initBottomView(arg_10_0)
	local var_10_0 = csv.scene_conf[arg_10_0.gateId]

	arg_10_0.chapterType = csv.world_map[var_10_0.ownerId].chapterType

	local var_10_1 = var_0_2[arg_10_0.chapterType]

	arg_10_0.bottomView = gGameUI:createView(var_10_1, arg_10_0.bottomPanel):init(arg_10_0.gateId, arg_10_0.pageId, arg_10_0:createHandler("startFighting")):z(999)
end

function var_0_1.initRightTop(arg_11_0)
	local var_11_0 = csv.scene_conf[arg_11_0.gateId]
	local var_11_1 = csv.world_map[var_11_0.ownerId]

	local function var_11_2(arg_12_0, arg_12_1)
		local var_12_0 = {}

		for iter_12_0, iter_12_1 in ipairs(arg_12_0) do
			local var_12_1 = csv.unit[iter_12_1.unitId]

			table.insert(var_12_0, {
				unitId = iter_12_1.unitId,
				level = iter_12_1.level,
				advance = iter_12_1.advance,
				rarity = var_12_1.rarity,
				attr1 = var_12_1.natureType,
				attr2 = var_12_1.natureType2,
				isBoss = arg_12_1
			})
		end

		table.sort(var_12_0, function(arg_13_0, arg_13_1)
			return arg_13_0.advance > arg_13_1.advance
		end)

		return var_12_0
	end

	local var_11_3 = var_11_2(var_11_0.boss, true)
	local var_11_4 = var_11_2(var_11_0.monsters, false)

	arg_11_0.monsterDatas = arraytools.merge({
		var_11_3,
		var_11_4
	})

	local var_11_5 = arg_11_0.cardIcon:size()

	ccui.ImageView:create(var_11_0.bg_boss):align(cc.p(0.5, 0.5), var_11_5.width / 2 + var_11_0.bg_boss_pos.x, var_11_5.height + var_11_0.bg_boss_pos.y + 70):scale(1.5):addTo(arg_11_0.cardIcon, 5, "icon")

	local var_11_6 = {}

	for iter_11_0, iter_11_1 in csvPairs(var_11_0.stars) do
		table.insert(var_11_6, iter_11_1)
	end

	arg_11_0.conditionDatas = var_11_6
	arg_11_0.starDatas = idlertable.new()

	idlereasy.when(arg_11_0.gate_star, function(arg_14_0, arg_14_1)
		local var_14_0 = {}
		local var_14_1 = arg_14_1[arg_11_0.gateId] and arg_11_0.gate_star:read()[arg_11_0.gateId].star or 0
		local var_14_2 = 3

		for iter_14_0 = 1, var_14_2 do
			table.insert(var_14_0, {
				enabled = iter_14_0 <= var_14_1
			})
		end

		arg_11_0.starDatas:set(var_14_0)
	end)
end

function var_0_1.startFighting(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.gateId
	local var_15_1 = arg_15_0.pageId or 1

	battleEntrance.battleRequest("/game/start_gate", var_15_0):onStartOK(function(arg_16_0)
		if arg_15_0.chapterType == 3 then
			arg_16_0.battleCards = gGameModel.role:read("huodong_cards")[game.EMBATTLE_HOUDONG_ID.nightmare] or gGameModel.role:read("battle_cards")
		end

		gGameUI:goBackInStackUI("city.gate.view")
	end):onResult(function(arg_17_0, arg_17_1)
		local var_17_0 = 0

		if arg_17_1.result == "win" and arg_17_1.gateStar then
			var_17_0 = math.max(arg_17_1.gateStar - (arg_17_0.preData.dungeonStar or 0), 0)
		end

		userDefault.setForeverLocalKey("gateAddStarNum", {
			gateId = arg_17_0.sceneID,
			starAdd = var_17_0,
			sectionId = var_15_1
		})
	end):show()
end

return var_0_1
