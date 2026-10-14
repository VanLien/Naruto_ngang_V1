local var_0_0 = {
	card = gLanguageCsv.card,
	item = gLanguageCsv.res,
	desc = gLanguageCsv.probability,
	equip = gLanguageCsv.carryItem
}
local var_0_1 = {
	diamond_up = 7,
	limit = 6,
	limit_sprite = 5,
	gold = 1,
	equip = 4,
	lucky_egg = 8,
	diamond = 2,
	component = 3,
	self_choose = 9
}
local var_0_2 = class("DrawCardPreviewView", cc.load("mvc").ViewBase)

var_0_2.RESOURCE_FILENAME = "drawcard_preview.json"
var_0_2.RESOURCE_BINDING = {
	textInnerList = "textInnerList",
	roleItem = "roleItem",
	item = "item",
	textItem = "textItem",
	innerList = "innerList",
	list = {
		varname = "listview",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 7,
				data = bindHelper.self("showDatas"),
				item = bindHelper.self("item"),
				roleItem = bindHelper.self("roleItem"),
				textItem = bindHelper.self("textItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					if arg_1_3.type == "title" then
						arg_1_1:size(1950, 60)
						itertools.invoke({
							arg_1_1:get("textNote"),
							arg_1_1:get("list"),
							arg_1_1:get("textInnerList")
						}, "hide")
						arg_1_1:get("title"):y(30)
						arg_1_1:get("title.textTitle"):text(var_0_0[arg_1_3.title])
						adapt.oneLineCenter(arg_1_1:get("title.textTitle"), arg_1_1:get("title.imgLeft"), arg_1_1:get("title.imgRight"), cc.p(10, 0))
					else
						itertools.invoke({
							arg_1_1:get("textNote"),
							arg_1_1:get("title"),
							arg_1_1:get("textInnerList")
						}, "hide")

						local var_1_0 = cc.size(1950, 195)
						local var_1_1 = arg_1_1:get("list")
						local var_1_2 = arg_1_0.roleItem

						if arg_1_3.type == "desc" then
							var_1_0 = cc.size(1950, 60)

							arg_1_1:get("textInnerList"):visible(true)
							arg_1_1:get("list"):visible(false)

							var_1_1 = arg_1_1:get("textInnerList")
							var_1_2 = arg_1_0.textItem
						end

						arg_1_1:size(var_1_0)
						var_1_1:y(0)

						local var_1_3 = {
							class = "listview",
							props = {
								data = arg_1_3.items,
								item = var_1_2,
								onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
									if arg_1_3.type == "desc" then
										arg_2_1:get("textName"):text(gLanguageCsv[arg_2_3.text])
										adapt.setTextScaleWithWidth(arg_2_1:get("textName"), nil, 380)
										arg_2_1:get("textVal"):text(arg_2_3.val .. "%")
										adapt.oneLinePos(arg_2_1:get("textName"), arg_2_1:get("textVal"), cc.p(10, 0), "left")
									else
										bind.extend(arg_2_0, arg_2_1, {
											class = var_0_0[arg_1_3.type] and "icon_key" or "explore_icon",
											props = {
												data = arg_2_3
											}
										})
									end

									if arg_2_3.up == true then
										cc.Sprite:create("city/drawcard/draw/txt_up.png"):addTo(arg_2_1):xy(cc.p(arg_2_1:size().width - 40, arg_2_1:size().height - 17)):z(5)
									end

									arg_2_1:visible(true)
								end
							}
						}

						bind.extend(arg_1_0, var_1_1, var_1_3)
					end
				end
			}
		}
	}
}

function var_0_2.onCreate(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_1 = var_0_1[arg_3_1] or 1

	local var_3_0 = {}

	arg_3_0.showDatas = {}

	local var_3_1 = arg_3_0:initModel(arg_3_1, arg_3_2, arg_3_3)

	arg_3_0:initUI(arg_3_1, var_3_1, arg_3_2, arg_3_3)
end

function var_0_2.initModel(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = {}

	if arg_4_1 == var_0_1.limit or arg_4_1 == var_0_1.diamond_up or arg_4_1 == var_0_1.limit_sprite or arg_4_1 == var_0_1.lucky_egg then
		local var_4_1 = csv.yunying.yyhuodong[arg_4_2].clientParam

		if var_4_1.priviewId and csv.draw_preview[var_4_1.priviewId] then
			var_4_0 = csv.draw_preview[var_4_1.priviewId]
		end
	elseif arg_4_1 == var_0_1.self_choose then
		local var_4_2 = arg_4_0:getPreviewId(arg_4_3)

		var_4_0 = csv.draw_preview[var_4_2]
	else
		var_4_0 = gDrawPreviewCsv[arg_4_1][1]
	end

	return var_4_0
end

function var_0_2.initUI(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	arg_5_0:card(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	arg_5_0:heldItem(arg_5_2)
	arg_5_0:itemId(arg_5_2)
	arg_5_0:description(arg_5_2)
end

function var_0_2.card(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if arg_6_2.card and csvSize(arg_6_2.card) > 0 then
		local var_6_0 = {}

		for iter_6_0, iter_6_1 in ipairs(arg_6_2.card) do
			local var_6_1 = false

			if arg_6_1 == var_0_1.diamond_up then
				local var_6_2 = csv.yunying.yyhuodong[arg_6_3].clientParam.up

				for iter_6_2, iter_6_3 in csvPairs(var_6_2) do
					if iter_6_1 == iter_6_3 then
						var_6_1 = true

						break
					end
				end
			end

			if arg_6_1 == var_0_1.self_choose then
				local var_6_3 = {}

				for iter_6_4, iter_6_5 in csvMapPairs(csv.draw_card_up_group) do
					if iter_6_4 == arg_6_4 then
						var_6_3 = iter_6_5.cards

						break
					end
				end

				for iter_6_6, iter_6_7 in csvPairs(var_6_3) do
					if iter_6_1 == iter_6_7 then
						var_6_1 = true

						break
					end
				end
			end

			table.insert(var_6_0, {
				key = "card",
				num = iter_6_1,
				up = var_6_1
			})
		end

		if arg_6_1 == var_0_1.diamond_up or arg_6_1 == var_0_1.self_choose then
			table.sort(var_6_0, function(arg_7_0, arg_7_1)
				local var_7_0 = csv.unit[csv.cards[arg_7_0.num].unitID]
				local var_7_1 = csv.unit[csv.cards[arg_7_1.num].unitID]

				if arg_7_0.up == arg_7_1.up then
					if var_7_0.rarity ~= var_7_1.rarity then
						return var_7_0.rarity >= var_7_1.rarity
					end

					return var_7_0.cardID < var_7_1.cardID
				elseif arg_7_0.up == true and arg_7_1.up == false then
					return true
				elseif arg_7_0.up == false and arg_7_1.up == true then
					return false
				end

				return false
			end)
		else
			table.sort(var_6_0, function(arg_8_0, arg_8_1)
				local var_8_0 = csv.unit[csv.cards[arg_8_0.num].unitID]
				local var_8_1 = csv.unit[csv.cards[arg_8_1.num].unitID]

				if var_8_0.rarity ~= var_8_1.rarity then
					return var_8_0.rarity > var_8_1.rarity
				end

				return var_8_0.cardID < var_8_1.cardID
			end)
		end

		table.insert(arg_6_0.showDatas, {
			title = "card",
			type = "title"
		})

		local var_6_4 = {}

		for iter_6_8, iter_6_9 in ipairs(var_6_0) do
			if iter_6_8 % 9 == 1 and iter_6_8 > 9 then
				table.insert(arg_6_0.showDatas, {
					type = "card",
					items = var_6_4
				})

				var_6_4 = {}
			end

			table.insert(var_6_4, iter_6_9)
		end

		if #var_6_4 > 0 then
			table.insert(arg_6_0.showDatas, {
				type = "card",
				items = var_6_4
			})
		end
	end
end

function var_0_2.heldItem(arg_9_0, arg_9_1)
	if arg_9_1.helditem and csvSize(arg_9_1.helditem) then
		local var_9_0 = {}

		for iter_9_0, iter_9_1 in ipairs(arg_9_1.helditem) do
			table.insert(var_9_0, {
				num = 0,
				key = iter_9_1
			})
		end

		table.sort(var_9_0, dataEasy.sortItemCmp)
		table.insert(arg_9_0.showDatas, {
			title = "equip",
			type = "title"
		})

		local var_9_1 = {}

		for iter_9_2, iter_9_3 in ipairs(var_9_0) do
			if iter_9_2 % 9 == 1 and iter_9_2 > 9 then
				table.insert(arg_9_0.showDatas, {
					type = "equip",
					items = var_9_1
				})

				var_9_1 = {}
			end

			table.insert(var_9_1, iter_9_3)
		end

		if #var_9_1 > 0 then
			table.insert(arg_9_0.showDatas, {
				type = "equip",
				items = var_9_1
			})
		end
	end
end

function var_0_2.itemId(arg_10_0, arg_10_1)
	if arg_10_1.item and csvSize(arg_10_1.item) > 0 then
		local var_10_0 = {}

		for iter_10_0, iter_10_1 in ipairs(arg_10_1.item) do
			table.insert(var_10_0, {
				num = 0,
				key = iter_10_1
			})
		end

		table.sort(var_10_0, dataEasy.sortItemCmp)
		table.insert(arg_10_0.showDatas, {
			title = "item",
			type = "title"
		})

		local var_10_1 = {}

		for iter_10_2, iter_10_3 in ipairs(var_10_0) do
			if iter_10_2 % 9 == 1 and iter_10_2 > 9 then
				table.insert(arg_10_0.showDatas, {
					type = "item",
					items = var_10_1
				})

				var_10_1 = {}
			end

			table.insert(var_10_1, iter_10_3)
		end

		if #var_10_1 > 0 then
			table.insert(arg_10_0.showDatas, {
				type = "item",
				items = var_10_1
			})
		end
	end
end

function var_0_2.description(arg_11_0, arg_11_1)
	if arg_11_1.desc and csvSize(arg_11_1.desc) then
		local var_11_0 = {}

		for iter_11_0, iter_11_1 in ipairs(arg_11_1.desc) do
			local var_11_1 = math.ceil(iter_11_0 / 4)

			if not var_11_0[var_11_1] then
				var_11_0[var_11_1] = {}
			end

			table.insert(var_11_0[var_11_1], {
				text = iter_11_1[1],
				val = iter_11_1[2]
			})
		end

		table.insert(arg_11_0.showDatas, {
			title = "desc",
			type = "title"
		})

		for iter_11_2, iter_11_3 in ipairs(var_11_0) do
			table.insert(arg_11_0.showDatas, {
				type = "desc",
				items = iter_11_3
			})
		end
	end
end

function var_0_2.getPreviewId(arg_12_0, arg_12_1)
	local var_12_0 = 0

	for iter_12_0, iter_12_1 in csvMapPairs(csv.draw_card_up_group) do
		if iter_12_0 == arg_12_1 then
			var_12_0 = iter_12_1.priviewId

			break
		end
	end

	return var_12_0
end

return var_0_2
