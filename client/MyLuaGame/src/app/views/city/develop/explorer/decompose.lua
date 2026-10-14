local var_0_0 = class("ExploreDecomposeView", Dialog)
local var_0_1 = {
	cc.c4b(153, 153, 153, 255),
	cc.c4b(92, 153, 112, 255),
	cc.c4b(61, 138, 153, 255),
	cc.c4b(139, 92, 153, 255),
	cc.c4b(229, 153, 0, 255)
}

local function var_0_2(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0, var_1_1 = arg_1_0:xy()
	local var_1_2 = cc.Label:createWithTTF(arg_1_1, "font/youmi.ttf", 40):align(cc.p(0.5, 0.5), arg_1_0:size().width / 2, arg_1_0:size().height / 2 + 30):addTo(arg_1_0, 11)

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
			arg_1_0.lvUpEffect = widget.addAnimation(arg_1_0, "effect/jineng.skel", "effect", 10):xy(90, 85):scale(1.2)
		else
			arg_1_0.lvUpEffect:play("effect")
		end

		audio.playEffectWithWeekBGM("circle.mp3")
	end
end

var_0_0.RESOURCE_FILENAME = "explore_decompose_view.json"
var_0_0.RESOURCE_BINDING = {
	subList = "subList",
	havePanel = "havePanel",
	["gainPanel.num"] = "decomposeTxt",
	["havePanel.num"] = "haveTxt",
	rightIcon = "rightIcon",
	["gainPanel.icon"] = "gainIcon",
	item1 = "item1",
	item = "item",
	["duckPanel.txt"] = "txtDuckPanel",
	["gainPanel.txt"] = "gainTxt",
	duckPanel = "duckPanel",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	title = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	title1 = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	btnDecompose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDecompose")
			}
		}
	},
	btnShop = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShop")
			}
		}
	},
	["btnDecompose.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	leftList = {
		varname = "leftList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 8,
				data = bindHelper.self("subassemblys"),
				dataOrderCmp = function(arg_3_0, arg_3_1)
					if arg_3_0.cfg.sortType ~= arg_3_1.cfg.sortType then
						return arg_3_0.cfg.sortType > arg_3_1.cfg.sortType
					end

					if arg_3_0.cfg.sortValue ~= arg_3_1.cfg.sortValue then
						return arg_3_0.cfg.sortValue > arg_3_1.cfg.sortValue
					end

					if arg_3_0.cfg.quality ~= arg_3_1.cfg.quality then
						return arg_3_0.cfg.quality < arg_3_1.cfg.quality
					end

					return arg_3_0.id < arg_3_1.id
				end,
				isRefresh = bindHelper.self("isRefresh"),
				item = bindHelper.self("subList"),
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

					local function var_4_1(arg_5_0)
						local var_5_0 = var_4_0:proxy().targetNum or 0
						local var_5_1 = cc.clampf(var_5_0 + arg_5_0, 0, var_4_0:proxy().num)

						var_4_0:proxy().targetNum = var_5_1 ~= 0 and var_5_1 or nil
						arg_4_3.targetNum = var_5_1

						arg_4_3.isRefresh:notify()

						if var_5_1 + arg_5_0 < 0 or var_5_1 + arg_5_0 > var_4_0:proxy().num then
							arg_4_0:unSchedule("numChange")
						end
					end

					local var_4_2

					local function var_4_3(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
						local var_6_0 = arg_4_3.targetNum

						if var_4_2 == nil then
							var_4_2 = arg_6_2
						end

						if arg_6_2.name == "click" then
							arg_4_0:unScheduleAll()

							if var_4_2 and (var_6_0 < arg_4_3.num or arg_6_3 < 0) then
								var_4_1(arg_6_3)
								var_0_2(arg_6_0, arg_6_4)
							end

							var_4_2 = nil
						elseif arg_6_2.name == "began" then
							if var_4_2 then
								arg_4_0:schedule(function(arg_7_0)
									if var_6_0 <= arg_4_3.num then
										var_4_1(arg_6_3)
										var_0_2(arg_6_0, arg_6_4)
									end
								end, 0.1, 0, "numChange")
							end
						elseif arg_6_2.name == "moved" then
							if var_4_2 then
								local var_6_1 = math.abs(arg_6_2.x - var_4_2.x)
								local var_6_2 = math.abs(arg_6_2.y - var_4_2.y)

								if var_6_1 >= ui.TOUCH_MOVE_CANCAE_THRESHOLD or var_6_2 >= ui.TOUCH_MOVE_CANCAE_THRESHOLD then
									var_4_2 = false

									arg_4_0:unSchedule("numChange")
								end
							end
						elseif arg_6_2.name == "ended" or arg_6_2.name == "cancelled" then
							var_4_2 = nil

							arg_4_0:unSchedule("numChange")
						end
					end

					bind.extend(arg_4_0, arg_4_1, {
						class = "explore_icon",
						props = {
							showReduce = true,
							longtouch = true,
							data = var_4_0,
							onNode = function(arg_8_0)
								bind.touch(arg_4_0, arg_8_0, {
									longtouch = 0.5,
									method = function(arg_9_0, arg_9_1, arg_9_2)
										var_4_3(arg_8_0, arg_9_1, arg_9_2, 1, "+1")
									end
								})
								bind.touch(arg_4_0, arg_8_0:get("reduceIcon"), {
									longtouch = 0.5,
									method = function(arg_10_0, arg_10_1, arg_10_2)
										var_4_3(arg_8_0, arg_10_1, arg_10_2, -1, "-1")
									end
								})
							end
						}
					})
				end
			}
		}
	},
	bottomList = {
		varname = "listview",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 15,
				padding = 25,
				data = bindHelper.self("bottomData"),
				item = bindHelper.self("item1"),
				onItem = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
					local var_11_0 = arg_11_1:multiget("bg", "name", "selected")

					var_11_0.bg:texture(arg_11_3.icon)
					var_11_0.name:text(arg_11_3.name)
					var_11_0.selected:visible(arg_11_3.selected == true)
					var_11_0.bg:setTouchEnabled(true)
					text.addEffect(var_11_0.name, {
						color = var_0_1[arg_11_3.quality]
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
	}
}

function var_0_0.onCreate(arg_12_0, arg_12_1)
	arg_12_0:initModel()
	adapt.setTextAdaptWithSize(arg_12_0.txtDuckPanel, {
		vertical = "center",
		horizontal = "center",
		size = cc.size(300, 200)
	})

	arg_12_0.isRefresh = idler.new(false)
	arg_12_0.components = arg_12_1()
	arg_12_0.subassemblys = idlers.newWithMap({})
	arg_12_0.bottomData = idlers.newWithMap({
		{
			icon = "city/develop/explore/tag_2.png",
			quality = 2,
			name = gLanguageCsv.greenText
		},
		{
			icon = "city/develop/explore/tag_3.png",
			quality = 3,
			name = gLanguageCsv.blueText
		},
		{
			icon = "city/develop/explore/tag_4.png",
			quality = 4,
			name = gLanguageCsv.purpleText
		},
		{
			icon = "city/develop/explore/tag_5.png",
			quality = 5,
			name = gLanguageCsv.orangeText
		}
	})

	idlereasy.when(arg_12_0.components, function(arg_13_0, arg_13_1)
		local var_13_0 = {}

		for iter_13_0, iter_13_1 in ipairs(arg_13_1) do
			if iter_13_1.count ~= 0 then
				local var_13_1 = csv.explorer.component[iter_13_1.id].itemID

				table.insert(var_13_0, {
					targetNum = 0,
					id = var_13_1,
					num = iter_13_1.count,
					cfg = csv.items[var_13_1],
					isRefresh = arg_12_0.isRefresh
				})
			end
		end

		dataEasy.tryCallFunc(arg_12_0.leftList, "updatePreloadCenterIndex")
		arg_12_0.subassemblys:update(var_13_0)
		arg_12_0.duckPanel:visible(#var_13_0 == 0)
	end)

	arg_12_0.decomposeNum = idler.new(0)

	idlereasy.when(arg_12_0.decomposeNum, function(arg_14_0, arg_14_1)
		arg_12_0.decomposeTxt:text(arg_14_1)
		adapt.oneLinePos(arg_12_0.gainTxt, {
			arg_12_0.decomposeTxt,
			arg_12_0.gainIcon
		}, cc.p(15, 0), "left")
	end)
	idlereasy.when(arg_12_0.isRefresh, function()
		local var_15_0 = 0
		local var_15_1 = {}

		for iter_15_0, iter_15_1 in arg_12_0.subassemblys:ipairs() do
			if arg_12_0.subassemblys:atproxy(iter_15_0).targetNum and arg_12_0.subassemblys:atproxy(iter_15_0).targetNum > 0 then
				local var_15_2, var_15_3 = csvNext(arg_12_0.subassemblys:atproxy(iter_15_0).cfg.specialArgsMap)

				var_15_0 = var_15_0 + var_15_3 * arg_12_0.subassemblys:atproxy(iter_15_0).targetNum
			end
		end

		arg_12_0.decomposeNum:set(var_15_0)
	end)
	idlereasy.when(arg_12_0.coin4, function(arg_16_0, arg_16_1)
		arg_12_0.haveTxt:text(arg_16_1)
	end)
	Dialog.onCreate(arg_12_0)
end

function var_0_0.initModel(arg_17_0)
	arg_17_0.items = gGameModel.role:getIdler("items")
	arg_17_0.coin4 = gGameModel.role:getIdler("coin4")
end

function var_0_0.onColorClick(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	arg_18_0.bottomData:atproxy(arg_18_2).selected = not arg_18_0.bottomData:atproxy(arg_18_2).selected

	for iter_18_0, iter_18_1 in arg_18_0.subassemblys:ipairs() do
		if iter_18_1:proxy().cfg.quality == arg_18_3 then
			arg_18_0.subassemblys:atproxy(iter_18_0).selected = arg_18_0.bottomData:atproxy(arg_18_2).selected
			arg_18_0.subassemblys:atproxy(iter_18_0).targetNum = arg_18_0.subassemblys:atproxy(iter_18_0).selected and arg_18_0.subassemblys:atproxy(iter_18_0).num or 0
		end
	end

	local var_18_0 = 0

	for iter_18_2, iter_18_3 in arg_18_0.subassemblys:ipairs() do
		if arg_18_0.subassemblys:atproxy(iter_18_2).targetNum and arg_18_0.subassemblys:atproxy(iter_18_2).targetNum > 0 then
			local var_18_1, var_18_2 = csvNext(arg_18_0.subassemblys:atproxy(iter_18_2).cfg.specialArgsMap)

			var_18_0 = var_18_0 + var_18_2 * arg_18_0.subassemblys:atproxy(iter_18_2).targetNum
		end
	end

	arg_18_0.decomposeNum:set(var_18_0)
end

function var_0_0.onDecompose(arg_19_0)
	if arg_19_0.decomposeNum:read() == 0 then
		gGameUI:showTip(gLanguageCsv.noChooseComponent)

		return
	end

	local var_19_0 = {}
	local var_19_1 = false

	for iter_19_0, iter_19_1 in arg_19_0.subassemblys:ipairs() do
		if arg_19_0.subassemblys:atproxy(iter_19_0).targetNum and arg_19_0.subassemblys:atproxy(iter_19_0).targetNum > 0 then
			var_19_0[arg_19_0.subassemblys:atproxy(iter_19_0).id] = arg_19_0.subassemblys:atproxy(iter_19_0).targetNum

			if arg_19_0.subassemblys:atproxy(iter_19_0).cfg.quality >= 4 then
				var_19_1 = var_19_1 or true
			end
		end
	end

	if var_19_1 then
		gGameUI:showDialog({
			isRich = true,
			btnType = 2,
			title = gLanguageCsv.spaceTips,
			content = gLanguageCsv.selectedHighQualityComponent,
			cb = function()
				arg_19_0:onDecomposeRequest(var_19_0)
			end
		})
	else
		gGameUI:showDialog({
			isRich = true,
			btnType = 2,
			title = gLanguageCsv.spaceTips,
			content = string.format(gLanguageCsv.deComposeComponent, dataEasy.getIconResByKey("coin4"), arg_19_0.decomposeNum:read()),
			cb = function()
				arg_19_0:onDecomposeRequest(var_19_0)
			end
		})
	end
end

function var_0_0.onDecomposeRequest(arg_22_0, arg_22_1)
	local var_22_0 = {
		false
	}

	gGameApp:requestServerCustom("/game/explorer/component/decompose"):params(arg_22_1):onResponse(function()
		var_22_0[1] = true
	end):wait(var_22_0):doit(function(arg_24_0)
		gGameUI:showGainDisplay({
			{
				"coin4",
				arg_22_0.decomposeNum:read()
			}
		}, {
			raw = false
		})
		arg_22_0.decomposeNum:set(0)
	end)
end

function var_0_0.onShop(arg_25_0)
	if not gGameUI:goBackInStackUI("city.shop") then
		gGameApp:requestServer("/game/explorer/shop/get", function()
			gGameUI:stackUI("city.shop", nil, {
				full = true
			}, game.SHOP_INIT.EXPLORER_SHOP)
		end)
	end
end

return var_0_0
