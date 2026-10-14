local var_0_0 = {
	nightmare = 525,
	hero = 524,
	normal = 523
}
local var_0_1 = class("CaptureView", Dialog)

var_0_1.RESOURCE_FILENAME = "common_capture_popup.json"
var_0_1.RESOURCE_BINDING = {
	titleName = "titleName",
	animain = "animain",
	attrTmp = "attrTmp",
	txtTimeNumber = "txtTimeNumber",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	spritXq = {
		varname = "captureBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("captureMenuBtn")
			}
		}
	},
	returnBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	confirm = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCaptureBtnClick")
			}
		}
	},
	["spritXq.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["titleName.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["icon.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["txtTimeNumber.txt"] = {
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
	["txtTimeNumber.txtNumber"] = {
		varname = "txtNumber",
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
	["txtTimeNumber.txt2"] = {
		varname = "txt2",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["txtTimeNumber.txtTime"] = {
		varname = "txtTime",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	upList = {
		varname = "upList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("cardAttrs"),
				item = bindHelper.self("attrTmp"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = ui.ATTR_ICON[arg_1_3]

					arg_1_1:get("imgIcon"):texture(var_1_0)
				end
			}
		}
	}
}

function var_0_1.initModel(arg_2_0)
	arg_2_0.cards = gGameModel.role:read("cards")
	arg_2_0.cardCapacity = gGameModel.role:read("card_capacity")
	arg_2_0.captureNumber = gGameModel.role:getIdler("items")
	arg_2_0.gold = gGameModel.role:getIdler("gold")
	arg_2_0.level = gGameModel.role:getIdler("level")
	arg_2_0.limitSprites = gGameModel.capture:getIdler("limit_sprites")
end

function var_0_1.onCreate(arg_3_0, arg_3_1)
	arg_3_0.item = arg_3_1.node
	arg_3_0.tabId = arg_3_1.captureID
	arg_3_0.captureData = arg_3_1.captureData
	arg_3_0.limitData = arg_3_1.limitData

	arg_3_0:initModel()

	arg_3_0.cardAttrs = idlertable.new({})

	local var_3_0 = arg_3_1.captureData.cardID
	local var_3_1 = csv.unit[csv.cards[var_3_0].unitID]

	if arg_3_0.limitData then
		arg_3_0.txtTimeNumber:show()
		idlereasy.when(arg_3_0.limitSprites, function(arg_4_0, arg_4_1)
			for iter_4_0, iter_4_1 in pairs(arg_4_1) do
				if arg_3_0.tabId == iter_4_0 - 1 then
					arg_3_0.totalTimes = csv.capture.sprite[arg_3_0.limitData.csv_id].totalTimes

					arg_3_0.txtNumber:text(arg_3_0.totalTimes - iter_4_1.total_times .. "/" .. arg_3_0.totalTimes)

					arg_3_0.limitData = iter_4_1
				end
			end
		end)

		local function var_3_2()
			local var_5_0 = arg_3_0.limitData.find_time + csv.capture.sprite[arg_3_0.limitData.csv_id].time
			local var_5_1 = time.getCutDown(var_5_0 - time.getTime())

			arg_3_0.txtTime:text(var_5_1.str)
			arg_3_0.txt2:x(arg_3_0.txtTime:x() - arg_3_0.txtTime:size().width - 10)

			if var_5_0 - time.getTime() <= 0 then
				arg_3_0:onClose()

				return false
			end

			return true
		end

		arg_3_0:enableSchedule()
		arg_3_0:schedule(function(arg_6_0)
			return var_3_2()
		end, 1, 0)
	else
		arg_3_0.txtTimeNumber:hide()
	end

	local var_3_3 = var_3_1.scale * gCommonConfigCsv.captureSprite

	widget.addAnimation(arg_3_0.animain, var_3_1.unitRes, "standby_loop", 5):alignCenter(arg_3_0.animain:size()):scale(var_3_3):setSkin(var_3_1.skin)
	arg_3_0.animain:y(arg_3_0.animain:y() - 180)

	local var_3_4 = {}

	table.insert(var_3_4, var_3_1.natureType)

	if var_3_1.natureType2 then
		table.insert(var_3_4, var_3_1.natureType2)
	end

	arg_3_0.cardAttrs:set(var_3_4)
	arg_3_0.titleName:get("name"):text(csv.cards[var_3_0].name)
	arg_3_0.titleName:get("iconLeft"):texture(ui.RARITY_ICON[var_3_1.rarity])
	Dialog.onCreate(arg_3_0)
end

function var_0_1.captureMenuBtn(arg_7_0)
	local var_7_0 = {
		cardId = arg_7_0.captureData.cardID
	}

	gGameUI:stackUI("city.handbook.view", nil, nil, var_7_0)
end

function var_0_1.onCaptureBtnClick(arg_8_0)
	arg_8_0:initModel()

	if arg_8_0.captureData.type == 2 and arg_8_0.totalTimes == arg_8_0.limitData.total_times then
		gGameUI:showTip(gLanguageCsv.captureSceneTimesNotEnough)

		return
	end

	if arg_8_0.cardCapacity - itertools.size(arg_8_0.cards) <= 0 then
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

	local var_8_0 = 0

	for iter_8_0, iter_8_1 in pairs(var_0_0) do
		if not arg_8_0.captureNumber:read()[var_0_0[iter_8_0]] or arg_8_0.captureNumber:read()[var_0_0[iter_8_0]] <= 0 then
			var_8_0 = var_8_0 + 1
		end
	end

	if var_8_0 == 3 then
		gGameUI:showTip(gLanguageCsv.captureBallNotEnough)

		local var_8_1 = csv.items[var_0_0.normal].specialArgsMap.buy_gold
		local var_8_2 = 100

		gGameUI:stackUI("common.buy_info", nil, nil, {
			gold = var_8_1
		}, {
			id = var_0_0.normal
		}, {
			contentType = "num",
			maxNum = var_8_2
		}, arg_8_0:createHandler("showBuyInfo"))

		return
	end

	gGameApp:requestServer("/game/capture/enter", function(arg_10_0)
		gGameUI:stackUI("city.capture.capture_sprite", nil, nil, arg_8_0.captureData, arg_8_0.tabId, arg_8_0:createHandler("captureReturnBtnView"))
	end, arg_8_0.captureData.type, arg_8_0.tabId)
end

function var_0_1.showBuyInfo(arg_11_0, arg_11_1)
	if csv.items[var_0_0.normal].specialArgsMap.buy_level > arg_11_0.level:read() then
		gGameUI:showTip(gLanguageCsv.buyItemLevelLimit)

		return
	else
		gGameApp:requestServer("/game/ball/buy_item", function(arg_12_0)
			gGameUI:showTip(gLanguageCsv.hasBuy)
		end, var_0_0.normal, arg_11_1)
	end
end

function var_0_1.captureReturnBtnView(arg_13_0, arg_13_1)
	if arg_13_0.item and not arg_13_1 then
		arg_13_0.item:removeFromParent()
	end

	arg_13_0:onCloseFast()
end

return var_0_1
