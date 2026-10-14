local var_0_0 = class("ResonanceView", Dialog)

var_0_0.RESOURCE_FILENAME = "gem_resonance.json"
var_0_0.RESOURCE_BINDING = {
	name = "name",
	suitList2 = "suitList2",
	icon = "icon",
	suit3 = "suit3",
	item = "item",
	suit1 = "suit1",
	suit2 = "suit2",
	suitList = "suitList",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	titleTxt1 = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	titleTxt2 = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	downList = {
		varname = "downList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("suitData"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("icon"):texture(arg_1_3.icon)
					arg_1_1:get("select"):visible(arg_1_3.select)
					arg_1_1:onTouch(functools.partial(arg_1_0.clickCell, arg_1_1, arg_1_2, arg_1_3))
				end
			},
			handlers = {
				clickCell = bindHelper.self("btnSuitFunc")
			}
		}
	},
	icon1 = {
		varname = "icon1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_2_0)
					arg_2_0:atrributeBtn(2)
				end)
			}
		}
	},
	icon2 = {
		varname = "icon2",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_3_0)
					arg_3_0:atrributeBtn(3)
				end)
			}
		}
	},
	icon3 = {
		varname = "icon3",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_4_0)
					arg_4_0:atrributeBtn(4)
				end)
			}
		}
	},
	icon4 = {
		varname = "icon4",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_5_0)
					arg_5_0:atrributeBtn(5)
				end)
			}
		}
	},
	icon5 = {
		varname = "icon5",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_6_0)
					arg_6_0:atrributeBtn(6)
				end)
			}
		}
	}
}

function var_0_0.onCreate(arg_7_0)
	arg_7_0.suit2:hide()
	arg_7_0.suit1:hide()
	arg_7_0.suit3:hide()
	arg_7_0.suitList:setScrollBarEnabled(false)
	arg_7_0.suitList2:setScrollBarEnabled(false)

	arg_7_0.quality = 2
	arg_7_0.suitId = 1
	arg_7_0.btnTab = idler.new(1)
	arg_7_0.suitData = idlers.new({})

	local var_7_0 = {}

	for iter_7_0 = 1, 9 do
		table.insert(var_7_0, {
			select = false,
			icon = ui.GEM_SUIT_ICON[iter_7_0]
		})
	end

	arg_7_0.suitData:update(var_7_0)
	arg_7_0.btnTab:addListener(function(arg_8_0, arg_8_1)
		arg_7_0.suitData:atproxy(arg_8_1).select = false
		arg_7_0.suitData:atproxy(arg_8_0).select = true
	end)
	arg_7_0.icon:texture("city/card/gem/suit/icon_t1.png")
	arg_7_0.icon1:get("select"):visible(true)
	arg_7_0:suitUpdate(arg_7_0.suitId, arg_7_0.quality)
	arg_7_0.item:visible(false)
	Dialog.onCreate(arg_7_0)
end

function var_0_0.atrributeBtn(arg_9_0, arg_9_1)
	for iter_9_0 = 2, 6 do
		arg_9_0["icon" .. iter_9_0 - 1]:get("select"):visible(iter_9_0 == arg_9_1)
	end

	if arg_9_1 ~= arg_9_0.quality then
		arg_9_0:suitUpdate(arg_9_0.suitId, arg_9_1)

		arg_9_0.quality = arg_9_1
	end
end

function var_0_0.btnSuitFunc(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	if arg_10_5.name == "began" then
		arg_10_0.touchBeganPos = arg_10_2:getTouchBeganPosition()

		arg_10_0.downList:setTouchEnabled(false)

		arg_10_0.isClicked = true
	elseif arg_10_5.name == "moved" then
		local var_10_0 = arg_10_5

		if math.abs(var_10_0.x - arg_10_0.touchBeganPos.x) >= ui.TOUCH_MOVED_THRESHOLD then
			arg_10_0.isClicked = false

			arg_10_0.downList:setTouchEnabled(true)
		end
	elseif (arg_10_5.name == "ended" or arg_10_5.name == "cancelled") and arg_10_0.isClicked then
		arg_10_0.btnTab:set(arg_10_3)
		arg_10_0.icon:texture(ui.GEM_SUIT_ICON[arg_10_3])

		if arg_10_0.suitId ~= arg_10_3 then
			arg_10_0:suitUpdate(arg_10_3, arg_10_0.quality)

			arg_10_0.suitId = arg_10_3
		end
	end
end

function var_0_0.suitUpdate(arg_11_0, arg_11_1, arg_11_2)
	if not arg_11_1 then
		return
	end

	arg_11_0.suitList:removeAllChildren()
	arg_11_0.suitList2:removeAllChildren()

	local function var_11_0(arg_12_0)
		local var_12_0 = arg_11_0.suit1:clone():show()

		var_12_0:get("txt"):text(gLanguageCsv["symbolNumber" .. arg_12_0] .. gLanguageCsv.emboitement)
		arg_11_0.suitList:pushBackCustomItem(var_12_0)
	end

	local var_11_1 = true

	for iter_11_0 = 1, 9 do
		local var_11_2 = gGemSuitCsv[arg_11_1][arg_11_2][iter_11_0]

		if var_11_2 then
			if var_11_1 then
				var_11_1 = false

				arg_11_0.name:text(var_11_2.suitName)
			end

			var_11_0(var_11_2.suitNum or 6)

			local var_11_3

			for iter_11_1 = 1, math.huge do
				if var_11_2["attrType" .. iter_11_1] and var_11_2["attrType" .. iter_11_1] ~= 0 then
					if iter_11_1 % 3 == 1 then
						var_11_3 = arg_11_0.suitList2:clone()

						arg_11_0.suitList:pushBackCustomItem(var_11_3)
					end

					local var_11_4 = game.ATTRDEF_TABLE[var_11_2["attrType" .. iter_11_1]]
					local var_11_5 = gLanguageCsv["attr" .. string.caption(var_11_4)]
					local var_11_6 = arg_11_0.suit2:clone():show()

					var_11_6:get("txt"):text(var_11_5)
					var_11_6:get("num"):x(var_11_6:get("txt"):width() + var_11_6:get("txt"):x())
					var_11_6:get("num"):text("+" .. dataEasy.getAttrValueString(var_11_2["attrType" .. iter_11_1], var_11_2["attrNum" .. iter_11_1]))
					var_11_3:pushBackCustomItem(var_11_6)
				else
					break
				end
			end

			local var_11_7 = arg_11_0.suit3:clone():show()

			arg_11_0.suitList:pushBackCustomItem(var_11_7)
		end
	end
end

return var_0_0
