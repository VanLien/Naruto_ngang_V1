local var_0_0 = class("CardEffortValueDetailView", Dialog)

var_0_0.RESOURCE_FILENAME = "card_effortvalue_detail.json"
var_0_0.RESOURCE_BINDING = {
	item = "item",
	["panel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				padding = 5,
				data = bindHelper.self("advanceDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("pos")
					local var_1_1 = (arg_1_3.effortAdvance >= arg_1_3.advance and "#C0xFFFFFF#" or "#C0x989898#") .. gLanguageCsv.effortAdvanceAttrTip

					if arg_1_3.effortAdvance == arg_1_3.advance then
						var_1_1 = var_1_1 .. gLanguageCsv.effortCurrentAdvance
					end

					local var_1_2 = arg_1_3.addStr

					if not string.find(var_1_2, "%%") then
						var_1_2 = var_1_2 .. "%"
					end

					if matchLanguage({
						"cn",
						"tw"
					}) then
						rich.createByStr(string.format(var_1_1, dataEasy.getRomanNumeral(arg_1_3.advance), var_1_2), 40):anchorPoint(0, 0.5):addTo(var_1_0.pos, 6)
					else
						rich.createByStr(string.format(var_1_1, dataEasy.getRomanNumeral(arg_1_3.advance), var_1_2), 36):anchorPoint(0, 0.5):addTo(var_1_0.pos, 6)
					end
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.item:hide()
	arg_2_0.list:size(918, 770)

	local var_2_0 = csv.cards[arg_2_2]
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in orderCsvPairs(gCardEffortAdvance[var_2_0.effortSeqID]) do
		if iter_2_0 <= iter_2_1.advanceLimit then
			table.insert(var_2_1, {
				advance = iter_2_0,
				addStr = iter_2_1.attrEffect,
				effortAdvance = arg_2_1
			})
		end
	end

	arg_2_0.advanceDatas = var_2_1

	Dialog.onCreate(arg_2_0, {
		clickClose = true,
		noBlackLayer = true
	})
end

return var_0_0
