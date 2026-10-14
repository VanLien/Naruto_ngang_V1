local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = require("app.views.city.handbook.tools")
local var_0_2 = class("HandbookDetailView", Dialog)

var_0_2.RESOURCE_FILENAME = "handbook_detail.json"
var_0_2.RESOURCE_BINDING = {
	rightPanel = "rightPanel",
	pageItem = "pageItem",
	mask = "mask",
	leftPanel = "leftPanel",
	starItem = "starItem",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	textTitle1 = {
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
	textTitle2 = {
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
	["leftPanel.pageList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 15,
				data = bindHelper.self("evolutionDatas"),
				item = bindHelper.self("pageItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("normal"):visible(arg_1_3.select ~= true)
					arg_1_1:get("select"):visible(arg_1_3.select == true)
				end,
				onAfterBuild = function(arg_2_0)
					arg_2_0:setItemAlignCenter()
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	["rightPanel.btnDetail"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnDetail")
			}
		}
	},
	["rightPanel.addPanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("starDatas"),
				item = bindHelper.self("starItem"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					arg_3_1:get("icon"):texture(arg_3_3.icon)
				end
			}
		}
	},
	["rightPanel.nextAddPanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("nextStarDatas"),
				item = bindHelper.self("starItem"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					arg_4_1:get("icon"):texture(arg_4_3.icon)
				end
			}
		}
	},
	["rightPanel.nextAddPanel.btnGoto"] = {
		varname = "btnGoto",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnGotoClick")
			}
		}
	},
	["rightPanel.nextAddPanel.btnGoto.textTitle"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_2.onCreate(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.cb = arg_5_2

	arg_5_0:initModel()

	arg_5_1 = arg_5_1 or gGameModel.cards:find(arg_5_0.cards:read()[1]):read("card_id")
	arg_5_0.cardId = arg_5_1

	local var_5_0 = csv.cards[arg_5_0.cardId]

	arg_5_0.cardMarkID = var_5_0.cardMarkID
	arg_5_0.starDatas = idlertable.new({})
	arg_5_0.nextStarDatas = idlertable.new({})

	arg_5_0:setRightPanel()

	local var_5_1, var_5_2, var_5_3 = dataEasy.getCardMaxStar(arg_5_0.cardMarkID)

	arg_5_0.evolutionDatas = idlers.new({})

	local var_5_4 = {}

	for iter_5_0, iter_5_1 in orderCsvPairs(csv.cards) do
		if matchLanguage(iter_5_1.languages) and iter_5_1.cardMarkID == var_5_0.cardMarkID and iter_5_1.canDevelop then
			table.insert(var_5_4, {
				existCards = var_5_2,
				selectDevelop = iter_5_1.develop,
				cfg = iter_5_1,
				id = iter_5_0
			})
		end
	end

	table.sort(var_5_4, function(arg_6_0, arg_6_1)
		return arg_6_0.id < arg_6_1.id
	end)
	arg_5_0.evolutionDatas:update(var_5_4)

	local var_5_5 = 0

	for iter_5_2, iter_5_3 in ipairs(var_5_4) do
		if iter_5_3.id == var_5_0.id then
			var_5_5 = iter_5_2
		end
	end

	arg_5_0.selectEvolution = idler.new(var_5_5)

	arg_5_0.selectEvolution:addListener(function(arg_7_0, arg_7_1)
		local var_7_0 = arg_5_0.evolutionDatas:atproxy(arg_7_0)
		local var_7_1 = arg_5_0.evolutionDatas:atproxy(arg_7_1)

		if var_7_1 then
			var_7_1.select = false
		end

		if var_7_0 then
			arg_5_0:setLeftPanel(var_7_0)

			var_7_0.select = true
		end
	end)
	Dialog.onCreate(arg_5_0)
end

function var_0_2.initModel(arg_8_0)
	arg_8_0.items = gGameModel.role:getIdler("items")
	arg_8_0.cards = gGameModel.role:getIdler("cards")
	arg_8_0.cardFeels = gGameModel.role:getIdler("card_feels")
	arg_8_0.gold = gGameModel.role:getIdler("gold")
end

function var_0_2.setLeftPanel(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.leftPanel:multiget("cardIcon", "iconRarity", "textCardName", "iconAttr1", "iconAttr2", "btnSelectItem")
	local var_9_1 = csv.unit[arg_9_1.cfg.unitID]
	local var_9_2 = var_9_0.cardIcon:size()
	local var_9_3 = {
		"standby_loop",
		"attack",
		"win_loop",
		"run_loop"
	}

	var_9_0.cardIcon:removeAllChildren()

	local var_9_4 = string.gsub(var_9_1.unitRes, ".skel", "_ui.skel")

	widget.addAnimation(var_9_0.cardIcon, var_9_4, var_9_3[1], 5):xy(var_9_2.width / 2, 110):scale(var_9_1.scaleU * 0.6):setSkin(var_9_1.skin)
	var_9_0.iconAttr1:texture(ui.ATTR_ICON[var_9_1.natureType])
	var_9_0.iconAttr2:hide()

	if var_9_1.natureType2 then
		var_9_0.iconAttr2:texture(ui.ATTR_ICON[var_9_1.natureType2]):show()
	end

	var_9_0.textCardName:text(arg_9_1.cfg.name)
	var_9_0.iconRarity:texture(ui.RARITY_ICON[var_9_1.rarity])
	adapt.oneLinePos(var_9_0.textCardName, var_9_0.iconRarity, cc.p(8, 0), "right")
	adapt.oneLinePos(var_9_0.textCardName, {
		var_9_0.iconAttr1,
		var_9_0.iconAttr2
	}, cc.p(8, 0))
end

function var_0_2.setRightPanel(arg_10_0)
	local var_10_0, var_10_1, var_10_2 = dataEasy.getCardMaxStar(arg_10_0.cardMarkID)

	arg_10_0.dbid = var_10_2

	local var_10_3, var_10_4, var_10_5 = var_0_1.getStarAttrData(arg_10_0.cardMarkID)
	local var_10_6
	local var_10_7 = 0

	for iter_10_0, iter_10_1 in orderCsvPairs(gPokedexDevelop[arg_10_0.cardMarkID]) do
		if var_10_5 ~= iter_10_1.attrValue1 and var_10_0 < iter_10_0 then
			var_10_6 = iter_10_1.attrValue1
			var_10_7 = iter_10_0

			break
		end
	end

	var_0_1.setAttrPanel(arg_10_0.rightPanel:get("addPanel"), var_10_3, var_10_4 .. ":", var_10_5)

	if var_10_6 ~= nil then
		var_0_1.setAttrPanel(arg_10_0.rightPanel:get("nextAddPanel"), var_10_3, var_10_4 .. ":", var_10_6)
	end

	arg_10_0.rightPanel:get("nextAddPanel"):visible(var_10_6 ~= nil)
	arg_10_0.rightPanel:get("ImgMax"):scale(2):visible(var_10_6 == nil)
	arg_10_0.btnGoto:visible(var_10_0 > 0)
	arg_10_0.starDatas:set(dataEasy.getStarData(var_10_0))
	arg_10_0.nextStarDatas:set(dataEasy.getStarData(var_10_7))
end

function var_0_2.initPrivilegeListener(arg_11_0)
	uiEasy.addTouchOneByOne(arg_11_0.mask, {
		ended = function(arg_12_0, arg_12_1, arg_12_2)
			if math.abs(arg_12_1) > 100 and math.abs(arg_12_1) > math.abs(arg_12_2) then
				local var_12_0 = arg_12_1 > 0 and -1 or 1

				arg_11_0.selectEvolution:modify(function(arg_13_0)
					arg_13_0 = cc.clampf(arg_13_0 + var_12_0, 1, arg_11_0.evolutionDatas:size())

					return true, arg_13_0
				end)
			end
		end
	})
end

function var_0_2.onClose(arg_14_0)
	arg_14_0:addCallbackOnExit(arg_14_0.cb)
	var_0_0.onClose(arg_14_0)
end

function var_0_2.onBtnGotoClick(arg_15_0)
	gGameUI:stackUI("city.card.strengthen", nil, nil, 1, arg_15_0.dbid, arg_15_0:createHandler("setRightPanel"))
end

function var_0_2.onBtnDetail(arg_16_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_16_0:createHandler("getRuleContext"), {
		width = 1220
	})
end

function var_0_2.getRuleContext(arg_17_0, arg_17_1)
	local var_17_0 = adaptContext

	return {
		var_17_0.clone(arg_17_1.title, function(arg_18_0)
			arg_18_0:get("text"):text(gLanguageCsv.descriptionCultureAddition)
		end),
		var_17_0.noteText(72001, 72004)
	}
end

return var_0_2
