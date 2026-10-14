local function var_0_0(arg_1_0, arg_1_1)
	local var_1_0 = {}
	local var_1_1 = 1
	local var_1_2 = arg_1_1 or #arg_1_0

	while #arg_1_0 ~= 0 do
		local var_1_3 = math.random(0, #arg_1_0)

		if arg_1_0[var_1_3] ~= nil then
			var_1_0[var_1_1] = arg_1_0[var_1_3]

			table.remove(arg_1_0, var_1_3)

			var_1_1 = var_1_1 + 1

			if var_1_2 < var_1_1 then
				break
			end
		end
	end

	return var_1_0
end

local function var_0_1(arg_2_0)
	local var_2_0 = 0
	local var_2_1 = csv.union_qa.qa_type
	local var_2_2 = csv.union_qa.qa_base

	for iter_2_0, iter_2_1 in ipairs(arg_2_0) do
		var_2_0 = var_2_0 + var_2_1[iter_2_1.type].score * var_2_2[iter_2_0].multiple
	end

	return var_2_0
end

local var_0_2 = {
	NORMAL = 1,
	SEEPICTURE = 4,
	GAME = 5,
	DIFFICULT = 3,
	MEDIUM = 2
}
local var_0_3 = {
	"A",
	"B",
	"C",
	"D"
}
local var_0_4 = {
	TRUE = 1,
	FAIL = 2,
	NONE = 0
}
local var_0_5 = {
	MOSAIC = 1,
	BLINK = 0.3,
	MESS = 0.4
}
local var_0_6 = {
	ALL = 0.5,
	GOLD = 0.1,
	RMB = 0.25
}
local var_0_7 = {
	{
		res = "config/big_hero/standby/img_250_fw@.png",
		x = 195,
		y = 440
	},
	{
		res = "config/big_hero/standby/img_250_fw@.png",
		x = 595,
		y = 440
	},
	{
		res = "config/big_hero/standby/img_250_fw@.png",
		x = 1000,
		y = 440
	},
	{
		res = "config/big_hero/standby/img_250_fw@.png",
		x = 1405,
		y = 440
	},
	{
		res = "config/big_hero/standby/img_250_fw@.png",
		x = 195,
		y = 130
	},
	{
		res = "config/big_hero/standby/img_250_fw@.png",
		x = 595,
		y = 130
	},
	{
		res = "config/big_hero/standby/img_250_fw@.png",
		x = 1000,
		y = 130
	},
	{
		res = "config/big_hero/standby/img_250_fw@.png",
		x = 1405,
		y = 130
	}
}
local var_0_8 = 250
local var_0_9 = cc.load("mvc").ViewBase
local var_0_10 = class("UnionAnswerProblemView", var_0_9)

var_0_10.RESOURCE_FILENAME = "union_answer_problem.json"
var_0_10.RESOURCE_BINDING = {
	bottomPanel = "bottomPanel",
	topPanel = "topPanel",
	["bottomPanel.text"] = "bottomPanelText",
	["panel2.item"] = "item2",
	panel3 = "panel3",
	["panel3.item"] = "item3",
	["panel3.title"] = "title3",
	["panel3.text"] = "seeTip",
	panel4 = "panel4",
	["panel1.item"] = "item1",
	["topPanel.textNum1"] = "textNum1",
	["panel3.cardPanel"] = "cardPanel",
	panelBg = "panelBg",
	["panel2.title"] = "title2",
	["topPanel.textNum"] = "textNum",
	bg = "bg",
	panel1 = "panel1",
	panel2 = "panel2",
	["panel1.title"] = "title1",
	["topPanel.time"] = "timeText",
	endPanel = "endPanel",
	["bottomPanel.bagPanel"] = "bagPanel",
	["bottomPanel.sureBtn"] = {
		varname = "sureBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("submitAnswer")
			}
		}
	},
	["bottomPanel.sureBtn.text"] = {
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
	["panel1.list"] = {
		varname = "list1",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("answerData1"),
				item = bindHelper.self("item1"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("icon", "bg", "name")

					var_3_0.bg:get("txt"):text(var_0_3[arg_3_2])
					adapt.setTextScaleWithWidth(var_3_0.name, arg_3_3.name, 1250)

					if arg_3_3.state == var_0_4.NONE then
						var_3_0.icon:hide()
					elseif arg_3_3.state == var_0_4.TRUE then
						var_3_0.icon:show()
					else
						var_3_0.icon:texture("city/union/answer/logo_cw.png")
					end

					if arg_3_3.fontType == 1 then
						var_3_0.name:setColor(cc.c3b(255, 230, 64))
						var_3_0.bg:texture("city/card/gem/btn_yq_h.png")
						text.addEffect(var_3_0.bg:get("txt"), {
							color = ui.COLORS.NORMAL.WHITE
						})
					else
						var_3_0.name:setColor(cc.c3b(255, 252, 237))
						var_3_0.bg:texture("city/card/gem/btn_yq_b.png")
						text.addEffect(var_3_0.bg:get("txt"), {
							color = ui.COLORS.NORMAL.RED
						})
					end

					arg_3_1:setTouchEnabled(arg_3_3.canTouch)
					bind.touch(arg_3_0, arg_3_1, {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_2, arg_3_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	["panel2.list"] = {
		varname = "list2",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("answerData2"),
				item = bindHelper.self("item2"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("icon", "bg", "name")

					var_4_0.bg:get("txt"):text(var_0_3[arg_4_2])
					var_4_0.name:text(csv.unit[arg_4_3.name].name)

					if arg_4_3.state == var_0_4.NONE then
						var_4_0.icon:hide()
					elseif arg_4_3.state == var_0_4.TRUE then
						var_4_0.icon:show()
					else
						var_4_0.icon:texture("city/union/answer/logo_cw.png")
					end

					if arg_4_3.fontType == 1 then
						var_4_0.name:setColor(cc.c3b(255, 230, 64))
						var_4_0.bg:texture("city/card/gem/btn_yq_h.png")
						text.addEffect(var_4_0.bg:get("txt"), {
							color = ui.COLORS.NORMAL.WHITE
						})
					else
						var_4_0.name:setColor(cc.c3b(255, 252, 237))
						var_4_0.bg:texture("city/card/gem/btn_yq_b.png")
						text.addEffect(var_4_0.bg:get("txt"), {
							color = ui.COLORS.NORMAL.RED
						})
					end

					arg_4_1:setTouchEnabled(arg_4_3.canTouch)
					bind.touch(arg_4_0, arg_4_1, {
						methods = {
							ended = functools.partial(arg_4_0.clickCell, arg_4_2, arg_4_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	["panel3.list"] = {
		varname = "list3",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("answerData3"),
				item = bindHelper.self("item3"),
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = arg_5_1:multiget("icon", "bg", "iconBg")

					var_5_0.bg:get("txt"):text(var_0_3[arg_5_2])
					var_5_0.iconBg:get("icon"):texture(csv.unit[arg_5_3.name].show)

					local var_5_1 = math.min(1, 300 / var_5_0.iconBg:get("icon"):size().height)

					var_5_0.iconBg:get("icon"):scale(var_5_1 * 0.5)

					if arg_5_3.state == var_0_4.NONE then
						var_5_0.icon:hide()
					elseif arg_5_3.state == var_0_4.TRUE then
						var_5_0.icon:show()
					else
						var_5_0.icon:texture("city/union/answer/logo_cw.png")
					end

					if arg_5_3.fontType == 1 then
						var_5_0.bg:texture("city/card/gem/btn_yq_h.png")
						text.addEffect(var_5_0.bg:get("txt"), {
							color = ui.COLORS.NORMAL.WHITE
						})
					else
						var_5_0.bg:texture("city/card/gem/btn_yq_b.png")
						text.addEffect(var_5_0.bg:get("txt"), {
							color = ui.COLORS.NORMAL.RED
						})
					end

					arg_5_1:setTouchEnabled(arg_5_3.canTouch)
					bind.touch(arg_5_0, arg_5_1, {
						methods = {
							ended = functools.partial(arg_5_0.clickCell, arg_5_2, arg_5_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	}
}

function var_0_10.onCreate(arg_6_0, arg_6_1)
	arg_6_0.topUI = gGameUI.topuiManager:createView("union_answer", arg_6_0, {
		onClose = arg_6_0:createHandler("onClose")
	}):init({
		subTitle = "POKEMONANSWER",
		title = gLanguageCsv.pokemonAnswer
	})

	arg_6_0:enableSchedule()

	local var_6_0, var_6_1, var_6_2, var_6_3, var_6_4 = arg_6_1()

	arg_6_0.problemData = var_6_0.questions
	arg_6_0.roleData = var_6_1
	arg_6_0.unionData = var_6_2
	arg_6_0.myRoleData = var_6_3
	arg_6_0.myUnionData = var_6_4

	arg_6_0:initModel()

	local var_6_5 = csv.unit
	local var_6_6 = csv.union_qa.qa_type
	local var_6_7 = csv.union_qa.qa_base

	arg_6_0.inGame = false

	local var_6_8 = ""

	arg_6_0.allGrade = var_0_1(arg_6_0.problemData)

	local function var_6_9(arg_7_0, arg_7_1, arg_7_2)
		local var_7_0 = arg_7_2 or 0

		arg_7_1:removeAllChildren()
		rich.createWithWidth(arg_7_0, 50, nil, 1237):addTo(arg_7_1, 10):anchorPoint(cc.p(0, 0.5)):xy(0, var_7_0):formatText()
	end

	idlereasy.any({
		arg_6_0.problemIndex,
		arg_6_0.choice,
		arg_6_0.tabNum
	}, function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
		local var_8_0 = {}

		arg_6_0.sureBtn:hide()

		local var_8_1 = arg_6_0.problemData[arg_8_1]

		if var_8_1 then
			if var_8_1.type <= var_0_2.DIFFICULT then
				arg_6_0.panel1:show()
				arg_6_0.panel2:hide()
				arg_6_0.panel3:hide()

				if #var_8_1.question <= 60 then
					arg_6_0.panel1:get("title"):x(221)
				else
					arg_6_0.panel1:get("title"):x(47)
				end

				if var_6_7[arg_8_1].multiple == 1 then
					var_6_8 = arg_8_1 .. "." .. var_8_1.question .. "   " .. "(" .. var_6_6[var_8_1.type].score .. gLanguageCsv.gradeText .. ")"
				else
					var_6_8 = arg_8_1 .. "." .. var_8_1.question .. "   " .. "(" .. var_6_6[var_8_1.type].score .. gLanguageCsv.gradeText .. ")" .. "#C0xFFE640#" .. " (" .. gLanguageCsv.score .. "x" .. var_6_7[arg_8_1].multiple .. ")"
				end

				var_6_9(var_6_8, arg_6_0.panel1:get("title"), 25)

				var_8_0 = {
					{
						fontType = 0,
						state = 0,
						canTouch = true,
						id = var_8_1.questionID,
						name = var_8_1.choices[1]
					},
					{
						fontType = 0,
						state = 0,
						canTouch = true,
						id = var_8_1.questionID,
						name = var_8_1.choices[2]
					},
					{
						fontType = 0,
						state = 0,
						canTouch = true,
						id = var_8_1.questionID,
						name = var_8_1.choices[3]
					},
					{
						fontType = 0,
						state = 0,
						canTouch = true,
						id = var_8_1.questionID,
						name = var_8_1.choices[4]
					}
				}

				if arg_8_3 ~= 0 then
					var_8_0[arg_8_3].fontType = 1

					arg_6_0.sureBtn:show()
				end

				arg_6_0.answerData1:update(var_8_0)

				if arg_6_0.inGame == false then
					arg_6_0:initCountDown(var_8_1)

					arg_6_0.inGame = true
				end

				arg_6_0.list1:setTouchEnabled(true)
			elseif var_8_1.type == var_0_2.SEEPICTURE then
				arg_6_0.panel1:hide()
				arg_6_0.panel2:show()
				arg_6_0.panel3:hide()

				if var_6_7[arg_8_1].multiple == 1 then
					var_6_8 = arg_8_1 .. "." .. gLanguageCsv.pokemonAnswerQuestion2 .. "   " .. "(" .. var_6_6[var_8_1.type].score .. gLanguageCsv.gradeText .. ")"
				else
					var_6_8 = arg_8_1 .. "." .. gLanguageCsv.pokemonAnswerQuestion2 .. "   " .. "(" .. var_6_6[var_8_1.type].score .. gLanguageCsv.gradeText .. ")" .. "#C0xFFE640#" .. " (" .. gLanguageCsv.score .. "x" .. var_6_7[arg_8_1].multiple .. ")"
				end

				var_6_9(var_6_8, arg_6_0.panel2:get("title"))

				arg_6_0.picture = var_6_5[var_8_1.question].show

				arg_6_0.panel2:get("iconBg.icon"):texture(var_6_5[var_8_1.question].show)

				local var_8_2 = cc.GLProgram:create("shader/ver_shader.vsh", "shader/color.fsh")

				var_8_2:link()
				var_8_2:updateUniforms()

				local var_8_3 = cc.GLProgramState:getOrCreateWithGLProgram(var_8_2)

				var_8_3:setUniformVec3("color", cc.vec3(0.19607843137254902, 0.2784313725490196, 0.24313725490196078, 1))
				arg_6_0.panel2:get("iconBg.icon"):setGLProgramState(var_8_3)

				var_8_0 = {
					{
						canTouch = true,
						fontType = 0,
						state = 0,
						name = var_8_1.choices[1]
					},
					{
						canTouch = true,
						fontType = 0,
						state = 0,
						name = var_8_1.choices[2]
					},
					{
						canTouch = true,
						fontType = 0,
						state = 0,
						name = var_8_1.choices[3]
					},
					{
						canTouch = true,
						fontType = 0,
						state = 0,
						name = var_8_1.choices[4]
					}
				}

				if arg_8_3 ~= 0 then
					var_8_0[arg_8_3].fontType = 1

					arg_6_0.sureBtn:show()
				end

				arg_6_0.answerData2:update(var_8_0)

				if arg_6_0.inGame == false then
					arg_6_0:initCountDown(var_8_1)

					arg_6_0.inGame = true
				end

				arg_6_0.list2:setTouchEnabled(true)
			else
				arg_6_0.panel1:hide()
				arg_6_0.panel2:hide()
				arg_6_0.panel3:show()
				arg_6_0.list3:setTouchEnabled(true)

				local var_8_4 = csv.union_qa.qa_game1[var_8_1.gameID]

				if var_6_7[arg_8_1].multiple == 1 then
					var_6_8 = arg_8_1 .. "." .. gLanguageCsv.pokemonAnswerQuestion3 .. "   " .. "(" .. var_6_6[var_8_1.type].score .. gLanguageCsv.gradeText .. ")"
				else
					var_6_8 = arg_8_1 .. "." .. gLanguageCsv.pokemonAnswerQuestion3 .. "   " .. "(" .. var_6_6[var_8_1.type].score .. gLanguageCsv.gradeText .. ")" .. "#C0xFFE640#" .. " (" .. gLanguageCsv.score .. "x" .. var_6_7[arg_8_1].multiple .. ")"
				end

				var_6_9(var_6_8, arg_6_0.panel3:get("title"))

				for iter_8_0 = 1, var_8_4.displayNum do
					var_0_7[iter_8_0].res = var_6_5[var_8_1.display[iter_8_0]].show
				end

				for iter_8_1 = 1, var_8_4.choiceNum do
					if iter_8_1 == arg_8_3 then
						table.insert(var_8_0, {
							canTouch = true,
							fontType = 1,
							state = 0,
							name = var_8_1.choices[iter_8_1]
						})
						arg_6_0.sureBtn:show()
					else
						table.insert(var_8_0, {
							canTouch = true,
							fontType = 0,
							state = 0,
							name = var_8_1.choices[iter_8_1]
						})
					end
				end

				arg_6_0.answerData3:update(var_8_0)
			end
		else
			arg_6_0.onClose(true)
		end
	end)
	idlereasy.when(arg_6_0.times, function(arg_9_0, arg_9_1)
		if arg_9_1 == 0 then
			arg_6_0:submitAnswer()
		end
	end)

	local var_6_10 = #arg_6_0.problemData

	idlereasy.when(arg_6_0.problemIndex, function(arg_10_0, arg_10_1)
		arg_6_0.bottomPanelText:text(arg_10_1 .. "/" .. var_6_10)
	end)
end

function var_0_10.initModel(arg_11_0)
	arg_11_0.problemIndex = idler.new(0)
	arg_11_0.choice = idler.new(0)
	arg_11_0.tabNum = idler.new(0)
	arg_11_0.times = idler.new(15)
	arg_11_0.counTtime = 0
	arg_11_0.myGrade = 0

	arg_11_0:getGrade()

	arg_11_0.answerData1 = idlers.new({})
	arg_11_0.answerData2 = idlers.new({})
	arg_11_0.answerData3 = idlers.new({})
	arg_11_0.isQuit = false
	arg_11_0.needEraser = false

	arg_11_0:startAnswer()

	arg_11_0.rightNum = 0
	arg_11_0.bagSpineState = 0
	arg_11_0.messIndex = 0
	arg_11_0.mosaicSizeX = 3
	arg_11_0.mosaicSizeY = 3
	arg_11_0.giftData = {}
	arg_11_0.bagSpine = widget.addAnimationByKey(arg_11_0.bagPanel, "union_answer/beibao.skel", "effect", "effect_loop", 999):xy(-860, 650):scale(2)
	arg_11_0.timeScale = 1
end

function var_0_10.startAnswer(arg_12_0)
	arg_12_0.problemIndex:set(arg_12_0.problemIndex:read() + 1)
	arg_12_0.tabNum:set(0)
	gGameApp:requestServer("/game/union/qa/answer/start", function(arg_13_0)
		return
	end, arg_12_0.problemIndex:read())
end

function var_0_10.showGameRule(arg_14_0)
	local var_14_0 = userDefault.getForeverLocalKey("gameRule", false)
	local var_14_1 = arg_14_0.problemData[arg_14_0.problemIndex:read() + 1]

	local function var_14_2()
		if not arg_14_0.isEnding then
			gGameApp:requestServer("/game/union/qa/answer/start", function(arg_16_0)
				return
			end, arg_14_0.problemIndex:read())
			arg_14_0:showPanel(var_14_1)
		end
	end

	if var_14_0 == false then
		arg_14_0.panel3:hide()
		arg_14_0.panel4:show()

		arg_14_0.isEraser = true

		performWithDelay(arg_14_0.panel4, function()
			arg_14_0.isEraser = false

			arg_14_0.panel4:hide()
			arg_14_0.panel3:show()
			arg_14_0.problemIndex:set(arg_14_0.problemIndex:read() + 1)
			arg_14_0.tabNum:set(0)

			if arg_14_0.inGame == true then
				var_14_2()
			else
				arg_14_0:seeTime(var_14_1)
			end

			userDefault.setForeverLocalKey("gameRule", true)
		end, 5 / arg_14_0.timeScale)
	else
		arg_14_0.problemIndex:set(arg_14_0.problemIndex:read() + 1)
		arg_14_0.tabNum:set(0)

		if arg_14_0.inGame == true then
			var_14_2()
		else
			arg_14_0:seeTime(var_14_1)
		end
	end
end

function var_0_10.submitAnswer(arg_18_0)
	local var_18_0 = arg_18_0.problemIndex:read()

	if arg_18_0.lastProblemIndex == var_18_0 then
		return
	end

	arg_18_0.lastProblemIndex = var_18_0

	arg_18_0.topPanel:unscheduleUpdate()

	arg_18_0.inGame = false

	gGameApp:requestServer("/game/union/qa/answer/submit", function(arg_19_0)
		arg_18_0:showAnswer()
		arg_18_0.sureBtn:hide()
		arg_18_0:getGrade(arg_19_0.view)
	end, var_18_0, arg_18_0.tabNum:read())
end

function var_0_10.onTabClick(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	arg_20_0.tabNum:set(arg_20_2)
end

function var_0_10.showAnswer(arg_21_0)
	arg_21_0.isShowAnswer = true

	local var_21_0 = {}
	local var_21_1 = arg_21_0.problemData[arg_21_0.problemIndex:read()]

	for iter_21_0 = 1, #var_21_1.choices do
		if iter_21_0 == var_21_1.answer then
			if iter_21_0 == arg_21_0.tabNum:read() then
				table.insert(var_21_0, {
					canTouch = false,
					fontType = 1,
					state = 1,
					name = var_21_1.choices[iter_21_0]
				})

				arg_21_0.rightNum = arg_21_0.rightNum + 1
			else
				table.insert(var_21_0, {
					canTouch = false,
					fontType = 0,
					state = 1,
					name = var_21_1.choices[iter_21_0]
				})
			end
		elseif iter_21_0 == arg_21_0.tabNum:read() then
			table.insert(var_21_0, {
				canTouch = false,
				fontType = 1,
				state = 2,
				name = var_21_1.choices[iter_21_0]
			})
		else
			table.insert(var_21_0, {
				canTouch = false,
				fontType = 0,
				state = 0,
				name = var_21_1.choices[iter_21_0]
			})
		end
	end

	local var_21_2

	if var_21_1.type <= var_0_2.DIFFICULT then
		arg_21_0.answerData1:update(var_21_0)
		arg_21_0.list1:setTouchEnabled(false)

		local var_21_3 = arg_21_0.panel1

		arg_21_0:endShow(var_21_3)
	elseif var_21_1.type == var_0_2.SEEPICTURE then
		arg_21_0.answerData2:update(var_21_0)
		arg_21_0.list2:setTouchEnabled(false)

		local var_21_4 = csv.unit
		local var_21_5 = arg_21_0.problemData[arg_21_0.problemIndex:read()]

		cache.setShader(arg_21_0.panel2:get("iconBg.icon"), false, "normal")

		local var_21_6 = arg_21_0.panel2

		arg_21_0:endShow(var_21_6)
	else
		arg_21_0.answerData3:update(var_21_0)

		local var_21_7 = arg_21_0.panel3

		arg_21_0.list3:setTouchEnabled(false)
		arg_21_0:endGame(var_21_7)
	end
end

function var_0_10.endShow(arg_22_0, arg_22_1)
	if arg_22_0.isQuit == false then
		arg_22_0.isEraser = true

		performWithDelay(arg_22_0.panel4, function()
			arg_22_0:openEraser(arg_22_1)
		end, 2 / arg_22_0.timeScale)
	else
		arg_22_0.needEraser = true
	end
end

function var_0_10.getGrade(arg_24_0, arg_24_1)
	if not arg_24_1 then
		arg_24_0.textNum:text(0)

		return
	end

	local var_24_0 = arg_24_0.myGrade

	arg_24_0.myGrade = arg_24_0.myGrade + arg_24_1.result.score

	if arg_24_1.result.score > 0 then
		uiEasy.storageTo({
			targetPos = cc.p(2300 + display.uiOrigin.x, 240)
		})

		if arg_24_0.myGrade >= arg_24_0.allGrade * var_0_6.GOLD and arg_24_0.myGrade <= arg_24_0.allGrade * var_0_6.RMB and arg_24_0.bagSpineState == 0 then
			arg_24_0.bagSpine:play("effect1")
			arg_24_0.bagSpine:addPlay("effect1_loop")

			arg_24_0.bagSpineState = 1
		elseif arg_24_0.myGrade >= arg_24_0.allGrade * var_0_6.RMB and arg_24_0.myGrade <= arg_24_0.allGrade * var_0_6.ALL and arg_24_0.bagSpineState <= 1 then
			arg_24_0.bagSpine:play("effect2")
			arg_24_0.bagSpine:addPlay("effect2_loop")

			arg_24_0.bagSpineState = 2
		elseif arg_24_0.myGrade >= arg_24_0.allGrade * var_0_6.ALL and arg_24_0.bagSpineState <= 2 then
			arg_24_0.bagSpine:play("effect3")
			arg_24_0.bagSpine:addPlay("effect3_loop")

			arg_24_0.bagSpineState = 3
		end
	end

	uiEasy.digitRollAction(arg_24_0.textNum, var_24_0, arg_24_0.myGrade, nil, arg_24_0.timeScale, arg_24_0.textNum1)
	arg_24_0.textNum1:show()
	arg_24_0.textNum1:text("+" .. arg_24_1.result.score)
end

function var_0_10.showPanel(arg_25_0, arg_25_1)
	if arg_25_0.inGame == true then
		return
	end

	if arg_25_1.gameID == 1 then
		arg_25_0:gameMess()
	elseif arg_25_1.gameID == 2 then
		arg_25_0:mosaic()
	else
		arg_25_0:blink()
	end

	arg_25_0:initCountDown(arg_25_1)

	arg_25_0.inGame = true

	arg_25_0.sureBtn:setTouchEnabled(true)
end

function var_0_10.seeTime(arg_26_0, arg_26_1)
	arg_26_0.sureBtn:setTouchEnabled(false)

	if arg_26_0.countSchedule then
		return
	end

	for iter_26_0 = 1, 8 do
		arg_26_0.panel3:get("cardBg" .. iter_26_0):hide()
	end

	local var_26_0 = 0
	local var_26_1 = 250
	local var_26_2 = 160
	local var_26_3 = 0

	arg_26_0.seeTip:scheduleUpdate(function(arg_27_0)
		if arg_26_0.timeScale > 1 then
			var_26_0 = var_26_0 + 1 * arg_26_0.timeScale
		else
			var_26_0 = var_26_0 + 1
		end

		local var_27_0 = math.modf(var_26_0 / 60)

		if var_27_0 == 1 then
			arg_26_0.seeTip:text(3)

			var_26_1 = var_26_1 - 3
			var_26_2 = var_26_2 + 2

			arg_26_0.seeTip:setFontSize(var_26_2)
			arg_26_0.seeTip:setOpacity(var_26_1)

			var_26_3 = var_27_0
		elseif var_27_0 == 2 then
			if var_26_3 ~= var_27_0 then
				var_26_3 = var_27_0
				var_26_1 = 250
				var_26_2 = 160
			end

			arg_26_0.seeTip:text(2)

			var_26_1 = var_26_1 - 3
			var_26_2 = var_26_2 + 2

			arg_26_0.seeTip:setFontSize(var_26_2)
			arg_26_0.seeTip:setOpacity(var_26_1)
		elseif var_27_0 == 3 then
			if var_26_3 ~= var_27_0 then
				var_26_3 = var_27_0
				var_26_1 = 250
				var_26_2 = 160
			end

			arg_26_0.seeTip:text(1)

			var_26_1 = var_26_1 - 3
			var_26_2 = var_26_2 + 2

			arg_26_0.seeTip:setFontSize(var_26_2)
			arg_26_0.seeTip:setOpacity(var_26_1)
		elseif var_27_0 >= 4 then
			arg_26_0.seeTip:hide()

			for iter_27_0 = 1, 8 do
				arg_26_0.panel3:get("cardBg" .. iter_27_0):show()
			end

			arg_26_0.seeTip:unscheduleUpdate()

			if not arg_26_0.isEnding then
				gGameApp:requestServer("/game/union/qa/answer/start", function(arg_28_0)
					return
				end, arg_26_0.problemIndex:read())
				arg_26_0:showPanel(arg_26_1)
			end

			arg_26_0.countSchedule = nil
		end
	end)
end

function var_0_10.initCountDown(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_2 or 0

	arg_29_0.counTtime = csv.union_qa.qa_type[arg_29_1.type].limitTime - var_29_0

	local var_29_1 = time.getTime() + arg_29_0.counTtime - 1

	arg_29_0.times:set(15)
	arg_29_0.topPanel:scheduleUpdate(function(arg_30_0)
		arg_29_0.counTtime = var_29_1 - time.getTime()

		if arg_29_0.counTtime < 0 then
			arg_29_0.times:set(0)
			arg_29_0.topPanel:unscheduleUpdate()
		else
			arg_29_0.timeText:text(arg_29_0.counTtime)
		end
	end)
end

function var_0_10.initTimeScale(arg_31_0)
	local var_31_0 = os.time()
	local var_31_1 = 0

	arg_31_0.bg:scheduleUpdate(function(arg_32_0)
		var_31_1 = var_31_1 + arg_32_0

		if var_31_1 >= 1 then
			local var_32_0 = os.time()
			local var_32_1 = var_32_0 - var_31_0 == 0 and 1 or var_32_0 - var_31_0

			arg_31_0.timeScale = var_32_1 / var_31_1
			var_31_0 = var_32_0
			var_31_1 = 0
		end
	end)
end

function var_0_10.gameMess(arg_33_0)
	local var_33_0 = {}

	arg_33_0.cardPanel:removeAllChildren()

	local var_33_1 = 2
	local var_33_2 = var_0_7[2].x - var_0_7[1].x
	local var_33_3 = var_0_7[1].y - var_0_7[5].y

	for iter_33_0, iter_33_1 in ipairs(var_0_7) do
		local var_33_4 = iter_33_1.res

		for iter_33_2 = 0, var_33_1 * var_33_1 - 1 do
			local var_33_5 = iter_33_1.res
			local var_33_6 = (iter_33_2 + iter_33_0) % 8
			local var_33_7, var_33_8 = math.modf(var_33_6 / 4)
			local var_33_9 = var_0_7[5].x - iter_33_1.x + var_33_8 * 4 * var_33_2
			local var_33_10 = var_0_7[5].y - iter_33_1.y + var_33_7 * var_33_3
			local var_33_11 = cc.Sprite:create(var_33_5):xy(iter_33_1.x, iter_33_1.y)

			if var_33_11:size().height > var_0_8 then
				var_33_11:size({
					height = var_0_8,
					width = var_0_8 * var_33_11:size().width / var_33_11:size().height
				})
			end

			local var_33_12 = var_33_11:size()
			local var_33_13 = ccui.Scale9Sprite:create()

			var_33_13:initWithFile(cc.rect(0, 0, 0, 0), "city/union/answer/box_character2.png")
			var_33_13:size(var_33_12):xy(var_33_11:xy())

			if iter_33_2 == 0 then
				var_33_13:anchorPoint(1, 0)
			elseif iter_33_2 == 1 then
				var_33_13:anchorPoint(1, 1)
			elseif iter_33_2 == 2 then
				var_33_13:anchorPoint(0, 0)
			else
				var_33_13:anchorPoint(0, 1)
			end

			local var_33_14 = cc.ClippingNode:create(var_33_13):setAlphaThreshold(0.1):add(var_33_11):addTo(arg_33_0.cardPanel, 3):xy(var_33_9, var_33_10)

			table.insert(var_33_0, {
				imgBg = var_33_14,
				x = iter_33_1.x,
				y = iter_33_1.y
			})
		end
	end

	arg_33_0.imgList = var_0_0(var_33_0)

	arg_33_0:messSchedule(var_0_5.MESS)
end

function var_0_10.messSchedule(arg_34_0, arg_34_1)
	arg_34_0.panel3:unscheduleUpdate()

	local var_34_0 = 0

	arg_34_0.panel3:scheduleUpdate(function(arg_35_0)
		var_34_0 = var_34_0 + 0.017

		if var_34_0 > arg_34_1 then
			arg_34_0.messIndex = arg_34_0.messIndex + 1

			if arg_34_0.messIndex > #arg_34_0.imgList then
				arg_34_0:endShow(arg_34_0.panel3)
				arg_34_0.panel3:unscheduleUpdate()

				arg_34_0.isEnding = false
			end

			if arg_34_0.imgList[arg_34_0.messIndex] then
				arg_34_0.imgList[arg_34_0.messIndex].imgBg:xy(0, 0)
			end

			var_34_0 = 0
		end
	end)
end

function var_0_10.mosaic(arg_36_0)
	arg_36_0.cardPanel:removeAllChildren()

	local var_36_0 = {}

	for iter_36_0, iter_36_1 in ipairs(var_0_7) do
		local var_36_1 = cc.Sprite:create(iter_36_1.res):addTo(arg_36_0.cardPanel, 3):xy(iter_36_1.x, iter_36_1.y)

		if var_36_1:size().height > var_0_8 then
			var_36_1:size({
				height = var_0_8,
				width = var_0_8 * var_36_1:size().width / var_36_1:size().height
			})
		end

		table.insert(var_36_0, var_36_1)
	end

	local var_36_2 = cc.GLProgram:createWithFilenames("shader/ver_shader.vsh", "shader/mosaic_shader.fsh")

	var_36_2:link()
	var_36_2:updateUniforms()

	arg_36_0.mosaicState = cc.GLProgramState:getOrCreateWithGLProgram(var_36_2)

	table.insert(var_36_0, imgBg)

	arg_36_0.mosaicTable = var_36_0
	arg_36_0.mosaicNum = 2

	arg_36_0:mosaicSchedule(var_0_5.MOSAIC)
end

function var_0_10.mosaicSchedule(arg_37_0, arg_37_1)
	arg_37_0.panel3:unscheduleUpdate()

	local var_37_0 = arg_37_1

	arg_37_0.panel3:scheduleUpdate(function(arg_38_0)
		var_37_0 = var_37_0 + 0.017

		if var_37_0 > arg_37_1 then
			arg_37_0.mosaicSizeX = arg_37_0.mosaicSizeX + arg_37_0.mosaicNum
			arg_37_0.mosaicSizeY = arg_37_0.mosaicSizeY + arg_37_0.mosaicNum

			arg_37_0.mosaicState:setUniformFloat("mosaicSizeX", arg_37_0.mosaicSizeX)
			arg_37_0.mosaicState:setUniformFloat("mosaicSizeY", arg_37_0.mosaicSizeY)

			for iter_38_0, iter_38_1 in ipairs(arg_37_0.mosaicTable) do
				if arg_37_0.mosaicSizeX > 1 then
					iter_38_1:setGLProgramState(arg_37_0.mosaicState)
				end
			end

			if arg_37_0.mosaicSizeX >= 33 then
				arg_37_0.mosaicState:setUniformFloat("mosaicSizeX", 300)
				arg_37_0.mosaicState:setUniformFloat("mosaicSizeY", 300)
				arg_37_0:endShow(arg_37_0.panel3)
				arg_37_0.panel3:unscheduleUpdate()

				arg_37_0.isEnding = false
			end

			var_37_0 = 0
		end
	end)
end

function var_0_10.endGame(arg_39_0)
	if arg_39_0.isEnding then
		return
	end

	arg_39_0.isEnding = true

	local var_39_0 = arg_39_0.problemData[arg_39_0.problemIndex:read()]

	if var_39_0.gameID then
		if var_39_0.gameID == 1 then
			arg_39_0:messSchedule(var_0_5.MESS / 4)
		elseif var_39_0.gameID == 2 then
			arg_39_0:mosaicSchedule(var_0_5.MOSAIC / 4)
		else
			if arg_39_0.blinkIndex <= arg_39_0.blinkTimes then
				arg_39_0.blinkIndex = arg_39_0.blinkTimes - 1
			end

			arg_39_0:blinkSchedule(var_0_5.BLINK)
		end
	else
		arg_39_0:endShow(arg_39_0.panel3)

		arg_39_0.isEnding = false
	end
end

function var_0_10.blink(arg_40_0)
	arg_40_0.cardPanel:removeAllChildren()

	local var_40_0 = {}

	for iter_40_0, iter_40_1 in ipairs(var_0_7) do
		local var_40_1 = cc.Sprite:create(iter_40_1.res):addTo(arg_40_0.cardPanel, 3):xy(iter_40_1.x, iter_40_1.y)

		var_40_1:hide()

		if var_40_1:size().height > var_0_8 then
			var_40_1:size({
				height = var_0_8,
				width = var_0_8 * var_40_1:size().width / var_40_1:size().height
			})
		end

		table.insert(var_40_0, var_40_1)
	end

	arg_40_0.blinkTable = var_0_0(var_40_0)
	arg_40_0.blinkIndex = 0
	arg_40_0.blinkTimes = 40

	arg_40_0:blinkSchedule(var_0_5.BLINK)
end

function var_0_10.blinkSchedule(arg_41_0, arg_41_1)
	arg_41_0.panel3:unscheduleUpdate()

	local var_41_0 = 0

	arg_41_0.panel3:scheduleUpdate(function(arg_42_0)
		var_41_0 = var_41_0 + 0.017

		if var_41_0 > arg_41_1 then
			arg_41_0.blinkIndex = arg_41_0.blinkIndex + 1

			if arg_41_0.blinkIndex >= arg_41_0.blinkTimes then
				if arg_41_0.blinkIndex == arg_41_0.blinkTimes then
					for iter_42_0, iter_42_1 in ipairs(arg_41_0.blinkTable) do
						iter_42_1:hide()
					end
				end

				if arg_41_0.blinkIndex <= arg_41_0.blinkTimes + #arg_41_0.blinkTable - 1 then
					arg_41_0.blinkTable[arg_41_0.blinkIndex - arg_41_0.blinkTimes + 1]:show()
				else
					arg_41_0:endShow(arg_41_0.panel3)
					arg_41_0.panel3:unscheduleUpdate()

					arg_41_0.isEnding = false
				end
			elseif arg_41_0.blinkIndex <= #arg_41_0.blinkTable then
				for iter_42_2, iter_42_3 in ipairs(arg_41_0.blinkTable) do
					if iter_42_2 == arg_41_0.blinkIndex then
						iter_42_3:show()
					else
						iter_42_3:hide()
					end
				end
			else
				local var_42_0 = math.random(#arg_41_0.blinkTable)

				for iter_42_4, iter_42_5 in ipairs(arg_41_0.blinkTable) do
					if iter_42_4 == var_42_0 then
						iter_42_5:show()
					else
						iter_42_5:hide()
					end
				end
			end

			var_41_0 = 0
		end
	end)
end

function var_0_10.openEraser(arg_43_0, arg_43_1)
	arg_43_0.textNum1:hide()

	local var_43_0 = arg_43_1
	local var_43_1 = arg_43_0.panelBg
	local var_43_2 = var_43_1:size().width - display.uiOrigin.x
	local var_43_3 = cc.utils:captureNodeSprite(gGameUI.uiRoot, cc.TEXTURE2_D_PIXEL_FORMAT_RG_B565, 1, display.uiOrigin.x, 0):addTo(var_43_1, 100)

	var_43_3:x(var_43_3:x() - display.uiOrigin.x)
	var_43_0:hide()

	local var_43_4 = cc.GLProgram:create("shader/ver_shader.vsh", "shader/eraser2.fsh")

	var_43_4:link()
	var_43_4:updateUniforms()

	local var_43_5 = cc.GLProgramState:getOrCreateWithGLProgram(var_43_4)
	local var_43_6 = var_43_1:size()
	local var_43_7 = cc.RenderTexture:create(var_43_6.width, var_43_6.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444)
	local var_43_8 = cc.Node:create()

	var_43_8:addTo(var_43_1):scale(0.5)

	local var_43_9 = cc.RenderTexture:create(var_43_6.width / 2, var_43_6.height / 2, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444):addTo(var_43_8):setAutoDraw(true):x(-var_43_6.width - display.uiOrigin.x)

	var_43_7:hide()
	var_43_7:begin()
	var_43_3:visit()
	var_43_7:endToLua()
	var_43_7:drawOnce(true)
	var_43_3:hide()

	local var_43_10 = var_43_7:getSprite()

	var_43_10:removeFromParent()
	var_43_10:addTo(var_43_1)
	var_43_10:getTexture():setAlphaTexture(var_43_9:getSprite():getTexture())
	var_43_10:setGLProgramState(var_43_5)

	local var_43_11 = cc.Sprite:create("city/union/answer/guangyun.png")

	var_43_11:addTo(var_43_9):scale(1):xy(var_43_2, -var_43_6.height / 2)

	local var_43_12 = 0.2 / arg_43_0.timeScale

	var_43_11:runAction(cc.Sequence:create(cc.MoveTo:create(var_43_12, cc.p(1.5 * var_43_6.width / 4 + var_43_2, var_43_6.height)), cc.MoveTo:create(var_43_12, cc.p(0.5 * var_43_6.width / 4 + var_43_2, -var_43_6.height / 2)), cc.MoveTo:create(var_43_12, cc.p(2.5 * var_43_6.width / 4 + var_43_2, var_43_6.height)), cc.MoveTo:create(var_43_12, cc.p(1.5 * var_43_6.width / 4 + var_43_2, -var_43_6.height / 2)), cc.MoveTo:create(var_43_12, cc.p(3.5 * var_43_6.width / 4 + var_43_2, var_43_6.height)), cc.MoveTo:create(var_43_12, cc.p(2.5 * var_43_6.width / 4 + var_43_2, -var_43_6.height / 2)), cc.MoveTo:create(var_43_12, cc.p(var_43_6.width + var_43_2, var_43_6.height)), cc.CallFunc:create(function()
		arg_43_0.panelBg:removeAllChildren()

		if gGameUI.scene:getChildByName("answerGift") then
			gGameUI.scene:getChildByName("answerGift"):removeSelf()
		end

		arg_43_0.isEraser = false

		if #arg_43_0.problemData > arg_43_0.problemIndex:read() then
			if arg_43_0.problemData[arg_43_0.problemIndex:read() + 1].type ~= var_0_2.GAME then
				arg_43_0:startAnswer()
			else
				arg_43_0:showGameRule()
			end
		else
			arg_43_0:onClose(true)
		end
	end)))
end

function var_0_10.onClose(arg_45_0, arg_45_1)
	if arg_45_0.endData then
		var_0_9.onClose(arg_45_0)

		return
	end

	if arg_45_0.isEraser then
		return
	end

	if arg_45_1 == true then
		arg_45_0:showEnd()
	else
		arg_45_0.isQuit = true

		local var_45_0 = "#C0x5b545b#" .. string.format(gLanguageCsv.unionAnswerQuitText, arg_45_0.myGrade)

		gGameUI:stackUI("city.union.answer.tips", nil, nil, {
			content = var_45_0,
			cb = function()
				arg_45_0:showEnd()
			end,
			closeCb = function()
				arg_45_0.isQuit = false

				if arg_45_0.needEraser == true then
					local var_47_0

					if arg_45_0.problemData[arg_45_0.problemIndex:read()].type <= var_0_2.DIFFICULT then
						var_47_0 = arg_45_0.panel1
					elseif arg_45_0.problemData[arg_45_0.problemIndex:read()].type == var_0_2.SEEPICTURE then
						var_47_0 = arg_45_0.panel2
					else
						var_47_0 = arg_45_0.panel3
					end

					arg_45_0:openEraser(var_47_0)

					arg_45_0.needEraser = false
				end
			end,
			time = arg_45_0.counTtime
		})
	end
end

function var_0_10.showEnd(arg_48_0)
	arg_48_0.isEraser = true

	arg_48_0.endPanel:show()
	arg_48_0.panel1:hide()
	arg_48_0.panel2:hide()
	arg_48_0.panel3:hide()
	arg_48_0.sureBtn:hide()
	arg_48_0.endPanel:get("text1"):text(string.format(gLanguageCsv.unionAnswerEndText1, arg_48_0.rightNum, arg_48_0.myGrade))
	arg_48_0.endPanel:get("text2"):text("x" .. arg_48_0.rightNum)
	arg_48_0.bagPanel:xy(241, 400)
	arg_48_0.topPanel:unscheduleUpdate()
	arg_48_0.seeTip:unscheduleUpdate()
	gGameApp:requestServer("/game/union/qa/settle", function(arg_49_0)
		arg_48_0.giftData = arg_49_0
	end)
	arg_48_0.bagPanel:onClick(functools.partial(arg_48_0.getGift, arg_48_0))
	arg_48_0.topUI:hide()
end

function var_0_10.getGift(arg_50_0)
	arg_50_0.isEraser = false
	arg_50_0.endData = true

	local var_50_0 = arg_50_0.giftData

	if var_50_0.view.ranks then
		arg_50_0.roleData:update(var_50_0.view.ranks.role_ranks)
		arg_50_0.unionData:update(var_50_0.view.ranks.union_ranks)
		arg_50_0.myRoleData:update(var_50_0.view.ranks.my_rank)
		arg_50_0.myUnionData:update(var_50_0.view.ranks.my_union_rank)
	end

	if var_50_0.view.result then
		var_0_9.onClose(arg_50_0)

		if not itertools.isempty(var_50_0.view.result) then
			gGameUI:showGainDisplay(var_50_0)
		else
			gGameUI:showTip(gLanguageCsv.unionAnswerNoGift)
		end
	end
end

return var_0_10
