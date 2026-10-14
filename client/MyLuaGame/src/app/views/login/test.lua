local var_0_0 = {}

local function var_0_1(arg_1_0, arg_1_1)
	return (ccui.Button:create("common/btn/btn_normal_red.png"):setTitleText(arg_1_0):setTitleFontSize(48):xy(display.width + display.uiOriginMax.x - 230, arg_1_1):scale(0.8):opacity(150))
end

function var_0_0.createTestScene(arg_2_0)
	require("battle.models.play.include")

	local var_2_0 = 800
	local var_2_1 = var_0_1("battle editor", var_2_0):addTo(arg_2_0, 1)

	bind.touch(arg_2_0, var_2_1, {
		methods = {
			ended = function()
				gGameUI:stackUI("city.test.choose_card", nil, {
					full = true
				})
			end
		}
	})

	local var_2_2 = var_2_0 - 120
	local var_2_3 = var_0_1("test战斗界面", var_2_2):addTo(arg_2_0, 1)

	bind.touch(arg_2_0, var_2_3, {
		methods = {
			ended = function()
				arg_2_0:createTestSceneData()

				local var_4_0 = {
					moduleType = 1,
					sceneID = 999999,
					roleLevel = 1,
					gateType = game.GATE_TYPE.test,
					roleOut = csvClone(csv.test_battle),
					randSeed = math.random(1, 1000000),
					names = {
						"复仇者联盟",
						"口袋联盟"
					},
					preData = {}
				}
				local var_4_1 = {
					_data = var_4_0,
					_modes = {
						baseMusic = "battle1.mp3"
					}
				}

				battleEntrance._switchUI(var_4_1, function()
					local var_5_0 = {
						isTestScene = true,
						_results = {},
						_onResult = function(arg_6_0, arg_6_1)
							performWithDelay(gRootViewProxy:raw(), function()
								gGameUI:switchUI("login.view")
							end, 0)
						end
					}

					battleEntrance._localHack.postEndResultToServer(var_5_0)

					gRootViewProxy:raw().showEndView = var_5_0._onResult

					performWithDelay(gRootViewProxy:raw(), function()
						local var_8_0 = gRootViewProxy:raw()._model.scene.play

						var_8_0.OperatorArgs = battlePlay.TestGate.OperatorArgs

						var_8_0:initFightOperatorMode()
					end, 1)
					battleEntrance._localHack.postEndResultToServer(var_5_0)
					battleEntrance._localHack.showEndView(var_5_0)
				end)
			end
		}
	})

	local var_2_4 = var_2_2 - 120
	local var_2_5 = var_0_1("全自动战斗技能测试", var_2_4):addTo(arg_2_0, 1)

	bind.touch(arg_2_0, var_2_5, {
		methods = {
			ended = function()
				arg_2_0:createTestSceneData()

				local var_9_0 = {
					moduleType = 1,
					sceneID = 999999,
					roleLevel = 1,
					gateType = game.GATE_TYPE.skillTest,
					roleOut = csvClone(csv.skill_auto_test),
					randSeed = math.random(1, 1000000),
					names = {
						"复仇者联盟",
						"口袋联盟"
					},
					preData = {}
				}

				battleEntrance.battleRecord(var_9_0, "unknown", {
					fromRecordFile = true
				}):run()
			end
		}
	})

	local var_2_6 = var_2_4 - 120
	local var_2_7 = var_0_1("100次战斗模拟", var_2_6):addTo(arg_2_0, 1)

	bind.touch(arg_2_0, var_2_7, {
		methods = {
			ended = function()
				arg_2_0:createTestSceneData()

				local var_10_0 = 100
				local var_10_1 = 0
				local var_10_2 = 0

				for iter_10_0 = 1, var_10_0 do
					local var_10_3 = {
						moduleType = 1,
						sceneID = 999999,
						roleLevel = 1,
						gateType = game.GATE_TYPE.test,
						roleOut = csvClone(csv.test_battle),
						randSeed = math.random(1, 1000000),
						names = {
							"复仇者联盟",
							"口袋联盟"
						},
						preData = {}
					}
					local var_10_4 = battleEntrance.battleRecord(var_10_3, "unknown", {
						fromRecordFile = true
					}):run()

					if var_10_4.result == "win" then
						var_10_1 = var_10_1 + 1
					elseif var_10_4.result == "fail" then
						var_10_2 = var_10_2 + 1
					end

					print(string.format("[INFO] 当前: %d (%d vs %d)", var_10_0, var_10_1, var_10_2))
					print(string.format("[INFO] RunTime: (%d/%d), Seed: %d", iter_10_0, var_10_0, var_10_3.randSeed))
				end

				print(string.format("[INFO] 总战斗测试次数: %d 其中赢%d次 输%d次", var_10_0, var_10_1, var_10_2))
			end
		}
	})

	local var_2_8 = var_2_6 - 120
	local var_2_9 = var_0_1("界面显示测试", var_2_8):addTo(arg_2_0, 1)

	bind.touch(arg_2_0, var_2_9, {
		methods = {
			ended = function()
				package.loaded["tests.test_view"] = nil

				require("tests.test_view")()
			end
		}
	})
end

function var_0_0.createTestSceneData(arg_12_0)
	gGameModel.role:init({
		_db = {
			yy_endtime = 0,
			id = "1111111",
			level = 99,
			yyhuodongs = {},
			yy_delta = {},
			figures = {},
			pokedex = {},
			skins = {},
			logos = {},
			gate_star = {
				[10102] = {
					star = 3
				},
				[10105] = {
					star = 3
				}
			}
		}
	})

	local var_12_0 = {}

	return {
		roleLevel = 99,
		sceneID = 999999,
		gateFirst = true,
		moduleType = 1,
		randSeed = math.random(1, 1000000),
		talents = {
			{},
			{}
		},
		fightgoVal = {
			0,
			0
		},
		gateType = game.GATE_TYPE.test
	}
end

local var_0_2 = {
	"res/img/dazhaodi.jpg",
	"res/resources/activity/server_open/img_haibao@.png",
	"res/resources/city/friend/panel_image.png",
	"res/resources/common/bg/img_bg2.png",
	"res/resources/battle/end/win/img_bg.png",
	"res/resources/common/bg/img_bg1.png",
	"res/resources/city/gate/map/img_alldqxx.png",
	"res/resources/city/gate/map/img_fqcs.png",
	"res/resources/city/gate/map/img_spcj.png",
	"res/resources/city/gate/map/img_xbxz.png",
	"res/resources/city/gate/map/img_smbl.png",
	"res/resources/city/gate/map/img_llajdhz.png",
	"res/resources/activity/server_open/img_xszk.png",
	"res/resources/common/bg/bg_d.png",
	"res/resources/activity/regain_stamina/img_baofulei@.png"
}

local function var_0_3(arg_13_0)
	if not arg_13_0 then
		return
	end

	return function()
		performWithDelay(gGameUI.uiRoot, function()
			arg_13_0()
		end, 0.1)
	end
end

local function var_0_4(arg_16_0)
	local var_16_0 = require("socket")
	local var_16_1 = table.insert
	local var_16_2 = 100000

	collectgarbage()

	local var_16_3 = collectgarbage("count")

	print("create cc.Node begin", var_16_3)

	local var_16_4 = os.clock()
	local var_16_5 = var_16_0.gettime()
	local var_16_6 = {}

	for iter_16_0 = 1, var_16_2 do
		var_16_1(var_16_6, cc.Node:create():retain())
	end

	local var_16_7 = os.clock()
	local var_16_8 = var_16_0.gettime()
	local var_16_9 = collectgarbage("count")

	print("create cc.Node end", var_16_9, var_16_9 - var_16_3)
	gGameUI:showDialog({
		fontSize = 40,
		align = "left",
		title = string.format("%d create cc.Node", var_16_2),
		content = string.format("clock: %s s\ntime: %s s\nmem: %s K\n", var_16_7 - var_16_4, var_16_8 - var_16_5, var_16_9 - var_16_3)
	})
	performWithDelay(gGameUI.uiRoot, function()
		collectgarbage()

		local var_17_0 = collectgarbage("count")

		print("release cc.Node begin", var_17_0)

		local var_17_1 = os.clock()
		local var_17_2 = var_16_0.gettime()

		for iter_17_0 = 1, var_16_2 do
			var_16_6[iter_17_0]:release()
		end

		var_16_6 = nil

		local var_17_3 = os.clock()
		local var_17_4 = var_16_0.gettime()
		local var_17_5 = collectgarbage("count")

		print("release cc.Node end", var_17_5, var_17_5 - var_17_0)
		gGameUI:showDialog({
			fontSize = 40,
			align = "left",
			title = string.format("%d release cc.Node", var_16_2),
			content = string.format("clock: %s s\ntime: %s s\nmem: %s K\n", var_17_3 - var_17_1, var_17_4 - var_17_2, var_17_5 - var_17_0),
			cb = var_0_3(arg_16_0),
			closeCb = var_0_3(arg_16_0)
		})
	end, 1)
end

local function var_0_5(arg_18_0)
	local var_18_0 = require("socket")

	for iter_18_0, iter_18_1 in ipairs(var_0_2) do
		display.textureCache:removeTextureForKey(iter_18_1)
	end

	local var_18_1 = os.clock()
	local var_18_2 = var_18_0.gettime()
	local var_18_3 = #var_0_2

	for iter_18_2, iter_18_3 in ipairs(var_0_2) do
		display.textureCache:addImageAsync(iter_18_3, function()
			var_18_3 = var_18_3 - 1

			if var_18_3 <= 0 then
				local var_19_0 = os.clock()
				local var_19_1 = var_18_0.gettime()

				gGameUI:showDialog({
					fontSize = 40,
					title = "async load image",
					align = "left",
					content = string.format("clock: %s s\ntime: %s s\n", var_19_0 - var_18_1, var_19_1 - var_18_2),
					cb = var_0_3(arg_18_0),
					closeCb = var_0_3(arg_18_0)
				})
			end
		end)
	end
end

function var_0_0.showBenchmark(arg_20_0)
	print("---- showBenchmark ----")

	local var_20_0 = require("socket")
	local var_20_1 = table.insert
	local var_20_2 = ymrand.random

	for iter_20_0, iter_20_1 in ipairs(var_0_2) do
		var_0_2[iter_20_0] = display.textureCache:checkFullPath(iter_20_1)
	end

	for iter_20_2, iter_20_3 in ipairs(var_0_2) do
		display.textureCache:removeTextureForKey(iter_20_3)
	end

	local var_20_3 = os.clock()
	local var_20_4 = var_20_0.gettime()

	for iter_20_4, iter_20_5 in ipairs(var_0_2) do
		display.textureCache:addImage(iter_20_5)
	end

	local var_20_5 = os.clock()
	local var_20_6 = var_20_0.gettime()

	gGameUI:showDialog({
		fontSize = 40,
		title = "sync load image",
		align = "left",
		content = string.format("clock: %s s\ntime: %s s\n", var_20_5 - var_20_3, var_20_6 - var_20_4)
	})

	local var_20_7 = 10000000
	local var_20_8, var_20_9 = os.clock(), var_20_0.gettime()
	local var_20_10

	for iter_20_6 = 1, var_20_7 do
		local var_20_11 = var_20_7 / iter_20_6
	end

	local var_20_12, var_20_13 = os.clock(), var_20_0.gettime()

	gGameUI:showDialog({
		fontSize = 40,
		align = "left",
		title = string.format("%d float division", var_20_7),
		content = string.format("clock: %s s\ntime: %s s\n", var_20_12 - var_20_8, var_20_13 - var_20_9)
	})

	local var_20_14 = 1000000
	local var_20_15, var_20_16 = os.clock(), var_20_0.gettime()

	for iter_20_7 = 1, var_20_14 do
		var_20_2()
	end

	local var_20_17, var_20_18 = os.clock(), var_20_0.gettime()

	gGameUI:showDialog({
		fontSize = 40,
		align = "left",
		title = string.format("%d ymrand calculate", var_20_14),
		content = string.format("clock: %s s\ntime: %s s\n", var_20_17 - var_20_15, var_20_18 - var_20_16)
	})

	local var_20_19 = 1000000

	collectgarbage()

	local var_20_20 = collectgarbage("count")

	print("create table begin", var_20_20)

	local var_20_21, var_20_22 = os.clock(), var_20_0.gettime()
	local var_20_23 = {}

	for iter_20_8 = 1, var_20_19 do
		var_20_1(var_20_23, {})
	end

	local var_20_24, var_20_25 = os.clock(), var_20_0.gettime()
	local var_20_26 = collectgarbage("count")

	print("create table end", var_20_26, var_20_26 - var_20_20)
	gGameUI:showDialog({
		fontSize = 40,
		align = "left",
		title = string.format("%d create table", var_20_19),
		content = string.format("clock: %s s\ntime: %s s\nmem: %s K\n", var_20_24 - var_20_21, var_20_25 - var_20_22, var_20_26 - var_20_20)
	})

	local var_20_27, var_20_28 = os.clock(), var_20_0.gettime()
	local var_20_29

	collectgarbage()

	local var_20_30, var_20_31 = os.clock(), var_20_0.gettime()
	local var_20_32 = collectgarbage("count")

	print("gc table end", var_20_32, var_20_26 - var_20_32)
	gGameUI:showDialog({
		fontSize = 40,
		align = "left",
		title = string.format("%d gc table", var_20_19),
		content = string.format("clock: %s s\ntime: %s s\nmem: %s K\n", var_20_30 - var_20_27, var_20_31 - var_20_28, var_20_26 - var_20_32)
	})
	var_0_4(var_0_5)
end

return function(arg_21_0)
	for iter_21_0, iter_21_1 in pairs(var_0_0) do
		arg_21_0[iter_21_0] = iter_21_1
	end
end
