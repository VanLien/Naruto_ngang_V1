local var_0_0 = class("CaptureHandbook", cc.load("mvc").ViewBase)
local var_0_1 = 9

local function var_0_2(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_1:size(1950, 90)
	arg_1_1:get("list"):hide()
	arg_1_1:get("title"):y(45):show()

	local var_1_0 = arg_1_1:get("title.textTitle")
	local var_1_1 = arg_1_1:get("title.imgRight")
	local var_1_2 = arg_1_1:get("title.imgLeft")

	if arg_1_3.gate == 0 then
		var_1_0:text(gLanguageCsv.card)
	else
		local var_1_3 = string.format(gLanguageCsv.unlockGateToCapture, arg_1_3.gate, csv.world_map[arg_1_3.gate + 10].name)

		var_1_0:text(var_1_3)
	end

	var_1_0:x(975)
	var_1_1:x(var_1_0:width() / 2 + 40 + 975)
	var_1_2:x(-var_1_0:width() / 2 - 40 + 975)
end

local function var_0_3(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = {}

	for iter_2_0, iter_2_1 in ipairs(arg_2_3) do
		table.insert(var_2_0, {
			key = "card",
			num = iter_2_1.cardID
		})
	end

	arg_2_1:get("title"):hide()

	local var_2_1 = arg_2_1:get("list"):y(0)
	local var_2_2 = arg_2_0.spriteItem

	arg_2_1:size(cc.size(1950, 195))
	bind.extend(arg_2_0, var_2_1, {
		class = "listview",
		props = {
			data = var_2_0,
			item = var_2_2,
			onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				bind.extend(arg_3_0, arg_3_1, {
					class = "icon_key",
					props = {
						data = arg_3_3
					}
				})
				arg_3_1:visible(true)
			end
		}
	})
end

var_0_0.RESOURCE_FILENAME = "capture_handbook.json"
var_0_0.RESOURCE_BINDING = {
	spriteItem = "spriteItem",
	item = "item",
	list = {
		varname = "listview",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 7,
				data = bindHelper.self("showDatas"),
				item = bindHelper.self("item"),
				spriteItem = bindHelper.self("spriteItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					if arg_4_3.type == "title" then
						var_0_2(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					else
						var_0_3(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					end
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_5_0)
	local var_5_0 = gGameModel.role:read("gate_open")

	arg_5_0.showDatas = {}

	local var_5_1 = {
		[0] = {}
	}

	for iter_5_0, iter_5_1 in orderCsvPairs(csv.capture.sprite) do
		if iter_5_1.type == 2 and iter_5_1.weight ~= 0 then
			local var_5_2 = math.floor(iter_5_1.gate % 10000 / 100)
			local var_5_3 = false

			if var_5_1[var_5_2] then
				for iter_5_2, iter_5_3 in ipairs(var_5_1[var_5_2]) do
					if iter_5_1.cardID == iter_5_3.cardID then
						var_5_3 = true

						break
					end
				end
			end

			if var_5_3 == false then
				if itertools.include(var_5_0, iter_5_1.gate) or iter_5_1.gate == 0 then
					table.insert(var_5_1[0], iter_5_1)
				else
					var_5_1[var_5_2] = var_5_1[var_5_2] or {}

					table.insert(var_5_1[var_5_2], iter_5_1)
				end
			end
		end
	end

	for iter_5_4, iter_5_5 in pairs(var_5_1) do
		table.sort(iter_5_5, function(arg_6_0, arg_6_1)
			local var_6_0 = csv.cards[arg_6_0.cardID].unitID
			local var_6_1 = csv.cards[arg_6_1.cardID].unitID

			return csv.unit[var_6_0].rarity > csv.unit[var_6_1].rarity
		end)
	end

	local var_5_4 = 0

	for iter_5_6, iter_5_7 in pairs(var_5_1) do
		var_5_4 = math.max(var_5_4, iter_5_6)
	end

	local var_5_5 = 1

	for iter_5_8 = 0, var_5_4 do
		local var_5_6 = var_5_1[iter_5_8]

		if var_5_6 ~= nil then
			arg_5_0.showDatas[var_5_5] = {
				type = "title",
				gate = iter_5_8
			}

			local var_5_7 = 0

			for iter_5_9, iter_5_10 in ipairs(var_5_6) do
				local var_5_8 = math.ceil(iter_5_9 / var_0_1)
				local var_5_9 = (iter_5_9 - 1) % var_0_1 + 1

				arg_5_0.showDatas[var_5_8 + var_5_5] = arg_5_0.showDatas[var_5_8 + var_5_5] or {}
				arg_5_0.showDatas[var_5_8 + var_5_5][var_5_9] = iter_5_10
				var_5_7 = var_5_7 + 1
			end

			var_5_5 = math.ceil(var_5_7 / var_0_1) + var_5_5 + 1
		end
	end
end

return var_0_0
