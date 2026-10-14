local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = csv.cards[arg_1_3]
	local var_1_1 = csv.unit[var_1_0.unitID]

	bind.extend(arg_1_0, arg_1_2:get("head"), {
		class = "card_icon",
		props = {
			cardId = arg_1_3,
			rarity = var_1_1.rarity,
			grayState = arg_1_4 and 0 or 2,
			onNode = function(arg_2_0)
				arg_2_0:scale(0.8)
			end
		}
	})

	local var_1_2 = arg_1_4 and ui.COLORS.NORMAL.WHITE or ui.NEWCOLORS.GRAY2

	text.addEffect(arg_1_2:get("textName"), {
		color = var_1_2
	})
	arg_1_2:get("textName"):text(var_1_0.name)
	arg_1_2:get("textName"):setFontSize(30)
	arg_1_1:get("list"):pushBackCustomItem(arg_1_2)
	arg_1_1:get("list"):adaptTouchEnabled()
end

local var_0_1 = class("HandBookFetterView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "handbook_fetter.json"
var_0_1.RESOURCE_BINDING = {
	roleItem = "roleItem",
	item = "item",
	["baseNode.tip"] = "tip",
	["baseNode.textName"] = "nodeName",
	["baseNode.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("fetterDatas"),
				subItem = bindHelper.self("roleItem"),
				cardId = bindHelper.self("cardIdIdler"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true,
					alwaysShow = true
				},
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					arg_3_1:removeChildByName("richtext")
					arg_3_1:get("list"):setScrollBarEnabled(false)

					local var_3_0 = csv.fetter[arg_3_3.id]
					local var_3_1 = arg_3_1:get("title.imgBg")
					local var_3_2 = arg_3_1:get("title.textName")

					var_3_2:text(var_3_0.name)

					if matchLanguage({
						"en"
					}) then
						var_3_1:size(var_3_2:size().width + 50, var_3_1:size().height)
						arg_3_1:get("title"):anchorPoint(0, 0.5)
						var_3_1:anchorPoint(0, 0.5)
						var_3_2:anchorPoint(0, 0.5)
						arg_3_1:get("title"):x(arg_3_1:get("title"):x() - 328)
						var_3_2:x(var_3_2:x() + 25)
						adapt.oneLinePos(var_3_2, arg_3_1:get("textTip"), cc.p(-100, 0))
					else
						adapt.setTextScaleWithWidth(arg_3_1:get("title.textName"), nil, 300)
					end

					local var_3_3 = {}
					local var_3_4 = false
					local var_3_5 = true

					for iter_3_0, iter_3_1 in ipairs(var_3_0.cards) do
						local var_3_6 = csv.cards[iter_3_1]
						local var_3_7 = arg_3_3.pokedex[iter_3_1] ~= nil

						table.insert(var_3_3, {
							id = arg_3_3.cardDatas[var_3_6.cardMarkID] or iter_3_1,
							state = var_3_7
						})

						if not var_3_7 then
							var_3_5 = false
						end
					end

					for iter_3_2, iter_3_3 in ipairs(var_3_3) do
						var_0_0(arg_3_0, arg_3_1, arg_3_0.subItem:clone():show(), iter_3_3.id, iter_3_3.state)
					end

					local var_3_8 = "city/handbook/box_output1.png"
					local var_3_9 = "city/handbook/tag__jb_01.png"
					local var_3_10 = cc.c4b(166, 151, 149, 255)

					if var_3_5 then
						var_3_8 = "city/handbook/box_output.png"
						var_3_9 = "city/handbook/tag__jb_00.png"
						var_3_10 = cc.c4b(229, 103, 92, 255)
					end

					arg_3_1:get("imgBg"):texture(var_3_8)
					arg_3_1:get("title.imgBg"):texture(var_3_9)
					text.addEffect(arg_3_1:get("title.textName"), {
						outline = {
							size = 3,
							color = var_3_10
						}
					})
					arg_3_1:get("textTip"):visible(not var_3_5)

					local var_3_11 = {}
					local var_3_12

					var_3_12 = var_3_5 and "#C0xF76B45#" or ""

					for iter_3_4, iter_3_5 in csvPairs(var_3_0.attrMap) do
						local var_3_13 = getLanguageAttr(iter_3_4)
						local var_3_14 = string.format("#C0xFFFFFF#%s" .. gLanguageCsv.improve .. " %s", var_3_13, dataEasy.getAttrValueString(iter_3_4, iter_3_5))

						table.insert(var_3_11, var_3_14)
					end

					local var_3_15 = table.concat(var_3_11, " ")
					local var_3_16 = rich.createWithWidth(var_3_15, 40, nil, 1000):setAnchorPoint(cc.p(0, 0.5)):xy(38, 244):addTo(arg_3_1, 10, "richtext")
				end
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1)
	arg_4_0:initModel()

	arg_4_0.cardIdIdler = arg_4_1.selCardId()
	arg_4_0.fetterDatas = idlers.newWithMap({})

	idlereasy.any({
		arg_4_0.cardDatas,
		arg_4_0.cardIdIdler,
		arg_4_0.pokedex
	}, function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		local var_5_0 = csv.cards[arg_5_2]
		local var_5_1 = {}
		local var_5_2 = {}

		for iter_5_0, iter_5_1 in ipairs(arg_5_1) do
			local var_5_3 = gGameModel.cards:find(iter_5_1)

			if var_5_3 then
				local var_5_4 = var_5_3:read("card_id")
				local var_5_5 = csv.cards[var_5_4].cardMarkID
				local var_5_6 = var_5_2[var_5_5]

				if not var_5_6 or var_5_6 < var_5_4 then
					var_5_2[var_5_5] = var_5_4
				end
			end
		end

		local var_5_7 = csvSize(var_5_0.fetterList)

		for iter_5_2 = 1, var_5_7 do
			var_5_1[iter_5_2] = {
				id = var_5_0.fetterList[iter_5_2],
				cardDatas = var_5_2,
				pokedex = arg_5_3
			}
		end

		arg_4_0.fetterDatas:update(var_5_1)
		arg_4_0.tip:visible(var_5_7 <= 0)

		local var_5_8 = {}
		local var_5_9 = csv.unit[var_5_0.unitID]

		table.insert(var_5_8, var_5_9.natureType)

		if var_5_9.natureType2 then
			table.insert(var_5_8, var_5_9.natureType2)
		end
	end)
end

function var_0_1.initModel(arg_6_0)
	arg_6_0.cardDatas = gGameModel.role:getIdler("cards")
	arg_6_0.pokedex = gGameModel.role:getIdler("pokedex")
end

return var_0_1
