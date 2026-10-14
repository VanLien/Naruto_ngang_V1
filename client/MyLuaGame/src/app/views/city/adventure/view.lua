local var_0_0 = require("app.views.city.adventure.dispatch_task.view")
local var_0_1 = {
	dispatchTask = {
		specialTag = "dispatchTask"
	},
	randomTower = {
		specialTag = "randomTower"
	},
	arena = {
		specialTag = "arenaAward"
	},
	crossArena = {
		specialTag = "crossArenaAward"
	},
	onlineFight = {
		specialTag = "onlineFightAward"
	},
	gym = {
		specialTag = "gymChallenge"
	},
	cloneBattle = {
		specialTag = "cloneBattle"
	},
	normalBraveChallenge = {
		specialTag = "braveChallengeAch",
		listenData = {
			sign = game.BRAVE_CHALLENGE_TYPE.common
		}
	},
	mimicry = {
		specialTag = {
			"mimicry"
		}
	}
}
local var_0_2 = {
	endlessTower = {
		res = "common/icon/double/label_sdsb.png",
		key = "endlessSaodang"
	},
	randomTower = {
		res = "common/icon/double/label_jbsb.png",
		key = "randomGold"
	}
}

local function var_0_3(arg_1_0)
	if not arg_1_0 then
		return
	end

	return loadstring("return " .. arg_1_0)()
end

local function var_0_4(arg_2_0)
	if arg_2_0.unlockFeature == "" then
		return "functionError", gLanguageCsv.comingSoon
	end

	if not dataEasy.isInServer(arg_2_0.unlockFeature) then
		return "serverError", gLanguageCsv.comingSoon
	end

	if arg_2_0.serverDayInfo then
		local var_2_0 = false
		local var_2_1 = 0

		if arg_2_0.serverDayInfo.funcType == "less" then
			var_2_1 = var_0_3(arg_2_0.serverDayInfo.sevCsv)
			var_2_0 = dataEasy.serverOpenDaysLess(var_2_1)
		end

		if var_2_0 then
			return "openSevError", string.format(gLanguageCsv.unlockServerOpen, var_2_1)
		end
	end

	if not dataEasy.isUnlock(gUnlockCsv[arg_2_0.unlockFeature]) then
		return "unlockError", dataEasy.getUnlockTip(gUnlockCsv[arg_2_0.unlockFeature])
	end

	if arg_2_0.unlockFeature == "unionFight" then
		if not gGameModel.role:read("union_db_id") then
			return "unionError", gLanguageCsv.nonunion
		end

		if gGameModel.role:read("union_level") < gUnionFeatureCsv[arg_2_0.unlockFeature] then
			return "unionError", string.format(gLanguageCsv.unlockUnionLevel, gUnionFeatureCsv[arg_2_0.unlockFeature])
		end

		if dataEasy.notUseUnionBuild() then
			return "unionQuitToday", gLanguageCsv.unlockUnionQuit
		end
	end

	return "succ"
end

local function var_0_5(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_1:get("baseNode.imgBG"):texture(arg_3_2.cfg.lockbg1)

	if var_0_1[arg_3_2.cfg.unlockFeature] then
		performWithDelay(arg_3_1, function()
			local var_4_0 = var_0_1[arg_3_2.cfg.unlockFeature]

			function var_4_0.onNode(arg_5_0)
				arg_5_0:xy(arg_3_3)
				arg_5_0:scale(1.3)
			end

			bind.extend(arg_3_0, arg_3_1:get("baseNode"), {
				class = "red_hint",
				props = var_4_0
			})
		end, 0)
	end

	bind.touch(arg_3_0, arg_3_1, {
		methods = {
			ended = functools.partial(arg_3_0.clickCell, arg_3_2)
		}
	})

	local var_3_0, var_3_1 = var_0_4(arg_3_2.cfg)

	arg_3_1:get("baseNode.black"):visible(var_3_0 ~= "succ")

	if var_3_0 ~= "succ" then
		if arg_3_1:get("baseNode.black.imgTextBG") then
			arg_3_1:get("baseNode.black.imgTextBG"):hide()
		end

		if arg_3_1:get("baseNode.black.textNote") then
			arg_3_1:get("baseNode.black.textNote"):hide()
		end

		arg_3_1:get("baseNode.black.imgBlack"):texture(arg_3_2.cfg.maskbg)

		local var_3_2 = arg_3_1:get("baseNode.black.lockPanel.imgLock")
		local var_3_3 = arg_3_1:get("baseNode.black.lockPanel.textNote")
		local var_3_4 = var_3_1

		if var_3_0 == "unlockError" then
			local var_3_5 = gUnlockCsv[arg_3_2.cfg.unlockFeature]

			var_3_4 = string.format(gLanguageCsv.lvToUnlock, csv.unlock[var_3_5].startLevel)
		end

		var_3_3:text(var_3_4)
		adapt.setTextScaleWithWidth(var_3_3, nil, 550)

		local var_3_6 = arg_3_1:get("baseNode.black.lockPanel"):size()

		adapt.oneLineCenterPos(cc.p(var_3_6.width / 2, var_3_6.height / 2), {
			var_3_2,
			var_3_3
		}, cc.p(15, 0))
	end
end

local var_0_6 = class("AdventureView", cc.load("mvc").ViewBase)

var_0_6.RESOURCE_FILENAME = "adventure.json"
var_0_6.RESOURCE_BINDING = {
	pvpItem = "pvpItem",
	item = "item",
	bg = "bg",
	bg_pve = "bg_pve",
	list = {
		varname = "pveList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				padding = 38,
				data = bindHelper.self("activityDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					arg_6_1:setName(arg_6_3.cfg.unlockFeature)

					local var_6_0 = arg_6_3.cfg

					arg_6_1:get("baseNode.textDesc"):text(var_6_0.desc)

					local var_6_1 = var_0_2[arg_6_3.cfg.unlockFeature]

					if var_6_1 then
						local var_6_2, var_6_3 = dataEasy.isDoubleHuodong(var_6_1.key)

						arg_6_1:get("baseNode.flagImg"):visible(var_6_2)
						arg_6_1:get("baseNode.flagImg"):texture(var_6_1.res)
					end

					var_0_5(arg_6_0, arg_6_1, arg_6_3, cc.p(700, 1020), "", cc.p(325, 558))

					if arg_6_3.cfg.unlockFeature == "activityGate" then
						local var_6_4, var_6_5 = dataEasy.isShowDailyActivityIcon()

						if var_6_4 then
							if arg_6_1:getChildByName("_icon_") then
								return
							end

							local var_6_6 = var_6_5.paramMap
							local var_6_7 = ccui.ImageView:create(var_6_6.fbwkRes):xy(arg_6_1:width() / 2 - 34, arg_6_1:height() / 2 + 10):scale(2):addTo(arg_6_1, 999, "_icon_")
						else
							local var_6_8 = arg_6_1:getChildByName("_icon_")

							if var_6_8 then
								var_6_8:removeFromParent()
							end
						end
					end

					if arg_6_3.cfg.unlockFeature == "fishing" then
						local var_6_9 = ccui.ImageView:create("city/adventure/fishing/logo_dy_dydsrk.png"):anchorPoint(0, 1):xy(23, arg_6_1:height() + 5):addTo(arg_6_1:get("baseNode"), 5)
						local var_6_10 = gGameModel.role:getIdler("cross_fishing_round")

						idlereasy.when(var_6_10, function(arg_7_0, arg_7_1)
							var_6_9:visible(arg_7_1 == "start")
						end):anonyOnly(arg_6_1)
					end
				end,
				onAfterBuild = function(arg_8_0)
					arg_8_0:setItemAlignCenter()
					performWithDelay(arg_8_0, function()
						local var_9_0, var_9_1 = gGameUI.guideManager:isInGuiding()

						if var_9_0 then
							local var_9_2 = csv.new_guide[var_9_1].jumpToNode

							if var_9_2 then
								for iter_9_0, iter_9_1 in pairs(arg_8_0:getChildren()) do
									if iter_9_1:getName() == var_9_2 then
										arg_8_0:jumpToItem(arg_8_0:getIndex(iter_9_1), cc.p(0.5, 0.5), cc.p(0.5, 0.5))

										break
									end
								end
							end
						end
					end, 0)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	},
	pvpList = {
		varname = "pvpList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				padding = 110,
				data = bindHelper.self("pvpDatas"),
				item = bindHelper.self("pvpItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
					arg_10_1:setName(arg_10_3.cfg.unlockFeature)
					var_0_5(arg_10_0, arg_10_1, arg_10_3, cc.p(700, 1060), "", cc.p(354, 552))
				end,
				onAfterBuild = function(arg_11_0)
					arg_11_0:setItemAlignCenter()
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	}
}

local var_0_7 = {
	activityGate = {
		viewName = "city.adventure.daily_activity.view",
		styles = {
			full = true
		},
		func = function(arg_12_0)
			gGameApp:requestServer("/game/huodong/show", function(arg_13_0)
				arg_12_0("", arg_13_0.view)
			end)
		end
	},
	endlessTower = {
		viewName = "city.adventure.endless_tower.view",
		styles = {
			full = true
		}
	},
	dispatchTask = {
		viewName = "city.adventure.dispatch_task.view",
		styles = {
			full = true
		},
		func = function(arg_14_0)
			gGameApp:requestServer("/game/dispatch/task/refresh", function(arg_15_0)
				arg_14_0()
			end, false)
		end
	},
	randomTower = {
		viewName = "city.adventure.random_tower.view",
		styles = {
			full = true
		},
		func = function(arg_16_0)
			gGameApp:requestServer("/game/random_tower/prepare", function(arg_17_0)
				if arg_17_0.view.point_award_update then
					userDefault.setForeverLocalKey("isGetAward", {})
					userDefault.setForeverLocalKey("saveGetAward", {})
					userDefault.setForeverLocalKey("awardState", {
						isOpen = true
					})
				else
					userDefault.setForeverLocalKey("awardState", {})
				end

				arg_16_0()
			end)
		end
	},
	arena = {
		viewName = "city.pvp.arena.view",
		styles = {
			full = true
		},
		func = function(arg_18_0)
			gGameApp:requestServer("/game/pw/battle/get", function(arg_19_0)
				arg_18_0()
			end)
		end
	},
	craft = {
		viewName = "city.pvp.craft.view",
		styles = {
			full = true
		},
		func = function(arg_20_0)
			gGameApp:requestServer("/game/craft/battle/main", function(arg_21_0)
				local var_21_0 = gGameModel.craft:read("round")

				if var_21_0 == "over" or var_21_0 == "closed" or var_21_0 == "signup" then
					arg_20_0()
				else
					gGameUI:stackUI("city.pvp.craft.myschedule", nil, {
						full = true
					})
				end
			end)
		end
	},
	cloneBattle = {
		viewName = "city.adventure.clone_battle.base",
		styles = {
			full = true
		},
		func = function(arg_22_0)
			gGameApp:requestServer("/game/clone/get", function(arg_23_0)
				arg_22_0(arg_23_0.view)
			end)
		end
	},
	unionFight = {
		viewName = "city.union.union_fight.view",
		styles = {
			full = true
		},
		func = function(arg_24_0)
			gGameApp:requestServer("/game/union/fight/battle/main", function(arg_25_0)
				arg_24_0()
			end)
		end
	},
	crossCraft = {
		viewName = "city.pvp.cross_craft.view",
		styles = {
			full = true
		},
		func = function(arg_26_0)
			jumpEasy.jumpTo("crossCraft")
		end
	},
	crossArena = {
		viewName = "city.pvp.cross_arena.view",
		styles = {
			full = true
		},
		func = function(arg_27_0)
			jumpEasy.jumpTo("crossArena")
		end
	},
	crossMine = {
		viewName = "city.pvp.cross_mine.view",
		styles = {
			full = true
		},
		func = function(arg_28_0)
			jumpEasy.jumpTo("crossMine")
		end
	},
	fishing = {
		viewName = "city.adventure.fishing.sence_select",
		styles = {
			full = true
		}
	},
	onlineFight = {
		viewName = "city.pvp.online_fight.view",
		styles = {
			full = true
		},
		func = function(arg_29_0)
			jumpEasy.jumpTo("onlineFight")
		end
	},
	gymChallenge = {
		viewName = "city.adventure.gym_challenge.view",
		styles = {
			full = true
		},
		func = function(arg_30_0)
			jumpEasy.jumpTo("gymChallenge")
		end
	},
	hunting = {
		func = function(arg_31_0)
			jumpEasy.jumpTo("hunting")
		end
	},
	normalBraveChallenge = {
		func = function(arg_32_0)
			jumpEasy.jumpTo("normalBraveChallenge")
		end
	},
	mimicry = {
		viewName = "city.adventure.mimicry.view",
		styles = {
			full = true
		},
		func = function(arg_33_0)
			jumpEasy.jumpTo("mimicry")
		end
	}
}

function var_0_6.onCreate(arg_34_0, arg_34_1)
	adapt.centerWithScreen({
		"left",
		nil,
		false
	}, {
		"right",
		nil,
		false
	}, nil, {
		{
			arg_34_0.pveList,
			"width"
		},
		{
			arg_34_0.pveList,
			"pos",
			"left"
		},
		{
			arg_34_0.pvpList,
			"width"
		},
		{
			arg_34_0.pvpList,
			"pos",
			"left"
		}
	})

	arg_34_1 = arg_34_1 or "pve"

	arg_34_0.pveList:visible(arg_34_1 == "pve")
	arg_34_0.pvpList:visible(arg_34_1 == "pvp")

	local var_34_0 = "common/txt/txt_bt_maoxian.png"
	local var_34_1 = "ADVENTURE"

	if arg_34_1 == "pvp" then
		arg_34_0.bg:visible(true)
		arg_34_0.bg_pve:visible(false)

		var_34_0 = "common/txt/txt_bt_jingji.png"
		var_34_1 = "COMPETITION"
	else
		arg_34_0.bg:visible(false)
		arg_34_0.bg_pve:visible(true)

		local var_34_2 = arg_34_0:getResourceNode()
	end

	gGameUI.topuiManager:createView("default", arg_34_0, {
		onClose = arg_34_0:createHandler("onClose")
	}):init({
		title = var_34_0,
		subTitle = var_34_1
	})

	arg_34_0.activityDatas = {}
	arg_34_0.pvpDatas = {}
	arg_34_0.data = idlers.newWithMap({})

	if arg_34_1 == "pve" then
		arg_34_0.activityDatas = arg_34_0.data
	elseif arg_34_1 == "pvp" then
		arg_34_0.pvpDatas = arg_34_0.data
	end

	local var_34_3 = {}

	local function var_34_4(arg_35_0, arg_35_1)
		var_34_3[arg_35_0] = arg_35_1

		local var_35_0 = {}

		for iter_35_0, iter_35_1 in pairs(var_34_3) do
			if iter_35_1 == true then
				local var_35_1 = csv.pvpandpve[iter_35_0]

				table.insert(var_35_0, {
					cfg = var_35_1,
					unlockKey = var_35_1.unlockFeature,
					viewData = var_0_7[var_35_1.goTo]
				})
			end
		end

		table.sort(var_35_0, function(arg_36_0, arg_36_1)
			return arg_36_0.cfg.sortIndex < arg_36_1.cfg.sortIndex
		end)
		arg_34_0.data:update(var_35_0)
	end

	for iter_34_0, iter_34_1 in orderCsvPairs(csv.pvpandpve) do
		if iter_34_1.type == arg_34_1 and iter_34_1.flag == 0 then
			local var_34_5 = gUnlockCsv[iter_34_1.unlockFeature]

			if iter_34_1.unlockFeature == "" then
				var_34_4(iter_34_0, true)
			else
				dataEasy.getListenShow(var_34_5, functools.partial(var_34_4, iter_34_0))
			end
		end
	end

	dataEasy.getListenUnlock(gUnlockCsv.dispatchTask, function(arg_37_0)
		if arg_37_0 then
			var_0_0.setRefreshTime(arg_34_0, nil, {
				tag = "dispatchTaskRefresh",
				cb = function()
					gGameModel.forever_dispatch:getIdlerOrigin("dispatchTasksRedHintRefrseh"):modify(function(arg_39_0)
						return true, not arg_39_0
					end)
				end
			})
		end
	end)
end

function var_0_6.onItemClick(arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = arg_40_2.cfg
	local var_40_1, var_40_2 = var_0_4(var_40_0)

	if var_40_1 ~= "succ" then
		gGameUI:showTip(var_40_2)

		return
	end

	if arg_40_2.unlockKey ~= "" and not dataEasy.isUnlock(arg_40_2.unlockKey) then
		gGameUI:showTip(dataEasy.getUnlockTip(arg_40_2.unlockKey))

		return
	end

	local var_40_3 = arg_40_2.viewData

	if not var_40_3 then
		return
	end

	if var_40_3.func then
		var_40_3.func(function(...)
			local var_41_0 = clone(var_40_3.params or {})

			for iter_41_0, iter_41_1 in ipairs({
				...
			}) do
				table.insert(var_41_0, iter_41_1)
			end

			gGameUI:stackUI(var_40_3.viewName, nil, var_40_3.styles, unpack(var_41_0))
		end)
	elseif var_40_3.viewName then
		gGameUI:stackUI(var_40_3.viewName, nil, var_40_3.styles, unpack(var_40_3.params or {}))
	end
end

return var_0_6
