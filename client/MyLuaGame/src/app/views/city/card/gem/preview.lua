local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = {
		class = "listview",
		props = {
			data = arg_1_3,
			item = arg_1_0.itemCell,
			onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				local var_2_0 = arg_2_1:multiget("textName", "textVal")

				var_2_0.textName:text(gLanguageCsv[arg_2_3.items[1]])
				var_2_0.textVal:text(arg_2_3.items[2] .. "%")
				adapt.oneLinePos(var_2_0.textName, var_2_0.textVal, cc.p(10, 0), "left")
			end
		}
	}

	bind.extend(arg_1_0, arg_1_1, var_1_0)
end

local var_0_1 = class("GemDrawPreview", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "gem_preview.json"
var_0_1.RESOURCE_BINDING = {
	item21 = "itemDwonChildCell",
	item = "item",
	item2 = "itemDwonCell",
	item1 = "itemUpCell",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("showData"),
				item = bindHelper.self("item"),
				itemUpCell = bindHelper.self("itemUpCell"),
				itemDwonCell = bindHelper.self("itemDwonCell"),
				itemDwonChildCell = bindHelper.self("itemDwonChildCell"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("upList", "downList")

					if arg_3_3[1].key then
						var_3_0.downList:visible(false)
						var_3_0.upList:visible(true)

						local var_3_1 = arg_3_0:size().width
						local var_3_2 = var_3_0.upList:size()

						arg_3_1:size(cc.size(var_3_1, var_3_2.height))

						local var_3_3 = {
							class = "listview",
							props = {
								data = arg_3_3,
								item = arg_3_0.itemUpCell,
								onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
									bind.extend(arg_4_0, arg_4_1, {
										class = "icon_key",
										props = {
											data = {
												key = arg_4_3.key
											},
											specialKey = {
												leftTopLv = 1
											}
										}
									})

									if arg_4_3.info == 2 then
										cc.Sprite:create("city/drawcard/draw/txt_up.png"):addTo(arg_4_1):xy(cc.p(arg_4_1:size().width - 40, arg_4_1:size().height - 17)):z(5)
									end
								end
							}
						}

						bind.extend(arg_3_0, var_3_0.upList, var_3_3)
					else
						var_3_0.downList:visible(true)
						var_3_0.upList:visible(false)

						local var_3_4 = {
							class = "listview",
							props = {
								data = arg_3_3,
								item = arg_3_0.itemDwonCell,
								itemCell = arg_3_0.itemDwonChildCell,
								onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
									var_0_0(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
								end
							}
						}

						bind.extend(arg_3_0, var_3_0.downList:get("list"), var_3_4)
					end
				end
			}
		}
	}
}

function var_0_1.onCreate(arg_6_0, arg_6_1)
	arg_6_0.showData = idlers.new()

	local var_6_0 = 1
	local var_6_1 = {}
	local var_6_2 = {}
	local var_6_3 = csv.gem.gem
	local var_6_4 = csv.yunying.yyhuodong[arg_6_1].clientParam.up
	local var_6_5 = {}

	for iter_6_0, iter_6_1 in ipairs(var_6_4) do
		var_6_5[iter_6_1] = true
	end

	local var_6_6 = csv.yunying.yyhuodong[arg_6_1].clientParam.priviewId
	local var_6_7 = csv.draw_preview[var_6_6]

	for iter_6_2, iter_6_3 in ipairs(var_6_7.item) do
		local var_6_8 = 1
		local var_6_9 = var_6_3[iter_6_3].suitID

		if var_6_9 and var_6_5[var_6_9] then
			var_6_8 = 2
		end

		if var_6_1[var_6_8] == nil then
			var_6_1[var_6_8] = {}
		end

		table.insert(var_6_1[var_6_8], {
			key = iter_6_3,
			quality = dataEasy.getCfgByKey(iter_6_3).quality,
			info = var_6_8
		})
	end

	local function var_6_10(arg_7_0)
		table.sort(arg_7_0, function(arg_8_0, arg_8_1)
			if arg_8_0.quality ~= arg_8_1.quality then
				return arg_8_0.quality > arg_8_1.quality
			end

			return arg_8_0.key < arg_8_1.key
		end)
	end

	for iter_6_4, iter_6_5 in pairs(var_6_1) do
		var_6_10(iter_6_5)
	end

	local var_6_11 = arg_6_0:setStructData(var_6_1)

	if var_6_7.desc and csvSize(var_6_7.desc) then
		for iter_6_6, iter_6_7 in ipairs(var_6_7.desc) do
			table.insert(var_6_2, {
				type = "desc",
				items = iter_6_7
			})
		end
	end

	local var_6_12 = arg_6_0:setStructEscData(var_6_2)

	table.insert(var_6_11, var_6_12)
	arg_6_0.showData:update(var_6_11)
end

function var_0_1.setStructData(arg_9_0, arg_9_1)
	local var_9_0 = {}
	local var_9_1 = 1
	local var_9_2 = {}

	for iter_9_0, iter_9_1 in pairs(arg_9_1) do
		for iter_9_2, iter_9_3 in pairs(iter_9_1) do
			if var_9_1 % 9 == 1 then
				if var_9_1 > 9 then
					table.insert(var_9_0, var_9_2)
				end

				var_9_2 = {}
			end

			table.insert(var_9_2, iter_9_3)

			var_9_1 = var_9_1 + 1
		end
	end

	if #var_9_2 > 0 then
		table.insert(var_9_0, var_9_2)
	end

	return var_9_0
end

function var_0_1.setStructEscData(arg_10_0, arg_10_1)
	local var_10_0 = {}
	local var_10_1 = 1
	local var_10_2 = {}

	for iter_10_0, iter_10_1 in pairs(arg_10_1) do
		if var_10_1 % 4 == 1 then
			if var_10_1 > 4 then
				table.insert(var_10_0, var_10_2)
			end

			var_10_2 = {}
		end

		table.insert(var_10_2, iter_10_1)

		var_10_1 = var_10_1 + 1
	end

	if #var_10_2 > 0 then
		table.insert(var_10_0, var_10_2)
	end

	return var_10_0
end

return var_0_1
