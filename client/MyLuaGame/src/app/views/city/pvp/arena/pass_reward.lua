local var_0_0 = class("ArenaPassRewardView", Dialog)

var_0_0.RESOURCE_FILENAME = "arena_pass_reward.json"
var_0_0.RESOURCE_BINDING = {
	item = "item",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnOK = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["btnOK.textNote"] = {
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
	["title.textTitle1"] = {
		varname = "textTitle1",
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
	["title.textTitle2"] = {
		varname = "textTitle2",
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
	role1 = {
		varname = "role1",
		binds = {
			event = "extend",
			class = "role_logo",
			props = {
				vip = false,
				level = false,
				logoId = bindHelper.self("logoId"),
				frameId = bindHelper.self("frameId"),
				onNode = function(arg_1_0)
					arg_1_0:y(arg_1_0:y() + 30)
				end
			}
		}
	},
	role2 = {
		varname = "role2",
		binds = {
			event = "extend",
			class = "role_logo",
			props = {
				vip = false,
				level = false,
				logoId = bindHelper.self("enemyRoleLogo"),
				frameId = bindHelper.self("enemyFrameId"),
				onNode = function(arg_2_0)
					arg_2_0:y(arg_2_0:y() + 30)
				end
			}
		}
	},
	list = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("datas"),
				item = bindHelper.self("item"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("title", "reward")

					var_3_0.title:text(string.format(gLanguageCsv.battleTimes, arg_3_2))

					local var_3_1, var_3_2 = next(arg_3_3)

					bind.extend(arg_3_0, var_3_0.reward, {
						class = "icon_key",
						props = {
							data = {
								key = var_3_1,
								num = var_3_2
							}
						}
					})
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.logoId = gGameModel.role:getIdler("logo")
	arg_4_0.frameId = gGameModel.role:getIdler("frame")
	arg_4_0.datas = arg_4_2
	arg_4_0.enemyRoleLogo = arg_4_1.logo
	arg_4_0.enemyFrameId = arg_4_1.frame

	local var_4_0 = gGameModel.role:read("level")
	local var_4_1 = gGameModel.role:read("name")

	arg_4_0:setRoleInfo(arg_4_0.role1, var_4_1, var_4_0)
	arg_4_0:setRoleInfo(arg_4_0.role2, arg_4_1.name, arg_4_1.level)
	Dialog.onCreate(arg_4_0)
end

function var_0_0.setRoleInfo(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_1:get("level"):text("Lv" .. arg_5_3)
	arg_5_1:get("name"):text(arg_5_2)
	text.addEffect(arg_5_1:get("level"), {
		outline = {
			size = 3,
			color = ui.COLORS.OUTLINE.WHITE
		}
	})
	text.addEffect(arg_5_1:get("name"), {
		outline = {
			size = 3,
			color = ui.COLORS.OUTLINE.WHITE
		}
	})
end

return var_0_0
