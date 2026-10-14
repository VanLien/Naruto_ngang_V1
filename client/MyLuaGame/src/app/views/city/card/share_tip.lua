local var_0_0 = {
	world = "world",
	union = "union"
}
local var_0_1 = class("CardShareTipView", Dialog)

var_0_1.RESOURCE_FILENAME = "card_share_tip.json"
var_0_1.RESOURCE_BINDING = {
	content = "content",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	titleTxt = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	btnCancel = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnSure = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShare")
			}
		}
	},
	textLeftNum = {
		binds = {
			event = "text",
			idler = bindHelper.self("shareTimes"),
			method = function(arg_1_0)
				local var_1_0 = gCommonConfigCsv.shareTimesLimit - arg_1_0

				return string.format("%s/%s", var_1_0, gCommonConfigCsv.shareTimesLimit)
			end
		}
	},
	checkBox1 = {
		varname = "checkBox1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_2_0)
					arg_2_0:onSelTargetPos(var_0_0.world)
				end)
			}
		}
	},
	checkBox2 = {
		varname = "checkBox2",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_3_0)
					arg_3_0:onSelTargetPos(var_0_0.union)
				end)
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1)
	arg_4_0:initModel()

	arg_4_0.dbId = arg_4_1
	arg_4_0.from = idler.new(var_0_0.world)

	idlereasy.when(arg_4_0.from, function(arg_5_0, arg_5_1)
		arg_4_0.checkBox1:get("checkBox"):setSelectedState(arg_5_1 == var_0_0.world)
		arg_4_0.checkBox2:get("checkBox"):setSelectedState(arg_5_1 == var_0_0.union)
	end)

	local var_4_0 = gGameModel.cards:find(arg_4_1)
	local var_4_1 = var_4_0:read("card_id")
	local var_4_2 = var_4_0:read("advance")
	local var_4_3 = csv.cards[var_4_1]
	local var_4_4, var_4_5 = dataEasy.getQuality(var_4_2)
	local var_4_6 = ui.QUALITY_OUTLINE_COLOR[var_4_4]
	local var_4_7 = "#C0x57472E#" .. string.format(gLanguageCsv.shareCardTo, var_4_6 .. var_4_3.name .. var_4_5 .. "#C0x57472E#")
	local var_4_8 = arg_4_0.content:size()
	local var_4_9 = rich.createWithWidth(var_4_7, 50, nil, var_4_8.width)

	var_4_9:alignCenter(var_4_8)
	var_4_9:addTo(arg_4_0.content, 2)
	Dialog.onCreate(arg_4_0)
end

function var_0_1.initModel(arg_6_0)
	arg_6_0.shareTimes = gGameModel.daily_record:getIdler("card_share_times")
	arg_6_0.unionId = gGameModel.role:getIdler("union_db_id")
end

function var_0_1.onSelTargetPos(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	arg_7_0.from:set(arg_7_1)
end

function var_0_1.onShare(arg_8_0)
	if gGameModel.daily_record:read("card_share_times") >= gCommonConfigCsv.shareTimesLimit then
		gGameUI:showTip(gLanguageCsv.shareTimesNotEnough)

		return
	end

	if arg_8_0.from:read() == var_0_0.union and not arg_8_0.unionId:read() then
		gGameUI:showTip(gLanguageCsv.notUnionCantShare)

		return
	end

	gGameApp:requestServer("/game/card/share", function()
		gGameUI:showTip(gLanguageCsv.recordShareSuccess)
		arg_8_0:onClose()
	end, arg_8_0.dbId, arg_8_0.from)
end

return var_0_1
