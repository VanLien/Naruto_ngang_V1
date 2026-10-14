local var_0_0 = {
	received = 2,
	noReach = 0,
	canReceive = 1
}
local var_0_1 = {
	reunion = 2,
	gift = 1
}
local var_0_2 = {
	ReunionGift = 1,
	TaskAward = 3,
	BindAward = 2,
	PointAward = 4
}
local var_0_3 = class("ReunionGiftView", cc.load("mvc").ViewBase)

var_0_3.RESOURCE_FILENAME = "reunion_gift.json"
var_0_3.RESOURCE_BINDING = {
	["rightPanel.list"] = "list",
	["rightPanel.textList"] = "textList",
	["rightPanel.receivebtn.label"] = "receivebtnLabel",
	["rightPanel.title"] = {
		varname = "title",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["rightPanel.receivebtn"] = {
		varname = "receivebtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onReceiveClick")
			}
		}
	}
}

function var_0_3.onCreate(arg_1_0, arg_1_1)
	arg_1_0.yyID = arg_1_1

	local var_1_0 = csv.yunying.yyhuodong[arg_1_1]

	arg_1_0:initModel()

	for iter_1_0, iter_1_1 in csvPairs(csv.yunying.reunion_gift) do
		if iter_1_1.huodongID == var_1_0.huodongID and iter_1_1.type == var_0_1.gift then
			uiEasy.createItemsToList(arg_1_0, arg_1_0.list, iter_1_1.item)

			arg_1_0.csvID = iter_1_0
		end
	end

	local var_1_1 = arg_1_0.reunion:read().info.gate

	if not csv.scene_conf[var_1_1].sceneName then
		local var_1_2 = ""
	end

	local var_1_3 = string.format(gLanguageCsv.reunionGiftText, arg_1_0.reunion:read().info.days)

	beauty.textScroll({
		fontSize = 40,
		isRich = true,
		verticalSpace = 20,
		list = arg_1_0.textList,
		strs = var_1_3
	})

	arg_1_0.datas = idlers.new()

	idlereasy.when(arg_1_0.reunion, function(arg_2_0, arg_2_1)
		text.deleteAllEffect(arg_1_0.receivebtnLabel)

		if not arg_2_1.gift then
			cache.setShader(arg_1_0.receivebtn, false, "hsl_gray")
			arg_1_0.receivebtnLabel:text(gLanguageCsv.notReach)
			arg_1_0.receivebtn:setTouchEnabled(false)
		elseif arg_2_1.gift.reunion and arg_2_1.gift.reunion[1] == arg_1_0.csvID and arg_2_1.gift.reunion[2] == var_0_0.canReceive then
			cache.setShader(arg_1_0.receivebtn, false, "normal")
			arg_1_0.receivebtnLabel:text(gLanguageCsv.spaceReceive)
			text.addEffect(arg_1_0.receivebtnLabel, {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
			arg_1_0.receivebtn:setTouchEnabled(true)
		elseif arg_2_1.gift.reunion and arg_2_1.gift.reunion[1] == arg_1_0.csvID and arg_2_1.gift.reunion[2] == var_0_0.received then
			cache.setShader(arg_1_0.receivebtn, false, "hsl_gray")
			arg_1_0.receivebtnLabel:text(gLanguageCsv.received)
			arg_1_0.receivebtn:setTouchEnabled(false)
		end
	end)
end

function var_0_3.initModel(arg_3_0)
	arg_3_0.reunion = gGameModel.role:getIdler("reunion")
end

function var_0_3.onReceiveClick(arg_4_0)
	if arg_4_0.reunion:read().info.end_time - time.getTime() < 0 then
		gGameUI:showTip(gLanguageCsv.activityOver)

		return
	end

	gGameApp:requestServer("/game/yy/reunion/award/get", function(arg_5_0)
		gGameUI:showGainDisplay(arg_5_0)
	end, arg_4_0.yyID, arg_4_0.csvID, var_0_2.ReunionGift)
end

return var_0_3
