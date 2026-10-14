local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	if arg_1_2 then
		arg_1_0:text(arg_1_2)
	end

	if arg_1_3 then
		arg_1_1:text(arg_1_3)
	end

	adapt.oneLinePos(arg_1_0, arg_1_1)
end

local function var_0_1(arg_2_0, arg_2_1)
	local var_2_0 = 0

	if not arg_2_1 then
		return var_2_0
	end

	for iter_2_0, iter_2_1 in ipairs(arg_2_0) do
		if iter_2_1[arg_2_1] then
			var_2_0 = var_2_0 + iter_2_1[arg_2_1]
		else
			for iter_2_2, iter_2_3 in pairs(iter_2_1.items or {}) do
				if iter_2_2 == arg_2_1 then
					var_2_0 = var_2_0 + iter_2_3
				end
			end
		end
	end

	return var_2_0
end

local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("GateSweepView", Dialog)

var_0_3.RESOURCE_FILENAME = "gate_sweep.json"
var_0_3.RESOURCE_BINDING = {
	["sweepInfo.textNoteNum1"] = "textNoteNum1",
	["sweepInfo.textNoteNum2"] = "textNoteNum2",
	itemTitle = "itemTitle",
	innerList = "innerList",
	imgBG = "imgBG",
	item1 = "item1",
	successItem = "successItem",
	bottomItem = "bottomItem",
	item = "item",
	list = "list",
	["item.textTip"] = "textTip",
	["title.btnClose"] = {
		varname = "btnClose",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSpeedClick")
			}
		}
	},
	["title.textNote1"] = {
		varname = "titleNode1",
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
	["title.textNote2"] = {
		varname = "titleNode2",
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
	btnSure = {
		varname = "sureBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["btnSure.textNote"] = {
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
	["btnAgain.textNote"] = {
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
	btnAgain = {
		varname = "againBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAgainClick")
			}
		}
	},
	panelBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSpeedClick")
			}
		}
	},
	sweepInfo = {
		varname = "sweepInfo",
		binds = {
			event = "visible",
			idler = bindHelper.self("isShowTargetInfo")
		}
	},
	bottomList = {
		varname = "bottomList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				preloadBottom = true,
				asyncPreload = 6,
				data = bindHelper.self("bottomDatas"),
				item = bindHelper.self("bottomItem"),
				item1 = bindHelper.self("item1"),
				startGateId = bindHelper.self("startGateId"),
				isDouble = bindHelper.self("isDouble"),
				innerList = bindHelper.self("innerList"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("textTitle", "innerList")

					if arg_3_3.effect then
						var_3_0.textTitle:hide()
						var_3_0.innerList:hide()

						local var_3_1 = arg_3_1:size()
						local var_3_2 = CSprite.new("level/saodangchenggong.skel")

						var_3_2:addTo(arg_3_1, 100)
						var_3_2:setAnchorPoint(cc.p(0.5, 0.5))
						var_3_2:xy(var_3_1.width / 2, var_3_1.height / 2)
						var_3_2:visible(true)
						var_3_2:play("saodangchenggong")
						var_3_2:addPlay("saodangchenggong_loop")
						var_3_2:retain()
					else
						local var_3_3 = ""

						if arg_3_3.isTotal then
							var_3_3 = gLanguageCsv.totalGot
						else
							var_3_3 = csv.endless_tower_scene[arg_3_0.startGateId + arg_3_2 - 1].sceneName
						end

						var_3_0.textTitle:text(var_3_3)

						local var_3_4 = arg_3_3.items

						if arg_3_3.gold and not var_3_4.gold then
							var_3_4.gold = arg_3_3.gold
						end

						local var_3_5 = {}

						for iter_3_0, iter_3_1 in pairs(var_3_4) do
							local var_3_6 = {
								key = iter_3_0,
								value = iter_3_1
							}

							if iter_3_0 == "gold" then
								var_3_6.sort = 1
							elseif iter_3_0 == 452 then
								var_3_6.sort = 2
							elseif iter_3_0 == 451 then
								var_3_6.sort = 3
							elseif type(iter_3_0) ~= "number" then
								var_3_6.sort = 4
							else
								var_3_6.sort = iter_3_0 + 4
							end

							table.insert(var_3_5, var_3_6)
						end

						table.sort(var_3_5, function(arg_4_0, arg_4_1)
							return arg_4_0.sort < arg_4_1.sort
						end)

						local var_3_7
						local var_3_8 = 0
						local var_3_9 = 6
						local var_3_10 = math.ceil(itertools.size(var_3_4) / 6)
						local var_3_11 = arg_3_0.innerList:height() * var_3_10 + var_3_0.innerList:getItemsMargin() * (var_3_10 - 1)

						arg_3_1:height(arg_3_1:height() + var_3_11 - arg_3_0.innerList:height())
						var_3_0.innerList:height(var_3_11)
						var_3_0.textTitle:y(var_3_0.textTitle:y() + var_3_11 - arg_3_0.innerList:height())

						for iter_3_2, iter_3_3 in pairs(var_3_5) do
							var_3_8 = var_3_8 + 1

							local var_3_12, var_3_13 = mathEasy.getRowCol(var_3_8, var_3_9)

							if var_3_8 % var_3_9 == 1 then
								var_3_7 = arg_3_0.innerList:clone():tag(var_3_12):show()

								var_3_0.innerList:pushBackCustomItem(var_3_7)
							end

							local var_3_14 = arg_3_0.item1:clone():show()
							local var_3_15 = {
								class = "icon_key",
								props = {
									data = {
										key = iter_3_3.key,
										num = iter_3_3.value
									},
									isDouble = arg_3_0.isDouble
								}
							}

							bind.extend(arg_3_0, var_3_14, var_3_15)
							var_3_7:pushBackCustomItem(var_3_14)
						end
					end
				end
			}
		}
	}
}
var_0_3.RESOURCE_STYLES = {
	backGlass = true
}

function var_0_3.setEffect(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1:size()
	local var_5_1 = CSprite.new("level/saodangchenggong.skel")

	var_5_1:addTo(arg_5_1, 100)
	var_5_1:setAnchorPoint(cc.p(0.5, 0.5))
	var_5_1:xy(var_5_0.width / 2, var_5_0.height / 2)
	var_5_1:visible(true)
	var_5_1:hide()

	arg_5_0.effect = var_5_1
end

function var_0_3.playEffect(arg_6_0)
	local var_6_0 = arg_6_0.effect

	if not var_6_0 then
		return
	end

	local var_6_1 = arg_6_0.from == "union"
	local var_6_2 = var_6_1 and "tiaozhanchenggong" or "saodangchenggong"
	local var_6_3 = var_6_1 and "tiaozhanchenggong_loop" or "saodangchenggong_loop"
	local var_6_4 = arg_6_0.from == "dailyAssistant"

	var_6_2 = var_6_4 and "saodangwancheng" or var_6_2
	var_6_3 = var_6_4 and "saodangwancheng_loop" or var_6_3

	var_6_0:show()
	var_6_0:play(var_6_2)
	var_6_0:addPlay(var_6_3)
	var_6_0:retain()
end

function var_0_3.onCreate(arg_7_0, arg_7_1)
	arg_7_0:initModel()

	arg_7_0.sweepTimes = 1
	arg_7_0.prenumb1 = 0
	arg_7_0.prenumb2 = 0

	var_0_0(arg_7_0.titleNode1, arg_7_0.titleNode2, arg_7_1.title1, arg_7_1.title2)

	arg_7_0.sweepData = arg_7_1.sweepData

	local var_7_0 = arg_7_1.sweepData
	local var_7_1 = arg_7_1.oldRoleLv
	local var_7_2 = arg_7_1.hasExtra
	local var_7_3 = arg_7_1.oldCapture
	local var_7_4 = arg_7_1.curMopUpNum or 0

	arg_7_0.startGateId = arg_7_1.startGateId or 100000
	arg_7_0.cb = arg_7_1.cb
	arg_7_0.checkCb = arg_7_1.checkCb
	arg_7_0.from = arg_7_1.from

	local var_7_5 = arg_7_1.showType or 1

	arg_7_0.isShowTargetInfo = idler.new(arg_7_1.targetId ~= nil and arg_7_1.targetNum ~= nil)
	arg_7_0.isDouble = arg_7_1.isDouble

	if arg_7_0.from == "gate" or arg_7_0.from == "gainWay" then
		arg_7_0.gateId = arg_7_1.gateId
	elseif arg_7_0.from == "allGate" then
		arg_7_0.gateId = arg_7_1.sweepData[1].gateId
	end

	arg_7_0.catchup = arg_7_1.catchup

	if arg_7_1.targetId and arg_7_1.targetNum then
		local var_7_6 = var_0_1(var_7_0, arg_7_1.targetId)

		arg_7_0.textNoteNum1:text(var_7_6)

		local var_7_7 = dataEasy.getNumByKey(arg_7_1.targetId)

		bind.extend(arg_7_0, arg_7_0.sweepInfo:get("item"), {
			class = "icon_key",
			props = {
				data = {
					key = arg_7_1.targetId,
					num = var_7_7
				},
				onNode = function(arg_8_0)
					arg_8_0:scale(0.9)
				end
			}
		})

		if var_7_7 >= arg_7_1.targetNum then
			local var_7_8 = gLanguageCsv.material

			if dataEasy.isFragment(arg_7_1.targetId) then
				var_7_8 = gLanguageCsv.fragment
			end

			local var_7_9 = arg_7_0.sweepInfo:get("textNote2")

			var_7_9:text(string.format(gLanguageCsv.hasEnoughItemOrFrag, var_7_8))
			adapt.setTextAdaptWithSize(var_7_9, {
				margin = -4,
				horizontal = "left",
				vertical = "center",
				size = cc.size(300, 100)
			})
			arg_7_0.sweepInfo:get("textNoteNum2"):visible(false)
			arg_7_0.sweepInfo:get("textNoteGe2"):visible(false)
		else
			arg_7_0.textNoteNum2:text(arg_7_1.targetNum - var_7_7)
		end
	end

	adapt.oneLinePos(arg_7_0.sweepInfo:get("textNote1"), {
		arg_7_0.textNoteNum1,
		arg_7_0.sweepInfo:get("textNoteGe1")
	}, {
		cc.p(10, 0)
	}, "left")
	adapt.oneLinePos(arg_7_0.sweepInfo:get("textNote2"), {
		arg_7_0.textNoteNum2,
		arg_7_0.sweepInfo:get("textNoteGe2")
	}, {
		cc.p(10, 0)
	}, "left")

	if var_7_5 == 2 then
		arg_7_0.sureBtn:x(arg_7_0.imgBG:x())
	end

	arg_7_0.list:setScrollBarEnabled(false)
	arg_7_0.innerList:setScrollBarEnabled(false)
	arg_7_0.bottomList:setScrollBarEnabled(false)
	arg_7_0.item:get("list"):setScrollBarEnabled(false)
	arg_7_0.bottomItem:get("innerList"):setScrollBarEnabled(false)

	local var_7_10 = gGameModel.capture:read("limit_sprites")
	local var_7_11 = 0
	local var_7_12 = 0

	arg_7_0.interval = 0.1
	arg_7_0.canClose = false

	arg_7_0.btnClose:setTouchEnabled(false)
	arg_7_0.againBtn:hide()
	arg_7_0.sureBtn:hide()

	local var_7_13 = itertools.size(var_7_0)

	local function var_7_14()
		arg_7_0.againBtn:visible(var_7_5 == 1)
		arg_7_0.sureBtn:show()

		if var_7_1 < arg_7_0.roleLv:read() then
			gGameUI:stackUI("common.upgrade_notice", nil, nil, var_7_1)
		end

		performWithDelay(arg_7_0, function()
			arg_7_0:playEffect()
			uiEasy.showMysteryShop()
			uiEasy.showActivityBoss()

			arg_7_0.canClose = true

			arg_7_0.btnClose:setTouchEnabled(true)

			if dataEasy.isUnlock(gUnlockCsv.limitCapture) then
				for iter_10_0, iter_10_1 in pairs(var_7_10) do
					if csv.capture.sprite[iter_10_1.csv_id] and iter_10_1.find_time + csv.capture.sprite[iter_10_1.csv_id].time - time.getTime() > 0 and iter_10_1.state == 1 and not itertools.equal(iter_10_1, var_7_3[iter_10_0]) then
						gGameUI:stackUI("common.capture_tips")

						break
					end
				end
			end
		end, 0.5)
	end

	if arg_7_0.from == "endlessTower" then
		var_7_14()

		local var_7_15 = {
			effect = true
		}

		table.insert(var_7_0, var_7_15)

		arg_7_0.bottomDatas = idlertable.new(var_7_0)

		arg_7_0.list:hide()
	else
		arg_7_0.bottomDatas = idlertable.new({})

		arg_7_0.bottomList:hide()
		arg_7_0:enableSchedule():schedule(function(arg_11_0)
			if var_7_11 >= var_7_13 then
				arg_7_0.interval = 10
				var_7_12 = 10

				arg_7_0.list:scrollToBottom(0.3, true)
				var_7_14()

				return false
			end

			var_7_12 = var_7_12 - arg_11_0

			if var_7_12 <= 0 and var_7_11 < var_7_13 then
				var_7_12 = arg_7_0.interval
				var_7_11 = var_7_11 + 1

				local var_11_0 = var_7_0[var_7_11]
				local var_11_1 = arg_7_0.isDouble

				if var_11_0.isExtra then
					local var_11_2 = arg_7_0.successItem:clone():show()

					arg_7_0:setEffect(var_11_2)
					arg_7_0.list:pushBackCustomItem(var_11_2)

					if var_7_2 == nil then
						var_7_2 = true
					end
				end

				local var_11_3 = var_7_11 == var_7_13 and arg_7_1.isTotal

				if var_11_0.textDatas then
					if var_11_0.dailyDatas and var_11_0.dailyDatas.hasTitle then
						local var_11_4 = arg_7_0:cloneTitleItem(var_7_11, var_11_0.exp or 0, var_11_0.isExtra, var_11_3, var_11_0.dailyDatas)

						arg_7_0.list:pushBackCustomItem(var_11_4)
						arg_7_0.list:pushBackCustomItem(arg_7_0:cloneTextItem(" ", {
							fontSize = 1
						}))
					end

					local var_11_5 = arg_7_0:cloneTextItem(var_11_0.textDatas.content, var_11_0.textDatas.params or {})

					arg_7_0.list:pushBackCustomItem(var_11_5)
				else
					if not var_11_0.noTitle then
						local var_11_6 = arg_7_0:cloneTitleItem(var_7_11, var_11_0.exp or 0, var_11_0.isExtra, var_11_3, var_11_0.dailyDatas)

						arg_7_0.list:pushBackCustomItem(var_11_6)
					end

					local var_11_7 = var_11_0.items

					if var_11_0.gold and not var_11_7.gold then
						var_11_7.gold = var_11_0.gold
					end

					local var_11_8
					local var_11_9 = 0
					local var_11_10 = 6
					local var_11_11 = {}

					for iter_11_0, iter_11_1 in pairs(var_11_7) do
						local var_11_12 = {
							key = iter_11_0,
							value = iter_11_1
						}

						var_11_12.type = "items"

						if iter_11_0 == "fish" then
							for iter_11_2, iter_11_3 in pairs(iter_11_1) do
								var_11_12 = {
									key = iter_11_2,
									value = iter_11_3
								}
								var_11_12.type = "fish"
								var_11_12.sort = 5

								table.insert(var_11_11, var_11_12)
							end
						elseif iter_11_0 == "cards" then
							for iter_11_4, iter_11_5 in pairs(iter_11_1) do
								var_11_12 = {
									key = iter_11_4,
									value = iter_11_5
								}
								var_11_12.type = "cards"
								var_11_12.sort = 6

								table.insert(var_11_11, var_11_12)
							end
						elseif iter_11_0 == "carddbIDs" then
							-- block empty
						else
							if iter_11_0 == "gold" then
								var_11_12.sort = 1
							elseif iter_11_0 == 452 then
								var_11_12.sort = 2
							elseif iter_11_0 == 451 then
								var_11_12.sort = 3
							elseif type(iter_11_0) ~= "number" then
								var_11_12.sort = 4
							else
								var_11_12.sort = iter_11_0 + 4
							end

							table.insert(var_11_11, var_11_12)
						end
					end

					table.sort(var_11_11, function(arg_12_0, arg_12_1)
						return arg_12_0.sort < arg_12_1.sort
					end)

					local var_11_13 = math.ceil(itertools.size(var_11_11) / 6)
					local var_11_14 = arg_7_0:cloneItem(var_11_13, var_7_11, var_11_11)

					arg_7_0.list:pushBackCustomItem(var_11_14)

					if arg_7_0.catchup and arg_7_0.catchup > 0 then
						var_11_1 = true

						if var_7_11 > arg_7_0.catchup then
							var_11_1 = false
						end
					end

					if var_7_11 == var_7_13 then
						var_11_1 = false
					end

					for iter_11_6, iter_11_7 in pairs(var_11_11) do
						var_11_9 = var_11_9 + 1

						local var_11_15, var_11_16 = mathEasy.getRowCol(var_11_9, var_11_10)

						if var_11_9 % var_11_10 == 1 then
							var_11_8 = arg_7_0.innerList:clone():tag(var_11_15):show()

							var_11_14:get("list"):pushBackCustomItem(var_11_8)
						end

						local var_11_17 = arg_7_0.item1:clone():tag(var_11_16):show()
						local var_11_18 = var_11_1

						if var_11_18 and iter_11_7.key ~= "gold" then
							local var_11_19 = csv.items[iter_11_7.key]

							if var_11_19 and var_11_19.isLimitDrop then
								var_11_18 = false
							end
						end

						if iter_11_7.type == "cards" then
							local var_11_20 = csv.cards[iter_11_7.value.id].unitID
							local var_11_21 = csv.cards[iter_11_7.value.id].star
							local var_11_22 = csv.unit[var_11_20].rarity

							bind.extend(arg_7_0, var_11_17, {
								class = "card_icon",
								props = {
									unitId = var_11_20,
									rarity = var_11_22,
									star = var_11_21,
									onNodeClick = function(arg_13_0)
										arg_7_0:onitemClick(arg_13_0, iter_11_7.value.id)
									end
								}
							})
						elseif iter_11_7.type == "fish" then
							bind.extend(arg_7_0, var_11_17, {
								class = "fish_icon",
								props = {
									onNodeClick = true,
									data = {
										key = iter_11_7.key,
										num = iter_11_7.value
									}
								}
							})
						else
							local var_11_23 = {
								class = "icon_key",
								props = {
									data = {
										key = iter_11_7.key,
										num = iter_11_7.value
									},
									isDouble = var_11_18
								}
							}

							bind.extend(arg_7_0, var_11_17, var_11_23)
						end

						var_11_8:pushBackCustomItem(var_11_17)
					end
				end

				if var_7_2 == false and var_7_11 == var_7_13 then
					local var_11_24 = arg_7_0.successItem:clone():show()

					arg_7_0:setEffect(var_11_24)
					arg_7_0.list:pushBackCustomItem(var_11_24)
				end

				if var_7_11 == var_7_13 and var_7_4 > var_7_13 then
					gGameUI:showTip(gLanguageCsv.sweepAdaptiveTip)
				end

				arg_7_0.list:scrollToBottom(0.3, true)
			end
		end, 0.016666666666666666, 0, "GateSweepView")
	end

	bind.click(arg_7_0, arg_7_0.imgBG, {
		method = function()
			arg_7_0.interval = 0
		end
	})
	Dialog.onCreate(arg_7_0)
end

function var_0_3.titleItemClone(arg_15_0)
	if arg_15_0.type == "mimicry" then
		if not self.mimicryNum then
			self.mimicryNum = 1
		else
			self.mimicryNum = self.mimicryNum + 1
		end

		local var_15_0 = self.itemTitle:clone():show()

		var_15_0:removeAllChildren()

		local var_15_1 = arg_15_0.scaors[self.mimicryNum]

		if var_15_1.newBuffs then
			local var_15_2 = self.itemTitle:clone():show()

			var_15_2:removeAllChildren()

			local var_15_3 = rich.createByStr("#C0xF76B45#" .. gLanguageCsv.mimicryEndNewBuff, 36):align(cc.p(0.5, 0.5), var_15_2:width() / 2, var_15_2:height() / 2):addTo(var_15_2, 4):formatText()

			self.list:pushBackCustomItem(var_15_2)
		end

		local var_15_4 = string.format(gLanguageCsv.mimicrySaoDangScore, var_15_1.sum, var_15_1.bossScores, var_15_1.buffScores)
		local var_15_5 = rich.createByStr("#C0x5B545B#" .. var_15_4, 40):align(cc.p(0, 0), 0, 0):addTo(var_15_0, 4):formatText()

		if arg_15_0.newNum and arg_15_0.newNum == self.mimicryNum then
			local var_15_6 = cc.Sprite:create("common/icon/txt_new.png"):align(cc.p(0, 0), 0, -10):addTo(var_15_0, 4)

			adapt.oneLinePos(var_15_5, var_15_6, cc.p(15, 0), "left")
		end

		self.list:pushBackCustomItem(var_15_0)
	end
end

function var_0_3.initModel(arg_16_0)
	arg_16_0.roleLv = gGameModel.role:getIdler("level")
	arg_16_0.stamina = gGameModel.role:getIdler("stamina")
	arg_16_0.gateTimes = gGameModel.daily_record:getIdler("gate_times")
end

function var_0_3.cloneItem(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = 10
	local var_17_1 = 200 * arg_17_1 + var_17_0 * (arg_17_1 - 1)
	local var_17_2 = arg_17_0.item:clone():tag(arg_17_2):size(1248, var_17_1):xy(1000, 1500):show()
	local var_17_3 = var_17_2:size()

	var_17_2:get("textTip"):visible(next(arg_17_3) == nil)
	var_17_2:get("list"):size(1248, var_17_1):y(0)

	return var_17_2
end

function var_0_3.cloneTextItem(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_2.width or arg_18_0.list:width()
	local var_18_1 = math.min(var_18_0, arg_18_0.list:width())
	local var_18_2 = cc.size(var_18_1, 300)
	local var_18_3 = "center"
	local var_18_4, var_18_5 = beauty.textScroll({
		margin = 20,
		size = var_18_2,
		fontSize = arg_18_2.fontSize or 50,
		effect = {
			color = ui.COLORS.NORMAL.DEFAULT
		},
		strs = arg_18_1,
		verticalSpace = arg_18_2.verticalSpace or 10,
		isRich = arg_18_2.isRich,
		align = arg_18_2.align or var_18_3
	})

	var_18_4:height(var_18_5 + 30)

	return var_18_4
end

function var_0_3.cloneTitleItem(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	local var_19_0 = arg_19_0.itemTitle:clone():show()

	if arg_19_3 == true then
		if arg_19_0.gateId and dataEasy.getWorldLevelExpAdd(math.floor(arg_19_0.gateId / 10000)) then
			var_19_0:get("textTitle"):text(gLanguageCsv.sweepWorldLevelExtra):x(624)
		else
			var_19_0:get("textTitle"):text(gLanguageCsv.addedBonus):x(624)
		end
	else
		local var_19_1 = string.format(gLanguageCsv.battleTimes, arg_19_1)

		if arg_19_0.from == "allGate" then
			local var_19_2 = arg_19_0.sweepData[arg_19_1].gateId
			local var_19_3 = csv.scene_conf
			local var_19_4 = csv.world_map
			local var_19_5 = var_19_3[var_19_2].ownerId
			local var_19_6 = 0

			for iter_19_0, iter_19_1 in ipairs(var_19_4[var_19_5].seq) do
				if var_19_2 == iter_19_1 then
					var_19_6 = iter_19_0
				end
			end

			if arg_19_0.prenumb1 == var_19_5 and arg_19_0.prenumb2 == var_19_6 then
				arg_19_0.sweepTimes = arg_19_0.sweepTimes + 1
			else
				arg_19_0.sweepTimes = 1
			end

			arg_19_0.prenumb1 = var_19_5
			arg_19_0.prenumb2 = var_19_6
			var_19_1 = string.format(gLanguageCsv.battleTimes, arg_19_0.sweepTimes)

			var_19_0:get("textGate"):text(string.format(gLanguageCsv.allBattleTimes, var_19_5 - 110, var_19_6))
			text.addEffect(var_19_0:get("textGate"), {
				outline = {
					size = 4,
					color = cc.c4b(234, 67, 22, 255)
				}
			})
			var_19_0:get("textGate"):show()
		else
			var_19_0:get("textGate"):hide()
		end

		if arg_19_0.from == "endlessTower" and not arg_19_4 then
			var_19_1 = csv.endless_tower_scene[arg_19_0.startGateId + arg_19_1 - 1].sceneName
		end

		if arg_19_4 then
			var_19_1 = gLanguageCsv.totalGot
		end

		if arg_19_0.gateId and dataEasy.getWorldLevelExpAdd(math.floor(arg_19_0.gateId / 10000)) then
			var_19_0:get("textTitle"):text(var_19_1)

			local var_19_7 = csv.scene_conf[arg_19_0.gateId].roleExp
			local var_19_8 = arg_19_2 - var_19_7

			var_19_0:get("textExpNum"):text("+" .. var_19_7 .. "(+" .. var_19_8 .. ")")
		else
			var_19_0:get("textTitle"):text(var_19_1)
			var_19_0:get("textExpNum"):text("+" .. arg_19_2)
		end

		if arg_19_0.from == "union" then
			var_19_0:get("textExpNum"):text(arg_19_2)
			var_19_0:get("textExpNote"):text(gLanguageCsv.percentageOfInjuries)
			adapt.oneLinePos(var_19_0:get("textExpNote"), var_19_0:get("textExpNum"), cc.p(20, 0), "left")
		end

		if arg_19_0.from == "dailyAssistant" then
			local var_19_9 = ""
			local var_19_10 = ""
			local var_19_11 = string.format(gLanguageCsv.totalTodo, arg_19_2)

			if arg_19_5.hasTitle then
				var_19_9 = arg_19_5.hasTitle
			else
				local var_19_12 = arg_19_5.feature

				var_19_9 = gDailyAssistantCsv[var_19_12].cfg.name

				if var_19_12 == "endlessTower" then
					var_19_11 = string.format(gLanguageCsv.totalReset, arg_19_2)
				elseif var_19_12 == "catch" then
					local var_19_13 = arg_19_5.win or 0
					local var_19_14 = arg_19_5.fail or 0

					var_19_11 = string.format(gLanguageCsv.successAndFailTimes, var_19_13, var_19_14)
				elseif var_19_12 == "unionFuben" then
					var_19_11 = gLanguageCsv.percentageOfInjuries
					var_19_10 = arg_19_2
				end
			end

			var_19_0:get("textTitle"):text(var_19_9)
			var_19_0:get("textExpNum"):text(var_19_10)
			var_19_0:get("textExpNote"):text(var_19_11)
			adapt.oneLinePos(var_19_0:get("textTitle"), {
				var_19_0:get("textExpNote"),
				var_19_0:get("textExpNum")
			}, cc.p(20, 0), "left")
		end
	end

	var_19_0:get("textExpNum"):visible(arg_19_2 ~= 0)
	var_19_0:get("textExpNote"):visible(arg_19_2 ~= 0)

	return var_19_0
end

function var_0_3.onAgainClick(arg_20_0)
	local var_20_0 = arg_20_0.checkCb

	if var_20_0 and not var_20_0() then
		return
	end

	arg_20_0:addCallbackOnExit(arg_20_0.cb)
	var_0_2.onClose(arg_20_0)
end

function var_0_3.onSpeedClick(arg_21_0)
	if arg_21_0.canClose then
		arg_21_0:onClose()
	else
		arg_21_0.interval = 0
	end
end

function var_0_3.onitemClick(arg_22_0, arg_22_1, arg_22_2)
	gGameUI:showItemDetail(arg_22_1, {
		key = "card",
		num = arg_22_2
	})
end

return var_0_3
