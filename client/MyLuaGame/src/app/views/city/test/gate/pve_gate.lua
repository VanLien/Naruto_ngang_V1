local var_0_0 = require("app.views.city.test.model.gameobject")
local var_0_1 = require("app.views.city.test.model.prefab")
local var_0_2 = require("app.views.city.test.gate.gate")
local var_0_3 = class("PveGate", var_0_2)
local var_0_4 = {
	dailyGold = 3,
	gift = 7,
	simpleActivity = 16,
	endlessTower = 5,
	dailyExp = 4,
	worldBoss = 15,
	unionFuben = 6,
	fragment = 8,
	gym = 18,
	Normal = 1
}
local var_0_5 = {
	"普通关卡",
	nil,
	"金币副本",
	"经验副本",
	"冒险之路",
	"公会副本",
	"礼物副本",
	"碎片副本",
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	"世界boss",
	"活动副本",
	nil,
	"道馆副本"
}

function var_0_3.init(arg_1_0)
	for iter_1_0 = 1, 6 do
		arg_1_0:addGameObject()
	end

	arg_1_0.curGateType = 1

	arg_1_0:initBtnGateType()
end

function var_0_3.initRecordGateAndSceneID(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.curGateType = arg_2_1

	arg_2_0:refreshBtnGateType()
	arg_2_0.parent.textSceneID:setText(arg_2_2)
end

function var_0_3.initBtnGateType(arg_3_0)
	arg_3_0.parent.gateTypeList:hide()
	arg_3_0:refreshBtnGateType()
	arg_3_0.parent.btnGateType:addClickEventListener(functools.handler(arg_3_0, arg_3_0.showGateTypeList))

	for iter_3_0, iter_3_1 in pairs(var_0_4) do
		local var_3_0 = arg_3_0.parent.btnItem:clone()

		var_3_0:get("label"):setString(var_0_5[iter_3_1])
		var_3_0:addClickEventListener(functools.handler(arg_3_0, arg_3_0.changeGateType, iter_3_1))
		arg_3_0.parent.gateTypeList:pushBackCustomItem(var_3_0)
	end
end

function var_0_3.refreshBtnGateType(arg_4_0)
	arg_4_0.parent.btnGateType:get("label"):setString(var_0_5[arg_4_0.curGateType])
end

function var_0_3.showGateTypeList(arg_5_0)
	arg_5_0.parent.gateTypeList:setVisible(not arg_5_0.parent.gateTypeList:isVisible())
end

function var_0_3.changeGateType(arg_6_0, arg_6_1)
	arg_6_0.parent.gateTypeList:hide()

	arg_6_0.curGateType = arg_6_1

	arg_6_0.parent.btnGateType:get("label"):setString(var_0_5[arg_6_0.curGateType])
end

function var_0_3.getCurGateType(arg_7_0)
	return arg_7_0.curGateType or 1
end

function var_0_3.parseRecord(arg_8_0, arg_8_1)
	arg_8_0:cleanGameObject()

	for iter_8_0, iter_8_1 in pairs(arg_8_1) do
		if iter_8_0 < 7 then
			local var_8_0 = arg_8_0:indexToSeat(iter_8_0)

			arg_8_0:initGameObjectByRoleId(var_8_0, iter_8_0, iter_8_1.roleId, iter_8_1)
		end
	end
end

function var_0_3.parseScene(arg_9_0, arg_9_1)
	arg_9_0:cleanGameObject()

	if arg_9_1 and next(arg_9_1) then
		for iter_9_0, iter_9_1 in pairs(arg_9_1) do
			if iter_9_0 < 13 then
				arg_9_0:initGameObjectByRoleId(iter_9_1.index, arg_9_0:indexToSeat(iter_9_0), iter_9_1._prefab.roleId, iter_9_1._prefab.data)
			end
		end
	end
end

function var_0_3.addGameObject(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_1 then
		for iter_10_0, iter_10_1 in ipairs(arg_10_0.scene) do
			if not iter_10_1:getRoleData() then
				arg_10_2 = arg_10_2 or iter_10_1.seat

				iter_10_1:init(iter_10_1.index, arg_10_2, arg_10_1)

				break
			end
		end

		return
	end

	local var_10_0 = cc.p(10, 2)
	local var_10_1 = 3
	local var_10_2 = var_0_0.new(arg_10_0.gameObject:clone())
	local var_10_3 = var_10_2.node
	local var_10_4 = cc.p(var_10_3:size().width / 2 + var_10_0.x + 220, var_10_3:size().height / 2 - var_10_0.y)

	arg_10_0.parent:addItemToScrollView(arg_10_0.gameObjects, var_10_3, var_10_0, var_10_4, var_10_1)
	var_10_3:onTouch(functools.handler(arg_10_0, arg_10_0.dragSprite, var_10_2))
	var_10_3:addClickEventListener(functools.handler(arg_10_0.parent, arg_10_0.parent.onlyShowSelect, arg_10_0.gameObjects, var_10_2))
	var_10_3:get("del"):addClickEventListener(functools.handler(arg_10_0, arg_10_0.delGameObject, var_10_2))
	table.insert(arg_10_0.scene, var_10_2)

	arg_10_2 = arg_10_2 or arg_10_0:indexToSeat(#arg_10_0.scene)

	var_10_2:init(#arg_10_0.scene, arg_10_2, arg_10_1)
end

function var_0_3.exchange(arg_11_0)
	local var_11_0 = {}

	for iter_11_0, iter_11_1 in pairs(arg_11_0.scene) do
		var_11_0[arg_11_0:exchangeSeat(iter_11_1.seat)] = iter_11_1:getRoleData()
	end

	arg_11_0:cleanGameObject()

	for iter_11_2, iter_11_3 in pairs(arg_11_0.scene) do
		if var_11_0[iter_11_3.seat] then
			iter_11_3:initByRoleData(iter_11_3.index, iter_11_3.seat, var_11_0[iter_11_3.seat])
		end
	end
end

function var_0_3.delGameObject(arg_12_0, arg_12_1)
	if arg_12_0.lastClickObj and arg_12_0.lastClickObj.id == arg_12_1.id then
		arg_12_0.lastClickObj = nil

		arg_12_0.parent:showAttr()
	end

	arg_12_1:init(arg_12_1.index, arg_12_1.seat)
end

function var_0_3.cleanGameObject(arg_13_0)
	arg_13_0.gameObjects:removeAllChildren()

	arg_13_0.scene = {}

	for iter_13_0 = 1, 6 do
		arg_13_0:addGameObject()
	end
end

function var_0_3.getGameObjectIndex(arg_14_0, arg_14_1)
	return arg_14_1 > 5 and arg_14_1 + 3 or arg_14_1
end

function var_0_3.getFightRoleData(arg_15_0, arg_15_1)
	local var_15_0 = {}
	local var_15_1 = {
		0,
		0
	}
	local var_15_2

	if arg_15_0.scene then
		for iter_15_0, iter_15_1 in ipairs(arg_15_0.scene) do
			local var_15_3 = iter_15_1:getRoleData()

			if var_15_3 then
				var_15_0[iter_15_1.seat] = var_15_3
			end
		end
	end

	if arg_15_1 then
		var_15_0 = {}

		for iter_15_2, iter_15_3 in ipairs(arg_15_1.left) do
			if iter_15_3 ~= 0 then
				local var_15_4 = var_0_1.new()

				var_15_4:init(iter_15_3, clone(arg_15_1.DefaultAttr))

				var_15_0[iter_15_2] = var_15_4:getRoleData()
			end
		end
	end

	return {
		var_15_0
	}
end

return var_0_3
