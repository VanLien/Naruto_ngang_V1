local var_0_0 = table.insert
local var_0_1 = 1907061635
local var_0_2 = class("GuideManager")

var_0_2.NextGuideActionTag = var_0_1

local var_0_3 = {}

var_0_3.RESOURCE_FILENAME = "common_guide.json"
var_0_3.RESOURCE_BINDING = {
	btnR = "btnR",
	skipBtn = "skipBtn",
	btnL = "btnL",
	box = "box"
}
var_0_2.GuideView = var_0_3

local var_0_4 = {}

var_0_4.RESOURCE_FILENAME = "battle_story_panel.json"
var_0_4.RESOURCE_BINDING = {
	bg = "bg",
	skipBtn = "skipBtn",
	textBkg = "textBkg",
	nameL = "nameL",
	texL = "texL",
	texR = "texR",
	listSelect = "listSelect",
	nameR = "nameR",
	selectItem = "selectItem",
	textAarea = "textAarea"
}
var_0_2.BattleStoryPanelView = var_0_4

local var_0_5 = {
	["common.upgrade_notice"] = true,
	["battle.battle_end.random_win"] = true,
	["battle.battle_end.win"] = true
}

function var_0_2.ctor(arg_1_0)
	arg_1_0.curGuideId = nil
	arg_1_0.inGuiding = false
	arg_1_0.guidePanel = nil
	arg_1_0.ignoreGuide = false
	arg_1_0.choicesFunc = nil
	arg_1_0.guideCsv = csv.new_guide
	arg_1_0.stageCsv = gGuideStageCsv
end

function var_0_2.setIgnoreGuide(arg_2_0, arg_2_1)
	arg_2_0.ignoreGuide = arg_2_1

	return arg_2_0
end

function var_0_2.checkFinished(arg_3_0, arg_3_1)
	local var_3_0 = gGameModel.role:read("newbie_guide")

	for iter_3_0, iter_3_1 in ipairs(var_3_0) do
		if arg_3_1 == iter_3_1 then
			return true
		end
	end

	return false
end

function var_0_2.isInGuiding(arg_4_0)
	return arg_4_0.inGuiding, arg_4_0.curGuideId
end

function var_0_2.onClose(arg_5_0)
	gGameUI.scene:stopAllActionsByTag(var_0_1)
	arg_5_0:cleanGuidePanel()

	arg_5_0.inGuiding = false

	gGameUI.guideLayer:stopAllActions()
	gGameUI.guideLayer:hide()
end

function var_0_2.forceClose(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:onClose()
	gGameUI:removeAllDelayTouchDispatch()

	if arg_6_2 then
		for iter_6_0, iter_6_1 in orderCsvPairs(arg_6_0.guideCsv) do
			if iter_6_1.startSceen == arg_6_2 then
				arg_6_1 = iter_6_1.stage

				break
			end
		end
	end

	if arg_6_1 and not arg_6_0:checkFinished(arg_6_1) then
		arg_6_0:onSaveStage(nil, arg_6_1)
	end
end

function var_0_2.onCleanup(arg_7_0)
	arg_7_0.orderStageCsv = nil
end

function var_0_2.onSaveStage(arg_8_0, arg_8_1, arg_8_2)
	gGameApp:requestServer("/game/role/guide/newbie", arg_8_1, arg_8_2)
end

function var_0_2.checkGuide(arg_9_0, arg_9_1)
	arg_9_1 = arg_9_1 or {}

	log.guide("check name:", arg_9_1.name, "isInGuiding:", arg_9_0:isInGuiding(), arg_9_0.ignoreGuide, arg_9_0.continueLastGuide)

	if dev.GUIDE_CLOSED or FOR_SHENHE or arg_9_0.ignoreGuide then
		return
	end

	if gGameUI.rootViewName == "login.view" then
		return
	end

	local var_9_0 = gGameModel.role:read("newbie_guide")

	if not var_9_0 then
		return
	end

	if arg_9_0:isInGuiding() then
		return
	end

	if not arg_9_1.specialName and arg_9_0:checkFinished(-2) then
		return
	end

	if arg_9_0.continueLastGuide then
		arg_9_0.curGuideId = arg_9_0.continueLastGuide
		arg_9_0.continueLastGuide = nil
		arg_9_0.inGuiding = true

		arg_9_0:nextGuide()

		return true
	end

	arg_9_0.curGuideId = nil

	if not arg_9_0.orderStageCsv then
		arg_9_0.orderStageCsv = {}

		local var_9_1 = arraytools.hash(var_9_0)

		for iter_9_0, iter_9_1 in pairs(arg_9_0.stageCsv) do
			if not var_9_1[iter_9_0] then
				var_0_0(arg_9_0.orderStageCsv, arg_9_0.guideCsv[iter_9_1.begin])
			end
		end

		table.sort(arg_9_0.orderStageCsv, function(arg_10_0, arg_10_1)
			if arg_10_0.order ~= arg_10_1.order then
				return arg_10_0.order < arg_10_1.order
			end

			return arg_10_0.stage < arg_10_1.stage
		end)
	end

	for iter_9_2, iter_9_3 in ipairs(arg_9_0.orderStageCsv) do
		if arg_9_0:canTriggerGuide(iter_9_3, arg_9_1) then
			table.remove(arg_9_0.orderStageCsv, iter_9_2)
			arg_9_0:triggerGuide(iter_9_3.id, arg_9_1)

			return true
		end
	end

	if var_0_5[arg_9_1.name] then
		arg_9_0:checkGuide({
			name = "all"
		})
	end
end

function var_0_2.canTriggerGuide(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_0:checkFinished(arg_11_1.stage) then
		return false
	end

	local var_11_0 = arg_11_0.stageCsv[arg_11_1.stage]

	if arg_11_2.specialName ~= var_11_0.specialName then
		return false
	end

	if arg_11_2.specialName or arg_11_1.startSceen == "all" and arg_11_2.name == "city.view" then
		-- block empty
	elseif (arg_11_1.startSceen or "city.view") ~= arg_11_2.name then
		return false
	end

	local var_11_1 = gGameModel.role:read("level")
	local var_11_2 = eval.doFormula(arg_11_1.extendCondition, {
		finish = functools.partial(arg_11_0.checkFinished, arg_11_0)
	}, arg_11_1.extendCondition)

	if arg_11_1.id ~= var_11_0.begin or not (var_11_1 >= arg_11_1.startLevel) or not dataEasy.isGateFinished(arg_11_1.startGate) or var_11_2 == false then
		return false
	end

	return true
end

function var_0_2.checkGateCondition(arg_12_0, arg_12_1)
	local var_12_0 = gGameModel.role:read("gate_star")
	local var_12_1 = arg_12_1.startGate

	if not var_12_1 or var_12_1 == 0 then
		return true
	end

	if var_12_0[var_12_1] and var_12_0[var_12_1].star and var_12_0[var_12_1].star > 0 then
		return true
	end

	return false
end

function var_0_2.triggerGuide(arg_13_0, arg_13_1, arg_13_2)
	log.guide(arg_13_2.log or "trigger:", arg_13_1)

	if arg_13_0.ignoreGuide then
		arg_13_0:onClose()

		return
	end

	local var_13_0 = arg_13_0.guideCsv[arg_13_1]

	arg_13_0.curGuideId = arg_13_1
	arg_13_0.inGuiding = true
	arg_13_0.continueLastGuide = nil

	if var_13_0.award or var_13_0.awardChoose then
		arg_13_0:quiteGiveAward(var_13_0, arg_13_1, arg_13_2)

		return
	end

	gGameUI.guideLayer:show()

	if var_13_0.battleEnter then
		arg_13_0:setBattleCardEnter(var_13_0.battleEnter)
	end

	gGameUI:disableTouchDispatch(nil, false)

	if var_13_0.showType == 3 then
		if var_13_0.outDelay or 0 > 0 then
			printWarn("guide 检查id(%d), 不应配置outDelay，尝试使用多个空白条", arg_13_1)
		end

		arg_13_0.continueLastGuide = arg_13_0.curGuideId

		arg_13_0:onClose()
		gGameUI:disableTouchDispatch(nil, true)
	else
		transition.executeSequence(gGameUI.guideLayer, true):delay(var_13_0.outDelay or 0):func(function()
			if var_13_0.showType == 2 then
				arg_13_0:showDialog(var_13_0, function(arg_15_0)
					arg_13_0:nextGuide(arg_15_0)
				end, arg_13_2)
				gGameUI:disableTouchDispatch(nil, true)
			else
				arg_13_0:showClickGuide(var_13_0, function()
					arg_13_0:nextGuide(arg_13_2)
				end)
			end
		end):done()
	end
end

function var_0_2.quiteGiveAward(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	gGameUI:disableTouchDispatch(0.01)
	performWithDelay(gGameUI.scene, function()
		gGameApp:requestServerCustom("/game/role/guide/newbie/award"):onErrCall(function()
			arg_17_0:forceClose()
		end):params(arg_17_2):doit(function(arg_20_0)
			local function var_20_0()
				if arg_17_3.awardCb then
					arg_17_3.awardCb()
				end

				arg_17_0:nextGuide(arg_17_3)
			end

			if arg_17_1.showAward then
				gGameUI.guideLayer:hide()
				gGameUI:showGainDisplay(arg_20_0, {
					cb = var_20_0
				})
			else
				var_20_0()
			end
		end)
	end, 0)
end

function var_0_2.nextGuide(arg_22_0, arg_22_1)
	if arg_22_0.ignoreGuide or not arg_22_0.curGuideId then
		arg_22_0:onClose()

		return
	end

	arg_22_1 = arg_22_1 or {}

	local var_22_0 = arg_22_0.guideCsv[arg_22_0.curGuideId]

	local function var_22_1()
		gGameUI:disableTouchDispatch(nil, true)

		if var_22_0.gotoScene ~= 0 then
			arg_22_0:jumpScene(var_22_0)
		end

		if arg_22_0.curGuideId then
			local var_23_0 = arg_22_1.nextId or arg_22_0.curGuideId + 1
			local var_23_1 = arg_22_0.guideCsv[var_23_0]

			if var_23_1 and var_22_0.stage == var_23_1.stage and var_23_0 ~= arg_22_1.endId then
				arg_22_1.nextId = nil

				arg_22_0:triggerGuide(var_23_0, arg_22_1)

				return
			end

			if var_22_0.gotoStep then
				arg_22_0:triggerGuide(var_22_0.gotoStep, arg_22_1)

				return
			end
		end

		arg_22_0:onClose()

		if arg_22_1.endCb then
			arg_22_1.endCb()
		else
			local var_23_2, var_23_3 = gGameUI:getTopStackUI()

			arg_22_0:checkGuide({
				name = var_23_3
			})
		end
	end

	gGameUI:disableTouchDispatch(nil, false)

	local var_22_2

	var_22_2 = schedule(gGameUI.scene, function()
		if not gGameUI:isConnecting() and var_22_2 then
			gGameUI.scene:stopAllActionsByTag(var_0_1)

			var_22_2 = nil

			if var_22_0.service == 3 then
				arg_22_0.inBattleStage = var_22_0.stage

				arg_22_0:onClose()
				gGameUI:disableTouchDispatch(nil, true)
			elseif var_22_0.service ~= 0 and not var_22_0.award and not var_22_0.awardChoose then
				arg_22_0:onSaveStage(function()
					if var_22_0.stage == 32 then
						-- block empty
					end

					var_22_1()
				end, var_22_0.stage)
			else
				var_22_1()
			end
		end
	end, 0)

	var_22_2:setTag(var_0_1)
end

function var_0_2.battleStageSave(arg_26_0, arg_26_1)
	if arg_26_0.inBattleStage then
		gGameModel:setNewGuideID(arg_26_0.inBattleStage)

		arg_26_0.inBattleStage = nil

		arg_26_1()
	else
		arg_26_1()
	end
end

function var_0_2.setBattleCardEnter(arg_27_0, arg_27_1)
	local var_27_0 = table.deepcopy(gGameModel.role:read("battle_cards"), true)

	for iter_27_0, iter_27_1 in csvMapPairs(arg_27_1) do
		if iter_27_1 == 0 then
			var_27_0[iter_27_0] = nil
		else
			local var_27_1 = dataEasy.getCardById(iter_27_1)

			if var_27_1 then
				var_27_0[iter_27_0] = var_27_1
			end
		end
	end

	gGameApp:requestServer("/game/battle/card", nil, var_27_0)
end

function var_0_2.jumpScene(arg_28_0, arg_28_1)
	gGameUI:cleanStash()

	if arg_28_1.gotoScene == 1 then
		arg_28_0:gotoCity()
	elseif arg_28_1.gotoScene == 2 then
		arg_28_0:gotoBattleMap()
	elseif arg_28_1.gotoScene >= 3 then
		arg_28_0:gotoBattleMap(arg_28_1.gotoScene)
	end
end

function var_0_2.gotoCity(arg_29_0)
	gGameUI:switchUI("city.view")
end

function var_0_2.gotoBattleMap(arg_30_0, arg_30_1)
	arg_30_0:gotoCity()
	jumpEasy.jumpTo("gate", arg_30_1)
end

function var_0_2.cleanGuidePanel(arg_31_0)
	if arg_31_0.guideView then
		arg_31_0.guideView:stopAllActions()
		arg_31_0.guideView:unScheduleAll()

		arg_31_0.guideView = nil
	end

	if arg_31_0.guidePanel then
		arg_31_0.guidePanel:removeFromParent()

		arg_31_0.guidePanel = nil
	end
end

function var_0_2.showDialog(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	arg_32_3 = arg_32_3 or {}

	if not gGameUI.guideLayer:get("dialog") then
		arg_32_0:cleanGuidePanel()

		arg_32_0.guidePanel = ccui.Layout:create():anchorPoint(0.5, 0.5):size(display.sizeInView.width, display.sizeInView.height):xy(display.size.width / 2, display.size.height / 2):addTo(gGameUI.guideLayer, 1, "dialog")

		arg_32_0.guidePanel:setBackGroundColorType(1)
		arg_32_0.guidePanel:setBackGroundColor(cc.c3b(0, 0, 0))
		arg_32_0.guidePanel:setBackGroundColorOpacity(150)
		arg_32_0.guidePanel:setTouchEnabled(true)

		arg_32_0.guideView = gGameUI:createSimpleView(var_0_4, arg_32_0.guidePanel):init()

		arg_32_0.guideView:x(display.uiOrigin.x)
		arg_32_0.guideView:enableSchedule()
		arg_32_0.guideView.skipBtn:hide()
		text.addEffect(arg_32_0.guideView.skipBtn:get("text"), {
			outline = {
				size = 4,
				color = ui.NEWCOLORS.OUTLINE.YELLOW
			}
		})

		local var_32_0 = arg_32_0.guideView:getResourceNode()

		var_32_0:setTouchEnabled(false)
		var_32_0:get("texL"):hide()
		var_32_0:get("texR"):hide()

		local var_32_1, var_32_2 = var_32_0:get("texL"):xy()

		arg_32_0.guideView.texLPos = cc.p(var_32_1, var_32_2)

		local var_32_3, var_32_4 = var_32_0:get("texR"):xy()

		arg_32_0.guideView.texRPos = cc.p(var_32_3, var_32_4)

		ccui.ImageView:create():addTo(var_32_0, 0, "bgRes"):anchorPoint(0.5, 0.5):xy(display.sizeInView.width / 2, display.sizeInView.height / 2):scale(2):hide()
	end

	local var_32_5 = arg_32_0.guidePanel
	local var_32_6 = arg_32_0.guideView:show()
	local var_32_7 = var_32_6:getResourceNode()

	if var_32_6.lastShowRecover then
		var_32_6.lastShowRecover()
	end

	if arg_32_1.bgRes then
		var_32_7:get("bgRes"):show():texture(arg_32_1.bgRes)
	else
		var_32_7:get("bgRes"):hide()
	end

	local var_32_8 = ""
	local var_32_9 = ""
	local var_32_10 = 1
	local var_32_11 = 0
	local var_32_12 = 0

	if arg_32_1.useRoleFigure then
		local var_32_13 = arg_32_1.useRoleFigure
		local var_32_14 = var_32_13[1]
		local var_32_15 = var_32_13[2] or "res"

		if var_32_14 == 0 then
			local var_32_16 = gGameModel.role:read("name") or ""
			local var_32_17 = gGameModel.role:read("figure") or 1

			var_32_8 = (gRoleFigureCsv[var_32_17] or {})[var_32_15]
			var_32_9 = var_32_16
		else
			local var_32_18 = gRoleFigureCsv[var_32_14] or {}

			var_32_8 = var_32_18[var_32_15]
			var_32_9 = var_32_18.name
		end

		var_32_10 = 1.3
	elseif arg_32_1.unitId then
		local var_32_19 = arg_32_1.unitId
		local var_32_20 = csv.unit[var_32_19] or {}

		var_32_8 = var_32_20.show
		var_32_9 = var_32_20.name
		var_32_10 = 1.77
		var_32_11 = -108
		var_32_12 = 676
	else
		var_32_8 = arg_32_1.headRes
		var_32_9 = arg_32_1.roleName
		var_32_10 = 1.3
	end

	local var_32_21 = arg_32_1.offPos or {}
	local var_32_22 = var_32_11 + (var_32_21.x or 0)
	local var_32_23 = var_32_12 + (var_32_21.y or 0)
	local var_32_24 = arg_32_1.force == 1
	local var_32_25 = var_32_24 and "L" or "R"
	local var_32_26 = var_32_24 and "R" or "L"

	var_32_6.nameL:hide()
	var_32_6.nameR:hide()

	if var_32_9 and var_32_9 ~= "" then
		var_32_7:get("name" .. var_32_25):show()
		var_32_7:get("name" .. var_32_25 .. ".name"):text(var_32_9)
		adapt.setTextScaleWithWidth(var_32_7:get("name" .. var_32_25 .. ".name"), nil, 450)
	end

	local var_32_27 = var_32_24 and 1 or -1
	local var_32_28 = var_32_6["tex" .. var_32_25 .. "Pos"]

	if var_32_8 and var_32_8 ~= "" then
		var_32_7:get("tex" .. var_32_25):show():texture(var_32_8):scale(var_32_27 * var_32_10 * 1.1, var_32_10 * 1.1):xy(var_32_28.x + var_32_22 * var_32_27, var_32_28.y + var_32_23)
	else
		var_32_7:get("tex" .. var_32_25):hide()
	end

	var_32_7:get("tex" .. var_32_25):color(cc.c3b(255, 255, 255))
	var_32_7:get("tex" .. var_32_26):color(cc.c3b(128, 128, 128))

	function var_32_6.lastShowRecover()
		var_32_7:get("tex" .. var_32_25):scale(var_32_27 * var_32_10, var_32_10)
	end

	local var_32_29 = "#C0xFFFFFF##F50#" .. arg_32_1.talkContent

	var_32_6.textAarea:removeChildByName("richText")

	local var_32_30 = var_32_6.textAarea:size()
	local var_32_31 = StreamRichText.new(var_32_29, var_32_30.width)
	local var_32_32 = var_32_31.raw
	local var_32_33 = var_32_31:getLen() + 20

	var_32_32:ignoreContentAdaptWithSize(false)

	local var_32_34 = var_32_32:getVirtualRendererSize()

	var_32_32:size(var_32_30.width, var_32_34.height):xy(0, var_32_30.height - 20):anchorPoint(0, 1):addTo(var_32_6.textAarea, 3, "richText")
	var_32_6:unSchedule("write")

	local var_32_35 = 1

	local function var_32_36()
		if var_32_35 == 1 then
			var_32_35 = 2

			var_32_31:showWithLen(var_32_33)
			var_32_32:formatText()
			var_32_6:unSchedule("write")
		end
	end

	local function var_32_37(arg_35_0, arg_35_1)
		if var_32_35 < 3 then
			var_32_35 = 3

			var_32_6.skipBtn:stopAllActions()
			var_32_6:unSchedule("write")
			var_32_6:hide()

			if arg_35_0 then
				arg_35_0(arg_35_1)
			end
		end
	end

	local var_32_38 = 1

	var_32_31:showWithLen(1)
	var_32_6:schedule(function()
		if var_32_38 > var_32_33 then
			var_32_36()

			return false
		end

		var_32_38 = var_32_38 + 1

		var_32_31:showWithLen(var_32_38)
		var_32_32:formatText()
	end, 0.02, 0, "write")

	local var_32_39 = type(arg_32_1.choices) == "table" and table.length(arg_32_1.choices) > 0

	arg_32_0.guideView.bg:visible(not var_32_39)
	var_32_6.listSelect:visible(var_32_39)

	if var_32_39 and arg_32_1.showType ~= 3 then
		local var_32_40 = {}

		for iter_32_0, iter_32_1 in ipairs(arg_32_1.choices) do
			local var_32_41 = csv.scene_story_choices[iter_32_1]
			local var_32_42 = var_32_41.text

			local function var_32_43()
				if var_32_35 == 2 then
					arg_32_3.nextId = var_32_41.startStoryID

					var_32_37(arg_32_2, arg_32_3)

					if arg_32_2 then
						arg_32_0:runChoicesFunc(arg_32_1, var_32_41)
					end
				end
			end

			var_0_0(var_32_40, {
				text = var_32_42,
				onClickCallBack = var_32_43
			})
		end

		bind.extend(arg_32_0.guideView, var_32_6.listSelect, {
			class = "listview",
			props = {
				data = var_32_40,
				item = var_32_6.selectItem,
				onItem = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
					arg_38_1:get("textNum"):text(arg_38_2)
					adapt.setTextAdaptWithSize(arg_38_1:get("text"), {
						str = arg_38_3.text
					})
					bind.click(arg_38_0, arg_38_1, {
						method = arg_38_3.onClickCallBack
					})
				end,
				onAfterBuild = function(arg_39_0)
					arg_39_0:setItemAlignCenter()
				end
			}
		})
	else
		arg_32_0.guideView.bg:onClick(function()
			if var_32_35 == 1 then
				var_32_36()
			elseif var_32_35 == 2 then
				var_32_37(arg_32_2, arg_32_3)
			end
		end)

		if arg_32_1.needAutoJump == 1 then
			performWithDelay(var_32_6.skipBtn, function()
				var_32_37(arg_32_2, arg_32_3)
			end, arg_32_1.lastTime / 1000)
		end

		var_32_6.skipBtn:visible(arg_32_1.canSkip or false)

		if arg_32_3.skipCb then
			bind.touch(var_32_6, var_32_6.skipBtn, {
				methods = {
					ended = function()
						var_32_37(arg_32_3.skipCb, arg_32_3)
					end
				}
			})
		end
	end
end

function var_0_2.showClickGuide(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	arg_43_3 = arg_43_3 or {}

	arg_43_0:cleanGuidePanel()

	arg_43_0.guidePanel = ccui.Layout:create():anchorPoint(0.5, 0.5):size(display.sizeInView.width, display.sizeInView.height):xy(display.size.width / 2, display.size.height / 2):addTo(gGameUI.guideLayer, 1, "click")

	arg_43_0.guidePanel:setTouchEnabled(false)

	local var_43_0 = gGameUI:createSimpleView(var_0_3, arg_43_0.guidePanel):init():x(display.uiOrigin.x):z(10)

	arg_43_0.guideView = var_43_0

	var_43_0:enableSchedule()
	var_43_0.skipBtn:hide()

	local var_43_1 = var_43_0.box:multiget("textBg", "textArea", "texL", "texR", "nameL", "nameR")
	local var_43_2 = var_43_0:getResourceNode()

	var_43_2:setTouchEnabled(false)

	local var_43_3 = 0
	local var_43_4 = 0
	local var_43_5 = ccui.Layout:create():size(display.sizeInView.width, display.sizeInView.height):alignCenter(display.sizeInView):addTo(arg_43_0.guidePanel, 1)

	var_43_5:setBackGroundColorType(1)
	var_43_5:setBackGroundColor(cc.c3b(0, 0, 0))
	var_43_5:setBackGroundColorOpacity(150)
	var_43_5:setTouchEnabled(true)

	local var_43_6 = {
		1,
		2,
		3,
		4,
		1,
		4,
		3,
		2,
		1
	}
	local var_43_7 = cc.size(800, 400)

	var_43_5:onClick(function(arg_44_0)
		gGameUI:showTip(gLanguageCsv.guideTip)

		if not arg_43_3.isBattle then
			var_43_3 = var_43_3 + 1

			local var_44_0 = arg_44_0.x <= var_43_7.width and arg_44_0.y >= display.sizeInView.height - var_43_7.height
			local var_44_1 = arg_44_0.x >= display.sizeInView.width - var_43_7.width and arg_44_0.y >= display.sizeInView.height - var_43_7.height
			local var_44_2 = arg_44_0.x >= display.sizeInView.width - var_43_7.width and arg_44_0.y <= var_43_7.height
			local var_44_3 = arg_44_0.x <= var_43_7.width and arg_44_0.y <= var_43_7.height
			local var_44_4 = {
				var_44_0,
				var_44_1,
				var_44_2,
				var_44_3
			}

			if var_43_4 < #var_43_6 and var_44_4[var_43_6[var_43_4 + 1]] then
				var_43_4 = var_43_4 + 1

				if var_43_4 == #var_43_6 then
					var_43_4 = 0

					arg_43_0:onSaveStage(function(arg_45_0)
						arg_43_0:onClose()
					end, -2)
				end
			else
				var_43_4 = 0
			end
		end
	end)

	local function var_43_8(arg_46_0)
		if arg_46_0 then
			arg_43_0:onClose()
			jumpEasy.jumpTo(arg_46_0)

			return
		end

		arg_43_0:cleanGuidePanel()
		arg_43_2()
	end

	var_43_0.btnL:hide()
	var_43_0.btnR:hide()

	if arg_43_1.chooseDesc1 then
		var_43_0.btnL:show()
		var_43_0.btnL:get("text"):text(arg_43_1.chooseDesc1)
		text.addEffect(var_43_0.btnL:get("text"), {
			color = ui.COLORS.NORMAL.WHITE,
			glow = {
				color = ui.COLORS.GLOW.WHITE
			}
		})
		bind.touch(var_43_0, var_43_0.btnL, {
			methods = {
				ended = functools.partial(var_43_8, arg_43_1.choose1)
			}
		})
	end

	if arg_43_1.chooseDesc2 then
		var_43_0.btnR:show()
		var_43_0.btnR:get("text"):text(arg_43_1.chooseDesc2)
		text.addEffect(var_43_0.btnR:get("text"), {
			color = ui.COLORS.NORMAL.WHITE,
			glow = {
				color = ui.COLORS.GLOW.WHITE
			}
		})
		bind.touch(var_43_0, var_43_0.btnR, {
			methods = {
				ended = functools.partial(var_43_8, arg_43_1.choose2)
			}
		})
	end

	if arg_43_1.talkContent ~= "" then
		itertools.invoke({
			var_43_1.texL,
			var_43_1.texR,
			var_43_1.nameL,
			var_43_1.nameR
		}, "hide")
		;(arg_43_1.force == 1 and var_43_1.texL or var_43_1.texR):show():texture(arg_43_1.headRes)

		if arg_43_1.roleName then
			local var_43_9 = arg_43_1.force == 1 and var_43_1.nameL or var_43_1.nameR

			var_43_9:show()
			var_43_9:get("name"):text(arg_43_1.roleName)
			var_43_9:width(var_43_9:get("name"):width() + 40)
			var_43_9:get("name"):alignCenter(var_43_9:size())
		end

		var_43_1.textBg:setFlippedX(arg_43_1.force == 1)

		local var_43_10 = var_43_1.textArea:size()
		local var_43_11 = beauty.textScroll({
			fontSize = 50,
			isRich = true,
			size = var_43_10,
			strs = "#C0x5b545b#" .. arg_43_1.talkContent
		})

		var_43_11:addTo(var_43_1.textArea)

		local var_43_12 = math.max(var_43_11:getInnerItemSize().height, 120) - 120

		var_43_11:height(var_43_1.textArea:height() + var_43_12)
		var_43_1.textBg:height(var_43_1.textBg:height() + var_43_12)

		local var_43_13 = arg_43_1.offPos or {}
		local var_43_14, var_43_15 = var_43_0.box:xy()

		var_43_0.box:xy(var_43_14 + (var_43_13.x or 0), var_43_15 + (var_43_13.y or 0))
	else
		var_43_0.box:hide()
	end

	local function var_43_16(arg_47_0)
		if arg_47_0 then
			if not arg_43_1.anyPosCancel and not arg_47_0:isTouchEnabled() then
				printWarn("guide targetNode:isTouchEnabled(目标控件定位可能存在问题) id(%s): <%s>", tostring(arg_43_0.curGuideId), tostring(table.concat(arg_43_1.tagName, ";")))
			end

			local var_47_0 = arg_47_0:box()
			local var_47_1 = gGameUI:getConvertPos(arg_47_0)
			local var_47_2 = arg_47_0:anchorPoint()

			var_47_1.x = var_47_1.x - var_47_2.x * var_47_0.width + display.uiOrigin.x
			var_47_1.y = var_47_1.y - var_47_2.y * var_47_0.height

			local var_47_3 = cc.RenderTexture:create(display.sizeInView.width, display.sizeInView.height):addTo(arg_43_0.guidePanel, 1, "bgRender")
			local var_47_4 = cc.LayerColor:create(cc.c4b(0, 0, 0, 150), display.sizeInView.width, display.sizeInView.height)
			local var_47_5 = ccui.Scale9Sprite:create()
			local var_47_6 = arg_43_1.lightSize or {}
			local var_47_7 = var_47_6.width or var_47_0.width
			local var_47_8 = var_47_6.height or var_47_0.height

			var_47_4:retain()
			var_47_5:retain()
			var_47_5:initWithFile(cc.rect(80, 80, 1, 1), "other/guide/icon_mask.png")
			var_47_5:anchorPoint(0.5, 0.5):size(var_47_7, var_47_8):xy(var_47_1.x + var_47_0.width / 2 + (var_47_6.dx or 0), var_47_1.y + var_47_0.height / 2 + (var_47_6.dy or 0))
			var_47_5:setBlendFunc({
				dst = 0,
				src = GL_DST_ALPHA
			})

			local var_47_9 = display.sizeInView.width * 2 / var_47_0.width
			local var_47_10 = display.sizeInView.height * 2 / var_47_0.height
			local var_47_11 = math.max(var_47_9, var_47_10)

			var_47_5:scale(var_47_11)
			var_47_3:begin()
			var_47_4:visit()
			var_47_5:visit()
			var_47_3:endToLua()

			local var_47_12 = false
			local var_47_13 = var_47_11 - 1

			var_43_0:schedule(function(arg_48_0)
				var_47_11 = var_47_11 - arg_48_0 / 0.3 * var_47_13

				if not var_47_12 then
					if var_47_11 <= 1 then
						var_47_11 = 1
						var_47_12 = true
					end

					var_47_5:scale(var_47_11)
					var_47_3:beginWithClear(0, 0, 0, 0)
					var_47_4:visit()
					var_47_5:visit()
					var_47_3:endToLua()
				else
					var_47_4:release()
					var_47_5:release()

					if arg_43_1.animate then
						local var_48_0 = arg_43_1.animatePos or {}
						local var_48_1 = var_47_1.x + var_47_0.width / 2 + (var_48_0.x or 0)
						local var_48_2 = var_47_1.y + var_47_0.height / 2 + (var_48_0.y or 0)
						local var_48_3 = ccui.Layout:create():size(0, 0):rotate(arg_43_1.animateAngle):xy(var_48_1, var_48_2):addTo(arg_43_0.guidePanel, 9)

						widget.addAnimation(var_48_3, arg_43_1.animate, "effect_loop")
						audio.playEffectWithWeekBGM("guide.mp3")
					end

					gGameUI:disableTouchDispatch(nil, true)

					return false
				end
			end, 0.03333333333333333, 0, "guideCircleAni")
			var_43_5:setBackGroundColorOpacity(0)

			local var_47_14 = cc.LayerColor:create(cc.c4b(255, 0, 255, 150), display.sizeInView.width, display.sizeInView.height):addTo(arg_43_0.guidePanel, 2)
			local var_47_15 = false

			var_47_14:hide()

			local var_47_16 = cc.EventListenerTouchOneByOne:create()
			local var_47_17 = var_47_14:getEventDispatcher()
			local var_47_18 = cc.p(0, 0)

			local function var_47_19(arg_49_0)
				var_47_16:setEnabled(false)
				var_47_17:dispatchEvent(arg_49_0)
				var_47_16:setEnabled(true)
			end

			local function var_47_20(arg_50_0, arg_50_1)
				var_47_18 = arg_50_0:getLocation()
				var_47_15 = arg_47_0:hitTest(var_47_18)

				return true
			end

			local function var_47_21(arg_51_0, arg_51_1)
				var_47_19(arg_51_1)
			end

			local function var_47_22(arg_52_0, arg_52_1)
				local var_52_0 = arg_52_0:getLocation()
				local var_52_1 = var_52_0.x - var_47_18.x
				local var_52_2 = var_52_0.y - var_47_18.y
				local var_52_3 = false
				local var_52_4 = arg_47_0:hitTest(var_52_0)

				log.guide("touch end, hit:", var_47_15, "isTouchEnabled:", arg_47_0:isTouchEnabled(), "hitTest:", var_52_4)

				if var_47_15 and var_52_4 then
					var_43_5:setTouchEnabled(false)
					var_43_5:setTouchEnabled(true)
				end

				arg_52_1:setEventCode(ccui.TouchEventType.began)
				var_47_19(arg_52_1)
				log.guide("touch end, lighted:", arg_47_0:isHighlighted())
				arg_52_1:setEventCode(ccui.TouchEventType.ended)

				if not var_47_15 or not var_52_4 then
					var_47_19(arg_52_1)

					return
				end

				if arg_47_0:isTouchEnabled() and not arg_47_0:isHighlighted() then
					var_47_19(arg_52_1)

					return
				end

				arg_43_0:cleanGuidePanel()
				var_47_19(arg_52_1)
				arg_43_2()
			end

			var_47_16:setSwallowTouches(true)
			var_47_16:registerScriptHandler(var_47_20, cc.Handler.EVENT_TOUCH_BEGAN)
			var_47_16:registerScriptHandler(var_47_21, cc.Handler.EVENT_TOUCH_MOVED)
			var_47_16:registerScriptHandler(var_47_22, cc.Handler.EVENT_TOUCH_ENDED)
			var_47_16:registerScriptHandler(var_47_22, cc.Handler.EVENT_TOUCH_CANCELLED)
			var_47_17:addEventListenerWithSceneGraphPriority(var_47_16, var_47_14)
		else
			gGameUI:disableTouchDispatch(nil, true)

			if arg_43_1.lightSize then
				var_43_5:setBackGroundColorOpacity(0)
			end
		end

		if arg_43_1.anyPosCancel or not arg_47_0 then
			var_43_2:setTouchEnabled(true)
			var_43_2:onClick(function()
				arg_43_0:cleanGuidePanel()
				arg_43_2()
			end)
		end
	end

	local var_43_17 = {}

	if table.length(arg_43_1.tagName) > 0 then
		for iter_43_0, iter_43_1 in ipairs(arg_43_1.tagName) do
			var_43_17[iter_43_0] = iter_43_1
		end
	end

	local var_43_18 = arg_43_0:findNodeByName(gGameUI.scene, var_43_17)

	if table.length(arg_43_1.tagName) > 0 and not var_43_18 then
		local var_43_19 = 0

		var_43_0:schedule(function(arg_54_0)
			var_43_19 = var_43_19 + arg_54_0
			var_43_18 = arg_43_0:findNodeByName(gGameUI.scene, var_43_17)

			if var_43_18 or var_43_19 > 1 then
				if not var_43_18 then
					printWarn("guide id(%s) 检查控件配置当前状态定位不到: <%s>", tostring(arg_43_0.curGuideId), tostring(table.concat(arg_43_1.tagName, ";")))
				end

				performWithDelay(var_43_0, function()
					var_43_16(var_43_18)
				end, 0)

				return false
			end
		end, 0.03333333333333333, 0, "findTargetNode")
	else
		var_43_16(var_43_18)
	end
end

function var_0_2.findNodeByName(arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	local var_56_0 = not itertools.isempty(arg_56_2)

	if not arg_56_3 and not var_56_0 then
		return nil
	end

	local var_56_1 = queue or {
		{
			layer = 1,
			node = arg_56_1
		}
	}
	local var_56_2 = 1

	while var_56_2 <= #var_56_1 do
		local var_56_3 = var_56_1[var_56_2]
		local var_56_4 = var_56_3.node

		if arg_56_3 and arg_56_3 == var_56_4:getName() then
			return true
		end

		if var_56_0 then
			local var_56_5 = nodetools.get(var_56_4, unpack(arg_56_2))

			if var_56_5 and var_56_5 ~= var_56_4 and var_56_5:isVisibleInGlobal() then
				return var_56_5
			end
		end

		var_56_2 = var_56_2 + 1

		for iter_56_0, iter_56_1 in pairs(var_56_4:getChildren()) do
			if iter_56_1:isVisible() then
				var_0_0(var_56_1, {
					node = iter_56_1,
					layer = var_56_3.layer + 1
				})
			end
		end
	end
end

function var_0_2.setChoicesFunc(arg_57_0, arg_57_1)
	arg_57_0.choicesFunc = arg_57_1
end

function var_0_2.runChoicesFunc(arg_58_0, ...)
	if arg_58_0.choicesFunc then
		arg_58_0.choicesFunc(...)
	end
end

return var_0_2
