local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("GainWayView", Dialog)
local var_0_2 = {
	gLanguageCsv.mopUp,
	gLanguageCsv.leaveFor,
	gLanguageCsv.notOpen
}
local var_0_3 = {
	MOPUP = 1,
	NOTOPEN = 3,
	LEAVEFOR = 2
}
local var_0_4 = game.SHOP_UNLOCK_KEY

var_0_1.WAY_TITLE = {
	normal = gLanguageCsv.getplay,
	shop = {
		gLanguageCsv.spaceHandpick,
		gLanguageCsv.spaceGuild,
		gLanguageCsv.spaceFragment,
		gLanguageCsv.spacePvp,
		gLanguageCsv.explorer,
		gLanguageCsv.randomTower,
		gLanguageCsv.craft,
		gLanguageCsv.equipShop,
		gLanguageCsv.unionCombet,
		gLanguageCsv.crossCraft,
		gLanguageCsv.crossArena,
		gLanguageCsv.fishing,
		gLanguageCsv.onlineFight,
		gLanguageCsv.skin,
		gLanguageCsv.crossMine,
		gLanguageCsv.huntingArea
	},
	activity = gLanguageCsv.activity,
	gate = gLanguageCsv.mainline,
	endlessTower = gLanguageCsv.endlessTower,
	dispatchTask = gLanguageCsv.dispatch,
	randomTower = gLanguageCsv.randomTower,
	explorerDraw = gLanguageCsv.explorerDraw,
	cloneBattle = gLanguageCsv.clone,
	craft = gLanguageCsv.craft,
	task = gLanguageCsv.task,
	talent = gLanguageCsv.talent,
	fishing = gLanguageCsv.angling,
	gymChallenge = gLanguageCsv.gymChallenge,
	drawCard = {
		diamond = gLanguageCsv.diamondDraw,
		limit = gLanguageCsv.drawLimit,
		gold = gLanguageCsv.goldDraw,
		equip = gLanguageCsv.drawEquip,
		diamondup = gLanguageCsv.diamondUpDrawCard
	},
	activityGate = {
		gold = gLanguageCsv.GoldTranscript,
		exp = gLanguageCsv.expTranscript,
		frag = gLanguageCsv.FragmentTranscript,
		gift = gLanguageCsv.GiftTranscript
	},
	gemDraw = gLanguageCsv.drawGemTitle,
	megaStone = gLanguageCsv.everydayTransform,
	keyStone = gLanguageCsv.everydayTransform,
	zawakeFragExclusive = gLanguageCsv.zawakeFragExchange,
	zawakeFragCurrency = gLanguageCsv.zawakeFragExchange
}

local var_0_5 = {
	endlessTower = gLanguageCsv.adventure,
	dispatchTask = gLanguageCsv.adventure,
	randomTower = gLanguageCsv.adventure,
	cloneBattle = gLanguageCsv.adventure,
	activityGate = gLanguageCsv.adventure,
	fishing = gLanguageCsv.adventure,
	gym = gLanguageCsv.gymChallenge
}
local var_0_6 = {
	zawakeFragExclusive = gLanguageCsv.zawake,
	zawakeFragCurrency = gLanguageCsv.zawake
}
local var_0_7 = {
	{
		1,
		10,
		50
	},
	{
		1,
		3
	},
	{
		1,
		3,
		10,
		50
	}
}
local var_0_8 = {
	"sweepSelected",
	"sweepSelectedHard",
	"sweepSelectedNomalAndHard"
}

var_0_1.RESOURCE_FILENAME = "common_gain_way.json"
var_0_1.RESOURCE_BINDING = {
	["bg.emptyBg"] = "emptyBg",
	cardName = "cardNameText",
	item = "wayItem",
	["bg.emptyTxt"] = "emptyTxt",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	num1 = {
		varname = "num1"
	},
	num = {
		varname = "num",
		binds = {
			{
				event = "text",
				idler = bindHelper.self("cardNum")
			}
		}
	},
	list = {
		varname = "wayList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("wayDatas"),
				item = bindHelper.self("wayItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("btn", "btnTitle")
					local var_1_1 = arg_1_1:multiget("title", "txt", "btn", "list")

					if matchLanguage({
						"en",
						"tw"
					}) then
						local var_1_2 = #arg_1_3.title / 3

						if var_1_2 == 2 then
							text.addEffect(var_1_1.title, {
								size = 80
							})
						elseif var_1_2 == 3 then
							text.addEffect(var_1_1.title, {
								size = 60
							})
						elseif var_1_2 == 4 or var_1_2 == 5 then
							text.addEffect(var_1_1.title, {
								size = 40
							})
						end
					end

					if matchLanguage({
						"cn"
					}) then
						local var_1_3 = math.floor(#arg_1_3.title / 3)

						if var_1_3 == 3 then
							text.addEffect(var_1_1.title, {
								size = 45
							})
						elseif var_1_3 == 4 then
							text.addEffect(var_1_1.title, {
								size = 38
							})
						elseif var_1_3 == 5 then
							text.addEffect(var_1_1.title, {
								size = 34
							})
						elseif var_1_3 > 5 then
							text.addEffect(var_1_1.title, {
								size = 30
							})
						end
					end

					var_1_1.title:text(arg_1_3.title)
					var_1_0:text(arg_1_3.btnTitle)
					var_1_1.txt:text(arg_1_3.txt)
					adapt.setTextAdaptWithSize(var_1_1.txt, {
						vertical = "center",
						horizontal = "left",
						size = cc.size(200, 200)
					})

					if arg_1_3.typ == var_0_3.LEAVEFOR or arg_1_3.typ == var_0_3.MOPUP then
						arg_1_1:get("btn"):loadTextureNormal("common/btn/btn_normal.png")
					else
						arg_1_1:get("btn"):loadTextureNormal("common/btn/btn_normal.png")
					end

					if arg_1_3.typ == var_0_3.LEAVEFOR or arg_1_3.typ == var_0_3.MOPUP then
						cache.setShader(var_1_1.btn, false, "normal")
						text.addEffect(var_1_0, {
							outline = {
								size = 4,
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
					else
						cache.setShader(var_1_1.btn, false, "hsl_gray")
						text.deleteAllEffect(var_1_0)
						text.addEffect(var_1_0, {
							color = ui.COLORS.DISABLED.WHITE
						})
					end

					uiEasy.createItemsToList(arg_1_0, var_1_1.list, arg_1_3.dropIds, {
						scale = 1,
						margin = 25
					})
					bind.touch(arg_1_0, var_1_1.btn, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
						}
					})
					var_1_1.list:setTouchEnabled(false)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onWayItemClick")
			}
		}
	},
	selectPanel = {
		varname = "selectPanel",
		binds = {
			event = "extend",
			class = "sort_menus",
			props = {
				width = 300,
				data = bindHelper.self("waySelectDatas"),
				locked = bindHelper.self("locked"),
				btnClick = bindHelper.self("onSortMenusBtnClick", true),
				showSelected = bindHelper.self("sweepSelected"),
				onNode = function(arg_2_0)
					arg_2_0:xy(-1100, -500):z(20)
				end
			}
		}
	},
	cardImg = {
		binds = {
			event = "extend",
			class = "icon_key",
			props = {
				data = bindHelper.self("keyData")
			}
		}
	},
	title = {
		varname = "title",
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
	title1 = {
		varname = "title1",
		binds = {
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

function var_0_1.onCreate(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0:initModel()

	arg_3_0.cb = arg_3_2
	arg_3_0.key = arg_3_1
	arg_3_0.targetNum = arg_3_3

	arg_3_0:initTopInfo()
	arg_3_0.wayItem:get("list"):setScrollBarEnabled(false)
	arg_3_0.selectPanel:visible(false)

	arg_3_0.sectionCsv = arg_3_0:getSectionCsv()
	arg_3_0.chapterType = 1
	arg_3_0.wayDatas = {}

	local var_3_0 = {}

	arg_3_0.title:text(gLanguageCsv.specialGet)
	arg_3_0.title1:text(gLanguageCsv.specialWay)
	arg_3_0:initWayDatas(var_3_0)
	arg_3_0:initEmpty()

	if itertools.size(var_3_0) > 1 then
		arg_3_0.chapterType = 3
	else
		arg_3_0.chapterType = next(var_3_0) or 1
	end

	local var_3_1 = var_0_7[arg_3_0.chapterType]

	arg_3_0:initWaySelectDatas(var_3_1)
	dataEasy.fixSaoDangLocalKey(var_0_8[arg_3_0.chapterType], var_3_1)

	arg_3_0.sweepSelected = userDefault.getForeverLocalKey(var_0_8[arg_3_0.chapterType], 1)
	arg_3_0.mopUpNum = var_3_1[math.min(#var_3_1, arg_3_0.sweepSelected)]

	arg_3_0:initSweepLocked(var_3_1)
	Dialog.onCreate(arg_3_0)
end

function var_0_1.initTopInfo(arg_4_0)
	arg_4_0.keyData = {
		key = arg_4_0.key
	}

	uiEasy.setIconName(arg_4_0.key, nil, {
		node = arg_4_0.cardNameText
	})
	text.deleteAllEffect(arg_4_0.cardNameText)
	idlereasy.when(dataEasy.getListenNumByKey(arg_4_0.key), function(arg_5_0, arg_5_1)
		arg_4_0:setNum(arg_5_1)
	end)
end

function var_0_1.isShowTargetNum(arg_6_0)
	if tonumber(arg_6_0.targetNum) then
		return tonumber(arg_6_0.targetNum) > 1
	else
		return false
	end
end

function var_0_1.initWayDatas(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.key
	local var_7_1 = dataEasy.getCfgByKey(var_7_0)

	for iter_7_0 = 1, math.huge do
		if not var_7_1["produceGate" .. iter_7_0] or var_7_1["produceGate" .. iter_7_0] == "" then
			break
		end

		local var_7_2 = string.split(var_7_1["produceGate" .. iter_7_0], "-")
		local var_7_3 = var_0_3.NOTOPEN
		local var_7_4 = var_7_2[1]
		local var_7_5
		local var_7_6 = ""
		local var_7_7 = {}
		local var_7_8 = gLanguageCsv[var_7_4] or ""

		if var_0_5[var_7_4] then
			var_7_8 = var_0_5[var_7_4]
		end

		if var_0_6[var_7_4] then
			var_7_8 = var_0_6[var_7_4]
		end

		if #var_7_2 == 1 and tonumber(var_7_2[1]) then
			var_7_5 = tonumber(var_7_2[1])
			var_7_6, var_7_3 = arg_7_0:getGateDescribe(var_7_5)
			var_7_4 = "gate"

			local var_7_9 = arg_7_0.gateStar:read()
			local var_7_10, var_7_11, var_7_12, var_7_13 = dataEasy.getChapterInfoByGateID(var_7_5)

			var_7_8 = var_7_13

			if arg_7_0:checkCanSweep(var_7_5) then
				var_7_3 = var_0_3.MOPUP

				arg_7_0.selectPanel:visible(true)

				arg_7_1[var_7_10] = true
			end

			local var_7_14 = csv.scene_conf[var_7_5] or {}

			for iter_7_1, iter_7_2 in csvMapPairs(var_7_14.dropIds or {}) do
				table.insert(var_7_7, {
					key = iter_7_1,
					num = iter_7_2
				})
			end

			arg_7_0.chapterType = var_7_10
		else
			local var_7_15 = arg_7_0.WAY_TITLE[var_7_4]

			if type(var_7_15) == "table" and var_7_2[2] then
				var_7_6 = var_7_15[tonumber(var_7_2[2]) or var_7_2[2]] or ""
			else
				local var_7_16 = var_7_15

				if type(var_7_15) == "table" or var_7_15 == nil then
					var_7_16 = gLanguageCsv[var_7_4]
				end

				var_7_6 = string.format(gLanguageCsv.acquiringWay, var_7_16)
			end

			var_7_3 = var_0_3.LEAVEFOR

			if var_7_4 == "shop" then
				local var_7_17 = tonumber(var_7_2[2]) or 1
				local var_7_18 = var_0_4[var_7_17].unlockKey

				if var_7_18 and (not dataEasy.isUnlock(var_7_18) or var_0_4[var_7_17].mustHaveUion == true and not arg_7_0.unionId:read()) then
					var_7_3 = var_0_3.NOTOPEN
				end
			end
		end

		if arg_7_0:canShow(var_7_2) then
			table.insert(arg_7_0.wayDatas, {
				title = var_7_8,
				btnTitle = var_0_2[var_7_3],
				produceGate = var_7_1["produceGate" .. iter_7_0],
				typ = var_7_3,
				txt = var_7_6,
				gateId = var_7_5,
				dropIds = var_7_7,
				id = var_7_1.id,
				targetNum = arg_7_0.targetNum
			})
		end
	end
end

function var_0_1.initWaySelectDatas(arg_8_0, arg_8_1)
	local var_8_0 = {}

	for iter_8_0 = 1, #arg_8_1 do
		table.insert(var_8_0, string.format(gLanguageCsv.sweepManyTimes, arg_8_1[iter_8_0]))
	end

	arg_8_0.waySelectDatas:set(var_8_0)
end

function var_0_1.initEmpty(arg_9_0)
	local var_9_0 = dataEasy.getCfgByKey(arg_9_0.key)
	local var_9_1 = #arg_9_0.wayDatas == 0

	arg_9_0.emptyTxt:visible(var_9_1)
	arg_9_0.emptyBg:visible(var_9_1)
	arg_9_0.emptyTxt:text(var_9_0.produceDesc or "")
	arg_9_0.emptyBg:scale((arg_9_0.emptyTxt:width() + 100) / arg_9_0.emptyBg:width())
end

function var_0_1.initSweepLocked(arg_10_0, arg_10_1)
	idlereasy.when(arg_10_0.vipLevel, function(arg_11_0, arg_11_1)
		local var_11_0 = gVipCsv[arg_11_1].saodangCountOpen
		local var_11_1 = dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.GateSaoDangTimes)
		local var_11_2 = 0

		for iter_11_0 = 2, #arg_10_1 do
			if var_11_1 < arg_10_1[iter_11_0] and var_11_0 < arg_10_1[iter_11_0] then
				var_11_2 = iter_11_0
			end
		end

		arg_10_0.locked:set(var_11_2)
	end)
end

function var_0_1.getSectionCsv(arg_12_0)
	local var_12_0 = {}

	for iter_12_0, iter_12_1 in csvPairs(csv.world_map) do
		local var_12_1 = {
			cfg = iter_12_1
		}

		if var_12_1.cfg.chapterType then
			if not var_12_0[var_12_1.cfg.chapterType] then
				var_12_0[var_12_1.cfg.chapterType] = {}
			end

			var_12_1.sortIndex = iter_12_0

			table.insert(var_12_0[var_12_1.cfg.chapterType], var_12_1)
		end
	end

	for iter_12_2, iter_12_3 in pairs(var_12_0) do
		table.sort(iter_12_3, function(arg_13_0, arg_13_1)
			return arg_13_0.sortIndex < arg_13_1.sortIndex
		end)
	end

	return var_12_0
end

function var_0_1.canShow(arg_14_0, arg_14_1)
	local var_14_0 = true

	if #arg_14_1 == 1 and tonumber(arg_14_1[1]) then
		local var_14_1 = tonumber(arg_14_1[1])
		local var_14_2, var_14_3 = dataEasy.getChapterInfoByGateID(var_14_1)

		if var_14_3 ~= 0 then
			var_14_0 = arg_14_0.sectionCsv[var_14_2][var_14_3] ~= nil
		end
	elseif arg_14_1[1] == "shop" then
		local var_14_4 = tonumber(arg_14_1[2]) or 1
		local var_14_5 = var_0_4[var_14_4].unlockKey

		if var_14_5 and not dataEasy.isUnlock(var_14_5) then
			var_14_0 = false
		end

		if not gShopGainMap[arg_14_0.key] then
			var_14_0 = false
		end
	end

	if arg_14_1[1] == "drawCard" and not gDrawPreviewMap[arg_14_0.key] then
		var_14_0 = false
	end

	return var_14_0
end

function var_0_1.getGateDescribe(arg_15_0, arg_15_1)
	local var_15_0, var_15_1, var_15_2, var_15_3 = dataEasy.getChapterInfoByGateID(arg_15_1)
	local var_15_4 = var_0_3.NOTOPEN
	local var_15_5 = ""

	if var_15_1 == 0 then
		var_15_4 = var_0_3.LEAVEFOR

		if var_15_0 == 1 then
			var_15_5 = string.format("%s%s", gLanguageCsv.gateStory, gLanguageCsv.gate)
		else
			var_15_5 = string.format("%s%s", gLanguageCsv.gateDifficult, gLanguageCsv.gate)
		end
	else
		local var_15_6 = arg_15_0.sectionCsv[var_15_0][var_15_1]

		if var_15_6 then
			var_15_5 = var_15_6.cfg.name
			var_15_4 = var_0_3.LEAVEFOR

			if var_15_2 ~= 0 then
				var_15_5 = var_15_5 .. " " .. var_15_1 .. "-" .. var_15_2
				var_15_4 = var_0_3.NOTOPEN
			end
		end
	end

	return var_15_5, var_15_4
end

function var_0_1.getOtherDescribe(arg_16_0, arg_16_1, arg_16_2)
	return true
end

function var_0_1.checkCanSweep(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0.gateStar:read()

	return var_17_0[arg_17_1] and var_17_0[arg_17_1].star == 3
end

function var_0_1.initModel(arg_18_0)
	arg_18_0.gateStar = gGameModel.role:getIdler("gate_star")
	arg_18_0.roleLv = gGameModel.role:getIdler("level")
	arg_18_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_18_0.stamina = gGameModel.role:getIdler("stamina")
	arg_18_0.buyHerogateTimes = gGameModel.daily_record:getIdler("buy_herogate_times")
	arg_18_0.gateTimes = gGameModel.daily_record:getIdler("gate_times")
	arg_18_0.unionId = gGameModel.role:getIdler("union_db_id")
	arg_18_0.locked = idler.new(0)
	arg_18_0.waySelectDatas = idlertable.new()
end

function var_0_1.setNum(arg_19_0, arg_19_1)
	arg_19_0.num:text(arg_19_1)

	if not arg_19_0:isShowTargetNum() then
		arg_19_0.num1:hide()

		return
	end

	arg_19_0.num1:text("/" .. arg_19_0.targetNum):show()
	adapt.oneLinePos(arg_19_0.num, arg_19_0.num1)

	local var_19_0 = ui.NEWCOLORS.RED1

	if arg_19_1 >= arg_19_0.targetNum then
		var_19_0 = ui.NEWCOLORS.GREEN1
	end

	text.addEffect(arg_19_0.num, {
		color = var_19_0
	})
end

function var_0_1.onWayItemClick(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	if arg_20_3.typ == var_0_3.LEAVEFOR then
		local var_20_0 = csv.card_mega_convert[arg_20_3.id]
		local var_20_1 = dataEasy.isZawakeFragment(arg_20_0.key)

		if var_20_0 then
			local var_20_2 = {
				id = arg_20_3.id,
				num = arg_20_3.targetNum
			}

			jumpEasy.jumpTo(arg_20_3.produceGate, var_20_2)
		elseif var_20_1 then
			local var_20_3 = {
				fragID = arg_20_0.key,
				needNum = arg_20_3.targetNum
			}

			jumpEasy.jumpTo(arg_20_3.produceGate, var_20_3)
		else
			jumpEasy.jumpTo(arg_20_3.produceGate)
		end
	elseif arg_20_3.typ == var_0_3.MOPUP then
		arg_20_0.gateId = arg_20_3.gateId

		arg_20_0:onSweepBtn()
	end
end

function var_0_1.onTimesBtnClick(arg_21_0, arg_21_1)
	local var_21_0 = gVipCsv[gGameModel.role:read("vip_level")].buyHeroGateTimes
	local var_21_1 = arg_21_0.buyHerogateTimes:read()

	if var_21_0 <= (var_21_1[arg_21_0.gateId] or 0) then
		gGameUI:showTip(gLanguageCsv.herogateBuyMax)

		return
	end

	if arg_21_1 > 0 then
		gGameUI:showTip(gLanguageCsv.haveChallengeTimesUnused)

		return
	end

	local var_21_2 = {
		"#C0x5b545b#" .. string.format(gLanguageCsv.resetNumberEliteLevels1, gCostCsv.herogate_buy_cost[(var_21_1[arg_21_0.gateId] or 0) + 1]),
		"#C0x8A5B0C#" .. string.format(gLanguageCsv.resetNumberEliteLevels2, var_21_1[arg_21_0.gateId] or 0, var_21_0)
	}

	gGameUI:showDialog({
		btnType = 2,
		isRich = true,
		content = var_21_2,
		cb = function()
			gGameApp:requestServer("/game/role/hero_gate/buy", function()
				gGameUI:showTip(gLanguageCsv.resetSuccess)
			end, arg_21_0.gateId)
		end,
		dialogParams = {
			clickClose = false
		}
	})
end

function var_0_1.checkSweep(arg_24_0)
	local var_24_0 = csv.scene_conf[arg_24_0.gateId].staminaCost
	local var_24_1 = dataEasy.getStamina()

	if var_24_1 < var_24_0 then
		gGameUI:stackUI("common.gain_stamina")

		return false
	end

	arg_24_0.curMopUpNum = math.min(arg_24_0.mopUpNum, math.floor(var_24_1 / var_24_0))

	local var_24_2 = csv.scene_conf[arg_24_0.gateId].dayChallengeMax

	if arg_24_0.gateTimes:read()[arg_24_0.gateId] then
		var_24_2 = var_24_2 - arg_24_0.gateTimes:read()[arg_24_0.gateId]
	end

	local var_24_3 = arg_24_0.buyHerogateTimes:read()[arg_24_0.gateId] or 0
	local var_24_4, var_24_5, var_24_6 = dataEasy.isDoubleHuodong("heroGateTimes")

	if var_24_4 then
		for iter_24_0, iter_24_1 in pairs(var_24_5) do
			local var_24_7 = iter_24_1.count

			if var_24_7 and var_24_7 > 0 and var_24_3 == 0 then
				var_24_2 = var_24_2 + var_24_7
			end
		end
	end

	if var_24_2 and var_24_2 <= 0 then
		arg_24_0:onTimesBtnClick(var_24_2)

		return false
	end

	return true
end

function var_0_1.onSweepBtn(arg_25_0)
	if not arg_25_0:checkSweep() then
		return
	end

	local var_25_0 = arg_25_0.gateId
	local var_25_1 = arg_25_0.roleLv:read()
	local var_25_2 = gGameModel.capture:read("limit_sprites")

	gGameApp:requestServer("/game/saodang", function(arg_26_0)
		local var_26_0 = arg_26_0.view.result

		table.insert(var_26_0, {
			exp = 0,
			isExtra = true,
			items = arg_26_0.view.extra
		})
		gGameUI:stackUI("city.gate.sweep", nil, nil, {
			from = "gainWay",
			hasExtra = true,
			sweepData = var_26_0,
			oldRoleLv = var_25_1,
			cb = arg_25_0:createHandler("onSweepBtn"),
			checkCb = arg_25_0:createHandler("checkSweep"),
			targetNum = arg_25_0.targetNum,
			targetId = arg_25_0.key,
			oldCapture = var_25_2,
			gateId = var_25_0,
			curMopUpNum = arg_25_0.curMopUpNum,
			isDouble = dataEasy.isGateIdDoubleDrop(var_25_0),
			catchup = arg_26_0.view.catchup
		})
	end, var_25_0, arg_25_0.curMopUpNum, arg_25_0.key, arg_25_0.targetNum and arg_25_0.targetNum - dataEasy.getNumByKey(arg_25_0.key))

	return true
end

function var_0_1.onSortMenusBtnClick(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	local var_27_0 = var_0_7[arg_27_0.chapterType]
	local var_27_1 = dataEasy.getSaoDangState(var_27_0[arg_27_3])

	if not var_27_1.canSaoDang then
		gGameUI:showTip(var_27_1.tip)

		return
	end

	arg_27_0.mopUpNum = var_27_0[arg_27_3]

	userDefault.setForeverLocalKey(var_0_8[arg_27_0.chapterType], arg_27_3)
end

function var_0_1.onClose(arg_28_0)
	arg_28_0:addCallbackOnExit(arg_28_0.cb)
	var_0_0.onClose(arg_28_0)
end

return var_0_1
