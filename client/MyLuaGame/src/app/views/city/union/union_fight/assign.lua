local var_0_0 = class("UnionAssignView", Dialog)
local var_0_1 = 1.2
local var_0_2 = 12
local var_0_3 = 0.2
local var_0_4 = 300
local var_0_5 = 50
local var_0_6 = 7
local var_0_7 = 10
local var_0_8 = {
	insert = 1,
	change = 2
}
local var_0_9 = {
	CHAIRMAN = 1,
	MEMBER = 3,
	VICE_CHAIRMAN = 2
}
local var_0_10 = {
	before = 1,
	ended = 2
}
local var_0_11 = {
	DOWN = 3,
	UP = 2,
	RANDOM = 1
}
local var_0_12 = {
	gLanguageCsv.randomText,
	gLanguageCsv.fightPointUp,
	gLanguageCsv.fightPointDown
}

local function var_0_13(arg_1_0, arg_1_1)
	if arg_1_1.chairman == arg_1_0 then
		return var_0_9.CHAIRMAN
	end

	if arg_1_1.viceChairmans[arg_1_0] then
		return var_0_9.VICE_CHAIRMAN
	end

	return var_0_9.MEMBER
end

local function var_0_14(arg_2_0)
	for iter_2_0 = #arg_2_0, 1, -1 do
		if not arg_2_0[iter_2_0].isNull then
			return iter_2_0
		end
	end

	return 0
end

local function var_0_15(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0.baseDatas()[arg_3_2] = {
		isNull = true
	}

	local var_3_0 = arg_3_1:multiget("head", "info", "flag")

	itertools.invoke(var_3_0, "hide")
	arg_3_1:get("imgBg"):texture("city/union/union_fight/part2/bg_bz2.png")

	local var_3_1 = arg_3_1:get("normal")

	var_3_1:get("textIdx"):text(arg_3_2)
	text.addEffect(var_3_1:get("textIdx"), {
		outline = {
			color = ui.NEWCOLORS.OUTLINE.BLACK
		}
	})
	var_3_1:show()
	adapt.oneLinePos(arg_3_1:get("info.textFightNote"), arg_3_1:get("info.textFightPoint"))
end

local function var_0_16(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_1:multiget("head", "info")

	itertools.invoke(var_4_0, "show")

	local var_4_1 = "city/union/union_fight/part2/bg_bz1.png"

	if arg_4_3.isSel then
		var_4_1 = "city/union/union_fight/part2/bg_xz.png"
	end

	arg_4_1:get("imgBg"):texture(var_4_1)
	var_4_0.info:get("textLv"):text(arg_4_3.data.level)
	var_4_0.info:get("textName"):text(arg_4_3.data.name)
	var_4_0.info:get("textFightPoint"):text(arg_4_3.data.total_fp)
	adapt.oneLineCenterPos(cc.p(arg_4_1:size().width / 2, 20), {
		var_4_0.info:get("textFightNote"),
		var_4_0.info:get("textFightPoint")
	})
	adapt.oneLineCenterPos(cc.p(arg_4_1:size().width / 2, 105), {
		var_4_0.info:get("textLvNote"),
		var_4_0.info:get("textLv")
	})
	text.addEffect(arg_4_1:get("flag.textMe"), {
		outline = {
			color = ui.NEWCOLORS.OUTLINE.BLACK
		}
	})
	text.addEffect(var_4_0.info:get("textLv"), {
		outline = {
			color = ui.NEWCOLORS.OUTLINE.BLACK
		}
	})
	text.addEffect(var_4_0.info:get("textLvNote"), {
		outline = {
			color = ui.NEWCOLORS.OUTLINE.BLACK
		}
	})
	text.addEffect(var_4_0.info:get("textFightPoint"), {
		outline = {
			color = ui.NEWCOLORS.OUTLINE.BLACK
		}
	})
	arg_4_1:get("flag"):visible(arg_4_3.roleId == arg_4_0.roleId())
	arg_4_1:get("normal.textIdx"):text(arg_4_2)
	text.addEffect(arg_4_1:get("normal.textIdx"), {
		outline = {
			color = ui.NEWCOLORS.OUTLINE.BLACK
		}
	})
	arg_4_1:get("normal"):hide()
	var_4_0.head:scale(1)
	bind.extend(arg_4_0, var_4_0.head, {
		class = "role_logo",
		props = {
			vip = false,
			level = false,
			logoId = arg_4_3.data.logo,
			frameId = arg_4_3.data.frame,
			onNode = function(arg_5_0)
				arg_5_0:y(130)
			end
		}
	})
	arg_4_1:onTouch(functools.partial(arg_4_0.moveCell, arg_4_1, arg_4_2, arg_4_3))
	adapt.oneLinePos(arg_4_1:get("info.textFightNote"), arg_4_1:get("info.textFightPoint"))
end

local function var_0_17(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_1:get("textFightPoint"):text(arg_6_3.troops_fp)
	arg_6_1:get("flag.textIdx"):text(arg_6_2)
	text.addEffect(arg_6_1:get("flag.textIdx"), {
		outline = {
			size = 4,
			color = ui.NEWCOLORS.OUTLINE.BLACK
		}
	})
	text.addEffect(arg_6_1:get("flag.textNote"), {
		outline = {
			size = 4,
			color = ui.NEWCOLORS.OUTLINE.BLACK
		}
	})
	text.addEffect(arg_6_1:get("textFightPoint"), {
		outline = {
			size = 4,
			color = ui.COLORS.NORMAL.WHITE
		}
	})
	text.addEffect(arg_6_1:get("textFightNote"), {
		outline = {
			size = 4,
			color = ui.COLORS.NORMAL.WHITE
		}
	})

	local var_6_0 = true
	local var_6_1 = {
		{},
		{}
	}

	for iter_6_0 = 1, 3 do
		for iter_6_1 = 1, 2 do
			local var_6_2 = arg_6_3.cards[(iter_6_1 - 1) * 3 + iter_6_0]

			if var_6_2 then
				table.insert(var_6_1[iter_6_1], var_6_2)

				if var_6_0 and var_6_2[3] ~= 0 then
					var_6_0 = false
				end
			else
				table.insert(var_6_1[iter_6_1], {})
			end
		end
	end

	local function var_6_3(arg_7_0, arg_7_1)
		bind.extend(arg_6_0, arg_7_0, {
			class = "listview",
			props = {
				data = arg_7_1,
				item = arg_6_0.roleItem(),
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					if itertools.isempty(arg_8_3) then
						nodetools.invoke(arg_8_1, {
							"head",
							"bar",
							"imgDie",
							"imgBarBg"
						}, "hide")
						nodetools.invoke(arg_8_1, {
							"emptyPanel"
						}, "show")
					else
						nodetools.invoke(arg_8_1, {
							"head",
							"bar",
							"imgBarBg"
						}, "show")
						nodetools.invoke(arg_8_1, {
							"imgDie",
							"emptyPanel"
						}, "hide")

						local var_8_0 = csv.cards[arg_8_3[1]]
						local var_8_1 = arg_8_3[3] <= 0
						local var_8_2 = csv.unit[var_8_0.unitID].rarity
						local var_8_3 = dataEasy.getUnitId(arg_8_3[1], arg_8_3[2])

						bind.extend(arg_8_0, arg_8_1, {
							class = "card_icon",
							props = {
								unitId = var_8_3,
								rarity = var_8_2,
								grayState = var_8_1 and 1 or 0,
								levelProps = {
									data = arg_8_3[4]
								},
								star = arg_8_3[5],
								advance = arg_8_3[6],
								onNode = function(arg_9_0)
									arg_9_0:scale(0.7)
									arg_9_0:xy(0, 15)
								end
							}
						})
						arg_8_1:visible(true)
						arg_8_1:get("imgDie"):visible(var_8_1)
						bind.extend(arg_8_0, arg_8_1:get("bar"), {
							event = "extend",
							class = "loadingbar",
							props = {
								maskImg = "city/union/union_fight/part2/jdt_2.png",
								data = math.max(0, arg_8_3[3])
							}
						})
					end
				end
			}
		})
		arg_7_0:setRenderHint(0)
	end

	var_6_3(arg_6_1:get("list1"), var_6_1[1])
	var_6_3(arg_6_1:get("list2"), var_6_1[2])
	arg_6_1:get("fail"):visible(var_6_0)
	adapt.setAutoText(arg_6_1:get("textNote1"), nil, 70)
	adapt.setAutoText(arg_6_1:get("textNote2"), nil, 70)
end

var_0_0.RESOURCE_FILENAME = "union_fight_assign.json"
var_0_0.RESOURCE_BINDING = {
	item = "item",
	item2 = "item2",
	topView = "topView",
	innerList = "innerList",
	item1 = "item1",
	btnSort = {
		varname = "btnSort",
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("isMember"),
				method = function(arg_10_0)
					return not arg_10_0
				end
			},
			{
				event = "extend",
				class = "sort_menus",
				props = {
					btnType = 4,
					expandUp = true,
					showLock = false,
					data = bindHelper.self("sortTabData"),
					defaultTitle = bindHelper.self("btnTitle"),
					btnClick = bindHelper.self("onSortMenusBtnClick", true),
					showSortList = bindHelper.self("btnState"),
					locked = bindHelper.self("locked"),
					onNode = function(arg_11_0)
						arg_11_0:xy(-1125, -480):z(20)
					end
				}
			}
		}
	},
	["timeInfo.textTimeNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["timeInfo.textTip"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("isMember"),
			method = function(arg_12_0)
				return not arg_12_0
			end
		}
	},
	["timeInfo.textTime"] = {
		binds = {
			{
				event = "text",
				idler = bindHelper.self("time"),
				method = function(arg_13_0)
					return time.getCutDown(arg_13_0).str
				end
			},
			{
				event = "effect",
				data = {
					outline = {
						color = ui.COLORS.OUTLINE.WHITE
					}
				}
			}
		}
	},
	["btnBack.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["btnSave.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	leftList = {
		varname = "leftList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 28,
				columnSize = 7,
				data = bindHelper.self("showDatas"),
				item = bindHelper.self("innerList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
					local var_14_0 = arg_14_0:getIdx(arg_14_2)

					arg_14_1:name("item" .. var_14_0.k)

					if arg_14_3.isNull then
						var_0_15(arg_14_0, arg_14_1, var_14_0.k, arg_14_3)
					else
						var_0_16(arg_14_0, arg_14_1, var_14_0.k, arg_14_3)
					end
				end
			},
			handlers = {
				moveCell = bindHelper.self("initHeroSprite"),
				baseDatas = bindHelper.self("baseDatas"),
				roleId = bindHelper.self("roleId"),
				clickCell = bindHelper.self("onClickCell")
			}
		}
	},
	rightList = {
		varname = "rightList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("teamDatas"),
				item = bindHelper.self("item1"),
				onItem = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
					var_0_17(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				end
			},
			handlers = {
				roleItem = bindHelper.self("item2")
			}
		}
	},
	btnBack = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnSave = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onSave")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("isMember"),
				method = function(arg_16_0)
					return not arg_16_0
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_17_0, arg_17_1)
	arg_17_0.locked = idler.new(1)
	arg_17_0.btnState = idler.new(false)
	arg_17_0.btnTitle = idler.new(gLanguageCsv.unionFightSortTitle)
	arg_17_0.isMember = idler.new(true)
	arg_17_0.sortType = idler.new()
	arg_17_0.sortTabData = idlertable.new(var_0_12)

	arg_17_0:initModel()

	arg_17_0.curSelIdx = idler.new()
	arg_17_0.time = idler.new(0)
	arg_17_0.itemActionCache = {}
	arg_17_0.itemBoxCache = {}
	arg_17_0.teamDatas = idlers.newWithMap({})
	arg_17_0.baseDatas = {}
	arg_17_0.showDatas = idlers.newWithMap({})

	local var_17_0 = arg_17_1.roles
	local var_17_1 = arg_17_1.rolesInfo

	idlereasy.when(arg_17_0.sortType, function(arg_18_0, arg_18_1)
		local var_18_0 = 0
		local var_18_1 = {}

		for iter_18_0, iter_18_1 in ipairs(var_17_0) do
			if not arg_17_0:isAllCardDie(var_17_1[iter_18_1].troops) then
				table.insert(var_18_1, {
					isSel = false,
					isNull = false,
					data = var_17_1[iter_18_1],
					roleId = iter_18_1
				})

				var_18_0 = var_18_0 + 1
			end
		end

		local var_18_2 = math.ceil(var_18_0 / var_0_6) + 1
		local var_18_3 = math.max(4, var_18_2)

		for iter_18_2 = 1, var_18_3 * var_0_6 - var_18_0 do
			table.insert(var_18_1, {
				isSel = false,
				isNull = true
			})
		end

		if not arg_17_0.modelDatas then
			arg_17_0.modelDatas = clone(var_18_1)
		end

		if arg_18_1 then
			if arg_18_1 == 1 then
				local var_18_4 = #arg_17_1.roles

				for iter_18_3 = 1, math.floor(var_18_4 / 2) do
					local var_18_5 = math.random(1, var_18_4)
					local var_18_6 = math.random(1, var_18_4)

					var_18_1[var_18_5], var_18_1[var_18_6] = var_18_1[var_18_6], var_18_1[var_18_5]
				end
			else
				table.sort(var_18_1, function(arg_19_0, arg_19_1)
					if arg_18_1 == 3 then
						if arg_19_0.data and arg_19_1.data then
							return arg_19_0.data.total_fp > arg_19_1.data.total_fp
						elseif arg_19_0.data or arg_19_1.data then
							return arg_19_0.data ~= nil
						end

						return false
					elseif arg_18_1 == 2 then
						if arg_19_0.data and arg_19_1.data then
							return arg_19_0.data.total_fp < arg_19_1.data.total_fp
						elseif arg_19_0.data or arg_19_1.data then
							return arg_19_0.data ~= nil
						end

						return false
					end
				end)
			end
		end

		if not arg_17_0.selectId then
			arg_17_0.selectId = var_18_1[1].roleId
		end

		local var_18_7

		for iter_18_4, iter_18_5 in ipairs(var_18_1) do
			if arg_17_0.selectId and iter_18_5.roleId == arg_17_0.selectId then
				var_18_7 = iter_18_4

				break
			end
		end

		var_18_1[var_18_7].isSel = true
		arg_17_0.baseDatas = var_18_1

		arg_17_0.showDatas:update(var_18_1)
		arg_17_0.curSelIdx:set(var_18_7)
		arg_17_0.teamDatas:update(var_18_1[var_18_7].data.troops)
	end)
	arg_17_0.curSelIdx:addListener(function(arg_20_0, arg_20_1)
		if arg_17_0.showDatas:atproxy(arg_20_0) and not arg_17_0.showDatas:atproxy(arg_20_0).isNull then
			if arg_20_1 and arg_17_0.showDatas:atproxy(arg_20_1) then
				arg_17_0.showDatas:atproxy(arg_20_1).isSel = false
			end

			if arg_20_0 and arg_17_0.showDatas:atproxy(arg_20_0) then
				arg_17_0.showDatas:atproxy(arg_20_0).isSel = true

				arg_17_0.teamDatas:update(arg_17_0.baseDatas[arg_20_0].data.troops)

				arg_17_0.selectId = arg_17_0.baseDatas[arg_20_0].roleId
			end
		end
	end)

	local var_17_2 = time.getTime()
	local var_17_3 = arg_17_0.nextBattleTime - var_17_2

	arg_17_0.time:set(var_17_3)
	arg_17_0:enableSchedule():schedule(function()
		var_17_3 = var_17_3 - 1

		if var_17_3 < 0 then
			Dialog.onClose(arg_17_0)

			return false
		end

		arg_17_0.time:set(var_17_3)
	end, 1, nil)
	Dialog.onCreate(arg_17_0, {
		clickClose = false
	})
end

function var_0_0.isAllCardDie(arg_22_0, arg_22_1)
	for iter_22_0, iter_22_1 in ipairs(arg_22_1) do
		for iter_22_2, iter_22_3 in pairs(iter_22_1.cards) do
			if iter_22_3[3] > 0 then
				return false
			end
		end
	end

	return true
end

function var_0_0.initModel(arg_23_0)
	arg_23_0.nextBattleTime = gGameModel.union_fight:read("next_round_battle_time")
	arg_23_0.roleId = gGameModel.role:read("id")

	local var_23_0 = gGameModel.union

	arg_23_0.chairmanId = var_23_0:getIdler("chairman_db_id")
	arg_23_0.viceChairmans = var_23_0:getIdler("vice_chairmans")

	idlereasy.any({
		arg_23_0.chairmanId,
		arg_23_0.viceChairmans
	}, function(arg_24_0, arg_24_1, arg_24_2)
		local var_24_0 = {
			chairman = arg_24_1
		}
		local var_24_1 = {}

		for iter_24_0, iter_24_1 in ipairs(arg_24_2) do
			var_24_1[iter_24_1] = true
		end

		var_24_0.viceChairmans = var_24_1

		local var_24_2 = var_0_13(arg_23_0.roleId, var_24_0) == var_0_9.MEMBER

		arg_23_0.isMember:set(var_24_2)
	end)
end

function var_0_0.getPercent(arg_25_0)
	local var_25_0 = arg_25_0.leftList:getInnerContainer()
	local var_25_1 = var_25_0:size()
	local var_25_2 = arg_25_0.leftList:size()
	local var_25_3, var_25_4 = var_25_0:xy()

	return 100 - math.abs(var_25_4) / (var_25_1.height - var_25_2.height) * 100
end

function var_0_0.onClickCell(arg_26_0, arg_26_1, arg_26_2)
	if arg_26_2 == arg_26_0.curSelIdx:read() or arg_26_0.baseDatas[arg_26_2].isNull then
		return
	end

	arg_26_0.curSelIdx:set(arg_26_2)
end

function var_0_0.deleteMovingItem(arg_27_0)
	if arg_27_0.movePanel then
		arg_27_0.movePanel:removeSelf()

		arg_27_0.movePanel = nil

		return true
	end
end

function var_0_0.initHeroSprite(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	if arg_28_5.name == "began" then
		arg_28_0.topView:setTouchEnabled(true)

		arg_28_0.touchBeganPos = arg_28_5
		arg_28_0.hasMovingItem = nil
		arg_28_0.movingTime = 0
		arg_28_0.isClick = false

		arg_28_0:deleteMovingItem()
		arg_28_1:enableSchedule()

		if not arg_28_0.isMember:read() then
			arg_28_1:schedule(function(arg_29_0)
				arg_28_0.movingTime = arg_28_0.movingTime + arg_29_0

				if arg_28_0.movingTime >= 0.3 then
					arg_28_0.isClick = true

					if arg_28_0.leftList:getItemNodes(arg_28_0.curSelIdx:read()) then
						arg_28_0.leftList:getItemNodes(arg_28_0.curSelIdx:read()):get("imgBg"):texture("city/union/union_fight/part2/bg_bz1.png")
					end

					local var_29_0 = arg_28_0.leftList:getItemNodes(arg_28_3)

					var_29_0:get("imgBg"):texture("city/union/union_fight/part2/bg_xz.png")
					var_29_0:get("head"):scale(var_0_1)

					return false
				end
			end, 0.1, nil, "itemSchedule" .. arg_28_3)
		end
	elseif arg_28_5.name == "moved" then
		local var_28_0 = math.abs(arg_28_5.x - arg_28_0.touchBeganPos.x)
		local var_28_1 = math.abs(arg_28_5.y - arg_28_0.touchBeganPos.y)

		if arg_28_0.hasMovingItem == nil and (arg_28_0.isClick or var_28_0 >= ui.TOUCH_MOVED_THRESHOLD or var_28_1 >= ui.TOUCH_MOVED_THRESHOLD) then
			arg_28_0.hasMovingItem = false

			arg_28_1:unSchedule("itemSchedule" .. arg_28_3)

			if not arg_28_0.isMember:read() and (arg_28_0.isClick or var_28_1 < var_28_0 * 0.7 or arg_28_0:getPercent() < 0.1 and arg_28_5.y < arg_28_0.touchBeganPos.y or arg_28_0:getPercent() > 99.9 and arg_28_5.y > arg_28_0.touchBeganPos.y) then
				if arg_28_0.leftList:getItemNodes(arg_28_0.curSelIdx:read()) then
					arg_28_0.leftList:getItemNodes(arg_28_0.curSelIdx:read()):get("imgBg"):texture("city/union/union_fight/part2/bg_bz1.png")
				end

				local var_28_2 = arg_28_0.leftList:getItemNodes(arg_28_3)

				var_28_2:get("imgBg"):texture("city/union/union_fight/part2/bg_xz.png")
				var_28_2:get("head"):scale(var_0_1)

				arg_28_0.hasMovingItem = true
				arg_28_0.movePanel = arg_28_5.target:get("head"):clone():addTo(arg_28_0.topView, 1000, "cloneRoleItem" .. arg_28_3):scale(var_0_1)

				bind.extend(arg_28_0, arg_28_0.movePanel, {
					class = "role_logo",
					props = {
						vip = false,
						level = false,
						logoId = arg_28_0.baseDatas[arg_28_3].data.logo,
						frameId = arg_28_0.baseDatas[arg_28_3].data.frame
					}
				})

				local var_28_3 = arg_28_0.leftList:getItemNodes(arg_28_3)

				var_28_3:get("head"):hide()
				var_28_3:get("info"):hide()
				var_28_3:get("flag"):hide()
				var_28_3:get("normal"):show()
				var_28_3:get("normal.textIdx"):text(arg_28_3)
			end
		end

		arg_28_0.leftList:setTouchEnabled(not arg_28_0.hasMovingItem)

		if arg_28_0.movePanel then
			local var_28_4 = arg_28_0.topView:convertToNodeSpace(arg_28_5)

			arg_28_0.movePanel:xy(var_28_4)

			local var_28_5, var_28_6, var_28_7 = arg_28_0:whichEmbattleTargetPos(arg_28_5.target:get("head"), var_28_4, arg_28_3)

			arg_28_0:playHeadAction(var_28_5, var_28_6, var_28_7)
		end
	elseif arg_28_5.name == "ended" or arg_28_5.name == "cancelled" then
		arg_28_0.topView:setTouchEnabled(false)
		arg_28_1:unSchedule("itemSchedule" .. arg_28_3)

		if arg_28_0.hasMovingItem == nil then
			arg_28_0.curSelIdx:set(arg_28_3)
		end

		arg_28_0.hasMovingItem = nil

		arg_28_0.leftList:getItemNodes(arg_28_3):get("head"):scale(1)

		if arg_28_0:deleteMovingItem() then
			arg_28_0.leftList:getItemNodes(arg_28_3):get("normal"):hide()
			arg_28_0.leftList:getItemNodes(arg_28_3):get("imgBg"):texture("city/union/union_fight/part2/bg_bz1.png")

			local var_28_8 = arg_28_0.topView:convertToNodeSpace(arg_28_5)
			local var_28_9, var_28_10, var_28_11 = arg_28_0:whichEmbattleTargetPos(arg_28_5.target:get("head"), var_28_8, arg_28_3)

			if var_28_9 then
				if var_28_9 == var_28_10 or var_28_9 == arg_28_3 or var_28_10 == arg_28_3 then
					if var_28_9 ~= var_28_10 then
						var_28_9 = arg_28_3
					end

					arg_28_0:playChangeAction(var_28_9, arg_28_3)
				else
					arg_28_0:playInsertAction(var_28_9, var_28_10, arg_28_3)
				end
			else
				local var_28_12 = arg_28_0.curSelIdx:read() == arg_28_3

				arg_28_0.curSelIdx:set(arg_28_3, var_28_12)
			end

			arg_28_0:playHeadAction()
		end
	end
end

function var_0_0.createNode(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0.item:get("head"):clone():addTo(arg_30_0.topView, 1000)
	local var_30_1 = gGameUI:getConvertPos(arg_30_1:get("head"), arg_30_0.topView)

	var_30_0:xy(var_30_1.x, var_30_1.y + var_0_7)
	bind.extend(arg_30_0, var_30_0, {
		class = "role_logo",
		props = {
			vip = false,
			level = false,
			logoId = arg_30_2.logo,
			frameId = arg_30_2.frame
		}
	})
	var_30_0:show()

	return var_30_0
end

function var_0_0.playChangeAction(arg_31_0, arg_31_1, arg_31_2)
	if arg_31_1 == arg_31_2 then
		local var_31_0 = arg_31_0.leftList:getItemNodes(arg_31_2)

		var_31_0:get("head"):show()
		var_31_0:get("info"):show()
		var_31_0:get("flag"):visible(arg_31_0.baseDatas[arg_31_1].roleId == arg_31_0.roleId)
		var_31_0:get("normal"):hide()
		arg_31_0.curSelIdx:set(arg_31_1)

		return
	end

	local var_31_1 = arg_31_0.leftList:getItemNodes(arg_31_1)
	local var_31_2 = arg_31_0.leftList:getItemNodes(arg_31_2)

	if not var_31_1 or not var_31_2 then
		return
	end

	local var_31_3 = arg_31_0.item:clone():addTo(arg_31_0.topView, 1000, "curPosClone")
	local var_31_4 = gGameUI:getConvertPos(var_31_1, arg_31_0.topView)

	var_31_3:xy(var_31_4.x, var_31_4.y)

	local var_31_5 = arg_31_0.baseDatas[arg_31_2]

	bind.extend(arg_31_0, var_31_3:get("head"), {
		class = "role_logo",
		props = {
			vip = false,
			level = false,
			logoId = var_31_5.data.logo,
			frameId = var_31_5.data.frame
		}
	})
	var_31_3:get("head"):y(var_31_3:get("head"):y() + var_0_7)
	var_31_3:get("info.textName"):text(var_31_5.data.name)
	var_31_3:get("info.textFightPoint"):text(var_31_5.data.total_fp)
	var_31_3:get("normal"):hide()
	var_31_3:get("flag"):visible(var_31_5.roleId == arg_31_0.roleId)
	adapt.oneLineCenterPos(cc.p(var_31_3:size().width / 2, 20), {
		var_31_3:get("info.textFightNote"),
		var_31_3:get("info.textFightPoint")
	})
	adapt.oneLineCenterPos(cc.p(var_31_3:size().width / 2, 105), {
		var_31_3:get("info.textLvNote"),
		var_31_3:get("info.textLv")
	})
	text.addEffect(var_31_3:get("flag.textMe"), {
		outline = {
			color = ui.NEWCOLORS.OUTLINE.BLACK
		}
	})
	text.addEffect(var_31_3:get("info.textLv"), {
		outline = {
			size = 3,
			color = ui.NEWCOLORS.OUTLINE.BLACK
		}
	})
	text.addEffect(var_31_3:get("info.textLvNote"), {
		outline = {
			size = 3,
			color = ui.NEWCOLORS.OUTLINE.BLACK
		}
	})
	var_31_3:show()

	local var_31_6 = arg_31_0.baseDatas[arg_31_1]
	local var_31_7 = arg_31_0.item:get("head"):clone():addTo(arg_31_0.topView, 1001, "tarPosClone")
	local var_31_8 = gGameUI:getConvertPos(var_31_1:get("head"), arg_31_0.topView)

	var_31_7:xy(var_31_8.x, var_31_8.y + var_0_7)
	bind.extend(arg_31_0, var_31_7, {
		class = "role_logo",
		props = {
			vip = false,
			level = false,
			logoId = var_31_6.data.logo,
			frameId = var_31_6.data.frame
		}
	})
	var_31_7:show()
	arg_31_0.topView:setTouchEnabled(true)

	local var_31_9 = gGameUI:getConvertPos(var_31_2:get("head"), arg_31_0.topView)

	transition.executeSequence(var_31_7):moveTo(var_0_3, var_31_9.x, var_31_9.y + var_0_7):func(function()
		performWithDelay(arg_31_0, function()
			var_31_3:removeFromParent()

			var_31_3 = nil

			var_31_7:removeFromParent()

			var_31_7 = nil

			dataEasy.tryCallFunc(arg_31_0.leftList, "updatePreloadCenterIndex")

			local var_33_0 = arg_31_1
			local var_33_1 = false

			if var_33_0 == arg_31_0.curSelIdx:read() then
				arg_31_0.baseDatas[arg_31_1].isSel = false
				var_33_1 = true
			end

			arg_31_0.baseDatas[arg_31_1], arg_31_0.baseDatas[arg_31_2] = arg_31_0.baseDatas[arg_31_2], arg_31_0.baseDatas[arg_31_1]

			arg_31_0.showDatas:update(arg_31_0.baseDatas)
			arg_31_0.curSelIdx:set(var_33_0, var_33_1)
			arg_31_0.topView:setTouchEnabled(false)
		end, 0.016666666666666666)
	end):done()
end

function var_0_0.playInsertAction(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	local var_34_0 = arg_34_0.baseDatas[arg_34_3]
	local var_34_1 = {}
	local var_34_2
	local var_34_3

	if arg_34_3 < arg_34_1 then
		var_34_2 = var_0_10.before
		var_34_3 = arg_34_1

		for iter_34_0 = arg_34_3 + 1, arg_34_1 do
			local var_34_4 = arg_34_0.leftList:getItemNodes(iter_34_0)

			if var_34_4 then
				itertools.invoke(var_34_4:multiget("head", "info", "flag", "normal"), "hide")

				local var_34_5 = arg_34_0:createNode(var_34_4, arg_34_0.baseDatas[iter_34_0].data)

				table.insert(var_34_1, {
					item = var_34_5,
					idx = iter_34_0,
					isAction = iter_34_0 % var_0_6 ~= 1
				})
			end
		end
	elseif arg_34_2 < arg_34_3 then
		var_34_2 = var_0_10.ended
		var_34_3 = arg_34_2

		for iter_34_1 = arg_34_3 - 1, arg_34_2, -1 do
			local var_34_6 = arg_34_0.leftList:getItemNodes(iter_34_1)

			if var_34_6 then
				itertools.invoke(var_34_6:multiget("head", "info", "flag", "normal"), "hide")

				local var_34_7 = arg_34_0:createNode(var_34_6, arg_34_0.baseDatas[iter_34_1].data)

				table.insert(var_34_1, {
					item = var_34_7,
					idx = iter_34_1,
					isAction = iter_34_1 % var_0_6 ~= 0
				})
			end
		end
	end

	if not var_34_2 then
		return
	end

	local var_34_8 = arg_34_0.leftList:getItemNodes(var_34_3)
	local var_34_9 = arg_34_0:createNode(var_34_8, arg_34_0.baseDatas[arg_34_3].data)

	var_34_9:hide()
	arg_34_0.topView:setTouchEnabled(true)
	transition.executeSequence(var_34_9):delay(var_0_3 / 4):func(function()
		var_34_9:show()
	end):delay(var_0_3 / 4 * 3):delay(0.05):func(function()
		performWithDelay(arg_34_0, function()
			var_34_9:removeFromParent()
		end, 0.016666666666666666)
	end):done()

	for iter_34_2, iter_34_3 in ipairs(var_34_1) do
		local var_34_10 = var_34_2 == var_0_10.before and iter_34_3.idx - 1 or iter_34_3.idx + 1
		local var_34_11 = arg_34_0.leftList:getItemNodes(var_34_10)

		if var_34_11 then
			local var_34_12 = gGameUI:getConvertPos(var_34_11:get("head"), arg_34_0.topView)

			if iter_34_3.isAction then
				transition.executeSequence(iter_34_3.item):moveTo(var_0_3, var_34_12.x, var_34_12.y + var_0_7):delay(0.05):func(function()
					performWithDelay(arg_34_0, function()
						iter_34_3.item:removeFromParent()
					end, 0.016666666666666666)
				end):done()
			else
				transition.executeSequence(iter_34_3.item):delay(var_0_3 / 2):func(function()
					iter_34_3.item:xy(var_34_12.x, var_34_12.y + var_0_7)
				end):delay(var_0_3 / 2):delay(0.05):func(function()
					performWithDelay(arg_34_0, function()
						iter_34_3.item:removeFromParent()
					end, 0.016666666666666666)
				end):done()
			end
		end
	end

	transition.executeSequence(arg_34_0):delay(var_0_3 + 0.05):func(function()
		local var_43_0 = arg_34_1
		local var_43_1 = false

		if var_34_2 == var_0_10.before then
			if arg_34_0.curSelIdx:read() == arg_34_1 then
				var_43_1 = true
			end

			arg_34_0.baseDatas[arg_34_0.curSelIdx:read()].isSel = false

			for iter_43_0 = arg_34_3 + 1, arg_34_1 do
				arg_34_0.baseDatas[iter_43_0 - 1] = arg_34_0.baseDatas[iter_43_0]
			end

			arg_34_0.baseDatas[arg_34_1] = var_34_0
		else
			var_43_0 = arg_34_2

			if arg_34_0.curSelIdx:read() == arg_34_2 then
				var_43_1 = true
			end

			arg_34_0.baseDatas[arg_34_0.curSelIdx:read()].isSel = false

			for iter_43_1 = arg_34_3 - 1, arg_34_2, -1 do
				arg_34_0.baseDatas[iter_43_1 + 1] = arg_34_0.baseDatas[iter_43_1]
			end

			arg_34_0.baseDatas[arg_34_2] = var_34_0
		end

		dataEasy.tryCallFunc(arg_34_0.leftList, "updatePreloadCenterIndex")
		arg_34_0.showDatas:update(arg_34_0.baseDatas)
		arg_34_0.curSelIdx:set(var_43_0, var_43_1)
		arg_34_0.topView:setTouchEnabled(false)
	end):done()
end

function var_0_0.playHeadAction(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	if not arg_44_1 then
		for iter_44_0, iter_44_1 in pairs(arg_44_0.itemActionCache) do
			local var_44_0 = arg_44_0.leftList:getItemNodes(iter_44_0)

			if var_44_0 then
				var_44_0:get("imgFlag"):hide()
			end
		end

		arg_44_0.itemActionCache = {}

		return
	end

	if arg_44_1 ~= 0 then
		local var_44_1 = arg_44_0.leftList:getItemNodes(arg_44_1)
		local var_44_2 = var_0_14(arg_44_0.baseDatas)

		var_44_1:get("imgFlag"):visible(arg_44_1 ~= var_44_2 or arg_44_3 ~= var_0_8.insert)

		arg_44_0.itemActionCache[arg_44_1] = 1
	end

	arg_44_0.leftList:getItemNodes(arg_44_2):get("imgFlag"):show()

	arg_44_0.itemActionCache[arg_44_2] = 1

	local var_44_3 = {}

	for iter_44_2, iter_44_3 in pairs(arg_44_0.itemActionCache) do
		if iter_44_2 ~= arg_44_1 and iter_44_2 ~= arg_44_2 then
			local var_44_4 = arg_44_0.leftList:getItemNodes(iter_44_2)

			if var_44_4 then
				var_44_4:get("imgFlag"):hide()
				table.insert(var_44_3, iter_44_2)
			end
		end
	end

	for iter_44_4, iter_44_5 in ipairs(var_44_3) do
		arg_44_0.itemActionCache[iter_44_5] = nil
	end
end

function var_0_0.whichEmbattleTargetPos(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	local var_45_0 = arg_45_1:box()
	local var_45_1 = 190
	local var_45_2 = 190
	local var_45_3 = cc.p(arg_45_2.x - var_45_1 / 2 + var_0_2, arg_45_2.y + var_45_2 / 2 - var_0_2)
	local var_45_4 = cc.p(arg_45_2.x - var_45_1 / 2 + var_0_2, arg_45_2.y - var_45_2 / 2 + var_0_2)
	local var_45_5 = cc.p(arg_45_2.x + var_45_1 / 2 - var_0_2, arg_45_2.y + var_45_2 / 2 - var_0_2)
	local var_45_6 = cc.p(arg_45_2.x + var_45_1 / 2 - var_0_2, arg_45_2.y - var_45_2 / 2 + var_0_2)
	local var_45_7 = {
		var_45_3,
		var_45_5,
		var_45_4,
		var_45_6
	}
	local var_45_8 = #arg_45_0.baseDatas
	local var_45_9 = {}
	local var_45_10 = 0
	local var_45_11 = arg_45_0.leftList:getInnerContainer()
	local var_45_12 = var_45_11:size().height
	local var_45_13 = arg_45_0.leftList:size().height
	local var_45_14 = var_45_11:y()
	local var_45_15 = var_45_12 - var_45_13 - math.abs(var_45_14)

	for iter_45_0, iter_45_1 in ipairs(var_45_7) do
		for iter_45_2 = 1, var_45_8 do
			local var_45_16 = arg_45_0.itemBoxCache[iter_45_2]
			local var_45_17 = arg_45_0.leftList:getItemNodes(iter_45_2)

			if var_45_17 then
				if not var_45_16 then
					local var_45_18 = var_45_17

					var_45_16 = var_45_18:box()

					local var_45_19 = gGameUI:getConvertPos(var_45_18, arg_45_0.topView)

					var_45_16.x = var_45_19.x - var_45_16.width / 2
					var_45_16.y = var_45_19.y + var_0_7 - var_45_16.height / 2 - var_45_15
					arg_45_0.itemBoxCache[iter_45_2] = var_45_16
				end

				local var_45_20 = arg_45_0.leftList:getInnerContainer():y()
				local var_45_21 = {
					y = var_45_16.y + var_45_12 - var_45_13 - math.abs(var_45_20),
					x = var_45_16.x,
					width = var_45_16.width,
					height = var_45_16.height
				}

				if cc.rectContainsPoint(var_45_21, iter_45_1) then
					table.insert(var_45_9, {
						targetIdx = iter_45_2,
						pointIdx = iter_45_0
					})

					var_45_10 = var_45_10 + 1
				end
			end
		end
	end

	if var_45_10 <= 1 then
		return
	end

	return arg_45_0:getTargetMoveType(var_45_10, var_45_9, arg_45_2, arg_45_3)
end

function var_0_0.getTargetMoveType(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
	local var_46_0 = var_0_14(arg_46_0.baseDatas)

	if arg_46_1 == 2 then
		local var_46_1 = arg_46_2[1]
		local var_46_2 = arg_46_2[2]

		if var_46_1.targetIdx == var_46_2.targetIdx then
			if arg_46_0.baseDatas[var_46_1.targetIdx].isNull then
				return var_46_0, var_46_0 + 1, var_0_8.insert
			end

			if var_46_1.targetIdx % var_0_6 == 1 and var_46_1.pointIdx == 2 and var_46_2.pointIdx == 4 then
				return var_46_1.targetIdx - 1, var_46_1.targetIdx, var_0_8.insert
			end

			return var_46_1.targetIdx, var_46_1.targetIdx, var_0_8.change
		elseif var_46_2.pointIdx - var_46_1.pointIdx == 1 then
			if var_46_0 < var_46_1.targetIdx then
				return var_46_0, var_46_0 + 1, var_0_8.insert
			end

			return var_46_1.targetIdx, var_46_2.targetIdx, var_0_8.insert
		end
	end

	if arg_46_1 == 4 then
		local var_46_3 = arg_46_2[1]
		local var_46_4 = arg_46_2[2]
		local var_46_5 = arg_46_2[3]
		local var_46_6 = arg_46_2[4]

		if var_46_3.targetIdx == var_46_4.targetIdx and var_46_5.targetIdx == var_46_6.targetIdx and var_46_4.targetIdx == var_46_5.targetIdx then
			if var_46_3.targetIdx ~= arg_46_4 and arg_46_0.baseDatas[var_46_3.targetIdx].isNull then
				return var_46_0, var_46_0 + 1, var_0_8.insert
			else
				return var_46_3.targetIdx, var_46_4.targetIdx, var_0_8.change
			end
		elseif var_46_3.targetIdx == var_46_5.targetIdx and var_46_4.targetIdx == var_46_6.targetIdx and var_46_4.targetIdx ~= var_46_5.targetIdx then
			if var_46_0 < var_46_3.targetIdx then
				return var_46_0, var_46_0 + 1, var_0_8.insert
			end

			return var_46_3.targetIdx, var_46_4.targetIdx, var_0_8.insert
		else
			local var_46_7 = var_46_3.targetIdx
			local var_46_8 = var_46_4.targetIdx
			local var_46_9 = 0
			local var_46_10 = 0

			for iter_46_0 = 1, 2 do
				var_46_9 = var_46_9 + arg_46_0:getDistance(arg_46_3, arg_46_2[iter_46_0].targetIdx)
				var_46_10 = var_46_10 + arg_46_0:getDistance(arg_46_3, arg_46_2[iter_46_0 + 2].targetIdx)
			end

			if var_46_10 < var_46_9 then
				var_46_7, var_46_8 = var_46_5.targetIdx, var_46_6.targetIdx
			end

			if arg_46_0.baseDatas[var_46_5.targetIdx].isNull then
				return var_46_0, var_46_0 + 1, var_0_8.insert
			end

			local var_46_11 = var_46_3.targetIdx == var_46_4.targetIdx and var_0_8.change or var_0_8.insert

			return var_46_7, var_46_8, var_46_11
		end
	end
end

function var_0_0.getDistance(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_0.leftList:getItemNodes(arg_47_2)
	local var_47_1 = gGameUI:getConvertPos(var_47_0, arg_47_0.topView)

	return math.sqrt(math.abs(var_47_1.x - arg_47_1.x)^2 + math.abs(var_47_1.y + var_0_7 - arg_47_1.y)^2)
end

function var_0_0.onSortMenusBtnClick(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
	local var_48_0 = {
		btnType = 2,
		cb = function()
			arg_48_0.sortType:set(arg_48_3, true)
			arg_48_0.btnState:set(false)
		end,
		cancelCb = function()
			arg_48_0.btnState:set(false)
		end,
		content = string.format(gLanguageCsv.sortTipText, arg_48_0.sortTabData:read()[arg_48_3])
	}

	gGameUI:showDialog(var_48_0)
end

function var_0_0.isChange(arg_51_0)
	local var_51_0 = false

	for iter_51_0, iter_51_1 in ipairs(arg_51_0.modelDatas) do
		if arg_51_0.baseDatas[iter_51_0].roleId ~= iter_51_1.roleId then
			var_51_0 = true

			break
		end
	end

	return var_51_0
end

function var_0_0.onSave(arg_52_0, arg_52_1)
	if not arg_52_0:isChange() then
		return
	end

	local var_52_0 = {}

	for iter_52_0, iter_52_1 in ipairs(arg_52_0.baseDatas) do
		if not iter_52_1.data then
			break
		end

		table.insert(var_52_0, iter_52_1.roleId)
	end

	gGameApp:requestServer("/game/union/fight/top8/deploy", function(arg_53_0)
		arg_52_0.modelDatas = clone(arg_52_0.baseDatas)

		if arg_52_1 == true then
			Dialog.onClose(arg_52_0)

			return
		end

		gGameUI:showTip(gLanguageCsv.positionSave)
	end, var_52_0)
end

function var_0_0.onClose(arg_54_0)
	if not arg_54_0:isChange() then
		Dialog.onClose(arg_54_0)

		return
	end

	gGameUI:showDialog({
		clearFast = true,
		btnType = 2,
		cb = function()
			arg_54_0:onSave(true)
		end,
		cancelCb = function()
			Dialog.onClose(arg_54_0)
		end,
		content = gLanguageCsv.isSaveCurBattle
	})
end

return var_0_0
