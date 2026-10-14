local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CraftEmbattleView", var_0_0)
local var_0_2 = {
	{
		attr = "fight",
		name = gLanguageCsv.fighting
	},
	{
		attr = "level",
		name = gLanguageCsv.level
	},
	{
		attr = "rarity",
		name = gLanguageCsv.rarity
	},
	{
		attr = "star",
		name = gLanguageCsv.star
	},
	{
		attr = "getTime",
		name = gLanguageCsv.getTime
	}
}
local var_0_3 = -1
local var_0_4 = 10
local var_0_5 = {
	final = 300,
	pre = 240,
	prepare = 600
}
local var_0_6 = {
	final = 4,
	pre = 3,
	signup = 1,
	over = 5,
	closed = 6,
	prepare = 2
}
local var_0_7 = {
	{
		7,
		8,
		9
	},
	{
		4,
		5,
		6
	},
	{
		1,
		2,
		3
	}
}
local var_0_8 = 10

local function var_0_9(arg_1_0)
	local var_1_0 = 0

	if string.find(arg_1_0, "prepare") then
		var_1_0 = var_0_5.prepare
	elseif string.find(arg_1_0, "pre") then
		var_1_0 = var_0_5.pre
	elseif string.find(arg_1_0, "final") then
		var_1_0 = var_0_5.final
	elseif arg_1_0 == "signup" then
		local var_1_1, var_1_2 = dataEasy.getTimeStrByKey("craft", "signUpStart", true)
		local var_1_3, var_1_4 = dataEasy.getTimeStrByKey("craft", "signUpEnd", true)
		local var_1_5 = time.getNowDate()

		var_1_5.hour = var_1_3
		var_1_5.min = var_1_4

		local var_1_6 = time.getTimestamp(var_1_5)

		var_1_5.hour = var_1_1
		var_1_5.min = var_1_2
		var_1_0 = var_1_6 - time.getTimestamp(var_1_5)
	end

	return var_1_0
end

var_0_1.RESOURCE_FILENAME = "craft_battle.json"
var_0_1.RESOURCE_BINDING = {
	["up.state2.item1"] = "item21",
	["up.state1.item9"] = "item9",
	["up.state1.item10"] = "item10",
	["down.sel"] = "sel",
	roleItem = "roleItem",
	["up.state2.item9"] = "item29",
	["up.state2.item8"] = "item28",
	item = "item",
	["up.state2.item3"] = "item23",
	["up.state1.item2"] = "item2",
	["up.state1.item1"] = "item1",
	["down.textTip"] = "textTip",
	["up.state2.item2"] = "item22",
	["up.state2.item10"] = "item210",
	["up.state1.item3"] = "item3",
	["up.state1.item4"] = "item4",
	up = "up",
	imgStar = "imgStar",
	["up.state1.item6"] = "item6",
	["up.state2.item7"] = "item27",
	["up.state1.item5"] = "item5",
	["up.state2.item5"] = "item25",
	["up.state1.item7"] = "item7",
	["up.state2.item6"] = "item26",
	["up.state2.item4"] = "item24",
	["up.state1.item8"] = "item8",
	down = {
		binds = {
			event = "visible",
			idler = bindHelper.self("round"),
			method = function(arg_2_0)
				return arg_2_0 == "signup"
			end
		}
	},
	startDown = {
		binds = {
			event = "visible",
			idler = bindHelper.self("round"),
			method = function(arg_3_0)
				return arg_3_0 ~= "signup"
			end
		}
	},
	["startDown.btnSave"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSave")
			}
		}
	},
	["startDown.btnCancle"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["down.selTime"] = {
		varname = "selTime",
		binds = {
			event = "extend",
			class = "sort_menus",
			props = {
				expandUp = true,
				data = bindHelper.self("sortDatas"),
				btnClick = bindHelper.self("onSortMenusBtnClick", true),
				onNode = function(arg_4_0)
					arg_4_0:xy(-1000, -485):z(2)
				end
			}
		}
	},
	["down.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 11,
				data = bindHelper.self("allCardDatas"),
				item = bindHelper.self("roleItem"),
				emptyTxt = bindHelper.self("textTip"),
				dataFilterGen = bindHelper.self("onFilterCards", true),
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = arg_5_3.battle > 0 and 1 or 0

					if arg_5_3.inMeteor then
						var_5_0 = 1
					end

					arg_5_1:setName("item" .. arg_5_0:getIdx(arg_5_2))

					local var_5_1 = arg_5_1:size()

					bind.extend(arg_5_0, arg_5_1, {
						class = "card_icon",
						props = {
							unitId = arg_5_3.unitId,
							advance = arg_5_3.advance,
							rarity = arg_5_3.rarity,
							star = arg_5_3.star,
							grayState = var_5_0,
							levelProps = {
								data = arg_5_3.level
							},
							onNode = function(arg_6_0)
								arg_6_0:xy(-4, -4)
							end
						}
					})

					local var_5_2 = arg_5_1:get("textNote")

					var_5_2:visible(arg_5_3.battle == 1)

					if arg_5_3.inMeteor then
						var_5_2.text(var_5_2, gLanguageCsv.inMeteorites)
						var_5_2.show(var_5_2)
					end

					uiEasy.addTextEffect1(var_5_2)
					arg_5_1:onTouch(functools.partial(arg_5_0.clickCell, arg_5_0, arg_5_1, arg_5_2, arg_5_3))
				end,
				onBeforeBuild = function(arg_7_0)
					arg_7_0.emptyTxt:hide()
				end,
				onAfterBuild = function(arg_8_0)
					if #itertools.values(arg_8_0.data) == 0 then
						arg_8_0.emptyTxt:show()
					else
						arg_8_0.emptyTxt:hide()
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onCardItemTouch")
			}
		}
	},
	["up.state1"] = {
		varname = "state1",
		binds = {
			event = "visible",
			idler = bindHelper.self("curState"),
			method = function(arg_9_0)
				return arg_9_0 ~= var_0_6.final
			end
		}
	},
	["up.state2"] = {
		varname = "state2",
		binds = {
			event = "visible",
			idler = bindHelper.self("curState"),
			method = function(arg_10_0)
				return arg_10_0 == var_0_6.final
			end
		}
	},
	["up.spe"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("hasSpecial")
		}
	},
	["up.spe.list"] = {
		varname = "speList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
					for iter_11_0 = 1, 2 do
						arg_11_1:get("imgIcon" .. iter_11_0):hide()
					end

					local var_11_0 = 0

					for iter_11_1, iter_11_2 in ipairs(arg_11_3.natureTypes) do
						arg_11_1:get("imgIcon" .. iter_11_1):texture(ui.ATTR_ICON[iter_11_2])
						arg_11_1:get("imgIcon" .. iter_11_1):show()

						var_11_0 = var_11_0 + 1
					end

					local var_11_1 = game.ATTRDEF_TABLE[arg_11_3.attrType]
					local var_11_2 = "attr" .. string.caption(var_11_1)

					arg_11_1:get("textName"):text(gLanguageCsv[var_11_2])

					local var_11_3 = dataEasy.getAttrValueString(arg_11_3.attrType, arg_11_3.attrNum)

					arg_11_1:get("textVal"):text("+" .. var_11_3)
					text.addEffect(arg_11_1:get("textName"), {
						outline = {
							size = 3,
							color = ui.NEWCOLORS.OUTLINE.BLACK
						}
					})
					text.addEffect(arg_11_1:get("textVal"), {
						outline = {
							size = 3,
							color = ui.NEWCOLORS.OUTLINE.BLACK
						}
					})

					local var_11_4 = var_11_0 == 1 and arg_11_1:get("imgIcon1") or arg_11_1:get("imgIcon2")

					adapt.oneLinePos(var_11_4, {
						arg_11_1:get("textName"),
						arg_11_1:get("textVal")
					}, cc.p(10, 0))
				end
			}
		}
	},
	["up.textTimeNote"] = {
		varname = "textTimeNote",
		binds = {
			{
				event = "text",
				idler = bindHelper.self("stateTextNote")
			},
			{
				event = "visible",
				idler = bindHelper.self("info"),
				method = function(arg_12_0)
					return not arg_12_0.isout
				end
			}
		}
	},
	["up.textTime"] = {
		varname = "textTime",
		binds = {
			{
				event = "text",
				idler = bindHelper.self("timeNote"),
				method = function(arg_13_0)
					if not arg_13_0 then
						return ""
					end

					return time.getCutDown(arg_13_0).short_clock_str
				end
			},
			{
				event = "visible",
				idler = bindHelper.self("info"),
				method = function(arg_14_0)
					return not arg_14_0.isout
				end
			}
		}
	},
	["down.btnOneKeySet"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("oneKeyEmbattleBtn")
			}
		}
	},
	["down.btnSave"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSave")
			}
		}
	},
	["down.btnSave.textNote"] = {
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
	["down.btnOneKeySet.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["startDown.btnSave.textNote"] = {
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
	["startDown.btnCancle.textNote"] = {
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
	["down.textNum"] = {
		binds = {
			{
				event = "text",
				idler = bindHelper.self("roleNum")
			},
			{
				event = "effect",
				data = {
					outline = {
						size = 3,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	},
	["down.textTip1"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["down.textTip2"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["down.textNote1"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_15_0)
	gGameUI.topuiManager:createView("title", arg_15_0, {
		onClose = arg_15_0:createHandler("onClose")
	}):init({
		subTitle = "FORMATION",
		title = "common/txt/txt_bt_wodeduiwu.png"
	})
	arg_15_0:enableSchedule()

	local var_15_0 = arg_15_0:convertToWorldSpace(cc.p(arg_15_0.up:x(), arg_15_0.up:y()))

	arg_15_0.offsetX = arg_15_0.up:x() - var_15_0.x
	arg_15_0.offsetY = arg_15_0.up:y() - var_15_0.y

	arg_15_0:initHeroSprite()

	arg_15_0.isChanged = false
	arg_15_0.baseDatas = {}
	arg_15_0.showDatas = idlertable.new({})

	arg_15_0:initModel()

	arg_15_0.roleNum = idler.new("")
	arg_15_0.timeNote = idler.new()
	arg_15_0.attrDatas = idlers.newWithMap({})
	arg_15_0.hasSpecial = idler.new(false)

	local var_15_1 = csv.craft.buffs
	local var_15_2 = {}
	local var_15_3 = 0

	for iter_15_0, iter_15_1 in ipairs(arg_15_0.buffs) do
		var_15_3 = var_15_3 + 1

		local var_15_4 = {}
		local var_15_5 = var_15_1[iter_15_1]

		if var_15_5 ~= nil then
			var_15_4.natureTypes = var_15_5.natureTypes
			var_15_4.attrType = var_15_5.attrType
			var_15_4.attrNum = var_15_5.attrNum

			table.insert(var_15_2, var_15_4)
		end
	end

	arg_15_0.attrDatas:update(var_15_2)
	arg_15_0.hasSpecial:set(var_15_3 > 0)

	arg_15_0.sortDatas = idlertable.new(arraytools.map(var_0_2, function(arg_16_0, arg_16_1)
		return arg_16_1.name
	end))
	arg_15_0.allCardDatas = idlers.newWithMap({})

	local var_15_6 = dataEasy.getInMeteorCardsHash()

	idlereasy.when(arg_15_0.cards, function(arg_17_0, arg_17_1)
		local var_17_0 = arg_15_0.showDatas:read()
		local var_17_1 = itertools.map(var_17_0, function(arg_18_0, arg_18_1)
			return arg_18_1.dbId, arg_18_0
		end)
		local var_17_2 = {}

		for iter_17_0, iter_17_1 in ipairs(arg_17_1) do
			local var_17_3 = gGameModel.cards:find(iter_17_1):multigetIdler("card_id", "skin_id", "fighting_point", "level", "star", "advance", "created_time")

			idlereasy.any(var_17_3, function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7)
				local var_19_0 = csv.cards[arg_19_1]
				local var_19_1 = csv.unit[var_19_0.unitID]
				local var_19_2 = dataEasy.getUnitId(arg_19_1, arg_19_2)
				local var_19_3 = var_17_1[iter_17_1] and 1 or 2

				var_17_2[iter_17_1] = {
					id = arg_19_1,
					unitId = var_19_2,
					rarity = var_19_1.rarity,
					attr1 = var_19_1.natureType,
					attr2 = var_19_1.natureType2,
					fight = arg_19_3,
					level = arg_19_4,
					star = arg_19_5,
					getTime = arg_19_7,
					dbid = iter_17_1,
					advance = arg_19_6,
					battle = var_19_3,
					atkType = var_19_0.atkType,
					inMeteor = var_15_6[iter_17_1]
				}

				dataEasy.tryCallFunc(arg_15_0.list, "updatePreloadCenterIndex")
				arg_15_0.allCardDatas:update(var_17_2)
			end):anonyOnly(arg_15_0, iter_17_0)
		end
	end)

	arg_15_0.filterCondition = idlertable.new()

	local var_15_7 = arg_15_0.sel:parent():convertToWorldSpace(arg_15_0.sel:box())
	local var_15_8 = arg_15_0:convertToNodeSpace(var_15_7)

	arg_15_0.bagFilter = gGameUI:createView("city.card.bag_filter", arg_15_0.sel):init({
		cb = arg_15_0:createHandler("onBattleFilter"),
		others = {
			panelOrder = true,
			height = 122,
			width = 190,
			x = gGameUI:getConvertPos(arg_15_0.sel, arg_15_0:getResourceNode())
		}
	}):z(19):xy(-var_15_8.x + 55, -var_15_8.y + 18)

	arg_15_0.sel:z(5)

	arg_15_0.seletSortKey = idler.new(1)
	arg_15_0.tabOrder = idler.new(true)

	idlereasy.any({
		arg_15_0.filterCondition,
		arg_15_0.seletSortKey,
		arg_15_0.tabOrder
	}, function()
		dataEasy.tryCallFunc(arg_15_0.list, "filterSortItems", false)
	end)

	arg_15_0.curState = idler.new(var_0_6.signup)
	arg_15_0.stateTextNote = idler.new(gLanguageCsv.stateFighting .. ":")

	arg_15_0.textTimeNote:text(gLanguageCsv.stateFighting .. ":")
	adapt.oneLinePos(arg_15_0.textTimeNote, arg_15_0.textTime)

	arg_15_0.refresh = idler.new(false)

	idlereasy.any({
		arg_15_0.round,
		arg_15_0.stateTime,
		arg_15_0.info,
		arg_15_0.refresh
	}, function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
		if arg_21_1 == "over" or arg_21_1 == "closed" then
			arg_15_0:unScheduleAll()
			performWithDelay(arg_15_0, function()
				var_0_0.onClose(arg_15_0)
				gGameUI:showTip(gLanguageCsv.todayBattleOver)
			end, 0)

			return
		end

		local var_21_0
		local var_21_1 = ""

		if arg_21_1 == "signup" then
			var_21_0 = var_0_6.signup
			var_21_1 = gLanguageCsv.isSIgnUping
			var_0_3 = -1
		elseif arg_21_1 == "prepare" then
			var_0_3 = -1
			var_21_0 = var_0_6.prepare
			var_21_1 = gLanguageCsv.isReading
		elseif string.find(arg_21_1, "^pre%d") then
			var_21_0 = var_0_6.pre
			var_21_1 = gLanguageCsv.stateFighting

			if not string.find(arg_21_1, "_lock") then
				var_21_1 = gLanguageCsv.stateReady
				var_0_3 = -1
			end
		elseif string.find(arg_21_1, "final") then
			arg_15_0:changeHeroPos()

			var_21_0 = var_0_6.final
			var_21_1 = gLanguageCsv.stateFighting

			if not string.find(arg_21_1, "_lock") then
				var_21_1 = gLanguageCsv.stateReady
				var_0_3 = -1
			end
		end

		arg_15_0.stateTextNote:set(var_21_1 .. ":")
		arg_15_0.textTimeNote:text(var_21_1 .. ":")
		adapt.oneLinePos(arg_15_0.textTimeNote, arg_15_0.textTime)

		if var_21_0 == var_0_6.final and arg_21_3.isout then
			arg_15_0:onClose()

			return
		end

		arg_15_0.curState:set(var_21_0, true)
	end)
	idlereasy.any({
		arg_15_0.showDatas,
		arg_15_0.curState,
		arg_15_0.info
	}, function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
		local var_23_0 = 0

		for iter_23_0 = 1, var_0_8 do
			if arg_23_1[iter_23_0] then
				var_23_0 = var_23_0 + 1

				arg_15_0:upHero(arg_23_1[iter_23_0].dbId, false, iter_23_0)
			end
		end

		arg_15_0.roleNum:set(string.format("%s/%s", var_23_0, var_0_8))
	end)

	local var_15_9 = 0

	local function var_15_10()
		if time.getTime() - var_15_9 > var_0_4 then
			var_15_9 = time.getTime()

			gGameApp:requestServer("/game/craft/battle/main", function()
				if arg_15_0.refresh then
					arg_15_0.refresh:set(not arg_15_0.refresh:read())
				end
			end)

			return true
		end
	end

	local function var_15_11(arg_26_0)
		local var_26_0 = arg_15_0.round:read()

		if var_26_0 ~= "signup" and var_26_0 ~= "prepare" then
			if arg_26_0 <= 60 and not string.find(var_26_0, "_lock") then
				if var_0_3 < 0 then
					var_0_3 = 10

					gGameApp:requestServer("/game/craft/battle/main", function()
						if arg_15_0.refresh then
							arg_15_0.refresh:set(not arg_15_0.refresh:read())
						end
					end)
				else
					var_0_3 = var_0_3 - 1
				end
			end

			if arg_26_0 > 60 then
				arg_26_0 = arg_26_0 - 60
			end
		end

		arg_15_0.timeNote:set(arg_26_0)
	end

	var_15_11(arg_15_0:getTime())
	arg_15_0:schedule(function()
		local var_28_0 = arg_15_0.round:read()

		if var_28_0 == "over" or var_28_0 == "closed" then
			return false
		end

		local var_28_1 = arg_15_0:getTime()

		if var_28_1 < 0 then
			var_15_10()
		else
			var_15_11(var_28_1)
		end
	end, 1, 0)
end

function var_0_1.changeHeroPos(arg_29_0)
	if arg_29_0.isChanged then
		return
	end

	arg_29_0.showDatas:modify(function(arg_30_0)
		for iter_30_0 = 1, 3 do
			arg_30_0[iter_30_0], arg_30_0[6 + iter_30_0] = arg_30_0[6 + iter_30_0], arg_30_0[iter_30_0]
		end

		arg_29_0.baseDatas = clone(arg_30_0)

		return true, arg_30_0
	end)

	arg_29_0.isChanged = true
end

function var_0_1.initModel(arg_31_0)
	local var_31_0 = gGameModel.craft

	arg_31_0.round = var_31_0:getIdler("round")
	arg_31_0.perRound = arg_31_0.round:read()
	arg_31_0.stateTime = var_31_0:getIdler("time")
	arg_31_0.cards = gGameModel.role:getIdler("cards")
	arg_31_0.info = var_31_0:getIdler("info")
	arg_31_0.cardAttrs = arg_31_0.info:read().card_attrs
	arg_31_0.history = var_31_0:getIdler("history")
	arg_31_0.buffs = var_31_0:read("buffs")
	arg_31_0.isSignup = gGameModel.daily_record:read("craft_sign_up")

	local var_31_1 = {}
	local var_31_2 = 0
	local var_31_3 = arg_31_0.info:read().cards
	local var_31_4 = arraytools.hash(var_31_3)
	local var_31_5 = {}

	for iter_31_0, iter_31_1 in pairs(arg_31_0.cardAttrs) do
		if var_31_4[iter_31_0] then
			var_31_5[iter_31_0] = iter_31_1
		end
	end

	arg_31_0.cardAttrs = var_31_5

	for iter_31_2 = 1, 10 do
		local var_31_6 = var_31_3[iter_31_2]

		if var_31_6 then
			var_31_2 = var_31_2 + 1

			local var_31_7 = arg_31_0.cardAttrs[var_31_6]
			local var_31_8

			if not var_31_7 then
				var_31_7 = gGameModel.cards:find(var_31_6)
				var_31_8 = var_31_7:read("card_id")
			else
				var_31_8 = var_31_7.card_id
			end

			local var_31_9 = csv.cards[var_31_8]

			var_31_1[var_31_2] = {
				dbId = var_31_6,
				markId = var_31_9.cardMarkID
			}
		end
	end

	arg_31_0.baseDatas = clone(var_31_1)

	arg_31_0.showDatas:set(var_31_1)
end

function var_0_1.isInBattle(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0.round:read()
	local var_32_1 = string.find(var_32_0, "final")
	local var_32_2 = string.find(var_32_0, "^pre%d+")
	local var_32_3, var_32_4, var_32_5 = string.find(var_32_0, "(%d+)")
	local var_32_6 = tonumber(var_32_5)
	local var_32_7 = false

	if var_32_6 then
		if var_32_2 then
			if arg_32_1 < var_32_6 then
				var_32_7 = true
			elseif arg_32_1 == var_32_6 then
				var_32_7 = arg_32_0:getTime() <= 60
			end
		elseif var_32_1 then
			local var_32_8 = math.ceil(arg_32_1 / 3)

			if var_32_8 == 1 then
				var_32_8 = 3
			elseif var_32_8 == 3 then
				var_32_8 = 1
			end

			if var_32_8 < var_32_6 then
				var_32_7 = true
			elseif var_32_8 == var_32_6 then
				var_32_7 = arg_32_0:getTime() <= 60
			end
		end
	end

	return var_32_7
end

function var_0_1.initHeroSprite(arg_33_0)
	for iter_33_0 = 1, var_0_8 do
		local var_33_0
		local var_33_1

		local function var_33_2(arg_34_0)
			if arg_33_0:isInBattle(iter_33_0) then
				return
			end

			if arg_34_0.name == "began" then
				var_33_0 = arg_34_0.target:getTouchBeganPosition()
			elseif arg_34_0.name == "moved" then
				local var_34_0 = arg_34_0.target:getTouchMovePosition()
				local var_34_1 = math.abs(var_34_0.x - var_33_0.x)
				local var_34_2 = math.abs(var_34_0.y - var_33_0.y)

				if (var_34_1 >= ui.TOUCH_MOVED_THRESHOLD or var_34_2 >= ui.TOUCH_MOVED_THRESHOLD) and not var_33_1 then
					var_33_1 = arg_34_0.target:clone():addTo(arg_33_0, 1000, "cloneRoleItem" .. iter_33_0)

					local var_34_3 = arg_33_0.showDatas:read()[iter_33_0].dbId
					local var_34_4 = arg_33_0.cardAttrs[var_34_3]
					local var_34_5
					local var_34_6
					local var_34_7

					if not var_34_4 then
						var_34_4 = gGameModel.cards:find(var_34_3)
						var_34_5 = var_34_4:read("card_id")
						var_34_7 = var_34_4:read("skin_id")
						var_34_6 = var_34_4:read("advance")
					else
						var_34_5 = var_34_4.card_id
						var_34_7 = var_34_4.skin_id
						var_34_6 = var_34_4.advance
					end

					local var_34_8 = csv.unit[csv.cards[var_34_5].unitID].rarity
					local var_34_9 = dataEasy.getUnitId(var_34_5, var_34_7)

					bind.extend(arg_33_0, var_33_1, {
						class = "card_icon",
						props = {
							unitId = var_34_9,
							rarity = var_34_8,
							advance = var_34_6
						}
					})
				end

				if var_33_1 then
					var_33_1:xy(var_34_0.x + arg_33_0.offsetX, var_34_0.y + arg_33_0.offsetY)
				end
			elseif arg_34_0.name == "ended" or arg_34_0.name == "cancelled" then
				if var_33_1 then
					if arg_34_0.y < 340 and arg_33_0.round:read() == "signup" then
						arg_33_0:downHero(arg_33_0.showDatas:read()[iter_33_0].dbId, true, iter_33_0)
					else
						local var_34_10 = arg_33_0:whichEmbattleTargetPos(arg_34_0.target:getTouchEndPosition())
						local var_34_11 = arg_33_0.info:read().isout

						if var_34_10 and not var_34_11 then
							arg_33_0:changeHero(iter_33_0, var_34_10)
						elseif var_34_10 and var_34_11 then
							gGameUI:showTip(gLanguageCsv.isOutCantResetBattle)
						end
					end

					var_33_1:removeFromParent()

					var_33_1 = nil
				elseif arg_33_0.showDatas:read()[iter_33_0] and arg_33_0.round:read() == "signup" then
					arg_33_0:downHero(arg_33_0.showDatas:read()[iter_33_0].dbId, true, iter_33_0)
				end
			end
		end

		arg_33_0["item" .. iter_33_0]:get("head"):onTouch(var_33_2)
		arg_33_0["item2" .. iter_33_0]:get("head"):onTouch(var_33_2)
	end
end

function var_0_1.onSortMenusBtnClick(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5)
	if arg_35_5 == arg_35_3 then
		arg_35_0.tabOrder:modify(function(arg_36_0)
			return true, not arg_36_0
		end)
	else
		arg_35_0.tabOrder:set(true)
	end

	arg_35_0.seletSortKey:set(arg_35_3)
end

function var_0_1.hasCommonCard(arg_37_0, arg_37_1)
	local var_37_0 = csv.cards[arg_37_1.id].cardMarkID

	for iter_37_0, iter_37_1 in arg_37_0.showDatas:pairs() do
		if iter_37_1.markId == var_37_0 then
			return iter_37_0
		end
	end

	return false
end

function var_0_1.isInShowData(arg_38_0, arg_38_1)
	for iter_38_0, iter_38_1 in arg_38_0.showDatas:pairs() do
		if iter_38_1.dbId == markId then
			return true
		end
	end

	return false
end

function var_0_1.getIdxByDbId(arg_39_0, arg_39_1)
	if not arg_39_1 then
		return
	end

	for iter_39_0, iter_39_1 in arg_39_0.showDatas:pairs() do
		if arg_39_1 == iter_39_1.dbId then
			return iter_39_0
		end
	end
end

function var_0_1.changeHero(arg_40_0, arg_40_1, arg_40_2)
	if not arg_40_1 or not arg_40_2 or arg_40_1 == arg_40_2 then
		return
	end

	local var_40_0 = arg_40_0.showDatas:read()[arg_40_1]
	local var_40_1 = arg_40_0.showDatas:read()[arg_40_2]

	if not var_40_0 and not var_40_1 then
		return
	end

	if not var_40_0 then
		arg_40_0:downHero(var_40_1.dbId, false, arg_40_2)
		arg_40_0:upHero(var_40_1.dbId, false, arg_40_1)
	elseif not var_40_1 then
		arg_40_0:downHero(var_40_0.dbId, false, arg_40_1)
		arg_40_0:upHero(var_40_0.dbId, false, arg_40_2)
	else
		arg_40_0:downHero(var_40_0.dbId, false, arg_40_1)
		arg_40_0:downHero(var_40_1.dbId, false, arg_40_2)
		arg_40_0:upHero(var_40_0.dbId, false, arg_40_2)
		arg_40_0:upHero(var_40_1.dbId, false, arg_40_1)
	end
end

function var_0_1.downHero(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	if arg_41_1 then
		if arg_41_0.allCardDatas:atproxy(arg_41_1) then
			arg_41_0.allCardDatas:atproxy(arg_41_1).battle = 2
		end

		arg_41_3 = arg_41_3 or arg_41_0:getIdxByDbId(arg_41_1)

		if arg_41_3 then
			arg_41_0.showDatas:modify(function(arg_42_0)
				local var_42_0 = arg_42_0[arg_41_3] ~= nil

				arg_42_0[arg_41_3] = nil

				return var_42_0, arg_42_0
			end)
		end
	end

	if not arg_41_3 then
		return
	end

	local var_41_0 = arg_41_0.curState:read()
	local var_41_1 = var_41_0 == var_0_6.final and arg_41_0["item2" .. arg_41_3] or arg_41_0["item" .. arg_41_3]
	local var_41_2 = var_41_1:multiget("head", "textLv", "textNote", "textFightPoint", "imgAttr1", "imgAttr2")

	itertools.invoke(var_41_2, "hide")

	if var_41_0 ~= var_0_6.final then
		var_41_1:get("btnAdd"):show()
		var_41_1:get("imgState"):hide()
		var_41_1:get("imgFlag"):hide()
	end

	for iter_41_0 = 1, math.huge do
		local var_41_3 = var_41_1:getChildByName("star" .. iter_41_0)

		if not var_41_3 then
			break
		end

		var_41_3:removeFromParent()
	end

	arg_41_0.roleNum:set(string.format("%s/%s", arg_41_0.showDatas:size(), var_0_8))

	if arg_41_2 then
		gGameUI:showTip(gLanguageCsv.downToEmbattle)
	end
end

function var_0_1.upHero(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	local var_43_0

	for iter_43_0 = 1, var_0_8 do
		if arg_43_3 then
			var_43_0 = arg_43_3

			break
		end

		if not arg_43_0.showDatas:read()[iter_43_0] then
			var_43_0 = iter_43_0

			break
		end
	end

	arg_43_3 = var_43_0

	if not arg_43_3 then
		return
	end

	local var_43_1 = arg_43_0.cardAttrs[arg_43_1]
	local var_43_2
	local var_43_3
	local var_43_4
	local var_43_5
	local var_43_6
	local var_43_7

	if not var_43_1 then
		var_43_1 = gGameModel.cards:find(arg_43_1)
		var_43_2 = var_43_1:read("card_id")
		var_43_3 = var_43_1:read("skin_id")
		var_43_4 = var_43_1:read("advance")
		var_43_5 = var_43_1:read("level")
		var_43_6 = var_43_1:read("fighting_point")
		var_43_7 = var_43_1:read("star")
	else
		var_43_2 = var_43_1.card_id
		var_43_3 = var_43_1.skin_id
		var_43_4 = var_43_1.advance
		var_43_5 = var_43_1.level
		var_43_6 = var_43_1.fighting_point
		var_43_7 = var_43_1.star
	end

	local var_43_8 = csv.cards[var_43_2]

	arg_43_0.showDatas:modify(function(arg_44_0)
		local var_44_0 = false
		local var_44_1 = arg_44_0[arg_43_3]

		if var_44_1 == nil or var_44_1.dbId ~= arg_43_1 then
			var_44_0 = true
			arg_44_0[arg_43_3] = {
				dbId = arg_43_1,
				markId = var_43_8.cardMarkID
			}
		end

		return var_44_0, arg_44_0
	end)

	if arg_43_0.allCardDatas:atproxy(arg_43_1) then
		arg_43_0.allCardDatas:atproxy(arg_43_1).battle = 1
	end

	local var_43_9 = arg_43_0.curState:read()
	local var_43_10 = var_43_9 == var_0_6.final and arg_43_0["item2" .. arg_43_3] or arg_43_0["item" .. arg_43_3]
	local var_43_11 = var_43_10:multiget("head", "textLv", "textNote", "textFightPoint", "imgAttr1", "imgAttr2")

	itertools.invoke(var_43_11, "show")

	if var_43_9 ~= var_0_6.final then
		var_43_10:get("btnAdd"):hide()
		var_43_10:get("imgState"):hide()
		var_43_10:get("imgFlag"):hide()
	end

	if var_43_9 == var_0_6.pre then
		local var_43_12 = var_0_8

		for iter_43_1 = 1, var_0_8 do
			local var_43_13 = arg_43_0.history:read()[iter_43_1]

			if not var_43_13 or arg_43_0:isCurBattle(var_43_13.round) then
				var_43_12 = iter_43_1

				break
			end

			local var_43_14 = var_43_13.result == "win" and "city/pvp/craft/icon_win.png" or "city/pvp/craft/icon_lose.png"
			local var_43_15 = var_43_9 == var_0_6.final and arg_43_0["item2" .. iter_43_1] or arg_43_0["item" .. iter_43_1]

			var_43_15:get("imgFlag"):texture(var_43_14)
			var_43_15:get("imgFlag"):show()
			var_43_15:removeChildByName("stateEffect")
		end

		for iter_43_2 = var_43_12, var_0_8 do
			arg_43_0["item" .. iter_43_2]:get("imgFlag"):hide()
			arg_43_0["item" .. iter_43_2]:get("imgState"):hide()
		end

		local var_43_16 = arg_43_0:getTime()
		local var_43_17 = arg_43_0["item" .. var_43_12]

		if var_43_17 and not arg_43_0.info:read().isout then
			var_43_17:removeChildByName("stateEffect")

			if var_43_16 > 60 then
				widget.addAnimationByKey(var_43_17, "kuafushiying/wz.skel", "stateEffect", "effect_bzz_loop", 10):scale(0.8):xy(var_43_17:size().width / 2 - 30, var_43_17:size().height - 130)
			else
				widget.addAnimationByKey(var_43_17, "kuafushiying/wz.skel", "stateEffect", "effect_zdz_loop", 10):scale(0.8):xy(var_43_17:size().width / 2 - 30, var_43_17:size().height - 130)
			end
		end
	elseif var_43_9 == var_0_6.final then
		local var_43_18 = arg_43_0.info:read().isout
		local var_43_19 = "city/pvp/craft/box_bs.png"

		if var_43_18 then
			local var_43_20
			local var_43_21

			for iter_43_3 = 1, 3 do
				local var_43_22 = arg_43_0.history:read()[10 + iter_43_3]
				local var_43_23

				if var_43_22 and var_43_22.result then
					var_43_19 = "city/pvp/craft/box_jj.png"
					var_43_20 = var_43_22.result == "win" and gLanguageCsv.jinji or gLanguageCsv.luobai
					var_43_23 = "normal"
				else
					var_43_20 = gLanguageCsv.notjinji
					var_43_19 = "city/pvp/craft/box_bs.png"
					var_43_23 = "hsl_gray"
				end

				arg_43_0.state2:get("state" .. iter_43_3):get("textNote"):text(var_43_20)
				arg_43_0.state2:get("state" .. iter_43_3):get("imgBg"):texture(var_43_19)
				arg_43_0.state2:get("state" .. iter_43_3):show()
				cache.setShader(arg_43_0.state2:get("state" .. iter_43_3), false, var_43_23)
			end
		else
			local var_43_24 = arg_43_0.round:read()
			local var_43_25 = tonumber(string.sub(var_43_24, string.find(var_43_24, "%d+")))

			for iter_43_4 = 1, var_43_25 do
				local var_43_26 = gLanguageCsv.beisai
				local var_43_27 = "city/pvp/craft/box_bs.png"
				local var_43_28 = arg_43_0:getTime()
				local var_43_29 = "normal"

				if iter_43_4 == var_43_25 and var_43_28 <= 60 then
					var_43_26 = gLanguageCsv.zhandou
				elseif iter_43_4 < var_43_25 then
					local var_43_30 = arg_43_0.history:read()[10 + iter_43_4]

					if var_43_30 and var_43_30.result then
						var_43_27 = "city/pvp/craft/box_jj.png"

						if var_43_30.result == "win" then
							var_43_26 = gLanguageCsv.jinji
							var_43_29 = "normal"
						else
							var_43_26 = gLanguageCsv.luobai
							var_43_29 = "hsl_gray"
						end
					end
				end

				arg_43_0.state2:get("state" .. iter_43_4):get("textNote"):text(var_43_26)
				arg_43_0.state2:get("state" .. iter_43_4):get("imgBg"):texture(var_43_27)
				arg_43_0.state2:get("state" .. iter_43_4):show()
				cache.setShader(arg_43_0.state2:get("state" .. iter_43_4), false, var_43_29)

				if iter_43_4 == 3 then
					local var_43_31 = arg_43_0.history:read()[12]
					local var_43_32 = "city/pvp/craft/myteam/txt_gjs.png"

					if var_43_31 and var_43_31.result == "fail" then
						var_43_32 = "city/pvp/craft/myteam/txt_jjs.png"
					end

					arg_43_0.state2:get("img3"):texture(var_43_32)
				end
			end

			for iter_43_5 = var_43_25 + 1, 3 do
				arg_43_0.state2:get("state" .. iter_43_5):hide()
				cache.setShader(arg_43_0.state2:get("state" .. iter_43_5), false, "normal")
			end
		end
	end

	local var_43_33 = csv.unit[var_43_8.unitID]
	local var_43_34 = var_43_33.rarity
	local var_43_35 = dataEasy.getUnitId(var_43_2, var_43_3)

	bind.extend(arg_43_0, var_43_11.head, {
		class = "card_icon",
		props = {
			unitId = var_43_35,
			rarity = var_43_34,
			advance = var_43_4
		}
	})

	local var_43_36 = var_43_33.natureType

	var_43_11.imgAttr1:texture(ui.ATTR_ICON[var_43_36])

	local var_43_37 = csv.unit[var_43_8.unitID].natureType2

	if var_43_37 then
		var_43_11.imgAttr2:texture(ui.ATTR_ICON[var_43_37])
	else
		var_43_11.imgAttr2:hide()
	end

	var_43_11.textLv:text("Lv" .. var_43_5)
	var_43_11.textFightPoint:text(var_43_6)
	adapt.oneLinePos(var_43_11.textLv, {
		var_43_11.imgAttr1,
		var_43_11.imgAttr2
	}, cc.p(5, 0))

	if var_43_9 ~= var_0_6.final then
		adapt.oneLineCenterPos(cc.p(160, 40), {
			var_43_11.textNote,
			var_43_11.textFightPoint
		}, cc.p(10, 0))
	end

	for iter_43_6 = 1, math.huge do
		local var_43_38 = var_43_10:getChildByName("star" .. iter_43_6)

		if not var_43_38 then
			break
		end

		var_43_38:removeFromParent()
	end

	for iter_43_7 = 1, var_43_7 do
		if iter_43_7 < 7 then
			local var_43_39 = math.min(var_43_7, 6)
			local var_43_40 = var_43_9 == var_0_6.final and cc.p(232 + (iter_43_7 - 1) * 40, 104) or cc.p(165 - 15 * (var_43_39 + 1 - 2 * iter_43_7), 85)
			local var_43_41 = arg_43_0.imgStar:clone():xy(var_43_40):show():addTo(var_43_10, 10, "star" .. iter_43_7):scale(0.37)
		else
			local var_43_42 = "common/icon/icon_star_z.png"

			if iter_43_7 < 19 and iter_43_7 > 12 then
				var_43_42 = "common/icon/icon_star_h.png"
			elseif iter_43_7 < 25 and iter_43_7 > 18 then
				var_43_42 = "common/icon/icon_star_c.png"
			end

			local var_43_43 = iter_43_7 % 6 == 0 and 6 or iter_43_7 % 6
			local var_43_44 = var_43_10:getChildByName("star" .. var_43_43)

			if var_43_44 then
				var_43_44:texture(var_43_42):scale(0.37)
			end
		end
	end

	arg_43_0.roleNum:set(string.format("%s/%s", arg_43_0.showDatas:size(), var_0_8))

	if arg_43_2 then
		gGameUI:showTip(gLanguageCsv.addToEmbattle)
	end
end

function var_0_1.onCardItemTouch(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6)
	if arg_45_5.inMeteor then
		gGameUI:showTip(gLanguageCsv.cardInMeteorites)

		return
	end

	if arg_45_6.name == "began" then
		arg_45_0.touchBeganPos = arg_45_3:getTouchBeganPosition()

		arg_45_0.list:setTouchEnabled(false)
	elseif arg_45_6.name == "moved" then
		local var_45_0 = arg_45_3:getTouchMovePosition()
		local var_45_1 = arg_45_6
		local var_45_2 = math.abs(var_45_1.x - arg_45_0.touchBeganPos.x)
		local var_45_3 = math.abs(var_45_1.y - arg_45_0.touchBeganPos.y)

		if arg_45_0.hasMovingItem == nil and (var_45_2 >= ui.TOUCH_MOVED_THRESHOLD or var_45_3 >= ui.TOUCH_MOVED_THRESHOLD) then
			arg_45_0.hasMovingItem = false

			if var_45_3 > var_45_2 * 0.7 then
				arg_45_0.hasMovingItem = true
				arg_45_0.movePanel = arg_45_0.roleItem:clone():addTo(arg_45_0, 1000, "i")

				bind.extend(arg_45_1, arg_45_0.movePanel, {
					class = "card_icon",
					props = {
						unitId = arg_45_5.unitId,
						advance = arg_45_5.advance,
						rarity = arg_45_5.rarity,
						star = arg_45_5.star,
						levelProps = {
							data = arg_45_5.level
						},
						onNode = function(arg_46_0)
							arg_46_0:xy(-4, -4)
						end
					}
				})
				arg_45_0.movePanel:show()
				arg_45_0.movePanel:get("textNote"):hide()
			end
		end

		arg_45_0.list:setTouchEnabled(not arg_45_0.hasMovingItem)

		if arg_45_0.movePanel then
			arg_45_0.movePanel:xy(var_45_0.x + arg_45_0.offsetX, var_45_0.y + arg_45_0.offsetY)
		end
	elseif arg_45_6.name == "ended" or arg_45_6.name == "cancelled" then
		local var_45_4 = arg_45_3:getTouchEndPosition()
		local var_45_5 = false
		local var_45_6 = false

		if arg_45_0.showDatas:size() >= var_0_8 then
			var_45_5 = true
		end

		if arg_45_0:hasCommonCard(arg_45_5) then
			var_45_6 = true
		end

		if arg_45_0.hasMovingItem == nil then
			if arg_45_5.battle == 1 then
				local var_45_7 = arg_45_0:getIdxByDbId(arg_45_5.dbid)

				if not arg_45_0:isInBattle(var_45_7) then
					arg_45_0:downHero(arg_45_5.dbid, true)
				end
			elseif var_45_5 then
				gGameUI:showTip(gLanguageCsv.battleCardCountEnough)
			elseif var_45_6 then
				gGameUI:showTip(gLanguageCsv.alreadyHaveSameSprite)
			else
				arg_45_0:upHero(arg_45_5.dbid, true)
			end
		end

		arg_45_0.hasMovingItem = nil

		if arg_45_0.movePanel then
			local var_45_8 = arg_45_0:whichEmbattleTargetPos(arg_45_6)

			if var_45_8 then
				arg_45_0:resetBattle(var_45_8, arg_45_5)
				audio.playEffectWithWeekBGM("formation.mp3")
			end

			arg_45_0.movePanel:removeSelf()
		end

		arg_45_0.movePanel = nil
	end
end

function var_0_1.resetBattle(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_0.showDatas:read()[arg_47_1]

	if arg_47_2.battle == 2 then
		local var_47_1 = arg_47_0:hasCommonCard(arg_47_2)

		if var_47_1 and var_47_1 ~= arg_47_1 then
			gGameUI:showTip(gLanguageCsv.alreadyHaveSameSprite)

			return
		end

		if var_47_0 then
			arg_47_0:downHero(var_47_0.dbId, false, arg_47_1)
		end

		arg_47_0:upHero(arg_47_2.dbid, true, arg_47_1)
	elseif var_47_0 then
		local var_47_2 = arg_47_0:getIdxByDbId(arg_47_2.dbid)

		arg_47_0:changeHero(arg_47_1, var_47_2)
	else
		arg_47_0:downHero(arg_47_2.dbid, false)
		arg_47_0:upHero(arg_47_2.dbid, false, arg_47_1)
	end
end

function var_0_1.oneKeyEmbattleBtn(arg_48_0)
	local var_48_0 = itertools.values(arg_48_0.allCardDatas)

	table.sort(var_48_0, function(arg_49_0, arg_49_1)
		arg_49_0, arg_49_1 = arg_49_0:read(), arg_49_1:read()

		if arg_49_0.fight == arg_49_1.fight then
			return arg_49_0.rarity > arg_49_1.rarity
		else
			return arg_49_0.fight > arg_49_1.fight
		end
	end)

	local var_48_1 = {}
	local var_48_2 = {}
	local var_48_3 = 0

	for iter_48_0, iter_48_1 in ipairs(var_48_0) do
		iter_48_1 = iter_48_1:read()

		local var_48_4 = gGameModel.cards:find(iter_48_1.dbid):read("card_id")
		local var_48_5 = csv.cards[var_48_4]

		if not var_48_1[var_48_5.cardMarkID] and not iter_48_1.inMeteor then
			var_48_3 = var_48_3 + 1
			var_48_2[var_48_3] = {
				dbId = iter_48_1.dbid,
				markId = var_48_5.cardMarkID
			}
			var_48_1[var_48_5.cardMarkID] = true

			if var_48_3 == var_0_8 then
				break
			end
		end
	end

	arg_48_0.roleNum:set(string.format("%s/%s", var_48_3, var_0_8))

	for iter_48_2, iter_48_3 in arg_48_0.showDatas:pairs() do
		arg_48_0:downHero(iter_48_3.dbId, false, iter_48_2)
	end

	arg_48_0.showDatas:set(var_48_2)
end

function var_0_1.onBattleFilter(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
	arg_50_0.filterCondition:set({
		attr1 = arg_50_1,
		attr2 = arg_50_2,
		rarity = arg_50_3,
		atkType = arg_50_4
	}, true)
end

function var_0_1.onFilterCards(arg_51_0, arg_51_1)
	local var_51_0 = arg_51_0.filterCondition:read()
	local var_51_1 = {
		{
			"rarity",
			var_51_0.rarity < ui.RARITY_LAST_VAL and var_51_0.rarity or nil
		},
		{
			"attr2",
			var_51_0.attr2 < ui.ATTR_MAX and var_51_0.attr2 or nil
		},
		{
			"attr1",
			var_51_0.attr1 < ui.ATTR_MAX and var_51_0.attr1 or nil
		},
		{
			"atkType",
			var_51_0.atkType
		}
	}

	local function var_51_2(arg_52_0, arg_52_1, arg_52_2)
		if arg_52_0[arg_52_1] == nil and (arg_52_1 ~= "attr2" or arg_52_0.attr1 == arg_52_2) then
			return true
		end

		if arg_52_1 == "atkType" then
			for iter_52_0, iter_52_1 in ipairs(arg_52_0.atkType) do
				if arg_52_2[iter_52_1] then
					return true
				end
			end

			return false
		end

		if arg_52_0[arg_52_1] == arg_52_2 then
			return true
		end

		return false
	end

	return function(arg_53_0, arg_53_1)
		for iter_53_0 = 1, #var_51_1 do
			local var_53_0 = var_51_1[iter_53_0]

			if var_53_0[2] and not var_51_2(arg_53_1, var_53_0[1], var_53_0[2]) then
				return false
			end
		end

		return true, arg_53_0
	end
end

function var_0_1.onSortCards(arg_54_0, arg_54_1)
	local var_54_0 = arg_54_0.seletSortKey:read()
	local var_54_1 = var_0_2[var_54_0].attr
	local var_54_2 = arg_54_0.tabOrder:read()

	return function(arg_55_0, arg_55_1)
		if arg_55_0.battle ~= arg_55_1.battle then
			return arg_55_0.battle < arg_55_1.battle
		end

		local var_55_0 = arg_55_0[var_54_1]
		local var_55_1 = arg_55_1[var_54_1]

		if var_55_0 ~= var_55_1 then
			if var_54_2 then
				return var_55_1 < var_55_0
			else
				return var_55_0 < var_55_1
			end
		end

		return arg_55_0.id < arg_55_1.id
	end
end

function var_0_1.whichEmbattleTargetPos(arg_56_0, arg_56_1)
	arg_56_1.x = arg_56_1.x + arg_56_0.offsetX
	arg_56_1.y = arg_56_1.y + arg_56_0.offsetY

	for iter_56_0 = 1, var_0_8 do
		local var_56_0 = arg_56_0.curState:read() == var_0_6.final and arg_56_0["item2" .. iter_56_0] or arg_56_0["item" .. iter_56_0]
		local var_56_1 = var_56_0:box()
		local var_56_2, var_56_3 = var_56_0:xy()
		local var_56_4 = arg_56_0.up:convertToWorldSpace(cc.p(var_56_2, var_56_3))
		local var_56_5 = arg_56_0:convertToNodeSpace(var_56_4)

		var_56_1.x = var_56_5.x - var_56_1.width / 2
		var_56_1.y = var_56_5.y - var_56_1.height / 2

		local var_56_6 = arg_56_0:isInBattle(iter_56_0)

		if cc.rectContainsPoint(var_56_1, arg_56_1) and not var_56_6 then
			return iter_56_0
		end
	end
end

function var_0_1.onSave(arg_57_0)
	if arg_57_0.showDatas:size() < var_0_8 then
		gGameUI:showTip(gLanguageCsv.numNotEnough)

		return
	end

	local var_57_0, var_57_1 = arg_57_0:checkBattlerPos()

	if var_57_1 then
		return
	end

	local var_57_2 = {}
	local var_57_3 = arg_57_0.showDatas:read()

	if arg_57_0.isChanged then
		var_57_3 = table.deepcopy(var_57_3, true)

		for iter_57_0 = 1, 3 do
			var_57_3[iter_57_0], var_57_3[6 + iter_57_0] = var_57_3[6 + iter_57_0], var_57_3[iter_57_0]
		end
	end

	for iter_57_1, iter_57_2 in ipairs(var_57_3) do
		table.insert(var_57_2, iter_57_2.dbId)
	end

	local var_57_4 = "/game/craft/battle/deploy"
	local var_57_5 = gLanguageCsv.battleResetSuccess

	if not arg_57_0.isSignup then
		var_57_4 = "/game/craft/signup"
		var_57_5 = gLanguageCsv.signUpSuccess
	end

	gGameApp:requestServer(var_57_4, function(arg_58_0)
		arg_57_0.showDatas:read(function(arg_59_0)
			arg_57_0.baseDatas = clone(arg_59_0)
		end)
		arg_57_0:onClose()
		gGameUI:showTip(var_57_5)
	end, var_57_2)
end

function var_0_1.getTime(arg_60_0)
	local var_60_0 = var_0_9(arg_60_0.round:read())
	local var_60_1 = time.getTime()

	return arg_60_0.stateTime:read() + var_60_0 - var_60_1
end

function var_0_1.isCurBattle(arg_61_0, arg_61_1)
	local var_61_0 = arg_61_0.round:read()

	if not string.find(var_61_0, "_lock") then
		return arg_61_1 == var_61_0
	else
		local var_61_1, var_61_2, var_61_3 = string.find(var_61_0, "(%d+)")
		local var_61_4, var_61_5, var_61_6 = string.find(arg_61_1, "(%d+)")

		return var_61_3 == var_61_6
	end
end

function var_0_1.isChangedCardsPos(arg_62_0)
	if arg_62_0.showDatas:size() ~= var_0_8 then
		return true
	end

	local var_62_0 = false
	local var_62_1 = {}

	for iter_62_0, iter_62_1 in arg_62_0.showDatas:pairs() do
		if iter_62_1.dbId ~= arg_62_0.baseDatas[iter_62_0].dbId then
			table.insert(var_62_1, iter_62_0)

			var_62_0 = true
		end
	end

	return var_62_0, var_62_1
end

function var_0_1.checkBattlerPos(arg_63_0)
	local var_63_0 = arg_63_0.round:read()

	if var_63_0 == "signup" or var_63_0 == "prepare" then
		return
	end

	local var_63_1, var_63_2 = arg_63_0:isChangedCardsPos()
	local var_63_3 = arg_63_0.round:read()
	local var_63_4, var_63_5, var_63_6 = string.find(var_63_3, "(%d+)")
	local var_63_7 = tonumber(var_63_6)
	local var_63_8 = false
	local var_63_9 = string.find(var_63_3, "_lock")

	if string.find(var_63_3, "pre") then
		for iter_63_0, iter_63_1 in ipairs(var_63_2) do
			if iter_63_1 < var_63_7 or var_63_9 and iter_63_1 == var_63_7 then
				var_63_8 = true

				break
			end
		end
	else
		local var_63_10 = var_63_9 and var_63_7 or var_63_7 - 1
		local var_63_11 = {}

		for iter_63_2 = 1, var_63_10 do
			for iter_63_3, iter_63_4 in ipairs(var_0_7[iter_63_2]) do
				table.insert(var_63_11, iter_63_4)
			end
		end

		for iter_63_5, iter_63_6 in ipairs(var_63_2) do
			var_63_8 = itertools.include(var_63_11, iter_63_6)

			if var_63_8 then
				break
			end
		end
	end

	if var_63_8 then
		arg_63_0.showDatas:set(arg_63_0.baseDatas)
		gGameUI:showTip(gLanguageCsv.stateChangedResetPos)

		var_63_1 = false
	end

	return var_63_1, var_63_8
end

function var_0_1.onClose(arg_64_0)
	if arg_64_0:isChangedCardsPos() then
		local var_64_0 = {
			clearFast = true,
			btnType = 2,
			cb = function()
				arg_64_0:onSave()
			end,
			cancelCb = function()
				var_0_0.onClose(arg_64_0)
			end,
			content = gLanguageCsv.isSaveCurBattle
		}

		gGameUI:showDialog(var_64_0)
	else
		var_0_0.onClose(arg_64_0)
	end
end

return var_0_1
