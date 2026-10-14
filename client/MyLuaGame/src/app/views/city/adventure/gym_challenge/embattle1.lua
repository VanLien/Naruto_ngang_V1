local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = require("app.views.city.card.embattle.base")
local var_0_2 = class("GymChallengeEmbattleView", var_0_1)

var_0_2.RESOURCE_FILENAME = "gym_embattle1.json"
var_0_2.RESOURCE_BINDING = {
	spritePanel = "spriteItem",
	fightNote = "fightNote",
	textNotRole = "emptyTxt",
	rightTop = "rightTop",
	["rightTop.imgBg"] = "attrBg",
	["rightTop.textNote"] = "textNote",
	battlePanel = "battlePanel",
	rightDown = "rightDown",
	["fightNote.textFightPoint"] = "textFightPoint",
	bottomPanel = "bottomPanel",
	attrItem = "attrItem",
	btnGHimg = {
		varname = "btnGHimg",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onTeamBuffClick")
			}
		}
	},
	["battlePanel.ahead.txt"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["battlePanel.back.txt"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["rightDown.btnChallenge"] = {
		varname = "btnChallenge",
		binds = {
			clicksafe = true,
			event = "touch",
			methods = {
				ended = bindHelper.self("fightBtn")
			}
		}
	},
	["rightDown.btnChallenge.textNote"] = {
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
	["rightDown.btnSave"] = {
		varname = "btnSave",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("saveBtn")
			}
		}
	},
	["rightDown.btnSave.textNote"] = {
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
	["rightDown.btnOneKeySet"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("oneKeyEmbattleBtn")
			}
		}
	},
	["rightDown.btnOneKeySet.textNote"] = {
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
	["rightTop.arrList"] = {
		varname = "arrList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("limitInfo"),
				item = bindHelper.self("attrItem"),
				textNote = bindHelper.self("textNote"),
				attrBg = bindHelper.self("attrBg"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("imgIcon"):texture(ui.ATTR_ICON[arg_1_3])
				end,
				onAfterBuild = function(arg_2_0)
					local var_2_0 = arg_2_0.item:size()
					local var_2_1 = csvSize(arg_2_0.data)
					local var_2_2 = var_2_0.width * var_2_1 + arg_2_0:getItemsMargin() * (var_2_1 - 1)

					arg_2_0:setAnchorPoint(cc.p(1, 0.5))
					arg_2_0:width(var_2_2)
					arg_2_0:xy(cc.p(600, 50))
					adapt.oneLinePos(arg_2_0, arg_2_0.textNote, cc.p(0, 0), "right")
					arg_2_0.attrBg:width(var_2_2 + arg_2_0.textNote:width() + 40)
					arg_2_0.attrBg:x(arg_2_0.textNote:x() - 40)
				end
			}
		}
	},
	["textPanel.textNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("battleNum")
		}
	}
}

function var_0_2.onCreate(arg_3_0, arg_3_1)
	gGameUI.topuiManager:createView("title", arg_3_0, {
		onClose = arg_3_0:createHandler("onClose", false)
	}):init({
		subTitle = "FORMATION",
		title = "common/txt/txt_bt_buzhen.png"
	})
	arg_3_0.spriteItem:get("attrBg"):hide()
	arg_3_0:initDefine(arg_3_1)
	arg_3_0:initParams(arg_3_1)
	arg_3_0:initModel(arg_3_1)
	arg_3_0:checkTeamBuffOpen()
	arg_3_0:initRoundUIPanel()
	arg_3_0:initHeroSprite()
	arg_3_0:initBottomList()

	arg_3_0.haveSaved = false

	if arg_3_0.from == game.EMBATTLE_FROM_TABLE.gymChallenge then
		local var_3_0 = arg_3_0.battleCardsData:read()

		if itertools.size(var_3_0) == 0 then
			local var_3_1 = arg_3_0:getOneKeyCardDatas()

			arg_3_0.battleCardsData:set(var_3_1)
		end
	elseif arg_3_0.from == game.EMBATTLE_FROM_TABLE.onekey then
		local var_3_2 = arg_3_0:getOneKeyCardDatas()

		arg_3_0.battleCardsData:set(var_3_2)
	end
end

function var_0_2.initDefine(arg_4_0, arg_4_1)
	if arg_4_1.gateId then
		arg_4_0.embattleMax = csv.gym.gate[arg_4_1.gateId].deployCardNumLimit
	else
		arg_4_0.embattleMax = 6
	end

	arg_4_0.panelNum = 6
	arg_4_0.gymId = arg_4_1.gymId
end

function var_0_2.initParams(arg_5_0, arg_5_1)
	arg_5_1 = arg_5_1 or {}
	arg_5_0.from = arg_5_1.from
	arg_5_0.sceneType = game.SCENE_TYPE.gym
	arg_5_0.fightCb = arg_5_1.fightCb
	arg_5_0.saveCb = arg_5_1.saveCb

	if arg_5_1.gateId then
		arg_5_0.limitInfo = csv.gym.gate[arg_5_1.gateId].deployNatureLimit
	else
		arg_5_0.limitInfo = arg_5_1.limitInfo
	end

	arg_5_0.checkBattleArr = arg_5_1.checkBattleArr or function()
		return true
	end
end

function var_0_2.initRoundUIPanel(arg_7_0)
	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_7_0.fightNote,
			"pos",
			"right"
		},
		{
			arg_7_0.rightDown,
			"pos",
			"right"
		},
		{
			arg_7_0.rightTop,
			"pos",
			"right"
		}
	})

	if itertools.size(arg_7_0.limitInfo) == 0 then
		arg_7_0.rightTop:hide()
	end

	arg_7_0.btnChallenge:visible(arg_7_0.fightCb and true or false)
	arg_7_0.btnSave:visible(arg_7_0.saveCb and true or false)
end

function var_0_2.limtFunc(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9, arg_8_10)
	local var_8_0 = itertools.map(arg_8_0.limitInfo or {}, function(arg_9_0, arg_9_1)
		return arg_9_1, 1
	end)
	local var_8_1 = csv.cards[arg_8_2]
	local var_8_2 = csv.unit[var_8_1.unitID]

	if csvSize(arg_8_0.limitInfo) == 0 or var_8_0[var_8_2.natureType] or var_8_0[var_8_2.natureType2] then
		return var_0_1.limtFunc(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9, arg_8_10)
	else
		return nil
	end
end

function var_0_2.whichEmbattleTargetPos(arg_10_0, arg_10_1)
	for iter_10_0, iter_10_1 in pairs(arg_10_0.heroSprite) do
		local var_10_0 = arg_10_0.battlePanel:get("item" .. iter_10_0)
		local var_10_1 = var_10_0:box()
		local var_10_2 = var_10_0:getParent():convertToWorldSpace(cc.p(var_10_1.x, var_10_1.y))

		var_10_1.x, var_10_1.y = var_10_2.x, var_10_2.y

		if cc.rectContainsPoint(var_10_1, arg_10_1) then
			return iter_10_0
		end
	end
end

function var_0_2.saveBtn(arg_11_0, arg_11_1)
	arg_11_0.saveCb(arg_11_0, arg_11_0.clientBattleCards, arg_11_0.battleCardsData, false)
end

function var_0_2.onClose(arg_12_0, arg_12_1)
	if arg_12_1 == true then
		-- block empty
	elseif arg_12_0.saveCb then
		if not arg_12_0.haveSaved or not itertools.equal(arg_12_0.clientBattleCards:read(), arg_12_0.battleCardsData:read()) then
			local var_12_0 = {
				clearFast = true,
				btnType = 2,
				cb = function()
					arg_12_0.saveCb(arg_12_0, arg_12_0.clientBattleCards, arg_12_0.battleCardsData, true)
				end,
				cancelCb = function()
					var_0_0.onClose(arg_12_0)
				end,
				content = gLanguageCsv.gymOutCanNotChangeEmbattle
			}

			gGameUI:showDialog(var_12_0)
		else
			var_0_0.onClose(arg_12_0)
		end
	else
		if arg_12_0.from == game.EMBATTLE_FROM_TABLE.gymChallenge then
			local var_12_1 = gGameModel.gym:read("date")
			local var_12_2 = arg_12_0.clientBattleCards:read()
			local var_12_3 = {}

			for iter_12_0, iter_12_1 in pairs(var_12_2) do
				var_12_3[iter_12_0] = stringz.bintohex(iter_12_1)
			end

			userDefault.setForeverLocalKey("gym_emabttle" .. arg_12_0.gymId, var_12_3, {
				new = true
			})
		end

		var_0_0.onClose(arg_12_0)
	end
end

return var_0_2
