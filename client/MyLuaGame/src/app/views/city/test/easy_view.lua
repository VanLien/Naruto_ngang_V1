local var_0_0 = {
	CustomBtnType = {
		Center = 2,
		RightToLeft = 3,
		LeftToRight = 1
	},
	stage = {},
	btnItem = {}
}

function var_0_0.initBaseView(arg_1_0)
	local var_1_0 = {
		root = ccui.Layout:create():size(arg_1_0.stage:width(), arg_1_0.stage:height()):setBackGroundColorType(ccui.LayoutBackGroundColorType.solid):color(cc.c3b(0, 0, 0)):opacity(200):addTo(arg_1_0.stage, 9999, "baseView"):xy(0, 0):setTouchEnabled(true):setSwallowTouches(true)
	}

	var_0_0.addBtnListToView(var_1_0, {
		"btnClose|关闭"
	}, cc.p(arg_1_0.stage:width() / 2, 100), var_0_0.CustomBtnType.Center)

	return var_1_0
end

function var_0_0.initScrollView(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = var_0_0.initBaseView(arg_2_0)

	var_2_0.scrollView = ccui.ScrollView:create():size(arg_2_0.stage:width(), arg_2_0.stage:height() - 200):setInnerContainerSize(cc.size(arg_2_1 or arg_2_0.stage:width() * 4, arg_2_2 or arg_2_0.stage:height() - 200)):setBackGroundColorType(ccui.LayoutBackGroundColorType.solid):color(cc.c3b(0, 255, 0)):opacity(100):xy(0, 200):setTouchEnabled(true):setSwallowTouches(true):addTo(var_2_0.root, 1, "scrollView"):setDirection(0)

	return var_2_0
end

local var_0_1 = 700
local var_0_2 = 300

function var_0_0.initForceScrollView(arg_3_0, arg_3_1)
	local var_3_0 = var_0_0.initBaseView(arg_3_0)

	var_3_0.leftFrontUnitScrollView = ccui.ScrollView:create():size(var_0_2, (arg_3_0.stage:height() - 200) / 2):setInnerContainerSize(cc.size(var_0_2, (arg_3_0.stage:height() - 200) / 2 + 100)):setBackGroundColorType(ccui.LayoutBackGroundColorType.solid):color(cc.c3b(255, 0, 0)):opacity(100):xy(0, 200 + (arg_3_0.stage:height() - 200) / 2):setTouchEnabled(true):setSwallowTouches(true):addTo(var_3_0.root, 1, "scrollView"):setDirection(1)
	var_3_0.leftBackUnitScrollView = ccui.ScrollView:create():size(var_0_2, (arg_3_0.stage:height() - 200) / 2):setInnerContainerSize(cc.size(var_0_2, (arg_3_0.stage:height() - 200) / 2 + 100)):setBackGroundColorType(ccui.LayoutBackGroundColorType.solid):color(cc.c3b(255, 0, 0)):opacity(100):xy(0, 200):setTouchEnabled(true):setSwallowTouches(true):addTo(var_3_0.root, 1, "scrollView"):setDirection(1)
	var_3_0.rightFrontUnitScrollView = ccui.ScrollView:create():size(var_0_2, (arg_3_0.stage:height() - 200) / 2):setInnerContainerSize(cc.size(var_0_2, (arg_3_0.stage:height() - 200) / 2 + 100)):setBackGroundColorType(ccui.LayoutBackGroundColorType.solid):color(cc.c3b(0, 0, 255)):opacity(100):xy(var_0_2, 200 + (arg_3_0.stage:height() - 200) / 2):setTouchEnabled(true):setSwallowTouches(true):addTo(var_3_0.root, 1, "scrollView"):setDirection(1)
	var_3_0.rightBackUnitScrollView = ccui.ScrollView:create():size(var_0_2, (arg_3_0.stage:height() - 200) / 2):setInnerContainerSize(cc.size(var_0_2, (arg_3_0.stage:height() - 200) / 2 + 100)):setBackGroundColorType(ccui.LayoutBackGroundColorType.solid):color(cc.c3b(0, 0, 255)):opacity(100):xy(var_0_2, 200):setTouchEnabled(true):setSwallowTouches(true):addTo(var_3_0.root, 1, "scrollView"):setDirection(1)
	var_3_0.scrollForceView = ccui.ScrollView:create():size(arg_3_0.stage:width() - var_0_1 - 2 * var_0_2, arg_3_0.stage:height() - 200):setInnerContainerSize(cc.size(arg_3_1 or arg_3_0.stage:width() * 4, arg_3_0.stage:height() - 200)):setBackGroundColorType(ccui.LayoutBackGroundColorType.solid):color(cc.c3b(0, 255, 0)):opacity(100):xy(var_0_2 * 2, 200):setTouchEnabled(true):setSwallowTouches(true):addTo(var_3_0.root, 1, "scrollView"):setDirection(2)
	var_3_0.attrView = ccui.ListView:create():size(var_0_1, arg_3_0.stage:height() - 200):setInnerContainerSize(cc.size(var_0_1, arg_3_0.stage:height() * 2)):setBackGroundColorType(ccui.LayoutBackGroundColorType.solid):color(cc.c3b(123, 123, 123)):opacity(100):addTo(var_3_0.root, 1, "attrView"):xy(arg_3_0.stage:width() - var_0_1, 200):setTouchEnabled(true):setSwallowTouches(true):setItemsMargin(5)

	return var_3_0
end

function var_0_0.initForceAttrView(arg_4_0, arg_4_1)
	return
end

function var_0_0.initListView(arg_5_0)
	local var_5_0 = var_0_0.initBaseView(arg_5_0)

	var_5_0.listView = ccui.ListView:create():size(arg_5_0.stage:width(), arg_5_0.stage:height() - 200):setInnerContainerSize(cc.size(arg_5_0.stage:width(), arg_5_0.stage:height() * 2)):setBackGroundColorType(ccui.LayoutBackGroundColorType.solid):color(cc.c3b(0, 255, 0)):opacity(100):xy(0, 200):setTouchEnabled(true):setSwallowTouches(true):addTo(var_5_0.root, 1, "listView"):setItemsMargin(5)

	return var_5_0
end

function var_0_0.addTextListView(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_0.listView then
		arg_6_0.listView:removeAllItems()

		return
	end

	arg_6_0.listView = ccui.ListView:create():size(arg_6_2):setInnerContainerSize(arg_6_2):setBackGroundColorType(ccui.LayoutBackGroundColorType.solid):color(cc.c3b(0, 255, 0)):opacity(100):xy(arg_6_1):setTouchEnabled(true):setSwallowTouches(true):addTo(arg_6_0.root, 1, "listView"):setItemsMargin(5)
end

function var_0_0.addInputControl(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = ccui.EditBox:create(cc.size(600, 100), "img/editor/input.png"):addTo(arg_7_0.root, 1, "input"):setFontSize(72):setFontColor(ui.COLORS.NORMAL.DEFAULT):xy(arg_7_1):setInputMode(arg_7_2):setPlaceHolder(arg_7_3)

	if arg_7_4 then
		arg_7_0.editBox = arg_7_0.editBox or {}
		arg_7_0.editBox[arg_7_4] = var_7_0
	else
		arg_7_0.editBox = var_7_0
	end
end

function var_0_0.addBtnListToView(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0
	local var_8_1
	local var_8_2 = 10

	if arg_8_0.btnClose then
		arg_8_0.btnClose:removeSelf()

		arg_8_0.btnClose = nil
	end

	if arg_8_3 == var_0_0.CustomBtnType.Center then
		var_8_0 = cc.p(arg_8_2.x - (var_0_0.btnItem:width() / 3 + var_8_2) * (#arg_8_1 - 1), arg_8_2.y)
		var_8_1 = cc.p(var_0_0.btnItem:width() / 3 * 2 + 2 * var_8_2, 0)
	end

	local var_8_3
	local var_8_4
	local var_8_5

	for iter_8_0, iter_8_1 in ipairs(arg_8_1) do
		local var_8_6 = iter_8_0 - 1
		local var_8_7 = string.split(iter_8_1, "|")
		local var_8_8 = var_0_0.btnItem:clone()

		var_8_8:get("label"):text(var_8_7[2])
		var_8_8:addTo(arg_8_0.root, 1, var_8_7[1]):xy(var_8_0.x + var_8_1.x * var_8_6, var_8_0.y + var_8_1.y * var_8_6)

		if var_8_7[1] == "btnClose" then
			var_8_8:addClickEventListener(function()
				arg_8_0.root:removeSelf()
			end)
		end

		arg_8_0[var_8_7[1]] = var_8_8
	end
end

return var_0_0
