local var_0_0 = require("app.views.city.test.model.gameobject")
local var_0_1 = require("app.views.city.test.gate.gate")
local var_0_2 = class("SingleGate", var_0_1)

function var_0_2.init(arg_1_0)
	for iter_1_0 = 1, 30 do
		arg_1_0:addGameObject()
	end
end

function var_0_2.parseRecord(arg_2_0, arg_2_1)
	arg_2_0:cleanGameObject()

	for iter_2_0, iter_2_1 in pairs(arg_2_1) do
		if iter_2_0 < 13 then
			local var_2_0 = arg_2_0:indexToSeat(iter_2_0)

			arg_2_0:initGameObjectByRoleId(var_2_0, iter_2_0, iter_2_1.roleId, iter_2_1)
		end
	end
end

function var_0_2.parseScene(arg_3_0, arg_3_1)
	arg_3_0:cleanGameObject()

	if arg_3_1 and next(arg_3_1) then
		for iter_3_0, iter_3_1 in pairs(arg_3_1) do
			if iter_3_0 < 13 then
				arg_3_0:initGameObjectByRoleId(iter_3_1.index, arg_3_0:indexToSeat(iter_3_0), iter_3_1._prefab.roleId, iter_3_1._prefab.data)
			end
		end
	end
end

function var_0_2.addGameObject(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_1 then
		for iter_4_0, iter_4_1 in ipairs(arg_4_0.scene) do
			if not iter_4_1:getRoleData() then
				arg_4_2 = arg_4_2 or iter_4_1.seat

				iter_4_1:init(iter_4_1.index, arg_4_2, arg_4_1)

				break
			end
		end

		return
	end

	local var_4_0 = cc.p(10, 2)
	local var_4_1 = 3
	local var_4_2 = var_0_0.new(arg_4_0.gameObject:clone())
	local var_4_3 = var_4_2.node
	local var_4_4 = cc.p(var_4_3:size().width / 2 + var_4_0.x, var_4_3:size().height / 2 - var_4_0.y)

	arg_4_0.parent:addItemToScrollView(arg_4_0.gameObjects, var_4_3, var_4_0, var_4_4, var_4_1)
	var_4_3:onTouch(functools.handler(arg_4_0, arg_4_0.dragSprite, var_4_2))
	var_4_3:addClickEventListener(functools.handler(arg_4_0.parent, arg_4_0.parent.onlyShowSelect, arg_4_0.gameObjects, var_4_2))
	var_4_3:get("del"):addClickEventListener(functools.handler(arg_4_0, arg_4_0.delGameObject, var_4_2))
	table.insert(arg_4_0.scene, var_4_2)

	arg_4_2 = arg_4_2 or arg_4_0:indexToSeat(#arg_4_0.scene)

	var_4_2:init(#arg_4_0.scene, arg_4_2, arg_4_1)
end

function var_0_2.delGameObject(arg_5_0, arg_5_1)
	if arg_5_0.lastClickObj and arg_5_0.lastClickObj.id == arg_5_1.id then
		arg_5_0.lastClickObj = nil

		arg_5_0.parent:showAttr()
	end

	arg_5_1:init(arg_5_1.index, arg_5_1.seat)
end

function var_0_2.cleanGameObject(arg_6_0)
	arg_6_0.gameObjects:removeAllChildren()

	arg_6_0.scene = {}

	for iter_6_0 = 1, 12 do
		arg_6_0:addGameObject()
	end
end

function var_0_2.getGameObjectIndex(arg_7_0, arg_7_1)
	return arg_7_1 > 5 and arg_7_1 + 3 or arg_7_1
end

function var_0_2.getFightRoleData(arg_8_0)
	local var_8_0 = {}
	local var_8_1 = {
		{},
		{}
	}
	local var_8_2

	for iter_8_0, iter_8_1 in ipairs(arg_8_0.scene) do
		local var_8_3 = iter_8_1:getRoleData()

		if var_8_3 then
			table.insert(var_8_1[iter_8_1.force], var_8_3)
		end
	end

	if not next(var_8_1[1]) or not next(var_8_1[2]) then
		return var_8_0
	end

	for iter_8_2, iter_8_3 in pairs(var_8_1[1]) do
		for iter_8_4, iter_8_5 in pairs(var_8_1[2]) do
			var_8_0[#var_8_0 + 1] = {
				[2] = iter_8_3,
				[8] = iter_8_5
			}
		end
	end

	return var_8_0
end

return var_0_2
