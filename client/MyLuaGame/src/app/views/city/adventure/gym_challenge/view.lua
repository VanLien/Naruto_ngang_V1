local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("GymChallengeView", var_0_0)
local var_0_2 = gCommonConfigCsv.gymMapScale
local var_0_3 = gCommonConfigCsv.crossMapScale
local var_0_4 = {
	WAIT_STAR = 3,
	ENDED = 2,
	GAMING = 1
}
local var_0_5 = {
	{
		scale = 3,
		spine = "dao2_loop",
		pos = {
			x = 600,
			y = 3450
		}
	},
	{
		scale = 2,
		spine = "dao5_loop",
		pos = {
			x = 5754,
			y = 3040
		}
	},
	{
		scale = 2,
		spine = "dao4_loop",
		pos = {
			x = 290,
			y = 600
		}
	},
	{
		scale = 2,
		spine = "dao1_loop",
		pos = {
			x = 4180,
			y = 160
		}
	},
	{
		scale = 2,
		spine = "dao3_loop",
		pos = {
			x = 6000,
			y = 1800
		}
	},
	{
		scale = 2,
		spine = "dao15_loop",
		pos = {
			x = 5000,
			y = 3550
		}
	},
	{
		scale = 2,
		spine = "dao14_loop",
		pos = {
			x = 50,
			y = 2750
		}
	},
	{
		scale = 1.8,
		spine = "dao3_loop",
		pos = {
			x = 2000,
			y = 3230
		}
	},
	{
		scale = 2,
		spine = "dao2_loop",
		pos = {
			x = 400,
			y = 1640
		}
	}
}

var_0_1.RESOURCE_FILENAME = "gym_challenge.json"
var_0_1.RESOURCE_BINDING = {
	["rightTopPanel.textNote2"] = "textNote2",
	gymItem = "gymItem",
	rightDownPanel = "rightDownPanel",
	["rightTopPanel.textNote1"] = "textNote1",
	scrollView = {
		varname = "scrollView",
		binds = {
			event = "scrollBarEnabled",
			data = false
		}
	},
	["rightTopPanel.textNote1"] = {
		varname = "textNote1",
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
	["rightTopPanel.textNote2"] = {
		varname = "textNote2",
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
	["rightTopPanel.textTime"] = {
		varname = "textTime",
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
	["rightTopPanel.textTimes"] = {
		varname = "textTimes",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	},
	["rightDownPanel.btnBuf.textNote"] = {
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
	["rightDownPanel.btnRule.textNote"] = {
		varname = "ruleNote",
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
	["rightDownPanel.btnRule"] = {
		varname = "btnRule",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRuleClick")
			}
		}
	},
	["rightDownPanel.btnBuf"] = {
		varname = "btnBuf",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onBtnBufClick")
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
					onNode = function(arg_1_0)
						arg_1_0:xy(90, 90):scale(0.66)
					end
				}
			}
		}
	},
	["rightDownPanel.btnCross"] = {
		varname = "btnCross",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onBtnCrossClick")
				}
			},
			{
				scale = 2,
				res = "gym/kuafu_btn.skel",
				action = "effect_loop",
				event = "animation",
				pos = {
					x = 100,
					y = 100
				},
				onSpine = function(arg_2_0)
					arg_2_0:xy(100, 100):scale(2)
				end
			}
		}
	},
	["rightTopPanel.btnAdd"] = {
		varname = "btnAdd",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddClick")
			}
		}
	},
	["btnLog.textNote"] = {
		varname = "ruleNote",
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
	["rightDownPanel.btnCross.textNote"] = {
		varname = "btnCrossText",
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
	btnLog = {
		varname = "btnLog",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onBtnLogClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "gymLogs",
					listenData = {
						gymLogs = bindHelper.self("record"),
						lastTime = bindHelper.self("lastTime")
					},
					onNode = function(arg_3_0)
						arg_3_0:xy(180, 180)
					end
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1, arg_4_2)
	gGameUI.topuiManager:createView("default", arg_4_0, {
		onClose = arg_4_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_daochangtiaozhan.png"
	})

	arg_4_0.gyms = {}
	arg_4_0.notCross = idler.new(arg_4_0._notCross == nil and true or arg_4_0._notCross)
	arg_4_0.endTime = 0

	arg_4_0:initScrollView()
	arg_4_0:initGyms()
	arg_4_0:initModel()
	arg_4_0:addBuildingMoveAction()
	arg_4_0:moveToGym(arg_4_0.maxLockID)
	arg_4_0:refreshOpacity()
	arg_4_0:initParticle()
end

function var_0_1.initParticle(arg_5_0)
	local var_5_0 = "particle/huoxin2.plist"
	local var_5_1 = "particle/ani_huoxin2.json"

	cc.ParticleSystemQuad:create(var_5_0, var_5_1):addTo(arg_5_0.rightDownPanel):xy(arg_5_0.btnCross:xy()):scale(2)
end

function var_0_1.onClose(arg_6_0, arg_6_1)
	if not arg_6_0.notCross:read() then
		arg_6_0.notCross:modify(function(arg_7_0)
			return true, not arg_7_0
		end)
		arg_6_0:getResourceNode():removeChildByName("cloudSpine")

		local var_6_0 = widget.addAnimationByKey(arg_6_0:getResourceNode(), "gym/kuafu_yun.skel", "cloudSpine", "kuafu_effect", 6):xy(cc.p(display.sizeInView.width / 2, display.sizeInView.height / 2)):scale(2)
	else
		var_0_0.onClose(arg_6_0)
	end
end

function var_0_1.onCleanup(arg_8_0)
	arg_8_0._notCross = arg_8_0.notCross:read()

	var_0_0.onCleanup(arg_8_0)
end

function var_0_1.initScrollView(arg_9_0)
	arg_9_0.mapScale = var_0_2

	arg_9_0.scrollView:getInnerContainer():scale(arg_9_0.mapScale)
	arg_9_0.scrollView:size(display.sizeInViewRect):xy(display.sizeInViewRect)

	local var_9_0 = cc.TMXTiledMap:create("city/adventure/gym_challenge/map/map.tmx")

	var_9_0:z(1)
	var_9_0:scale(2)
	var_9_0:setColor(cc.c3b(0, 0, 0))
	var_9_0:addTo(arg_9_0.scrollView:get("bg"))
end

function var_0_1.initGyms(arg_10_0)
	for iter_10_0, iter_10_1 in orderCsvPairs(csv.gym.gym) do
		local var_10_0 = arg_10_0.gymItem:clone():addTo(arg_10_0.scrollView):xy(iter_10_1.pos)
		local var_10_1 = widget.addAnimationByKey(var_10_0, "city/adventure/gym_challenge/house/house" .. iter_10_0 .. ".png", "spine" .. iter_10_0, iter_10_1.spine, 0):xy(iter_10_1.posSkew):scale(2)

		arg_10_0.gyms[iter_10_0] = var_10_0

		local var_10_2 = var_10_0:get("imgGymNameBg.textGymName")

		var_10_2:text(iter_10_1.name)

		local var_10_3 = var_10_0:get("imgHeadBg.textName")

		text.addEffect(var_10_3, {
			outline = {
				size = 4,
				color = ui.COLORS.OUTLINE.WHITE
			}
		})
		var_10_0:color(cc.c3b(128, 128, 128))
		var_10_0:get("imgLocked"):show()
		var_10_0:get("imgComplete"):hide()
		bind.touch(arg_10_0, var_10_0, {
			methods = {
				ended = function()
					arg_10_0:onGymClick(iter_10_0)
				end
			}
		})
		bind.touch(arg_10_0, var_10_0:get("imgHeadBg"), {
			methods = {
				ended = function()
					if arg_10_0.notCross:read() == false then
						local var_12_0 = arg_10_0.round:read() == "start" and arg_10_0.gymCrossOwners:read()[iter_10_0] or arg_10_0.lastCrossGymOwners:read()[iter_10_0]

						if var_12_0 and var_12_0[1] then
							local var_12_1 = var_12_0[1].record_id

							gGameApp:requestServer("/game/gym/role/info", function(arg_13_0)
								local var_13_0 = csvSize(csv.gym.gym[iter_10_0].hardDegreeID)
								local var_13_1 = csv.gym.gym[iter_10_0].hardDegreeID[var_13_0]
								local var_13_2 = arg_10_0.gymsInfo:atproxy(iter_10_0).unlocked and var_13_1 < arg_10_0.gymDatas:read().gym_fuben[iter_10_0]

								gGameUI:createView("city.adventure.gym_challenge.master_info", arg_10_0):init(arg_13_0.view, iter_10_0, true, var_13_2, 1)
							end, var_12_1, var_12_0[1].game_key)
						end
					else
						local var_12_2 = arg_10_0.round:read() == "start" and arg_10_0.gymOwners:read() or arg_10_0.lastGymOwners:read()

						if var_12_2 and var_12_2[iter_10_0] then
							local var_12_3 = var_12_2[iter_10_0].record_id

							gGameApp:requestServer("/game/gym/role/info", function(arg_14_0)
								local var_14_0 = csvSize(csv.gym.gym[iter_10_0].hardDegreeID)
								local var_14_1 = csv.gym.gym[iter_10_0].hardDegreeID[var_14_0]
								local var_14_2 = arg_10_0.gymsInfo:atproxy(iter_10_0).unlocked and var_14_1 < arg_10_0.gymDatas:read().gym_fuben[iter_10_0]

								gGameUI:createView("city.adventure.gym_challenge.master_info", arg_10_0):init(arg_14_0.view, iter_10_0, false, var_14_2)
							end, var_12_3)
						else
							gGameUI:createView("city.adventure.gym_challenge.npc_info", arg_10_0):init(iter_10_0)
						end
					end
				end
			}
		})
		bind.extend(arg_10_0, var_10_2, {
			class = "red_hint",
			props = {
				specialTag = "gymAward",
				state = arg_10_0.notCross,
				listenData = {
					gymDatas = bindHelper.self("gymDatas"),
					id = iter_10_0
				},
				onNode = function(arg_15_0)
					arg_15_0:xy(400, 110)
				end
			}
		})
	end
end

local function var_0_6(arg_16_0, arg_16_1)
	arg_16_0:setOpacity(arg_16_1)

	for iter_16_0, iter_16_1 in pairs(arg_16_0:getChildren()) do
		var_0_6(iter_16_1, arg_16_1)
	end
end

function var_0_1.refreshOpacity(arg_17_0)
	local var_17_0 = arg_17_0.scrollView:getInnerContainerPosition()
	local var_17_1 = arg_17_0.scrollView:width() - 300
	local var_17_2 = arg_17_0.scrollView:height() - 300
	local var_17_3 = var_17_1 / 2
	local var_17_4 = var_17_2 / 2

	for iter_17_0, iter_17_1 in ipairs(arg_17_0.gyms) do
		local var_17_5 = iter_17_1:x()
		local var_17_6 = iter_17_1:y()
		local var_17_7 = var_17_0.x + var_17_5 * arg_17_0.mapScale - 150
		local var_17_8 = var_17_0.y + var_17_6 * arg_17_0.mapScale - 150
		local var_17_9 = 0

		if var_17_3 < math.abs(var_17_7 - var_17_3) or var_17_4 < math.abs(var_17_8 - var_17_4) then
			var_17_9 = math.max(math.abs(var_17_7 - var_17_3) - var_17_3, math.abs(var_17_8 - var_17_4) - var_17_4)
		end

		local var_17_10 = math.max(76.5, 255 * (1 - math.min(1, var_17_9 / 300)))

		var_0_6(iter_17_1, var_17_10)
	end
end

function var_0_1.addBuildingMoveAction(arg_18_0)
	local var_18_0 = true

	arg_18_0.scrollView:onEvent(function(arg_19_0)
		if arg_19_0.name == "CONTAINER_MOVED" then
			var_18_0 = true
		end
	end)
	schedule(arg_18_0.scrollView, function()
		if var_18_0 then
			arg_18_0:refreshOpacity()

			var_18_0 = false
		end
	end, 0.1)
end

function var_0_1.updateGym(arg_21_0, arg_21_1, arg_21_2)
	local function var_21_0(arg_22_0, arg_22_1)
		arg_22_0:setColor(arg_22_1)

		for iter_22_0, iter_22_1 in pairs(arg_22_0:getChildren()) do
			var_21_0(iter_22_1, arg_22_1)
		end
	end

	local var_21_1 = arg_21_0.gyms[arg_21_1]

	if not csv.gym.gym[arg_21_1].preGymID then
		local var_21_2 = 0
	end

	if arg_21_2.completed == true then
		var_21_0(var_21_1:get("spine" .. arg_21_1), cc.c3b(255, 255, 255))
		var_21_1:color(cc.c3b(255, 255, 255))
		var_21_1:get("imgComplete"):show()
		var_21_1:get("imgLocked"):hide()
	elseif arg_21_2.unlocked == true then
		var_21_0(var_21_1:get("spine" .. arg_21_1), cc.c3b(255, 255, 255))
		var_21_1:color(cc.c3b(255, 255, 255))
		var_21_1:get("imgComplete"):hide()
		var_21_1:get("imgLocked"):hide()
	else
		var_21_0(var_21_1:get("spine" .. arg_21_1), cc.c3b(128, 128, 128))
		var_21_1:get("imgLocked"):show()
		var_21_1:get("imgComplete"):hide()
	end
end

function var_0_1.updateGymOwner(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = arg_23_0.gyms[arg_23_1]:get("imgHeadBg")

	if arg_23_2 == nil then
		var_23_0:hide()
	else
		if arg_23_3 then
			var_23_0:get("imgOwner"):texture("city/adventure/gym_challenge/map/txt_gz.png")
		else
			var_23_0:get("imgOwner"):texture("city/adventure/gym_challenge/map/txt_rygz.png")
		end

		var_23_0:show()
		var_23_0:get("textName"):text(arg_23_2.name)

		local var_23_1 = bind.extend(arg_23_0, var_23_0, {
			event = "extend",
			class = "role_logo",
			props = {
				vip = false,
				frameId = false,
				level = false,
				logoId = arg_23_2.logo,
				onNode = function(arg_24_0)
					if arg_23_3 then
						local var_24_0 = csv.gym.gym[arg_23_1].npcID
						local var_24_1 = csv.gym.npc[var_24_0]
						local var_24_2 = csv.role_figure[var_24_1.figure].logo

						arg_24_0:get("logoClipping.logo"):texture(var_24_2)
					end

					arg_24_0:scale(1.22)
				end
			}
		})
	end
end

function var_0_1.initModel(arg_25_0)
	arg_25_0.gymDatas = gGameModel.role:getIdler("gym_datas")
	arg_25_0.gymOwners = gGameModel.gym:getIdler("leaderRoles")
	arg_25_0.lastGymOwners = gGameModel.gym:getIdler("lastLeaderRoles")
	arg_25_0.starDate = gGameModel.gym:read("date")
	arg_25_0.round = gGameModel.gym:getIdler("round")
	arg_25_0.gymCrossOwners = gGameModel.gym:getIdler("crossGymRoles")
	arg_25_0.lastCrossGymOwners = gGameModel.gym:getIdler("lastCrossGymRoles")
	arg_25_0.curIndex = idler.new(0)
	arg_25_0.gymsInfo = idlers.newWithMap({
		{},
		{},
		{},
		{},
		{},
		{},
		{},
		{}
	})
	arg_25_0.buyTimes = gGameModel.daily_record:getIdler("gym_battle_buy_times")
	arg_25_0.record = gGameModel.gym:getIdler("record")

	local var_25_0 = userDefault.getForeverLocalKey("gymLogOpenTime", 0)

	arg_25_0.lastTime = idler.new(var_25_0)

	idlereasy.when(arg_25_0.round, function(arg_26_0, arg_26_1)
		arg_25_0:initCountDown()
	end)
	idlereasy.when(arg_25_0.gymDatas, function(arg_27_0, arg_27_1)
		arg_25_0.maxLockID = 1
		arg_25_0.maxCrossLockID = 1

		for iter_27_0, iter_27_1 in pairs(arg_27_1.gym_fuben or {}) do
			arg_25_0.gymsInfo:atproxy(iter_27_0).unlocked = true

			local var_27_0 = csvSize(csv.gym.gym[iter_27_0].hardDegreeID)

			if iter_27_1 > csv.gym.gym[iter_27_0].hardDegreeID[var_27_0] then
				arg_25_0.gymsInfo:atproxy(iter_27_0).completed = true
				arg_25_0.maxCrossLockID = math.max(arg_25_0.maxLockID, iter_27_0)

				for iter_27_2, iter_27_3 in orderCsvPairs(csv.gym.gym) do
					if iter_27_3.preGymID == iter_27_0 then
						arg_25_0.gymsInfo:atproxy(iter_27_2).unlocked = true
					end
				end
			end

			arg_25_0.maxLockID = math.max(arg_25_0.maxLockID, iter_27_0)
		end
	end)
	idlereasy.any({
		arg_25_0.gymsInfo,
		arg_25_0.notCross
	}, function(arg_28_0, arg_28_1, arg_28_2)
		for iter_28_0, iter_28_1 in ipairs(arg_28_1) do
			if arg_28_2 then
				arg_25_0:updateGym(iter_28_0, iter_28_1:read())
			else
				arg_25_0:updateGym(iter_28_0, {
					completed = false,
					unlocked = iter_28_1:read().completed
				})
			end

			local var_28_0 = gGameModel.gym:read("lastCrossGymRoles")
			local var_28_1 = csv.cross.gym.base[1].servOpenDays
			local var_28_2 = arg_25_0:getOpenTime()

			arg_25_0.btnCross:get("imgLock"):setVisible(arg_28_2 and gGameModel.gym:read("crossKey") == "" and itertools.size(var_28_0) == 0 or var_28_2 > time.getTime())
		end
	end)
	idlereasy.any({
		arg_25_0.gymOwners,
		arg_25_0.gymCrossOwners,
		arg_25_0.notCross,
		arg_25_0.round
	}, function(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
		local var_29_0
		local var_29_1

		if arg_29_4 == "start" then
			var_29_0 = arg_29_2 or {}
			var_29_1 = arg_29_1 or {}
		else
			var_29_0 = arg_25_0.lastCrossGymOwners:read() or {}
			var_29_1 = arg_25_0.lastGymOwners:read() or {}
		end

		for iter_29_0 = 1, 8 do
			if arg_29_3 then
				if var_29_1[iter_29_0] then
					arg_25_0:updateGymOwner(iter_29_0, var_29_1[iter_29_0], false)
				else
					local var_29_2 = csv.gym.gym[iter_29_0].npcID
					local var_29_3 = csv.gym.npc[var_29_2]
					local var_29_4 = csv.role_figure[var_29_3.figure]
					local var_29_5 = {
						name = var_29_4.name,
						logo = var_29_3.figure
					}

					arg_25_0:updateGymOwner(iter_29_0, var_29_5, true)
				end
			elseif var_29_0[iter_29_0] then
				arg_25_0:updateGymOwner(iter_29_0, var_29_0[iter_29_0][1], false)
			else
				arg_25_0:updateGymOwner(iter_29_0, nil, false)
			end
		end
	end)

	arg_25_0.first = true

	arg_25_0.notCross:addListener(function(arg_30_0, arg_30_1)
		local var_30_0 = 1
		local var_30_1 = arg_25_0.mapScale

		if not arg_30_0 then
			local var_30_2 = matchLanguage({
				"kr"
			}) and 1 or 0.8

			arg_25_0.mapScale = var_0_3

			arg_25_0.btnCrossText:text(gLanguageCsv.gymReturn):scale(var_30_2)

			var_30_0 = arg_25_0.maxCrossLockID
		else
			arg_25_0.mapScale = var_0_2

			arg_25_0.btnCrossText:text(gLanguageCsv.gymCross):scale(1)

			var_30_0 = arg_25_0.maxLockID
		end

		local function var_30_3()
			arg_25_0:moveToGym(var_30_0)
			arg_25_0:refreshOpacity()

			if not arg_30_0 then
				arg_25_0.scrollView:get("bg"):texture("city/adventure/gym_challenge/map/bg_kf_0.png")

				for iter_31_0, iter_31_1 in orderCsvPairs(csv.gym.gym) do
					arg_25_0.gyms[iter_31_0]:get("imgGymNameBg"):texture("city/adventure/gym_challenge/map/box_dgmc_kf.png")

					local var_31_0 = arg_25_0.gyms[iter_31_0]:get("imgGymNameBg.textGymName")

					if matchLanguage({
						"kr"
					}) then
						var_31_0:setFontSize(50)
					end

					var_31_0:text(gLanguageCsv.crossServer .. iter_31_1.name)
				end
			else
				arg_25_0.scrollView:get("bg"):texture("city/adventure/gym_challenge/map/bg_0.png")

				for iter_31_2, iter_31_3 in orderCsvPairs(csv.gym.gym) do
					arg_25_0.gyms[iter_31_2]:get("imgGymNameBg"):texture("city/adventure/gym_challenge/map/box_dgmc.png")
					arg_25_0.gyms[iter_31_2]:get("imgGymNameBg.textGymName"):text(iter_31_3.name)
				end
			end

			if arg_30_0 == false then
				arg_25_0.btnBuf:hide()
				arg_25_0.btnRule:xy(394, 155)
				arg_25_0.ruleNote:text(gLanguageCsv.crossRule)
			else
				arg_25_0.btnBuf:show()
				arg_25_0.btnRule:xy(207, 155)
				arg_25_0.ruleNote:text(gLanguageCsv.spaceRule)
			end
		end

		if arg_25_0.first == true then
			arg_25_0.scrollView:getInnerContainer():scale(arg_25_0.mapScale)
			var_30_3()
		else
			local var_30_4 = arg_25_0.scrollView:size()
			local var_30_5 = arg_25_0.scrollView:getInnerContainerSize()
			local var_30_6 = arg_25_0.scrollView:getInnerContainerPosition()
			local var_30_7 = (var_30_4.width / 2 - var_30_6.x) / var_30_1
			local var_30_8 = (var_30_4.height / 2 - var_30_6.y) / var_30_1
			local var_30_9 = var_30_4.width / 2 - var_30_7 * arg_25_0.mapScale
			local var_30_10 = var_30_4.height / 2 - var_30_8 * arg_25_0.mapScale
			local var_30_11 = math.min(0, var_30_9)
			local var_30_12 = math.min(0, var_30_10)
			local var_30_13 = math.max(-arg_25_0.scrollView:getInnerContainerSize().width * arg_25_0.mapScale + var_30_4.width, var_30_11)
			local var_30_14 = math.max(-arg_25_0.scrollView:getInnerContainerSize().height * arg_25_0.mapScale + var_30_4.height, var_30_12)
			local var_30_15 = cc.ScaleTo:create(1, arg_25_0.mapScale)
			local var_30_16 = cc.MoveTo:create(1, {
				x = var_30_13,
				y = var_30_14
			})

			arg_25_0.scrollView:getInnerContainer():stopAllActions()
			arg_25_0.scrollView:getInnerContainer():runAction(cc.Sequence:create(cc.Spawn:create(var_30_15, var_30_16), cc.CallFunc:create(function()
				var_30_3()
			end)))
		end

		arg_25_0.first = false
	end)
	idlereasy.any({
		gGameModel.daily_record:getIdler("gym_battle_times"),
		arg_25_0.buyTimes
	}, function(arg_33_0, arg_33_1, arg_33_2)
		arg_25_0.textTimes:text(math.max(gCommonConfigCsv.gymBattleTimes - arg_33_1 + arg_33_2, 0) .. gLanguageCsv.times)
	end)
end

function var_0_1.moveToGym(arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0.gyms[arg_34_1]
	local var_34_1 = arg_34_0.scrollView:size()
	local var_34_2 = var_34_0:x()
	local var_34_3 = var_34_0:y()
	local var_34_4 = var_34_1.width / 2 - var_34_2 * arg_34_0.mapScale
	local var_34_5 = var_34_1.height / 2 - var_34_3 * arg_34_0.mapScale
	local var_34_6 = math.min(0, var_34_4)
	local var_34_7 = math.min(0, var_34_5)
	local var_34_8 = math.max(-arg_34_0.scrollView:getInnerContainerSize().width * arg_34_0.mapScale + var_34_1.width, var_34_6)
	local var_34_9 = math.max(-arg_34_0.scrollView:getInnerContainerSize().height * arg_34_0.mapScale + var_34_1.height, var_34_7)

	arg_34_0.scrollView:setInnerContainerPosition(cc.p(var_34_8, var_34_9))
end

function var_0_1.getCountDownState(arg_35_0)
	if arg_35_0.round:read() == "closed" then
		local var_35_0 = time.getTimeTable().hour

		if tonumber(var_35_0) >= 5 and tonumber(var_35_0) < 10 then
			return var_0_4.WAIT_STAR
		else
			return var_0_4.ENDED
		end
	elseif arg_35_0.round:read() == "start" then
		arg_35_0.endTime = time.getNumTimestamp(arg_35_0.starDate, 21, 45) + 518400

		return var_0_4.GAMING
	end
end

function var_0_1.initCountDown(arg_36_0)
	if arg_36_0:getCountDownState() ~= var_0_4.GAMING then
		arg_36_0.textTime:text("")
		arg_36_0.textTimes:text(""):hide()
		arg_36_0.textNote2:text("")
		arg_36_0.btnAdd:hide()
		text.deleteEffect(arg_36_0.textNote1, "all")
		text.deleteEffect(arg_36_0.textNote2, "all")

		if arg_36_0:getCountDownState() == var_0_4.ENDED then
			arg_36_0.textNote1:text(gLanguageCsv.gymEnd)
		else
			arg_36_0.textNote1:text(gLanguageCsv.gymWaitBegin)
		end

		arg_36_0.textNote1:color(ui.COLORS.NORMAL.ALERT_YELLOW)
		arg_36_0.textNote1:y(arg_36_0.textNote1:y() / 2 + arg_36_0.textNote2:y() / 2)
		adapt.oneLinePos(arg_36_0.textTime, arg_36_0.textNote1, cc.p(-50, 0), "right")

		return
	else
		arg_36_0.textTimes:show()
		arg_36_0.btnAdd:show()
	end

	local function var_36_0()
		if arg_36_0.endTime - time.getTime() < 0 then
			performWithDelay(arg_36_0, function()
				gGameApp:requestServer("/game/gym/main", function(arg_39_0)
					return
				end)
			end, 10)
			arg_36_0:unSchedule(1)

			return false
		end

		local var_37_0 = time.getCutDown(arg_36_0.endTime - time.getTime())

		arg_36_0.textTime:text(var_37_0.str)
		adapt.oneLinePos(arg_36_0.textTime, arg_36_0.textNote1, cc.p(5, 0), "right")

		return true
	end

	arg_36_0:enableSchedule()
	var_36_0()
	arg_36_0:schedule(function(arg_40_0)
		if not var_36_0() then
			return false
		end
	end, 1, 0, 1)

	local var_36_1 = time.getNumTimestamp(time.getWeekStrInClock(0), 5)

	if var_36_1 <= time.getTime() then
		var_36_1 = var_36_1 + 604800
	end

	arg_36_0:schedule(function(arg_41_0)
		if time.getTime() > var_36_1 + 10 and gGameModel.role:read("gym_record_db_id") then
			gGameApp:requestServer("/game/gym/main", function(arg_42_0)
				return
			end)
			arg_36_0:unSchedule(2)

			return false
		end
	end, 1, 0, 2)
end

function var_0_1.getOpenTime(arg_43_0)
	local var_43_0 = csv.cross.gym.base[1].servOpenDays - 1
	local var_43_1 = game.SERVER_OPENTIME + var_43_0 * 24 * 3600
	local var_43_2 = time.getDate(var_43_1)
	local var_43_3 = var_43_2.wday == 1 and 7 or var_43_2.wday - 1
	local var_43_4 = 0

	if var_43_3 == 1 and var_43_2.hour < time.getRefreshHour() then
		var_43_4 = var_43_1 - (var_43_2.hour * 3600 + var_43_2.min * 60 + var_43_2.sec) + 18000
	else
		var_43_4 = var_43_1 + (8 - var_43_3) * 24 * 3600 - (var_43_2.hour * 3600 + var_43_2.min * 60 + var_43_2.sec) + 18000
	end

	return var_43_4
end

function var_0_1.onBtnCrossClick(arg_44_0)
	if arg_44_0:getOpenTime() > time.getTime() then
		gGameUI:showTip(string.format(gLanguageCsv.crossGymDayTips, csv.cross.gym.base[1].servOpenDays))

		return
	end

	if arg_44_0.notCross:read() == true then
		local var_44_0 = gGameModel.gym:read("lastCrossGymRoles")

		if gGameModel.gym:read("crossKey") == "" and itertools.size(var_44_0) == 0 then
			gGameUI:showTip(gLanguageCsv.crossGymNotOpen)

			return
		end
	end

	arg_44_0.notCross:modify(function(arg_45_0)
		return true, not arg_45_0
	end)
	arg_44_0:getResourceNode():removeChildByName("cloudSpine")

	local var_44_1 = widget.addAnimationByKey(arg_44_0:getResourceNode(), "gym/kuafu_yun.skel", "cloudSpine", "kuafu_effect", 6):xy(cc.p(display.sizeInView.width / 2, display.sizeInView.height / 2)):scale(2)
end

function var_0_1.onBtnBufClick(arg_46_0)
	if arg_46_0.round:read() == "start" then
		gGameUI:stackUI("city.adventure.gym_challenge.buff", nil, {
			full = true
		})
	else
		gGameUI:showTip(gLanguageCsv.gymEndTips)
	end
end

function var_0_1.onGymClick(arg_47_0, arg_47_1)
	if not arg_47_0.notCross:read() then
		local var_47_0 = gGameModel.gym:read("lastCrossGymRoles")

		if gGameModel.gym:read("crossKey") == "" and itertools.size(var_47_0) == 0 then
			gGameUI:showTip(gLanguageCsv.crossGymNotOpen)

			return
		end

		if arg_47_0.gymsInfo:atproxy(arg_47_1).completed == true then
			gGameUI:stackUI("city.adventure.gym_challenge.cross_gate", nil, {
				full = true
			}, arg_47_1, arg_47_0.gymsInfo:atproxy(arg_47_1).completed)
		else
			gGameUI:showTip(gLanguageCsv.gymCrossTips1)
		end
	elseif arg_47_0.gymsInfo:atproxy(arg_47_1).unlocked == true then
		gGameUI:stackUI("city.adventure.gym_challenge.gate", nil, {
			full = true
		}, arg_47_1)
	else
		local var_47_1 = csv.gym.gym[arg_47_1].preGymID

		if var_47_1 then
			gGameUI:showTip(string.format(gLanguageCsv.gymNotUnlock, csv.gym.gym[var_47_1].name))
		end
	end
end

function var_0_1.onBtnRuleClick(arg_48_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_48_0:createHandler("getRuleContext"), {
		width = 1500
	})
end

function var_0_1.getRuleContext(arg_49_0, arg_49_1)
	local var_49_0 = adaptContext

	if arg_49_0.notCross:read() then
		local var_49_1 = {
			var_49_0.clone(arg_49_1.title, function(arg_50_0)
				arg_50_0:get("text"):text(gLanguageCsv.rules)
			end),
			var_49_0.noteText(102001, 102100)
		}

		for iter_49_0, iter_49_1 in orderCsvPairs(csv.gym.gym) do
			table.insert(var_49_1, var_49_0.clone(arg_49_1.awardItem, function(arg_51_0)
				local var_51_0 = arg_51_0:multiget("text", "list")

				var_51_0.text:text("")
				rich.createByStr("#C0xFFFFFF#" .. iter_49_1.leaderAwardDesc, 40):anchorPoint(1, 0.5):xy(250, 100):addTo(var_51_0.text, 6)
				uiEasy.createItemsToList(arg_49_1, var_51_0.list, iter_49_1.leaderAward)
			end))
		end

		return var_49_1
	else
		local var_49_2 = {
			var_49_0.clone(arg_49_1.title, function(arg_52_0)
				arg_52_0:get("text"):text(gLanguageCsv.rules)
			end),
			var_49_0.noteText(103001, 103100)
		}

		if gGameModel.gym:read("round") == "start" then
			local var_49_3 = gGameModel.gym:read("servers")

			if var_49_3 then
				local var_49_4 = arraytools.map(getMergeServers(var_49_3), function(arg_53_0, arg_53_1)
					return string.format(gLanguageCsv.brackets, getServerArea(arg_53_1, nil, true))
				end)

				table.insert(var_49_2, 2, "#C0xFFFFFF#" .. gLanguageCsv.currentServers .. table.concat(var_49_4, ","))
			end
		end

		for iter_49_2, iter_49_3 in orderCsvPairs(csv.gym.gym) do
			table.insert(var_49_2, var_49_0.clone(arg_49_1.awardItem, function(arg_54_0)
				local var_54_0 = arg_54_0:multiget("text", "list")

				var_54_0.text:text("")
				rich.createByStr("#C0xFFFFFF#" .. iter_49_3.crossLeaderAwardDesc, 40):anchorPoint(1, 0.5):xy(260, 100):addTo(var_54_0.text, 6)
				uiEasy.createItemsToList(arg_49_1, var_54_0.list, iter_49_3.crossLeaderAward)
			end))
			table.insert(var_49_2, var_49_0.clone(arg_49_1.awardItem, function(arg_55_0)
				local var_55_0 = arg_55_0:multiget("text", "list")

				var_55_0.text:text("")
				rich.createByStr("#C0xFFFFFF#" .. iter_49_3.crossSubAwardDesc, 40):anchorPoint(1, 0.5):xy(260, 100):addTo(var_55_0.text, 6)
				uiEasy.createItemsToList(arg_49_1, var_55_0.list, iter_49_3.crossSubAward)
			end))
		end

		return var_49_2
	end
end

function var_0_1.onAddClick(arg_56_0)
	local var_56_0 = gCostCsv.gym_battle_buy_cost[math.min(arg_56_0.buyTimes:read() + 1, csvSize(gCostCsv.gym_talent_point_buy_cost))]

	if arg_56_0.buyTimes:read() >= gVipCsv[gGameModel.role:read("vip_level")].gymBattleBuyTimes then
		gGameUI:showTip(gLanguageCsv.cardCapacityBuyMax)

		return
	end

	local var_56_1 = string.format(gLanguageCsv.gymBattleTimesBuy, var_56_0)

	gGameUI:showDialog({
		clearFast = true,
		isRich = true,
		btnType = 2,
		strs = {
			var_56_1
		},
		cb = function()
			if gGameModel.role:read("rmb") >= var_56_0 then
				gGameApp:requestServer("/game/gym/battle/buy", function(arg_58_0)
					gGameUI:showTip(gLanguageCsv.buySuccess)
				end)
			else
				uiEasy.showDialog("rmb")
			end
		end,
		dialogParams = {
			clickClose = false
		}
	})
end

function var_0_1.onBtnLogClick(arg_59_0)
	gGameApp:requestServer("/game/gym/main", function(arg_60_0)
		gGameUI:stackUI("city.adventure.gym_challenge.log", nil, {
			full = true
		})

		local var_60_0 = time.getTime()

		arg_59_0.lastTime:set(var_60_0)
		userDefault.setForeverLocalKey("gymLogOpenTime", var_60_0)
	end)
end

return var_0_1
