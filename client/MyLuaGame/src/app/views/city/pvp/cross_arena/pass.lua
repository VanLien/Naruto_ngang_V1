local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CrossArenaPass", Dialog)

var_0_1.RESOURCE_FILENAME = "cross_arena_pass.json"
var_0_1.RESOURCE_BINDING = {
	title = "titleLabel",
	role1 = "head1",
	textName1 = "textName1",
	textName2 = "textName2",
	role2 = "head2",
	textLv1 = {
		varname = "textLv1"
	},
	textLv2 = {
		varname = "textLv2"
	},
	textNote1 = {
		varname = "textNote1"
	},
	textNote2 = {
		varname = "textNote2"
	},
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnOk = {
		varname = "btnOk",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["btnOk.title"] = {
		varname = "btnText",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1, arg_1_2)
	bind.extend(arg_1_0, arg_1_0.head1, {
		event = "extend",
		class = "role_logo",
		props = {
			vip = false,
			level = false,
			logoId = arg_1_1.logo,
			frameId = arg_1_1.frame
		}
	})
	bind.extend(arg_1_0, arg_1_0.head2, {
		event = "extend",
		class = "role_logo",
		props = {
			vip = false,
			level = false,
			logoId = arg_1_2.logo,
			frameId = arg_1_2.frame
		}
	})
	arg_1_0.textLv1:text(arg_1_1.level)
	arg_1_0.textLv2:text(arg_1_2.level)
	arg_1_0.textName1:text(arg_1_1.name)
	arg_1_0.textName2:text(arg_1_2.name)
	adapt.oneLineCenterPos(cc.p(arg_1_0.textName1:x(), 648), {
		arg_1_0.textNote1,
		arg_1_0.textLv1
	}, cc.p(5, 0))
	adapt.oneLineCenterPos(cc.p(arg_1_0.textName2:x(), 648), {
		arg_1_0.textNote2,
		arg_1_0.textLv2
	}, cc.p(5, 0))
	Dialog.onCreate(arg_1_0)
end

function var_0_1.onClose(arg_2_0)
	Dialog.onClose(arg_2_0)
end

return var_0_1
