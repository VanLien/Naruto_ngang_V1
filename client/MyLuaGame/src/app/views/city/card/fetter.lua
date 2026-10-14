local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = csv.cards[arg_1_3]
	local var_1_1 = csv.unit[var_1_0.unitID]

	bind.extend(arg_1_0, arg_1_2:get("icon"), {
		class = "card_icon",
		props = {
			cardId = arg_1_3,
			rarity = var_1_1.rarity,
			grayState = arg_1_4 and 0 or 2,
			onNode = function(arg_2_0)
				arg_2_0:xy(-4, -4)
			end
		}
	})

	local var_1_2 = arg_1_4 and ui.NEWCOLORS.BROWN1 or ui.COLORS.NORMAL.GRAY

	text.addEffect(arg_1_2:get("name"), {
		color = var_1_2
	})
	arg_1_2:get("name"):text(var_1_0.name)
	arg_1_2:get("mask"):visible(false)
	arg_1_1:get("list"):pushBackCustomItem(arg_1_2)
	arg_1_1:get("list"):adaptTouchEnabled()
end

local var_0_1 = class("CardFetterView", Dialog)

var_0_1.RESOURCE_FILENAME = "card_fetter.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	subItem = "subItem",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	infoBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onFetterInfo")
			}
		}
	},
	titleTxt1 = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
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
				data = bindHelper.self("fetterDatas"),
				cardId = bindHelper.self("cardId"),
				subItem = bindHelper.self("subItem"),
				item = bindHelper.self("item"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_0.cardId
					local var_3_1 = arg_3_0.subItem
					local var_3_2 = csv.fetter[arg_3_3.id]
					local var_3_3 = gGameModel.role:read("pokedex")
					local var_3_4 = {}

					table.insert(var_3_4, {
						state = true,
						id = var_3_0
					})

					for iter_3_0, iter_3_1 in ipairs(var_3_2.cards) do
						local var_3_5 = arg_3_3.cardDatas[iter_3_1] or iter_3_1

						table.insert(var_3_4, {
							id = var_3_5,
							state = var_3_3[iter_3_1] ~= nil
						})
					end

					arg_3_1:get("bg"):texture(string.format("city/card/system/fetter/box_pop_panel%d.png", arg_3_3.isShow and 7 or 5))
					arg_3_1:get("titleBg"):texture(string.format("city/card/system/fetter/box_pop_panel%d.png", arg_3_3.isShow and 8 or 6))

					local var_3_6 = arg_3_1:get("title1")

					var_3_6:text(var_3_2.name)

					if matchLanguage({
						"en"
					}) then
						adapt.setTextAdaptWithSize(var_3_6, {
							vertical = "center",
							horizontal = "center",
							size = cc.size(380, 200)
						})
					end

					arg_3_1:get("title2"):visible(not arg_3_3.isShow)
					arg_3_1:get("txtPos"):removeAllChildren()

					local var_3_7 = {}

					for iter_3_2, iter_3_3 in ipairs(var_3_4) do
						var_0_0(arg_3_0, arg_3_1, var_3_1:clone():show(), iter_3_3.id, iter_3_3.state)
					end

					local var_3_8 = 0
					local var_3_9 = csvSize(var_3_2.attrMap)
					local var_3_10 = arg_3_3.isShow and "#C0xF76B45#" or ""
					local var_3_11 = "#C0x57472E#%s%s%s %s "

					if matchLanguage({
						"en"
					}) then
						var_3_11 = var_3_11 .. "\n"
					end

					for iter_3_4, iter_3_5 in csvPairs(var_3_2.attrMap) do
						var_3_8 = var_3_8 + 1

						local var_3_12 = getLanguageAttr(iter_3_4)
						local var_3_13 = string.format(var_3_11, var_3_12, gLanguageCsv.improve, var_3_10, dataEasy.getAttrValueString(iter_3_4, iter_3_5))

						table.insert(var_3_7, var_3_13)

						if var_3_8 < var_3_9 then
							table.insert(var_3_7, "\n")
						end
					end

					local var_3_14 = table.concat(var_3_7, "")
					local var_3_15 = matchLanguage({
						"kr"
					}) and 470 or 350
					local var_3_16 = matchLanguage({
						"en"
					}) and 35 or 44
					local var_3_17 = rich.createWithWidth(var_3_14, var_3_16, nil, var_3_15, 24)

					var_3_17:setAnchorPoint(cc.p(0, 0.5))
					arg_3_1:get("txtPos"):addChild(var_3_17)
				end
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.cardId = arg_4_2
	arg_4_0.fetterDatas = arg_4_1

	arg_4_0.item:get("list"):setScrollBarEnabled(false)
	Dialog.onCreate(arg_4_0)
end

function var_0_1.onClose(arg_5_0)
	if arg_5_0._closecb then
		arg_5_0._closecb()
	end

	return Dialog.onClose(arg_5_0)
end

function var_0_1.onFetterInfo(arg_6_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_6_0:createHandler("getRuleContext"), {
		width = 860
	})
end

function var_0_1.getRuleContext(arg_7_0, arg_7_1)
	local var_7_0 = adaptContext

	return {
		var_7_0.clone(arg_7_1.title, function(arg_8_0)
			arg_8_0:get("text"):text(gLanguageCsv.fetterInfo)
		end),
		var_7_0.noteText(54001, 54003)
	}
end

return var_0_1
