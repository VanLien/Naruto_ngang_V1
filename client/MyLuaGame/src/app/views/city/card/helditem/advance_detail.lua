local var_0_0 = require("app.views.city.card.helditem.tools")
local var_0_1 = 640
local var_0_2 = 973

local function var_0_3(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = gLanguageCsv.advance .. " +" .. arg_1_3.advance

	if arg_1_3.advance == arg_1_0.advance then
		var_1_0 = var_1_0 .. string.format("(%s)", gLanguageCsv.current)
	end

	local var_1_1 = arg_1_3.rellyAdvance and arg_1_3.rellyAdvance + 1 or arg_1_3.advance + 1

	arg_1_1:get("textTitle"):text(var_1_0)

	local var_1_2 = arg_1_0.advance < arg_1_3.advance
	local var_1_3 = {}

	for iter_1_0, iter_1_1 in ipairs(arg_1_3.attr) do
		local var_1_4 = csv.held_item.effect[iter_1_1]
		local var_1_5 = var_1_4.desc
		local var_1_6 = {}
		local var_1_7 = "#C0xFFFFFF#"

		if var_1_2 then
			var_1_7 = "#C0xB7B09E#"
		end

		local var_1_8 = 1

		if itertools.size(var_1_4.exclusiveCards) > 0 then
			local var_1_9 = var_1_4.exclusiveCards[1]
			local var_1_10 = csv.cards[var_1_9]
			local var_1_11 = csv.unit[var_1_10.unitID]

			table.insert(var_1_6, var_1_10.name)

			if not var_1_2 then
				local var_1_12 = var_1_11.natureType
				local var_1_13 = ui.ATTRCOLOR[game.NATURE_TABLE[var_1_12]]

				var_1_5 = var_0_0.insertColor(var_1_5, var_1_13, true, var_1_8, true, var_1_7)
			end

			var_1_8 = var_1_8 + 1
		end

		if var_1_4.type == 1 then
			for iter_1_2 = 1, 100 do
				if not var_1_4["attrNum" .. iter_1_2] then
					break
				end

				local var_1_14 = var_1_4["attrNum" .. iter_1_2][arg_1_3.idx]
				local var_1_15 = var_1_4["attrType" .. iter_1_2]

				table.insert(var_1_6, dataEasy.getAttrValueString(var_1_15, var_1_14))
			end

			var_1_5 = var_0_0.insertColor(var_1_5, ui.QUALITYCOLOR[2], false, var_1_8, false, var_1_7)
		elseif var_1_4.type == 2 then
			local var_1_16 = csv.skill[var_1_4.skillID].describe
			local var_1_17 = var_0_0.insertSkillDescColor(var_1_16, ui.QUALITYCOLOR[2], var_1_7)

			table.insert(var_1_6, eval.doMixedFormula(var_1_17, {
				skillLevel = var_1_1,
				math = math
			}))
		end

		local var_1_18 = string.format(var_1_5, unpack(var_1_6))

		table.insert(var_1_3, var_1_18)
	end

	local var_1_19 = table.concat(var_1_3, "\n")

	if arg_1_3.isNew then
		var_1_19 = var_1_19 .. "#Icommon/icon/txt_new.png#"
	end

	local var_1_20 = "#C0xFFFFFF#"

	if var_1_2 then
		var_1_20 = "#C0xB7B09E#"
	end

	local var_1_21 = rich.createWithWidth(var_1_20 .. var_1_19, 40, nil, 920):anchorPoint(0, 1):x(25):addTo(arg_1_1, 10, "attrText")
	local var_1_22 = var_1_21:size().height + 50

	arg_1_1:size(960, var_1_22)
	arg_1_1:get("textTitle"):y(var_1_22 - 25)
	var_1_21:y(var_1_22 - 50)
	arg_1_0.baseNodeHeight:modify(function(arg_2_0)
		return true, arg_2_0 + var_1_22
	end)
end

local var_0_4 = class("HeldItemBreachView", Dialog)

var_0_4.RESOURCE_FILENAME = "held_item_info.json"
var_0_4.RESOURCE_BINDING = {
	item = "item",
	baseNode = "baseNode",
	["baseNode.imgBg"] = "imgBg",
	["baseNode.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("infos"),
				item = bindHelper.self("item"),
				advance = bindHelper.self("advance"),
				baseNodeHeight = bindHelper.self("baseNodeHeight"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					var_0_3(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				end,
				onAfterBuild = function(arg_4_0)
					arg_4_0.afterBuild()
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	}
}

function var_0_4.onCreate(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1.data.advance

	arg_5_0.advance = var_5_0
	arg_5_0.params = arg_5_1
	arg_5_0.baseNodeHeight = idler.new(0)

	local var_5_1 = arg_5_1.data.cfg
	local var_5_2 = arg_5_1.data.csvId
	local var_5_3 = csv.held_item.items
	local var_5_4 = var_5_1.advanceMax
	local var_5_5 = {}
	local var_5_6 = {}
	local var_5_7 = {}
	local var_5_8 = 0

	for iter_5_0 = 1, math.huge do
		local var_5_9 = var_5_1["effect" .. iter_5_0]

		if not var_5_9 or var_5_9 == 0 then
			break
		end

		local var_5_10 = var_5_1[string.format("effect%dLevelAdvSeq", iter_5_0)]

		var_5_8 = var_5_8 + 1

		local var_5_11 = var_5_10[1]

		if not var_5_6[var_5_11] then
			var_5_6[var_5_11] = {}
		end

		table.insert(var_5_6[var_5_11], var_5_9)

		var_5_7[var_5_11] = true
	end

	local var_5_12 = {}

	for iter_5_1 = 1, var_5_8 do
		local var_5_13 = var_5_1[string.format("effect%dLevelAdvSeq", iter_5_1)]
		local var_5_14 = true

		if var_5_0 >= var_5_13[1] then
			var_5_14 = false
		end

		local var_5_15 = 0

		for iter_5_2, iter_5_3 in ipairs(var_5_13) do
			if iter_5_3 <= var_5_4 and not var_5_12[iter_5_3] then
				var_5_12[iter_5_3] = true
				var_5_15 = var_5_15 + 1

				if var_5_15 > 1 then
					var_5_14 = false
				end

				local var_5_16 = {}

				for iter_5_4, iter_5_5 in pairs(var_5_7) do
					if iter_5_4 <= iter_5_3 then
						for iter_5_6, iter_5_7 in pairs(var_5_6[iter_5_4]) do
							table.insert(var_5_16, iter_5_7)
						end
					end
				end

				table.insert(var_5_5, {
					attr = var_5_16,
					advance = iter_5_3,
					idx = iter_5_2,
					cfg = data,
					isNew = var_5_14
				})
			end
		end
	end

	table.sort(var_5_5, function(arg_6_0, arg_6_1)
		return arg_6_0.advance < arg_6_1.advance
	end)

	for iter_5_8 = 2, math.huge do
		local var_5_17 = var_5_5[iter_5_8]
		local var_5_18 = var_5_5[iter_5_8 - 1]

		if not var_5_17 then
			break
		end

		local var_5_19 = var_5_17.advance - var_5_18.advance

		for iter_5_9 = 1, var_5_19 - 1 do
			local var_5_20 = clone(var_5_18)

			var_5_20.isNew = false
			var_5_20.advance = var_5_20.advance + iter_5_9
			var_5_20.rellyAdvance = var_5_18.advance

			table.insert(var_5_5, iter_5_8 - 1 + iter_5_9, var_5_20)
		end
	end

	arg_5_0.infos = idlertable.new(var_5_5)

	Dialog.onCreate(arg_5_0, {
		clickClose = true,
		noBlackLayer = true
	})
end

function var_0_4.onAfterBuild(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.infos:size()
	local var_7_1 = math.max(var_0_1, arg_7_0.baseNodeHeight:read())
	local var_7_2 = math.min(var_0_2, var_7_1)
	local var_7_3 = arg_7_0.baseNode:size().width

	arg_7_0.baseNode:size(var_7_3, var_7_2)
	arg_7_0.imgBg:size(var_7_3 + 10, var_7_2 + 5)
	arg_7_0.imgBg:y(var_7_2 / 2)
	arg_7_0.list:size(960, var_7_2 - 50)
	arg_7_0.list:y(25)

	local var_7_4 = arg_7_0.params.target:getBoundingBox().height
	local var_7_5 = arg_7_0.params.y - var_7_2 / 2 - var_7_4 / 2
	local var_7_6, var_7_7 = arg_7_0:resetPosition(arg_7_0.params.x, var_7_5)
	local var_7_8 = arg_7_0.params.offx or 0
	local var_7_9 = arg_7_0.params.offy or 0

	arg_7_0.baseNode:xy(var_7_6 + var_7_8, var_7_7 + var_7_9)
end

function var_0_4.resetPosition(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1
	local var_8_1 = arg_8_2
	local var_8_2 = arg_8_0:getResourceNode():getBoundingBox()
	local var_8_3 = display.size.height
	local var_8_4 = display.size.width
	local var_8_5 = arg_8_0.baseNode:size()
	local var_8_6 = arg_8_2 + var_8_5.height / 2
	local var_8_7 = arg_8_2 - var_8_5.height / 2

	if var_8_3 < var_8_6 then
		var_8_1 = var_8_3 - 50 - var_8_5.height / 2
	elseif var_8_7 < 0 then
		var_8_1 = var_8_5.height / 2 + 20
	end

	local var_8_8 = arg_8_1 - var_8_5.width / 2

	if var_8_8 < 0 then
		var_8_0 = var_8_5.width / 2 + 20
	elseif var_8_4 < var_8_8 then
		var_8_0 = var_8_4 - var_8_5.width / 2 - 20
	end

	return var_8_0, var_8_1
end

return var_0_4
