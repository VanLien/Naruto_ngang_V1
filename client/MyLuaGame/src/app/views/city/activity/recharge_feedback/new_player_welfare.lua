local var_0_0 = {
	CAN_NOT_GOTTEN = 2,
	CAN_GOTTEN = 1,
	GOTTEN = 0
}
local var_0_1 = {
	{
		(cc.p(200, 200))
	},
	{
		cc.p(200, 300),
		(cc.p(200, 100))
	},
	{
		cc.p(200, 300),
		cc.p(100, 100),
		(cc.p(300, 100))
	},
	{
		cc.p(100, 300),
		cc.p(300, 300),
		cc.p(100, 100),
		(cc.p(300, 100))
	}
}
local var_0_2 = {
	[2091] = {
		scale = 2.5,
		dayFileName = "activity/new_player_welfare/num_3.png",
		rot = 0,
		nameFileName = "activity/new_player_welfare/txt_gg.png",
		pos = cc.p(554, 846)
	},
	[2181] = {
		scale = 2.3,
		dayFileName = "activity/new_player_welfare/num_7.png",
		rot = 0,
		nameFileName = "activity/new_player_welfare/txt_mh.png",
		pos = cc.p(600, 846)
	}
}
local var_0_3 = class("ActivityNewPlayerWelfareDialog", Dialog)

var_0_3.RESOURCE_FILENAME = "activity_new_player_welfare.json"
var_0_3.RESOURCE_BINDING = {
	item = "item",
	["ImageActivity.imgSptireName"] = "imgSptireName",
	imgAttr1 = "imgAttr1",
	iconItem = "iconItem",
	imgAttr2 = "imgAttr2",
	imgSpriteShow = "imgSpriteShow",
	textToday1 = "textToday1",
	imgRarity = "imgRarity",
	["ImageActivity.imgTotalDay"] = "imgTotalDay",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	textTodayNum = {
		varname = "textTodayNum",
		binds = {
			{
				event = "text",
				idler = bindHelper.self("daySum")
			}
		}
	},
	textToday = {
		varname = "textToday"
	},
	["item.btnGet.textGet"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.NEWCOLORS.OUTLINE.BLACK1,
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["item.btnGet.textNotGet"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["item.textGotten"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
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
				data = bindHelper.self("itemsData"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_0.initItem(arg_1_1, arg_1_2, arg_1_3)
				end
			},
			handlers = {
				initItem = bindHelper.self("initItem")
			}
		}
	}
}

function var_0_3.onCreate(arg_2_0, arg_2_1)
	Dialog.onCreate(arg_2_0, {
		blackType = 1
	})

	arg_2_0.activityId = arg_2_1

	arg_2_0:initModel()
	arg_2_0:initUI()
	gGameModel.currday_dispatch:getIdlerOrigin("newPlayerWeffare"):set(true)
end

function var_0_3.initModel(arg_3_0)
	arg_3_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_3_0.daySum = idler.new(0)
	arg_3_0.loginwealData = {}
	arg_3_0.itemsData = idlertable.new({})

	local var_3_0 = csv.yunying.yyhuodong[arg_3_0.activityId].huodongID

	for iter_3_0, iter_3_1 in csvPairs(csv.yunying.loginweal) do
		if iter_3_1.huodongID == var_3_0 then
			arg_3_0.loginwealData[iter_3_1.daySum] = {
				award = iter_3_1.award,
				id = iter_3_0
			}
		end
	end
end

function var_0_3.initUI(arg_4_0)
	idlereasy.when(arg_4_0.yyhuodongs, function(arg_5_0, arg_5_1)
		local var_5_0 = arg_5_1[arg_4_0.activityId]
		local var_5_1 = {}

		for iter_5_0, iter_5_1 in pairs(arg_4_0.loginwealData) do
			if iter_5_0 > var_5_0.info.daysum then
				var_5_1[iter_5_0] = {
					award = iter_5_1.award,
					id = iter_5_1.id,
					getType = var_0_0.CAN_NOT_GOTTEN
				}
			else
				var_5_1[iter_5_0] = {
					award = iter_5_1.award,
					id = iter_5_1.id,
					getType = var_5_0.stamps[iter_5_1.id]
				}
			end
		end

		dataEasy.tryCallFunc(arg_4_0.list, "updatePreloadCenterIndex")
		arg_4_0.itemsData:set(var_5_1)
		arg_4_0.daySum:set(var_5_0.info.daysum)
	end)
	arg_4_0:initLeftSprite()
	adapt.oneLinePos(arg_4_0.textToday1, {
		arg_4_0.textTodayNum,
		arg_4_0.textToday
	}, cc.p(5, 0), "right")
end

function var_0_3.initLeftSprite(arg_6_0)
	local var_6_0 = csv.yunying.yyhuodong[arg_6_0.activityId]

	if arg_6_0.daySum:read() <= 2 then
		arg_6_0.showCardId = var_6_0.clientParam.cardId1
	else
		arg_6_0.showCardId = var_6_0.clientParam.cardId2
	end

	local var_6_1 = csv.cards[arg_6_0.showCardId]
	local var_6_2 = csv.unit[var_6_1.unitID]
	local var_6_3 = var_6_2.rarity
	local var_6_4 = var_6_2.name
	local var_6_5 = var_6_2.natureType
	local var_6_6 = var_6_2.natureType2

	arg_6_0.imgRarity:texture(ui.RARITY_ICON[var_6_3])
	arg_6_0.imgAttr1:texture(ui.ATTR_ICON[var_6_5])

	if var_6_6 == nil then
		arg_6_0.imgAttr2:hide()
	else
		arg_6_0.imgAttr2:texture(ui.ATTR_ICON[var_6_6]):show()
	end

	local var_6_7 = var_6_2.cardShow
	local var_6_8 = var_0_2[arg_6_0.showCardId]

	arg_6_0.imgSpriteShow:texture(var_6_7):xy(var_6_8.pos.x + display.uiOrigin.x, var_6_8.pos.y):scale(var_6_8.scale):setRotation(var_6_8.rot)
	arg_6_0.imgTotalDay:texture(var_6_8.dayFileName)
	arg_6_0.imgSptireName:texture(var_6_8.nameFileName)
end

function var_0_3.initItem(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = arg_7_2:multiget("textDay", "btnGet", "textGotten", "imgGift", "iconPanel")
	local var_7_1 = var_7_0.textDay:setString(arg_7_3)
	local var_7_2 = arg_7_4.award
	local var_7_3 = itertools.size(var_7_2)
	local var_7_4 = 0

	var_7_0.iconPanel:removeAllChildren()

	for iter_7_0, iter_7_1 in pairs(var_7_2) do
		var_7_4 = var_7_4 + 1

		local var_7_5 = var_0_1[var_7_3][var_7_4]
		local var_7_6 = arg_7_0.iconItem:clone()

		var_7_6:addTo(var_7_0.iconPanel)
		var_7_6:show()
		var_7_6:xy(var_7_5.x, var_7_5.y)

		local var_7_7 = {
			class = "icon_key",
			props = {
				data = {
					key = iter_7_0,
					num = iter_7_1
				}
			}
		}

		bind.extend(arg_7_0, var_7_6, var_7_7)
	end

	if arg_7_4.getType == var_0_0.CAN_NOT_GOTTEN then
		var_7_0.btnGet:get("textGet"):hide()
		var_7_0.btnGet:get("textNotGet"):show()
		var_7_0.btnGet:setEnabled(false)
		var_7_0.btnGet:opacity(102)
		var_7_0.imgGift:hide()
		var_7_0.textGotten:hide()
		adapt.setTextScaleWithWidth(var_7_0.btnGet:get("textNotGet"), var_7_0.btnGet:get("textNotGet"):text(), 200)
	elseif arg_7_4.getType == var_0_0.CAN_GOTTEN then
		var_7_0.btnGet:get("textGet"):show()
		var_7_0.btnGet:get("textNotGet"):hide()
		var_7_0.btnGet:setEnabled(true)
		var_7_0.btnGet:opacity(255)
		var_7_0.imgGift:hide()
		var_7_0.textGotten:hide()
		adapt.setTextScaleWithWidth(var_7_0.btnGet:get("textGet"), var_7_0.btnGet:get("textGet"):text(), 200)
	elseif arg_7_4.getType == var_0_0.GOTTEN then
		var_7_0.btnGet:hide()
		var_7_0.textGotten:show()
		var_7_0.imgGift:show()
	end

	bind.touch(arg_7_0, var_7_0.btnGet, {
		methods = {
			ended = functools.partial(arg_7_0.sendGetAward, arg_7_0, arg_7_4.id)
		}
	})
end

function var_0_3.sendGetAward(arg_8_0, arg_8_1)
	gGameApp:requestServer("/game/yy/award/get", function(arg_9_0)
		gGameUI:showGainDisplay(arg_9_0)
	end, arg_8_0.activityId, arg_8_1)
end

return var_0_3
