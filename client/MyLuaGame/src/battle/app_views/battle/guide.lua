local var_0_0 = require("app.views.guide.manager")
local var_0_1 = class("BattleGuideManager", var_0_0)
local var_0_2 = var_0_0.GuideView
local var_0_3 = var_0_0.BattleStoryPanelView

function var_0_1.ctor(arg_1_0, arg_1_1)
	arg_1_0.battleView = arg_1_1
	arg_1_0.stroyDatas = {}
	arg_1_0.totalTriggerTime = 0
	arg_1_0.curGuideIdx = 0
	arg_1_0.startGuideIdx = 0
	arg_1_0.guidePanel = nil
	arg_1_0.inGuiding = false
	arg_1_0.choicesFunc = nil
end

function var_0_1.initStoryDatas(arg_2_0, arg_2_1)
	arg_2_0.stroyDatas = {}

	for iter_2_0, iter_2_1 in ipairs(arg_2_1) do
		for iter_2_2 = 0, 99 do
			local var_2_0 = iter_2_1 + iter_2_2
			local var_2_1 = csv.scene_monster_story[var_2_0]

			if not var_2_1 then
				break
			end

			table.insert(arg_2_0.stroyDatas, {
				cfg = var_2_1,
				id = var_2_0
			})
		end
	end

	arg_2_0.curGuideIdx = 1
end

function var_0_1.setData(arg_3_0, arg_3_1)
	arg_3_0:initStoryDatas(arg_3_1)

	arg_3_0.totalTriggerTime = 0
	arg_3_0.inGuiding = true

	gGameUI.guideLayer:show()
	gGameUI:disableTouchDispatch(nil, false)
end

function var_0_1.update(arg_4_0, arg_4_1)
	if not arg_4_0.inGuiding or arg_4_0.ignoreGuide then
		return
	end

	local var_4_0 = arg_4_0.stroyDatas[arg_4_0.curGuideIdx]

	if not var_4_0 then
		arg_4_0:cleanGuidePanel()

		arg_4_0.inGuiding = false

		gGameUI.guideLayer:hide()
		gGameUI:disableTouchDispatch(nil, true)
		arg_4_0.battleView:showMainUI(true)
		arg_4_0.battleView:onModelResume()

		return
	end

	local var_4_1 = arg_4_0.stroyDatas[arg_4_0.curGuideIdx + 1]
	local var_4_2 = var_4_0.cfg

	arg_4_0.totalTriggerTime = arg_4_0.totalTriggerTime + arg_4_1

	if not var_4_0.visit and arg_4_0.totalTriggerTime >= var_4_2.triggerTime then
		log.battle.guide("update: id", var_4_0.id, "triggerTime", arg_4_0.totalTriggerTime)

		var_4_0.visit = true

		if var_4_2.showType == 2 then
			gGameUI:disableTouchDispatch(nil, true)
			arg_4_0:showDialog(var_4_2, function(arg_5_0)
				arg_4_0.totalTriggerTime = var_4_2.triggerTime + var_4_2.lastTime
				arg_4_0.curGuideIdx = arg_4_0.curGuideIdx + 1

				arg_4_0:updateChoice(var_4_2, arg_5_0)
				gGameUI:disableTouchDispatch(nil, false)
			end, {
				isBattle = true,
				skipCb = function()
					local var_6_0 = var_4_2

					for iter_6_0 = arg_4_0.curGuideIdx + 1, table.length(arg_4_0.stroyDatas) do
						if arg_4_0.stroyDatas[iter_6_0].cfg.canSkip then
							var_6_0 = arg_4_0.stroyDatas[iter_6_0].cfg
							arg_4_0.curGuideIdx = iter_6_0
						else
							break
						end
					end

					arg_4_0.totalTriggerTime = var_6_0.triggerTime + var_6_0.lastTime
					arg_4_0.curGuideIdx = arg_4_0.curGuideIdx + 1

					gGameUI:disableTouchDispatch(nil, false)
				end
			})
		elseif var_4_2.showType == 3 then
			local var_4_3 = arg_4_0.battleView:onViewProxyCall("getSceneObjBySeat", var_4_2.topTalkPos)

			if var_4_3 then
				var_4_3:showGuide(var_4_2.topTalk, var_4_2.lastTime)

				arg_4_0.curGuideIdx = arg_4_0.curGuideIdx + 1
			else
				arg_4_0.totalTriggerTime = var_4_2.triggerTime + var_4_2.lastTime
				arg_4_0.curGuideIdx = arg_4_0.curGuideIdx + 1
			end
		else
			arg_4_0:showClickGuide(var_4_2, function()
				arg_4_0.totalTriggerTime = var_4_2.triggerTime + var_4_2.lastTime
				arg_4_0.curGuideIdx = arg_4_0.curGuideIdx + 1

				gGameUI:disableTouchDispatch(nil, false)
			end, {
				isBattle = true
			})
		end
	end
end

function var_0_1.updateChoice(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0

	if arg_8_2 and arg_8_2.nextId and arg_8_2.nextId > 0 then
		var_8_0 = {
			arg_8_2.nextId
		}
	end

	if table.length(arg_8_1.gotoStep) > 0 then
		var_8_0 = arg_8_1.gotoStep
	end

	if var_8_0 then
		arg_8_0:initStoryDatas(var_8_0)
	end
end

function var_0_1.showDialog(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	var_0_0.showDialog(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	arg_9_0.guidePanel:setBackGroundColorOpacity(0)
end

return var_0_1
