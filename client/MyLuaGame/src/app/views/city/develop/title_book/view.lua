local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	idlereasy.when(arg_1_0.titleId, function(arg_2_0, arg_2_1)
		if arg_1_3.isSelected then
			local var_2_0 = arg_1_1:multiget("downPanel", "list", "layout")
			local var_2_1 = arg_1_0.checkState:read() and arg_1_3.ownTitles or arg_1_3.titles

			var_2_0.downPanel:size(arg_1_0.titleItem:size().width, arg_1_0.titleItem:size().height * #var_2_1)
			var_2_0.list:size(var_2_0.downPanel:size())
			var_2_0.list:anchorPoint(cc.p(0.5, 1))
			itertools.invoke({
				var_2_0.downPanel,
				var_2_0.list
			}, "show")
			bind.extend(arg_1_0, var_2_0.list, {
				event = "extend",
				class = "listview",
				props = {
					data = var_2_1,
					item = arg_1_0.titleItem,
					onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
						local var_3_0 = arg_3_1:multiget("txt", "img", "used", "imgTime", "bg")

						if type(arg_3_3.data) ~= "string" then
							var_3_0.txt:text("")

							local var_3_1 = {
								event = "extend",
								class = "role_title",
								props = {
									isGray = arg_3_3.data == nil,
									data = arg_3_3.id,
									onNode = function(arg_4_0)
										arg_4_0:xy(arg_3_1:size().width / 2, arg_3_1:size().height / 2):z(10)
									end
								}
							}

							itertools.invoke({
								var_3_0.img,
								var_3_0.used
							}, "visible", arg_3_3.id == arg_2_1)

							if arg_3_3.data and arg_3_3.data[1] ~= 0 then
								var_3_0.imgTime:show()
							else
								var_3_0.imgTime:hide()
							end

							idlereasy.when(arg_1_0.id, function(arg_5_0, arg_5_1)
								if not tolua.isnull(arg_3_1) then
									var_3_0.bg:texture(arg_5_1 == arg_3_3.id and "city/develop/title_book/box_xlxz.png" or "city/develop/title_book/box_xld.png")

									if arg_3_3.id == arg_5_1 then
										arg_1_0:enableSchedule():unSchedule("tag")

										if arg_3_3.data and arg_3_3.data[1] ~= 0 then
											local var_5_0 = arg_3_3.data[1] - time.getTime()

											arg_1_0:schedule(function()
												var_5_0 = var_5_0 - 1

												local var_6_0 = time.getCutDown(var_5_0).head_date_str
												local var_6_1 = string.format(gLanguageCsv.titleHaveTimeLimit, var_6_0)

												arg_1_0.timeLimit:text(var_6_1)
												adapt.setTextScaleWithWidth(arg_1_0.timeLimit, nil, 1120)
												text.addEffect(arg_1_0.timeLimit, {
													color = ui.COLORS.NORMAL.ALERT_ORANGE
												})
												text.addEffect(arg_1_0.rightPanelTip, {
													color = ui.NEWCOLORS.BROWN1
												})

												if var_5_0 <= 0 then
													arg_1_0.timeLimit:hide()

													return false
												end
											end, 1, 0, "tag")
										else
											local var_5_1 = gTitleCsv[arg_3_3.id]
											local var_5_2 = gLanguageCsv.afterObtaining

											if arg_3_3.data then
												var_5_2 = ""

												text.addEffect(arg_1_0.timeLimit, {
													color = ui.NEWCOLORS.GREENLIGHT
												})
												text.addEffect(arg_1_0.rightPanelTip, {
													color = ui.NEWCOLORS.BROWN1
												})
											else
												text.addEffect(arg_1_0.timeLimit, {
													color = ui.NEWCOLORS.GRAY1
												})
												text.addEffect(arg_1_0.rightPanelTip, {
													color = ui.NEWCOLORS.GRAY1
												})
											end

											if var_5_1.days > 0 then
												arg_1_0.timeLimit:text(string.format(gLanguageCsv.titleHaveTimeLimitDays, var_5_2, var_5_1.days))
											else
												arg_1_0.timeLimit:text(string.format(gLanguageCsv.foreverUse, var_5_2))
											end
										end
									end
								end
							end):anonyOnly(arg_1_0, "title" .. arg_3_3.id)
							bind.extend(arg_1_0, arg_3_1, var_3_1)
							arg_3_1:onClick(functools.partial(arg_1_0.clickCell, arg_3_2, arg_3_3))

							if arg_1_0.id:read() == arg_3_3.id then
								functools.partial(arg_1_0.clickCell, arg_3_2, arg_3_3)()
							end
						else
							var_3_0.txt:text(arg_3_3.data)
							itertools.invoke({
								var_3_0.img,
								var_3_0.used
							}, "hide")
							var_3_0.imgTime:hide()
						end
					end
				}
			})
			arg_1_1:size(var_2_0.list:size().width, var_2_0.list:size().height + 186)
			var_2_0.layout:y(var_2_0.list:size().height + 186)
			var_2_0.downPanel:y(var_2_0.list:size().height + 186 - var_2_0.layout:size().height + 38)
			var_2_0.list:xy(var_2_0.downPanel:xy())
		end
	end):anonyOnly(arg_1_0, "initItem" .. arg_1_2)
end

local var_0_1 = class("TitleBookView", Dialog)

var_0_1.RESOURCE_FILENAME = "title_book.json"
var_0_1.RESOURCE_BINDING = {
	["leftPanel.item"] = "leftItem",
	itemAttr = "attrItem",
	["rightPanel.title"] = "titlePanel",
	["rightPanel.tip"] = "rightPanelTip",
	["rightPanel.timeLimit"] = "timeLimit",
	leftPanel = "leftPanel",
	itemCondition = "conditionItem",
	["leftPanel.title"] = "titleItem",
	rightPanel = "rightPanel",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["rightPanel.btnUse"] = {
		varname = "btn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onUseOrDown")
			}
		}
	},
	title = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 1,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	["leftPanel.list"] = {
		varname = "leftList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				backupCached = false,
				margin = -20,
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("leftItem"),
				titleId = bindHelper.self("titleId"),
				titleItem = bindHelper.self("titleItem"),
				timeLimit = bindHelper.self("timeLimit"),
				rightPanelTip = bindHelper.self("rightPanelTip"),
				checkState = bindHelper.self("checkState"),
				id = bindHelper.self("id"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = arg_7_1:get("layout"):multiget("name", "selected", "flag", "line")

					adapt.setTextScaleWithWidth(var_7_0.name, arg_7_3.name, arg_7_1:width() - 150)
					var_7_0.selected:visible(arg_7_3.isSelected == true)

					if arg_7_3.isSelected and arg_7_3.isDropDown then
						var_7_0.flag:rotate(0):z(10)
						text.addEffect(var_7_0.name, {
							outline = {
								size = 1,
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
						var_0_0(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
						var_7_0.line:hide()
					else
						var_7_0.flag:rotate(180):z(10)
						text.deleteAllEffect(var_7_0.name)
						text.addEffect(var_7_0.name, {
							color = ui.COLORS.NORMAL.WHITE
						})
						arg_7_1:size(518, 186)
						arg_7_1:get("layout"):y(180)
						arg_7_1:get("list"):hide()
						arg_7_1:get("downPanel"):hide()
						var_7_0.line:show()
					end

					arg_7_0:forceDoLayout()
					arg_7_1:onClick(functools.partial(arg_7_0.itemClick, arg_7_2, arg_7_3))
				end
			},
			handlers = {
				itemClick = bindHelper.self("onParentNodeClick"),
				clickCell = bindHelper.self("onNodeClick")
			}
		}
	},
	["rightPanel.list1"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("attrData"),
				item = bindHelper.self("attrItem"),
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					local var_8_0 = arg_8_1:multiget("name", "icon", "attr", "num")

					var_8_0.name:text(arg_8_3.txt)
					var_8_0.attr:text(getLanguageAttr(arg_8_3.attrType))
					var_8_0.num:text("+" .. dataEasy.getAttrValueString(arg_8_3.attrType, arg_8_3.attrValue))

					if ui.ATTR_LOGO[game.ATTRDEF_TABLE[arg_8_3.attrType]] then
						var_8_0.icon:texture(ui.ATTR_LOGO[game.ATTRDEF_TABLE[arg_8_3.attrType]])
					else
						var_8_0.icon:hide()
					end

					adapt.oneLinePos(var_8_0.attr, var_8_0.num, cc.p(20, 0), "left")
				end
			}
		}
	},
	["rightPanel.list2"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("conditionData"),
				item = bindHelper.self("conditionItem"),
				onItem = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
					local var_9_0 = arg_9_1:get("tip"):text(arg_9_3.con)
					local var_9_1 = arg_9_1:get("tip1")

					if arg_9_3.progress and arg_9_3.progress[1] < arg_9_3.progress[2] then
						local var_9_2 = "(%d/%d)"

						var_9_1:text(string.format(var_9_2, arg_9_3.progress[1], arg_9_3.progress[2]))
						var_9_0:text(arg_9_3.con .. var_9_1:text())
						var_9_1:hide()
					else
						var_9_1:hide()
					end
				end
			}
		}
	},
	["leftPanel.icon"] = {
		varname = "checkStatus",
		binds = {
			event = "click",
			method = bindHelper.self("onChangeState")
		}
	},
	["leftPanel.tip"] = {
		varname = "checkTip",
		binds = {
			event = "click",
			method = bindHelper.self("onChangeState")
		}
	}
}

function var_0_1.onCreate(arg_10_0)
	arg_10_0:initModel()

	arg_10_0.originY = arg_10_0.timeLimit:y()
	arg_10_0.attrData = idlertable.new({})
	arg_10_0.conditionData = idlertable.new({})
	arg_10_0.id = idler.new(0)
	arg_10_0.showTab = idler.new(1)
	arg_10_0.checkState = idler.new(false)

	arg_10_0.checkTip:setTouchEnabled(true)

	local var_10_0, var_10_1 = arg_10_0:getData()

	arg_10_0.tabDatas = idlers.newWithMap(var_10_1)

	arg_10_0.leftList:setBounceEnabled(true)
	idlereasy.when(arg_10_0.checkState, function(arg_11_0, arg_11_1)
		arg_10_0.checkStatus:texture(arg_11_1 and "common/icon/radio_selected1.png" or "common/icon/radio_normal1.png")
		arg_10_0.tabDatas:at(arg_10_0.showTab):notify()
		performWithDelay(arg_10_0, function()
			arg_10_0.leftList:refreshView()

			if arg_10_0.leftList:getScrolledPercentVertical() > 100 then
				arg_10_0.leftList:scrollToBottom(0.3, true)
			end
		end, 0.01)
	end)
	arg_10_0.showTab:addListener(function(arg_13_0, arg_13_1, arg_13_2)
		if arg_13_1 == arg_13_0 then
			arg_10_0.tabDatas:atproxy(arg_13_1).isSelected = not arg_10_0.tabDatas:atproxy(arg_13_1).isSelected
			arg_10_0.tabDatas:atproxy(arg_13_0).isDropDown = not arg_10_0.tabDatas:atproxy(arg_13_0).isDropDown
		else
			arg_10_0.tabDatas:atproxy(arg_13_0).isDropDown = true
			arg_10_0.tabDatas:atproxy(arg_13_1).isSelected = false
			arg_10_0.tabDatas:atproxy(arg_13_0).isSelected = true
		end

		performWithDelay(arg_10_0, function()
			arg_10_0.leftList:refreshView()

			if arg_10_0.leftList:getScrolledPercentVertical() > 100 then
				if arg_13_0 > arg_13_1 then
					arg_10_0.leftList:jumpToBottom()
				else
					arg_10_0.leftList:scrollToBottom(0.3, true)
				end
			end
		end, 0.01)
	end, true)
	idlereasy.any({
		arg_10_0.id,
		arg_10_0.titleId
	}, function(arg_15_0, arg_15_1, arg_15_2)
		local var_15_0 = arg_10_0.btn:get("txt")

		if arg_15_1 == arg_15_2 then
			var_15_0:text(gLanguageCsv.spaceDischarge)
			text.addEffect(var_15_0, {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
			cache.setShader(arg_10_0.btn, false, "normal")
			arg_10_0.btn:setTouchEnabled(true)
		else
			local var_15_1 = var_10_0[arg_15_1] or var_10_0[gTitleCsv[arg_15_1].sameId]

			cache.setShader(arg_10_0.btn, false, var_15_1 and "normal" or "hsl_gray")

			if not var_15_1 then
				text.deleteAllEffect(var_15_0)
			else
				text.addEffect(var_15_0, {
					outline = {
						size = 1,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				})
			end

			arg_10_0.btn:setTouchEnabled(var_15_1 ~= nil)
			var_15_0:text(gLanguageCsv.spaceUse)
		end
	end)
	Dialog.onCreate(arg_10_0)
end

function var_0_1.getData(arg_16_0)
	local var_16_0 = gGameModel.role:read("titles")
	local var_16_1 = {}

	for iter_16_0, iter_16_1 in pairs(var_16_0) do
		if not gTitleCsv[iter_16_0].sameId then
			var_16_1[iter_16_0] = {
				iter_16_1[1],
				iter_16_1[2],
				id = iter_16_0
			}
		end
	end

	for iter_16_2, iter_16_3 in pairs(var_16_0) do
		local var_16_2 = gTitleCsv[iter_16_2].sameId

		if var_16_2 and (not var_16_1[var_16_2] or iter_16_3[1] > var_16_1[var_16_2][1]) then
			var_16_1[var_16_2] = {
				iter_16_3[1],
				iter_16_3[2],
				id = iter_16_2
			}
		end
	end

	local var_16_3 = {}

	for iter_16_4, iter_16_5 in pairs(var_16_1) do
		if gTitleCsv[iter_16_4].alwaysDisplay == 1 then
			table.insert(var_16_3, {
				id = iter_16_5.id,
				data = iter_16_5
			})
		end
	end

	local var_16_4 = 0
	local var_16_5 = 0
	local var_16_6 = {}
	local var_16_7 = {}

	for iter_16_6, iter_16_7 in orderCsvPairs(gTitleCsv) do
		if iter_16_7.alwaysDisplay == 1 and not iter_16_7.sameId then
			var_16_6[iter_16_7.type] = var_16_6[iter_16_7.type] or {}
			var_16_5 = var_16_5 + 1

			if not var_16_1[iter_16_6] or not var_16_1[iter_16_6].id then
				local var_16_8 = iter_16_6
			end

			table.insert(var_16_6[iter_16_7.type], {
				id = var_16_1[iter_16_6] and var_16_1[iter_16_6].id or iter_16_6,
				data = var_16_1[iter_16_6]
			})

			if var_16_1[iter_16_6] then
				var_16_7[iter_16_7.type] = var_16_7[iter_16_7.type] or {}

				table.insert(var_16_7[iter_16_7.type], {
					id = var_16_1[iter_16_6] and var_16_1[iter_16_6].id or iter_16_6,
					data = var_16_1[iter_16_6]
				})

				var_16_4 = var_16_4 + 1
			end
		end
	end

	arg_16_0.checkTip:text(string.format(gLanguageCsv.gotTitle, var_16_4, var_16_5))
	adapt.oneLineCenterPos(cc.p(281, 53), {
		arg_16_0.checkStatus,
		arg_16_0.checkTip
	}, cc.p(10, 0))

	for iter_16_8, iter_16_9 in pairs(var_16_6) do
		table.sort(iter_16_9, function(arg_17_0, arg_17_1)
			if not arg_17_0.data and arg_17_1.data then
				return false
			end

			if arg_17_0.data and not arg_17_1.data then
				return true
			end

			return arg_17_0.id < arg_17_1.id
		end)
	end

	for iter_16_10, iter_16_11 in pairs(var_16_7) do
		table.sort(iter_16_11, function(arg_18_0, arg_18_1)
			return arg_18_0.id < arg_18_1.id
		end)
	end

	local var_16_9 = {
		{
			id = -1,
			data = gLanguageCsv.currNoTitle
		}
	}
	local var_16_10 = {}

	if not itertools.isempty(var_16_3) then
		table.sort(var_16_3, function(arg_19_0, arg_19_1)
			return arg_19_0.data[2] > arg_19_1.data[2]
		end)
		arg_16_0.id:set(var_16_3[1].id)
		table.insert(var_16_10, {
			name = gLanguageCsv.recentGain,
			titles = arraytools.slice(var_16_3, 1, 3)
		})
	end

	for iter_16_12, iter_16_13 in orderCsvPairs(csv.title_type) do
		table.insert(var_16_10, {
			name = iter_16_13.name,
			titles = itertools.isempty(var_16_6[iter_16_13.type]) and var_16_9 or var_16_6[iter_16_13.type],
			ownTitles = itertools.isempty(var_16_7[iter_16_13.type]) and var_16_9 or var_16_7[iter_16_13.type]
		})
	end

	var_16_10[1].isSelected = true
	var_16_10[1].isDropDown = true

	return var_16_1, var_16_10
end

function var_0_1.initModel(arg_20_0)
	arg_20_0.titleId = gGameModel.role:getIdler("title_id")
end

function var_0_1.onChangeState(arg_21_0)
	arg_21_0.checkState:modify(function(arg_22_0)
		return true, not arg_22_0
	end)
end

function var_0_1.onParentNodeClick(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	arg_23_0.showTab:set(arg_23_2, true)
end

function var_0_1.onNodeClick(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = gTitleCsv[arg_24_3.id]

	bind.extend(arg_24_0, arg_24_0.titlePanel, {
		event = "extend",
		class = "role_title",
		props = {
			data = arg_24_3.id
		}
	})

	local var_24_1 = {}

	for iter_24_0 = 1, 3 do
		local var_24_2 = var_24_0["attrType" .. iter_24_0]

		if var_24_2 == nil or var_24_2 == 0 then
			break
		end

		local var_24_3 = var_24_0["attrNatureType" .. iter_24_0]
		local var_24_4 = var_24_3 == 0 and gLanguageCsv.allSprite or string.format(gLanguageCsv.someSprite, gLanguageCsv[game.NATURE_TABLE[var_24_3]])
		local var_24_5 = var_24_0["attrValue" .. iter_24_0]

		if var_24_5 then
			table.insert(var_24_1, {
				txt = var_24_4,
				attrType = var_24_2,
				attrValue = var_24_5,
				typ = var_24_3
			})
		end
	end

	arg_24_0.attrData:set(var_24_1)

	local var_24_6 = {}

	for iter_24_1 = 1, 2 do
		local var_24_7 = var_24_0[iter_24_1 == 1 and "conditionDesc" or "conditionDesc2"]

		if var_24_7 then
			table.insert(var_24_6, {
				con = var_24_7
			})
		end
	end

	if var_24_0.feature == nil and var_24_0.itemId == nil then
		local var_24_8 = gGameModel.role:getTitleProgress(var_24_0.condition1, var_24_0.conditionArg1_1, var_24_0.conditionArg1_2)

		var_24_6[1].progress = var_24_8
	end

	arg_24_0.conditionData:set(var_24_6)
	arg_24_0.id:set(arg_24_3.id)
	arg_24_0.timeLimit:y(#var_24_6 == 1 and arg_24_0.originY + 20 or arg_24_0.originY - 40)
end

function var_0_1.onUseOrDown(arg_25_0)
	gGameApp:requestServer("/game/role/title/switch", function(arg_26_0)
		if arg_25_0.id:read() == arg_25_0.titleId:read() then
			gGameUI:showTip(gLanguageCsv.successUseTitle)
		else
			gGameUI:showTip(gLanguageCsv.successDischargeTitle)
		end
	end, arg_25_0.id:read() == arg_25_0.titleId:read() and -1 or arg_25_0.id:read())
end

return var_0_1
