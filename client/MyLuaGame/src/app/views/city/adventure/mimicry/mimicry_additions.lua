local var_0_0 = class("MimicryAddView", cc.load("mvc").ViewBase)
local var_0_1 = {
	cc.c4b(145, 225, 177, 255),
	cc.c4b(112, 161, 227, 255),
	cc.c4b(177, 135, 254, 255),
	cc.c4b(236, 183, 42, 255)
}
local var_0_2 = {
	"lv",
	"lan",
	"zi",
	"cheng"
}
local var_0_3 = {
	"#C0x91FFB1#",
	"#C0x70A1E3#",
	"#C0xB187FE#",
	"#C0xECB72A#"
}
local var_0_4 = 4

var_0_0.RESOURCE_FILENAME = "mimicry_addition.json"
var_0_0.RESOURCE_BINDING = {
	suitItem = "suitItem",
	noItem = "noItem",
	item2 = "item2",
	harm = "harm",
	itemUnlock = "itemUnlock",
	list = "list",
	noBuffItem = "noBuffItem",
	imgBg = {
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	},
	["item2.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.COLORS.NORMAL.DEFAULT
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_1 = arg_1_1 or {}
	arg_1_2 = arg_1_2[arg_1_3] or {}

	arg_1_0.suitItem:get("icon"):scale(0.44)
	arg_1_0.list:setScrollBarEnabled(false)

	for iter_1_0 = var_0_4, 1, -1 do
		local var_1_0 = iter_1_0
		local var_1_1 = arg_1_1[iter_1_0]
		local var_1_2 = arg_1_0.item2:clone():show()

		var_1_2:get("title"):text(string.format(gLanguageCsv.mimicryQuality, var_1_0))
		var_1_2:get("title"):setTextColor(var_0_1[var_1_0])
		arg_1_0.list:pushBackCustomItem(var_1_2)

		if #var_1_1 ~= 0 then
			for iter_1_1, iter_1_2 in ipairs(var_1_1) do
				local var_1_3 = arg_1_0.suitItem:clone():show()
				local var_1_4 = csv.mimicry.buffs[iter_1_2.id]
				local var_1_5 = string.format("#F44#%s%s#C0xFFFCED#   %s%s", var_0_3[var_1_0], var_1_4.name, gLanguageCsv.buffEffect, var_1_4.desc)

				var_1_3:get("icon"):texture(var_1_4.icon1)
				var_1_3:get("bg"):texture(string.format("city/adventure/mimicry/icon_ntdz_%s.png", var_0_2[var_1_4.quality]))
				beauty.textScroll({
					isRich = true,
					list = var_1_3:get("descList"),
					strs = var_1_5
				})
				arg_1_0.list:pushBackCustomItem(var_1_3)
			end
		else
			local var_1_6 = arg_1_0.noBuffItem:clone():show()

			arg_1_0.list:pushBackCustomItem(var_1_6)
		end

		if csv.mimicry.base[1][string.format("quality%sBuffFieldNum", var_1_0)] > (arg_1_2[var_1_0] or 0) then
			local var_1_7 = gGameModel.mimicry:read("total_scores")[arg_1_3]
			local var_1_8

			for iter_1_3, iter_1_4 in orderCsvPairs(csv.mimicry.buff_field) do
				if var_1_0 == iter_1_4.quality and iter_1_4.scoresCondition > (var_1_7 or 0) then
					var_1_8 = var_1_8 and math.min(iter_1_4.scoresCondition, var_1_8) or iter_1_4.scoresCondition
				end
			end

			if var_1_8 then
				local var_1_9 = arg_1_0.itemUnlock:clone():show()

				beauty.textScroll({
					isRich = true,
					align = "center",
					list = var_1_9:get("unLockList"),
					strs = string.format(gLanguageCsv.mimicryBuffUnlock2, tostring(var_1_8))
				})
				var_1_9:get("unLockList"):setItemAlignCenter()
				arg_1_0.list:pushBackCustomItem(var_1_9)
			end
		end
	end

	arg_1_0.list:adaptTouchEnabled()
end

return var_0_0
