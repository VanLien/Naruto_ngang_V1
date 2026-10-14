local var_0_0 = {
	SSS = 3,
	S = 1,
	SS = 2
}
local var_0_1 = 3
local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("ActivityBossView", var_0_2)

var_0_3.RESOURCE_FILENAME = "activity_boss.json"
var_0_3.RESOURCE_BINDING = {
	["leftPanel.item"] = "bossItem",
	["centerPanel.discover"] = "discover",
	["leftPanel.myChallengeTimesNum"] = "myChallengeTimesNum",
	["centerPanel.escapeTime"] = "escapeTime",
	["centerPanel.escapeTip"] = "escapeTip",
	["rightPanel.drop.item"] = "dropItem",
	["centerPanel.spine"] = "cardSpine",
	["rightPanel.enemy.subList"] = "subList",
	centerPanel = "centerPanel",
	["centerPanel.escapeTip2"] = "escapeTip2",
	bg = "bg",
	["rightPanel.hasChallenged"] = "hasChallenged",
	["rightPanel.effect.textList"] = "effectText",
	noBoss = "noBoss",
	["rightPanel.timesNum"] = "timesNum",
	["leftPanel.item.pos"] = "pos",
	title = "title",
	leftPanel = "leftPanel",
	["noBoss.noBossImg"] = "noBossImg",
	["rightPanel.enemy.item"] = "enemyItem",
	["leftPanel.item.challenged"] = "challenged",
	["centerPanel.bossAppearText"] = "bossAppearText",
	rightPanel = "rightPanel",
	btnRule = {
		varname = "rule",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRule")
			}
		}
	},
	["leftPanel.myChallengeTimesText"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(58, 31, 47, 255)
				}
			}
		}
	},
	["leftPanel.item.ChallengeTimesText"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(96, 86, 94, 255)
				}
			}
		}
	},
	["leftPanel.item.timeText"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(96, 86, 94, 255)
				}
			}
		}
	},
	["leftPanel.item.discover"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(96, 86, 94, 255)
				}
			}
		}
	},
	["leftPanel.item.discoverName"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(96, 86, 94, 255)
				}
			}
		}
	},
	["leftPanel.item.myBoss"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(241, 62, 86, 255)
				}
			}
		}
	},
	["leftPanel.bossList"] = {
		varname = "bossList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("bossDatas"),
				item = bindHelper.self("bossItem"),
				itemAction = {
					isAction = true
				},
				onBeforeBuild = function(arg_1_0)
					arg_1_0:setRenderHint(0)
				end,
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					arg_2_1:get("bgK"):visible(arg_2_3.isSel == true)
					arg_2_1:get("new"):visible(false)
					arg_2_1:get("myBoss"):visible(arg_2_3.myBoss)
					arg_2_1:get("challenged"):visible(arg_2_3.myBoss == true and arg_2_3.ownerWin == true)
					arg_2_1:get("discoverName"):text(getServerArea(arg_2_3.gameKey) .. " " .. arg_2_3.discoverName)
					arg_2_1:get("ChallengeTimesNum"):text(arg_2_3.remainTime .. "/" .. arg_2_3.maxTimes)
					arg_2_1:get("pos"):get("img"):xy(arg_2_1:get("pos"):get("img"):x() + arg_2_3.posX, arg_2_1:get("pos"):get("img"):y() + arg_2_3.posY)
					arg_2_1:get("pos"):get("img"):scale(arg_2_3.scale)
					adapt.oneLinePos(arg_2_1:get("discoverName"), arg_2_1:get("discover"), cc.p(5, 0))

					if arg_2_3.hardDegree == var_0_0.S then
						arg_2_1:get("degreeImg"):texture("activity/activity_boss/icon_wsj_s.png")
					elseif arg_2_3.hardDegree == var_0_0.SS then
						arg_2_1:get("degreeImg"):texture("activity/activity_boss/icon_wsj_ss.png")
					elseif arg_2_3.hardDegree == var_0_0.SSS then
						arg_2_1:get("degreeImg"):texture("activity/activity_boss/icon_wsj_sss.png")
					end

					arg_2_1:get("degreeImg"):x(arg_2_1:get("degreeImg"):x() + arg_2_3.hardDegree * 10)
					bind.extend(arg_2_0, arg_2_1:get("timeNum"), {
						class = "cutdown_label",
						props = {
							time = arg_2_3.endTime - time.getTime(),
							endFunc = function()
								return
							end
						}
					})
					adapt.oneLinePos(arg_2_1:get("ChallengeTimesNum"), arg_2_1:get("ChallengeTimesText"), nil, "right")
					adapt.oneLinePos(arg_2_1:get("timeNum"), arg_2_1:get("timeText"), nil, "right")

					local var_2_0 = csv.scene_conf[arg_2_3.gateId]
					local var_2_1 = csv.unit[var_2_0.boss[1].unitId]

					arg_2_1:get("pos"):get("img"):texture(var_2_1.cardShow)
					bind.touch(arg_2_0, arg_2_1, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBossItemClick")
			}
		}
	},
	["leftPanel.btnRefresh"] = {
		varname = "btnRefresh",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRefresh")
			}
		}
	},
	["rightPanel.effect.titleBg.titleText"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(54, 0, 0, 255)
				}
			}
		}
	},
	["rightPanel.enemy.titleText"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(54, 0, 0, 255)
				}
			}
		}
	},
	["rightPanel.enemy.list"] = {
		varname = "enemyList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				topPadding = 20,
				data = bindHelper.self("enemyData"),
				columnSize = var_0_1,
				item = bindHelper.self("subList"),
				cell = bindHelper.self("enemyItem"),
				onCell = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					bind.extend(arg_4_0, arg_4_1, {
						class = "card_icon",
						props = {
							showAttribute = true,
							unitId = arg_4_3.id,
							advance = arg_4_3.advance,
							rarity = arg_4_3.rarity,
							levelProps = {
								data = arg_4_3.level
							},
							isBoss = arg_4_3.isBoss,
							onNode = function(arg_5_0)
								arg_4_1:scale(0.9)
							end
						}
					})
				end
			}
		}
	},
	["rightPanel.drop.titleText"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(54, 0, 0, 255)
				}
			}
		}
	},
	["rightPanel.drop.list"] = {
		varname = "dropList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("dropDatas"),
				item = bindHelper.self("dropItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					bind.extend(arg_6_0, arg_6_1, {
						class = "icon_key",
						props = {
							data = {
								key = arg_6_3.key,
								num = arg_6_3.num
							},
							onNode = function(arg_7_0)
								arg_7_0:scale(0.7)
							end
						}
					})
				end
			}
		}
	},
	["rightPanel.btnPlayer"] = {
		varname = "btnPlayer",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClearance")
			}
		}
	},
	["rightPanel.btnChallenge"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChallenge")
			}
		}
	},
	["rightPanel.btnChallenge.text"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	}
}

function var_0_3.onCreate(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0.data = arg_8_0.data or arg_8_2
	arg_8_0.activityId = arg_8_1

	arg_8_0:initModel()

	arg_8_0.topView = gGameUI.topuiManager:createView("default", arg_8_0, {
		onClose = arg_8_0:createHandler("onClose")
	}):init({
		subTitle = "ACTIVITYBOSS",
		title = gLanguageCsv.huodongBoss
	})

	local var_8_0 = csv.yunying.yyhuodong[arg_8_1]

	arg_8_0.huodongID = var_8_0.huodongID
	arg_8_0.yyData = arg_8_0.yyhuodongs[arg_8_1] or {}
	arg_8_0.yyCfg = var_8_0
	arg_8_0.selIdx = idler.new(1)
	arg_8_0.bossDatas = idlers.newWithMap({})
	arg_8_0.dropDatas = idlers.newWithMap({})
	arg_8_0.enemyData = idlers.newWithMap({})
	arg_8_0.minTime = idler.new(0)

	arg_8_0:initBossList(arg_8_0.data)
	arg_8_0.selIdx:addListener(function(arg_9_0, arg_9_1)
		if arg_8_0.bossDatas:atproxy(arg_9_1) then
			arg_8_0.bossDatas:atproxy(arg_9_1).isSel = false
		end

		if arg_8_0.bossDatas:atproxy(arg_9_0) then
			arg_8_0.bossDatas:atproxy(arg_9_0).isSel = true

			arg_8_0:initRightPanel(arg_9_0)
		end
	end)

	if arg_8_0.count ~= 0 then
		local var_8_1 = math.min(arg_8_0.count, arg_8_0.selIdx:read())

		arg_8_0.selIdx:set(var_8_1, true)
	end

	arg_8_0.minTime:addListener(function(arg_10_0, arg_10_1)
		arg_8_0:enableSchedule():unSchedule(100)

		local var_10_0 = arg_8_0.minTime:read() - time.getTime()

		arg_8_0:schedule(function()
			var_10_0 = var_10_0 - 1

			if var_10_0 <= 0 then
				arg_8_0:onRefresh()

				return false
			end
		end, 1, 1, 100)
	end)

	if arg_8_0.challenge == true then
		arg_8_0.challenge = false

		arg_8_0:onRefresh(function()
			local var_12_0 = arg_8_0.selIdx:read()

			if arg_8_0.bossDatas:atproxy(var_12_0) then
				arg_8_0:initRightPanel(arg_8_0.selIdx:read())
			end
		end)
	end
end

function var_0_3.initModel(arg_13_0)
	arg_13_0.yyhuodongs = gGameModel.role:read("yyhuodongs")
	arg_13_0.id = gGameModel.role:read("id")
end

function var_0_3.initBossList(arg_14_0, arg_14_1)
	arg_14_0.data = arg_14_1
	arg_14_0.count = #arg_14_1.view.huodongboss

	arg_14_0.noBoss:visible(true)
	arg_14_0.leftPanel:visible(false)
	arg_14_0.centerPanel:visible(false)
	arg_14_0.rightPanel:visible(false)

	if #arg_14_1.view.huodongboss > 0 then
		local var_14_0 = {}

		for iter_14_0, iter_14_1 in ipairs(arg_14_1.view.huodongboss) do
			local var_14_1 = csv.yunying.huodongboss[iter_14_1.gate_id]
			local var_14_2 = 0
			local var_14_3
			local var_14_4 = {}

			if not iter_14_1.win_roles then
				var_14_2 = var_14_1.times
				var_14_3 = false
			else
				var_14_3 = true
				var_14_2 = var_14_1.times - #iter_14_1.win_roles
				var_14_4 = iter_14_1.win_roles
			end

			if iter_14_1.owner.role_id == arg_14_0.id and iter_14_1.owner_win then
				table.insert(var_14_4, {
					name = gGameModel.role:read("name"),
					level = gGameModel.role:read("level"),
					frame = gGameModel.role:read("frame"),
					logo = gGameModel.role:read("logo"),
					fight_point = gGameModel.role:read("top6_fighting_point"),
					game_key = gGameApp.serverInfo.key
				})
			end

			local var_14_5 = false

			if #iter_14_1.win_roles > 0 then
				for iter_14_2, iter_14_3 in ipairs(iter_14_1.win_roles) do
					if iter_14_3.role_id == arg_14_0.id then
						var_14_5 = true
					end
				end
			end

			if var_14_2 == 0 and iter_14_1.owner.role_id ~= arg_14_0.id then
				var_14_5 = true
			end

			local function var_14_6(arg_15_0, arg_15_1)
				local var_15_0 = {}

				for iter_15_0, iter_15_1 in ipairs(arg_15_0) do
					local var_15_1 = csv.unit[iter_15_1.unitId]

					table.insert(var_15_0, {
						id = iter_15_1.unitId,
						level = iter_15_1.level,
						advance = iter_15_1.advance,
						rarity = var_15_1.rarity,
						isBoss = arg_15_1
					})
				end

				table.sort(var_15_0, function(arg_16_0, arg_16_1)
					return arg_16_0.advance > arg_16_1.advance
				end)

				return var_15_0
			end

			local var_14_7 = csv.scene_conf[iter_14_1.gate_id]
			local var_14_8 = var_14_6(var_14_7.boss, true)
			local var_14_9 = var_14_6(var_14_7.monsters, false)
			local var_14_10 = arraytools.merge({
				var_14_8,
				var_14_9
			})
			local var_14_11 = time.getTime() - iter_14_1.start_time < gCommonConfigCsv.huodongbossNewTimes * 60

			if var_14_5 == false then
				table.insert(var_14_0, {
					gateId = iter_14_1.gate_id,
					uId = iter_14_1.uid,
					startTime = iter_14_1.start_time,
					endTime = iter_14_1.start_time + var_14_1.timeLimit * 60,
					maxTimes = var_14_1.times,
					remainTime = var_14_2,
					hardDegree = var_14_1.hardDegree,
					posX = var_14_1.posX,
					posY = var_14_1.posY,
					scale = var_14_1.scale,
					myBoss = iter_14_1.owner.role_id == arg_14_0.id,
					discoverName = iter_14_1.owner.name,
					haveWinRole = var_14_3,
					winRoles = var_14_4,
					ownerWin = iter_14_1.owner_win,
					hasChallenge = var_14_5,
					enemyData = var_14_10,
					new = var_14_11,
					posX = var_14_1.posX,
					posY = var_14_1.posY,
					scale = var_14_1.scale,
					gameKey = iter_14_1.owner.game_key
				})
			end
		end

		if #var_14_0 <= 0 then
			arg_14_0.bossDatas:update(var_14_0)

			return
		end

		arg_14_0.noBoss:visible(false)
		arg_14_0.leftPanel:visible(true)
		arg_14_0.centerPanel:visible(true)
		arg_14_0.rightPanel:visible(true)

		local var_14_12 = var_14_0[1].endTime

		for iter_14_4 = 1, #var_14_0 do
			var_14_12 = math.min(var_14_12, var_14_0[iter_14_4].endTime)
		end

		arg_14_0.minTime:set(var_14_12)
		table.sort(var_14_0, function(arg_17_0, arg_17_1)
			if arg_17_0.myBoss ~= arg_17_1.myBoss then
				return arg_17_0.myBoss == true
			end

			if arg_17_0.startTime ~= arg_17_1.startTime then
				return arg_17_0.startTime < arg_17_1.startTime
			end

			if arg_17_0.remainTime ~= arg_17_1.remainTime then
				return arg_17_0.remainTime > arg_17_1.remainTime
			end

			return arg_17_0.gateId > arg_17_1.gateId
		end)
		dataEasy.tryCallFunc(arg_14_0.bossList, "updatePreloadCenterIndex")
		arg_14_0.bossDatas:update(var_14_0)

		local var_14_13 = math.min(arg_14_0.count, arg_14_0.selIdx:read())

		arg_14_0.selIdx:set(var_14_13, true)

		local var_14_14 = gGameModel.daily_record:read("huodong_boss_times")
		local var_14_15 = csv.yunying.huodongboss_config[arg_14_1.view.csv_id].dailyChallengeLimit

		arg_14_0.myChallengeTimesNum:text(var_14_15 - var_14_14 .. "/" .. var_14_15)
	end
end

function var_0_3.onRefresh(arg_18_0, arg_18_1)
	gGameApp:requestServer("/game/yy/huodongboss/list", function(arg_19_0)
		arg_18_0:initBossList(arg_19_0)

		if type(arg_18_1) == "function" then
			arg_18_1()
		end
	end, arg_18_0.activityId, gCommonConfigCsv.huodongbossMaxNumber)
end

function var_0_3.onRule(arg_20_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_20_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_3.getRuleContext(arg_21_0, arg_21_1)
	local var_21_0 = adaptContext

	return {
		var_21_0.clone(arg_21_1.title, function(arg_22_0)
			arg_22_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_21_0.noteText(151),
		var_21_0.noteText(107001, 107007)
	}
end

function var_0_3.onClearance(arg_23_0)
	local var_23_0 = {}

	if arg_23_0.bossDatas:atproxy(arg_23_0.selIdx:read()).haveWinRole then
		var_23_0 = arg_23_0.bossDatas:atproxy(arg_23_0.selIdx:read()).winRoles
	end

	gGameUI:stackUI("city.activity.activity_boss.clearance", nil, nil, table.shallowcopy(var_23_0))
end

function var_0_3.onChallenge(arg_24_0)
	local var_24_0 = gGameModel.daily_record:read("huodong_boss_times")
	local var_24_1 = csv.yunying.huodongboss_config[arg_24_0.data.view.csv_id].dailyChallengeLimit
	local var_24_2 = arg_24_0.selIdx:read()
	local var_24_3 = arg_24_0.bossDatas:atproxy(var_24_2)

	if var_24_3.myBoss and var_24_3.ownerWin then
		gGameUI:showTip(gLanguageCsv.huoDongBossChallenged)

		return
	end

	if var_24_1 - var_24_0 == 0 and var_24_3.myBoss == false then
		gGameUI:showTip(gLanguageCsv.bossDailyChallengeLimit)

		return
	end

	local var_24_4 = var_24_3.uId

	arg_24_0.challenge = true

	local function var_24_5(arg_25_0, arg_25_1)
		gGameApp:requestServer("/game/yy/huodongboss/list", function(arg_26_0)
			arg_24_0:initBossList(arg_26_0)

			for iter_26_0, iter_26_1 in arg_24_0.bossDatas:ipairs() do
				if var_24_4 == iter_26_1:read().uId then
					local var_26_0 = arg_25_1:read()
					local var_26_1 = arg_24_0.activityId

					battleEntrance.battleRequest("/game/yy/huodongboss/battle/start", var_26_0, var_24_4, var_26_1):onStartOK(function(arg_27_0)
						arg_27_0.activityID = var_26_1
						arg_27_0.idx = var_24_4

						if arg_25_0 then
							arg_25_0:onClose(false)

							arg_25_0 = nil
						end
					end):show()

					return
				end
			end

			arg_25_0:onClose(false)
			gGameUI:showTip(gLanguageCsv.huoDongBossNotExist)
		end, arg_24_0.activityId, gCommonConfigCsv.huodongbossMaxNumber)
	end

	gGameUI:stackUI("city.activity.activity_boss.embattle", nil, {
		full = true
	}, {
		from = game.EMBATTLE_FROM_TABLE.huodongBoss,
		fightCb = var_24_5
	})
end

function var_0_3.initRightPanel(arg_28_0, arg_28_1)
	local var_28_0 = csv.scene_conf[arg_28_0.bossDatas:atproxy(arg_28_1).gateId]
	local var_28_1 = csv.unit[var_28_0.boss[1].unitId]

	arg_28_0.bossAppearText:text(var_28_0.sceneName .. gLanguageCsv.huodongBossAppear)
	beauty.textScroll({
		isRich = true,
		fontSize = 35,
		list = arg_28_0.effectText,
		strs = {
			verticalSpace = 5,
			str = "#C0xFFFCED#" .. var_28_0.desc
		}
	})

	if matchLanguage({
		"kr",
		"en"
	}) then
		arg_28_0.rightPanel:get("effect.titleBg"):size(250, 60)
		arg_28_0.rightPanel:get("enemy.titleBg"):size(250, 60)
		arg_28_0.rightPanel:get("drop.titleBg"):size(250, 60)
	end

	local var_28_2 = arg_28_0.cardSpine:size()

	arg_28_0.cardSpine:removeAllChildren()
	widget.addAnimation(arg_28_0.cardSpine, var_28_1.unitRes, "standby_loop", 5):xy(var_28_2.width / 2, 100):scale(var_28_1.scaleU * 3):setSkin(var_28_1.skin)

	local var_28_3 = {}

	for iter_28_0, iter_28_1 in ipairs(arg_28_0.bossDatas:atproxy(arg_28_1).enemyData) do
		table.insert(var_28_3, {
			id = iter_28_1.id,
			level = iter_28_1.level,
			advance = iter_28_1.advance,
			rarity = iter_28_1.rarity
		})
	end

	arg_28_0.enemyData:update(var_28_3)

	local var_28_4 = {}

	for iter_28_2, iter_28_3 in orderCsvPairs(var_28_0.dropIds) do
		table.insert(var_28_4, {
			key = iter_28_2,
			num = iter_28_3
		})
	end

	arg_28_0.dropDatas:update(var_28_4)
	arg_28_0.discover:text(getServerArea(arg_28_0.bossDatas:atproxy(arg_28_1).gameKey) .. " " .. arg_28_0.bossDatas:atproxy(arg_28_1).discoverName .. " " .. gLanguageCsv.huodongBossDiscover)

	local var_28_5 = arg_28_0.bossDatas:atproxy(arg_28_1).endTime

	bind.extend(arg_28_0, arg_28_0.escapeTime, {
		class = "cutdown_label",
		props = {
			time = var_28_5 - time.getTime(),
			callFunc = function()
				adapt.oneLinePos(arg_28_0.escapeTip, {
					arg_28_0.escapeTime,
					arg_28_0.escapeTip2
				}, {
					cc.p(5, 0),
					cc.p(5, 0)
				})
			end
		}
	})

	if arg_28_0.bossDatas:atproxy(arg_28_1).myBoss and arg_28_0.bossDatas:atproxy(arg_28_1).ownerWin then
		arg_28_0.hasChallenged:visible(true)
	else
		arg_28_0.hasChallenged:visible(false)
	end

	arg_28_0.timesNum:text(arg_28_0.bossDatas:atproxy(arg_28_1).remainTime .. "/" .. arg_28_0.bossDatas:atproxy(arg_28_1).maxTimes)
end

function var_0_3.onBossItemClick(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	arg_30_0.selIdx:set(arg_30_2)
end

return var_0_3
