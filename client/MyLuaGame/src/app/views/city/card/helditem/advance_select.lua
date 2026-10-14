local var_0_0 = class("HeldItemAdvanceSelectView", Dialog)

var_0_0.RESOURCE_FILENAME = "held_item_advance_select.json"
var_0_0.RESOURCE_BINDING = {
	textNum = "textNum",
	subList = "subList",
	item = "item",
	empty = "empty",
	["empty.text"] = "txtEmpty",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 20,
				columnSize = 5,
				data = bindHelper.self("itemDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:multiget("mask").mask:visible(arg_1_3.selectState == true)
					bind.extend(arg_1_0, arg_1_1, {
						class = "icon_key",
						props = {
							data = {
								key = arg_1_3.csvId,
								dbId = arg_1_3.dbId
							},
							specialKey = {
								lv = arg_1_3.orderType ~= 1 and arg_1_3.lv or nil
							},
							grayState = arg_1_3.selectState == true and 1 or 0,
							onNode = function(arg_2_0)
								arg_2_0:setTouchEnabled(false)
							end
						}
					})
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.itemClick, arg_1_0:getIdx(arg_1_2), arg_1_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	btnSure = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSureClick")
			}
		}
	},
	["btnSure.textNote"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0.selectMaxNum = arg_3_3
	arg_3_0.cb = arg_3_4

	adapt.setTextAdaptWithSize(arg_3_0.txtEmpty, {
		vertical = "center",
		horizontal = "center",
		size = cc.size(520, 200)
	})
	arg_3_0:initModel()

	arg_3_0.itemDatas = idlers.new()

	idlereasy.any({
		arg_3_0.heldItems,
		arg_3_0.items
	}, function(arg_4_0, arg_4_1, arg_4_2)
		local var_4_0 = dataEasy.getInMeteorHelditemsHash()
		local var_4_1 = {}

		for iter_4_0, iter_4_1 in pairs(arg_4_1) do
			local var_4_2 = gGameModel.held_items:find(iter_4_1)

			if var_4_2 then
				local var_4_3 = var_4_2:read("held_item_id", "advance", "sum_exp", "card_db_id", "level", "exist_flag")

				if var_4_3.exist_flag and iter_4_1 ~= arg_3_1 and var_4_3.held_item_id == arg_3_2 and not var_4_0[iter_4_1] then
					table.insert(var_4_1, {
						quality = 1,
						csvId = var_4_3.held_item_id,
						dbId = iter_4_1,
						lv = var_4_3.level,
						advance = var_4_3.advance,
						cardDbId = var_4_3.card_db_id,
						orderType = var_4_3.card_db_id and 3 or 2
					})
				end
			end
		end

		local var_4_4 = csv.held_item.items[arg_3_2].universalItems

		for iter_4_2, iter_4_3 in pairs(var_4_4) do
			local var_4_5 = arg_4_2[iter_4_3] or 0

			for iter_4_4 = 1, var_4_5 do
				local var_4_6 = csv.items[iter_4_3]

				table.insert(var_4_1, {
					lv = 1,
					orderType = 1,
					csvId = iter_4_3,
					quality = var_4_6.quality
				})
			end
		end

		table.sort(var_4_1, function(arg_5_0, arg_5_1)
			if arg_5_0.orderType ~= arg_5_1.orderType then
				return arg_5_0.orderType < arg_5_1.orderType
			end

			if arg_5_0.lv ~= arg_5_1.lv then
				return arg_5_0.lv < arg_5_1.lv
			end

			return arg_5_0.quality < arg_5_1.quality
		end)
		arg_3_0.empty:visible(itertools.size(var_4_1) == 0)
		arg_3_0.itemDatas:update(var_4_1)
	end)

	arg_3_0.selectIdx = idler.new()
	arg_3_0.selectNum = 0

	idlereasy.when(arg_3_0.selectIdx, function(arg_6_0, arg_6_1)
		arg_3_0.textNum:text(arg_3_0.selectNum .. "/" .. arg_3_3)

		if arg_3_0.itemDatas:atproxy(arg_6_1) then
			local var_6_0 = arg_3_0.itemDatas:atproxy(arg_6_1)

			if arg_3_0.selectNum >= arg_3_3 and var_6_0.selectState ~= true then
				return
			end

			var_6_0.selectState = not var_6_0.selectState

			local var_6_1 = 0

			for iter_6_0 = 1, arg_3_0.itemDatas:size() do
				if arg_3_0.itemDatas:atproxy(iter_6_0).selectState == true then
					var_6_1 = var_6_1 + 1
				end
			end

			arg_3_0.selectNum = var_6_1

			arg_3_0.textNum:text(var_6_1 .. "/" .. arg_3_3)
		end
	end)
	Dialog.onCreate(arg_3_0, {
		blackType = 1,
		clickClose = true,
		noBlackLayer = true
	})
end

function var_0_0.initModel(arg_7_0)
	arg_7_0.heldItems = gGameModel.role:getIdler("held_items")
	arg_7_0.items = gGameModel.role:getIdler("items")
end

function var_0_0.onItemClick(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if arg_8_0.selectMaxNum <= arg_8_0.selectNum and arg_8_3.selectState ~= true then
		gGameUI:showTip(gLanguageCsv.numberSelectedHasMet)

		return
	end

	local function var_8_0()
		if arg_8_3.lv and arg_8_3.lv > 1 or arg_8_3.advance and arg_8_3.advance > 1 then
			gGameUI:showDialog({
				btnType = 2,
				clearFast = true,
				isRich = true,
				content = gLanguageCsv.heldItemAdvanceLvTip,
				cb = function()
					arg_8_0.selectIdx:set(arg_8_2.k, true)
				end
			})
		else
			arg_8_0.selectIdx:set(arg_8_2.k, true)
		end
	end

	if arg_8_3.selectState ~= true then
		if arg_8_3.cardDbId then
			local var_8_1 = gGameModel.cards:find(arg_8_3.cardDbId)
			local var_8_2 = var_8_1:read("advance")
			local var_8_3 = var_8_1:read("name")
			local var_8_4 = var_8_1:read("card_id")

			if var_8_3 == "" then
				var_8_3 = csv.cards[var_8_4].name
			end

			local var_8_5, var_8_6 = dataEasy.getQuality(var_8_2)
			local var_8_7 = ui.QUALITYCOLOR[var_8_5] .. var_8_3 .. var_8_6

			gGameUI:showDialog({
				btnType = 2,
				clearFast = true,
				isRich = true,
				content = string.format(gLanguageCsv.heldItemAdvanceDressTip, var_8_7),
				cb = function()
					gGameApp:requestServer("/game/helditem/unload", function()
						arg_8_0.itemDatas:atproxy(arg_8_2.k).cardDbId = nil

						var_8_0()
					end, arg_8_3.dbId)
				end
			})
		else
			var_8_0()
		end
	else
		arg_8_0.selectIdx:set(arg_8_2.k, true)
	end
end

function var_0_0.onSureClick(arg_13_0)
	local var_13_0 = {}
	local var_13_1 = {}

	for iter_13_0, iter_13_1 in arg_13_0.itemDatas:pairs() do
		local var_13_2 = iter_13_1:proxy()

		if var_13_2.selectState and var_13_2.dbId ~= nil then
			table.insert(var_13_1, var_13_2.dbId)
		end

		if var_13_2.selectState and not var_13_2.dbId then
			if not var_13_0[var_13_2.csvId] then
				var_13_0[var_13_2.csvId] = 0
			end

			var_13_0[var_13_2.csvId] = var_13_0[var_13_2.csvId] + 1
		end
	end

	arg_13_0.cb(var_13_1, var_13_0)
	arg_13_0:onClose()
end

return var_0_0
