local var_0_0 = {
	"standby_loop",
	"attack",
	"win_loop",
	"run_loop",
	"skill1"
}
local var_0_1 = {
	gLanguageCsv.skinBuff1,
	gLanguageCsv.skinBuff2
}
local var_0_2 = {
	"city/drawcard/draw/panel_card_gh.png",
	"city/drawcard/draw/panel_card_l.png",
	"city/drawcard/draw/panel_card_b.png",
	"city/drawcard/draw/panel_card_z.png",
	"city/drawcard/draw/panel_card_h.png",
	"city/drawcard/draw/panel_card_c.png",
	"city/drawcard/draw/panel_card_r.png"
}
local var_0_3 = class("CardSkinView", Dialog)

var_0_3.RESOURCE_FILENAME = "card_skin.json"
var_0_3.RESOURCE_BINDING = {
	["panelLeft.imgActionDi"] = "imgActionBg",
	itemAttr = "itemAttr",
	["panelRight.skinNoAdd"] = "skinNoAdd",
	["panelLeft.btnSwitch.imgSwitch"] = "imgSwitch",
	["panelLeft.imgFlag"] = "imgFlag",
	["panelRight.imgDress"] = "imgDress",
	panelRight = "panelRight",
	["panelLeft.imgIcon"] = "imgIcon",
	["panelLeft.imgIconBg"] = "imgIconBg",
	["panelRight.panelNature"] = "panelNature",
	panelCell = "panelCell",
	item = "item",
	["panelRight.skinList"] = "skinList",
	["panelRight.panelNature.txtBuffObj"] = "txtBuffObj",
	["panelRight.txtSkinDesc"] = "txtSkinDesc",
	starItem = "starItem",
	["panelRight.txtLimitTime"] = "txtLimitTime",
	["panelLeft.btnSwitch.labelSwitch"] = "labelSwitch",
	["panelLeft.textName"] = "cardNameTxt",
	attrItem = "attrItem",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["panelLeft.attrList"] = {
		varname = "attrList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("attrItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("imgIcon"):texture(ui.ATTR_ICON[arg_1_3])
				end
			}
		}
	},
	["panelLeft.btnSwitch"] = {
		varname = "btnSwitch",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnSwitch")
			}
		}
	},
	["panelLeft.starList"] = {
		varname = "starList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("starDatas"),
				item = bindHelper.self("starItem"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					arg_2_1:get("imgStar"):texture(arg_2_3.icon)
				end
			}
		}
	},
	["panelLeft.heroNode"] = {
		varname = "heroNode",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCardClick")
			}
		}
	},
	["panelRight.panelNature.infoList"] = {
		varname = "attrList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("skinNativeDatas"),
				item = bindHelper.self("itemAttr"),
				itemCell = bindHelper.self("item"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = {
						class = "listview",
						props = {
							margin = 100,
							data = arg_3_3,
							item = arg_3_0.itemCell,
							onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
								local var_4_0 = arg_4_1:multiget("title", "num")

								var_4_0.title:text(getLanguageAttr(arg_4_3.attrType))
								var_4_0.num:text("+" .. dataEasy.getAttrValueString(arg_4_3.attrType, arg_4_3.attrValue))
								adapt.oneLinePos(var_4_0.title, var_4_0.num, cc.p(5, 0), "left")

								local var_4_1 = var_4_0.title:width()
								local var_4_2 = var_4_0.num:width()

								arg_4_1:width(var_4_1 + var_4_2 + 5)
							end
						}
					}

					bind.extend(arg_3_0, arg_3_1, var_3_0)
				end
			}
		}
	},
	["panelRight.buttonLeft"] = {
		varname = "buttonLeft",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onButtonLeft")
			}
		}
	},
	["panelRight.buttonRight"] = {
		varname = "buttonRight",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onButtonRight")
			}
		}
	},
	["panelRight.buttonOp"] = {
		varname = "buttonOp",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onButtonOp")
			}
		}
	},
	["panelRight.buttonOp.text"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["panelRight.buttonBuy"] = {
		varname = "buttonBuy",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onButtonBuy")
			}
		}
	},
	["panelRight.buttonBuy.text"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	}
}

function var_0_3.onCreate(arg_5_0, arg_5_1)
	arg_5_0.cardDbid = arg_5_1
	arg_5_0.selectID = idler.new(0)
	arg_5_0.selectSkinID = idler.new(0)
	arg_5_0.starDatas = idlertable.new({})
	arg_5_0.attrDatas = idlers.newWithMap({})
	arg_5_0.skinDatas = {}
	arg_5_0.skinItemList = {}
	arg_5_0.showTp = idler.new(0)
	arg_5_0.skinNativeDatas = idlers.new({})
	arg_5_0.cardActionState = idler.new(1)
	arg_5_0.skinChilds = {}
	arg_5_0.count = 10

	arg_5_0:initModel()

	local var_5_0 = gGameModel.cards:find(arg_5_1)

	arg_5_0.cardName = idlereasy.assign(var_5_0:getIdler("name"), arg_5_0.cardName)
	arg_5_0.cardId = idlereasy.assign(var_5_0:getIdler("card_id"), arg_5_0.cardId)
	arg_5_0.unitId = idlereasy.assign(var_5_0:getIdler("unit_id"), arg_5_0.unitId)
	arg_5_0.skinId = idlereasy.assign(var_5_0:getIdler("skin_id"), arg_5_0.skinId)
	arg_5_0.star = idlereasy.assign(var_5_0:getIdler("star"), arg_5_0.star)
	arg_5_0.advance = idlereasy.assign(var_5_0:getIdler("advance"), arg_5_0.advance)
	arg_5_0.level = idlereasy.assign(var_5_0:getIdler("level"), arg_5_0.level)

	uiEasy.setIconName("card", arg_5_0.cardId:read(), {
		space = true,
		node = arg_5_0.cardNameTxt,
		name = arg_5_0.cardName:read(),
		advance = arg_5_0.advance:read()
	})
	idlereasy.when(arg_5_0.star, function(arg_6_0, arg_6_1)
		local var_6_0 = {}
		local var_6_1 = arg_6_1 - 6

		for iter_6_0 = 1, 6 do
			local var_6_2 = "common/icon/icon_star_d.png"

			if iter_6_0 <= arg_6_1 then
				var_6_2 = dataEasy.getStarRes(arg_6_1, iter_6_0)
			end

			table.insert(var_6_0, {
				icon = var_6_2
			})
		end

		arg_5_0.starDatas:set(var_6_0)
	end)

	local var_5_1 = userDefault.getForeverLocalKey("skinShowType", 0, {
		rawData = true,
		rawKey = true
	})

	arg_5_0.showTp:set(var_5_1)
	arg_5_0.cardId:addListener(function(arg_7_0, arg_7_1)
		local var_7_0 = csv.cards[arg_7_0].unitID
		local var_7_1 = csv.unit[var_7_0]
		local var_7_2 = {}

		table.insert(var_7_2, var_7_1.natureType)

		if var_7_1.natureType2 then
			table.insert(var_7_2, var_7_1.natureType2)
		end

		arg_5_0.attrDatas:update(var_7_2)
		arg_5_0.imgFlag:texture(ui.RARITY_ICON[var_7_1.rarity])
	end)
	idlereasy.any({
		arg_5_0.cardId,
		arg_5_0.skins
	}, function(arg_8_0, arg_8_1, arg_8_2)
		arg_5_0:setSkinList(arg_8_1, arg_8_2)
		arg_5_0:initSkinList()

		if arg_5_0.selectID:read() ~= 0 then
			arg_5_0.selectID:notify()
		end
	end)
	idlereasy.when(arg_5_0.skinId, function(arg_9_0, arg_9_1)
		arg_9_1 = arg_9_1 or 0

		for iter_9_0, iter_9_1 in ipairs(arg_5_0.skinDatas) do
			if iter_9_1.id and iter_9_1.id == arg_9_1 then
				arg_5_0.selectID:set(iter_9_0 - 1, true)

				break
			end
		end
	end)
	arg_5_0.selectID:addListener(function(arg_10_0, arg_10_1)
		local var_10_0 = arg_5_0.skinDatas[arg_10_0 + 1]

		arg_5_0:setSkinInfo(var_10_0.id)
		arg_5_0:setButtonInfo(var_10_0)
		arg_5_0:setButtonEnabled()
		arg_5_0:setAutoScroll(arg_10_0)
		arg_5_0:setLeftPanelInfo(var_10_0.unitId)
	end)
	idlereasy.when(arg_5_0.showTp, function(arg_11_0, arg_11_1)
		arg_5_0:setLeftPanelShow()
		arg_5_0.cardActionState:set(3, true)
	end)
	idlereasy.when(arg_5_0.cardActionState, function(arg_12_0, arg_12_1)
		arg_5_0.cardSprite:setSpriteEventHandler()

		local var_12_0 = arg_5_0.heroNode:getContentSize()

		arg_5_0.cardSprite:retain()
		arg_5_0.cardSprite:removeFromParent()
		arg_5_0.cardSprite:addTo(arg_5_0.heroNode, 5):xy(var_12_0.width / 2, 0)
		arg_5_0.cardSprite:release()

		if arg_12_1 ~= 1 then
			local var_12_1 = 0

			arg_5_0.cardSprite:setSpriteEventHandler(function(arg_13_0, arg_13_1)
				if arg_12_1 == 4 then
					var_12_1 = var_12_1 + 1

					if var_12_1 > 5 then
						arg_5_0.cardSprite:setSpriteEventHandler()
						arg_5_0.cardActionState:set(1)
					end
				else
					arg_5_0.cardSprite:setSpriteEventHandler()
					arg_5_0.cardActionState:set(1)
				end
			end, sp.EventType.ANIMATION_COMPLETE)
		end

		if arg_12_1 == 4 then
			arg_5_0.cardSprite:play(var_0_0[arg_12_1], false)

			for iter_12_0 = 2, 5 do
				arg_5_0.cardSprite:addPlay(var_0_0[arg_12_1])
			end
		else
			arg_5_0.cardSprite:play(var_0_0[arg_12_1])
		end

		local var_12_2 = csv.cards[arg_5_0.cardId:read()].soundsEffect or {}

		if var_12_2[var_0_0[arg_12_1]] then
			audio.playEffectWithWeekBGM(var_12_2[var_0_0[arg_12_1]])
		end
	end)
	Dialog.onCreate(arg_5_0)
end

function var_0_3.initModel(arg_14_0)
	arg_14_0.skins = gGameModel.role:getIdler("skins")
end

function var_0_3.setSkinList(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = csv.cards[arg_15_1].skinSkillMap
	local var_15_1 = {
		{
			sign = false,
			rank = 0
		}
	}
	local var_15_2 = csv.unit[arg_15_0.unitId:read()]

	var_15_1[2] = {
		skinType = 1,
		days = 0,
		rank = 1,
		skinFrameType = 1,
		sign = true,
		id = 0,
		isHas = 0,
		icon = var_15_2.cardShow,
		scale = var_15_2.cardShowScale,
		posOffset = var_15_2.cardShowPosC,
		rarity = var_15_2.rarity,
		unitId = arg_15_0.unitId:read(),
		name = gLanguageCsv.skinStart
	}

	for iter_15_0, iter_15_1 in csvMapPairs(var_15_0) do
		local var_15_3 = gSkinCsv[iter_15_0]

		if var_15_3 and var_15_3.isOpen then
			local var_15_4 = dataEasy.getUnitId(arg_15_0.cardId:read(), iter_15_0)
			local var_15_5 = csv.unit[var_15_4]
			local var_15_6 = {
				skinFrameType = 0,
				sign = true,
				id = iter_15_0,
				skinType = var_15_3.skinType,
				days = var_15_3.days,
				isHas = arg_15_2[iter_15_0] or false,
				icon = var_15_5.cardShow,
				scale = var_15_5.cardShowScale,
				posOffset = var_15_5.cardShowPosC,
				rarity = var_15_5.rarity,
				costMap = var_15_3.costMap,
				skinFrameRes = var_15_3.skinFrameRes,
				extraItem = var_15_3.extraItem,
				isOpen = var_15_3.isOpen,
				name = var_15_3.name,
				desc = var_15_3.desc,
				rank = var_15_3.rank + 2,
				activeType = var_15_3.activeType,
				unitId = var_15_4
			}

			var_15_1[#var_15_1 + 1] = var_15_6
		end
	end

	var_15_1[#var_15_1 + 1] = {
		sign = false,
		rank = 99999
	}

	table.sort(var_15_1, function(arg_16_0, arg_16_1)
		return arg_16_0.rank < arg_16_1.rank
	end)

	arg_15_0.skinDatas = var_15_1
end

function var_0_3.initCell(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_1:multiget("ImageBg", "labelName", "imageAdd", "imgLimitBg", "labelInfo")

	nodetools.map({
		var_17_0.imageAdd,
		var_17_0.imgLimitBg,
		var_17_0.labelInfo
	}, "visible", false)
	arg_17_1:visible(arg_17_2.sign)

	if not arg_17_2.sign then
		return
	end

	local var_17_1 = var_17_0.ImageBg:size()
	local var_17_2 = 80
	local var_17_3 = ccui.Scale9Sprite:create()

	var_17_3:initWithFile(cc.rect(82, 82, 1, 1), "common/icon/mask_card.png")
	var_17_3:size(var_17_1.width - 39, var_17_1.height - 39):alignCenter(var_17_1)

	local var_17_4 = cc.Sprite:create(arg_17_2.icon)
	local var_17_5 = var_17_4:size()
	local var_17_6 = cc.p(arg_17_2.posOffset.x / arg_17_2.scale, -arg_17_2.posOffset.y / arg_17_2.scale)
	local var_17_7 = cc.size(var_17_1.width / arg_17_2.scale, var_17_1.height / arg_17_2.scale)
	local var_17_8 = cc.rect((var_17_5.width - var_17_7.width) / 2 - var_17_6.x, (var_17_5.height - var_17_7.height) / 2 - var_17_6.y, var_17_7.width, var_17_7.height)

	var_17_4:alignCenter(var_17_1):scale(arg_17_2.scale + 0.2):setTextureRect(var_17_8)
	arg_17_1:removeChildByName("clipping")
	cc.ClippingNode:create(var_17_3):setAlphaThreshold(0.1):size(var_17_1):alignCenter(arg_17_1:size()):add(var_17_4):addTo(arg_17_1, 5, "clipping")
	var_17_0.labelName:text(arg_17_2.name)

	if arg_17_2.skinFrameType == 1 then
		var_17_0.ImageBg:texture(var_0_2[arg_17_2.rarity + 2])
	else
		var_17_0.ImageBg:texture(arg_17_2.skinFrameRes)
	end

	bind.touch(arg_17_0, arg_17_1, {
		clicksafe = true,
		scaletype = 0,
		methods = {
			ended = function()
				arg_17_0.onButtonClick(arg_17_0, arg_17_3)
			end
		}
	})

	if arg_17_2.isHas then
		return
	end

	if arg_17_2.extraItem and csvSize(arg_17_2.extraItem) == 1 then
		var_17_0.imageAdd:visible(true)

		local var_17_9, var_17_10 = csvNext(arg_17_2.extraItem)
		local var_17_11 = csv.items[var_17_9]
		local var_17_12 = cc.Sprite:create(var_17_11.icon)

		var_17_12:alignCenter(var_17_12:size()):scale(1.2):xy(cc.p(80, 80)):addTo(var_17_0.imageAdd)
	end
end

function var_0_3.initSkinList(arg_19_0)
	local var_19_0 = {}

	for iter_19_0, iter_19_1 in ipairs(arg_19_0.skinDatas) do
		local var_19_1 = arg_19_0.panelCell:clone()

		var_19_0[#var_19_0 + 1] = var_19_1

		arg_19_0:initCell(var_19_1, iter_19_1, iter_19_0)
	end

	arg_19_0.skinChilds = var_19_0

	arg_19_0.skinList:removeAllChildren()

	local var_19_2 = arg_19_0.panelCell:anchorPoint()
	local var_19_3 = arg_19_0.panelCell:size()

	for iter_19_2, iter_19_3 in pairs(var_19_0) do
		local var_19_4 = iter_19_3:anchorPoint()

		iter_19_3:xy(var_19_3.width * (var_19_4.x + iter_19_2 - 1), var_19_3.height * var_19_4.y)
		arg_19_0.skinList:add(iter_19_3, #var_19_0 - iter_19_2)
	end

	arg_19_0.skinList:setInnerContainerSize(cc.size(#var_19_0 * var_19_3.width, var_19_3.height))
	arg_19_0.skinList:setScrollBarEnabled(false)
	arg_19_0.skinList:setInertiaScrollEnabled(false)

	local var_19_5 = arg_19_0.skinList:size()
	local var_19_6 = arg_19_0.skinList:getInnerContainerSize()
	local var_19_7 = arg_19_0.skinList:getInnerContainer()
	local var_19_8 = var_19_5.width / 2
	local var_19_9 = var_19_6.width - var_19_5.width
	local var_19_10 = var_19_3.width

	local function var_19_11()
		local var_20_0 = var_19_7:x()

		for iter_20_0, iter_20_1 in pairs(var_19_0) do
			local var_20_1 = iter_20_1:xy()
			local var_20_2 = 1.1 - 0.4 * math.abs(var_19_8 - var_20_1 - var_20_0) / var_19_8

			iter_20_1:scale(var_20_2, var_20_2)
		end
	end

	arg_19_0.skinList:onScroll(function(arg_21_0)
		if arg_21_0.name == "CONTAINER_MOVED" then
			var_19_11()
		elseif arg_21_0.name == "SCROLLING_ENDED" then
			local var_21_0 = var_19_7:x()
			local var_21_1 = math.min(var_21_0, 0)
			local var_21_2 = math.max(var_21_1, -var_19_9)
			local var_21_3 = math.abs(var_21_2)
			local var_21_4 = var_21_3 % var_19_10
			local var_21_5 = math.floor(var_21_3 / var_19_10)

			if var_21_4 > var_19_10 / 2 then
				var_21_5 = var_21_5 + 1
			end

			arg_19_0.selectID:set(var_21_5 + 1, true)
		end
	end)
	var_19_11()
end

function var_0_3.setLeftPanelInfo(arg_22_0, arg_22_1)
	local var_22_0 = csv.unit[arg_22_1]

	if arg_22_0.cardSprite then
		arg_22_0.cardSprite:removeFromParent()
	end

	local var_22_1 = arg_22_0.heroNode:getContentSize()

	arg_22_0.cardSprite = widget.addAnimation(arg_22_0.heroNode, var_22_0.unitRes, "standby_loop", 5):xy(var_22_1.width / 2, 0)

	arg_22_0.cardSprite:scale(var_22_0.scaleU * 3)
	arg_22_0.cardSprite:setSkin(var_22_0.skin)
	arg_22_0.imgIcon:texture(var_22_0.cardShow)
	arg_22_0.cardActionState:set(3, true)
end

function var_0_3.setSkinInfo(arg_23_0, arg_23_1)
	arg_23_0.panelNature:visible(arg_23_1 ~= 0)
	arg_23_0.skinNoAdd:visible(arg_23_1 == 0)

	if arg_23_1 == 0 then
		return
	end

	local var_23_0 = csv.card_skin[arg_23_1]
	local var_23_1 = {}
	local var_23_2 = 0
	local var_23_3 = var_23_0.attrAddType

	arg_23_0.txtBuffObj:text(var_0_1[var_23_3])

	local var_23_4 = {}

	for iter_23_0 = 1, 6 do
		if iter_23_0 % 3 == 1 then
			if iter_23_0 > 3 and #var_23_4 > 0 then
				var_23_1[#var_23_1 + 1] = var_23_4
			end

			var_23_4 = {}
		end

		local var_23_5 = var_23_0["attrType" .. iter_23_0]

		if var_23_5 and var_23_5 ~= 0 then
			table.insert(var_23_4, {
				attrType = var_23_5,
				attrValue = var_23_0["attrNum" .. iter_23_0]
			})
		end
	end

	if #var_23_4 > 0 then
		var_23_1[#var_23_1 + 1] = var_23_4
	end

	if #var_23_1 > 0 then
		arg_23_0.skinNativeDatas:update(var_23_1)

		local var_23_6 = arg_23_0.attrList:y() + arg_23_0.attrList:height() - arg_23_0.attrList:size().height

		arg_23_0.panelNature:get("desc"):y(var_23_6)
	else
		arg_23_0.panelNature:visible(false)
		arg_23_0.skinNoAdd:visible(true)
	end
end

function var_0_3.setAutoScroll(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.skinList:size()
	local var_24_1 = arg_24_0.skinList:getInnerContainerSize()
	local var_24_2 = arg_24_0.skinList:getInnerContainer()
	local var_24_3 = arg_24_0.panelCell:size()
	local var_24_4 = var_24_1.width - var_24_0.width
	local var_24_5 = var_24_2:x()
	local var_24_6 = math.min(var_24_5, -1)
	local var_24_7 = math.max(var_24_6, -(var_24_4 + 1))
	local var_24_8 = math.abs(var_24_7)
	local var_24_9 = var_24_3.width * (arg_24_1 - 1)
	local var_24_10 = math.min(var_24_9, var_24_4)

	if var_24_8 >= 0 and var_24_4 >= var_24_8 - 2 then
		arg_24_0.skinList:scrollToPercentHorizontal(var_24_10 / var_24_4 * 100, 0.4, true)
	end

	arg_24_0.count = arg_24_0.count + 1

	arg_24_0.skinChilds[arg_24_1 + 1]:setLocalZOrder(arg_24_0.count)
end

function var_0_3.setButtonInfo(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0.panelRight:get("privilege")

	if var_25_0 then
		var_25_0:removeFromParent()
	end

	nodetools.map({
		arg_25_0.imgDress,
		arg_25_0.buttonOp,
		arg_25_0.buttonBuy,
		arg_25_0.txtLimitTime,
		arg_25_0.txtSkinDesc
	}, "visible", false)

	if arg_25_0.skinId:read() == arg_25_1.id then
		arg_25_0.imgDress:show()
	elseif arg_25_1.isHas then
		arg_25_0.buttonOp:show()
	elseif csvSize(arg_25_1.costMap) > 0 then
		arg_25_0.buttonBuy:show()

		local var_25_1 = gLanguageCsv.skinXiaoFei
		local var_25_2 = true

		for iter_25_0, iter_25_1 in csvMapPairs(arg_25_1.costMap) do
			if iter_25_1 > dataEasy.getNumByKey(iter_25_0) then
				local var_25_3 = false
			end

			var_25_1 = var_25_1 .. string.format("%d#I%s-56-56#", iter_25_1, dataEasy.getIconResByKey(iter_25_0))
		end

		local var_25_4 = arg_25_0.buttonBuy:size()
		local var_25_5, var_25_6 = arg_25_0.buttonBuy:xy()
		local var_25_7 = rich.createByStr(var_25_1, 40):addTo(arg_25_0.panelRight, 10, "privilege"):anchorPoint(1, 0.5):xy(cc.p(var_25_5 - var_25_4.width / 2 - 10, var_25_6)):formatText()
	else
		arg_25_0.txtSkinDesc:show()
		arg_25_0.txtSkinDesc:text(arg_25_1.desc)
	end

	if arg_25_1.isHas and arg_25_1.isHas > 0 then
		local var_25_8 = math.ceil(arg_25_1.isHas)
		local var_25_9 = time.getTime()

		if var_25_9 < var_25_8 then
			arg_25_0.txtLimitTime:show()

			local var_25_10 = var_25_8 - var_25_9
			local var_25_11 = math.floor(var_25_10 / 3600 / 24)
			local var_25_12 = ""

			if var_25_11 > 0 then
				var_25_12 = string.format(gLanguageCsv.skinTip05, var_25_11)

				arg_25_0.txtLimitTime:text(var_25_12)
			else
				local function var_25_13()
					var_25_10 = var_25_8 - time.getTime()

					if var_25_10 < 0 then
						return false
					end

					local var_26_0 = time.getCutDown(var_25_10).clock_str

					var_25_12 = string.format(gLanguageCsv.skinTip06, var_26_0)

					arg_25_0.txtLimitTime:text(var_25_12)

					return true
				end

				var_25_13()

				local var_25_14 = tag or 100

				arg_25_0:enableSchedule():unSchedule(var_25_14)
				arg_25_0:schedule(function()
					if not var_25_13() then
						gGameApp:requestServer("/game/sync")

						return false
					end
				end, 1, 1, var_25_14)
			end
		end
	end
end

function var_0_3.setButtonEnabled(arg_28_0)
	local var_28_0 = arg_28_0.selectID:read()

	arg_28_0.buttonRight:visible(var_28_0 + 2 < #arg_28_0.skinDatas)
	arg_28_0.buttonLeft:visible(var_28_0 > 1)
end

function var_0_3.setLeftPanelShow(arg_29_0)
	local var_29_0 = arg_29_0.showTp:read() == 0

	arg_29_0.heroNode:visible(var_29_0)
	arg_29_0.imgActionBg:visible(var_29_0)
	arg_29_0.imgIcon:visible(not var_29_0)
	arg_29_0.imgIconBg:visible(not var_29_0)
	arg_29_0.imgSwitch:xy(var_29_0 and cc.p(156, 40) or cc.p(40, 40))
	arg_29_0.labelSwitch:xy(var_29_0 and cc.p(70, 40) or cc.p(125, 40))
	arg_29_0.labelSwitch:text(var_29_0 and gLanguageCsv.skinAction or gLanguageCsv.skinImg)
end

function var_0_3.onButtonBuy(arg_30_0)
	local var_30_0 = arg_30_0.skinDatas[arg_30_0.selectID:read() + 1]
	local var_30_1 = gLanguageCsv.skinTip01
	local var_30_2 = true
	local var_30_3, var_30_4 = csvNext(var_30_0.costMap)
	local var_30_5 = var_30_1 .. string.format("%d#I%s-56-56#", var_30_4, dataEasy.getIconResByKey(var_30_3))

	if var_30_4 > dataEasy.getNumByKey(var_30_3) then
		var_30_2 = false
	end

	if var_30_2 then
		gGameUI:showDialog({
			isRich = true,
			btnType = 2,
			strs = string.format(gLanguageCsv.skinTip02, var_30_5, var_30_0.name),
			cb = function()
				gGameApp:requestServer("/game/card/skin/buy", function(arg_32_0)
					gGameUI:stackUI("city.card.skin.award", nil, nil, var_30_0.id)
				end, var_30_0.id)
			end,
			dialogParams = {
				clickClose = false
			}
		})
	else
		uiEasy.showDialog(var_30_3)
	end
end

function var_0_3.onCardClick(arg_33_0)
	local var_33_0 = arg_33_0.cardActionState:read()
	local var_33_1

	repeat
		var_33_1 = math.random(2, #var_0_0)
	until var_33_1 ~= var_33_0

	arg_33_0.cardActionState:set(var_33_1, true)
end

function var_0_3.onButtonRight(arg_34_0)
	local var_34_0 = arg_34_0.selectID:read()
	local var_34_1 = math.min(var_34_0 + 1, #arg_34_0.skinDatas - 2)

	arg_34_0.selectID:set(var_34_1)
end

function var_0_3.onButtonLeft(arg_35_0)
	local var_35_0 = arg_35_0.selectID:read()
	local var_35_1 = math.max(var_35_0 - 1, 1)

	arg_35_0.selectID:set(var_35_1)
end

function var_0_3.onButtonOp(arg_36_0)
	local var_36_0 = arg_36_0.skinDatas[arg_36_0.selectID:read() + 1]

	gGameApp:requestServer("/game/card/skin/use", function(arg_37_0)
		gGameUI:showTip(gLanguageCsv.skinTip03)
	end, var_36_0.id, arg_36_0.cardDbid)
end

function var_0_3.onBtnSwitch(arg_38_0)
	local var_38_0 = arg_38_0.showTp:read() == 0 and 1 or 0

	arg_38_0.showTp:set(var_38_0)
end

function var_0_3.onButtonClick(arg_39_0, arg_39_1)
	arg_39_0.selectID:set(arg_39_1 - 1)

	local var_39_0 = 0.2

	arg_39_0.skinList:setEnabled(false)
	performWithDelay(arg_39_0.skinList, function()
		arg_39_0.skinList:setEnabled(true)
	end, var_39_0)
end

function var_0_3.onClose(arg_41_0)
	Dialog.onClose(arg_41_0)
	userDefault.setForeverLocalKey("skinShowType", arg_41_0.showTp:read(), {
		rawKey = true
	})
end

return var_0_3
