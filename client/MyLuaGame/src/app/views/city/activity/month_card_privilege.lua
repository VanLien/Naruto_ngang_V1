local var_0_0 = class("ActivityMonthCardPrivilegeView", Dialog)

var_0_0.RESOURCE_FILENAME = "activity_month_card_privilege.json"
var_0_0.RESOURCE_BINDING = {
	subList = "subList",
	card1 = "card1",
	item = "item",
	card2 = "card2",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("datas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("desc", "value")
					local var_1_1 = arg_1_1:size()
					local var_1_2 = string.format("%d.%s", arg_1_2, arg_1_3.str)
					local var_1_3 = ""

					if arg_1_3.typ == "normal" then
						var_1_3 = arg_1_3.val
					elseif arg_1_3.typ == "percent" then
						var_1_3 = arg_1_3.val * 100 .. "%"
					end

					var_1_0.desc:text(var_1_2)
					var_1_0.value:text(var_1_3)
					adapt.oneLinePos(var_1_0.desc, var_1_0.value, cc.p(0, 0), "left")
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1)
	local var_2_0 = {
		{
			name = "lianjinRate",
			typ = "percent",
			str = gLanguageCsv.monthCardPrivilege1
		},
		{
			name = "staminaExtraMax",
			typ = "normal",
			str = gLanguageCsv.monthCardPrivilege2
		},
		{
			name = "skillPointExtraMax",
			typ = "normal",
			str = gLanguageCsv.monthCardPrivilege3
		},
		{
			name = "pwNoCD",
			str = gLanguageCsv.monthCardPrivilege4
		},
		{
			name = "lianjinFreeTimes",
			typ = "normal",
			str = gLanguageCsv.monthCardPrivilege5
		},
		{
			name = "staminaBuyFreeTimes",
			typ = "normal",
			str = gLanguageCsv.monthCardPrivilege6
		},
		{
			name = "lianJinUpstart",
			str = gLanguageCsv.monthCardPrivilege7
		},
		{
			name = "huodongFragTimes",
			typ = "normal",
			str = gLanguageCsv.monthCardPrivilege8
		},
		{
			name = "huodongFragDropRate",
			typ = "percent",
			str = gLanguageCsv.monthCardPrivilege9
		},
		{
			name = "huodongGiftTimes",
			typ = "normal",
			str = gLanguageCsv.monthCardPrivilege10
		},
		{
			name = "huodongGiftDropRate",
			typ = "percent",
			str = gLanguageCsv.monthCardPrivilege11
		},
		{
			name = "fragShopRefreshLimit",
			typ = "normal",
			str = gLanguageCsv.monthCardPrivilege12
		},
		{
			name = "mysteryShopDiscount",
			typ = "percent",
			str = gLanguageCsv.monthCardPrivilege13
		},
		{
			name = "fixShopDiscount",
			typ = "percent",
			str = gLanguageCsv.monthCardPrivilege14
		},
		{
			name = "huodongGoldTimes",
			typ = "percent",
			str = gLanguageCsv.monthCardPrivilege15
		},
		{
			name = "huodongGoldDropRate",
			typ = "percent",
			str = gLanguageCsv.monthCardPrivilege16
		},
		{
			name = "huodongExpTimes",
			typ = "percent",
			str = gLanguageCsv.monthCardPrivilege17
		},
		{
			name = "huodongExpDropRate",
			typ = "percent",
			str = gLanguageCsv.monthCardPrivilege18
		}
	}
	local var_2_1 = arg_2_1.privilegeId
	local var_2_2 = arg_2_1.activityId
	local var_2_3 = csv.month_card_privilege[var_2_1]
	local var_2_4 = arg_2_0.list
	local var_2_5 = var_2_4:size()

	var_2_4:setScrollBarEnabled(false)

	local var_2_6 = 0

	arg_2_0.datas = {}

	local var_2_7 = csv.yunying.yyhuodong[var_2_2].paramMap.title

	if var_2_7 then
		local var_2_8 = gTitleCsv[var_2_7].title

		table.insert(arg_2_0.datas, {
			typ = "normal",
			str = gLanguageCsv.monthCardPrivilege19,
			val = var_2_8
		})
	end

	for iter_2_0, iter_2_1 in ipairs(var_2_0) do
		local var_2_9 = var_2_3[iter_2_1.name]

		if var_2_9 then
			iter_2_1.val = var_2_9

			table.insert(arg_2_0.datas, iter_2_1)
		end
	end

	arg_2_0.card1:visible(var_2_1 == 1)
	arg_2_0.card2:visible(var_2_1 == 2)
	Dialog.onCreate(arg_2_0)
end

return var_0_0
