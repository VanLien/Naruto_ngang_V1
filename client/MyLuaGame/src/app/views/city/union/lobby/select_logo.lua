local var_0_0 = class("UnionSelectLogoView", Dialog)

var_0_0.RESOURCE_FILENAME = "union_select_logo.json"
var_0_0.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
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
	btnSure = {
		varname = "btnSure",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClickSure")
			}
		}
	},
	["btnSure.txt"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	btnCancel = {
		varname = "btnCancel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["btnCancel.txt"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 16,
				columnSize = 6,
				data = bindHelper.self("logoDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("locked"):visible(arg_1_3.unlocked == 2)
					arg_1_1:get("used"):visible(arg_1_3.inUse)
					arg_1_1:get("selected"):visible(arg_1_3.selectEffect or false)
					arg_1_1:get("icon"):texture(arg_1_3.icon)
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.itemClick, arg_1_0:getIdx(arg_1_2), arg_1_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onFrameItemClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1)
	arg_2_0.cb = arg_2_1.cb
	arg_2_0.logoDatas = idlers.new()

	local var_2_0 = {}

	for iter_2_0, iter_2_1 in csvPairs(csv.union.union_logo) do
		local var_2_1 = arg_2_1.id == iter_2_0
		local var_2_2 = 1

		table.insert(var_2_0, {
			id = iter_2_0,
			icon = iter_2_1.icon,
			inUse = var_2_1,
			unlocked = var_2_2
		})
	end

	table.sort(var_2_0, function(arg_3_0, arg_3_1)
		if arg_3_0.unlocked ~= arg_3_1.unlocked then
			return arg_3_0.unlocked < arg_3_1.unlocked
		end

		return arg_3_0.id < arg_3_1.id
	end)
	arg_2_0.logoDatas:update(var_2_0)

	arg_2_0.selectFrame = idler.new(arg_2_1.id)

	arg_2_0.selectFrame:addListener(function(arg_4_0, arg_4_1)
		local var_4_0 = arg_2_0.logoDatas:atproxy(arg_4_0)
		local var_4_1 = arg_2_0.logoDatas:atproxy(arg_4_1)

		if var_4_1 then
			var_4_1.selectEffect = false
		end

		var_4_0.selectEffect = true
	end)
	Dialog.onCreate(arg_2_0)
end

function var_0_0.onFrameItemClick(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_0.selectFrame:set(arg_5_2.k)
end

function var_0_0.onClickSure(arg_6_0)
	if arg_6_0.cb then
		local var_6_0 = arg_6_0.selectFrame:read()

		arg_6_0:addCallbackOnExit(functools.partial(arg_6_0.cb, var_6_0))
		arg_6_0:onClose()
	else
		gGameApp:requestServer("/game/union/logo/modify", function(arg_7_0)
			arg_6_0:onClose()
		end, arg_6_0.selectFrame)
	end
end

return var_0_0
