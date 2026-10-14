local var_0_0 = {
	AWAKE = 2,
	STAR = 1
}
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("CardSignetOneKeyView", Dialog)

var_0_2.RESOURCE_FILENAME = "card_equip_fast_strengthen.json"
var_0_2.RESOURCE_BINDING = {
	["top.nameMax"] = "nameMax",
	subList = "subList",
	title = "title",
	["top.cashNum"] = "cashNum",
	["top.cashIcon"] = "cashIcon",
	item = "item",
	["top.name"] = "cardName",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	titleTxt1 = {
		varname = "titleTxt1",
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
	titleTxt2 = {
		varname = "titleTxt2",
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
	["top.subBtn"] = {
		varname = "subBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_1_0, arg_1_1, arg_1_2)
				return arg_1_0:onChangeNum(arg_1_1, arg_1_2, -1)
			end)
		}
	},
	["top.addBtn"] = {
		varname = "addBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_2_0, arg_2_1, arg_2_2)
				return arg_2_0:onChangeNum(arg_2_1, arg_2_2, 1)
			end)
		}
	},
	breakBtn = {
		varname = "breakBtn",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onOneKeyAdvanceClick")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("signetBreak")
			}
		}
	},
	sureBtn = {
		varname = "sureBtn",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onOneKeyAdvanceClick")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("signetSelect")
			}
		}
	},
	cancelBtn = {
		varname = "cancelBtn",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onClose")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("signetSelect")
			}
		}
	},
	["cancelBtn.title"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["sureBtn.title"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	card = {
		binds = {
			event = "extend",
			class = "equip_icon",
			props = {
				selected = false,
				data = bindHelper.self("equipData"),
				onNode = function(arg_3_0)
					arg_3_0:setTouchEnabled(false)
					arg_3_0:get("imgArrow"):hide()
				end
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 12,
				columnSize = 6,
				data = bindHelper.self("itemData"),
				dataOrderCmpGen = bindHelper.self("onSortRank", true),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:size()
					local var_4_1 = {
						class = "icon_key",
						props = {
							data = {
								key = arg_4_3.id,
								num = arg_4_3.num,
								targetNum = arg_4_3.targetNum
							},
							grayState = arg_4_3.num < arg_4_3.targetNum and 1 or 0,
							onNode = function(arg_5_0)
								arg_5_0:setTouchEnabled(false)

								local var_5_0 = arg_5_0:size()
								local var_5_1 = arg_5_0:get("addIcon")

								if arg_4_3.targetNum > arg_4_3.num then
									if not var_5_1 then
										ccui.ImageView:create("common/btn/btn_add_icon.png"):xy(var_5_0.width / 2, var_5_0.height / 2):addTo(arg_5_0, 600, "addIcon")
									else
										var_5_1:show()
									end
								elseif var_5_1 then
									var_5_1:hide()
								end
							end
						}
					}

					bind.extend(arg_4_0, arg_4_1, var_4_1)
					bind.touch(arg_4_0, arg_4_1, {
						methods = {
							ended = functools.partial(arg_4_0.clickCell, arg_4_2, arg_4_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_2.initModel(arg_6_0)
	idlereasy.when(arg_6_0.selectDbId, function(arg_7_0, arg_7_1)
		local var_7_0 = gGameModel.cards:find(arg_7_1)

		arg_6_0.equips = idlereasy.assign(var_7_0:getIdler("equips"), arg_6_0.equips)
		arg_6_0.fight = idlereasy.assign(var_7_0:getIdler("fighting_point"), arg_6_0.fight)
	end)

	arg_6_0.roleLv = gGameModel.role:getIdler("level")
	arg_6_0.gold = gGameModel.role:read("gold")
end

function var_0_2.onCreate(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0.selectDbId = idler.new(arg_8_1)
	arg_8_0.cb = arg_8_3
	arg_8_0.signetBreak = idler.new(false)
	arg_8_0.signetSelect = idler.new(true)

	arg_8_0:enableSchedule()
	arg_8_0:initModel()
	arg_8_0.titleTxt1:text(gLanguageCsv.oneKey)
	arg_8_0.titleTxt2:text(gLanguageCsv.signet)
	arg_8_0.title:text(gLanguageCsv.oneKeySignet)

	local var_8_0 = csv.equips[arg_8_2]

	arg_8_0.equipData = arg_8_0.equips:read()[var_8_0.part]

	local var_8_1 = var_8_0.name0

	if arg_8_0.equipData.awake ~= 0 then
		var_8_1 = var_8_0.name1 .. gLanguageCsv["symbolRome" .. arg_8_0.equipData.awake]
	end

	local var_8_2, var_8_3 = dataEasy.getQuality(arg_8_0.equipData.advance)

	text.addEffect(arg_8_0.cardName, {
		color = var_8_2 == 1 and ui.COLORS.NORMAL.WHITE or ui.COLORS.QUALITY[var_8_2]
	})

	local var_8_4 = var_8_1 .. var_8_3

	arg_8_0.cardName:text(var_8_4)

	local var_8_5 = var_8_0.signetStrengthMax[var_8_0.signetAdvanceMax]

	arg_8_0.currLevelLen = var_8_0.signetAdvanceMax

	local var_8_6 = arg_8_0.equipData.signet_advance or 0
	local var_8_7 = arg_8_0.equipData.equip_id
	local var_8_8 = arg_8_0.equipData.signet or 0

	arg_8_0.level = var_8_8
	arg_8_0.advance = var_8_6
	arg_8_0.upgradeLv = var_8_8 + 1
	arg_8_0.leftQuality = ""

	local var_8_9 = arg_8_0:upLevelMax(var_8_5, var_8_0)
	local var_8_10 = var_8_8
	local var_8_11 = var_8_6
	local var_8_12 = var_8_8 % 5

	for iter_8_0 = 1, math.huge do
		if var_8_10 % 5 ~= 0 then
			var_8_10 = var_8_10 + 1
			var_8_12 = var_8_10 % 5 == 0 and 5 or var_8_10 % 5
		elseif var_8_12 == 0 then
			var_8_10 = var_8_10 + 1
			var_8_12 = 1
		else
			var_8_11 = var_8_11 + 1
			var_8_12 = 0
		end

		if var_8_9 <= var_8_10 then
			if var_8_9 == var_8_5 and var_8_12 == 4 then
				var_8_12 = 5
			end

			break
		end
	end

	arg_8_0.advanceLv = var_8_11
	arg_8_0.shwoLv = var_8_12
	arg_8_0.varLv = var_8_10
	arg_8_0.upMaxLv = var_8_9
	arg_8_0.upMinLv = var_8_8 + 1
	arg_8_0.selectLv = idler.new(var_8_9)
	arg_8_0.itemData = idlertable.new({})

	idlereasy.when(arg_8_0.selectLv, function(arg_9_0, arg_9_1)
		arg_8_0.upgradeLv = arg_8_0.advanceLv * 5 + arg_8_0.shwoLv
		arg_8_0.advanceId = arg_8_0.advanceLv

		local var_9_0 = arg_8_0:updataShowAward(var_8_0)

		if arg_8_0.upgradeLv <= var_8_9 then
			arg_8_0.isEnoughGoldStrengthen = var_9_0 <= dataEasy.getNumByKey("gold")

			local var_9_1 = arg_8_0:updataAttribute(var_8_0.advanceIndex)

			arg_8_0.nameMax:text(var_9_1 .. " " .. arg_8_0.shwoLv .. gLanguageCsv.signetLevel)

			arg_8_0.rightQuality = var_9_1 .. " " .. arg_8_0.shwoLv .. gLanguageCsv.signetLevel

			arg_8_0.cashNum:text(var_9_0)

			local var_9_2 = arg_8_0.isEnoughGoldStrengthen and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.RED

			text.addEffect(arg_8_0.cashNum, {
				color = var_9_2
			})
			adapt.oneLinePos(arg_8_0.cashNum, arg_8_0.cashIcon, cc.p(12, 0))
			cache.setShader(arg_8_0.addBtn, false, arg_8_0.upgradeLv >= arg_8_0.upMaxLv and "hsl_gray" or "normal")
			arg_8_0.addBtn:setTouchEnabled(arg_8_0.upgradeLv < arg_8_0.upMaxLv)

			local var_9_3 = false
			local var_9_4 = false

			if arg_8_0.upgradeLv >= arg_8_0.upMinLv and arg_8_0.advanceLv >= arg_8_0.advance then
				var_9_3 = true
				var_9_4 = true
			end

			if arg_8_0.upgradeLv == arg_8_0.upMinLv and arg_8_0.advanceLv == arg_8_0.advance then
				var_9_4 = false
			end

			cache.setShader(arg_8_0.subBtn, false, not var_9_4 and "hsl_gray" or "normal")
			arg_8_0.subBtn:setTouchEnabled(var_9_3)
		else
			gGameUI:showTip(gLanguageCsv.equipNotEnoughSignetItems)
		end
	end)
	Dialog.onCreate(arg_8_0)
end

function var_0_2.upLevelMax(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = true
	local var_10_1 = true
	local var_10_2 = {}
	local var_10_3 = arg_10_0.level
	local var_10_4 = arg_10_0.advance * 5 ~= arg_10_0.level
	local var_10_5 = {}

	for iter_10_0, iter_10_1 in ipairs(arg_10_2.signetStrengthMax) do
		var_10_5[iter_10_1] = iter_10_1
	end

	for iter_10_2 = arg_10_0.level, arg_10_1 do
		if not var_10_0 or not var_10_1 then
			break
		end

		if iter_10_2 < arg_10_1 then
			for iter_10_3, iter_10_4 in csvMapPairs(csv.base_attribute.equip_signet[iter_10_2]["costItemMap" .. arg_10_2.signetStrengthSeqID]) do
				if iter_10_3 ~= "gold" then
					var_10_2[iter_10_3] = var_10_2[iter_10_3] or {
						targetNum = 0
					}

					local var_10_6 = var_10_2[iter_10_3].targetNum + iter_10_4

					if var_10_6 > dataEasy.getNumByKey(iter_10_3) then
						var_10_0 = false

						break
					end

					var_10_2[iter_10_3].targetNum = var_10_6
				end
			end
		end

		if var_10_4 then
			if var_10_5[iter_10_2] then
				local var_10_7 = math.floor(iter_10_2 / 6)

				for iter_10_5, iter_10_6 in csvMapPairs(csv.base_attribute.equip_signet_advance_cost[var_10_7]["costItemMap" .. arg_10_2.advanceIndex]) do
					if iter_10_5 ~= "gold" then
						var_10_2[iter_10_5] = var_10_2[iter_10_5] or {
							targetNum = 0
						}

						local var_10_8 = var_10_2[iter_10_5].targetNum + iter_10_6

						if var_10_8 > dataEasy.getNumByKey(iter_10_5) then
							var_10_1 = false

							break
						end

						var_10_2[iter_10_5].targetNum = var_10_8
					end
				end
			end
		else
			var_10_4 = true
		end

		var_10_3 = iter_10_2
	end

	return var_10_3
end

function var_0_2.updataShowAward(arg_11_0, arg_11_1)
	local var_11_0 = 0
	local var_11_1 = {}

	arg_11_0.signetAdvanceData = {}

	for iter_11_0 = arg_11_0.level, arg_11_0.upgradeLv - 1 do
		for iter_11_1, iter_11_2 in csvMapPairs(csv.base_attribute.equip_signet[iter_11_0]["costItemMap" .. arg_11_1.signetStrengthSeqID]) do
			if iter_11_1 ~= "gold" then
				var_11_1[iter_11_1] = var_11_1[iter_11_1] or {
					orderKey = 1,
					targetNum = 0,
					id = iter_11_1,
					num = dataEasy.getNumByKey(iter_11_1)
				}

				local var_11_2 = var_11_1[iter_11_1].targetNum + iter_11_2

				if var_11_2 > dataEasy.getNumByKey(iter_11_1) then
					var_11_1[iter_11_1].orderKey = 2

					break
				end

				var_11_1[iter_11_1].targetNum = var_11_2
			else
				var_11_0 = var_11_0 + iter_11_2
			end
		end

		for iter_11_3 = 1, math.huge do
			local var_11_3 = arg_11_1["signetAttrType" .. iter_11_3]

			if not var_11_3 or var_11_3 == 0 then
				break
			end

			local var_11_4 = game.ATTRDEF_TABLE[var_11_3]
			local var_11_5 = "attr" .. string.caption(var_11_4)
			local var_11_6, var_11_7 = dataEasy.getAttrValueAndNextValue(var_11_3, arg_11_1["signetAttrNum" .. iter_11_3][iter_11_0] or 0, arg_11_1["signetAttrNum" .. iter_11_3][iter_11_0 + 1] or 0)

			if not arg_11_0.signetAdvanceData[iter_11_3] then
				arg_11_0.signetAdvanceData[iter_11_3] = {
					num1 = var_11_6,
					num2 = var_11_7
				}
			else
				arg_11_0.signetAdvanceData[iter_11_3].num2 = arg_11_0.signetAdvanceData[iter_11_3].num2 + (var_11_7 - var_11_6)
			end
		end
	end

	for iter_11_4, iter_11_5 in ipairs(arg_11_1.signetStrengthMax) do
		if iter_11_4 - 1 >= arg_11_0.advance and iter_11_4 - 1 < arg_11_0.advanceId then
			for iter_11_6, iter_11_7 in csvMapPairs(csv.base_attribute.equip_signet_advance_cost[iter_11_4 - 1]["costItemMap" .. arg_11_1.advanceIndex]) do
				if iter_11_6 ~= "gold" then
					var_11_1[iter_11_6] = var_11_1[iter_11_6] or {
						orderKey = 1,
						targetNum = 0,
						id = iter_11_6,
						num = dataEasy.getNumByKey(iter_11_6)
					}

					local var_11_8 = var_11_1[iter_11_6].targetNum + iter_11_7

					if var_11_8 > dataEasy.getNumByKey(iter_11_6) then
						var_11_1[iter_11_6].orderKey = 2
						signetAdvance = false

						break
					end

					var_11_1[iter_11_6].targetNum = var_11_8
				else
					var_11_0 = var_11_0 + iter_11_7
				end
			end
		end
	end

	arg_11_0.itemData:set(var_11_1)

	return var_11_0
end

function var_0_2.updataAttribute(arg_12_0, arg_12_1)
	local var_12_0 = ""

	for iter_12_0, iter_12_1 in csvPairs(csv.base_attribute.equip_signet_advance) do
		if iter_12_1.advanceIndex == arg_12_1 and iter_12_1.advanceLevel == arg_12_0.advanceLv then
			var_12_0 = iter_12_1.advanceName

			local var_12_1 = {}

			for iter_12_2 = 1, math.huge do
				local var_12_2 = iter_12_1["attrType" .. iter_12_2]

				if not var_12_2 or var_12_2 == 0 then
					break
				end

				local var_12_3 = game.ATTRDEF_TABLE[var_12_2]
				local var_12_4 = "attr" .. string.caption(var_12_3)

				table.insert(var_12_1, {
					name = gLanguageCsv[var_12_4],
					num = dataEasy.getAttrValueString(var_12_2, iter_12_1["attrNum" .. iter_12_2])
				})
			end

			local var_12_5 = ""

			for iter_12_3 = 1, #var_12_1 do
				var_12_5 = var_12_5 .. var_12_1[iter_12_3].name .. "+" .. var_12_1[iter_12_3].num .. "  "
			end

			local var_12_6 = ""

			if iter_12_1.sceneType then
				for iter_12_4, iter_12_5 in csvMapPairs(iter_12_1.sceneType) do
					local var_12_7 = iter_12_5
					local var_12_8 = game.SCENE_TYPE_STRING_TABLE[var_12_7]

					var_12_6 = var_12_6 .. gLanguageCsv[var_12_8]

					if iter_12_4 < table.getn(iter_12_1.sceneType) then
						var_12_6 = var_12_6 .. gLanguageCsv.signetAnd
					end
				end
			end

			arg_12_0.strAttr = string.format(gLanguageCsv.signetBeiDong, iter_12_1.advanceLevel, var_12_6) .. var_12_5
		end

		local var_12_9 = arg_12_0.level - arg_12_0.advance * 5

		if iter_12_1.advanceIndex == arg_12_1 and iter_12_1.advanceLevel == arg_12_0.advance then
			arg_12_0.leftQuality = iter_12_1.advanceName .. " " .. var_12_9 .. gLanguageCsv.signetLevel
		end

		if iter_12_1.advanceLimitType then
			if iter_12_1.advanceLimitType == var_0_0.STAR then
				if arg_12_0.equipData.star < iter_12_1.advanceLimitNum then
					arg_12_0.limitTip = string.format(gLanguageCsv.needEquipStar, iter_12_1.advanceLimitNum)
				end
			elseif iter_12_1.advanceLimitType == var_0_0.AWAKE and arg_12_0.equipData.awake < iter_12_1.advanceLimitNum then
				arg_12_0.limitTip = gLanguageCsv.needEquipAwake .. gLanguageCsv["symbolRome" .. iter_12_1.advanceLimitNum]
			end
		else
			arg_12_0.limitTip = 0
		end
	end

	return var_12_0
end

function var_0_2.onChangeNum(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = false

	if arg_13_2.name == "click" then
		arg_13_0:unScheduleAll()

		var_13_0 = true

		arg_13_0:onIncreaseNum(arg_13_3)
	elseif arg_13_2.name == "began" then
		var_13_0 = true

		arg_13_0:schedule(function()
			arg_13_0:onIncreaseNum(arg_13_3)
		end, 0.05, 0, 1)
	elseif arg_13_2.name == "ended" or arg_13_2.name == "cancelled" then
		arg_13_0:unScheduleAll()

		if not var_13_0 then
			arg_13_0:onIncreaseNum(arg_13_3)
		end
	end
end

function var_0_2.onIncreaseNum(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.selectLv:read()

	if arg_15_1 > 0 then
		local var_15_1 = arg_15_0.advanceLv * 5 + arg_15_0.shwoLv

		if arg_15_0.upMaxLv == var_15_1 or arg_15_0.shwoLv == 5 and arg_15_0.advanceLv == arg_15_0.currLevelLen - 1 then
			arg_15_0:unScheduleAll()
		elseif arg_15_0.shwoLv == 4 then
			arg_15_0.shwoLv = arg_15_0.shwoLv + 1
		elseif arg_15_0.shwoLv == 5 then
			arg_15_0.advanceLv = arg_15_0.advanceLv + 1
			arg_15_0.shwoLv = 0
		else
			arg_15_0.shwoLv = arg_15_0.shwoLv + 1
		end
	elseif arg_15_0.advanceLv * 5 + arg_15_0.shwoLv <= arg_15_0.level + 1 and arg_15_0.advanceLv <= arg_15_0.advance then
		arg_15_0:unScheduleAll()
	elseif arg_15_0.shwoLv == 1 then
		arg_15_0.shwoLv = 0
	elseif arg_15_0.shwoLv == 0 then
		arg_15_0.advanceLv = arg_15_0.advanceLv - 1
		arg_15_0.shwoLv = 5
	else
		arg_15_0.shwoLv = arg_15_0.shwoLv - 1
	end

	arg_15_0.selectLv:set(var_15_0 + 1)
end

function var_0_2.onOneKeyAdvanceClick(arg_16_0)
	if not arg_16_0.isEnoughGoldStrengthen then
		gGameUI:showTip(gLanguageCsv.strengthGoldNotEnough)

		return
	end

	local var_16_0 = arg_16_0.fight:read()
	local var_16_1 = arg_16_0.equipData
	local var_16_2 = csv.equips[var_16_1.equip_id]

	if not var_16_1.signet then
		local var_16_3 = 0
	end

	local var_16_4 = var_16_1.signet_advance or 0
	local var_16_5 = true

	local function var_16_6()
		arg_16_0:addCallbackOnExit(functools.partial(arg_16_0.cb, 1))
		Dialog.onClose(arg_16_0)
	end

	local var_16_7 = {
		false
	}
	local var_16_8 = matchLanguage({
		"kr"
	}) and arg_16_0.strAttr or string.sub(arg_16_0.strAttr, 10)

	gGameApp:requestServerCustom("/game/equip/signet"):params(arg_16_0.selectDbId, var_16_2.part, arg_16_0.upgradeLv, true, arg_16_0.advanceId):onResponse(function(arg_18_0)
		if var_16_4 < arg_16_0.advanceId then
			var_16_5 = false

			idlereasy.do_(function(arg_19_0)
				gGameUI:stackUI("city.card.equip.success", nil, {
					blackLayer = true
				}, {
					type = "signetAdvance",
					leftItem = var_16_1,
					rightItem = arg_19_0[var_16_2.part],
					fight = var_16_0,
					cardDbid = arg_16_0.selectDbId:read(),
					leftQuality = arg_16_0.leftQuality,
					rightQuality = arg_16_0.rightQuality,
					textBD = var_16_8,
					limitTip = arg_16_0.limitTip or 0,
					isMax = arg_16_0.advanceId >= var_16_2.signetAdvanceMax,
					signetAdvanceData = arg_16_0.signetAdvanceData,
					cb = var_16_6
				})

				var_16_7[1] = true
			end, arg_16_0.equips)
		else
			var_16_7[1] = true
		end
	end):wait(var_16_7):doit(function()
		if var_16_5 and var_16_4 >= arg_16_0.advanceId then
			gGameUI:showTip(gLanguageCsv.signetOk)
			var_16_6()
		end
	end)
end

function var_0_2.onItemClick(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	gGameUI:stackUI("common.gain_way", nil, nil, arg_21_3.id, arg_21_0:createHandler("refreshUI"), arg_21_3.num)
end

function var_0_2.refreshUI(arg_22_0)
	arg_22_0.selectLv:notify()
end

function var_0_2.onSortRank(arg_23_0, arg_23_1)
	return function(arg_24_0, arg_24_1)
		return arg_24_0.orderKey > arg_24_1.orderKey
	end
end

return var_0_2
