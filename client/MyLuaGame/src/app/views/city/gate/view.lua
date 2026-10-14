local var_0_0 = {
	nightmare = 3,
	hero = 2,
	normal = 1
}
local var_0_1 = {
	[var_0_0.normal] = 10,
	[var_0_0.hero] = 110,
	[var_0_0.nightmare] = 210
}
local var_0_2 = {
	"city/gate/bg_cj1.png",
	"city/gate/bg_cj_kn1.png",
	"city/gate/bg_cj_em1.png"
}
local var_0_3 = {
	"city/gate/bg_cj2.png",
	"city/gate/bg_cj_kn2.png",
	"city/gate/bg_cj_em2.png"
}

local function var_0_4(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	return arg_1_0 and arg_1_0 == arg_1_1 and arg_1_2 > 0 and arg_1_3 == arg_1_2
end

local function var_0_5(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	if arg_2_0.isFirstEnter and arg_2_1 == 1 and arg_2_2 == 1 and arg_2_3 <= 0 then
		userDefault.setForeverLocalKey("isEnterLevelFirst", {
			[arg_2_0.levelType] = false
		})

		return true
	elseif arg_2_0.isFirstEnter then
		userDefault.setForeverLocalKey("isEnterLevelFirst", {
			[arg_2_0.levelType] = false
		})
	end

	return false
end

local function var_0_6(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_3 and arg_3_0:getName() .. arg_3_3 .. "vibrate" .. arg_3_4 or arg_3_0:getName() .. "toRotationScheduleTag" .. arg_3_4

	uiEasy.addVibrateToNode(arg_3_0, arg_3_1, arg_3_2, var_3_0)
end

local function var_0_7(arg_4_0, arg_4_1, arg_4_2)
	local function var_4_0(arg_5_0, arg_5_1)
		local var_5_0 = {}

		table.insert(var_5_0, {
			x = arg_5_0.x,
			y = arg_5_0.y
		})

		local var_5_1 = math.abs(arg_5_1.x - arg_5_0.x)
		local var_5_2 = math.abs(arg_5_1.y - arg_5_0.y)
		local var_5_3 = math.max(var_5_1, var_5_2)
		local var_5_4 = math.max(0, math.floor(var_5_3 / 45) - 1)

		for iter_5_0 = 1, var_5_4 do
			local var_5_5 = arg_5_1.x >= arg_5_0.x and 1 or -1
			local var_5_6 = arg_5_1.y >= arg_5_0.y and 1 or -1
			local var_5_7 = var_5_1 / (var_5_4 + 1)
			local var_5_8 = arg_5_0.x + iter_5_0 * var_5_7 * var_5_5 + math.random(0, 8)
			local var_5_9 = var_5_2 / (var_5_4 + 1)
			local var_5_10 = arg_5_0.y + iter_5_0 * var_5_9 * var_5_6 + math.random(0, 8)

			table.insert(var_5_0, {
				x = var_5_8,
				y = var_5_10
			})
		end

		return var_5_0
	end

	local var_4_1 = {}

	for iter_4_0 = 2, itertools.size(arg_4_1.frontWay) do
		local var_4_2 = arg_4_1.frontWay[iter_4_0 - 1]
		local var_4_3 = arg_4_1.frontWay[iter_4_0]
		local var_4_4 = var_4_0({
			x = var_4_2[1],
			y = var_4_2[2]
		}, {
			x = var_4_3[1],
			y = var_4_3[2]
		})

		for iter_4_1, iter_4_2 in ipairs(var_4_4) do
			local var_4_5 = cc.Sprite:create("city/gate/logo_path.png")

			var_4_5:visible(false)
			var_4_5:xy(iter_4_2.x + arg_4_2, iter_4_2.y)
			arg_4_0:addChild(var_4_5, 9, "point")
			table.insert(var_4_1, var_4_5)
		end
	end

	return var_4_1
end

local function var_0_8(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	for iter_6_0 = 1, arg_6_1 - arg_6_2 do
		arg_6_0:get("imgStar" .. iter_6_0):get("star"):visible(true)
	end

	local var_6_0 = 0.3

	for iter_6_1 = arg_6_1 - arg_6_2, arg_6_1 - 1 do
		local var_6_1 = arg_6_3.starSpineName
		local var_6_2 = arg_6_3.starSpinePos(iter_6_1)

		arg_6_0:get("imgStar" .. iter_6_1 + 1):get("star"):visible(false)
		performWithDelay(arg_6_0, function()
			widget.addAnimationByKey(arg_6_0, var_6_1, "star" .. iter_6_1 + 1, "effect_star" .. iter_6_1 + 1, 11):xy(var_6_2)
		end, 0.3 + var_6_0 * iter_6_1)
	end
end

local function var_0_9(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = arg_8_0:get("levelName")
	local var_8_1 = arg_8_0:get("textLvNum")
	local var_8_2 = arg_8_0:get("imgMask")
	local var_8_3 = cc.c4b(255, 252, 237, 255)

	var_8_0:text(arg_8_2)
	var_8_0:visible(true)
	var_8_1:visible(true)

	local var_8_4 = -7
	local var_8_5 = 48
	local var_8_6 = 0

	if arg_8_4 == 1 then
		var_8_4 = 0
		var_8_5 = 0
	elseif arg_8_4 == 2 then
		var_8_4 = -5
		var_8_5 = -20
		var_8_6 = -25
	elseif arg_8_4 == 3 then
		var_8_6 = -12
	end

	text.addEffect(var_8_0, {
		outline = {
			size = 4,
			color = var_8_3
		}
	})
	text.addEffect(var_8_1, {
		outline = {
			size = 4,
			color = var_8_3
		}
	})
	adapt.oneLineCenterPos(cc.p(160, 368 + var_8_6), {
		var_8_1,
		var_8_0
	}, cc.p(5, 0))
	arg_8_0:get("imgIcon"):hide()

	if arg_8_3 then
		arg_8_0:get("imgBG"):loadTexture(arg_8_3)
	end

	local var_8_7, var_8_8 = arg_8_0:get("imgIcon"):xy()
	local var_8_9 = cc.Sprite:create(arg_8_1):scale(2.2)
	local var_8_10 = ccui.Scale9Sprite:create("city/gate/kunnanzhezhao.png"):scale(3)
	local var_8_11 = cc.ClippingNode:create(var_8_10):setAlphaThreshold(0.1):xy(var_8_7 + var_8_4, var_8_8 + var_8_5):add(var_8_9):addTo(arg_8_0, 4, "clipping")

	var_8_9:xy(0, 0)
end

local function var_0_10(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = arg_9_5 and "effect2" or "effect"

	if arg_9_3 then
		local var_9_1 = 1.6

		arg_9_0:get("levelName"):visible(false)
		arg_9_0:get("textLvNum"):visible(false)
		performWithDelay(arg_9_0, function()
			widget.addAnimationByKey(arg_9_0, "level/emengjiedian.skel", "iconBG", var_9_0, 1):xy(160, 25):addPlay(var_9_0 .. "_loop")
			widget.addAnimationByKey(arg_9_0, "level/emengjiedian.skel", "starSpine", "effect_stardi", 10):xy(160, 25)
		end, 0.3 + arg_9_4)
		performWithDelay(arg_9_0, function()
			var_0_9(arg_9_0, arg_9_1.icon, arg_9_1.sceneName, nil, 1)
		end, var_9_1 + arg_9_4)

		return var_9_1
	else
		widget.addAnimationByKey(arg_9_0, "level/emengjiedian.skel", "iconBG", var_9_0 .. "_loop", 1):xy(160, 25)
		var_0_9(arg_9_0, arg_9_1.icon, arg_9_1.sceneName, nil, 1)

		return 0
	end
end

local function var_0_11(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	if arg_12_3 then
		local var_12_0 = 1.6

		arg_12_0:get("imgBG"):visible(false)
		arg_12_0:get("levelName"):visible(false)
		arg_12_0:get("textLvNum"):visible(false)
		performWithDelay(arg_12_0, function()
			widget.addAnimationByKey(arg_12_0, "level/kunnanjiedian.skel", "iconBG", arg_12_5 and "effect2" or "effect", 1):xy(160, 25)
			widget.addAnimationByKey(arg_12_0, "level/kunnanjiedian.skel", "starSpine", "effect_stardi", 10):xy(160, 25)
		end, 0.3 + arg_12_4)
		performWithDelay(arg_12_0, function()
			var_0_9(arg_12_0, arg_12_1.icon, arg_12_1.sceneName, arg_12_5 and "city/gate/boss.png" or nil, 2)
		end, var_12_0 + arg_12_4)

		return var_12_0
	else
		var_0_9(arg_12_0, arg_12_1.icon, arg_12_1.sceneName, arg_12_5 and "city/gate/boss.png" or nil, 3)

		return 0
	end
end

local function var_0_12(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	if arg_15_3 then
		local var_15_0 = "effect_1"
		local var_15_1 = 2.1

		arg_15_0:get("imgtextBG"):visible(false)
		arg_15_0:get("imgIcon"):visible(false)
		arg_15_0:get("spePanel"):visible(false)

		if arg_15_1.icon then
			var_15_0 = arg_15_5 and "effect_3" or "effect_2"

			arg_15_0:get("spePanel"):get("imgIcon"):texture(arg_15_1.icon)
			arg_15_0:size(cc.size(170, 315))

			local var_15_2 = arg_15_0:get("spePanel"):y()

			arg_15_0:get("spePanel"):y(var_15_2 + 15)
			arg_15_0:anchorPoint(0.5, 0.3)
			performWithDelay(arg_15_2, function()
				arg_15_0:get("spePanel"):visible(true)
			end, var_15_1 + arg_15_4)
		end

		performWithDelay(arg_15_0, function()
			widget.addAnimationByKey(arg_15_0, "level/anniu1.skel", "downSpine", var_15_0, 1):xy(85, 105)
			widget.addAnimationByKey(arg_15_0, "level/anniu1.skel", "starSpine", "effect_stardi", 10):xy(85, 105)
		end, 0.3 + arg_15_4)

		return var_15_1
	else
		local var_15_3 = "city/gate/icon_node_white.png"
		local var_15_4 = "city/gate/icon_node_boss.png"

		if arg_15_1.icon then
			local var_15_5 = "city/gate/icon_node_red.png"

			arg_15_0:get("spePanel"):visible(true)
			arg_15_0:get("imgIcon"):visible(false)
			arg_15_0:get("spePanel"):get("imgIcon"):texture(arg_15_1.icon)
			arg_15_0:size(cc.size(170, 315))
			arg_15_0:anchorPoint(0.5, 0.3)

			if arg_15_5 then
				var_15_4 = "city/gate/icon_node_big_boss.png"
			end
		end

		arg_15_0:get("spePanel"):get("imgTopBG"):texture(var_15_4)

		return 0
	end
end

local var_0_13 = {
	[var_0_0.normal] = {
		starSpineName = "level/anniu1.skel",
		getItem = function(arg_18_0)
			return arg_18_0.levelItem
		end,
		starSpinePos = function(arg_19_0)
			return cc.p(84 + arg_19_0, 93)
		end,
		setItemFunc = var_0_12,
		selIconPos = function(arg_20_0)
			if arg_20_0 then
				return cc.p(85, 140)
			else
				return cc.p(85, 20)
			end
		end
	},
	[var_0_0.hero] = {
		starSpineName = "level/kunnanjiedian.skel",
		getItem = function(arg_21_0)
			return arg_21_0.speItem
		end,
		starSpinePos = function(arg_22_0)
			return cc.p(153 + arg_22_0, 27)
		end,
		setItemFunc = var_0_11,
		selIconPos = function()
			return cc.p(160, 204)
		end
	},
	[var_0_0.nightmare] = {
		starSpineName = "level/emengjiedian.skel",
		getItem = function(arg_24_0)
			return arg_24_0.emItem
		end,
		starSpinePos = function(arg_25_0)
			return cc.p(153 + arg_25_0, 27)
		end,
		setItemFunc = var_0_10,
		selIconPos = function()
			return cc.p(160, 101)
		end
	}
}
local var_0_14 = cc.load("mvc").ViewBase
local var_0_15 = class("GateView", var_0_14)

var_0_15.RESOURCE_FILENAME = "gate.json"
var_0_15.RESOURCE_BINDING = {
	["levelInfo.textNoteNum4"] = "textNoteNum4",
	emLevel = "emItem",
	box = "box",
	speLevel = "speItem",
	level = "levelItem",
	levelInfo = "levelInfo",
	item = "item",
	mask = "mask",
	["leftTip.cloud6"] = "cloud6",
	["leftTip.txt_zj_0_1"] = "labelzj",
	["levelInfo.textNote4"] = "textNote4",
	capture = "capture",
	["leftTip.cloud5"] = "cloud5",
	imgBG2 = {
		varname = "imgBG2",
		binds = {
			event = "texture",
			idler = bindHelper.self("mapType"),
			method = function(arg_27_0)
				return "city/gate/map/img_1.png"
			end
		}
	},
	["leftDown.btnMainLine"] = {
		varname = "btnJuQing",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChangeJuQing")
			}
		}
	},
	["leftDown.btnMainLine.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.ATROVIRENS
				}
			}
		}
	},
	["leftDown.btnDiffect"] = {
		varname = "btnKunNan",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onChangeKunNan")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("heroGateListen")
			}
		}
	},
	["leftDown.btnDiffect.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["leftDown.btnNightmare"] = {
		varname = "btnNightmare",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onChangeNightmare")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("nightGateListen")
			}
		}
	},
	["leftDown.btnNightmare.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.PURPLE
				}
			}
		}
	},
	btnRight = {
		varname = "btnRight",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onMoveRight")
			}
		}
	},
	btnLeft = {
		varname = "btnLeft",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onMoveLeft")
			}
		}
	},
	["leftTip.rightDown"] = {
		varname = "rightDown",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onEnterStarBox")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "levelRightDownGift",
					listenData = {
						chapterId = bindHelper.self("chapterId")
					},
					onNode = function(arg_28_0)
						arg_28_0:xy(250, 250)
					end
				}
			}
		}
	},
	["leftTip.rightDown.textStarNum"] = {
		varname = "textStarNum",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightTop.imgSaveBG"] = {
		varname = "imgSaveBG",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onSaveLevel")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("quickSweep")
			}
		}
	},
	["rightTop.imgSaveBG.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightTop.imgCaptureBG"] = {
		varname = "limitCapture",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onClickResidentCapture")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("captureListen")
			}
		}
	},
	["rightTop.imgCaptureBG.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["levelInfo.textNoteNum1"] = {
		varname = "textNoteNum1",
		binds = {
			event = "text",
			idler = bindHelper.self("worldLevel")
		}
	},
	["levelInfo.textNoteNum2"] = {
		varname = "textNoteNum2",
		binds = {
			event = "text",
			idler = bindHelper.self("roleLevel")
		}
	},
	pageView = {
		varname = "pageView",
		binds = {
			event = "extend",
			class = "pageview",
			props = {
				data = bindHelper.self("levelDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
					arg_29_1:name("page" .. arg_29_3.pageId)
					arg_29_0.initItem(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				end,
				onAfterBuild = function(arg_30_0)
					arg_30_0.afterBuild()
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuild"),
				clickGateItem = bindHelper.self("onClickGateItem"),
				initItem = bindHelper.self("onInitPage"),
				clickBox = bindHelper.self("onClickBox"),
				captureClick = bindHelper.self("onClickCapture")
			}
		}
	}
}

function var_0_15.getCsvIByChapterId(arg_31_0, arg_31_1)
	if not arg_31_0.chaterIdtab then
		arg_31_0.chaterIdtab = {}

		for iter_31_0, iter_31_1 in orderCsvPairs(csv.world_map) do
			if iter_31_1.chapterType then
				if not arg_31_0.chaterIdtab[iter_31_1.chapterType] then
					arg_31_0.chaterIdtab[iter_31_1.chapterType] = {}
				end

				table.insert(arg_31_0.chaterIdtab[iter_31_1.chapterType], iter_31_0)
			end
		end

		for iter_31_2, iter_31_3 in pairs(arg_31_0.chaterIdtab) do
			table.sort(iter_31_3)
		end
	end

	return arg_31_0.chaterIdtab[arg_31_0.mapType:read()][arg_31_1]
end

local function var_0_16(arg_32_0)
	local var_32_0 = csv.world_map
	local var_32_1 = 0

	for iter_32_0, iter_32_1 in orderCsvPairs(var_32_0) do
		if iter_32_1.chapterType == arg_32_0 then
			var_32_1 = var_32_1 + 1
		end
	end

	return var_32_1
end

function var_0_15.onCreate(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0.item:size().width

	arg_33_0.off = (display.sizeInView.width - var_33_0) / 2

	arg_33_0.item:size(display.sizeInView)
	arg_33_0.item:get("topView"):size(display.sizeInView)
	arg_33_0.mask:size(display.sizeInView):anchorPoint(cc.p(0, 0)):x(0)
	arg_33_0.pageView:size(display.sizeInView):x(0)

	for iter_33_0, iter_33_1 in pairs(arg_33_0.item:getChildren()) do
		iter_33_1:anchorPoint(cc.p(0, 0))
		iter_33_1:xy(0, 0)
	end

	arg_33_0.heroGateListen = dataEasy.getListenUnlock(gUnlockCsv.heroGate)
	arg_33_0.captureListen = dataEasy.getListenUnlock(gUnlockCsv.limitCapture)
	arg_33_0.nightGateListen = dataEasy.getListenUnlock(gUnlockCsv.nightmareGate)
	arg_33_0.worldLevelInfoListen = dataEasy.getListenUnlock(gUnlockCsv.worldLevel)
	arg_33_0.quickSweep = dataEasy.getListenUnlock(gUnlockCsv.quickSweep)
	arg_33_0.battleData = userDefault.getForeverLocalKey("gateAddStarNum", {})

	adapt.oneLinePos(arg_33_0.levelInfo:get("textNote1"), arg_33_0.textNoteNum1, cc.p(5, 0))
	adapt.oneLinePos(arg_33_0.levelInfo:get("textNote2"), arg_33_0.textNoteNum2, cc.p(5, 0))
	adapt.oneLinePos(arg_33_0.levelInfo:get("textNote3"), arg_33_0.levelInfo:get("textNoteE3"), cc.p(5, 0))
	adapt.oneLinePos(arg_33_0.levelInfo:get("textNote4"), arg_33_0.textNoteNum4, cc.p(5, 0))
	userDefault.setForeverLocalKey("gateAddStarNum")

	local var_33_1 = 1
	local var_33_2 = 0

	arg_33_1 = tonumber(arg_33_1) or tonumber(arg_33_0.battleData.gateId) or 0

	local var_33_3 = csv.scene_conf
	local var_33_4 = csv.world_map

	if arg_33_1 and arg_33_1 ~= 0 then
		if arg_33_1 % 100 == 0 then
			var_33_1, var_33_2 = dataEasy.getChapterInfoByGateID(arg_33_1)
			arg_33_1 = 0
		else
			local var_33_5 = var_33_3[arg_33_1]

			var_33_1 = var_33_4[var_33_5.ownerId].chapterType
			var_33_2 = var_33_5.ownerId - var_0_1[var_33_1] or 0
		end
	end

	var_33_1 = arg_33_0._mapType or var_33_1
	var_33_2 = arg_33_0._curPageIdx or var_33_2

	if tonumber(arg_33_1) and arg_33_1 ~= 0 and (not arg_33_0.battleData.gateId or tonumber(arg_33_0.battleData.gateId) == 0) and not gGameUI.guideManager:isInGuiding() then
		performWithDelay(arg_33_0, function()
			gGameUI:stackUI("city.gate.section_detail.view", nil, nil, arg_33_1, var_33_2)
		end, 0.016666666666666666)
	end

	arg_33_0:initModel(var_33_1, arg_33_1, var_33_2)
	gGameUI.topuiManager:createView("default", arg_33_0, {
		onClose = arg_33_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_guanqia.png"
	})

	local var_33_6 = {
		arg_33_0.btnJuQing,
		arg_33_0.btnKunNan,
		arg_33_0.btnNightmare
	}

	idlereasy.any({
		arg_33_0.mapOpen,
		arg_33_0.mapType,
		arg_33_0.level,
		arg_33_0.gateOpen
	}, function(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
		arg_33_0.chapterOpen = {}

		for iter_35_0, iter_35_1 in ipairs(arg_35_1) do
			local var_35_0 = var_33_4[iter_35_1].chapterType

			arg_33_0.chapterOpen[var_35_0] = arg_33_0.chapterOpen[var_35_0] or {}

			table.insert(arg_33_0.chapterOpen[var_35_0], iter_35_1)
		end

		for iter_35_2, iter_35_3 in ipairs(arg_33_0.chapterOpen) do
			table.sort(iter_35_3)
		end

		for iter_35_4, iter_35_5 in ipairs(var_33_6) do
			iter_35_5:setTouchEnabled(iter_35_4 ~= arg_35_2)
			iter_35_5:get("selected"):visible(iter_35_4 == arg_35_2)
		end

		arg_33_0:refreshData(arg_35_2)
	end)
	idlereasy.any({
		arg_33_0.mapType,
		arg_33_0.worldLevelInfoListen,
		arg_33_0.level
	}, function(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
		local var_36_0 = dataEasy.getWorldLevelExpAdd(arg_36_1)

		if not var_36_0 then
			arg_33_0.levelInfo:hide()
		elseif arg_36_1 == var_0_0.normal and arg_36_2 then
			arg_33_0.levelInfo:show()
			arg_33_0.textNote4:text(gLanguageCsv.nomalExpAddtext)
			arg_33_0.textNoteNum4:text(var_36_0)

			if matchLanguage({
				"en"
			}) then
				adapt.oneLinePos(arg_33_0.textNote4, arg_33_0.textNoteNum4, cc.p(5, 0))
			end
		elseif arg_36_1 == var_0_0.hero and arg_36_2 then
			arg_33_0.levelInfo:show()
			arg_33_0.textNote4:text(gLanguageCsv.heroExpAddtext)
			arg_33_0.textNoteNum4:text(var_36_0)

			if matchLanguage({
				"en"
			}) then
				adapt.oneLinePos(arg_33_0.textNote4, arg_33_0.textNoteNum4, cc.p(5, 0))
			end
		else
			arg_33_0.levelInfo:hide()
		end
	end)
	idlereasy.any({
		arg_33_0.chapterId,
		arg_33_0.mapStar
	}, function(arg_37_0, arg_37_1, arg_37_2)
		local var_37_0 = false

		if arg_37_2 and arg_37_2[arg_37_1] and arg_37_2[arg_37_1].star_award and itertools.first(arg_37_2[arg_37_1].star_award, 1) ~= nil then
			var_37_0 = true
		end

		if var_37_0 then
			widget.addAnimationByKey(arg_33_0.rightDown, "effect/guanqiabaoxiang.skel", "rewardEffect", "effect_loop", 2):xy(110, 135)
		else
			arg_33_0.rightDown:removeChildByName("rewardEffect")
		end
	end)
	arg_33_0.pageView:setTouchEnabled(false)
	idlereasy.when(arg_33_0.pageIdler, function(arg_38_0, arg_38_1)
		local var_38_0 = arg_33_0.levelDatas:size()
		local var_38_1 = var_0_16(arg_33_0.mapType:read())

		arg_38_1 = cc.clampf(tonumber(arg_38_1), 1, tonumber(var_38_0))

		arg_33_0.btnLeft:visible(arg_38_1 > 1)
		arg_33_0.btnLeft:setTouchEnabled(arg_38_1 > 1)
		arg_33_0.btnRight:visible(arg_38_1 < var_38_1)
		arg_33_0.btnRight:setTouchEnabled(arg_38_1 < var_38_1)
		cache.setShader(arg_33_0.btnLeft, false, arg_38_1 > 1 and "normal" or "hsl_gray")
		cache.setShader(arg_33_0.btnRight, false, arg_38_1 < var_38_0 and "normal" or "hsl_gray")

		local var_38_2 = arg_33_0.levelDatas:atproxy(arg_38_1)
		local var_38_3

		if arg_38_1 == var_38_0 then
			local var_38_4 = itertools.size(var_38_2.seq)

			var_38_3 = var_38_2.seq[var_38_4]
		elseif arg_33_0.selGateIdx.chapterId == arg_38_1 then
			var_38_3 = arg_33_0.selGateIdx.gateId ~= 0 and arg_33_0.selGateIdx.gateId or var_38_2.seq[1]
		else
			var_38_3 = var_38_2.seq[1]
		end

		arg_33_0.levelDatas:atproxy(arg_38_1).selGateId = var_38_3
		arg_33_0.levelDatas:atproxy(arg_38_1).isShow = true

		arg_33_0.pageView:setCurrentPageIndex(arg_38_1 - 1)

		local var_38_5 = var_38_2.chapterId

		arg_33_0.chapterId:set(var_38_5)

		local var_38_6 = string.format(gLanguageCsv.levelChapterId, arg_38_1) .. " " .. csv.world_map[var_38_5].name

		if matchLanguage({
			"en"
		}) then
			local var_38_7 = string.format(gLanguageCsv.levelChapterId, arg_38_1) .. " " .. csv.world_map[var_38_5].name
		end

		arg_33_0:onRefreshStarNum()
	end)
	uiEasy.addTouchOneByOne(arg_33_0.mask, {
		ended = function(arg_39_0, arg_39_1, arg_39_2)
			if arg_39_1 > 100 and math.abs(arg_39_1) > math.abs(arg_39_2) then
				arg_33_0:onMoveLeft()
			elseif arg_39_1 < -100 and math.abs(arg_39_1) > math.abs(arg_39_2) then
				arg_33_0:onMoveRight()
			end
		end
	})
	arg_33_0:setRedHint()

	local var_33_7, var_33_8, var_33_9 = dataEasy.isDoubleHuodong("gateDrop")

	if var_33_7 then
		for iter_33_2, iter_33_3 in pairs(var_33_8) do
			local var_33_10 = iter_33_3.start
			local var_33_11 = dataEasy.getChapterInfoByGateID(var_33_10)

			if var_33_11 == 1 then
				arg_33_0.btnJuQing:get("flagImg"):show()
			elseif var_33_11 == 2 then
				arg_33_0.btnKunNan:get("flagImg"):show()
			elseif var_33_11 == 3 then
				arg_33_0.btnNightmare:get("flagImg"):show()
			end
		end
	end

	local var_33_12, var_33_13, var_33_14 = dataEasy.isDoubleHuodong("heroGateTimes")

	if var_33_12 then
		for iter_33_4, iter_33_5 in pairs(var_33_13) do
			local var_33_15 = iter_33_5.count

			if var_33_15 and var_33_15 > 0 then
				arg_33_0.btnKunNan:get("heroGateTimesBg"):show()
			end
		end
	end
end

function var_0_15.setSelEffect(arg_40_0, arg_40_1, arg_40_2)
	if not arg_40_0.selEffect then
		arg_40_0.selEffect = CSprite.new("level/xuanguan.skel")

		arg_40_0.selEffect:play("effect_loop")
		arg_40_0.selEffect:visible(false)
		arg_40_0.selEffect:retain()
	end

	if arg_40_1 and arg_40_2 and arg_40_0.selEffect then
		arg_40_0.selEffect:removeFromParent()
		arg_40_0.selEffect:addTo(arg_40_1, 100, "selEffect")
		arg_40_0.selEffect:xy(arg_40_2)
		arg_40_0.selEffect:retain()

		return arg_40_0.selEffect
	end
end

function var_0_15.initModel(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	arg_41_0.mapOpen = gGameModel.role:getIdler("map_open")
	arg_41_0.gateOpen = gGameModel.role:getIdler("gate_open")
	arg_41_0.gateStar = gGameModel.role:getIdler("gate_star")
	arg_41_0.level = gGameModel.role:getIdler("level")
	arg_41_0.mapStar = gGameModel.role:getIdler("map_star")
	arg_41_0.captOpen = gGameModel.capture:getIdler("gate_sprites")
	arg_41_0.limitDatas = gGameModel.capture:getIdler("limit_sprites")
	arg_41_0.worldLevel = gGameModel.global_record:getIdler("world_level")
	arg_41_0.roleLevel = gGameModel.role:getIdler("level")
	arg_41_0.levelDatas = idlers.newWithMap({})
	arg_41_0.mapType = idler.new(arg_41_1)
	arg_41_0.selGateIdx = {
		gateId = arg_41_2,
		chapterId = arg_41_3
	}
	arg_41_0.curPageIdx = arg_41_3
	arg_41_0.pageIdler = idler.new(arg_41_0.curPageIdx)
	arg_41_0.chapterId = idler.new(0)
	arg_41_0.captureShow = idler.new(false)
end

function var_0_15.setRedHint(arg_42_0)
	bind.extend(arg_42_0, arg_42_0.btnRight, {
		class = "red_hint",
		props = {
			specialTag = "levelRightBtnGift",
			listenData = {
				chapterId = bindHelper.self("chapterId"),
				mapType = bindHelper.self("mapType")
			},
			onNode = function(arg_43_0)
				arg_43_0:xy(arg_43_0:x() - 66, arg_43_0:y() - 5):scale(0.66)
			end
		}
	})
	bind.extend(arg_42_0, arg_42_0.btnLeft, {
		class = "red_hint",
		props = {
			specialTag = "levelLeftBtnGift",
			listenData = {
				chapterId = bindHelper.self("chapterId"),
				mapType = bindHelper.self("mapType")
			},
			onNode = function(arg_44_0)
				arg_44_0:xy(arg_44_0:x() - 66, arg_44_0:y() - 5):scale(0.66)
			end
		}
	})
	bind.extend(arg_42_0, arg_42_0.btnJuQing, {
		class = "red_hint",
		props = {
			specialTag = "levelBtnJuQingGift",
			listenData = {
				chapterId = bindHelper.self("chapterId"),
				mapType = bindHelper.self("mapType")
			},
			onNode = function(arg_45_0)
				arg_45_0:x(arg_45_0:x())
				arg_45_0:y(arg_45_0:y()):scale(0.75)
			end
		}
	})
	bind.extend(arg_42_0, arg_42_0.btnKunNan, {
		class = "red_hint",
		props = {
			specialTag = "levelBtnKunNanGift",
			listenData = {
				chapterId = bindHelper.self("chapterId"),
				mapType = bindHelper.self("mapType")
			},
			onNode = function(arg_46_0)
				arg_46_0:x(arg_46_0:x())
				arg_46_0:y(arg_46_0:y()):scale(0.75)
			end
		}
	})
	bind.extend(arg_42_0, arg_42_0.btnNightmare, {
		class = "red_hint",
		props = {
			specialTag = "levelBtnNightMareGift",
			listenData = {
				chapterId = bindHelper.self("chapterId"),
				mapType = bindHelper.self("mapType")
			},
			onNode = function(arg_47_0)
				arg_47_0:x(arg_47_0:x())
				arg_47_0:y(arg_47_0:y()):scale(0.75)
			end
		}
	})
	bind.extend(arg_42_0, arg_42_0.limitCapture, {
		class = "red_hint",
		props = {
			showType = "new",
			specialTag = "limitCapture",
			listenData = {
				captureShow = bindHelper.self("captureShow")
			},
			onNode = function(arg_48_0)
				arg_48_0:scale(0.5)
				arg_48_0:xy(arg_42_0.limitCapture:size().width, arg_42_0.limitCapture:size().height - 12)
			end
		}
	})
end

function var_0_15.refreshData(arg_49_0, arg_49_1)
	local var_49_0 = userDefault.getForeverLocalKey("isEnterLevelFirst", {})[arg_49_1] ~= false
	local var_49_1 = csv.world_map
	local var_49_2 = {}
	local var_49_3 = arg_49_0.gateStar:read()

	for iter_49_0, iter_49_1 in ipairs(arg_49_0.chapterOpen[arg_49_1] or {}) do
		local var_49_4 = var_49_1[iter_49_1]
		local var_49_5 = var_49_4.baseMap

		if not var_49_4.isWorldEnter and var_49_4.chapterType == arg_49_0.mapType:read() and arg_49_0.level:read() >= var_49_4.openLevel then
			local var_49_6 = false

			if arg_49_0.selGateIdx.chapterId ~= 0 then
				var_49_6 = arg_49_0.selGateIdx.chapterId == iter_49_0
			end

			local var_49_7 = table.deepcopy(var_49_1[iter_49_1].seq, true)
			local var_49_8 = {}
			local var_49_9 = true

			for iter_49_2, iter_49_3 in ipairs(var_49_7) do
				var_49_8[iter_49_3] = var_49_3[iter_49_3]

				local var_49_10 = 0

				if var_49_3[iter_49_3] then
					var_49_10 = var_49_3[iter_49_3].star or 0
				end

				if var_49_10 == 0 then
					var_49_9 = false
				end
			end

			local var_49_11 = {
				showSelectedIcon = true,
				baseMap = var_49_5,
				pageId = iter_49_0,
				chapterId = iter_49_1,
				seq = var_49_7,
				isShow = var_49_6,
				selGateId = arg_49_0.selGateIdx.gateId,
				starInfo = var_49_8,
				isFirstEnter = var_49_0,
				levelType = arg_49_1,
				battleData = arg_49_0.battleData,
				isCompleted = var_49_9
			}

			table.insert(var_49_2, var_49_11)
		end
	end

	table.sort(var_49_2, function(arg_50_0, arg_50_1)
		return arg_50_0.pageId < arg_50_1.pageId
	end)

	if #var_49_2 <= 0 then
		return
	end

	local var_49_12 = #var_49_2
	local var_49_13 = false

	if arg_49_0.curPageIdx == 0 then
		var_49_2[var_49_12].isShow = true
		arg_49_0.curPageIdx = var_49_12
		var_49_13 = true
	end

	local var_49_14 = arg_49_0.gateOpen:read()
	local var_49_15 = var_49_2[var_49_12].seq

	for iter_49_4 = #var_49_15, 1, -1 do
		local var_49_16 = var_49_15[iter_49_4]
		local var_49_17 = false

		if arg_49_1 == var_0_0.nightmare then
			local var_49_18 = var_49_15[iter_49_4 - 1]

			if iter_49_4 == 1 then
				var_49_17 = true
			elseif itertools.include(var_49_14, var_49_18) and var_49_3[var_49_16] then
				var_49_17 = true
			end
		end

		if itertools.include(var_49_14, var_49_16) or var_49_17 then
			if arg_49_0.selGateIdx.gateId == 0 then
				var_49_2[var_49_12].selGateId = var_49_16
				var_49_2[var_49_12].pageId = var_49_12
			end

			break
		end

		table.remove(var_49_15)
	end

	local var_49_19 = math.min(arg_49_0.curPageIdx + 1, var_49_12)

	if arg_49_0:isNeedPlayAction(var_49_19, var_49_2) then
		arg_49_0.nextPageIdx = var_49_19
		var_49_2[var_49_19].isPlayAnimation = true
	end

	arg_49_0.levelDatas:update(var_49_2)

	if var_49_13 then
		arg_49_0.pageIdler:set(var_49_12, true)
	else
		arg_49_0.pageIdler:notify()
	end
end

function var_0_15.isNeedPlayAction(arg_51_0, arg_51_1, arg_51_2)
	local var_51_0 = arg_51_2[arg_51_1].seq

	if arg_51_1 > 1 and #var_51_0 == 1 and not arg_51_0.gateStar:read()[var_51_0[1]] then
		local var_51_1 = arg_51_2[arg_51_1 - 1].seq
		local var_51_2 = var_51_1[#var_51_1]
		local var_51_3 = arg_51_0.gateStar:read()
		local var_51_4 = var_51_3[var_51_2] and var_51_3[var_51_2].star

		if var_51_2 == tonumber(arg_51_0.battleData.gateId) and var_51_4 - (tonumber(arg_51_0.battleData.starAdd) or 0) == 0 then
			return true
		end
	end

	return false
end

function var_0_15.onInitPage(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4, arg_52_5)
	if not arg_52_5.isShow then
		return
	end

	local var_52_0 = csv.scene_conf
	local var_52_1 = arg_52_0.mapType:read()
	local var_52_2 = var_0_13[var_52_1] or var_0_13[var_0_0.hero]
	local var_52_3 = var_52_2.getItem(arg_52_0)

	if arg_52_0.nextPageIdx then
		arg_52_3:get("topView"):visible(true)
	else
		arg_52_3:get("topView"):visible(false)
	end

	local var_52_4 = tonumber(arg_52_5.battleData.gateId)
	local var_52_5 = false
	local var_52_6 = csv.world_map[arg_52_5.chapterId].seq
	local var_52_7 = csvSize(var_52_6)
	local var_52_8 = 0

	arg_52_3:get("imgBG"):texture(arg_52_5.baseMap)
	arg_52_0.cloud6:texture("city/gate/txt_gate_" .. arg_52_4 .. ".png"):scale(2)
	arg_52_0.labelzj:text(arg_52_4)

	for iter_52_0, iter_52_1 in ipairs(arg_52_5.seq) do
		local var_52_9 = "gate" .. iter_52_0
		local var_52_10 = arg_52_3:get(var_52_9)
		local var_52_11 = var_52_0[iter_52_1]

		if not var_52_10 then
			var_52_10 = var_52_3:clone()

			arg_52_3:addChild(var_52_10, 10, var_52_9)
			var_52_10:visible(true)
			bind.touch(arg_52_2, var_52_10, {
				methods = {
					ended = functools.partial(arg_52_2.clickGateItem, arg_52_4, arg_52_5, iter_52_1)
				}
			})
			var_52_10:xy(var_52_11.pos.x + arg_52_0.off, var_52_11.pos.y)

			local var_52_12 = var_52_5 or arg_52_5.isPlayAnimation
			local var_52_13 = arg_52_5.starInfo[iter_52_1] or {}
			local var_52_14 = var_52_13.star or 0
			local var_52_15 = var_52_4 == iter_52_1 and tonumber(arg_52_5.battleData.starAdd) or 0

			var_52_5 = var_0_4(var_52_4, iter_52_1, var_52_15, var_52_14)
			var_52_12 = var_0_5(arg_52_5, iter_52_0, arg_52_4, var_52_14) or var_52_12

			local var_52_16 = var_0_7(arg_52_3, var_52_11, arg_52_0.off)

			for iter_52_2, iter_52_3 in ipairs(var_52_16) do
				performWithDelay(arg_52_3, function()
					iter_52_3:visible(true)
				end, var_52_12 and 0.3 + iter_52_2 * 0.2 or 0)
			end

			local function var_52_17(arg_54_0, arg_54_1, arg_54_2)
				local var_54_0 = arg_52_0.box:clone():xy(arg_54_0):name(arg_54_1):visible(false):addTo(arg_52_3, 100)

				if arg_54_2 == 0 then
					var_54_0:get("imgBox"):texture("common/icon/icon_open_bx.png")
				end

				bind.touch(arg_52_2, var_54_0, {
					methods = {
						ended = functools.partial(arg_52_2.clickBox, iter_52_1, var_52_11.chestAward, iter_52_0)
					}
				})
				var_0_6(arg_52_2, var_54_0, arg_54_2 == 1, iter_52_0, iter_52_1)

				return var_54_0
			end

			if var_52_11.awardPos and var_52_14 > 0 then
				var_52_8 = var_52_8 + 1

				local var_52_18 = var_52_17(cc.p(var_52_11.awardPos.x + arg_52_0.off, var_52_11.awardPos.y), "box" .. var_52_8, var_52_13.chest)

				performWithDelay(arg_52_3, function()
					var_52_18:visible(true)
				end, var_52_12 and gCommonConfigCsv.levelBoxDelayTime or 0)
			end

			if var_52_12 then
				for iter_52_4 = 1, 3 do
					var_52_10:get("imgStar" .. iter_52_4):visible(false)
				end
			end

			var_0_8(var_52_10, var_52_14, var_52_15, var_52_2)

			local var_52_19 = 0.3 + 0.2 * #var_52_16
			local var_52_20 = var_52_2.setItemFunc(var_52_10, var_52_11, arg_52_3, var_52_12, var_52_19, iter_52_0 == var_52_7)

			local function var_52_21()
				local var_56_0 = var_52_2.selIconPos(var_52_11.icon)

				if not var_52_11.icon then
					var_52_10:get("spePanel"):visible(false)
				end

				if arg_52_5.selGateId == iter_52_1 then
					(var_52_10:getChildByName("selEffect") or arg_52_0:setSelEffect(var_52_10, var_56_0)):visible(true)
				end

				if var_52_1 == var_0_0.normal and not var_52_11.icon and not var_52_12 then
					var_52_10:get("imgIcon"):visible(true)
				end

				arg_52_5.showSelectedIcon = true

				var_52_10:get("textLvNum"):text(arg_52_5.pageId .. "-" .. iter_52_0)
				var_52_10:setTouchEnabled(true)

				if arg_52_0.nextPageIdx and tonumber(arg_52_0.battleData.gateId) == iter_52_1 then
					performWithDelay(var_52_10, function()
						arg_52_0.levelDatas:atproxy(arg_52_0.nextPageIdx).isShow = true

						arg_52_0.pageIdler:modify(function(arg_58_0)
							arg_58_0 = cc.clampf(arg_58_0 + 1, 1, arg_52_0.levelDatas:size())

							return true, arg_58_0
						end)
						arg_52_3:get("topView"):visible(false)

						arg_52_0.nextPageIdx = nil
					end, 0.5)
				end
			end

			if var_52_20 == 0 then
				var_52_21()
			else
				performWithDelay(arg_52_3, var_52_21, var_52_20 + var_52_19)
			end

			if var_52_14 > 0 then
				local var_52_22 = gGateCaptureCsv[iter_52_1]

				if var_52_22 then
					dataEasy.getListenUnlock(gUnlockCsv.gateCapture, function(arg_59_0)
						if arg_59_0 and arg_52_0.captOpen and not arg_52_0.captOpen:read()[var_52_22] then
							arg_52_3:removeChildByName("captureEnter" .. iter_52_1)

							local var_59_0 = csv.capture.sprite[var_52_22]
							local var_59_1 = csv.unit[csv.cards[var_59_0.cardID].unitID]
							local var_59_2 = arg_52_0.capture:clone():visible(true):xy(var_59_0.gatePos.x + arg_52_0.off, var_59_0.gatePos.y):addTo(arg_52_3, 100, "captureEnter" .. iter_52_1)

							var_59_2:get("imgIcon"):texture(var_59_1.iconSimple)
							bind.touch(arg_52_2, var_59_2, {
								methods = {
									ended = functools.partial(arg_52_2.captureClick, var_52_22, var_59_0, var_59_2)
								}
							})
						end
					end):anonyOnly(arg_52_2, "onInitPage" .. arg_52_4)
				end
			end
		elseif arg_52_5.showSelectedIcon and arg_52_5.selGateId == iter_52_1 then
			local var_52_23 = var_52_10:getChildByName("selEffect")

			if not var_52_23 then
				local var_52_24 = var_52_2.selIconPos(var_52_11.icon)

				var_52_23 = arg_52_0:setSelEffect(var_52_10, var_52_24)
			end

			var_52_23:visible(true)
		end
	end
end

function var_0_15.onClickCapture(arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4)
	local var_60_0 = {
		captureData = arg_60_3,
		captureID = arg_60_2,
		node = arg_60_4
	}

	gGameUI:stackUI("city.capture.capture_entrace", nil, nil, var_60_0)
end

function var_0_15.onRefreshStarNum(arg_61_0)
	local var_61_0 = arg_61_0.gateStar:read()
	local var_61_1 = 0
	local var_61_2 = 0
	local var_61_3 = csv.world_map[arg_61_0.levelDatas:atproxy(arg_61_0.pageIdler:read()).chapterId].seq

	for iter_61_0, iter_61_1 in ipairs(var_61_3) do
		var_61_2 = var_61_2 + ((var_61_0[iter_61_1] or {}).star or 0)
		var_61_1 = var_61_1 + 3
	end

	arg_61_0.textStarNum:text(var_61_2 .. "/" .. var_61_1)
end

function var_0_15.onChangeJuQing(arg_62_0, arg_62_1, arg_62_2)
	arg_62_0.curPageIdx = 0

	arg_62_0.mapType:set(var_0_0.normal)
end

function var_0_15.onChangeKunNan(arg_63_0, arg_63_1, arg_63_2)
	arg_63_0.curPageIdx = 0

	arg_63_0.mapType:set(var_0_0.hero)
end

function var_0_15.onChangeNightmare(arg_64_0, arg_64_1, arg_64_2)
	arg_64_0.curPageIdx = 0

	arg_64_0.mapType:set(var_0_0.nightmare)
end

function var_0_15.checkPreGateIsPass(arg_65_0, arg_65_1, arg_65_2)
	local var_65_0 = gNightmareForCsv[arg_65_1]

	if var_65_0 then
		local var_65_1 = csv.world_map[var_65_0]

		if not itertools.include(arg_65_0.chapterOpen[var_65_1.chapterType], var_65_0) then
			local var_65_2 = {
				[var_0_0.normal] = gLanguageCsv.pleasePassGateNormal,
				[var_0_0.hero] = gLanguageCsv.pleasePassGateDifficult,
				[var_0_0.nightmare] = gLanguageCsv.pleasePassGateNightMare
			}

			if arg_65_2 then
				gGameUI:showTip(string.format(var_65_2[var_65_1.chapterType], var_65_0 - var_0_1[var_65_1.chapterType]))
			end

			return false
		end
	else
		return arg_65_0.mapType:read() ~= var_0_0.nightmare
	end

	return true
end

function var_0_15.checkChapterOpen(arg_66_0, arg_66_1)
	local var_66_0 = arg_66_0:getCsvIByChapterId(arg_66_1)

	if not var_66_0 then
		return false
	end

	local var_66_1 = csv.world_map[var_66_0].openLevel

	if var_66_1 > arg_66_0.level:read() then
		gGameUI:showTip(string.format(gLanguageCsv.levelUnLock, var_66_1))

		return false
	end

	if not arg_66_0:checkPreGateIsPass(var_66_0, true) then
		return false
	end

	if arg_66_0.levelDatas:atproxy(math.max(1, arg_66_1 - 1)).isCompleted == false then
		gGameUI:showTip(gLanguageCsv.pleasePassCurPage)

		return false
	end

	if arg_66_1 > #arg_66_0.chapterOpen[1] then
		gGameUI:showTip(gLanguageCsv.pleasePassNormalCurPage)

		return false
	end

	return true
end

function var_0_15.onMoveRight(arg_67_0, arg_67_1, arg_67_2)
	arg_67_0.pageIdler:modify(function(arg_68_0)
		local var_68_0 = arg_68_0 + 1

		if arg_67_0:checkChapterOpen(var_68_0) then
			return true, var_68_0
		else
			return false
		end
	end)
end

function var_0_15.onMoveLeft(arg_69_0, arg_69_1, arg_69_2)
	arg_69_0.pageIdler:modify(function(arg_70_0)
		local var_70_0 = arg_70_0 - 1

		arg_70_0 = cc.clampf(var_70_0, 1, arg_69_0.levelDatas:size())

		return true, arg_70_0
	end)
end

function var_0_15.onAfterBuild(arg_71_0, arg_71_1)
	arg_71_1:setCurPageIndex(arg_71_0.curPageIdx - 1)

	local var_71_0 = arg_71_0.levelDatas:atproxy(arg_71_0.curPageIdx)
	local var_71_1 = var_71_0.selGateId
	local var_71_2 = var_71_0.chapterId
	local var_71_3 = string.format(gLanguageCsv.levelChapterId, arg_71_0.curPageIdx) .. " " .. csv.world_map[var_71_2].name

	if matchLanguage({
		"en"
	}) then
		local var_71_4 = string.format(gLanguageCsv.levelChapterId, arg_71_0.curPageIdx) .. " " .. csv.world_map[var_71_2].name
	end
end

function var_0_15.onClickGateItem(arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4, arg_72_5, arg_72_6)
	arg_72_0.levelDatas:atproxy(arg_72_2).selGateId = arg_72_4
	arg_72_0.selGateIdx.gateId = arg_72_4

	gGameUI:stackUI("city.gate.section_detail.view", nil, nil, arg_72_4, arg_72_3.pageId)
end

function var_0_15.onEnterStarBox(arg_73_0)
	gGameUI:stackUI("city.gate.section_detail.box", nil, nil, arg_73_0.levelDatas:atproxy(arg_73_0.pageIdler:read()).chapterId)
end

function var_0_15.onClickBox(arg_74_0, arg_74_1, arg_74_2, arg_74_3, arg_74_4, arg_74_5, arg_74_6, arg_74_7)
	local var_74_0 = arg_74_0.gateStar:read()[arg_74_2].chest

	if var_74_0 == -1 then
		return
	end

	if var_74_0 == 1 then
		local var_74_1 = {
			false
		}

		gGameApp:requestServerCustom("/game/role/gate/award"):params(arg_74_2, "chest"):onResponse(function()
			arg_74_6:get("imgBox"):texture("common/icon/icon_open_bx.png")
			uiEasy.setBoxEffect(arg_74_6, 1, function()
				var_74_1[1] = true
			end)
			var_0_6(arg_74_1, arg_74_6, false, arg_74_4, arg_74_2)
		end):wait(var_74_1):doit(function(arg_77_0)
			gGameUI:showGainDisplay(arg_77_0)
		end)

		return
	end

	gGameUI:showBoxDetail({
		content = "",
		data = arg_74_3,
		state = var_74_0,
		btnText = gLanguageCsv.received
	})
end

function var_0_15.onSaveLevel(arg_78_0, arg_78_1, arg_78_2)
	gGameUI:stackUI("city.gate.quick_like", nil, nil, nil)
end

function var_0_15.onClickResidentCapture(arg_79_0, arg_79_1, arg_79_2)
	gGameUI:stackUI("city.capture.capture_limit", nil, nil, arg_79_0:createHandler("removeNewRedHint"))
end

function var_0_15.removeNewRedHint(arg_80_0, arg_80_1)
	arg_80_0.captureShow:set(arg_80_1)
end

function var_0_15.onCleanup(arg_81_0)
	if arg_81_0.selEffect then
		arg_81_0.selEffect:release()

		arg_81_0.selEffect = nil
	end

	arg_81_0._mapType = arg_81_0.mapType:read()
	arg_81_0._curPageIdx = arg_81_0.pageIdler:read()

	var_0_14.onCleanup(arg_81_0)
end

function var_0_15.cloudAnimation(arg_82_0, arg_82_1)
	local var_82_0 = arg_82_0:getResourceNode()
	local var_82_1 = 1.2333333333333334
	local var_82_2 = "jq"

	if arg_82_1 == var_0_0.hero then
		var_82_2 = "kn"
	elseif arg_82_1 == var_0_0.nightmare then
		var_82_2 = "em"
	end

	for iter_82_0 = 1, 6 do
		arg_82_0["cloud" .. iter_82_0]:texture("city/gate/img_cloud" .. iter_82_0 .. "_" .. var_82_2 .. ".png")
		arg_82_0["cloud" .. iter_82_0]:xy(arg_82_0.cloudInitPos[iter_82_0].x, arg_82_0.cloudInitPos[iter_82_0].y)
	end

	arg_82_0["cloud" .. 2]:visible(false)
	arg_82_0["cloud" .. 6]:visible(false)

	if arg_82_1 == var_0_0.nightmare then
		transition.executeSequence(arg_82_0.sun, true):moveTo(var_82_1, var_82_0:width() / 2, display.height - 20):done()
	end
end

return var_0_15
