local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CaptureLimitView", var_0_0)
local var_0_2 = {
	{
		scale = 0.8,
		effect = "cao2_loop",
		direction = "right",
		effect2 = "cao2_effect_loop",
		pos = cc.p(407, 511)
	},
	{
		scale = 0.8,
		effect = "cao1_loop",
		direction = "left",
		effect2 = "cao1_effect_loop",
		pos = cc.p(1049, 514)
	},
	{
		scale = 1,
		effect = "cao2_loop",
		direction = "right",
		effect2 = "cao2_effect_loop",
		pos = cc.p(304, 359)
	},
	{
		scale = 1,
		effect = "cao1_loop",
		direction = "right",
		effect2 = "cao1_effect_loop",
		pos = cc.p(783, 362)
	},
	{
		scale = 1,
		effect = "shitou1_loop",
		direction = "left",
		effect2 = "shitou1_effect_loop",
		pos = cc.p(1358, 366)
	},
	{
		scale = 1.1,
		effect = "shitou2_loop",
		direction = "right",
		effect2 = "shitou2_effect_loop",
		pos = cc.p(262, 157)
	},
	{
		scale = 1.1,
		effect = "cao3_loop",
		direction = "left",
		effect2 = "cao3_effect_loop",
		pos = cc.p(1330, 172)
	}
}

var_0_1.RESOURCE_FILENAME = "capture_limit.json"
var_0_1.RESOURCE_BINDING = {
	bg = "bg",
	["leftDownPanel.imgScan"] = "imgScan",
	panelSprite = "panelSprite",
	["rightDownPanel.btnSprite"] = {
		varname = "btnSprite",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSpriteBtnClick")
			}
		}
	},
	["rightDownPanel.btnSprite.textSprite"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.DEFAULT,
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["rightDownPanel.btnRule"] = {
		varname = "btnRule",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleBtnClick")
			}
		}
	},
	["rightDownPanel.btnRule.textRule"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.DEFAULT,
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["leftDownPanel.textLv"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("capture", "level")
		}
	},
	["leftDownPanel.textExp"] = {
		varname = "textExp",
		binds = {
			event = "text",
			idler = bindHelper.model("capture", "level_exp")
		}
	},
	["leftDownPanel.textExpFull1"] = {
		varname = "textExpFull1"
	},
	["leftDownPanel.textExpFull"] = {
		varname = "textExpFull",
		binds = {
			event = "text",
			idler = bindHelper.self("expFull")
		}
	},
	["leftDownPanel.textTitle"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("captureTitle")
		}
	},
	["leftDownPanel.progressBar"] = {
		varname = "progressBar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				data = bindHelper.self("expSlider")
			}
		}
	},
	["panelSprite.textName"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.DEFAULT,
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["panelSprite.textTimes"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.WHITE,
				outline = {
					size = 2,
					color = ui.COLORS.BLACK
				}
			}
		}
	},
	["panelSprite.textTime"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.WHITE,
				outline = {
					size = 2,
					color = ui.COLORS.BLACK
				}
			}
		}
	},
	marqueePanel = {
		varname = "marqueePanel",
		binds = {
			event = "extend",
			class = "marquee"
		}
	}
}
var_0_1.RESOURCE_STYLES = {
	full = true
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	gGameUI.topuiManager:createView("capture", arg_1_0, {
		onClose = arg_1_0:createHandler("onClose")
	}):init({
		subTitle = "CAPTURE",
		title = gLanguageCsv.capture
	})

	arg_1_0.captureCount1, arg_1_0.captureCount2 = 0, 0
	arg_1_0.cb = arg_1_1
	arg_1_0.spriteTable = {}

	arg_1_0:initAction()
	arg_1_0:initBgSpine()
	arg_1_0:initGrassSpine()
	arg_1_0:initModel()
end

function var_0_1.onClose(arg_2_0)
	if arg_2_0.behindGrassEff then
		audio.stopSound(arg_2_0.behindGrassEff)

		arg_2_0.behindGrassEff = nil
	end

	local var_2_0 = false
	local var_2_1 = arg_2_0.captureCount1 == arg_2_0.captureCount2 and arg_2_0.captureCount1 ~= 0 and true or false

	if arg_2_0.cb then
		arg_2_0:addCallbackOnExit(functools.partial(arg_2_0.cb, var_2_1))
	end

	var_0_0.onClose(arg_2_0)
end

function var_0_1.initModel(arg_3_0)
	arg_3_0.level = gGameModel.capture:getIdler("level")
	arg_3_0.levelExp = gGameModel.capture:getIdler("level_exp")
	arg_3_0.captureTitle = idler.new("")

	idlereasy.when(arg_3_0.level, function(arg_4_0, arg_4_1)
		arg_3_0.captureTitle:set(csv.capture.level[arg_4_1].name)
	end)

	arg_3_0.expFull = idler.new(0)
	arg_3_0.expSlider = idler.new(0)

	idlereasy.any({
		arg_3_0.level,
		arg_3_0.levelExp
	}, function(arg_5_0, arg_5_1, arg_5_2)
		local var_5_0 = 0

		if arg_5_1 < csvSize(csv.capture.level) then
			var_5_0 = cc.clampf(100 * arg_5_2 / csv.capture.level[arg_5_1].needExp, 0, 100)
		else
			arg_3_0.textExpFull:hide()
			arg_3_0.textExp:hide()
			arg_3_0.textExpFull1:text(gLanguageCsv.levelMax)
			arg_3_0.textExpFull1:setAnchorPoint(0.5, 0.5)

			var_5_0 = 100
		end

		arg_3_0.expFull:set(csv.capture.level[arg_5_1].needExp)
		arg_3_0.expSlider:set(var_5_0)
	end)

	arg_3_0.limitSprites = gGameModel.capture:getIdler("limit_sprites")

	idlereasy.when(arg_3_0.limitSprites, function(arg_6_0, arg_6_1)
		arg_3_0.captureCount1, arg_3_0.captureCount2 = 0, 0

		for iter_6_0, iter_6_1 in pairs(arg_6_1) do
			if csv.capture.sprite[iter_6_1.csv_id] then
				arg_3_0:initSpriteInfo(iter_6_0, iter_6_1)
			end
		end
	end)
end

function var_0_1.initSpriteInfo(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_0.spriteTable[arg_7_1]:get("spriteInfoPanel") then
		arg_7_0:unSchedule(arg_7_1)
		arg_7_0.spriteTable[arg_7_1]:removeChildByName("spine")
		arg_7_0.spriteTable[arg_7_1]:removeChildByName("spriteInfoPanel")
	end

	arg_7_0.captureCount1 = arg_7_0.captureCount1 + 1

	local var_7_0 = csv.capture.sprite[arg_7_2.csv_id]
	local var_7_1 = arg_7_2.find_time + var_7_0.time
	local var_7_2 = var_7_0.totalTimes

	if arg_7_2.state == 0 or var_7_1 - time.getTime() < 0 or var_7_2 - arg_7_2.total_times == 0 then
		arg_7_0.spriteTable[arg_7_1]:get("effect"):play(var_0_2[arg_7_1].effect)

		arg_7_0.captureCount2 = arg_7_0.captureCount2 + 1

		return
	end

	local var_7_3 = csv.cards[var_7_0.cardID].unitID
	local var_7_4 = csv.unit[var_7_3]
	local var_7_5 = widget.addAnimation(arg_7_0.spriteTable[arg_7_1], var_7_4.unitRes, "standby_loop", 0):scale(var_7_4.scale * var_0_2[arg_7_1].scale * 0.6):setName("spine"):anchorPoint(cc.p(0.5, 0.5))

	var_7_5:setSkin(var_7_4.skin)
	arg_7_0.spriteTable[arg_7_1]:get("effect"):play(var_0_2[arg_7_1].effect2)

	local var_7_6 = arg_7_0.panelSprite:clone():xy(0, 0):z(2):show():scale(0.5):addTo(arg_7_0.spriteTable[arg_7_1]):setName("spriteInfoPanel")
	local var_7_7 = var_7_6:get("textName"):text(var_7_4.name)

	var_7_6:get("textTimes"):text(var_7_2 - arg_7_2.total_times .. "/" .. var_7_2)
	var_7_6:get("imgIconLeft"):texture(ui.RARITY_ICON[var_7_4.rarity])

	local function var_7_8()
		local var_8_0 = var_7_6:get("textTime")
		local var_8_1, var_8_2 = var_7_6:getPosition()
		local var_8_3 = var_7_6:isVisible()
		local var_8_4 = time.getCutDown(var_7_1 - time.getTime())

		var_8_0:text(var_8_4.str)

		if var_8_4.hour < 1 and var_8_4.day < 1 then
			text.addEffect(var_8_0, {
				color = ui.COLORS.NORMAL.ALERT_ORANGE
			})
		else
			text.addEffect(var_8_0, {
				color = ui.COLORS.NORMAL.ALERT_GREEN
			})
		end

		if var_7_1 - time.getTime() <= 0 then
			arg_7_0.captureCount2 = arg_7_0.captureCount2 + 1

			arg_7_0:unSchedule(arg_7_1)
			arg_7_0.spriteTable[arg_7_1]:removeChildByName("spine")
			arg_7_0.spriteTable[arg_7_1]:removeChildByName("spriteInfoPanel")
			arg_7_0.spriteTable[arg_7_1]:get("effect"):play(var_0_2[arg_7_1].effect)

			if arg_7_0.behindGrassEff then
				audio.stopSound(arg_7_0.behindGrassEff)

				arg_7_0.behindGrassEff = nil
			end

			return false
		end

		return true
	end

	arg_7_0:enableSchedule()
	arg_7_0:schedule(function(arg_9_0)
		if not var_7_8() then
			return false
		end
	end, 1, 0, arg_7_1)

	if var_0_2[arg_7_1].direction == "left" then
		var_7_5:scaleX(-1 * var_7_5:scaleX())
		var_7_5:x(-100)
		var_7_6:x(-100)
	else
		var_7_5:x(100)
		var_7_6:x(100)
	end

	if not arg_7_0.behindGrassEff then
		arg_7_0.behindGrassEff = audio.playEffectWithWeekBGM("capture/behindgrass.mp3", true)
	end

	bind.touch(arg_7_0, var_7_6, {
		methods = {
			ended = function()
				local var_10_0 = {
					captureData = var_7_0,
					captureID = arg_7_1 - 1,
					limitData = arg_7_2
				}

				gGameUI:stackUI("city.capture.capture_entrace", nil, nil, var_10_0)
			end
		}
	})
end

function var_0_1.initBgSpine(arg_11_0)
	widget.addAnimation(arg_11_0.bg, "capture/buzhuo_changjing_qianjing.skel", "effect_loop", 10):xy(arg_11_0.bg:width() / 2, arg_11_0.bg:height() / 2):anchorPoint(cc.p(0, 0)):z(3)
end

function var_0_1.initGrassSpine(arg_12_0)
	for iter_12_0, iter_12_1 in ipairs(var_0_2) do
		arg_12_0.spriteTable[iter_12_0] = cc.Node:create():xy(iter_12_1.pos):addTo(arg_12_0.bg)

		local var_12_0 = iter_12_1.effect

		widget.addAnimationByKey(arg_12_0.spriteTable[iter_12_0], "capture/buzhuo_changjing.skel", "effect", var_12_0, 1):anchorPoint(cc.p(0.5, 0.5)):scale(iter_12_1.scale)
	end
end

function var_0_1.initAction(arg_13_0)
	arg_13_0.imgScan:runAction(cc.RepeatForever:create(cc.RotateBy:create(1, 360)))
end

function var_0_1.onSpriteBtnClick(arg_14_0)
	gGameUI:stackUI("city.capture.capture_handbook", nil, {
		clickClose = true,
		blackLayer = true
	})
end

function var_0_1.onRuleBtnClick(arg_15_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_15_0:createHandler("getRuleContext"))
end

function var_0_1.getRuleContext(arg_16_0, arg_16_1)
	local var_16_0 = adaptContext

	return {
		var_16_0.clone(arg_16_1.title, function(arg_17_0)
			arg_17_0:get("text"):text(gLanguageCsv.capture .. gLanguageCsv.playRule .. gLanguageCsv.rule)
		end),
		var_16_0.noteText(108),
		var_16_0.noteText(2101, 2109)
	}
end

return var_0_1
