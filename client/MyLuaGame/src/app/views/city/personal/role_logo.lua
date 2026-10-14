local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	for iter_1_0, iter_1_1 in arg_1_2:ipairs() do
		local var_1_0 = iter_1_1:proxy()

		if var_1_0.csvId == arg_1_1 then
			var_1_0.inUse = false
		end

		if var_1_0.csvId == arg_1_0 then
			var_1_0.inUse = true

			arg_1_3:set(iter_1_0)
		end
	end
end

local function var_0_1(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = {
		event = "extend",
		class = "role_logo",
		props = {
			vip = false,
			level = false,
			logoId = arg_2_2,
			frameId = arg_2_3,
			onNode = function(arg_3_0)
				arg_3_0:scale(arg_2_4 or 1):z(3)
			end
		}
	}

	bind.extend(arg_2_0, arg_2_1, var_2_0)
end

local function var_0_2(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	return rich.createWithWidth(arg_4_0, 40, nil, 480):anchorPoint(0.5, 0.5):xy(arg_4_1, arg_4_2):addTo(arg_4_3, 6)
end

local function var_0_3(arg_5_0)
	table.sort(arg_5_0, function(arg_6_0, arg_6_1)
		if arg_6_0.unlocked ~= arg_6_1.unlocked then
			return arg_6_0.unlocked < arg_6_1.unlocked
		end

		return arg_6_0.csvId < arg_6_1.csvId
	end)

	return arg_5_0
end

local var_0_4 = class("PersonalRoleLogoView", Dialog)

var_0_4.RESOURCE_FILENAME = "personal_role_logo.json"
var_0_4.RESOURCE_BINDING = {
	title3 = "frameTitle",
	name = "nodeName",
	subList1 = "subList1",
	itemLogo = "itemLogo",
	title2 = "logoTitle",
	itemFrame = "itemFrame",
	condition = "condition",
	subList2 = "subList2",
	logoPanel = "logoPanel",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSaveClose")
			}
		}
	},
	logo_btn = {
		varname = "logo_btn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onLogoBtn")
			}
		}
	},
	logo_frame_btn = {
		varname = "logo_frame_btn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onLogoFrameBtn")
			}
		}
	},
	logoList = {
		varname = "logoList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 25,
				columnSize = 5,
				data = bindHelper.self("logoData"),
				item = bindHelper.self("subList1"),
				cell = bindHelper.self("itemLogo"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					arg_7_1:get("locked"):visible(arg_7_3.unlocked == 2)
					arg_7_1:get("used"):visible(arg_7_3.inUse)
					arg_7_1:get("selected"):visible(arg_7_3.selectEffect or false)
					var_0_1(arg_7_0, arg_7_1, arg_7_3.csvId, false, 1.1)
					bind.click(arg_7_0, arg_7_1, {
						method = functools.partial(arg_7_0.itemClick, arg_7_0:getIdx(arg_7_2), arg_7_3)
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onLogoItemClick")
			}
		}
	},
	frameList = {
		varname = "frameList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 20,
				columnSize = 5,
				data = bindHelper.self("frameData"),
				item = bindHelper.self("subList2"),
				cell = bindHelper.self("itemFrame"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					arg_8_1:get("locked"):visible(arg_8_3.unlocked == 2)
					arg_8_1:get("used"):visible(arg_8_3.inUse)
					arg_8_1:get("selected"):visible(arg_8_3.selectEffect or false)
					var_0_1(arg_8_0, arg_8_1, false, arg_8_3.csvId, 1.15)
					bind.click(arg_8_0, arg_8_1, {
						method = functools.partial(arg_8_0.itemClick, arg_8_0:getIdx(arg_8_2), arg_8_3)
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onFrameItemClick")
			}
		}
	},
	btnSave = {
		varname = "btnSave",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSaveClick")
			}
		}
	},
	["btnSave.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	}
}

function var_0_4.onCreate(arg_9_0, arg_9_1)
	arg_9_0.cb = arg_9_1
	arg_9_0.btns = {
		arg_9_0.logo_btn,
		arg_9_0.logo_frame_btn
	}

	arg_9_0:initModel()

	arg_9_0.leftDatas = idlers.newWithMap({
		{
			name = gLanguageCsv.roleLogo
		},
		{
			name = gLanguageCsv.roleLogoFrame
		}
	})
	arg_9_0.selectFrame = idler.new(arg_9_0.frame:read())
	arg_9_0.selectLogo = idler.new(arg_9_0.logo:read())
	arg_9_0.csvIdLogo = idler.new(arg_9_0.logo:read())
	arg_9_0.csvIdFrame = idler.new(arg_9_0.frame:read())
	arg_9_0.showTab = idler.new(1)

	arg_9_0.showTab:addListener(function(arg_10_0, arg_10_1, arg_10_2)
		arg_9_0.leftDatas:atproxy(arg_10_1).select = false
		arg_9_0.leftDatas:atproxy(arg_10_0).select = true

		if arg_10_0 == 1 then
			itertools.invoke({
				arg_9_0.logoTitle,
				arg_9_0.logoList
			}, "show")
			itertools.invoke({
				arg_9_0.frameTitle,
				arg_9_0.frameList
			}, "hide")
			arg_9_0.selectLogo:set(arg_9_0.selectLogo:read(), true)
		else
			itertools.invoke({
				arg_9_0.logoTitle,
				arg_9_0.logoList
			}, "hide")
			itertools.invoke({
				arg_9_0.frameTitle,
				arg_9_0.frameList
			}, "show")
			arg_9_0.selectFrame:set(arg_9_0.selectFrame:read(), true)
		end
	end)

	arg_9_0.logoData = idlers.new()

	idlereasy.when(arg_9_0.activeLogos, function(arg_11_0, arg_11_1)
		local var_11_0 = {}

		for iter_11_0, iter_11_1 in pairs(gRoleLogoCsv) do
			local var_11_1 = arg_9_0.logo:read() == iter_11_0
			local var_11_2 = arg_11_1[iter_11_0] and 1 or 2

			table.insert(var_11_0, {
				csvId = iter_11_0,
				inUse = var_11_1,
				unlocked = var_11_2,
				cfg = iter_11_1
			})
		end

		arg_9_0.logoData:update(var_0_3(var_11_0))
	end)

	arg_9_0.frameData = idlers.new()

	idlereasy.when(arg_9_0.frames, function(arg_12_0, arg_12_1)
		local var_12_0 = {}

		for iter_12_0, iter_12_1 in pairs(gRoleFrameCsv) do
			local var_12_1 = arg_9_0.frame:read() == iter_12_0
			local var_12_2 = arg_12_1[iter_12_0] and 1 or 2

			table.insert(var_12_0, {
				csvId = iter_12_0,
				inUse = var_12_1,
				unlocked = var_12_2,
				cfg = iter_12_1
			})
		end

		arg_9_0.frameData:update(var_0_3(var_12_0))
	end)
	arg_9_0.logo:addListener(function(arg_13_0, arg_13_1)
		var_0_0(arg_13_0, arg_13_1, arg_9_0.logoData, arg_9_0.selectLogo)
	end)
	arg_9_0.frame:addListener(function(arg_14_0, arg_14_1)
		var_0_0(arg_14_0, arg_14_1, arg_9_0.frameData, arg_9_0.selectFrame)
	end)
	arg_9_0.selectFrame:addListener(function(arg_15_0, arg_15_1)
		arg_9_0:setRightPanel(arg_15_0, arg_15_1, arg_9_0.frameData)
	end)
	arg_9_0.selectLogo:addListener(function(arg_16_0, arg_16_1)
		arg_9_0:setRightPanel(arg_16_0, arg_16_1, arg_9_0.logoData)
	end)
	Dialog.onCreate(arg_9_0)
	arg_9_0:onLeftButtonClick(nil, 1)
end

function var_0_4.initModel(arg_17_0)
	arg_17_0.logo = gGameModel.role:getIdler("logo")
	arg_17_0.logos = gGameModel.role:getIdler("logos")
	arg_17_0.figures = gGameModel.role:getIdler("figures")
	arg_17_0.frame = gGameModel.role:getIdler("frame")
	arg_17_0.frames = gGameModel.role:getIdler("frames")
	arg_17_0.pokedex = gGameModel.role:getIdler("pokedex")
	arg_17_0.activeLogos = gGameModel.role:getIdler("active_logos")
end

function var_0_4.setRightPanel(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = arg_18_3:atproxy(arg_18_1)

	arg_18_0.condition:removeAllChildren()
	arg_18_0.condition:text("")

	if var_18_0.unlocked == 2 then
		local var_18_1 = var_18_0.cfg.unlockDesc

		arg_18_0.condition:text(var_18_1)

		if arg_18_0.condition:size().width > 480 then
			arg_18_0.condition:text("")
			var_0_2("#C0x5B545B#" .. var_18_1, 0, 0, arg_18_0.condition)
		end
	end

	arg_18_0.btnSave:visible(var_18_0.unlocked == 1)
	arg_18_0.nodeName:text(var_18_0.cfg.name)

	if arg_18_0.showTab:read() == 1 then
		var_0_1(arg_18_0, arg_18_0.logoPanel, var_18_0.csvId, arg_18_0.csvIdFrame:read(), 1.5)
	else
		var_0_1(arg_18_0, arg_18_0.logoPanel, arg_18_0.csvIdLogo:read(), var_18_0.csvId, 1.5)
	end

	local var_18_2 = arg_18_3:atproxy(arg_18_2)

	if var_18_2 then
		var_18_2.selectEffect = false
	end

	var_18_0.selectEffect = true
end

function var_0_4.onLeftButtonClick(arg_19_0, arg_19_1, arg_19_2)
	arg_19_0.showTab:set(arg_19_2)

	for iter_19_0, iter_19_1 in pairs(arg_19_0.btns) do
		if iter_19_0 == arg_19_2 then
			arg_19_0.btns[iter_19_0]:loadTextureNormal("common/btn/btn_lan.png")
		else
			arg_19_0.btns[iter_19_0]:loadTextureNormal("common/btn/btn_hong.png")
		end
	end
end

function var_0_4.onLogoFrameBtn(arg_20_0)
	arg_20_0:onLeftButtonClick(nil, 2)
end

function var_0_4.onLogoBtn(arg_21_0)
	arg_21_0:onLeftButtonClick(nil, 1)
end

function var_0_4.onFrameItemClick(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	arg_22_0.selectFrame:set(arg_22_2.k)
	arg_22_0.csvIdFrame:set(arg_22_3.csvId)
end

function var_0_4.onLogoItemClick(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	arg_23_0.selectLogo:set(arg_23_2.k)
	arg_23_0.csvIdLogo:set(arg_23_3.csvId)
end

function var_0_4.onSaveClick(arg_24_0)
	if arg_24_0.showTab:read() == 1 then
		local var_24_0 = arg_24_0.selectLogo:read()
		local var_24_1 = arg_24_0.logoData:atproxy(var_24_0)

		if var_24_1.unlocked == 2 then
			gGameUI:showTip(gLanguageCsv.logoNotUnlock)

			return
		end

		local var_24_2 = {}

		if arg_24_0.logo:read() == var_24_1.csvId then
			gGameUI:showTip(gLanguageCsv.logoHasBeenSaved)

			return
		end

		gGameApp:requestServer("/game/role/logo", function()
			gGameUI:showTip(gLanguageCsv.logoWasSavedSuccessfully)
		end, var_24_1.csvId)

		return
	end

	local var_24_3 = arg_24_0.selectFrame:read()
	local var_24_4 = arg_24_0.frameData:atproxy(var_24_3)

	if var_24_4.unlocked == 2 then
		gGameUI:showTip(gLanguageCsv.frameNotUnlock)

		return
	end

	if arg_24_0.frame:read() == var_24_4.csvId then
		gGameUI:showTip(gLanguageCsv.frameHasBeenSaved)

		return
	end

	gGameApp:requestServer("/game/role/frame", function()
		gGameUI:showTip(gLanguageCsv.frameWasSavedSuccessfully)
	end, var_24_4.csvId)
end

function var_0_4.onSaveClose(arg_27_0)
	local var_27_0 = arg_27_0.selectLogo:read()
	local var_27_1 = arg_27_0.logoData:atproxy(var_27_0)
	local var_27_2 = arg_27_0.selectFrame:read()
	local var_27_3 = arg_27_0.frameData:atproxy(var_27_2)
	local var_27_4 = arg_27_0.logo:read() ~= var_27_1.csvId and var_27_1.unlocked == 1

	if var_27_4 or arg_27_0.frame:read() ~= var_27_3.csvId and var_27_3.unlocked == 1 then
		local var_27_5 = var_27_4 and gLanguageCsv.changesHaveBeenDetectedLogo or gLanguageCsv.changesHaveBeenDetectedFrame

		gGameUI:showDialog({
			btnType = 2,
			content = var_27_5,
			cb = function()
				arg_27_0:onClose()
			end
		})

		return
	end

	arg_27_0:onClose()
end

function var_0_4.onChangeClick(arg_29_0, arg_29_1)
	arg_29_0.selectPage:set(arg_29_1)
end

return var_0_4
