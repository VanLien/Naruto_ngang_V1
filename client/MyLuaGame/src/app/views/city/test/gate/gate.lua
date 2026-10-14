local var_0_0 = require("app.views.city.test.model.gameobject")
local var_0_1 = class("Gate")

function var_0_1.ctor(arg_1_0, arg_1_1)
	arg_1_0.parent = arg_1_1
	arg_1_0.scene = {}
	arg_1_0.gameObjects = arg_1_1.gameObjects
	arg_1_0.gameObject = arg_1_1.gameObject
	arg_1_0.lastClickObj = nil
end

function var_0_1.init(arg_2_0)
	return
end

function var_0_1.parseScene(arg_3_0, arg_3_1)
	if arg_3_1 and next(arg_3_1) then
		for iter_3_0, iter_3_1 in pairs(arg_3_1) do
			arg_3_0:addGameObject(iter_3_1, iter_3_0)
		end
	end
end

function var_0_1.parseRecord(arg_4_0, arg_4_1)
	return
end

function var_0_1.initGameObjectByRoleId(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if not arg_5_0.parent.resources[arg_5_3] then
		arg_5_0.parent:addRes(arg_5_3, arg_5_4)
	end

	arg_5_0.scene[arg_5_1]:init(arg_5_1, arg_5_2, arg_5_0.parent.resources[arg_5_3])
	arg_5_0.scene[arg_5_1]:loadRoleData(arg_5_4)
end

function var_0_1.addGameObject(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = cc.p(10, 2)
	local var_6_1 = 3
	local var_6_2 = var_0_0.new(arg_6_0.gameObject:clone())
	local var_6_3 = var_6_2.node
	local var_6_4 = cc.p(var_6_3:size().width / 2 + var_6_0.x, var_6_3:size().height / 2 - var_6_0.y)

	arg_6_0.parent:addItemToScrollView(arg_6_0.gameObjects, var_6_3, var_6_0, var_6_4, var_6_1)
	var_6_3:addClickEventListener(functools.handler(arg_6_0.parent, arg_6_0.parent.onlyShowSelect, arg_6_0.gameObjects, var_6_2))
	var_6_3:get("del"):addClickEventListener(functools.handler(arg_6_0, arg_6_0.delGameObject, var_6_2))
	table.insert(arg_6_0.scene, var_6_2)

	arg_6_2 = arg_6_2 or #arg_6_0.scene

	var_6_2:init(#arg_6_0.scene, arg_6_2, arg_6_1)
end

function var_0_1.delGameObject(arg_7_0, arg_7_1)
	if arg_7_0.lastClickObj and arg_7_0.lastClickObj.id == arg_7_1.id then
		arg_7_0.lastClickObj = nil

		arg_7_0.parent:showAttr()
	end

	arg_7_0.scene[arg_7_1.index] = arg_7_0.scene[#arg_7_0.scene]
	arg_7_0.scene[#arg_7_0.scene] = nil

	arg_7_0.parent:delItemFromScrollView(arg_7_0.gameObjects, arg_7_1.node)
	arg_7_1:clean()
end

function var_0_1.cleanGameObject(arg_8_0)
	arg_8_0.gameObjects:removeAllChildren()

	arg_8_0.scene = {}
end

function var_0_1.exchange(arg_9_0)
	return
end

function var_0_1.exchangeSeat(arg_10_0, arg_10_1)
	return ({
		7,
		8,
		9,
		10,
		11,
		12,
		1,
		2,
		3,
		4,
		5,
		6
	})[arg_10_1]
end

function var_0_1.indexToSeat(arg_11_0, arg_11_1)
	return ({
		4,
		5,
		6,
		1,
		2,
		3
	})[arg_11_1] or arg_11_1
end

function var_0_1.getGameObjectIndex(arg_12_0, arg_12_1)
	return arg_12_1
end

function var_0_1.getFightRoleData(arg_13_0)
	return {}
end

function var_0_1.dragSprite(arg_14_0, arg_14_1, arg_14_2)
	if arg_14_1.roleId <= 0 then
		return
	end

	local var_14_0

	if arg_14_2.name == "began" then
		arg_14_0.gameObjects:setDirection(0)

		arg_14_0.parent.dragSpriteNow.collider = nil

		local var_14_1 = arg_14_2.target:getTouchBeganPosition()
	elseif arg_14_2.name == "moved" then
		local var_14_2 = arg_14_0.parent.dragSpriteNow:get("icon")
		local var_14_3 = arg_14_2.target:getTouchMovePosition()
		local var_14_4 = arg_14_0.parent.dragSpriteNow.collider and arg_14_0.parent.dragSpriteNow.collider:getRect() or nil

		if not var_14_2 then
			widget.addAnimation(arg_14_0.parent.dragSpriteNow, arg_14_1.unit.unitRes, "standby_loop", 5):name("icon"):anchorPoint(0.5, 1):xy(0, 10):scale(1):setSkin(arg_14_1.unit.skin)
		end

		arg_14_0.parent.dragSpriteNow:xy(var_14_3.x, var_14_3.y)

		if cc.rectContainsPoint(arg_14_0.parent.gameObjectsRect, var_14_3) then
			if var_14_4 and cc.rectContainsPoint(var_14_4, var_14_3) then
				return
			end

			for iter_14_0, iter_14_1 in ipairs(arg_14_0.scene) do
				local var_14_5 = iter_14_1:getRect()

				if cc.rectContainsPoint(iter_14_1:getRect(), var_14_3) then
					arg_14_0.parent.dragSpriteNow.collider = iter_14_1

					arg_14_0.parent.drawNode:clear()
					arg_14_0.parent.drawNode:drawRect(cc.p(var_14_5.x, var_14_5.y), cc.p(var_14_5.x + var_14_5.width, var_14_5.y + var_14_5.height), cc.c4f(1, 0, 0, 1))

					return
				end
			end
		end

		arg_14_0.parent.drawNode:clear()

		arg_14_0.parent.dragSpriteNow.collider = nil
	elseif arg_14_2.name == "ended" or arg_14_2.name == "cancelled" then
		local var_14_6 = arg_14_0.parent.dragSpriteNow:get("icon")
		local var_14_7 = arg_14_2.target:getTouchMovePosition()

		if arg_14_0.parent.dragSpriteNow.collider and arg_14_0.parent.dragSpriteNow.collider.roleId ~= arg_14_1.roleId then
			arg_14_0.parent.dragSpriteNow.collider:init(arg_14_0.parent.dragSpriteNow.collider.index, arg_14_0.parent.dragSpriteNow.collider.seat, arg_14_1)
			arg_14_0.parent.drawNode:clear()

			arg_14_0.parent.dragSpriteNow.collider = nil
		end

		if var_14_6 then
			var_14_6:removeFromParent()
		end

		arg_14_0.gameObjects:setDirection(2)
	end
end

return var_0_1
