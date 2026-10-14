local var_0_0 = {
	"city/adventure/endless_tower/bg_1.jpg",
	"city/adventure/endless_tower/bg_2.jpg",
	"city/adventure/endless_tower/bg_3.jpg"
}
local var_0_1 = display.maxWidth
local var_0_2 = 110
local var_0_3 = 10
local var_0_4 = cc.load("mvc").ViewBase
local var_0_5 = class("EndlessTowerView", var_0_4)

var_0_5.RESOURCE_FILENAME = "endless_tower.json"
var_0_5.RESOURCE_BINDING = {
	item = "item",
	scroll = "scroll",
	downScroll = "downScroll",
	effectPanel = "effectPanel",
	["leftDown.btnRank"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRankShow")
			}
		}
	},
	["leftDown.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleShow")
			}
		}
	},
	["leftDown.btnRank.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["leftDown.btnRule.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightDown.btnSweep"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSweep")
			}
		}
	},
	["rightDown.btnSweep.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["rightDown.btnReset.textNote"] = {
		varname = "textNote",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["rightDown.btnReset.textNum"] = {
		varname = "textNum",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["rightDown.btnReset"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onReset")
			}
		}
	},
	marqueePanel = {
		varname = "marqueePanel",
		binds = {
			event = "extend",
			class = "marquee"
		}
	}
}

function var_0_5.onCreate(arg_1_0)
	arg_1_0.scroll:size(display.sizeInViewRect):x(display.sizeInViewRect.x)
	arg_1_0.downScroll:size(display.sizeInViewRect):x(display.sizeInViewRect.x)
	arg_1_0:initModel()
	gGameUI.topuiManager:createView("default", arg_1_0, {
		onClose = arg_1_0:createHandler("onClose")
	}):init({
		subTitle = "UNLIMITED CHALLENGE",
		title = "common/txt/txt_bt_chengzhangzhilu.png"
	})

	arg_1_0.selEffect = CSprite.new("level/xuanguan.skel")

	arg_1_0.selEffect:play("effect_loop")
	arg_1_0.selEffect:scale(1.3)
	arg_1_0.selEffect:visible(false)
	arg_1_0.selEffect:retain()

	arg_1_0.bossEffect = CSprite.new("huoyankuang/huoyankuang.skel")

	arg_1_0.bossEffect:play("effect_loop")
	arg_1_0.bossEffect:visible(false)
	arg_1_0.bossEffect:retain()
	arg_1_0.scroll:setScrollBarEnabled(false)
	arg_1_0.downScroll:setScrollBarEnabled(false)

	arg_1_0.selIdx = 0

	arg_1_0:buildScroll()

	arg_1_0.selGateIdx = idler.new(0)

	arg_1_0:buildItem()
	idlereasy.when(arg_1_0.selGateIdx, function(arg_2_0, arg_2_1)
		local var_2_0 = arg_1_0.scroll:getChildByName("gate" .. arg_2_1)

		if not var_2_0 then
			return
		end

		var_2_0:get("baseNode.info.mask"):hide()

		if not arg_1_0.isMax then
			var_2_0:get("baseNode.imgFlag"):hide()
		else
			var_2_0:get("baseNode.imgFlag"):show()
		end

		if arg_1_0.selEffect:getParent() then
			arg_1_0.selEffect:removeFromParent()
			arg_1_0.bossEffect:removeFromParent()
		end

		local var_2_1 = cc.p(200, 10)

		if arg_2_1 % 5 == 0 then
			var_2_1 = cc.p(198, -12)

			arg_1_0.bossEffect:addTo(var_2_0:get("baseNode"), 1)
			arg_1_0.bossEffect:xy(cc.p(198, 18))
			arg_1_0.bossEffect:visible(true)
			arg_1_0.bossEffect:z(10):scale(0.6)
		end

		arg_1_0.selEffect:addTo(var_2_0, 100)
		arg_1_0.selEffect:xy(var_2_1)
		arg_1_0.selEffect:visible(true)

		arg_1_0.selIdx = arg_2_1
	end)
	idlereasy.when(arg_1_0.resetCount, function(arg_3_0, arg_3_1)
		local var_3_0 = gVipCsv[arg_1_0.vip:read()].endlessTowerResetTimes
		local var_3_1 = var_3_0 - arg_1_0.resetCount:read()

		arg_1_0.textNum:text(string.format("(%d/%d)", var_3_1, var_3_0))
		adapt.oneLineCenterPos(cc.p(111, 39), {
			arg_1_0.textNote,
			arg_1_0.textNum
		}, cc.p(0, 0))
	end)
	idlereasy.when(arg_1_0.curChallengeId, function(arg_4_0, arg_4_1)
		local var_4_0

		if arg_4_1 == 0 then
			var_4_0 = 1
		else
			local var_4_1 = 0

			for iter_4_0, iter_4_1 in orderCsvPairs(csv.endless_tower_scene) do
				var_4_1 = var_4_1 + 1

				if arg_4_1 > 0 and iter_4_0 == arg_4_1 then
					var_4_0 = var_4_1

					break
				end
			end

			var_4_0 = var_4_0 or var_4_1
		end

		arg_1_0.selGateIdx:set(var_4_0)

		arg_1_0.curGateIdx = var_4_0

		arg_1_0:jumpScroll()
	end)
	arg_1_0:enableMessage():registerMessage("nextGate", functools.partial(arg_1_0.onNextGate, arg_1_0))
	arg_1_0:quickFor()
end

function var_0_5.initModel(arg_5_0)
	arg_5_0.roleLv = gGameModel.role:getIdler("level")
	arg_5_0.vip = gGameModel.role:getIdler("vip_level")
	arg_5_0.maxChallengeGate = gGameModel.role:getIdler("endless_tower_max_gate")
	arg_5_0.curChallengeId = gGameModel.role:getIdler("endless_tower_current")
	arg_5_0.resetCount = gGameModel.daily_record:getIdler("endless_tower_reset_times")
	arg_5_0.rmb = gGameModel.role:getIdler("rmb")

	arg_5_0:initData()
end

function var_0_5.initData(arg_6_0)
	local var_6_0 = arg_6_0.maxChallengeGate:read()
	local var_6_1 = arg_6_0.curChallengeId:read()
	local var_6_2 = 0

	if var_6_0 == 0 then
		arg_6_0.curMaxIdx = 0
		var_6_2 = var_0_3
	end

	local var_6_3 = {}
	local var_6_4 = 0
	local var_6_5 = false

	arg_6_0.factIndex = 0

	local var_6_6 = csvSize(csv.endless_tower_scene)

	for iter_6_0, iter_6_1 in orderCsvPairs(csv.endless_tower_scene) do
		var_6_4 = var_6_4 + 1

		local var_6_7 = {
			cfg = iter_6_1,
			csvId = iter_6_0
		}

		if var_6_0 > 0 and iter_6_0 == var_6_0 then
			var_6_2 = math.max(var_6_4 + 2, var_0_3)
			var_6_2 = math.min(var_6_6, var_6_2)
			arg_6_0.curMaxIdx = var_6_4
		end

		if not var_6_5 then
			table.insert(var_6_3, var_6_7)
		end

		if iter_6_0 == var_6_1 then
			arg_6_0.curGateIdx = var_6_4
			arg_6_0.factIndex = math.max(var_6_4 + 2, var_0_3)
			arg_6_0.factIndex = math.min(var_6_6, arg_6_0.factIndex)

			if var_6_0 < var_6_1 then
				arg_6_0.factIndex = math.min(arg_6_0.factIndex, var_6_2)
			end
		end

		if arg_6_0.factIndex ~= 0 and var_6_4 == arg_6_0.factIndex then
			var_6_5 = true
		end

		if var_6_4 == var_6_2 then
			break
		end
	end

	if arg_6_0.factIndex == 0 and var_6_1 then
		arg_6_0.factIndex = var_6_6
		arg_6_0.curGateIdx = arg_6_0.factIndex
		arg_6_0.isMax = true
	else
		arg_6_0.isMax = false
	end

	arg_6_0.gateInfos = var_6_3
	arg_6_0.dataLenght = #var_6_3
end

function var_0_5.addBgAndGrid(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.scroll:size()
	local var_7_1 = math.abs(arg_7_0.scroll:getInnerContainer():x())
	local var_7_2 = math.floor(var_7_1 / var_0_1)

	for iter_7_0 = 1, 2 do
		local var_7_3 = ccui.ImageView:create(var_0_0[iter_7_0])

		var_7_3:scale(2)

		local var_7_4 = var_7_3:size()

		var_7_3:xy(var_0_1 / 2 + (iter_7_0 - 1 + var_7_2) * var_0_1, var_7_4.height)
		arg_7_0.downScroll:addChild(var_7_3, -1, "bgDown" .. iter_7_0)
	end
end

function var_0_5.addItem(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0.item:clone()

	var_8_0:xy(arg_8_1.cfg.bg_boss_pos.x, arg_8_1.cfg.bg_boss_pos.y)

	local var_8_1 = false

	if arg_8_2 % 5 == 0 then
		local var_8_2 = -27
		local var_8_3 = -240
		local var_8_4 = true

		var_8_0:get("baseNode.info"):scale(1.2)
		var_8_0:size(450 + var_8_2, 320 + var_8_3)
		var_8_0:get("baseNode.textGate"):xy(225 + var_8_2, 73 + var_8_3)
		var_8_0:get("baseNode.imgRedPoint"):xy(225 + var_8_2, -94)
		var_8_0:get("baseNode.info"):xy(225 + var_8_2, 283 + var_8_3)
		var_8_0:get("baseNode.imgFlag"):y(394 + var_8_3)
		var_8_0:get("baseNode.imgBoss"):texture(bossPath):scale(0.7)
		var_8_0:get("baseNode.imgBoss"):visible(var_8_4):y(292 + var_8_3)
	end

	arg_8_0.scroll:addChild(var_8_0, arg_8_2, "gate" .. arg_8_2)
	var_8_0:get("baseNode.textGate"):text(arg_8_1.cfg.sceneName)
	var_8_0:get("baseNode.imgFlag"):visible(arg_8_0.isMax or arg_8_2 < arg_8_0.curGateIdx)
	var_8_0:get("baseNode.info.imgSel"):visible(arg_8_2 == arg_8_0.curGateIdx)

	local var_8_5 = "city/adventure/endless_tower/panel_icon_7.png"
	local var_8_6 = "city/adventure/endless_tower/panel_icon_boss0.png"

	if arg_8_3 then
		var_8_5 = "city/adventure/endless_tower/panel_icon_6.png"

		local var_8_7 = "city/adventure/endless_tower/panel_icon_boss1.png"

		var_8_0:get("baseNode.info.mask"):hide()
	else
		var_8_0:get("baseNode.imgFlag"):hide()
		var_8_0:get("baseNode.info.mask"):show()
	end

	var_8_0:get("baseNode.info.imgBG"):texture(var_8_5)
	var_8_0:get("baseNode.info.imgIcon"):texture(arg_8_1.cfg.icon)
	var_8_0:show()
	bind.touch(arg_8_0, var_8_0:get("baseNode"), {
		methods = {
			ended = function(arg_9_0, arg_9_1, arg_9_2)
				arg_8_0:onItemClick(arg_8_2, arg_8_1)
			end
		}
	})

	if arg_8_2 == arg_8_0.curGateIdx then
		arg_8_0.selGateIdx:set(arg_8_2, true)
	end

	return var_8_0
end

function var_0_5.addCurItemDirection(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_2 >= arg_10_0.dataLenght then
		return
	end

	local var_10_0 = "city/adventure/endless_tower/icon_arrow0.png"

	if arg_10_3 then
		var_10_0 = "city/adventure/endless_tower/icon_arrow.png"
	end

	local var_10_1 = arg_10_2 % 3
	local var_10_2 = 0
	local var_10_3 = cc.p(520, 50)

	if var_10_1 == 1 then
		var_10_2 = 45
		var_10_3 = cc.p(380, -140)
	elseif var_10_1 == 0 then
		var_10_2 = -45
		var_10_3 = cc.p(480, 240)
	end

	local var_10_4 = cc.Sprite:create(var_10_0)

	var_10_4:setRotation(var_10_2)
	var_10_4:xy(var_10_3)
	arg_10_1:addChild(var_10_4, -1)
end

function var_0_5.onItemClick(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_1 > arg_11_0.curGateIdx then
		gGameUI:showTip(gLanguageCsv.challengeLastGate)

		return
	end

	local var_11_0 = arg_11_0.scroll:getChildByName("gate" .. arg_11_0.selIdx)

	if var_11_0 then
		var_11_0:get("baseNode.info.imgSel"):visible(false)
	end

	local var_11_1 = arg_11_0.scroll:getChildByName("gate" .. arg_11_1)

	if var_11_1 then
		var_11_1:get("baseNode.info.imgSel"):visible(true)
	end

	arg_11_0.selIdx = arg_11_1

	gGameUI:stackUI("city.adventure.endless_tower.gate_detail", nil, nil, arg_11_1, arg_11_2.csvId, arg_11_0:createHandler("refreshGateState"))
end

function var_0_5.buildItem(arg_12_0)
	arg_12_0:addItem(arg_12_0.gateInfos[arg_12_0.curGateIdx], arg_12_0.curGateIdx, arg_12_0.curGateIdx <= arg_12_0.factIndex)

	local function var_12_0()
		local var_13_0 = arg_12_0.curGateIdx - 1
		local var_13_1 = arg_12_0.curGateIdx + 1
		local var_13_2 = math.min(arg_12_0.factIndex, csvSize(csv.endless_tower_scene))

		while var_13_0 > 0 or var_13_1 <= var_13_2 do
			if var_13_0 > 0 then
				arg_12_0:addItem(arg_12_0.gateInfos[var_13_0], var_13_0, var_13_0 <= arg_12_0.curGateIdx)

				var_13_0 = var_13_0 - 1
			end

			if var_13_1 <= var_13_2 then
				arg_12_0:addItem(arg_12_0.gateInfos[var_13_1], var_13_1, var_13_1 <= arg_12_0.curGateIdx)

				var_13_1 = var_13_1 + 1
			end

			coroutine.yield()
		end
	end

	arg_12_0:enableAsyncload():asyncFor(var_12_0, nil, 4)
end

function var_0_5.buildScroll(arg_14_0)
	local var_14_0 = arg_14_0.scroll:size()
	local var_14_1 = math.ceil(var_14_0.width / 110)
	local var_14_2 = 110 * var_14_1
	local var_14_3 = (var_14_0.width - 50 - 450) / 4
	local var_14_4 = 250 + (math.min(csvSize(csv.endless_tower_scene), arg_14_0.factIndex) - 1) * var_14_3 + 300
	local var_14_5 = var_14_0.height
	local var_14_6 = math.max(var_14_4, var_14_0.width)
	local var_14_7 = arg_14_0.scroll:getInnerContainer()

	var_14_7:size(var_14_6, var_14_5)
	arg_14_0.downScroll:getInnerContainer():size(var_14_6, var_14_5)
	arg_14_0.scroll:setTouchEnabled(var_14_6 ~= var_14_0.width)
	arg_14_0:addBgAndGrid(var_14_1)

	local var_14_8 = 1
	local var_14_9 = var_14_1
	local var_14_10
	local var_14_11
	local var_14_12

	arg_14_0.scroll:onEvent(function(arg_15_0)
		if arg_15_0.name == "CONTAINER_MOVED" then
			local var_15_0 = arg_14_0.scroll:getScrolledPercentHorizontal()

			var_14_12 = var_14_12 or var_15_0

			arg_14_0.downScroll:jumpToPercentHorizontal(var_15_0)

			if var_14_12 - var_15_0 > 0 then
				var_14_10 = "right"
				var_14_11 = var_14_9
			elseif var_14_12 - var_15_0 < 0 then
				var_14_10 = "left"
				var_14_11 = var_14_8
			else
				local var_15_1 = arg_15_0.target:getTouchBeganPosition()
				local var_15_2 = arg_15_0.target:getTouchMovePosition()

				if var_15_2.x - var_15_1.x > 0 then
					var_14_10 = "right"
					var_14_11 = var_14_9
				elseif var_15_2.x - var_15_1.x < 0 or var_15_1.x == 0 and var_15_2.x == 0 then
					var_14_10 = "left"
					var_14_11 = var_14_8
				end
			end

			if not var_14_10 then
				var_14_12 = nil
				var_14_11 = nil

				return
			end

			var_14_12 = var_15_0

			local var_15_3 = math.abs(var_14_7:x())
			local var_15_4 = var_15_3 + var_14_0.width

			local function var_15_5(arg_16_0, arg_16_1)
				local var_16_0 = arg_16_1

				if arg_16_0 ~= "left" then
					var_16_0 = var_14_1 - arg_16_1
				end

				var_14_8 = (var_16_0 + var_14_8 - 1) % var_14_1 + 1
				var_14_9 = (var_16_0 + var_14_9 - 1) % var_14_1 + 1
			end

			local function var_15_6(arg_17_0)
				for iter_17_0 = 1, arg_17_0 do
					local var_17_0 = var_14_10 == "left" and (var_14_11 + iter_17_0 - 1) % var_14_1 or (var_14_11 - iter_17_0 + 1) % var_14_1

					var_17_0 = var_17_0 == 0 and var_14_1 or var_17_0

					local var_17_1 = arg_14_0.scroll:getChildByName("item" .. var_17_0)

					if var_17_1 then
						if var_14_10 == "left" then
							var_17_1:x(var_17_1:x() + var_14_2)
						else
							var_17_1:x(var_17_1:x() - var_14_2)
						end
					end
				end
			end

			local var_15_7 = arg_14_0.scroll:getChildByName("item" .. var_14_11)

			if var_15_7 then
				local var_15_8 = var_15_7:x()

				var_15_8 = var_14_10 == "left" and var_15_8 - var_0_2 / 2 or var_15_8 + var_0_2 / 2

				if var_14_10 == "left" and var_15_3 > var_15_8 + var_0_2 then
					local var_15_9 = math.ceil((var_15_3 - (var_15_8 + var_0_2)) / var_0_2)

					var_15_5(var_14_10, var_15_9)
					var_15_6(var_15_9)

					var_14_11 = var_14_8
				elseif var_14_10 == "right" and var_15_4 < var_15_8 - var_0_2 then
					local var_15_10 = math.ceil((var_15_8 - var_0_2 - var_15_4) / var_0_2)

					var_15_5(var_14_10, var_15_10)
					var_15_6(var_15_10)

					var_14_11 = var_14_9
				end
			end

			local var_15_11 = arg_14_0.downScroll:getChildByName("bgDown1")
			local var_15_12 = arg_14_0.downScroll:getChildByName("bgDown2")
			local var_15_13 = var_15_11:x()
			local var_15_14 = var_15_12:x()
			local var_15_15 = math.min(var_15_13, var_15_14) - var_0_1 / 2
			local var_15_16 = math.max(var_15_13, var_15_14) + var_0_1 / 2
			local var_15_17 = arg_14_0.downScroll:getChildByName("bgDown1")
			local var_15_18 = arg_14_0.downScroll:getChildByName("bgDown2")
			local var_15_19 = false

			if var_15_16 < var_15_4 then
				var_15_19 = true

				if var_15_14 < var_15_13 then
					var_15_18, var_15_17 = var_15_17, var_15_18
				end

				local var_15_20 = math.ceil((var_15_4 - var_15_16) / var_0_1)

				var_15_17:x(var_15_17:x() + var_0_1 * (var_15_20 + 1))
				var_15_18:x(var_15_18:x() + var_0_1 * (var_15_20 - 1))
			end

			if var_15_3 < var_15_15 then
				var_15_19 = true

				if var_15_13 < var_15_14 then
					var_15_18, var_15_17 = var_15_17, var_15_18
				end

				local var_15_21 = math.ceil((var_15_15 - var_15_3) / var_0_1)

				var_15_17:x(var_15_17:x() - var_0_1 * (var_15_21 + 1))
				var_15_18:x(var_15_18:x() - var_0_1 * (var_15_21 - 1))
			end

			if var_15_19 then
				local var_15_22 = false
				local var_15_23 = math.ceil(var_15_17:x() / var_0_1) % 3

				var_15_23 = var_15_23 == 0 and 3 or var_15_23

				var_15_17:texture(var_0_0[var_15_23])

				local var_15_24 = math.ceil(var_15_18:x() / var_0_1) % 3

				var_15_24 = var_15_24 == 0 and 3 or var_15_24

				var_15_18:texture(var_0_0[var_15_24])
			end
		elseif arg_15_0.name == "AUTOSCROLL_ENDED" or arg_15_0.name == "SCROLLING_ENDED" then
			var_14_10 = nil
			var_14_11 = nil
			var_14_12 = nil
		end
	end)
end

function var_0_5.refreshGateState(arg_18_0)
	arg_18_0.scroll:removeAllChildren()
	arg_18_0:initData()
	arg_18_0:buildItem()
	arg_18_0:buildScroll()
	arg_18_0:jumpScroll()
end

function var_0_5.onReset(arg_19_0)
	if gVipCsv[arg_19_0.vip:read()].endlessTowerResetTimes - arg_19_0.resetCount:read() <= 0 then
		gGameUI:showTip(gLanguageCsv.resetTimesNotEnough)

		return
	end

	if arg_19_0.curGateIdx == 1 then
		gGameUI:showTip(gLanguageCsv.cannotResetGate)

		return
	end

	local var_19_0 = math.min(arg_19_0.resetCount:read() + 1, table.length(gCostCsv.endless_tower_reset_times_cost))
	local var_19_1 = gCostCsv.endless_tower_reset_times_cost[var_19_0]
	local var_19_2 = {
		clearFast = true,
		btnType = 2,
		cb = function()
			if var_19_1 > 0 and arg_19_0.rmb:read() < var_19_1 then
				uiEasy.showDialog("rmb")

				return
			end

			gGameApp:requestServer("/game/endless/reset", function()
				arg_19_0:refreshGateState()
			end)
		end,
		isRich = var_19_1 ~= 0,
		content = var_19_1 == 0 and gLanguageCsv.resetGate or string.format(gLanguageCsv.endlessTowerResetCost, var_19_1),
		dialogParams = {
			clickClose = false
		}
	}

	gGameUI:showDialog(var_19_2)
end

function var_0_5.onSweep(arg_22_0)
	if arg_22_0.curGateIdx > arg_22_0.curMaxIdx or arg_22_0.isMax then
		gGameUI:showTip(gLanguageCsv.cannotSweep)

		return
	end

	local var_22_0 = gGameModel.capture:read("limit_sprites")
	local var_22_1 = {
		isRich = false,
		clearFast = true,
		btnType = 2,
		cb = function()
			local var_23_0 = arg_22_0.curChallengeId:read()
			local var_23_1 = arg_22_0.curGateIdx

			gGameApp:requestServer("/game/endless/saodang", function(arg_24_0)
				local var_24_0 = {}

				for iter_24_0, iter_24_1 in ipairs(arg_24_0.view.result) do
					local var_24_1 = {
						items = {}
					}

					for iter_24_2, iter_24_3 in pairs(iter_24_1) do
						if iter_24_2 ~= "gold" then
							var_24_1.items[iter_24_2] = iter_24_3
						else
							var_24_1.gold = iter_24_3
						end
					end

					table.insert(var_24_0, var_24_1)
				end

				local var_24_2 = {
					isTotal = true,
					items = {}
				}

				for iter_24_4, iter_24_5 in ipairs(dataEasy.mergeRawDate(arg_24_0.view.result)) do
					if iter_24_5.key ~= "gold" then
						var_24_2.items[iter_24_5.key] = iter_24_5.num
					else
						var_24_2.gold = iter_24_5.num
					end
				end

				table.insert(var_24_0, var_24_2)
				arg_22_0:refreshGateState()
				gGameUI:stackUI("city.gate.sweep", nil, nil, {
					showType = 2,
					from = "endlessTower",
					hasExtra = false,
					sweepData = var_24_0,
					oldRoleLv = arg_22_0.roleLv:read(),
					startGateId = var_23_0,
					oldCapture = var_22_0,
					isDouble = dataEasy.isDoubleHuodong("endlessSaodang")
				})
			end)
		end,
		content = string.format(gLanguageCsv.sweepGate, arg_22_0.curMaxIdx)
	}

	gGameUI:showDialog(var_22_1)
end

function var_0_5.jumpScroll(arg_25_0)
	local var_25_0 = arg_25_0.selGateIdx:read()
	local var_25_1 = arg_25_0.scroll:getChildByName("gate" .. var_25_0)

	if not var_25_1 then
		return
	end

	local var_25_2 = var_25_1:x()
	local var_25_3 = arg_25_0.scroll:getInnerContainer():size()
	local var_25_4 = arg_25_0.scroll:size().width
	local var_25_5 = (var_25_2 - var_25_4 / 2) / (var_25_3.width - var_25_4) * 100
	local var_25_6 = math.min(var_25_5, 100)
	local var_25_7 = math.max(var_25_6, 0)

	arg_25_0.scroll:scrollToPercentHorizontal(var_25_7, 0.01, false)
end

function var_0_5.onRankShow(arg_26_0)
	gGameApp:requestServer("/game/rank", function(arg_27_0)
		gGameUI:stackUI("city.adventure.endless_tower.rank", nil, nil, arg_27_0.view.rank)
	end, "endless", 0, 50)
end

function var_0_5.onCleanup(arg_28_0)
	if arg_28_0.selEffect then
		arg_28_0.selEffect:release()
	end

	if arg_28_0.bossEffect then
		arg_28_0.bossEffect:release()
	end

	var_0_4.onCleanup(arg_28_0)
end

function var_0_5.onNextGate(arg_29_0, arg_29_1)
	return arg_29_0:onItemClick(arg_29_1, arg_29_0.gateInfos[arg_29_1])
end

function var_0_5.onRuleShow(arg_30_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_30_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_5.getRuleContext(arg_31_0, arg_31_1)
	local var_31_0 = adaptContext

	return {
		var_31_0.clone(arg_31_1.title, function(arg_32_0)
			arg_32_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_31_0.noteText(57001, 57005)
	}
end

return var_0_5
