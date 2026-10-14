local function var_0_0(arg_1_0)
	if arg_1_0 then
		return "city/union/gate/box_jdt.png"
	end

	return "city/union/gate/box_jdd.png"
end

local function var_0_1(arg_2_0, arg_2_1)
	if arg_2_1 then
		text.addEffect(arg_2_0, {
			color = ui.COLORS.NORMAL.LIGHT_GREEN
		})
	else
		text.addEffect(arg_2_0, {
			color = ui.COLORS.NORMAL.ALERT_ORANGE
		})
	end
end

local var_0_2 = {
	gLanguageCsv.chairman,
	gLanguageCsv.viceChairman,
	gLanguageCsv.member
}

local function var_0_3(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_0 == arg_3_1 then
		return 1
	end

	for iter_3_0, iter_3_1 in ipairs(arg_3_2) do
		if arg_3_0 == iter_3_1 then
			return 2
		end
	end

	return 3
end

local var_0_4 = class("UnionGateProgressView", Dialog)

var_0_4.RESOURCE_FILENAME = "union_gate_progress.json"
var_0_4.RESOURCE_BINDING = {
	item = "item",
	maskPanel = "maskPanel",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	title1 = {
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
	title2 = {
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
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("members"),
				item = bindHelper.self("item"),
				chairmanId = bindHelper.self("chairmanId"),
				viceChairmans = bindHelper.self("viceChairmans"),
				dataOrderCmpGen = bindHelper.self("onSortRank", true),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_0.chairmanId:read()
					local var_4_1 = arg_4_0.viceChairmans:read()
					local var_4_2 = arg_4_1:multiget("logo", "roleName", "level", "job", "progressTxt", "progress1", "progress2", "progress3")

					bind.extend(arg_4_0, var_4_2.logo, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_4_3.logo,
							frameId = arg_4_3.frame
						}
					})
					var_4_2.roleName:text(arg_4_3.name)
					var_4_2.level:text(arg_4_3.level)
					var_4_2.job:text(var_0_2[var_0_3(arg_4_3.id, var_4_0, var_4_1)])
					var_4_2.progressTxt:text(arg_4_3.fuben_times .. "/3")
					var_0_1(var_4_2.progressTxt, arg_4_3.fuben_times >= 3)
					var_4_2.progress1:texture(var_0_0(arg_4_3.fuben_times >= 1))
					var_4_2.progress2:texture(var_0_0(arg_4_3.fuben_times >= 2))
					var_4_2.progress3:texture(var_0_0(arg_4_3.fuben_times >= 3))
				end,
				onAfterBuild = function(arg_5_0)
					arg_5_0.afterBuild()
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	}
}

function var_0_4.onCreate(arg_6_0)
	arg_6_0:initModel()
	Dialog.onCreate(arg_6_0)
end

function var_0_4.initModel(arg_7_0)
	local var_7_0 = gGameModel.union

	arg_7_0.members = var_7_0:getIdler("members")
	arg_7_0.chairmanId = var_7_0:getIdler("chairman_db_id")
	arg_7_0.viceChairmans = var_7_0:getIdler("vice_chairmans")
end

function var_0_4.onSortRank(arg_8_0, arg_8_1)
	return function(arg_9_0, arg_9_1)
		return arg_9_0.fuben_times > arg_9_1.fuben_times
	end
end

function var_0_4.onAfterBuild(arg_10_0)
	uiEasy.setBottomMask(arg_10_0.list, arg_10_0.maskPanel)
end

return var_0_4
