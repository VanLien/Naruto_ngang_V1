local var_0_0 = require("app.views.city.test.model.gameobject")
local var_0_1 = require("app.views.city.test.gate.gate")
local var_0_2 = class("CraftGate", var_0_1)

function var_0_2.init(arg_1_0)
	for iter_1_0 = 1, 6 do
		arg_1_0:addGameObject()
	end
end

function var_0_2.parseScene(arg_2_0, arg_2_1)
	arg_2_0:cleanGameObject()

	if arg_2_1 and next(arg_2_1) then
		for iter_2_0, iter_2_1 in pairs(arg_2_1) do
			arg_2_0:initGameObjectByRoleId(iter_2_1.index, iter_2_1.index < 4 and iter_2_1.index or iter_2_1.index + 3, iter_2_1._prefab.roleId, iter_2_1._prefab.data)
		end
	end
end

function var_0_2.addGameObject(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_1 then
		for iter_3_0, iter_3_1 in ipairs(arg_3_0.scene) do
			if not iter_3_1:getRoleData() then
				iter_3_1:init(iter_3_1.index, arg_3_2 or iter_3_1.index > 3 and iter_3_1.index + 3 or iter_3_1.index, arg_3_1)

				break
			end
		end

		return
	end

	local var_3_0 = cc.p(80, 2)
	local var_3_1 = 3
	local var_3_2 = var_0_0.new(arg_3_0.gameObject:clone())
	local var_3_3 = var_3_2.node
	local var_3_4 = cc.p(var_3_3:size().width / 2 + var_3_0.x, var_3_3:size().height / 2 - var_3_0.y)

	arg_3_0.parent:addItemToScrollView(arg_3_0.gameObjects, var_3_3, var_3_0, var_3_4, var_3_1)
	var_3_3:onTouch(functools.handler(arg_3_0, arg_3_0.dragSprite, var_3_2))
	var_3_3:addClickEventListener(functools.handler(arg_3_0.parent, arg_3_0.parent.onlyShowSelect, arg_3_0.gameObjects, var_3_2))
	var_3_3:get("del"):addClickEventListener(functools.handler(arg_3_0, arg_3_0.delGameObject, var_3_2))
	table.insert(arg_3_0.scene, var_3_2)

	arg_3_2 = arg_3_2 or #arg_3_0.scene

	var_3_2:init(#arg_3_0.scene, arg_3_2 > 3 and arg_3_2 + 3 or arg_3_2, arg_3_1)
end

function var_0_2.delGameObject(arg_4_0, arg_4_1)
	if arg_4_0.lastClickObj and arg_4_0.lastClickObj.id == arg_4_1.id then
		arg_4_0.lastClickObj = nil

		arg_4_0.parent:showAttr()
	end

	arg_4_1:init(arg_4_1.index)
end

function var_0_2.cleanGameObject(arg_5_0)
	arg_5_0.gameObjects:removeAllChildren()

	arg_5_0.scene = {}

	for iter_5_0 = 1, 6 do
		arg_5_0:addGameObject()
	end
end

function var_0_2.getGameObjectIndex(arg_6_0, arg_6_1)
	return arg_6_1 > 2 and arg_6_1 + 3 or arg_6_1
end

function var_0_2.parseRecord(arg_7_0, arg_7_1)
	arg_7_0:cleanGameObject()

	for iter_7_0, iter_7_1 in pairs(arg_7_1) do
		local var_7_0 = iter_7_0

		arg_7_0:initGameObjectByRoleId(var_7_0, iter_7_0, iter_7_1.roleId, iter_7_1)
	end
end

function var_0_2.initGameObjectByRoleId(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	if not arg_8_0.parent.resources[arg_8_3] then
		arg_8_0.parent:addRes(arg_8_3, arg_8_4)
	end

	arg_8_0.scene[arg_8_1 > 6 and arg_8_1 - 3 or arg_8_1]:init(arg_8_1, arg_8_2, arg_8_0.parent.resources[arg_8_3])
	arg_8_0.scene[arg_8_1 > 6 and arg_8_1 - 3 or arg_8_1]:loadRoleData(arg_8_4)
end

function var_0_2.getFightRoleData(arg_9_0)
	local var_9_0 = {}
	local var_9_1 = {
		0,
		0
	}
	local var_9_2

	for iter_9_0, iter_9_1 in ipairs(arg_9_0.scene) do
		local var_9_3 = iter_9_1:getRoleData()

		if var_9_3 then
			var_9_0[iter_9_1.seat] = var_9_3
			var_9_1[iter_9_1.force] = var_9_1[iter_9_1.force] + 1
		end
	end

	if var_9_1[1] == 0 or var_9_1[2] == 0 then
		var_9_0 = {}
	end

	return {
		var_9_0
	}
end

return var_0_2
