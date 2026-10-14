local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CloneBattleBaseView", var_0_0)

var_0_1.RESOURCE_FILENAME = "clone_battle_base.json"
var_0_1.RESOURCE_BINDING = {}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0:getResourceNode():size()

	if arg_1_1 then
		arg_1_0.data = arg_1_1

		arg_1_0:refreshView()
	else
		arg_1_0:refresh()
	end
end

function var_0_1.onCleanup(arg_2_0)
	if arg_2_0.view then
		arg_2_0.view:removeFromParent()

		arg_2_0.view = nil
	end

	var_0_0.onCleanup(arg_2_0)
end

function var_0_1.refresh(arg_3_0)
	gGameApp:requestServer("/game/clone/get", function(arg_4_0)
		arg_3_0.data = arg_4_0.view

		arg_3_0:refreshView()
	end)
end

function var_0_1.refreshView(arg_5_0, arg_5_1)
	arg_5_0.data = arg_5_1 or arg_5_0.data

	if arg_5_0.view then
		arg_5_0.view:onClose()

		arg_5_0.view = nil
	end

	if gGameModel.role:read("clone_room_db_id") then
		arg_5_0.view = gGameUI:createView("city.adventure.clone_battle.room", arg_5_0):init(arg_5_0)
	else
		arg_5_0:playBgAni(nil)

		arg_5_0.view = gGameUI:createView("city.adventure.clone_battle.view", arg_5_0):init(arg_5_0.data, arg_5_0)
	end

	gGameUI.topuiManager:createView("default", arg_5_0.view, {
		onClose = arg_5_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_huanxiangtiaozhan.png"
	})
end

function var_0_1.playBgAni(arg_6_0, arg_6_1)
	if arg_6_1 then
		-- block empty
	end
end

return var_0_1
