local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("TrainLevelUpgrade", var_0_0)
local var_0_2 = require("app.views.city.develop.trainer.view")

var_0_1.RESOURCE_FILENAME = "trainer_success.json"
var_0_1.RESOURCE_BINDING = {
	pos = "pos",
	name = "nodeName",
	item = "item",
	["centerTip.txt"] = "centerTxt",
	["centerTip.bg"] = "centerBg",
	leftTxt = "leftTxt",
	["centerTip.arrow"] = "centerArrow",
	rightTxt = "rightTxt",
	["centerTip.num"] = "centerNum",
	arrow = "arrow",
	leftList = {
		varname = "leftList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("leftData"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("icon", "name")
					local var_1_1 = game.ATTRDEF_TABLE[arg_1_3.id]

					var_1_0.icon:texture(ui.ATTR_LOGO[var_1_1])
					var_1_0.name:text(getLanguageAttr(arg_1_3.id) .. " +" .. dataEasy.getAttrValueString(arg_1_3.id, arg_1_3.num))
				end
			}
		}
	},
	rightList = {
		varname = "rightList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("rightData"),
				item = bindHelper.self("item"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("icon", "name")
					local var_2_1 = game.ATTRDEF_TABLE[arg_2_3.id]

					var_2_0.icon:texture(ui.ATTR_LOGO[var_2_1])
					var_2_0.name:text(getLanguageAttr(arg_2_3.id) .. " +" .. dataEasy.getAttrValueString(arg_2_3.id, arg_2_3.num))
				end
			}
		}
	},
	bg = {
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1, arg_3_2)
	audio.playEffectWithWeekBGM("unlock.mp3")
	arg_3_0:initModel()

	arg_3_0.topCenter = arg_3_2()

	if arg_3_1 == 0 then
		arg_3_0.leftList:hide()
		arg_3_0.arrow:hide()
		arg_3_0.rightList:x(arg_3_0.rightList:x() - 327)
		arg_3_0.leftTxt:hide()
		arg_3_0.rightTxt:x(arg_3_0.rightTxt:x() - 317)

		arg_3_0.leftData = idlertable.new({})
	else
		local var_3_0 = csv.trainer.trainer_level[arg_3_1]
		local var_3_1 = {}

		for iter_3_0, iter_3_1 in csvPairs(var_3_0.attrs) do
			table.insert(var_3_1, {
				id = iter_3_0,
				num = iter_3_1
			})
		end

		table.sort(var_3_1, function(arg_4_0, arg_4_1)
			return arg_4_0.id < arg_4_1.id
		end)

		arg_3_0.leftData = idlertable.new(var_3_1)

		arg_3_0.leftTxt:text(var_3_0.name)
	end

	local var_3_2 = {}
	local var_3_3 = csv.trainer.trainer_level[arg_3_0.trainerLevel:read()]

	for iter_3_2, iter_3_3 in csvPairs(var_3_3.attrs) do
		table.insert(var_3_2, {
			id = iter_3_2,
			num = iter_3_3
		})
	end

	table.sort(var_3_2, function(arg_5_0, arg_5_1)
		return arg_5_0.id < arg_5_1.id
	end)

	arg_3_0.rightData = idlertable.new(var_3_2)

	table.sort(var_3_2, function(arg_6_0, arg_6_1)
		return arg_6_0.id < arg_6_1.id
	end)

	arg_3_0.rightData = idlertable.new(var_3_2)

	arg_3_0.nodeName:text(var_3_3.name)
	arg_3_0.rightTxt:text(var_3_3.name)

	local var_3_4

	var_3_4 = arg_3_0.trainerLevel:read() < 7 and "1_6" or "7_12"

	widget.addAnimation(arg_3_0.pos, "config/trainer/trainer_" .. arg_3_0.trainerLevel:read() .. ".png", "", 2):alignCenter(arg_3_0.pos:size())

	local var_3_5, var_3_6 = csvNext(var_3_3.privilege)

	if not string.find(tostring(var_3_6), ".", 1, true) then
		arg_3_0.centerNum:text((itertools.first(var_0_2.ADD_SHOW, var_3_5) ~= nil and "+" or "") .. var_3_6)
	else
		arg_3_0.centerNum:text((itertools.first(var_0_2.ADD_SHOW, var_3_5) ~= nil and var_3_5 ~= game.PRIVILEGE_TYPE.ExpItemCostFallRate and "+" or "") .. var_3_6 * 100 .. "%")
	end

	local var_3_7 = gLanguageCsv["trainerPrivilege" .. var_3_5]

	if var_3_5 == game.PRIVILEGE_TYPE.BattleSkip then
		local var_3_8 = gLanguageCsv[game.SCENE_TYPE_STRING_TABLE[var_3_6]]

		var_3_7 = string.format(gLanguageCsv["trainerPrivilege" .. var_3_5], var_3_8)
	elseif var_3_5 == game.PRIVILEGE_TYPE.GateSaoDangTimes or var_3_5 == game.PRIVILEGE_TYPE.DrawItemFreeTimes then
		var_3_7 = string.format(gLanguageCsv["trainerPrivilege" .. var_3_5], var_3_6)
	end

	arg_3_0.centerTxt:text(var_3_7)

	local var_3_9 = 0

	if var_3_5 ~= 1 then
		var_3_9 = var_3_9 + arg_3_0.centerNum:size().width
	end

	if itertools.first(var_0_2.ARROW_NOT_SHOW, var_3_5) then
		arg_3_0.centerArrow:hide()

		if var_3_5 == game.PRIVILEGE_TYPE.ExpItemCostFallRate then
			arg_3_0.centerNum:show()
		else
			arg_3_0.centerNum:hide()
		end
	else
		arg_3_0.centerArrow:show()
		arg_3_0.centerNum:show()

		var_3_9 = var_3_9 + arg_3_0.centerArrow:getBoundingBox().width
	end

	local var_3_10 = var_3_9 + arg_3_0.centerTxt:size().width
	local var_3_11 = arg_3_0.centerBg:size()

	arg_3_0.centerBg:size(var_3_10 + 200, var_3_11.height)

	local var_3_12 = arg_3_0.centerBg:x()

	arg_3_0.centerTxt:x(var_3_12 - (var_3_10 - 200) / 2 - 20)
	adapt.oneLinePos(arg_3_0.centerTxt, {
		arg_3_0.centerNum,
		arg_3_0.centerArrow
	})

	local var_3_13 = arg_3_0:getResourceNode()
	local var_3_14 = widget.addAnimationByKey(var_3_13, "effect/gongxihuode.skel", "spine1", "xjiesuan_jinshengzi", 103)

	var_3_14:align(cc.p(0.5, 1), var_3_13:get("title"):xy())
	var_3_14:addPlay("jiesuan_jinshengzi_loop")

	local var_3_15 = widget.addAnimationByKey(var_3_13, "effect/gongxihuode.skel", "spine2", "jiesuan_shenglitu", 100)

	var_3_15:align(cc.p(0.5, 1), var_3_13:get("title"):xy())
	var_3_15:addPlay("jiesuan_shenglitu_loop")
	arg_3_0:showReward()
end

function var_0_1.showReward(arg_7_0)
	local var_7_0 = csv.trainer.trainer_level[arg_7_0.trainerLevel:read()]
	local var_7_1 = {}

	for iter_7_0, iter_7_1 in csvMapPairs(var_7_0.firstAward) do
		var_7_1[iter_7_0] = iter_7_1
	end

	gGameUI:showGainDisplay(var_7_1)
end

function var_0_1.initModel(arg_8_0)
	arg_8_0.trainerLevel = gGameModel.role:getIdler("trainer_level")
end

function var_0_1.onClose(arg_9_0)
	arg_9_0.topCenter:set(arg_9_0.trainerLevel:read() + 1)
	var_0_0.onClose(arg_9_0)
end

return var_0_1
