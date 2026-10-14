local var_0_0 = class("QualityIndexView", Dialog)

var_0_0.RESOURCE_FILENAME = "gem_index.json"
var_0_0.RESOURCE_BINDING = {
	index = "index",
	item = "item",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	titleTxt1 = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	titleTxt2 = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("qualityDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("name"):text(arg_1_3.name)
					arg_1_1:get("name"):x(0)

					local var_1_0 = arg_1_0:width() - arg_1_1:get("name"):width()
					local var_1_1 = rich.createWithWidth(arg_1_3.txt, 40, nil, var_1_0):anchorPoint(0, 1)

					var_1_1:xy(arg_1_1:get("name"):x() + arg_1_1:get("name"):width(), var_1_1:height()):addTo(arg_1_1):z(2)
					arg_1_1:height(var_1_1:height())
					arg_1_1:get("name"):y(arg_1_1:height())

					local var_1_2 = arg_1_3.selfct and cc.c4b(91, 84, 91, 255) or cc.c4b(183, 176, 158, 255)

					text.addEffect(arg_1_1:get("name"), {
						color = var_1_2
					})
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.list:y(348):height(622):setItemsMargin(13)

	local var_2_0 = arg_2_2 or 0

	arg_2_0.index:text(var_2_0)

	local var_2_1 = gGameModel.cards:find(arg_2_1):read("card_id")
	local var_2_2 = csv.cards[var_2_1].gemQualitySeqID
	local var_2_3 = {}

	arg_2_0.qualityDatas = idlers.new({})

	local var_2_4 = "#C0x5B545B#"
	local var_2_5 = "#C0x60c456#"
	local var_2_6 = true

	for iter_2_0, iter_2_1 in orderCsvPairs(csv.gem.quality_attrs) do
		if var_2_2 == iter_2_1.gemQualitySeqID then
			local var_2_7

			if var_2_0 < iter_2_1.qualityNum then
				var_2_4 = "#C0xB7B09E#"
				var_2_5 = "#C0xB7B09E#"
				var_2_7 = false
			else
				var_2_7 = true
			end

			local var_2_8 = string.format(gLanguageCsv.indexNumEffect, iter_2_1.qualityNum)
			local var_2_9 = ""
			local var_2_10 = {}

			for iter_2_2 = 1, math.huge do
				if iter_2_1["attrType" .. iter_2_2] and iter_2_1["attrType" .. iter_2_2] ~= 0 then
					local var_2_11 = game.ATTRDEF_TABLE[iter_2_1["attrType" .. iter_2_2]]
					local var_2_12 = gLanguageCsv.card .. var_2_4 .. gLanguageCsv["attr" .. string.caption(var_2_11)]

					if matchLanguage({
						"en"
					}) then
						var_2_12 = var_2_4 .. gLanguageCsv["attr" .. string.caption(var_2_11)]
					end

					if iter_2_2 >= 2 then
						var_2_9 = var_2_9 .. ", " .. var_2_12 .. var_2_5 .. "+" .. dataEasy.getAttrValueString(iter_2_1["attrType" .. iter_2_2], iter_2_1["attrNum" .. iter_2_2]) .. var_2_5 .. var_2_4
					else
						var_2_9 = var_2_9 .. var_2_12 .. var_2_5 .. "+" .. dataEasy.getAttrValueString(iter_2_1["attrType" .. iter_2_2], iter_2_1["attrNum" .. iter_2_2]) .. var_2_5 .. var_2_4
					end

					var_2_10[iter_2_2] = dataEasy.getAttrValueString(iter_2_1["attrType" .. iter_2_2], iter_2_1["attrNum" .. iter_2_2])
				else
					break
				end
			end

			local var_2_13 = var_2_10[1]
			local var_2_14 = true

			if #var_2_10 == 6 then
				for iter_2_3, iter_2_4 in pairs(var_2_10) do
					if iter_2_4 ~= var_2_13 then
						var_2_14 = false
					end
				end

				if var_2_14 then
					var_2_9 = gLanguageCsv.card .. gLanguageCsv.basicAttribute .. var_2_5 .. "+" .. var_2_13

					if matchLanguage({
						"en"
					}) then
						var_2_9 = gLanguageCsv.basicAttribute .. var_2_5 .. "+" .. var_2_13
					end
				end
			end

			table.insert(var_2_3, {
				name = var_2_8,
				txt = var_2_4 .. var_2_9,
				selfct = var_2_7
			})
		end
	end

	arg_2_0.qualityDatas:update(var_2_3)
	arg_2_0.item:visible(false)
	Dialog.onCreate(arg_2_0)
end

return var_0_0
