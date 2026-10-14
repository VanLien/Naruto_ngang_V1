local var_0_0 = class("GymMasterInfoView", Dialog)

var_0_0.RESOURCE_FILENAME = "gym_master_info.json"
var_0_0.RESOURCE_BINDING = {
	imgBG = "bg",
	["top.textFightPoint"] = "textFightPoint",
	["top.textNoteServer"] = "textNoteServer",
	["top.textServer"] = "textServer",
	["top.imgVipInfo"] = "imgVipInfo",
	["top.textUnionNote"] = "textUnionNote",
	["top.textName"] = "textName",
	["top.textUnion"] = "textUnion",
	["imgBG.down.list"] = {
		varname = "battleArrayList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 65,
				data = bindHelper.self("battleData"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1, {
						class = "card_icon",
						props = {
							unitId = arg_1_3.unitId,
							advance = arg_1_3.advance,
							rarity = arg_1_3.rarity,
							star = arg_1_3.star,
							levelProps = {
								data = arg_1_3.level
							},
							onNode = function(arg_2_0)
								arg_2_0:scale(1.2)
								arg_2_0:xy(-10, -30)
							end
						}
					})
				end
			}
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
	["top.head"] = {
		varname = "headImg",
		binds = {
			event = "extend",
			class = "role_logo",
			props = {
				vip = false,
				level = false,
				logoId = bindHelper.self("logoId"),
				frameId = bindHelper.self("frameId"),
				onNode = function(arg_3_0)
					arg_3_0:scale(1.1)
				end
			}
		}
	},
	["top.textLevel1"] = {
		varname = "textLevel1"
	},
	["top.textLevel2"] = {
		varname = "textLevel2",
		binds = {
			{
				event = "text",
				idler = bindHelper.self("levelId")
			}
		}
	},
	["top.btnTake"] = {
		varname = "btnChat",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPrivateChat")
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
	["top.btnChallenge.textNote"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["top.btnChallenge"] = {
		varname = "btnChallenge",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChallenge")
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
	}
}

function var_0_0.onCreate(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_0.masterData = arg_4_1
	arg_4_0.friendMessage = gGameModel.messages:getIdler("private")

	arg_4_0.textName:text(arg_4_1.role_name)

	arg_4_0.logoId = idler.new(arg_4_1.role_logo)
	arg_4_0.frameId = idler.new(arg_4_1.role_frame)
	arg_4_0.levelId = idler.new(arg_4_1.role_level)

	if arg_4_1.role_vip == 0 then
		arg_4_0.imgVipInfo:hide()
	else
		arg_4_0.imgVipInfo:texture("common/icon/vip/icon_vip" .. arg_4_1.role_vip .. ".png")
	end

	arg_4_0.isCross = arg_4_3
	arg_4_0.unlocked = arg_4_4
	arg_4_0.id = arg_4_2
	arg_4_0.pos = arg_4_5

	if arg_4_3 == true then
		arg_4_0.textUnionNote:hide()
		arg_4_0.textUnion:hide()
		arg_4_0.textNoteServer:show()
		arg_4_0.textServer:text(getServerArea(arg_4_1.game_key, true))
		arg_4_0.textServer:show()
		arg_4_0.btnChat:hide()
		arg_4_0.btnChallenge:y(arg_4_0.btnChat:y())
	else
		arg_4_0.textUnionNote:show()
		arg_4_0.textUnion:text(arg_4_1.union_name)
		arg_4_0.textUnion:show()
		arg_4_0.textNoteServer:hide()
		arg_4_0.textServer:hide()
	end

	local var_4_0 = gGameModel.role:read("gym_record_db_id")
	local var_4_1 = arg_4_0.masterData.id

	if arg_4_0.masterData.id == gGameModel.role:read("gym_record_db_id") then
		arg_4_0.btnChallenge:hide()
		arg_4_0.btnChat:hide()
	end

	if not arg_4_4 then
		uiEasy.setBtnShader(arg_4_0.btnChallenge, arg_4_0.btnChallenge:get("textNote"), 2)
	end

	if arg_4_4 then
		text.addEffect(arg_4_0.btnChallenge:get("textNote"), {
			outline = {
				size = 4,
				color = ui.NEWCOLORS.OUTLINE.YELLOW
			}
		})
	else
		text.deleteAllEffect(arg_4_0.btnChallenge:get("textNote"))
	end

	adapt.oneLinePos(arg_4_0.textLevel1, arg_4_0.textLevel2, cc.p(-5, 0))
	adapt.oneLinePos(arg_4_0.textName, arg_4_0.imgVipInfo, cc.p(10, 0))
	arg_4_0:initSprites(arg_4_1)
	Dialog.onCreate(arg_4_0)
end

function var_0_0.initSprites(arg_5_0, arg_5_1)
	arg_5_0.item = ccui.Layout:create():size(180, 180):show():setTouchEnabled(false):retain():scale(0.8)

	local var_5_0 = {}
	local var_5_1 = 0
	local var_5_2 = {}

	if arg_5_0.isCross then
		var_5_2 = arg_5_1.cross_card_attrs
	else
		var_5_2 = arg_5_1.card_attrs
	end

	for iter_5_0, iter_5_1 in pairs(var_5_2) do
		local var_5_3 = csv.cards[iter_5_1.card_id == 0 and 11 or iter_5_1.card_id]
		local var_5_4 = csv.unit[var_5_3.unitID]
		local var_5_5 = dataEasy.getUnitId(iter_5_1.card_id, iter_5_1.skin_id)

		table.insert(var_5_0, {
			cardId = iter_5_1.card_id == 0 and 11 or iter_5_1.card_id,
			advance = iter_5_1.advance,
			unitId = var_5_5,
			star = iter_5_1.star,
			level = iter_5_1.level,
			rarity = var_5_4.rarity,
			id = iter_5_1.id
		})

		var_5_1 = var_5_1 + iter_5_1.fighting_point
	end

	if #var_5_0 < 6 then
		for iter_5_2 = #var_5_0 + 1, 6 do
			table.insert(var_5_0, {
				unitId = -1
			})
		end
	end

	arg_5_0.battleData = idlertable.new(var_5_0)

	arg_5_0.textFightPoint:text(var_5_1)
end

function var_0_0.onPrivateChat(arg_6_0)
	local var_6_0 = {
		isMine = false,
		role = {
			level = arg_6_0.masterData.role_level,
			id = arg_6_0.masterData.role_id,
			logo = arg_6_0.masterData.role_logo,
			name = arg_6_0.masterData.role_name,
			vip = arg_6_0.masterData.role_vip,
			frame = arg_6_0.masterData.role_frame
		}
	}

	gGameUI:stackUI("city.chat.privataly", nil, nil, var_6_0)
end

function var_0_0.onChallenge(arg_7_0)
	if arg_7_0:getChallengeState() == false then
		gGameUI:showTip(gLanguageCsv.gymTimeOut)

		return
	end

	if arg_7_0.isCross then
		if gGameModel.role:read("gym_datas").cross_gym_pw_last_time + gCommonConfigCsv.gymPwCD > time.getTime() then
			gGameUI:showTip(gLanguageCsv.gymInCd)

			return
		end
	elseif gGameModel.role:read("gym_datas").gym_pw_last_time + gCommonConfigCsv.gymPwCD > time.getTime() then
		gGameUI:showTip(gLanguageCsv.gymInCd)

		return
	end

	if not arg_7_0.unlocked then
		if arg_7_0.isCross then
			gGameUI:showTip(gLanguageCsv.gymCrossTips1)
		else
			gGameUI:showTip(gLanguageCsv.gymTips1)
		end

		return
	end

	local var_7_0 = csv.gym.gym[arg_7_0.id].limitAttribute

	if #dataEasy.getNatureSprite(var_7_0) == 0 then
		gGameUI:showTip(gLanguageCsv.gymNoSptire1)

		return
	end

	local var_7_1 = arg_7_0.id
	local var_7_2 = arg_7_0.pos
	local var_7_3 = arg_7_0.masterData
	local var_7_4 = arg_7_0.isCross

	local function var_7_5(arg_8_0, arg_8_1)
		if time.getNumTimestamp(gGameModel.gym:read("date"), 21, 45) + 518400 <= time.getTime() then
			gGameUI:showTip(gLanguageCsv.gymTimeOut)

			return
		end

		local var_8_0 = arg_8_1:read()

		if not var_7_4 then
			battleEntrance.battleRequest("/game/gym/leader/battle/start", var_8_0, var_7_1, var_7_3.id):onStartOK(function(arg_9_0)
				arg_8_0:onClose(false)
			end):run():show()
		else
			battleEntrance.battleRequest("/game/cross/gym/battle/start", var_8_0, var_7_1, var_7_2, var_7_3.game_key, var_7_3.id):onStartOK(function(arg_10_0)
				arg_8_0:onClose(false)
			end):run():show()
		end
	end

	gGameUI:stackUI("city.adventure.gym_challenge.embattle1", nil, {
		full = true
	}, {
		fightCb = var_7_5,
		limitInfo = csv.gym.gym[arg_7_0.id].limitAttribute,
		from = game.EMBATTLE_FROM_TABLE.onekey
	})
	arg_7_0:onClose()
end

function var_0_0.getChallengeState(arg_11_0)
	if gGameModel.gym:read("round") == "closed" then
		return false
	end

	return time.getNumTimestamp(gGameModel.gym:read("date"), 21, 45) + 518400 > time.getTime()
end

return var_0_0
