local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("TotemCollect", var_0_0)
local var_0_2 = require("app.views.city.develop.totem.tools")

var_0_1.RESOURCE_FILENAME = "totem_collect.json"
var_0_1.RESOURCE_BINDING = {
	totemGet = "totemGet",
	award = "award",
	["tipMask.img"] = "tipMaskImg",
	totemAll = "totemAll",
	imgLock = "imgLock",
	bgSpine = "bgSpine",
	bgSpine2 = "bgSpine2",
	groupSpine = "groupSpine",
	["award.barBg"] = "barBg",
	mask = "mask",
	["award.bar"] = "bar",
	totemBg = "totemBg",
	["tipMask.txt"] = "tipMaskTxt",
	items = "items",
	tipMask = "tipMask",
	leftBtn = {
		varname = "leftBtn",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onLeftBtnClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "totemAwardGet",
					listenData = {
						right = false,
						idx = bindHelper.self("index")
					},
					onNode = function(arg_1_0)
						arg_1_0.xy(arg_1_0, 30, 50)
						arg_1_0.scale(arg_1_0, 1.5)
					end
				}
			}
		}
	},
	rightBtn = {
		varname = "rightBtn",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onRightBtnClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "totemAwardGet",
					listenData = {
						right = true,
						idx = bindHelper.self("index")
					},
					onNode = function(arg_2_0)
						arg_2_0.xy(arg_2_0, 30, 160)
						arg_2_0.scale(arg_2_0, 1.5)
					end
				}
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showData"),
				item = bindHelper.self("items"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1.multiget(arg_3_1, "attr1", "attr2", "img")

					if itertools.isempty(arg_3_3) then
						arg_3_1.size(arg_3_1, 800, 15)
						itertools.invoke({
							var_3_0.attr1,
							var_3_0.attr2,
							var_3_0.img
						}, "hide")
					elseif arg_3_3.totemType == 2 then
						for iter_3_0, iter_3_1 in pairs(arg_3_3.type) do
							var_3_0.img:clone():addTo(arg_3_1, 10):show():xy(37 + (iter_3_0 - 1) * 70, 29):texture(ui.ATTR_ICON[iter_3_1])
							var_3_0.attr1:get("txt"):text(gLanguageCsv.totemNatureAdditionText):xy(iter_3_0 * 70, 29)
							text.addEffect(var_3_0.attr1:get("txt"), {
								outline = {
									size = 4,
									color = ui.COLORS.OUTLINE.DEFAULT
								}
							})
						end

						var_3_0.attr2:hide()
						var_3_0.attr1:get("icon"):hide()
					else
						for iter_3_2 = 1, 2 do
							local var_3_1 = arg_3_3[iter_3_2]

							if var_3_1 then
								local var_3_2 = gLanguageCsv["attr" .. string.caption(game.ATTRDEF_TABLE[var_3_1.type])]
								local var_3_3 = ui.ATTR_LOGO[game.ATTRDEF_TABLE[var_3_1.type]]

								if var_3_3 then
									var_3_0["attr" .. iter_3_2]:get("icon"):texture(var_3_3)
								else
									var_3_0["attr" .. iter_3_2]:get("icon"):hide()
									var_3_0["attr" .. iter_3_2]:get("txt"):xy(15, 29)
								end

								var_3_0["attr" .. iter_3_2]:get("txt"):text(string.format("%s: %s", var_3_2, dataEasy.getAttrValueString(var_3_1.type, var_3_1.num)))
								text.addEffect(var_3_0["attr" .. iter_3_2]:get("txt"), {
									outline = {
										size = 4,
										color = ui.COLORS.OUTLINE.DEFAULT
									}
								})
							else
								var_3_0["attr" .. iter_3_2]:hide()
							end

							adapt.setTextScaleWithWidth(var_3_0["attr" .. iter_3_2]:get("txt"), nil, 390)
						end
					end
				end
			}
		}
	},
	awardList = {
		varname = "awardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				backupCached = false,
				data = bindHelper.self("awardData"),
				item = bindHelper.self("award"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = 1860
					local var_4_1 = 1860

					if itertools.size(arg_4_3.data) < 6 then
						var_4_0 = 1860
						var_4_1 = 1860 / itertools.size(arg_4_3.data)
					else
						var_4_1 = 310
						var_4_0 = 310 * itertools.size(arg_4_3.data)
					end

					arg_4_1:size(var_4_0 + 80, 250)

					local var_4_2 = arg_4_1:multiget("bar", "itemBox", "barBg")

					var_4_2.bar:setCapInsets(cc.rect(10, 2, 1, 1))
					var_4_2.barBg:size(var_4_0, 20)
					var_4_2.bar:size(var_4_0, 20)
					var_4_2.barBg:xy(var_4_0 / 2, 48)
					var_4_2.bar:xy(var_4_0 / 2, 48)

					local var_4_3 = {}
					local var_4_4 = {}
					local var_4_5 = itertools.size(arg_4_3.data)

					for iter_4_0, iter_4_1 in pairs(arg_4_3.data) do
						table.insert(var_4_3, iter_4_1.cfg.val.activeNum)
						table.insert(var_4_4, 100 / var_4_5 * iter_4_0)

						local var_4_6 = var_4_2.itemBox:clone():addTo(arg_4_1, 5, "itemBox" .. iter_4_0):xy(var_4_1 * iter_4_0, 125):show()
						local var_4_7 = iter_4_1.scoreEnough == true
						local var_4_8 = iter_4_1.boxGet == true
						local var_4_9 = var_4_6:get("icon")

						var_4_6:get("bg"):texture(var_4_7 and "city/task/bg_huoyuedu1.png" or "city/develop/totem/sign_tt.png")
						var_4_9:texture("common/icon/icon_box" .. math.min(iter_4_0, 5) .. (var_4_8 and "_open.png" or ".png"))

						local var_4_10 = var_4_7 and not var_4_8

						if var_4_10 then
							local var_4_11 = widget.addAnimation(var_4_6, "effect/jiedianjiangli.skel", "effect_loop", var_4_9:z() - 1)
							local var_4_12 = var_4_9:size()
							local var_4_13 = var_4_6:size()
							local var_4_14 = math.max(var_4_12.width / var_4_13.width, var_4_12.height / var_4_13.height)
							local var_4_15 = math.min(var_4_14, 0.5)

							var_4_11:scale(var_4_15):x(var_4_9:x()):y(var_4_9:y() - 30)

							var_4_6.effectBox = var_4_11
						elseif var_4_6.effectBox then
							var_4_6.effectBox:hide()
							var_4_6.effectBox:removeFromParent()

							var_4_6.effectBox = nil
						end

						uiEasy.addVibrateToNode(arg_4_0, var_4_9, var_4_10, var_4_6:getName() .. math.min(iter_4_0, 5) .. "vibrate")
						var_4_6:get("num"):text(iter_4_1.cfg.val.activeNum)
						var_4_9:setTouchEnabled(true)
						bind.touch(arg_4_0, var_4_9, {
							methods = {
								ended = functools.partial(arg_4_0.clickBoxGet, iter_4_0, iter_4_1, var_4_9)
							}
						})
						bind.extend(arg_4_0, var_4_6, {
							class = "red_hint",
							props = {
								specialTag = "totemAwardGet",
								listenData = {
									csvId = iter_4_1.cfg.csvId
								},
								onNode = function(arg_5_0)
									arg_5_0:xy(180, 180)
								end
							}
						})
					end

					var_4_2.bar:setPercent(mathEasy.showProgress(var_4_4, var_4_3, arg_4_3.activeNum))
				end
			},
			handlers = {
				clickBoxGet = bindHelper.self("onBoxGetClick")
			}
		}
	},
	noAttr = {
		varname = "noAttr",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	totemName = {
		varname = "totemName",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(255, 84, 0, 255)
				},
				color = ui.COLORS.NORMAL.WHITE
			}
		}
	},
	allTxt = {
		varname = "allTxt",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	totemRate = {
		varname = "totemRate",
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
	["tipMask.mask"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_6_0)
					return arg_6_0.onTipsClick(arg_6_0, false)
				end)
			}
		}
	},
	tips = {
		varname = "exTips",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_7_0)
					return arg_7_0.onTipsClick(arg_7_0, true)
				end)
			}
		}
	},
	imgEnergy = {
		varname = "imgEnergy",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onEnergy")
			}
		}
	},
	["imgEnergy.textNote"] = {
		varname = "energyTextNote",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["imgEnergy.textNum"] = {
		varname = "energyNum",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	energyPanel = {
		varname = "energyPanel",
		binds = {
			event = "click",
			method = bindHelper.self("hideEnergyPanel")
		}
	}
}

function var_0_1.onCreate(arg_8_0)
	gGameUI.topuiManager:createView("title", arg_8_0, {
		onClose = arg_8_0:createHandler("onClose")
	}):init({
		subTitle = "TOTEM COLLECTION",
		title = "common/txt/txt_bt_zuhui.png"
	})
	arg_8_0:initModel()

	local var_8_0 = cc.Sprite:create("city/develop/totem/bg_img_20.png")

	var_8_0:setScale(2):xy(1560, 720)
	arg_8_0.bgSpine:addChild(var_8_0)
	idlereasy.any({
		arg_8_0.index,
		arg_8_0.activeAward,
		arg_8_0.activeTotem
	}, function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		arg_8_0.groupSpine:removeAllChildren()

		local var_9_0 = cc.Sprite:create(string.format("city/develop/totem/fang%d.png", arg_9_1))

		var_9_0:setScale(1.5)
		var_9_0:xy(275, 150)
		arg_8_0.groupSpine:addChild(var_9_0)

		if arg_9_1 <= 1 then
			arg_8_0.leftBtn:hide()
		else
			arg_8_0.leftBtn:show()
		end

		if arg_9_1 >= arg_8_0.maxTotem then
			arg_8_0.rightBtn:hide()
		else
			arg_8_0.rightBtn:show()
		end

		if itertools.size(arg_8_0:getActivateTotem(arg_9_3)) <= 0 then
			arg_8_0.noAttr:show()
			arg_8_0.list:hide()
		else
			arg_8_0.noAttr:hide()
			arg_8_0.list:show()
			arg_8_0:refreshData()
		end

		local var_9_1, var_9_2 = arg_8_0:refreshBar()

		arg_8_0.totemName:text(arg_8_0.totemCfg[arg_9_1].val.name)

		if arg_8_0.totemCfg[arg_9_1].unlock then
			arg_8_0.imgLock:hide()
		else
			arg_8_0.imgLock:show()
		end

		arg_8_0.totemBg:texture(arg_8_0.totemCfg[arg_9_1].val.icon)
		arg_8_0.totemGet:text(var_9_1)
		arg_8_0.totemAll:text("/" .. var_9_2)
		arg_8_0.totemRate:text(itertools.size(arg_8_0:getActivateTotem(arg_9_3)) .. "/" .. arg_8_0.groupNum[arg_8_0.totemCfg[arg_9_1].csvId])
		adapt.oneLinePos(arg_8_0.totemAll, arg_8_0.totemGet, cc.p(5, 0), "right")
		arg_8_0.energyNum:text(arg_8_0:getActivateTotemEnergy(arg_9_3))
		adapt.oneLinePos(arg_8_0.energyNum, arg_8_0.imgEnergy:get("info"), cc.p(10, 0))

		local var_9_3 = arg_8_0.imgEnergy:multiget("img", "textNote", "textNum", "info")
		local var_9_4 = var_9_3.img:width() + var_9_3.textNote:width() + var_9_3.textNum:width() + var_9_3.info:width() + 20 + 10

		arg_8_0.imgEnergy:width(var_9_4)
	end)
	adapt.setTextScaleWithWidth(arg_8_0.energyTextNote, nil, 200)
	arg_8_0.tipMaskTxt:text(gLanguageCsv.totemExAttrTips)

	local var_8_1 = arg_8_0.tipMaskTxt:size()

	arg_8_0.tipMaskImg:size(var_8_1.width + 50, 82)
	uiEasy.addTouchOneByOne(arg_8_0.mask, {
		ended = function(arg_10_0, arg_10_1, arg_10_2)
			if arg_10_1 > 100 and math.abs(arg_10_2) < math.abs(arg_10_1) then
				arg_8_0:onLeftBtnClick()
			elseif arg_10_1 < -100 and math.abs(arg_10_2) < math.abs(arg_10_1) then
				arg_8_0:onRightBtnClick()
			end
		end
	})
end

function var_0_1.initModel(arg_11_0)
	arg_11_0.itemss = gGameModel.role:getIdler("items")
	arg_11_0.activeTotem = gGameModel.totem:getIdler("totem_insetted")
	arg_11_0.activeAward = gGameModel.totem:getIdler("award")
	arg_11_0.index = idler.new(1)

	local var_11_0 = 0

	arg_11_0.totemCfg = {}
	arg_11_0.groupNum = {}
	arg_11_0.groupEnergy = {}
	arg_11_0.showData = idlers.new({})
	arg_11_0.awardData = idlers.new({})

	local var_11_1 = gGameModel.totem:read("totem_insetted")
	local var_11_2 = var_0_2.getActivateTotemEnergy(var_11_1)

	for iter_11_0, iter_11_1 in orderCsvPairs(csv.totem.symbol_group) do
		if var_11_2 >= iter_11_1.showEnergy then
			var_11_0 = var_11_0 + 1

			local var_11_3 = var_11_2 >= iter_11_1.unlockEnergy

			table.insert(arg_11_0.totemCfg, {
				csvId = iter_11_0,
				val = iter_11_1,
				unlock = var_11_3
			})
		end
	end

	for iter_11_2, iter_11_3 in orderCsvPairs(csv.totem.symbol) do
		if not arg_11_0.groupNum[iter_11_3.symbolGroupType] then
			arg_11_0.groupNum[iter_11_3.symbolGroupType] = 1
		else
			arg_11_0.groupNum[iter_11_3.symbolGroupType] = arg_11_0.groupNum[iter_11_3.symbolGroupType] + 1
		end

		if not arg_11_0.groupEnergy[iter_11_3.symbolGroupType] then
			arg_11_0.groupEnergy[iter_11_3.symbolGroupType] = 0
		else
			arg_11_0.groupEnergy[iter_11_3.symbolGroupType] = arg_11_0.groupEnergy[iter_11_3.symbolGroupType] + iter_11_3.power
		end
	end

	arg_11_0.toTemCollect = {}

	local var_11_4 = -1
	local var_11_5 = {}

	for iter_11_4, iter_11_5 in orderCsvPairs(csv.totem.collection) do
		if iter_11_5.groupType ~= var_11_4 then
			if not itertools.isempty(var_11_5) then
				arg_11_0.toTemCollect[var_11_4] = var_11_5
				var_11_5 = {}
			end

			var_11_4 = iter_11_5.groupType
		end

		table.insert(var_11_5, {
			csvId = iter_11_4,
			val = iter_11_5
		})
	end

	if not itertools.isempty(var_11_5) then
		arg_11_0.toTemCollect[var_11_4] = var_11_5

		local var_11_6 = {}
	end

	arg_11_0.pressBar = idler.new(0)
	arg_11_0.maxTotem = var_11_0

	arg_11_0.imgEnergy:visible(dataEasy.isUnlock(gUnlockCsv.totemEnergy))
end

function var_0_1.onLeftBtnClick(arg_12_0)
	arg_12_0.index:set(math.max(1, arg_12_0.index:read() - 1))
end

function var_0_1.onRightBtnClick(arg_13_0)
	arg_13_0.index:set(math.min(arg_13_0.maxTotem, arg_13_0.index:read() + 1))
end

function var_0_1.refreshData(arg_14_0)
	local var_14_0 = arg_14_0.index:read()
	local var_14_1 = arg_14_0.totemCfg[var_14_0]
	local var_14_2 = arg_14_0:getActivateTotem(arg_14_0.activeTotem:read() or {})
	local var_14_3 = {}
	local var_14_4 = {}

	for iter_14_0, iter_14_1 in pairs(var_14_2) do
		local var_14_5 = csv.totem.symbol[iter_14_1]

		for iter_14_2 = 1, math.huge do
			local var_14_6 = false
			local var_14_7 = false
			local var_14_8 = var_14_5["attrType" .. iter_14_2]
			local var_14_9 = var_14_5["attrNum" .. iter_14_2]

			if var_14_8 and var_14_8 > 0 then
				var_14_3[var_14_8] = var_14_3[var_14_8] and var_14_3[var_14_8] or {}

				if string.find(var_14_9, "%%") then
					var_14_3[var_14_8][2] = dataEasy.attrAddition(var_14_3[var_14_8][2], var_14_9)
				else
					var_14_3[var_14_8][1] = dataEasy.attrAddition(var_14_3[var_14_8][1], var_14_9)
				end
			else
				var_14_6 = true
			end

			local var_14_10 = var_14_5["extraAttrsType" .. iter_14_2]
			local var_14_11 = var_14_5["extraAttrNum" .. iter_14_2]

			if var_14_10 and var_14_10 > 0 then
				for iter_14_3, iter_14_4 in pairs(var_14_5.nature) do
					if not var_14_4[iter_14_4] then
						var_14_4[iter_14_4] = {}
					end

					var_14_4[iter_14_4][var_14_10] = var_14_4[iter_14_4][var_14_10] and var_14_4[iter_14_4][var_14_10] or {}

					if string.find(var_14_11, "%%") then
						var_14_4[iter_14_4][var_14_10][2] = dataEasy.attrAddition(var_14_4[iter_14_4][var_14_10][2], var_14_11)
					else
						var_14_4[iter_14_4][var_14_10][1] = dataEasy.attrAddition(var_14_4[iter_14_4][var_14_10][1], var_14_11)
					end
				end
			else
				var_14_7 = true
			end

			if var_14_6 and var_14_7 then
				break
			end
		end
	end

	local var_14_12 = {}

	for iter_14_5, iter_14_6 in pairs(var_14_3) do
		for iter_14_7 = 1, 2 do
			if iter_14_6[iter_14_7] then
				table.insert(var_14_12, {
					attrType = iter_14_5,
					attrNum = iter_14_6[iter_14_7],
					style = iter_14_7
				})
			end
		end
	end

	table.sort(var_14_12, function(arg_15_0, arg_15_1)
		if arg_15_0.attrType == arg_15_1.attrType then
			return arg_15_0.style < arg_15_1.style
		end

		return arg_15_0.attrType < arg_15_1.attrType
	end)

	local var_14_13 = 0
	local var_14_14 = {}

	for iter_14_8, iter_14_9 in ipairs(var_14_12) do
		var_14_13 = var_14_13 + 1

		if var_14_13 % 2 == 1 then
			table.insert(var_14_14, {})
		end

		table.insert(var_14_14[#var_14_14], {
			type = iter_14_9.attrType,
			num = iter_14_9.attrNum
		})
	end

	local var_14_15 = arg_14_0.setExtAttr(arg_14_0, var_14_4)

	for iter_14_10, iter_14_11 in pairs(var_14_15) do
		table.insert(var_14_14, {})
		table.insert(var_14_14, {
			totemType = 2,
			type = iter_14_11.types
		})

		local var_14_16 = 0

		for iter_14_12, iter_14_13 in ipairs(iter_14_11.nums) do
			var_14_16 = var_14_16 + 1

			if var_14_16 % 2 == 1 then
				table.insert(var_14_14, {})
			end

			table.insert(var_14_14[#var_14_14], {
				type = iter_14_13.attrType,
				num = iter_14_13.attrNum
			})
		end
	end

	arg_14_0.showData:update(var_14_14)
end

function var_0_1.setExtAttr(arg_16_0, arg_16_1)
	local var_16_0 = {}
	local var_16_1 = {}
	local var_16_2 = itertools.size(arg_16_1)

	local function var_16_3(arg_17_0, arg_17_1)
		if itertools.size(arg_17_0) ~= itertools.size(arg_17_1) then
			return false
		end

		for iter_17_0, iter_17_1 in pairs(arg_17_0) do
			if not arg_17_1[iter_17_0] then
				return false
			end

			for iter_17_2 = 1, 2 do
				if not arg_17_1[iter_17_0][iter_17_2] and iter_17_1[iter_17_2] or arg_17_1[iter_17_0][iter_17_2] ~= iter_17_1[iter_17_2] then
					return false
				end
			end
		end

		return true
	end

	local function var_16_4(arg_18_0)
		local var_18_0 = {}

		for iter_18_0, iter_18_1 in pairs(arg_18_0) do
			for iter_18_2 = 1, 2 do
				if iter_18_1[iter_18_2] then
					table.insert(var_18_0, {
						attrType = iter_18_0,
						attrNum = iter_18_1[iter_18_2],
						style = iter_18_2
					})
				end
			end
		end

		table.sort(var_18_0, function(arg_19_0, arg_19_1)
			if arg_19_0.attrType == arg_19_1.attrType then
				return arg_19_0.style < arg_19_1.style
			end

			return arg_19_0.attrType < arg_19_1.attrType
		end)

		return var_18_0
	end

	for iter_16_0, iter_16_1 in pairs(arg_16_1) do
		local var_16_5 = {
			iter_16_0
		}

		if not itertools.include(var_16_1, iter_16_0) then
			for iter_16_2, iter_16_3 in pairs(arg_16_1) do
				if not itertools.include(var_16_1, iter_16_2) and iter_16_0 ~= iter_16_2 and var_16_3(arg_16_1[iter_16_0], arg_16_1[iter_16_2]) then
					table.insert(var_16_5, iter_16_2)
					table.insert(var_16_1, iter_16_2)
				end
			end

			table.insert(var_16_0, {
				types = var_16_5,
				nums = var_16_4(iter_16_1)
			})
		end
	end

	table.sort(var_16_0, function(arg_20_0, arg_20_1)
		if itertools.size(arg_20_0.types) == itertools.size(arg_20_1.types) then
			return itertools.size(arg_20_0.nums) < itertools.size(arg_20_1.nums)
		end

		return itertools.size(arg_20_0.types) < itertools.size(arg_20_1.types)
	end)

	return var_16_0
end

function var_0_1.refreshBar(arg_21_0)
	local var_21_0 = arg_21_0.index:read()
	local var_21_1 = arg_21_0.totemCfg[var_21_0]
	local var_21_2 = arg_21_0:getActivateTotem(arg_21_0.activeTotem:read() or {})
	local var_21_3 = itertools.size(var_21_2)
	local var_21_4 = arg_21_0.toTemCollect[var_21_1.csvId]
	local var_21_5 = 0
	local var_21_6 = itertools.size(var_21_4)
	local var_21_7 = {}
	local var_21_8 = 0
	local var_21_9 = arg_21_0.activeAward:read() or {}

	for iter_21_0, iter_21_1 in pairs(var_21_4) do
		local var_21_10 = false

		if var_21_9[iter_21_1.csvId] then
			var_21_5 = var_21_5 + 1
			var_21_10 = var_21_9[iter_21_1.csvId] == 0 and true or false
		end

		var_21_8 = math.max(var_21_8, iter_21_1.val.activeNum)

		local var_21_11 = {
			cfg = iter_21_1,
			scoreEnough = var_21_3 >= iter_21_1.val.activeNum and true or false,
			boxGet = var_21_10
		}

		table.insert(var_21_7, var_21_11)
	end

	arg_21_0.awardData:update({
		{
			activeNum = var_21_3,
			allNum = var_21_8,
			activeTask = var_21_5,
			taskNum = var_21_6,
			data = var_21_7
		}
	})

	return var_21_5, var_21_6
end

function var_0_1.onBoxGetClick(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	if not arg_22_3.boxGet and arg_22_3.scoreEnough then
		local var_22_0 = {
			false
		}

		gGameApp:requestServerCustom("/game/symbol/collection/award/get"):params(arg_22_3.cfg.csvId):onResponse(function(arg_23_0)
			arg_22_4:texture("common/icon/icon_box" .. math.min(arg_22_2, 5) .. "_open.png")
			uiEasy.setBoxEffect(arg_22_4, 0.5, function()
				var_22_0[1] = true
			end, -15, 10)
		end):wait(var_22_0):doit(function(arg_25_0)
			gGameUI:showGainDisplay(arg_25_0)

			arg_22_3.boxGet = true
		end)

		return
	end

	gGameUI:showBoxDetail({
		data = arg_22_3.cfg.val.award,
		content = string.format(arg_22_3.cfg.val.text, arg_22_3.cfg.val.activeNum),
		state = arg_22_3.boxGet == true and 0 or 1
	})
end

function var_0_1.showGainDisplayThenLevel(arg_26_0, arg_26_1, arg_26_2)
	if arg_26_2 then
		for iter_26_0, iter_26_1 in pairs(arg_26_2) do
			arg_26_0.params[iter_26_0] = iter_26_1
		end
	end

	gGameUI:showGainDisplay(arg_26_1, arg_26_0.params)

	arg_26_0.params = {}
end

function var_0_1.getActivateTotem(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0.index:read()
	local var_27_1 = arg_27_0.totemCfg[var_27_0]
	local var_27_2 = csv.totem.symbol
	local var_27_3 = {}

	for iter_27_0, iter_27_1 in pairs(arg_27_1) do
		if var_27_2[iter_27_0] and var_27_1.csvId == var_27_2[iter_27_0].symbolGroupType and itertools.size(var_27_2[iter_27_0].totemGroup1) <= itertools.size(iter_27_1) then
			table.insert(var_27_3, iter_27_0)
		end
	end

	return var_27_3
end

function var_0_1.getActivateTotemEnergy(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0.getActivateTotem(arg_28_0, arg_28_1)
	local var_28_1 = 0

	for iter_28_0, iter_28_1 in pairs(var_28_0) do
		var_28_1 = var_28_1 + csv.totem.symbol[iter_28_1].power
	end

	return var_28_1
end

function var_0_1.getTotalEnergy(arg_29_0, arg_29_1)
	local var_29_0 = 0

	for iter_29_0, iter_29_1 in csvPairs(csv.totem.symbol) do
		if iter_29_1.symbolGroupType == arg_29_1 then
			var_29_0 = var_29_0 + iter_29_1.power
		end
	end

	return var_29_0
end

function var_0_1.onTipsClick(arg_30_0, arg_30_1)
	arg_30_0.tipMask:visible(arg_30_1)
end

function var_0_1.onEnergy(arg_31_0)
	local var_31_0 = arg_31_0.index:read()
	local var_31_1 = arg_31_0.activeTotem:read()

	arg_31_0.energyPanel:show()

	local var_31_2 = arg_31_0:getActivateTotemEnergy(var_31_1)

	arg_31_0.energyPanel:get("name"):text(arg_31_0.totemCfg[var_31_0].val.name)
	arg_31_0.energyPanel:get("canNum"):text(var_31_2)

	local var_31_3 = {}

	for iter_31_0, iter_31_1 in orderCsvPairs(csv.totem.energy) do
		if iter_31_1.symbolGroupType == var_31_0 then
			var_31_3[iter_31_0] = iter_31_1
		end
	end

	local var_31_4 = {}

	for iter_31_2, iter_31_3 in pairs(var_31_3) do
		local var_31_5 = "#C0xB7B09E#"

		if var_31_2 >= iter_31_3.powerNum then
			var_31_5 = "#C0x60565E#"
		end

		local var_31_6 = "#Pfont/youmi1.ttf#" .. string.format(gLanguageCsv.totemEnergyCollect, iter_31_3.powerNum) .. "#Pfont/youmi.ttf#\n" .. iter_31_3.attrDesc .. "\n"

		for iter_31_4 = 1, math.huge do
			if iter_31_3["attrAddDesc" .. iter_31_4] then
				local var_31_7 = dataEasy.getAttrValueString(iter_31_3["attrType" .. iter_31_4], iter_31_3["attrNum" .. iter_31_4])

				if var_31_7 ~= "" then
					var_31_6 = var_31_6 .. string.format("%s+%s", iter_31_3["attrAddDesc" .. iter_31_4], var_31_7) .. "\n"
				end
			else
				break
			end
		end

		table.insert(var_31_4, {
			verticalSpace = 10,
			str = var_31_5 .. var_31_6 .. "\n",
			powerNum = iter_31_3.powerNum
		})
	end

	table.sort(var_31_4, function(arg_32_0, arg_32_1)
		return arg_32_0.powerNum < arg_32_1.powerNum
	end)
	beauty.textScroll({
		fontSize = 40,
		margin = 20,
		isRich = true,
		align = "left",
		list = arg_31_0.energyPanel:get("list"),
		strs = var_31_4
	})
end

function var_0_1.hideEnergyPanel(arg_33_0)
	arg_33_0.energyPanel:hide()
end

return var_0_1
