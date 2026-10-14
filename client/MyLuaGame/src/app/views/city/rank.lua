local var_0_0 = {
	"powerList",
	"collectList",
	"arenaList",
	"kingList",
	"unionList",
	"activityList",
	"craftList",
	"gateStarList"
}

local function var_0_1(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = arg_1_1:multiget("img", "num", "name", "iconBg", "level", "bg", "szbg2")

	var_1_0.name:text(arg_1_3.name)

	local var_1_1 = {
		event = "extend",
		class = "role_logo",
		props = {
			vip = false,
			level = false,
			logoId = arg_1_3.logo,
			frameId = arg_1_3.frame,
			onNode = function(arg_2_0)
				arg_2_0:xy(104, 95):z(6):scale(0.9)
			end
		}
	}

	bind.extend(arg_1_0, var_1_0.iconBg, var_1_1)
	var_1_0.level:get("txt"):text(arg_1_3.level)

	local var_1_2 = arg_1_4 or arg_1_2

	var_1_0.img:visible(var_1_2 <= 3)
	var_1_0.num:visible(var_1_2 > 3)
	var_1_0.num:text(var_1_2)

	if var_1_2 <= 3 then
		var_1_0.img:texture(ui.RANK_ICON[var_1_2])
	end

	var_1_0.iconBg:setTouchEnabled(false)
	var_1_0.bg:setTouchEnabled(true)
	var_1_0.bg:onClick(functools.partial(arg_1_0.clickHead, arg_1_2, arg_1_3, var_1_2))
end

local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("RankView", var_0_2)

var_0_3.RESOURCE_FILENAME = "rank.json"
var_0_3.RESOURCE_BINDING = {
	["leftPanel.item"] = "leftItem",
	["rightPanel.bottomPanel.txtName"] = "myName",
	["rightPanel.topPanelCollect"] = "topPanelCollect",
	["rightPanel.topPanelUnion"] = "topPanelUnion",
	["rightPanel.bottomPanel.txtRank"] = "myRanking",
	["rightPanel.bottomPanelCraft"] = "bottomPanelCraft",
	["rightPanel.bottomPanel"] = "bottomPanel",
	["rightPanel.bottomPanelFight"] = "bottomPanelFight",
	["rightPanel.topPanelFight"] = "topPanelFight",
	["rightPanel.bottomPanelCollect"] = "bottomPanelCollect",
	itemCollect = "itemCollect",
	["rightPanel.bottomPanelGateStar"] = "bottomPanelGateStar",
	["rightPanel.bottomPanelUnion"] = "bottomPanelUnion",
	itemGateStar = "itemGateStar",
	["rightPanel.topPanelbiaoti_bg.biaoti_bg"] = "rightTopBg",
	["rightPanel.topPanelCraft"] = "topPanelCraft",
	itemFight = "itemFight",
	leftPanel = "leftPanel",
	["rightPanel.topPanel"] = "topPanel",
	itemUnion = "itemUnion",
	itemCraft = "itemCraft",
	["rightPanel.bottomPanel.txtStatic1"] = "txtStatic1",
	["rightPanel.topPanelGateStar"] = "topPanelGateStar",
	rightPanel = "rightPanel",
	["leftPanel.list"] = {
		varname = "leftList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("leftDatas"),
				item = bindHelper.self("leftItem"),
				dataOrderCmp = function(arg_3_0, arg_3_1)
					return arg_3_0.sortValue < arg_3_1.sortValue
				end,
				itemAction = {
					isAction = true
				},
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:get("normal")
					local var_4_1 = arg_4_1:get("selected")
					local var_4_2

					if arg_4_3.select then
						var_4_0:hide()

						var_4_2 = var_4_1:show()
					else
						var_4_1:hide()

						var_4_2 = var_4_0:show()

						var_4_2:get("subTxt"):text(arg_4_3.subName)
					end

					var_4_2:get("txt"):text(arg_4_3.name)
					var_4_1:setTouchEnabled(false)
					bind.touch(arg_4_0, var_4_0, {
						methods = {
							ended = functools.partial(arg_4_0.clickCell, arg_4_2)
						}
					})
					adapt.setTextScaleWithWidth(var_4_2:get("txt"), nil, 300)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	["rightPanel.powerList"] = {
		varname = "powerList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showData1"),
				item = bindHelper.self("itemFight"),
				scrollState = bindHelper.self("scrollState"),
				itemAction = {
					isAction = true
				},
				onBeforeBuild = function(arg_5_0)
					arg_5_0.scrollState:set(false)
				end,
				onAfterBuild = function(arg_6_0)
					arg_6_0.scrollState:set(true)
				end,
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					var_0_1(arg_7_0, arg_7_1, arg_7_2, arg_7_3.role)

					local var_7_0 = arg_7_1:get("item1")

					var_7_0:hide()
					arg_7_1:get("power"):text(arg_7_3.fighting_point)

					local var_7_1 = arraytools.filter(arg_7_3.top6_cards, function(arg_8_0, arg_8_1)
						if arg_8_1 and arg_8_1.card_id ~= 0 then
							return true
						end
					end)

					bind.extend(arg_7_0, arg_7_1:get("list"), {
						class = "listview",
						props = {
							data = var_7_1,
							item = var_7_0,
							onItem = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
								arg_9_1:get("level"):text("Lv." .. arg_9_3.level)

								local var_9_0 = dataEasy.getUnitCsv(arg_9_3.card_id, arg_9_3.skin_id)

								arg_9_1:get("icon"):texture(var_9_0.iconSimple)
								arg_9_1:get("bg"):texture("common/icon/panel_icon_" .. var_9_0.rarity .. ".png")
								arg_9_1:get("frame"):texture("common/icon/panel_icon_k" .. var_9_0.rarity .. ".png")
							end
						}
					})
				end
			},
			handlers = {
				clickHead = bindHelper.self("onHeadClick")
			}
		}
	},
	["rightPanel.collectList"] = {
		varname = "collectList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showData2"),
				item = bindHelper.self("itemCollect"),
				scrollState = bindHelper.self("scrollState"),
				itemAction = {
					isAction = true
				},
				onBeforeBuild = function(arg_10_0)
					arg_10_0.scrollState:set(false)
				end,
				onAfterBuild = function(arg_11_0)
					arg_11_0.scrollState:set(true)
				end,
				onItem = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
					var_0_1(arg_12_0, arg_12_1, arg_12_2, arg_12_3.role, arg_12_3.index)

					local var_12_0 = arg_12_1:multiget("txtCollect", "txtUnlock")
					local var_12_1 = arg_12_3.pokedex * 100 / table.length(gHandbookArrayCsv)

					var_12_0.txtCollect:text(string.format("%.1f%%", var_12_1))
					var_12_0.txtUnlock:text(arg_12_3.pokedex)
				end
			},
			handlers = {
				clickHead = bindHelper.self("onHeadClick")
			}
		}
	},
	["rightPanel.craftList"] = {
		varname = "craftList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showData7"),
				item = bindHelper.self("itemCraft"),
				scrollState = bindHelper.self("scrollState"),
				itemAction = {
					isAction = true
				},
				onBeforeBuild = function(arg_13_0)
					arg_13_0.scrollState:set(false)
				end,
				onAfterBuild = function(arg_14_0)
					arg_14_0.scrollState:set(true)
				end,
				onItem = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
					var_0_1(arg_15_0, arg_15_1, arg_15_2, arg_15_3.role, arg_15_3.index)

					local var_15_0 = arg_15_1:multiget("txtScore", "txtRecord")

					var_15_0.txtScore:text(arg_15_3.craft.point)
					var_15_0.txtRecord:text(string.format(gLanguageCsv.winAndLoseNum, arg_15_3.craft.win, math.min(arg_15_3.craft.round, 13) - arg_15_3.craft.win))
				end
			},
			handlers = {
				clickHead = bindHelper.self("onHeadClick")
			}
		}
	},
	["rightPanel.gateStarList"] = {
		varname = "gateStarList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showData8"),
				item = bindHelper.self("itemGateStar"),
				scrollState = bindHelper.self("scrollState"),
				itemAction = {
					isAction = true
				},
				onBeforeBuild = function(arg_16_0)
					arg_16_0.scrollState:set(false)
				end,
				onAfterBuild = function(arg_17_0)
					arg_17_0.scrollState:set(true)
				end,
				onItem = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
					var_0_1(arg_18_0, arg_18_1, arg_18_2, arg_18_3.role, arg_18_3.index)

					local var_18_0 = arg_18_1:multiget("txtStar", "txtUnion")

					var_18_0.txtStar:text(arg_18_3.star)
					var_18_0.txtUnion:text((arg_18_3.union_name == "" or not arg_18_3.union_name) and gLanguageCsv.none or arg_18_3.union_name)
				end
			},
			handlers = {
				clickHead = bindHelper.self("onHeadClick")
			}
		}
	},
	["rightPanel.arenaList"] = {
		varname = "arenaList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showData3"),
				item = bindHelper.self("itemFight"),
				scrollState = bindHelper.self("scrollState"),
				itemAction = {
					isAction = true
				},
				onBeforeBuild = function(arg_19_0)
					arg_19_0.scrollState:set(false)
				end,
				onAfterBuild = function(arg_20_0)
					arg_20_0.scrollState:set(true)
				end,
				onItem = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
					var_0_1(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				end
			},
			handlers = {
				clickHead = bindHelper.self("onHeadClick")
			}
		}
	},
	["rightPanel.kingList"] = {
		varname = "kingList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showData4"),
				item = bindHelper.self("itemFight"),
				scrollState = bindHelper.self("scrollState"),
				itemAction = {
					isAction = true
				},
				onBeforeBuild = function(arg_22_0)
					arg_22_0.scrollState:set(false)
				end,
				onAfterBuild = function(arg_23_0)
					arg_23_0.scrollState:set(true)
				end,
				onItem = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
					var_0_1(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				end
			},
			handlers = {
				clickHead = bindHelper.self("onHeadClick")
			}
		}
	},
	["rightPanel.unionList"] = {
		varname = "unionList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showData5"),
				item = bindHelper.self("itemUnion"),
				scrollState = bindHelper.self("scrollState"),
				itemAction = {
					isAction = true
				},
				onBeforeBuild = function(arg_25_0)
					arg_25_0.scrollState:set(false)
				end,
				onAfterBuild = function(arg_26_0)
					arg_26_0.scrollState:set(true)
				end,
				onItem = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
					local var_27_0 = arg_27_1:multiget("name", "level", "bossName", "people", "img", "iconBg", "bg", "num", "icon")

					var_27_0.name:text(arg_27_3.name)
					var_27_0.level:get("txt"):text(arg_27_3.level)
					var_27_0.icon:texture(csv.union.union_logo[arg_27_3.logo].icon)
					var_27_0.bossName:text(arg_27_3.chairman_name)
					var_27_0.people:text(arg_27_3.members .. "/" .. arg_27_3.member_max)
					var_27_0.img:visible(arg_27_2 <= 3)
					var_27_0.num:visible(arg_27_2 > 3)
					var_27_0.num:text(arg_27_2)

					if arg_27_2 <= 3 then
						var_27_0.img:texture(ui.RANK_ICON[arg_27_2])
					end

					var_27_0.iconBg:setTouchEnabled(false)
					var_27_0.bg:setTouchEnabled(true)
					var_27_0.bg:onClick(functools.partial(arg_27_0.clickHead, arg_27_2, arg_27_3, index))
				end
			},
			handlers = {
				clickHead = bindHelper.self("onUnionHeadClick")
			}
		}
	},
	["rightPanel.activityList"] = {
		varname = "activityList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showData6"),
				item = bindHelper.self("itemFight"),
				scrollState = bindHelper.self("scrollState"),
				itemAction = {
					isAction = true
				},
				onBeforeBuild = function(arg_28_0)
					arg_28_0.scrollState:set(false)
				end,
				onAfterBuild = function(arg_29_0)
					arg_29_0.scrollState:set(true)
				end,
				onItem = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
					var_0_1(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				end
			},
			handlers = {
				clickHead = bindHelper.self("onHeadClick")
			}
		}
	},
	["rightPanel.bottomPanel.txtState1"] = {
		varname = "txtState1",
		binds = {
			event = "text",
			idler = bindHelper.self("bottomTextState1")
		}
	},
	["rightPanel.bottomPanel.txtState2"] = {
		varname = "txtState2",
		binds = {
			event = "text",
			idler = bindHelper.self("bottomTextState2")
		}
	},
	["rightPanel.bottomPanelFight.txtRank"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("fightRank")
		}
	},
	["rightPanel.bottomPanelFight.txtName"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("roleName")
		}
	},
	["rightPanel.bottomPanelFight.txtState1"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("level")
		}
	},
	["rightPanel.bottomPanelFight.txtState2"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("power"),
			method = function(arg_31_0)
				return gLanguageCsv.power .. ": " .. arg_31_0
			end
		}
	},
	["rightPanel.bottomPanelCollect.txtRank"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("cardNumRank")
		}
	},
	["rightPanel.bottomPanelCollect.txtName"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("roleName")
		}
	},
	["rightPanel.bottomPanelCollect.txtState1"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("pokedex"),
			method = function(arg_32_0)
				return string.format("%.1f%%", itertools.size(arg_32_0) * 100 / table.length(gHandbookArrayCsv))
			end
		}
	},
	["rightPanel.bottomPanelCollect.txtState2"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("pokedex"),
			method = function(arg_33_0)
				return itertools.size(arg_33_0)
			end
		}
	},
	["rightPanel.bottomPanelUnion.txtRank"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("unionRank")
		}
	},
	["rightPanel.bottomPanelCraft.txtName"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "name")
		}
	},
	["rightPanel.bottomPanelCraft.txtRank"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("craftRank"),
			method = function(arg_34_0)
				return arg_34_0 and arg_34_0 > 0 and arg_34_0 or gLanguageCsv.craftNoRank
			end
		}
	},
	["rightPanel.bottomPanelGateStar.txtRank"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("gate_star_rank"),
			method = function(arg_35_0)
				return arg_35_0 > 0 and arg_35_0 or gLanguageCsv.craftNoRank
			end
		}
	},
	["rightPanel.bottomPanelGateStar.txtName"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("roleName")
		}
	},
	["rightPanel.bottomPanelGateStar.txtStar"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("gate_star_sum")
		}
	}
}

function var_0_3.initData(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5)
	local var_36_0 = #arg_36_2 == 10

	if arg_36_3 == 0 then
		arg_36_0.datas[arg_36_4] = arg_36_2
	else
		for iter_36_0, iter_36_1 in ipairs(arg_36_2) do
			table.insert(arg_36_0.datas[arg_36_4], iter_36_1)
		end
	end

	local var_36_1 = #arg_36_0.datas[arg_36_4]

	if arg_36_4 == 2 then
		local var_36_2 = 0
		local var_36_3 = 0

		for iter_36_2 = 1, var_36_1 do
			local var_36_4 = arg_36_0.datas[arg_36_4][iter_36_2]

			if iter_36_2 == 1 then
				var_36_2 = var_36_4.pokedex
				var_36_3 = iter_36_2
				var_36_4.index = var_36_3
			elseif var_36_2 == var_36_4.pokedex then
				var_36_4.index = var_36_3
			else
				var_36_2 = var_36_4.pokedex
				var_36_3 = iter_36_2
				var_36_4.index = iter_36_2
			end
		end
	end

	arg_36_0.isCanDown = false

	arg_36_0["showData" .. arg_36_4]:update(arg_36_0.datas[arg_36_4])
	gGameUI:disableTouchDispatch(0.01)
	arg_36_5:jumpToItem(arg_36_3 - 4, cc.p(0, 1), cc.p(0, 1))

	local var_36_5 = arg_36_1 == "craft" and 50 or 100

	arg_36_0.isCanDown = var_36_0 and var_36_1 < var_36_5
end

function var_0_3.sendProtocol(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	if arg_37_0.isRequest then
		return
	end

	arg_37_0.isRequest = true

	if arg_37_2 < 100 then
		if arg_37_1 == "union" then
			gGameApp:requestServer("/game/union/rank", function(arg_38_0)
				arg_37_0.isRequest = false

				arg_37_0:initData(arg_37_1, arg_38_0.view.unions, arg_37_2, arg_37_3, arg_37_4)
			end, arg_37_2, arg_37_2 + 10 > 100 and 100 - arg_37_2 or 10)
		else
			local var_37_0 = arg_37_1 == "craft" and 50 or 100

			gGameApp:requestServer("/game/rank", function(arg_39_0)
				if tolua.isnull(arg_37_0) then
					return
				end

				arg_37_0.isRequest = false

				if arg_37_1 == "craft" then
					if arg_39_0.view.craft then
						arg_37_0.bottomPanelCraft:get("txtScore"):text(arg_39_0.view.craft.point)
						arg_37_0.bottomPanelCraft:get("txtRecord"):text((string.format(gLanguageCsv.winAndLoseNum, arg_39_0.view.craft.win, math.min(arg_39_0.view.craft.round, 13) - arg_39_0.view.craft.win)))
					else
						arg_37_0.bottomPanelCraft:get("txtScore"):text("0")
						arg_37_0.bottomPanelCraft:get("txtRecord"):text(string.format(gLanguageCsv.winAndLoseNum, 0, 0))
					end
				end

				arg_37_0:initData(arg_37_1, arg_39_0.view.rank, arg_37_2, arg_37_3, arg_37_4)
			end, arg_37_1, arg_37_2, var_37_0 < arg_37_2 + 10 and var_37_0 - arg_37_2 or 10)
		end
	end
end

function var_0_3.adapUI(arg_40_0)
	local var_40_0 = arg_40_0.itemCraft:multiget("bg")
	local var_40_1 = arg_40_0.itemCraft:multiget("img", "num", "iconBg", "name", "txt", "level", "szbg1", "szbg2")
	local var_40_2 = arg_40_0.itemCraft:multiget("txtScore", "txtRecord")
	local var_40_3 = arg_40_0.topPanelCraft:multiget("txtRank", "txtName")
	local var_40_4 = arg_40_0.topPanelCraft:multiget("txtScore", "txtRecord")
	local var_40_5 = arg_40_0.bottomPanelCraft:multiget("bg")
	local var_40_6 = arg_40_0.bottomPanelCraft:multiget("txtRank", "txtName")
	local var_40_7 = arg_40_0.bottomPanelCraft:multiget("txtRecord", "txtScore")
	local var_40_8 = arg_40_0.itemFight:multiget("bg")
	local var_40_9 = arg_40_0.itemFight:multiget("img", "num", "iconBg", "name", "txt", "level", "szbg1", "szbg2")
	local var_40_10 = arg_40_0.itemFight:multiget("list")
	local var_40_11 = arg_40_0.topPanelFight:multiget("txtRank", "txtName")
	local var_40_12 = arg_40_0.topPanelFight:multiget("txtState2")
	local var_40_13 = arg_40_0.bottomPanel:multiget("bg")
	local var_40_14 = arg_40_0.bottomPanel:multiget("txtRank", "txtName")
	local var_40_15 = arg_40_0.bottomPanel:multiget("txtStatic1", "txtState2", "txtState1")
	local var_40_16 = arg_40_0.bottomPanelFight:multiget("txtName")
	local var_40_17 = arg_40_0.bottomPanelFight:multiget("txtStatic1", "txtState1", "txtState2")
	local var_40_18 = arg_40_0.bottomPanelFight:multiget("bg")
	local var_40_19 = arg_40_0.itemUnion:multiget("bg")
	local var_40_20 = arg_40_0.itemUnion:multiget("img", "num", "txt", "level", "iconBg", "name", "icon", "szbg1", "szbg2")
	local var_40_21 = arg_40_0.itemUnion:multiget("people", "bossName")
	local var_40_22 = arg_40_0.topPanelUnion:multiget("txtRank", "txtName", "txtState1")
	local var_40_23 = arg_40_0.topPanelUnion:multiget("txtState2", "txtState3")
	local var_40_24 = arg_40_0.bottomPanelUnion:multiget("bg")
	local var_40_25 = arg_40_0.bottomPanelUnion:multiget("txtRank", "txtName", "txtStatic1", "none", "txtState1")
	local var_40_26 = arg_40_0.bottomPanelUnion:multiget("txtState2", "txtState3")
	local var_40_27 = arg_40_0.itemUnion:multiget("union_bg")
	local var_40_28 = arg_40_0.itemUnion:multiget("union_szbg")
	local var_40_29 = arg_40_0.itemCollect:multiget("bg")
	local var_40_30 = arg_40_0.itemCollect:multiget("img", "num", "iconBg", "name", "txt", "level", "szbg1", "szbg2")
	local var_40_31 = arg_40_0.itemCollect:multiget("txtCollect", "icon1", "txtUnlock", "icon2")
	local var_40_32 = arg_40_0.topPanelCollect:multiget("txtRank", "txtName")
	local var_40_33 = arg_40_0.topPanelCollect:multiget("txtState1", "txtState2")
	local var_40_34 = arg_40_0.bottomPanelCollect:multiget("bg")
	local var_40_35 = arg_40_0.bottomPanelCollect:multiget("txtRank", "txtName")
	local var_40_36 = arg_40_0.bottomPanelCollect:multiget("txtState1", "txtState2")
	local var_40_37 = arg_40_0.itemCollect:multiget("collect_bg")
	local var_40_38 = arg_40_0.itemCollect:multiget("collect_szbg")
	local var_40_39 = arg_40_0.itemGateStar:multiget("bg")
	local var_40_40 = arg_40_0.itemGateStar:multiget("img", "num", "iconBg", "name", "txt", "level", "szbg1", "szbg2")
	local var_40_41 = arg_40_0.itemGateStar:multiget("txtStar", "txtUnion")
	local var_40_42 = arg_40_0.topPanelGateStar:multiget("txtRank", "txtName")
	local var_40_43 = arg_40_0.topPanelGateStar:multiget("txtStar", "txtUnion")
	local var_40_44 = arg_40_0.bottomPanelGateStar:multiget("bg")
	local var_40_45 = arg_40_0.bottomPanelGateStar:multiget("txtRank", "txtName")
	local var_40_46 = arg_40_0.bottomPanelGateStar:multiget("txtStar", "txtUnion")
	local var_40_47 = arg_40_0.itemGateStar:multiget("gatestar_bg")
	local var_40_48 = arg_40_0.itemGateStar:multiget("gatestar_szbg")

	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_40_0.leftPanel,
			"pos",
			"left"
		},
		{
			arg_40_0.rightPanel,
			"pos",
			"left"
		},
		{
			arg_40_0.rightTopBg,
			"width"
		},
		{
			arg_40_0.rightTopBg,
			"pos",
			"right"
		}
	})
end

function var_0_3.onCreate(arg_41_0, arg_41_1)
	arg_41_0:initModel()
	arg_41_0:adapUI()

	arg_41_0.isCanDown = true
	arg_41_0.scrollState = idler.new(true)
	arg_41_0.datas = {}

	local var_41_0 = arg_41_1

	for iter_41_0 = 1, itertools.size(var_0_0) do
		arg_41_0.datas[iter_41_0] = iter_41_0 == 1 and var_41_0 or {}
		arg_41_0["showData" .. iter_41_0] = idlers.newWithMap(arg_41_0.datas[iter_41_0])
	end

	local var_41_1 = arg_41_0.txtState1:x()
	local var_41_2 = arg_41_0.txtState2:x()

	gGameUI.topuiManager:createView("default", arg_41_0, {
		onClose = arg_41_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_paihangbang.png"
	})

	arg_41_0.bottomTextState1 = idler.new("")
	arg_41_0.bottomTextState2 = idler.new("")

	local var_41_3 = {
		{
			subName = "Fight",
			type = "fight",
			sortValue = 1,
			name = gLanguageCsv.fighting,
			top = arg_41_0.topPanelFight,
			bottom = arg_41_0.bottomPanelFight
		},
		{
			subName = "CollectRate",
			type = "pokedex",
			sortValue = 2,
			name = gLanguageCsv.collectRate,
			top = arg_41_0.topPanelCollect,
			bottom = arg_41_0.bottomPanelCollect
		},
		[5] = {
			subName = "Union",
			unlockKey = "union",
			type = "union",
			sortValue = 5,
			name = gLanguageCsv.spaceGuild,
			top = arg_41_0.topPanelUnion,
			bottom = arg_41_0.bottomPanelUnion
		},
		[7] = {
			subName = "Craft",
			unlockKey = "craft",
			type = "craft",
			sortValue = 7,
			name = gLanguageCsv.craft,
			top = arg_41_0.topPanelCraft,
			bottom = arg_41_0.bottomPanelCraft
		},
		[8] = {
			subName = "Accumulated stars",
			type = "star",
			sortValue = 8,
			name = gLanguageCsv.gateStar,
			top = arg_41_0.topPanelGateStar,
			bottom = arg_41_0.bottomPanelGateStar
		}
	}

	arg_41_0.leftDatas = idlers.new()

	local var_41_4 = {}

	local function var_41_5(arg_42_0, arg_42_1)
		var_41_4[arg_42_0] = arg_42_1

		local var_42_0 = {}

		for iter_42_0, iter_42_1 in pairs(var_41_3) do
			if var_41_4[iter_42_0] == true then
				var_42_0[iter_42_0] = iter_42_1
			end
		end

		arg_41_0.leftDatas:update(var_42_0)
	end

	for iter_41_1, iter_41_2 in pairs(var_41_3) do
		if not iter_41_2.unlockKey then
			var_41_5(iter_41_1, true)
		else
			dataEasy.getListenUnlock(iter_41_2.unlockKey, functools.partial(var_41_5, iter_41_1))
		end
	end

	local var_41_6 = gGameModel.role:getIdler("union_db_id")
	local var_41_7 = true
	local var_41_8 = arg_41_0.bottomPanelUnion:multiget("txtRank", "txtName", "txtStatic1", "txtState1", "txtState2", "txtState3")

	if var_41_6:read() then
		itertools.invoke({
			var_41_8.txtRank,
			var_41_8.txtName,
			var_41_8.txtStatic1,
			var_41_8.txtState1,
			var_41_8.txtState2,
			var_41_8.txtState3
		}, "show")
		arg_41_0.bottomPanelUnion:get("none"):hide()
		idlereasy.any({
			arg_41_0.unionName,
			arg_41_0.unionLevel,
			arg_41_0.chairmanId,
			arg_41_0.members
		}, function(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
			var_41_8.txtName:text(arg_43_1)
			var_41_8.txtState1:text(arg_43_2)

			local var_43_0 = arg_43_4[arg_43_3]

			var_41_8.txtState3:text(var_43_0.name)

			local var_43_1 = itertools.size(arg_43_4)
			local var_43_2 = csv.union.union_level[arg_43_2].memberMax

			var_41_8.txtState2:text(var_43_1 .. "/" .. var_43_2)
			arg_41_0.bottomPanelGateStar:get("txtUnion"):text(arg_43_1)
		end)
	else
		arg_41_0.bottomPanelUnion:get("none"):show()
		itertools.invoke({
			var_41_8.txtRank,
			var_41_8.txtName,
			var_41_8.txtStatic1,
			var_41_8.txtState1,
			var_41_8.txtState2,
			var_41_8.txtState3
		}, "hide")
		arg_41_0.bottomPanelGateStar:get("txtUnion"):text(gLanguageCsv.none)
	end

	arg_41_0.bottomPanelCraft:get("txtScore"):text("")
	arg_41_0.bottomPanelCraft:get("txtRecord"):text("")

	for iter_41_3, iter_41_4 in ipairs(var_0_0) do
		arg_41_0[iter_41_4]:visible(false)
	end

	arg_41_0.showTab = idler.new(1)

	arg_41_0.powerList:visible(true)
	arg_41_0.showTab:addListener(function(arg_44_0, arg_44_1, arg_44_2)
		arg_41_0[var_0_0[arg_44_1]]:visible(false)
		arg_41_0[var_0_0[arg_44_0]]:visible(true)

		if arg_44_0 ~= arg_44_1 then
			arg_41_0.datas[arg_44_0] = {}

			arg_41_0["showData" .. arg_44_0]:update({})
		end

		dataEasy.tryCallFunc(arg_41_0[var_0_0[arg_44_0]], "setItemAction", {
			isAction = true
		})

		if arg_41_0.leftDatas:atproxy(arg_44_0).type and #arg_41_0.datas[arg_44_0] == 0 then
			arg_41_0:sendProtocol(arg_41_0.leftDatas:atproxy(arg_44_0).type, 0, arg_44_0, arg_41_0[var_0_0[arg_44_0]])
		end

		arg_41_0.leftDatas:atproxy(arg_44_1).select = false
		arg_41_0.leftDatas:atproxy(arg_44_0).select = true

		arg_41_0.leftDatas:atproxy(arg_44_1).top:hide()
		arg_41_0.leftDatas:atproxy(arg_44_1).bottom:hide()
		arg_41_0.leftDatas:atproxy(arg_44_0).top:show()
		arg_41_0.leftDatas:atproxy(arg_44_0).bottom:show()
	end)

	for iter_41_5, iter_41_6 in ipairs(var_0_0) do
		local var_41_9 = arg_41_0[iter_41_6]:getInnerContainer()

		arg_41_0[iter_41_6]:onScroll(function(arg_45_0)
			if var_41_9:getPositionY() >= -10 and arg_41_0.isCanDown and arg_41_0.leftDatas:atproxy(iter_41_5).type then
				arg_41_0.isCanDown = false

				arg_41_0:sendProtocol(arg_41_0.leftDatas:atproxy(iter_41_5).type, #arg_41_0.datas[iter_41_5], iter_41_5, arg_41_0[iter_41_6])
			end
		end)
	end
end

function var_0_3.initModel(arg_46_0)
	arg_46_0.roleName = gGameModel.role:getIdler("name")
	arg_46_0.level = gGameModel.role:getIdler("level")
	arg_46_0.fightRank = gGameModel.role:getIdler("fight_rank")
	arg_46_0.power = gGameModel.role:getIdler("top6_fighting_point")
	arg_46_0.id = gGameModel.role:read("id")
	arg_46_0.pokedex = gGameModel.role:getIdler("pokedex")
	arg_46_0.cardNumRank = gGameModel.role:getIdler("cardNum_rank")
	arg_46_0.unionId = gGameModel.role:getIdler("union_db_id")
	arg_46_0.gate_star_rank = gGameModel.role:getIdler("gate_star_rank")
	arg_46_0.gate_star_sum = gGameModel.role:getIdler("gate_star_sum")

	if arg_46_0.unionId:read() then
		arg_46_0.unionRank = gGameModel.union:getIdler("rank")
		arg_46_0.unionName = gGameModel.union:getIdler("name")
		arg_46_0.unionLevel = gGameModel.union:getIdler("level")
		arg_46_0.chairmanId = gGameModel.union:getIdler("chairman_db_id")
		arg_46_0.members = gGameModel.union:getIdler("members")
	end

	arg_46_0.craftRank = gGameModel.daily_record:getIdler("craft_rank")
end

function var_0_3.onTabClick(arg_47_0, arg_47_1, arg_47_2)
	arg_47_0.showTab:set(arg_47_2)
end

function var_0_3.onUnionHeadClick(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4, arg_48_5)
	gGameUI:stackUI("city.union.join.detail", nil, nil, arg_48_2, arg_48_3, nil, arg_48_0:createHandler("unionCb"))
end

function var_0_3.unionCb(arg_49_0)
	var_0_2.onClose(arg_49_0)
	gGameUI:stackUI("city.union.view", nil, {
		full = true
	})
end

function var_0_3.onHeadClick(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4, arg_50_5)
	if arg_50_0.id == arg_50_3.id then
		return
	end

	local var_50_0 = arg_50_5.target
	local var_50_1, var_50_2 = var_50_0:xy()
	local var_50_3 = var_50_0:getParent():convertToWorldSpace(cc.p(var_50_1, var_50_2))

	gGameUI:stackUI("city.chat.personal_info", nil, {
		clickClose = true,
		dispatchNodes = arg_50_1:parent()
	}, var_50_3, {
		role = arg_50_3
	}, {
		speical = "rank",
		disableTouch = true,
		target = arg_50_1.item:get("bg")
	})
end

return var_0_3
