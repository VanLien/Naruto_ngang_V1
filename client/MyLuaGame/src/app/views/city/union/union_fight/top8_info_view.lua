local var_0_0 = require("app.views.city.union.tools")
local var_0_1 = class("UnionFightFightListDialog", Dialog)

var_0_1.RESOURCE_FILENAME = "union_fight_fight_list.json"
var_0_1.RESOURCE_BINDING = {
	["lines.line6"] = "line6",
	["icons.icon5"] = "icon5",
	["icons.icon2"] = "icon2",
	["icons.icon7"] = "icon7",
	["lines.line45"] = "line45",
	text = "text",
	["icons.icon18"] = "icon18",
	["icons.icon1845"] = "icon1845",
	["icons.icon36"] = "icon36",
	["lines.line7"] = "line7",
	bg = "bg",
	["lines.line3"] = "line3",
	["icons.icon1"] = "icon1",
	iconBg = "iconBg",
	["icons.icon4"] = "icon4",
	["icons.icon2736"] = "icon2736",
	["lines.line5"] = "line5",
	["icons.icon8"] = "icon8",
	["lines.line8"] = "line8",
	["lines.line1"] = "line1",
	["icons.icon3"] = "icon3",
	["icons.icon45"] = "icon45",
	["lines.line4"] = "line4",
	["icons.icon6"] = "icon6",
	["lines.line18"] = "line18",
	["lines.line2"] = "line2",
	["lines.line36"] = "line36",
	["lines.line27"] = "line27",
	["icons.icon27"] = "icon27",
	btnClose = {
		varname = "btnClose",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["icons.icon1.self.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(130, 45, 19, 255)
				}
			}
		}
	},
	["icons.icon2.self.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(130, 45, 19, 255)
				}
			}
		}
	},
	["icons.icon3.self.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(130, 45, 19, 255)
				}
			}
		}
	},
	["icons.icon4.self.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(130, 45, 19, 255)
				}
			}
		}
	},
	["icons.icon5.self.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(130, 45, 19, 255)
				}
			}
		}
	},
	["icons.icon6.self.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(130, 45, 19, 255)
				}
			}
		}
	},
	["icons.icon7.self.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(130, 45, 19, 255)
				}
			}
		}
	},
	["icons.icon8.self.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(130, 45, 19, 255)
				}
			}
		}
	}
}

local var_0_2 = {
	[36] = "group-b2",
	[-18452736] = "third",
	[27] = "group-b1",
	[45] = "group-a2",
	[18] = "group-a1",
	[2736] = "group-b3",
	[18452736] = "champion",
	[1845] = "group-a3"
}
local var_0_3 = {
	8,
	7,
	6,
	5,
	4,
	3,
	2,
	1,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	45,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	36,
	[36] = 27,
	[1845] = 2736,
	[2736] = 1845,
	[45] = 18
}

local function var_0_4(arg_1_0)
	local var_1_0 = string.len(arg_1_0)

	if var_1_0 > 1 then
		local var_1_1 = var_1_0 / 2

		return string.sub(arg_1_0, 1, var_1_1), string.sub(arg_1_0, var_1_1 + 1, var_1_0)
	end
end

function var_0_1.onCreate(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0.unionId = gGameModel.role:read("union_db_id")
	arg_2_0.dialogHandler = arg_2_3

	local var_2_0 = gGameModel.union_fight:read("top8_vs_info") or {}

	arg_2_0.data = var_2_0

	local var_2_1 = {}
	local var_2_2 = {}
	local var_2_3 = {}
	local var_2_4 = {}
	local var_2_5

	for iter_2_0, iter_2_1 in pairs(var_2_0) do
		local var_2_6 = {
			pos = tostring(iter_2_0),
			id = iter_2_1[1],
			name = iter_2_1[2],
			icon = iter_2_1[3],
			level = iter_2_1[4],
			maxNum = iter_2_1[5],
			num = iter_2_1[6]
		}

		if iter_2_0 < 10 and iter_2_0 > 0 then
			table.insert(var_2_1, var_2_6)
		elseif iter_2_0 < 100 and iter_2_0 > 0 then
			table.insert(var_2_2, var_2_6)
		elseif iter_2_0 < 10000 and iter_2_0 > 0 then
			table.insert(var_2_3, var_2_6)
		elseif iter_2_0 > 0 then
			var_2_5 = var_2_6

			local var_2_7, var_2_8 = var_0_4(tostring(iter_2_0))

			var_2_4[var_2_7] = var_2_6.id
			var_2_4[var_2_8] = var_2_6.id
		end
	end

	for iter_2_2, iter_2_3 in pairs(var_0_3) do
		arg_2_0["icon" .. iter_2_2]:get("???"):hide()
	end

	local function var_2_9(arg_3_0)
		for iter_3_0, iter_3_1 in pairs(arg_3_0) do
			local var_3_0 = iter_3_1.pos
			local var_3_1 = arg_2_0["icon" .. var_3_0]
			local var_3_2 = var_2_4[var_3_0] == iter_3_1.id

			var_3_1:get("win"):visible(var_3_2)
			var_3_1:get("icon"):texture(gUnionLogoCsv[iter_3_1.icon]):show()
			var_3_1:get("name"):text(iter_3_1.name):show()
			var_3_1:get("text"):text(iter_3_1.num .. "/" .. iter_3_1.maxNum):show()
			var_3_1:get("bg"):show()
			var_3_1:setOpacity(178.5)

			if arg_2_0.unionId == iter_3_1.id and var_3_1:get("self") then
				var_3_1:get("self"):show()
			end

			local var_3_3, var_3_4 = var_0_4(var_3_0)

			if var_3_3 and var_3_4 then
				var_2_4[var_3_3] = iter_3_1.id
				var_2_4[var_3_4] = iter_3_1.id
			end

			local var_3_5 = arg_2_0["line" .. var_3_0]

			if var_3_5 then
				var_3_5:get("img"):visible(var_3_2)
			end

			local var_3_6 = var_3_1:get("btn")

			if arg_2_2 and var_3_6 then
				var_3_6:show()
				bind.touch(arg_2_0, var_3_6, {
					methods = {
						ended = arg_2_0:createHandler("onBtnClick", var_3_0, iter_3_1.id)
					}
				})
			end

			local var_3_7 = var_0_3[tonumber(var_3_0)]

			if var_3_7 and not arg_2_0.data[var_3_7] then
				local var_3_8 = arg_2_0["icon" .. var_3_7]

				var_3_8:get("???"):show()
				var_3_8:get("bg"):show()
				var_3_8:get("name"):text(gLanguageCsv.curRoundNoEnemy):show()

				if matchLanguage({
					"kr"
				}) then
					var_3_8:get("name"):setFontSize(27)
				end
			end
		end
	end

	var_2_9(var_2_3)
	var_2_9(var_2_2)
	var_2_9(var_2_1)

	if var_2_5 then
		arg_2_0:playChampionAni(var_2_5, arg_2_2)
	end

	if arg_2_1 then
		arg_2_0.btnClose:hide()
		arg_2_0.bg:hide()
		arg_2_0:getResourceNode():scale(0.7)

		local var_2_10 = gGameModel.union_fight:read("round")
		local var_2_11 = arg_2_0:getWDay()

		arg_2_0.text:visible(var_2_11 ~= 7 and var_2_10 ~= "over")
	else
		Dialog.onCreate(arg_2_0, {
			clickClose = true
		})
	end
end

function var_0_1.getWDay(arg_4_0)
	local var_4_0 = time.getNowDate().wday

	var_4_0 = var_4_0 == 1 and 7 or var_4_0 - 1

	return var_4_0
end

function var_0_1.onBtnClick(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = var_0_2[tonumber(arg_5_1)]

	gGameApp:requestServer("/game/union/fight/top8/round/results", function(arg_6_0)
		local var_6_0 = gGameModel.union_fight:read("round_results")[var_5_0] or {}

		if not next(var_6_0) then
			gGameUI:showTip(gLanguageCsv.notStartBattle)

			return
		end

		local var_6_1, var_6_2 = var_0_4(arg_5_1)
		local var_6_3 = arg_5_0.data[tonumber(var_6_1)]
		local var_6_4 = arg_5_0.data[tonumber(var_6_2)]
		local var_6_5 = {
			left = {
				id = var_6_3[1],
				name = var_6_3[2],
				icon = var_6_3[3],
				level = var_6_3[4],
				isWin = arg_5_2 == var_6_3[1]
			},
			right = {
				id = var_6_4[1],
				name = var_6_4[2],
				icon = var_6_4[3],
				level = var_6_4[4],
				isWin = arg_5_2 == var_6_4[1]
			}
		}

		arg_5_0.dialogHandler("city.union.union_fight.fighting_list.js", var_6_0, var_6_5, true)
	end, var_5_0)
end

function var_0_1.playChampionAni(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = 0.8333333333333334
	local var_7_1 = "union_fight/ghz_touxiang.skel"
	local var_7_2 = arg_7_0:getResourceNode()
	local var_7_3 = arg_7_0.iconBg
	local var_7_4 = var_7_3:size()
	local var_7_5 = widget.addAnimationByKey(var_7_3, var_7_1, "main_ani", "effect", 8):addPlay("effect_loop"):xy(var_7_4.width / 2, var_7_4.height / 2):scale(2)

	if arg_7_2 then
		local var_7_6 = arg_7_0.iconBg:get("btnPanel"):visible(arg_7_2)
		local var_7_7 = -1

		var_7_6:scale(0)
		transition.executeSpawn(var_7_6):scaleTo(var_7_0, 1):rotateBy(var_7_0, 360 * var_7_7):done()
		bind.touch(arg_7_0, var_7_6:get("btn"), {
			methods = {
				ended = arg_7_0:createHandler("onBtnClick", arg_7_1.pos, arg_7_1.id)
			}
		})
	end

	arg_7_0.iconBg:get("winner.icon"):texture(gUnionLogoCsv[arg_7_1.icon])
	arg_7_0.iconBg:get("winner.name"):text(arg_7_1.name)
	arg_7_0.iconBg:get("winner.text"):text(arg_7_1.num .. "/" .. arg_7_1.maxNum)
	arg_7_0.iconBg:get("???"):hide()
	arg_7_0.iconBg:get("iconBg"):hide()
	performWithDelay(arg_7_0, function()
		arg_7_0.iconBg:get("winner"):show()
	end, var_7_0)
end

return var_0_1
