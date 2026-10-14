local var_0_0 = require("app.views.city.card.property_swap.view")
local var_0_1 = class("PropertySwapChooseView", Dialog)
local var_0_2 = var_0_0.SWAP_TYPE

var_0_1.RESOURCE_FILENAME = "card_property_swap_choose.json"
var_0_1.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
	["empty.txtEmpty"] = "txtEmpty",
	empty = "empty",
	list = {
		varname = "cardList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 3,
				asyncPreload = 12,
				data = bindHelper.self("cardDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				dataOrderCmpGen = bindHelper.self("onSortCardList", true),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("cardItem", "name", "txtValueTitle", "txtValue")

					uiEasy.setIconName("card", arg_1_3.id, {
						space = true,
						node = var_1_0.name,
						name = arg_1_3.name,
						advance = arg_1_3.advance
					})
					var_1_0.txtValueTitle:text(arg_1_3.title)
					var_1_0.txtValue:text(arg_1_3.value)
					adapt.oneLinePos(var_1_0.txtValueTitle, var_1_0.txtValue, {
						cc.p(-10, 0)
					}, "left")
					bind.extend(arg_1_0, var_1_0.cardItem, {
						class = "card_icon",
						props = {
							unitId = arg_1_3.unitId,
							advance = arg_1_3.advance,
							star = arg_1_3.star,
							rarity = arg_1_3.rarity,
							lock = arg_1_3.lock,
							selected = arg_1_3.isSel,
							levelProps = {
								data = arg_1_3.level
							},
							params = {
								starScale = 0.85,
								starInterval = 12.5
							},
							onNode = function(arg_2_0)
								arg_2_0:xy(0, 0):scale(1)
								arg_2_0:get("frame"):scale(1.07)
								arg_2_0:get("rarity"):align(cc.p(0.5, 0.5)):xy(30, 165):scale(0.71)
								arg_2_0:get("imgSel"):scale(0.94)
							end
						}
					})
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.itemClick, arg_1_1, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemChoose")
			}
		}
	},
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0.cb = arg_3_3
	arg_3_0.cardDatas = idlers.new()

	adapt.setTextAdaptWithSize(arg_3_0.txtEmpty, {
		vertical = "center",
		horizontal = "center",
		size = cc.size(550, 200)
	})

	arg_3_0.pokedex = gGameModel.role:getIdler("pokedex")

	local var_3_0 = gGameModel.role:read("card_feels")
	local var_3_1 = csv.cards[gGameModel.cards:find(arg_3_2):read("card_id")]
	local var_3_2 = var_3_1.cardMarkID
	local var_3_3 = csv.unit[csv.cards[var_3_2].unitID].rarity
	local var_3_4 = var_3_1.feelItems

	arg_3_0.showTab = arg_3_1

	local var_3_5 = {}
	local var_3_6 = 0
	local var_3_7 = arg_3_1 == var_0_2.NATURE
	local var_3_8 = arg_3_1 == var_0_2.NVALUE
	local var_3_9 = arg_3_1 == var_0_2.EFFORTVALUE
	local var_3_10 = arg_3_1 == var_0_2.FEEL

	if var_3_10 then
		arg_3_0.txtEmpty:text(gLanguageCsv.noSpiritCondition)
	end

	if not var_3_10 then
		for iter_3_0, iter_3_1 in ipairs(gGameModel.role:read("cards")) do
			local var_3_11 = gGameModel.cards:find(iter_3_1):read("card_id", "skin_id", "level", "star", "advance", "locked", "name", "nvalue", "effort_values", "character")
			local var_3_12 = csv.cards[var_3_11.card_id]
			local var_3_13 = csv.unit[var_3_12.unitID]
			local var_3_14 = ""
			local var_3_15 = 0

			if var_3_7 then
				var_3_14 = gLanguageCsv.nature .. ": "
				var_3_15 = csv.character[var_3_11.character].name
			elseif var_3_8 then
				var_3_14 = gLanguageCsv.nvalue .. ": "

				for iter_3_2, iter_3_3 in pairs(var_3_11.nvalue) do
					var_3_15 = var_3_15 + iter_3_3
				end
			elseif var_3_9 then
				var_3_14 = gLanguageCsv.effortvalue .. ": "

				for iter_3_4, iter_3_5 in pairs(var_3_11.effort_values) do
					if iter_3_4 ~= "specialDamage" then
						var_3_15 = var_3_15 + iter_3_5
					end
				end
			end

			local var_3_16 = dataEasy.getUnitId(var_3_11.card_id, var_3_11.skin_id)

			if arg_3_2 ~= iter_3_1 and (var_3_2 == csv.cards[var_3_11.card_id].cardMarkID or var_3_9) then
				var_3_5[iter_3_1] = {
					isSel = false,
					id = var_3_11.card_id,
					unitId = var_3_16,
					name = var_3_12.name,
					rarity = var_3_13.rarity,
					level = var_3_11.level,
					star = var_3_11.star,
					dbid = iter_3_1,
					advance = var_3_11.advance,
					title = var_3_14,
					value = var_3_15
				}
				var_3_6 = var_3_6 + 1
			end
		end
	else
		local var_3_17 = {}
		local var_3_18 = arg_3_0.pokedex:read()

		for iter_3_6, iter_3_7 in pairs(gCardsCsv) do
			local var_3_19

			for iter_3_8, iter_3_9 in pairs(iter_3_7) do
				for iter_3_10, iter_3_11 in pairs(iter_3_9) do
					if var_3_18[iter_3_11.id] and (not var_3_19 or var_3_19.id < iter_3_11.id) then
						var_3_19 = iter_3_11
					end
				end
			end

			if var_3_19 then
				local var_3_20 = csv.cards[var_3_19.id]
				local var_3_21 = csv.cards[var_3_20.cardMarkID]
				local var_3_22 = csv.unit[var_3_21.unitID]
				local var_3_23 = var_3_21.feelItems

				if var_3_19.cardMarkID ~= var_3_2 and var_3_22.rarity == var_3_3 and var_3_23[1] == var_3_4[1] and var_3_23[2] == var_3_4[2] and var_3_23[3] == var_3_4[3] then
					table.insert(var_3_17, var_3_19)
				end
			end
		end

		for iter_3_12, iter_3_13 in pairs(var_3_17) do
			local var_3_24 = csv.cards[iter_3_13.id]
			local var_3_25 = csv.unit[var_3_24.unitID]
			local var_3_26 = (var_3_0[var_3_24.cardMarkID] or {}).level or 0

			var_3_5[iter_3_12] = {
				isSel = false,
				id = iter_3_13.id,
				unitId = var_3_24.unitID,
				name = var_3_24.name,
				rarity = var_3_25.rarity,
				dbid = iter_3_13.id,
				title = gLanguageCsv.feelValue .. ": ",
				value = var_3_26
			}
			var_3_6 = var_3_6 + 1
		end
	end

	arg_3_0.empty:setVisible(var_3_6 <= 0)
	arg_3_0.cardDatas:update(var_3_5)
	Dialog.onCreate(arg_3_0)
end

function var_0_1.onItemChoose(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	arg_4_0.cb(arg_4_4.dbid)
	arg_4_0:onClose()
end

function var_0_1.onSortCardList(arg_5_0, arg_5_1)
	return function(arg_6_0, arg_6_1)
		if arg_6_0.value ~= arg_6_1.value then
			return arg_6_0.value > arg_6_1.value
		end

		if arg_6_0.rarity ~= arg_6_1.rarity then
			return arg_6_0.rarity > arg_6_1.rarity
		end

		return arg_6_0.id < arg_6_1.id
	end
end

return var_0_1
