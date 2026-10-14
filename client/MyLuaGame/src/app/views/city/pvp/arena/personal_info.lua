local var_0_0 = class("ArenaPersonalInfoView", Dialog)

var_0_0.RESOURCE_FILENAME = "arena_personal_info.json"
var_0_0.RESOURCE_BINDING = {
	item = "item",
	["top.imgVipInfo"] = "imgVipInfo",
	["top.textName"] = {
		varname = "textName",
		binds = {
			event = "text",
			idler = bindHelper.self("roleName")
		}
	},
	["title.textTitle1"] = {
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
	["top.textRank"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("rank")
		}
	},
	["top.textFightPoint"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("fightPoint")
		}
	},
	["top.textUnion"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("union")
		}
	},
	["top.textLv"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("level")
		}
	},
	["top.head"] = {
		binds = {
			event = "extend",
			class = "role_logo",
			props = {
				vip = false,
				level = false,
				logoId = bindHelper.self("logoId"),
				frameId = bindHelper.self("frameId"),
				onNode = function(arg_1_0)
					arg_1_0:scale(1.1)
				end
			}
		}
	},
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["top.btnTake"] = {
		varname = "btnTake",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onEnterChat")
			}
		}
	},
	["top.btnTake.textNote"] = {
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
	["top.btnAddFriend"] = {
		varname = "btnAddFriend",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddFriend")
			}
		}
	},
	["top.btnAddFriend.textNote"] = {
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
	["down.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("team"),
				item = bindHelper.self("item"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					if not arg_2_3.isInfo then
						return
					end

					arg_2_1:get("emptyPanel"):hide()

					local var_2_0 = dataEasy.getUnitId(arg_2_3.card_id, arg_2_3.skin_id)

					bind.extend(arg_2_0, arg_2_1, {
						class = "card_icon",
						props = {
							unitId = var_2_0,
							advance = arg_2_3.advance,
							rarity = arg_2_3.rarity,
							star = arg_2_3.star,
							levelProps = {
								data = arg_2_3.level
							},
							onNode = function(arg_3_0)
								arg_3_0:xy(0, -6)
							end
						}
					})
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_4_0, arg_4_1)
	arg_4_0:initModel()

	arg_4_0.roleId = arg_4_1.role_db_id
	arg_4_0.level = idler.new(arg_4_1.role_level)
	arg_4_0.roleName = idler.new(arg_4_1.role_name)
	arg_4_0.vip = idler.new(arg_4_1.role_vip)
	arg_4_0.rank = idler.new(arg_4_1.rank)
	arg_4_0.fightPoint = idler.new(arg_4_1.fighting_point)

	local var_4_0 = string.len(arg_4_1.union_name) > 0 and arg_4_1.union_name or gLanguageCsv.noUnion

	arg_4_0.union = idler.new(var_4_0)
	arg_4_0.logoId = idler.new(arg_4_1.role_logo)
	arg_4_0.frameId = idler.new(arg_4_1.role_frame)
	arg_4_0.personalInfo = arg_4_1
	arg_4_0.team = idlers.newWithMap({})

	local var_4_1 = {}
	local var_4_2 = csv.cards
	local var_4_3 = csv.unit

	for iter_4_0, iter_4_1 in pairs(arg_4_1.defence_cards) do
		local var_4_4 = arg_4_1.defence_card_attrs[iter_4_1]

		if var_4_2[var_4_4.card_id] then
			var_4_4.rarity = var_4_3[var_4_2[var_4_4.card_id].unitID].rarity
			var_4_4.isInfo = true

			table.insert(var_4_1, var_4_4)
		end
	end

	if #var_4_1 < 6 then
		for iter_4_2 = #var_4_1 + 1, 6 do
			table.insert(var_4_1, {
				isInfo = false
			})
		end
	end

	arg_4_0.team:update(var_4_1)

	local var_4_5 = arg_4_0.vip:read()

	arg_4_0.imgVipInfo:visible(var_4_5 > 0)

	if var_4_5 > 0 then
		arg_4_0.imgVipInfo:texture(string.format("common/icon/vip/icon_vip%d.png", var_4_5))
	end

	arg_4_0.btnTake:setVisible(not arg_4_1.robot)
	arg_4_0.btnAddFriend:setVisible(not arg_4_1.robot)
	arg_4_0.textName:text(arg_4_0.roleName:read())
	adapt.oneLinePos(arg_4_0.textName, arg_4_0.imgVipInfo, cc.p(10, 0))
	Dialog.onCreate(arg_4_0)
end

function var_0_0.initModel(arg_5_0)
	arg_5_0.friendMessage = gGameModel.messages:getIdler("private")
end

function var_0_0.onEnterChat(arg_6_0)
	local var_6_0 = {
		isMine = false,
		role = {
			level = arg_6_0.personalInfo.role_level,
			id = arg_6_0.personalInfo.role_db_id,
			logo = arg_6_0.personalInfo.role_logo,
			name = arg_6_0.personalInfo.role_name,
			vip = arg_6_0.vip:read(),
			frame = arg_6_0.personalInfo.role_frame
		}
	}

	gGameUI:stackUI("city.chat.privataly", nil, nil, var_6_0)
end

function var_0_0.onAddFriend(arg_7_0)
	if userDefault.getCurrDayKey("friendsAddState", {})[arg_7_0.roleId] then
		gGameUI:showTip(gLanguageCsv.friendAlready)

		return
	end

	gGameApp:requestServer("/game/society/friend/askfor", function(arg_8_0)
		userDefault.setCurrDayKey("friendsAddState", alreadyFriend)
		gGameUI:showTip(gLanguageCsv.addFriendWait)
	end, {
		arg_7_0.roleId
	})
end

return var_0_0
