local var_0_0 = table.insert
local var_0_1 = require("app.views.guide.manager")
local var_0_2 = class("GuideManagerLocal", var_0_1)
local var_0_3 = var_0_1.NextGuideActionTag

function var_0_2.ctor(arg_1_0)
	arg_1_0.curGuideId = nil
	arg_1_0.inGuiding = false
	arg_1_0.guidePanel = nil
	arg_1_0.ignoreGuide = false
	arg_1_0.choicesFunc = nil

	local var_1_0 = {}
	local var_1_1

	for iter_1_0, iter_1_1 in orderCsvPairs(csv.new_guide_local) do
		if var_1_1 ~= iter_1_1.stage and not var_1_0[iter_1_1.stage] then
			var_1_1 = iter_1_1.stage
			var_1_0[iter_1_1.stage] = {
				begin = iter_1_0,
				specialName = iter_1_1.specialName
			}
		end
	end

	arg_1_0.guideCsv = csv.new_guide_local
	arg_1_0.stageCsv = var_1_0
end

function var_0_2.checkFinished(arg_2_0, arg_2_1)
	local var_2_0 = userDefault.getForeverLocalKey("guideLocal", {})

	for iter_2_0, iter_2_1 in ipairs(var_2_0) do
		if arg_2_1 == iter_2_1 then
			return true
		end
	end

	return false
end

function var_0_2.onSaveStage(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = userDefault.getForeverLocalKey("guideLocal", {})

	if not arraytools.hash(var_3_0)[arg_3_2] then
		var_0_0(var_3_0, arg_3_2)
		userDefault.setForeverLocalKey("guideLocal", var_3_0, {
			new = true
		})
		printInfo("save guide local stage: " .. arg_3_2)
		arg_3_1()
	else
		gGameUI:showTip("guideID error")
	end
end

function var_0_2.checkGuide(arg_4_0, arg_4_1)
	arg_4_1 = arg_4_1 or {}

	log.guide("local check name:", arg_4_1.name, "specialName:", arg_4_1.specialName, "isInGuiding:", arg_4_0:isInGuiding(), arg_4_0.ignoreGuide, arg_4_0.continueLastGuide)

	if dev.GUIDE_CLOSED or FOR_SHENHE or arg_4_0.ignoreGuide then
		return
	end

	if gGameUI.rootViewName == "login.view" then
		return
	end

	local var_4_0 = userDefault.getForeverLocalKey("guideLocal", {})

	if arg_4_0:isInGuiding() then
		return
	end

	if arg_4_0.continueLastGuide then
		arg_4_0.curGuideId = arg_4_0.continueLastGuide
		arg_4_0.continueLastGuide = nil
		arg_4_0.inGuiding = true

		arg_4_0:nextGuide()

		return true
	end

	arg_4_0.curGuideId = nil

	if not arg_4_0.orderStageCsv then
		arg_4_0.orderStageCsv = {}

		local var_4_1 = arraytools.hash(var_4_0)

		for iter_4_0, iter_4_1 in pairs(arg_4_0.stageCsv) do
			if not var_4_1[iter_4_0] then
				var_0_0(arg_4_0.orderStageCsv, arg_4_0.guideCsv[iter_4_1.begin])
			end
		end

		table.sort(arg_4_0.orderStageCsv, function(arg_5_0, arg_5_1)
			if arg_5_0.order ~= arg_5_1.order then
				return arg_5_0.order < arg_5_1.order
			end

			return arg_5_0.stage < arg_5_1.stage
		end)
	end

	for iter_4_2, iter_4_3 in ipairs(arg_4_0.orderStageCsv) do
		if arg_4_0:canTriggerGuide(iter_4_3, arg_4_1) then
			table.remove(arg_4_0.orderStageCsv, iter_4_2)
			arg_4_0:triggerGuide(iter_4_3.id, arg_4_1)

			return true
		end
	end
end

function var_0_2.triggerGuide(arg_6_0, arg_6_1, arg_6_2)
	arg_6_2.log = "local trigger:"

	var_0_1.triggerGuide(arg_6_0, arg_6_1, arg_6_2)
end

function var_0_2.quiteGiveAward(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	printWarn("local guide no award")
	arg_7_0:nextGuide(arg_7_3)
end

function var_0_2.onDeleteStage(arg_8_0, arg_8_1)
	if dev.GUIDE_CLOSED or FOR_SHENHE or arg_8_0.ignoreGuide or not arg_8_1 then
		return false
	end

	local var_8_0 = userDefault.getForeverLocalKey("guideLocal", {})

	for iter_8_0, iter_8_1 in ipairs(var_8_0) do
		if arg_8_1 == iter_8_1 then
			table.remove(var_8_0, iter_8_0)
			userDefault.setForeverLocalKey("guideLocal", var_8_0, {
				new = true
			})
			var_0_0(arg_8_0.orderStageCsv, arg_8_0.guideCsv[arg_8_0.stageCsv[arg_8_1].begin])
			printInfo("del guide local stage: " .. arg_8_1)

			return true
		end
	end

	return false
end

return var_0_2
