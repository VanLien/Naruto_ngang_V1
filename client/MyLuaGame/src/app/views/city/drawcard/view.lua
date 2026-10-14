local var_0_0 = 10
local var_0_1 = 9
local var_0_2 = {
	diamond_up = "diamond_up",
	diamond = "diamond",
	equip = "equip",
	gold = "gold",
	limit = "limit",
	self_choose = "self_choose"
}
local var_0_3 = {
	nightmare = 0,
	hero = 30,
	normal = 10
}
local var_0_4 = {
	"city/drawcard/draw/icon_jfbx_dk.png",
	"city/drawcard/draw/icon_jfbx.png",
	"city/drawcard/draw/icon_jfbx1.png",
	"city/drawcard/draw/icon_jfbx2.png",
	"city/drawcard/draw/icon_jfbx3.png",
	"city/drawcard/draw/icon_jfbx3_dk.png"
}
local var_0_5 = {
	"city/drawcard/draw/box_wdd.png",
	"city/drawcard/draw/box_ydd.png"
}
local var_0_6 = require("app.views.city.drawcard.tools")
local var_0_7 = class("DrawCardView", cc.load("mvc").ViewBase)

var_0_7.RESOURCE_FILENAME = "drawcard.json"
var_0_7.RESOURCE_BINDING = {
	["drawTenPanel.costInfo.textNote"] = "costTextNote2",
	downPanel = "downPanel",
	cardItem = "cardItem",
	item = "item",
	["downPanel.item2.number"] = "number2",
	["downPanel.item3.number"] = "number3",
	btnItem = "btnItem",
	["downPanel.item4.number"] = "number4",
	["downPanel.item1.number"] = "numberAll",
	["selfChooseCurrentUp.icon"] = "chooseUpIcon",
	["freePanel.textNote"] = "freeTxt",
	["drawOnePanel.privilegePanel"] = "privilegePanel",
	["drawOnePanel.costInfo.textNote"] = "costTextNote1",
	effectView = {
		varname = "effectView",
		binds = {
			event = "visible",
			idler = bindHelper.self("isShowEffect")
		}
	},
	topView = {
		binds = {
			event = "visible",
			idler = bindHelper.self("canClick"),
			method = function(arg_1_0)
				return not arg_1_0
			end
		}
	},
	imgBG = {
		varname = "imgBG",
		binds = {
			event = "texture",
			idler = bindHelper.self("curType"),
			method = function(arg_2_0)
				local var_2_0 = "city/drawcard/img_ck@.jpg"

				if arg_2_0 == var_0_2.gold then
					var_2_0 = "city/drawcard/img_ck_jb@.jpg"
				elseif arg_2_0 == var_0_2.equip then
					var_2_0 = "city/drawcard/img_xsck.jpg"
				elseif arg_2_0 == var_0_2.diamond_up then
					var_2_0 = "city/drawcard/img_bg_zxck.jpg"
				elseif arg_2_0 == var_0_2.self_choose then
					var_2_0 = "city/drawcard/img_bg_zxck.jpg"
				elseif arg_2_0 == var_0_2.limit then
					var_2_0 = "city/drawcard/ck_bg_rzzh.jpg"
				end

				return var_2_0
			end
		}
	},
	list = {
		varname = "listview",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("btnItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					arg_3_1:name(arg_3_3.key)

					local var_3_0 = "city/drawcard/draw/"
					local var_3_1 = arg_3_3.isSel and var_3_0 .. arg_3_3.titlePath[2] or var_3_0 .. arg_3_3.titlePath[1]

					arg_3_1:get("imgTitle"):texture(var_3_1)
					bind.touch(arg_3_0, arg_3_1, {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_2, arg_3_3)
						}
					})
					arg_3_1:setTouchEnabled(not arg_3_3.isSel)

					if arg_3_3.redHint then
						arg_3_0.state = arg_3_3.isSel ~= true

						function arg_3_3.redHint.props.onNode(arg_4_0)
							arg_4_0:xy(290, 210)

							if arg_3_3.redHintPos then
								arg_4_0:xy(arg_3_3.redHintPos)
							end
						end

						bind.extend(arg_3_0, arg_3_1, arg_3_3.redHint)
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBtnClick")
			}
		}
	},
	typePanel = {
		binds = {
			event = "visible",
			idler = bindHelper.self("curType"),
			method = function(arg_5_0)
				local var_5_0 = false

				if arg_5_0 == var_0_2.diamond or arg_5_0 == var_0_2.diamond_up or arg_5_0 == var_0_2.self_choose then
					var_5_0 = true
				end

				return var_5_0
			end
		}
	},
	perview = {
		varname = "perview",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPerviewClick")
			}
		}
	},
	drawOnePanel = {
		varname = "drawOnePanel",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onDrawOneClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "drawcardOnece",
					state = true,
					listenData = {
						curType = bindHelper.self("curType")
					},
					onNode = function(arg_6_0)
						arg_6_0:xy(450, 250):z(10)
					end
				}
			}
		}
	},
	["drawOnePanel.textFree"] = {
		varname = "txtFree",
		binds = {
			event = "visible",
			idler = bindHelper.self("isFree")
		}
	},
	["drawOnePanel.textNote"] = {
		varname = "drawLeftText",
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("curType"),
				method = function(arg_7_0)
					return arg_7_0 == var_0_2.equip
				end
			},
			{
				event = "text",
				idler = bindHelper.self("leftDrawTimes")
			}
		}
	},
	["drawOnePanel.costInfo"] = {
		varname = "costInfo",
		binds = {
			event = "visible",
			idler = bindHelper.self("isCost"),
			method = function(arg_8_0)
				return arg_8_0
			end
		}
	},
	["drawOnePanel.costInfo.textCost"] = {
		varname = "costOne",
		binds = {
			event = "text",
			idler = bindHelper.self("drawOnceCost")
		}
	},
	["drawOnePanel.costInfo.imgIcon"] = {
		varname = "imgOne",
		binds = {
			event = "texture",
			idler = bindHelper.self("oneIconPath")
		}
	},
	["drawOnePanel.btnDrawOne.textNote"] = {
		varname = "oneDrawText",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	drawTenPanel = {
		varname = "drawTenPanel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDrawTenClick")
			}
		}
	},
	["drawTenPanel.costInfo.imgIcon"] = {
		varname = "imgTen",
		binds = {
			event = "texture",
			idler = bindHelper.self("tenIconPath")
		}
	},
	["drawTenPanel.btnDrawTen.textNote"] = {
		varname = "tenDrawText",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			},
			{
				event = "text",
				idler = bindHelper.self("btnText")
			}
		}
	},
	["drawTenPanel.costInfo.textCost"] = {
		varname = "costTen",
		binds = {
			event = "text",
			idler = bindHelper.self("drawTenCost")
		}
	},
	cutDownPanel = {
		binds = {
			event = "visible",
			idler = bindHelper.self("isCutDown")
		}
	},
	diamondUpCutDownPanel = {
		varname = "diamondUpCutDownPanel",
		binds = {
			event = "visible",
			idler = bindHelper.self("curType"),
			method = function(arg_9_0)
				return arg_9_0 == var_0_2.diamond_up
			end
		}
	},
	diamondUpCardPanel = {
		varname = "diamondUpCardPanel",
		binds = {
			event = "visible",
			idler = bindHelper.self("curType"),
			method = function(arg_10_0)
				return arg_10_0 == var_0_2.diamond_up or arg_10_0 == var_0_2.self_choose
			end
		}
	},
	imgDiamondUpTips = {
		varname = "imgDiamondUpTips",
		binds = {
			event = "visible",
			idler = bindHelper.self("curType"),
			method = function(arg_11_0)
				return arg_11_0 == var_0_2.diamond_up
			end
		}
	},
	["diamondUpCutDownPanel.textTime"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("time"),
			method = function(arg_12_0)
				if arg_12_0 == 0 then
					return ""
				end

				return time.getCutDown(arg_12_0).min_sec_clock
			end
		}
	},
	["cutDownPanel.textTime"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("time"),
			method = function(arg_13_0)
				if arg_13_0 == 0 then
					return ""
				end

				return time.getCutDown(arg_13_0).min_sec_clock
			end
		}
	},
	freePanel = {
		binds = {
			event = "visible",
			idler = bindHelper.self("isFree")
		}
	},
	["freePanel.textTime"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("freeTimes")
		}
	},
	equipTip = {
		binds = {
			event = "visible",
			idler = bindHelper.self("curType"),
			method = function(arg_14_0)
				return arg_14_0 == var_0_2.equip
			end
		}
	},
	shop = {
		varname = "shop",
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("curType"),
				method = function(arg_15_0)
					return arg_15_0 == var_0_2.equip
				end
			},
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onShopClick")
				}
			}
		}
	},
	goldLeftTimes = {
		binds = {
			event = "visible",
			idler = bindHelper.self("curType"),
			method = function(arg_16_0)
				return arg_16_0 == var_0_2.gold
			end
		}
	},
	["goldLeftTimes.textNote"] = {
		varname = "goldTextNote"
	},
	["goldLeftTimes.textLeftNum"] = {
		varname = "goldLeftTimes"
	},
	["goldLeftTimes.textAllNum"] = {
		varname = "goldAllTimes"
	},
	limitPanel = {
		varname = "limitPanel",
		binds = {
			event = "visible",
			idler = bindHelper.self("curType"),
			method = function(arg_17_0)
				return arg_17_0 == var_0_2.limit
			end
		}
	},
	["limitPanel.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["limitPanel.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	equipPanel = {
		binds = {
			event = "visible",
			idler = bindHelper.self("curType"),
			method = function(arg_18_0)
				return arg_18_0 == var_0_2.equip
			end
		}
	},
	["downPanel.item1.bar"] = {
		varname = "bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				data = bindHelper.self("livenessPoint1")
			}
		}
	},
	["downPanel.item2.bar"] = {
		varname = "bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				data = bindHelper.self("livenessPoint2")
			}
		}
	},
	["downPanel.item3.bar"] = {
		varname = "bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				data = bindHelper.self("livenessPoint3")
			}
		}
	},
	["downPanel.item2"] = {
		binds = {
			event = "click",
			method = bindHelper.defer(function(arg_19_0)
				return arg_19_0:onAwardClick(1)
			end)
		}
	},
	["downPanel.item3"] = {
		binds = {
			event = "click",
			method = bindHelper.defer(function(arg_20_0)
				return arg_20_0:onAwardClick(2)
			end)
		}
	},
	["downPanel.item4"] = {
		binds = {
			event = "click",
			method = bindHelper.defer(function(arg_21_0)
				return arg_21_0:onAwardClick(3)
			end)
		}
	},
	marqueePanel = {
		varname = "marqueePanel",
		binds = {
			event = "extend",
			class = "marquee"
		}
	},
	switchBtn = {
		varname = "switchBtn",
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("curType"),
				method = function(arg_22_0)
					return arg_22_0 == var_0_2.self_choose
				end
			},
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onSwitchClick")
				}
			}
		}
	},
	selfChooseTip = {
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("curType"),
				method = function(arg_23_0)
					return arg_23_0 == var_0_2.self_choose
				end
			}
		}
	},
	selfChooseCurrentUp = {
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("curType"),
				method = function(arg_24_0)
					return arg_24_0 == var_0_2.self_choose
				end
			}
		}
	},
	["selfChooseCurrentUp.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("selfChooseCurrentUpData"),
				item = bindHelper.self("chooseUpIcon"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
					arg_25_1:texture(ui.ATTR_ICON[arg_25_3])
				end
			}
		}
	},
	["limitPanel.btn_sxlb"] = {
		varname = "btnSxlb",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onSxlbClick")
				}
			}
		}
	},
	["limitPanel.btn_xdlb"] = {
		varname = "btnXdlb",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onXdlbClick")
				}
			}
		}
	}
}

function var_0_7.onCreate(arg_26_0, arg_26_1)
	arg_26_0.isShowEffect = idler.new(false)
	arg_26_0.diamondUpId = idler.new(false)
	arg_26_0.limitId = idler.new(false)
	arg_26_0.btnSxlb:hide()
	arg_26_0:initModel()

	local var_26_0 = {
		key = "diamond",
		weight = 3,
		isSel = false,
		txt = gLanguageCsv.diamondDraw,
		type = var_0_2.diamond,
		titlePath = {
			"txt_zsck.png",
			"txt_zsck1.png"
		},
		redHint = {
			class = "red_hint",
			props = {
				specialTag = "drawcardDiamondFree",
				state = bindHelper.self("state"),
				onNode = function(arg_27_0)
					arg_27_0:xy(380, 160):z(10)
				end
			}
		}
	}
	local var_26_1 = {
		key = "gold",
		weight = 2,
		isSel = false,
		txt = gLanguageCsv.goldDraw,
		type = var_0_2.gold,
		titlePath = {
			"txt_jbck.png",
			"txt_jbck1.png"
		},
		redHint = {
			class = "red_hint",
			props = {
				specialTag = "drawcardGoldFree",
				state = bindHelper.self("state"),
				onNode = function(arg_28_0)
					arg_28_0:xy(380, 160):z(10)
				end
			}
		}
	}
	local var_26_2 = {
		key = "equip",
		weight = 1,
		isSel = false,
		txt = gLanguageCsv.drawEquip,
		type = var_0_2.equip,
		titlePath = {
			"txt_spck.png",
			"txt_spck1.png"
		},
		redHint = {
			class = "red_hint",
			props = {
				specialTag = "drawcardEquipFree",
				state = bindHelper.self("state"),
				onNode = function(arg_29_0)
					arg_29_0:xy(380, 160):z(10)
				end
			}
		}
	}
	local var_26_3 = {
		key = "limit",
		weight = 6,
		isSel = false,
		txt = gLanguageCsv.drawLimit,
		type = var_0_2.limit,
		titlePath = {
			"txt_xsss.png",
			"txt_xsss1.png"
		}
	}
	local var_26_4 = {
		key = "diamondup",
		weight = 4,
		isSel = false,
		txt = gLanguageCsv.diamondUpDrawCard,
		type = var_0_2.diamond_up,
		titlePath = {
			"txt_xdck.png",
			"txt_xdck1.png"
		}
	}
	local var_26_5 = {
		key = "self_choose",
		weight = 5,
		isSel = false,
		txt = gLanguageCsv.diamondUpDrawCard,
		type = var_0_2.self_choose,
		titlePath = {
			"txt_zxck.png",
			"txt_zxck1.png"
		}
	}

	local function var_26_6(arg_30_0)
		table.sort(arg_30_0, function(arg_31_0, arg_31_1)
			return arg_31_0.weight > arg_31_1.weight
		end)

		for iter_30_0, iter_30_1 in ipairs(arg_30_0) do
			if iter_30_1.key == "diamond" then
				arg_26_0.rmblocation = iter_30_0
			elseif iter_30_1.key == "limit" then
				arg_26_0.limitIdHJ = iter_30_0
			elseif iter_30_1.key == "diamondup" then
				arg_26_0.limitlocation = iter_30_0
			elseif iter_30_1.key == "self_choose" then
				arg_26_0.selfChooseLocation = iter_30_0
			end
		end
	end

	local var_26_7 = {
		var_26_0,
		var_26_1
	}

	var_26_6(var_26_7)

	if arg_26_0.diamondUpId:read() then
		table.insert(var_26_7, var_26_4)
		var_26_6(var_26_7)
	end

	if arg_26_0.limitId:read() then
		table.insert(var_26_7, var_26_3)
		var_26_6(var_26_7)
	end

	dataEasy.getListenUnlock(gUnlockCsv.groupDrawCardUp, function(arg_32_0)
		if not arg_32_0 then
			return
		end

		table.insert(var_26_7, var_26_5)
		var_26_6(var_26_7)

		if arg_26_0.tabDatas then
			arg_26_0.tabDatas:update(var_26_7)
		end
	end)
	dataEasy.getListenUnlock(gUnlockCsv.drawEquip, function(arg_33_0)
		if not arg_33_0 then
			return
		end

		table.insert(var_26_7, var_26_2)

		if arg_26_0.tabDatas then
			arg_26_0.tabDatas:update(var_26_7)
		end
	end)

	local var_26_8

	if arg_26_1 then
		for iter_26_0, iter_26_1 in ipairs(var_26_7) do
			if iter_26_1.key == arg_26_1 then
				var_26_8 = iter_26_0

				break
			end
		end
	end

	var_26_8 = var_26_8 or 1
	var_26_7[var_26_8].isSel = true
	arg_26_0.tabDatas = idlers.newWithMap(var_26_7)
	arg_26_0.perIdx = var_26_8
	arg_26_0.curType = idler.new(var_26_7[var_26_8].type)
	arg_26_0.canClick = idler.new(true)
	arg_26_0.isHalf = false
	arg_26_0.isLimitDraw = idler.new(false)
	arg_26_0.isCost = idler.new(false)
	arg_26_0.isFree = idler.new(false)
	arg_26_0.isCutDown = idler.new(false)
	arg_26_0.freeTimes = idler.new("")
	arg_26_0.tenIconPath = idler.new("")
	arg_26_0.oneIconPath = idler.new("")
	arg_26_0.btnText = idler.new("")
	arg_26_0.drawOnceCost = idler.new(0)
	arg_26_0.drawTenCost = idler.new(0)
	arg_26_0.leftDrawTimes = idler.new("")
	arg_26_0.time = idler.new(0)
	arg_26_0.selfChooseCurrentUpData = idlers.new()

	local function var_26_9(arg_34_0)
		local var_34_0 = {}

		for iter_34_0, iter_34_1 in orderCsvPairs(clone(var_26_7)) do
			if iter_34_0 ~= arg_34_0 then
				iter_34_1.isSel = false

				table.insert(var_34_0, iter_34_1)
			end
		end

		var_26_7 = clone(var_34_0)
		arg_26_0.rmblocation = arg_26_0.rmblocation - 1
		var_34_0[1].isSel = true
		arg_26_0.perIdx = 1

		arg_26_0.tabDatas:update(var_34_0)
		arg_26_0.downPanel:visible(false)
		arg_26_0.curType:set(var_34_0[arg_26_0.perIdx].type)
		arg_26_0:initAward()
	end

	idlereasy.any({
		arg_26_0.limitId,
		arg_26_0.diamondUpId
	}, function(arg_35_0, arg_35_1, arg_35_2)
		arg_26_0.diamondDataId = arg_35_2
		arg_26_0.limitDataId = arg_35_1

		if arg_26_0.limitIdHJ and not arg_35_1 then
			var_26_9(arg_26_0.limitIdHJ)

			arg_26_0.limitIdHJ = nil
			arg_26_0.limitInitiative = true
		end

		if not arg_35_2 then
			if arg_26_0.limitIdHJ and arg_26_0.limitlocation == 2 then
				var_26_9(arg_26_0.limitlocation)

				arg_26_0.limitlocation = nil
			elseif not arg_26_0.limitIdHJ and arg_26_0.limitlocation == 1 then
				var_26_9(arg_26_0.limitlocation)

				arg_26_0.limitlocation = nil
			elseif arg_26_0.limitInitiative and arg_26_0.limitlocation == 2 then
				var_26_9(1)

				arg_26_0.limitlocation = nil
			end
		end
	end)
	idlereasy.any({
		arg_26_0.curType,
		arg_26_0.goldCount,
		arg_26_0.diamondCount,
		arg_26_0.allCount,
		arg_26_0.halfDiamondCount,
		arg_26_0.trainerGoldCount,
		arg_26_0.equipCount,
		arg_26_0.drawEquipCount,
		arg_26_0.items,
		arg_26_0.lastDrawTime,
		arg_26_0.selfChooseNum
	}, arg_26_0:createHandler("initPageItem"))
	idlereasy.when(arg_26_0.selfChooseNum, function(arg_36_0, arg_36_1)
		local var_36_0 = {}
		local var_36_1 = {}

		local function var_36_2(arg_37_0)
			return arg_37_0 == 0 and 1 or arg_37_0
		end

		for iter_36_0, iter_36_1 in csvMapPairs(csv.draw_card_up_group) do
			if iter_36_0 == var_36_2(arg_36_1) then
				var_36_0 = iter_36_1.attrs

				break
			end
		end

		arg_26_0.selfChooseCurrentUpData:update(var_36_0)
	end)
	idlereasy.any({
		arg_26_0.rmb,
		arg_26_0.gold
	}, arg_26_0:createHandler("refreshCostText"))
	idlereasy.when(gGameModel.role:getIdler("items"), function(arg_38_0, arg_38_1)
		arg_26_0:createHandler("refreshCostText")
	end)
	idlereasy.when(arg_26_0.isCutDown, function(arg_39_0, arg_39_1)
		local var_39_0 = gCommonConfigCsv.drawGoldFreeRefreshDuration - (time.getTime() - arg_26_0.lastDrawTime:read())

		if arg_39_1 and var_39_0 > 0 then
			arg_26_0.time:set(var_39_0)
		end
	end)
	idlereasy.when(arg_26_0.equipAllCount, function(arg_40_0, arg_40_1)
		local var_40_0 = arg_40_1 % var_0_0

		var_40_0 = var_40_0 == 0 and var_0_0 or var_0_0 - var_40_0

		local var_40_1 = string.format(gLanguageCsv.drawLeftTime, var_40_0)

		if var_40_0 == 1 then
			var_40_1 = gLanguageCsv.curDrawHaveSprite
		end

		arg_26_0.leftDrawTimes:set(var_40_1)
	end)
	idlereasy.any({
		arg_26_0.vip,
		arg_26_0.dcGoldCount
	}, function(arg_41_0, arg_41_1, arg_41_2)
		local var_41_0 = gVipCsv[arg_41_1].goldDrawCardCountLimit

		arg_26_0.goldAllTimes:text("/" .. var_41_0)

		local var_41_1 = var_41_0 - (arg_41_2 or 0)

		arg_26_0.goldLeftTimes:text(var_41_1)

		local var_41_2 = ui.NEWCOLORS.GREEN2

		if var_41_1 <= 0 then
			var_41_2 = ui.COLORS.NORMAL.ALERT_ORANGE
		end

		text.addEffect(arg_26_0.goldLeftTimes, {
			color = var_41_2
		})
		adapt.oneLineCenterPos(cc.p(270, 40), {
			arg_26_0.goldTextNote,
			arg_26_0.goldLeftTimes,
			arg_26_0.goldAllTimes
		}, cc.p(6, 0))
	end)
	arg_26_0:enableSchedule():schedule(function(arg_42_0)
		if not arg_26_0.isCutDown:read() then
			return
		end

		arg_26_0.time:modify(function(arg_43_0)
			local var_43_0 = arg_43_0 - 1

			if var_43_0 <= 0 then
				arg_26_0.isCutDown:set(false)

				local var_43_1 = arg_26_0.goldCount:read() < gCommonConfigCsv.drawGoldFreeLimit

				arg_26_0.isFree:set(var_43_1)
				arg_26_0.isCost:set(not var_43_1)
				bind.extend(arg_26_0, arg_26_0.drawOnePanel, {
					class = "red_hint",
					props = {
						state = var_43_1,
						onNode = function(arg_44_0)
							arg_44_0:xy(410, 250):z(10)
						end
					}
				})
			end

			return true, var_43_0
		end)
	end, 1, 0)

	arg_26_0.siteStateTab, arg_26_0.diamondAwardTab, arg_26_0.limitAwardTab = {}, {}, {}
	arg_26_0.awardIdTabel = {}

	for iter_26_2, iter_26_3 in orderCsvPairs(csv.draw_count) do
		if iter_26_3.drawType == 2 then
			arg_26_0.diamondAwardTab[iter_26_2] = iter_26_3
		elseif iter_26_3.drawType == 1 then
			arg_26_0.limitAwardTab[iter_26_2] = iter_26_3
		end
	end

	for iter_26_4 = 1, 3 do
		arg_26_0["livenessPoint" .. iter_26_4] = idler.new(0)
		arg_26_0.siteStateTab[iter_26_4] = 2
	end

	arg_26_0:initAward()
end

function var_0_7.initModel(arg_45_0)
	arg_45_0.vip = gGameModel.role:getIdler("vip_level")
	arg_45_0.cardDatas = gGameModel.role:getIdler("cards")
	arg_45_0.cardCapacity = gGameModel.role:getIdler("card_capacity")

	local var_45_0 = gGameModel.daily_record

	arg_45_0.diamondCount = var_45_0:getIdler("dc1_free_count")
	arg_45_0.goldCount = var_45_0:getIdler("gold1_free_count")
	arg_45_0.dcGoldCount = var_45_0:getIdler("dc_gold_count")
	arg_45_0.allCount = var_45_0:getIdler("draw_card")
	arg_45_0.lastDrawTime = var_45_0:getIdler("gold1_free_last_time")
	arg_45_0.halfDiamondCount = var_45_0:getIdler("draw_card_rmb1_half")
	arg_45_0.trainerGoldCount = var_45_0:getIdler("draw_card_gold1_trainer")
	arg_45_0.equipCount = var_45_0:getIdler("eq_dc1_free_counter")
	arg_45_0.drawEquipCount = var_45_0:getIdler("draw_equip")

	local var_45_1 = gGameModel.lottery_record

	arg_45_0.selfChooseNum = var_45_1:getIdler("draw_card_up_choose")
	arg_45_0.selfChooseTimes = var_45_1:getIdler("draw_card_up_change_times")
	arg_45_0.selfChooseUp1Counters = var_45_1:getIdler("draw_card_up1_counters")
	arg_45_0.selfChooseUp10Counters = var_45_1:getIdler("draw_card_up10_counters")
	arg_45_0.diamondAllCount = var_45_1:getIdler("dc1_counter")
	arg_45_0.diamondAllCountTen = var_45_1:getIdler("dc10_counter")
	arg_45_0.equipAllCount = var_45_1:getIdler("eq_dc1_counter")
	arg_45_0.yyhuodongCounters = var_45_1:getIdler("yyhuodong_counters")
	arg_45_0.rmb = gGameModel.role:getIdler("rmb")
	arg_45_0.gold = gGameModel.role:getIdler("gold")
	arg_45_0.items = gGameModel.role:getIdler("items")
	arg_45_0.getDiamondAwardState = gGameModel.role:getIdler("draw_sum_box")

	local var_45_2 = gGameModel.role:read("yy_open")

	for iter_45_0, iter_45_1 in ipairs(var_45_2) do
		if csv.yunying.yyhuodong[iter_45_1].type == game.YYHUODONG_TYPE_ENUM_TABLE.timeLimitDraw then
			arg_45_0.limitId:set(iter_45_1)
		elseif csv.yunying.yyhuodong[iter_45_1].type == game.YYHUODONG_TYPE_ENUM_TABLE.timeLimitUpDraw then
			arg_45_0.diamondUpId:set(iter_45_1)
		end
	end
end

function var_0_7.initPageItem(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7, arg_46_8, arg_46_9)
	arg_46_0:resetChildFuncs(arg_46_2)

	arg_46_0.isHalf = false

	arg_46_0.privilegePanel:hide()
	arg_46_0.btnText:set(string.format(gLanguageCsv.drawTimes, 10))
	arg_46_0:initPageItemFunc(arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7, arg_46_8, arg_46_9)
	arg_46_0:refreshCostText()
end

function var_0_7.isEnoughToDraw(arg_47_0, arg_47_1)
	return arg_47_0:isEnoughToDrawFunc(arg_47_1)
end

function var_0_7.refreshCostText(arg_48_0)
	local var_48_0 = ui.COLORS.NORMAL.RED
	local var_48_1 = ui.COLORS.NORMAL.RED

	if arg_48_0:isEnoughToDraw(true) then
		var_48_0 = ui.COLORS.NORMAL.WHITE
		var_48_1 = ui.COLORS.NORMAL.WHITE
	elseif arg_48_0:isEnoughToDraw(false) then
		var_48_0 = ui.COLORS.NORMAL.WHITE
	end

	text.addEffect(arg_48_0.costOne, {
		color = var_48_0
	})
	text.addEffect(arg_48_0.costTen, {
		color = var_48_1
	})
end

function var_0_7.initCardData(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
	local var_49_0 = arg_49_1["res" .. arg_49_3]
	local var_49_1 = csv.cards[arg_49_1["card" .. arg_49_3]]
	local var_49_2 = csv.unit[var_49_1.unitID]
	local var_49_3

	var_49_3 = var_49_0 or var_49_2.cardShow

	local var_49_4 = widget.addAnimationByKey(arg_49_2:get("imgIcon"), string.gsub(var_49_2.unitRes, ".skel", "_ui.skel"), "spine", "standby_loop"):xy(0, -210):scale(0.7)

	arg_49_2:get("imgIcon"):texture("common/btn/kong.png")
	arg_49_2:get("imgIcon"):alignCenter(arg_49_2:size())

	local var_49_5, var_49_6 = arg_49_2:get("imgIcon"):xy()
	local var_49_7 = arg_49_1["resPos" .. arg_49_3]

	arg_49_2:get("imgIcon"):xy(var_49_5 + var_49_7.x, var_49_6 + var_49_7.y)
	arg_49_2:get("imgIcon"):scale(arg_49_1["resScale" .. arg_49_3])
	arg_49_2:get("info.img2"):texture(arg_49_1["posRes" .. arg_49_3])
	arg_49_2:get("name.imgName"):texture(arg_49_1["titleRes" .. arg_49_3])

	local var_49_8 = ui.RARITY_ICON[var_49_2.rarity]

	arg_49_2:get("name.imgIcon"):texture(var_49_8)
	table.insert(arg_49_4, arg_49_1["card" .. arg_49_3])
	bind.touch(arg_49_0, arg_49_2:get("info.btnJump"), {
		methods = {
			ended = function()
				arg_49_0:onjumpToHandBook(arg_49_1["card" .. arg_49_3])
			end
		}
	})

	if not arg_49_0.cardsInfo then
		arg_49_0.cardsInfo = {}
	end

	table.insert(arg_49_0.cardsInfo, var_49_2.unitRes)
end

function var_0_7.onBtnClick(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	arg_51_0.tabDatas:atproxy(arg_51_0.perIdx).isSel = false
	arg_51_0.tabDatas:atproxy(arg_51_2).isSel = true
	arg_51_0.perIdx = arg_51_2
	arg_51_0.cardsInfo = {}

	arg_51_0.curType:set(arg_51_3.type)
	arg_51_0:initAward()
end

function var_0_7.onDrawOneClick(arg_52_0)
	local var_52_0 = arg_52_0:isEnoughToDraw(false)
	local var_52_1 = arg_52_0.curType:read()

	if not var_52_0 and not arg_52_0.isFree:read() then
		if var_52_1 == var_0_2.gold then
			uiEasy.showDialog("gold")
		elseif var_52_1 == var_0_2.limit then
			local var_52_2 = dataEasy.getCfgByKey(game.ITEM_TICKET.limitCard)

			gGameUI:showDialog({
				content = string.format(gLanguageCsv.limitCardNotEnough, var_52_2.name),
				cb = function()
					arg_52_0:onXdlbClick()
				end,
				closeCb = function()
					return
				end
			})
		else
			uiEasy.showDialog("rmb")
		end

		return
	end

	if (var_52_1 == var_0_2.diamond or var_52_1 == var_0_2.limit or var_52_1 == var_0_2.diamond_up or var_52_1 == var_0_2.self_choose) and itertools.size(arg_52_0.cardDatas:read()) >= arg_52_0.cardCapacity:read() then
		gGameUI:showDialog({
			btnType = 2,
			clearFast = true,
			content = gLanguageCsv.cardBagHaveBeenFullDraw,
			cb = function()
				gGameUI:stackUI("city.card.bag", nil, {
					full = true
				})
			end
		})

		return
	end

	if not arg_52_0.isFree:read() and var_52_1 == "gold" and gVipCsv[arg_52_0.vip:read()].goldDrawCardCountLimit - (arg_52_0.dcGoldCount:read() or 0) < 1 then
		gGameUI:showTip(string.format(gLanguageCsv.leftTimesNotEnough, 1))

		return
	end

	arg_52_0:drawOneClickFunc()
end

function var_0_7.onDrawTenClick(arg_56_0)
	local var_56_0 = arg_56_0:isEnoughToDraw(true)
	local var_56_1 = arg_56_0.curType:read()

	if not var_56_0 then
		if var_56_1 == "gold" then
			uiEasy.showDialog("gold")
		elseif var_56_1 == var_0_2.limit then
			local var_56_2 = dataEasy.getCfgByKey(game.ITEM_TICKET.limitCard)

			gGameUI:showDialog({
				content = string.format(gLanguageCsv.limitCardNotEnough, var_56_2.name),
				cb = function()
					arg_56_0:onXdlbClick()
				end,
				closeCb = function()
					return
				end
			})
		else
			uiEasy.showDialog("rmb")
		end

		return
	end

	if var_56_1 == var_0_2.gold and gVipCsv[arg_56_0.vip:read()].goldDrawCardCountLimit - (arg_56_0.dcGoldCount:read() or 0) < 10 then
		gGameUI:showTip(string.format(gLanguageCsv.leftTimesNotEnough, 10))

		return
	end

	if (var_56_1 == var_0_2.diamond or var_56_1 == var_0_2.limit or var_56_1 == var_0_2.diamond_up or var_56_1 == var_0_2.self_choose) and arg_56_0.cardCapacity:read() - itertools.size(arg_56_0.cardDatas:read()) <= var_0_1 then
		gGameUI:showDialog({
			btnType = 2,
			clearFast = true,
			content = gLanguageCsv.cardBagHaveBeenFullDraw,
			cb = function()
				gGameUI:stackUI("city.card.bag", nil, {
					full = true
				})
			end
		})

		return
	end

	arg_56_0:drawTenClickFunc()
end

function var_0_7.onShopClick(arg_60_0)
	jumpEasy.jumpTo("shop", 8)
end

function var_0_7.addEffectInRect(arg_61_0, arg_61_1, arg_61_2)
	local var_61_0 = arg_61_0.imgBG

	var_61_0:removeChildByName("effectBg")

	local var_61_1 = widget.addAnimationByKey(var_61_0, arg_61_1, arg_61_2, "effect_loop", 999):alignCenter(var_61_0:size())

	var_61_1:xy(var_61_0:size().width / 2, 0)

	return var_61_1
end

function var_0_7.onPerviewClick(arg_62_0)
	gGameUI:stackUI("city.drawcard.preview", nil, {
		clickClose = true,
		blackLayer = true
	}, arg_62_0.curType:read())
end

function var_0_7.onjumpToHandBook(arg_63_0, arg_63_1)
	gGameUI:stackUI("city.handbook.view", nil, {
		full = true
	}, {
		cardId = arg_63_1
	})
end

function var_0_7.onSwitchClick(arg_64_0)
	gGameUI:stackUI("city.drawcard.select_property", nil, {
		clickClose = true,
		blackLayer = true
	}, arg_64_0.selfChooseNum:read() or 1)
end

local var_0_8 = {
	[var_0_2.diamond] = require("app.views.city.drawcard.diamond"),
	[var_0_2.gold] = require("app.views.city.drawcard.gold"),
	[var_0_2.equip] = require("app.views.city.drawcard.equip"),
	[var_0_2.limit] = require("app.views.city.drawcard.limit"),
	[var_0_2.diamond_up] = require("app.views.city.drawcard.diamond_up"),
	[var_0_2.self_choose] = require("app.views.city.drawcard.self_choose")
}

function var_0_7.resetTopUIView(arg_65_0, arg_65_1)
	if arg_65_0.topView then
		gGameUI.topuiManager:removeView(arg_65_0.topView)

		arg_65_0.topView = nil
	end

	local var_65_0 = {
		[var_0_2.diamond] = "rmb_card",
		[var_0_2.gold] = "default",
		[var_0_2.equip] = "equip_card",
		[var_0_2.limit] = "limit_card",
		[var_0_2.diamond_up] = "diamond_up_card",
		[var_0_2.self_choose] = "diamond_up_card"
	}

	arg_65_0.topView = gGameUI.topuiManager:createView(arg_65_1 and var_65_0[arg_65_1] or "default", arg_65_0, {
		onClose = arg_65_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_chouka.png"
	})

	function arg_65_0.topView.onLimitCardClick()
		arg_65_0:onXdlbClick()
	end
end

function var_0_7.resetChildFuncs(arg_67_0, arg_67_1)
	if arg_67_0.lastCurType == arg_67_1 then
		return
	end

	arg_67_0.lastCurType = arg_67_1

	local var_67_0 = var_0_8[arg_67_1]

	for iter_67_0, iter_67_1 in pairs(var_67_0) do
		arg_67_0[iter_67_0] = iter_67_1
	end

	arg_67_0:resetTopUIView(arg_67_1)
	arg_67_0.imgBG:removeAllChildren()
end

function var_0_7.onAwardClick(arg_68_0, arg_68_1)
	local var_68_0 = arg_68_0.awardIdTabel[arg_68_1]

	if arg_68_0.siteStateTab[arg_68_1] == 1 then
		gGameApp:requestServer("/game/draw/sum/box/get", function(arg_69_0)
			gGameUI:showGainDisplay(csv.draw_count[var_68_0].award, {
				raw = false,
				cb = function()
					arg_68_0.downPanel:get("item" .. arg_68_1 + 1):get("result"):visible(false)
					arg_68_0:initAward()
				end
			})
		end, var_68_0)

		return
	end

	gGameUI:showBoxDetail({
		data = csv.draw_count[var_68_0].award,
		content = string.format(gLanguageCsv.accumulatedAward, csv.draw_count[var_68_0].count - (arg_68_0.preCount or 0)),
		state = arg_68_0.siteStateTab[arg_68_1] == 2 and 1 or 0
	})
end

function var_0_7.initAward(arg_71_0)
	local var_71_0

	if arg_71_0:judgeLimitOrSelfChooseDrawCard() then
		var_71_0 = 1
	elseif arg_71_0.perIdx == arg_71_0.rmblocation and dataEasy.isUnlock(gUnlockCsv.drawSumBox) then
		var_71_0 = 2
	end

	arg_71_0.downPanel:visible(false)

	if var_71_0 then
		arg_71_0.awardIdTabel = {}
		arg_71_0.siteStateTab = {
			2,
			2,
			2
		}

		local var_71_1
		local var_71_2
		local var_71_3
		local var_71_4

		arg_71_0.awardTab = {}

		local var_71_5 = {}
		local var_71_6 = 0
		local var_71_7 = 0
		local var_71_8
		local var_71_9
		local var_71_10
		local var_71_11 = 0

		if var_71_0 == 1 then
			arg_71_0.awardTab = arg_71_0.limitAwardTab
			var_71_2 = arg_71_0.getDiamondAwardState:read()[1] or {}
			var_71_11 = arg_71_0:caculateLimitNum()
		elseif var_71_0 == 2 then
			arg_71_0.awardTab = arg_71_0.diamondAwardTab
			var_71_2 = arg_71_0.getDiamondAwardState:read()[2] or {}

			local var_71_12 = arg_71_0.diamondAllCountTen:read() * 10

			var_71_11 = arg_71_0.diamondAllCount:read() + var_71_12
		end

		var_71_2 = var_71_2 or {}

		local function var_71_13(arg_72_0, arg_72_1, arg_72_2)
			local var_72_0 = csv.draw_count[arg_72_1] and csv.draw_count[arg_72_1].count

			if not var_72_0 then
				return
			end

			arg_71_0.awardIdTabel[arg_72_0] = arg_72_1

			local var_72_1 = arg_71_0.downPanel:get("item" .. arg_72_0 + 1)

			var_72_1:get("number"):text(var_72_0 - arg_72_2)
			var_72_1:get("result"):visible(false)
			arg_71_0["livenessPoint" .. arg_72_0]:set(100)
			var_72_1:get("bg"):texture(var_0_5[2])
			var_72_1:get("number"):setTextColor(ui.COLORS.GLOW.YELLOW)

			if var_72_1:get("effect") then
				var_72_1:get("effect"):hide()
			end

			if var_71_2[arg_72_1] == 0 then
				var_72_1:get("state"):texture(arg_72_0 == 3 and var_0_4[6] or var_0_4[1])

				arg_71_0.siteStateTab[arg_72_0] = 0
			elseif var_71_2[arg_72_1] == 1 or var_72_0 <= var_71_11 then
				var_72_1:get("state"):texture(arg_72_0 == 3 and var_0_4[5] or var_0_4[2])

				arg_71_0.siteStateTab[arg_72_0] = 1

				if not var_72_1:get("effect") then
					widget.addAnimationByKey(var_72_1, "effect/jiedianjiangli.skel", "effect", "effect_loop", 0):xy(100, 60):scale(0.7)
				end

				var_72_1:get("effect"):show()
			else
				local var_72_2 = csv.draw_count[arg_72_1 - 1] and csv.draw_count[arg_72_1 - 1].count or 0
				local var_72_3 = csv.draw_count[arg_72_1].count - var_72_2

				arg_71_0["livenessPoint" .. arg_72_0]:set(not var_71_11 and 0 or (var_71_11 - var_72_2) / var_72_3 * 100)
				var_72_1:get("number"):setTextColor(ui.COLORS.NORMAL.WHITE)
				var_72_1:get("bg"):texture(var_0_5[1])
				var_72_1:get("state"):texture(arg_72_0 == 3 and var_0_4[4] or var_0_4[3])
			end
		end

		if csvSize(arg_71_0.awardTab) >= 3 then
			local var_71_14 = 0
			local var_71_15
			local var_71_16

			for iter_71_0, iter_71_1 in orderCsvPairs(arg_71_0.awardTab) do
				var_71_14 = var_71_14 + 1
				var_71_15 = iter_71_0

				if var_71_2[iter_71_0] ~= 0 then
					local var_71_17 = iter_71_0 - (var_71_14 - 1) % 3

					if arg_71_0.awardTab[var_71_17 + 2] then
						var_71_16 = var_71_17
					end

					break
				end
			end

			var_71_16 = var_71_16 or var_71_15 - var_71_14 % 3 - 2

			local var_71_18 = 0

			if arg_71_0.awardTab[var_71_16 - 1] then
				var_71_18 = arg_71_0.awardTab[var_71_16 - 1].count
			end

			arg_71_0.preCount = var_71_18

			var_71_13(1, var_71_16, var_71_18)
			var_71_13(2, var_71_16 + 1, var_71_18)
			var_71_13(3, var_71_16 + 2, var_71_18)
			arg_71_0.downPanel:get("item1"):get("number"):text(var_71_11 - var_71_18)
			arg_71_0.downPanel:visible(true)
		end
	end
end

function var_0_7.judgeLimitOrSelfChooseDrawCard(arg_73_0)
	if arg_73_0.selfChooseLocation and arg_73_0.perIdx == arg_73_0.selfChooseLocation and dataEasy.isUnlock(gUnlockCsv.groupDrawCardUp) or arg_73_0.diamondUpId:read() and arg_73_0.perIdx == arg_73_0.limitlocation and dataEasy.isUnlock(gUnlockCsv.timeLimitUpDrawSumBox) then
		return true
	else
		return false
	end
end

function var_0_7.caculateLimitNum(arg_74_0)
	local var_74_0 = arg_74_0.yyhuodongCounters:read()[game.YYHUODONG_TYPE_ENUM_TABLE.timeLimitUpDraw] or 0
	local var_74_1 = arg_74_0.selfChooseUp1Counters:read()
	local var_74_2 = arg_74_0.selfChooseUp10Counters:read()
	local var_74_3 = 0
	local var_74_4 = 0

	if var_74_1 then
		for iter_74_0, iter_74_1 in pairs(var_74_1) do
			var_74_3 = var_74_3 + iter_74_1
		end
	end

	if var_74_2 then
		for iter_74_2, iter_74_3 in pairs(var_74_2) do
			var_74_4 = var_74_4 + iter_74_3
		end
	end

	return var_74_3 + 10 * var_74_4 + var_74_0
end

function var_0_7.initPageItemFunc(arg_75_0, arg_75_1, arg_75_2, arg_75_3, arg_75_4, arg_75_5, arg_75_6, arg_75_7, arg_75_8)
	return
end

function var_0_7.isEnoughToDrawFunc(arg_76_0, arg_76_1)
	return
end

function var_0_7.drawOneClickFunc(arg_77_0)
	return
end

function var_0_7.drawTenClickFunc(arg_78_0)
	return
end

function var_0_7.onSxlbClick(arg_79_0)
	local var_79_0 = arg_79_0.limitId:read()
	local var_79_1

	if csv.yunying.yyhuodong[var_79_0] then
		var_79_1 = csv.yunying.yyhuodong[var_79_0].huodongID
	end

	local var_79_2

	if arg_79_0.cardsInfo and #arg_79_0.cardsInfo > 0 then
		var_79_2 = {}

		local var_79_3 = math.random(1, #arg_79_0.cardsInfo)

		var_79_2.res = arg_79_0.cardsInfo[var_79_3]
	end

	gGameUI:stackUI("city.activity.recharge_feedback.stargift", nil, nil, var_79_1, var_79_0, var_79_2)
end

function var_0_7.onXdlbClick(arg_80_0)
	gGameUI:stackUI("city.activity.focus_buy_gift", nil, nil, arg_80_0.limitId:read(), arg_80_0.cardsInfo)
end

return var_0_7
