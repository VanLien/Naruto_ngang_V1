local var_0_0 = class("WorldBossRankView", Dialog)

var_0_0.RESOURCE_FILENAME = "activity_world_boss_rank.json"
var_0_0.RESOURCE_BINDING = {
	unionPanel = "unionPanel",
	["trainerPanel.myRankPanel.txtName"] = "myName",
	["leftPanel.tabItem"] = "tabItem",
	["unionPanel.myRankPanel.txtName"] = "myUnionName",
	noRankPanel = "noRankPanel",
	["unionPanel.myRankPanel.txtDamage"] = "myUnionDamage",
	rightPanel = "rightPanel",
	["unionPanel.rankItem"] = "unionRankItem",
	["unionPanel.myRankPanel.txtRank"] = "myUnionRank",
	trainerPanel = "trainerPanel",
	["trainerPanel.rankItem"] = "trainerRankItem",
	["leftPanel.tabList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("tabItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("normal")
					local var_1_1 = arg_1_1:get("selected")
					local var_1_2

					if arg_1_3.select then
						var_1_0:hide()

						var_1_2 = var_1_1:show()
					else
						var_1_1:hide()

						var_1_2 = var_1_0:show()
					end

					adapt.setAutoMultiLine(var_1_2:get("txt"), arg_1_3.name, nil, 5)
					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	["trainerPanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("showData1"),
				item = bindHelper.self("trainerRankItem"),
				itemAction = {
					isAction = true,
					alwaysShow = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("txtRank", "headPanel", "rankIcon", "txtName", "txtDamage", "txt", "level")

					bind.extend(arg_2_0, var_2_0.headPanel, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_2_3.role.logo,
							frameId = arg_2_3.role.frame,
							onNode = function(arg_3_0)
								arg_3_0:xy(104, 95):z(6):scale(0.9)
							end
						}
					})
					var_2_0.txtName:text(arg_2_3.role.name)
					var_2_0.level:text(arg_2_3.role.level)
					text.addEffect(var_2_0.txt, {
						outline = {
							color = ui.NEWCOLORS.OUTLINE.YELLOW
						}
					})
					text.addEffect(var_2_0.level, {
						outline = {
							color = ui.NEWCOLORS.OUTLINE.YELLOW
						}
					})
					adapt.oneLineCenterPos(cc.p(385, 5), {
						var_2_0.txt,
						var_2_0.level
					}, cc.p(2, 0))
					var_2_0.txtRank:visible(arg_2_2 > 3):text(arg_2_2)
					var_2_0.rankIcon:hide()

					if arg_2_2 <= 3 then
						var_2_0.rankIcon:show():texture("activity/world_boss/img_rank" .. arg_2_2 .. ".png")
					end

					var_2_0.txtDamage:text(arg_2_3.boss_damage)
					bind.touch(arg_2_0, arg_2_1, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_1, arg_2_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		},
		{
			event = "touch",
			methods = {
				ended = bindHelper.self("btnrightClose")
			}
		},
		varname = "rankList"
	},
	["unionPanel.list"] = {
		varname = "rankList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("showData2"),
				item = bindHelper.self("unionRankItem"),
				itemAction = {
					isAction = true,
					alwaysShow = true
				},
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("txtRank", "headPanel", "rankIcon", "txtName", "txtDamage", "icon", "txt", "level")

					var_4_0.txtName:text(arg_4_3.name)
					var_4_0.level:text(arg_4_3.level)
					text.addEffect(var_4_0.txt, {
						outline = {
							color = ui.COLORS.OUTLINE.DEFAULT
						}
					})
					text.addEffect(var_4_0.level, {
						outline = {
							color = ui.COLORS.OUTLINE.DEFAULT
						}
					})
					adapt.oneLineCenterPos(cc.p(385, 5), {
						var_4_0.txt,
						var_4_0.level
					}, cc.p(2, 0))
					var_4_0.icon:texture(csv.union.union_logo[arg_4_3.logo].icon)
					var_4_0.txtRank:visible(arg_4_2 > 3):text(arg_4_2)
					var_4_0.rankIcon:hide()

					if arg_4_2 <= 3 then
						var_4_0.rankIcon:show():texture("activity/world_boss/img_rank" .. arg_4_2 .. ".png")
					end

					var_4_0.txtDamage:text(arg_4_3.damage)
				end
			}
		}
	},
	["rightPanel.title1.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = cc.c4b(212, 86, 95, 255)
				}
			}
		}
	},
	["rightPanel.title2.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = cc.c4b(212, 86, 95, 255)
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.trainerPanel:hide()
	arg_5_0.unionPanel:hide()
	arg_5_0.noRankPanel:hide()
	arg_5_0.rightPanel:get("list1"):setScrollBarEnabled(false)
	arg_5_0.rightPanel:get("list2"):setScrollBarEnabled(false)

	arg_5_0.showData1 = idlers.newWithMap(arg_5_2.roleRank.ranks or {})
	arg_5_0.showData2 = idlers.newWithMap(arg_5_2.unionRank.ranks or {})
	arg_5_0.panel = {
		{
			node = arg_5_0.trainerPanel,
			data = arg_5_2.roleRank
		},
		{
			node = arg_5_0.unionPanel,
			data = arg_5_2.unionRank
		}
	}
	arg_5_0.tabDatas = idlers.newWithMap({
		{
			name = gLanguageCsv.role
		},
		{
			name = gLanguageCsv.guild
		}
	})
	arg_5_0.showTab = idler.new(1)

	arg_5_0.showTab:addListener(function(arg_6_0, arg_6_1)
		arg_5_0.tabDatas:atproxy(arg_6_1).select = false
		arg_5_0.tabDatas:atproxy(arg_6_0).select = true

		arg_5_0.rightPanel:hide()
		arg_5_0.panel[arg_6_1].node:hide()
		arg_5_0.panel[arg_6_0].node:show()

		local var_6_0 = itertools.isempty(arg_5_0.panel[arg_6_0].data.ranks)

		arg_5_0.noRankPanel:visible(var_6_0)

		local var_6_1 = arg_5_0.panel[arg_6_0].node:get("myRankPanel")

		var_6_1:visible(not var_6_0)

		local var_6_2 = arg_5_0.panel[arg_6_0].data

		var_6_1:get("txtRank"):text(var_6_2.selfRank == 0 and gLanguageCsv.notOnTheList or var_6_2.selfRank)
		var_6_1:get("txtDamage"):text(var_6_2.selfDamage)
		arg_5_0.myName:text(gGameModel.role:read("name"))

		if gGameModel.role:read("union_db_id") then
			arg_5_0.myUnionName:text(gGameModel.union:read("name"))
		else
			arg_5_0.myUnionName:text(gLanguageCsv.nonunion)
			arg_5_0.myUnionDamage:hide()
			arg_5_0.myUnionRank:hide()
		end
	end)
	Dialog.onCreate(arg_5_0)
end

function var_0_0.onTabClick(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0.showTab:set(arg_7_2)
end

function var_0_0.onItemClick(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0.rightPanel:show()

	local var_8_0 = arg_8_0.rightPanel:get("item")

	local function var_8_1(arg_9_0, arg_9_1, arg_9_2)
		arg_9_0:removeAllChildren()

		for iter_9_0 = arg_9_1, arg_9_2 do
			local var_9_0 = var_8_0:clone()

			arg_9_0:pushBackCustomItem(var_9_0)

			local var_9_1 = arg_8_3.boss_battle_cards[iter_9_0]

			if var_9_1 then
				local var_9_2 = csv.cards[var_9_1.card_id]
				local var_9_3 = csv.unit[var_9_2.unitID]
				local var_9_4 = dataEasy.getUnitId(var_9_1.card_id, var_9_1.skin_id)

				bind.extend(arg_8_0, var_9_0, {
					class = "card_icon",
					props = {
						unitId = var_9_4,
						advance = var_9_1.advance,
						star = var_9_1.star,
						rarity = var_9_3.rarity,
						levelProps = {
							data = var_9_1.level
						}
					}
				})
			else
				var_9_0:get("emptyPanel"):show()
			end
		end
	end

	var_8_1(arg_8_0.rightPanel:get("list1"), 1, 3)
	var_8_1(arg_8_0.rightPanel:get("list2"), 4, 6)
end

return var_0_0
