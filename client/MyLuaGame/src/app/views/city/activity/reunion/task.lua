local var_0_0 = {
	received = 2,
	noReach = 0,
	canReceive = 1
}
local var_0_1 = {
	received = 3,
	noReach = 2,
	canReceive = 1
}
local var_0_2 = {
	ReunionGift = 1,
	TaskAward = 3,
	BindAward = 2,
	PointAward = 4
}
local var_0_3 = {
	reunion = 1,
	senior = 2
}
local var_0_4 = {
	{
		sortWeight = 1,
		name = gLanguageCsv.reunionTaskBack
	},
	{
		name = gLanguageCsv.reunionTaskAll,
		topPanelSenior,
		sortWeight = 2
	},
	{
		sortWeight = 3,
		name = gLanguageCsv.reunionTaskBindInfo
	}
}

local function var_0_5(arg_1_0)
	local var_1_0 = var_0_1.noReach

	if arg_1_0 and arg_1_0 == var_0_0.canReceive then
		var_1_0 = var_0_1.canReceive
	elseif arg_1_0 and arg_1_0 == var_0_0.received then
		var_1_0 = var_0_1.received
	end

	return var_1_0
end

local var_0_6 = class("ReunionTaskView", cc.load("mvc").ViewBase)

var_0_6.RESOURCE_FILENAME = "reunion_task.json"
var_0_6.RESOURCE_BINDING = {
	["rightPanel.seniorPanel.showTextPanel"] = "seniorShowTextPanel",
	["topPanel.bg.reunion"] = "topPanelReunion",
	["rightPanel.reunionPanel.infoPanel"] = "infoPanel",
	["rightPanel.reunionPanel.taskPanel"] = "taskPanel",
	["rightPanel.item"] = "item",
	["rightPanel.tabItem"] = "tabItem",
	["rightPanel.seniorPanel.img.light"] = "seniorPanelLight",
	["rightPanel.reunionPanel.pageInfo.textPro"] = "pageInfoTextPro",
	["rightPanel.seniorPanel.textPro"] = "seniorTextPro",
	["rightPanel.seniorPanel"] = "seniorPanel",
	["rightPanel.item1"] = "item1",
	["rightPanel.reunionPanel"] = "reunionPanel",
	["topPanel.bg.senior"] = "topPanelSenior",
	rightBg = {
		binds = {
			event = "visible",
			idler = bindHelper.self("isShowRightBg")
		}
	},
	["topPanel.bg.reunion.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(233, 251, 229, 255)
				}
			}
		}
	},
	["topPanel.bg.reunion.title_0"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(233, 251, 229, 255)
				},
				shadow = {
					size = 6,
					color = cc.c4b(0, 0, 0, 255),
					offset = cc.size(0, -6)
				}
			}
		}
	},
	["topPanel.bg.senior.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(233, 251, 229, 255)
				},
				shadow = {
					size = 6,
					color = cc.c4b(0, 0, 0, 255),
					offset = cc.size(0, -6)
				}
			}
		}
	},
	["topPanel.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRule")
			}
		}
	},
	["rightPanel.reunionPanel.pageInfo.progress"] = {
		varname = "pageInfoProgressBar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "common/icon/mask_bar_red.png",
				data = bindHelper.self("curPagePro")
			}
		}
	},
	["rightPanel.reunionPanel.pageInfo.box"] = {
		varname = "pageInfoBox",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onBoxGetClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					state = bindHelper.self("pageInfoBoxRedHint"),
					onNode = function(arg_2_0)
						arg_2_0:xy(122, 83)
						arg_2_0:scale(0.8)
					end
				}
			}
		}
	},
	["rightPanel.reunionPanel.pageInfo.box.imgBox"] = {
		binds = {
			{
				event = "texture",
				idler = bindHelper.self("boxPath")
			}
		}
	},
	["rightPanel.reunionPanel.infoPanel.nameBg.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["rightPanel.reunionPanel.tabList"] = {
		varname = "tabList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 3,
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("tabItem"),
				dataOrderCmp = function(arg_3_0, arg_3_1)
					return arg_3_0.sortWeight < arg_3_1.sortWeight
				end,
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					arg_4_1:get("label"):text(arg_4_3.name)
					arg_4_1:setTouchEnabled(not arg_4_3.selected)
					arg_4_1:setEnabled(not arg_4_3.selected)
					text.deleteAllEffect(arg_4_1:get("label"))

					if arg_4_3.selected then
						arg_4_1:setTouchEnabled(arg_4_3.selected)
						text.addEffect(arg_4_1:get("label"), {
							color = ui.COLORS.NORMAL.WHITE,
							outline = {
								size = 4,
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
					else
						text.addEffect(arg_4_1:get("label"), {
							color = ui.COLORS.NORMAL.WHITE,
							outline = {
								size = 4,
								color = ui.NEWCOLORS.OUTLINE.BLUE
							}
						})
					end

					bind.click(arg_4_0, arg_4_1, {
						method = functools.partial(arg_4_0.clickCell, arg_4_2, arg_4_3)
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	["rightPanel.item.panel.btnGet.textNote"] = {
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
	["rightPanel.reunionPanel.taskPanel.list"] = {
		varname = "reunionList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("reunionDatas"),
				item = bindHelper.self("item"),
				dataOrderCmp = function(arg_5_0, arg_5_1)
					if arg_5_0.state ~= arg_5_1.state then
						return arg_5_0.state < arg_5_1.state
					end

					return arg_5_0.csvID < arg_5_1.csvID
				end,
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					local var_6_0 = arg_6_3.cfg

					arg_6_1:get("textCount"):text(var_6_0.point)

					local var_6_1 = arg_6_1:get("panel"):multiget("textNote1", "textNote2", "list", "btnGet", "textPro", "imgGot", "btnGo")

					uiEasy.createItemsToList(arg_6_0, var_6_1.list, var_6_0.award, {
						scale = 0.9
					})
					var_6_1.textNote1:text(var_6_0.theme)
					var_6_1.textNote2:text(var_6_0.desc)
					var_6_1.textPro:text(arg_6_3.count .. "/" .. var_6_0.taskParam)

					if arg_6_3.count < var_6_0.taskParam then
						text.addEffect(var_6_1.textPro, {
							color = ui.NEWCOLORS.RED1
						})
					else
						text.addEffect(var_6_1.textPro, {
							color = ui.NEWCOLORS.GREEN1
						})
					end

					var_6_1.btnGet:visible(arg_6_3.state == var_0_1.canReceive)
					var_6_1.btnGo:visible(arg_6_3.state == var_0_1.noReach)
					var_6_1.imgGot:visible(arg_6_3.state == var_0_1.received)

					if var_6_0.goTo == "" then
						var_6_1.btnGo:visible(false)
					end

					local var_6_2 = var_6_1.btnGo:size()

					widget.addAnimationByKey(var_6_1.btnGo:get("panel"), "effect/jiantou.skel", "efc1", "effect_loop", 6):xy(var_6_2.width / 2, var_6_2.height / 2):scale(0.8)
					bind.touch(arg_6_0, var_6_1.btnGo, {
						methods = {
							ended = functools.partial(arg_6_0.goCell, var_6_0.goTo)
						}
					})
					bind.touch(arg_6_0, var_6_1.btnGet, {
						methods = {
							ended = functools.partial(arg_6_0.clickCell, arg_6_2, arg_6_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onReceiveClick"),
				goCell = bindHelper.self("onJumpToClick")
			}
		}
	},
	["rightPanel.seniorPanel.textPro2"] = {
		varname = "seniorTextPro2",
		binds = {
			event = "effect",
			data = {
				color = ui.NEWCOLORS.WHITE,
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightPanel.seniorPanel.progress"] = {
		varname = "seniorProgressBar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "common/icon/mask_bar_red.png",
				data = bindHelper.self("curPagePro")
			}
		}
	},
	["rightPanel.seniorPanel.btnGet"] = {
		varname = "seniorBtnGet",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBoxGetClick")
			}
		}
	},
	["rightPanel.seniorPanel.img.redIcon"] = {
		binds = {
			event = "extend",
			class = "red_hint",
			props = {
				state = bindHelper.self("seniorBoxRedHint"),
				onNode = function(arg_7_0)
					arg_7_0:xy(20, 20)
				end
			}
		}
	},
	["rightPanel.seniorPanel.img.imgIcon"] = {
		varname = "seniorPanelImgIcon",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("showBoxAward")
			}
		}
	},
	["rightPanel.seniorPanel.list"] = {
		varname = "seniorList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("seniorDatas"),
				item = bindHelper.self("item1"),
				dataOrderCmp = function(arg_8_0, arg_8_1)
					return arg_8_0.csvID < arg_8_1.csvID
				end,
				onItem = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
					local var_9_0 = arg_9_3.cfg

					arg_9_1:get("textCount"):text(var_9_0.point)

					local var_9_1 = arg_9_1:get("panel"):multiget("textNote1", "textNote2", "textPro", "imgGot")

					var_9_1.textNote1:text(var_9_0.theme)
					var_9_1.textNote2:text(var_9_0.desc)
					var_9_1.textPro:text(arg_9_3.count .. "/" .. var_9_0.taskParam)

					if arg_9_3.count < var_9_0.taskParam then
						text.addEffect(var_9_1.textPro, {
							color = ui.NEWCOLORS.RED1
						})
					else
						text.addEffect(var_9_1.textPro, {
							color = ui.NEWCOLORS.GREEN1
						})
					end

					var_9_1.textPro:visible(arg_9_3.state ~= var_0_1.received)
					var_9_1.imgGot:visible(arg_9_3.state == var_0_1.received)
				end
			}
		}
	}
}

function var_0_6.onCreate(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0.yyID = arg_10_1

	local var_10_0 = csv.yunying.yyhuodong[arg_10_1]
	local var_10_1 = arg_10_2.bindInfo

	arg_10_0.huodongID = var_10_0.huodongID

	arg_10_0:initModel(arg_10_2.reunionRecord)

	local var_10_2 = arg_10_0.reunion:read().role_type

	arg_10_0.role_type = var_10_2

	arg_10_0.topPanelReunion:visible(var_10_2 == var_0_3.reunion)
	arg_10_0.topPanelSenior:visible(var_10_2 == var_0_3.senior)
	arg_10_0.reunionPanel:visible(var_10_2 == var_0_3.reunion)
	arg_10_0.seniorPanel:visible(var_10_2 == var_0_3.senior)
	arg_10_0.tabType:addListener(function(arg_11_0, arg_11_1)
		arg_10_0.taskPanel:visible(arg_11_0 == 1 or arg_11_0 == 2)
		arg_10_0.infoPanel:visible(arg_11_0 == 3)
		arg_10_0.isShowRightBg:set(arg_11_0 == 3)

		if arg_11_1 then
			arg_10_0.tabDatas:atproxy(arg_11_1).selected = false
		end

		if arg_11_0 then
			arg_10_0.tabDatas:atproxy(arg_11_0).selected = true
		end

		if arg_11_0 == 1 or arg_11_0 == 2 then
			arg_10_0:updateTaskInfo(var_10_2, arg_11_0)
		end
	end)
	idlereasy.any({
		arg_10_0.reunion,
		arg_10_0.reunionBindPoint,
		arg_10_0.reunionValsums
	}, function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		local var_12_0 = arg_12_2 or 0
		local var_12_1 = arg_12_1.point_box or {}
		local var_12_2 = 0
		local var_12_3
		local var_12_4 = {}
		local var_12_5 = {}
		local var_12_6 = 0

		for iter_12_0, iter_12_1 in csvPairs(csv.yunying.reunion_point_box) do
			if iter_12_1.huodongID == arg_10_0.huodongID then
				local var_12_7 = var_12_1[iter_12_0] or var_0_0.noReach

				table.insert(var_12_5, {
					csvID = iter_12_0,
					cfg = iter_12_1,
					state = var_12_7,
					boxGet = var_12_7 == var_0_0.received
				})
			end
		end

		table.sort(var_12_5, function(arg_13_0, arg_13_1)
			return arg_13_0.cfg.pointNode < arg_13_1.cfg.pointNode
		end)

		local var_12_8 = #var_12_5

		for iter_12_2, iter_12_3 in pairs(var_12_5) do
			local var_12_9 = iter_12_3.state

			if var_12_0 < iter_12_3.cfg.pointNode and var_12_2 == 0 then
				var_12_2 = iter_12_3.cfg.pointNode
			end

			if (var_12_9 == var_0_0.canReceive or var_12_9 == var_0_0.noReach) and #var_12_4 == 0 then
				table.insert(var_12_4, iter_12_3)
			elseif var_12_9 == var_0_0.received then
				var_12_6 = var_12_6 + 1

				if var_12_6 == var_12_8 and #var_12_4 == 0 then
					table.insert(var_12_4, iter_12_3)

					var_12_2 = var_12_2 == 0 and iter_12_3.cfg.pointNode or var_12_2

					arg_10_0.haveReceiveAllBox:set(true)
				end
			end

			local var_12_10, var_12_11 = next(var_12_5, iter_12_2)

			if var_12_10 == nil and var_12_2 == 0 then
				var_12_2 = iter_12_3.cfg.pointNode
			end
		end

		if var_10_2 == var_0_3.reunion then
			arg_10_0:updateTaskInfo(var_10_2, arg_10_0.tabType:read(), arg_12_1, arg_12_3)
			arg_10_0.pageInfoTextPro:text(var_12_0 .. "/" .. var_12_2)
			arg_10_0.pageInfoBox:get("light"):visible(var_12_4[1].state == var_0_1.canReceive)
			arg_10_0.pageInfoBoxRedHint:set(var_12_4[1].state == var_0_1.canReceive)

			if arg_10_0.haveReceiveAllBox:read() then
				arg_10_0.boxPath:set(var_12_4[1].cfg.resOpen)
			else
				arg_10_0.boxPath:set(var_12_4[1].cfg.res)
			end

			arg_10_0.pageInfoBox:setTouchEnabled(not arg_10_0.haveReceiveAllBox:read())
		else
			arg_10_0.seniorTextPro2:text(var_12_0 .. "/" .. var_12_2)
			arg_10_0.seniorTextPro:text(string.format(gLanguageCsv.haveGetBy, var_12_6, var_12_8))
			text.deleteAllEffect(arg_10_0.seniorBtnGet:get("textNote"))

			if var_12_4[1] and var_12_4[1].state == var_0_1.canReceive then
				cache.setShader(arg_10_0.seniorBtnGet, false, "normal")
				text.addEffect(arg_10_0.seniorBtnGet:get("textNote"), {
					glow = {
						color = ui.COLORS.GLOW.WHITE
					}
				})
			else
				cache.setShader(arg_10_0.seniorBtnGet, false, "hsl_gray")
			end

			arg_10_0.seniorBtnGet:setTouchEnabled(var_12_4[1] and var_12_4[1].state == var_0_1.canReceive)
			arg_10_0.seniorPanelLight:setVisible(var_12_4[1] and var_12_4[1].state == var_0_1.canReceive)
			arg_10_0.seniorBoxRedHint:set(var_12_4[1] and var_12_4[1].state == var_0_1.canReceive)
			arg_10_0:updateTaskInfo(var_10_2, nil, arg_12_1, arg_12_3)
			arg_10_0.seniorPanelImgIcon:setTouchEnabled(not arg_10_0.haveReceiveAllBox:read())
		end

		arg_10_0.curPagePro:set(math.min(100, var_12_0 / var_12_2 * 100))
		arg_10_0.livenessPoint:set(var_12_0)
		arg_10_0.boxDatas:set(var_12_4)
	end)

	if var_10_2 == var_0_3.reunion then
		arg_10_0:onTabDatas(1)
		arg_10_0:showBindInfo(var_10_1)
		arg_10_0.pageInfoBox:get("light"):runAction(cc.RepeatForever:create(cc.RotateBy:create(30, 360)))
	else
		local var_10_3 = arg_10_0.seniorShowTextPanel:get("label"):getFontSize()
		local var_10_4 = rich.createByStr(gLanguageCsv.reunionTaskBindToText, var_10_3):anchorPoint(cc.p(0, 0.5)):addTo(arg_10_0.seniorShowTextPanel):xy(arg_10_0.seniorShowTextPanel:get("label"):xy()):formatText()

		arg_10_0.seniorShowTextPanel:get("bg"):width(var_10_4:width() / 0.8 + 20)
		arg_10_0.seniorPanelLight:runAction(cc.RepeatForever:create(cc.RotateBy:create(30, 360)))
	end
end

function var_0_6.initModel(arg_14_0, arg_14_1)
	arg_14_0.reunionRecord = arg_14_1
	arg_14_0.reunion = gGameModel.role:getIdler("reunion")

	if arg_14_0.reunion:read().role_type == var_0_3.reunion then
		arg_14_0.reunionValsums = gGameModel.reunion_record:getIdler("valsums")
		arg_14_0.reunionBindPoint = gGameModel.reunion_record:getIdler("bind_point")
	else
		arg_14_0.reunionValsums = idlertable.new(arg_14_1.valsums)
		arg_14_0.reunionBindPoint = idler.new(arg_14_1.bind_point)
	end

	arg_14_0.curPagePro = idler.new(0)
	arg_14_0.tabDatas = idlers.new()
	arg_14_0.reunionDatas = idlers.new()
	arg_14_0.seniorDatas = idlers.new()
	arg_14_0.tabType = idler.new()
	arg_14_0.boxDatas = idlertable.new({})
	arg_14_0.livenessPoint = idler.new(0)
	arg_14_0.boxPath = idler.new("")
	arg_14_0.isShowRightBg = idler.new(false)
	arg_14_0.haveReceiveAllBox = idler.new(false)
	arg_14_0.pageInfoBoxRedHint = idler.new(false)
	arg_14_0.seniorBoxRedHint = idler.new(false)
end

function var_0_6.onTabDatas(arg_15_0, arg_15_1)
	local var_15_0 = {}

	for iter_15_0 = 1, 3 do
		local var_15_1 = false

		if arg_15_1 == iter_15_0 then
			var_15_1 = true
		end

		table.insert(var_15_0, {
			k = iter_15_0,
			name = var_0_4[iter_15_0].name,
			sortWeight = var_0_4[iter_15_0].sortWeight,
			selected = var_15_1
		})
	end

	arg_15_0.tabDatas:update(var_15_0)
	arg_15_0.tabType:set(arg_15_1)
end

function var_0_6.updateTaskInfo(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	if arg_16_1 == var_0_3.reunion and arg_16_2 ~= 1 and arg_16_2 ~= 2 then
		return
	end

	local var_16_0 = {}
	local var_16_1 = {}
	local var_16_2 = {}
	local var_16_3 = (arg_16_3 or arg_16_0.reunion:read()).stamps or {}

	if arg_16_1 == var_0_3.senior then
		var_16_3 = arg_16_0.reunionRecord.stamps or {}
	end

	local var_16_4 = arg_16_4 or arg_16_0.reunionValsums:read()

	for iter_16_0, iter_16_1 in csvPairs(csv.yunying.reunion_task) do
		if iter_16_1.huodongID == arg_16_0.huodongID and iter_16_1.themeType == 2 then
			if iter_16_1.isSync then
				if not var_16_2[iter_16_1.taskType] then
					var_16_2[iter_16_1.taskType] = {}
				end

				table.insert(var_16_2[iter_16_1.taskType], {
					csvID = iter_16_0,
					cfg = iter_16_1,
					state = var_0_5(var_16_3[iter_16_0])
				})
			else
				if not var_16_1[iter_16_1.taskType] then
					var_16_1[iter_16_1.taskType] = {}
				end

				table.insert(var_16_1[iter_16_1.taskType], {
					csvID = iter_16_0,
					cfg = iter_16_1,
					state = var_0_5(var_16_3[iter_16_0])
				})
			end
		end
	end

	local function var_16_5(arg_17_0)
		local var_17_0 = {}

		for iter_17_0, iter_17_1 in pairs(arg_17_0) do
			table.sort(iter_17_1, function(arg_18_0, arg_18_1)
				if arg_18_0.state ~= arg_18_1.state and arg_16_1 == var_0_3.reunion then
					return arg_18_0.state < arg_18_1.state
				end

				return arg_18_0.cfg.taskLinks < arg_18_1.cfg.taskLinks
			end)

			for iter_17_2, iter_17_3 in pairs(iter_17_1) do
				local var_17_1, var_17_2 = next(iter_17_1, iter_17_2)

				if iter_17_3.state == var_0_1.canReceive or iter_17_3.state == var_0_1.noReach or var_17_1 == nil then
					local var_17_3 = var_16_4[iter_17_0] and var_16_4[iter_17_0][1] or 0

					if iter_17_3.cfg.isCooperative then
						local var_17_4 = var_16_4[iter_17_0] and var_16_4[iter_17_0][2] or 0

						var_17_3 = math.min(var_17_3, var_17_4)
					end

					table.insert(var_17_0, {
						csvID = iter_17_3.csvID,
						cfg = iter_17_3.cfg,
						state = iter_17_3.state,
						count = var_17_3
					})

					break
				end
			end
		end

		return var_17_0
	end

	if arg_16_1 == var_0_3.reunion then
		if arg_16_2 == 1 then
			var_16_0 = var_16_5(var_16_1)
		elseif arg_16_2 == 2 then
			var_16_0 = var_16_5(var_16_2)
		end

		arg_16_0.reunionDatas:update(var_16_0)
	else
		local var_16_6 = var_16_5(var_16_2)

		arg_16_0.seniorDatas:update(var_16_6)
	end
end

function var_0_6.showBindInfo(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_1
	local var_19_1 = arg_19_0.infoPanel:multiget("playerPanel", "bindLabel", "name", "lv", "infoList", "power", "guild", "nameBg", "playerBtn", "nameLabel", "powerLabel", "lvLabel", "guildLabel")

	var_19_1.nameBg:get("name"):text(var_19_0.name)
	var_19_1.name:text(var_19_0.name)
	var_19_1.lv:text(var_19_0.level)
	var_19_1.guild:text(var_19_0.union_name ~= "" and var_19_0.union_name or gLanguageCsv.none)
	var_19_1.power:text(var_19_0.battle_fighting_point)
	var_19_1.playerPanel:removeAllChildren()

	local var_19_2 = gRoleFigureCsv[var_19_0.figure]
	local var_19_3 = var_19_1.playerPanel:width() / 2
	local var_19_4 = var_19_1.playerPanel:height() / 2
	local var_19_5 = cc.Sprite:create(var_19_2.res):anchorPoint(0.5, 0.5):xy(var_19_3, var_19_4):addTo(var_19_1.playerPanel, 2)

	beauty.textScroll({
		fontSize = 36,
		list = var_19_1.infoList,
		strs = var_19_0.personal_sign ~= "" and var_19_0.personal_sign or gLanguageCsv.soLazy
	})
	var_19_1.bindLabel:removeAllChildren()

	local var_19_6 = string.format(gLanguageCsv.reunionTaskOldText, var_19_0.name)

	rich.createWithWidth(var_19_6, 36, nil, 800):addTo(var_19_1.bindLabel, 2):anchorPoint(0, 0.5):xy(0, 0)
	adapt.oneLinePos(var_19_1.nameLabel, var_19_1.name, cc.p(5, 0), "left")
	adapt.oneLinePos(var_19_1.guildLabel, var_19_1.guild, cc.p(5, 0), "left")
	adapt.oneLinePos(var_19_1.lvLabel, var_19_1.lv, cc.p(5, 0), "left")
	adapt.oneLinePos(var_19_1.powerLabel, var_19_1.power, cc.p(5, 0), "left")
	var_19_1.playerBtn:onClick(functools.partial(arg_19_0.onBindHeadBtnClick, arg_19_0, var_19_0))
end

function var_0_6.onTabClick(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	arg_20_0.tabType:set(arg_20_2)
end

function var_0_6.onReceiveClick(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	arg_21_0:onGetAward(arg_21_3.csvID, var_0_2.TaskAward, function(arg_22_0)
		gGameUI:showGainDisplay(arg_22_0)
	end)
end

function var_0_6.onJumpToClick(arg_23_0, arg_23_1, arg_23_2)
	if arg_23_2 ~= "" then
		jumpEasy.jumpTo(arg_23_2)
	end
end

function var_0_6.onPointReceiveClick(arg_24_0, arg_24_1)
	arg_24_0:onGetAward(arg_24_1, var_0_2.PointAward, function(arg_25_0)
		gGameUI:showGainDisplay(arg_25_0)
	end)
end

function var_0_6.onGetAward(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	if arg_26_0.reunion:read().info.end_time - time.getTime() < 0 then
		gGameUI:showTip(gLanguageCsv.activityOver)

		return
	end

	gGameApp:requestServer("/game/yy/reunion/award/get", function(arg_27_0)
		if arg_26_3 then
			arg_26_3(arg_27_0)
		end
	end, arg_26_0.yyID, arg_26_1, arg_26_2)
end

function var_0_6.onRule(arg_28_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_28_0:createHandler("getRuleContext"))
end

function var_0_6.getRuleContext(arg_29_0, arg_29_1)
	local var_29_0 = adaptContext

	return {
		var_29_0.clone(arg_29_1.title, function(arg_30_0)
			arg_30_0:get("text"):text(gLanguageCsv.reunionRule)
		end),
		var_29_0.noteText(148),
		var_29_0.noteText(101001, 101020)
	}
end

function var_0_6.onBindHeadBtnClick(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_2.target
	local var_31_1, var_31_2 = var_31_0:xy()
	local var_31_3 = var_31_0:getParent():convertToWorldSpace(cc.p(var_31_1, var_31_2))

	var_31_3.x = var_31_3.x + 250
	var_31_3.y = var_31_3.y + 600

	gGameUI:stackUI("city.chat.personal_info", nil, nil, var_31_3, {
		role = arg_31_1
	})
end

function var_0_6.onBoxGetClick(arg_32_0)
	local var_32_0 = arg_32_0.boxDatas:proxy()[1]

	if arg_32_0.livenessPoint:read() >= var_32_0.cfg.pointNode and not var_32_0.boxGet then
		arg_32_0:onGetAward(var_32_0.csvID, var_0_2.PointAward, function(arg_33_0)
			gGameUI:showGainDisplay(arg_33_0)
		end)
	else
		arg_32_0:showBoxAward()
	end
end

function var_0_6.showBoxAward(arg_34_0)
	local var_34_0 = arg_34_0.boxDatas:proxy()[1]
	local var_34_1 = var_34_0.cfg.award1

	if arg_34_0.role_type == var_0_3.reunion then
		var_34_1 = var_34_0.cfg.award2
	end

	gGameUI:showBoxDetail({
		data = var_34_1,
		content = string.format(gLanguageCsv.canReceivedByScore .. "", var_34_0.cfg.pointNode),
		state = var_34_0.boxGet == true and 0 or 1
	})
end

return var_0_6
