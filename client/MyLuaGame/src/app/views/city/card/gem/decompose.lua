local var_0_0 = require("app.views.city.card.rebirth.tools")
local var_0_1 = class("GemDecomposeView", Dialog)
local var_0_2 = ui.COLORS.QUALITY
local var_0_3 = {}

local function var_0_4(arg_1_0, arg_1_1, arg_1_2)
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
			arg_1_0.lvUpEffect = widget.addAnimation(arg_1_0, "effect/gonghuixunlian.skel", "fangguang", 10):xy(100, 5):scale(1)
		else
			arg_1_0.lvUpEffect:play("fangguang")
		end

		audio.playEffectWithWeekBGM("circle.mp3")
	end
end

var_0_1.RESOURCE_FILENAME = "gem_resolve.json"
var_0_1.RESOURCE_BINDING = {
	["acquire2.rmbPanel.title"] = "gainTxt",
	["acquire2.rmbPanel"] = "rmbPanel",
	["acquire2.rmbPanel.num"] = "decomposeTxt",
	["acquire2.rmbPanel.icon"] = "gainIcon",
	["acquire.num"] = "haveTxt",
	acquire = "havePanel",
	icon = "icon",
	item1 = "item1",
	item = "item",
	mask = "mask",
	lineList = "lineList",
	duckPanel = "duckPanel",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	titleTxt1 = {
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
	titleTxt2 = {
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
	["acquire2.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDecompose")
			}
		}
	},
	["acquire2.btn.txt"] = {
		binds = {
			{
				event = "text",
				data = gLanguageCsv.decomposeText
			},
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	list = {
		varname = "leftList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 4,
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
								table.insert(var_0_3, arg_4_3.dbids[var_5_1])

								var_4_1 = true
							elseif var_4_0:proxy().num == var_5_1 and var_4_1 then
								local var_5_2 = arg_4_3.dbids and arg_4_3.dbids[var_5_1] or arg_4_3.dbid
								local var_5_3 = true

								for iter_5_0, iter_5_1 in pairs(var_0_3) do
									if var_5_2 == iter_5_1 then
										var_5_3 = false
									end
								end

								if var_5_3 then
									table.insert(var_0_3, var_5_2)
								end

								var_4_1 = false
							end
						else
							for iter_5_2, iter_5_3 in pairs(var_0_3) do
								if arg_4_3.level ~= 1 then
									if iter_5_3 == arg_4_3.dbid then
										table.remove(var_0_3, iter_5_2)
									end
								elseif iter_5_3 == arg_4_3.dbids[var_5_1 + 1] then
									table.remove(var_0_3, iter_5_2)
								end
							end

							var_4_1 = true
						end

						arg_4_3.targetNum = var_5_1

						arg_4_3.isRefresh:notify()

						if var_5_1 + arg_5_0 < 0 or var_5_1 + arg_5_0 > var_4_0:proxy().num then
							arg_4_0:unSchedule("numChange")
						end
					end

					local var_4_3

					local function var_4_4(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
						local var_6_0 = arg_4_3.targetNum

						var_6_0 = arg_6_3 < 0 and var_6_0 - 1 or var_6_0

						if var_4_3 == nil then
							var_4_3 = arg_6_2
						end

						if arg_6_2.name == "click" then
							arg_4_0:unScheduleAll()

							if var_4_3 and var_6_0 < arg_4_3.num then
								var_4_2(arg_6_3)
								var_0_4(arg_6_0, arg_6_4)
							end

							var_4_3 = nil
						elseif arg_6_2.name == "began" then
							if var_4_3 then
								arg_4_0:schedule(function(arg_7_0)
									if var_6_0 < arg_4_3.num then
										var_4_2(arg_6_3)
										var_0_4(arg_6_0, arg_6_4)
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
							showReduce = true,
							gemIconShow = true,
							longtouch = true,
							data = var_4_0,
							specialKey = {
								leftTopLv = arg_4_3.level
							},
							onNode = function(arg_8_0)
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
				data = bindHelper.self("bottomData"),
				item = bindHelper.self("item1"),
				onItem = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
					local var_11_0 = arg_11_1:multiget("bg", "name", "selected")

					var_11_0.bg:texture(arg_11_3.icon)
					var_11_0.name:text(arg_11_3.name)
					var_11_0.selected:visible(arg_11_3.selected == true)
					var_11_0.bg:setTouchEnabled(true)
					text.addEffect(var_11_0.name, {
						color = var_0_2[arg_11_3.quality]
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
	["acquire.rule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleShow")
			}
		}
	},
	jumpShop = {
		varname = "jumpShop",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRebirthBtn")
			}
		}
	}
}

function var_0_1.onCreate(arg_12_0)
	arg_12_0.isRefresh = idler.new(false)

	arg_12_0.item1:visible(false)

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
	arg_12_0.subassemblys = idlers.newWithMap({})
	arg_12_0.decomposeNum = idler.new(0)
	arg_12_0.decomposeDbid = idler.new(0)

	idlereasy.when(gGameModel.role:getIdler("gems"), function(arg_13_0, arg_13_1)
		local var_13_0 = {}

		var_0_3 = {}
		arg_12_0.qualityData = {}

		local var_13_1 = {}

		for iter_13_0, iter_13_1 in pairs(arg_13_1) do
			local var_13_2 = gGameModel.gems:find(iter_13_1)

			if var_13_2:read("exist_flag") then
				local var_13_3 = var_13_2:read("gem_id")
				local var_13_4 = var_13_2:read("level")
				local var_13_5 = var_13_2:read("card_db_id")
				local var_13_6 = {
					targetNum = 0,
					num = 1,
					id = var_13_3,
					cfg = dataEasy.getCfgByKey(var_13_3),
					level = var_13_4,
					dbid = iter_13_1,
					quality = csv.gem.gem[var_13_3].quality
				}

				if not var_13_5 then
					if var_13_4 == 1 then
						if not var_13_1[var_13_3] then
							var_13_6.dbids = {
								iter_13_1
							}
							var_13_1[var_13_3] = var_13_6

							table.insert(var_13_0, var_13_6)
						else
							table.insert(var_13_1[var_13_3].dbids, iter_13_1)

							var_13_1[var_13_3].num = var_13_1[var_13_3].num + 1
						end
					else
						table.insert(var_13_0, var_13_6)
					end
				end
			end
		end

		for iter_13_2, iter_13_3 in pairs(var_13_0) do
			var_13_0[iter_13_2].isRefresh = arg_12_0.isRefresh

			local var_13_7 = csv.gem.gem[iter_13_3.id].quality

			if not arg_12_0.qualityData[var_13_7] then
				arg_12_0.qualityData[var_13_7] = {}
			end

			if iter_13_3.num == 1 then
				table.insert(arg_12_0.qualityData[var_13_7], iter_13_3.dbid)
			else
				for iter_13_4, iter_13_5 in ipairs(iter_13_3.dbids) do
					table.insert(arg_12_0.qualityData[var_13_7], iter_13_5)
				end
			end
		end

		arg_12_0.subassemblys:update(var_13_0)
		arg_12_0.duckPanel:visible(#var_13_0 == 0)
		arg_12_0.mask:visible(not #var_13_0 == 0)
		arg_12_0.decomposeNum:set(0)
		arg_12_0.decomposeDbid:set(0)

		arg_12_0.quality = 2
	end)

	arg_12_0.fenjie = widget.addAnimation(arg_12_0.icon, "fushichouqu/fuwenfenjie.skel", "effect_loop", 99):alignCenter(arg_12_0.icon:size())

	idlereasy.when(arg_12_0.decomposeDbid, function(arg_14_0, arg_14_1)
		arg_12_0.decomposeTxt:text(arg_14_1)
		adapt.oneLinePos(arg_12_0.gainTxt, {
			arg_12_0.decomposeTxt,
			arg_12_0.gainIcon
		})
	end)
	idlereasy.when(arg_12_0.isRefresh, function()
		local var_15_0 = 0
		local var_15_1 = {}

		for iter_15_0, iter_15_1 in arg_12_0.subassemblys:ipairs() do
			if arg_12_0.subassemblys:atproxy(iter_15_0).targetNum and arg_12_0.subassemblys:atproxy(iter_15_0).targetNum > 0 then
				local var_15_2, var_15_3 = csvNext(arg_12_0.subassemblys:atproxy(iter_15_0).cfg.decomposeReturn)

				var_15_0 = var_15_0 + var_15_3 * arg_12_0.subassemblys:atproxy(iter_15_0).targetNum
			end
		end

		arg_12_0.decomposeNum:set(var_15_0)
		arg_12_0:refreshTextUpdata()
		arg_12_0:qualityNumCalculate()
	end)
	arg_12_0:gemQuintessence()
	Dialog.onCreate(arg_12_0)
end

function var_0_1.gemQuintessence(arg_16_0)
	local var_16_0 = gGameModel.role:read("items")[529] or 0

	arg_16_0.haveTxt:text(var_16_0)

	local var_16_1 = arg_16_0.haveTxt:width() + 50
	local var_16_2 = math.max(var_16_1, 187)

	arg_16_0.havePanel:get("bg"):width(var_16_2)
	arg_16_0.havePanel:get("rule"):x(arg_16_0.havePanel:get("bg"):x() + var_16_2 + 50)
	arg_16_0.haveTxt:x(arg_16_0.havePanel:get("bg"):x() + var_16_2 / 2)
end

function var_0_1.onRuleShow(arg_17_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_17_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_1.getRuleContext(arg_18_0, arg_18_1)
	local var_18_0 = adaptContext

	return {
		var_18_0.clone(arg_18_1.title, function(arg_19_0)
			arg_19_0:get("text"):text(gLanguageCsv.gemResolve)
		end),
		var_18_0.noteText(unpack({
			84001,
			84005
		}))
	}
end

function var_0_1.onRebirthBtn(arg_20_0)
	if not gGameUI:goBackInStackUI("city.card.rebirth.view") then
		gGameUI:stackUI("city.card.rebirth.view", nil, nil, 4)
	end
end

function var_0_1.onColorClick(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	arg_21_0.bottomData:atproxy(arg_21_2).selected = not arg_21_0.bottomData:atproxy(arg_21_2).selected

	local var_21_0 = arg_21_0.bottomData:atproxy(arg_21_2).selected

	for iter_21_0, iter_21_1 in arg_21_0.subassemblys:ipairs() do
		if iter_21_1:proxy().cfg.quality == arg_21_3 then
			arg_21_0.subassemblys:atproxy(iter_21_0).selected = arg_21_0.bottomData:atproxy(arg_21_2).selected
			arg_21_0.subassemblys:atproxy(iter_21_0).targetNum = arg_21_0.subassemblys:atproxy(iter_21_0).selected and arg_21_0.subassemblys:atproxy(iter_21_0).num or 0
		end
	end

	local var_21_1 = {}

	for iter_21_2, iter_21_3 in ipairs(var_0_3) do
		local var_21_2 = gGameModel.gems:find(iter_21_3):read("gem_id")

		if arg_21_3 == csv.gem.gem[var_21_2].quality then
			table.insert(var_21_1, iter_21_3)
		end
	end

	for iter_21_4, iter_21_5 in ipairs(var_21_1) do
		for iter_21_6, iter_21_7 in ipairs(var_0_3) do
			if iter_21_5 == iter_21_7 then
				table.remove(var_0_3, iter_21_6)
			end
		end
	end

	local var_21_3 = true

	if arg_21_0.qualityData[arg_21_3] then
		for iter_21_8, iter_21_9 in pairs(arg_21_0.qualityData[arg_21_3]) do
			if arg_21_0.bottomData:atproxy(arg_21_2).selected then
				table.insert(var_0_3, iter_21_9)

				var_21_3 = false
			end
		end
	end

	arg_21_0:qualityNumCalculate()

	if var_21_3 and var_21_0 then
		gGameUI:showTip(gLanguageCsv.gemnotQuality)

		arg_21_0.bottomData:atproxy(arg_21_2).selected = false

		return
	end

	local var_21_4 = 0
	local var_21_5 = true

	for iter_21_10, iter_21_11 in arg_21_0.subassemblys:ipairs() do
		if arg_21_0.subassemblys:atproxy(iter_21_10).targetNum and arg_21_0.subassemblys:atproxy(iter_21_10).targetNum > 0 then
			local var_21_6, var_21_7 = csvNext(arg_21_0.subassemblys:atproxy(iter_21_10).cfg.decomposeReturn)

			var_21_4 = var_21_4 + var_21_7 * arg_21_0.subassemblys:atproxy(iter_21_10).targetNum
		end
	end

	arg_21_0.decomposeNum:set(var_21_4)
	arg_21_0:refreshTextUpdata(var_21_0)
end

function var_0_1.qualityNumCalculate(arg_22_0)
	local var_22_0 = 2

	for iter_22_0, iter_22_1 in pairs(var_0_3) do
		local var_22_1 = gGameModel.gems:find(iter_22_1):read("gem_id")

		if var_22_0 < csv.gem.gem[var_22_1].quality then
			var_22_0 = csv.gem.gem[var_22_1].quality
		end
	end

	arg_22_0.quality = var_22_0
end

function var_0_1.refreshTextUpdata(arg_23_0, arg_23_1)
	local var_23_0
	local var_23_1
	local var_23_2 = 0

	if #var_0_3 == 0 or arg_23_0.decomposeNum:read() == 0 then
		var_0_3 = {}
		arg_23_0.quality = 0

		for iter_23_0 = 1, 6 do
			if arg_23_0.bottomData:atproxy(iter_23_0) then
				arg_23_0.bottomData:atproxy(iter_23_0).selected = false
			end
		end

		if arg_23_1 then
			gGameUI:showTip(gLanguageCsv.gemnotQuality)

			return false
		end
	else
		for iter_23_1, iter_23_2 in pairs(var_0_3) do
			local var_23_3 = gGameModel.gems:find(iter_23_2):read("gem_id")
			local var_23_4 = csv.gem.gem[var_23_3].strengthCostSeq
			local var_23_5 = csv.gem.gem[var_23_3].decomposeReturn
			local var_23_6 = gGameModel.gems:find(iter_23_2):read("level")

			if var_23_6 > 1 then
				for iter_23_3, iter_23_4 in orderCsvPairs(csv.gem.cost) do
					if iter_23_3 < var_23_6 then
						var_23_2 = var_23_2 + iter_23_4["costItemMap" .. var_23_4][529]
					end
				end

				var_23_2 = gCommonConfigCsv.gemRebirthRetrunProportion * var_23_2 + var_23_5[529]
			else
				var_23_2 = var_23_2 + var_23_5[529]
			end
		end
	end

	arg_23_0.decomposeDbid:set(var_23_2)
end

function var_0_1.onDecompose(arg_24_0)
	local var_24_0 = gGameModel.role:read("rmb")

	if arg_24_0.decomposeNum:read() == 0 then
		gGameUI:showTip(gLanguageCsv.noChooseComponent)

		return
	end

	if arg_24_0.quality >= 4 then
		gGameUI:showDialog({
			isRich = true,
			btnType = 2,
			title = gLanguageCsv.spaceTips,
			content = gLanguageCsv.resolve,
			cb = function()
				arg_24_0:onDecomposeRequest()
			end
		})
	else
		arg_24_0:onDecomposeRequest()
	end
end

function var_0_1.onDecomposeRequest(arg_26_0)
	local var_26_0 = {
		false
	}

	gGameApp:requestServerCustom("/game/gem/decompose"):params(var_0_3):onResponse(function(arg_27_0)
		arg_26_0.fenjie:play("effect")
		performWithDelay(arg_26_0, function()
			var_26_0[1] = true

			gGameUI:showGainDisplay({
				{
					csvNext(arg_27_0.view)
				}
			}, {
				raw = false,
				cb = function(...)
					arg_26_0:gemQuintessence()
					var_0_4(arg_26_0.haveTxt, "+" .. arg_27_0.view[529], true)
					arg_26_0.jumpShop:setEnabled(true)

					for iter_29_0 = 1, 6 do
						if arg_26_0.bottomData:atproxy(iter_29_0) then
							arg_26_0.bottomData:atproxy(iter_29_0).selected = false
						end
					end
				end
			})
			arg_26_0.fenjie:play("effect_loop")
		end, 1.6)
	end):wait(var_26_0):doit(function(arg_30_0)
		arg_26_0.fenjie:play("effect_loop")
	end)
end

function var_0_1.onCleanup(arg_31_0)
	var_0_3 = {}

	Dialog.onCleanup(arg_31_0)
end

return var_0_1
