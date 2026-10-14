local var_0_0 = {
	gLanguageCsv.doubleReward,
	gLanguageCsv.additionalNumber
}
local var_0_1 = {
	gLanguageCsv.mopUp,
	gLanguageCsv.spaceChallenge
}
local var_0_2 = {
	MOPUP = 1,
	CHALLENGE = 2,
	NOT_UNLOCK = 3
}

local function var_0_3(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	return rich.createWithWidth(arg_1_0, 40, nil, arg_1_4):anchorPoint(0, 1):xy(arg_1_1, arg_1_2):addTo(arg_1_3, 6)
end

local function var_0_4(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_1 == 1 and gLanguageCsv.attrDamage or gLanguageCsv.attrSpecialDamage

	if arg_2_2 then
		arg_2_0:show()
		var_0_3(gLanguageCsv.todayCharacteristics, 0, 10, arg_2_0, 400)
		var_0_3(string.format(gLanguageCsv.immuneInjury, var_2_0), 0, -50, arg_2_0, 400)
	else
		var_0_3(gLanguageCsv.todayCharacteristics .. string.format(gLanguageCsv.immuneInjury, var_2_0), 0, 10, arg_2_0, 1400)
	end
end

local function var_0_5(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_3 and 2 or -20

	var_0_3(gLanguageCsv.recommendedToday, 0, var_3_0, arg_3_1, 1400)

	local var_3_1 = {}

	for iter_3_0, iter_3_1 in orderCsvPairs(arg_3_2) do
		local var_3_2 = csv.cards[iter_3_1]
		local var_3_3 = csv.unit[var_3_2.unitID]

		table.insert(var_3_1, {
			id = iter_3_1,
			rarity = var_3_3.rarity
		})
	end

	table.sort(var_3_1, function(arg_4_0, arg_4_1)
		return arg_4_0.rarity > arg_4_1.rarity
	end)

	local var_3_4 = 0
	local var_3_5 = matchLanguage({
		"en"
	}) and 300 or matchLanguage({
		"kr"
	}) and 150 or 110

	for iter_3_2, iter_3_3 in ipairs(var_3_1) do
		local var_3_6 = var_3_5 + iter_3_2 * 160
		local var_3_7 = -120

		if arg_3_3 then
			arg_3_1:show()

			if iter_3_2 <= 3 then
				var_3_6, var_3_7 = (iter_3_2 - 1) * 170, -190
			else
				var_3_6, var_3_7 = (iter_3_2 - 4) * 170, -330
			end

			arg_3_1:get("bg"):size(560, 390)
		end

		local var_3_8 = ccui.Layout:create():size(0, 0):addTo(arg_3_1, 6):xy(var_3_6, var_3_7)

		bind.extend(arg_3_0, var_3_8, {
			class = "card_icon",
			props = {
				cardId = iter_3_3.id,
				rarity = iter_3_3.rarity,
				onNode = function(arg_5_0)
					arg_5_0:setTouchEnabled(false):scale(0.7)
					arg_5_0:get("imgBG"):texture(ui.QUALITY_BOX[iter_3_3.rarity + 2])
				end
			}
		})
	end
end

local var_0_6 = class("DailyActivityGateSelectView", cc.load("mvc").ViewBase)

var_0_6.RESOURCE_FILENAME = "daily_activity_gate_select.json"
var_0_6.RESOURCE_BINDING = {
	["left.timeInfo.textTime"] = "openTime",
	["left.leftUp.textTimes"] = "times",
	["left.flagIcon"] = "flagIcon",
	["left.textName"] = "title",
	["right.textNote"] = "topTxt",
	["right.pos"] = "pos",
	item = "item",
	["left.imgBg"] = "background",
	["left.doubleFlag"] = "doubleFlag",
	["left.textDesc"] = "desc",
	["left.imgIcon"] = "imgIcon",
	["right.btnRank"] = {
		varname = "btnRank",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRankBtn")
			}
		}
	},
	["right.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				backupCached = false,
				data = bindHelper.self("gates"),
				item = bindHelper.self("item"),
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				preloadCenterIndex = bindHelper.self("jumpPos"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					arg_6_1:setName("item" .. arg_6_0:getIdx(arg_6_2))

					local var_6_0 = arg_6_1:multiget("imgIcon", "textLv", "textLvNum", "list", "btnChallenge", "unLock", "imgLvBg", "imgJxBg", "btnJxWipe", "btnJxNext", "imgJxLogo")

					if arg_6_3.limitGate then
						var_6_0.unLock:hide()
						var_6_0.imgJxBg:show()
						var_6_0.imgJxLogo:show()
						var_6_0.btnJxWipe:visible(not arg_6_3.isLastGate)
						var_6_0.btnJxWipe:get("textNote"):setFontSize(50)
						var_6_0.btnJxNext:visible(not arg_6_3.isLastGate)
						var_6_0.btnJxNext:get("textNote"):setFontSize(50)
						var_6_0.btnChallenge:visible(arg_6_3.isLastGate)
						var_6_0.btnChallenge:setTouchEnabled(arg_6_3.isLastGate)
						var_6_0.imgJxLogo:get("textNote"):text(string.format(gLanguageCsv.nextLimitGate, arg_6_3.gateLimitNum))
						var_6_0.btnJxNext:get("textNote"):text(gLanguageCsv.nextGate)

						if arg_6_3.gateLimitNum == 0 then
							cache.setShader(var_6_0.btnJxWipe, false, "hsl_gray")
							var_6_0.btnJxNext:get("textNote"):text(gLanguageCsv.challenage)
						end

						text.addEffect(var_6_0.imgJxLogo:get("textNote"), {
							outline = {
								size = 5,
								color = cc.c4b(209, 50, 18, 255)
							}
						})
						text.addEffect(var_6_0.btnChallenge:get("textNote"), {
							outline = {
								size = 1,
								color = ui.NEWCOLORS.OUTLINE.YELLOW1
							}
						})
						text.addEffect(var_6_0.btnJxNext:get("textNote"), {
							outline = {
								size = 1,
								color = ui.NEWCOLORS.OUTLINE.YELLOW1
							}
						})
						text.addEffect(var_6_0.btnJxWipe:get("textNote"), {
							outline = {
								size = 1,
								color = ui.NEWCOLORS.OUTLINE.YELLOW1
							}
						})
						bind.touch(arg_6_0, var_6_0.btnChallenge, {
							methods = {
								ended = functools.partial(arg_6_0.clickCell, arg_6_2, arg_6_3)
							}
						})
						bind.touch(arg_6_0, var_6_0.btnJxWipe, {
							methods = {
								ended = functools.partial(arg_6_0.clickCell, arg_6_2, arg_6_3)
							}
						})
						bind.touch(arg_6_0, var_6_0.btnJxNext, {
							methods = {
								ended = functools.partial(arg_6_0.clickLimitNext, arg_6_2, arg_6_3.gateNextId)
							}
						})
					else
						var_6_0.imgJxBg:hide()
						var_6_0.btnJxWipe:hide()
						var_6_0.btnJxNext:hide()
						var_6_0.imgJxLogo:hide()
						var_6_0.btnChallenge:get("textNote"):text(var_0_1[arg_6_3.btnState == var_0_2.MOPUP and 1 or 2])
						text.addEffect(var_6_0.btnChallenge:get("textNote"), {
							outline = {
								size = 0,
								color = ui.NEWCOLORS.OUTLINE.YELLOW1
							}
						})
						var_6_0.btnChallenge:get("textNote"):visible(arg_6_3.btnState ~= var_0_2.NOT_UNLOCK)
						var_6_0.btnChallenge:visible(arg_6_3.btnState == var_0_2.CHALLENGE or arg_6_3.btnState == var_0_2.MOPUP)
						var_6_0.unLock:get("textNote"):text(arg_6_3.unlockBtnTitle)
						var_6_0.unLock:visible(arg_6_3.btnState == var_0_2.NOT_UNLOCK)
						bind.touch(arg_6_0, var_6_0.btnChallenge, {
							methods = {
								ended = functools.partial(arg_6_0.clickCell, arg_6_2, arg_6_3)
							}
						})
						bind.touch(arg_6_0, var_6_0.unLock, {
							methods = {
								ended = functools.partial(arg_6_0.clickCell, arg_6_2, arg_6_3)
							}
						})
					end

					bind.touch(arg_6_0, arg_6_1, {
						methods = {
							ended = functools.partial(arg_6_0.clickNode, arg_6_2, arg_6_3)
						}
					})
					var_6_0.imgIcon:texture(arg_6_3.icon)
					var_6_0.textLvNum:text(arg_6_3.openLevel)
					var_6_0.imgLvBg:anchorPoint(0, 0.5):x(var_6_0.textLv:box().x - 30):width(math.max(145, var_6_0.textLv:width() + var_6_0.textLvNum:width() + 60))
					uiEasy.createItemsToList(arg_6_0, var_6_0.list, arg_6_3.dropIds, {
						margin = 20,
						scale = 0.8,
						onAfterBuild = function()
							local var_7_0 = var_6_0.list:getInnerItemSize(var_6_0.list)
							local var_7_1 = var_6_0.list:width()

							if var_7_1 > var_7_0.width then
								var_6_0.list:x(var_6_0.list:x() + var_7_1 - var_7_0.width)
							end
						end
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick"),
				clickNode = bindHelper.self("onNodeClick"),
				clickLimitNext = bindHelper.self("onSkipBattle")
			}
		}
	}
}

function var_0_6.onCreate(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0:initModel()

	arg_8_0.csvId = arg_8_1

	local var_8_0 = csv.huodong[arg_8_1]

	gGameUI.topuiManager:createView("default", arg_8_0, {
		onClose = arg_8_0:createHandler("onClose")
	}):init({
		subTitle = "TRANSCRIPT",
		title = "common/txt/txt_bt_richangfuben.png"
	})
	arg_8_0:setFeltPanel(var_8_0, arg_8_2)

	arg_8_0.jumpPos = 0
	arg_8_0.gates = idlers.new()
	arg_8_0.gateIds = idlertable.new(table.deepcopy(var_8_0.gateSeq, true))
	arg_8_0.gateDatas = idlertable.new({})

	arg_8_0.btnRank:visible(arg_8_1 == 1 or arg_8_1 == 2)
	idlereasy.any({
		arg_8_0.giftImmuneType,
		arg_8_0.giftGroup
	}, function(arg_9_0, arg_9_1, arg_9_2)
		if arg_8_1 == 3 then
			arg_8_0.list:size(1772, 960)
			var_0_4(arg_8_0.pos, arg_9_1, false)

			local var_9_0 = arg_9_2 == 1 and var_8_0.gateSeq or var_8_0.gateSeq2

			arg_8_0.gateIds:set(table.deepcopy(var_9_0, true))
		end
	end)
	idlereasy.when(arg_8_0.fragGroup, function(arg_10_0, arg_10_1)
		if arg_8_1 == 4 then
			arg_8_0.list:size(1772, 880)

			local var_10_0 = csv.huodong_gate_fragment[arg_10_1]

			var_0_5(arg_8_0, arg_8_0.pos, var_10_0.markIDs, false)

			local var_10_1 = var_10_0.gateGroup

			arg_8_0.gateIds:set(var_10_1)
		end
	end)
	idlereasy.when(arg_8_0.gateIds, function(arg_11_0, arg_11_1)
		local var_11_0 = {}

		for iter_11_0, iter_11_1 in orderCsvPairs(arg_11_1) do
			local var_11_1 = csv.scene_conf[iter_11_1]
			local var_11_2 = gLanguageCsv.currentLevelNotAvailable

			if arg_8_0.roleLv:read() >= var_11_1.openLevel then
				var_11_2 = gLanguageCsv.notPerfectClearanceNextLevel
			end

			local var_11_3 = iter_11_0 == 1 and arg_8_0.roleLv:read() >= var_11_1.openLevel and var_0_2.CHALLENGE or var_0_2.NOT_UNLOCK

			var_11_0[iter_11_0] = {
				limitGate = false,
				gateId = iter_11_1,
				icon = var_11_1.icon,
				dropIds = var_11_1.dropIds,
				openLevel = var_11_1.openLevel,
				btnState = var_11_3,
				unlockBtnTitle = var_11_2
			}
		end

		arg_8_0.gateDatas:set(var_11_0)
	end)
	idlereasy.any({
		arg_8_0.huodongsGate,
		arg_8_0.roleLv,
		arg_8_0.gateDatas,
		arg_8_0.huodongsIndex
	}, function(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
		local var_12_0 = clone(arg_12_3)
		local var_12_1 = {}

		for iter_12_0, iter_12_1 in pairs(arg_12_4) do
			var_12_1[iter_12_0] = iter_12_1
		end

		if var_12_1[arg_8_0.csvId] and var_12_1[arg_8_0.csvId] >= #var_12_0 - 1 and (arg_8_0.csvId == 1 and dataEasy.isUnlock(gUnlockCsv.goldLimitMode) or arg_8_0.csvId == 2 and dataEasy.isUnlock(gUnlockCsv.expLimitMode)) then
			local var_12_2 = var_12_1[arg_8_0.csvId] + 1 - #var_12_0
			local var_12_3 = var_12_2 == 0 and var_8_0.gateLimitSeq[1] or var_8_0.gateLimitSeq[var_12_2]
			local var_12_4 = var_12_2 == csvSize(var_8_0.gateLimitSeq)
			local var_12_5 = var_12_4 and var_12_3 or var_8_0.gateLimitSeq[var_12_2 + 1]
			local var_12_6 = csv.scene_conf[var_12_3]

			var_12_0[#var_12_0 + 1] = {
				limitGate = true,
				gateId = var_12_3,
				gateNextId = var_12_5,
				icon = var_12_6.icon,
				dropIds = var_12_6.dropIds,
				openLevel = var_12_6.openLevel,
				gateLimitNum = var_12_2,
				isLastGate = var_12_4,
				btnState = var_0_2.MOPUP
			}
		end

		if arg_12_1[arg_8_1] then
			for iter_12_2, iter_12_3 in ipairs(var_12_0) do
				if not iter_12_3.limitGate then
					local var_12_7 = false

					if var_8_0.type == "gold" or var_8_0.type == "exp" or var_8_0.type == "event" then
						if (arg_12_1[arg_8_1][iter_12_3.gateId] or 0) == 3 then
							var_12_7 = true
						end
					elseif arg_12_4 and iter_12_2 <= (arg_12_4[arg_8_1] or -1) + 1 and (var_8_0.type == "gift" and dataEasy.isUnlock(gUnlockCsv.dailyGiftGate) or var_12_0[iter_12_2 + 1] and arg_12_2 >= var_12_0[iter_12_2 + 1].openLevel) then
						var_12_7 = true
					end

					if arg_12_2 < iter_12_3.openLevel then
						var_12_0[iter_12_2].btnState = var_0_2.NOT_UNLOCK
					elseif var_12_7 then
						var_12_0[iter_12_2].btnState = var_0_2.MOPUP

						if var_12_0[iter_12_2 + 1] and arg_12_2 >= var_12_0[iter_12_2 + 1].openLevel then
							var_12_0[iter_12_2 + 1].btnState = var_0_2.CHALLENGE
							arg_8_0.jumpPos = arg_8_0.jumpPos + 1
						end
					end
				end
			end
		end

		arg_8_0.gates:update(var_12_0)
	end)

	local var_8_1 = {
		{
			game.PRIVILEGE_TYPE.HuodongTypeGoldTimes,
			game.PRIVILEGE_TYPE.HuodongTypeGoldDropRate,
			gLanguageCsv.gold
		},
		{
			game.PRIVILEGE_TYPE.HuodongTypeExpTimes,
			game.PRIVILEGE_TYPE.HuodongTypeExpDropRate,
			gLanguageCsv.expLiquid
		},
		{
			game.PRIVILEGE_TYPE.HuodongTypeGiftTimes,
			game.PRIVILEGE_TYPE.HuodongTypeGiftDropRate,
			gLanguageCsv.favouriteGift
		},
		{
			game.PRIVILEGE_TYPE.HuodongTypeFragTimes,
			game.PRIVILEGE_TYPE.HuodongTypeFragDropRate,
			gLanguageCsv.spriteFrags
		}
	}

	idlereasy.when(arg_8_0.huodongs, function(arg_13_0, arg_13_1)
		local var_13_0 = var_8_1[var_8_0.huodongType] or {}
		local var_13_1 = var_13_0[1] and dataEasy.getPrivilegeVal(var_13_0[1]) or 0

		if arg_8_2 and arg_8_2.show and arg_8_2.type == 2 then
			var_13_1 = var_13_1 + arg_8_2.paramMap.count or 0
		end

		local var_13_2 = var_8_0.times + var_13_1
		local var_13_3 = tonumber(time.getTodayStrInClock())

		if arg_13_1[var_13_3] and arg_13_1[var_13_3][arg_8_1] then
			var_13_2 = var_13_2 - arg_13_1[var_13_3][arg_8_1].times
		end

		local var_13_4 = math.max(var_13_2, 0)

		arg_8_0.surplusTimes = var_13_4

		arg_8_0.times:text(var_13_4 .. "/" .. var_8_0.times + var_13_1)
		arg_8_0.topTxt:removeAllChildren()

		if var_13_0[2] then
			local var_13_5 = cc.p(arg_8_0.topTxt:size().width, arg_8_0.topTxt:size().height)

			uiEasy.setPrivilegeRichText(var_13_0[2], arg_8_0.topTxt, var_8_1[var_8_0.huodongType][3], var_13_5, true)
		end
	end)
end

function var_0_6.initModel(arg_14_0)
	arg_14_0.huodongs = gGameModel.role:getIdler("huodongs")
	arg_14_0.huodongsGate = gGameModel.role:getIdler("huodongs_gate")
	arg_14_0.roleLv = gGameModel.role:getIdler("level")
	arg_14_0.giftGroup = gGameModel.global_record:getIdler("huodong_gift_group")
	arg_14_0.fragGroup = gGameModel.global_record:getIdler("huodong_frag_group")
	arg_14_0.giftImmuneType = gGameModel.global_record:getIdler("huodong_gift_immune_type")
	arg_14_0.huodongsIndex = gGameModel.role:getIdler("huodongs_index")
end

function var_0_6.setFeltPanel(arg_15_0, arg_15_1, arg_15_2)
	arg_15_0.background:texture(arg_15_1.background)
	arg_15_0.imgIcon:texture(arg_15_1.icon)
	arg_15_0.title:text(arg_15_1.name)
	arg_15_0.doubleFlag:visible(arg_15_2.isDoubleAward)

	if arg_15_2 then
		arg_15_0.flagIcon:visible(arg_15_2.show)
		arg_15_0.flagIcon:get("textNote"):text(var_0_0[arg_15_2.type])
	end

	arg_15_0.openTime:text(arg_15_1.openTimeDesc)
	arg_15_0.desc:text(arg_15_1.desc)
	arg_15_0.topTxt:text(arg_15_1.desc)
end

function var_0_6.onRankBtn(arg_16_0)
	gGameApp:requestServer("/game/rank", function(arg_17_0)
		gGameUI:stackUI("city.adventure.daily_activity.rank", nil, nil, arg_17_0.view)
	end, "huodong_" .. arg_16_0.csvId, 0, 50)
end

function var_0_6.onSkipBattle(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if arg_18_0.surplusTimes <= 0 then
		gGameUI:showTip(gLanguageCsv.timesLimitBreakBrick)

		return
	end

	arg_18_0.gateId = arg_18_3

	local var_18_0 = arg_18_0:createHandler("onClose")

	gGameUI:stackUI("city.card.embattle.base", nil, {
		full = true
	}, {
		team = true,
		from = game.EMBATTLE_FROM_TABLE.huodong,
		fromId = arg_18_0.csvId,
		fightCb = arg_18_0:createHandler("startFighting"),
		startCb = arg_18_0:createHandler("showTip")
	})
end

function var_0_6.showTip(arg_19_0, arg_19_1)
	if arg_19_0.csvId == 3 then
		var_0_4(arg_19_1.dailyGateTipsPos, arg_19_0.giftImmuneType:read(), true)
	end

	if arg_19_0.csvId == 4 then
		local var_19_0 = csv.huodong_gate_fragment[arg_19_0.fragGroup:read()]

		var_0_5(arg_19_0, arg_19_1.dailyGateTipsPos, var_19_0.markIDs, true)
	end
end

function var_0_6.startFighting(arg_20_0, arg_20_1, arg_20_2)
	battleEntrance.battleRequest("/game/huodong/start", arg_20_2, arg_20_0.csvId, arg_20_0.gateId):onStartOK(function(arg_21_0)
		if arg_20_1 then
			arg_20_1:onClose(false)

			arg_20_1 = nil
		end
	end):show()
end

function var_0_6.onItemClick(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	arg_22_0.gateId = arg_22_3.gateId

	if arg_22_3.limitGate and arg_22_3.gateLimitNum == 0 then
		gGameUI:showTip(gLanguageCsv.notSwipe)
	elseif arg_22_3.limitGate or arg_22_3.btnState == var_0_2.MOPUP then
		arg_22_0:onSweepBtn()
	elseif arg_22_3.btnState == var_0_2.CHALLENGE then
		arg_22_0:onSkipBattle(arg_22_1, arg_22_2, arg_22_3.gateId)
	elseif arg_22_3.btnState == var_0_2.NOT_UNLOCK then
		local var_22_0 = gLanguageCsv[arg_22_0.roleLv:read() >= arg_22_3.openLevel and "notPerfectClearanceNextLevel" or "currentLevelNotAvailable"]

		gGameUI:showTip(var_22_0)
	end
end

function var_0_6.onNodeClick(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	arg_23_0.gateId = arg_23_3.gateId

	if arg_23_3.limitGate and arg_23_3.gateLimitNum == 0 then
		arg_23_0.gateId = arg_23_3.nextGateId
	end

	if arg_23_3.btnState == var_0_2.MOPUP or arg_23_3.btnState == var_0_2.CHALLENGE then
		arg_23_0:onSkipBattle(arg_23_1, arg_23_2, arg_23_3.gateId)
	elseif arg_23_3.btnState == var_0_2.NOT_UNLOCK then
		local var_23_0 = gLanguageCsv[arg_23_0.roleLv:read() >= arg_23_3.openLevel and "notPerfectClearanceNextLevel" or "currentLevelNotAvailable"]

		gGameUI:showTip(var_23_0)
	end
end

function var_0_6.onSweepBtn(arg_24_0)
	if arg_24_0.surplusTimes <= 0 then
		gGameUI:showTip(gLanguageCsv.saodangTimesNotEnough)

		return
	end

	local var_24_0 = arg_24_0.roleLv:read()

	gGameApp:requestServer("/game/huodong/saodang", function(arg_25_0)
		gGameUI:showGainDisplay(arg_25_0, {
			isDouble = dataEasy.isGateIdDoubleDrop(arg_24_0.gateId)
		})
	end, arg_24_0.csvId, arg_24_0.gateId, 1)
end

function var_0_6.onAfterBuild(arg_26_0)
	arg_26_0.list:jumpToItem(arg_26_0.jumpPos, cc.p(0, 1), cc.p(0, 1))
end

function var_0_6.onSortCards(arg_27_0, arg_27_1)
	return function(arg_28_0, arg_28_1)
		if arg_28_0.openLevel ~= arg_28_1.openLevel then
			return arg_28_0.openLevel < arg_28_1.openLevel
		end

		return arg_28_0.gateId < arg_28_1.gateId
	end
end

return var_0_6
