local var_0_0 = class("HandbookAttrAddView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "handbook_attadd.json"
var_0_0.RESOURCE_BINDING = {
	["panel.item"] = "item",
	["panel.innerList"] = "innerList",
	panel = {
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	},
	["panel.list"] = {
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 3,
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("innerList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = game.ATTRDEF_TABLE[arg_1_2]
					local var_1_1 = "attr" .. string.caption(arg_1_3.key)

					arg_1_1:get("textName"):text(gLanguageCsv[var_1_1])

					local var_1_2 = mathEasy.getPreciseDecimal(arg_1_3.val, 2)

					adapt.setTextScaleWithWidth(arg_1_1:get("textNum"), "+" .. var_1_2 .. "%", 160)
					arg_1_1:get("imgIcon"):texture(ui.ATTR_LOGO[arg_1_3.key])
					adapt.oneLinePos(arg_1_1:get("imgIcon"), arg_1_1:get("textName"), cc.p(8, 0), "left")
					adapt.oneLinePos(arg_1_1:get("textName"), arg_1_1:get("textNum"), nil, "left")
				end,
				dataOrderCmp = function(arg_2_0, arg_2_1)
					return arg_2_0.idx < arg_2_1.idx
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_3_0, arg_3_1)
	arg_3_0:initModel()
	gGameModel.handbook:getIdlerOrigin("isNew"):set(false)

	local var_3_0 = {
		{
			val = 0,
			idx = 1,
			key = "hp"
		},
		[7] = {
			val = 0,
			idx = 2,
			key = "damage"
		},
		[8] = {
			val = 0,
			idx = 3,
			key = "specialDamage"
		},
		[9] = {
			val = 0,
			idx = 4,
			key = "defence"
		},
		[10] = {
			val = 0,
			idx = 5,
			key = "specialDefence"
		},
		[13] = {
			val = 0,
			idx = 6,
			key = "speed"
		}
	}

	for iter_3_0, iter_3_1 in pairs(arg_3_0.pokedex:read()) do
		local var_3_1 = gHandbookCsv[iter_3_0]

		if var_3_1 then
			for iter_3_2 = 1, math.huge do
				local var_3_2 = var_3_1["attrType" .. iter_3_2]

				if not var_3_2 then
					break
				end

				local var_3_3, var_3_4 = dataEasy.parsePercentStr(var_3_1["attrValue" .. iter_3_2])
				local var_3_5 = mathEasy.getPreciseDecimal(var_3_3, 2)

				var_3_0[var_3_2].val = var_3_0[var_3_2].val + var_3_5
			end
		end
	end

	local var_3_6 = {}

	for iter_3_3, iter_3_4 in ipairs(arg_3_0.cards:read()) do
		local var_3_7 = gGameModel.cards:find(iter_3_4)
		local var_3_8 = var_3_7:read("card_id")
		local var_3_9 = var_3_7:read("star")
		local var_3_10 = csv.cards[var_3_8].cardMarkID
		local var_3_11 = gPokedexDevelop[var_3_10][var_3_9]
		local var_3_12, var_3_13 = dataEasy.parsePercentStr(var_3_11.attrValue1)
		local var_3_14 = mathEasy.getPreciseDecimal(var_3_12, 2)

		var_3_6[var_3_10] = var_3_6[var_3_10] or {
			typ = var_3_11.attrType1,
			val = var_3_14
		}

		if var_3_14 > var_3_6[var_3_10].val then
			var_3_6[var_3_10].val = var_3_14
		end
	end

	for iter_3_5, iter_3_6 in pairs(var_3_6) do
		var_3_0[iter_3_6.typ].val = var_3_0[iter_3_6.typ].val + iter_3_6.val
	end

	arg_3_0.attrDatas = idlers.newWithMap(var_3_0)
end

function var_0_0.initModel(arg_4_0)
	arg_4_0.pokedex = gGameModel.role:getIdler("pokedex")
	arg_4_0.cards = gGameModel.role:getIdler("cards")
end

return var_0_0
