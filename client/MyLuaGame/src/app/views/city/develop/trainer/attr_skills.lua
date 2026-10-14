local var_0_0 = class("TrainAttrSkills", Dialog)
local var_0_1 = 453

var_0_0.RESOURCE_FILENAME = "trainer_attr_skills.json"
var_0_0.RESOURCE_BINDING = {
	panel = "panel",
	icon = "coinIcon",
	item = "item",
	item2 = "item2",
	num = "coinNum",
	slider = "slider",
	txt5 = "txt5",
	titleTxt1 = {
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
	["panel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				padding = 0,
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("item"),
				sliderBg = bindHelper.self("slider"),
				item2 = bindHelper.self("item2"),
				panel = bindHelper.self("panel"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("panel"):multiget("dark", "light", "lock", "attrName", "percent", "lv", "num", "icon", "btnSub", "btnAdd", "txtPanel")

					var_1_0.dark:visible(arg_1_2 % 2 == 0)
					var_1_0.light:visible(arg_1_2 % 2 == 1)
					var_1_0.attrName:text(arg_1_3.cfg.name)
					var_1_0.lock:visible(arg_1_3.isLockLevel or arg_1_3.isLockTotalLevel)
					adapt.oneLinePos(var_1_0.attrName, var_1_0.lock)

					if arg_1_3.dummyLevel then
						local var_1_1 = dataEasy.getAttrValueString(arg_1_3.cfg.attrType1, arg_1_3.cfg.attrValue)
						local var_1_2, var_1_3 = dataEasy.parsePercentStr(var_1_1)

						var_1_0.percent:text("+" .. dataEasy.getPercentStr(var_1_2, var_1_3, arg_1_3.dummyLevel))

						local var_1_4 = arg_1_3.dummyLevel ~= arg_1_3.originLevel and ui.COLORS.QUALITY[2] or ui.COLORS.NORMAL.DEFAULT

						text.addEffect(var_1_0.percent, {
							color = var_1_4
						})

						if arg_1_3.cfg.levelMax ~= -1 or arg_1_3.cfg.levelMax == -1 and arg_1_3.dummyLevel >= 0 then
							var_1_0.lv:text(arg_1_3.cfg.levelMax == -1 and arg_1_3.dummyLevel or arg_1_3.dummyLevel .. "/" .. arg_1_3.cfg.levelMax)
						end

						text.addEffect(var_1_0.lv, {
							color = var_1_4
						})

						local var_1_5, var_1_6 = csvNext(arg_1_3.cfg.upCost)

						var_1_0.num:text(var_1_6)
						adapt.oneLinePos(var_1_0.num, var_1_0.icon)
					end

					if arg_1_3.isLockLevel or arg_1_3.isLockTotalLevel then
						var_1_0.txtPanel:show()
						var_1_0.percent:hide()
						var_1_0.lv:hide()
						cache.setShader(var_1_0.btnSub, false, "hsl_gray")
						cache.setShader(var_1_0.btnAdd, false, "hsl_gray")
						text.addEffect(var_1_0.attrName, {
							color = cc.c4b(121, 114, 116, 153)
						})
						text.addEffect(var_1_0.num, {
							color = cc.c4b(121, 114, 116, 153)
						})

						local var_1_7 = var_1_0.txtPanel:multiget("txt1", "txt2", "txt3")

						if arg_1_3.cfg.totalAttrLevel == 0 then
							var_1_7.txt3:text(string.format(gLanguageCsv.levelUpgradeToTrainer, csv.trainer.trainer_level[arg_1_3.cfg.trainerLevel].name))
							var_1_7.txt3:show()
							itertools.invoke({
								var_1_7.txt1,
								var_1_7.txt2
							}, "hide")
						else
							var_1_7.txt3:hide()
							var_1_7.txt1:text("1." .. string.format(gLanguageCsv.levelUpgradeToTrainer, csv.trainer.trainer_level[arg_1_3.cfg.trainerLevel].name))
							text.addEffect(var_1_7.txt1, {
								color = arg_1_3.isLockLevel and ui.COLORS.NORMAL.RED or ui.COLORS.QUALITY[2]
							})
							var_1_7.txt2:text("2." .. string.format(gLanguageCsv.trainerSkillTotal, arg_1_3.cfg.totalAttrLevel, arg_1_3.totalLevel, arg_1_3.cfg.totalAttrLevel))
							text.addEffect(var_1_7.txt2, {
								color = arg_1_3.isLockTotalLevel and ui.COLORS.NORMAL.RED or ui.COLORS.QUALITY[2]
							})
							itertools.invoke({
								var_1_7.txt1,
								var_1_7.txt2
							}, "show")
						end
					else
						var_1_0.lv:show()
						cache.setShader(var_1_0.btnSub, false, "normal")
						cache.setShader(var_1_0.btnAdd, false, "normal")
						text.addEffect(var_1_0.attrName, {
							color = ui.COLORS.NORMAL.DEFAULT
						})
						text.addEffect(var_1_0.num, {
							color = ui.COLORS.NORMAL.DEFAULT
						})
						var_1_0.txtPanel:hide()
						var_1_0.percent:show()
					end

					var_1_0.btnSub:onTouch(functools.partial(arg_1_0.clickSub, arg_1_1, arg_1_2, arg_1_3))
					var_1_0.btnAdd:onTouch(functools.partial(arg_1_0.clickAdd, arg_1_1, arg_1_2, arg_1_3))
				end,
				onBeforeBuild = function(arg_2_0)
					arg_2_0:insertCustomItem(arg_2_0.item2:clone(), 0)

					if arg_2_0.sliderBg:visible() then
						arg_2_0.sliderShow = true

						arg_2_0.sliderBg:hide()
					end

					arg_2_0:setScrollBarEnabled(false)
				end,
				onAfterBuild = function(arg_3_0)
					if arg_3_0.sliderShow then
						arg_3_0.sliderBg:show()

						arg_3_0.sliderShow = false
					end

					local var_3_0 = arg_3_0:size()
					local var_3_1, var_3_2 = arg_3_0.sliderBg:xy()
					local var_3_3 = arg_3_0.sliderBg:size()
					local var_3_4 = gGameUI:getConvertPos(arg_3_0)

					arg_3_0:setScrollBarEnabled(true)
					arg_3_0:setScrollBarColor(cc.c3b(245, 156, 2))
					arg_3_0:setScrollBarOpacity(255)
					arg_3_0:setScrollBarAutoHideEnabled(false)
					arg_3_0:setScrollBarPositionFromCorner(cc.p(var_3_4.x + var_3_0.width - var_3_1, (var_3_0.height - var_3_3.height) / 2 + 5))
					arg_3_0:setScrollBarWidth(var_3_3.width)
					arg_3_0:refreshView()
				end
			},
			handlers = {
				clickAdd = bindHelper.self("onItemAddClick"),
				clickSub = bindHelper.self("onItemSubClick")
			}
		}
	},
	btnSure = {
		varname = "btnSure",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onSureClick")
				}
			}
		}
	},
	btnReset = {
		varname = "btnReset",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onResetClick")
				}
			}
		}
	},
	btnClear = {
		varname = "btnClear",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onClearClick")
				}
			}
		}
	},
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["btnReset.txt"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["btnClear.txt"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["btnSure.txt"] = {
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
	}
}

function var_0_0.onCreate(arg_4_0)
	arg_4_0:initModel()

	local var_4_0 = {}

	for iter_4_0, iter_4_1 in orderCsvPairs(csv.trainer.attr_skills) do
		table.insert(var_4_0, {
			originLevel = 0,
			isLockTotalLevel = false,
			isLockLevel = false,
			id = iter_4_0,
			cfg = iter_4_1
		})
	end

	arg_4_0.attrDatas = idlers.newWithMap(var_4_0)
	arg_4_0.clear = idler.new(true)

	uiEasy.addTabListClipping(arg_4_0.list, arg_4_0.panel, {
		mask = "city/develop/train/bg_zz.png",
		rect = cc.rect(15, 133, 1, 1)
	})

	arg_4_0.totalNum = dataEasy.getNumByKey(var_0_1)
	arg_4_0.listIndex = idlertable.new({})

	idlereasy.any({
		arg_4_0.trainerLevel,
		arg_4_0.trainerAttrSkills,
		arg_4_0.clear
	}, function(arg_5_0, arg_5_1, arg_5_2)
		local var_5_0 = 0

		for iter_5_0, iter_5_1 in pairs(arg_5_2) do
			var_5_0 = var_5_0 + iter_5_1
		end

		for iter_5_2, iter_5_3 in arg_4_0.attrDatas:pairs() do
			local var_5_1 = iter_5_3:proxy()

			var_5_1.originLevel = arg_5_2[var_5_1.id] or 0
			var_5_1.dummyLevel = arg_5_2[var_5_1.id] or 0
			var_5_1.isLockLevel = arg_5_1 < var_5_1.cfg.trainerLevel
			var_5_1.isLockTotalLevel = var_5_0 < var_5_1.cfg.totalAttrLevel
			var_5_1.totalLevel = var_5_0
		end

		adapt.oneLinePos(arg_4_0.coinIcon, arg_4_0.btnReset)
	end)
	idlereasy.any({
		arg_4_0.items,
		arg_4_0.listIndex
	}, function(arg_6_0, arg_6_1, arg_6_2)
		local var_6_0 = 0

		for iter_6_0, iter_6_1 in pairs(arg_6_2) do
			local var_6_1, var_6_2 = csvNext(csv.trainer.attr_skills[iter_6_0].upCost)

			var_6_0 = var_6_0 + var_6_2 * iter_6_1
		end

		local var_6_3 = (arg_6_1[var_0_1] or 0) - var_6_0

		arg_4_0.totalNum = var_6_3

		arg_4_0.coinNum:text(var_6_3)
		adapt.oneLinePos(arg_4_0.txt5, {
			arg_4_0.coinNum,
			arg_4_0.coinIcon
		})
	end)
	Dialog.onCreate(arg_4_0)
end

function var_0_0.initModel(arg_7_0)
	arg_7_0.trainerLevel = gGameModel.role:getIdler("trainer_level")
	arg_7_0.trainerAttrSkills = gGameModel.role:getIdler("trainer_attr_skills")
	arg_7_0.items = gGameModel.role:getIdler("items")
	arg_7_0.rmb = gGameModel.role:getIdler("rmb")
end

function var_0_0.onItemAddClick(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	if arg_8_4.isLockLevel or arg_8_4.isLockTotalLevel then
		if arg_8_5.name == "ended" or arg_8_5.name == "cancelled" then
			gGameUI:showTip(gLanguageCsv.noConditionNoGrade)
		end

		return
	end

	local var_8_0 = arg_8_0.attrDatas:atproxy(arg_8_3)
	local var_8_1, var_8_2 = csvNext(var_8_0.cfg.upCost)

	if arg_8_5.name == "began" then
		local var_8_3 = 0.3
		local var_8_4 = 0.6

		arg_8_0.notMoved = true
		arg_8_0.touchBeganPos = arg_8_5

		arg_8_0:enableSchedule():schedule(function(arg_9_0)
			if var_8_3 <= 0 then
				var_8_4 = var_8_4 <= 0.2 and 0.2 or var_8_4 - 0.2

				if var_8_0.dummyLevel == var_8_0.cfg.levelMax then
					gGameUI:showTip(gLanguageCsv.levelMax)

					return false
				end

				if arg_8_0.totalNum < var_8_2 then
					gGameUI:showTip(gLanguageCsv.trainerCointNotEnough)

					return false
				end

				var_8_0.dummyLevel = var_8_0.dummyLevel + 1

				local var_9_0 = var_8_0.dummyLevel - var_8_0.originLevel

				arg_8_0.listIndex:modify(function(arg_10_0)
					if var_9_0 > 0 then
						arg_10_0[var_8_0.id] = var_9_0
					else
						arg_10_0[var_8_0.id] = nil
					end

					return true, arg_10_0
				end, true)

				arg_8_0.notMoved = false
			end

			var_8_3 = var_8_3 - arg_9_0
		end, 0.1, 0, "levelAdd")
	elseif arg_8_5.name == "moved" then
		local var_8_5 = arg_8_5
		local var_8_6 = math.abs(var_8_5.x - arg_8_0.touchBeganPos.x)
		local var_8_7 = math.abs(var_8_5.y - arg_8_0.touchBeganPos.y)

		if var_8_6 >= ui.TOUCH_MOVE_CANCAE_THRESHOLD or var_8_7 >= ui.TOUCH_MOVE_CANCAE_THRESHOLD then
			arg_8_0.notMoved = false

			arg_8_0:unSchedule("levelAdd")
		end
	elseif arg_8_5.name == "ended" or arg_8_5.name == "cancelled" then
		arg_8_0:unSchedule("levelAdd")

		if arg_8_0.notMoved then
			if var_8_0.dummyLevel == var_8_0.cfg.levelMax then
				gGameUI:showTip(gLanguageCsv.levelMax)

				return
			end

			if var_8_2 > arg_8_0.totalNum then
				gGameUI:showTip(gLanguageCsv.trainerCointNotEnough)

				return
			end

			var_8_0.dummyLevel = var_8_0.dummyLevel + 1

			local var_8_8 = var_8_0.dummyLevel - var_8_0.originLevel

			arg_8_0.listIndex:modify(function(arg_11_0)
				if var_8_8 > 0 then
					arg_11_0[var_8_0.id] = var_8_8
				else
					arg_11_0[var_8_0.id] = nil
				end

				return true, arg_11_0
			end, true)
		end
	end
end

function var_0_0.onItemSubClick(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	if arg_12_4.isLockLevel or arg_12_4.isLockTotalLevel then
		gGameUI:showTip(gLanguageCsv.noConditionNoGrade)

		return
	end

	local var_12_0 = arg_12_0.attrDatas:atproxy(arg_12_3)

	if arg_12_5.name == "began" then
		local var_12_1 = 0.3
		local var_12_2 = 0.6

		arg_12_0.notMoved = true
		arg_12_0.touchBeganPos = arg_12_5

		arg_12_0:enableSchedule():schedule(function(arg_13_0)
			if var_12_1 <= 0 then
				var_12_2 = var_12_2 <= 0.2 and 0.2 or var_12_2 - 0.2

				if var_12_0.dummyLevel == var_12_0.originLevel then
					return false
				end

				var_12_0.dummyLevel = var_12_0.dummyLevel - 1

				local var_13_0 = var_12_0.dummyLevel - var_12_0.originLevel

				arg_12_0.listIndex:modify(function(arg_14_0)
					if var_13_0 > 0 then
						arg_14_0[var_12_0.id] = var_13_0
					else
						arg_14_0[var_12_0.id] = nil
					end

					return true, arg_14_0
				end, true)

				arg_12_0.notMoved = false
			end

			var_12_1 = var_12_1 - arg_13_0
		end, 0.1, 0, "levelSub")
	elseif arg_12_5.name == "moved" then
		local var_12_3 = arg_12_5
		local var_12_4 = math.abs(var_12_3.x - arg_12_0.touchBeganPos.x)
		local var_12_5 = math.abs(var_12_3.y - arg_12_0.touchBeganPos.y)

		if var_12_4 >= ui.TOUCH_MOVE_CANCAE_THRESHOLD or var_12_5 >= ui.TOUCH_MOVE_CANCAE_THRESHOLD then
			arg_12_0.notMoved = false

			arg_12_0:unSchedule("levelSub")
		end
	elseif arg_12_5.name == "ended" or arg_12_5.name == "cancelled" then
		arg_12_0:unSchedule("levelSub")

		if arg_12_0.notMoved then
			if var_12_0.dummyLevel == var_12_0.originLevel then
				return
			end

			var_12_0.dummyLevel = var_12_0.dummyLevel - 1

			local var_12_6 = var_12_0.dummyLevel - var_12_0.originLevel

			arg_12_0.listIndex:modify(function(arg_15_0)
				if var_12_6 > 0 then
					arg_15_0[var_12_0.id] = var_12_6
				else
					arg_15_0[var_12_0.id] = nil
				end

				return true, arg_15_0
			end, true)
		end
	end
end

function var_0_0.onClearClick(arg_16_0)
	arg_16_0.clear:set(true, true)
	arg_16_0.listIndex:set({})
end

function var_0_0.onResetClick(arg_17_0)
	if itertools.size(arg_17_0.trainerAttrSkills:read()) == 0 then
		gGameUI:showTip(gLanguageCsv.noAttrReset)

		return
	end

	local var_17_0 = string.format(gLanguageCsv.traineraaResetNote, gCommonConfigCsv.trainerAttrSkillsResetRMB)
	local var_17_1 = {
		btnType = 2,
		clearFast = true,
		isRich = true,
		content = var_17_0,
		cb = function()
			if arg_17_0.rmb:read() < gCommonConfigCsv.trainerAttrSkillsResetRMB then
				uiEasy.showDialog("rmb")

				return
			end

			gGameApp:requestServer("/game/trainer/attr_skill/reset")
		end
	}

	gGameUI:showDialog(var_17_1)
end

function var_0_0.onSureClick(arg_19_0)
	if arg_19_0.listIndex:size() == 0 then
		return
	end

	gGameApp:requestServer("/game/trainer/attr_skill/levelup", function(arg_20_0)
		gGameUI:showTip(gLanguageCsv.updateSuccessfully)

		arg_19_0.totalNum = dataEasy.getNumByKey(var_0_1)

		arg_19_0.listIndex:set({})
	end, arg_19_0.listIndex:read())
end

return var_0_0
