local var_0_0 = {
	UNSHOW = 0,
	SHOW_SENIRO = 2,
	SHOW_REUNION = 1
}
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("CloneBattleInviteView", Dialog)

var_0_2.RESOURCE_FILENAME = "clone_battle_friend_invite.json"
var_0_2.RESOURCE_BINDING = {
	empty = "empty",
	item = "item",
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
				data = bindHelper.self("roles"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("icon", "name", "text1", "text2", "lv", "lvNumber", "btn", "reunionPanel")

					bind.extend(arg_1_0, var_1_0.icon, {
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_1_3.logo,
							frameId = arg_1_3.frame
						}
					})
					var_1_0.name:text(arg_1_3.name)
					var_1_0.text2:text(arg_1_3.battle_fighting_point)
					var_1_0.lvNumber:text(arg_1_3.level)
					adapt.oneLinePos(var_1_0.name, {
						var_1_0.lv,
						var_1_0.lvNumber
					}, cc.p(15, 0), "left")
					adapt.oneLinePos(var_1_0.text1, var_1_0.text2, cc.p(15, 0), "left")
					var_1_0.btn:tag(arg_1_2)
					bind.click(arg_1_0, var_1_0.btn, {
						method = functools.partial(arg_1_0.clickCell, var_1_0.btn, arg_1_2, arg_1_3)
					})
					text.addEffect(var_1_0.btn:get("text"), {
						outline = {
							color = ui.NEWCOLORS.OUTLINE.YELLOW
						}
					})
					var_1_0.reunionPanel:visible(arg_1_3.reunionType and arg_1_3.reunionType ~= var_0_0.UNSHOW or false)

					if arg_1_3.reunionType and arg_1_3.reunionType ~= var_0_0.UNSHOW then
						var_1_0.reunionPanel:get("label"):text(gLanguageCsv["reunionType" .. arg_1_3.reunionType])
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	},
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	}
}

function var_0_2.getReunionType(arg_2_0, arg_2_1)
	local var_2_0 = var_0_0.UNSHOW

	if arg_2_0.reunion and arg_2_0.reunion.role_type == 1 and arg_2_0.reunion.info and arg_2_0.reunion.info.end_time - time.getTime() > 0 and arg_2_0.reunionBindRoleId and arg_2_0.reunionBindRoleId == arg_2_1 then
		var_2_0 = var_0_0.SHOW_SENIRO
	elseif arg_2_0.reunion and arg_2_0.reunion.role_type == 2 and arg_2_0.reunion.info and arg_2_0.reunion.info.end_time - time.getTime() > 0 and arg_2_0.reunion.info.role_id == arg_2_1 then
		var_2_0 = var_0_0.SHOW_REUNION
	end

	return var_2_0
end

function var_0_2.onCreate(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.reunion = gGameModel.role:read("reunion")
	arg_3_0.reunionBindRoleId = gGameModel.reunion_record:read("bind_role_db_id")
	arg_3_0.roles = idlers.newWithMap({})

	local var_3_0 = arg_3_1.roles or {}

	for iter_3_0, iter_3_1 in ipairs(var_3_0) do
		var_3_0[iter_3_0].reunionType = arg_3_0:getReunionType(iter_3_1.id)
	end

	arg_3_0.roles:update(var_3_0)

	arg_3_0.func = arg_3_2

	if arg_3_1.size == 0 then
		arg_3_0.empty:show()
		arg_3_0.list:hide()
	end

	Dialog.onCreate(arg_3_0, {
		clickClose = true
	})
end

function var_0_2.onItemClick(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	arg_4_0.func(arg_4_4, arg_4_0, arg_4_2)
end

return var_0_2
