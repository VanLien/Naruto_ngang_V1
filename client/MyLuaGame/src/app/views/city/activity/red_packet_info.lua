local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	bind.extend(arg_1_0, arg_1_1.iconBg, {
		event = "extend",
		class = "role_logo",
		props = {
			vip = false,
			level = false,
			logoId = arg_1_3.logo,
			frameId = arg_1_3.frame,
			onNode = function(arg_2_0)
				arg_2_0:scale(0.8)
			end
		}
	})
end

local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("RedPacketInfoView", Dialog)

var_0_2.RESOURCE_FILENAME = "activity_get_particulars.json"
var_0_2.RESOURCE_BINDING = {
	name = "name",
	item = "item",
	anima = "anima",
	oneself = "oneself",
	benediction = "benediction",
	name1 = "name1",
	close = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["item.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = ui.COLORS.NORMAL.DULL_YELLOW
				}
			}
		}
	},
	["item.rmb"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = ui.COLORS.NORMAL.DULL_YELLOW
				}
			}
		}
	},
	list = {
		varname = "listview",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("bg", "name", "society", "gh", "luck", "rmb", "icon", "iconBg", "name1")

					var_0_0(arg_3_0, var_3_0, arg_3_2, arg_3_3)
					var_3_0.name:text(arg_3_3.name)

					if arg_3_3.game_key then
						var_3_0.name1:text(string.format(gLanguageCsv.brackets, getServerArea(arg_3_3.game_key, true)))
					else
						var_3_0.name1:hide()
					end

					adapt.oneLinePos(var_3_0.name, var_3_0.name1, cc.p(6, 0))

					if arg_3_3.union and string.len(arg_3_3.union) == 0 then
						arg_3_3.union = gLanguageCsv.nonunion
					end

					var_3_0.gh:text(arg_3_3.union)
					var_3_0.luck:visible(arg_3_3.lickId == arg_3_3.id)
					var_3_0.rmb:text(arg_3_3.val)
					bind.touch(arg_3_0, arg_3_1, {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_2, arg_3_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBtnClick")
			}
		}
	}
}

function var_0_2.onCreate(arg_4_0, arg_4_1, arg_4_2)
	if not arg_4_1 then
		return
	end

	arg_4_0.cb = arg_4_2
	arg_4_0.tabDatas = idlers.newWithMap({})

	local var_4_0 = {}
	local var_4_1 = clone(arg_4_1.members)

	arg_4_0.tabDatas:update(var_4_1)
	arg_4_0.name:text(arg_4_1.role_name)

	if arg_4_1.game_key then
		arg_4_0.name1:text(string.format(gLanguageCsv.brackets, getServerArea(arg_4_1.game_key, true)))
	else
		arg_4_0.name1:hide()
	end

	adapt.oneLinePos(arg_4_0.name, arg_4_0.name1, cc.p(6, 0))
	arg_4_0.benediction:text(arg_4_1.message)

	local var_4_2 = {
		logo = arg_4_1.role_logo,
		frame = arg_4_1.role_frame
	}
	local var_4_3 = arg_4_0.oneself:multiget("iconBg")

	var_0_0(arg_4_0, var_4_3, nil, var_4_2)
	Dialog.onCreate(arg_4_0)
end

function var_0_2.onClose(arg_5_0)
	arg_5_0:addCallbackOnExit(arg_5_0.cb)
	var_0_1.onClose(arg_5_0)
end

return var_0_2
