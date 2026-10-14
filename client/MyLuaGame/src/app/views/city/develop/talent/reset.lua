local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("TalentResetView", Dialog)

var_0_1.RESOURCE_FILENAME = "talent_reset.json"
var_0_1.RESOURCE_BINDING = {
	icon = "rmbIcon",
	num = "rmbNum",
	txt1 = "txt1",
	txt2 = "txt2",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnNo = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnOk = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSureBtnClick")
			}
		}
	},
	title = {
		varname = "title",
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
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	arg_1_0:initModel()

	arg_1_0.params = arg_1_1 or {}
	arg_1_0.from = arg_1_0.params.from or "talent"
	arg_1_0.cost = arg_1_0.params.cost or arg_1_0.params.treeID and gCommonConfigCsv.talentResetCost or gCommonConfigCsv.talentResetAllCost

	arg_1_0.rmbNum:text("X" .. arg_1_0.cost)

	if arg_1_0.from == "dispatch_task" then
		arg_1_0.title:text(arg_1_0.params.title)
		arg_1_0.txt1:text(arg_1_0.params.txt1)
		arg_1_0.txt2:text(arg_1_0.params.txt2)
		adapt.oneLineCenterPos(cc.p(arg_1_0.title:x(), arg_1_0.txt1:y()), {
			arg_1_0.txt1,
			arg_1_0.rmbNum,
			arg_1_0.rmbIcon
		}, cc.p(15, 0))
	end

	if arg_1_0.params.treeID then
		arg_1_0.txt1:text(gLanguageCsv.talentTreeOneCost)
		adapt.oneLineCenterPos(cc.p(arg_1_0.title:x(), arg_1_0.txt1:y()), {
			arg_1_0.txt1,
			arg_1_0.rmbIcon,
			arg_1_0.rmbNum
		}, cc.p(15, 0))
	elseif matchLanguage({
		"kr"
	}) then
		adapt.oneLineCenterPos(cc.p(arg_1_0.title:x(), arg_1_0.txt1:y()), {
			arg_1_0.txt1,
			arg_1_0.rmbIcon,
			arg_1_0.rmbNum
		}, cc.p(15, 0))
	end

	adapt.setTextAdaptWithSize(arg_1_0.txt2, {
		vertical = "top",
		horizontal = "center",
		size = cc.size(850, 200)
	})
	arg_1_0.txt2:setAnchorPoint(0.5, 1)
	arg_1_0.txt2:x(arg_1_0.title:x())
	Dialog.onCreate(arg_1_0)
end

function var_0_1.initModel(arg_2_0)
	arg_2_0.rmb = gGameModel.role:getIdler("rmb")
	arg_2_0.level = gGameModel.role:read("level")
	arg_2_0.talentTree = gGameModel.role:getIdler("talent_trees")
end

function var_0_1.onSureBtnClick(arg_3_0)
	if arg_3_0.rmb:read() < arg_3_0.cost then
		gGameUI:showTip(gLanguageCsv.buyRMBNotEnough)

		return
	end

	local var_3_0 = false

	if arg_3_0.params.treeID then
		if arg_3_0.talentTree:read()[arg_3_0.params.treeID] and arg_3_0.talentTree:read()[arg_3_0.params.treeID].cost > 0 then
			var_3_0 = true
		end
	else
		for iter_3_0, iter_3_1 in csvMapPairs(csv.talent_tree) do
			if matchLanguage(iter_3_1.languages) and arg_3_0.level >= iter_3_1.showLevel and arg_3_0.talentTree:read()[iter_3_0] and arg_3_0.talentTree:read()[iter_3_0].cost > 0 then
				var_3_0 = true

				break
			end
		end
	end

	if not var_3_0 and arg_3_0.from == "talent" then
		gGameUI:showTip(gLanguageCsv.talentResetNoIDs)

		return
	end

	if arg_3_0.from == "talent" then
		gGameApp:requestServer("/game/talent/reset", function(arg_4_0)
			arg_3_0:onClose()
		end, arg_3_0.params.treeID)
	end

	if arg_3_0.from == "dispatch_task" then
		if arg_3_0.params.typ == "end" then
			gGameApp:requestServer("/game/dispatch/task/award", function(arg_5_0)
				local var_5_0 = arg_3_0.params.cb

				var_0_0.onClose(arg_3_0)
				var_5_0(arg_5_0)
			end, unpack(arg_3_0.params.requestParams or {}))
		else
			gGameApp:requestServer("/game/dispatch/task/refresh", function(arg_6_0)
				arg_3_0:onClose()
			end, true)
		end
	end
end

return var_0_1
