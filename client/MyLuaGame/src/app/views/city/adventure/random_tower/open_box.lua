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
local var_0_3 = require("app.views.city.adventure.random_tower.tools")
local var_0_4 = cc.load("mvc").ViewBase
local var_0_5 = class("RandomTowerOpenBoxView", var_0_4)

var_0_5.RESOURCE_FILENAME = "random_tower_open_box.json"
var_0_5.RESOURCE_BINDING = {
	textNote = "textNote",
	textOpenTimes = "textOpenTimes",
	imgCost = "imgCost",
	titlePos = "titlePos",
	textFree = "textFree",
	boxPos = "boxPos",
	textCost = "textCost",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
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
			{
				event = "effect",
				data = {
					outline = {
						size = 1,
						color = ui.NEWCOLORS.OUTLINE.YELLOW1
					}
				}
			}
		}
	}
}

function var_0_5.onCreate(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.boardID = arg_1_1
	arg_1_0.cb = arg_1_2

	arg_1_0:initModel()

	local var_1_0 = csv.random_tower.board[arg_1_1]

	arg_1_0.boxLimit = gCommonConfigCsv["randomTowerBoxLimit" .. var_1_0.boxType] + 1
	arg_1_0.boxType = var_1_0.boxType

	var_0_3.setEffect(arg_1_0.titlePos, var_0_0[var_1_0.boxType], "random_tower/baoxiang.skel", 770)
	var_0_3.setEffect(arg_1_0.boxPos, var_0_1[var_1_0.boxType], "random_tower/baoxiang.skel", 240)
	idlereasy.any({
		arg_1_0.roomInfo,
		arg_1_0.rmb
	}, function(arg_2_0, arg_2_1, arg_2_2)
		local var_2_0 = arg_2_1.count or 0

		if not arg_2_1.board_id then
			var_2_0 = arg_1_0.boxLimit
		end

		local var_2_1 = math.min(var_2_0 + 1, arg_1_0.boxLimit)
		local var_2_2 = "#C0x01A001#"

		if var_2_0 >= arg_1_0.boxLimit then
			var_2_2 = "#C0xF41F0E#"
		end

		uiEasy.setBtnShader(arg_1_0.btnNext, arg_1_0.btnNext:get("textNote"), var_2_0 ~= 0 and 1 or 2)

		if var_2_0 ~= 0 then
			text.addEffect(arg_1_0.btnNext:get("textNote"), {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		else
			text.deleteAllEffect(arg_1_0.btnNext:get("textNote"))
		end

		arg_1_0.textOpenTimes:text(""):removeAllChildren()

		local var_2_3 = arg_1_0.boxLimit - var_2_0

		rich.createByStr(string.format(gLanguageCsv.canOpenTimes, var_2_2 .. var_2_3 .. "#C0xFFFCED#", arg_1_0.boxLimit), 36):anchorPoint(0.5, 0.5):addTo(arg_1_0.textOpenTimes, 6)

		local var_2_4 = gCostCsv["random_tower_box_cost" .. var_1_0.boxType]

		arg_1_0.rmbCost = var_2_4[math.min(var_2_1, table.length(var_2_4))]

		arg_1_0.textCost:text(arg_1_0.rmbCost)

		local var_2_5 = ui.COLORS.NORMAL.ALERT_YELLOW

		if arg_2_2 >= arg_1_0.rmbCost then
			var_2_5 = ui.COLORS.NORMAL.WHITE
		end

		arg_1_0.textFree:visible(var_2_1 == 1 and var_1_0.boxType == 2)
		itertools.invoke({
			arg_1_0.textNote,
			arg_1_0.textCost,
			arg_1_0.imgCost
		}, (var_2_1 == 1 or var_2_0 == arg_1_0.boxLimit) and "hide" or "show")
		text.addEffect(arg_1_0.textCost, {
			color = var_2_5
		})
		adapt.oneLineCenterPos(cc.p(arg_1_0.btnOpen:x(), arg_1_0.textCost:y()), {
			arg_1_0.textNote,
			arg_1_0.textCost,
			arg_1_0.imgCost
		}, cc.p(15, 0))
	end)
end

function var_0_5.initModel(arg_3_0)
	arg_3_0.roomInfo = gGameModel.random_tower:getIdler("room_info")
	arg_3_0.rmb = gGameModel.role:getIdler("rmb")
end

function var_0_5.onBtnOpen(arg_4_0)
	if arg_4_0.notClick == true then
		return
	end

	local var_4_0 = arg_4_0.roomInfo:read().count

	if arg_4_0.rmbCost > arg_4_0.rmb:read() and var_4_0 and var_4_0 > 0 then
		uiEasy.showDialog("rmb")

		return
	end

	local function var_4_1()
		arg_4_0.notClick = true

		gGameApp:requestServer("/game/random_tower/box/open", function(arg_6_0)
			var_0_3.setEffect(arg_4_0.boxPos, var_0_2[arg_4_0.boxType], "random_tower/baoxiang.skel", 240)
			performWithDelay(arg_4_0.boxPos, function()
				gGameUI:showGainDisplay(arg_6_0, {
					onlyGoldDouble = dataEasy.isDoubleHuodong("randomGold"),
					cb = function()
						arg_4_0.notClick = false

						if var_4_0 and var_4_0 >= arg_4_0.boxLimit - 1 or not arg_4_0.roomInfo:read().board_id then
							arg_4_0:addCallbackOnExit(arg_4_0.cb)
							var_0_4.onClose(arg_4_0)

							return
						end

						var_0_3.setEffect(arg_4_0.boxPos, var_0_1[arg_4_0.boxType], "random_tower/baoxiang.skel", 240)
					end
				})
			end, 1)
		end)
	end

	if var_4_0 and var_4_0 > 0 then
		dataEasy.sureUsingDiamonds(var_4_1, arg_4_0.rmbCost)
	else
		var_4_1()
	end
end

function var_0_5.onClose(arg_9_0)
	if arg_9_0.notClick == true then
		return
	end

	var_0_4.onClose(arg_9_0)
end

function var_0_5.onBtnNext(arg_10_0)
	if arg_10_0.notClick == true then
		return
	end

	gGameApp:requestServer("/game/random_tower/next", function(arg_11_0)
		arg_10_0:addCallbackOnExit(arg_10_0.cb)
		var_0_4.onClose(arg_10_0)
	end)
end

return var_0_5
