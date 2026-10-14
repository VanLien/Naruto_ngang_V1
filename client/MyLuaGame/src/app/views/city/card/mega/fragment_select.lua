local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("MegaFragmentSelectView", Dialog)

var_0_1.RESOURCE_FILENAME = "card_mega_fragment_select.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	["tipPanel.textTip"] = "textTip",
	title = "title",
	innerList = "innerList",
	["title.btnClose"] = {
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
			class = "tableview",
			props = {
				columnSize = 6,
				data = bindHelper.self("showData"),
				item = bindHelper.self("innerList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					uiEasy.setIconName(arg_1_3.id, nil, {
						node = arg_1_1:get("name")
					})
					adapt.setTextScaleWithWidth(arg_1_1:get("name"), nil, 240)
					bind.extend(arg_1_0, arg_1_1:get("icon"), {
						class = "icon_key",
						props = {
							data = {
								key = arg_1_3.id,
								num = arg_1_3.num
							},
							onNode = function(arg_2_0)
								arg_2_0:setTouchEnabled(false)
							end
						}
					})
					bind.touch(arg_1_0, arg_1_1:get("icon"), {
						methods = {
							ended = functools.partial(arg_1_0.itemClick, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	tipPanel = {
		binds = {
			event = "visible",
			idler = bindHelper.self("showTip")
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.data = arg_3_1

	arg_3_0.item:visible(false)
	arg_3_0.list:setScrollBarEnabled(false)
	arg_3_0.innerList:setScrollBarEnabled(false)

	arg_3_0.showData = idlers.new({})
	arg_3_0.cb = arg_3_2
	arg_3_0.showTip = idler.new(false)

	local var_3_0 = csv.card_mega_convert[arg_3_1.csvId]
	local var_3_1 = gLanguageCsv.fragment

	idlereasy.any({
		gGameModel.role:getIdler("frags"),
		gGameModel.role:getIdler("zfrags")
	}, function(arg_4_0, arg_4_1, arg_4_2)
		local var_4_0 = {}

		for iter_4_0, iter_4_1 in pairs(arg_4_1) do
			local var_4_1 = csv.fragments[iter_4_0]

			if var_4_1.type == 1 then
				local var_4_2 = csv.cards[var_4_1.combID]
				local var_4_3 = csv.unit[var_4_2.unitID]
				local var_4_4 = dataEasy.getCfgByKey(iter_4_0).quality

				if var_3_0.needFrags1[1] == var_4_4 then
					for iter_4_2 = 1, math.huge do
						local var_4_5 = var_3_0["needFrags" .. iter_4_2]

						if itertools.isempty(var_4_5) then
							break
						end

						if var_4_5[2] == -1 or var_4_3.natureType == var_4_5[2] or var_4_3.natureType2 and var_4_3.natureType2 == var_4_5[2] then
							table.insert(var_4_0, {
								id = iter_4_0,
								num = iter_4_1,
								itemNum = var_4_5[3],
								cardType = var_4_2.cardType
							})

							break
						end
					end
				end
			end
		end

		arg_4_2 = arg_4_2 or {}

		for iter_4_3, iter_4_4 in pairs(arg_4_2) do
			local var_4_6 = csv.zawake.zawake_fragments[iter_4_3]
			local var_4_7 = var_4_6.quality

			if var_3_0.type == 1 and var_4_6.type == 5 or var_4_6.type == 6 then
				if var_3_0.needFrags1[1] == var_4_7 then
					for iter_4_5 = 1, math.huge do
						local var_4_8 = var_3_0["needFrags" .. iter_4_5]

						if itertools.isempty(var_4_8) then
							break
						end

						if var_4_8[2] == -1 then
							table.insert(var_4_0, {
								cardType = 0,
								id = iter_4_3,
								num = iter_4_4,
								itemNum = var_4_8[3]
							})

							break
						end
					end
				end
			elseif var_3_0.type == 2 and var_4_6.type == 5 and var_3_0.needFrags1[1] == var_4_7 then
				local var_4_9 = csv.cards[var_4_6.cardID]
				local var_4_10 = csv.unit[var_4_9.unitID]

				for iter_4_6 = 1, math.huge do
					local var_4_11 = var_3_0["needFrags" .. iter_4_6]

					if itertools.isempty(var_4_11) then
						break
					end

					if var_4_11[2] == -1 or var_4_10.natureType == var_4_11[2] or var_4_10.natureType2 and var_4_10.natureType2 == var_4_11[2] then
						table.insert(var_4_0, {
							cardType = 0,
							id = iter_4_3,
							num = iter_4_4,
							itemNum = var_4_11[3]
						})

						break
					end
				end
			end
		end

		table.sort(var_4_0, function(arg_5_0, arg_5_1)
			if arg_5_0.cardType ~= arg_5_1.cardType then
				return arg_5_0.cardType > arg_5_1.cardType
			end

			if arg_5_0.num ~= arg_5_1.num then
				return arg_5_0.num > arg_5_1.num
			end

			return arg_5_0.id < arg_5_1.id
		end)
		arg_3_0.showData:update(var_4_0)
		arg_3_0.textTip:text(gLanguageCsv.fragMentNotNum)
		arg_3_0.showTip:set(#var_4_0 == 0)
	end)
	arg_3_0.title:get("textNote2"):text(var_3_1)
	Dialog.onCreate(arg_3_0)
end

function var_0_1.onItemClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_0.data.selectId = arg_6_3.id

	arg_6_0:addCallbackOnExit(arg_6_0.cb)
	var_0_0.onClose(arg_6_0)
end

return var_0_1
