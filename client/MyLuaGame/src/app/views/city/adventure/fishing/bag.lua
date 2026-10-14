local var_0_0 = 4
local var_0_1 = 25
local var_0_2 = class("FishingBagView", Dialog)

var_0_2.RESOURCE_FILENAME = "fishing_bag.json"
var_0_2.RESOURCE_BINDING = {
	["rightRod.value.waitTime.txt"] = "rodWaitTimeTxt",
	["rightBait.get.costTip.icon"] = "baitCostIcon",
	["rightRod.value.scaleUp"] = "rodValScaleUp",
	["rightRod.value.upSpeed"] = "rodValUpSpe",
	["rightBait.value.autoSuccessRate"] = "baitValAutoSuccessRate",
	["rightRod.get.lockTip"] = "rodGetLock",
	rightPartner = "rightPartner",
	["rightRod.specialGet"] = "rodSpecialGet",
	["rightRod.value.upSpeed.txt"] = "rodUpSpeTxt",
	["rightBait.get.costTip"] = "baitGetCost",
	["rightRod.value.upSpeed.name"] = "rodUpSpeName",
	center = "center",
	["rightRod.get.costTip.cost2"] = "rodCostCost2",
	["rightBait.specialGet"] = "baitSpecialGet",
	rightBait = "rightBait",
	["rightBait.get.lockTip"] = "baitGetLock",
	["rightRod.value.waitTime.name"] = "rodWaitTimeName",
	["rightBait.get.costTip.cost"] = "baitCostCost",
	["rightRod.get.costTip.cost"] = "rodCostCost",
	["rightRod.value.scaleUp.txt"] = "rodScaleUpTxt",
	["rightBait.value"] = "baitVal",
	["rightRod.value.autoSuccessRate.txt"] = "rodAutoSuccessRateTxt",
	["rightBait.value.lowerWait.txt"] = "baitLowerWaitTxt",
	rightRod = "rightRod",
	["rightBait.value.lowerRange.name"] = "baitLowerRangeName",
	["center.subList"] = "subList",
	["rightBait.value.lowerRange.txt"] = "baitLowerRangeTxt",
	["rightBait.get.costTip.cost2"] = "baitCostCost2",
	btn = "btnItem",
	["rightBait.value.lowerWait.name"] = "baitLowerWaitName",
	["rightBait.value.lowerRange"] = "baitValLowerRange",
	["rightPartner.get.cost.need.need1"] = "partnerNeed1",
	["rightRod.get.costTip"] = "rodGetCost",
	["rightBait.get.lockTip.cost"] = "baitLockCost",
	["rightRod.get.lockTip.cost"] = "rodLockCost",
	["rightBait.value.autoSuccessRate.name"] = "baitAutoSuccessRateName",
	["rightBait.value.lowerWait"] = "baitValLowerWait",
	["rightBait.value.autoSuccessRate.txt"] = "baitAutoSuccessRateTxt",
	["center.item"] = "item",
	["rightRod.value.speed"] = "rodValSpe",
	["rightPartner.get.cost.need.need2"] = "partnerNeed2",
	["rightRod.value"] = "rodVal",
	["rightPartner.get.cost"] = "partnerGetCost",
	["rightPartner.get.cost.cost.cost"] = "partnerCostCost",
	["rightRod.value.autoSuccessRate.name"] = "rodAutoSuccessRateName",
	["rightPartner.get.cost.cost.cost2"] = "partnerCostCost2",
	["rightRod.get.costTip.icon"] = "rodCostIcon",
	["rightPartner.get.cost.cost.icon"] = "partnerCostIcon",
	["rightPartner.get.cost.need.txt"] = "partnerTxt",
	["rightRod.value.scaleUp.name"] = "rodScaleUpName",
	["rightRod.value.speed.txt"] = "rodSpeTxt",
	["rightRod.value.autoSuccessRate"] = "rodValAutoSuccessRate",
	["rightRod.value.waitTime"] = "rodValWaitTime",
	["rightRod.value.speed.name"] = "rodSpeName",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["left.list"] = {
		varname = "btnList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("btnDatas"),
				item = bindHelper.self("btnItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("btnNormal")
					local var_1_1 = arg_1_1:get("btnSelected")

					var_1_1:visible(arg_1_3.selected)
					var_1_0:visible(not arg_1_3.selected)
					var_1_0:get("txt"):text(arg_1_3.txt)
					var_1_1:get("txt"):text(arg_1_3.txt)
					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onSelectClick")
			}
		}
	},
	["center.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				data = bindHelper.self("itemDatas"),
				columnSize = var_0_0,
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				leftPadding = var_0_1,
				topPadding = var_0_1,
				itemAction = {
					isAction = true
				},
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					bind.extend(arg_2_0, arg_2_1, {
						class = "fishtools_icon",
						props = {
							num = true,
							lock = true,
							data = {
								key = arg_2_3.id,
								typ = arg_2_3.typ,
								needLv = arg_2_3.needLv,
								lock = arg_2_3.isLock
							},
							onNode = function(arg_3_0)
								if arg_2_3.selectEffect then
									arg_2_3.selectEffect:removeSelf()
									arg_2_3.selectEffect:align(cc.p(0.5, 0.5), 100, 100)
									arg_3_0:add(arg_2_3.selectEffect, -1)

									local var_3_0 = "common/box/box_selected.png"
									local var_3_1 = 1

									if arg_2_3.typ == 3 then
										var_3_0 = "common/box/box_portrait_select.png"
										var_3_1 = 0.9
									end

									arg_2_3.selectEffect:scale(var_3_1)
									arg_2_3.selectEffect:texture(var_3_0)
								end
							end
						}
					})

					local var_2_0 = arg_2_0:getIdx(arg_2_2)

					arg_2_1:get("use"):visible(arg_2_3.isUse)

					local var_2_1 = "common/box/mask_fangd.png"
					local var_2_2 = 1
					local var_2_3 = 1

					if arg_2_3.typ == 3 then
						var_2_1 = "common/box/mask_d.png"
						var_2_2 = 1.2
						var_2_3 = 0.7
					end

					arg_2_1:get("use"):texture(var_2_1)
					arg_2_1:get("use"):scale(var_2_2)
					arg_2_1:get("use"):get("txt"):scale(var_2_3):xy(arg_2_1:get("use"):width() / 2, arg_2_1:get("use"):height() / 2)
					text.addEffect(arg_2_1:get("use"):get("txt"), {
						outline = {
							size = 3,
							color = cc.c4b(91, 84, 91, 255)
						}
					})
					bind.click(arg_2_0, arg_2_1, {
						method = functools.partial(arg_2_0.itemClick, var_2_0, arg_2_3)
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	["rightRod.get.btnBuy"] = {
		varname = "rodBtnBuy",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRodBtnBuy")
			}
		}
	},
	["rightRod.get.btnUse"] = {
		varname = "rodBtnUse",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnUse")
			}
		}
	},
	["rightBait.get.btnBuy"] = {
		varname = "baitBtnBuy",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBaitBtnBuy")
			}
		}
	},
	["rightBait.get.btnUse"] = {
		varname = "baitBtnUse",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnUse")
			}
		}
	},
	["rightPartner.get.btnBuy"] = {
		varname = "partnerBtnBuy",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPartnerBtnBuy")
			}
		}
	},
	["rightPartner.get.btnUse"] = {
		varname = "partnerBtnUse",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnUse")
			}
		}
	}
}

function var_0_2.onCreate(arg_4_0, arg_4_1, arg_4_2)
	Dialog.onCreate(arg_4_0)
	arg_4_0:initModel()

	arg_4_0.selectEffect = ccui.ImageView:create("common/box/box_selected.png"):alignCenter(arg_4_0.item:size()):retain()
	arg_4_0.selectItemRefresh = true
	arg_4_0.showTab = idler.new(arg_4_1 or 1)
	arg_4_0.itemDatas = idlers.new({})
	arg_4_0.selectItem = idler.new(1)

	idlereasy.any({
		arg_4_0.fishLevel,
		arg_4_0.items,
		arg_4_0.showTab,
		arg_4_0.partner,
		arg_4_0.selectRod,
		arg_4_0.selectBait,
		arg_4_0.selectPartner
	}, function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7)
		local var_5_0 = {}

		if arg_5_3 == 1 then
			for iter_5_0, iter_5_1 in csvPairs(csv.fishing.rod) do
				var_5_0[iter_5_0] = {
					typ = 1,
					csvID = iter_5_0,
					id = iter_5_1.itemId,
					name = iter_5_1.name,
					desc = iter_5_1.desc,
					extraSpeed = iter_5_1.extraSpeed,
					lowerSpeed = iter_5_1.lowerSpeed,
					extraZone = iter_5_1.extraZone,
					extraProbability = iter_5_1.extraProbability,
					lowerWait = iter_5_1.lowerWait,
					needLv = iter_5_1.needLv,
					cost = iter_5_1.cost,
					isLock = arg_5_2[iter_5_1.itemId],
					fishLevel = arg_5_1,
					isUse = arg_5_5 == iter_5_0
				}
			end
		elseif arg_5_3 == 2 then
			for iter_5_2, iter_5_3 in csvPairs(csv.fishing.bait) do
				if itertools.map(csv.fishing.bait[iter_5_2].scene, function(arg_6_0, arg_6_1)
					return arg_6_1, true
				end)[arg_4_2] then
					table.insert(var_5_0, {
						typ = 2,
						csvID = iter_5_2,
						id = iter_5_3.itemId,
						name = iter_5_3.name,
						desc = iter_5_3.desc,
						cost = iter_5_3.cost,
						lowerRandom = iter_5_3.lowerRandom,
						lowerWait = iter_5_3.lowerWait,
						extraProbability = iter_5_3.extraProbability,
						needLv = iter_5_3.needLv,
						isLock = arg_5_2[iter_5_3.itemId],
						fishLevel = arg_5_1,
						isUse = arg_5_6 == iter_5_2
					})
				end
			end

			table.sort(var_5_0, function(arg_7_0, arg_7_1)
				return arg_7_0.csvID < arg_7_1.csvID
			end)
		elseif arg_5_3 == 3 then
			for iter_5_4, iter_5_5 in csvPairs(csv.fishing.partner) do
				var_5_0[iter_5_4] = {
					typ = 3,
					csvID = iter_5_4,
					id = iter_5_5.unitId,
					name = iter_5_5.name,
					desc = iter_5_5.desc,
					cost = iter_5_5.cost,
					needLv = iter_5_5.needLv,
					isLock = arg_5_4[iter_5_4],
					fishLevel = arg_5_1,
					isUse = arg_5_7 == iter_5_4
				}
			end
		end

		if arg_4_0.selectItemRefresh then
			arg_4_0.selectItemRefresh = false

			local var_5_1 = 1

			for iter_5_6, iter_5_7 in pairs(var_5_0) do
				if iter_5_7.isUse then
					var_5_1 = iter_5_6

					break
				end
			end

			arg_4_0.selectItem:set(var_5_1)
		end

		local var_5_2 = arg_4_0.selectItem:read()

		if var_5_0[var_5_2] then
			var_5_0[var_5_2].selectEffect = arg_4_0.selectEffect
		end

		arg_4_0.itemDatas:update(var_5_0)

		arg_4_0.idx = arg_5_3

		arg_4_0.selectItem:notify()
	end)

	local var_4_0 = {
		{
			selected = false,
			txt = gLanguageCsv.rod
		},
		{
			selected = false,
			txt = gLanguageCsv.bait
		},
		{
			selected = false,
			txt = gLanguageCsv.partner
		}
	}

	arg_4_0.btnDatas = idlers.new(var_4_0)

	arg_4_0.btnDatas:update(var_4_0)

	arg_4_0.panel = {
		arg_4_0.rightRod,
		arg_4_0.rightBait,
		arg_4_0.rightPartner
	}

	arg_4_0.showTab:addListener(function(arg_8_0, arg_8_1, arg_8_2)
		arg_4_0.btnDatas:atproxy(arg_8_1).selected = false
		arg_4_0.btnDatas:atproxy(arg_8_0).selected = true
	end)
	arg_4_0.selectItem:addListener(function(arg_9_0, arg_9_1)
		local var_9_0 = arg_4_0.itemDatas:atproxy(arg_9_1)

		if arg_9_0 ~= arg_9_1 and var_9_0 and var_9_0.selectEffect ~= nil then
			var_9_0.selectEffect = nil
		end

		local var_9_1 = arg_4_0.itemDatas:atproxy(arg_9_0)

		if var_9_1 then
			if arg_9_0 ~= arg_9_1 and var_9_1.selectEffect ~= arg_4_0.selectEffect then
				var_9_1.selectEffect = arg_4_0.selectEffect
			end

			arg_4_0:resetShowPanel(var_9_1, arg_4_0.idx)
		end
	end)
end

function var_0_2.resetShowPanel(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0.panel[1]:visible(arg_10_2 == 1)
	arg_10_0.panel[2]:visible(arg_10_2 == 2)
	arg_10_0.panel[3]:visible(arg_10_2 == 3)
	bind.extend(arg_10_0, arg_10_0.panel[arg_10_2], {
		class = "fishtools_icon",
		props = {
			data = {
				key = arg_10_1.id,
				typ = arg_10_1.typ
			},
			onNode = function(arg_11_0)
				arg_11_0:align(cc.p(0.5, 0.5), arg_10_0.panel[arg_10_2]:get("icon"):x() - 35, arg_10_0.panel[arg_10_2]:get("icon"):y() - 35):scale(1.3):z(3)
			end
		}
	})
	arg_10_0.panel[arg_10_2]:get("name"):text(arg_10_1.name)

	local var_10_0 = arg_10_1.desc
	local var_10_1 = csv.items[arg_10_1.id]

	if arg_10_2 == 1 or arg_10_2 == 2 then
		var_10_0 = var_10_1.desc
	end

	beauty.textScroll({
		isRich = true,
		align = "center",
		list = arg_10_0.panel[arg_10_2]:get("list"),
		strs = "#C0x5B545B#" .. var_10_0
	})

	if arg_10_2 == 1 then
		arg_10_0.rodSpeTxt:text("+" .. arg_10_1.extraSpeed * 100 .. "%")
		arg_10_0.rodValSpe:visible(arg_10_1.extraSpeed ~= 0)
		adapt.oneLinePos(arg_10_0.rodSpeName, arg_10_0.rodSpeTxt, cc.p(30, 0), "left")
		arg_10_0.rodUpSpeTxt:text("-" .. arg_10_1.lowerSpeed * 100 .. "%")
		arg_10_0.rodValUpSpe:visible(arg_10_1.lowerSpeed ~= 0)
		adapt.oneLinePos(arg_10_0.rodUpSpeName, arg_10_0.rodUpSpeTxt, cc.p(30, 0), "left")
		arg_10_0.rodScaleUpTxt:text("+" .. (arg_10_1.extraZone - 1) * 100 .. "%")
		arg_10_0.rodValScaleUp:visible(arg_10_1.extraZone ~= 0)
		adapt.oneLinePos(arg_10_0.rodScaleUpName, arg_10_0.rodScaleUpTxt, cc.p(30, 0), "left")
		arg_10_0.rodAutoSuccessRateTxt:text("+" .. arg_10_1.extraProbability * 100 .. "%")
		arg_10_0.rodValAutoSuccessRate:visible(arg_10_1.extraProbability ~= 0)
		adapt.oneLinePos(arg_10_0.rodAutoSuccessRateName, arg_10_0.rodAutoSuccessRateTxt, cc.p(30, 0), "left")
		arg_10_0.rodWaitTimeTxt:text("-" .. arg_10_1.lowerWait * 100 .. "%")
		arg_10_0.rodValWaitTime:visible(arg_10_1.lowerWait ~= 0)
		adapt.oneLinePos(arg_10_0.rodWaitTimeName, arg_10_0.rodWaitTimeTxt, cc.p(30, 0), "left")

		local var_10_2 = {}

		if arg_10_1.extraSpeed ~= 0 then
			table.insert(var_10_2, "extraSpeed")
		end

		if arg_10_1.lowerSpeed ~= 0 then
			table.insert(var_10_2, "lowerSpeed")
		end

		if arg_10_1.extraZone ~= 0 then
			table.insert(var_10_2, "extraZone")
		end

		if arg_10_1.extraProbability ~= 0 then
			table.insert(var_10_2, "extraProbability")
		end

		if arg_10_1.lowerWait ~= 0 then
			table.insert(var_10_2, "lowerWait")
		end

		local var_10_3 = table.length(var_10_2)

		for iter_10_0 = 1, var_10_3 do
			local var_10_4 = (5 - iter_10_0) / 2 * 90

			if var_10_2[iter_10_0] == "extraSpeed" then
				arg_10_0.rodValSpe:y(var_10_4)
			elseif var_10_2[iter_10_0] == "lowerSpeed" then
				arg_10_0.rodValUpSpe:y(var_10_4)
			elseif var_10_2[iter_10_0] == "extraZone" then
				arg_10_0.rodValScaleUp:y(var_10_4)
			elseif var_10_2[iter_10_0] == "extraProbability" then
				arg_10_0.rodValAutoSuccessRate:y(var_10_4)
			elseif var_10_2[iter_10_0] == "lowerWait" then
				arg_10_0.rodValWaitTime:y(var_10_4)
			end
		end

		local var_10_5, var_10_6 = csvNext(arg_10_1.cost)

		arg_10_0.rodGetLock:visible(arg_10_1.fishLevel < arg_10_1.needLv)
		arg_10_0.rodLockCost:text(string.format(gLanguageCsv.fishingLvNotEnough, arg_10_1.needLv))
		arg_10_0.rodBtnBuy:setTouchEnabled(arg_10_1.fishLevel >= arg_10_1.needLv)
		cache.setShader(arg_10_0.rodBtnBuy, false, arg_10_1.fishLevel >= arg_10_1.needLv and "normal" or "hsl_gray")
		arg_10_0.rodBtnUse:setTouchEnabled(arg_10_1.fishLevel >= arg_10_1.needLv)
		cache.setShader(arg_10_0.rodBtnUse, false, arg_10_1.fishLevel >= arg_10_1.needLv and "normal" or "hsl_gray")

		local var_10_7 = arg_10_1.isLock

		arg_10_0.rodBtnBuy:visible(var_10_7 == nil)
		arg_10_0.rodBtnUse:visible(var_10_7 ~= nil)

		if var_10_7 == nil then
			arg_10_0.rodGetCost:visible(var_10_5 ~= nil)
			arg_10_0.rodSpecialGet:visible(var_10_5 == nil)

			if var_10_5 ~= nil then
				arg_10_0.rodCostCost2:text(var_10_6)
				arg_10_0.rodCostIcon:texture(dataEasy.getIconResByKey(var_10_5))
				adapt.oneLineCenterPos(cc.p(165, arg_10_0.rodCostCost:y()), {
					arg_10_0.rodCostCost,
					arg_10_0.rodCostCost2,
					arg_10_0.rodCostIcon
				}, cc.p(5, 0))
			else
				itertools.invoke({
					arg_10_0.rodBtnBuy,
					arg_10_0.rodBtnUse
				}, "hide")
			end
		else
			itertools.invoke({
				arg_10_0.rodGetCost,
				arg_10_0.rodSpecialGet
			}, "hide")
		end
	elseif arg_10_2 == 2 then
		arg_10_0.baitLowerRangeTxt:text("-" .. arg_10_1.lowerRandom * 100 .. "%")
		arg_10_0.baitValLowerRange:visible(arg_10_1.lowerRandom ~= 0)
		adapt.oneLinePos(arg_10_0.baitLowerRangeName, arg_10_0.baitLowerRangeTxt, cc.p(30, 0), "left")
		arg_10_0.baitLowerWaitTxt:text("-" .. arg_10_1.lowerWait * 100 .. "%")
		arg_10_0.baitValLowerWait:visible(arg_10_1.lowerWait ~= 0)
		adapt.oneLinePos(arg_10_0.baitLowerWaitName, arg_10_0.baitLowerWaitTxt, cc.p(30, 0), "left")
		arg_10_0.baitAutoSuccessRateTxt:text("+" .. arg_10_1.extraProbability * 100 .. "%")
		arg_10_0.baitValAutoSuccessRate:visible(arg_10_1.extraProbability ~= 0)
		adapt.oneLinePos(arg_10_0.baitAutoSuccessRateName, arg_10_0.baitAutoSuccessRateTxt, cc.p(30, 0), "left")

		local var_10_8 = {}

		if arg_10_1.lowerRandom ~= 0 then
			table.insert(var_10_8, "lowerRandom")
		end

		if arg_10_1.lowerWait ~= 0 then
			table.insert(var_10_8, "lowerWait")
		end

		if arg_10_1.extraProbability ~= 0 then
			table.insert(var_10_8, "extraProbability")
		end

		local var_10_9 = table.length(var_10_8)

		for iter_10_1 = 1, var_10_9 do
			local var_10_10 = (3 - iter_10_1) / 2 * 90

			if var_10_8[iter_10_1] == "lowerRandom" then
				arg_10_0.baitValLowerRange:y(var_10_10)
			elseif var_10_8[iter_10_1] == "lowerWait" then
				arg_10_0.baitValLowerWait:y(var_10_10)
			elseif var_10_8[iter_10_1] == "extraProbability" then
				arg_10_0.baitValAutoSuccessRate:y(var_10_10)
			end
		end

		arg_10_0.baitGetLock:visible(arg_10_1.fishLevel < arg_10_1.needLv)
		arg_10_0.baitLockCost:text(string.format(gLanguageCsv.fishingLvNotEnough, arg_10_1.needLv))
		arg_10_0.baitBtnBuy:setTouchEnabled(arg_10_1.fishLevel >= arg_10_1.needLv)
		cache.setShader(arg_10_0.baitBtnBuy, false, arg_10_1.fishLevel >= arg_10_1.needLv and "normal" or "hsl_gray")
		arg_10_0.baitBtnUse:setTouchEnabled(arg_10_1.fishLevel >= arg_10_1.needLv)
		cache.setShader(arg_10_0.baitBtnUse, false, arg_10_1.fishLevel >= arg_10_1.needLv and "normal" or "hsl_gray")

		local var_10_11, var_10_12 = csvNext(arg_10_1.cost)

		arg_10_0.baitBtnBuy:visible(var_10_11 ~= nil)
		arg_10_0.baitBtnUse:visible(var_10_11 ~= nil)
		arg_10_0.baitGetCost:visible(var_10_11 ~= nil)
		arg_10_0.baitSpecialGet:visible(var_10_11 == nil)
		arg_10_0.baitGetLock:x(var_10_11 == nil and 400 or 310)

		if var_10_11 ~= nil then
			arg_10_0.baitCostCost2:text(var_10_12)
			arg_10_0.baitCostIcon:texture(dataEasy.getIconResByKey(var_10_11))
			adapt.oneLineCenterPos(cc.p(150, arg_10_0.baitCostCost:y()), {
				arg_10_0.baitCostCost,
				arg_10_0.baitCostCost2,
				arg_10_0.baitCostIcon
			}, cc.p(5, 0))
		end

		if arg_10_1.isLock ~= nil and var_10_11 == nil then
			arg_10_0.baitBtnBuy:show()
			arg_10_0.baitBtnUse:show()
			arg_10_0.baitBtnBuy:setTouchEnabled(false)
			cache.setShader(arg_10_0.baitBtnBuy, false, "hsl_gray")
		elseif arg_10_1.isLock ~= nil then
			arg_10_0.baitBtnUse:show()
			arg_10_0.baitBtnUse:setTouchEnabled(true)
			cache.setShader(arg_10_0.baitBtnUse, false, "normal")
		elseif arg_10_1.isLock == nil and var_10_11 == nil then
			arg_10_0.baitBtnBuy:hide()
			arg_10_0.baitBtnUse:hide()
		end
	elseif arg_10_2 == 3 then
		if arg_10_1.fishLevel < arg_10_1.needLv then
			text.addEffect(arg_10_0.partnerTxt, {
				color = cc.c4b(183, 176, 158, 255)
			})
			text.addEffect(arg_10_0.partnerNeed2, {
				color = cc.c4b(183, 176, 158, 255)
			})
		else
			text.addEffect(arg_10_0.partnerTxt, {
				color = cc.c4b(91, 84, 91, 255)
			})
			text.addEffect(arg_10_0.partnerNeed2, {
				color = cc.c4b(91, 84, 91, 255)
			})
		end

		local var_10_13 = csv.unit[arg_10_1.id]

		if arg_10_0.pokedex:read()[var_10_13.cardID] == nil then
			text.addEffect(arg_10_0.partnerNeed1, {
				color = cc.c4b(183, 176, 158, 255)
			})
		else
			text.addEffect(arg_10_0.partnerNeed1, {
				color = cc.c4b(91, 84, 91, 255)
			})
		end

		arg_10_0.partnerBtnBuy:setTouchEnabled(arg_10_1.fishLevel >= arg_10_1.needLv and arg_10_0.pokedex:read()[var_10_13.cardID] ~= nil)
		cache.setShader(arg_10_0.partnerBtnBuy, false, arg_10_1.fishLevel >= arg_10_1.needLv and arg_10_0.pokedex:read()[var_10_13.cardID] ~= nil and "normal" or "hsl_gray")
		arg_10_0.partnerTxt:text(arg_10_1.needLv)
		adapt.oneLinePos(arg_10_0.partnerNeed2, arg_10_0.partnerTxt, cc.p(0, 0), "left")

		local var_10_14, var_10_15 = csvNext(arg_10_1.cost)

		arg_10_0.partnerCostCost2:text(var_10_15)
		arg_10_0.partnerCostIcon:texture(dataEasy.getIconResByKey(var_10_14))
		adapt.oneLineCenterPos(cc.p(175, arg_10_0.partnerCostCost:y()), {
			arg_10_0.partnerCostCost,
			arg_10_0.partnerCostCost2,
			arg_10_0.partnerCostIcon
		}, cc.p(5, 0))
		arg_10_0.partnerBtnBuy:visible(arg_10_1.isLock == nil)
		arg_10_0.partnerBtnUse:visible(arg_10_1.isLock ~= nil)
		arg_10_0.partnerGetCost:visible(arg_10_1.isLock == nil)
	end
end

function var_0_2.onRodBtnBuy(arg_12_0)
	local var_12_0 = arg_12_0.itemDatas:atproxy(arg_12_0.selectItem:read())
	local var_12_1 = "num"

	if var_12_0.typ == 1 then
		local var_12_2
	end

	local var_12_3 = {}
	local var_12_4, var_12_5 = csvNext(var_12_0.cost)

	var_12_3[var_12_4] = var_12_5

	gGameUI:stackUI("common.buy_info", nil, nil, var_12_3, {
		id = var_12_0.id
	}, {}, arg_12_0:createHandler("rodBuyInfo"))
end

function var_0_2.rodBuyInfo(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.itemDatas:atproxy(arg_13_0.selectItem:read())
	local var_13_1 = "rod"

	gGameApp:requestServer("/game/fishing/item/unlock", function(arg_14_0)
		gGameUI:showTip(gLanguageCsv.hasBuy)
	end, var_13_1, var_13_0.csvID)
end

function var_0_2.onBaitBtnBuy(arg_15_0)
	local var_15_0 = arg_15_0.itemDatas:atproxy(arg_15_0.selectItem:read())
	local var_15_1 = {}
	local var_15_2, var_15_3 = csvNext(var_15_0.cost)

	var_15_1[var_15_2] = var_15_3

	gGameUI:stackUI("common.buy_info", nil, nil, var_15_1, {
		id = var_15_0.id
	}, {
		contentType = "num"
	}, arg_15_0:createHandler("baitBuyInfo"))
end

function var_0_2.baitBuyInfo(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.itemDatas:atproxy(arg_16_0.selectItem:read())

	gGameApp:requestServer("/game/fishing/bait/buy", function(arg_17_0)
		gGameUI:showTip(gLanguageCsv.hasBuy)
	end, var_16_0.csvID, arg_16_1)
end

function var_0_2.onPartnerBtnBuy(arg_18_0)
	local var_18_0 = arg_18_0.itemDatas:atproxy(arg_18_0.selectItem:read())
	local var_18_1, var_18_2 = csvNext(var_18_0.cost)

	if var_18_1 == "rmb" and var_18_2 > arg_18_0.rmb:read() then
		uiEasy.showDialog("rmb")
	elseif var_18_1 == "gold" and var_18_2 > arg_18_0.gold:read() then
		uiEasy.showDialog("gold")
	else
		local var_18_3 = "partner"

		local function var_18_4()
			gGameApp:requestServer("/game/fishing/item/unlock", function(arg_20_0)
				gGameUI:showTip(gLanguageCsv.hasBuy)
			end, var_18_3, var_18_0.csvID)
		end

		if var_18_1 == "rmb" then
			dataEasy.sureUsingDiamonds(var_18_4, var_18_2)
		else
			var_18_4()
		end
	end
end

function var_0_2.onBtnUse(arg_21_0)
	local var_21_0 = {
		"rod",
		"bait",
		"partner"
	}
	local var_21_1 = arg_21_0.itemDatas:atproxy(arg_21_0.selectItem:read())

	if var_21_1.isLock == nil then
		gGameUI:showTip(gLanguageCsv.noBaitCount)

		return
	end

	if var_21_1.typ == 1 and arg_21_0.selectRod:read() == var_21_1.csvID or var_21_1.typ == 2 and arg_21_0.selectBait:read() == var_21_1.csvID or var_21_1.typ == 3 and arg_21_0.selectPartner:read() == var_21_1.csvID then
		gGameUI:showTip(gLanguageCsv.useSuccess)
	elseif arg_21_0.isAuto:read() == true then
		gGameUI:showTip(gLanguageCsv.switchToolsNeedStopAutoFishing)
	else
		gGameApp:requestServer("/game/fishing/prepare", function(arg_22_0)
			gGameUI:showTip(gLanguageCsv.useSuccess)
		end, var_21_0[var_21_1.typ], var_21_1.csvID)
	end
end

function var_0_2.onSelectClick(arg_23_0, arg_23_1, arg_23_2)
	arg_23_0.selectItemRefresh = true

	dataEasy.tryCallFunc(arg_23_0.list, "setItemAction", {
		isAction = true
	})
	arg_23_0.showTab:set(arg_23_2)
end

function var_0_2.onItemClick(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	arg_24_2.data = arg_24_3

	arg_24_0.selectItem:set(arg_24_2.k)
end

function var_0_2.initModel(arg_25_0)
	arg_25_0.fishLevel = gGameModel.fishing:getIdler("level")
	arg_25_0.partner = gGameModel.fishing:getIdler("partner")
	arg_25_0.items = gGameModel.role:getIdler("items")
	arg_25_0.selectRod = gGameModel.fishing:getIdler("select_rod")
	arg_25_0.selectBait = gGameModel.fishing:getIdler("select_bait")
	arg_25_0.selectPartner = gGameModel.fishing:getIdler("select_partner")
	arg_25_0.pokedex = gGameModel.role:getIdler("pokedex")
	arg_25_0.rmb = gGameModel.role:getIdler("rmb")
	arg_25_0.gold = gGameModel.role:getIdler("gold")
	arg_25_0.isAuto = gGameModel.fishing:getIdler("is_auto")
end

return var_0_2
