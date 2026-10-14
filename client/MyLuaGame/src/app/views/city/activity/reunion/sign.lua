local var_0_0 = {
	received = 2,
	noReach = 0,
	canReceive = 1
}
local var_0_1 = {
	received = 2,
	noReach = 1,
	canReceive = 0
}
local var_0_2 = {
	sign = 1,
	reunion = 2
}
local var_0_3 = {
	ReunionGift = 1,
	TaskAward = 3,
	BindAward = 2,
	PointAward = 4
}
local var_0_4 = class("ReunionSignView", cc.load("mvc").ViewBase)

var_0_4.RESOURCE_FILENAME = "reunion_sign.json"
var_0_4.RESOURCE_BINDING = {
	["topPanel.textPanel"] = "topTextPanel",
	item = "item",
	["topPanel.textPanel.textBg"] = "toptextBg",
	["topPanel.bg.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(242, 122, 96, 255)
				},
				shadow = {
					size = 6,
					color = cc.c4b(195, 109, 72, 255),
					offset = cc.size(0, -6)
				}
			}
		}
	},
	["item.receivebtn.label"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["item.received.label"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["item.noReceive.label"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("datas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_1_0, arg_1_1)
					if arg_1_0.state ~= arg_1_1.state then
						return arg_1_0.state < arg_1_1.state
					end

					return arg_1_0.csvId < arg_1_1.csvId
				end,
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_3.cfg
					local var_2_1 = arg_2_1:multiget("list", "receivebtn", "received", "noReceive", "title", "subList", "item")

					var_2_1.title:text(string.format(gLanguageCsv.currDay, var_2_0.taskParam))
					var_2_1.receivebtn:visible(arg_2_3.state == var_0_1.canReceive)
					var_2_1.received:visible(arg_2_3.state == var_0_1.received)
					var_2_1.noReceive:visible(arg_2_3.state == var_0_1.noReach)
					bind.touch(arg_2_0, var_2_1.receivebtn, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
						}
					})
					var_2_1.list:removeAllItems()
					var_2_1.list:size(cc.size(376, 560))
					var_2_1.list:setScrollBarEnabled(false)
					var_2_1.list:setGravity(ccui.ListViewGravity.bottom)

					local var_2_2
					local var_2_3 = 0
					local var_2_4 = csvSize(var_2_0.award) == 1 and var_2_1.item:size().width / 2 or 0

					for iter_2_0, iter_2_1 in ipairs(dataEasy.getItemData(var_2_0.award)) do
						local var_2_5 = iter_2_1.key
						local var_2_6 = iter_2_1.num

						var_2_3 = var_2_3 + 1

						if var_2_3 % 2 == 1 then
							var_2_2 = var_2_1.subList:clone():show():tag(math.floor(var_2_3 / 2 + 1))

							var_2_2:setScrollBarEnabled(false)
							var_2_2:setTouchEnabled(false)
							var_2_1.list:pushBackCustomItem(var_2_2)
						end

						local var_2_7 = var_2_1.item:clone():show()
						local var_2_8 = var_2_7:size()

						bind.extend(arg_2_0, var_2_7, {
							class = "icon_key",
							props = {
								data = {
									key = var_2_5,
									num = var_2_6
								},
								onNode = function(arg_3_0)
									arg_3_0:xy(var_2_8.width / 2 + var_2_4, var_2_8.height / 2):scale(0.9)
								end
							}
						})
						var_2_2:pushBackCustomItem(var_2_7)
					end

					var_2_1.list:adaptTouchEnabled():setItemAlignCenter()
				end
			},
			handlers = {
				clickCell = bindHelper.self("onReceiveClick")
			}
		}
	}
}

function var_0_4.onCreate(arg_4_0, arg_4_1)
	arg_4_0.yyID = arg_4_1

	local var_4_0 = csv.yunying.yyhuodong[arg_4_1]

	arg_4_0:initModel()

	local var_4_1 = string.format(gLanguageCsv.reunionSignText, arg_4_0.reunion:read().info.days)
	local var_4_2 = rich.createByStr(var_4_1, 42):anchorPoint(0, 0.5):addTo(arg_4_0.topTextPanel:get("label")):formatText()

	arg_4_0.toptextBg:width(var_4_2:width() + 20)

	arg_4_0.datas = idlers.new()

	idlereasy.when(arg_4_0.reunion, function(arg_5_0, arg_5_1)
		local var_5_0 = arg_5_1.stamps or {}
		local var_5_1 = {}

		for iter_5_0, iter_5_1 in csvPairs(csv.yunying.reunion_task) do
			if iter_5_1.huodongID == var_4_0.huodongID and iter_5_1.themeType == var_0_2.sign then
				local var_5_2 = var_0_1.noReach

				if var_5_0[iter_5_0] and var_5_0[iter_5_0] == var_0_0.canReceive then
					var_5_2 = var_0_1.canReceive
				elseif var_5_0[iter_5_0] and var_5_0[iter_5_0] == var_0_0.received then
					var_5_2 = var_0_1.received
				end

				table.insert(var_5_1, {
					csvId = iter_5_0,
					cfg = iter_5_1,
					state = var_5_2
				})
			end
		end

		dataEasy.tryCallFunc(arg_4_0.list, "updatePreloadCenterIndex")
		arg_4_0.datas:update(var_5_1)
	end)
end

function var_0_4.initModel(arg_6_0)
	arg_6_0.reunion = gGameModel.role:getIdler("reunion")
end

function var_0_4.onReceiveClick(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if arg_7_3.state == var_0_1.canReceive then
		if arg_7_0.reunion:read().info.end_time - time.getTime() < 0 then
			gGameUI:showTip(gLanguageCsv.activityOver)

			return
		end

		gGameApp:requestServer("/game/yy/reunion/award/get", function(arg_8_0)
			gGameUI:showGainDisplay(arg_8_0)
		end, arg_7_0.yyID, arg_7_3.csvId, var_0_3.TaskAward)
	elseif arg_7_3.state == var_0_1.noReach then
		gGameUI:showTip(gLanguageCsv.notReachedCannotGet)
	end
end

return var_0_4
