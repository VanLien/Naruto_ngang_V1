local var_0_0 = {
	ready = "/game/ready/card/rename",
	role = "/game/role/rename",
	plan = "/game/chip/plan/edit",
	union = "/game/union/rename",
	card = "/game/card/rename"
}
local var_0_1 = class("CardChangeNameView", Dialog)

var_0_1.RESOURCE_FILENAME = "card_changename.json"
var_0_1.RESOURCE_BINDING = {
	diamondImg = "diamondImg",
	titleTxt = "titleTxt",
	diamondTxt = "diamondTxt",
	bg = "bg",
	nameField = "nameField",
	diamondNum = "diamondNum",
	["bg.nameBg"] = "nameBg",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	cancelBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	sureBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSureClick")
			}
		}
	},
	txt = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = ui.COLORS.OUTLINE.DEFAULT
					}
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("showCenterTxt")
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	arg_1_0:initModel()

	arg_1_0.params = arg_1_1
	arg_1_0.curName = arg_1_1.name
	arg_1_0.textWidth = arg_1_1.maxFontCount and math.min(arg_1_1.maxFontCount * 40, 300) or 300

	arg_1_0.titleTxt:text(arg_1_1.titleTxt)
	text.addEffect(arg_1_0.titleTxt, {
		color = ui.NEWCOLORS.OUTLINE.BLACK,
		outline = {
			color = ui.NEWCOLORS.OUTLINE.WHITE
		}
	})
	arg_1_0.nameField:setPlaceHolderColor(ui.NEWCOLORS.GRAY3)
	arg_1_0.nameField:setTextColor(ui.NEWCOLORS.WHITE)
	arg_1_0.nameField:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)

	if arg_1_0.params.typ == "ready" or not arg_1_1.cost then
		arg_1_0.diamondTxt:visible(false)
		arg_1_0.diamondNum:visible(false)
		arg_1_0.diamondImg:visible(false)
		arg_1_0:addListener(arg_1_0.nameField, functools.partial(arg_1_0.nameAdapt, arg_1_0))
		arg_1_0.nameBg:y(arg_1_0.nameBg:y() - 60)
		arg_1_0.nameField:y(arg_1_0.nameField:y() - 60)
	else
		blacklist:addListener(arg_1_0.nameField, nil, functools.partial(arg_1_0.nameAdapt, arg_1_0))
		arg_1_0.diamondNum:text(arg_1_1.cost)
		idlereasy.when(gGameModel.role:getIdler("rmb"), function(arg_2_0, arg_2_1)
			arg_1_0.diamondNum:setTextColor(arg_1_1.cost > 0 and arg_2_1 < arg_1_1.cost and ui.COLORS.NORMAL.RED or ui.NEWCOLORS.BROWN1)
		end)
		adapt.oneLinePos(arg_1_0.diamondNum, arg_1_0.diamondImg, cc.p(5, 0))
	end

	Dialog.onCreate(arg_1_0, {
		clickClose = false
	})
end

function var_0_1.initModel(arg_3_0)
	arg_3_0.rmb = gGameModel.role:getIdler("rmb")
	arg_3_0.renameCount = gGameModel.role:getIdler("rename_count")
end

function var_0_1.nameAdapt(arg_4_0, arg_4_1)
	arg_4_1 = arg_4_1 or arg_4_0.nameField:text()

	local var_4_0 = beauty.singleTextLimitWord(arg_4_1, {
		fontSize = 40
	}, {
		onlyText = true,
		replaceStr = "",
		width = arg_4_0.textWidth
	})

	arg_4_0.nameField:text(var_4_0)
end

function var_0_1.onSureClick(arg_5_0)
	arg_5_0:nameAdapt()

	local var_5_0 = arg_5_0.nameField:text()
	local var_5_1 = {
		name = arg_5_0.curName,
		cost = arg_5_0.params.cost,
		noBlackList = arg_5_0.params.noBlackList
	}

	if arg_5_0.params.typ == "ready" then
		var_5_1 = {
			noBlackList = true,
			name = arg_5_0.curName,
			cost = arg_5_0.params.cost
		}
	end

	if uiEasy.checkText(var_5_0, var_5_1) and (not arg_5_0.params.customCheck or arg_5_0.params.customCheck(var_5_0)) then
		local function var_5_2()
			local var_6_0 = arg_5_0.params.requestParams or {}

			if not arg_5_0.params.requestParamsCount then
				table.insert(var_6_0, var_5_0)
			else
				var_6_0[arg_5_0.params.requestParamsCount + 1] = var_5_0
			end

			gGameApp:requestServer(var_0_0[arg_5_0.params.typ], function(arg_7_0)
				local var_7_0 = arg_5_0.params.cb

				arg_5_0:onClose()

				if arg_5_0.params.typ == "role" then
					sdk.commitRoleInfo(8, function()
						print("sdk commitRoleInfo CardChangeName")
					end)
				end

				if var_7_0 then
					var_7_0(arg_5_0.nameField:text())
				end
			end, unpack(var_6_0, 1, table.maxn(var_6_0)))
		end

		if arg_5_0.params.cost and arg_5_0.params.cost > 0 then
			dataEasy.sureUsingDiamonds(var_5_2, arg_5_0.params.cost)
		else
			var_5_2()
		end
	end
end

local function var_0_2(arg_9_0)
	if arg_9_0 == ccui.TextFiledEventType.detach_with_ime then
		return true
	end

	if device.platform == "windows" and (arg_9_0 == ccui.TextFiledEventType.insert_text or arg_9_0 == ccui.TextFiledEventType.delete_backward) then
		return true
	end
end

function var_0_1.addListener(arg_10_0, arg_10_1, arg_10_2)
	arg_10_1:addEventListener(function(arg_11_0, arg_11_1)
		local var_11_0 = arg_10_1:text()

		if var_0_2(arg_11_1) and arg_10_2 then
			arg_10_2(var_11_0)
		end
	end)
end

return var_0_1
