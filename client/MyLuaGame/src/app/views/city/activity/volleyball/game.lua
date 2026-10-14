local var_0_0 = require("app.views.city.activity.volleyball.ball")
local var_0_1 = require("app.views.city.activity.volleyball.sprite")
local var_0_2 = {
	{
		nodeName = "cannonPanel1",
		content = gLanguageCsv.volleyballGuide1
	},
	{
		nodeName = "cannonPanel2",
		content = gLanguageCsv.volleyballGuide2
	},
	{
		nodeName = "cannonPanel3",
		content = gLanguageCsv.volleyballGuide7
	},
	{
		nodeName = "cannonPanel4",
		content = gLanguageCsv.volleyballGuide8
	},
	{
		nodeName = "movePanel",
		content = gLanguageCsv.volleyballGuide3
	},
	{
		nodeName = "jump",
		content = gLanguageCsv.volleyballGuide6
	},
	{
		nodeName = "storage",
		content = gLanguageCsv.volleyballGuide4
	},
	{
		nodeName = "skill",
		content = gLanguageCsv.volleyballGuide5
	},
	{
		nodeName = "maskAttr",
		content = gLanguageCsv.volleyballGuide9
	},
	{
		nodeName = "btnRandom",
		content = gLanguageCsv.volleyballGuide10
	}
}
local var_0_3 = cc.load("mvc").ViewBase
local var_0_4 = class("VolleyBallGame", var_0_3)

var_0_4.RESOURCE_FILENAME = "volleyball_game.json"
var_0_4.RESOURCE_BINDING = {
	cannonPanel2 = "cannonPanel2",
	panelCountDown = "panelCountDown",
	["mask.maskAttr.explain"] = "explain",
	["bg.leftCable1"] = "leftCable1",
	["mask.maskAttr"] = "maskAttr",
	matchPoint = "matchPointMask",
	["bg.leftCable2"] = "leftCable2",
	movePanel = "movePanel",
	["panelCountDown.victoryRule"] = "victoryRule",
	["scoreboard.enemy"] = "enemyScorePanel",
	mask = "mask",
	cannonPanel4 = "cannonPanel4",
	bg = "bg",
	["bg.rightCable1"] = "rightCable1",
	["mask.random.imgRandom"] = "imgRandom",
	["mask.random.player"] = "randomPlayer",
	["mask.random.ai"] = "randomAi",
	["bg.net"] = "net",
	["mask.random"] = "randomStart",
	["scoreboard.self"] = "selfScorePanel",
	cannonPanel1 = "cannonPanel1",
	operatePanel = "operatePanel",
	["bg.rightCable2"] = "rightCable2",
	["bg.stockPile1"] = "stockPile1",
	cannonPanel3 = "cannonPanel3",
	["bg.stockPile2"] = "stockPile2",
	["bg.stockPile1.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.COLORS.NORMAL.DEFAULT
				}
			}
		}
	},
	["bg.stockPile1.bar"] = {
		varname = "stockPile1Bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				data = bindHelper.self("stockPro1")
			}
		}
	},
	["bg.stockPile2.bar"] = {
		varname = "stockPile2Bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				data = bindHelper.self("stockPro2")
			}
		}
	},
	["scoreboard.self.score"] = {
		varname = "selfScore",
		binds = {
			event = "effect",
			data = {
				color = cc.c4b(0, 193, 251, 255)
			}
		}
	},
	["scoreboard.enemy.score"] = {
		varname = "enemyScore",
		binds = {
			event = "effect",
			data = {
				color = cc.c4b(236, 91, 99, 255)
			}
		}
	},
	["operatePanel.skill"] = {
		varname = "skill",
		binds = {
			event = "touch",
			method = bindHelper.self("onFreedPalsy")
		}
	},
	["operatePanel.storage"] = {
		varname = "storage",
		binds = {
			event = "touch",
			method = bindHelper.self("onStoragePower")
		}
	},
	["operatePanel.jump"] = {
		varname = "jump",
		binds = {
			event = "touch",
			method = bindHelper.self("onJump")
		}
	},
	["movePanel.leftMove"] = {
		varname = "leftMove",
		binds = {
			event = "touch",
			method = bindHelper.self("onLeftMove")
		}
	},
	["movePanel.rightMove"] = {
		varname = "rightMove",
		binds = {
			event = "touch",
			method = bindHelper.self("onRightMove")
		}
	},
	["mask.maskAttr.fast"] = {
		varname = "fastAttr",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onFastAttr")
			}
		}
	},
	["mask.maskAttr.fast.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(40, 88, 187, 255)
				},
				color = ui.COLORS.NORMAL.WHITE
			}
		}
	},
	["mask.maskAttr.power"] = {
		varname = "powerAttr",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPowerAttr")
			}
		}
	},
	["mask.maskAttr.power.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(221, 127, 5, 255)
				},
				color = ui.COLORS.NORMAL.WHITE
			}
		}
	},
	["mask.maskAttr.size"] = {
		varname = "sizeAttr",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSizeAttr")
			}
		}
	},
	["mask.maskAttr.size.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(215, 69, 69, 255)
				},
				color = ui.COLORS.NORMAL.WHITE
			}
		}
	},
	["mask.random.btnRandom"] = {
		varname = "btnRandom",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("randomAnimation")
			}
		}
	},
	["panelCountDown.textNum"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 8,
					color = cc.c4b(118, 24, 0, 130)
				},
				color = cc.c4b(255, 246, 61, 255)
			}
		}
	}
}

function var_0_4.onCreate(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.unitId = {}
	arg_1_0.moveCount = {
		left = false,
		right = false
	}
	arg_1_0.activityId = arg_1_1

	arg_1_0:enableSchedule()
	gGameUI:setMultiTouches(true)

	arg_1_0.isGuide = arg_1_2 == 0 and not userDefault.getForeverLocalKey("volleyballGame", false)

	if arg_1_0.isGuide then
		arg_1_0.mask:hide()
		arg_1_0:checkGuide(1)
	else
		gGameUI.topuiManager:createView("title", arg_1_0, {
			onClose = arg_1_0:createHandler("onClose")
		}):init({
			title = gLanguageCsv.volleyballGame
		})
	end

	arg_1_0.stockPro1 = idler.new(0)
	arg_1_0.stockPro2 = idler.new(0)
end

function var_0_4.initData(arg_2_0)
	arg_2_0.score = {
		0,
		0
	}
	arg_2_0.matchPoint = {
		0,
		0
	}
	arg_2_0.matchPointEffect = {}
	arg_2_0.gameOverSign = false
	arg_2_0.outBoundTimes = {
		0,
		0
	}
	arg_2_0.netSize = arg_2_0.net:size()
	arg_2_0.netPos = {}
	arg_2_0.netPos.x, arg_2_0.netPos.y = arg_2_0.net:getPosition()
	arg_2_0.ball = var_0_0.new(arg_2_0.netPos, arg_2_0.netSize)

	local var_2_0 = arg_2_0:randomeExtract(1)

	arg_2_0.player = var_0_1.new(arg_2_0.netPos, arg_2_0.netSize, var_2_0, 1)

	local var_2_1 = arg_2_0:randomeExtract(2)

	arg_2_0.robot = var_0_1.new(arg_2_0.netPos, arg_2_0.netSize, var_2_1, 2)
end

function var_0_4.createSpriteRes(arg_3_0)
	arg_3_0.player:createImage(arg_3_0.bg, arg_3_0.stockPile1, arg_3_0.stockPro1)
	arg_3_0.robot:createImage(arg_3_0.bg, arg_3_0.stockPile2, arg_3_0.stockPro2)

	local var_3_0, var_3_1 = arg_3_0.skill:getPosition()

	arg_3_0.energyProgress = cc.ProgressTimer:create(cc.Sprite:create("activity/volleyball/btn_jn_q.png")):setReverseDirection(false):setType(cc.PROGRESS_TIMER_TYPE_RADIAL):addTo(arg_3_0.skill, 4):alignCenter(arg_3_0.skill:size()):scale(1):anchorPoint(0.5, 0.5)

	local var_3_2 = arg_3_0.selfScore
	local var_3_3 = "effect_wofang_loop"

	for iter_3_0 = 1, 2 do
		local var_3_4, var_3_5 = var_3_2:getPosition()

		if iter_3_0 == 2 then
			var_3_2 = arg_3_0.enemyScore
			var_3_3 = "effect_difang_loop"
			var_3_4, var_3_5 = var_3_2:getPosition()
		end

		arg_3_0.matchPointEffect[iter_3_0] = widget.addAnimationByKey(var_3_2, "volleyball_saidian/saidian.skel", var_3_3, var_3_3, 10):xy(var_3_4 - 125, var_3_5 - 35):scale(2):hide()
	end

	arg_3_0.skillEffect = widget.addAnimationByKey(arg_3_0.skill, "volleyball_skill/jineng.skel", "jineng", "effect_loop1", 10):alignCenter(arg_3_0.skill:size()):scale(0.5):anchorPoint(0.5, 0.5):hide()
end

function var_0_4.createBallRes(arg_4_0)
	local var_4_0 = {
		arg_4_0.player.headCenterPos,
		arg_4_0.robot.headCenterPos
	}

	arg_4_0.robot.initPos = arg_4_0.robot.pos
	arg_4_0.player.initPos = arg_4_0.player.pos
	arg_4_0.player.initBonePos = arg_4_0.player.image:getBonePosition("tou")

	arg_4_0.ball:createImage(arg_4_0.bg, var_4_0)
end

function var_0_4.randomeExtract(arg_5_0, arg_5_1)
	local var_5_0 = {}

	for iter_5_0, iter_5_1 in csvPairs(csv.volleyball_unit) do
		if arg_5_1 == 2 then
			for iter_5_2 = 1, iter_5_1.ranWeight do
				table.insert(var_5_0, iter_5_1)
			end
		elseif iter_5_1.attrType == arg_5_0.selectAttrType then
			table.insert(var_5_0, iter_5_1)
		end
	end

	local var_5_1 = math.random(1, table.length(var_5_0))

	arg_5_0.unitId[arg_5_1] = var_5_0[var_5_1].id

	return var_5_0[var_5_1]
end

function var_0_4.collision(arg_6_0, arg_6_1)
	local function var_6_0(arg_7_0, arg_7_1, arg_7_2)
		if (arg_6_0.ball.radius + arg_7_2) * (arg_6_0.ball.radius + arg_7_2) - arg_7_0 * arg_7_0 - arg_7_1 * arg_7_1 > 0 then
			local var_7_0 = math.atan2(arg_7_1, arg_7_0)
			local var_7_1 = math.deg(var_7_0)

			if var_7_1 < 180 then
				return var_7_1
			end

			return var_7_1 - 180
		end
	end

	local var_6_1 = arg_6_0.ball.pos.x
	local var_6_2 = arg_6_0.ball.pos.y
	local var_6_3 = arg_6_1.headCenterPos.x
	local var_6_4 = arg_6_1.headCenterPos.y
	local var_6_5 = var_6_0(var_6_1 - var_6_3, var_6_2 - var_6_4, arg_6_1.hitRadius)

	if var_6_0(var_6_1 - var_6_3, var_6_2 - var_6_4, 5 * arg_6_1.hitRadius) then
		arg_6_0:notifySprite(arg_6_1, {
			name = "playPreHitAni",
			node = arg_6_0
		})
	end

	if var_6_5 then
		arg_6_0.robot.batSign = arg_6_1.force == 2
		arg_6_0.player.batSign = arg_6_1.force == 1

		if arg_6_1.force == 2 and arg_6_1.slowSpeedSign == true then
			arg_6_1.slowSpeedRate = arg_6_0.player.slowSpeedRate
			arg_6_1.slowSpeedSign = false
			arg_6_0.player.slowSpeedRate = 1

			arg_6_0:notifySprite(arg_6_1, {
				name = "playSkillAni"
			})
			arg_6_0:notifyBall(arg_6_1, {
				reset = true,
				name = "playSkillAni"
			})
		end

		arg_6_0:notifySprite(arg_6_1, {
			name = "playHitAni",
			node = arg_6_0
		})
		arg_6_0:notifyBall(arg_6_1, {
			name = "collision"
		})
		arg_6_0:notifySprite(arg_6_0.robot, {
			name = "hit",
			hitForce = arg_6_1.force
		})
	end
end

function var_0_4.notifyBall(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0.ball["onEvent_" .. arg_8_2.name]

	if var_8_0 == nil then
		return
	end

	var_8_0(arg_8_0.ball, arg_8_1, arg_8_2)
end

function var_0_4.notifySprite(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_1["onEvent_" .. arg_9_2.name]

	if var_9_0 == nil then
		return
	end

	var_9_0(arg_9_1, arg_9_0.ball, arg_9_2)
end

function var_0_4.updateView(arg_10_0)
	arg_10_0.ball:updateView()
	arg_10_0.robot:updateView()
	arg_10_0.player:updateView()
	arg_10_0.energyProgress:setPercentage(math.min(6, arg_10_0.player.batTimes) * 100 / 6)
end

function var_0_4.gameStart(arg_11_0)
	gGameApp:requestServer("/game/yy/volleyball/start", function(arg_12_0)
		arg_11_0:keyboardMonitor()
		arg_11_0.panelCountDown:hide()
		arg_11_0.bg:scheduleUpdate(function()
			arg_11_0:collision(arg_11_0.robot)
			arg_11_0:collision(arg_11_0.player)
			arg_11_0.ball:move()
			arg_11_0.robot:move()
			arg_11_0.player:move()
			arg_11_0.robot:stockpile()
			arg_11_0.player:stockpile()
			arg_11_0:updateView()
			arg_11_0:updateScore()
			arg_11_0:checkResult()

			if arg_11_0.gameOverSign then
				return false
			end
		end)

		arg_11_0.gameTime = 0

		arg_11_0:schedule(function(arg_14_0)
			arg_11_0.gameTime = arg_11_0.gameTime + 0.1
		end, 0.1, 0, "gameTime")
	end, arg_11_0.activityId)
end

function var_0_4.updateScore(arg_15_0)
	local var_15_0 = arg_15_0.netPos
	local var_15_1 = arg_15_0.netSize
	local var_15_2 = var_15_0.y + var_15_1.height / 2
	local var_15_3 = arg_15_0.ball.pos.x
	local var_15_4 = arg_15_0.ball.pos.y
	local var_15_5 = arg_15_0.ball.speed.x
	local var_15_6 = arg_15_0.ball.speed.y

	if var_15_4 <= arg_15_0.ball.floorY then
		local var_15_7 = 1

		if var_15_3 > var_15_0.x and var_15_3 < var_15_0.x + 570 then
			arg_15_0.score[1] = arg_15_0.score[1] + 1
		else
			var_15_7 = 2

			if var_15_3 >= var_15_0.x + 570 or var_15_3 <= var_15_0.x - 570 then
				arg_15_0.outBoundTimes[1] = arg_15_0.outBoundTimes[1] + 1
			end

			arg_15_0.score[2] = arg_15_0.score[2] + 1
		end

		arg_15_0.selfScore:text(string.format("%d", arg_15_0.score[1]))
		arg_15_0.enemyScore:text(string.format("%d", arg_15_0.score[2]))
		arg_15_0:hideOpBtn()
		arg_15_0.ball:reset(var_15_7)
		arg_15_0.robot:reset()
		arg_15_0.player:reset()
		arg_15_0.skillEffect:hide()
	end

	if var_15_3 >= var_15_0.x and var_15_2 < var_15_4 and var_15_5 > 0 and arg_15_0.player.batSign then
		arg_15_0.player.batSign = false
		arg_15_0.ball.serveAction = false
		arg_15_0.player.batTimes = arg_15_0.player.batTimes + 1

		if arg_15_0.player.batTimes >= 6 then
			arg_15_0.skillEffect:show()
			arg_15_0.skillEffect:play("effect_loop2")
		elseif arg_15_0.player.batTimes >= 3 then
			arg_15_0.skillEffect:show()
			arg_15_0.skillEffect:play("effect_loop1")
		end
	elseif var_15_3 < var_15_0.x and var_15_2 < var_15_4 and var_15_5 < 0 and arg_15_0.robot.batSign then
		arg_15_0.robot.batSign = false
		arg_15_0.ball.serveAction = false
		arg_15_0.robot.batTimes = arg_15_0.robot.batTimes + 1
	end
end

function var_0_4.checkResult(arg_16_0)
	for iter_16_0 = 1, 2 do
		if arg_16_0.score[iter_16_0] == 2 and arg_16_0.matchPoint[iter_16_0] == 0 then
			local var_16_0 = arg_16_0.ball.gravity

			arg_16_0.ball.gravity = 0

			arg_16_0.ball.image:hide()
			arg_16_0.ball.shadow:hide()
			arg_16_0.robot.image:hide()

			arg_16_0.robot.isHideState = true

			arg_16_0.player.image:hide()
			arg_16_0.matchPointMask:show()
			arg_16_0.matchPointEffect[iter_16_0]:show()
			performWithDelay(arg_16_0, function()
				arg_16_0.matchPointMask:hide()
				arg_16_0.ball.image:show()
				arg_16_0.robot.image:show()

				arg_16_0.robot.isHideState = false

				arg_16_0.player.image:show()
				arg_16_0.ball.shadow:show()

				arg_16_0.ball.gravity = var_16_0
			end, 2)

			arg_16_0.matchPoint[iter_16_0] = 1
		end
	end

	if (arg_16_0.score[1] >= 3 or arg_16_0.score[2] >= 3) and not arg_16_0.gameOverSign then
		arg_16_0.gameOverSign = true

		arg_16_0.player.image:play("win_loop")

		local var_16_1 = {
			[102] = arg_16_0.score[1],
			[202] = arg_16_0.unitId[2],
			[203] = arg_16_0.outBoundTimes[1],
			[204] = arg_16_0.unitId[1],
			[206] = arg_16_0.robot.skillHitTimes[1],
			[207] = arg_16_0.robot.skillHitTimes[2]
		}

		arg_16_0:gameOver()

		local var_16_2 = arg_16_0.score[1] >= 3 and 1 or 0

		gGameApp:requestServerCustom("/game/yy/volleyball/end"):onErrClose(function()
			var_0_3.onClose(arg_16_0)
		end):params(arg_16_0.activityId, var_16_2 == 1 and "win" or "fail", arg_16_0.gameTime, var_16_1):doit(function(arg_19_0)
			arg_16_0:showGameEnd(var_16_2, arg_16_0.score, arg_16_0.unitId[1])
		end)
	end
end

function var_0_4.enterCourt(arg_20_0)
	arg_20_0.player.pos.x = arg_20_0.player.pos.x + 6
	arg_20_0.robot.pos.x = arg_20_0.robot.pos.x - 6

	arg_20_0.robot:updateView()
	arg_20_0.player:updateView()
end

function var_0_4.startCount(arg_21_0)
	arg_21_0.victoryRule:hide()

	local var_21_0 = 60
	local var_21_1 = arg_21_0.panelCountDown:get("textNum")

	var_21_1:scale(1.5)
	var_21_1:text(var_21_0 / 20)
	var_21_1:show()
	arg_21_0:createSpriteRes()
	arg_21_0:schedule(function(arg_22_0)
		if var_21_0 > 0 then
			if var_21_0 % 20 == 0 then
				local var_22_0 = var_21_1

				var_21_1:text(var_21_0 / 20)
				var_21_1:runAction(cc.ScaleTo:create(0.5, 1))
			end

			arg_21_0:enterCourt()

			var_21_0 = var_21_0 - 1
		else
			arg_21_0:createBallRes()
			arg_21_0:gameStart()

			return false
		end
	end, 0.05, 0, 663)
end

function var_0_4.gameOver(arg_23_0)
	arg_23_0.bg:unscheduleUpdate()
	arg_23_0:disableSchedule()
end

function var_0_4.onClose(arg_24_0)
	if arg_24_0.isGuide then
		return
	end

	local function var_24_0()
		gGameUI:setMultiTouches(false)
		arg_24_0:gameOver()
		var_0_3.onClose(arg_24_0)
	end

	if arg_24_0.score and (arg_24_0.score[1] >= 3 or arg_24_0.score[2] >= 3) then
		var_24_0()
	else
		gGameUI:showDialog({
			btnType = 2,
			isRich = true,
			content = "#C0x5b545b#" .. gLanguageCsv.confirmEndGame,
			cb = var_24_0,
			dialogParams = {
				clearFast = true,
				clickClose = false
			}
		})
	end
end

function var_0_4.onFreedPalsy(arg_26_0, arg_26_1, arg_26_2)
	if not arg_26_0.player or not arg_26_0.robot then
		return
	end

	if arg_26_2.name == "began" then
		arg_26_0:notifySprite(arg_26_0.player, {
			name = "palsy"
		})

		if arg_26_0.player.slowSpeedRate < 1 then
			arg_26_0.robot.slowSpeedSign = true

			arg_26_0:notifyBall(arg_26_0.player, {
				reset = false,
				name = "playSkillAni"
			})
		end

		arg_26_0.skillEffect:hide()
	elseif arg_26_2.name ~= "cancelled" and arg_26_2.name == "ended" then
		-- block empty
	end
end

function var_0_4.onStoragePower(arg_27_0, arg_27_1, arg_27_2)
	if not arg_27_0.player then
		return
	end

	if arg_27_2.name == "began" then
		arg_27_0.player.stockpileSign = true

		arg_27_0.storage:get("click"):show()
	elseif arg_27_2.name == "cancelled" or arg_27_2.name == "ended" then
		arg_27_0.player.stockpileSign = false

		arg_27_0.storage:get("click"):hide()
	end
end

function var_0_4.onLeftMove(arg_28_0, arg_28_1, arg_28_2)
	if not arg_28_0.player then
		return
	end

	if arg_28_2.name == "began" then
		arg_28_0.player.speed.x = -arg_28_0.player.lrSpeedDelta
		arg_28_0.moveCount.left = true

		arg_28_0.leftMove:get("click"):show()
	elseif arg_28_2.name == "cancelled" or arg_28_2.name == "ended" then
		arg_28_0.moveCount.left = false

		if arg_28_0.moveCount.right then
			arg_28_0.player.speed.x = arg_28_0.player.lrSpeedDelta
		else
			arg_28_0.player.speed.x = 0
		end

		arg_28_0.leftMove:get("click"):hide()
	end
end

function var_0_4.onRightMove(arg_29_0, arg_29_1, arg_29_2)
	if not arg_29_0.player then
		return
	end

	if arg_29_2.name == "began" then
		arg_29_0.player.speed.x = arg_29_0.player.lrSpeedDelta
		arg_29_0.moveCount.right = true

		arg_29_0.rightMove:get("click"):show()
	elseif arg_29_2.name == "cancelled" or arg_29_2.name == "ended" then
		arg_29_0.moveCount.right = false

		if arg_29_0.moveCount.left then
			arg_29_0.player.speed.x = -arg_29_0.player.lrSpeedDelta
		else
			arg_29_0.player.speed.x = 0
		end

		arg_29_0.rightMove:get("click"):hide()
	end
end

function var_0_4.onJump(arg_30_0, arg_30_1, arg_30_2)
	if not arg_30_0.player then
		return
	end

	if arg_30_2.name == "began" then
		if arg_30_0.player.operateAni ~= "effect_daqiu1" then
			arg_30_0:notifySprite(arg_30_0.player, {
				name = "playJumpAni",
				node = arg_30_0
			})
		end

		arg_30_0.jump:get("click"):show()
	elseif arg_30_2.name == "cancelled" or arg_30_2.name == "ended" then
		arg_30_0.jump:get("click"):hide()
	end
end

function var_0_4.hideOpBtn(arg_31_0)
	arg_31_0.leftMove:get("click"):hide()
	arg_31_0.rightMove:get("click"):hide()
	arg_31_0.jump:get("click"):hide()
	arg_31_0.storage:get("click"):hide()
end

function var_0_4.hideAttrBtn(arg_32_0)
	arg_32_0.randomPlayer:texture("config/big_hero/normal/img_25_pkq@.png")
	arg_32_0.randomAi:texture("config/big_hero/normal/img_25_pkq@.png")
	cache.setShader(arg_32_0.randomPlayer, false, "black")
	cache.setShader(arg_32_0.randomAi, false, "black")
	arg_32_0.maskAttr:hide()
	arg_32_0.randomStart:show()

	if arg_32_0.isGuide then
		arg_32_0.randomStart:setTouchEnabled(false)
		arg_32_0:createGuide(10, function()
			arg_32_0.isGuide = false

			userDefault.setForeverLocalKey("volleyballGame", true)
			arg_32_0.randomStart:setTouchEnabled(true)
			gGameUI.topuiManager:createView("title", arg_32_0, {
				onClose = arg_32_0:createHandler("onClose")
			}):init({
				title = gLanguageCsv.volleyballGame
			})
		end)
	end
end

function var_0_4.onFastAttr(arg_34_0)
	arg_34_0.selectAttrType = 1

	arg_34_0:hideAttrBtn()
end

function var_0_4.onPowerAttr(arg_35_0)
	arg_35_0.selectAttrType = 2

	arg_35_0:hideAttrBtn()
end

function var_0_4.onSizeAttr(arg_36_0)
	arg_36_0.selectAttrType = 3

	arg_36_0:hideAttrBtn()
end

function var_0_4.onRandomStart(arg_37_0)
	arg_37_0.btnRandom:show()
	arg_37_0.mask:hide()
	arg_37_0.panelCountDown:show()
	arg_37_0.panelCountDown:get("textNum"):hide()
	arg_37_0.victoryRule:show()
	performWithDelay(arg_37_0, function()
		arg_37_0:startCount()
	end, 2)
end

function var_0_4.keyboardMonitor(arg_39_0)
	if device.platform ~= "windows" then
		return
	end

	local var_39_0 = arg_39_0.player

	local function var_39_1(arg_40_0, arg_40_1)
		if arg_40_0 == 124 then
			arg_39_0:onLeftMove(nil, {
				name = "began"
			})
		end

		if arg_40_0 == 127 then
			arg_39_0:onRightMove(nil, {
				name = "began"
			})
		end

		if arg_40_0 == 146 and var_39_0.pos.y <= var_39_0.floorY + 10 and not var_39_0.stockpileSign then
			var_39_0.speed.y = var_39_0.udSpeedDelta
		end

		if arg_40_0 == 59 then
			var_39_0.stockpileSign = true
		end
	end

	local function var_39_2(arg_41_0, arg_41_1)
		if arg_41_0 == 59 then
			var_39_0.stockpileSign = false
		elseif arg_41_0 == 124 then
			arg_39_0:onLeftMove(nil, {
				name = "ended"
			})
		elseif arg_41_0 == 127 then
			arg_39_0:onRightMove(nil, {
				name = "ended"
			})
		end
	end

	local var_39_3 = cc.EventListenerKeyboard:create()

	var_39_3:registerScriptHandler(var_39_1, cc.Handler.EVENT_KEYBOARD_PRESSED)
	var_39_3:registerScriptHandler(var_39_2, cc.Handler.EVENT_KEYBOARD_RELEASED)
	arg_39_0:getEventDispatcher():addEventListenerWithSceneGraphPriority(var_39_3, arg_39_0)
end

function var_0_4.checkGuide(arg_42_0, arg_42_1)
	if arg_42_1 >= 9 then
		arg_42_0.mask:show()
		arg_42_0:createGuide(9)

		return
	end

	arg_42_0:createGuide(arg_42_1, function()
		arg_42_0:checkGuide(arg_42_1 + 1)
	end)
end

function var_0_4.createGuide(arg_44_0, arg_44_1, arg_44_2)
	local function var_44_0(arg_45_0, arg_45_1)
		if arg_44_0:get("maskPanel") then
			arg_44_0:get("maskPanel"):removeFromParent()
		end

		local var_45_0 = ccui.Layout:create():size(display.sizeInView.width, display.sizeInView.height):anchorPoint(0.5, 0.5):xy(display.center):addTo(arg_44_0, 5, "maskPanel")
		local var_45_1 = ccui.ImageView:create("login/new_character/img_tjltm@.png"):xy(arg_45_0.x > display.sizeInView.width / 2 and arg_45_0.x - arg_45_1 - 150 or arg_45_0.x + arg_45_1 + 850, arg_45_0.y > display.sizeInView.height / 2 and arg_45_0.y - 200 or arg_45_0.y + 200):addTo(var_45_0, 2)
		local var_45_2 = ccui.ImageView:create("city/gate/bg_dialog.png")

		var_45_2:setScale9Enabled(true)
		var_45_2:setCapInsets({
			width = 1,
			height = 1,
			x = 77,
			y = 58
		})
		var_45_2:addTo(var_45_1)
		var_45_2:xy(-160, 200)
		var_45_2:width(500)

		local var_45_3 = rich.createWithWidth("#C0x5b545b#" .. var_0_2[arg_44_1].content, 40, nil, 450):anchorPoint(0, 0):addTo(var_45_2, 3, "talkContent"):xy(25, 50)

		var_45_2:height(var_45_3:height() + 80)

		return var_45_0
	end

	local var_44_1 = var_0_2[arg_44_1] and arg_44_0[var_0_2[arg_44_1].nodeName]

	if var_44_1 then
		var_44_1:show()

		local var_44_2 = var_44_1:box()
		local var_44_3 = gGameUI:getConvertPos(var_44_1)
		local var_44_4 = var_44_1:anchorPoint()

		var_44_3.x = var_44_3.x - var_44_4.x * var_44_2.width + display.uiOrigin.x
		var_44_3.y = var_44_3.y - var_44_4.y * var_44_2.height

		local var_44_5 = var_44_0(var_44_3, (1 - var_44_4.x) * var_44_2.width)
		local var_44_6 = cc.RenderTexture:create(display.sizeInView.width, display.sizeInView.height):addTo(var_44_5, 1, "bgRender")
		local var_44_7 = cc.LayerColor:create(cc.c4b(0, 0, 0, 150), display.sizeInView.width, display.sizeInView.height)
		local var_44_8 = ccui.Scale9Sprite:create()
		local var_44_9 = var_44_2.width
		local var_44_10 = var_44_2.height

		var_44_7:retain()
		var_44_8:retain()
		var_44_8:initWithFile(cc.rect(80, 80, 1, 1), "other/guide/icon_mask.png")
		var_44_8:anchorPoint(0.5, 0.5):size(var_44_9, var_44_10):xy(var_44_3.x + var_44_2.width / 2, var_44_3.y + var_44_2.height / 2)
		var_44_8:setBlendFunc({
			dst = 0,
			src = GL_DST_ALPHA
		})

		local var_44_11 = display.sizeInView.width * 2 / var_44_2.width
		local var_44_12 = display.sizeInView.height * 2 / var_44_2.height
		local var_44_13 = math.max(var_44_11, var_44_12)

		var_44_8:scale(var_44_13)
		var_44_6:begin()
		var_44_7:visit()
		var_44_8:visit()
		var_44_6:endToLua()

		local var_44_14 = false
		local var_44_15 = var_44_13 - 1

		arg_44_0:schedule(function(arg_46_0)
			var_44_13 = var_44_13 - arg_46_0 / 0.3 * var_44_15

			if not var_44_14 then
				if var_44_13 <= 1 then
					var_44_13 = 1
					var_44_14 = true
				end

				var_44_8:scale(var_44_13)
				var_44_6:beginWithClear(0, 0, 0, 0)
				var_44_7:visit()
				var_44_8:visit()
				var_44_6:endToLua()
			else
				var_44_7:release()
				var_44_8:release()

				return false
			end
		end, 0.03333333333333333, 0, "guideCircleAni")
		var_44_5:setBackGroundColorOpacity(0)

		local var_44_16 = cc.LayerColor:create(cc.c4b(255, 0, 255, 150), display.sizeInView.width, display.sizeInView.height):addTo(var_44_5, 2)
		local var_44_17 = false

		var_44_16:hide()

		local var_44_18 = cc.EventListenerTouchOneByOne:create()
		local var_44_19 = var_44_16:getEventDispatcher()
		local var_44_20 = cc.p(0, 0)

		local function var_44_21(arg_47_0)
			var_44_18:setEnabled(false)
			var_44_19:dispatchEvent(arg_47_0)
			var_44_18:setEnabled(true)
		end

		local function var_44_22(arg_48_0, arg_48_1)
			return true
		end

		local function var_44_23(arg_49_0, arg_49_1)
			var_44_21(arg_49_1)
		end

		local function var_44_24(arg_50_0, arg_50_1)
			if var_44_5 and var_44_14 then
				if arg_44_0:get("maskPanel") then
					arg_44_0:get("maskPanel"):removeFromParent()
				end

				var_44_5 = nil
			end

			if arg_44_2 then
				arg_44_2(arg_44_0)
			end
		end

		var_44_18:setSwallowTouches(true)
		var_44_18:registerScriptHandler(var_44_22, cc.Handler.EVENT_TOUCH_BEGAN)
		var_44_18:registerScriptHandler(var_44_23, cc.Handler.EVENT_TOUCH_MOVED)
		var_44_18:registerScriptHandler(var_44_24, cc.Handler.EVENT_TOUCH_ENDED)
		var_44_18:registerScriptHandler(var_44_24, cc.Handler.EVENT_TOUCH_CANCELLED)
		var_44_19:addEventListenerWithSceneGraphPriority(var_44_18, var_44_16)
	else
		var_44_0()

		if arg_44_2 then
			arg_44_2(arg_44_0)
		end
	end
end

function var_0_4.showGameEnd(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	local var_51_0 = {
		res = arg_51_0.player.res,
		result = arg_51_1,
		score = arg_51_2,
		unitId = arg_51_3
	}

	gGameUI:stackUI("city.activity.volleyball.game_over", nil, nil, arg_51_0, var_51_0)
end

function var_0_4.resetGame(arg_52_0)
	arg_52_0:hideOpBtn()
	arg_52_0:enableSchedule()
	arg_52_0.ball:deleteImage()
	arg_52_0.robot:deleteImage()
	arg_52_0.player:deleteImage()
	arg_52_0.energyProgress:removeSelf()
	arg_52_0.mask:show()
	arg_52_0.maskAttr:show()
	arg_52_0.skillEffect:hide()
	arg_52_0.randomStart:hide()
	arg_52_0.panelCountDown:get("textNum"):text(3)
	arg_52_0.selfScore:text(string.format("%d", 0))
	arg_52_0.enemyScore:text(string.format("%d", 0))
	arg_52_0.matchPointEffect[1]:hide()
	arg_52_0.matchPointEffect[2]:hide()

	arg_52_0.moveCount = {
		left = false,
		right = false
	}
end

function var_0_4.randomAnimation(arg_53_0)
	arg_53_0.btnRandom:hide()
	arg_53_0.imgRandom:show()
	widget.addAnimationByKey(arg_53_0.imgRandom, "volleyball_suijizhong/suijizhong.skel", "suijiEffect", "effect_loop", 10):alignCenter(arg_53_0.imgRandom:size()):scale(1.5)
	arg_53_0:initData()

	local var_53_0 = arg_53_0.unitId[1]
	local var_53_1 = arg_53_0.unitId[2]
	local var_53_2 = {}

	for iter_53_0, iter_53_1 in csvPairs(csv.volleyball_unit) do
		table.insert(var_53_2, csv.unit[iter_53_1.id].cardShow)
	end

	local var_53_3 = 1
	local var_53_4 = 1
	local var_53_5 = 1
	local var_53_6 = 16
	local var_53_7 = #var_53_2
	local var_53_8 = 1
	local var_53_9 = 1

	arg_53_0:enableSchedule()
	arg_53_0:schedule(function(arg_54_0)
		if var_53_8 - var_53_3 == var_53_9 then
			if var_53_8 < 60 then
				local var_54_0 = math.random(1, var_53_7)
				local var_54_1 = math.random(1, var_53_7)

				arg_53_0.randomPlayer:texture(var_53_2[var_54_0])
				arg_53_0.randomAi:texture(var_53_2[var_54_1])
			else
				arg_53_0.randomPlayer:texture(csv.unit[var_53_0].cardShow)
				arg_53_0.randomAi:texture(csv.unit[var_53_1].cardShow)
			end

			cache.setShader(arg_53_0.randomPlayer, false, "black")
			cache.setShader(arg_53_0.randomAi, false, "black")

			var_53_3 = var_53_8
		end

		var_53_8 = var_53_8 + 1

		if var_53_8 > 15 * var_53_4 then
			var_53_9 = 2 + var_53_9
			var_53_4 = var_53_4 + 1
		end

		if var_53_8 >= 75 then
			arg_53_0.imgRandom:hide()
			arg_53_0.randomPlayer:texture(csv.unit[var_53_0].cardShow)
			arg_53_0.randomAi:texture(csv.unit[var_53_1].cardShow)
			cache.setShader(arg_53_0.randomPlayer, false, "normal")
			cache.setShader(arg_53_0.randomAi, false, "normal")
			arg_53_0:unSchedule("randomAnimation")
			performWithDelay(arg_53_0, function()
				arg_53_0:onRandomStart()
			end, 2)

			return
		end
	end, 0.06666666666666667, 0, "randomAnimation")
end

return var_0_4
