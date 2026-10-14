local var_0_0 = {
	poison = "#C0xFFAE7EDE#",
	fire = "#C0xFFA87B31#",
	ice = "#C0xFF6BDBEC#",
	water = "#C0xFF22C222#",
	ground = "#C0xFFB8B7B1#",
	fairy = "#C0xFFF96494#",
	worm = "#C0xFFC4D138#",
	combat = "#C0xFFF98562#",
	normal = "#C0xFFC52091#",
	super = "#C0xFFE76FD7#",
	evil = "#C0xFFAF8B85#",
	grass = "#C0xFF2497DD#",
	ghost = "#C0xFF788797#",
	fly = "#C0xFF85CEFC#",
	dragon = "#C0xFFABA2FF#",
	rock = "#C0xFFBE9E6A#",
	electricity = "#C0xFFED251B#",
	steel = "#C0xFFA5B8BE#"
}

local function var_0_1(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_1:get("progressBar"):removeChildByName("changtiao")
	arg_1_1:get("topView"):visible(false)

	local var_1_0 = arg_1_3.cfg.targetType
	local var_1_1 = ""
	local var_1_2 = ""

	if var_1_0 == 2 then
		var_1_1 = gLanguageCsv.xi .. " " .. gLanguageCsv[game.NATURE_TABLE[arg_1_3.cfg.targetArg2]]
		var_1_2 = ui.ATTRCOLOR[game.NATURE_TABLE[arg_1_3.cfg.targetArg2]]
	end

	arg_1_1:removeChildByName("richText1")
	rich.createByStr(string.format(gLanguageCsv.handbookBreakTitle, "#C0xFF57472E#", arg_1_3.cfg.targetArg, var_1_2, var_1_1, "#C0xFF57472E#"), 50):anchorPoint(0, 0.5):xy(57, 180):name("richText1"):addTo(arg_1_1, 3)

	local var_1_3 = arg_1_0.hasNum:read()

	if var_1_0 == 2 then
		var_1_3 = 0

		for iter_1_0, iter_1_1 in pairs(arg_1_0.cards:read()) do
			local var_1_4 = csv.cards[iter_1_0]
			local var_1_5 = csv.unit[var_1_4.unitID]

			if arg_1_3.cfg.targetArg2 == var_1_5.natureType or var_1_5.natureType2 and arg_1_3.cfg.targetArg2 == var_1_5.natureType2 then
				var_1_3 = var_1_3 + 1
			end
		end
	end

	local var_1_6 = string.format("%d/%d", var_1_3, arg_1_3.cfg.targetArg)

	arg_1_1:get("textNum"):text(var_1_6)

	local var_1_7 = var_1_3 / arg_1_3.cfg.targetArg * 100
	local var_1_8 = math.min(var_1_7, 100)
	local var_1_9 = math.max(var_1_8, 0)

	arg_1_1:get("progressBar"):setPercent(var_1_9)
	arg_1_1:removeChildByName("richText2")
	rich.createByStr(arg_1_3.cfg.desc, 40):anchorPoint(0, 0.5):xy(57, 100):name("richText2"):addTo(arg_1_1, 3)

	local var_1_10

	var_1_10 = var_1_3 >= arg_1_3.cfg.targetArg

	local var_1_11 = arg_1_1:get("btnBreak")
	local var_1_12 = arg_1_1:get("imgFlag")

	cache.setShader(var_1_11, false, "normal")
	cache.setShader(var_1_11:get("textNote"), false, "normal")

	if arg_1_3.state == 0 then
		var_1_12:visible(true)
		var_1_11:visible(false)
	elseif arg_1_3.state == 1 then
		var_1_12:visible(false)
		var_1_11:visible(true)
		text.addEffect(var_1_11:get("textNote"), {
			outline = {
				color = ui.NEWCOLORS.OUTLINE.YELLOW
			}
		})
		widget.addAnimationByKey(arg_1_1:get("progressBar"), "shengjichangtiao/changtiao.skel", "changtiao", "effect_loop", 99):anchorPoint(cc.p(0.5, 0.5)):xy(arg_1_1:get("imgProBar"):width() / 2, arg_1_1:get("imgProBar"):height() / 2)
	else
		var_1_12:visible(false)
		var_1_11:visible(true)
		cache.setShader(var_1_11, false, "hsl_gray")
		cache.setShader(var_1_11:get("textNote"), false, "hsl_gray")
		text.deleteEffect(var_1_11:get("textNote"), {
			"outline"
		})
	end
end

local var_0_2 = class("HandbookBreakView", Dialog)

var_0_2.RESOURCE_FILENAME = "handbook_break.json"
var_0_2.RESOURCE_BINDING = {
	item = "item",
	btnItem = "btnItem",
	["panel.title.btnClose"] = {
		varname = "btnClose",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["panel.title.textNote1"] = {
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
	["panel.title.textNote2"] = {
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
	["panel.listview"] = {
		varname = "breakList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("breakDatas"),
				item = bindHelper.self("item"),
				hasNum = bindHelper.self("hasNum"),
				cards = bindHelper.self("cards"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					var_0_1(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					bind.touch(arg_2_0, arg_2_1:get("btnBreak"), {
						methods = {
							ended = functools.partial(arg_2_0.clickItem, arg_2_2, arg_2_3, arg_2_1)
						}
					})
				end
			},
			handlers = {
				clickItem = bindHelper.self("onBreak")
			}
		}
	},
	["panel.tabPanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("btnsData"),
				item = bindHelper.self("btnItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:get("textNote")

					arg_3_1:get("btnClick"):visible(arg_3_3.state)
					arg_3_1:get("btnNormal"):visible(not arg_3_3.state)
					var_3_0:text(arg_3_3.text)
					adapt.setTextScaleWithWidth(var_3_0, nil, 150)

					if arg_3_3.state then
						text.addEffect(var_3_0, {
							color = ui.NEWCOLORS.ORANGE,
							outline = {
								size = 3,
								color = ui.NEWCOLORS.OUTLINE.WHITE
							}
						})
					else
						text.deleteAllEffect(var_3_0)
						text.addEffect(var_3_0, {
							color = ui.COLORS.NORMAL.WHITE
						})
					end

					if arg_3_3.attrNatureType > 0 then
						arg_3_1:get("imgIcon"):texture(ui.SKILL_ICON[arg_3_3.attrNatureType]):scale(0.8)
					else
						arg_3_1:get("imgIcon"):texture("city/handbook/icon_tj.png")
						arg_3_1:get("imgIcon"):scale(1.2)
					end

					bind.touch(arg_3_0, arg_3_1:get("btnNormal"), {
						methods = {
							ended = functools.partial(arg_3_0.clickItem, arg_3_2, arg_3_3)
						}
					})

					local var_3_1 = {
						class = "red_hint",
						props = {
							state = arg_3_3.red_hint,
							onNode = function(arg_4_0)
								arg_4_0:xy(390, 150)
							end
						}
					}

					bind.extend(arg_3_0, arg_3_1, var_3_1)
				end
			},
			handlers = {
				clickItem = bindHelper.self("onChangeView")
			}
		}
	}
}

function var_0_2.onCreate(arg_5_0)
	arg_5_0:initModel()

	arg_5_0.curSelBtn = 1

	local var_5_0 = {
		{
			red_hint = false,
			attrNatureType = 0,
			state = true,
			text = gLanguageCsv.overView
		},
		{
			red_hint = false,
			attrNatureType = 1,
			state = false,
			text = gLanguageCsv.normal
		},
		{
			red_hint = false,
			attrNatureType = 2,
			state = false,
			text = gLanguageCsv.fire
		},
		{
			red_hint = false,
			attrNatureType = 3,
			state = false,
			text = gLanguageCsv.water
		},
		{
			red_hint = false,
			attrNatureType = 4,
			state = false,
			text = gLanguageCsv.grass
		},
		{
			red_hint = false,
			attrNatureType = 5,
			state = false,
			text = gLanguageCsv.electricity
		}
	}

	arg_5_0.btnsData = idlers.newWithMap(var_5_0)
	arg_5_0.hasNum = idler.new(itertools.size(arg_5_0.cards:read()))
	arg_5_0.breakDatas = idlers.newWithMap({})

	arg_5_0:refreshIdlersMap()
	arg_5_0:refreshTabRedHint()
	Dialog.onCreate(arg_5_0)
end

function var_0_2.initModel(arg_6_0)
	arg_6_0.cards = gGameModel.role:getIdler("pokedex")
	arg_6_0.pokedexAdvance = gGameModel.role:getIdler("pokedex_advance")
end

function var_0_2.refreshIdlersMap(arg_7_0)
	local var_7_0 = {}
	local var_7_1 = arg_7_0.btnsData:atproxy(arg_7_0.curSelBtn).attrNatureType
	local var_7_2 = arg_7_0.pokedexAdvance:read()

	for iter_7_0, iter_7_1 in orderCsvPairs(csv.pokedex_advance) do
		local var_7_3 = iter_7_1.targetArg2 or 0

		if matchLanguage(iter_7_1.languages) and var_7_1 == var_7_3 then
			local var_7_4 = {
				cfg = iter_7_1,
				state = var_7_2[iter_7_0] or 0.5,
				csvId = iter_7_0
			}

			table.insert(var_7_0, var_7_4)
		end
	end

	table.sort(var_7_0, function(arg_8_0, arg_8_1)
		if arg_8_0.state ~= arg_8_1.state then
			return arg_8_0.state > arg_8_1.state
		end

		return arg_8_0.csvId < arg_8_1.csvId
	end)
	dataEasy.tryCallFunc(arg_7_0.breakList, "updatePreloadCenterIndex")
	arg_7_0.breakDatas:update(var_7_0)
	arg_7_0.breakList:jumpToTop()
end

function var_0_2.refreshTabRedHint(arg_9_0)
	local var_9_0 = arg_9_0.pokedexAdvance:read()

	for iter_9_0, iter_9_1 in arg_9_0.btnsData:pairs() do
		arg_9_0.btnsData:atproxy(iter_9_0).red_hint = false

		local var_9_1 = arg_9_0.btnsData:atproxy(iter_9_0).attrNatureType

		for iter_9_2, iter_9_3 in orderCsvPairs(csv.pokedex_advance) do
			local var_9_2 = iter_9_3.targetArg2 or 0
			local var_9_3 = var_9_0[iter_9_2] or 0.5

			if matchLanguage(iter_9_3.languages) and var_9_1 == var_9_2 and var_9_3 == 1 then
				arg_9_0.btnsData:atproxy(iter_9_0).red_hint = true

				break
			end
		end
	end
end

function var_0_2.onBreak(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	if arg_10_3.state ~= 1 then
		return
	end

	gGameApp:requestServer("/game/role/pokedex_advance", function(arg_11_0)
		arg_10_4:get("topView"):visible(true)
		widget.addAnimationByKey(arg_10_4:get("progressBar"), "shengjichangtiao/changtiao.skel", "changtiao", "effect_loop", 99):play("effect")
		performWithDelay(arg_10_0, function()
			arg_10_0:refreshIdlersMap()
			arg_10_0:refreshTabRedHint(arg_10_0.btnsData:atproxy(arg_10_0.curSelBtn).attrNatureType)
			gGameUI:showTip(gLanguageCsv.breakSuccess)
		end, 0.8333333333333334)
	end, arg_10_3.csvId)
end

function var_0_2.onChangeView(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	arg_13_0.btnsData:atproxy(arg_13_0.curSelBtn).state = false
	arg_13_0.btnsData:atproxy(arg_13_2).state = true
	arg_13_0.curSelBtn = arg_13_2

	arg_13_0:refreshIdlersMap()
end

return var_0_2
