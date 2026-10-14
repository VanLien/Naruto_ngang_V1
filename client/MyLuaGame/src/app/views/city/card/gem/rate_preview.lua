local var_0_0 = class("GemRatePreview", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "gem_rate_preview.json"
var_0_0.RESOURCE_BINDING = {
	listLine2 = "listLine2",
	subTitle = "subTitle",
	item = "item",
	bgLayer = "bg",
	listLine = "listLine",
	list = "list"
}

local var_0_1 = {
	{
		key = "gold",
		type = 9
	},
	{
		key = "rmb",
		type = 10
	}
}
local var_0_2 = {
	rarityGem5 = "city/card/gem/img_orange.png",
	rarityGem4 = "city/card/gem/img_purple.png",
	rarityGem3 = "city/card/gem/img_blue.png",
	normalItem = "city/card/gem/img_hs.png",
	rarityGem2 = "city/card/gem/img_green.png",
	rarityGem6 = "city/card/gem/img_yellow.png"
}
local var_0_3 = {
	[0] = cc.c4b(255, 255, 255, 255),
	[2] = cc.c4b(145, 224, 177, 255),
	[3] = cc.c4b(139, 175, 223, 255),
	[4] = cc.c4b(203, 141, 221, 255),
	[5] = cc.c4b(243, 137, 91, 255),
	[6] = cc.c4b(235, 183, 41, 255)
}

function var_0_0.onCreate(arg_1_0)
	arg_1_0.bg:scale(2)
	arg_1_0.item:visible(false)
	arg_1_0.subTitle:visible(false)
	arg_1_0.list:setScrollBarEnabled(false)

	for iter_1_0, iter_1_1 in pairs(var_0_1) do
		for iter_1_2, iter_1_3 in csvPairs(csv.draw_preview) do
			if iter_1_3.type == iter_1_1.type then
				arg_1_0:addRateItems(iter_1_3, iter_1_1.key)

				break
			end
		end
	end
end

var_0_0.RESOURCE_STYLES = {
	full = true
}

function var_0_0.addRateItems(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0.subTitle:clone()

	var_2_0:visible(true)
	var_2_0:get("textTitle"):text(gLanguageCsv[arg_2_2 .. "DrawRate"])
	arg_2_0.list:pushBackCustomItem(var_2_0)

	local var_2_1

	if csvSize(arg_2_1.desc) > 5 then
		var_2_1 = arg_2_0.listLine2:clone()
	else
		var_2_1 = arg_2_0.listLine:clone()
	end

	var_2_1:visible(true):setScrollBarEnabled(false)
	arg_2_0.list:pushBackCustomItem(var_2_1)

	for iter_2_0, iter_2_1 in orderCsvPairs(arg_2_1.desc) do
		local var_2_2 = arg_2_0.item:clone()

		var_2_2:visible(true)
		var_2_1:pushBackCustomItem(var_2_2)
		var_2_2:get("icon"):texture(var_0_2[iter_2_1[1]])
		var_2_2:get("name"):text(gLanguageCsv[iter_2_1[1]])
		text.addEffect(var_2_2:get("name"), {
			outline = {
				size = 2,
				color = ui.COLORS.NORMAL.BLACK
			}
		})
		var_2_2:get("rate"):text(iter_2_1[2] .. "%")

		local var_2_3 = tonumber(string.sub(iter_2_1[1], -1)) or 0

		var_2_2:get("name"):setTextColor(var_0_3[var_2_3])
	end

	var_2_1:setItemAlignCenter()
end

return var_0_0
