local var_0_0 = 0
local var_0_1 = class("GameObject")

function var_0_1.ctor(arg_1_0, arg_1_1)
	arg_1_0.node = arg_1_1
	arg_1_0.unit = {}
	arg_1_0.roleData = {}
	arg_1_0.force = 1
	arg_1_0.seat = 0
	arg_1_0.index = 0
	arg_1_0.selectShowChild = {
		"del"
	}

	text.addEffect(arg_1_0.node:get("heroName"), {
		italic = true,
		color = ui.COLORS.GREEN,
		outline = {
			color = ui.COLORS.BLUE
		},
		shadow = {
			size = 6,
			color = ui.COLORS.RED,
			offset = cc.size(6, -6)
		}
	})

	var_0_0 = var_0_0 + 1
	arg_1_0.id = var_0_0

	arg_1_0.node:setName("gameObject_" .. var_0_0)
end

function var_0_1._init(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0.unit = arg_2_3 and csv.unit[arg_2_3.roleId] or {}
	arg_2_0.roleId = arg_2_3 and arg_2_3.roleId or 0
	arg_2_0.roleData.roleId = arg_2_0.roleId
	arg_2_0.index = arg_2_1
	arg_2_0.seat = arg_2_2 or arg_2_1
	arg_2_0.force = arg_2_0.seat > 6 and 2 or 1

	if arg_2_0.node:get("icon") then
		arg_2_0.node:get("icon"):removeFromParent()
	end

	if arg_2_0.unit.unitRes then
		local var_2_0 = arg_2_0.force == 2 and -1 or 1

		widget.addAnimation(arg_2_0.node, arg_2_0.unit.unitRes, "standby_loop", 5):name("icon"):anchorPoint(0.5, 0):xy(arg_2_0.node:size().width / 2, 80):scale(var_2_0 * 2, 2):setSkin(arg_2_0.unit.skin)
	end

	local var_2_1 = arg_2_0.node:get("heroName")

	if arg_2_0.unit.name then
		var_2_1:text(arg_2_0.unit.name)
	else
		var_2_1:text("heroName")
	end

	for iter_2_0, iter_2_1 in ipairs(arg_2_0.selectShowChild) do
		arg_2_0.node:get(iter_2_1):visible(false)
	end
end

function var_0_1.init(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0.roleData = arg_3_3 and arg_3_3:getRoleData() or {}
	arg_3_0.prefab = arg_3_3

	arg_3_0:_init(arg_3_1, arg_3_2, arg_3_3)
end

function var_0_1.initByObject(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	arg_4_0.roleData = arg_4_3 and arg_4_3:getRoleData() or {}

	arg_4_0:_init(arg_4_1, arg_4_2, arg_4_3)
end

function var_0_1.initByRoleData(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_0.roleData = arg_5_3 or {}

	arg_5_0:_init(arg_5_1, arg_5_2, arg_5_3)
end

function var_0_1.clean(arg_6_0)
	arg_6_0.node:removeFromParent()
end

function var_0_1.loadRoleData(arg_7_0, arg_7_1)
	arg_7_1 = arg_7_1 or {}

	for iter_7_0, iter_7_1 in pairs(arg_7_1) do
		arg_7_0.roleData[iter_7_0] = iter_7_1
	end
end

function var_0_1.getRect(arg_8_0)
	local var_8_0 = arg_8_0.node:parent():convertToWorldSpace(cc.p(arg_8_0.node:x(), arg_8_0.node:y()))
	local var_8_1 = cc.size(arg_8_0.node:width() * arg_8_0.node:scaleX(), arg_8_0.node:height() * arg_8_0.node:scaleY())
	local var_8_2 = cc.p(var_8_0.x - var_8_1.width / 2, var_8_0.y - var_8_1.height / 2)

	return cc.rect(var_8_2.x, var_8_2.y, var_8_1.width, var_8_1.height)
end

function var_0_1.getRoleData(arg_9_0)
	return arg_9_0.roleId ~= 0 and csvClone(arg_9_0.roleData) or nil
end

return var_0_1
