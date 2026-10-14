local var_0_0 = require("app.views.city.card.chip.tools")
local var_0_1 = {
	90,
	615,
	1130,
	1640
}

local function var_0_2(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_0:size().width
	local var_1_1 = arg_1_0.item01:clone():anchorPoint(cc.p(0, 0.5)):xy(arg_1_3, 36):addTo(arg_1_1):show():multiget("txtTitle", "img01", "img02")

	var_1_1.txtTitle:text(arg_1_2.title)
	adapt.oneLineCenterPos(cc.p(800, 50), {
		var_1_1.img02,
		var_1_1.txtTitle,
		var_1_1.img01
	}, cc.p(10, 0))
end

local function var_0_3(arg_2_0, arg_2_1, arg_2_2)
	arg_2_1:size(cc.size(listW, 73))

	local var_2_0 = arg_2_0.item02:clone():anchorPoint(cc.p(0, 0.5)):xy(0, 36):addTo(arg_2_1):show()

	for iter_2_0 = 1, 3 do
		var_2_0:get("item0" .. iter_2_0):visible(false)
	end

	for iter_2_1, iter_2_2 in pairs(arg_2_2) do
		local var_2_1 = var_2_0:get("item0" .. iter_2_1)

		var_2_1:visible(true)

		local var_2_2 = var_2_1:multiget("imgAttr", "txtAttrName", "txtAttrCount")

		var_2_2.txtAttrCount:text("+" .. iter_2_2.val)
		var_2_2.txtAttrName:text(getLanguageAttr(iter_2_2.attr))

		if ui.ATTR_LOGO[iter_2_2.attr] and not string.match(iter_2_2.val, "%%") then
			var_2_2.imgAttr:texture(ui.ATTR_LOGO[iter_2_2.attr])
			adapt.oneLinePos(var_2_2.imgAttr, {
				var_2_2.txtAttrName,
				var_2_2.txtAttrCount
			}, {
				cc.p(5, 0),
				cc.p(10, 0)
			})
		else
			var_2_2.imgAttr:visible(false)
			var_2_2.txtAttrName:xy(var_2_2.imgAttr:xy())
			text.addEffect(var_2_2.txtAttrCount, {
				color = cc.c3b(145, 225, 177)
			})
			adapt.oneLinePos(var_2_2.txtAttrName, var_2_2.txtAttrCount, cc.p(10, 0))
		end
	end
end

local function var_0_4(arg_3_0, arg_3_1, arg_3_2)
	arg_3_1:size(cc.size(listW, 73))

	local var_3_0 = arg_3_0.item02:clone():anchorPoint(cc.p(0, 0.5)):xy(0, 36):addTo(arg_3_1):show()

	for iter_3_0 = 1, 3 do
		var_3_0:get("item0" .. iter_3_0):visible(false)
	end

	for iter_3_1, iter_3_2 in pairs(arg_3_2) do
		local var_3_1 = var_3_0:get("item0" .. iter_3_1)

		var_3_1:visible(true)

		local var_3_2 = var_3_1:multiget("icon", "text", "val", "up1", "upVal", "upIcon", "up2")

		if type(iter_3_2.val) == "table" then
			itertools.invoke({
				var_3_2.up1,
				var_3_2.upVal,
				var_3_2.upIcon,
				var_3_2.up2
			}, "show")
			var_3_2.val:text(iter_3_2.val[1])
			var_3_2.upVal:text(iter_3_2.val[4])

			if iter_3_2.val[3] == 0 then
				var_3_2.upIcon:hide()
				text.addEffect(var_3_2.upVal, {
					color = cc.c4b(183, 176, 158, 255)
				})
			elseif iter_3_2.val[3] > 0 then
				var_3_2.upIcon:texture("common/icon/logo_arrow_green.png")
				text.addEffect(var_3_2.upVal, {
					color = ui.COLORS.QUALITY_DARK[2]
				})
			else
				var_3_2.upIcon:texture("common/icon/logo_arrow_red.png")
				text.addEffect(var_3_2.upVal, {
					color = ui.COLORS.QUALITY_DARK[6]
				})
			end
		end

		var_3_2.text:text(getLanguageAttr(iter_3_2.attr))

		if ui.ATTR_LOGO[iter_3_2.attr] and not string.match(iter_3_2.val[1], "%%") and not string.match(iter_3_2.val[4], "%%") then
			var_3_2.icon:texture(ui.ATTR_LOGO[iter_3_2.attr])
			adapt.oneLinePos(var_3_2.icon, {
				var_3_2.text,
				var_3_2.val,
				var_3_2.up1,
				var_3_2.upVal,
				var_3_2.upIcon,
				var_3_2.up2
			}, cc.p(10, 0))
		else
			var_3_2.icon:visible(false)
			var_3_2.text:xy(var_3_2.icon:xy())
			adapt.oneLinePos(var_3_2.text, {
				var_3_2.val,
				var_3_2.up1,
				var_3_2.upVal,
				var_3_2.upIcon,
				var_3_2.up2
			}, cc.p(10, 0))
		end
	end
end

local function var_0_5(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_0:size().width

	arg_4_1:size(cc.size(var_4_0, 72))

	local var_4_1 = csv.chip.resonance[arg_4_2.id]
	local var_4_2 = var_4_1.param
	local var_4_3 = ""

	if var_4_1.type == 1 then
		var_4_3 = string.format(gLanguageCsv.chipAttr01, var_4_2[1], ui.QUALITY_DARK_COLOR[var_4_2[2]], gLanguageCsv[ui.QUALITY_COLOR_TEXT[var_4_2[2]]])
	else
		var_4_3 = string.format(gLanguageCsv.chipAttr07, var_4_2[1], var_4_2[2])
	end

	local var_4_4 = rich.createWithWidth(var_4_3, 40, nil, 1000, nil, cc.p(0, 0.5)):anchorPoint(cc.p(0, 0.5)):xy(var_0_1[1] + arg_4_3, 36):addTo(arg_4_1)
	local var_4_5 = {}

	for iter_4_0 = 1, math.huge do
		local var_4_6 = var_4_1["attrType" .. iter_4_0]

		if var_4_6 and var_4_6 ~= 0 then
			local var_4_7 = dataEasy.getAttrValueString(var_4_6, var_4_1["attrNum" .. iter_4_0])
			local var_4_8 = {
				key = var_4_6,
				val = var_4_7
			}

			table.insert(var_4_5, var_4_8)
		else
			break
		end
	end

	local var_4_9 = var_0_0.getBaseAttr(var_4_5)

	table.sort(var_4_9, function(arg_5_0, arg_5_1)
		return arg_5_0.key < arg_5_1.key
	end)

	for iter_4_1, iter_4_2 in ipairs(var_4_9) do
		local var_4_10 = var_0_0.getAttrName(iter_4_2.key)
		local var_4_11 = string.format("#C0xFFFCED#%s #C0x91e1b1#+%s", var_4_10, iter_4_2.val)
		local var_4_12 = rich.createWithWidth(var_4_11, 40, nil, 1000, nil, cc.p(0, 0.5)):anchorPoint(cc.p(0, 0.5)):xy(var_0_1[iter_4_1 + 1] + arg_4_3, 36):addTo(arg_4_1)
	end
end

local function var_0_6(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0:size().width

	arg_6_1:size(cc.size(var_6_0, 300))

	local var_6_1 = arg_6_2 == 1 and gLanguageCsv.chipHaveNot or gLanguageCsv.chipHaveNotResonance
	local var_6_2 = arg_6_1:get("txtTip")

	var_6_2:text(var_6_1)
	var_6_2:visible(true)
	var_6_2:xy(var_6_0 / 2, 150)
end

local var_0_7 = cc.load("mvc").ViewBase
local var_0_8 = class("ChipTotalAttrView", var_0_7)

var_0_8.RESOURCE_FILENAME = "chip_base_attr.json"
var_0_8.RESOURCE_BINDING = {
	item02 = "item02",
	item = "item",
	item03 = "item03",
	item04 = "item04",
	item01 = "item01",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showDatas"),
				item = bindHelper.self("item"),
				item01 = bindHelper.self("item01"),
				item02 = bindHelper.self("item02"),
				item03 = bindHelper.self("item03"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					if arg_7_3.sign == 1 then
						var_0_2(arg_7_0, arg_7_1, arg_7_3, 0)
					elseif arg_7_3.sign == 2 then
						if arg_7_3.id == 0 then
							var_0_6(arg_7_0, arg_7_1, 2)
						else
							var_0_5(arg_7_0, arg_7_1, arg_7_3, 0)
						end
					elseif #arg_7_3 == 0 then
						var_0_6(arg_7_0, arg_7_1, 1)
					else
						var_0_3(arg_7_0, arg_7_1, arg_7_3)
					end
				end,
				onAfterBuild = function(arg_8_0)
					local var_8_0 = arg_8_0:getInnerContainerSize()
					local var_8_1 = arg_8_0:getContentSize()

					if var_8_0.height <= var_8_1.height then
						arg_8_0:setTouchEnabled(false)
					end
				end
			}
		}
	},
	compareList = {
		varname = "compareList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showCompareDatas"),
				item = bindHelper.self("item03"),
				item01 = bindHelper.self("item01"),
				item02 = bindHelper.self("item04"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
					if arg_9_3.sign == 1 then
						var_0_2(arg_9_0, arg_9_1, arg_9_3, 200)
					elseif arg_9_3.sign == 2 then
						if arg_9_3.id == 0 then
							var_0_6(arg_9_0, arg_9_1, 2)
						else
							var_0_5(arg_9_0, arg_9_1, arg_9_3, 200)
						end
					elseif #arg_9_3 == 0 then
						var_0_6(arg_9_0, arg_9_1, 1)
					else
						var_0_4(arg_9_0, arg_9_1, arg_9_3)
					end
				end,
				onAfterBuild = function(arg_10_0)
					local var_10_0 = arg_10_0:getInnerContainerSize()
					local var_10_1 = arg_10_0:getContentSize()

					if var_10_0.height <= var_10_1.height then
						arg_10_0:setTouchEnabled(false)
					end
				end
			}
		}
	},
	btnResonance = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnResonance")
			}
		}
	}
}
var_0_8.RESOURCE_STYLES = {
	backGlass = true,
	blackLayer = true,
	clickClose = true
}

function var_0_8.onCreate(arg_11_0, arg_11_1)
	arg_11_0.typ = arg_11_1.typ
	arg_11_0.curPlan = arg_11_1.curPlan
	arg_11_0.cardPlan = arg_11_1.cardPlan
	arg_11_0.showDatas = idlertable.new({})
	arg_11_0.showCompareDatas = idlertable.new({})
	arg_11_0.typeData = {
		{
			idler = arg_11_0.showDatas,
			getAttrs = function()
				local var_12_0, var_12_1 = var_0_0.getAttrs(arg_11_0.cardPlan)

				var_0_0.setAttrCollect(var_12_0, var_12_1)

				return var_12_0
			end,
			getResonanceAttr = function()
				return (var_0_0.getResonanceAttr(arg_11_0.cardPlan))
			end
		},
		{
			idler = arg_11_0.showCompareDatas,
			getAttrs = function()
				return (var_0_0.getAttrsValueCmp(arg_11_0.curPlan, arg_11_0.cardPlan))
			end,
			getResonanceAttr = function()
				return (var_0_0.getResonanceAttr(arg_11_0.curPlan))
			end
		}
	}

	arg_11_0.list:visible(arg_11_0.typ == 1)
	arg_11_0.compareList:visible(arg_11_0.typ == 2)
	arg_11_0:getTotalAttrs()
end

function var_0_8.arrangeData(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = {}

	for iter_16_0, iter_16_1 in pairs(arg_16_2) do
		if iter_16_0 % 3 == 1 and iter_16_0 > 1 then
			table.insert(arg_16_1, var_16_0)

			var_16_0 = {}
		end

		table.insert(var_16_0, iter_16_1)
	end

	if #var_16_0 > 0 then
		table.insert(arg_16_1, var_16_0)

		local var_16_1 = {}
	end
end

function var_0_8.getTotalAttrs(arg_17_0)
	local var_17_0 = {}

	table.insert(var_17_0, {
		sign = 1,
		title = gLanguageCsv.basicAttribute
	})

	local var_17_1 = {}
	local var_17_2 = arg_17_0.typeData[arg_17_0.typ].getAttrs()

	for iter_17_0 = 1, math.huge do
		if not var_17_2[iter_17_0] then
			break
		elseif table.nums(var_17_2[iter_17_0]) > 0 then
			if var_17_1[iter_17_0] == nil then
				var_17_1[iter_17_0] = {}
			end

			for iter_17_1, iter_17_2 in ipairs(game.ATTRDEF_TABLE) do
				local var_17_3 = game.ATTRDEF_ENUM_TABLE[iter_17_2]

				if var_17_2[iter_17_0][var_17_3] then
					table.insert(var_17_1[iter_17_0], {
						attr = iter_17_2,
						key = var_17_3,
						val = var_17_2[iter_17_0][var_17_3]
					})
				end
			end
		end
	end

	if table.nums(var_17_1) == 0 then
		table.insert(var_17_0, {})
	else
		for iter_17_3, iter_17_4 in pairs(var_17_1) do
			arg_17_0:arrangeData(var_17_0, iter_17_4)
		end
	end

	table.insert(var_17_0, {
		sign = 1,
		title = gLanguageCsv.chipResonance
	})

	local var_17_4 = arg_17_0.typeData[arg_17_0.typ].getResonanceAttr()

	if #var_17_4 == 0 then
		table.insert(var_17_0, {
			sign = 2,
			id = 0
		})
	else
		table.sort(var_17_4, function(arg_18_0, arg_18_1)
			return arg_18_0[2] < arg_18_1[2]
		end)

		for iter_17_5, iter_17_6 in ipairs(var_17_4) do
			table.insert(var_17_0, {
				sign = 2,
				id = iter_17_6[1]
			})
		end
	end

	arg_17_0.typeData[arg_17_0.typ].idler:set(var_17_0)
end

function var_0_8.onBtnResonance(arg_19_0)
	gGameUI:stackUI("city.card.chip.resonance_preview")
end

return var_0_8
