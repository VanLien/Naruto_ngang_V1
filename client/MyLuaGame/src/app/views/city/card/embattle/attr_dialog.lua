local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CardEmbattleAttrDialog", Dialog)

local function var_0_2(arg_1_0, arg_1_1)
	if arg_1_1 then
		return
	end

	local var_1_0 = cc.c4b(151, 147, 137, 255)

	text.addEffect(arg_1_0, {
		color = var_1_0
	})
end

var_0_1.RESOURCE_FILENAME = "card_embattle_attr_dialog.json"
var_0_1.RESOURCE_BINDING = {
	bottomItem = "bottomItem",
	subList = "subList",
	item = "item",
	textNote1 = "textNote1",
	textNote3 = "textNote3",
	textItem1 = "textItem1",
	text = "attrText",
	textItem2 = "textItem2",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("buffData1"),
				item = bindHelper.self("item"),
				textItem = bindHelper.self("textItem1"),
				itemAction = {
					isAction = true
				},
				onAfterBuild = function(arg_2_0)
					arg_2_0.afterBuild()
				end,
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("icon", "textList", "text", "bg")

					var_3_0.icon:texture(arg_3_3.icon)
					var_3_0.text:text(arg_3_3.desc)
					adapt.setTextAdaptWithSize(var_3_0.text, {
						margin = -3,
						vertical = "center",
						size = cc.size(1100, 100)
					})
					bind.extend(arg_3_0, var_3_0.textList, {
						class = "listview",
						props = {
							data = arg_3_3.data,
							item = arg_3_0.textItem,
							onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
								local var_4_0 = arg_4_1:multiget("text1", "text2")

								var_4_0.text1:text(arg_4_3[1])
								var_4_0.text2:text(arg_4_3[2])
								adapt.oneLinePos(var_4_0.text1, var_4_0.text2, cc.p(0, 0))
								var_0_2(var_4_0.text1, arg_3_3.isGet)
								var_0_2(var_4_0.text2, arg_3_3.isGet)
							end
						}
					})
					var_3_0.icon:get("mask"):visible(not arg_3_3.isGet)
					var_0_2(var_3_0.text, arg_3_3.isGet)

					if arg_3_3.isLast then
						var_3_0.bg:hide()
					end
				end
			},
			handlers = {
				afterBuild = bindHelper.self("initBottomType")
			}
		}
	}
}

function var_0_1.onCreate(arg_5_0, arg_5_1)
	local var_5_0 = csv.battle_card_halo
	local var_5_1 = {}
	local var_5_2 = {}
	local var_5_3 = {}

	for iter_5_0, iter_5_1 in csvPairs(var_5_0) do
		local var_5_4 = false

		if iter_5_1.type == 1 then
			local var_5_5 = {}

			for iter_5_2 = 1, 3 do
				if iter_5_1["attrType" .. iter_5_2] ~= 0 then
					local var_5_6 = iter_5_1["attrType" .. iter_5_2]
					local var_5_7 = iter_5_1["attrValue" .. iter_5_2]
					local var_5_8 = gLanguageCsv["attr" .. string.caption(game.ATTRDEF_TABLE[var_5_6])]

					if arg_5_1[iter_5_0] then
						var_5_4 = true

						local var_5_9 = false
						local var_5_10 = var_5_7

						if string.find(var_5_10, "%%") then
							var_5_10 = string.sub(var_5_10, 1, #var_5_10 - 1)
							var_5_9 = true
						end

						local var_5_11 = tonumber(var_5_10)

						var_5_1[var_5_8] = var_5_1[var_5_8] or {
							value = 0,
							attr = var_5_6,
							percent = var_5_9
						}
						var_5_1[var_5_8].value = var_5_1[var_5_8].value + var_5_11
					end

					local var_5_12 = "+" .. dataEasy.getAttrValueString(var_5_6, var_5_7)

					table.insert(var_5_5, {
						var_5_8,
						var_5_12
					})
				end
			end

			table.insert(var_5_2, {
				id = iter_5_0,
				icon = iter_5_1.icon,
				desc = iter_5_1.desc,
				isGet = var_5_4,
				data = var_5_5
			})
		elseif iter_5_1.type == 2 then
			arg_5_0.bottomIcon = iter_5_1.icon
			arg_5_0.bottomDesc = iter_5_1.desc

			local var_5_13 = iter_5_1.args[1]

			if arg_5_1[iter_5_0] then
				var_5_4 = true
			end

			local var_5_14 = gLanguageCsv["attr" .. string.caption(game.ATTRDEF_TABLE[iter_5_1.attrType1])]

			table.insert(var_5_3, {
				attr = var_5_13[1],
				num = "+" .. var_5_13[2],
				str1 = var_5_14,
				str2 = "+" .. dataEasy.getAttrValueString(iter_5_1.attrType1, iter_5_1.attrValue1),
				isGet = var_5_4
			})
		end
	end

	table.sort(var_5_2, function(arg_6_0, arg_6_1)
		return arg_6_0.id < arg_6_1.id
	end)

	local var_5_15 = #var_5_2

	if #var_5_3 <= 0 then
		var_5_2[var_5_15].isLast = true
	end

	arg_5_0.buffData1 = var_5_2
	arg_5_0.buffData2 = var_5_3

	local var_5_16 = {}

	for iter_5_3, iter_5_4 in pairs(var_5_1) do
		local var_5_17 = iter_5_3 .. "+" .. dataEasy.getAttrValueString(iter_5_4.attr, iter_5_4.value)

		if iter_5_4.percent then
			var_5_17 = var_5_17 .. "%"
		end

		table.insert(var_5_16, {
			attrId = iter_5_4.attr,
			str = var_5_17
		})
	end

	table.sort(var_5_16, function(arg_7_0, arg_7_1)
		return arg_7_0.attrId < arg_7_1.attrId
	end)

	local var_5_18 = {}

	for iter_5_5, iter_5_6 in pairs(var_5_16) do
		table.insert(var_5_18, iter_5_6.str)
	end

	arg_5_0.attrText:text(table.concat(var_5_18, ", "))
	arg_5_0.textNote1:text(gLanguageCsv.teamHaloTitle)

	if not matchLanguage({
		"cn",
		"tw"
	}) then
		adapt.setTextAdaptWithSize(arg_5_0.textNote1, {
			margin = -3,
			size = cc.size(1650, 200)
		})
		arg_5_0.textNote1:y(arg_5_0.textNote1:y() - 55)
		adapt.setTextAdaptWithSize(arg_5_0.textNote3, {
			margin = -8,
			size = cc.size(1650, 200)
		})
		arg_5_0.textNote3:y(arg_5_0.textNote3:y() - 55)
	end

	Dialog.onCreate(arg_5_0)
end

function var_0_1.initBottomType(arg_8_0)
	local var_8_0 = 3
	local var_8_1 = arg_8_0.bottomItem:clone():show()
	local var_8_2 = var_8_1:multiget("icon", "text", "list", "bg")

	var_8_2.bg:hide()
	var_8_2.icon:texture(arg_8_0.bottomIcon)
	var_8_2.text:text(arg_8_0.bottomDesc)

	local var_8_3 = false

	var_8_2.list:setScrollBarEnabled(false)
	arg_8_0.subList:setScrollBarEnabled(false)

	local var_8_4 = arg_8_0.subList:clone()
	local var_8_5 = var_8_4:size().height
	local var_8_6 = 0
	local var_8_7 = 0
	local var_8_8 = 0

	local function var_8_9()
		var_8_2.list:pushBackCustomItem(var_8_4)

		var_8_6 = var_8_6 + 1
		var_8_7 = 0
		var_8_8 = 0
		var_8_4 = arg_8_0.subList:clone()
	end

	for iter_8_0, iter_8_1 in pairs(arg_8_0.buffData2) do
		local var_8_10 = arg_8_0.textItem2:clone()
		local var_8_11 = var_8_10:multiget("text1", "text2", "text3", "icon")

		var_8_11.icon:texture(ui.ATTR_ICON[iter_8_1.attr])
		var_8_11.text1:text(iter_8_1.num)
		var_8_11.text2:text(iter_8_1.str1)
		var_8_11.text3:text(iter_8_1.str2)
		var_0_2(var_8_11.text1, iter_8_1.isGet)
		var_0_2(var_8_11.text2, iter_8_1.isGet)
		var_0_2(var_8_11.text3, iter_8_1.isGet)

		if iter_8_1.isGet then
			var_8_3 = true
		end

		local var_8_12 = var_8_10:size()
		local var_8_13 = var_8_11.text2:size()
		local var_8_14 = var_8_11.text3:size()
		local var_8_15 = var_8_12.width
		local var_8_16 = var_8_12.height

		adapt.oneLinePos(var_8_11.text2, var_8_11.text3, cc.p(0, 0))
		var_8_10:size(var_8_15 + var_8_13.width + var_8_14.width, var_8_16)

		local var_8_17 = var_8_10:size().width

		if var_8_8 + var_8_17 > var_8_4:size().width then
			var_8_9()
		end

		var_8_8 = var_8_8 + var_8_17
		var_8_7 = var_8_7 + 1

		var_8_4:pushBackCustomItem(var_8_10)

		if var_8_0 <= var_8_7 then
			var_8_9()
		end
	end

	if var_8_7 > 0 then
		var_8_9()
	end

	local var_8_18 = var_8_2.list:size()
	local var_8_19 = math.max(var_8_6 - 1, 0) * arg_8_0.subList:size().height

	var_8_2.list:size(var_8_18.width, var_8_18.height + var_8_19)

	local var_8_20 = var_8_1:size()

	var_8_1:size(var_8_20.width, var_8_20.height + var_8_19)
	var_8_2.icon:y(var_8_2.icon:y() + var_8_19)
	var_8_2.text:y(var_8_2.text:y() + var_8_19)
	var_0_2(var_8_2.text, var_8_3)
	var_8_2.icon:get("mask"):visible(not var_8_3)

	if var_8_6 > 0 then
		arg_8_0.list:pushBackCustomItem(var_8_1)
	end
end

return var_0_1
