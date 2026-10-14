local var_0_0 = table.insert
local var_0_1 = table.sort
local var_0_2 = {
	NORMAL = "city/card/gem/btn_yq_b.png",
	SELECTED = "city/card/gem/btn_yq_h.png"
}
local var_0_3 = class("GemView", Dialog)

var_0_3.RESOURCE_FILENAME = "activity_gem_up.json"
var_0_3.RESOURCE_BINDING = {
	["right.item"] = "item",
	["right.subList"] = "subList",
	["right.acquire.bg"] = "acquireBg",
	["right.acquire.num"] = "acquireNum",
	["right.noGemTip"] = "noGemTip",
	["right.btnFilterPanel.btnFilter.arrow"] = "filterArrow",
	left = "left",
	["left.numPan"] = "numPan",
	["right.btnFilterPanel"] = "btnFilterPanel",
	["right.pageBtn"] = "pageBtn",
	["left.icon1"] = "centerBg",
	["left.animation"] = "animation",
	right = "right",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["right.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				leftPadding = 10,
				asyncPreload = 20,
				topPadding = 15,
				columnSize = 5,
				data = bindHelper.self("showData"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1, {
						class = "icon_key",
						props = {
							noListener = true,
							data = {
								key = arg_1_3.id,
								num = arg_1_3.num,
								dbId = arg_1_3.dbid
							},
							specialKey = {
								leftTopLv = arg_1_3.level
							},
							onNode = function(arg_2_0)
								if arg_1_3.selectEffect then
									arg_1_3.selectEffect:removeSelf()
									arg_1_3.selectEffect:alignCenter(arg_2_0:size())
									arg_2_0:add(arg_1_3.selectEffect, -1)
								end

								if arg_1_3.gemNew then
									ccui.ImageView:create("other/gain_sprite/txt_new.png"):alignCenter(arg_2_0:size()):addTo(arg_2_0, 11, "isNew"):scale(0.8)
								end

								arg_2_0:onTouch(functools.partial(arg_1_0.itemClick, arg_1_0, arg_2_0, arg_1_2, arg_1_3))
							end
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	["right.pageList"] = {
		varname = "pageList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("pageBtns"),
				item = bindHelper.self("pageBtn"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_3.select and var_0_2.SELECTED or var_0_2.NORMAL

					arg_3_1:get("bg"):texture(var_3_0)

					local var_3_1 = arg_3_3.select and ui.COLORS.WHITE or ui.COLORS.RED

					arg_3_1:get("title"):setTextColor(var_3_1)
					arg_3_1:get("title"):setString(gLanguageCsv["symbolRome" .. arg_3_2])
					arg_3_1:get("bg"):setTouchEnabled(true)
					bind.touch(arg_3_0, arg_3_1:get("bg"), {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("pageBtnClick")
			}
		}
	},
	["right.btnFilterPanel.btnFilter"] = {
		varname = "btnFilter",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onFilter")
			}
		}
	},
	["right.btnFilterPanel.btnFilter.txt"] = {
		varname = "filterTxt",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	["right.acquire.btnAdd"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("btnDecompose")
			}
		}
	},
	["left.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("btnClick")
			}
		}
	},
	["left.btn.txt"] = {
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
	["left.hintBtn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleShow")
			}
		}
	},
	["left.clickPanel1"] = {
		varname = "gemSuit",
		binds = {
			event = "click",
			method = bindHelper.self("btnTypeClick")
		}
	},
	["left.clickPanel2"] = {
		varname = "gemSerialNum",
		binds = {
			event = "click",
			method = bindHelper.self("btngemSerialNumClick")
		}
	}
}

function var_0_3.onCreate(arg_4_0, arg_4_1)
	arg_4_0.activityID = arg_4_1
	arg_4_0.gemType = "blank"

	arg_4_0.pageBtn:hide()

	local var_4_0 = arg_4_0:getResourceNode():convertToNodeSpace(cc.p(100, 0))

	arg_4_0.pageBtns = idlers.newWithMap({
		{},
		{},
		{},
		{},
		{},
		{}
	})
	arg_4_0.selectedPage = idler.new()

	arg_4_0.selectedPage:addListener(function(arg_5_0, arg_5_1)
		if arg_5_1 then
			arg_4_0.pageBtns:atproxy(arg_5_1).select = false
		end

		if arg_5_0 then
			arg_4_0.pageBtns:atproxy(arg_5_0).select = true
		end
	end)

	arg_4_0.selectEffect = ccui.ImageView:create("common/box/box_selected.png"):alignCenter(arg_4_0.item:size()):retain()
	arg_4_0.gemUp = csv.yunying.yyhuodong[arg_4_1].paramMap.exchangeTimes
	arg_4_0.selectItem = idlertable.new({})
	arg_4_0.showData = idlers.new({})
	arg_4_0.filterType = 0

	arg_4_0.selectItem:addListener(function(arg_6_0, arg_6_1)
		if next(arg_6_0) then
			local var_6_0 = arg_4_0.showData:atproxy(arg_6_0.k)

			var_6_0.selectEffect = arg_4_0.selectEffect
			var_6_0.gemNew = false
		end
	end)
	arg_4_0:initHeroSprite()
	arg_4_0:updateShowData()
	arg_4_0.right:get("title"):text(gLanguageCsv.gemSlogan)
	arg_4_0.right:get("title"):x(arg_4_0.pageList:x() + 10)

	if matchLanguage({
		"kr"
	}) then
		adapt.setTextAdaptWithSize(arg_4_0.noGemTip:get("txt"), {
			size = cc.size(500, 100)
		})
	end

	local var_4_1 = csv.yunying.yyhuodong[arg_4_1].huodongID

	arg_4_0.gemConsumeRmb = {}

	for iter_4_0, iter_4_1 in orderCsvPairs(csv.yunying.gem_exchange) do
		if iter_4_1.huodongID == var_4_1 then
			arg_4_0.gemConsumeRmb[iter_4_1.quality] = iter_4_1.cost
		end
	end

	idlereasy.when(gGameModel.role:getIdler("rmb"), function(arg_7_0, arg_7_1)
		local var_7_0 = arg_4_0:consumeRmb()
		local var_7_1 = ui.COLORS.NORMAL.DEFAULT

		if arg_7_1 < var_7_0 then
			var_7_1 = ui.COLORS.RED
		end

		arg_4_0.numPan:get("num"):color(var_7_1)
		adapt.oneLinePos(arg_4_0.numPan:get("title"), {
			arg_4_0.numPan:get("num"),
			arg_4_0.numPan:get("icon")
		}, cc.p(10, 0), "left")
	end)
	Dialog.onCreate(arg_4_0, {
		blackType = 2
	})
end

function var_0_3.updateShowData(arg_8_0)
	arg_8_0.selectItem:set({})
	dataEasy.tryCallFunc(arg_8_0.list, "updatePreloadCenterIndex")

	local var_8_0 = {}
	local var_8_1 = {}

	local function var_8_2(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		local var_9_0 = dataEasy.getCfgByKey(arg_9_1)
		local var_9_1 = {
			num = 1,
			id = arg_9_1,
			suitNo = var_9_0.suitNo,
			suitID = var_9_0.suitID,
			level = arg_9_2,
			quality = var_9_0.quality,
			dbid = arg_9_0,
			gemNew = arg_9_4
		}
		local var_9_2 = arg_8_0.selectedPage:read()

		if not arg_9_3 and (not var_9_2 or var_9_2 == var_9_1.suitNo or not var_9_1.suitNo) and (arg_8_0.filterType == 0 or arg_8_0.filterType == var_9_1.suitID or not var_9_1.suitID) then
			if arg_9_2 == 1 then
				if not var_8_1[arg_9_1] then
					var_9_1.dbids = {
						arg_9_0
					}
					var_8_1[arg_9_1] = var_9_1

					var_0_0(var_8_0, var_9_1)
				else
					var_0_0(var_8_1[arg_9_1].dbids, arg_9_0)

					var_8_1[arg_9_1].num = var_8_1[arg_9_1].num + 1
				end
			else
				var_0_0(var_8_0, var_9_1)
			end
		end
	end

	local var_8_3 = gGameModel.role:read("gems")

	for iter_8_0, iter_8_1 in pairs(var_8_3) do
		local var_8_4 = gGameModel.gems:find(iter_8_1)
		local var_8_5 = var_8_4:read("gem_id")
		local var_8_6 = var_8_4:read("level")
		local var_8_7 = dataEasy.getCfgByKey(var_8_5)
		local var_8_8 = 0
		local var_8_9 = false

		if arg_8_0.obtainDbid then
			for iter_8_2, iter_8_3 in ipairs(arg_8_0.obtainDbid) do
				if iter_8_3 == iter_8_1 then
					var_8_9 = true
				end
			end
		end

		local var_8_10 = var_8_4:read("card_db_id")

		if var_8_7.quality >= 4 and var_8_7.suitID then
			if csvSize(arg_8_0.gemReplacement) == 0 then
				var_8_2(iter_8_1, var_8_5, var_8_6, var_8_10, var_8_9)
			else
				for iter_8_4, iter_8_5 in pairs(arg_8_0.gemReplacement) do
					if iter_8_5.dbid and iter_8_5.dbid ~= iter_8_1 and iter_8_5.quality == var_8_7.quality then
						if arg_8_0.gemType == "blank" then
							var_8_8 = var_8_8 + 1
						elseif arg_8_0.gemType == "suitID" and iter_8_5.suitID == var_8_7.suitID or arg_8_0.gemType == "suitNo" and iter_8_5.suitNo == var_8_7.suitNo then
							var_8_8 = var_8_8 + 1
						end
					end
				end

				if var_8_8 == csvSize(arg_8_0.gemReplacement) then
					var_8_2(iter_8_1, var_8_5, var_8_6, var_8_10, var_8_9)

					local var_8_11 = 0
				end
			end
		end
	end

	var_0_1(var_8_0, function(arg_10_0, arg_10_1)
		if arg_10_0.quality ~= arg_10_1.quality then
			return arg_10_0.quality > arg_10_1.quality
		end

		if arg_10_0.suitID ~= arg_10_1.suitID then
			if arg_10_0.suitID and arg_10_1.suitID then
				return arg_10_0.suitID < arg_10_1.suitID
			else
				return not arg_10_1.suitID
			end
		end

		if arg_10_0.suitNo ~= arg_10_1.suitNo then
			if arg_10_0.suitNo and arg_10_1.suitNo then
				return arg_10_0.suitNo < arg_10_1.suitNo
			else
				return not arg_10_1.suitNo
			end
		end

		return arg_10_0.level > arg_10_1.level
	end)
	arg_8_0.showData:update(var_8_0)

	local var_8_12 = gLanguageCsv.knapsackNoGem

	if arg_8_0.gemType == "suitID" then
		var_8_12 = gLanguageCsv.identicalSuitIdGem
	elseif arg_8_0.gemType == "suitNo" then
		var_8_12 = gLanguageCsv.identicalSuitNoGem
	end

	arg_8_0.noGemTip:get("txt"):text(var_8_12)
	arg_8_0.noGemTip:visible(#var_8_0 == 0)

	local var_8_13, var_8_14 = arg_8_0:consumeRmb()

	arg_8_0.numPan:get("num"):text(var_8_13)
	arg_8_0.left:get("num"):text(var_8_14 .. "/" .. arg_8_0.gemUp)

	arg_8_0.dissatisfy = var_8_14 ~= arg_8_0.gemUp

	adapt.oneLinePos(arg_8_0.numPan:get("num"), arg_8_0.numPan:get("icon"), cc.p(10, 0), "left")
end

function var_0_3.consumeRmb(arg_11_0)
	local var_11_0 = gGameModel.role:read("yyhuodongs")[arg_11_0.activityID]
	local var_11_1 = csv.yunying.yyhuodong[arg_11_0.activityID].paramMap.cost
	local var_11_2 = 0
	local var_11_3 = 0

	if var_11_0 and var_11_0.info.exchange_counter then
		var_11_2 = var_11_1[cc.clampf(var_11_0.info.exchange_counter + 1, 1, csvSize(var_11_1))]
		var_11_3 = var_11_0.info.exchange_counter
	else
		var_11_2 = var_11_1[1]
	end

	if csvSize(arg_11_0.gemReplacement) >= 1 then
		for iter_11_0, iter_11_1 in pairs(arg_11_0.gemReplacement) do
			var_11_2 = var_11_2 + arg_11_0.gemConsumeRmb[csv.gem.gem[iter_11_1.id].quality]

			break
		end
	end

	return var_11_2, var_11_3
end

function var_0_3.initHeroSprite(arg_12_0, arg_12_1)
	arg_12_0.gemSuit:get("icon"):hide()
	arg_12_0.gemSerialNum:get("icon"):hide()

	arg_12_0.gemReplacement = {}
	arg_12_0.gemSlots = {}

	for iter_12_0 = 1, 3 do
		local var_12_0 = arg_12_0.left:get("item" .. iter_12_0)

		var_12_0:get("bg"):hide()
		var_12_0:get("levelBg"):hide()
		var_12_0:get("lv"):hide()
		var_12_0:get("icon"):hide()

		arg_12_0.gemSlots[iter_12_0] = var_12_0

		arg_12_0.gemSlots[iter_12_0]:onTouch(function(arg_13_0)
			if arg_13_0.name == "began" then
				arg_12_0.touchBeganPos = arg_12_0.gemSlots[iter_12_0]:getTouchBeganPosition()

				if arg_12_0.movePanel then
					arg_12_0.movePanel:removeSelf()

					arg_12_0.movePanel = nil
				end
			elseif arg_13_0.name == "moved" and arg_12_0.gemReplacement[iter_12_0] then
				local var_13_0 = math.abs(arg_13_0.x - arg_12_0.touchBeganPos.x)
				local var_13_1 = math.abs(arg_13_0.y - arg_12_0.touchBeganPos.y)

				if not arg_12_0.movePanel and (var_13_0 >= ui.TOUCH_MOVED_THRESHOLD or var_13_1 >= ui.TOUCH_MOVED_THRESHOLD) then
					arg_12_0.gemSlots[iter_12_0]:get("icon"):hide()
					arg_12_0.gemSlots[iter_12_0]:get("levelBg"):hide()
					arg_12_0.gemSlots[iter_12_0]:get("lv"):hide()

					arg_12_0.movePanel = arg_12_0:createMovePanel(arg_12_0.gemReplacement[iter_12_0])
				end

				if arg_12_0.movePanel then
					local var_13_2 = arg_12_0:convertToNodeSpace(arg_13_0)

					arg_12_0.movePanel:xy(var_13_2.x, var_13_2.y)
				end
			elseif arg_13_0.name == "ended" or arg_13_0.name == "cancelled" and arg_12_0.gemReplacement[iter_12_0] then
				for iter_13_0 = 1, 3 do
					arg_12_0.gemSlots[iter_13_0]:get("bg"):visible(iter_12_0 == iter_13_0)
				end

				if arg_12_0.movePanel then
					local var_13_3 = arg_12_0.movePanel:box()
					local var_13_4 = arg_12_0:convertToWorldSpace(cc.p(var_13_3.x, var_13_3.y))
					local var_13_5 = arg_12_0.left:convertToNodeSpace(var_13_4)

					var_13_3.x, var_13_3.y = var_13_5.x, var_13_5.y

					local var_13_6 = arg_12_0:checkRectInSlots(var_13_3)

					if var_13_6 then
						if not arg_12_0.gemReplacement[var_13_6] then
							arg_12_0.gemReplacement[var_13_6] = arg_12_0.gemReplacement[iter_12_0]

							arg_12_0.gemSlots[var_13_6]:get("icon"):show()
							arg_12_0.gemSlots[var_13_6]:get("levelBg"):show()
							arg_12_0.gemSlots[var_13_6]:get("lv"):show()
							arg_12_0.gemSlots[var_13_6]:get("icon"):texture(csv.gem.gem[arg_12_0.gemReplacement[iter_12_0].id].icon)
							arg_12_0.gemSlots[var_13_6]:get("lv"):text("Lv" .. arg_12_0.gemReplacement[iter_12_0].level)
							arg_12_0.gemSlots[var_13_6]:get("levelBg"):width(arg_12_0.gemSlots[var_13_6]:get("lv"):width() + 20)
							arg_12_0.gemSlots[var_13_6]:get("add"):hide()
							arg_12_0.gemSlots[iter_12_0]:get("add"):show()
							arg_12_0.gemSlots[iter_12_0]:get("icon"):hide()
							arg_12_0.gemSlots[iter_12_0]:get("levelBg"):hide()
							arg_12_0.gemSlots[iter_12_0]:get("lv"):hide()

							arg_12_0.gemReplacement[iter_12_0] = nil
						else
							arg_12_0.gemReplacement[var_13_6], arg_12_0.gemReplacement[iter_12_0] = arg_12_0.gemReplacement[iter_12_0], arg_12_0.gemReplacement[var_13_6]

							arg_12_0.gemSlots[var_13_6]:get("icon"):texture(csv.gem.gem[arg_12_0.gemReplacement[var_13_6].id].icon)
							arg_12_0.gemSlots[iter_12_0]:get("icon"):texture(csv.gem.gem[arg_12_0.gemReplacement[iter_12_0].id].icon)
							arg_12_0.gemSlots[var_13_6]:get("lv"):text("Lv" .. arg_12_0.gemReplacement[var_13_6].level)
							arg_12_0.gemSlots[var_13_6]:get("levelBg"):width(arg_12_0.gemSlots[var_13_6]:get("lv"):width() + 20)
							arg_12_0.gemSlots[iter_12_0]:get("lv"):text("Lv" .. arg_12_0.gemReplacement[iter_12_0].level)
							arg_12_0.gemSlots[iter_12_0]:get("levelBg"):width(arg_12_0.gemSlots[iter_12_0]:get("lv"):width() + 20)
							arg_12_0.gemSlots[iter_12_0]:get("icon"):show()
							arg_12_0.gemSlots[iter_12_0]:get("levelBg"):show()
							arg_12_0.gemSlots[iter_12_0]:get("lv"):show()
						end
					else
						arg_12_0.gemSlots[iter_12_0]:get("add"):show()
						arg_12_0.gemSlots[iter_12_0]:get("icon"):hide()
						arg_12_0.gemSlots[iter_12_0]:get("levelBg"):hide()
						arg_12_0.gemSlots[iter_12_0]:get("lv"):hide()

						arg_12_0.gemReplacement[iter_12_0] = nil

						arg_12_0:updateShowData()
					end

					arg_12_0.movePanel:removeSelf()

					arg_12_0.movePanel = nil
				elseif arg_12_0.gemReplacement[iter_12_0] then
					arg_12_0:showDetails(arg_12_0.gemReplacement[iter_12_0].dbid, "left")
				end
			end
		end)
	end
end

function var_0_3.btnTypeClick(arg_14_0)
	local var_14_0 = arg_14_0.gemSuit:get("icon")
	local var_14_1 = arg_14_0.gemSerialNum:get("icon")

	if arg_14_0.gemType == "suitID" then
		var_14_0:hide()

		arg_14_0.gemType = "blank"
	elseif arg_14_0.gemType == "suitNo" then
		for iter_14_0 = 1, 3 do
			arg_14_0.gemReplacement[iter_14_0] = nil

			arg_14_0.gemSlots[iter_14_0]:get("icon"):hide()
			arg_14_0.gemSlots[iter_14_0]:get("levelBg"):hide()
			arg_14_0.gemSlots[iter_14_0]:get("lv"):hide()
			arg_14_0.gemSlots[iter_14_0]:get("add"):show()
			var_14_1:hide()
			var_14_0:hide()
		end

		var_14_0:show()
		var_14_1:hide()

		arg_14_0.gemType = "suitID"
	else
		arg_14_0:calculate("suitID", gLanguageCsv.gemType)
		var_14_0:show()
		var_14_1:hide()

		arg_14_0.gemType = "suitID"
	end

	arg_14_0:updateShowData()
end

function var_0_3.btngemSerialNumClick(arg_15_0)
	local var_15_0 = arg_15_0.gemSuit:get("icon")
	local var_15_1 = arg_15_0.gemSerialNum:get("icon")

	if arg_15_0.gemType == "suitNo" then
		var_15_1:hide()

		arg_15_0.gemType = "blank"
	elseif arg_15_0.gemType == "suitID" then
		for iter_15_0 = 1, 3 do
			arg_15_0.gemReplacement[iter_15_0] = nil

			arg_15_0.gemSlots[iter_15_0]:get("icon"):hide()
			arg_15_0.gemSlots[iter_15_0]:get("levelBg"):hide()
			arg_15_0.gemSlots[iter_15_0]:get("lv"):hide()
			arg_15_0.gemSlots[iter_15_0]:get("add"):show()
			var_15_1:hide()
			var_15_0:hide()
		end

		var_15_1:show()
		var_15_0:hide()

		arg_15_0.gemType = "suitNo"
	else
		arg_15_0:calculate("suitNo", gLanguageCsv.gemNumber)
		var_15_1:show()
		var_15_0:hide()

		arg_15_0.gemType = "suitNo"
	end

	arg_15_0:updateShowData()
end

function var_0_3.calculate(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = {}

	if csvSize(arg_16_0.gemReplacement) >= 2 then
		for iter_16_0, iter_16_1 in pairs(arg_16_0.gemReplacement) do
			if iter_16_1[arg_16_1] and not var_16_0[iter_16_1[arg_16_1]] then
				var_16_0[iter_16_1[arg_16_1]] = iter_16_1[arg_16_1]
			end
		end

		if csvSize(var_16_0) ~= 1 then
			for iter_16_2 = 1, 3 do
				arg_16_0.gemReplacement[iter_16_2] = nil

				arg_16_0.gemSlots[iter_16_2]:get("icon"):hide()
				arg_16_0.gemSlots[iter_16_2]:get("levelBg"):hide()
				arg_16_0.gemSlots[iter_16_2]:get("lv"):hide()
				arg_16_0.gemSlots[iter_16_2]:get("add"):show()
			end

			gGameUI:showTip(arg_16_2)
		end
	end
end

function var_0_3.btnClick(arg_17_0)
	if not arg_17_0.dissatisfy then
		gGameUI:showTip(gLanguageCsv.gemUpperLimit)

		return
	end

	if arg_17_0.gemType == "suitID" then
		local var_17_0 = 0
		local var_17_1 = 0
		local var_17_2 = 0
		local var_17_3 = {}
		local var_17_4 = true

		for iter_17_0, iter_17_1 in pairs(arg_17_0.gemReplacement) do
			var_17_1 = iter_17_1.suitID
			var_17_2 = iter_17_1.quality

			if itertools.include(var_17_3, iter_17_1.suitNo) then
				var_17_4 = false

				break
			else
				table.insert(var_17_3, iter_17_1.suitNo)
			end
		end

		for iter_17_2, iter_17_3 in csvMapPairs(csv.gem.suit) do
			if iter_17_3.suitID == var_17_1 and iter_17_3.suitQuality == var_17_2 then
				var_17_0 = math.max(var_17_0, iter_17_3.suitNum)
			end
		end

		if var_17_0 <= 3 and var_17_4 and csvSize(arg_17_0.gemReplacement) == 3 then
			gGameUI:showTip(gLanguageCsv.activityGemUpShowText)

			return
		end
	end

	if csvSize(arg_17_0.gemReplacement) < 2 then
		gGameUI:showTip(gLanguageCsv.gemNum)

		return
	end

	if arg_17_0:consumeRmb() > gGameModel.role:read("rmb") then
		uiEasy.showDialog("rmb")

		return
	end

	local var_17_5 = {}

	for iter_17_4, iter_17_5 in pairs(arg_17_0.gemReplacement) do
		if iter_17_5.id then
			table.insert(var_17_5, iter_17_5.dbid)
		end
	end

	local var_17_6 = csvSize(arg_17_0.gemReplacement) == 2 and gLanguageCsv.gemHint or gLanguageCsv.gemUpNum

	gGameUI:showDialog({
		fontSize = 50,
		btnType = 2,
		isRich = true,
		title = gLanguageCsv.spaceTips,
		content = var_17_6,
		cb = function()
			gGameApp:requestServerCustom("/game/yy/gem/exchange"):params(arg_17_0.activityID, var_17_5, arg_17_0.gemType):doit(function(arg_19_0)
				local var_19_0 = arg_17_0.animation:getChildByName("effect")

				if var_19_0 then
					var_19_0:xy(cc.p(600, 170))
					var_19_0:show()
					var_19_0:play("effect")
				else
					local var_19_1 = widget.addAnimationByKey(arg_17_0.animation, "effect/chongsheng.skel", "effect", "effect", 100):xy(cc.p(600, 170)):scale(1.5)
				end

				performWithDelay(arg_17_0, function()
					for iter_20_0 = 1, 3 do
						arg_17_0.gemReplacement[iter_20_0] = nil

						arg_17_0.gemSlots[iter_20_0]:get("icon"):hide()
						arg_17_0.gemSlots[iter_20_0]:get("levelBg"):hide()
						arg_17_0.gemSlots[iter_20_0]:get("lv"):hide()
						arg_17_0.gemSlots[iter_20_0]:get("add"):show()
					end

					arg_17_0.obtainDbid = arg_19_0.view.result.gemdbIDs

					arg_17_0:updateShowData()
					gGameUI:showGainDisplay(arg_19_0)
				end, 0.8333333333333334)
			end)
		end
	})
end

function var_0_3.checkRectInSlots(arg_21_0, arg_21_1)
	local var_21_0 = math.huge
	local var_21_1

	for iter_21_0, iter_21_1 in pairs(arg_21_0.gemSlots) do
		local var_21_2 = iter_21_1:box()

		if cc.rectIntersectsRect(var_21_2, arg_21_1) then
			local var_21_3 = cc.p(var_21_2.x + var_21_2.width / 2, var_21_2.y + var_21_2.height / 2)
			local var_21_4 = cc.p(arg_21_1.x + arg_21_1.width / 2, arg_21_1.y + arg_21_1.height / 2)
			local var_21_5 = cc.pGetDistance(var_21_3, var_21_4)

			if var_21_5 < var_21_0 then
				var_21_0 = var_21_5
				var_21_1 = iter_21_0
			end
		end
	end

	return var_21_1
end

function var_0_3.pageBtnClick(arg_22_0, arg_22_1, arg_22_2)
	if arg_22_0.selectedPage:read() == arg_22_2 then
		arg_22_2 = nil
	end

	arg_22_0.selectedPage:set(arg_22_2)
	arg_22_0:updateShowData()
end

function var_0_3.getPercent(arg_23_0)
	local var_23_0 = arg_23_0.list:getInnerContainer()
	local var_23_1 = var_23_0:size()
	local var_23_2 = arg_23_0.list:size()
	local var_23_3, var_23_4 = var_23_0:xy()

	return 100 - math.abs(var_23_4) / (var_23_1.height - var_23_2.height) * 100
end

function var_0_3.onItemClick(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	if arg_24_6.name == "began" then
		arg_24_0.touchBeganPos = arg_24_3:getTouchBeganPosition()

		arg_24_0.list:setTouchEnabled(false)

		arg_24_0.isClicked = true
	elseif arg_24_6.name == "moved" then
		local var_24_0 = arg_24_6
		local var_24_1 = math.abs(var_24_0.x - arg_24_0.touchBeganPos.x)
		local var_24_2 = math.abs(var_24_0.y - arg_24_0.touchBeganPos.y)

		if var_24_1 >= ui.TOUCH_MOVED_THRESHOLD or var_24_2 >= ui.TOUCH_MOVED_THRESHOLD then
			if (var_24_1 > var_24_2 * 0.7 or arg_24_0:getPercent() < 0.1 and arg_24_6.y < arg_24_0.touchBeganPos.y or arg_24_0:getPercent() > 99.9 and arg_24_6.y > arg_24_0.touchBeganPos.y) and not arg_24_0.movePanel then
				arg_24_0.movePanel = arg_24_0:createMovePanel(arg_24_5)
			end

			arg_24_0.list:setTouchEnabled(true)

			arg_24_0.isClicked = false
		end

		if arg_24_0.movePanel then
			local var_24_3 = arg_24_0:convertToNodeSpace(var_24_0)

			arg_24_0.movePanel:xy(var_24_3.x, var_24_3.y)
		end
	elseif arg_24_6.name == "ended" or arg_24_6.name == "cancelled" then
		if not arg_24_0.movePanel then
			local var_24_4 = arg_24_1:getIdx(arg_24_4)

			var_24_4.data = arg_24_5

			arg_24_0.selectItem:set(var_24_4)
			arg_24_0:showDetails(arg_24_5.dbid, "right")
		else
			local var_24_5 = arg_24_0.movePanel:box()
			local var_24_6 = arg_24_0:convertToWorldSpace(cc.p(var_24_5.x, var_24_5.y))
			local var_24_7 = arg_24_0.left:convertToNodeSpace(var_24_6)

			var_24_5.x, var_24_5.y = var_24_7.x, var_24_7.y

			local var_24_8 = arg_24_0:checkRectInSlots(var_24_5)

			if var_24_8 and arg_24_0.dissatisfy then
				arg_24_0.gemReplacement[var_24_8] = {
					id = arg_24_5.id,
					dbid = arg_24_5.dbid,
					suitID = arg_24_5.suitID,
					suitNo = arg_24_5.suitNo,
					quality = arg_24_5.quality,
					level = arg_24_5.level
				}

				arg_24_0.gemSlots[var_24_8]:get("icon"):show()
				arg_24_0.gemSlots[var_24_8]:get("icon"):texture(csv.gem.gem[arg_24_5.id].icon)
				arg_24_0.gemSlots[var_24_8]:get("levelBg"):show()
				arg_24_0.gemSlots[var_24_8]:get("lv"):show()
				arg_24_0.gemSlots[var_24_8]:get("lv"):text("Lv" .. arg_24_5.level)
				arg_24_0.gemSlots[var_24_8]:get("levelBg"):width(arg_24_0.gemSlots[var_24_8]:get("lv"):width() + 20)
				arg_24_0.gemSlots[var_24_8]:get("add"):hide()
				arg_24_0:updateShowData()
			end

			if arg_24_0.movePanel then
				arg_24_0.movePanel:removeSelf()

				arg_24_0.movePanel = nil

				if not arg_24_0.dissatisfy then
					gGameUI:showTip(gLanguageCsv.gemUpperLimit)
				end
			end
		end
	end
end

function var_0_3.createMovePanel(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0.item:clone():addTo(arg_25_0, 100)

	bind.extend(arg_25_0, var_25_0, {
		class = "icon_key",
		props = {
			noListener = true,
			simpleShow = true,
			data = {
				key = arg_25_1.id
			},
			specialKey = {
				leftTopLv = arg_25_1.level
			}
		}
	})

	return var_25_0
end

function var_0_3.onFilter(arg_26_0)
	arg_26_0.filterArrow:setRotation(180)

	local var_26_0 = arg_26_0.btnFilterPanel:size()
	local var_26_1 = arg_26_0.btnFilterPanel:convertToWorldSpace(cc.p(var_26_0.width, -100))

	gGameUI:stackUI("city.card.gem.filter", nil, nil, var_26_1, {
		"right",
		"top"
	}, arg_26_0:createHandler("setFilterType"), arg_26_0.filterType)
end

function var_0_3.setFilterType(arg_27_0, arg_27_1)
	arg_27_0.filterArrow:setRotation(0)

	if arg_27_1 then
		arg_27_0.filterType = arg_27_1

		arg_27_0.filterTxt:text(gLanguageCsv["gemSuit" .. arg_27_1] or gLanguageCsv.typeFilter)
		arg_27_0:updateShowData()
	end
end

function var_0_3.showDetails(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0.left:get("bg"):convertToWorldSpaceAR(cc.p(0, 0))

	if arg_28_2 == "left" then
		var_28_0 = arg_28_0.noGemTip:convertToWorldSpaceAR(cc.p(0, 0))
	end

	arg_28_0.details = gGameUI:stackUI("city.activity.gem_up.gem_details", nil, {
		clickClose = true,
		dispatchNodes = {
			arg_28_0.list,
			arg_28_0.left
		}
	}, {
		dbId = arg_28_1,
		pos = var_28_0,
		align = arg_28_2,
		dissatisfy = arg_28_0.dissatisfy
	}, arg_28_0:createHandler("gemDetailsClick"))
end

function var_0_3.gemDetailsClick(arg_29_0, arg_29_1, arg_29_2)
	if arg_29_2 == "right" then
		if csvSize(arg_29_0.gemReplacement) == 3 then
			gGameUI:showTip(gLanguageCsv.noPlace)

			return
		end

		local var_29_0 = gGameModel.gems:find(arg_29_1)
		local var_29_1 = var_29_0:read("gem_id")
		local var_29_2 = var_29_0:read("level")
		local var_29_3 = csv.gem.gem[var_29_1]

		for iter_29_0 = 1, 3 do
			if not arg_29_0.gemReplacement[iter_29_0] then
				arg_29_0.gemReplacement[iter_29_0] = {
					id = var_29_1,
					dbid = arg_29_1,
					suitID = var_29_3.suitID,
					suitNo = var_29_3.suitNo,
					quality = var_29_3.quality,
					level = var_29_2
				}

				arg_29_0.gemSlots[iter_29_0]:get("icon"):show()
				arg_29_0.gemSlots[iter_29_0]:get("icon"):texture(var_29_3.icon)
				arg_29_0.gemSlots[iter_29_0]:get("levelBg"):show()
				arg_29_0.gemSlots[iter_29_0]:get("lv"):show()
				arg_29_0.gemSlots[iter_29_0]:get("lv"):text("Lv" .. var_29_2)
				arg_29_0.gemSlots[iter_29_0]:get("levelBg"):width(arg_29_0.gemSlots[iter_29_0]:get("lv"):width() + 20)
				arg_29_0.gemSlots[iter_29_0]:get("add"):hide()

				break
			end
		end
	else
		local var_29_4

		for iter_29_1, iter_29_2 in pairs(arg_29_0.gemReplacement) do
			if iter_29_2.dbid and iter_29_2.dbid == arg_29_1 then
				var_29_4 = iter_29_1
			end
		end

		arg_29_0.gemReplacement[var_29_4] = nil

		arg_29_0.gemSlots[var_29_4]:get("icon"):hide()
		arg_29_0.gemSlots[var_29_4]:get("levelBg"):hide()
		arg_29_0.gemSlots[var_29_4]:get("lv"):hide()
		arg_29_0.gemSlots[var_29_4]:get("add"):show()
	end

	arg_29_0:updateShowData(true)
end

function var_0_3.onRuleShow(arg_30_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_30_0:createHandler("getRuleContext"), {
		width = 1600
	})
end

function var_0_3.getRuleContext(arg_31_0, arg_31_1)
	local var_31_0 = {
		91001,
		91011
	}
	local var_31_1 = adaptContext

	return {
		var_31_1.clone(arg_31_1.title, function(arg_32_0)
			arg_32_0:get("text"):text(gLanguageCsv.gemReplacement)
		end),
		var_31_1.noteText(unpack(var_31_0))
	}
end

function var_0_3.closeDetails(arg_33_0)
	arg_33_0.details:onClose()
end

function var_0_3.onCleanup(arg_34_0)
	arg_34_0.selectItem:destroy()
	Dialog.onCleanup(arg_34_0)
end

return var_0_3
