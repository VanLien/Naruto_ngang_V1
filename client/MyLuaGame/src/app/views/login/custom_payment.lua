local var_0_0 = ""
local var_0_1 = ""
local var_0_2 = "0"
local var_0_3 = "#"
local var_0_4 = "#"
local var_0_5 = {
	HISTORY = 4,
	MOMO = 3,
	BANK = 2,
	CARD = 1
}
local var_0_6 = {
	"cardPanel",
	"momoPanel",
	"bankPanel",
	"historyPanel"
}
local var_0_7 = {
	"battle_fighting_point",
	"last_time",
	"level"
}
local var_0_8 = {
	gLanguageCsv.whereMyFriend,
	gLanguageCsv.noOneApply,
	[4] = "Bạn chưa nạp tiền vào game ^^"
}
local var_0_9 = {
	UNSHOW = 0,
	SHOW_SENIRO = 2,
	SHOW_REUNION = 1
}

local function var_0_10(arg_1_0)
	return tostring(arg_1_0):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

local var_0_11 = cc.load("mvc").ViewBase
local var_0_12 = class("PaymentView", Dialog)

var_0_12.RESOURCE_FILENAME = "custom_payment.json"
var_0_12.RESOURCE_BINDING = {
	leftItem = "leftItem",
	["leftPanel.panel.duckPanel"] = "duckPanel",
	["leftPanel.panel.cardPanel"] = "cardPanel",
	["leftPanel.panel.bankPanel"] = "bankPanel",
	["leftPanel.panel.momoPanel.stk.txt"] = "stkMomo",
	["leftPanel.panel.bankPanel.stk.txt"] = "stkBank",
	["leftPanel.panel.item2"] = "itemProvider",
	["leftPanel.panel.historyPanel"] = "historyPanel",
	["leftPanel.panel"] = "leftPanel",
	["leftPanel.panel.bankPanel.txt_host_name"] = "txt_bank_host_name",
	["leftPanel.panel.momoPanel"] = "momoPanel",
	["leftPanel.panel.duckPanel.txt"] = "iconText",
	["leftPanel.panel.momoPanel.txt_host_name"] = "txt_momo_host_name",
	["leftPanel.panel.bankPanel.description"] = "bank_description",
	["leftPanel.panel.item1"] = "itemHistory",
	["leftPanel.panel.bankPanel.img"] = "bank_icon",
	["leftPanel.panel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["leftPanel.panel.cardPanel.btnPayment"] = {
		varname = "btnPayment",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSubmitPaymentClick")
			}
		}
	},
	["leftPanel.panel.cardPanel.btnPayment.txt"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["leftPanel.panel.cardPanel.pin.nameInput"] = {
		varname = "pinInput",
		binds = {
			event = "text",
			method = function(arg_2_0)
				return
			end
		}
	},
	["leftPanel.panel.cardPanel.serial.nameInput"] = {
		varname = "serialInput",
		binds = {
			event = "text",
			method = function(arg_3_0)
				return
			end
		}
	},
	["leftPanel.panel.cardPanel.pin.btnDelete"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPinDeleteClick")
			}
		}
	},
	["leftPanel.panel.cardPanel.pin.btnPaste"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPinPasteClick")
			}
		}
	},
	["leftPanel.panel.cardPanel.serial.btnDelete"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSerialDeleteClick")
			}
		}
	},
	["leftPanel.panel.cardPanel.serial.btnPaste"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSerialPasteClick")
			}
		}
	},
	["leftPanel.panel.leftList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				padding = 5,
				data = bindHelper.self("btnsAttr"),
				item = bindHelper.self("leftItem"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:get("normal")
					local var_4_1 = arg_4_1:get("selected")

					if arg_4_2 < 3 then
						local var_4_2 = {
							class = "red_hint",
							props = {
								state = arg_4_3.select ~= true,
								specialTag = arg_4_2 == 1 and "friendStaminaRecv" or "friendReqs",
								onNode = function(arg_5_0)
									arg_5_0:xy(50, 255)
								end
							}
						}

						bind.extend(arg_4_0, var_4_0, var_4_2)
					end

					local var_4_3

					if arg_4_3.select then
						var_4_0:hide()

						var_4_3 = var_4_1:show()

						var_4_3:get("txt"):getVirtualRenderer():setLineSpacing(-10)
					else
						var_4_1:hide()

						var_4_3 = var_4_0:show()

						var_4_3:get("txt"):getVirtualRenderer():setLineSpacing(-10)
					end

					local var_4_4 = var_4_3:size().height - 40

					adapt.setAutoText(var_4_3:get("txt"), arg_4_3.name, var_4_4)
					var_4_1:setTouchEnabled(false)
					bind.touch(arg_4_0, var_4_0, {
						methods = {
							ended = functools.partial(arg_4_0.clickCell, arg_4_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onLeftButtonClick")
			}
		}
	},
	["leftPanel.panel.bankPanel.comment.txt"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("account", "name"),
			method = function(arg_6_0)
				var_0_0 = arg_6_0

				return string.format("THOIDAI %s", arg_6_0)
			end
		}
	},
	["leftPanel.panel.momoPanel.comment.txt"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("account", "name"),
			method = function(arg_7_0)
				var_0_0 = arg_7_0

				return string.format("THOIDAI %s", arg_7_0)
			end
		}
	},
	["leftPanel.panel.cardPanel.list"] = {
		varname = "providerList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 8,
				data = bindHelper.self("listData"),
				item = bindHelper.self("itemProvider"),
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					local var_8_0 = arg_8_1:multiget("name", "check")

					var_8_0.name:text(arg_8_3.name)
					var_8_0.check:setSelectedState(arg_8_3.selected)
					bind.touch(arg_8_0, arg_8_1, {
						methods = {
							ended = functools.partial(arg_8_0.chooseProvider, arg_8_2, arg_8_3)
						}
					})
				end,
				onBeforeBuild = function(arg_9_0)
					return
				end
			},
			handlers = {
				chooseProvider = bindHelper.self("onChooseProvider")
			}
		}
	},
	["leftPanel.panel.cardPanel.money"] = {
		varname = "moneyList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 8,
				data = bindHelper.self("listMoney"),
				item = bindHelper.self("itemProvider"),
				onItem = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
					local var_10_0 = arg_10_1:multiget("name", "check")

					var_10_0.name:text(var_0_10(arg_10_3.name))
					var_10_0.check:setSelectedState(arg_10_3.selected)
					bind.touch(arg_10_0, arg_10_1, {
						methods = {
							ended = functools.partial(arg_10_0.chooseMoney, arg_10_2, arg_10_3)
						}
					})
				end,
				onBeforeBuild = function(arg_11_0)
					return
				end
			},
			handlers = {
				chooseMoney = bindHelper.self("onChooseMoney")
			}
		}
	},
	["leftPanel.panel.momoPanel.stk.btnCopy"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCopyMomoAccount")
			}
		}
	},
	["leftPanel.panel.bankPanel.stk.btnCopy"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCopyBankAccount")
			}
		}
	},
	["leftPanel.panel.bankPanel.comment.btnCopy"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCopyComment")
			}
		}
	},
	["leftPanel.panel.momoPanel.comment.btnCopy"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCopyComment")
			}
		}
	},
	["leftPanel.panel.historyPanel.list"] = {
		varname = "historyList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 8,
				asyncPreload = 1,
				data = bindHelper.self("listHistory"),
				item = bindHelper.self("itemHistory"),
				onItem = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
					local var_12_0 = arg_12_1:multiget("type", "provider", "money", "created_at")

					var_12_0.type:text(arg_12_2)
					var_12_0.provider:text(arg_12_3.provider)
					var_12_0.money:text(var_0_10(arg_12_3.money))
					var_12_0.created_at:text(arg_12_3.created_at)
				end
			},
			handlers = {}
		}
	},
	["leftPanel.panel.historyPanel.name"] = {
		varname = "paymentName",
		binds = {
			event = "text",
			idler = bindHelper.model("account", "name"),
			method = function(arg_13_0)
				var_0_1 = arg_13_0

				return string.format(arg_13_0)
			end
		}
	},
	["leftPanel.panel.historyPanel.payid"] = {
		varname = "payId",
		binds = {
			event = "text",
			idler = bindHelper.model("account", "pay_id"),
			method = function(arg_14_0)
				return string.format(arg_14_0)
			end
		}
	},
	["leftPanel.panel.historyPanel.money"] = {
		varname = "totalMoney",
		binds = {
			event = "text",
			idler = bindHelper.model("account", "money"),
			method = function(arg_15_0)
				if money == nill then
					arg_15_0 = 0
				end

				return string.format(" %s 元宝 [NB]", var_0_10(arg_15_0))
			end
		}
	}
}

local var_0_13 = {}

function var_0_12.onCleanup(arg_16_0)
	arg_16_0._showType = arg_16_0.leftButtonTab:read()
	arg_16_0._data = arg_16_0.datas[arg_16_0._showType]

	var_0_11.onCleanup(arg_16_0)
end

function var_0_12.onClose(arg_17_0)
	var_0_11.onClose(arg_17_0)
end

local var_0_14 = false

function var_0_12.onSyncConfig(arg_18_0, arg_18_1)
	gGameApp.net:sendHttpRequest("POST", PAYMENT_CONFIG, "", cc.XMLHTTPREQUEST_RESPONSE_STRING, function(arg_19_0)
		if arg_19_0.status == 200 then
			local var_19_0 = json.decode(arg_19_0.response)

			if var_19_0.code == 0 then
				if arg_18_1 ~= nil then
					arg_18_1(1, var_19_0.message)
				end
			elseif arg_18_1 ~= nil then
				arg_18_1(-1, {})
			end
		else
			gGameUI:showTip("网络不稳定，请联系网络提供商")
		end
	end)
end

local var_0_15

function var_0_12.onCreate(arg_20_0, arg_20_1, arg_20_2)
	var_0_15 = nil
	arg_20_0.listHistory = arg_20_0.listHistory or idlers.newWithMap({})

	arg_20_0:syncPayHis()
	arg_20_0.stkBank:text(var_0_4)
	arg_20_0.stkMomo:text(var_0_3)

	arg_20_0.datas = {}
	arg_20_1 = arg_20_0._showType or arg_20_1

	if arg_20_1 == nil then
		arg_20_0._showType = arg_20_0.initPaymentShowType()
		arg_20_1 = arg_20_0.initPaymentShowType()
	end

	arg_20_0.originX = arg_20_0.leftPanel:x()

	arg_20_0.pinInput:setPlaceHolderColor(ui.COLORS.DISABLED.KHAKI)
	arg_20_0.pinInput:setPlaceHolder("输入刮刮卡序列码")
	arg_20_0.pinInput:setTextColor(ui.COLORS.NORMAL.DEFAULT)
	arg_20_0.serialInput:setPlaceHolderColor(ui.COLORS.DISABLED.KHAKI)
	arg_20_0.serialInput:setPlaceHolder("输入刮刮卡序列")
	arg_20_0.serialInput:setTextColor(ui.COLORS.NORMAL.DEFAULT)
	arg_20_0.pinInput:setCursorEnabled(true)
	arg_20_0.serialInput:setCursorEnabled(true)

	local var_20_0 = {
		{
			enter = false,
			name = "CARD"
		},
		{
			enter = false,
			name = "BANK +50%"
		},
		{
			enter = false,
			name = "MOMO +25%"
		},
		{
			enter = false,
			name = "历史"
		}
	}

	var_20_0[1].enter = true
	arg_20_0.btnsAttr = idlers.newWithMap(var_20_0)

	local var_20_1 = {}
	local var_20_2 = 1
	local var_20_3 = {
		"Viettel",
		"Mobiphone",
		"Vinaphone"
	}

	for iter_20_0, iter_20_1 in ipairs(var_20_3) do
		table.insert(var_20_1, {
			name = iter_20_1,
			selected = var_20_2 == iter_20_0
		})
	end

	arg_20_0.listData = idlers.newWithMap(var_20_1)

	local var_20_4 = {}
	local var_20_5 = 1
	local var_20_6 = {
		20000,
		50000,
		100000,
		200000,
		500000,
		1000000
	}

	for iter_20_2, iter_20_3 in ipairs(var_20_6) do
		table.insert(var_20_4, {
			name = iter_20_3,
			selected = var_20_5 == iter_20_2
		})
	end

	arg_20_0.listMoney = idlers.newWithMap(var_20_4)
	arg_20_0.leftButtonTab = idler.new(2)

	arg_20_0:composeData(arg_20_1, arg_20_0._data or arg_20_2)

	arg_20_0.firstEnter = true

	arg_20_0.leftButtonTab:addListener(function(arg_21_0, arg_21_1, arg_21_2)
		arg_20_0.btnsAttr:atproxy(arg_21_1).select = false
		arg_20_0.btnsAttr:atproxy(arg_21_0).select = true

		if not arg_20_0.btnsAttr:atproxy(arg_21_0).enter then
			arg_20_0:changeTab(arg_21_0)

			arg_20_0.btnsAttr:atproxy(arg_21_0).enter = true
		else
			arg_20_0:changeTagShow(arg_21_0)
		end
	end)
	Dialog.onCreate(arg_20_0)
end

function var_0_12.onChooseProvider(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	for iter_22_0, iter_22_1 in arg_22_0.listData:pairs() do
		iter_22_1:proxy().selected = iter_22_0 == arg_22_2
	end
end

function var_0_12.onChooseMoney(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	for iter_23_0, iter_23_1 in arg_23_0.listMoney:pairs() do
		iter_23_1:proxy().selected = iter_23_0 == arg_23_2
	end
end

function var_0_12.changeTagShow(arg_24_0, arg_24_1)
	arg_24_0.cardPanel:visible(arg_24_1 == var_0_5.CARD)
	arg_24_0.bankPanel:visible(arg_24_1 == var_0_5.BANK)
	arg_24_0.momoPanel:visible(arg_24_1 == var_0_5.MOMO)
	arg_24_0.historyPanel:visible(arg_24_1 == var_0_5.HISTORY)
	arg_24_0.leftPanel:x(arg_24_0.originX)

	if arg_24_1 == var_0_5.HISTORY then
		arg_24_0:syncPayHis()
	end

	idlereasy.do_(function(arg_25_0)
		local var_25_0 = arg_24_1 == 4 and #arg_25_0 == 0

		if arg_24_1 == var_0_5.HISTORY and var_25_0 then
			arg_24_0.duckPanel:hide()
		else
			arg_24_0.duckPanel:hide()
		end
	end, arg_24_0.listHistory)

	if arg_24_1 ~= var_0_5.HISTORY then
		if var_0_15 == nil then
			arg_24_0:onSyncConfig(function(arg_26_0, arg_26_1)
				local var_26_0 = {}

				for iter_26_0, iter_26_1 in ipairs(arg_26_1) do
					local var_26_1 = {
						name = iter_26_1.name,
						status = iter_26_1.status,
						host_name = iter_26_1.host_name,
						host_number = iter_26_1.host_number,
						comment = iter_26_1.comment,
						type = iter_26_1.type,
						icon = iter_26_1.icon,
						description = iter_26_1.description
					}

					if iter_26_1.type == 2 then
						if var_26_0[iter_26_1.type] == nil then
							var_26_0[iter_26_1.type] = {}
						end

						table.insert(var_26_0[iter_26_1.type], var_26_1)
					elseif iter_26_1.type == 1 then
						if var_26_0[iter_26_1.type] == nil then
							var_26_0[iter_26_1.type] = {}
						end

						table.insert(var_26_0[iter_26_1.type], var_26_1)
					else
						var_26_0[iter_26_1.type] = var_26_1
					end
				end

				var_0_15 = var_26_0

				arg_24_0:HandlerShowTab(arg_24_1)
			end)
		else
			arg_24_0:HandlerShowTab(arg_24_1)
		end
	end
end

function var_0_12.HandlerShowTab(arg_27_0, arg_27_1)
	local var_27_0 = "未更新"
	local var_27_1 = "未更新"

	if var_0_15[1] ~= nil then
		var_27_0 = var_0_15[1].host_number or "未更新"
	end

	if var_0_15[2] ~= nil then
		var_27_1 = var_0_15[2].host_number or "未更新"
	end

	arg_27_0.stkMomo:text(var_27_0)
	arg_27_0.stkBank:text(var_27_1)
	arg_27_0.duckPanel:visible(false)
	arg_27_0.iconText:text("系统正在维护中")
	arg_27_0.cardPanel:visible(false)
	arg_27_0.bankPanel:visible(false)

	if arg_27_1 == var_0_5.MOMO then
		local var_27_2
		local var_27_3
		local var_27_4
		local var_27_5

		for iter_27_0, iter_27_1 in ipairs(var_0_15[1]) do
			if iter_27_1.status == 1 then
				var_27_2 = iter_27_1.host_name
				var_27_3 = iter_27_1.host_number

				local var_27_6 = iter_27_1.icon
				local var_27_7 = iter_27_1.description
			end
		end

		if var_27_2 == nil then
			arg_27_0.momoPanel:visible(false)
			arg_27_0.duckPanel:visible(var_0_15[2].status ~= 1)
			arg_27_0.iconText:text("MOMO đang bảo trì")
		else
			arg_27_0.momoPanel:visible(true)
			arg_27_0.txt_momo_host_name:setText(var_27_2)
			arg_27_0.stkMomo:text(var_27_3)
		end
	end

	if arg_27_1 == var_0_5.BANK then
		local var_27_8
		local var_27_9
		local var_27_10
		local var_27_11

		for iter_27_2, iter_27_3 in ipairs(var_0_15[2]) do
			if iter_27_3.status == 1 then
				var_27_8 = iter_27_3.host_name
				var_27_9 = iter_27_3.host_number
				var_27_10 = iter_27_3.icon
				var_27_11 = iter_27_3.description
			end
		end

		if var_27_8 == nil then
			arg_27_0.bankPanel:visible(false)
			arg_27_0.duckPanel:visible(var_0_15[2].status ~= 1)
			arg_27_0.iconText:text("银行正在维护")
		else
			arg_27_0.bankPanel:visible(true)
			arg_27_0.bank_icon:texture("payment/" .. var_27_10):show()
			arg_27_0.bank_description:text("银行转账 " .. var_27_11)
			arg_27_0.txt_bank_host_name:setText(var_27_8)
			arg_27_0.stkBank:text(var_27_9)
		end
	end

	if arg_27_1 == var_0_5.CARD then
		arg_27_0.cardPanel:visible(var_0_15[3].status == 1)
		arg_27_0.duckPanel:visible(var_0_15[3].status ~= 1)
		arg_27_0.iconText:text("卡正在维护中")
	end
end

function var_0_12.composeData(arg_28_0, arg_28_1, arg_28_2)
	arg_28_2 = arg_28_2 or arg_28_0.datas[arg_28_1]

	arg_28_0:changeTagShow(arg_28_0.leftButtonTab:read())
end

function var_0_12.onPinDeleteClick(arg_29_0)
	print("onPinDeleteClick")
	arg_29_0.pinInput:setText("")
end

function var_0_12.onSerialDeleteClick(arg_30_0)
	print("onSerialDeleteClick")
	arg_30_0.serialInput:setText("")
end

function var_0_12.changeTab(arg_31_0, arg_31_1)
	if arg_31_1 == var_0_5.CARD then
		arg_31_0.firstEnter = false
	elseif arg_31_1 == var_0_5.BANK then
		arg_31_0.firstEnter = false
	elseif arg_31_1 == var_0_5.MOMO then
		arg_31_0.firstEnter = false
	else
		arg_31_0.firstEnter = false
	end

	arg_31_0:changeTagShow(arg_31_1)
end

function var_0_12.sendProtocolCountDown(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	return
end

function var_0_12.onResetRightPanel(arg_33_0)
	arg_33_0.myShowFriend:set(0)
end

function var_0_12.onLeftButtonClick(arg_34_0, arg_34_1, arg_34_2)
	arg_34_0.leftButtonTab:set(arg_34_2)
end

function var_0_12.initPaymentShowType(arg_35_0)
	return var_0_5.BANK
end

function var_0_12.onCopyMomoAccount(arg_36_0)
	local var_36_0 = arg_36_0.stkMomo:getString()
	local var_36_1 = cc.Application:getInstance():getTargetPlatform()

	local function var_36_2(arg_37_0, arg_37_1)
		if arg_37_0 == 0 then
			gGameUI:showTip("复制账号")
		else
			gGameUI:showTip("无法复制账号")
		end
	end

	if cc.PLATFORM_OS_WINDOWS == var_36_1 then
		-- block empty
	else
		sdk.callPlatformFunc("copyToClipboard", var_36_0, function(arg_38_0)
			if arg_38_0 == "error" then
				var_36_2(-1, "copyToClipboard " .. arg_38_0)
			elseif arg_38_0 == "cancel" then
				var_36_2(-1, "copyToClipboard " .. arg_38_0)
			else
				var_36_2(0, "copyToClipboard " .. arg_38_0)
			end
		end)
	end
end

function var_0_12.onCopyBankAccount(arg_39_0)
	local var_39_0 = arg_39_0.stkBank:getString()
	local var_39_1 = cc.Application:getInstance():getTargetPlatform()

	local function var_39_2(arg_40_0, arg_40_1)
		if arg_40_0 == 0 then
			gGameUI:showTip("将[账号]复制到内存中")
		else
			gGameUI:showTip("无法将[账号]复制到内存中")
		end
	end

	if cc.PLATFORM_OS_WINDOWS == var_39_1 then
		-- block empty
	else
		sdk.callPlatformFunc("copyToClipboard", var_39_0, function(arg_41_0)
			if arg_41_0 == "error" then
				var_39_2(-1, "copyToClipboard " .. arg_41_0)
			elseif arg_41_0 == "cancel" then
				var_39_2(-1, "copyToClipboard " .. arg_41_0)
			else
				var_39_2(0, "copyToClipboard " .. arg_41_0)
			end
		end)
	end
end

function var_0_12.onCopyComment(arg_42_0)
	local var_42_0 = "THOIDAI " .. var_0_0
	local var_42_1 = cc.Application:getInstance():getTargetPlatform()

	local function var_42_2(arg_43_0, arg_43_1)
		if arg_43_0 == 0 then
			gGameUI:showTip("已将[转账内容]复制到内存中")
		else
			gGameUI:showTip("无法将[传输内容]复制到内存中")
		end
	end

	if cc.PLATFORM_OS_WINDOWS == var_42_1 then
		-- block empty
	else
		sdk.callPlatformFunc("copyToClipboard", var_42_0, function(arg_44_0)
			if arg_44_0 == "error" then
				var_42_2(-1, "copyToClipboard " .. arg_44_0)
			elseif arg_44_0 == "cancel" then
				var_42_2(-1, "copyToClipboard " .. arg_44_0)
			else
				var_42_2(0, "copyToClipboard " .. arg_44_0)
			end
		end)
	end
end

function var_0_12.onPinPasteClick(arg_45_0)
	local var_45_0 = "THOIDAI " .. var_0_0
end

function var_0_12.onSerialPasteClick(arg_46_0)
	local var_46_0 = "THOIDAI " .. var_0_0
end

function var_0_12.cb(arg_47_0, arg_47_1)
	return
end

function var_0_12.onSubmitPaymentClick(arg_48_0)
	local var_48_0 = ""
	local var_48_1 = ""
	local var_48_2 = ""
	local var_48_3 = ""

	for iter_48_0, iter_48_1 in arg_48_0.listData:pairs() do
		if iter_48_1:proxy().selected then
			var_48_0 = iter_48_0
		end
	end

	for iter_48_2, iter_48_3 in arg_48_0.listMoney:pairs() do
		local var_48_4 = iter_48_3:proxy()

		if var_48_4.selected then
			var_48_3 = var_48_4.name
		end
	end

	local var_48_5 = arg_48_0.serialInput:getString()
	local var_48_6 = arg_48_0.pinInput:getString()

	if var_48_5 == nil or var_48_5.length == 0 or var_48_6 == nil or var_48_6.length == 0 then
		gGameUI:showDialog({
			title = "发生了错误",
			content = "请输入您的完整信息",
			dialogParams = {
				clickClose = true
			}
		})

		return
	end

	arg_48_0.pinInput:setString("")
	arg_48_0.serialInput:setString("")

	local var_48_7 = string.format("account=%s&provider=%d&serial=%s&pin=%s&money=%d&", var_0_1, tonumber(var_48_0), var_48_5, var_48_6, var_48_3)

	gGameApp.net:sendHttpRequest("POST", CARD_CFG, var_48_7, cc.XMLHTTPREQUEST_RESPONSE_STRING, function(arg_49_0)
		if arg_49_0.status == 200 then
			local var_49_0 = json.decode(arg_49_0.response)

			if var_49_0.code == 0 then
				gGameUI:showTip("卡加载成功!")
				arg_48_0:syncPayHis()
				arg_48_0.cb(0)
			elseif var_49_0.code == -300 then
				gGameUI:showTip("卡信息不能为空!")
				arg_48_0.cb(-1)
			elseif var_49_0.code == -100 then
				gGameUI:showTip("此卡已加载，如果您有任何错误，请联系管理员")
				arg_48_0.cb(-1)
			elseif var_49_0.code == -2100 then
				gGameUI:showTip("卡代码或序列号无效，请检查并重试")
				arg_48_0.cb(-1)
			else
				gGameUI:showTip("卡加载失败，卡信息错误!")
				arg_48_0.cb(-1)
			end
		else
			gGameUI:showTip("卡加载失败，请重试!")
			arg_48_0.cb(-1)
		end
	end)
end

function var_0_12.syncPayHis(arg_50_0)
	gGameApp:getPayhistory():SyncData(var_0_1, function(arg_51_0, arg_51_1, arg_51_2)
		if arg_51_0 then
			local var_51_0 = {}

			for iter_51_0, iter_51_1 in ipairs(arg_51_1) do
				table.insert(var_51_0, {
					type = iter_51_0,
					provider = iter_51_1.provider,
					money = iter_51_1.money,
					created_at = iter_51_1.created_at
				})
			end

			arg_50_0.listHistory = arg_50_0.listHistory or idlers.newWithMap(var_51_0)

			arg_50_0.listHistory:update(arg_51_1)

			local var_51_1 = NUMBER_FORMAT(arg_51_2)

			arg_50_0.totalMoney:text(var_51_1 .. " Nguyên bảo [NB]")
		end
	end)
end

return var_0_12
