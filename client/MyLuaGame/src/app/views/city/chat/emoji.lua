local var_0_0 = 10
local var_0_1 = class("ChatEmojiView", Dialog)

var_0_1.RESOURCE_FILENAME = "chat_emoji.json"
var_0_1.RESOURCE_BINDING = {
	dot = "dot",
	pagePanel = "pagePanel",
	btnItem = "btnItem",
	bg1 = "bg1",
	bg = "bg",
	btnList = {
		varname = "btnList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("btnDatas"),
				item = bindHelper.self("btnItem"),
				showTab = bindHelper.self("showTab"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					idlereasy.when(arg_1_0.showTab, function(arg_2_0, arg_2_1)
						local var_2_0 = arg_1_1:size()

						if arg_2_1 == arg_1_2 then
							arg_1_1:get("normal"):hide()
							arg_1_1:get("selected"):show()
							arg_1_1:get("selected.txt"):text(arg_1_3)
							adapt.oneLineCenterPos(cc.p(var_2_0.width / 2, var_2_0.height / 2 - 10), {
								arg_1_1:get("selected.logo"),
								arg_1_1:get("selected.txt")
							}, cc.p(10, 0))
						else
							arg_1_1:get("normal"):show()
							arg_1_1:get("selected"):hide()
							arg_1_1:get("normal.txt"):text(arg_1_3)
							adapt.oneLineCenterPos(cc.p(var_2_0.width / 2, var_2_0.height / 2 - 10), {
								arg_1_1:get("normal.logo"),
								arg_1_1:get("normal.txt")
							}, cc.p(10, 0))
							bind.touch(arg_1_0, arg_1_1:get("normal"), {
								methods = {
									ended = functools.partial(arg_1_0.clickCell, arg_1_2)
								}
							})
						end
					end)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBtnItemClick")
			}
		}
	},
	pageview = {
		varname = "pageview",
		binds = {
			event = "extend",
			class = "pageview",
			props = {
				data = bindHelper.self("pageDatas"),
				item = bindHelper.self("pagePanel"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					arg_3_0:setClippingEnabled(true)

					local var_3_0 = arg_3_1:multiget("list", "subList", "item")

					var_3_0.list:setScrollBarEnabled(false)
					var_3_0.subList:setScrollBarEnabled(false)

					local var_3_1 = #arg_3_3
					local var_3_2, var_3_3 = mathEasy.getRowCol(var_3_1, 5)

					for iter_3_0 = 1, var_3_2 do
						local var_3_4 = var_3_0.subList:clone():show()

						var_3_0.list:pushBackCustomItem(var_3_4)

						local var_3_5 = iter_3_0 == var_3_2 and var_3_3 or 5

						for iter_3_1 = 1, var_3_5 do
							local var_3_6 = iter_3_1 + (iter_3_0 - 1) * 5
							local var_3_7 = var_3_0.item:clone():show()
							local var_3_8 = gEmojiCsv[arg_3_3[var_3_6].key]

							var_3_7:get("icon"):texture(var_3_8.resource)
							bind.click(self, var_3_7, {
								method = functools.partial(arg_3_0.itemClick, arg_3_2, arg_3_3[var_3_6])
							})
							var_3_4:pushBackCustomItem(var_3_7)
						end
					end
				end
			},
			handlers = {
				itemClick = bindHelper.self("onSelPicture")
			}
		}
	},
	dotList = {
		varname = "dotList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("pointDatas"),
				item = bindHelper.self("dot"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = string.format("common/icon/logo_%s_fy.png", arg_4_3.isCur == true and "highlight" or "normal")

					arg_4_1:texture(var_4_0)
				end,
				onAfterBuild = function(arg_5_0)
					arg_5_0:setItemAlignCenter()
				end
			}
		}
	}
}

function var_0_1.onCreate(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_0.sendData = arg_6_1
	arg_6_0.channel = arg_6_2
	arg_6_0.freshList = arg_6_3

	local var_6_0 = gGameUI:getConvertPos(arg_6_0.freshList)

	arg_6_0.unlockKey = gUnlockCsv.roleChat
	arg_6_0.unlockKey = gUnlockCsv.worldChat

	local var_6_1 = 120

	arg_6_0.bg:width(arg_6_0.bg:width() - var_6_1)
	arg_6_0.bg1:width(arg_6_0.bg1:width() - var_6_1)
	arg_6_0.btnList:width(arg_6_0.btnList:width() - var_6_1):x(arg_6_0.btnList:x() + var_6_1 / 2)

	local var_6_2 = math.min(var_6_1, 80)

	arg_6_0.pageview:width(arg_6_0.pageview:width() - var_6_2):x(arg_6_0.pageview:x() + var_6_2 / 2)
	arg_6_0.pagePanel:width(arg_6_0.pagePanel:width() - var_6_2)

	local var_6_3 = arg_6_0.pagePanel:get("list")
	local var_6_4 = arg_6_0.pagePanel:get("subList")

	var_6_3:width(var_6_3:width() - var_6_2)
	var_6_4:width(var_6_4:width() - var_6_2)
	var_6_4:setItemsMargin(0)

	local var_6_5 = var_6_0.x + arg_6_0.bg:size().width / 2 - 20
	local var_6_6 = var_6_0.y + arg_6_0.bg:size().height / 2 - 32

	arg_6_0:getResourceNode():xy(var_6_5, var_6_6)

	local var_6_7 = userDefault.getForeverLocalKey("chatEmoji", {})
	local var_6_8 = {}

	arg_6_0.datas = {}

	for iter_6_0, iter_6_1 in pairs(gEmojiCsv) do
		if var_6_7[iter_6_0] and var_6_7[iter_6_0] > 0 then
			table.insert(var_6_8, {
				key = iter_6_0,
				count = var_6_7[iter_6_0] or 0,
				id = iter_6_1.id
			})
		end

		for iter_6_2, iter_6_3 in ipairs(iter_6_1.tab) do
			for iter_6_4 = #arg_6_0.datas + 1, iter_6_3 do
				arg_6_0.datas[iter_6_4] = {}
			end

			table.insert(arg_6_0.datas[iter_6_3], {
				key = iter_6_0,
				id = iter_6_1.id
			})
		end
	end

	for iter_6_5, iter_6_6 in ipairs(arg_6_0.datas) do
		table.sort(iter_6_6, function(arg_7_0, arg_7_1)
			return arg_7_0.id < arg_7_1.id
		end)
	end

	arg_6_0.btnDatas = {}

	for iter_6_7 = #arg_6_0.datas, 1, -1 do
		if #arg_6_0.datas[iter_6_7] == 0 then
			table.remove(arg_6_0.datas, iter_6_7)
		else
			table.insert(arg_6_0.btnDatas, 1, gLanguageCsv["emojiTab" .. iter_6_7] or "")
		end
	end

	if #var_6_8 ~= 0 then
		table.sort(var_6_8, function(arg_8_0, arg_8_1)
			if arg_8_0.count ~= arg_8_1.count then
				return arg_8_0.count > arg_8_1.count
			end

			return arg_8_0.id < arg_8_1.id
		end)
		table.insert(arg_6_0.datas, 1, var_6_8)
		table.insert(arg_6_0.btnDatas, 1, gLanguageCsv.commonUse)
	end

	arg_6_0.showTab = idler.new(1)
	arg_6_0.pageIndex = idler.new(1)

	arg_6_0.pageview:addEventListener(function(arg_9_0)
		arg_6_0.pageIndex:set(math.min(arg_6_0.pageview:getCurPageIndex() + 1, arg_6_0.pointDatas:size()))
	end)

	arg_6_0.pageDatas = idlers.new()
	arg_6_0.pointDatas = idlers.new()

	idlereasy.when(arg_6_0.showTab, function(arg_10_0, arg_10_1)
		local var_10_0 = {}
		local var_10_1 = {}

		for iter_10_0 = 1, #arg_6_0.datas[arg_10_1], var_0_0 do
			table.insert(var_10_0, arraytools.slice(arg_6_0.datas[arg_10_1], iter_10_0, var_0_0))
			table.insert(var_10_1, {
				isCur = iter_10_0 == 1
			})
		end

		arg_6_0.pageDatas:update(var_10_0)
		arg_6_0.pointDatas:update(var_10_1)
		arg_6_0.pageIndex:set(1)
		arg_6_0.dotList:visible(#var_10_1 > 1)
	end)
	idlereasy.when(arg_6_0.pageIndex, function(arg_11_0, arg_11_1)
		for iter_11_0, iter_11_1 in arg_6_0.pointDatas:ipairs() do
			iter_11_1:proxy().isCur = iter_11_0 == arg_11_1
		end
	end)
	Dialog.onCreate(arg_6_0, {
		clickClose = true,
		noBlackLayer = true
	})
end

function var_0_1.setReuseEmoji(arg_12_0, arg_12_1)
	local var_12_0 = userDefault.getForeverLocalKey("chatEmoji", {})

	for iter_12_0, iter_12_1 in pairs(arg_12_1) do
		var_12_0[iter_12_0] = iter_12_1 + (var_12_0[iter_12_0] or 0)
	end

	userDefault.setForeverLocalKey("chatEmoji", var_12_0)
end

function var_0_1.onSelPicture(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if not dataEasy.isUnlock(arg_13_0.unlockKey) then
		gGameUI:showTip(dataEasy.getUnlockTip(arg_13_0.unlockKey))

		return
	end

	local var_13_0 = arg_13_3.key

	gGameApp:requestServer("/game/chat", function(arg_14_0)
		arg_13_0:setReuseEmoji({
			[var_13_0] = 1
		})
		arg_13_0.freshList:jumpToBottom()
		arg_13_0:onClose()
	end, "[" .. var_13_0 .. "]", arg_13_0.channel, arg_13_0.sendData)
end

function var_0_1.onBtnItemClick(arg_15_0, arg_15_1, arg_15_2)
	arg_15_0.showTab:set(arg_15_2)
end

return var_0_1
