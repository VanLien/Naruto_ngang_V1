local var_0_0 = require("app.views.city.adventure.fishing.tools")
local var_0_1 = class("SenceSelectView", cc.load("mvc").ViewBase)
local var_0_2 = 86400

var_0_1.RESOURCE_FILENAME = "fishing_main.json"
var_0_1.RESOURCE_BINDING = {
	btn = "btnItem",
	["right.time.txt1"] = "refreshTimeTxt",
	["right.underRight.btnEnter"] = "btnEnter",
	imgBg = "imgBg",
	["right.underRight.times"] = "times",
	["right.underRight.tip"] = "tip",
	["right.scenePanel.item"] = "item",
	["right.underRight.numTip"] = "numTip",
	["right.underRight.time"] = "time",
	["right.scenePanel"] = "scenePanel",
	right = "right",
	["right.scenePanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("fishShow"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1, {
						event = "extend",
						class = "fish_icon",
						props = {
							lock = true,
							onNodeClick = true,
							data = {
								key = arg_1_3
							}
						}
					})
				end
			}
		}
	},
	["right.time.txt2"] = {
		varname = "refreshTime",
		binds = {
			event = "text",
			idler = bindHelper.self("deltaTime"),
			method = function(arg_2_0)
				return time.getCutDown(arg_2_0).str
			end
		}
	},
	["right.underLeft.btnLv"] = {
		varname = "btnLv",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnLv")
			}
		}
	},
	["right.underLeft.btnHandbook"] = {
		varname = "btnHandbook",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnHandbook")
			}
		}
	},
	["right.underLeft.btnShop"] = {
		varname = "btnShop",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnShop")
			}
		}
	},
	["right.underLeft.btnTools"] = {
		varname = "btnTools",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnTools")
			}
		}
	},
	["right.underLeft.btnRank"] = {
		varname = "btnRank",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRank")
			}
		}
	},
	["right.underRight.btnCatch"] = {
		varname = "btnCatch",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnCatch")
			}
		}
	},
	["left.listview"] = {
		varname = "btnList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				dataOrderCmp = function(arg_3_0, arg_3_1)
					if arg_3_0.sort ~= arg_3_1.sort then
						return arg_3_0.sort > arg_3_1.sort
					end

					return arg_3_0.csvId < arg_3_1.csvId
				end,
				data = bindHelper.self("btnDatas"),
				item = bindHelper.self("btnItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:get("btnNormal")
					local var_4_1 = arg_4_1:get("btnSelected")

					var_4_0:get("lock"):visible(arg_4_3.myLv < arg_4_3.needLv or arg_4_3.lock == 0)

					if arg_4_2 == game.FISHING_GAME then
						var_4_0:loadTextureNormal("city/adventure/fishing/tab_dyds.png")
						var_4_1:loadTextureNormal("city/adventure/fishing/tab_selected_dyds.png")

						if matchLanguage({
							"en"
						}) then
							adapt.setTextScaleWithWidth(var_4_0:get("textNote"), arg_4_3.name, arg_4_1:width() - 170)
							adapt.setTextScaleWithWidth(var_4_1:get("textNote"), arg_4_3.name, arg_4_1:width() - 150)
							var_4_0:get("waiting"):width(220)
							var_4_1:get("waiting"):width(220)
							var_4_0:get("waiting.txt"):x(100)
							var_4_1:get("waiting.txt"):x(100)
						end
					end

					var_4_1:visible(arg_4_3.selected)
					var_4_0:visible(not arg_4_3.selected)
					var_4_0:get("textNote"):text(arg_4_3.name)
					var_4_1:get("textNote"):text(arg_4_3.name)

					local var_4_2 = gGameModel.role:getIdler("cross_fishing_round")

					idlereasy.when(var_4_2, function(arg_5_0, arg_5_1)
						local var_5_0 = arg_4_2 == game.FISHING_GAME and arg_4_3.preTime and arg_4_3.preTime < var_0_2 or false

						var_4_1:get("waiting"):visible(var_5_0 and arg_5_1 == "closed")
						var_4_0:get("waiting"):visible(var_5_0 and arg_5_1 == "closed")
					end):anonyOnly(arg_4_0)

					if matchLanguage({
						"kr"
					}) then
						var_4_1:get("waiting"):width(200)
						var_4_0:get("waiting"):width(200)
						var_4_1:get("waiting"):x(300)
						var_4_0:get("waiting"):x(300)
						var_4_1:get("waiting.txt"):x(100)
						var_4_0:get("waiting.txt"):x(100)
					end

					bind.touch(arg_4_0, var_4_0, {
						methods = {
							ended = functools.partial(arg_4_0.clickCell, arg_4_2, arg_4_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onSelectClick")
			}
		}
	},
	["right.scenePanel.txt"] = {
		varname = "txtCommon",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["right.underLeft.btnLv.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["right.underLeft.btnHandbook.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["right.underLeft.btnShop.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["right.underLeft.btnTools.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["right.underLeft.btnRank.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_6_0)
	gGameUI.topuiManager:createView("default", arg_6_0, {
		onClose = arg_6_0:createHandler("onClose")
	}):init({
		subTitle = "FISHING",
		title = gLanguageCsv.angling
	})
	arg_6_0:enableSchedule()
	arg_6_0:initModel()
	arg_6_0:initBgMask()

	arg_6_0.oldLv = arg_6_0.fishLevel:read()

	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_6_0.scenePanel:get("bg"),
			"width"
		},
		{
			arg_6_0.mask1,
			"width"
		},
		{
			arg_6_0.list,
			"width"
		},
		{
			arg_6_0.right:get("tip.bg"),
			"width"
		},
		{
			arg_6_0.right:get("time.bg"),
			"width"
		}
	})

	arg_6_0.showTab = idler.new(arg_6_0.crossFishingRound:read() == "start" and game.FISHING_GAME or 1)
	arg_6_0.fishShow = idlers.new({})
	arg_6_0.deltaTime = idler.new(0)

	local var_6_0 = {}

	for iter_6_0, iter_6_1 in csvPairs(csv.fishing.scene) do
		var_6_0[iter_6_0] = {
			selected = false,
			myLv = 1,
			sort = 0,
			csvId = iter_6_0,
			name = iter_6_1.name,
			res = iter_6_1.res,
			typ = iter_6_1.type,
			needLv = iter_6_1.needLv,
			priview = iter_6_1.priview,
			lock = iter_6_1.lock
		}
	end

	arg_6_0.btnDatas = idlers.newWithMap(var_6_0)

	idlereasy.any({
		arg_6_0.fishLevel,
		arg_6_0.fishCounter,
		arg_6_0.targetCounter,
		arg_6_0.fishingCounter,
		arg_6_0.isAuto,
		arg_6_0.selectScene,
		arg_6_0.crossFishingRound
	}, function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7)
		arg_6_0.right:get("tip"):visible(arg_7_5)

		for iter_7_0, iter_7_1 in csvPairs(csv.fishing.scene) do
			arg_6_0.btnDatas:at(iter_7_0):modify(function(arg_8_0)
				arg_8_0.myLv = arg_7_1

				if arg_8_0.typ == 2 then
					arg_8_0.sort = arg_7_7 == "start" and 1 or 0
					arg_8_0.preTime = arg_6_0:getFishingGamePreTime()
				end
			end, true)
		end

		dataEasy.tryCallFunc(arg_6_0.btnList, "filterSortItems", true)

		arg_6_0.nowCounter = gCommonConfigCsv.fishingDailyTimes - arg_7_4

		arg_6_0.times:text(arg_6_0.nowCounter .. "/" .. gCommonConfigCsv.fishingDailyTimes)
		bind.touch(arg_6_0, arg_6_0.btnEnter, {
			methods = {
				ended = function()
					arg_6_0:onBtnEnter(arg_6_0.showTab:read(), arg_7_6)
				end
			}
		})
		arg_6_0.showTab:addListener(function(arg_10_0, arg_10_1, arg_10_2)
			local var_10_0 = arg_6_0.btnDatas:atproxy(arg_10_0)

			arg_6_0.btnDatas:atproxy(arg_10_1).selected = false
			arg_6_0.btnDatas:atproxy(arg_10_0).selected = true

			local var_10_1 = {}

			for iter_10_0, iter_10_1 in orderCsvPairs(var_10_0.priview) do
				table.insert(var_10_1, iter_10_1)
			end

			arg_6_0.fishShow:update(var_10_1)
			arg_6_0.btnEnter:setTouchEnabled(var_10_0.myLv >= var_10_0.needLv)
			arg_6_0.btnCatch:setTouchEnabled(var_10_0.myLv >= var_10_0.needLv)
			arg_6_0.tip:visible(var_10_0.myLv < var_10_0.needLv)

			if arg_10_0 == game.FISHING_GAME then
				local var_10_2 = dataEasy.isUnlock(gUnlockCsv.gameCatch)

				arg_6_0.btnCatch:visible(var_10_0.myLv >= var_10_0.needLv and var_10_2 == true)
			else
				local var_10_3 = dataEasy.isUnlock(gUnlockCsv.catch)

				arg_6_0.btnCatch:visible(var_10_0.myLv >= var_10_0.needLv and var_10_3 == true)
			end

			arg_6_0.numTip:visible(var_10_0.myLv < var_10_0.needLv)
			arg_6_0.numTip:text(var_10_0.needLv)
			adapt.oneLinePos(arg_6_0.tip, arg_6_0.numTip, cc.p(0, 0), "left")
			cache.setShader(arg_6_0.btnEnter, false, var_10_0.myLv >= var_10_0.needLv and "normal" or "hsl_gray")
			cache.setShader(arg_6_0.btnCatch, false, var_10_0.myLv >= var_10_0.needLv and "normal" or "hsl_gray")
			arg_6_0.right:get("time"):hide()

			if arg_10_0 == game.FISHING_GAME and arg_7_7 == "closed" then
				arg_6_0:fishingGameTimer(arg_6_0.btnDatas:atproxy(game.FISHING_GAME).preTime)
			end

			arg_6_0.btnTools:visible(var_10_0.myLv >= var_10_0.needLv or arg_10_0 == game.FISHING_GAME)
			arg_6_0.btnLv:visible(var_10_0.myLv >= var_10_0.needLv or arg_10_0 == game.FISHING_GAME)
			arg_6_0.btnHandbook:visible(var_10_0.myLv >= var_10_0.needLv or arg_10_0 == game.FISHING_GAME)
			arg_6_0.btnShop:visible(var_10_0.myLv >= var_10_0.needLv or arg_10_0 == game.FISHING_GAME)
			arg_6_0.time:visible(var_10_0.myLv >= var_10_0.needLv)
			arg_6_0.times:visible(var_10_0.myLv >= var_10_0.needLv)

			if arg_10_0 == game.FISHING_GAME and arg_7_7 == "closed" then
				arg_6_0.btnEnter:setTouchEnabled(false)
				cache.setShader(arg_6_0.btnEnter, false, "hsl_gray")
				arg_6_0.right:get("tip"):hide()
			elseif arg_6_0.isAuto:read() == true then
				arg_6_0.right:get("tip"):show()
			end

			local var_10_4 = arg_6_0.scenePanel:get("pos.clippingNode")

			var_10_4:removeAllChildren()
			arg_6_0.btnRank:visible(arg_10_0 == game.FISHING_GAME)
			arg_6_0.right:get("fishingGameTag"):visible(arg_10_0 == game.FISHING_GAME and arg_7_7 == "start")
			widget.addAnimationByKey(var_10_4, var_10_0.res, "diaoyuBg", "effect_loop", 1):scale(1.5)

			if arg_10_0 == game.FISHING_GAME then
				widget.addAnimationByKey(arg_6_0.scenePanel:get("pos.clippingNode.diaoyuBg"), "fishing/diaoyudasai.skel", "diaoyudasai", "effect_loop", 2):xy(-300, 90)
			end
		end)
	end)
end

function var_0_1.fishingGameTimer(arg_11_0, arg_11_1)
	arg_11_0:unSchedule(7000)
	arg_11_0.deltaTime:set(0)
	arg_11_0.right:get("time"):hide()

	if not arg_11_1 then
		return
	end

	arg_11_0.deltaTime:set(arg_11_1)
	arg_11_0.right:get("time"):visible(arg_11_1 > 0 and arg_11_1 < var_0_2)
	arg_11_0:schedule(function()
		arg_11_1 = arg_11_1 - 1

		if arg_11_1 <= 0 or arg_11_1 > var_0_2 then
			arg_11_0.right:get("time"):hide()
		end

		arg_11_0.deltaTime:set(arg_11_1)
		adapt.oneLineCenterPos(cc.p(400, arg_11_0.refreshTimeTxt:y()), {
			arg_11_0.refreshTimeTxt,
			arg_11_0.refreshTime
		})
	end, 1, 0, 7000)
end

function var_0_1.initModel(arg_13_0)
	arg_13_0.fishLevel = gGameModel.fishing:getIdler("level")
	arg_13_0.fishCounter = gGameModel.fishing:getIdler("fish_counter")
	arg_13_0.targetCounter = gGameModel.fishing:getIdler("target_counter")
	arg_13_0.fishingCounter = gGameModel.daily_record:getIdler("fishing_counter")
	arg_13_0.selectScene = gGameModel.fishing:getIdler("select_scene")
	arg_13_0.isAuto = gGameModel.fishing:getIdler("is_auto")
	arg_13_0.crossFishingRound = gGameModel.role:getIdler("cross_fishing_round")
	arg_13_0.selectRod = gGameModel.fishing:getIdler("select_rod")
	arg_13_0.selectBait = gGameModel.fishing:getIdler("select_bait")
	arg_13_0.items = gGameModel.role:getIdler("items")
end

function var_0_1.initBgMask(arg_14_0)
	arg_14_0.mask1 = ccui.Scale9Sprite:create()

	arg_14_0.mask1:initWithFile(cc.rect(50, 50, 1, 1), "city/adventure/fishing/mask_dy_bgpre.png")
	arg_14_0.mask1:size(cc.size(1858, 888))

	local var_14_0 = cc.ClippingNode:create(arg_14_0.mask1):setAlphaThreshold(0.1):addTo(arg_14_0.scenePanel:get("pos"), 1, "clippingNode")
end

function var_0_1.onSelectClick(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	if arg_15_3.lock ~= 0 then
		arg_15_0.showTab:set(arg_15_2)
	else
		gGameUI:showTip(gLanguageCsv.pleaseWaitOpen)

		return
	end

	if arg_15_2 == game.FISHING_GAME and arg_15_0.crossFishingRound:read() == "closed" then
		gGameUI:showTip(gLanguageCsv.fishGameNotStart)
	end
end

function var_0_1.getFishingGamePreTime(arg_16_0)
	local var_16_0 = dataEasy.getCrossServiceData("crossfishing", csv.cross.fishing.base[1].servOpenDays)

	if var_16_0 then
		local var_16_1 = csv.cross.service[var_16_0].date

		return time.getNumTimestamp(var_16_1, 5) - time.getTime()
	end
end

function var_0_1.onBtnLv(arg_17_0)
	gGameUI:stackUI("city.adventure.fishing.level")
end

function var_0_1.onBtnHandbook(arg_18_0)
	gGameUI:stackUI("city.adventure.fishing.book")
end

function var_0_1.onBtnShop(arg_19_0)
	if not gGameUI:goBackInStackUI("city.shop") then
		gGameApp:requestServer("/game/fishing/shop/get", function(arg_20_0)
			gGameUI:stackUI("city.shop", nil, {
				full = true
			}, game.SHOP_INIT.FISHING_SHOP)
		end)
	end
end

function var_0_1.onBtnTools(arg_21_0)
	if arg_21_0.crossFishingRound:read() == "closed" and arg_21_0.showTab:read() == game.FISHING_GAME then
		gGameUI:showTip(gLanguageCsv.fishGameNotStart)

		return
	end

	if arg_21_0.isAuto:read() == true and arg_21_0.showTab:read() == gGameModel.fishing:read("select_scene") then
		if arg_21_0.showTab:read() == gGameModel.fishing:read("select_scene") then
			gGameUI:stackUI("city.adventure.fishing.bag", nil, nil, 1, arg_21_0.showTab:read())
		else
			gGameApp:requestServer("/game/fishing/prepare", function(arg_22_0)
				gGameUI:stackUI("city.adventure.fishing.bag", nil, nil, 1, arg_21_0.showTab:read())
			end, "scene", arg_21_0.showTab:read())
		end
	elseif arg_21_0.isAuto:read() == true and arg_21_0.showTab:read() ~= gGameModel.fishing:read("select_scene") then
		gGameUI:stackUI("city.adventure.fishing.auto", nil, {
			clickClose = false,
			blackLayer = true
		}, idx, arg_21_0:createHandler("onOpenView"))
	elseif arg_21_0.isAuto:read() == false then
		if arg_21_0.showTab:read() == gGameModel.fishing:read("select_scene") then
			gGameUI:stackUI("city.adventure.fishing.bag", nil, nil, 1, arg_21_0.showTab:read())
		else
			gGameApp:requestServer("/game/fishing/prepare", function(arg_23_0)
				gGameUI:stackUI("city.adventure.fishing.bag", nil, nil, 1, arg_21_0.showTab:read())
			end, "scene", arg_21_0.showTab:read())
		end
	end
end

function var_0_1.onBtnRank(arg_24_0)
	gGameApp:requestServer("/game/cross/fishing/rank", function(arg_25_0)
		gGameUI:stackUI("city.adventure.fishing.rank", nil, nil, arg_25_0.view)
	end)
end

function var_0_1.onBtnCatch(arg_26_0)
	if arg_26_0.showTab:read() == game.FISHING_GAME and arg_26_0.crossFishingRound:read() == "closed" then
		gGameUI:showTip(gLanguageCsv.fishGameNotStart)

		return
	end

	local var_26_0 = arg_26_0.selectBait:read()
	local var_26_1 = arg_26_0.selectRod:read()
	local var_26_2 = csv.fishing.bait[var_26_0]
	local var_26_3 = 0

	if var_26_2 then
		var_26_3 = arg_26_0.items:read()[var_26_2.itemId] == nil and 0 or arg_26_0.items:read()[var_26_2.itemId]
	end

	local var_26_4 = var_26_3 < arg_26_0.nowCounter and var_26_3 or arg_26_0.nowCounter

	if var_26_1 == 0 then
		gGameUI:showTip(gLanguageCsv.noRod)

		return
	elseif var_26_0 == 0 then
		gGameUI:showTip(gLanguageCsv.noBait)

		return
	elseif var_26_0 then
		if not itertools.map(var_26_2.scene, function(arg_27_0, arg_27_1)
			return arg_27_1, true
		end)[arg_26_0.showTab:read()] then
			gGameUI:showTip(gLanguageCsv.noBait)

			return
		end

		if var_26_3 == 0 then
			gGameUI:showTip(gLanguageCsv.noBaitCount)

			return
		end
	end

	if arg_26_0.nowCounter <= 0 then
		gGameUI:showTip(gLanguageCsv.fishNoTimes)

		return
	end

	if arg_26_0.isAuto:read() == true then
		gGameUI:stackUI("city.adventure.fishing.auto", nil, {
			clickClose = false,
			blackLayer = true
		}, nil, arg_26_0:createHandler("autoLvUp"))

		return
	end

	if arg_26_0.showTab:read() ~= gGameModel.fishing:read("select_scene") then
		gGameApp:requestServer("/game/fishing/prepare", nil, "scene", arg_26_0.showTab:read())
	end

	local var_26_5 = arg_26_0.fishLevel:read()

	gGameUI:showDialog({
		fontSize = 42,
		clearFast = true,
		btnType = 2,
		isRich = true,
		strs = {
			string.format(gLanguageCsv.catchTip, var_26_4, var_26_2.name, var_26_4)
		},
		cb = function()
			gGameApp:requestServer("/game/fishing/onekey", function(arg_29_0)
				if arg_29_0.view.fish == nil and arg_29_0.view.award == nil then
					gGameUI:showTip(gLanguageCsv.catchLoseFishRunAway)
				else
					gGameUI:stackUI("city.adventure.fishing.award", nil, {
						clickClose = true,
						blackLayer = true
					}, arg_29_0.view, arg_26_0.showTab:read(), var_26_5)
				end
			end)
		end
	})
end

function var_0_1.onBtnEnter(arg_30_0, arg_30_1, arg_30_2)
	if arg_30_0.isAuto:read() == true and arg_30_1 == arg_30_2 then
		if arg_30_2 == game.FISHING_GAME then
			gGameApp:requestServer("/game/cross/fishing/rank", function(arg_31_0)
				gGameUI:stackUI("city.adventure.fishing.view", nil, {
					full = true
				}, arg_30_1, arg_31_0.view)
			end)
		else
			gGameUI:stackUI("city.adventure.fishing.view", nil, {
				full = true
			}, arg_30_1)
		end
	elseif arg_30_0.isAuto:read() == true and arg_30_1 ~= arg_30_2 then
		gGameUI:stackUI("city.adventure.fishing.auto", nil, {
			clickClose = false,
			blackLayer = true
		}, arg_30_1, arg_30_0:createHandler("fishSprite"))
	elseif arg_30_0.isAuto:read() == false then
		gGameApp:requestServer("/game/fishing/prepare", function(arg_32_0)
			if arg_30_1 == game.FISHING_GAME then
				gGameApp:requestServer("/game/cross/fishing/rank", function(arg_33_0)
					gGameUI:stackUI("city.adventure.fishing.view", nil, {
						full = true
					}, arg_30_1, arg_33_0.view)
				end)
			else
				gGameUI:stackUI("city.adventure.fishing.view", nil, {
					full = true
				}, arg_30_1)
			end
		end, "scene", arg_30_1)
	end
end

function var_0_1.autoLvUp(arg_34_0)
	if arg_34_0.fishLevel:read() > arg_34_0.oldLv then
		gGameUI:stackUI("city.adventure.fishing.upgrade")
	end
end

function var_0_1.fishSprite(arg_35_0)
	if arg_35_0.fishLevel:read() > arg_35_0.oldLv then
		gGameUI:stackUI("city.adventure.fishing.upgrade", nil, nil, arg_35_0:createHandler("onOpenView"))
	else
		arg_35_0:onOpenView()
	end
end

function var_0_1.onOpenView(arg_36_0)
	if arg_36_0.showTab:read() == game.FISHING_GAME and arg_36_0.crossFishingRound:read() == "closed" then
		gGameUI:showTip(gLanguageCsv.fishGameNotStart)

		return
	end

	gGameApp:requestServer("/game/fishing/prepare", function(arg_37_0)
		if arg_36_0.showTab:read() == game.FISHING_GAME then
			gGameApp:requestServer("/game/cross/fishing/rank", function(arg_38_0)
				gGameUI:stackUI("city.adventure.fishing.view", nil, {
					full = true
				}, arg_36_0.showTab:read(), arg_38_0.view)
			end)

			return
		end

		gGameUI:stackUI("city.adventure.fishing.view", nil, {
			full = true
		}, arg_36_0.showTab:read())
	end, "scene", arg_36_0.showTab:read())
end

return var_0_1
