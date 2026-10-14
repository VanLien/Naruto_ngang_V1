local var_0_0 = {
	REFUSEJOIN = 2,
	APPROVEJOIN = 0,
	DIRECTJOIN = 1
}
local var_0_1 = {
	[0] = gLanguageCsv.needApply,
	gLanguageCsv.directJoin,
	gLanguageCsv.refuseJoin
}
local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("UnionDetailView", Dialog)

var_0_3.RESOURCE_FILENAME = "union_info.json"
var_0_3.RESOURCE_BINDING = {
	["head.imgIcon"] = "headIcon",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["title.textNote1"] = {
		varname = "textNote1",
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
	["title.textNote2"] = {
		varname = "textNote2",
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
	btnCancle = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["btnCancle.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	btnRequest = {
		varname = "btnRequest",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRequestJoin")
			}
		}
	},
	["btnRequest.textNote"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			},
			{
				event = "text",
				idler = bindHelper.self("showNote")
			}
		}
	},
	textUnionName = {
		binds = {
			event = "text",
			idler = bindHelper.self("unionName")
		}
	},
	textUnionID = {
		binds = {
			event = "text",
			idler = bindHelper.self("unionID")
		}
	},
	textUnionBoss = {
		binds = {
			event = "text",
			idler = bindHelper.self("unionBoss")
		}
	},
	textUnionPeople = {
		binds = {
			event = "text",
			idler = bindHelper.self("unionPeople")
		}
	},
	textUnionNote = {
		binds = {
			event = "text",
			idler = bindHelper.self("unionNote")
		}
	},
	textState1 = {
		varname = "textState1",
		binds = {
			event = "text",
			idler = bindHelper.self("state1")
		}
	}
}

function var_0_3.onCreate(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0.unionInfo = arg_1_2
	arg_1_0.handler = arg_1_3
	arg_1_0.idx = arg_1_1
	arg_1_0.cb = arg_1_4

	arg_1_0:initModel()

	local var_1_0 = gLanguageCsv.approve

	if arg_1_2.join_type == var_0_0.DIRECTJOIN then
		var_1_0 = gLanguageCsv.joinIn
	elseif arg_1_2.isApprove then
		var_1_0 = gLanguageCsv.approveCancle
	end

	arg_1_0.showNote = idler.new(var_1_0)
	arg_1_0.unionID = idler.new(arg_1_2.uid)
	arg_1_0.unionName = idler.new(arg_1_2.name)
	arg_1_0.unionBoss = idler.new(arg_1_2.chairman_name)
	arg_1_0.unionPeople = idler.new(string.format("%d/%d", arg_1_2.members, arg_1_2.member_max))

	local var_1_1 = string.len(arg_1_2.join_desc) > 0 and arg_1_2.join_desc or gLanguageCsv.unionJoinupDesc

	arg_1_0.unionNote = idler.new(var_1_1)

	local var_1_2 = var_0_1[arg_1_2.join_type]
	local var_1_3 = ui.NEWCOLORS.BROWN1

	if arg_1_2.join_level > 0 then
		var_1_2 = var_1_2 .. string.format(gLanguageCsv.levelLimit, arg_1_2.join_level)

		if arg_1_0.level:read() < arg_1_2.join_level then
			var_1_3 = ui.COLORS.NORMAL.RED
		end
	else
		var_1_2 = var_1_2 .. gLanguageCsv.noLimit
	end

	arg_1_0.state1 = idler.new(var_1_2)

	text.addEffect(arg_1_0.textState1, {
		color = var_1_3
	})
	arg_1_0.headIcon:texture(csv.union.union_logo[arg_1_2.logo].icon)
	uiEasy.setBtnShader(arg_1_0.btnRequest, arg_1_0.btnRequest:get("textNote"), not arg_1_0.myUnionId and 1 or 2)

	if not arg_1_0.myUnionId then
		text.addEffect(arg_1_0.btnRequest:get("textNote"), {
			outline = {
				size = 4,
				color = ui.NEWCOLORS.OUTLINE.YELLOW
			}
		})
	end

	Dialog.onCreate(arg_1_0)
end

function var_0_3.initModel(arg_2_0)
	arg_2_0.level = gGameModel.role:getIdler("level")
	arg_2_0.myUnionId = gGameModel.role:read("union_db_id")
end

function var_0_3.onRequestJoin(arg_3_0)
	local var_3_0 = "/game/union/join"

	if arg_3_0.unionInfo.isApprove then
		var_3_0 = "/game/union/join/cancel"
	end

	gGameApp:requestServer(var_3_0, function(arg_4_0)
		if arg_3_0.handler then
			arg_3_0.handler(arg_3_0.idx)
		end

		if arg_3_0.unionInfo.join_type == var_0_0.DIRECTJOIN then
			gGameApp:requestServer("/game/union/get", function(arg_5_0)
				arg_3_0:addCallbackOnExit(arg_3_0.cb)
				var_0_2.onClose(arg_3_0)
			end)
		else
			local var_4_0 = arg_3_0.unionInfo.isApprove and gLanguageCsv.approveCancle or gLanguageCsv.approve

			arg_3_0.showNote:set(var_4_0)
		end
	end, arg_3_0.unionInfo.id)
end

return var_0_3
