local var_0_0 = require("app.views.city.test.model.gameobject")
local var_0_1 = require("app.views.city.test.model.prefab")
local var_0_2 = require("app.views.city.test.gate.gate")
local var_0_3 = class("NormalGate", var_0_2)

function var_0_3.init(arg_1_0)
	for iter_1_0 = 1, 12 do
		arg_1_0:addGameObject()
	end
end

function var_0_3.parseRecord(arg_2_0, arg_2_1)
	arg_2_0:cleanGameObject()

	for iter_2_0, iter_2_1 in pairs(arg_2_1) do
		if iter_2_0 < 13 then
			local var_2_0 = arg_2_0:indexToSeat(iter_2_0)

			arg_2_0:initGameObjectByRoleId(var_2_0, iter_2_0, iter_2_1.roleId, iter_2_1)
		end
	end
end

function var_0_3.parseScene(arg_3_0, arg_3_1)
	arg_3_0:cleanGameObject()

	if arg_3_1 and next(arg_3_1) then
		for iter_3_0, iter_3_1 in pairs(arg_3_1) do
			if iter_3_0 < 13 then
				arg_3_0:initGameObjectByRoleId(iter_3_1.index, arg_3_0:indexToSeat(iter_3_0), iter_3_1._prefab.roleId, iter_3_1._prefab.data)
			end
		end
	end
end

function var_0_3.addGameObject(arg_4_0, arg_4_1, arg_4_2)
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

function var_0_3.exchange(arg_5_0)
	local var_5_0 = {}

	for iter_5_0, iter_5_1 in pairs(arg_5_0.scene) do
		var_5_0[arg_5_0:exchangeSeat(iter_5_1.seat)] = iter_5_1:getRoleData()
	end

	arg_5_0:cleanGameObject()

	for iter_5_2, iter_5_3 in pairs(arg_5_0.scene) do
		if var_5_0[iter_5_3.seat] then
			iter_5_3:initByRoleData(iter_5_3.index, iter_5_3.seat, var_5_0[iter_5_3.seat])
		end
	end
end

function var_0_3.delGameObject(arg_6_0, arg_6_1)
	if arg_6_0.lastClickObj and arg_6_0.lastClickObj.id == arg_6_1.id then
		arg_6_0.lastClickObj = nil

		arg_6_0.parent:showAttr()
	end

	arg_6_1:init(arg_6_1.index, arg_6_1.seat)
end

function var_0_3.cleanGameObject(arg_7_0)
	arg_7_0.gameObjects:removeAllChildren()

	arg_7_0.scene = {}

	for iter_7_0 = 1, 12 do
		arg_7_0:addGameObject()
	end
end

function var_0_3.getGameObjectIndex(arg_8_0, arg_8_1)
	return arg_8_1 > 5 and arg_8_1 + 3 or arg_8_1
end

function var_0_3.getFightRoleData(arg_9_0, arg_9_1)
	local var_9_0 = {}
	local var_9_1 = {
		0,
		0
	}
	local var_9_2

	if arg_9_0.scene then
		for iter_9_0, iter_9_1 in ipairs(arg_9_0.scene) do
			local var_9_3 = iter_9_1:getRoleData()

			if var_9_3 then
				var_9_0[iter_9_1.seat] = var_9_3
				var_9_1[iter_9_1.force] = var_9_1[iter_9_1.force] + 1
			end
		end
	end

	if var_9_1[1] == 0 or var_9_1[2] == 0 then
		var_9_0 = {}
	end

	if arg_9_1 then
		var_9_0 = {}

		for iter_9_2, iter_9_3 in ipairs(arg_9_1.left) do
			if iter_9_3 ~= 0 then
				local var_9_4 = var_0_1.new()

				var_9_4:init(iter_9_3, clone(arg_9_1.DefaultAttr))

				var_9_0[iter_9_2] = var_9_4:getRoleData()
			end
		end

		for iter_9_4, iter_9_5 in ipairs(arg_9_1.right) do
			if iter_9_5 ~= 0 then
				local var_9_5 = var_0_1.new()

				var_9_5:init(iter_9_5, clone(arg_9_1.DefaultAttr))

				var_9_0[6 + iter_9_4] = var_9_5:getRoleData()
			end
		end
	end

	return {
		var_9_0
	}
end

return var_0_3
