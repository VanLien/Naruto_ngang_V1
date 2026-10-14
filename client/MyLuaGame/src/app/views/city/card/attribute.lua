local function var_0_0(arg_1_0)
	local var_1_0 = arg_1_0:get("effect")
	local var_1_1 = arg_1_0:size()

	if not var_1_0 then
		var_1_0 = widget.addAnimationByKey(arg_1_0, "effect/shengjitiao.skel", "effect", "effect", 10):xy(var_1_1.width / 2 + 0, var_1_1.height / 2 + 0):scale(1)
	else
		var_1_0:play("effect")
	end
end

local var_0_1 = class("CardAttributeView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "card_attribute.json"
var_0_1.RESOURCE_BINDING = {
	attrItem = "attrItem",
	["center.levelupPanel.btnLvUp.txt"] = "btnLvUpTxt",
	["center.medLvUp.textNote"] = "medLvUpTextNote",
	trammelItem = "fetterItem",
	["center.levelupPanel.textExp"] = "textExp",
	["center.levelupPanel"] = "levelupPanel",
	["center.levelupPanel.textNum"] = "textNum",
	medItem = "medItem",
	innerList = "fetterSubList",
	["center.top.textTypeNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("raceTxt")
		}
	},
	["center.top.btnInfo"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCharacterClick")
			}
		}
	},
	["center.top.btnAttrInfo"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowAtrtInfo")
			}
		}
	},
	["center.top.btnChooseAttr"] = {
		varname = "btnChooseAttr",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onExchangeChooseNature")
			}
		}
	},
	["center.top.btnShare"] = {
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("cardShareListen")
			},
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onShareCard")
				}
			}
		}
	},
	["center.top.btnShare.textNote"] = {
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
	["center.top.attrList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("attrItem"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					arg_2_1:get("imgIcon"):texture(ui.ATTR_ICON[arg_2_3[1]])
				end
			}
		}
	},
	["center.top.textSexVal"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("gender"),
			method = function(arg_3_0)
				return getLanguageGender(arg_3_0)
			end
		}
	},
	["center.top.textNature"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("currSelect"),
			method = function(arg_4_0)
				return csv.character[arg_4_0].name
			end
		}
	},
	["center.levelupPanel.textLv"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("clientLv"),
			method = function(arg_5_0)
				return "Lv." .. arg_5_0
			end
		}
	},
	["center.center.btnInfo"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAttrDetail")
			}
		}
	},
	["center.down"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("trammelsPanel")
		}
	},
	["center.medLvUp"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("gradePanel")
		}
	},
	["center.levelupPanel.progressBar"] = {
		varname = "progressBar"
	},
	["center.levelupPanel.btnOneKeyLvUp"] = {
		varname = "btnOneKeyLvUp",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onUpGradePanelClick")
			}
		}
	},
	["center.levelupPanel.btnLvUp"] = {
		varname = "btnLvUp",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowGradeClick")
			}
		}
	},
	["center.center.textLifeNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("hpVal")
		}
	},
	["center.center.textSpeedVal"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("speedVal")
		}
	},
	["center.center.textAttackNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("damageVal")
		}
	},
	["center.center.textDefNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("defenceVal")
		}
	},
	["center.center.textSpeAttackNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("specialDamageVal")
		}
	},
	["center.center.textSpeDefNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("specialDefenceVal")
		}
	},
	["center.medLvUp.list"] = {
		varname = "gradelist",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("itemData"),
				item = bindHelper.self("medItem"),
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					arg_6_1:name("item" .. arg_6_2)
					bind.extend(arg_6_0, arg_6_1, {
						class = "icon_key",
						props = {
							data = arg_6_3,
							grayState = arg_6_3.num <= 0 and 1 or 0,
							onNode = function(arg_7_0)
								arg_7_0:scale(0.7)
								arg_7_0:setTouchEnabled(false)
							end
						}
					})

					arg_6_1.num = arg_6_3.num

					function arg_6_1.resetState()
						local var_8_0 = arg_6_1:get("_icon_")

						var_8_0:get("num"):text(arg_6_1.num)

						local var_8_1 = arg_6_1:get("btnAdd")

						arg_6_1:get("imgMask"):hide(false)
						var_8_1:visible(arg_6_1.num <= 0)

						local var_8_2 = arg_6_1.num <= 0 and cc.c3b(128, 128, 128) or cc.c3b(255, 255, 255)

						var_8_0:get("box"):color(var_8_2)
						var_8_0:get("icon"):color(var_8_2)
					end

					arg_6_1.resetState()
					arg_6_1:get("textAddVal"):text(arg_6_3.cfg.specialArgsMap.exp)
					arg_6_1:onTouch(functools.partial(arg_6_0.itemClick, arg_6_1, arg_6_2, arg_6_3))
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	["center.down.list"] = {
		varname = "fetterList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 6,
				columnSize = 3,
				data = bindHelper.self("fetterData"),
				item = bindHelper.self("fetterSubList"),
				cell = bindHelper.self("fetterItem"),
				onCell = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
					local var_9_0 = csv.fetter[arg_9_3.id]

					arg_9_1:get("textNote"):text(var_9_0.name)

					if arg_9_3.isShow then
						text.addEffect(arg_9_1:get("textNote"), {
							color = ui.NEWCOLORS.WHITE
						})
					else
						text.addEffect(arg_9_1:get("textNote"), {
							color = ui.NEWCOLORS.GRAY
						})
					end
				end
			}
		}
	},
	["center.down.btnInfo"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("showFetterClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0.selectDbId = arg_10_1()
	arg_10_0.costData = {}

	arg_10_0:initModel()
	arg_10_0:enableSchedule()
	adapt.setTextAdaptWithSize(arg_10_0.medLvUpTextNote, {
		margin = -8,
		horizontal = "center",
		vertical = "center",
		size = cc.size(835, 80)
	})
	arg_10_0.medLvUpTextNote:y(arg_10_0.medLvUpTextNote:y() + 5)

	arg_10_0.cardShareListen = dataEasy.getListenUnlock(gUnlockCsv.cardShare)

	dataEasy.getListenUnlock(gUnlockCsv.cardComment, function(arg_11_0)
		return
	end)

	arg_10_0.clientCurLvExp = idler.new(arg_10_0.levelExp:read())
	arg_10_0.clientLv = idler.new(arg_10_0.cardLevel:read())
	arg_10_0.clickLevelUpdata = idler.new(false)

	idlereasy.when(arg_10_0.cardLevel, function(arg_12_0, arg_12_1)
		arg_10_0.clientLv:set(arg_12_1)
	end, true)
	idlereasy.when(arg_10_0.levelExp, function(arg_13_0, arg_13_1)
		arg_10_0.clientCurLvExp:set(arg_13_1)
	end, true)

	arg_10_0.showSuccessTip = false

	local var_10_0 = table.length(gRoleLevelCsv)

	idlereasy.any({
		arg_10_0.clientLv,
		arg_10_0.clientCurLvExp
	}, function(arg_14_0, arg_14_1, arg_14_2)
		if arg_10_0.showSuccessTip then
			arg_10_2(false, true)

			arg_10_0.showSuccessTip = false

			arg_10_0.progressBar:setPercent(0)
			var_0_0(arg_10_0.progressBar)
		end

		local var_14_0 = csv.cards[arg_10_0.cardId:read()]
		local var_14_1 = csv.base_attribute.card_level

		arg_10_0.clientNextLvExp = var_14_1[arg_14_1]["levelExp" .. var_14_0.levelExpID]
		arg_10_0.clientMaxLvNeedExp = arg_10_0.clientNextLvExp - arg_14_2

		for iter_14_0 = arg_14_1 + 1, arg_10_0.roleLv:read() do
			arg_10_0.clientMaxLvNeedExp = arg_10_0.clientMaxLvNeedExp + var_14_1[iter_14_0]["levelExp" .. var_14_0.levelExpID]
		end

		arg_10_0.textExp:text(arg_14_2 .. "/" .. arg_10_0.clientNextLvExp)

		local var_14_2 = cc.clampf(arg_14_2 / arg_10_0.clientNextLvExp * 100, 0, 100)

		if arg_10_0.roleLv:read() == var_10_0 and arg_14_1 == var_10_0 then
			var_14_2 = 100

			local var_14_3 = var_14_1[var_10_0 - 1]["levelExp" .. var_14_0.levelExpID]

			arg_10_0.textExp:text(var_14_3 .. "/" .. var_14_3)
		end

		if var_14_2 < arg_10_0.progressBar:getPercent() or arg_10_0.selectDbIdChange then
			arg_10_0.progressBar:setPercent(var_14_2)
		else
			transition.executeSequence(arg_10_0.progressBar):progressTo(arg_10_0.lvTouchTimes - 0.01, var_14_2):done()
		end

		arg_10_0.clickLevelUpdata:set(true, true)
	end)

	arg_10_0.raceTxt = idler.new()
	arg_10_0.hpVal = idler.new(0)
	arg_10_0.speedVal = idler.new(0)
	arg_10_0.damageVal = idler.new(0)
	arg_10_0.defenceVal = idler.new(0)
	arg_10_0.specialDamageVal = idler.new(0)
	arg_10_0.specialDefenceVal = idler.new(0)

	idlereasy.when(arg_10_0.attrs, function(arg_15_0, arg_15_1)
		for iter_15_0, iter_15_1 in ipairs(game.ATTRDEF_SIMPLE_TABLE) do
			arg_10_0[iter_15_1 .. "Val"]:set(math.floor(arg_15_1[iter_15_1]))
		end
	end)

	local var_10_1 = {}

	for iter_10_0, iter_10_1 in ipairs(gCardExpItemCsv) do
		local var_10_2 = iter_10_1.id

		table.insert(var_10_1, {
			num = idler.new(0),
			key = var_10_2,
			y = y,
			cfg = iter_10_1
		})
	end

	arg_10_0.itemData = idlers.newWithMap(var_10_1)
	arg_10_0.showOneKeyUpgrade = false

	idlereasy.any({
		arg_10_0.items,
		arg_10_0.clickLevelUpdata
	}, function(arg_16_0, arg_16_1)
		local var_16_0 = 0
		local var_16_1 = arg_10_0.levelExp:read()

		for iter_16_0, iter_16_1 in ipairs(gCardExpItemCsv) do
			local var_16_2 = iter_16_1.id

			arg_10_0.itemData:atproxy(iter_16_0).num = math.max(0, (arg_16_1[var_16_2] or 0) - (arg_10_0.costData[iter_16_1.id] or 0))
			var_16_0 = var_16_0 + iter_16_1.specialArgsMap.exp * (arg_16_1[iter_16_1.id] or 0)
		end

		arg_10_0.showOneKeyUpgrade = var_16_0 + var_16_1 >= arg_10_0.clientNextLvExp
	end)

	arg_10_0.fetterData = idlertable.new({})
	arg_10_0.attrDatas = idlers.newWithMap({})

	idlereasy.any({
		arg_10_0.cardDatas,
		arg_10_0.fetters,
		arg_10_0.cardId,
		arg_10_0.natureChosse
	}, function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
		local var_17_0 = csv.cards[arg_17_3]

		arg_10_0.raceTxt:set(var_17_0.specValue[csvSize(var_17_0.specValue)])

		local var_17_1 = {}
		local var_17_2 = {}
		local var_17_3 = {}

		for iter_17_0, iter_17_1 in ipairs(arg_17_1) do
			local var_17_4 = gGameModel.cards:find(iter_17_1)

			if var_17_4 then
				local var_17_5 = var_17_4:read("card_id")
				local var_17_6 = csv.cards[var_17_5].cardMarkID

				if not var_17_3[var_17_6] then
					var_17_3[var_17_6] = var_17_5
				elseif var_17_5 > var_17_3[var_17_6] then
					var_17_3[var_17_6] = var_17_5
				end
			end
		end

		local var_17_7 = itertools.map(itertools.ivalues(arg_17_2), function(arg_18_0, arg_18_1)
			return arg_18_1, arg_18_0
		end)
		local var_17_8 = csvSize(var_17_0.fetterList)

		for iter_17_2 = 1, var_17_8 do
			local var_17_9 = var_17_0.fetterList[iter_17_2]
			local var_17_10 = var_17_7[var_17_9] ~= nil

			var_17_1[iter_17_2] = {
				id = var_17_9,
				cardDatas = var_17_3,
				isShow = var_17_10
			}
		end

		arg_10_0.fetterData:set(var_17_1)

		local var_17_11 = {}
		local var_17_12 = csv.unit[var_17_0.unitID]

		table.insert(var_17_11, {
			var_17_12.natureType,
			true
		})
		arg_10_0.btnChooseAttr:hide()

		if var_17_12.natureType2 and arg_17_4 and arg_17_4 ~= 0 then
			table.insert(var_17_11, {
				var_17_12.natureType2,
				true
			})

			var_17_11[3 - arg_17_4][2] = false
		end

		arg_10_0.attrDatas:update(var_17_11)
	end)

	arg_10_0.trammelsPanel = idler.new(false)
	arg_10_0.gradePanel = idler.new(false)
	arg_10_0.showGradePanel = idler.new(true)

	idlereasy.when(arg_10_0.showGradePanel, function(arg_19_0, arg_19_1)
		arg_10_0.trammelsPanel:set(arg_19_1)
		arg_10_0.gradePanel:set(not arg_19_1)

		local var_19_0 = "common/btn/btn_nomal_2.png"
		local var_19_1 = gLanguageCsv.upgrade

		if not arg_19_1 then
			var_19_0 = "common/btn/btn_cancel.png"
			var_19_1 = ""
		end

		arg_10_0.btnLvUpTxt:text(var_19_1)
		arg_10_0.btnLvUp:loadTextureNormal(var_19_0)
	end)
	dataEasy.getListenUnlock(gUnlockCsv.onekeyLevelup, function(arg_20_0)
		if not arg_20_0 then
			arg_10_0.btnOneKeyLvUp:hide()

			local var_20_0 = arg_10_0.btnOneKeyLvUp:x() + arg_10_0.btnOneKeyLvUp:size().width / 2 - arg_10_0.btnLvUp:size().width / 2

			arg_10_0.btnLvUp:x(var_20_0)
		end
	end)
	arg_10_0.textNum:hide()
end

function var_0_1.initModel(arg_21_0)
	idlereasy.when(arg_21_0.selectDbId, function(arg_22_0, arg_22_1)
		arg_21_0.selectDbIdChange = true

		local var_22_0 = gGameModel.cards:find(arg_22_1)

		arg_21_0.gender = idlereasy.assign(var_22_0:getIdler("gender"), arg_21_0.gender)
		arg_21_0.cardId = idlereasy.assign(var_22_0:getIdler("card_id"), arg_21_0.cardId)
		arg_21_0.cardLevel = idlereasy.assign(var_22_0:getIdler("level"), arg_21_0.cardLevel)
		arg_21_0.attrs = idlereasy.assign(var_22_0:getIdler("attrs"), arg_21_0.attrs)
		arg_21_0.fetters = idlereasy.assign(var_22_0:getIdler("fetters"), arg_21_0.fetters)
		arg_21_0.currSelect = idlereasy.assign(var_22_0:getIdler("character"), arg_21_0.currSelect)
		arg_21_0.levelExp = idlereasy.assign(var_22_0:getIdler("level_exp"), arg_21_0.levelExp)
		arg_21_0.natureChosse = idlereasy.assign(var_22_0:getIdler("nature_choose"), arg_21_0.natureChosse)
	end)

	arg_21_0.cardDatas = gGameModel.role:getIdler("cards")
	arg_21_0.items = gGameModel.role:getIdler("items")
	arg_21_0.rmb = gGameModel.role:getIdler("rmb")
	arg_21_0.roleLv = gGameModel.role:getIdler("level")
	arg_21_0.shareTimes = gGameModel.daily_record:getIdler("card_share_times")
end

function var_0_1.onExchangeChooseNature(arg_23_0)
	local var_23_0 = arg_23_0.cardId:read()
	local var_23_1 = arg_23_0.selectDbId:read()
	local var_23_2 = csv.cards[var_23_0]
	local var_23_3 = csv.unit[var_23_2.unitID]
	local var_23_4 = {
		var_23_3.natureType,
		var_23_3.natureType2
	}
	local var_23_5 = arg_23_0.natureChosse:read()

	local function var_23_6()
		gGameApp:requestServer("/game/card/nature/choose", function(arg_25_0)
			gGameUI:showTip(gLanguageCsv.chooseNatureTypeSuccess)
		end, var_23_1, 3 - var_23_5)
	end

	local var_23_7 = string.format(gLanguageCsv.chooseNatureText, ui.ATTR_ICON[var_23_4[var_23_5]], ui.ATTR_ICON[var_23_4[3 - var_23_5]])

	gGameUI:showDialog({
		btnType = 2,
		isRich = true,
		content = var_23_7,
		cb = var_23_6
	})
end

function var_0_1.onCharacterClick(arg_26_0)
	gGameUI:stackUI("city.card.character", nil, nil, arg_26_0.cardId:read(), arg_26_0.currSelect:read())
end

function var_0_1.onAttrDetail(arg_27_0)
	gGameUI:stackUI("city.card.attrdetail", nil, nil, arg_27_0.selectDbId:read())
end

function var_0_1.onShowGradeClick(arg_28_0)
	arg_28_0.showGradePanel:modify(function(arg_29_0)
		return true, not arg_29_0
	end)
end

function var_0_1.onUpGradePanelClick(arg_30_0)
	if arg_30_0.cardLevel:read() >= arg_30_0.roleLv:read() then
		gGameUI:showTip(gLanguageCsv.cardLevelReachedLimit)

		return
	end

	if not arg_30_0.showOneKeyUpgrade then
		gGameUI:showTip(gLanguageCsv.levelUpNoEnough)

		return
	end

	gGameUI:stackUI("city.card.upgrade", nil, nil, {
		type = 1,
		selectDbId = arg_30_0.selectDbId:read()
	}, arg_30_0:createHandler("isSuccess"))
end

function var_0_1.isSuccess(arg_31_0)
	arg_31_0.showSuccessTip = true

	arg_31_0.clientLv:notify()
end

function var_0_1.showFetterClick(arg_32_0)
	gGameUI:stackUI("city.card.fetter", nil, nil, arg_32_0.fetterData:read(), arg_32_0.cardId:read())
end

function var_0_1.checkCanLvUp(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_0.clientCurLvExp:read()
	local var_33_1 = true

	while var_33_0 >= arg_33_0.clientNextLvExp do
		if arg_33_0:canLevelUp() then
			arg_33_0.showSuccessTip = var_33_1
			var_33_1 = false
			var_33_0 = var_33_0 - arg_33_0.clientNextLvExp

			arg_33_0.clientCurLvExp:set(var_33_0)
			arg_33_0.clientLv:modify(function(arg_34_0)
				return true, arg_34_0 + 1
			end)
		else
			arg_33_0.clientCurLvExp:modify(function(arg_35_0)
				return true, arg_33_0.clientNextLvExp
			end)

			break
		end
	end
end

function var_0_1.onItemClick(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5)
	local function var_36_0(arg_37_0, arg_37_1)
		arg_37_0 = arg_37_0 or 1

		if arg_36_2.num <= 0 then
			if not arg_37_1 then
				if arg_36_0.roleLv:read() < arg_36_4.cfg.specialArgsMap.buy_level then
					gGameUI:showTip(string.format(gLanguageCsv.buyInfoTip, arg_36_4.cfg.specialArgsMap.buy_level))

					return
				end

				local var_37_0 = 1 - dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.ExpItemCostFallRate)
				local var_37_1 = arg_36_4.cfg.specialArgsMap.buy_rmb
				local var_37_2 = mathEasy.getPreciseDecimal(arg_36_4.cfg.specialArgsMap.buy_rmb * var_37_0, 0, true)
				local var_37_3 = 9999

				arg_36_0.key = arg_36_4.key

				gGameUI:stackUI("common.buy_info", nil, nil, {
					rmb = var_37_1
				}, {
					id = arg_36_4.key
				}, {
					contentType = "num",
					maxNum = var_37_3,
					discount = var_37_0
				}, arg_36_0:createHandler("showBuyInfo"))
			end
		elseif arg_36_0:canLevelUp() then
			arg_36_2.num = arg_36_2.num - arg_37_0

			arg_36_2.resetState()

			arg_36_0.costData[arg_36_4.key] = arg_36_0.costData[arg_36_4.key] and arg_36_0.costData[arg_36_4.key] + arg_37_0 or arg_37_0

			arg_36_0.clientCurLvExp:modify(function(arg_38_0)
				return true, arg_38_0 + arg_36_4.cfg.specialArgsMap.exp * arg_37_0
			end)
			arg_36_0.textNum:show():text("x" .. arg_36_0.costData[arg_36_4.key])
			arg_36_0:checkCanLvUp(arg_36_3, arg_36_4)

			if not arg_36_2.lvUpEffect then
				arg_36_2.lvUpEffect = widget.addAnimation(arg_36_2, "koudai_gonghuixunlian/gonghuixunlian.skel", "fangguang", 10):xy(65, 0):scale(0.8)
			else
				arg_36_2.lvUpEffect:play("fangguang")
			end

			audio.playEffectWithWeekBGM("square.mp3")

			return true
		else
			gGameUI:showTip(gLanguageCsv.cardLevelReachedLimit)
		end
	end

	if arg_36_5.name == "began" then
		arg_36_0.selectDbIdChange = false
		arg_36_0.lvTouchTimes = 0.5
		arg_36_0.count = 1

		local var_36_1 = 0.5

		local function var_36_2()
			arg_36_0.lvTouchTimes = math.max(arg_36_0.lvTouchTimes - 0.03, 0.05)
			var_36_1 = var_36_1 + 0.1

			if var_36_1 >= arg_36_0.lvTouchTimes then
				var_36_1 = 0
				arg_36_0.count = cc.clampf(arg_36_0.count, 1, math.floor(arg_36_0.clientMaxLvNeedExp / arg_36_4.cfg.specialArgsMap.exp))

				if not var_36_0(arg_36_0.count, arg_36_0.lvTouchTimes ~= 0.47) then
					return false
				end
			end
		end

		if var_36_2() ~= false then
			arg_36_0:schedule(var_36_2, 0.05, 0.05, "attrLvUp")
		end
	elseif arg_36_5.name == "moved" then
		if not arg_36_0.lvTouchBeganPos then
			arg_36_0.lvTouchBeganPos = arg_36_2:getTouchBeganPosition()
		end

		local var_36_3 = math.abs(arg_36_5.x - arg_36_0.lvTouchBeganPos.x)
		local var_36_4 = math.abs(arg_36_5.y - arg_36_0.lvTouchBeganPos.y)

		if var_36_3 >= ui.TOUCH_MOVE_CANCAE_THRESHOLD or var_36_4 >= ui.TOUCH_MOVE_CANCAE_THRESHOLD then
			arg_36_0:unSchedule("attrLvUp")
		end
	elseif arg_36_5.name == "ended" or arg_36_5.name == "cancelled" then
		arg_36_0:unSchedule("attrLvUp")

		arg_36_0.lvTouchBeganPos = nil

		arg_36_0:sendRequeat()
		arg_36_0.textNum:hide()
	end
end

function var_0_1.showBuyInfo(arg_40_0, arg_40_1)
	gGameApp:requestServer("/game/exp/buy_item", function(arg_41_0)
		gGameUI:showTip(gLanguageCsv.hasBuy)
	end, arg_40_0.key, arg_40_1)
end

function var_0_1.upgradeFloatingWord(arg_42_0, arg_42_1)
	local var_42_0, var_42_1 = arg_42_0.progressBar:xy()
	local var_42_2 = cc.Label:createWithTTF("exp+" .. arg_42_1, ui.FONT_PATH, 54):align(cc.p(0.5, 0.5), var_42_0, var_42_1 + 40):addTo(arg_42_0.levelupPanel, 11)

	text.addEffect(var_42_2, {
		color = cc.c4b(0, 255, 0, 255),
		outline = {
			size = 3,
			color = cc.c4b(44, 44, 44, 255)
		}
	})
	transition.executeSequence(var_42_2):moveBy(0.4, 0, 50):fadeOut(0.1):func(function()
		var_42_2:removeSelf()
	end):done()
end

function var_0_1.canLevelUp(arg_44_0)
	if arg_44_0.clientLv:read() < arg_44_0.roleLv:read() then
		return true
	end

	return false
end

function var_0_1.sendRequeat(arg_45_0, arg_45_1)
	if not itertools.isempty(arg_45_0.costData) then
		local var_45_0 = arg_45_0.costData

		arg_45_0.costData = {}

		gGameApp:requestServer("/game/card/exp/use_items", function()
			if arg_45_1 then
				arg_45_1()
			end
		end, arg_45_0.selectDbId, var_45_0)
	elseif arg_45_1 then
		arg_45_1()
	end
end

function var_0_1.onShowAtrtInfo(arg_47_0)
	gGameUI:stackUI("city.card.nature_attr_info", nil, nil, arg_47_0.selectDbId:read())
end

function var_0_1.onShareCard(arg_48_0)
	if arg_48_0.shareTimes:read() >= gCommonConfigCsv.shareTimesLimit then
		gGameUI:showTip(gLanguageCsv.shareTimesNotEnough)

		return
	end

	gGameUI:stackUI("city.card.share_tip", nil, nil, arg_48_0.selectDbId:read())
end

return var_0_1
