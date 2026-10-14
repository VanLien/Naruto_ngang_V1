local var_0_0 = {
	PAGE = 1,
	DROP_DOWN = 2
}
local var_0_1 = class("LoginPlacardView", Dialog)

var_0_1.RESOURCE_FILENAME = "login_placard.json"
var_0_1.RESOURCE_BINDING = {
	["leftPanel.item"] = "leftItem",
	rightContentList = "rightContentList",
	titleItem = "titleItem",
	contentItem = "contentItem",
	topBg = "topBg",
	leftPanel = "leftPanel",
	rightList = "contentList",
	["leftPanel.leftList"] = {
		varname = "leftList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 7,
				data = bindHelper.self("areaList"),
				itemSize = bindHelper.self("leftListCount"),
				item = bindHelper.self("leftItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("normal")
					local var_1_1 = arg_1_1:get("selected")
					local var_1_2

					if arg_1_3.select then
						var_1_0:hide()

						var_1_2 = var_1_1:show()

						text.addEffect(var_1_2:get("txt"), {
							outline = {
								color = ui.COLORS.NORMAL.YELLOW
							}
						})
					else
						var_1_1:hide()

						var_1_2 = var_1_0:show()
					end

					local var_1_3 = var_1_1:size().width - 30

					adapt.setTextScaleWithWidth(var_1_2:get("txt"), arg_1_3.name, var_1_3)
					arg_1_1:onClick(functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3))
				end,
				onAfterBuild = function(arg_2_0)
					arg_2_0:setTouchEnabled(#arg_2_0.data >= arg_2_0.asyncPreload)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onChooseArea")
			}
		}
	},
	["bottomPanel.btnKnow"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlacardClose")
			}
		}
	},
	["bottomPanel.btnKnow.txt"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["bottomPanel.icon"] = {
		varname = "checkStatus",
		binds = {
			event = "click",
			method = bindHelper.self("onCheckBox")
		}
	},
	["bottomPanel.tip"] = {
		varname = "bottomTip",
		binds = {
			event = "click",
			method = bindHelper.self("onCheckBox")
		}
	}
}

local var_0_2 = {
	{
		key = "activity",
		styleType = var_0_0.DROP_DOWN,
		name = gLanguageCsv.activityBoard
	},
	{
		key = "update",
		styleType = var_0_0.PAGE,
		name = gLanguageCsv.updateContent
	},
	{
		key = "caution",
		styleType = var_0_0.PAGE,
		name = gLanguageCsv.cautionBoard
	},
	{
		key = "note1",
		styleType = var_0_0.PAGE,
		name = gLanguageCsv.note1Content
	},
	{
		key = "note2",
		styleType = var_0_0.PAGE,
		name = gLanguageCsv.note2Content
	}
}

function var_0_1.onPlacardClose(arg_3_0)
	sdk.trackEvent(18)
	Dialog.onClose(arg_3_0)
end

function var_0_1.onCreate(arg_4_0, arg_4_1)
	arg_4_1 = arg_4_1 or {}

	arg_4_0.bottomTip:setTouchEnabled(true)

	local var_4_0 = {}

	for iter_4_0, iter_4_1 in ipairs(var_0_2) do
		if arg_4_1[iter_4_1.key] then
			iter_4_1.content = arg_4_1[iter_4_1.key]

			table.insert(var_4_0, iter_4_1)
		end
	end

	arg_4_0.content = arg_4_0:getResourceNode()

	arg_4_0.topBg:hide()
	arg_4_0.contentList:setScrollBarEnabled(false)
	arg_4_0.rightContentList:setScrollBarEnabled(false)

	arg_4_0.data = var_4_0
	arg_4_0.banner = arg_4_1.banner or {}

	arg_4_0:initData()

	if #var_4_0 > 0 then
		arg_4_0.showTab = idler.new(1)

		arg_4_0.showTab:addListener(function(arg_5_0, arg_5_1, arg_5_2)
			arg_4_0.areaList:atproxy(arg_5_1).select = false
			arg_4_0.areaList:atproxy(arg_5_0).select = true

			arg_4_0:showContent(arg_4_0.data[arg_5_0])
		end)
	end

	uiEasy.addTabListClipping(arg_4_0.leftList, arg_4_0.leftPanel)

	local var_4_1 = 0

	arg_4_0.leftPanel:onClick(function()
		var_4_1 = var_4_1 + 1

		if var_4_1 ~= 10 then
			return
		end

		local var_6_0 = "img/editor/btn_1.png"
		local var_6_1 = "img/editor/btn.png"
		local var_6_2 = cc.Node:create()
		local var_6_3 = ccui.Layout:create():size(display.sizeInView):xy(-display.sizeInView.width / 2, -display.sizeInView.height / 2)

		var_6_3:setBackGroundColorType(1)
		var_6_3:setBackGroundColor(cc.c3b(91, 84, 91))
		var_6_3:setBackGroundColorOpacity(204)
		var_6_3:setTouchEnabled(true)

		local var_6_4 = ccui.EditBox:create(cc.size(400, 100), "")

		var_6_4:setText("TianJi")
		var_6_4:setFontColor(ui.COLORS.RED)

		local var_6_5 = ccui.Button:create(var_6_0, var_6_1)

		var_6_5:setTitleText("OK")
		var_6_5:setTitleColor(cc.c3b(0, 0, 0))
		var_6_5:setTitleFontSize(30)
		var_6_5:setOpacity(100)
		var_6_5:setPressedActionEnabled(true)
		var_6_5:xy(0, -100):show()
		var_6_5:addClickEventListener(function()
			local var_7_0 = var_6_4:getText()

			print("dev code", var_7_0)

			if var_7_0 == "163hzyoumi" then
				DEBUG = 2
				CC_SHOW_FPS = true
				EDITOR_ENABLE = true

				display.director:setDisplayStats(true)
				printInfo("------ Editor init ------")
				require("editor.builder"):init(gGameUI.scene)
				printInfo("------------")
				arg_4_0.parent_:testInLogin()

				local var_7_1 = "96773f3f45bb6396332b079593367c71"
				local var_7_2 = userDefault.getForeverLocalKey(var_7_1, 1, {
					rawKey = true
				})

				printInfo("oldPatch:%d", var_7_2)
				label.create("patch:", {
					fontSize = 45,
					color = ui.COLORS.NORMAL.DEFAULT
				}):anchorPoint(0, 0.5):xy(700, 290):addTo(arg_4_0, 999)

				local var_7_3 = ccui.EditBox:create(cc.size(300, 60), "common/box/box_topui.png"):anchorPoint(0, 0.5):xy(820, 290):color(cc.c3b(200, 200, 200)):setText(var_7_2):addTo(arg_4_0, 999)

				var_7_3:setFontSize(45)
				var_7_3:setFontColor(ui.COLORS.NORMAL.DEFAULT)

				local var_7_4 = ccui.Button:create("common/btn/btn_normal_red.png"):setTitleText("确定"):setTitleFontSize(72):xy(900, 200):addTo(arg_4_0, 999):scale(0.5)

				bind.touch(arg_4_0, var_7_4, {
					methods = {
						ended = function()
							local var_8_0 = tonumber(var_7_3:getText())

							if not var_8_0 then
								gGameUI:showTip("请输入patch值")
							else
								userDefault.setForeverLocalKey(var_7_1, var_8_0, {
									rawKey = true
								})
								gGameUI:showTip("patch值已修改为%d, 请重新登录", var_8_0)
							end
						end
					}
				})
			end

			var_6_2:removeSelf()
		end)
		var_6_2:add(var_6_3, -99):add(var_6_4):add(var_6_5):xy(display.sizeInView.width / 2, display.sizeInView.height / 2):addTo(gGameUI.scene, 999)
	end)
	Dialog.onCreate(arg_4_0)
end

function var_0_1.onChooseArea(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	arg_9_0.showTab:set(arg_9_2)
end

function var_0_1.onChooseImg(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	print("click choose placard img!")
end

function var_0_1.onCheckBox(arg_11_0)
	arg_11_0.checkStatusVisible = not arg_11_0.checkStatusVisible

	local var_11_0 = os.date("%Y%m%d", os.time())

	userDefault.setForeverLocalKey("placardStatusDay", {
		[var_11_0] = arg_11_0.checkStatusVisible
	}, {
		rawKey = true
	})
	arg_11_0.checkStatus:texture(arg_11_0.checkStatusVisible and "common/icon/radio_selected.png" or "common/icon/radio_normal.png")
end

function var_0_1.initData(arg_12_0)
	local var_12_0 = os.date("%Y%m%d", os.time())

	arg_12_0.checkStatusVisible = userDefault.getForeverLocalKey("placardStatusDay", {}, {
		rawData = true,
		rawKey = true
	})[var_12_0] ~= false

	userDefault.setForeverLocalKey("placardStatusDay", {
		[var_12_0] = arg_12_0.checkStatusVisible
	}, {
		rawKey = true
	})
	arg_12_0.checkStatus:texture(arg_12_0.checkStatusVisible and "common/icon/radio_selected.png" or "common/icon/radio_normal.png")
	arg_12_0:topInit()

	arg_12_0.selected = 2

	local var_12_1 = {}
	local var_12_2 = #arg_12_0.data

	for iter_12_0 = 1, var_12_2 do
		local var_12_3 = {
			iconRes = arg_12_0.selected == iter_12_0 and "common/box/tab_s.png" or "common/box/tab_n.png",
			name = arg_12_0.data[iter_12_0].name,
			effects = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = arg_12_0.selected == iter_12_0 and {
					color = ui.COLORS.OUTLINE.ORANGE
				} or {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}

		table.insert(var_12_1, var_12_3)
	end

	arg_12_0.areaList = idlers.newWithMap(var_12_1)
	arg_12_0.leftListCount = var_12_2

	arg_12_0:showContent(arg_12_0.data[arg_12_0.selected])
end

function var_0_1.topInit(arg_13_0)
	local var_13_0 = arg_13_0.banner
	local var_13_1 = arg_13_0.topBg:size()
	local var_13_2 = arg_13_0.topBg:box()
	local var_13_3, var_13_4 = arg_13_0.topBg:xy()
	local var_13_5 = cc.rect(29, 42, 1, 1)
	local var_13_6 = ccui.ImageView:create("login/img_banner_01@.png")

	var_13_6:xy(var_13_2.width / 2, var_13_2.height / 2)

	local var_13_7 = var_13_6:clone()

	var_13_7:x(-var_13_2.width / 2)

	local var_13_8 = var_13_6:clone()

	var_13_8:x(1.5 * var_13_2.width)

	local var_13_9 = ccui.Scale9Sprite:create()

	var_13_9:initWithFile(var_13_5, "login/box_mask_banner.png")
	var_13_9:size(var_13_1.width, var_13_1.height):xy(var_13_2.width / 2, var_13_2.height / 2)

	local var_13_10 = cc.ClippingNode:create(var_13_9)

	var_13_10:setAlphaThreshold(0.01)
	var_13_10:add(var_13_6):add(var_13_7):add(var_13_8)
	var_13_10:xy(var_13_3 - var_13_2.width / 2, var_13_4 - var_13_2.height / 2)
	arg_13_0.content:add(var_13_10, arg_13_0.topBg:z() + 1)

	local var_13_11 = 0

	local function var_13_12(arg_14_0, arg_14_1)
		if #var_13_0 == 0 then
			return
		end

		var_13_11 = arg_14_1 and var_13_11 + arg_14_1 or var_13_11 + 1
		var_13_11 = var_13_11 > #var_13_0 and 1 or var_13_11
		var_13_11 = var_13_11 < 1 and #var_13_0 or var_13_11

		var_13_6:loadTexture(var_13_0[var_13_11])

		local var_14_0 = var_13_11 > 1 and var_13_11 - 1 or #var_13_0

		var_13_7:loadTexture(var_13_0[var_14_0])

		local var_14_1 = var_13_11 < #var_13_0 and var_13_11 + 1 or 1

		var_13_8:loadTexture(var_13_0[var_14_1])
	end

	local var_13_13 = 3

	arg_13_0:enableSchedule():schedule(var_13_12, var_13_13, 0, 1)

	local var_13_14 = 0
	local var_13_15 = var_13_6:x()
	local var_13_16 = var_13_7:x()
	local var_13_17 = var_13_8:x()
	local var_13_18 = 0
	local var_13_19 = 0

	var_13_6:setTouchEnabled(true)
	var_13_6:addTouchEventListener(function(arg_15_0, arg_15_1)
		if arg_15_1 == ccui.TouchEventType.began then
			local var_15_0 = arg_15_0:getTouchBeganPosition()

			arg_13_0:unSchedule(1)
			arg_13_0:unSchedule(2)

			var_13_14 = os.clock()
			var_13_19 = var_15_0.x
		elseif arg_15_1 == ccui.TouchEventType.moved then
			local var_15_1 = arg_15_0:getTouchMovePosition()

			var_13_18 = var_13_19 - var_15_1.x

			var_13_6:x(var_13_15 - var_13_18)
			var_13_7:x(var_13_16 - var_13_18)
			var_13_8:x(var_13_17 - var_13_18)
		elseif arg_15_1 == ccui.TouchEventType.ended or arg_15_1 == ccui.TouchEventType.canceled then
			arg_13_0:unSchedule(2)

			local var_15_2 = var_13_18 / (os.clock() - var_13_14)^2

			if var_13_18 >= var_13_2.width / 2 or var_15_2 > 3000 then
				functools.partial(var_13_12, var_13_13, 1)()
			elseif var_13_18 <= -var_13_2.width / 2 or var_15_2 <= -3000 then
				functools.partial(var_13_12, var_13_13, -1)()
			end

			var_13_7:x(var_13_16)
			var_13_8:x(var_13_17)
			var_13_6:x(var_13_15)
			arg_13_0:schedule(var_13_12, var_13_13, var_13_13, 1)
		end
	end)
end

function var_0_1.showContent(arg_16_0, arg_16_1)
	arg_16_1 = arg_16_1 or {}

	local var_16_0 = arg_16_1.styleType

	arg_16_0.contentList:visible(var_16_0 == var_0_0.PAGE)
	arg_16_0.rightContentList:visible(var_16_0 ~= var_0_0.PAGE)

	if var_16_0 == var_0_0.PAGE then
		arg_16_0:setStyle1List(arg_16_1.content)
	elseif not arg_16_0.initState then
		arg_16_0:setStyle2List(arg_16_1.content)
	end
end

function var_0_1.setStyle1List(arg_17_0, arg_17_1)
	if not arg_17_1 then
		return
	end

	local var_17_0 = arg_17_0.contentList

	var_17_0:removeAllChildren()

	local var_17_1 = arg_17_0.contentItem:get("downList"):size().width - 40
	local var_17_2 = arg_17_0.titleItem

	var_17_0:setItemsMargin(30)

	for iter_17_0, iter_17_1 in ipairs(arg_17_1) do
		local var_17_3 = var_17_2:clone()

		var_17_3:get("title"):text(iter_17_1.title)
		var_17_0:pushBackCustomItem(var_17_3)
		var_17_3:show()

		local var_17_4 = rich.createWithWidth("#C0x57472E#" .. iter_17_1.content, 40, deltaSize, var_17_1)

		var_17_0:pushBackCustomItem(var_17_4)
	end
end

function var_0_1.setStyle2List(arg_18_0, arg_18_1)
	if not arg_18_1 then
		return
	end

	arg_18_0.initState = true

	local var_18_0 = arg_18_0.rightContentList

	var_18_0:removeAllChildren()
	var_18_0:setItemsMargin(10)

	local var_18_1 = arg_18_0.contentItem
	local var_18_2 = var_18_1:size()
	local var_18_3 = var_18_1:get("downList"):size().width

	var_18_0.curItem = nil

	local var_18_4 = {}
	local var_18_5
	local var_18_6

	local function var_18_7(arg_19_0)
		arg_19_0 = arg_19_0 or var_18_0.curItem and var_18_0.curItem.idx

		if not arg_19_0 then
			return
		end

		local var_19_0 = arg_18_1[arg_19_0].id
		local var_19_1 = var_18_1:clone()

		var_19_1:z(arg_19_0)
		var_19_1:get("title"):text(arg_18_1[arg_19_0].titlebar)

		var_19_1.idx = arg_19_0

		var_19_1:get("tag"):visible(not var_18_4[var_19_0])

		var_19_1.isDropDown = false

		var_19_1:get("bg"):onClick(functools.partial(var_18_6, var_19_1))

		return var_19_1
	end

	function var_18_6(arg_20_0)
		local var_20_0 = arg_20_0.idx
		local var_20_1 = arg_18_1[var_20_0].id

		var_18_4[var_20_1] = true

		userDefault.setForeverLocalKey("placardNews", {
			[var_20_1] = true
		}, {
			rawKey = true
		})

		local var_20_2 = var_18_7(var_20_0)
		local var_20_3 = 100

		if not arg_20_0.isDropDown then
			local var_20_4 = var_20_2:get("downList")

			local function var_20_5(arg_21_0)
				local var_21_0 = arg_18_0.titleItem:clone()

				var_21_0:get("title"):text(arg_21_0.title)
				var_21_0:anchorPoint(0, 1)

				var_20_3 = var_20_3 + var_21_0:size().height + 30

				var_21_0:show()

				local var_21_1 = rich.createWithWidth("#C0x57472E#" .. arg_21_0.content, 40, deltaSize, var_18_3 - 40)
				local var_21_2 = var_21_1:size()

				var_21_1:anchorPoint(0, 1)

				var_20_3 = var_20_3 + var_21_2.height

				var_21_1:xy(10, var_20_3 - 120)
				var_21_0:xy(10, var_20_3 - 40)
				var_20_4:add(var_21_1)
				var_20_4:add(var_21_0)
			end

			local var_20_6 = arg_18_1[var_20_0].content
			local var_20_7 = false

			for iter_20_0 = #var_20_6, 1, -1 do
				local var_20_8 = var_20_6[iter_20_0]

				if var_20_8.channel == APP_CHANNEL then
					var_20_5(var_20_8)

					var_20_7 = true
				end
			end

			if not var_20_7 then
				for iter_20_1 = #var_20_6, 1, -1 do
					local var_20_9 = var_20_6[iter_20_1]

					if not var_20_9.channel then
						var_20_5(var_20_9)
					end
				end
			end

			var_20_4:size(var_18_3, var_20_3)
			var_20_4:show()

			var_20_2.isDropDown = true

			var_20_2:get("btn"):rotate(180)
		end

		local var_20_10 = ccui.Layout:create()
		local var_20_11 = var_18_2.height + (var_20_3 > 0 and var_20_3 - 100 or 0)

		var_20_10:size(cc.size(var_18_2.width, var_20_11))
		var_20_10:setAnchorPoint(cc.p(0.5, 0.5))
		var_20_10:addChild(var_20_2)
		var_20_2:xy(var_20_2:size().width / 2, var_20_11 - 44)
		var_20_2:show()
		var_18_0:removeItem(var_20_0 - 1)
		var_18_0:insertCustomItem(var_20_10, var_20_0 - 1)

		var_18_0.curItem = var_20_2

		var_18_0:jumpToItem(var_20_0 - 1, cc.p(0, 1), cc.p(0, 1))
	end

	var_18_0.total = #arg_18_1

	local var_18_8 = userDefault.getForeverLocalKey("placardNews", {}, {
		rawKey = true
	})

	for iter_18_0, iter_18_1 in ipairs(arg_18_1) do
		var_18_4[iter_18_1.id] = var_18_8[iter_18_1.id]

		local var_18_9 = var_18_7(iter_18_0)

		var_18_9:setTouchEnabled(true)
		var_18_9:show()
		var_18_0:pushBackCustomItem(var_18_9)

		if iter_18_0 == 1 then
			var_18_6(var_18_9)
		end
	end

	userDefault.setForeverLocalKey("placardNews", var_18_4, {
		new = true,
		rawKey = true
	})
end

return var_0_1
