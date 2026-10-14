local var_0_0 = class("NewCharacterView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "character.json"
var_0_0.RESOURCE_BINDING = {}

function var_0_0.onCreate(arg_1_0)
	performWithDelay(arg_1_0, function()
		arg_1_0:gotoNext()
		arg_1_0:getResourceNode():onClick(function()
			arg_1_0:onShowNextView()
		end)
	end, 0)
	audio.playMusic("city.mp3")
end

function var_0_0.gotoNext(arg_4_0)
	if gGameUI.guideManager:isInGuiding() then
		return
	end

	arg_4_0.showView = false

	if gGameUI.guideManager:checkGuide({
		specialName = "nameAndFigureBefore",
		endCb = functools.partial(arg_4_0.onShowNextView, arg_4_0)
	}) then
		return
	end

	if gGameUI.guideManager:checkGuide({
		specialName = "chooseCardBefore",
		endCb = functools.partial(arg_4_0.onShowNextView, arg_4_0)
	}) then
		return
	end

	arg_4_0:onShowNextView()
end

function var_0_0.onShowNextView(arg_5_0)
	if gGameUI.guideManager:isInGuiding() then
		return
	end

	if arg_5_0.showView then
		return
	end

	arg_5_0.showView = true

	if not gGameUI.guideManager:checkFinished(1) then
		gGameUI:stackUI("new_character.select_figure", nil, nil, arg_5_0:createHandler("gotoNext"))

		return
	end

	if not gGameUI.guideManager:checkFinished(2) then
		local var_5_0 = csv.newbie_init[1].cards

		gGameApp:requestServer("/game/role/newbie/card/choose", function()
			gGameUI:stackUI("new_character.gain_sprite", nil, nil, var_5_0[1].id, arg_5_0:createHandler("gotoNext"))
		end, 2, var_5_0[1].id)

		return
	end

	sdk.commitRoleInfo(4, function()
		print("sdk commitRoleInfo new role")
	end)

	if matchLanguage({
		"kr"
	}) then
		sdk.commitRoleInfo(1, function()
			print("info upload for kr version")
		end)
	end

	gGameUI:switchUI("city.view")
end

return var_0_0
