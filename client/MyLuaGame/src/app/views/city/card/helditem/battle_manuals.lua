local var_0_0 = class("BattlsManualsView", Dialog)
local var_0_1 = "city/card/battle_manuals/title_zdsc1_ml.png"
local var_0_2 = "city/card/battle_manuals/title_zdsc2_ml.png"

var_0_0.RESOURCE_FILENAME = "card_battle_manuals.json"
var_0_0.RESOURCE_BINDING = {
	item = "item",
	item2 = "item2",
	["right.list"] = "rightList",
	["right.slider"] = "slider",
	list = "list",
	right = "right",
	clickBg = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	name = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.RED
					}
				}
			}
		}
	},
	["right.title.name"] = {
		varname = "rightName",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BROWN2
					}
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0)
	gGameModel.forever_dispatch:getIdlerOrigin("battleManualDatas"):set(true)
	arg_1_0.list:setScrollBarEnabled(false)
	arg_1_0.item:get("list"):setScrollBarEnabled(false)

	local var_1_0 = csv.combat_manual

	arg_1_0.listData = idler.new(true)

	local function var_1_1(arg_2_0, arg_2_1, arg_2_2)
		arg_2_0:get("item"):get("bg"):texture("city/card/battle_manuals/title_zdsc1_mlxz.png")
		table.insert(arg_1_0.itemTab, {
			order = 1,
			k = arg_2_1,
			item = arg_2_0:get("item")
		})
		arg_1_0:rightUpdata(arg_2_1)
		arg_2_0:get("list"):removeAllChildren()

		if arg_2_2.contain and csvSize(arg_2_2.contain) >= 1 and not arg_2_0.select then
			arg_2_0:get("list"):show()
			arg_2_0:get("item"):get("icon"):rotate(90)

			arg_2_0.select = true

			arg_1_0:pushBackChild(arg_2_0, arg_2_1)
		else
			arg_2_0.select = false

			arg_2_0:get("item"):get("icon"):rotate(0)
			arg_2_0:get("list"):hide()
		end
	end

	arg_1_0.itemTabs = {}
	arg_1_0.itemK = false

	idlereasy.when(arg_1_0.listData, function(arg_3_0, arg_3_1)
		arg_1_0.itemTab = {}

		arg_1_0.list:removeAllChildren()

		local var_3_0 = 0

		for iter_3_0, iter_3_1 in orderCsvPairs(var_1_0) do
			if iter_3_1.catalogType == 1 then
				var_3_0 = var_3_0 + 1

				local var_3_1 = arg_1_0.item:clone():show()

				var_3_1:get("item"):get("name"):text(iter_3_1.name)

				local var_3_2 = iter_3_1.number < 10 and 0 .. iter_3_1.number or iter_3_1.number

				var_3_1:get("item"):get("order"):text(var_3_2)
				arg_1_0.list:pushBackCustomItem(var_3_1)

				if arg_1_0.itemK then
					if iter_3_0 == arg_1_0.itemK then
						var_3_1:get("item"):get("bg"):texture("city/card/battle_manuals/title_zdsc1_mlxz.png")

						arg_1_0.itemDataTab = var_3_1:get("item"):get("bg")
					end
				elseif csvSize(arg_1_0.itemTabs) >= 1 then
					if arg_1_0.itemTabs[iter_3_0] then
						var_3_1:get("item"):get("bg"):texture("city/card/battle_manuals/title_zdsc1_mlxz.png")
						var_3_1:get("list"):hide()

						arg_1_0.itemTabs[iter_3_0] = iter_3_0

						arg_1_0:rightUpdata(iter_3_0)
						var_1_1(var_3_1, iter_3_0, iter_3_1)
					end
				elseif iter_3_0 == 1 then
					var_3_1:get("item"):get("bg"):texture("city/card/battle_manuals/title_zdsc1_mlxz.png")
					var_3_1:get("list"):hide()

					arg_1_0.itemTabs[iter_3_0] = iter_3_0

					arg_1_0:rightUpdata(iter_3_0)
					var_1_1(var_3_1, iter_3_0, iter_3_1)
				end

				if iter_3_1.content ~= "FALSE" then
					var_3_1:get("item"):get("icon"):visible(iter_3_1.contain and csvSize(iter_3_1.contain) >= 1)
					var_3_1:get("item"):onClick(function()
						if iter_3_1.contain and csvSize(iter_3_1.contain) >= 1 then
							if not arg_1_0.itemTabs[iter_3_0] then
								arg_1_0.itemTabs = {}
								arg_1_0.itemTabs[iter_3_0] = iter_3_0
								arg_1_0.itemK = false
								arg_1_0.itemDataTab = nil
							else
								arg_1_0.itemTabs = {}
								arg_1_0.itemK = iter_3_0
							end

							arg_1_0.listData:set(true, true)
						else
							arg_1_0.itemK = false

							if arg_1_0.itemDataTab then
								arg_1_0.itemDataTab:texture(var_0_1)

								arg_1_0.itemDataTab = nil
							end

							table.insert(arg_1_0.itemTab, {
								order = 1,
								k = iter_3_0,
								item = var_3_1:get("item")
							})
							var_3_1:get("item"):get("bg"):texture("city/card/battle_manuals/title_zdsc1_mlxz.png")
							arg_1_0:rightUpdata(iter_3_0)
						end
					end)
				end
			end
		end

		local var_3_3
		local var_3_4
		local var_3_5

		if arg_1_0.itemK then
			var_3_4 = arg_1_0.itemK
		elseif csvSize(arg_1_0.itemTabs) >= 1 then
			local var_3_6

			var_3_6, var_3_4 = csvNext(arg_1_0.itemTabs)
		end

		if var_3_4 ~= 1 then
			if csvSize(var_1_0[var_3_4].contain) >= 1 then
				local var_3_7 = arg_1_0.item2:size().height * csvSize(var_1_0[var_3_4].contain) + 116 + (var_3_0 - 1) * arg_1_0.item:size().height

				var_3_5 = var_3_4 * arg_1_0.item:size().height / var_3_7 * 100
			else
				var_3_5 = var_3_4 / var_3_0 * 100
			end

			arg_1_0.list:jumpToPercentVertical(var_3_5)
		else
			arg_1_0.list:jumpToPercentVertical(0)
		end
	end)
	arg_1_0.item:hide()
	arg_1_0.item2:hide()
	Dialog.onCreate(arg_1_0)
end

function var_0_0.pushBackChild(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.item2:size().width
	local var_5_1 = arg_5_1:get("item")
	local var_5_2 = csv.combat_manual
	local var_5_3 = arg_5_0.item2:size().height * csvSize(var_5_2[arg_5_2].contain)

	arg_5_1:height(var_5_3 + 116)
	arg_5_1:get("list"):size(var_5_0, var_5_3)
	arg_5_1:get("list"):anchorPoint(cc.p(0, 1))
	arg_5_1:get("list"):y(var_5_3)
	var_5_1:y(var_5_3 + 58)

	for iter_5_0, iter_5_1 in ipairs(var_5_2[arg_5_2].contain) do
		local var_5_4 = var_5_2[iter_5_1]
		local var_5_5 = arg_5_0.item2:clone():show()

		var_5_5:get("name"):text(var_5_4.name)
		arg_5_1:get("list"):pushBackCustomItem(var_5_5)

		if var_5_4.content ~= "FALSE" then
			var_5_5:onClick(function()
				var_5_5:get("bg"):texture("city/card/battle_manuals/title_zdsc2_xz.png")
				table.insert(arg_5_0.itemTab, {
					order = 2,
					k = iter_5_1,
					item = var_5_5
				})
				arg_5_0:rightUpdata(iter_5_1)
			end)
		end
	end
end

function var_0_0.rightUpdata(arg_7_0, arg_7_1)
	if not arg_7_0.repetitionClick or arg_7_0.repetitionClick ~= arg_7_1 then
		arg_7_0.repetitionClick = arg_7_1
	elseif arg_7_0.repetitionClick == arg_7_1 then
		return
	end

	arg_7_0.rightList:removeAllChildren()

	for iter_7_0, iter_7_1 in pairs(arg_7_0.itemTab) do
		if iter_7_1.k ~= arg_7_1 and iter_7_1.item then
			local var_7_0 = iter_7_1.order == 1 and var_0_1 or var_0_2

			iter_7_1.item:get("bg"):texture(var_7_0)

			arg_7_0.itemTab[iter_7_0] = nil
		end
	end

	local var_7_1 = csv.combat_manual[arg_7_1]

	arg_7_0.rightName:text(var_7_1.name)

	local var_7_2 = "#C0x62440e#"
	local var_7_3, var_7_4 = beauty.textScroll({
		fontSize = 40,
		align = "left",
		rightPadding = 80,
		isRich = true,
		list = arg_7_0.rightList,
		strs = var_7_2 .. var_7_1.content .. var_7_2
	})

	if var_7_4 > var_7_3:size().height then
		local var_7_5, var_7_6 = arg_7_0.rightList:xy()
		local var_7_7 = arg_7_0.rightList:size()

		arg_7_0.slider:visible(true)

		local var_7_8, var_7_9 = arg_7_0.slider:xy()
		local var_7_10 = arg_7_0.slider:size()

		arg_7_0.rightList:setScrollBarEnabled(true)
		arg_7_0.rightList:setScrollBarColor(cc.c3b(245, 156, 2))
		arg_7_0.rightList:setScrollBarOpacity(255)
		arg_7_0.rightList:setScrollBarAutoHideEnabled(false)
		arg_7_0.rightList:setScrollBarPositionFromCorner(cc.p(var_7_5 + var_7_7.width - var_7_8, (var_7_7.height - var_7_10.height) / 2 + 15))
		arg_7_0.rightList:setScrollBarWidth(var_7_10.width)
		arg_7_0.rightList:jumpToPercentVertical(0)
		arg_7_0.rightList:refreshView()
	else
		arg_7_0.rightList:setScrollBarEnabled(false)
		arg_7_0.slider:visible(false)
	end
end

return var_0_0
