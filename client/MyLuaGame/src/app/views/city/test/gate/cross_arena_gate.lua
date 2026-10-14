local var_0_0 = require("app.views.city.test.model.gameobject")
local var_0_1 = require("app.views.city.test.gate.gate")
local var_0_2 = class("CrossArenaGate", var_0_1)

function var_0_2.init(arg_1_0)
	for iter_1_0 = 1, 24 do
		arg_1_0:addGameObject()
	end
end

function var_0_2.parseRecord(arg_2_0, arg_2_1)
	arg_2_0:cleanGameObject()

	for iter_2_0, iter_2_1 in ipairs(arg_2_1) do
		for iter_2_2, iter_2_3 in ipairs(iter_2_1) do
			for iter_2_4, iter_2_5 in pairs(iter_2_3) do
				local var_2_0 = iter_2_2 == 1 and 0 or 12

				arg_2_0:initGameObjectByRoleId(var_2_0 + iter_2_4, iter_2_4, iter_2_5.roleId, iter_2_5)
			end
		end
	end
end

function var_0_2.parseScene(arg_3_0, arg_3_1)
	arg_3_0:cleanGameObject()

	if arg_3_1 and next(arg_3_1) then
		for iter_3_0, iter_3_1 in pairs(arg_3_1) do
			arg_3_0:initGameObjectByRoleId(iter_3_1.index, arg_3_0:indexToSeat(iter_3_0), iter_3_1._prefab.roleId, iter_3_1._prefab.data)
		end
	end
end

function var_0_1.indexToSeat(arg_4_0, arg_4_1)
	return ({
		4,
		5,
		6,
		1,
		2,
		3,
		7,
		8,
		9,
		10,
		11,
		12,
		4,
		5,
		6,
		1,
		2,
		3,
		7,
		8,
		9,
		10,
		11,
		12
	})[arg_4_1] or arg_4_1
end

function var_0_2.addGameObject(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_1 then
		for iter_5_0, iter_5_1 in ipairs(arg_5_0.scene) do
			if not iter_5_1:getRoleData() then
				arg_5_2 = arg_5_2 or iter_5_1.seat

				iter_5_1:init(iter_5_1.index, arg_5_2, arg_5_1)

				break
			end
		end

		return
	end

	local var_5_0 = cc.p(10, 2)
	local var_5_1 = 3
	local var_5_2 = var_0_0.new(arg_5_0.gameObject:clone())
	local var_5_3 = var_5_2.node
	local var_5_4 = cc.p(-var_5_3:size().width / 2 + var_5_0.x + 250, var_5_3:size().height / 2 - var_5_0.y)

	arg_5_0.parent:addItemToScrollView(arg_5_0.gameObjects, var_5_3, var_5_0, var_5_4, var_5_1)
	var_5_3:onTouch(functools.handler(arg_5_0, arg_5_0.dragSprite, var_5_2))
	var_5_3:addClickEventListener(functools.handler(arg_5_0.parent, arg_5_0.parent.onlyShowSelect, arg_5_0.gameObjects, var_5_2))
	var_5_3:get("del"):addClickEventListener(functools.handler(arg_5_0, arg_5_0.delGameObject, var_5_2))
	table.insert(arg_5_0.scene, var_5_2)

	arg_5_2 = arg_5_2 or arg_5_0:indexToSeat(#arg_5_0.scene)

	var_5_2:init(#arg_5_0.scene, arg_5_2, arg_5_1)
end

function var_0_2.delGameObject(arg_6_0, arg_6_1)
	if arg_6_0.lastClickObj and arg_6_0.lastClickObj.id == arg_6_1.id then
		arg_6_0.lastClickObj = nil

		arg_6_0.parent:showAttr()
	end

	arg_6_1:init(arg_6_1.index)
end

function var_0_2.cleanGameObject(arg_7_0)
	arg_7_0.gameObjects:removeAllChildren()

	arg_7_0.scene = {}

	for iter_7_0 = 1, 24 do
		arg_7_0:addGameObject()
	end
end

function var_0_2.getGameObjectIndex(arg_8_0, arg_8_1)
	arg_8_1 = arg_8_1 > 11 and arg_8_1 + 3 or arg_8_1
	arg_8_1 = arg_8_1 > 20 and arg_8_1 + 3 or arg_8_1

	return arg_8_1 > 5 and arg_8_1 + 3 or arg_8_1
end

function var_0_2.getFightRoleData(arg_9_0, arg_9_1)
	local var_9_0 = {}
	local var_9_1 = {}
	local var_9_2 = {
		0,
		0
	}
	local var_9_3

	for iter_9_0, iter_9_1 in ipairs(arg_9_0.scene) do
		local var_9_4 = iter_9_1:getRoleData()

		if var_9_4 then
			if iter_9_0 < 13 then
				var_9_0[iter_9_1.seat] = var_9_4
			else
				var_9_1[iter_9_1.seat] = var_9_4
			end

			var_9_2[iter_9_1.force] = var_9_2[iter_9_1.force] + 1
		end
	end

	if var_9_2[1] == 0 or var_9_2[2] == 0 then
		var_9_0 = {}
		var_9_1 = {}
	end

	if arg_9_1 then
		var_9_0 = {}
		var_9_1 = {}

		for iter_9_2, iter_9_3 in ipairs(arg_9_1.left) do
			if iter_9_3 ~= 0 then
				local var_9_5 = Prefab.new()

				var_9_5:init(iter_9_3, clone(arg_9_1.DefaultAttr))

				if iter_9_2 < 7 then
					var_9_0[iter_9_2] = var_9_5:getRoleData()
				else
					var_9_1[iter_9_2 - 6] = var_9_5:getRoleData()
				end
			end
		end

		for iter_9_4, iter_9_5 in ipairs(arg_9_1.right) do
			if iter_9_5 ~= 0 then
				local var_9_6 = Prefab.new()

				var_9_6:init(iter_9_5, clone(arg_9_1.DefaultAttr))

				if iter_9_4 < 7 then
					var_9_0[6 + iter_9_4] = var_9_6:getRoleData()
				else
					var_9_1[iter_9_4] = var_9_6:getRoleData()
				end
			end
		end
	end

	return {
		{
			{
				var_9_0,
				var_9_1
			},
			{
				var_9_0,
				var_9_1
			}
		}
	}
end

return var_0_2
