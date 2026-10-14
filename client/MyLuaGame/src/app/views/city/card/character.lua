local var_0_0 = class("CardCharacterView", Dialog)

local function var_0_1(arg_1_0, arg_1_1)
	arg_1_0:setString(arg_1_1)

	if arg_1_1 == 0.9 then
		text.addEffect(arg_1_0, {
			color = cc.c4b(241, 59, 84, 255)
		})
	elseif arg_1_1 == 1.1 then
		text.addEffect(arg_1_0, {
			color = cc.c4b(96, 196, 86, 255)
		})
	else
		text.addEffect(arg_1_0, {
			color = cc.c4b(91, 84, 91, 255)
		})
	end
end

var_0_0.RESOURCE_FILENAME = "card_character.json"
var_0_0.RESOURCE_BINDING = {
	imgMark = "imgMark",
	subList = "characterSubList",
	item = "characterItem",
	titleTxt = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.RED
				}
			}
		}
	},
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	list = {
		varname = "characterList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 27,
				columnSize = 9,
				data = bindHelper.self("characterData"),
				item = bindHelper.self("characterSubList"),
				cell = bindHelper.self("characterItem"),
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					arg_2_1:get("select"):visible(arg_2_3.select == true)
					arg_2_1:get("img"):visible(arg_2_3.showCurr == true)

					if arg_2_0:getIdx(arg_2_2).col % 2 ~= 0 then
						arg_2_1:get("bg"):hide()
					end

					arg_2_1:get("name"):setString(arg_2_3.name or "")

					for iter_2_0 = 1, 5 do
						var_0_1(arg_2_1:get("txt" .. iter_2_0), arg_2_3["txt" .. iter_2_0] or "")
					end
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = {
		7,
		9,
		8,
		10,
		13
	}
	local var_3_1 = {}
	local var_3_2 = csv.cards[arg_3_1].chaRecom

	for iter_3_0, iter_3_1 in ipairs(csv.character) do
		local var_3_3 = {
			name = iter_3_1.name,
			showCurr = iter_3_0 == arg_3_2
		}

		for iter_3_2, iter_3_3 in ipairs(var_3_0) do
			if iter_3_1.attrMap and iter_3_1.attrMap[iter_3_3] then
				local var_3_4 = string.match(iter_3_1.attrMap[iter_3_3], "%d+")

				var_3_3["txt" .. iter_3_2] = var_3_4 / 100
			else
				var_3_3["txt" .. iter_3_2] = "-"
			end
		end

		for iter_3_4, iter_3_5 in pairs(var_3_2) do
			if iter_3_5 == iter_3_0 then
				var_3_3.select = true
			end
		end

		table.insert(var_3_1, var_3_3)
	end

	for iter_3_6 = 1, 27 do
		if #var_3_1 < 27 then
			table.insert(var_3_1, {})
		else
			break
		end
	end

	arg_3_0.characterData = var_3_1

	Dialog.onCreate(arg_3_0)
end

return var_0_0
