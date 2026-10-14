local var_0_0 = {
	"city/adventure/exp/icon_jd.png",
	"city/adventure/exp/icon_kn.png",
	"city/adventure/exp/icon_jj.png",
	"city/adventure/exp/icon_ds.png",
	"city/adventure/exp/icon_ly.png",
	"city/adventure/exp/icon_sy.png"
}
local var_0_1 = {
	OVER = 1,
	LOCK = 3,
	UNLOCK = 2
}
local var_0_2 = class("GymGate", cc.load("mvc").ViewBase)

var_0_2.RESOURCE_FILENAME = "gym_gate.json"
var_0_2.RESOURCE_BINDING = {
	panelRightDown = "rightDownPanel",
	["panelRightDown.attrItem"] = "attrItem",
	["panelLeft.imgBgCircle"] = "imgBgCircle",
	["panelLeft.imgBg"] = "leftBg",
	item = "item",
	panelLeft = "panelLeft",
	imgFileter = "imgFileter",
	["panelLeft.imgOwner"] = "imgOwner",
	["panelLeft.textNameNPC"] = {
		varname = "textNameNPC",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["panelLeft.textFight"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["panelLeft.textName"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["panelLeft.textFightNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["panelLeft.textLv"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["panelLeft.btnChallenge"] = {
		varname = "btnOwerChallenge",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnOwnerChallenge")
			}
		}
	},
	["panelLeft.figure"] = {
		varname = "figure",
		binds = {
			event = "extend",
			class = "role_figure",
			props = {
				spine = true,
				data = bindHelper.self("ownerFigure"),
				onNode = function(arg_1_0)
					return
				end,
				onSpine = function(arg_2_0)
					arg_2_0:scale(1):y(120)
				end
			}
		}
	},
	["panelLeft.textTime"] = {
		varname = "textTime",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["panelRightDown.btnBuf.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["panelRightDown.btnBuf"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onBtnBuf")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "gymBuff",
					listenData = {
						gymDatas = bindHelper.self("gymDatas"),
						round = bindHelper.self("round")
					},
					onNode = function(arg_3_0)
						arg_3_0:xy(90, 90):scale(0.5)
					end
				}
			}
		}
	},
	["panelRightDown.btnAward.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["panelRightDown.btnAward"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onBtnAward")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "gymAward",
					listenData = {
						gymDatas = bindHelper.self("gymDatas"),
						id = bindHelper.self("id")
					},
					onNode = function(arg_4_0)
						arg_4_0:xy(120, 120)
					end
				}
			}
		}
	},
	listview = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("gates"),
				item = bindHelper.self("item"),
				id = bindHelper.self("id"),
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					arg_5_1:get("imgDiff"):texture(var_0_0[arg_5_3.diff])

					if arg_5_3.state == var_0_1.OVER then
						arg_5_1:get("imgOver"):show()
						arg_5_1:get("btnChallenge"):hide()
						arg_5_1:get("btnChallenge2"):hide()
						arg_5_1:get("btnPass"):hide()
					elseif arg_5_3.state == var_0_1.UNLOCK then
						arg_5_1:get("imgOver"):hide()

						if arg_5_3.canPass then
							arg_5_1:get("btnChallenge"):hide()

							local var_5_0 = arg_5_1:get("btnChallenge2"):show()
							local var_5_1 = arg_5_1:get("btnPass"):show()

							uiEasy.setBtnShader(var_5_0, var_5_0:get("textNote"), 1)
							uiEasy.setBtnShader(var_5_1, var_5_1:get("textNote"), 1)
							text.addEffect(var_5_0:get("textNote"), {
								outline = {
									size = 3,
									color = ui.NEWCOLORS.OUTLINE.YELLOW
								}
							})
							text.addEffect(var_5_1:get("textNote"), {
								outline = {
									size = 3,
									color = ui.NEWCOLORS.OUTLINE.BLUE
								}
							})
						else
							local var_5_2 = arg_5_1:get("btnChallenge"):show()

							uiEasy.setBtnShader(var_5_2, var_5_2:get("textNote"), 1)
							text.addEffect(var_5_2:get("textNote"), {
								outline = {
									size = 3,
									color = ui.NEWCOLORS.OUTLINE.YELLOW
								}
							})
							arg_5_1:get("btnChallenge2"):hide()
							arg_5_1:get("btnPass"):hide()
						end
					else
						arg_5_1:get("btnChallenge2"):hide()
						arg_5_1:get("btnPass"):hide()
						arg_5_1:get("imgOver"):hide()

						local var_5_3 = arg_5_1:get("btnChallenge"):show()

						uiEasy.setBtnShader(var_5_3, var_5_3:get("textNote"), 2)
					end

					bind.touch(arg_5_0, arg_5_1, {
						methods = {
							ended = functools.partial(arg_5_0.clickCell, arg_5_2, arg_5_3)
						}
					})
					bind.touch(arg_5_0, arg_5_1:get("btnChallenge"), {
						methods = {
							ended = functools.partial(arg_5_0.clickCell, arg_5_2, arg_5_3)
						}
					})
					bind.touch(arg_5_0, arg_5_1:get("btnChallenge2"), {
						methods = {
							ended = functools.partial(arg_5_0.clickCell, arg_5_2, arg_5_3)
						}
					})
					bind.touch(arg_5_0, arg_5_1:get("btnPass"), {
						methods = {
							ended = functools.partial(arg_5_0.clickPass, arg_5_2, arg_5_3)
						}
					})

					local var_5_4 = arg_5_1:get("subList")

					uiEasy.createItemsToList(arg_5_0, var_5_4, arg_5_3.award, {
						margin = 20,
						onNode = function(arg_6_0, arg_6_1)
							if arg_6_1.key ~= "gold" then
								ccui.ImageView:create("city/adventure/endless_tower/icon_gl.png"):anchorPoint(1, 0.5):xy(arg_6_0:width() - 5, arg_6_0:height() - 25):addTo(arg_6_0, 15)
							end
						end
					})
				end,
				preloadCenterIndex = bindHelper.self("curHardIndex")
			},
			handlers = {
				clickCell = bindHelper.self("onGateDetail"),
				clickPass = bindHelper.self("onGatePass")
			}
		}
	},
	["panelRightDown.arrList"] = {
		varname = "arrList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("attrData"),
				item = bindHelper.self("attrItem"),
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					arg_7_1:get("imgIcon"):texture(ui.ATTR_ICON[arg_7_3])
				end
			}
		}
	}
}

function var_0_2.onCreate(arg_8_0, arg_8_1)
	gGameUI.topuiManager:createView("default", arg_8_0, {
		onClose = arg_8_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_daochangtiaozhan.png"
	})

	arg_8_0.id = arg_8_1

	arg_8_0:initModel()
	arg_8_0:initUI()
end

function var_0_2.initModel(arg_9_0)
	arg_9_0.gates = idlers.newWithMap({})
	arg_9_0.gymDatas = gGameModel.role:getIdler("gym_datas")
	arg_9_0.gatesDatas = gGameModel.gym:getIdler("gymGates")
	arg_9_0.round = gGameModel.gym:getIdler("round")
	arg_9_0.inCd = idler.new(false)
	arg_9_0.curHardIndex = 1

	idlereasy.any({
		arg_9_0.gymDatas,
		arg_9_0.gatesDatas,
		arg_9_0.inCd
	}, function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		local var_10_0 = csv.gym.gym[arg_9_0.id]
		local var_10_1 = arg_10_2[arg_9_0.id]
		local var_10_2 = {}

		for iter_10_0, iter_10_1 in orderCsvPairs(var_10_0.hardDegreeID) do
			local var_10_3

			if arg_10_1.gym_fuben[arg_9_0.id] == nil then
				var_10_3 = var_0_1.LOCK
			elseif arg_10_1.gym_fuben[arg_9_0.id] == iter_10_1 then
				var_10_3 = var_0_1.UNLOCK
			elseif iter_10_1 < arg_10_1.gym_fuben[arg_9_0.id] then
				var_10_3 = var_0_1.OVER
			else
				var_10_3 = var_0_1.LOCK
			end

			local var_10_4 = 0

			if dataEasy.isUnlock(gUnlockCsv.gymPass) then
				local var_10_5 = arg_10_1.last_jump
				local var_10_6 = arg_10_1.history_jump
				local var_10_7 = var_10_5[arg_9_0.id] or 0
				local var_10_8 = var_10_6[arg_9_0.id] or 0

				var_10_4 = math.max(var_10_7, var_10_8)
			end

			local var_10_9 = var_10_1[iter_10_1]

			var_10_2[iter_10_0] = {
				diff = iter_10_0,
				state = var_10_3,
				award = csv.scene_conf[var_10_9].dropIds,
				gateId = var_10_9,
				canPass = iter_10_1 <= var_10_4
			}

			local var_10_10 = csvSize(csv.gym.gym[arg_9_0.id].hardDegreeID)
			local var_10_11 = csv.gym.gym[arg_9_0.id].hardDegreeID[var_10_10]

			if arg_10_1.gym_fuben[arg_9_0.id] == iter_10_1 then
				arg_9_0.curHardIndex = iter_10_0 + 1
			end

			text.deleteAllEffect(arg_9_0.btnOwerChallenge:get("textNote"))

			if var_10_11 < arg_10_1.gym_fuben[arg_9_0.id] then
				if arg_10_3 then
					uiEasy.setBtnShader(arg_9_0.btnOwerChallenge, arg_9_0.btnOwerChallenge:get("textNote"), 3)
				else
					uiEasy.setBtnShader(arg_9_0.btnOwerChallenge, arg_9_0.btnOwerChallenge:get("textNote"), 1)
					text.addEffect(arg_9_0.btnOwerChallenge:get("textNote"), {
						outline = {
							size = 4,
							color = ui.NEWCOLORS.OUTLINE.YELLOW
						}
					})
				end

				arg_9_0.ownerUnlock = true
			else
				uiEasy.setBtnShader(arg_9_0.btnOwerChallenge, arg_9_0.btnOwerChallenge:get("textNote"), 3)

				arg_9_0.ownerUnlock = false
			end
		end

		arg_9_0.gates:update(var_10_2)
	end)

	arg_9_0.attrData = idlers.newWithMap(csv.gym.gym[arg_9_0.id].limitAttribute)

	idlereasy.when(arg_9_0.gymDatas, function(arg_11_0, arg_11_1)
		arg_9_0:initCountDown()
	end)
end

function var_0_2.initUI(arg_12_0)
	local var_12_0 = "city/adventure/gym_challenge/gate/"

	arg_12_0.imgFileter:texture(var_12_0 .. "bg_" .. csv.gym.gym[arg_12_0.id].texture):size(display.sizeInView)
	arg_12_0.imgBgCircle:texture(var_12_0 .. "icon_" .. csv.gym.gym[arg_12_0.id].texture)
	arg_12_0.leftBg:texture(var_12_0 .. "lighting_" .. csv.gym.gym[arg_12_0.id].texture)
	arg_12_0.item:get("imgTexture"):texture(var_12_0 .. "logo_" .. csv.gym.gym[arg_12_0.id].texture)
	arg_12_0.imgBgCircle:runAction(cc.RepeatForever:create(cc.RotateBy:create(90, 360)))
	arg_12_0:initOwner()

	arg_12_0.richText = rich.createWithWidth(gLanguageCsv.gymGateDesc, 38, nil, 800, 38):addTo(arg_12_0.rightDownPanel, 6):setAnchorPoint(0, 0.5):xy(5, 100)
end

function var_0_2.initOwner(arg_13_0)
	arg_13_0.gymOwners = gGameModel.gym:getIdler("leaderRoles")
	arg_13_0.ownerFigure = idler.new(1)

	idlereasy.any({
		arg_13_0.gymOwners,
		arg_13_0.round
	}, function(arg_14_0, arg_14_1, arg_14_2)
		local var_14_0

		if arg_14_2 == "start" then
			var_14_0 = arg_14_1 or {}
		else
			var_14_0 = gGameModel.gym:read("lastLeaderRoles") or {}
		end

		local var_14_1 = var_14_0[arg_13_0.id]

		if var_14_0 == nil or var_14_0[arg_13_0.id] == nil then
			local var_14_2 = csv.gym.gym[arg_13_0.id].npcID
			local var_14_3 = csv.gym.npc[var_14_2]
			local var_14_4 = csv.role_figure[var_14_3.figure]

			arg_13_0.textNameNPC:text(var_14_4.name):show()
			arg_13_0.ownerFigure:set(var_14_3.figure)
			nodetools.invoke(arg_13_0.panelLeft, {
				"textFight",
				"textName",
				"textFightNote",
				"textLv"
			}, "hide")
			arg_13_0.btnOwerChallenge:show()
			arg_13_0.imgOwner:texture("city/adventure/gym_challenge/txt_gz.png")
		elseif gGameModel.role:read("id") == var_14_1.role_id then
			arg_13_0.textNameNPC:hide()
			arg_13_0.ownerFigure:set(gGameModel.role:read("figure"))
			nodetools.invoke(arg_13_0.panelLeft, {
				"textFight",
				"textName",
				"textFightNote",
				"textLv"
			}, "show")
			arg_13_0.ownerFigure:set(var_14_1.figure)
			arg_13_0.panelLeft:get("textLv"):text("Lv:" .. var_14_1.level)
			arg_13_0.panelLeft:get("textFight"):text(var_14_1.fighting_point)
			arg_13_0.panelLeft:get("textName"):text(var_14_1.name)
			arg_13_0.btnOwerChallenge:hide()
			arg_13_0.textTime:hide()
			arg_13_0.imgOwner:texture("city/adventure/gym_challenge/txt_rygz.png")
		else
			arg_13_0.textNameNPC:hide()
			nodetools.invoke(arg_13_0.panelLeft, {
				"textFight",
				"textName",
				"textFightNote",
				"textLv"
			}, "show")
			arg_13_0.ownerFigure:set(var_14_1.figure)
			arg_13_0.panelLeft:get("textLv"):text("Lv:" .. var_14_1.level)
			arg_13_0.panelLeft:get("textFight"):text(var_14_1.fighting_point)
			arg_13_0.panelLeft:get("textName"):text(var_14_1.name)
			arg_13_0.btnOwerChallenge:show()

			local var_14_5 = gGameModel.role:read("gym_datas").gym_pw_last_time + gCommonConfigCsv.gymPwCD

			arg_13_0.textTime:setVisible(var_14_5 > time.getTime())
			arg_13_0.imgOwner:texture("city/adventure/gym_challenge/txt_rygz.png")
		end

		bind.touch(arg_13_0, arg_13_0.figure, {
			methods = {
				ended = function()
					if var_14_0 == nil or var_14_0[arg_13_0.id] == nil then
						gGameUI:createView("city.adventure.gym_challenge.npc_info", arg_13_0):init(arg_13_0.id)
					else
						gGameApp:requestServer("/game/gym/role/info", function(arg_16_0)
							local var_16_0 = csvSize(csv.gym.gym[arg_13_0.id].hardDegreeID)
							local var_16_1 = csv.gym.gym[arg_13_0.id].hardDegreeID[var_16_0]
							local var_16_2 = arg_13_0.ownerUnlock and var_16_1 < arg_13_0.gymDatas:read().gym_fuben[arg_13_0.id]

							gGameUI:createView("city.adventure.gym_challenge.master_info", arg_13_0):init(arg_16_0.view, arg_13_0.id, false, var_16_2)
						end, var_14_0[arg_13_0.id].record_id)
					end
				end
			}
		})
	end)
	adapt.oneLineCenterPos(cc.p(443, arg_13_0.panelLeft:get("textLv"):y()), {
		arg_13_0.panelLeft:get("textLv"),
		arg_13_0.panelLeft:get("textName")
	}, cc.p(15, 0))
	adapt.oneLineCenterPos(cc.p(443, arg_13_0.panelLeft:get("textFightNote"):y()), {
		arg_13_0.panelLeft:get("textFightNote"),
		arg_13_0.panelLeft:get("textFight")
	})
end

function var_0_2.onGateDetail(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_3.state == var_0_1.UNLOCK

	gGameUI:createView("city.adventure.gym_challenge.gate_detail", arg_17_0):init(arg_17_3.gateId, arg_17_2, arg_17_1.id, var_17_0)
end

function var_0_2.onGatePass(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	gGameApp:requestServer("/game/gym/gate/pass", function(arg_19_0)
		gGameUI:showGainDisplay(arg_19_0.view.drop)
	end, arg_18_0.id, arg_18_3.gateId)
end

function var_0_2.onBtnOwnerChallenge(arg_20_0)
	if arg_20_0:getChallengeState() == false then
		gGameUI:showTip(gLanguageCsv.gymTimeOut)

		return
	end

	if not arg_20_0.ownerUnlock then
		gGameUI:showTip(gLanguageCsv.gymTips1)

		return
	end

	if arg_20_0.inCd:read() then
		gGameUI:showTip(gLanguageCsv.gymInCd)

		return
	end

	if gGameModel.role:read("gym_datas").gym_pw_last_time + gCommonConfigCsv.gymPwCD > time.getTime() then
		return
	end

	local var_20_0 = csv.gym.gym[arg_20_0.id].limitAttribute

	if #dataEasy.getNatureSprite(var_20_0) == 0 then
		gGameUI:showTip(gLanguageCsv.gymNoSptire1)

		return
	end

	local var_20_1 = arg_20_0.gymOwners:read()

	if var_20_1 == nil or var_20_1[arg_20_0.id] == nil then
		local var_20_2 = {}

		for iter_20_0, iter_20_1 in csvPairs(csv.gym.gate) do
			if iter_20_1.npc then
				var_20_2[iter_20_1.gymID] = iter_20_0
			end
		end

		local var_20_3 = var_20_2[arg_20_0.id]
		local var_20_4 = csv.gym.gate[var_20_3].deployType

		local function var_20_5(arg_21_0, arg_21_1)
			local var_21_0 = arg_21_1:read()

			battleEntrance.battleRequest("/game/gym/gate/start", var_20_3, arg_20_0.id, var_21_0):onStartOK(function(arg_22_0)
				arg_21_0:onClose(false)
			end):show()
		end

		if var_20_4 == 1 then
			local var_20_6 = csv.gym.gym[arg_20_0.id].limitAttribute
			local var_20_7 = csv.gym.gate[var_20_3].deployCardNumLimit
			local var_20_8 = game.EMBATTLE_FROM_TABLE.gymChallenge

			if itertools.size(var_20_6) ~= 0 or var_20_7 ~= 6 then
				var_20_8 = game.EMBATTLE_FROM_TABLE.onekey
			end

			gGameUI:stackUI("city.adventure.gym_challenge.embattle1", nil, {
				full = true
			}, {
				fightCb = var_20_5,
				limitInfo = csv.gym.gym[arg_20_0.id].limitAttribute,
				gymId = arg_20_0.id,
				from = var_20_8
			})
		elseif var_20_4 == 2 then
			gGameUI:stackUI("city.adventure.gym_challenge.embattle2", nil, {
				full = true
			}, {
				fightCb = var_20_5,
				limitInfo = csv.gym.gym[arg_20_0.id].limitAttribute,
				gymId = arg_20_0.id
			})
		else
			gGameUI:stackUI("city.adventure.gym_challenge.embattle3", nil, {
				full = true
			}, {
				fightCb = var_20_5,
				limitInfo = csv.gym.gym[arg_20_0.id].limitAttribute,
				gymId = arg_20_0.id
			})
		end
	else
		local function var_20_9(arg_23_0, arg_23_1)
			local var_23_0 = arg_23_1:read()

			battleEntrance.battleRequest("/game/gym/leader/battle/start", var_23_0, arg_20_0.id, var_20_1[arg_20_0.id].record_id):onStartOK(function(arg_24_0)
				arg_23_0:onClose()
			end):run():show()
		end

		gGameUI:stackUI("city.adventure.gym_challenge.embattle1", nil, {
			full = true
		}, {
			fightCb = var_20_9,
			limitInfo = csv.gym.gym[arg_20_0.id].limitAttribute,
			from = game.EMBATTLE_FROM_TABLE.onekey
		})
	end
end

function var_0_2.onBtnBuf(arg_25_0)
	if arg_25_0:getChallengeState() then
		gGameUI:stackUI("city.adventure.gym_challenge.buff", nil, {
			full = true
		})
	else
		gGameUI:showTip(gLanguageCsv.gymEndTips)
	end
end

function var_0_2.onBtnAward(arg_26_0)
	local var_26_0 = {}

	for iter_26_0, iter_26_1 in pairs(csv.gym.gym[arg_26_0.id].gateAward) do
		if iter_26_0 ~= "libs" then
			var_26_0[iter_26_0] = iter_26_1
		end
	end

	local var_26_1 = 0
	local var_26_2 = ""
	local var_26_3 = arg_26_0.gymDatas:read().gym_pass_awards or {}
	local var_26_4

	if var_26_3[arg_26_0.id] == 0 then
		var_26_1 = 0
		var_26_2 = gLanguageCsv.received
	elseif var_26_3[arg_26_0.id] == 1 then
		var_26_1 = 1
		var_26_2 = gLanguageCsv.spaceReceive

		function var_26_4()
			gGameApp:requestServer("/game/gym/gate/award", function(arg_28_0)
				gGameUI:showGainDisplay(arg_28_0)
			end, arg_26_0.id)
		end
	else
		var_26_1 = 1
		var_26_2 = gLanguageCsv.commonTextOk
	end

	gGameUI:showBoxDetail({
		clearFast = true,
		data = var_26_0 or {},
		btnText = var_26_2,
		content = gLanguageCsv.gymAwardDesc,
		state = var_26_1,
		cb = var_26_4
	})
end

function var_0_2.getChallengeState(arg_29_0)
	if arg_29_0.round:read() == "closed" then
		return false
	end

	return time.getNumTimestamp(gGameModel.gym:read("date"), 21, 45) + 518400 > time.getTime()
end

function var_0_2.initCountDown(arg_30_0)
	if not arg_30_0:getChallengeState() then
		arg_30_0.textTime:text(gLanguageCsv.gymTimeOut)

		return
	end

	if gGameModel.role:read("gym_datas").gym_pw_last_time == 0 then
		arg_30_0.textTime:hide()

		return
	end

	local function var_30_0()
		local var_31_0 = gGameModel.role:read("gym_datas").gym_pw_last_time + gCommonConfigCsv.gymPwCD
		local var_31_1 = time.getCutDown(var_31_0 - time.getTime())

		arg_30_0.textTime:text(var_31_1.short_date_str .. gLanguageCsv.gymTimeLimit)
		adapt.oneLinePos(arg_30_0.textTime, arg_30_0.textNote1, cc.p(5, 0), "right")

		if var_31_0 - time.getTime() <= 0 then
			arg_30_0.inCd:set(false)
			arg_30_0.textTime:hide()
			arg_30_0:unSchedule(1)

			return false
		else
			arg_30_0.inCd:set(true)

			return true
		end
	end

	arg_30_0:enableSchedule()
	var_30_0()
	arg_30_0:schedule(function(arg_32_0)
		if not var_30_0() then
			return false
		end
	end, 1, 0, 1)
end

return var_0_2
