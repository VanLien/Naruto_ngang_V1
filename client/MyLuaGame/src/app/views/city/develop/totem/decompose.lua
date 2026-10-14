local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("totemDecomposeView", var_0_0)
local var_0_2 = 4
local var_0_3 = ui.COLORS.QUALITY
local var_0_4 = {}

local function var_0_5(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0, var_1_1 = arg_1_0:xy()
	local var_1_2 = cc.Label:createWithTTF(arg_1_1, "font/youmi1.ttf", 40):align(cc.p(0.5, 0.5), arg_1_0:size().width / 2, arg_1_0:size().height / 2 + 30):addTo(arg_1_0, 11)

	text.addEffect(var_1_2, {
		color = cc.c4b(0, 255, 0, 255),
		outline = {
			size = 3,
			color = cc.c4b(44, 44, 44, 255)
		}
	})
	transition.executeSequence(var_1_2):moveBy(0.4, 0, 30):fadeOut(0.1):func(function()
		var_1_2:removeSelf()
	end):done()

	if not arg_1_2 then
		if not arg_1_0.lvUpEffect then
			arg_1_0.lvUpEffect = widget.addAnimation(arg_1_0, "effect/gonghuixunlian.skel", "fangguang", 10):xy(100, 5):scale(1)
		else
			arg_1_0.lvUpEffect:play("fangguang")
		end

		audio.playEffectWithWeekBGM("circle.mp3")
	end
end

var_0_1.RESOURCE_FILENAME = "totem_resolve.json"
var_0_1.RESOURCE_BINDING = {
	["acquire.icon"] = "haveIcon",
	item1 = "item1",
	acquire = "havePanel",
	leftPanel = "leftPanel",
	spine1 = "spine1",
	icon = "icon",
	["acquire2.rmbPanel.icon"] = "gainIcon",
	item = "item",
	spine = "spine",
	lineList = "lineList",
	["acquire2.rmbPanel"] = "rmbPanel",
	duckPanel = "duckPanel",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["acquire2.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDecompose")
			}
		}
	},
	["acquire2.btn.txt"] = {
		varname = "btnTxt",
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["leftPanel.list"] = {
		varname = "leftList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				yMargin = 35,
				xMargin = 35,
				data = bindHelper.self("subassemblys"),
				dataOrderCmp = function(arg_3_0, arg_3_1)
					if arg_3_0.cfg.quality ~= arg_3_1.cfg.quality then
						return arg_3_0.cfg.quality < arg_3_1.cfg.quality
					end

					if arg_3_0.level ~= arg_3_1.level then
						return arg_3_0.level < arg_3_1.level
					end

					return arg_3_0.id < arg_3_1.id
				end,
				columnSize = bindHelper.self("midColumnSize"),
				isRefresh = bindHelper.self("isRefresh"),
				item = bindHelper.self("lineList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = idlertable.new({
						key = arg_4_3.id,
						num = arg_4_3.num,
						targetNum = arg_4_3.selected and arg_4_3.targetNum
					})

					arg_4_0:enableSchedule()

					local var_4_1 = true

					local function var_4_2(arg_5_0)
						local var_5_0 = var_4_0:proxy().targetNum or 0
						local var_5_1 = cc.clampf(var_5_0 + arg_5_0, 0, var_4_0:proxy().num)

						var_4_0:proxy().targetNum = var_5_1 ~= 0 and var_5_1 or nil

						if arg_5_0 > 0 then
							if var_5_1 < var_4_0:proxy().num then
								var_0_4[arg_4_3.id] = var_0_4[arg_4_3.id] and var_0_4[arg_4_3.id] + 1 or 1
								var_4_1 = true
							elseif var_4_0:proxy().num == var_5_1 and var_4_1 then
								var_0_4[arg_4_3.id] = var_5_1
								var_4_1 = false
							end
						else
							local var_5_2 = math.max(var_0_4[arg_4_3.id] + arg_5_0, 0)

							var_0_4[arg_4_3.id] = var_5_2 ~= 0 and var_5_2 or nil
							var_4_1 = true
						end

						arg_4_3.targetNum = var_5_1

						arg_4_3.isRefresh:notify()

						if var_5_1 + arg_5_0 < 0 or var_4_0:proxy().num < var_5_1 + arg_5_0 then
							arg_4_0:unSchedule("numChange")
						end
					end

					local var_4_3

					local function var_4_4(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
						local var_6_0 = arg_4_3.targetNum

						if arg_6_3 < 0 then
							var_6_0 = var_6_0 - 1
						end

						if var_4_3 == nil then
							var_4_3 = arg_6_2
						end

						if arg_6_2.name == "click" then
							arg_4_0:unScheduleAll()

							if var_4_3 and var_6_0 < arg_4_3.num then
								var_4_2(arg_6_3)
								var_0_5(arg_6_0, arg_6_4)
							end

							var_4_3 = nil
						elseif arg_6_2.name == "began" then
							if var_4_3 then
								arg_4_0:schedule(function(arg_7_0)
									if var_6_0 < arg_4_3.num then
										var_4_2(arg_6_3)
										var_0_5(arg_6_0, arg_6_4)
									end
								end, 0.1, 0, "numChange")
							end
						elseif arg_6_2.name == "moved" then
							if var_4_3 then
								local var_6_1 = math.abs(arg_6_2.x - var_4_3.x)
								local var_6_2 = math.abs(arg_6_2.y - var_4_3.y)

								if var_6_1 >= ui.TOUCH_MOVE_CANCAE_THRESHOLD or var_6_2 >= ui.TOUCH_MOVE_CANCAE_THRESHOLD then
									var_4_3 = false

									arg_4_0:unSchedule("numChange")
								end
							end
						elseif arg_6_2.name == "ended" or arg_6_2.name == "cancelled" then
							var_4_3 = nil

							arg_4_0:unSchedule("numChange")
						end
					end

					bind.extend(arg_4_0, arg_4_1, {
						class = "explore_icon",
						props = {
							gemIconShow = true,
							showReduce = true,
							longtouch = true,
							data = var_4_0,
							specialKey = {
								leftTopLv = arg_4_3.level
							},
							onNode = function(arg_8_0)
								arg_8_0:scale(1.1)
								bind.touch(arg_4_0, arg_8_0, {
									longtouch = 0.5,
									method = function(arg_9_0, arg_9_1, arg_9_2)
										var_4_4(arg_8_0, arg_9_1, arg_9_2, 1, "+1")
									end
								})
								bind.touch(arg_4_0, arg_8_0:get("reduceIcon"), {
									longtouch = 0.5,
									method = function(arg_10_0, arg_10_1, arg_10_2)
										var_4_4(arg_8_0, arg_10_1, arg_10_2, -1, "-1")
									end
								})
							end
						}
					})
				end,
				asyncPreload = bindHelper.self("midAsyncPreload")
			}
		}
	},
	["leftPanel.bottomList"] = {
		varname = "listview1",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 30,
				data = bindHelper.self("bottomData"),
				item = bindHelper.self("item1"),
				onItem = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
					local var_11_0 = arg_11_1:multiget("bg", "name", "selected")

					var_11_0.bg:texture(arg_11_3.icon)
					var_11_0.name:text(arg_11_3.name)
					adapt.setTextScaleWithWidth(var_11_0.name, nil, 100)
					var_11_0.selected:visible(arg_11_3.selected == true)
					var_11_0.bg:setTouchEnabled(true)
					text.addEffect(var_11_0.name, {
						size = 40,
						color = ui.COLORS.NORMAL.WHITE,
						outline = {
							size = 3,
							color = ui.COLORS.NORMAL.DEFAULT
						}
					})
					bind.touch(arg_11_0, var_11_0.bg, {
						methods = {
							ended = functools.partial(arg_11_0.clickCell, arg_11_2, arg_11_3.quality)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onColorClick")
			}
		}
	},
	["acquire2.rmbPanel.num"] = {
		varname = "decomposeTxt",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["acquire2.rmbPanel.rule"] = {
		varname = "decomposeRule",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleShow")
			}
		}
	},
	["acquire.num"] = {
		varname = "haveTxt",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["acquire.txt"] = {
		varname = "haveTip",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["acquire2.rmbPanel.title"] = {
		varname = "gainTxt",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["leftPanel.title"] = {
		varname = "title",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["duckPanel.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["duckPanel.totemGain"] = {
		varname = "totemGain",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onJump")
			}
		}
	},
	["duckPanel.totemGain.txt1"] = {
		varname = "totemGainTxt1",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 6,
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["duckPanel.totemGain.txt2"] = {
		varname = "totemGainTxt2",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 6,
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["leftPanel.tips"] = {
		varname = "tips",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_12_0)
	gGameUI.topuiManager:createView("default", arg_12_0, {
		onClose = arg_12_0:createHandler("onClose")
	}):init({
		subTitle = "TOTEM",
		title = "common/txt/txt_bt_zuhui.png"
	})

	local var_12_0 = cc.Sprite:create("city/develop/totem/bg_img_20.png")

	var_12_0:setScale(2)
	var_12_0:xy(100, 100)
	arg_12_0.spine:addChild(var_12_0)
	arg_12_0:initModel()
	idlereasy.when(arg_12_0.items, function(arg_13_0, arg_13_1)
		local var_13_0 = {}

		var_0_4 = {}
		arg_12_0.qualityData = {}

		local var_13_1 = {}

		for iter_13_0, iter_13_1 in pairs(arg_13_1) do
			local var_13_2 = dataEasy.getCfgByKey(iter_13_0)

			if var_13_2.type == game.ITEM_TYPE_ENUM_TABLE.totemType then
				local var_13_3 = {
					targetNum = 0,
					id = iter_13_0,
					num = iter_13_1,
					cfg = var_13_2,
					quality = csv.items[iter_13_0].quality
				}

				table.insert(var_13_0, var_13_3)
			end
		end

		for iter_13_2, iter_13_3 in pairs(var_13_0) do
			var_13_0[iter_13_2].isRefresh = arg_12_0.isRefresh

			local var_13_4 = csv.items[iter_13_3.id].quality

			if not arg_12_0.qualityData[var_13_4] then
				arg_12_0.qualityData[var_13_4] = {}
			end

			table.insert(arg_12_0.qualityData[var_13_4], {
				key = iter_13_3.id,
				num = iter_13_3.num
			})
		end

		arg_12_0.subassemblys:update(var_13_0)
		arg_12_0.duckPanel:visible(#var_13_0 == 0)
		arg_12_0.listview1:visible(#var_13_0 ~= 0)
		arg_12_0.title:visible(#var_13_0 ~= 0)
		arg_12_0.decomposeNum:set(0)
		arg_12_0.decomposeDbid:set(0)

		arg_12_0.quality = 2
	end)

	arg_12_0.fenjie = widget.addAnimation(arg_12_0.icon, "tuteng/fenjie.skel", "fenjie_standby_loop", 99):alignCenter(cc.size(200, 50)):scale(1.5):xy(100, 450)

	idlereasy.when(arg_12_0.decomposeDbid, function(arg_14_0, arg_14_1)
		arg_12_0.decomposeTxt:text(arg_14_1)
		adapt.oneLinePos(arg_12_0.gainTxt, {
			arg_12_0.decomposeTxt,
			arg_12_0.gainIcon,
			arg_12_0.decomposeRule
		})
		adapt.oneLinePos(arg_12_0.haveTip, {
			arg_12_0.haveTxt,
			arg_12_0.haveIcon
		})
	end)
	idlereasy.when(arg_12_0.isRefresh, function()
		local var_15_0 = 0
		local var_15_1 = {}

		for iter_15_0, iter_15_1 in arg_12_0.subassemblys:ipairs() do
			if arg_12_0.subassemblys:atproxy(iter_15_0).targetNum and arg_12_0.subassemblys:atproxy(iter_15_0).targetNum > 0 then
				local var_15_2, var_15_3 = csvNext(arg_12_0.subassemblys:atproxy(iter_15_0).cfg.specialArgsMap.decomposeReturn)

				var_15_0 = var_15_0 + var_15_3 * arg_12_0.subassemblys:atproxy(iter_15_0).targetNum
			end
		end

		arg_12_0.decomposeNum:set(var_15_0)
		arg_12_0:refreshTextUpdata()
		arg_12_0:qualityNumCalculate()
	end)
	arg_12_0:gemQuintessence()

	local var_12_1, var_12_2 = adapt.centerWithScreen("left", "right", {
		itemWidthExtra = 60,
		itemWidth = arg_12_0.item:size().width
	}, {
		{
			arg_12_0.leftList,
			"pos",
			"left"
		},
		{
			arg_12_0.lineList,
			"width"
		},
		{
			arg_12_0.leftList,
			"width"
		},
		{
			arg_12_0.listview1,
			"pos",
			"left"
		},
		{
			arg_12_0.title,
			"pos",
			"left"
		},
		{
			arg_12_0.tips,
			"pos",
			"left"
		}
	})

	arg_12_0.midColumnSize = var_0_2 + var_12_2
	arg_12_0.midAsyncPreload = arg_12_0.midColumnSize * 5

	adapt.oneLinePos(arg_12_0.haveTip, {
		arg_12_0.haveTxt,
		arg_12_0.haveIcon
	})
	adapt.oneLinePos(arg_12_0.totemGain:get("icon1"), {
		arg_12_0.totemGainTxt2,
		arg_12_0.totemGainTxt1
	}, {
		cc.p(20, 0),
		cc.p(10, 0)
	}, "right")
	adapt.setTextScaleWithWidth(arg_12_0.btnTxt, nil, 300)
end

function var_0_1.initModel(arg_16_0)
	arg_16_0.items = gGameModel.role:getIdler("items")
	arg_16_0.isRefresh = idler.new(false)

	arg_16_0.item1:visible(false)

	arg_16_0.bottomData = idlers.newWithMap({
		{
			quality = 1,
			icon = "city/develop/explore/tag_1.png",
			name = gLanguageCsv.whiteText
		},
		{
			quality = 2,
			icon = "city/develop/explore/tag_2.png",
			name = gLanguageCsv.greenText
		},
		{
			quality = 3,
			icon = "city/develop/explore/tag_3.png",
			name = gLanguageCsv.blueText
		},
		{
			quality = 4,
			icon = "city/develop/explore/tag_4.png",
			name = gLanguageCsv.purpleText
		},
		{
			quality = 5,
			icon = "city/develop/explore/tag_5.png",
			name = gLanguageCsv.orangeText
		}
	})
	arg_16_0.subassemblys = idlers.newWithMap({})
	arg_16_0.decomposeNum = idler.new(0)
	arg_16_0.decomposeDbid = idler.new(0)
end

function var_0_1.gemQuintessence(arg_17_0)
	local var_17_0 = gGameModel.role:read("items")
	local var_17_1 = dataEasy.getNumByKey("coin17") or 0

	arg_17_0.haveTxt:text(var_17_1)

	local var_17_2 = arg_17_0.haveTxt:width() + 50
	local var_17_3 = math.max(var_17_2, 187)

	arg_17_0.havePanel:get("bg"):width(var_17_3)
	adapt.oneLinePos(arg_17_0.haveTip, {
		arg_17_0.haveTxt,
		arg_17_0.haveIcon
	})
end

function var_0_1.onRuleShow(arg_18_0)
	gGameUI:stackUI("common.rule", nil, {}, arg_18_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_1.getRuleContext(arg_19_0, arg_19_1)
	local var_19_0 = adaptContext

	return {
		var_19_0.clone(arg_19_1.title, function(arg_20_0)
			arg_20_0:get("text"):text(gLanguageCsv.rule)
		end),
		var_19_0.noteText(unpack({
			126301,
			126311
		}))
	}
end

function var_0_1.onRebirthBtn(arg_21_0)
	if not gGameUI:goBackInStackUI("city.card.rebirth.view") then
		gGameUI:stackUI("city.card.rebirth.view", nil, {}, 4)
	end
end

function var_0_1.onColorClick(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	arg_22_0.bottomData:atproxy(arg_22_2).selected = not arg_22_0.bottomData:atproxy(arg_22_2).selected

	local var_22_0 = arg_22_0.bottomData:atproxy(arg_22_2).selected

	for iter_22_0, iter_22_1 in arg_22_0.subassemblys:ipairs() do
		if iter_22_1.proxy(iter_22_1).cfg.quality == arg_22_3 then
			arg_22_0.subassemblys:atproxy(iter_22_0).selected = arg_22_0.bottomData:atproxy(arg_22_2).selected
			arg_22_0.subassemblys:atproxy(iter_22_0).targetNum = arg_22_0.subassemblys:atproxy(iter_22_0).selected and arg_22_0.subassemblys:atproxy(iter_22_0).num or 0
		end
	end

	local var_22_1 = {}

	for iter_22_2, iter_22_3 in pairs(var_0_4) do
		if arg_22_3 == csv.items[iter_22_2].quality then
			table.insert(var_22_1, iter_22_2)
		end
	end

	for iter_22_4, iter_22_5 in ipairs(var_22_1) do
		for iter_22_6, iter_22_7 in pairs(var_0_4) do
			if iter_22_5 == iter_22_6 then
				var_0_4[iter_22_6] = nil
			end
		end
	end

	local var_22_2 = true

	if arg_22_0.qualityData[arg_22_3] then
		for iter_22_8, iter_22_9 in pairs(arg_22_0.qualityData[arg_22_3]) do
			if arg_22_0.bottomData:atproxy(arg_22_2).selected then
				var_0_4[iter_22_9.key] = var_0_4[iter_22_9.key] and var_0_4[iter_22_9.key] + iter_22_9.num or iter_22_9.num
				var_22_2 = false
			end
		end
	end

	arg_22_0.qualityNumCalculate(arg_22_0)

	if var_22_2 and var_22_0 then
		gGameUI:showTip(gLanguageCsv.totemNotQuality)

		arg_22_0.bottomData:atproxy(arg_22_2).selected = false

		return
	end

	local var_22_3 = 0
	local var_22_4 = true

	for iter_22_10, iter_22_11 in arg_22_0.subassemblys:ipairs() do
		if arg_22_0.subassemblys:atproxy(iter_22_10).targetNum and arg_22_0.subassemblys:atproxy(iter_22_10).targetNum > 0 then
			local var_22_5, var_22_6 = csvNext(arg_22_0.subassemblys:atproxy(iter_22_10).cfg.specialArgsMap.decomposeReturn)

			var_22_3 = var_22_3 + var_22_6 * arg_22_0.subassemblys:atproxy(iter_22_10).targetNum
		end
	end

	arg_22_0.decomposeNum:set(var_22_3)
	arg_22_0:refreshTextUpdata(var_22_0)
end

function var_0_1.qualityNumCalculate(arg_23_0)
	local var_23_0 = 2

	for iter_23_0, iter_23_1 in pairs(var_0_4) do
		if var_23_0 < csv.items[iter_23_0].quality then
			var_23_0 = csv.items[iter_23_0].quality
		end
	end

	arg_23_0.quality = var_23_0
end

function var_0_1.refreshTextUpdata(arg_24_0, arg_24_1)
	local var_24_0
	local var_24_1
	local var_24_2 = 0

	if itertools.size(var_0_4) == 0 or arg_24_0.decomposeNum:read() == 0 then
		var_0_4 = {}
		arg_24_0.quality = 0

		for iter_24_0 = 1, 6 do
			if arg_24_0.bottomData:atproxy(iter_24_0) then
				arg_24_0.bottomData:atproxy(iter_24_0).selected = false
			end
		end

		if arg_24_1 then
			gGameUI:showTip(gLanguageCsv.totemNotQuality)

			return false
		end
	else
		for iter_24_1, iter_24_2 in pairs(var_0_4) do
			local var_24_3 = csv.items[iter_24_1]
			local var_24_4 = "coin17"

			var_24_2 = var_24_2 + var_24_3.specialArgsMap.decomposeReturn[var_24_4] * iter_24_2
		end
	end

	arg_24_0.decomposeDbid:set(var_24_2)
end

function var_0_1.onDecompose(arg_25_0)
	local var_25_0 = gGameModel.role:read("rmb")

	if arg_25_0.decomposeNum:read() == 0 then
		gGameUI:showTip(gLanguageCsv.noChooseTotem)

		return
	end

	if arg_25_0.quality >= 4 then
		gGameUI:showDialog({
			btnType = 2,
			isRich = true,
			title = gLanguageCsv.spaceTips,
			content = gLanguageCsv.totemResolve,
			cb = function()
				arg_25_0:onDecomposeRequest()
			end
		})
	else
		arg_25_0.onDecomposeRequest(arg_25_0)
	end
end

function var_0_1.onDecomposeRequest(arg_27_0)
	local var_27_0 = {
		false
	}

	gGameApp:requestServerCustom("/game/totem/decompose"):params(var_0_4):onResponse(function(arg_28_0)
		printtable(arg_28_0)
		arg_27_0.fenjie:play("fenjie")
		performWithDelay(arg_27_0, function()
			var_27_0[1] = true

			gGameUI:showGainDisplay({
				{
					csvNext(arg_28_0.view)
				}
			}, {
				raw = false,
				cb = function(...)
					arg_27_0:gemQuintessence()

					local var_30_0 = "coin17"

					var_0_5(arg_27_0.haveTxt, "+" .. arg_28_0.view[var_30_0], true)

					for iter_30_0 = 1, 6 do
						if arg_27_0.bottomData:atproxy(iter_30_0) then
							arg_27_0.bottomData:atproxy(iter_30_0).selected = false
						end
					end
				end
			})
			arg_27_0.fenjie:play("fenjie_standby_loop")
		end, 1.6)
	end):wait(var_27_0):doit(function(arg_31_0)
		arg_27_0.fenjie:play("fenjie_standby_loop")
	end)
end

function var_0_1.onJump(arg_32_0)
	jumpEasy.jumpTo("townExploration")
end

return var_0_1
