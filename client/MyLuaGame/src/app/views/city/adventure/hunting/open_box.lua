local var_0_0 = {
	"baoxiangzi_loop",
	"haohuabaoxiangzi_loop"
}
local var_0_1 = {
	"baoxiang_loop",
	"haohuabaoxiang_loop"
}
local var_0_2 = {
	"baoxiangkaixiang",
	"haohuabaoxiangkaixiang"
}

local function var_0_3(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = not arg_1_2 and "random_tower/baox.skel" or arg_1_2
	local var_1_1 = arg_1_3 or 0
	local var_1_2 = arg_1_0:get("effect")

	if not var_1_2 then
		widget.addAnimationByKey(arg_1_0, var_1_0, "effect", arg_1_1, 0):xy(arg_1_0:width() / 2, arg_1_0:height() / 2 - var_1_1):scale(2)
	else
		var_1_2:play(arg_1_1)
	end
end

local var_0_4 = cc.load("mvc").ViewBase
local var_0_5 = class("HuntingOpenBoxView", var_0_4)

var_0_5.RESOURCE_FILENAME = "hunting_open_box.json"
var_0_5.RESOURCE_BINDING = {
	imgCost = "imgCost",
	textNote = "textNote",
	textOpenTimes = "textOpenTimes",
	titlePos = "titlePos",
	textFree = "textFree",
	boxPos = "boxPos",
	textCost = "textCost",
	btnNext = {
		varname = "btnNext",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnNext")
			}
		}
	},
	btnOpen = {
		varname = "btnOpen",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnOpen")
			}
		}
	},
	["btnOpen.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_5.onCreate(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0.cb = arg_2_3
	arg_2_0.route = arg_2_1
	arg_2_0.node = arg_2_2

	arg_2_0:initModel()

	arg_2_0.boxLimit = csv.cross.hunting.base[arg_2_1].boxOpenLimit

	var_0_3(arg_2_0.titlePos, "haohuabaoxiangzi_loop", "random_tower/baox.skel", 770)
	var_0_3(arg_2_0.boxPos, "haohuabaoxiang_loop", "random_tower/baox.skel", 240)
	idlereasy.any({
		arg_2_0.boxInfo,
		arg_2_0.rmb
	}, function(arg_3_0, arg_3_1, arg_3_2)
		local var_3_0 = arg_3_1[arg_2_0.route].box_open_count or 0
		local var_3_1 = csv.cross.hunting.route
		local var_3_2 = math.min(var_3_0 + 1, arg_2_0.boxLimit)

		if arg_3_1[arg_2_0.route].node ~= arg_2_2 then
			var_3_0 = arg_2_0.boxLimit
		end

		local var_3_3 = "#C0x23DB04#"

		if var_3_0 >= arg_2_0.boxLimit then
			var_3_3 = "#C0xEB580E#"
		end

		uiEasy.setBtnShader(arg_2_0.btnNext, arg_2_0.btnNext:get("textNote"), var_3_0 ~= 0 and 1 or 2)

		if var_3_0 == 0 then
			text.deleteAllEffect(arg_2_0.btnNext:get("textNote"))
		else
			text.addEffect(arg_2_0.btnNext:get("textNote"), {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		end

		arg_2_0.textOpenTimes:text(""):removeAllChildren()

		local var_3_4 = arg_2_0.boxLimit - var_3_0

		rich.createByStr(string.format(gLanguageCsv.canOpenTimes, var_3_3 .. var_3_4 .. "#C0xFFFCED#", arg_2_0.boxLimit), 36):anchorPoint(0.5, 0.5):addTo(arg_2_0.textOpenTimes, 6)

		local var_3_5 = gCostCsv.hunting_box_cost

		arg_2_0.rmbCost = var_3_5[math.min(math.max(var_3_2 - 1, 1), table.length(var_3_5))]

		arg_2_0.textCost:text(arg_2_0.rmbCost)

		local var_3_6 = ui.COLORS.NORMAL.ALERT_YELLOW

		if arg_3_2 >= arg_2_0.rmbCost then
			var_3_6 = ui.COLORS.NORMAL.WHITE
		end

		arg_2_0.textFree:visible(var_3_2 == 1 and var_3_1[arg_3_1[arg_2_0.route].node].type == 2)
		itertools.invoke({
			arg_2_0.textNote,
			arg_2_0.textCost,
			arg_2_0.imgCost
		}, (var_3_2 == 1 or var_3_0 == arg_2_0.boxLimit) and "hide" or "show")
		text.addEffect(arg_2_0.textCost, {
			color = var_3_6
		})
		adapt.oneLineCenterPos(cc.p(arg_2_0.btnOpen:x(), arg_2_0.textCost:y()), {
			arg_2_0.textNote,
			arg_2_0.textCost,
			arg_2_0.imgCost
		}, cc.p(15, 0))
	end)
end

function var_0_5.initModel(arg_4_0)
	arg_4_0.boxInfo = gGameModel.hunting:getIdler("hunting_route")
	arg_4_0.rmb = gGameModel.role:getIdler("rmb")
end

function var_0_5.onBtnOpen(arg_5_0)
	local var_5_0 = arg_5_0.boxInfo:read()[arg_5_0.route].box_open_count

	if arg_5_0.rmbCost > arg_5_0.rmb:read() and var_5_0 and var_5_0 > 0 then
		uiEasy.showDialog("rmb")

		return
	end

	local function var_5_1()
		local var_6_0 = {
			false
		}

		gGameApp:requestServerCustom("/game/hunting/box/open"):params(arg_5_0.route, arg_5_0.node):onResponse(function(arg_7_0)
			var_0_3(arg_5_0.boxPos, "haohuabaoxiangkaixiang", "random_tower/baox.skel", 240)
			performWithDelay(arg_5_0.boxPos, function()
				var_6_0[1] = true

				gGameUI:showGainDisplay(arg_7_0, {
					cb = function()
						if var_5_0 and var_5_0 >= arg_5_0.boxLimit - 1 or not arg_5_0.boxInfo:read() then
							arg_5_0:onClose()

							return
						end

						var_0_3(arg_5_0.boxPos, "haohuabaoxiang_loop", "random_tower/baox.skel", 240)
					end
				})
			end, 1)
		end):wait(var_6_0):doit(function(arg_10_0)
			return
		end)
	end

	if var_5_0 and var_5_0 > 0 then
		dataEasy.sureUsingDiamonds(var_5_1, arg_5_0.rmbCost)
	else
		var_5_1()
	end
end

function var_0_5.onClose(arg_11_0)
	arg_11_0:addCallbackOnExit(arg_11_0.cb)
	var_0_4.onClose(arg_11_0)
end

function var_0_5.onBtnNext(arg_12_0)
	gGameApp:requestServer("/game/hunting/next", function(arg_13_0)
		arg_12_0:onClose()
	end, arg_12_0.route)
end

return var_0_5
