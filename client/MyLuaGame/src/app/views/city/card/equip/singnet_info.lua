local var_0_0 = {
	AWAKE = 2,
	STAR = 1
}
local var_0_1 = 50
local var_0_2 = 50
local var_0_3 = 5

local function var_0_4(arg_1_0, arg_1_1)
	local var_1_0 = csv.equips[arg_1_0.equip_id]
	local var_1_1

	if arg_1_0.awake ~= 0 then
		var_1_1 = var_1_0.name1 .. gLanguageCsv["symbolRome" .. arg_1_0.awake]
	else
		var_1_1 = var_1_0.name0
	end

	local var_1_2, var_1_3 = dataEasy.getQuality(arg_1_0.advance)

	arg_1_1:text(var_1_1 .. var_1_3)
	text.addEffect(arg_1_1, {
		color = var_1_2 == 1 and ui.COLORS.NORMAL.WHITE or ui.COLORS.QUALITY[var_1_2]
	})
end

local var_0_5 = class("signetInfo", Dialog)

var_0_5.RESOURCE_FILENAME = "card_equip_signet_info.json"
var_0_5.RESOURCE_BINDING = {
	["baseNode.tip"] = "tip",
	item = "item",
	["baseNode.degree"] = "degree",
	baseNode = "baseNode",
	["baseNode.name"] = "name",
	["baseNode.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("advanceDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("text1", "condition", "detail")
					local var_2_1 = arg_2_3.signetAdvance >= arg_2_3.advance

					var_2_0.text1:text(gLanguageCsv.signetInfoBeiDong .. arg_2_2)
					var_2_0.condition:text("(" .. arg_2_3.condition .. ")")

					local var_2_2, var_2_3 = math.modf(#arg_2_3.attrDetail / var_0_1)

					var_2_2 = var_2_3 == 0 and var_2_2 or var_2_2 + 1

					var_2_0.detail:height(var_0_2 * var_2_2)
					arg_2_1:height(arg_2_1:height() + var_0_2 * (var_2_2 - 2))
					var_2_0.text1:y(var_2_0.text1:y() + var_0_2 * (var_2_2 - 2))
					var_2_0.condition:y(var_2_0.condition:y() + var_0_2 * (var_2_2 - 2))
					var_2_0.detail:y(var_2_0.detail:y() + var_0_2 * (var_2_2 - 2) / 2)
					var_2_0.detail:text(arg_2_3.attrDetail)
					adapt.oneLinePos(var_2_0.text1, var_2_0.condition, cc.p(10, 0))

					if var_2_1 and not arg_2_3.visible then
						var_2_0.detail:color(cc.c3b(91, 84, 91))
						var_2_0.condition:visible(false)
					end
				end
			}
		}
	},
	["baseNode.icon"] = {
		varname = "equip",
		binds = {
			event = "extend",
			class = "equip_icon",
			props = {
				data = bindHelper.self("leftData"),
				onNode = function(arg_3_0)
					arg_3_0:multiget("star", "txtLv", "txtLvNum", "imgArrow").imgArrow:visible(false)
				end
			}
		}
	}
}

function var_0_5.onCreate(arg_4_0, arg_4_1)
	arg_4_0.item:hide()
	arg_4_0.list:size(840, 972)

	arg_4_0.leftData = arg_4_1

	local var_4_0 = csv.equips[arg_4_1.equip_id]

	var_0_4(arg_4_0.leftData, arg_4_0.name)

	local var_4_1 = {}

	arg_4_0.tip:text(gLanguageCsv.signetInfoTip)

	for iter_4_0 = 1, var_4_0.signetAdvanceMax do
		for iter_4_1, iter_4_2 in csvPairs(csv.base_attribute.equip_signet_advance) do
			if arg_4_1.signet_advance == var_4_0.signetAdvanceMax then
				if iter_4_2.advanceIndex == var_4_0.advanceIndex and iter_4_2.advanceLevel == arg_4_1.signet_advance - 1 then
					arg_4_0.degree:text(iter_4_2.advanceName .. " " .. var_0_3 .. gLanguageCsv.signetLevel)
				end
			elseif iter_4_2.advanceIndex == var_4_0.advanceIndex and iter_4_2.advanceLevel == arg_4_1.signet_advance then
				arg_4_0.degree:text(iter_4_2.advanceName .. " " .. arg_4_1.signet - arg_4_1.signet_advance * var_0_3 .. " " .. gLanguageCsv.signetLevel)
			end

			if iter_4_2.advanceIndex == var_4_0.advanceIndex and iter_4_2.advanceLevel == iter_4_0 then
				local var_4_2
				local var_4_3 = {}

				for iter_4_3 = 1, math.huge do
					local var_4_4 = iter_4_2["attrType" .. iter_4_3]

					if not var_4_4 or var_4_4 == 0 then
						break
					end

					local var_4_5 = game.ATTRDEF_TABLE[var_4_4]
					local var_4_6 = "attr" .. string.caption(var_4_5)

					table.insert(var_4_3, {
						name = gLanguageCsv[var_4_6],
						num = dataEasy.getAttrValueString(var_4_4, iter_4_2["attrNum" .. iter_4_3])
					})
				end

				local var_4_7 = ""

				for iter_4_4 = 1, #var_4_3 do
					var_4_7 = var_4_7 .. var_4_3[iter_4_4].name .. "+" .. var_4_3[iter_4_4].num .. "  "
				end

				local var_4_8 = false
				local var_4_9

				if iter_4_2.advanceLimitType == var_0_0.STAR then
					var_4_9 = string.format(gLanguageCsv.needEquipStar, iter_4_2.advanceLimitNum)

					if arg_4_1.star < iter_4_2.advanceLimitNum then
						var_4_8 = true
					end
				elseif iter_4_2.advanceLimitType == var_0_0.AWAKE then
					var_4_9 = gLanguageCsv.needEquipAwake .. gLanguageCsv["symbolRome" .. iter_4_2.advanceLimitNum]

					if arg_4_1.awake < iter_4_2.advanceLimitNum then
						var_4_8 = true
					end
				end

				local var_4_10 = ""

				for iter_4_5, iter_4_6 in csvMapPairs(iter_4_2.sceneType) do
					local var_4_11 = iter_4_6
					local var_4_12 = game.SCENE_TYPE_STRING_TABLE[var_4_11]

					var_4_10 = var_4_10 .. gLanguageCsv[var_4_12]

					if iter_4_5 < table.getn(iter_4_2.sceneType) then
						var_4_10 = var_4_10 .. gLanguageCsv.signetAnd
					end
				end

				table.insert(var_4_1, {
					advance = iter_4_0,
					condition = var_4_9,
					attrDetail = string.format(gLanguageCsv.signetInfoIn, var_4_10) .. var_4_7,
					signetAdvance = arg_4_1.signet_advance,
					visible = var_4_8
				})
			end
		end
	end

	arg_4_0.advanceDatas = var_4_1

	arg_4_0.list:xy(20, 50)
	arg_4_0.list:size(750, 570)
	Dialog.onCreate(arg_4_0, {
		clickClose = true,
		noBlackLayer = true
	})
end

return var_0_5
