local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("TotemInsetView", var_0_0)
local var_0_2 = require("app.views.city.develop.totem.tools")
local var_0_3 = {
	"dot11",
	"dot12",
	"dot13",
	"dot21",
	"dot22",
	"dot23",
	"dot31",
	"dot32",
	"dot33"
}

local function var_0_4(arg_1_0, arg_1_1)
	if arg_1_1 then
		text.addEffect(arg_1_0, {
			color = cc.c4b(255, 252, 237, 255),
			outline = {
				size = 3,
				color = ui.COLORS.OUTLINE.DEFAULT
			}
		})
	else
		text.addEffect(arg_1_0, {
			color = cc.c4b(182, 182, 182, 255),
			outline = {
				size = 3,
				color = ui.COLORS.OUTLINE.DEFAULT
			}
		})
	end
end

local function var_0_5(arg_2_0)
	text.addEffect(arg_2_0, {
		outline = {
			size = 3,
			color = ui.COLORS.OUTLINE.DEFAULT
		}
	})
end

local function var_0_6(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = csv.totem.symbol[arg_3_1]
	local var_3_1 = itertools.size(var_3_0.totemGroup1)
	local var_3_2 = {}

	for iter_3_0, iter_3_1 in ipairs(var_0_2.dotArrangeType[var_3_1]) do
		local var_3_3 = arg_3_2[iter_3_0]

		if var_3_3 then
			local var_3_4 = csv.items[var_3_3].specialArgsMap.ease and 2 or 1

			var_3_2[iter_3_1] = {
				type = var_3_4
			}
		else
			var_3_2[iter_3_1] = {
				type = 0
			}
		end
	end

	for iter_3_2, iter_3_3 in pairs(var_0_3) do
		local var_3_5 = arg_3_0.get(arg_3_0, iter_3_3)

		if var_3_2[iter_3_2] then
			var_3_5:show()
		else
			var_3_5.hide(var_3_5)
		end
	end
end

var_0_1.RESOURCE_FILENAME = "totem_inset.json"
var_0_1.RESOURCE_BINDING = {
	bg = "bg",
	leftItem = "leftItem",
	rightItem = "rightItem",
	leaf = "leaf",
	["tipMask.img"] = "tipMaskImg",
	downPanel = "downPanel",
	icon = "icon",
	centerPanel = "centerPanel",
	["rightPanel.active"] = "active",
	["tipMask.txt"] = "tipMaskTxt",
	["rightPanel.item"] = "rightPanelItem",
	tipMask = "tipMask",
	rightPanel = "rightPanel",
	["rightPanel.iconList"] = {
		varname = "iconList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 10,
				padding = 0,
				data = bindHelper.self("iconListData"),
				item = bindHelper.self("icon"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					arg_4_1.texture(arg_4_1, ui.ATTR_ICON[arg_4_3])
					arg_4_1.scale(arg_4_1, 0.86)
				end
			}
		}
	},
	["leftPanel.list"] = {
		varname = "leftList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 7,
				margin = 20,
				padding = 2,
				dataOrderCmpGen = bindHelper.self("onSortList", true),
				data = bindHelper.self("leftListData"),
				item = bindHelper.self("leftItem"),
				insetedTotemsData = bindHelper.self("insettedTotem"),
				showTab = bindHelper.self("selectNum"),
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = arg_5_1:multiget("text", "dotPanel", "whiteBg", "redBg")

					var_5_0.text:setAnchorPoint(cc.p(0.5, 0.5))
					var_5_0.text:xy(cc.p(273, 66))
					var_5_0.text:text(csv.totem.symbol[arg_5_3.id].name)
					adapt.setTextScaleWithWidth(var_5_0.text, nil, 260)

					local var_5_1 = arg_5_0.insetedTotemsData:read()[arg_5_3.id] or {}

					var_0_6(var_5_0.dotPanel, arg_5_3.id, var_5_1)
					var_5_0.whiteBg:visible(arg_5_3.isSelect ~= true)
					var_5_0.redBg:visible(arg_5_3.isSelect == true)
					bind.touch(arg_5_0, arg_5_1, {
						methods = {
							ended = functools.partial(arg_5_0.clickLeftItem, arg_5_2)
						}
					})
					bind.extend(arg_5_0, arg_5_1, {
						class = "red_hint",
						props = {
							specialTag = "totemCanActive",
							state = arg_5_0.showTab:read() ~= arg_5_2,
							listenData = {
								csvId = arg_5_3.id
							},
							onNode = function(arg_6_0)
								arg_6_0:xy(460, 135)
							end
						}
					})
				end
			},
			handlers = {
				clickLeftItem = bindHelper.self("onLeftItemClick")
			}
		}
	},
	leftPanel = {
		varname = "filterPanel",
		binds = {
			event = "extend",
			class = "sort_menus",
			props = {
				btnHeight = 110,
				height = 110,
				btnWidth = 450,
				btnType = 5,
				width = 450,
				data = bindHelper.self("sortTabData"),
				btnClick = bindHelper.self("onSortMenusBtnClick", true),
				onNode = function(arg_7_0)
					arg_7_0:xy(-1025, 580):z(20)
				end
			}
		}
	},
	["leftPanel.fastInset"] = {
		varname = "btnFastInset",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onFastInset")
			}
		}
	},
	["leftPanel.upFilter"] = {
		varname = "upOrDownFilter",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onUpFliterClick")
			}
		}
	},
	["rightPanel.btn"] = {
		varname = "btnOneClickInset",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onOneClickInset")
			}
		}
	},
	["rightPanel.exTips"] = {
		varname = "exTips",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_8_0)
					return arg_8_0.onTipsClick(arg_8_0, true)
				end)
			}
		}
	},
	["rightPanel.normalAttr"] = {
		varname = "normalAttr",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 20,
				padding = 10,
				data = bindHelper.self("rightAttrData"),
				item = bindHelper.self("rightPanelItem"),
				onItem = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
					local var_9_0 = arg_9_1.multiget(arg_9_1, "icon", "text", "number")
					local var_9_1 = gLanguageCsv["attr" .. string.caption(game.ATTRDEF_TABLE[arg_9_3.type])]
					local var_9_2 = ui.ATTR_LOGO[game.ATTRDEF_TABLE[arg_9_3.type]]

					if var_9_2 then
						var_9_0.icon:texture(var_9_2)
					else
						var_9_0.icon:hide()
						var_9_0.text:xy(15, 29)
					end

					var_9_0.text:text(var_9_1)
					var_9_0.number:text("+" .. dataEasy.getAttrValueString(arg_9_3.type, arg_9_3.num))
					text.addEffect(var_9_0.text, {
						color = ui.COLORS.NORMAL.WHITE
					})
					var_0_5(var_9_0.text)
					var_0_4(var_9_0.number, arg_9_3.isActive)
					text.addEffect(var_9_0.number, {
						outline = {
							size = 3,
							color = cc.c4b(91, 84, 91)
						}
					})
					adapt.oneLinePos(var_9_0.text, var_9_0.number, cc.p(50, 0))
				end
			}
		}
	},
	["rightPanel.exAttr"] = {
		varname = "exAttr",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 20,
				padding = 0,
				data = bindHelper.self("rightExAttrData"),
				item = bindHelper.self("rightPanelItem"),
				onItem = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
					local var_10_0 = arg_10_1.multiget(arg_10_1, "icon", "text", "number")
					local var_10_1 = gLanguageCsv["attr" .. string.caption(game.ATTRDEF_TABLE[arg_10_3.type])]
					local var_10_2 = ui.ATTR_LOGO[game.ATTRDEF_TABLE[arg_10_3.type]]

					if var_10_2 then
						var_10_0.icon:texture(var_10_2)
					else
						var_10_0.icon:hide()
						var_10_0.text:xy(15, 29)
					end

					var_10_0.text:text(var_10_1)
					var_10_0.number:text("+" .. dataEasy.getAttrValueString(arg_10_3.type, arg_10_3.num))
					text.addEffect(var_10_0.text, {
						color = cc.c4b(255, 166, 102, 255)
					})
					text.addEffect(var_10_0.text, {
						outline = {
							size = 3,
							color = cc.c4b(91, 84, 91)
						}
					})

					if arg_10_3.isActive then
						text.addEffect(var_10_0.number, {
							color = cc.c4b(255, 252, 237)
						})
					else
						text.addEffect(var_10_0.number, {
							color = cc.c4b(182, 182, 182)
						})
					end

					if arg_10_3.isActive then
						text.addEffect(var_10_0.number, {
							color = cc.c4b(255, 252, 237)
						})
					else
						text.addEffect(var_10_0.number, {
							color = cc.c4b(128, 128, 128)
						})
					end

					var_0_5(var_10_0.text)
					var_0_4(var_10_0.number, arg_10_3.isActive)
					text.addEffect(var_10_0.number, {
						outline = {
							size = 3,
							color = cc.c4b(91, 84, 91)
						}
					})
					adapt.oneLinePos(var_10_0.text, var_10_0.number, cc.p(50, 0))
				end
			}
		}
	},
	["rightPanel.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91)
				}
			}
		}
	},
	["rightPanel.extraAddTitle"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91)
				}
			}
		}
	},
	["downPanel.totemNum"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91)
				}
			}
		}
	},
	["downPanel.totemAvail"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91)
				}
			}
		}
	},
	["tipMask.mask"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_11_0)
					return arg_11_0.onTipsClick(arg_11_0, false)
				end)
			}
		}
	}
}

function var_0_1.onCreate(arg_12_0, arg_12_1)
	gGameUI.topuiManager:createView("default", arg_12_0, {
		onClose = arg_12_0:createHandler("onClose")
	}):init({
		subTitle = "TOTEM",
		title = "common/txt/txt_bt_zuhui.png"
	})

	arg_12_0.cb = arg_12_1.cb
	arg_12_0.id = arg_12_1.id

	arg_12_0:initModel()
	arg_12_0:initUI()
end

function var_0_1.initUI(arg_13_0)
	local var_13_0 = cc.Sprite:create("city/develop/totem/bg_img_20.png")

	var_13_0:setScale(2)
	arg_13_0.bg:addChild(var_13_0)
	arg_13_0.leaf:setTouchEnabled(false)
	arg_13_0.tipMaskTxt:text(gLanguageCsv.totemExAttrTips)

	local var_13_1 = arg_13_0.tipMaskTxt:size()

	arg_13_0.tipMaskImg:size(var_13_1.width + 50, 82)
end

function var_0_1.initModel(arg_14_0)
	arg_14_0.items = gGameModel.role:getIdler("items")
	arg_14_0.insettedTotem = gGameModel.totem:getIdler("totem_insetted")
	arg_14_0.sortTabData = idlertable.new({
		gLanguageCsv.activeTotemStone,
		gLanguageCsv.activedTotemStone,
		gLanguageCsv.advanceTotemStone,
		gLanguageCsv.addtionTotemStone
	})
	arg_14_0.iconListData = idlers.new({})
	arg_14_0.leftListData = idlers.new()
	arg_14_0.selectNum = idler.new(1)
	arg_14_0.sortType = idler.new(1)
	arg_14_0.upFliter = idler.new(0)
	arg_14_0.resort = idler.new(false)
	arg_14_0.canBeFastInset = false
	arg_14_0.totems = {}
	arg_14_0.stoneData = {}
	arg_14_0.rightAttrData = idlers.new({})
	arg_14_0.rightExAttrData = idlers.new({})

	local var_14_0 = idlereasyArgs.new(arg_14_0, "sortType", "upFliter")

	idlereasy.any(var_14_0, function(...)
		arg_14_0.resort:set(true, true)
	end)
	idlerflow.if_(arg_14_0.resort):do_(function(arg_16_0)
		arg_14_0.leftList:jumpToTop()

		local var_16_0 = {}
		local var_16_1 = arg_14_0.insettedTotem:read()
		local var_16_2 = gGameModel.role:read("items")

		for iter_16_0, iter_16_1 in orderCsvPairs(csv.totem.symbol) do
			if iter_16_1.symbolGroupType == arg_14_0.id then
				local var_16_3 = 0
				local var_16_4 = 0
				local var_16_5 = false

				for iter_16_2, iter_16_3 in ipairs(iter_16_1.totemGroup1) do
					local var_16_6 = var_16_1[iter_16_1.id] and var_16_1[iter_16_1.id][iter_16_2] and true or false
					local var_16_7 = not var_16_6 and (var_16_2[iter_16_3] or 0) > 0

					if var_16_6 then
						var_16_3 = var_16_3 + 1
					end

					if var_16_7 then
						var_16_4 = var_16_4 + 1
					end
				end

				if itertools.size(iter_16_1.totemGroup1) - var_16_3 - var_16_4 == 0 and var_16_4 > 0 then
					var_16_5 = true
				end

				local var_16_8 = 0

				for iter_16_4, iter_16_5 in ipairs(iter_16_1.totemGroup1) do
					if csv.items[iter_16_5].specialArgsMap.ease then
						var_16_8 = var_16_8 + 1
					end
				end

				table.insert(var_16_0, {
					id = iter_16_1.id,
					canInsetTotems = var_16_4,
					canActive = var_16_5,
					allTotemsNum = itertools.size(iter_16_1.totemGroup1),
					specialTotemNum = var_16_8,
					attrAddNum = (iter_16_1.extraAttrsType1 > 0 and 1 or 0) + (iter_16_1.extraAttrsType2 > 0 and 1 or 0)
				})
			end
		end

		arg_14_0.leftListData:update(var_16_0)

		if arg_14_0.leftList.getIdx then
			for iter_16_6 = 1, #var_16_0 do
				if arg_14_0.leftList:getIdx(iter_16_6) == 1 then
					arg_14_0.selectNum:set(iter_16_6, true)

					break
				end
			end
		end
	end, var_14_0)
	idlereasy.any({
		arg_14_0.insettedTotem,
		arg_14_0.selectNum
	}, function(arg_17_0, arg_17_1, arg_17_2)
		for iter_17_0 = 1, arg_14_0.leftListData:size() do
			if arg_14_0.leftListData:atproxy(iter_17_0).isSelect then
				arg_14_0.leftListData:atproxy(iter_17_0).isSelect = false
			end
		end

		if arg_14_0.leftListData:atproxy(arg_17_2) then
			arg_14_0.leftListData:atproxy(arg_17_2).isSelect = true
		end

		arg_14_0:initCenterPanel(arg_17_1)
		arg_14_0:initDownPanel()
		arg_14_0:refreshButtonStatus(arg_17_1)
		arg_14_0:initRightPanel()
	end)
	performWithDelay(arg_14_0, function()
		arg_14_0.sortType:notify()
	end, 0)
end

function var_0_1.initCenterPanel(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0.selectNum:read()
	local var_19_1 = arg_19_0.leftListData:atproxy(var_19_0).id

	if var_19_1 == 0 then
		return
	end

	local var_19_2 = var_19_1
	local var_19_3 = csv.totem.symbol[var_19_2]
	local var_19_4 = itertools.size(var_19_3.totemGroup1)
	local var_19_5 = arg_19_0.centerPanel:get("panel1")

	var_19_5:xy(800, 570)

	local var_19_6 = var_19_5:get("totems")

	for iter_19_0 = 1, math.huge do
		if not var_19_6.get(var_19_6, "totem" .. iter_19_0) then
			break
		end

		var_19_6:get("totem" .. iter_19_0):hide()

		local var_19_7 = var_19_6:get("totem" .. iter_19_0):get("spine"):get("teshu_loop")

		if var_19_7 then
			var_19_7.hide(var_19_7)
		end

		local var_19_8 = var_19_6:get("totem" .. iter_19_0):get("spine"):get("kezhiru_loop")

		if var_19_8 then
			var_19_8.hide(var_19_8)
		end
	end

	local var_19_9 = arg_19_1[var_19_2] or {}

	for iter_19_1, iter_19_2 in ipairs(var_19_3.totemGroup1) do
		local var_19_10 = var_0_2.totemPosition[var_19_4][iter_19_1][1]
		local var_19_11 = var_0_2.totemPosition[var_19_4][iter_19_1][2]

		if not var_19_6.get(var_19_6, "totem" .. iter_19_1) then
			arg_19_0.centerPanel:get("totem"):clone():addTo(var_19_6, 5, "totem" .. iter_19_1)
		end

		local var_19_12 = var_19_6:get("totem" .. iter_19_1):show():xy(var_19_10, var_19_11)
		local var_19_13 = csv.items[iter_19_2]
		local var_19_14

		var_19_14 = var_19_13.specialArgsMap.ease and 2 or 1

		local var_19_15 = var_19_9[iter_19_1]
		local var_19_16 = var_19_13.icon
		local var_19_17 = not var_19_15 and arg_19_0.items:read()[iter_19_2] ~= nil
		local var_19_18 = var_19_12:multiget("bg", "canInset", "insetSuccess", "spine")

		var_19_18.bg:show()
		itertools.invoke({
			var_19_18.canInset,
			var_19_18.insetSuccess
		}, "hide")

		local var_19_19 = var_19_13.specialArgsMap

		var_19_18.bg:texture("config/item/unknow/bg_" .. var_19_13.quality .. ".png")

		local var_19_20 = cc.Sprite:create(var_19_16):xy(50, 50):addTo(var_19_18.bg)

		uiEasy.setBtnShader(var_19_18.bg, true, 1)

		if var_19_15 then
			if var_19_19 and var_19_19.ease == 1 then
				widget.addAnimationByKey(var_19_18.spine, "tuteng/tutengdx.skel", "teshu_loop", "teshu_loop", 0):scale(2):xy(100, 100):show()
				arg_19_0:sweepAction(var_19_18.bg, {
					delayTime = 0.2,
					scaleX = 3,
					speedTime = 2,
					angle = 20
				})
				var_19_18.bg:scale(2)
			end
		else
			uiEasy.setBtnShader(var_19_18.bg, false, 2)
		end

		local var_19_21 = arg_19_0:outlineAnimation(var_19_17, var_19_18.spine, var_19_18.bg)

		bind.touch(arg_19_0, var_19_12, {
			methods = {
				ended = functools.partial(arg_19_0.clickTotem, arg_19_0, var_19_17 and -1 or var_19_15 and 1 or 0, var_19_12, iter_19_1, iter_19_2, var_19_21)
			}
		})
	end
end

function var_0_1.sweepAction(arg_20_0, arg_20_1, arg_20_2)
	if arg_20_1.getChildByName(arg_20_1, "_sweepPanel_") then
		return
	end

	arg_20_2 = arg_20_2 or {}

	local var_20_0 = arg_20_1:width()
	local var_20_1 = arg_20_1:height()
	local var_20_2 = arg_20_2.speedTime or 1
	local var_20_3 = arg_20_2.delayTime or 0.5
	local var_20_4 = arg_20_2.angle or 20
	local var_20_5 = arg_20_2.scaleX or 3
	local var_20_6 = math.tan(math.rad(var_20_4)) * var_20_1
	local var_20_7 = var_20_1 / math.cos(math.rad(var_20_4))
	local var_20_8 = -100 - var_20_6
	local var_20_9 = var_20_0 + 50
	local var_20_10 = "common/icon/img_light_2.png"
	local var_20_11 = cc.rect(20, 20, 1, 1)
	local var_20_12 = cc.utils:captureNodeSprite(arg_20_1, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, 1, display.uiOrigin.x, 0)

	var_20_12:retain()

	local var_20_13 = ccui.Layout:create():anchorPoint(0, 0):xy(0, 0):size(arg_20_1:width(), arg_20_1:height()):addTo(arg_20_1, 100, "_sweepPanel_")
	local var_20_14 = ccui.Layout:create():setClippingEnabled(true):anchorPoint(0, 0):xy(0, 0):size(arg_20_1:width(), arg_20_1:height())
	local var_20_15 = cc.ClippingNode:create(var_20_12):setAlphaThreshold(0.05):xy(0, 0):addChild(var_20_14, 1, "_ClippingPanel_"):addTo(var_20_13, 1000, "_ClippingNode_")
	local var_20_16 = ccui.Scale9Sprite:create()

	var_20_16:initWithFile(var_20_11, var_20_10)
	var_20_16:setSkewX(var_20_4)
	var_20_16:height(var_20_7)
	var_20_16:setBlendFunc({
		src = GL_DST_COLOR,
		dst = GL_ONE
	})
	var_20_16:anchorPoint(0, 0)
	var_20_16:xy(var_20_8, 0)
	var_20_16:scaleX(var_20_5)
	var_20_16:addTo(var_20_14, 1, "_light_")
	var_20_12:release()

	local var_20_17 = var_20_8 - var_20_16:width() * var_20_5

	;(function(arg_21_0, arg_21_1, arg_21_2)
		arg_21_0:xy(arg_21_1[1], arg_21_1[2])

		local var_21_0 = cc.Sequence:create(cc.MoveTo:create(var_20_2, cc.p(arg_21_2[1], arg_21_2[2])), cc.CallFunc:create(function()
			arg_21_0:xy(arg_21_1[1], arg_21_1[2])
		end), cc.DelayTime:create(var_20_3))
		local var_21_1 = cc.RepeatForever:create(var_21_0)

		arg_21_0:runAction(var_21_1)
	end)(var_20_16, {
		var_20_17,
		0
	}, {
		var_20_9,
		0
	})

	local function var_20_18(arg_23_0)
		local var_23_0 = cc.Sequence:create(cc.DelayTime:create(var_20_2), cc.ScaleTo:create(var_20_3 / 4, 1.05), cc.ScaleTo:create(var_20_3 / 4, 0.95), cc.ScaleTo:create(var_20_3 / 4, 1.01), cc.ScaleTo:create(var_20_3 / 4, 1))
		local var_23_1 = cc.RepeatForever:create(var_23_0)

		arg_23_0:runAction(var_23_1)
	end

	local function var_20_19(arg_24_0)
		arg_24_0:setOpacity(5)

		local var_24_0 = cc.Sequence:create(cc.FadeTo:create((var_20_2 + var_20_3) / 4, 50), cc.FadeTo:create((var_20_2 + var_20_3) / 4, 5), cc.FadeTo:create((var_20_2 + var_20_3) / 4, 50), cc.FadeTo:create((var_20_2 + var_20_3) / 4, 5))
		local var_24_1 = cc.RepeatForever:create(var_24_0)

		arg_24_0:runAction(var_24_1)
	end
end

function var_0_1.refreshButtonStatus(arg_25_0, arg_25_1)
	arg_25_0.canBeFastInset = false

	local var_25_0 = gGameModel.role:read("items")

	for iter_25_0, iter_25_1 in orderCsvPairs(csv.totem.symbol) do
		if iter_25_1.symbolGroupType == arg_25_0.id then
			local var_25_1 = 0
			local var_25_2 = 0

			for iter_25_2, iter_25_3 in ipairs(iter_25_1.totemGroup1) do
				local var_25_3 = arg_25_1[iter_25_1.id] and arg_25_1[iter_25_1.id][iter_25_2] and true or false
				local var_25_4 = not var_25_3 and (var_25_0[iter_25_3] or 0) > 0

				if var_25_3 then
					var_25_1 = var_25_1 + 1
				end

				if var_25_4 then
					var_25_2 = var_25_2 + 1
				end
			end

			if not arg_25_1[iter_25_1.id] then
				local var_25_5 = {}
			end

			if itertools.size(iter_25_1.totemGroup1) - var_25_1 - var_25_2 == 0 and var_25_2 > 0 then
				arg_25_0.canBeFastInset = true

				break
			end
		end

		if arg_25_0.canBeFastInset then
			break
		end
	end

	cache.setShader(arg_25_0.btnFastInset:get("icon"), false, arg_25_0.canBeFastInset and "normal" or "hsl_gray")
	arg_25_0.btnFastInset:get("text"):setTextColor(arg_25_0.canBeFastInset and cc.c4b(241, 61, 86, 255) or cc.c4b(128, 128, 128, 255))
end

function var_0_1.initDownPanel(arg_26_0)
	local var_26_0 = arg_26_0.selectNum:read()
	local var_26_1 = arg_26_0.leftListData:atproxy(var_26_0).id

	if var_26_1 == 0 then
		return
	end

	if not arg_26_0.insettedTotem:read()[var_26_1] then
		local var_26_2 = {}
	end

	local var_26_3 = csv.totem.symbol[var_26_1]
	local var_26_4 = arg_26_0:calculateInsetTotemNum()
	local var_26_5 = itertools.size(var_26_3.totemGroup1)

	arg_26_0.downPanel:get("totemNum"):text(string.format(gLanguageCsv.totemState, var_26_5))
	adapt.setTextScaleWithWidth(arg_26_0.downPanel:get("totemAvail"), string.format(gLanguageCsv.ableToInsetTotem, var_26_4), 400)
	var_0_5(arg_26_0.downPanel:get("totemNum"))
	var_0_5(arg_26_0.downPanel:get("totemAvail"))
end

function var_0_1.isStoneActive(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0.insettedTotem:read()[arg_27_1] or {}
	local var_27_1 = csv.totem.symbol[arg_27_1]

	for iter_27_0, iter_27_1 in pairs(var_27_1.totemGroup1) do
		if not var_27_0[iter_27_0] or iter_27_1 ~= var_27_0[iter_27_0] then
			return false
		end
	end

	return true
end

function var_0_1.initRightPanel(arg_28_0)
	local var_28_0 = arg_28_0.selectNum:read()
	local var_28_1 = arg_28_0.leftListData:atproxy(var_28_0).id

	if var_28_1 == 0 then
		return
	end

	local var_28_2 = arg_28_0.insettedTotem:read()[var_28_1] or {}
	local var_28_3 = csv.totem.symbol[var_28_1]
	local var_28_4 = true

	for iter_28_0, iter_28_1 in pairs(var_28_3.totemGroup1) do
		if not var_28_2[iter_28_0] or iter_28_1 ~= var_28_2[iter_28_0] then
			var_28_4 = false

			break
		end
	end

	arg_28_0.active:visible(var_28_4)

	arg_28_0.isActive = var_28_4

	local var_28_5 = itertools.size(var_28_3.totemGroup1)
	local var_28_6 = csv.totem.symbol_group[var_28_3.symbolGroupType].spineAnimation

	if var_28_4 then
		local var_28_7 = string.format("%s_%d_hou_loop", var_28_6, var_0_2.panelReflect[var_28_5])

		arg_28_0:playAnimation(var_28_7)
		arg_28_0.centerPanel:get("panel1"):get("bg"):show()
	else
		arg_28_0.centerPanel:get("panel1"):get("bg"):show()

		local var_28_8 = string.format("%s_%d_qian_loop", var_28_6, var_0_2.panelReflect[var_28_5])

		arg_28_0:playAnimation(var_28_8)
	end

	local var_28_9 = arg_28_0:calculateInsetTotemNum()

	arg_28_0.btnOneClickInset:visible(var_28_9 > 0)
	arg_28_0.rightPanel:get("title"):text(var_28_3.name)

	local var_28_10 = var_28_3.nature

	if var_28_10 and itertools.size(var_28_10) > 0 then
		arg_28_0.exTips:show()
		arg_28_0.rightPanel:get("extraAddTitle"):show()
		arg_28_0.rightPanel:get("iconList"):show()
		arg_28_0.iconListData:update(var_28_10)
	else
		arg_28_0.exTips:hide()
		arg_28_0.rightPanel:get("iconList"):hide()
		arg_28_0.rightPanel:get("extraAddTitle"):hide()
	end

	local var_28_11 = {}
	local var_28_12 = {}

	for iter_28_2 = 1, math.huge do
		local var_28_13 = false
		local var_28_14 = false
		local var_28_15 = var_28_3["attrType" .. iter_28_2]
		local var_28_16 = var_28_3["attrNum" .. iter_28_2]

		if var_28_15 and var_28_15 > 0 then
			table.insert(var_28_11, {
				type = var_28_15,
				num = var_28_16,
				isActive = var_28_4
			})
		else
			var_28_13 = true
		end

		local var_28_17 = var_28_3["extraAttrsType" .. iter_28_2]
		local var_28_18 = var_28_3["extraAttrNum" .. iter_28_2]

		if var_28_17 and var_28_17 > 0 then
			table.insert(var_28_12, {
				type = var_28_17,
				num = var_28_18,
				isActive = var_28_4
			})
		else
			var_28_14 = true
		end

		if var_28_13 and var_28_14 then
			break
		end
	end

	arg_28_0.rightAttrData:update(var_28_11)
	arg_28_0.rightExAttrData:update(var_28_12)
	var_0_5(arg_28_0.rightPanel:get("title"))
	var_0_5(arg_28_0.rightPanel:get("extraAddTitle"))
	adapt.oneLinePos(arg_28_0.rightPanel:get("extraAddTitle"), arg_28_0.rightPanel:get("exTips"), cc.p(5, 0))
	adapt.setTextScaleWithWidth(arg_28_0.rightPanel:get("energyPanel.text"), nil, 300)

	if dataEasy.isUnlock(gUnlockCsv.totemEnergy) then
		var_0_5(arg_28_0.rightPanel:get("energyPanel.number"))
		arg_28_0.rightPanel:get("energyPanel.number"):text("+" .. csv.totem.symbol[var_28_1].power)
		var_0_4(arg_28_0.rightPanel:get("energyPanel.number"), var_28_4)
	else
		arg_28_0.rightPanel:get("energyPanel"):hide()
	end
end

function var_0_1.calculateInsetTotemNum(arg_29_0, arg_29_1)
	if not arg_29_1 then
		local var_29_0 = arg_29_0.selectNum:read()

		arg_29_1 = arg_29_0.leftListData:atproxy(var_29_0).id
	end

	if arg_29_1 == 0 then
		return 0
	end

	local var_29_1 = arg_29_0.insettedTotem:read()[arg_29_1] or {}
	local var_29_2 = csv.totem.symbol[arg_29_1]
	local var_29_3 = 0

	for iter_29_0, iter_29_1 in ipairs(var_29_2.totemGroup1) do
		if not var_29_1[iter_29_0] and arg_29_0.items:read()[iter_29_1] ~= nil then
			var_29_3 = var_29_3 + 1
		end
	end

	return var_29_3
end

function var_0_1.onSortList(arg_30_0)
	local var_30_0 = arg_30_0.sortType:read()

	return function(arg_31_0, arg_31_1)
		if var_30_0 == 2 then
			local var_31_0 = arg_30_0:isStoneActive(arg_31_0.id)

			if var_31_0 ~= arg_30_0:isStoneActive(arg_31_1.id) then
				return var_31_0
			end
		elseif var_30_0 == 3 then
			if arg_31_0.specialTotemNum ~= arg_31_1.specialTotemNum then
				return arg_31_1.specialTotemNum < arg_31_0.specialTotemNum
			end
		elseif var_30_0 == 4 and arg_31_0.attrAddNum ~= arg_31_1.attrAddNum then
			return arg_31_1.attrAddNum < arg_31_0.attrAddNum
		end

		if arg_31_0.canActive ~= arg_31_1.canActive then
			return arg_31_0.canActive
		end

		if arg_31_0.canInsetTotems ~= arg_31_1.canInsetTotems then
			return arg_31_1.canInsetTotems < arg_31_0.canInsetTotems
		end

		if arg_31_0.allTotemsNum ~= arg_31_1.allTotemsNum then
			return arg_31_1.allTotemsNum < arg_31_0.allTotemsNum
		end

		return arg_31_0.id < arg_31_1.id
	end
end

function var_0_1.onUpFliterClick(arg_32_0)
	local var_32_0 = arg_32_0.upFliter:read()

	arg_32_0.upFliter:set(var_32_0 > 0 and 0 or 1)
	arg_32_0.upOrDownFilter:get("down"):visible(var_32_0 > 0)
	arg_32_0.upOrDownFilter:get("up"):visible(var_32_0 < 1)
	arg_32_0.upOrDownFilter:get("text"):text(var_32_0 == 0 and gLanguageCsv.ascendingOrder or gLanguageCsv.descendingOrder)
end

function var_0_1.initActiveView(arg_33_0)
	if arg_33_0.stoneData[arg_33_0.selectNum:read()].isStoneActive then
		arg_33_0.active:show()
		arg_33_0.rightPanel:get("btn"):hide()
	else
		arg_33_0.active:hide()
		arg_33_0.rightPanel:get("btn"):show()
	end
end

function var_0_1.onSortMenusBtnClick(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5)
	arg_34_0.sortType:set(arg_34_3)
end

function var_0_1.onLeftItemClick(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	arg_35_0.centerPanel:get("panel1"):get("totems"):removeAllChildren()
	arg_35_0.selectNum:set(arg_35_2, true)
end

function var_0_1.clickTotem(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5)
	if arg_36_1 < 0 then
		local var_36_0 = arg_36_0.selectNum:read()
		local var_36_1 = arg_36_0.leftListData:atproxy(var_36_0).id
		local var_36_2 = {
			[var_36_1] = {
				arg_36_3
			}
		}

		gGameApp:requestServer("/game/totem/inset", function(arg_37_0)
			if itertools.size(arg_37_0.view.activeSymbol) > 0 then
				printtable(arg_37_0)

				local var_37_0 = csv.totem.symbol[var_36_1]
				local var_37_1 = itertools.size(var_37_0.totemGroup1)
				local var_37_2 = csv.totem.symbol_group[var_37_0.symbolGroupType].spineAnimation
				local var_37_3 = string.format("%s_%d", var_37_2, var_0_2.panelReflect[var_37_1])

				arg_36_0:playAnimation(var_37_3 .. "_jihuo")
				performWithDelay(arg_36_0, function()
					arg_36_0:playAnimation(var_37_3 .. "_hou_loop")
					gGameUI:stackUI("city.develop.totem.gain", nil, {
						blackLayer = true
					}, {
						sort = true,
						csvIds = arg_37_0.view.activeSymbol
					})
				end, 0.8)
			end

			arg_36_0:successAction(arg_36_2, arg_36_5)
		end, var_36_2)

		return
	end

	if arg_36_1 == 0 then
		gGameUI:stackUI("common.gain_way", nil, {}, arg_36_4, nil, 1)
	else
		gGameUI:showItemDetail(arg_36_2, {
			key = arg_36_4,
			num = arg_36_0.items:read()[arg_36_4],
			status = arg_36_1 == 0 and 0 or 1
		})
	end
end

function var_0_1.successAction(arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = arg_39_1:get("spine")

	arg_39_2 = arg_39_2 or arg_39_1:get("spine"):get("kezhiru_loop")

	var_39_0:z(5)

	if arg_39_2 then
		arg_39_2.play(arg_39_2, "zhiru")
	end

	performWithDelay(arg_39_1, function()
		var_39_0:z(-1)

		if arg_39_2 then
			arg_39_2:removeSelf()
		end
	end, 0.4)

	local var_39_1 = arg_39_1:get("insetSuccess")
	local var_39_2 = var_39_1:y()

	var_39_1:show()
	transition.executeSequence(var_39_1):moveTo(1, var_39_1:x(), 250):func(function()
		var_39_1:y(var_39_2)
	end):hide():done()
	transition.executeSequence(var_39_1):fadeOut(1):done()
end

function var_0_1.onFastInset(arg_42_0)
	if arg_42_0.canBeFastInset then
		gGameUI:stackUI("city.develop.totem.quick_inset", nil, {
			backGlass = true
		}, {
			id = arg_42_0.id,
			cb = function()
				arg_42_0.sortType:notify()
			end
		})
	else
		gGameUI:showTip(gLanguageCsv.totemCannotActivate)
	end
end

function var_0_1.onOneClickInset(arg_44_0)
	local var_44_0 = arg_44_0.selectNum:read()
	local var_44_1 = arg_44_0.leftListData:atproxy(var_44_0).id
	local var_44_2 = csv.totem.symbol[var_44_1]
	local var_44_3, var_44_4 = arg_44_0:calculateInsetTotems()
	local var_44_5 = itertools.size(var_44_4)
	local var_44_6 = userDefault.getCurrDayKey("totemSureInset", "first")

	if var_44_6 == "first" then
		var_44_6 = "true"

		userDefault.setCurrDayKey("totemSureInset", var_44_6)
	end

	local function var_44_7()
		gGameApp:requestServer("/game/totem/inset", function(arg_46_0)
			if itertools.size(arg_46_0.view.activeSymbol) > 0 then
				local var_46_0 = itertools.size(var_44_2.totemGroup1)
				local var_46_1 = csv.totem.symbol_group[var_44_2.symbolGroupType].spineAnimation
				local var_46_2 = string.format("%s_%d", var_46_1, var_0_2.panelReflect[var_46_0])

				arg_44_0:playAnimation(var_46_2 .. "_jihuo")
				performWithDelay(arg_44_0, function()
					arg_44_0:playAnimation(var_46_2 .. "_hou_loop")
					gGameUI:stackUI("city.develop.totem.gain", nil, {
						blackLayer = true
					}, {
						sort = true,
						csvIds = arg_46_0.view.activeSymbol
					})
				end, 0.8)
			end

			for iter_46_0, iter_46_1 in ipairs(var_44_3) do
				arg_44_0:successAction(iter_46_1)
			end
		end, {
			[var_44_1] = var_44_4
		})
	end

	if (var_44_6 == "first" or var_44_6 == "true") and var_44_5 > 0 then
		gGameUI:showDialog({
			selectType = 2,
			clearFast = true,
			btnType = 2,
			selectKey = "totemSureInset",
			content = string.format(gLanguageCsv.sureToInsetTotem, var_44_2.name, var_44_5),
			cb = var_44_7,
			selectTip = gLanguageCsv.todayNoTip
		})
	elseif var_44_5 > 0 then
		var_44_7()
	end
end

function var_0_1.calculateInsetTotems(arg_48_0)
	local var_48_0 = arg_48_0.selectNum:read()
	local var_48_1 = arg_48_0.leftListData:atproxy(var_48_0).id
	local var_48_2 = csv.totem.symbol[var_48_1]
	local var_48_3 = itertools.size(var_48_2.totemGroup1)
	local var_48_4 = arg_48_0.centerPanel:get("panel1"):get("totems")
	local var_48_5 = {}
	local var_48_6 = arg_48_0.insettedTotem:read()[var_48_1] or {}
	local var_48_7 = {}
	local var_48_8 = table.deepcopy(arg_48_0.items:read(), true)

	for iter_48_0, iter_48_1 in ipairs(var_48_2.totemGroup1) do
		local var_48_9 = var_48_4:get("totem" .. iter_48_0):show()
		local var_48_10 = csv.items[iter_48_1]

		if not var_48_6[iter_48_0] and var_48_8[iter_48_1] ~= nil and var_48_8[iter_48_1] > 0 then
			var_48_8[iter_48_1] = var_48_8[iter_48_1] - 1

			table.insert(var_48_5, iter_48_0)
			table.insert(var_48_7, var_48_9)
		end
	end

	return var_48_7, var_48_5
end

function var_0_1.getNewTotemPosition(arg_49_0)
	arg_49_0.optLayer = cc.LayerColor:create(cc.c4b(255, 0, 0, 25), 1600, 1100)

	arg_49_0.optLayer:setTouchEnabled(true)
	arg_49_0.optLayer:setSwallowsTouches(true)
	arg_49_0.centerPanel:get("panel1"):get("totems"):addChild(arg_49_0.optLayer, 100)

	local var_49_0 = cc.EventListenerTouchOneByOne:create()

	local function var_49_1(arg_50_0, arg_50_1)
		return true
	end

	local function var_49_2(arg_51_0, arg_51_1)
		local var_51_0 = arg_49_0.centerPanel:get("panel1"):get("totems"):convertToNodeSpace(arg_51_0:getLocation())
		local var_51_1 = {
			btnType = 2,
			isRich = false,
			cb = function()
				return
			end,
			content = string.format("position is x = %d, y = %d", var_51_0.x, var_51_0.y)
		}

		gGameUI:showDialog(var_51_1)
	end

	var_49_0:setSwallowTouches(true)
	var_49_0:registerScriptHandler(var_49_1, cc.Handler.EVENT_TOUCH_BEGAN)
	var_49_0:registerScriptHandler(var_49_2, cc.Handler.EVENT_TOUCH_ENDED)
	arg_49_0.optLayer:getEventDispatcher():addEventListenerWithSceneGraphPriority(var_49_0, arg_49_0.optLayer)
end

function var_0_1.outlineAnimation(arg_53_0, arg_53_1, arg_53_2, arg_53_3)
	if not arg_53_1 then
		return
	end

	arg_53_2:z(-1)

	return (widget.addAnimationByKey(arg_53_2, "tuteng/tutengdx.skel", "kezhiru_loop", "kezhiru_loop", 0):scale(2):xy(100, 100):show())
end

function var_0_1.playAnimation(arg_54_0, arg_54_1)
	local var_54_0 = arg_54_0.selectNum:read()
	local var_54_1 = arg_54_0.leftListData:atproxy(var_54_0).id
	local var_54_2 = arg_54_0.centerPanel:get("panel1"):get("spine"):get("bgSpine")
	local var_54_3 = csv.totem.symbol[var_54_1]
	local var_54_4 = itertools.size(var_54_3.totemGroup1)

	arg_54_0.centerPanel:get("panel1"):get("spine"):removeAllChildren()

	local var_54_5 = var_0_2.panelOffset[1]

	widget.addAnimationByKey(arg_54_0.centerPanel:get("panel1"):get("spine"), "tuteng/tutengdx.skel", "bgSpine", arg_54_1, 5):scale(2):xy(var_54_5[1], var_54_5[2])
end

function var_0_1.onTipsClick(arg_55_0, arg_55_1)
	arg_55_0.tipMask:visible(arg_55_1)
end

function var_0_1.onClose(arg_56_0)
	arg_56_0.addCallbackOnExit(arg_56_0, arg_56_0.cb)
	var_0_0.onClose(arg_56_0)
end

return var_0_1
