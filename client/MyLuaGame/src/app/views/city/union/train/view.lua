local var_0_0 = {
	open = "/game/union/training/open",
	list = "/game/union/training/list",
	see = "/game/union/training/see",
	speedup = "/game/union/training/speedup"
}
local var_0_1 = {
	UPTIN = 2,
	NOT_UNLOCK = 4,
	CAN_UNLOCK = 3,
	CHANGE = 1
}

local function var_0_2(arg_1_0, arg_1_1)
	local var_1_0 = csv.union.union_level[arg_1_0].trainingExp
	local var_1_1 = csv.base_attribute.role_level[arg_1_1].unionTrainingFix

	return math.floor(var_1_0 * var_1_1 * 60)
end

local function var_0_3(arg_2_0)
	local var_2_0 = arg_2_0:get("animation")

	if not var_2_0 then
		local var_2_1 = arg_2_0:getContentSize()

		var_2_0 = widget.addAnimationByKey(arg_2_0, "koudai_gonghuixunlian/gonghuixunlian.skel", "animation", "fangguang", 555):xy(var_2_1.width / 2, 0)
	else
		var_2_0:play("fangguang")
	end
end

local function var_0_4(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_2 then
		local var_3_0 = dataEasy.getUnitId(arg_3_2.card_id, arg_3_2.skin_id)

		bind.extend(arg_3_0, arg_3_1:get("icon"), {
			class = "card_icon",
			props = {
				unitId = var_3_0,
				advance = arg_3_2.advance,
				rarity = arg_3_2.rarity,
				star = arg_3_2.star,
				levelProps = {
					data = arg_3_2.level
				},
				onNode = function(arg_4_0)
					arg_4_0:xy(-5, -7)
				end
			}
		})
		arg_3_1:get("name"):text(arg_3_2.name)

		local var_3_1 = csv.base_attribute.card_level[arg_3_2.level]["levelExp" .. csv.cards[arg_3_2.card_id].levelExpID]
		local var_3_2 = arg_3_2.level >= arg_3_2.roleLv and gLanguageCsv.experienceFull or arg_3_2.level_exp .. "/" .. var_3_1
		local var_3_3 = arg_3_2.level >= arg_3_2.roleLv and ui.COLORS.NORMAL.FRIEND_GREEN or ui.NEWCOLORS.BROWN1
		local var_3_4 = arg_3_2.level < arg_3_2.roleLv and arg_3_2.expH or 0

		arg_3_1:get("level1"):text("+" .. var_3_4)
		adapt.oneLinePos(arg_3_1:get("level1"), arg_3_1:get("level2"))
		text.addEffect(arg_3_1:get("exp"), {
			color = var_3_3
		})
		arg_3_1:get("exp"):text(var_3_2)
		arg_3_1:get("bar"):setPercent(arg_3_2.level >= arg_3_2.roleLv and 100 or arg_3_2.level_exp / var_3_1 * 100)
	end
end

local function var_0_5(arg_5_0, arg_5_1)
	if arg_5_1.conditoinTxt then
		local var_5_0 = arg_5_0:get("txt1")
		local var_5_1 = arg_5_0:get("txt2")
		local var_5_2 = arg_5_0:get("txt3")

		var_5_0:text(arg_5_1.conditoinTxt)
		var_5_1:text(arg_5_1.conditoinLevel)
		adapt.oneLinePos(var_5_1, var_5_0, cc.p(8, 0), "right")
		adapt.oneLinePos(var_5_1, var_5_2, cc.p(8, 0))
	end
end

local function var_0_6(arg_6_0, arg_6_1)
	local var_6_0 = not arg_6_1 and ui.NEWCOLORS.BROWN1 or ui.NEWCOLORS.BROWN2

	text.addEffect(arg_6_0.name, {
		color = var_6_0
	})
	text.addEffect(arg_6_0.num, {
		color = var_6_0
	})
	text.addEffect(arg_6_0.numNote, {
		color = var_6_0
	})
	text.addEffect(arg_6_0.levelNote, {
		color = var_6_0
	})
	text.addEffect(arg_6_0.level, {
		color = var_6_0
	})
end

local function var_0_7(arg_7_0, arg_7_1)
	local var_7_0 = string.format(gLanguageCsv.aConditionsUnlock, arg_7_1)

	arg_7_0:get("txt2"):text(var_7_0)
end

local var_0_8 = class("UnionTrainView", Dialog)

var_0_8.RESOURCE_FILENAME = "union_train.json"
var_0_8.RESOURCE_BINDING = {
	roleItem = "roleItem",
	["otherPanel.empty"] = "empty",
	leftItem = "leftItem",
	["otherPanel.speedUpPanel"] = "speedUpPanel",
	["otherPanel.roleMaskPanel"] = "roleMaskPanel",
	["otherPanel.speedUpPanel.num1"] = "speedUpNum1",
	["otherPanel.speedUpPanel.num2"] = "speedUpNum2",
	mySubList = "mySubList",
	otherItem = "otherItem",
	myItem = "myItem",
	otherPanel = "otherPanel",
	myMaskPanel = "myMaskPanel",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
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
	title2 = {
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
	["leftItem.selected.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.WHITE
				}
			}
		}
	},
	leftList = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("leftDatas"),
				item = bindHelper.self("leftItem"),
				unionCanUnlockIdx = bindHelper.self("unionCanUnlockIdx"),
				showTab = bindHelper.self("showTab"),
				hasFriend = bindHelper.self("hasFriend"),
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					local var_8_0 = arg_8_1:get("normal")
					local var_8_1 = arg_8_1:get("selected")
					local var_8_2

					if arg_8_3.select then
						var_8_0:hide()

						var_8_2 = var_8_1:show()
					else
						var_8_1:hide()

						var_8_2 = var_8_0:show()
					end

					adapt.setAutoMultiLine(var_8_2:get("txt"), arg_8_3.name, 300, -8)
					text.addEffect(var_8_2:get("txt"), {
						color = ui.COLORS.NORMAL.WHITE,
						outline = {
							size = 1,
							color = ui.NEWCOLORS.OUTLINE.BLACK
						}
					})
					var_8_1:setTouchEnabled(false)
					bind.touch(arg_8_0, var_8_0, {
						methods = {
							ended = functools.partial(arg_8_0.clickCell, arg_8_2)
						}
					})
					bind.extend(arg_8_0, arg_8_1, {
						class = "red_hint",
						props = {
							state = arg_8_0.showTab:read() ~= arg_8_2,
							specialTag = arg_8_3.redHint,
							listenData = {
								unionCanUnlockIdx = arg_8_0.unionCanUnlockIdx,
								hasFriend = arg_8_0.hasFriend
							},
							onNode = function(arg_9_0)
								arg_9_0:xy(125, 310)
							end
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onLeftItemClick")
			}
		}
	},
	["myItem.panelUnlock.btnUnlock.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	myList = {
		varname = "myList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 16,
				columnSize = 2,
				data = bindHelper.self("trainDatas"),
				item = bindHelper.self("mySubList"),
				dataOrderCmpGen = bindHelper.self("onSortTrain", true),
				cell = bindHelper.self("myItem"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
					local var_10_0 = arg_10_1:multiget("panelChange", "panelPutIn", "panelUnlock", "mask")

					var_0_4(arg_10_0, var_10_0.panelChange, arg_10_3.cardData)
					var_0_5(var_10_0.mask, arg_10_3)
					var_0_7(var_10_0.panelUnlock, arg_10_3.cost)
					var_10_0.panelChange:visible(arg_10_3.unlocked == var_0_1.CHANGE)
					var_10_0.panelPutIn:visible(arg_10_3.unlocked == var_0_1.UPTIN)
					var_10_0.panelUnlock:visible(arg_10_3.unlocked == var_0_1.CAN_UNLOCK)
					var_10_0.mask:visible(arg_10_3.unlocked == var_0_1.NOT_UNLOCK)

					local var_10_1 = var_10_0.panelChange:get("btnChange")

					text.addEffect(var_10_1:get("title"), {
						outline = {
							size = 1,
							color = ui.NEWCOLORS.OUTLINE.YELLOW1
						},
						color = ui.COLORS.NORMAL.YELLOW
					})

					local var_10_2 = var_10_0.panelPutIn:get("btnPutIn")

					text.addEffect(var_10_2:get("title"), {
						outline = {
							size = 1,
							color = ui.NEWCOLORS.OUTLINE.YELLOW
						}
					})
					bind.touch(arg_10_0, var_10_1, {
						methods = {
							ended = functools.partial(arg_10_0.changeClick, arg_10_0:getIdx(arg_10_2), arg_10_3)
						}
					})
					bind.touch(arg_10_0, var_10_2, {
						methods = {
							ended = functools.partial(arg_10_0.changeClick, arg_10_0:getIdx(arg_10_2), arg_10_3)
						}
					})
					bind.touch(arg_10_0, var_10_0.panelUnlock:get("btnUnlock"), {
						methods = {
							ended = functools.partial(arg_10_0.unlockClick, arg_10_0:getIdx(arg_10_2), arg_10_3)
						}
					})
				end,
				onAfterBuild = function(arg_11_0)
					arg_11_0.afterBuild()
				end
			},
			handlers = {
				changeClick = bindHelper.self("onChangeClickClick"),
				unlockClick = bindHelper.self("onUnlockClickClick"),
				afterBuild = bindHelper.self("onMyAfterBuild")
			}
		}
	},
	["otherPanel.otherList"] = {
		varname = "otherList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("otherDatas"),
				item = bindHelper.self("otherItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
					local var_12_0 = arg_12_1:get("btn")

					var_0_4(arg_12_0, arg_12_1, arg_12_3)
					arg_12_1:get("level1"):hide()
					arg_12_1:get("level2"):hide()

					local var_12_1 = arg_12_3.level < arg_12_3.roleLv and arg_12_3.speedup < 6

					if arg_12_3.selectOtherId == arg_12_2 then
						var_0_3(arg_12_1:get("icon"))
					end

					uiEasy.setBtnShader(var_12_0, var_12_0:get("title"), var_12_1 and 1 or 2)

					if var_12_1 then
						text.addEffect(var_12_0:get("title"), {
							outline = {
								size = 4,
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
					else
						text.deleteAllEffect(var_12_0:get("title"))
					end

					bind.touch(arg_12_0, var_12_0, {
						methods = {
							ended = functools.partial(arg_12_0.itemClick, arg_12_2, arg_12_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onBtnSpeedUp")
			}
		}
	},
	["otherPanel.roleList"] = {
		varname = "roleList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("roleDatas"),
				item = bindHelper.self("roleItem"),
				onItem = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
					local var_13_0 = arg_13_1:multiget("bg", "logo", "name", "num", "numNote", "levelNote", "level")

					var_13_0.bg:visible(arg_13_3.select == true)
					bind.extend(arg_13_0, var_13_0.logo, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_13_3.memberData.logo,
							frameId = arg_13_3.memberData.frame,
							onNode = function(arg_14_0)
								arg_14_0:scale(0.9)
							end
						}
					})
					var_0_6(var_13_0, arg_13_3.select == true)
					var_13_0.name:text(arg_13_3.memberData.name)
					var_13_0.num:text(arg_13_3.num)
					adapt.oneLinePos(var_13_0.num, var_13_0.numNote)
					var_13_0.level:text(arg_13_3.memberData.level)
					bind.touch(arg_13_0, arg_13_1, {
						methods = {
							ended = functools.partial(arg_13_0.itemClick, arg_13_2, arg_13_3)
						}
					})
				end,
				onAfterBuild = function(arg_15_0)
					arg_15_0.afterBuild()
				end
			},
			handlers = {
				itemClick = bindHelper.self("onRoleItemClick"),
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	},
	["otherPanel.speedUpPanel.btnSpeedUp"] = {
		varname = "btnSpeedUp",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnSpeedUp")
			}
		}
	}
}

function var_0_8.onCreate(arg_16_0)
	arg_16_0.unionCanUnlockIdx = userDefault.getForeverLocalKey("unionCanUnlockIdx", 0)

	arg_16_0:initModel()

	arg_16_0.leftDatas = {
		{
			redHint = "unionTrainPosition",
			name = gLanguageCsv.myTrainingCenter
		},
		{
			redHint = "unionTrainSpeedUp",
			name = gLanguageCsv.accelerateForComrades
		}
	}
	arg_16_0.leftDatas = idlers.newWithMap(arg_16_0.leftDatas)
	arg_16_0.showTab = idler.new(1)
	arg_16_0.showOtherTrain = idler.new(false)

	arg_16_0.showTab:addListener(function(arg_17_0, arg_17_1, arg_17_2)
		arg_16_0.leftDatas:atproxy(arg_17_1).select = false
		arg_16_0.leftDatas:atproxy(arg_17_0).select = true

		arg_16_0.myList:visible(arg_17_0 == 1)
		arg_16_0.myMaskPanel:visible(arg_17_0 == 1)
		arg_16_0.showOtherTrain:set(arg_17_0 == 2)
	end)

	arg_16_0.trainDatas = idlers.new()

	idlereasy.any({
		arg_16_0.slots,
		arg_16_0.opened
	}, function(arg_18_0, arg_18_1, arg_18_2)
		local var_18_0 = arg_16_0.roleLv:read()
		local var_18_1 = arg_16_0.vipLevel:read()
		local var_18_2 = arg_16_0.unionLevel:read()
		local var_18_3 = {}
		local var_18_4 = 0

		for iter_18_0, iter_18_1 in csvPairs(csv.union.training) do
			local var_18_5
			local var_18_6
			local var_18_7
			local var_18_8
			local var_18_9

			if arg_18_1[iter_18_0] then
				var_18_9 = gGameModel.cards:find(arg_18_1[iter_18_0].id)
			end

			if arg_18_2[iter_18_0] and var_18_9 then
				var_18_5 = var_0_1.CHANGE
				arg_18_1[iter_18_0].rarity = csv.cards[arg_18_1[iter_18_0].card_id].rarity
				arg_18_1[iter_18_0].expH = var_0_2(var_18_2, var_18_0)
				arg_18_1[iter_18_0].roleLv = var_18_0
				arg_18_1[iter_18_0].nextExp = var_18_9:read("next_level_exp")
				arg_18_1[iter_18_0].skin_id = var_18_9:read("skin_id")
				var_18_6 = arg_18_1[iter_18_0]
			elseif arg_18_2[iter_18_0] and not var_18_9 then
				var_18_5 = var_0_1.UPTIN
			elseif not arg_18_2[iter_18_0] and var_18_0 >= iter_18_1.openLevel and var_18_1 >= iter_18_1.openVIP then
				var_18_5 = var_0_1.CAN_UNLOCK

				if var_18_4 < iter_18_0 then
					var_18_4 = iter_18_0
				end
			else
				local var_18_10 = var_18_0 >= iter_18_1.openLevel and "VIP " or gLanguageCsv.level

				var_18_8 = var_18_0 >= iter_18_1.openLevel and iter_18_1.openVIP or iter_18_1.openLevel
				var_18_7 = string.format(gLanguageCsv.reachedConditoinUnlock, var_18_10)
				var_18_5 = var_0_1.NOT_UNLOCK
			end

			table.insert(var_18_3, {
				id = iter_18_0,
				unlocked = var_18_5,
				cardData = var_18_6,
				conditoinTxt = var_18_7,
				conditoinLevel = var_18_8,
				cost = iter_18_1.costRMB
			})
		end

		dataEasy.tryCallFunc(arg_16_0.myList, "updatePreloadCenterIndex")
		arg_16_0.trainDatas:update(var_18_3)
		userDefault.setForeverLocalKey("unionCanUnlockIdx", var_18_4)
	end)

	arg_16_0.otherDatas = idlers.newWithMap({})
	arg_16_0.roleDatas = idlers.new({})
	arg_16_0.selectRole = idler.new(1)

	arg_16_0.selectRole:addListener(function(arg_19_0, arg_19_1, arg_19_2)
		local var_19_0 = arg_16_0.roleDatas:atproxy(arg_19_1)
		local var_19_1 = arg_16_0.roleDatas:atproxy(arg_19_0)

		if var_19_0 then
			var_19_0.select = false
		end

		if var_19_1 then
			var_19_1.select = true
		end
	end)

	arg_16_0.selectOtherId = idler.new(0)

	idlereasy.when(arg_16_0.selectRole, function(arg_20_0, arg_20_1)
		local var_20_0 = arg_16_0.roleDatas:atproxy(arg_20_1)

		arg_16_0.selectOtherId:set(0)

		if var_20_0 then
			arg_16_0:onRequest("see", {
				var_20_0.id
			}, function(arg_21_0)
				dataEasy.tryCallFunc(arg_16_0.otherList, "updatePreloadCenterIndex")
				arg_16_0.otherDatas:update(arg_16_0:setRoleDatas(arg_21_0.view, var_20_0.id))
			end)
		end
	end)
	idlereasy.when(arg_16_0.unionTrainingSpeedup, function(arg_22_0, arg_22_1)
		arg_16_0.speedUpNum1:text(math.max(6 - arg_22_1 or 0, 0))
		adapt.oneLinePos(arg_16_0.speedUpNum1, arg_16_0.speedUpNum2)
		uiEasy.setBtnShader(arg_16_0.btnSpeedUp, arg_16_0.btnSpeedUp:get("title"), arg_22_1 < 6 and 1 or 2)

		if arg_22_1 then
			text.addEffect(arg_16_0.btnSpeedUp:get("title"), {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			})
		else
			text.deleteAllEffect(arg_16_0.btnSpeedUp:get("title"))
		end

		for iter_22_0, iter_22_1 in pairs(csv.union.training) do
			if arg_16_0.otherDatas:atproxy(iter_22_0) then
				dataEasy.tryCallFunc(arg_16_0.otherList, "updatePreloadCenterIndex")

				arg_16_0.otherDatas:atproxy(iter_22_0).speedup = arg_22_1
				arg_16_0.otherDatas:atproxy(iter_22_0).selectOtherId = arg_16_0.selectOtherId:read()
			end
		end
	end)

	arg_16_0.hasFriend = false

	idlereasy.when(arg_16_0.showOtherTrain, function(arg_23_0, arg_23_1)
		if arg_23_1 then
			local var_23_0 = arg_16_0.roleId:read()
			local var_23_1 = arg_16_0.members:read()

			gGameApp:requestServer("/game/union/training/list", function(arg_24_0)
				local var_24_0 = {}
				local var_24_1 = 0

				for iter_24_0, iter_24_1 in ipairs(arg_24_0.view) do
					if var_23_0 ~= iter_24_1[1] and iter_24_1[2] > 0 then
						table.insert(var_24_0, {
							id = iter_24_1[1],
							num = iter_24_1[2],
							memberData = var_23_1[iter_24_1[1]]
						})

						var_24_1 = var_24_1 + 1
					end
				end

				arg_16_0.roleDatas:update(var_24_0)
				arg_16_0.selectRole:set(arg_16_0.selectRole:read(), true)
				arg_16_0.otherPanel:visible(true)

				arg_16_0.hasFriend = var_24_1 > 0
			end)
		else
			arg_16_0.otherPanel:visible(false)
		end
	end)
	Dialog.onCreate(arg_16_0)
end

function var_0_8.initModel(arg_25_0)
	local var_25_0 = gGameModel.union_training

	arg_25_0.slots = var_25_0:getIdler("slots")
	arg_25_0.opened = var_25_0:getIdler("opened")

	local var_25_1 = gGameModel.union

	arg_25_0.unionLevel = var_25_1:getIdler("level")
	arg_25_0.members = var_25_1:getIdler("members")
	arg_25_0.roleLv = gGameModel.role:getIdler("level")
	arg_25_0.roleId = gGameModel.role:getIdler("id")
	arg_25_0.rmb = gGameModel.role:getIdler("rmb")
	arg_25_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_25_0.unionTrainingSpeedup = gGameModel.daily_record:getIdler("union_training_speedup")
end

function var_0_8.setRoleDatas(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	local var_26_0 = arg_26_0.unionLevel:read()
	local var_26_1 = {}

	for iter_26_0, iter_26_1 in pairs(arg_26_1.slots) do
		local var_26_2 = arg_26_0.members:read()[arg_26_2].level

		iter_26_1.expH = var_0_2(var_26_0, var_26_2)
		iter_26_1.roleId = arg_26_2

		local var_26_3 = csv.cards[iter_26_1.card_id]

		iter_26_1.rarity = csv.unit[var_26_3.unitID].rarity
		iter_26_1.roleLv = var_26_2
		iter_26_1.selectOtherId = arg_26_3
		iter_26_1.speedup = arg_26_0.unionTrainingSpeedup:read()
		iter_26_1.selectOtherId = arg_26_0.selectOtherId:read()
		iter_26_1.nextExp = csv.base_attribute.card_level[iter_26_1.level]["levelExp" .. var_26_3.levelExpID]

		if arg_26_1.offline_exp and arg_26_1.offline_exp[iter_26_1.id] then
			local var_26_4 = iter_26_1.level
			local var_26_5 = iter_26_1.level_exp + arg_26_1.offline_exp[iter_26_1.id]

			for iter_26_2 = var_26_4, var_26_2 do
				local var_26_6 = csv.base_attribute.card_level[iter_26_2]["levelExp" .. var_26_3.levelExpID]

				if var_26_2 <= iter_26_2 or var_26_5 < var_26_6 then
					iter_26_1.level_exp = var_26_5
					iter_26_1.level = iter_26_2

					break
				end

				var_26_5 = var_26_5 - var_26_6
			end
		end

		var_26_1[iter_26_0] = iter_26_1
	end

	return var_26_1
end

function var_0_8.onChangeClickClick(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0 = arg_27_3.unlocked == 1 and "replace" or "start"

	gGameUI:stackUI("city.union.train.select_sprite", nil, nil, {
		idx = arg_27_3.id,
		requestTyp = var_27_0
	})
end

function var_0_8.onUnlockClickClick(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = {
		isRich = true,
		btnType = 2,
		cb = function()
			arg_28_0:onRequest("open", {
				arg_28_3.id
			})
		end,
		content = string.format(gLanguageCsv.unlockTrain, arg_28_3.cost),
		dialogParams = {
			clickClose = false
		}
	}

	gGameUI:showDialog(var_28_0)
end

function var_0_8.onBtnSpeedUp(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	local var_30_0 = {}
	local var_30_1 = math.max(6 - arg_30_0.unionTrainingSpeedup:read(), 1)

	if arg_30_3 then
		var_30_1 = 1
		var_30_0 = {
			arg_30_3.roleId,
			arg_30_2
		}
	end

	arg_30_0.selectOtherId:set(arg_30_2)
	arg_30_0:onRequest("speedup", var_30_0, function(arg_31_0)
		arg_30_0.selectRole:set(arg_30_0.selectRole:read(), true)
		gGameUI:showTip(string.format(gLanguageCsv.acceleratingSuccessTips, var_30_1 * gCommonConfigCsv.unionTrainingSpeedUpGold))
	end)
end

function var_0_8.onRoleItemClick(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	dataEasy.tryCallFunc(arg_32_0.otherList, "setItemAction", {
		isAction = true
	})
	arg_32_0.selectRole:set(arg_32_2)
end

function var_0_8.onLeftItemClick(arg_33_0, arg_33_1, arg_33_2)
	arg_33_0.showTab:set(arg_33_2)
end

function var_0_8.onRequest(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	gGameApp:requestServer(var_0_0[arg_34_1], function(arg_35_0)
		if arg_34_3 then
			arg_34_3(arg_35_0)
		end
	end, unpack(arg_34_2 or {}))
end

function var_0_8.onAfterBuild(arg_36_0)
	local var_36_0 = arg_36_0.roleList:getChildrenCount() == 0 and arg_36_0.showOtherTrain:read()

	arg_36_0.empty:visible(var_36_0)
	arg_36_0.speedUpPanel:visible(not var_36_0)
	arg_36_0.roleMaskPanel:visible(not var_36_0)
	uiEasy.setBottomMask(arg_36_0.roleList, arg_36_0.roleMaskPanel)
end

function var_0_8.onMyAfterBuild(arg_37_0)
	uiEasy.setBottomMask(arg_37_0.myList, arg_37_0.myMaskPanel)
end

function var_0_8.onSortTrain(arg_38_0, arg_38_1)
	return function(arg_39_0, arg_39_1)
		if arg_39_0.unlocked ~= arg_39_1.unlocked then
			return arg_39_0.unlocked < arg_39_1.unlocked
		end

		return arg_39_0.id < arg_39_1.id
	end
end

return var_0_8
