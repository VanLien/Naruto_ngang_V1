local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0 = arg_1_0:get("effect")
	local var_1_1 = arg_1_0:size()
	local var_1_2 = arg_1_3 or 0
	local var_1_3 = arg_1_4 or 0
	local var_1_4 = arg_1_5 or 10

	if not var_1_0 then
		var_1_0 = widget.addAnimationByKey(arg_1_0, arg_1_1, "effect", "effect", var_1_4):xy(var_1_1.width / 2 + var_1_2, var_1_1.height / 2 + var_1_3):scale(arg_1_2)
	else
		var_1_0:play("effect")
	end
end

local function var_0_1(arg_2_0, arg_2_1, arg_2_2)
	bind.extend(arg_2_0, arg_2_1, {
		class = "icon_key",
		props = {
			data = {
				key = arg_2_2.key,
				num = arg_2_2.num
			},
			grayState = arg_2_2.num <= 0 and 1 or 0,
			onNode = function(arg_3_0)
				arg_3_0:setTouchEnabled(false)
				arg_3_0:scale(0.8):z(100)
			end
		}
	})
	arg_2_1:get("icon"):visible(arg_2_2.num <= 0)
end

local var_0_2 = class("CardFeelView", Dialog)

var_0_2.RESOURCE_FILENAME = "card_feel.json"
var_0_2.RESOURCE_BINDING = {
	["leftPanel.textNum"] = "textNum",
	["leftPanel.bar"] = "progressBar",
	pageItem = "pageItem",
	["rightPanel.attrSubList"] = "attrSubList",
	attrItem = "attrItem",
	leftPanel = "leftPanel",
	rightPanel = "rightPanel",
	["rightPanel.effectList"] = "effectList",
	mask = "mask",
	item = "item",
	["rightPanel.btnSelectItem.img"] = "img",
	["rightPanel.btnSelectItem.note"] = "note",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["rightPanel.btnLvUp"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onOneKeyClick")
			}
		}
	},
	["rightPanel.btnLvUpEasy"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onLvUpEasyClick")
			}
		}
	},
	["leftPanel.btnLvUp.textTitle"] = {
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
	["leftPanel.btnLvUpEasy.textTitle"] = {
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
	textTitle1 = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	textTitle2 = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	["leftPanel.btnInfo"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnInfo")
			}
		}
	},
	["rightPanel.btnSelectItem"] = {
		varname = "btnSelectItem",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnSelectItem")
			}
		}
	},
	["rightPanel.itemList"] = {
		varname = "itemList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("costItemDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					var_0_1(arg_4_0, arg_4_1, arg_4_3)
					arg_4_1:onTouch(functools.partial(arg_4_0.itemClick, arg_4_1, arg_4_2, arg_4_3))
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
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
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					arg_5_1:get("normal"):visible(arg_5_3.select ~= true)
					arg_5_1:get("select"):visible(arg_5_3.select == true)
				end,
				onAfterBuild = function(arg_6_0)
					arg_6_0:setItemAlignCenter()
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	["rightPanel.attrList"] = {
		varname = "attrList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 2,
				asyncPreload = 6,
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("attrSubList"),
				cell = bindHelper.self("attrItem"),
				onCell = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = arg_7_1:multiget("txtName", "txtNum", "icon")

					var_7_0.icon:texture(arg_7_3.icon)
					var_7_0.txtName:text(arg_7_3.name)
					var_7_0.txtNum:text(math.floor(arg_7_3.num))
					adapt.oneLinePos(var_7_0.txtName, var_7_0.txtNum, cc.p(20, 0))
				end
			}
		}
	}
}

function var_0_2.onCreate(arg_8_0, arg_8_1)
	arg_8_0:initModel()

	arg_8_1 = arg_8_1 or gGameModel.cards:find(arg_8_0.cards:read()[1]):read("card_id")
	arg_8_0.cardId = arg_8_1
	arg_8_0.costData = {}

	arg_8_0:enableSchedule()

	arg_8_0.costItemDatas = idlertable.new()

	local var_8_0 = csv.cards[arg_8_0.cardId]

	arg_8_0.clientCurLvExp = idler.new(0)
	arg_8_0.showSuccessTip = false
	arg_8_0.cardMarkID = var_8_0.cardMarkID
	arg_8_0.maxLimitLv = table.length(gGoodFeelCsv[var_8_0.feelType])
	arg_8_0.isFirst = true
	arg_8_0.clientCurLvExp = idler.new(0)
	arg_8_0.clientLv = idler.new(0)
	arg_8_0.canOneUp = false

	idlereasy.when(arg_8_0.cardFeels, function(arg_9_0, arg_9_1)
		local var_9_0 = arg_9_1[var_8_0.cardMarkID] or {}
		local var_9_1 = var_9_0.level or 0

		if arg_8_0.oldClientLvEffect and var_9_1 > arg_8_0.oldClientLvEffect then
			arg_8_0.showSuccessTip = true
		end

		arg_8_0.oldClientLvEffect = var_9_1

		arg_8_0.clientLv:set(var_9_1)
		arg_8_0.clientCurLvExp:set(var_9_0.level_exp or 0)
	end)
	arg_8_0.note:anchorPoint(0.5, 0.5)
	adapt.setTextAdaptWithSize(arg_8_0.note, {
		vertical = "center",
		str = gLanguageCsv.cardFeelViewtext,
		size = cc.size(220, 200)
	})
	adapt.oneLinePos(arg_8_0.img, arg_8_0.note, nil, "left")

	arg_8_0.attrDatas = idlers.new()

	idlereasy.any({
		arg_8_0.clientLv,
		arg_8_0.items,
		arg_8_0.clientCurLvExp
	}, function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		local var_10_0 = gGoodFeelCsv[var_8_0.feelType]
		local var_10_1 = {}

		arg_8_0.canOneUp = false

		local var_10_2 = 0

		for iter_10_0, iter_10_1 in orderCsvPairs(var_8_0.feelItems) do
			table.insert(var_10_1, {
				key = iter_10_1,
				num = arg_10_2[iter_10_1] or 0,
				cfg = csv.items[iter_10_1]
			})

			local var_10_3 = var_10_0[math.min(arg_10_1 + 1, arg_8_0.maxLimitLv)].needExp

			var_10_2 = (arg_10_2[iter_10_1] or 0) * csv.items[iter_10_1].specialArgsMap.feel_exp + var_10_2

			if var_10_3 <= arg_10_3 + var_10_2 then
				arg_8_0.canOneUp = true
			end
		end

		arg_8_0.costItemDatas:set(var_10_1)
		arg_8_0.leftPanel:get("textLv"):text(arg_10_1)

		if arg_8_0.showSuccessTip then
			arg_8_0.showSuccessTip = false

			arg_8_0.progressBar:setPercent(0)
			var_0_0(arg_8_0.progressBar, "effect/shengjitiao.skel", 0.8)
			var_0_0(arg_8_0.leftPanel, "haogan/haogan.skel", 1, 30, -100, 10)
		end

		arg_8_0.clientNextLvExp = var_10_0[math.min(arg_10_1 + 1, arg_8_0.maxLimitLv)].needExp

		arg_8_0.leftPanel:get("textExp1"):text(arg_10_3)
		arg_8_0.leftPanel:get("textExp2"):text("/" .. arg_8_0.clientNextLvExp)

		local var_10_4 = cc.clampf(arg_10_3 / arg_8_0.clientNextLvExp * 100, 0, 100)

		if arg_8_0.maxLimitLv == arg_10_1 then
			var_10_4 = 100

			local var_10_5 = var_10_0[arg_10_1].needExp

			arg_8_0.leftPanel:get("textExp1"):text(var_10_5)
			arg_8_0.leftPanel:get("textExp2"):text("/" .. var_10_5)
		end

		adapt.oneLinePos(arg_8_0.leftPanel:get("textExp2"), arg_8_0.leftPanel:get("textExp1"), nil, "right")

		if var_10_4 < arg_8_0.progressBar:getPercent() or arg_8_0.isFirst then
			arg_8_0.isFirst = false

			arg_8_0.progressBar:setPercent(var_10_4)
		else
			transition.executeSequence(arg_8_0.progressBar):progressTo(0.29, var_10_4):done()
		end

		if arg_8_0.oldClientLv ~= arg_10_1 then
			arg_8_0:setAttrDatas(var_10_0, arg_10_1)
			arg_8_0:setAddAttrDatas(var_8_0, arg_10_1, arg_8_0.oldClientLv)

			arg_8_0.oldClientLv = arg_10_1
		end
	end)

	local var_8_1 = userDefault.getForeverLocalKey("CardFeelView", false)

	arg_8_0.selectState = idler.new(var_8_1)

	idlereasy.any({
		arg_8_0.selectState,
		arg_8_0.costItemDatas
	}, function(arg_11_0, arg_11_1, arg_11_2)
		local var_11_0 = arg_11_1 and "common/icon/radio_selected.png" or "common/icon/radio_normal.png"

		arg_8_0.btnSelectItem:get("img"):texture(var_11_0)

		local var_11_1 = 0

		for iter_11_0, iter_11_1 in ipairs(arg_11_2) do
			if arg_11_1 == false or arg_11_1 == true and not iter_11_1.cfg.specialArgsMap.special then
				var_11_1 = var_11_1 + iter_11_1.cfg.specialArgsMap.feel_exp * iter_11_1.num
			end
		end

		arg_8_0.expEnough = var_11_1 > 0
	end)

	arg_8_0.evolutionDatas = idlers.new({})

	local var_8_2 = {}

	for iter_8_0, iter_8_1 in ipairs(arg_8_0.cards:read()) do
		var_8_2[gGameModel.cards:find(iter_8_1):read("card_id")] = true
	end

	local var_8_3 = {}
	local var_8_4 = false

	for iter_8_2, iter_8_3 in orderCsvPairs(csv.cards) do
		if matchLanguage(iter_8_3.languages) then
			local var_8_5 = false

			if iter_8_3.cardMarkID == var_8_0.cardMarkID and iter_8_3.canDevelop then
				var_8_5 = true
			end

			if not dataEasy.isUnlock(gUnlockCsv.mega) and iter_8_3.megaIndex > 0 then
				var_8_5 = false
			elseif not iter_8_3.canDevelop and dataEasy.isUnlock(gUnlockCsv.mega) then
				var_8_5 = false
			end

			if var_8_5 then
				table.insert(var_8_3, {
					existCards = var_8_2,
					selectDevelop = iter_8_3.develop,
					cfg = iter_8_3,
					id = iter_8_2
				})
			end
		end
	end

	table.sort(var_8_3, function(arg_12_0, arg_12_1)
		return arg_12_0.id < arg_12_1.id
	end)
	arg_8_0.evolutionDatas:update(var_8_3)

	local var_8_6 = arg_8_0.item:size().width
	local var_8_7 = arg_8_0.costItemDatas:size()

	arg_8_0.itemList:x(arg_8_0.itemList:x() + (5 - var_8_7) * var_8_6 / 2)
	arg_8_0.itemList:setItemsMargin((5 - var_8_7) * var_8_6 / 8)

	local var_8_8 = 1

	for iter_8_4, iter_8_5 in ipairs(var_8_3) do
		if iter_8_5.id == var_8_0.id then
			var_8_8 = iter_8_4
		end
	end

	arg_8_0.selectEvolution = idler.new(var_8_8)

	arg_8_0.selectEvolution:addListener(function(arg_13_0, arg_13_1)
		local var_13_0 = arg_8_0.evolutionDatas:atproxy(arg_13_0)
		local var_13_1 = arg_8_0.evolutionDatas:atproxy(arg_13_1)

		if var_13_1 then
			var_13_1.select = false
		end

		if var_13_0 then
			arg_8_0:setLeftPanel(var_13_0)

			var_13_0.select = true
		end
	end)
	arg_8_0:initPrivilegeListener()
	arg_8_0.textNum:hide()
	Dialog.onCreate(arg_8_0)
end

function var_0_2.initModel(arg_14_0)
	arg_14_0.items = gGameModel.role:getIdler("items")
	arg_14_0.cards = gGameModel.role:getIdler("cards")
	arg_14_0.cardFeels = gGameModel.role:getIdler("card_feels")
	arg_14_0.gold = gGameModel.role:getIdler("gold")
end

function var_0_2.setAttrDatas(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = {}
	local var_15_1 = {}

	for iter_15_0 = 1, 6 do
		local var_15_2 = arg_15_1[arg_15_2]["attrNum" .. iter_15_0]
		local var_15_3 = game.ATTRDEF_TABLE[arg_15_1[arg_15_2]["attrType" .. iter_15_0]]
		local var_15_4 = gLanguageCsv["attr" .. string.caption(var_15_3)]
		local var_15_5 = 0

		if arg_15_2 < arg_15_0.maxLimitLv then
			var_15_5 = arg_15_1[arg_15_2 + 1]["attrNum" .. iter_15_0]
		end

		if var_15_2 < var_15_5 then
			table.insert(var_15_0, {
				name = var_15_4,
				num = var_15_5 - var_15_2
			})
		end

		table.insert(var_15_1, {
			name = var_15_4 .. ":",
			num = var_15_2,
			icon = ui.ATTR_LOGO[var_15_3]
		})
	end

	if #var_15_0 > 0 then
		local var_15_6 = "#C0x57472E#("

		for iter_15_1 = 1, 2 do
			if var_15_0[iter_15_1] then
				var_15_6 = string.format("%s#C0x57472E# %s#C0x01a001#+%s", var_15_6, var_15_0[iter_15_1].name, var_15_0[iter_15_1].num)
			end
		end

		local var_15_7 = var_15_6 .. "#C0x57472E# )"
		local var_15_8 = arg_15_0.rightPanel:get("textTip"):size()

		arg_15_0.rightPanel:get("textTip"):removeAllChildren()
		rich.createByStr(var_15_7, 40):anchorPoint(0, 0.5):xy(var_15_8.width + 20, var_15_8.height / 2):addTo(arg_15_0.rightPanel:get("textTip"), 6)
	else
		arg_15_0.rightPanel:get("textTip"):hide()
	end

	arg_15_0.attrDatas:update(var_15_1)
end

function var_0_2.setAddAttrDatas(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = gGoodFeelEffectCsv[arg_16_1.cardMarkID]
	local var_16_1 = {}

	for iter_16_0, iter_16_1 in pairs(var_16_0) do
		local var_16_2 = "#C0x57472E#"
		local var_16_3 = "#C0x56A732#"

		if arg_16_2 < iter_16_0 then
			var_16_2 = "#C0x979389#"
			var_16_3 = "#C0x979389#"
		end

		local var_16_4 = ""
		local var_16_5 = 0

		for iter_16_2 = 1, 6 do
			local var_16_6 = dataEasy.getAttrValueString(iter_16_1["attrType" .. iter_16_2], iter_16_1["attrNum" .. iter_16_2])

			if var_16_6 ~= "" then
				var_16_5 = var_16_5 + 1

				if var_16_5 > 1 then
					var_16_4 = string.format("%s%s,", var_16_4, var_16_2)
				end

				local var_16_7 = game.ATTRDEF_TABLE[iter_16_1["attrType" .. iter_16_2]]
				local var_16_8 = gLanguageCsv["attr" .. string.caption(var_16_7)]

				var_16_4 = string.format("%s%s %s%s+%s", var_16_4, var_16_2, var_16_8, var_16_3, var_16_6)
			end
		end

		if var_16_5 == 6 then
			var_16_4 = string.format("%s+%s", var_16_3, dataEasy.getAttrValueString(iter_16_1["attrType" .. 1], iter_16_1["attrNum" .. 1]))
		end

		if iter_16_1.natureType ~= 0 then
			local var_16_9 = gLanguageCsv[game.NATURE_TABLE[iter_16_1.natureType]] .. gLanguageCsv.xi

			var_16_4 = string.format(iter_16_1.desc, var_16_9, var_16_4)
		else
			var_16_4 = string.format(iter_16_1.desc, var_16_4)
		end

		table.insert(var_16_1, {
			verticalSpace = 10,
			str = var_16_2 .. string.format(gLanguageCsv.feelLevelNote, iter_16_0) .. var_16_4,
			level = iter_16_1.level
		})
	end

	table.sort(var_16_1, function(arg_17_0, arg_17_1)
		return arg_17_0.level < arg_17_1.level
	end)
	beauty.textScroll({
		isRich = true,
		fontSize = 40,
		list = arg_16_0.effectList,
		strs = var_16_1
	})

	for iter_16_3, iter_16_4 in ipairs(var_16_1) do
		if arg_16_3 and arg_16_3 < iter_16_4.level and arg_16_2 >= iter_16_4.level then
			local var_16_10 = arg_16_0.effectList:getChildren()[iter_16_3]

			var_0_0(var_16_10, "haogandujiesuo/shuzhibianhua.skel", 1, 0, 5)
		end
	end
end

function var_0_2.setLeftPanel(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.leftPanel:multiget("textLv", "textExp", "bar", "cardIcon", "textTip", "iconRarity", "textCardName", "iconAttr1", "iconAttr2", "btnSelectItem")
	local var_18_1 = csv.unit[arg_18_1.cfg.unitID]
	local var_18_2 = var_18_0.cardIcon:size()
	local var_18_3 = {
		"standby_loop",
		"attack",
		"win_loop",
		"run_loop"
	}

	var_18_0.cardIcon:removeAllChildren()

	local var_18_4 = string.gsub(var_18_1.unitRes, ".skel", "_ui.skel")

	widget.addAnimation(var_18_0.cardIcon, var_18_4, var_18_3[1], 5):xy(var_18_2.width / 2, 0):scale(var_18_1.scaleU * 0.6):setSkin(var_18_1.skin)
	var_18_0.iconAttr1:texture(ui.ATTR_ICON[var_18_1.natureType])
	var_18_0.iconAttr2:hide()

	if var_18_1.natureType2 then
		var_18_0.iconAttr2:texture(ui.ATTR_ICON[var_18_1.natureType2]):show()
	end

	var_18_0.textTip:visible(arg_18_1.existCards[arg_18_1.id] ~= true)
	var_18_0.textCardName:text(arg_18_1.cfg.name)
	var_18_0.iconRarity:texture(ui.RARITY_ICON[var_18_1.rarity])
	adapt.oneLinePos(var_18_0.textCardName, {
		var_18_0.iconRarity,
		var_18_0.textTip
	}, cc.p(8, 0), "right")
	adapt.oneLinePos(var_18_0.textCardName, {
		var_18_0.iconAttr1,
		var_18_0.iconAttr2
	}, cc.p(8, 0))
end

function var_0_2.onItemClick(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	local function var_19_0(arg_20_0, arg_20_1)
		arg_20_0 = arg_20_0 or 1

		if arg_19_4.num <= 0 then
			if not arg_20_1 then
				gGameUI:stackUI("common.gain_way", nil, nil, arg_19_4.key)
			end
		elseif arg_19_0:canLevelUp() then
			arg_19_4.num = arg_19_4.num - arg_20_0

			var_0_1(arg_19_1, arg_19_2, arg_19_4)

			arg_19_0.costData[arg_19_4.key] = arg_19_0.costData[arg_19_4.key] and arg_19_0.costData[arg_19_4.key] + arg_20_0 or arg_20_0

			arg_19_0.clientCurLvExp:modify(function(arg_21_0)
				return true, arg_21_0 + arg_19_4.cfg.specialArgsMap.feel_exp
			end)
			arg_19_0.textNum:show():text("x" .. arg_19_0.costData[arg_19_4.key])
			arg_19_0:checkCanLvUp(arg_19_3, arg_19_4)

			if not arg_19_2.lvUpEffect then
				arg_19_2.lvUpEffect = widget.addAnimation(arg_19_2, "koudai_gonghuixunlian/gonghuixunlian.skel", "fangguang", 10):xy(81, 6):scale(0.8)
			else
				arg_19_2.lvUpEffect:play("fangguang")
			end

			return true
		else
			gGameUI:showTip(gLanguageCsv.feelReachedFullLevel)
		end
	end

	if arg_19_5.name == "began" then
		arg_19_0.lvTouchTimes = 0.3
		arg_19_0.count = 1

		arg_19_0:schedule(function()
			arg_19_0.lvTouchTimes = math.max(arg_19_0.lvTouchTimes - 0.03, 0.05)

			if not var_19_0(arg_19_0.count, arg_19_0.lvTouchTimes ~= 0.27) then
				return false
			end
		end, 0.1, 0, "feelLvUp")
	elseif arg_19_5.name == "moved" then
		if not arg_19_0.lvTouchBeganPos then
			arg_19_0.lvTouchBeganPos = arg_19_2:getTouchBeganPosition()
		end

		local var_19_1 = math.abs(arg_19_5.x - arg_19_0.lvTouchBeganPos.x)
		local var_19_2 = math.abs(arg_19_5.y - arg_19_0.lvTouchBeganPos.y)

		if var_19_1 >= ui.TOUCH_MOVE_CANCAE_THRESHOLD or var_19_2 >= ui.TOUCH_MOVE_CANCAE_THRESHOLD then
			arg_19_0:unSchedule("feelLvUp")
		end
	elseif arg_19_5.name == "ended" or arg_19_5.name == "cancelled" then
		arg_19_0:unSchedule("feelLvUp")

		arg_19_0.lvTouchBeganPos = nil

		arg_19_0:sendRequeat()
		arg_19_0.textNum:hide()
	end
end

function var_0_2.checkCanLvUp(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0.clientCurLvExp:read()
	local var_23_1 = true

	while var_23_0 >= arg_23_0.clientNextLvExp do
		if arg_23_0:canLevelUp() then
			arg_23_0.showSuccessTip = var_23_1
			var_23_1 = false
			var_23_0 = var_23_0 - arg_23_0.clientNextLvExp

			arg_23_0.clientCurLvExp:set(var_23_0)
			arg_23_0.clientLv:modify(function(arg_24_0)
				return true, arg_24_0 + 1
			end)
		else
			arg_23_0.clientCurLvExp:modify(function(arg_25_0)
				return true, arg_23_0.clientNextLvExp
			end)

			break
		end
	end
end

function var_0_2.canLevelUp(arg_26_0)
	if arg_26_0.clientLv:read() < arg_26_0.maxLimitLv then
		return true
	end

	return false
end

function var_0_2.sendRequeat(arg_27_0, arg_27_1)
	if not itertools.isempty(arg_27_0.costData) then
		local var_27_0 = arg_27_0.costData

		arg_27_0.costData = {}

		gGameApp:requestServer("/game/card/feel/use_items", function()
			if arg_27_1 then
				arg_27_1()
			end
		end, arg_27_0.cardMarkID, var_27_0)
	elseif arg_27_1 then
		arg_27_1()
	end
end

function var_0_2.onOneKeyClick(arg_29_0)
	if not arg_29_0:canLevelUp() then
		gGameUI:showTip(gLanguageCsv.feelReachedFullLevel)

		return
	end

	if not arg_29_0.expEnough then
		gGameUI:showTip(gLanguageCsv.materialsNotEnough)

		return
	end

	gGameUI:showDialog({
		btnType = 2,
		content = gLanguageCsv.wantUpgradeWithOneClick,
		cb = function()
			gGameApp:requestServer("/game/card/feel/tomax", function(arg_31_0)
				return
			end, arg_29_0.cardMarkID, arg_29_0.selectState)
		end
	})
end

function var_0_2.onLvUpEasyClick(arg_32_0)
	if not arg_32_0:canLevelUp() then
		gGameUI:showTip(gLanguageCsv.feelReachedFullLevel)

		return
	end

	if arg_32_0.canOneUp then
		gGameUI:stackUI("city.card.feel.upgrade", nil, nil, {
			type = 2,
			cardMarkID = arg_32_0.cardMarkID,
			cardId = arg_32_0.cardId,
			selectState = arg_32_0.selectState
		})
	else
		gGameUI:showTip(gLanguageCsv.materialsNotEnough)
	end
end

function var_0_2.onBtnSelectItem(arg_33_0)
	local var_33_0 = userDefault.getForeverLocalKey("CardFeelView", false)

	arg_33_0.selectState:set(not var_33_0)
	userDefault.setForeverLocalKey("CardFeelView", not var_33_0)
end

function var_0_2.initPrivilegeListener(arg_34_0)
	uiEasy.addTouchOneByOne(arg_34_0.mask, {
		ended = function(arg_35_0, arg_35_1, arg_35_2)
			if math.abs(arg_35_1) > 100 and math.abs(arg_35_1) > math.abs(arg_35_2) then
				local var_35_0 = arg_35_1 > 0 and -1 or 1

				arg_34_0.selectEvolution:modify(function(arg_36_0)
					arg_36_0 = cc.clampf(arg_36_0 + var_35_0, 1, arg_34_0.evolutionDatas:size())

					return true, arg_36_0
				end)
			end
		end
	})
end

function var_0_2.onBtnInfo(arg_37_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_37_0:createHandler("getRuleContext"), {
		width = 880
	})
end

function var_0_2.getRuleContext(arg_38_0, arg_38_1)
	local var_38_0 = adaptContext

	return {
		var_38_0.clone(arg_38_1.title, function(arg_39_0)
			arg_39_0:get("text"):text(gLanguageCsv.savorableOpinionStatement)
		end),
		var_38_0.noteText(61001, 61020)
	}
end

return var_0_2
