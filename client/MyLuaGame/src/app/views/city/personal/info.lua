local var_0_0 = 50
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("PersonalInfoView", var_0_1)

var_0_2.RESOURCE_FILENAME = "personal_info.json"
var_0_2.RESOURCE_BINDING = {
	["rightPanel.titleTxt"] = "titleTxt",
	["rightPanel.needExp"] = "needExp",
	["rightPanel.name10"] = "txt",
	["rightPanel.exp"] = "expNum",
	["rightPanel.btnShare"] = "btnShare",
	["rightPanel.name"] = "rightPanelRoleName",
	["rightPanel.union"] = "textUnionName",
	["rightPanel.input"] = "input",
	rightPanel = "headImg",
	["leftPanel.cardImg"] = {
		binds = {
			event = "extend",
			class = "role_figure",
			props = {
				spine = true,
				data = bindHelper.model("role", "figure"),
				onNode = function(arg_1_0)
					arg_1_0:z(7):y(580)
				end,
				onSpine = function(arg_2_0)
					arg_2_0:scale(1.5):y(-260):x(438)
				end
			}
		}
	},
	["rightPanel.title"] = {
		varname = "title",
		binds = {
			event = "extend",
			class = "role_title",
			props = {
				data = bindHelper.model("role", "title_id")
			}
		}
	},
	["rightPanel.btnLogo"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChangeIconClick")
			}
		}
	},
	["rightPanel.btnName"] = {
		varname = "rightPanelBtnName",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChangeNameClick")
			}
		}
	},
	["rightPanel.btnTitle"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChangeTitleClick")
			}
		}
	},
	["leftPanel.btnChange"] = {
		varname = "btnChange",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChangeFigureClick")
			}
		}
	},
	["leftPanel.btnChange.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["rightPanel.uid"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "uid")
		}
	},
	["rightPanel.level"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "level")
		}
	},
	["rightPanel.power"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "top6_fighting_point")
		}
	},
	["rightPanel.bar"] = {
		varname = "bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "common/icon/mask_bar_red.png",
				data = bindHelper.self("expSlider")
			}
		}
	},
	["rightPanel.list"] = {
		varname = "battleArrayList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 0,
				data = bindHelper.self("battleData"),
				item = bindHelper.self("item"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					bind.extend(arg_3_0, arg_3_1, {
						class = "card_icon",
						props = {
							unitId = arg_3_3.unitId,
							advance = arg_3_3.advance,
							rarity = arg_3_3.rarity,
							star = arg_3_3.star,
							levelProps = {
								data = arg_3_3.level
							},
							onNode = function(arg_4_0)
								arg_4_0:xy(10, 0):scale(0.9)
							end
						}
					})
				end
			}
		}
	},
	["rightPanel.unlock"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "pokedex"),
			method = function(arg_5_0)
				return itertools.size(arg_5_0)
			end
		}
	},
	["rightPanel.collect"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "pokedex"),
			method = function(arg_6_0)
				local var_6_0 = itertools.size(arg_6_0) * 100 / table.length(gHandbookArrayCsv)

				return string.format("%.1f%%", var_6_0 >= 100 and 100 or var_6_0)
			end
		}
	},
	["rightPanel.btnExp"] = {
		varname = "btnExp",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("overflowExpExchangeListen")
			}
		}
	}
}

function var_0_2.onCreate(arg_7_0)
	arg_7_0:initModel()
	arg_7_0.input:text(arg_7_0.personalSign:read())
	arg_7_0.input:setPlaceHolderColor(ui.NEWCOLORS.OUTLINE.WHITE)
	arg_7_0.input:setTextColor(ui.NEWCOLORS.OUTLINE.WHITE)
	gGameUI.topuiManager:createView("title", arg_7_0, {
		onClose = arg_7_0:createHandler("onClose")
	}):init({
		subTitle = "INFORMATION",
		title = "common/txt/txt_bt_gerenxinxi.png"
	})

	arg_7_0.expSlider = idler.new(0)

	local var_7_0 = table.length(gRoleLevelCsv)

	idlereasy.any({
		arg_7_0.level,
		arg_7_0.levelExp
	}, function(arg_8_0, arg_8_1, arg_8_2)
		local var_8_0 = 100

		if arg_8_1 < var_7_0 then
			var_8_0 = cc.clampf(100 * arg_8_2 / gRoleLevelCsv[arg_8_1].levelExp, 0, 100)
		end

		arg_7_0.expNum:text(arg_8_2)
		arg_7_0.needExp:text("/" .. gRoleLevelCsv[arg_8_1].levelExp)
		adapt.oneLinePos(arg_7_0.expNum, arg_7_0.needExp, cc.p(0, 0), "left")
		arg_7_0.expSlider:set(var_8_0)
	end)

	local var_7_1 = not arg_7_0.vipDisplay and gGameModel.role:read("vip_level") or 0

	bind.extend(arg_7_0, arg_7_0.headImg, {
		class = "role_logo",
		props = {
			level = false,
			logoId = gGameModel.role:getIdler("logo"),
			frameId = gGameModel.role:getIdler("frame"),
			vip = var_7_1,
			onNode = function(arg_9_0)
				arg_9_0:xy(157, 1030)
			end
		}
	})
	idlereasy.when(arg_7_0.overflow_exp, function(arg_10_0, arg_10_1)
		arg_7_0.btnExp:visible(false)

		if dataEasy.isUnlock(gUnlockCsv.overflowExpExchange) and (var_7_0 == arg_7_0.level:read() or arg_10_1 > 0) then
			arg_7_0.btnExp:visible(true)
		end

		local var_10_0 = var_7_0 == arg_7_0.level:read() and "Max" or arg_7_0.levelExp:read()

		arg_7_0.expNum:text(var_10_0)
		adapt.oneLinePos(arg_7_0.expNum, arg_7_0.needExp, cc.p(0, 0), "left")
		arg_7_0.needExp:visible(var_7_0 ~= arg_7_0.level:read())
	end)

	arg_7_0.item = ccui.Layout:create():size(200, 200)

	arg_7_0.item:show()
	arg_7_0.item:retain()
	arg_7_0.battleArrayList:setScrollBarEnabled(false)
	idlereasy.any({
		arg_7_0.battleCards,
		arg_7_0.cards
	}, function(arg_11_0, arg_11_1, arg_11_2)
		local var_11_0 = {}

		for iter_11_0, iter_11_1 in pairs(arg_11_1) do
			local var_11_1 = gGameModel.cards:find(iter_11_1):read("card_id", "skin_id", "fighting_point", "level", "star", "advance", "created_time")
			local var_11_2 = csv.cards[var_11_1.card_id]
			local var_11_3 = csv.unit[var_11_2.unitID]
			local var_11_4 = dataEasy.getUnitId(var_11_1.card_id, var_11_1.skin_id)

			table.insert(var_11_0, {
				cardId = var_11_1.card_id,
				unitId = var_11_4,
				advance = var_11_1.advance,
				star = var_11_1.star,
				level = var_11_1.level,
				rarity = var_11_3.rarity
			})
		end

		if #var_11_0 < 6 then
			for iter_11_2 = #var_11_0 + 1, 6 do
				table.insert(var_11_0, {
					unitId = -1
				})
			end
		end

		arg_7_0.battleData = idlertable.new(var_11_0)
	end)
	blacklist:addListener(arg_7_0.input, "*", function(arg_12_0)
		arg_7_0.input:text(string.utf8limit(arg_12_0, var_0_0, true))

		if arg_7_0.input:text() ~= arg_7_0.personalSign:read() then
			gGameApp:requestServer("/game/role/personal/sign", nil, arg_7_0.input:text())
		end
	end)
	uiEasy.updateUnlockRes(gUnlockCsv.roleFigure, arg_7_0.btnChange, {
		pos = cc.p(260, 90)
	})
	arg_7_0:enableMessage():registerMessage("adapterNotchScreen", function(arg_13_0)
		adaptUI(arg_7_0:getResourceNode(), "personal_info.json", arg_13_0)
	end)
	idlereasy.when(arg_7_0.titleId, function(arg_14_0, arg_14_1)
		arg_7_0.titleTxt:visible(arg_14_1 == -1)
	end)
	idlereasy.any({
		arg_7_0.unionId,
		arg_7_0.unionName
	}, function(arg_15_0, arg_15_1, arg_15_2)
		local var_15_0 = gLanguageCsv.none

		if arg_15_1 then
			var_15_0 = arg_15_2
		end

		arg_7_0.textUnionName:text(var_15_0)
	end)

	local var_7_2 = cc.c4b(0, 0, 0, 255)

	text.addEffect(arg_7_0.txt, {
		color = var_7_2,
		outline = {
			size = 1,
			color = ui.NEWCOLORS.OUTLINE.WHITE
		}
	})
	adapt.setAutoMultiLine(arg_7_0.txt, arg_7_0.txt:text(), 300, -10)
end

function var_0_2.overflowExpExchangeListen(arg_16_0)
	gGameUI:stackUI("city.personal.overflow_exp", nil, {
		clickClose = true
	})
end

function var_0_2.initModel(arg_17_0)
	arg_17_0.level = gGameModel.role:getIdler("level")
	arg_17_0.levelExp = gGameModel.role:getIdler("level_exp")
	arg_17_0.cards = gGameModel.role:getIdler("cards")
	arg_17_0.battleCards = gGameModel.role:getIdler("battle_cards")
	arg_17_0.personalSign = gGameModel.role:getIdler("personal_sign")
	arg_17_0.logo = gGameModel.role:getIdler("logo")
	arg_17_0.frame = gGameModel.role:getIdler("frame")
	arg_17_0.figure = gGameModel.role:getIdler("figure")
	arg_17_0.roleName = gGameModel.role:getIdler("name")
	arg_17_0.renameCount = gGameModel.role:getIdler("rename_count")
	arg_17_0.titleId = gGameModel.role:getIdler("title_id")
	arg_17_0.unionId = gGameModel.role:getIdler("union_db_id")
	arg_17_0.unionName = gGameModel.union:getIdler("name")
	arg_17_0.overflow_exp = gGameModel.role:getIdler("overflow_exp")
	arg_17_0.vipDisplay = gGameModel.role:read("vip_hide")

	idlereasy.when(arg_17_0.roleName, function(arg_18_0, arg_18_1)
		arg_17_0.rightPanelRoleName:text(arg_18_1)

		local var_18_0 = cc.clampf(arg_17_0.rightPanelRoleName:x() + arg_17_0.rightPanelRoleName:width() + 40, 820, 990)

		arg_17_0.rightPanelBtnName:x(var_18_0)
	end)
end

function var_0_2.onChangeIconClick(arg_19_0)
	gGameUI:stackUI("city.personal.role_logo", nil, {
		clickClose = true
	})
end

function var_0_2.onCleanup(arg_20_0)
	if arg_20_0.item then
		arg_20_0.item:release()

		arg_20_0.item = nil
	end

	var_0_1.onCleanup(arg_20_0)
end

function var_0_2.onChangeFigureClick(arg_21_0)
	if not dataEasy.isUnlock(gUnlockCsv.roleFigure) then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.roleFigure))

		return
	end

	gGameUI:stackUI("city.personal.figure", nil, {
		clickClose = true
	})
end

function var_0_2.onChangeNameClick(arg_22_0)
	gGameUI:stackUI("city.card.changename", nil, nil, {
		typ = "role",
		name = arg_22_0.roleName:read(),
		cost = gCostCsv.rename_cost[math.min(arg_22_0.renameCount:read() + 1, table.length(gCostCsv.rename_cost))],
		titleTxt = gLanguageCsv.roleRename
	})
end

function var_0_2.onChangeTitleClick(arg_23_0)
	if not dataEasy.isUnlock(gUnlockCsv.title) then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.title))
	else
		gGameUI:stackUI("city.develop.title_book.view")
	end
end

return var_0_2
