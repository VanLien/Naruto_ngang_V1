local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CrossExtraAward", var_0_0)

var_0_1.RESOURCE_FILENAME = "cross_craft_bet_result.json"
var_0_1.RESOURCE_BINDING = {
	rolePanel3 = "rolePanel3",
	list = "list",
	item = "item",
	imgBG = "imgBG",
	rolePanel1 = "rolePanel1",
	imgJc = "imgJc",
	rolePanel2 = "rolePanel2",
	innerList = "innerList"
}

function var_0_1.initRoleData(arg_1_0, arg_1_1, arg_1_2)
	if not arg_1_1 then
		return
	end

	arg_1_2:get("txtName"):text(arg_1_1.role.name)
	bind.extend(arg_1_0, arg_1_2:get("trainerIcon"), {
		class = "role_logo",
		props = {
			vip = false,
			level = false,
			logoId = arg_1_1.role.logo,
			frameId = arg_1_1.role.frame,
			onNode = function(arg_2_0)
				arg_2_0:xy(96, 100):z(6)
			end
		}
	})
end

function var_0_1.initAward(arg_3_0)
	local var_3_0 = {}

	if arg_3_0.type == 1 then
		var_3_0 = csv.cross.craft.base[1].preBetExtraAward
	else
		var_3_0 = csv.cross.craft.base[1].top4BetExtraAward
	end

	bind.extend(arg_3_0, arg_3_0.list, {
		class = "listview",
		props = {
			data = dataEasy.getItemData(var_3_0),
			item = arg_3_0.item,
			dataOrderCmp = dataEasy.sortItemCmp,
			onAfterBuild = function()
				arg_3_0.list:setItemAlignCenter()
			end,
			onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				bind.extend(arg_5_0, arg_5_1, {
					class = "icon_key",
					props = {
						data = arg_5_3,
						grayState = arg_5_3.grayState,
						onNode = function(arg_6_0)
							arg_6_0:y(160)

							local var_6_0 = dataEasy.getCfgByKey(arg_5_3.key).name

							adapt.setTextScaleWithWidth(arg_5_1:get("txtName"), var_6_0, arg_6_0:width() + 80)
						end
					}
				})
			end
		}
	})
	arg_3_0.list:adaptTouchEnabled()
end

function var_0_1.onCreate(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0:getResourceNode()

	widget.addAnimation(var_7_0, "kuafushiying/jccg.skel", "effect_loop", 10):anchorPoint(cc.p(0.5, 0.5)):xy(var_7_0:width() / 2, var_7_0:height() - 280):scale(2)

	arg_7_0.type = arg_7_1.type

	for iter_7_0 = 1, 3 do
		arg_7_0:initRoleData(arg_7_1.roleData[iter_7_0], arg_7_0["rolePanel" .. iter_7_0])
	end

	local var_7_1 = {
		"txt_yxjc.png",
		"txt_4qjc.png",
		"txt_gjjc.png"
	}

	arg_7_0.imgJc:texture("city/pvp/cross_craft/txt/" .. var_7_1[arg_7_0.type])
	arg_7_0:initAward()
end

return var_0_1
