local var_0_0 = {
	nightmare = 3,
	hero = 2,
	normal = 1
}
local var_0_1 = {
	[var_0_0.normal] = 10,
	[var_0_0.hero] = 110,
	[var_0_0.nightmare] = 210
}
local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("GateQuickView", Dialog)

local function var_0_4(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_3 = arg_1_3 or {}

	local var_1_0 = ccui.Layout:create():size(0, 0):hide()

	var_1_0:retain()
	arg_1_0:onNodeEvent("exit", function()
		if var_1_0 then
			var_1_0:release()

			var_1_0 = nil
		end
	end)
	bind.extend(arg_1_0, arg_1_1, {
		class = "listview",
		props = {
			data = dataEasy.getItemData(arg_1_2),
			item = var_1_0,
			margin = arg_1_3.margin,
			padding = arg_1_3.padding,
			dataOrderCmp = function(arg_3_0, arg_3_1)
				return arg_3_0.key > arg_3_1.key
			end,
			onAfterBuild = arg_1_3.onAfterBuild,
			onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				bind.extend(arg_4_0, arg_4_1, {
					class = "icon_key",
					props = {
						data = arg_4_3,
						grayState = arg_4_3.grayState,
						isDouble = arg_1_3.isDouble,
						onNode = function(arg_5_0)
							if arg_1_3.scale then
								arg_5_0:scale(arg_1_3.scale)
							end

							local var_5_0 = arg_5_0:box()

							arg_5_0:alignCenter(var_5_0)
							arg_4_1:size(var_5_0)

							if arg_1_3.onNode then
								arg_1_3.onNode(arg_5_0, arg_4_3)
							end
						end
					}
				})
			end
		}
	})
	arg_1_1:adaptTouchEnabled()
end

var_0_3.RESOURCE_FILENAME = "gate_quick.json"
var_0_3.RESOURCE_BINDING = {
	panel = "panel1",
	leftPanel = "leftPanel",
	["panel1.panelNormal.listPanel"] = "itemNormal",
	["panel1.panelNormal"] = "panelNormal",
	["leftPanel.tabItem"] = "tabItem",
	item = "item",
	["panel1.panelLike.listItem"] = "listItem",
	["panel.listPanel"] = "listPanel",
	panel1 = "panel2",
	["panel1.txt"] = "txt",
	["panel1.txt1"] = "txt1",
	["panel1.txt2"] = "txt2",
	["panel1.panelLike"] = "panelLike",
	bg1 = "bg",
	["panel1.icon"] = "icon",
	emptyPanel = "emptyPanel",
	["topPanel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["topPanel.txtNode"] = {
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
	["topPanel.txtNode1"] = {
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
	["panel.listPanel.item.btn.txt"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 3,
						color = ui.NEWCOLORS.OUTLINE.BLUE
					}
				}
			}
		}
	},
	["panel.listPanel.item.btn1.txt"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 3,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	["leftPanel.tabItem.selected.txt"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 3,
						color = ui.NEWCOLORS.OUTLINE.WHITE
					}
				}
			}
		}
	},
	["leftPanel.tabList"] = {
		varname = "tabList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("tabItem"),
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					local var_6_0 = arg_6_1:get("normal")
					local var_6_1 = arg_6_1:get("selected")
					local var_6_2

					if arg_6_3.select then
						var_6_0:hide()

						var_6_2 = var_6_1:show()
					else
						var_6_1:hide()

						var_6_2 = var_6_0:show()
					end

					adapt.setAutoText(var_6_2:get("txt"), arg_6_3.name, 240)
					var_6_1:setTouchEnabled(false)
					bind.touch(arg_6_0, var_6_0, {
						methods = {
							ended = functools.partial(arg_6_0.clickCell, arg_6_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	["panel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				preloadCenter = bindHelper.self("lastIdx"),
				data = bindHelper.self("dataNormal"),
				item = bindHelper.self("listPanel"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = arg_7_1:multiget("txtNode", "list", "item")

					var_7_0.txtNode:text(string.format(gLanguageCsv.getaSectionBoxTitle, arg_7_3.chapterId))
					text.addEffect(var_7_0.txtNode, {
						outline = {
							size = 4,
							color = cc.c4b(234, 67, 22, 255)
						}
					})
					var_7_0.item:hide()

					for iter_7_0, iter_7_1 in ipairs(arg_7_3.chapterTable) do
						local var_7_1 = var_7_0.item:clone()

						var_7_1:get("name"):text(arg_7_3.chapterId .. "-" .. iter_7_1.index)

						if iter_7_1.size < 3 then
							var_0_4(arg_7_0, var_7_1:get("list"), iter_7_1.item, {
								scale = 0.67,
								margin = 50
							})
						else
							var_0_4(arg_7_0, var_7_1:get("list"), iter_7_1.item, {
								scale = 0.67,
								margin = 5
							})
						end

						var_7_1:get("list"):setItemAlignCenter()
						var_7_0.list:addChild(var_7_1)

						if iter_7_1.star ~= 3 then
							var_7_1:get("btn"):hide()
							var_7_1:get("btn1.txt"):text(gLanguageCsv.talentChallenge)
							var_7_1:get("btn1"):x(265)
						else
							var_7_1:get("btn"):show()
						end

						var_7_1:show()
						bind.touch(arg_7_0, var_7_1:get("btn"), {
							methods = {
								ended = functools.partial(arg_7_0.flagBtn, iter_7_0, iter_7_1)
							}
						})
						bind.touch(arg_7_0, var_7_1:get("btn1"), {
							methods = {
								ended = functools.partial(arg_7_0.flagBtn1, iter_7_0, iter_7_1)
							}
						})
					end

					var_7_0.list:setScrollBarEnabled(false)
				end,
				onAfterBuild = function(arg_8_0)
					return
				end
			},
			handlers = {
				flagBtn = bindHelper.self("onSweepBtnTen"),
				flagBtn1 = bindHelper.self("onSweepBtnFifty")
			}
		}
	},
	["panel1.panelNormal.list"] = {
		varname = "list1",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				preloadCenter = bindHelper.self("lastIdx1"),
				data = bindHelper.self("dataHard"),
				item = bindHelper.self("itemNormal"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
					local var_9_0 = arg_9_1:multiget("txtNode", "list", "item1")

					var_9_0.txtNode:text(string.format(gLanguageCsv.getaSectionBoxTitle, arg_9_3.chapterId))
					text.addEffect(var_9_0.txtNode, {
						outline = {
							size = 4,
							color = cc.c4b(234, 67, 22, 255)
						}
					})
					var_9_0.item1:hide()
					var_9_0.list:removeAllChildren()

					for iter_9_0, iter_9_1 in ipairs(arg_9_3.chapterTable) do
						local var_9_1 = var_9_0.item1:clone()

						var_9_1:get("name"):text(arg_9_3.chapterId .. "-" .. iter_9_1.index)

						if iter_9_1.chance == 1 then
							var_9_1:get("chanceIcon"):show()
						else
							var_9_1:get("chanceIcon"):hide()
						end

						if iter_9_1.like == 1 then
							var_9_1:get("star2"):hide()
							var_9_1:get("star1"):show()
						else
							var_9_1:get("star2"):show()
							var_9_1:get("star1"):hide()
						end

						if iter_9_1.surplusTimes == 0 then
							var_9_1:get("btn.txt"):text(gLanguageCsv.reChallenge)
							var_9_1:get("btn"):texture("common/btn/btn_nomal_4white.png")
							text.addEffect(var_9_1:get("btn.txt"), {
								outline = {
									size = 3,
									color = ui.NEWCOLORS.OUTLINE.BLUE
								}
							})
						else
							text.addEffect(var_9_1:get("btn.txt"), {
								outline = {
									size = 3,
									color = ui.NEWCOLORS.OUTLINE.YELLOW
								}
							})
						end

						if iter_9_1.star ~= 3 then
							var_9_1:get("btn.txt"):text(gLanguageCsv.talentChallenge)
						end

						bind.touch(arg_9_0, var_9_1:get("icon"), {
							methods = {
								ended = functools.partial(arg_9_0.likeBtn, arg_9_2, iter_9_0, iter_9_1)
							}
						})

						if iter_9_1.chanceRecharge == false then
							var_9_1:get("panel"):setTouchEnabled(true)
							bind.touch(arg_9_0, var_9_1:get("panel"), {
								methods = {
									ended = functools.partial(arg_9_0.chanceBtn, arg_9_2, iter_9_0, iter_9_1)
								}
							})
						else
							var_9_1:get("panel"):setTouchEnabled(false)
						end

						if iter_9_1.star ~= 3 and iter_9_1.chanceRecharge == false then
							var_9_1:get("maskIcon"):show()
						else
							var_9_1:get("maskIcon"):hide()
						end

						bind.touch(arg_9_0, var_9_1:get("btn"), {
							methods = {
								ended = functools.partial(arg_9_0.flagBtn, iter_9_0, iter_9_1)
							}
						})
						bind.extend(arg_9_0, var_9_1:get("list"), {
							class = "icon_key",
							props = {
								data = {
									key = iter_9_1.item
								},
								onNode = function(arg_10_0)
									local var_10_0, var_10_1 = var_9_1:get("list"):xy()

									arg_10_0:xy(var_10_0 + 40, var_10_1 + 35):scale(0.7)
								end
							}
						})
						var_9_0.list:addChild(var_9_1)
						var_9_1:show()
					end

					var_9_0.list:setScrollBarEnabled(false)
				end,
				onAfterBuild = function(arg_11_0)
					return
				end
			},
			handlers = {
				likeBtn = bindHelper.self("onLikeBtn"),
				chanceBtn = bindHelper.self("onChanceBtn"),
				flagBtn = bindHelper.self("onSweepBtn")
			}
		}
	},
	["panel1.panelLike.list"] = {
		varname = "panelLikeList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 4,
				data = bindHelper.self("dataLike"),
				item = bindHelper.self("listItem"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
					local var_12_0 = arg_12_1:multiget("name", "icon1", "bg", "btn", "star1", "star2", "chanceIcon", "maskIcon", "icon", "panel")

					var_12_0.name:text(arg_12_3.chapterId .. "-" .. arg_12_3.index)

					if arg_12_3.like == 1 then
						var_12_0.star2:hide()
						var_12_0.star1:show()
					else
						var_12_0.star2:show()
						var_12_0.star1:hide()
					end

					if arg_12_3.surplusTimes == 0 then
						var_12_0.btn:get("txt"):text(gLanguageCsv.reChallenge)
						var_12_0.btn:texture("common/btn/btn_nomal_4white.png")
						text.addEffect(var_12_0.btn:get("txt"), {
							outline = {
								size = 3,
								color = ui.NEWCOLORS.OUTLINE.BLUE
							}
						})
					else
						text.addEffect(var_12_0.btn:get("txt"), {
							outline = {
								size = 3,
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
					end

					if arg_12_3.star ~= 3 then
						var_12_0.btn:get("txt"):text(gLanguageCsv.talentChallenge)
					end

					if arg_12_3.chance == 1 then
						var_12_0.chanceIcon:show()
					else
						var_12_0.chanceIcon:hide()
					end

					bind.touch(arg_12_0, var_12_0.btn, {
						methods = {
							ended = functools.partial(arg_12_0.flagBtn, arg_12_2, arg_12_3)
						}
					})
					bind.touch(arg_12_0, var_12_0.icon, {
						methods = {
							ended = functools.partial(arg_12_0.likeBtn1, arg_12_0:getIdx(arg_12_2).k, arg_12_3)
						}
					})

					if arg_12_3.chanceRecharge == false then
						var_12_0.panel:setTouchEnabled(true)
						bind.touch(arg_12_0, var_12_0.panel, {
							methods = {
								ended = functools.partial(arg_12_0.chanceBtnLike, arg_12_0:getIdx(arg_12_2).k, arg_12_3)
							}
						})
					else
						var_12_0.panel:setTouchEnabled(false)
					end

					if arg_12_3.star ~= 3 and arg_12_3.chanceRecharge == false then
						var_12_0.maskIcon:show()
					else
						var_12_0.maskIcon:hide()
					end

					bind.extend(arg_12_0, var_12_0.icon1, {
						class = "icon_key",
						props = {
							data = {
								key = arg_12_3.item
							},
							onNode = function(arg_13_0)
								local var_13_0, var_13_1 = var_12_0.chanceIcon:xy()

								arg_13_0:xy(var_13_0 + 20, var_13_1 - 70):scale(0.7):z(3)
							end
						}
					})
				end,
				onAfterBuild = function(arg_14_0)
					return
				end
			},
			handlers = {
				chanceBtnLike = bindHelper.self("onChanceBtnLike"),
				likeBtn1 = bindHelper.self("onLikeBtn1"),
				flagBtn = bindHelper.self("onSweepBtn")
			}
		}
	},
	["panel1.btnBuy1"] = {
		varname = "btnBuy1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChangeClick")
			}
		}
	},
	["panel1.btnBuy1.txt"] = {
		varname = "btnBuy1Txt",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["panel1.btnBuy3.txt"] = {
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
	["panel1.btnBuy2"] = {
		varname = "btnBuy2",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChanceClick")
			}
		}
	},
	["panel1.btnBuy2.txt"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			},
			{
				event = "text",
				idler = bindHelper.self("chanceRecharge"),
				method = function(arg_15_0)
					if arg_15_0 then
						return gLanguageCsv.setTarget
					end

					return gLanguageCsv.confirmSelection
				end
			}
		}
	},
	["panel1.btnBuy3"] = {
		varname = "btnBuy3",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAllsweepclick")
			}
		}
	}
}

function var_0_3.onCreate(arg_16_0)
	arg_16_0.bg:height(1119)

	arg_16_0.owerCollection = idlers.new()

	arg_16_0:initModel()
	arg_16_0.panel1:hide()
	arg_16_0.panel2:hide()
	arg_16_0.panelLike:hide()

	arg_16_0.showTab = idler.new(1)
	arg_16_0.dataNormal = idlers.new()
	arg_16_0.dataHard = idlers.new()
	arg_16_0.dataLike = idlers.new()
	arg_16_0.lastIdx = 1
	arg_16_0.lastIdx1 = 1
	arg_16_0.chance = {}
	arg_16_0.chance1 = {}
	arg_16_0.hardClickFirst = false
	arg_16_0.likeClickFirst = false

	local var_16_0 = userDefault.getForeverLocalKey("gateChanceData", {})

	for iter_16_0, iter_16_1 in pairs(var_16_0) do
		table.insert(arg_16_0.chance, iter_16_1)
	end

	local var_16_1 = userDefault.getForeverLocalKey("gateChanceData1", {})

	for iter_16_2, iter_16_3 in pairs(var_16_1) do
		table.insert(arg_16_0.chance1, iter_16_3)
	end

	arg_16_0:deleteUnlike()

	arg_16_0.myCollectionData = {}
	arg_16_0.chanceData = idlers.new()
	arg_16_0.chanceData1 = idlers.new()
	arg_16_0.chanceDataUpd = idlers.new()
	arg_16_0.chanceDataUpd1 = idlers.new()

	arg_16_0.chanceData:update(arg_16_0.chance)
	arg_16_0.chanceData1:update(arg_16_0.chance1)
	arg_16_0.chanceDataUpd:update(arg_16_0.chance)
	arg_16_0.chanceDataUpd1:update(arg_16_0.chance1)

	arg_16_0.myCollection = idlers.new()
	arg_16_0.selectRecharge = idler.new(true)
	arg_16_0.chanceRecharge = idler.new(true)

	local var_16_2 = gGameModel.role:read("level")
	local var_16_3 = {}
	local var_16_4 = csv.scene_conf
	local var_16_5 = csv.world_map
	local var_16_6 = var_0_1[var_0_0.normal]
	local var_16_7 = var_0_1[var_0_0.hero]

	for iter_16_4, iter_16_5 in ipairs(arg_16_0.mapOpen:read()) do
		if var_16_5[iter_16_5].chapterType == 1 and var_16_2 >= var_16_5[iter_16_5].openLevel then
			table.insert(var_16_3, {
				chapterId = iter_16_5 - var_16_6,
				chapterTable = {}
			})
		end
	end

	if not itertools.isempty(var_16_3) then
		table.sort(var_16_3, function(arg_17_0, arg_17_1)
			return arg_17_0.chapterId < arg_17_1.chapterId
		end)
	end

	for iter_16_6, iter_16_7 in ipairs(arg_16_0.gateOpen:read()) do
		local var_16_8 = var_16_4[iter_16_7].ownerId

		if var_16_5[var_16_8].chapterType == 1 and var_16_2 >= var_16_5[var_16_8].openLevel and var_16_4[iter_16_7].kssdFlag == 1 then
			local var_16_9 = 0

			for iter_16_8, iter_16_9 in ipairs(var_16_5[var_16_4[iter_16_7].ownerId].seq) do
				if iter_16_7 == iter_16_9 then
					var_16_9 = iter_16_8
				end
			end

			local var_16_10 = {}
			local var_16_11 = {}
			local var_16_12 = 0

			for iter_16_10, iter_16_11 in pairs(var_16_4[iter_16_7].dropIds) do
				if type(iter_16_10) == "number" then
					table.insert(var_16_10, {
						key = iter_16_10,
						num = iter_16_11
					})
				end
			end

			table.sort(var_16_10, function(arg_18_0, arg_18_1)
				return arg_18_0.key > arg_18_1.key
			end)

			for iter_16_12, iter_16_13 in ipairs(var_16_10) do
				if iter_16_12 <= 3 then
					table.insert(var_16_11, iter_16_13)
				end

				var_16_12 = var_16_12 + 1
			end

			table.insert(var_16_3[var_16_4[iter_16_7].ownerId - var_16_6].chapterTable, {
				chapterId = var_16_3[var_16_4[iter_16_7].ownerId - var_16_6].chapterId,
				id = iter_16_7,
				item = var_16_11,
				index = var_16_9,
				size = var_16_12,
				star = arg_16_0.gateStar:read()[iter_16_7] and arg_16_0.gateStar:read()[iter_16_7].star or 0
			})
		end
	end

	local var_16_13 = 0

	for iter_16_14, iter_16_15 in ipairs(var_16_3) do
		if not itertools.isempty(iter_16_15.chapterTable) then
			table.sort(iter_16_15.chapterTable, function(arg_19_0, arg_19_1)
				return arg_19_0.id < arg_19_1.id
			end)
		end

		var_16_13 = var_16_13 + 1
	end

	arg_16_0.dataNormal:update(var_16_3)

	arg_16_0.lastIdx = var_16_13

	idlereasy.any({
		arg_16_0.chanceDataUpd,
		arg_16_0.chanceRecharge,
		arg_16_0.gateTimes,
		arg_16_0.selectRecharge,
		arg_16_0.collection
	}, function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
		local var_20_0 = gGameModel.role:read("level")
		local var_20_1 = {}

		for iter_20_0, iter_20_1 in ipairs(arg_16_0.mapOpen:read()) do
			if var_16_5[iter_20_1].chapterType == 2 and var_20_0 >= var_16_5[iter_20_1].openLevel then
				table.insert(var_20_1, {
					chapterId = iter_20_1 - var_16_7,
					chapterTable = {}
				})
			end
		end

		if not itertools.isempty(var_20_1) then
			table.sort(var_20_1, function(arg_21_0, arg_21_1)
				return arg_21_0.chapterId < arg_21_1.chapterId
			end)
		end

		for iter_20_2, iter_20_3 in ipairs(arg_16_0.gateOpen:read()) do
			local var_20_2 = var_16_4[iter_20_3].ownerId

			if var_16_5[var_20_2].chapterType == 2 and var_20_0 >= var_16_5[var_20_2].openLevel and var_16_4[iter_20_3].kssdFlag == 1 then
				local var_20_3 = 0

				for iter_20_4, iter_20_5 in pairs(var_16_4[iter_20_3].dropIds) do
					if type(iter_20_4) == "number" then
						var_20_3 = math.max(var_20_3, iter_20_4)
					end
				end

				local var_20_4 = var_16_4[iter_20_3].dayChallengeMax - (arg_20_3[iter_20_3] or 0)
				local var_20_5 = 0
				local var_20_6 = 0

				for iter_20_6, iter_20_7 in ipairs(arg_20_5) do
					if iter_20_7 == iter_20_3 then
						var_20_5 = 1
					end
				end

				for iter_20_8, iter_20_9 in ipairs(arg_16_0.chance) do
					if iter_20_9 == iter_20_3 then
						var_20_6 = 1
					end
				end

				local var_20_7 = 0

				for iter_20_10, iter_20_11 in ipairs(var_16_5[var_16_4[iter_20_3].ownerId].seq) do
					if iter_20_3 == iter_20_11 then
						var_20_7 = iter_20_10
					end
				end

				table.insert(var_20_1[var_16_4[iter_20_3].ownerId - var_16_7].chapterTable, {
					chapterId = var_20_1[var_16_4[iter_20_3].ownerId - var_16_7].chapterId,
					id = iter_20_3,
					item = var_20_3,
					chanceRecharge = arg_20_2,
					chance = var_20_6,
					like = var_20_5,
					surplusTimes = var_20_4,
					star = arg_16_0.gateStar:read()[iter_20_3] and arg_16_0.gateStar:read()[iter_20_3].star or 0,
					index = var_20_7
				})
			end
		end

		local var_20_8 = 0

		for iter_20_12, iter_20_13 in ipairs(var_20_1) do
			if not itertools.isempty(iter_20_13.chapterTable) then
				table.sort(iter_20_13.chapterTable, function(arg_22_0, arg_22_1)
					return arg_22_0.id < arg_22_1.id
				end)
			end

			var_20_8 = var_20_8 + 1
		end

		arg_16_0.lastIdx1 = var_20_8

		dataEasy.tryCallFunc(arg_16_0.list1, "updatePreloadCenterIndex")
		arg_16_0.dataHard:update(var_20_1)
	end)

	arg_16_0.panel = {
		{
			node = arg_16_0.panel1,
			data = arg_16_0.dataNormal
		},
		{
			node = arg_16_0.panel2,
			data = arg_16_0.dataHard
		}
	}
	arg_16_0.tabDatas = idlers.newWithMap({
		{
			fontSize = 50,
			name = gLanguageCsv.gateStoryBlank
		},
		{
			fontSize = 50,
			name = gLanguageCsv.gateDifficultBlank
		}
	})

	arg_16_0.showTab:addListener(function(arg_23_0, arg_23_1)
		arg_16_0.tabDatas:atproxy(arg_23_1).select = false
		arg_16_0.tabDatas:atproxy(arg_23_0).select = true

		arg_16_0.panel[arg_23_1].node:hide()
		arg_16_0.panel[arg_23_0].node:show()
	end)
	idlereasy.any({
		arg_16_0.selectRecharge,
		arg_16_0.chanceRecharge
	}, function(arg_24_0, arg_24_1, arg_24_2)
		if arg_24_1 == false and itertools.isempty(arg_16_0.owerCollectionData) then
			arg_16_0.emptyPanel:show()
		else
			arg_16_0.emptyPanel:hide()
		end

		if arg_24_2 == true then
			if arg_24_1 == true then
				arg_16_0.btnBuy1Txt:text(gLanguageCsv.onlyCollection)
				arg_16_0.panelNormal:show()
				arg_16_0.panelLike:hide()
			else
				arg_16_0.btnBuy1Txt:text(gLanguageCsv.seeAll)
				arg_16_0.panelNormal:hide()
				arg_16_0.panelLike:show()
			end

			arg_16_0.txt2:hide()
		else
			arg_16_0.btnBuy1Txt:text(gLanguageCsv.cleanAllChance)
			arg_16_0.txt2:show()
		end
	end)
	idlereasy.any({
		arg_16_0.chanceData,
		arg_16_0.gateTimes,
		arg_16_0.chanceData1,
		arg_16_0.selectRecharge
	}, function(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
		arg_16_0.staminaCost = 0

		local var_25_0 = gGameModel.role:read("level")

		if arg_16_0.selectRecharge:read() == true then
			for iter_25_0, iter_25_1 in ipairs(arg_16_0.chance) do
				local var_25_1 = var_16_4[iter_25_1].ownerId

				if var_25_0 >= var_16_5[var_25_1].openLevel then
					local var_25_2 = var_16_4[iter_25_1].dayChallengeMax - (arg_25_2[iter_25_1] or 0)

					arg_16_0.staminaCost = csv.scene_conf[iter_25_1].staminaCost * var_25_2 + arg_16_0.staminaCost
				end
			end
		else
			for iter_25_2, iter_25_3 in ipairs(arg_16_0.chance1) do
				local var_25_3 = var_16_4[iter_25_3].ownerId

				if var_25_0 >= var_16_5[var_25_3].openLevel then
					local var_25_4 = var_16_4[iter_25_3].dayChallengeMax - (arg_25_2[iter_25_3] or 0)

					arg_16_0.staminaCost = csv.scene_conf[iter_25_3].staminaCost * var_25_4 + arg_16_0.staminaCost
				end
			end
		end

		arg_16_0.txt1:text(arg_16_0.staminaCost)
		adapt.oneLineCenterPos(cc.p(1475, 57), {
			arg_16_0.txt,
			arg_16_0.icon,
			arg_16_0.txt1
		}, cc.p(2, 0))
	end)
	arg_16_0.txt2:text(gLanguageCsv.chooseGateToSweepText)
	Dialog.onCreate(arg_16_0)
end

function var_0_3.initModel(arg_26_0)
	arg_26_0.owerCollectionData = {}
	arg_26_0.gateOpen = gGameModel.role:getIdler("gate_open")
	arg_26_0.collection = gGameModel.role:getIdler("mop_up_collection")

	for iter_26_0, iter_26_1 in ipairs(arg_26_0.collection:read()) do
		table.insert(arg_26_0.owerCollectionData, iter_26_1)
	end

	arg_26_0.owerCollection:update(arg_26_0.owerCollectionData)

	arg_26_0.gateStar = gGameModel.role:getIdler("gate_star")
	arg_26_0.mapOpen = gGameModel.role:getIdler("map_open")
	arg_26_0.gateTimes = gGameModel.daily_record:getIdler("gate_times")
	arg_26_0.roleLv = gGameModel.role:getIdler("level")
	arg_26_0.buyHerogateTimes = gGameModel.daily_record:getIdler("buy_herogate_times")
	arg_26_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_26_0.buyHerogateTimes = gGameModel.daily_record:getIdler("buy_herogate_times")
	arg_26_0.rmb = gGameModel.role:getIdler("rmb")
end

function var_0_3.onTabClick(arg_27_0, arg_27_1, arg_27_2)
	arg_27_0.showTab:set(arg_27_2)

	if arg_27_2 == 1 then
		arg_27_0.bg:height(1119)
		arg_27_0.bg:hide()
	else
		idlereasy.when(arg_27_0.selectRecharge, function(arg_28_0, arg_28_1)
			if arg_28_1 == true then
				arg_27_0.bg:height(1008)
				arg_27_0.bg:hide()
			else
				arg_27_0.bg:hide()
			end
		end)
	end
end

function var_0_3.onItemClick(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	gGameUI:showItemDetail(arg_29_2, {
		key = arg_29_4.key,
		num = arg_29_4.num
	})
end

function var_0_3.onChangeClick(arg_30_0)
	if arg_30_0.likeClickFirst == false then
		local var_30_0 = csv.scene_conf
		local var_30_1 = csv.world_map
		local var_30_2 = var_0_1[var_0_0.normal]
		local var_30_3 = var_0_1[var_0_0.hero]

		idlereasy.any({
			arg_30_0.chanceDataUpd1,
			arg_30_0.chanceRecharge,
			arg_30_0.gateTimes,
			arg_30_0.owerCollection,
			arg_30_0.myCollection
		}, function(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5)
			local var_31_0 = {}
			local var_31_1 = gGameModel.role:read("level")

			for iter_31_0, iter_31_1 in ipairs(arg_31_4) do
				local var_31_2 = var_30_0[iter_31_1:read()].dayChallengeMax - (arg_31_3[iter_31_1:read()] or 0)
				local var_31_3 = 0
				local var_31_4 = 0

				for iter_31_2, iter_31_3 in ipairs(arg_31_5) do
					if iter_31_3:read().id == iter_31_1:read() then
						var_31_3 = 1
					end
				end

				local var_31_5 = 0

				for iter_31_4, iter_31_5 in pairs(var_30_0[iter_31_1:read()].dropIds) do
					if type(iter_31_4) ~= "number" or iter_31_4 < var_31_5 then
						-- block empty
					else
						var_31_5 = iter_31_4
					end
				end

				for iter_31_6, iter_31_7 in ipairs(arg_30_0.chance1) do
					if iter_31_7 == iter_31_1:read() then
						var_31_4 = 1
					end
				end

				local var_31_6 = 0

				for iter_31_8, iter_31_9 in ipairs(var_30_1[var_30_0[iter_31_1:read()].ownerId].seq) do
					if iter_31_1:read() == iter_31_9 then
						var_31_6 = iter_31_8
					end
				end

				local var_31_7 = var_30_0[iter_31_1:read()].ownerId - var_30_3

				if var_31_1 >= var_30_1[var_30_0[iter_31_1:read()].ownerId].openLevel then
					table.insert(var_31_0, {
						chapterId = var_31_7,
						id = iter_31_1:read(),
						item = var_31_5,
						like = var_31_3,
						chanceRecharge = arg_31_2,
						chance = var_31_4,
						surplusTimes = var_31_2,
						star = arg_30_0.gateStar:read()[iter_31_1:read()] and arg_30_0.gateStar:read()[iter_31_1:read()].star or 0,
						index = var_31_6
					})
				end
			end

			table.sort(var_31_0, function(arg_32_0, arg_32_1)
				return arg_32_0.id < arg_32_1.id
			end)
			arg_30_0.dataLike:update(var_31_0)
		end)

		arg_30_0.likeClickFirst = true
	end

	if arg_30_0.chanceRecharge:read() == false then
		if arg_30_0.selectRecharge:read() == true then
			arg_30_0.chance = {}

			arg_30_0.chanceData:update(arg_30_0.chance)
			arg_30_0.chanceDataUpd:update(arg_30_0.chance)
		else
			arg_30_0.chance1 = {}

			arg_30_0.chanceData1:update(arg_30_0.chance1)
			arg_30_0.chanceDataUpd1:update(arg_30_0.chance1)
		end
	else
		arg_30_0.selectRecharge:modify(function(arg_33_0)
			return true, not arg_33_0
		end)
	end
end

function var_0_3.onChanceClick(arg_34_0)
	arg_34_0.chanceRecharge:modify(function(arg_35_0)
		if arg_35_0 == false then
			userDefault.setForeverLocalKey("gateChanceData", arg_34_0.chance, {
				new = true
			})
			userDefault.setForeverLocalKey("gateChanceData1", arg_34_0.chance1, {
				new = true
			})
		end

		return true, not arg_35_0
	end)
end

function var_0_3.checkSweep(arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = csv.scene_conf[arg_36_1.id].staminaCost
	local var_36_1 = dataEasy.getStamina()

	if var_36_1 < var_36_0 then
		gGameUI:stackUI("common.gain_stamina")

		return false
	end

	arg_36_0.curMopUpNum = math.min(arg_36_2, math.floor(var_36_1 / var_36_0))

	return true
end

function var_0_3.checkAllSweep(arg_37_0)
	local var_37_0 = dataEasy.getStamina()

	if arg_37_0.staminaCost == 0 then
		gGameUI:showTip(gLanguageCsv.timeNotEnoughToSweepAll)

		return false
	end

	if var_37_0 < arg_37_0.staminaCost then
		gGameUI:stackUI("common.gain_stamina")

		return false
	end

	return true
end

function var_0_3.onSweepBtnTen(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	local var_38_0 = 10

	if dataEasy.getSaoDangState(var_38_0).canSaoDang then
		if not arg_38_0:checkSweep(arg_38_3, var_38_0) then
			return
		end

		local var_38_1 = gGameModel.capture:read("limit_sprites")
		local var_38_2 = arg_38_0.roleLv:read()

		gGameApp:requestServer("/game/saodang", function(arg_39_0)
			local var_39_0 = arg_39_0.view.result

			table.insert(var_39_0, {
				exp = 0,
				isExtra = true,
				items = arg_39_0.view.extra
			})
			gGameUI:stackUI("city.gate.sweep", nil, nil, {
				from = "gate",
				hasExtra = true,
				sweepData = var_39_0,
				oldRoleLv = var_38_2,
				cb = arg_38_0:createHandler("onSweepBtnTen", arg_38_1, arg_38_2, arg_38_3),
				checkCb = arg_38_0:createHandler("checkSweep", arg_38_3, var_38_0),
				oldCapture = var_38_1,
				isDouble = dataEasy.isGateIdDoubleDrop(arg_38_3.id),
				gateId = arg_38_3.id,
				catchup = arg_39_0.view.catchup
			})
		end, arg_38_3.id, arg_38_0.curMopUpNum)
	else
		gGameUI:showTip(gLanguageCsv.saodangMultiRoleNotEnough)
	end
end

function var_0_3.onSweepBtnFifty(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	if arg_40_3.star ~= 3 then
		gGameUI:stackUI("city.gate.section_detail.view", nil, nil, arg_40_3.id, arg_40_3.chapterId)

		return
	end

	local var_40_0 = 50

	if dataEasy.getSaoDangState(var_40_0).canSaoDang then
		if not arg_40_0:checkSweep(arg_40_3, var_40_0) then
			return
		end

		local var_40_1 = gGameModel.capture:read("limit_sprites")
		local var_40_2 = arg_40_0.roleLv:read()

		gGameApp:requestServer("/game/saodang", function(arg_41_0)
			local var_41_0 = arg_41_0.view.result

			table.insert(var_41_0, {
				exp = 0,
				isExtra = true,
				items = arg_41_0.view.extra
			})
			gGameUI:stackUI("city.gate.sweep", nil, nil, {
				from = "gate",
				hasExtra = true,
				sweepData = var_41_0,
				oldRoleLv = var_40_2,
				cb = arg_40_0:createHandler("onSweepBtnFifty", arg_40_1, arg_40_2, arg_40_3),
				checkCb = arg_40_0:createHandler("checkSweep", arg_40_3, var_40_0),
				oldCapture = var_40_1,
				isDouble = dataEasy.isGateIdDoubleDrop(arg_40_3.id),
				gateId = arg_40_3.id,
				catchup = arg_41_0.view.catchup
			})
		end, arg_40_3.id, arg_40_0.curMopUpNum)
	else
		gGameUI:showTip(gLanguageCsv.saodangMultiRoleNotEnough)
	end
end

function var_0_3.onSweepBtn(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	if arg_42_3.star ~= 3 then
		gGameUI:stackUI("city.gate.section_detail.view", nil, nil, arg_42_3.id, arg_42_3.chapterId)

		return
	end

	local var_42_0 = csv.scene_conf
	local var_42_1 = 0

	idlereasy.when(arg_42_0.gateTimes, function(arg_43_0, arg_43_1)
		var_42_1 = var_42_0[arg_42_3.id].dayChallengeMax - (arg_43_1[arg_42_3.id] or 0)
	end)

	if var_42_1 == 0 then
		local var_42_2 = gVipCsv[arg_42_0.vipLevel:read()].buyHeroGateTimes
		local var_42_3 = arg_42_0.buyHerogateTimes:read()

		if var_42_2 <= (var_42_3[arg_42_3.id] or 0) then
			gGameUI:showTip(gLanguageCsv.herogateBuyMax)

			return
		end

		local var_42_4 = {
			"#C0x5b545b#" .. string.format(gLanguageCsv.resetNumberEliteLevels1, gCostCsv.herogate_buy_cost[(var_42_3[arg_42_3.id] or 0) + 1]),
			"#C0x8A5B0C#" .. string.format(gLanguageCsv.resetNumberEliteLevels2, var_42_3[arg_42_3.id] or 0, var_42_2)
		}

		gGameUI:showDialog({
			btnType = 2,
			isRich = true,
			content = var_42_4,
			cb = function()
				if arg_42_0.rmb:read() < gCostCsv.herogate_buy_cost[(var_42_3[arg_42_3.id] or 0) + 1] then
					uiEasy.showDialog("rmb", nil, {
						dialog = true
					})

					return
				end

				gGameApp:requestServer("/game/role/hero_gate/buy", function()
					gGameUI:showTip(gLanguageCsv.resetSuccess)
				end, arg_42_3.id)
			end,
			dialogParams = {
				clickClose = false
			}
		})

		return
	end

	local var_42_5 = 3

	if not arg_42_0:checkSweep(arg_42_3, var_42_5) then
		return
	end

	local var_42_6 = gGameModel.capture:read("limit_sprites")
	local var_42_7 = arg_42_0.roleLv:read()

	gGameApp:requestServer("/game/saodang", function(arg_46_0)
		local var_46_0 = arg_46_0.view.result

		table.insert(var_46_0, {
			exp = 0,
			isExtra = true,
			items = arg_46_0.view.extra
		})
		gGameUI:stackUI("city.gate.sweep", nil, nil, {
			from = "gate",
			hasExtra = true,
			sweepData = var_46_0,
			oldRoleLv = var_42_7,
			cb = arg_42_0:createHandler("onSweepBtn", arg_42_1, arg_42_2, arg_42_3),
			checkCb = arg_42_0:createHandler("checkSweep", arg_42_3, var_42_5),
			oldCapture = var_42_6,
			isDouble = dataEasy.isGateIdDoubleDrop(arg_42_3.id),
			gateId = arg_42_3.id,
			catchup = arg_46_0.view.catchup
		})
	end, arg_42_3.id, var_42_5)
end

function var_0_3.onAllsweepclick(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	local var_47_0 = csv.scene_conf
	local var_47_1 = csv.world_map
	local var_47_2 = gGameModel.role:read("level")
	local var_47_3 = {}

	for iter_47_0, iter_47_1 in ipairs(arg_47_0.chance) do
		if var_47_2 >= var_47_1[var_47_0[iter_47_1].ownerId].openLevel and iter_47_1 ~= 0 then
			table.insert(var_47_3, iter_47_1)
		end
	end

	local var_47_4 = {}

	for iter_47_2, iter_47_3 in ipairs(arg_47_0.chance1) do
		if var_47_2 >= var_47_1[var_47_0[iter_47_3].ownerId].openLevel and iter_47_3 ~= 0 then
			table.insert(var_47_4, iter_47_3)
		end
	end

	if arg_47_0.selectRecharge:read() == true then
		if itertools.isempty(var_47_3) then
			gGameUI:showTip(gLanguageCsv.pleaseChanceGate)
		elseif arg_47_0.chanceRecharge:read() == false then
			gGameUI:showTip(gLanguageCsv.pleaseCheckFirst)
		else
			if not arg_47_0:checkAllSweep() then
				return
			end

			local var_47_5 = gGameModel.capture:read("limit_sprites")
			local var_47_6 = arg_47_0.roleLv:read()

			gGameApp:requestServer("/game/saodang/batch", function(arg_48_0)
				local var_48_0 = arg_48_0.view.result

				table.insert(var_48_0, {
					exp = 0,
					isExtra = true,
					items = arg_48_0.view.extra
				})
				gGameUI:stackUI("city.gate.sweep", nil, nil, {
					from = "allGate",
					hasExtra = true,
					sweepData = var_48_0,
					oldRoleLv = var_47_6,
					cb = arg_47_0:createHandler("onAllsweepclick", arg_47_1, arg_47_2, arg_47_3),
					checkCb = arg_47_0:createHandler("checkAllSweep"),
					oldCapture = var_47_5,
					isDouble = dataEasy.isGateIdDoubleDrop(var_47_3[1]),
					catchup = arg_48_0.view.catchup
				})
			end, var_47_3)
		end
	elseif itertools.isempty(var_47_4) then
		gGameUI:showTip(gLanguageCsv.pleaseChanceGate)
	elseif arg_47_0.chanceRecharge:read() == false then
		gGameUI:showTip(gLanguageCsv.pleaseCheckFirst)
	else
		if not arg_47_0:checkAllSweep() then
			return
		end

		local var_47_7 = gGameModel.capture:read("limit_sprites")
		local var_47_8 = arg_47_0.roleLv:read()

		gGameApp:requestServer("/game/saodang/batch", function(arg_49_0)
			local var_49_0 = arg_49_0.view.result

			table.insert(var_49_0, {
				exp = 0,
				isExtra = true,
				items = arg_49_0.view.extra
			})
			gGameUI:stackUI("city.gate.sweep", nil, nil, {
				from = "allGate",
				hasExtra = true,
				sweepData = var_49_0,
				oldRoleLv = var_47_8,
				cb = arg_47_0:createHandler("onAllsweepclick", arg_47_1, arg_47_2, arg_47_3),
				checkCb = arg_47_0:createHandler("checkAllSweep"),
				oldCapture = var_47_7,
				isDouble = dataEasy.isGateIdDoubleDrop(var_47_4[1]),
				catchup = arg_49_0.view.catchup
			})
		end, var_47_4)
	end
end

function var_0_3.onLikeBtn(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
	local var_50_0 = 0

	for iter_50_0, iter_50_1 in ipairs(arg_50_0.collection:read()) do
		if iter_50_1 == arg_50_4.id then
			var_50_0 = iter_50_0

			break
		end
	end

	if var_50_0 == 0 then
		local var_50_1 = false

		for iter_50_2, iter_50_3 in ipairs(arg_50_0.myCollectionData) do
			if iter_50_3.id == arg_50_4.id then
				table.remove(arg_50_0.myCollectionData, iter_50_2)
				arg_50_0.myCollection:update(arg_50_0.myCollectionData)

				var_50_1 = true

				break
			end
		end

		if not var_50_1 then
			table.insert(arg_50_0.owerCollectionData, arg_50_4.id)
		end

		gGameUI:showTip(gLanguageCsv.collectSucceed)
	else
		for iter_50_4, iter_50_5 in ipairs(arg_50_0.owerCollectionData) do
			if iter_50_5 == arg_50_4.id then
				table.remove(arg_50_0.owerCollectionData, iter_50_4)

				break
			end
		end

		gGameUI:showTip(gLanguageCsv.collectCancel)
	end

	arg_50_0.owerCollection:update(arg_50_0.owerCollectionData)
	gGameApp:requestServer("/game/saodang/batch/favorites", nil, arg_50_4.id)
end

function var_0_3.onLikeBtn1(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	gGameApp:requestServer("/game/saodang/batch/favorites", nil, arg_51_3.id)

	local var_51_0 = 0

	for iter_51_0, iter_51_1 in ipairs(arg_51_0.myCollectionData) do
		if iter_51_1.id == arg_51_3.id then
			var_51_0 = iter_51_0

			break
		end
	end

	if var_51_0 == 0 then
		table.insert(arg_51_0.myCollectionData, {
			id = arg_51_3.id
		})
		gGameUI:showTip(gLanguageCsv.collectCancel)
	else
		table.remove(arg_51_0.myCollectionData, var_51_0)
		gGameUI:showTip(gLanguageCsv.collectSucceed)
	end

	arg_51_0.myCollection:update(arg_51_0.myCollectionData)
end

function var_0_3.onChanceBtn(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
	local var_52_0 = 0
	local var_52_1 = 0

	for iter_52_0, iter_52_1 in ipairs(arg_52_0.chance) do
		if iter_52_1 == arg_52_4.id then
			var_52_0 = 1
			var_52_1 = iter_52_0

			break
		end
	end

	if var_52_0 == 0 then
		table.insert(arg_52_0.chance, arg_52_4.id)
	else
		table.remove(arg_52_0.chance, var_52_1)
	end

	table.sort(arg_52_0.chance, function(arg_53_0, arg_53_1)
		return arg_53_0 < arg_53_1
	end)
	arg_52_0.chanceData:update(arg_52_0.chance)

	local var_52_2 = arg_52_0.dataHard:atproxy(arg_52_2).chapterTable[arg_52_3].chance

	arg_52_0.dataHard:atproxy(arg_52_2).chapterTable[arg_52_3].chance = var_52_2 == 1 and 0 or 1
end

function var_0_3.onChanceBtnLike(arg_54_0, arg_54_1, arg_54_2, arg_54_3)
	local var_54_0 = 0
	local var_54_1 = 0

	for iter_54_0, iter_54_1 in ipairs(arg_54_0.chance1) do
		if iter_54_1 == arg_54_3.id then
			var_54_0 = 1
			var_54_1 = iter_54_0

			break
		end
	end

	if var_54_0 == 0 then
		table.insert(arg_54_0.chance1, arg_54_3.id)
	else
		table.remove(arg_54_0.chance1, var_54_1)
	end

	table.sort(arg_54_0.chance1, function(arg_55_0, arg_55_1)
		return arg_55_0 < arg_55_1
	end)
	arg_54_0.chanceData1:update(arg_54_0.chance1)

	local var_54_2 = arg_54_0.dataLike:atproxy(k)
	local var_54_3 = arg_54_0.dataLike:atproxy(arg_54_2).chance

	arg_54_0.dataLike:atproxy(arg_54_2).chance = var_54_3 == 1 and 0 or 1
end

function var_0_3.onClose(arg_56_0)
	if arg_56_0.chanceRecharge:read() == false then
		local var_56_0 = {
			"#C0x5b545b#" .. gLanguageCsv.noSaveToQuit
		}

		gGameUI:showDialog({
			btnType = 2,
			isRich = true,
			content = var_56_0,
			cb = function()
				var_0_2.onClose(arg_56_0)
			end,
			dialogParams = {
				clickClose = false
			}
		})

		return
	end

	var_0_2.onClose(arg_56_0)
end

function var_0_3.onShowDetail(arg_58_0, arg_58_1, arg_58_2, arg_58_3, arg_58_4)
	gGameUI:showItemDetail(arg_58_2, {
		key = arg_58_4.item.key,
		num = arg_58_4.item.num
	})
end

function var_0_3.deleteUnlike(arg_59_0)
	local var_59_0 = 0

	for iter_59_0, iter_59_1 in ipairs(arg_59_0.chance1) do
		if not itertools.include(arg_59_0.collection:read(), iter_59_1) then
			var_59_0 = var_59_0 + 1
		end
	end

	if var_59_0 ~= 0 then
		for iter_59_2 = 1, var_59_0 do
			local var_59_1 = 0

			for iter_59_3, iter_59_4 in ipairs(arg_59_0.chance1) do
				if not itertools.include(arg_59_0.collection:read(), iter_59_4) then
					var_59_1 = iter_59_3

					break
				end
			end

			table.remove(arg_59_0.chance1, var_59_1)
		end
	end
end

return var_0_3
