local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("GymBuffTree", var_0_0)

var_0_1.RESOURCE_FILENAME = "gym_buff.json"
var_0_1.RESOURCE_BINDING = {
	bufItem = "bufItem",
	["leftPanel.item"] = "leftItem",
	["rightTopPanel.textPoint"] = "textPoint",
	leftPanel = "leftPanel",
	rightTopPanel = "rightTopPanel",
	["leftPanel.listview"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("leftDatas"),
				item = bindHelper.self("leftItem"),
				showTab = bindHelper.self("showTab"),
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
					else
						var_1_1:hide()

						var_1_2 = var_1_0:show()

						var_1_2:get("subTxt"):text(arg_1_3.subName)
					end

					var_1_2:get("txt"):text(arg_1_3.name)
					var_1_1:setTouchEnabled(false)
					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2)
						}
					})
					adapt.setTextScaleWithWidth(var_1_2:get("txt"), nil, 300)

					local var_1_3 = bindHelper.self("gymDatas")

					bind.extend(arg_1_0, arg_1_1, {
						class = "red_hint",
						props = {
							specialTag = "gymBuffTab",
							state = arg_1_0.showTab:read() ~= arg_1_2,
							listenData = {
								treeId = arg_1_2,
								gymDatas = bindHelper.parent("gymDatas"),
								round = gGameModel.gym:getIdler("round")
							},
							onNode = function(arg_2_0)
								arg_2_0:xy(420, 160)
							end
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	scrollview = {
		varname = "scrollview",
		binds = {
			event = "scrollBarEnabled",
			data = false
		}
	},
	["rightTopPanel.btnAdd"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddClick")
			}
		}
	},
	btnReset = {
		varname = "btnReset",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onResetClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	gGameUI.topuiManager:createView("default", arg_3_0, {
		onClose = arg_3_0:createHandler("onClose")
	}):init({
		subTitle = "CHALLENGE ADD",
		title = "common/txt/txt_bt_tiaozhanjiacheng.png"
	})
	arg_3_0:initData()
	arg_3_0:initModel()
end

function var_0_1.initModel(arg_4_0)
	arg_4_0.showTab = idler.new(1)
	arg_4_0.treeId = idler.new(1)

	local var_4_0 = {}

	for iter_4_0, iter_4_1 in orderCsvPairs(csv.gym.talent_tree) do
		var_4_0[iter_4_0] = {
			select = false,
			name = iter_4_1.name,
			subName = iter_4_1.desc
		}
	end

	arg_4_0.leftDatas = idlers.newWithMap(var_4_0)

	arg_4_0.showTab:addListener(function(arg_5_0, arg_5_1)
		arg_4_0.leftDatas:atproxy(arg_5_1).select = false
		arg_4_0.leftDatas:atproxy(arg_5_0).select = true

		arg_4_0.treeId:set(arg_5_0)
	end)

	arg_4_0.unlockTable = idlertable.new()
	arg_4_0.gymDatas = gGameModel.role:getIdler("gym_datas")

	idlereasy.any({
		arg_4_0.gymDatas,
		arg_4_0.treeId
	}, function(arg_6_0, arg_6_1, arg_6_2)
		arg_4_0.depthData = {}

		arg_4_0:refreshShowData(arg_6_2)
		arg_4_0.textPoint:text(arg_6_1.gym_talent_point)
		adapt.oneLinePos(arg_4_0.rightTopPanel:get("btnAdd"), {
			arg_4_0.textPoint,
			arg_4_0.rightTopPanel:get("textNote"),
			arg_4_0.rightTopPanel:get("imgIcon")
		}, {
			cc.p(10, 0),
			cc.p(5, 0),
			cc.p(10, 0)
		}, "right")

		local var_6_0 = arg_6_1.gym_talent_trees[arg_6_2] or {}
		local var_6_1 = {}

		for iter_6_0, iter_6_1 in pairs(var_6_0.talent or {}) do
			local var_6_2 = csv.gym.talent_buff[iter_6_0].depth

			arg_4_0.depthData[arg_6_2] = arg_4_0.depthData[arg_6_2] or {}
			arg_4_0.depthData[arg_6_2][var_6_2] = iter_6_0
		end

		for iter_6_2, iter_6_3 in orderCsvPairs(csv.gym.talent_buff) do
			var_6_1[iter_6_2] = arg_4_0:checkUnlock(iter_6_2)
		end

		arg_4_0.unlockTable:set(var_6_1)

		for iter_6_4, iter_6_5 in pairs(arg_4_0.bufIcons) do
			if var_6_0.talent and var_6_0.talent[iter_6_4] then
				arg_4_0:refreshBufIcon(iter_6_4, var_6_0.talent[iter_6_4])
			else
				arg_4_0:refreshBufIcon(iter_6_4, 0)
			end
		end

		if itertools.isempty(arg_6_1.gym_talent_trees) then
			uiEasy.setBtnShader(arg_4_0.btnReset, arg_4_0.btnReset:get("textNote"), 3)
			text.deleteAllEffect(arg_4_0.btnReset:get("textNote"))
		else
			uiEasy.setBtnShader(arg_4_0.btnReset, arg_4_0.btnReset:get("textNote"), 1)
			text.addEffect(arg_4_0.btnReset:get("textNote"), {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		end
	end)

	local var_4_1 = arg_4_0.rightTopPanel:get("textNote1"):hide()
	local var_4_2 = rich.createByStr(string.format(gLanguageCsv.gymBuffDesc, gCommonConfigCsv.gymAutoRecoverPoints), 40):xy(cc.p(var_4_1:xy())):anchorPoint(1, 0.5):addTo(arg_4_0.rightTopPanel, 3)

	arg_4_0.buyTimes = gGameModel.daily_record:getIdler("gym_talent_point_buy_times")
end

function var_0_1.initData(arg_7_0)
	local var_7_0 = {}

	for iter_7_0, iter_7_1 in orderCsvPairs(csv.gym.talent_buff) do
		var_7_0[iter_7_0] = {
			id = iter_7_0
		}

		for iter_7_2, iter_7_3 in pairs(iter_7_1) do
			var_7_0[iter_7_0][iter_7_2] = iter_7_3
		end
	end

	for iter_7_4, iter_7_5 in pairs(var_7_0) do
		for iter_7_6, iter_7_7 in pairs(iter_7_5.preTalentIDs or {}) do
			var_7_0[iter_7_7].nextTalentIDs = var_7_0[iter_7_7].nextTalentIDs or {}

			table.insert(var_7_0[iter_7_7].nextTalentIDs, iter_7_4)
		end
	end

	arg_7_0.cfgData = {}

	for iter_7_8, iter_7_9 in pairs(var_7_0) do
		arg_7_0.cfgData[iter_7_9.treeID] = arg_7_0.cfgData[iter_7_9.treeID] or {}
		arg_7_0.cfgData[iter_7_9.treeID][iter_7_8] = iter_7_9
	end
end

function var_0_1.createBufIcon(arg_8_0, arg_8_1)
	local var_8_0 = csv.gym.talent_buff[arg_8_1]
	local var_8_1 = arg_8_0.bufItem:clone():z(5):scale(var_8_0.iconRate)
	local var_8_2 = var_8_1:get("imgBg.icon"):texture(var_8_0.icon)

	var_8_1:setTouchEnabled(true)
	bind.touch(arg_8_0, var_8_1, {
		methods = {
			ended = function()
				local var_9_0 = arg_8_0.unlockTable:read()
				local var_9_1, var_9_2 = arg_8_0:getPreLv(arg_8_1)

				gGameUI:stackUI("city.adventure.gym_challenge.buff_detail", nil, {
					clickClose = true,
					blackLayer = true
				}, arg_8_1, var_9_0[arg_8_1], var_9_1, var_9_2)
			end
		}
	})

	arg_8_0.bufIcons[arg_8_1] = var_8_1

	bind.extend(arg_8_0, arg_8_0.bufIcons[arg_8_1], {
		class = "red_hint",
		props = {
			specialTag = "gymBuffIcon",
			listenData = {
				id = arg_8_1,
				round = gGameModel.gym:getIdler("round"),
				gymDatas = bindHelper.self("gymDatas")
			},
			onNode = function(arg_10_0)
				arg_10_0:x(arg_10_0:x() - 10)
				arg_10_0:y(arg_10_0:y() - 10)
			end
		}
	})

	return var_8_1
end

function var_0_1.refreshBufIcon(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.bufIcons[arg_11_1]
	local var_11_1 = arg_11_0.unlockTable:read()[arg_11_1]

	if var_11_1 == false then
		var_11_0:get("imgLockBg"):show()
		var_11_0:get("imgLvBg"):hide()
		var_11_0:get("textLv"):hide()
	else
		var_11_0:get("imgLockBg"):hide()
		var_11_0:get("imgLvBg"):show()
		var_11_0:get("textLv"):show()
	end

	for iter_11_0, iter_11_1 in pairs(arg_11_0.lines[arg_11_1]) do
		for iter_11_2, iter_11_3 in ipairs(iter_11_1) do
			if var_11_1 == false then
				iter_11_3:setColor(cc.c4b(155, 155, 155, 127.5))
				iter_11_3:z(0)
			elseif arg_11_0.unlockTable:read()[iter_11_0] == false then
				iter_11_3:setColor(cc.c4b(155, 155, 155, 127.5))
				iter_11_3:z(0)
			else
				iter_11_3:setColor(cc.c4b(255, 59, 0, 255))
				iter_11_3:z(1)
			end
		end
	end

	var_11_0:get("textLv"):text("Lv." .. arg_11_2)
end

function var_0_1.checkUnlock(arg_12_0, arg_12_1)
	local var_12_0 = csv.gym.talent_buff[arg_12_1]
	local var_12_1 = var_12_0.preTalentIDs
	local var_12_2 = var_12_0.preLevel
	local var_12_3 = var_12_0.depth
	local var_12_4 = arg_12_0.gymDatas:read().gym_talent_trees[var_12_0.treeID] or {}

	if (var_12_4.talent and var_12_4.talent[arg_12_1] or 0) > 0 then
		return true
	end

	if var_12_3 == 1 then
		return true
	end

	if arg_12_0.depthData[var_12_0.treeID] and arg_12_0.depthData[var_12_0.treeID][var_12_3] and arg_12_0.depthData[var_12_0.treeID][var_12_3] ~= arg_12_1 then
		return false
	end

	for iter_12_0, iter_12_1 in ipairs(var_12_1) do
		if var_12_2 <= (var_12_4.talent and var_12_4.talent[iter_12_1] or 0) then
			return true
		end
	end

	return false
end

function var_0_1.getPreLv(arg_13_0, arg_13_1)
	local var_13_0 = csv.gym.talent_buff[arg_13_1]
	local var_13_1 = var_13_0.preTalentIDs
	local var_13_2 = var_13_0.preLevel
	local var_13_3 = var_13_0.depth
	local var_13_4 = arg_13_0.gymDatas:read().gym_talent_trees[var_13_0.treeID] or {}

	if not var_13_4.talent or not var_13_4.talent[arg_13_1] then
		local var_13_5 = 0
	end

	if var_13_3 == 1 then
		return 0, 0
	end

	for iter_13_0, iter_13_1 in ipairs(var_13_1) do
		local var_13_6 = var_13_4.talent and var_13_4.talent[iter_13_1]

		if var_13_6 and var_13_6 ~= 0 then
			return var_13_6, var_13_0.preLevel
		end
	end

	return 0, var_13_0.preLevel
end

function var_0_1.getDepthData(arg_14_0, arg_14_1)
	local var_14_0 = {}
	local var_14_1 = 0

	for iter_14_0, iter_14_1 in pairs(arg_14_0.cfgData[arg_14_1]) do
		var_14_0[iter_14_1.depth] = var_14_0[iter_14_1.depth] or {}

		table.insert(var_14_0[iter_14_1.depth], iter_14_1)

		var_14_1 = math.max(var_14_1, #var_14_0[iter_14_1.depth])
	end

	for iter_14_2, iter_14_3 in ipairs(var_14_0) do
		table.sort(iter_14_3, function(arg_15_0, arg_15_1)
			return arg_15_0.id < arg_15_1.id
		end)
	end

	return var_14_0, var_14_1
end

function var_0_1.drawBufIcon(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0.scrollview:width()
	local var_16_1 = #arg_16_1
	local var_16_2 = cc.size(var_16_0, math.max(var_16_1 * 300 - 100, 1120))
	local var_16_3 = 350
	local var_16_4 = 180
	local var_16_5 = (var_16_2.width - 300) / (arg_16_2 - 1)

	arg_16_0.scrollview:setInnerContainerSize(var_16_2)

	local var_16_6 = var_16_2.height - 120

	for iter_16_0, iter_16_1 in ipairs(arg_16_1) do
		local var_16_7 = 0

		if iter_16_0 == 1 then
			var_16_7 = var_16_6
			var_16_6 = var_16_7
		elseif iter_16_0 == 2 or iter_16_0 == #arg_16_1 then
			var_16_7 = var_16_6 - var_16_4
			var_16_6 = var_16_7
		else
			var_16_7 = var_16_6 - var_16_3
			var_16_6 = var_16_7
		end

		for iter_16_2, iter_16_3 in ipairs(iter_16_1) do
			local var_16_8 = arg_16_0:createBufIcon(iter_16_3.id):addTo(arg_16_0.scrollview)

			if #iter_16_1 == 2 then
				var_16_8:xy(var_16_0 / 3 * iter_16_2, var_16_7)
			else
				local var_16_9 = var_16_0 / 2 - var_16_5 / 2 * (#iter_16_1 - 1) + var_16_5 * (iter_16_2 - 1)

				var_16_8:xy(var_16_9, var_16_7)
			end

			arg_16_1[iter_16_0][iter_16_2].pos = cc.p(var_16_8:xy())
			arg_16_1[iter_16_0][iter_16_2].icon = var_16_8
		end
	end
end

function var_0_1.drawLine(arg_17_0, arg_17_1)
	arg_17_0.lines = {}

	for iter_17_0, iter_17_1 in ipairs(arg_17_1) do
		for iter_17_2, iter_17_3 in ipairs(iter_17_1) do
			local var_17_0 = {}

			arg_17_0.lines[iter_17_3.id] = var_17_0

			local var_17_1
			local var_17_2
			local var_17_3

			if iter_17_0 > 1 then
				if #arg_17_1[iter_17_0 - 1] > #iter_17_1 then
					var_17_1 = arg_17_1[iter_17_0 - 1][iter_17_2]
					var_17_2 = arg_17_1[iter_17_0 - 1][iter_17_2 + 1]
				elseif #arg_17_1[iter_17_0 - 1] < #iter_17_1 then
					var_17_1 = arg_17_1[iter_17_0 - 1][iter_17_2 - 1]
					var_17_2 = arg_17_1[iter_17_0 - 1][iter_17_2]
				end

				var_17_3 = var_17_1 and var_17_2 and 2 or 1
			end

			local var_17_4 = iter_17_3.icon:getBoundingBox().width / 2
			local var_17_5 = 22

			if iter_17_0 == 2 then
				if var_17_1 then
					local var_17_6 = {}
					local var_17_7 = var_17_1
					local var_17_8 = var_17_7.icon:getBoundingBox().width / 2
					local var_17_9 = ccui.ImageView:create("city/adventure/gym_challenge/bar_1.png")

					table.insert(var_17_6, var_17_9)
					var_17_9:scaleX(1):anchorPoint(0.6875, 0.6875):xy(iter_17_3.pos.x, var_17_7.pos.y):addTo(arg_17_0.scrollview)

					local var_17_10 = ccui.Scale9Sprite:create()

					table.insert(var_17_6, var_17_10)
					var_17_10:initWithFile(cc.rect(10, 27, 1, 1), "city/adventure/gym_challenge/bar_3.png")
					var_17_10:height(var_17_7.pos.y - iter_17_3.pos.y - var_17_5 - var_17_4):anchorPoint(0.5, 1):xy(iter_17_3.pos.x, var_17_7.pos.y - var_17_5):addTo(arg_17_0.scrollview)

					local var_17_11 = ccui.Scale9Sprite:create()

					table.insert(var_17_6, var_17_11)
					var_17_11:initWithFile(cc.rect(10, 27, 1, 1), "city/adventure/gym_challenge/bar_3.png")
					var_17_11:height(math.abs(iter_17_3.pos.x - var_17_7.pos.x) - var_17_5 - var_17_8):setRotation(270):anchorPoint(0.5, 0):xy(iter_17_3.pos.x - var_17_5, var_17_7.pos.y):addTo(arg_17_0.scrollview)

					var_17_0[var_17_1.id] = var_17_6
				end

				if var_17_2 then
					local var_17_12 = {}
					local var_17_13 = var_17_2
					local var_17_14 = var_17_13.icon:getBoundingBox().width / 2
					local var_17_15 = ccui.ImageView:create("city/adventure/gym_challenge/bar_1.png")

					table.insert(var_17_12, var_17_15)
					var_17_15:scaleX(-1):anchorPoint(0.6875, 0.6875):xy(iter_17_3.pos.x, var_17_13.pos.y):addTo(arg_17_0.scrollview)

					local var_17_16 = ccui.Scale9Sprite:create()

					table.insert(var_17_12, var_17_16)
					var_17_16:initWithFile(cc.rect(10, 27, 1, 1), "city/adventure/gym_challenge/bar_3.png")
					var_17_16:height(var_17_13.pos.y - iter_17_3.pos.y - var_17_5 - var_17_4):anchorPoint(0.5, 1):xy(iter_17_3.pos.x, var_17_13.pos.y - var_17_5):addTo(arg_17_0.scrollview)

					local var_17_17 = ccui.Scale9Sprite:create()

					table.insert(var_17_12, var_17_17)
					var_17_17:initWithFile(cc.rect(10, 27, 1, 1), "city/adventure/gym_challenge/bar_3.png")
					var_17_17:height(math.abs(iter_17_3.pos.x - var_17_13.pos.x) - var_17_5 - var_17_14):setRotation(90):anchorPoint(0.5, 0):xy(iter_17_3.pos.x + var_17_5, var_17_13.pos.y):addTo(arg_17_0.scrollview)

					var_17_0[var_17_2.id] = var_17_12
				end
			elseif iter_17_0 == #arg_17_1 then
				local var_17_18 = iter_17_3.pos.y

				if var_17_1 then
					local var_17_19 = {}

					if #var_17_1.nextTalentIDs == 1 then
						local var_17_20 = var_17_1
						local var_17_21 = var_17_20.icon:getBoundingBox().width / 2
						local var_17_22 = ccui.ImageView:create("city/adventure/gym_challenge/bar_1.png")

						table.insert(var_17_19, var_17_22)
						var_17_22:scale(-1):anchorPoint(0.6875, 0.6875):xy(var_17_20.pos.x, iter_17_3.pos.y):addTo(arg_17_0.scrollview)

						local var_17_23 = ccui.Scale9Sprite:create()

						var_17_23:initWithFile(cc.rect(10, 27, 1, 1), "city/adventure/gym_challenge/bar_3.png")
						table.insert(var_17_19, var_17_23)
						var_17_23:height(var_17_20.pos.y - iter_17_3.pos.y - var_17_5 - var_17_21 + 10):anchorPoint(0.5, 0):xy(var_17_22:x(), var_17_22:y() + var_17_5):addTo(arg_17_0.scrollview)

						local var_17_24 = ccui.Scale9Sprite:create()

						table.insert(var_17_19, var_17_24)
						var_17_24:initWithFile(cc.rect(10, 27, 1, 1), "city/adventure/gym_challenge/bar_3.png")
						var_17_24:height(math.abs(iter_17_3.pos.x - var_17_20.pos.x) - iter_17_3.icon:getBoundingBox().width / 2 - var_17_5):setRotation(90):anchorPoint(0.5, 0):xy(var_17_22:x() + var_17_5, var_17_22:y()):addTo(arg_17_0.scrollview)
					else
						local var_17_25 = ccui.Scale9Sprite:create()

						table.insert(var_17_19, var_17_25)
						var_17_25:initWithFile(cc.rect(15, 10, 1, 1), "city/adventure/gym_challenge/bar_3.png")
						var_17_25:height(iter_17_3.pos.x - var_17_1.pos.x - iter_17_3.icon:getBoundingBox().width / 2):setRotation(90):anchorPoint(0.5, 0):xy(var_17_1.pos.x, var_17_18):addTo(arg_17_0.scrollview)

						local var_17_26 = ccui.Scale9Sprite:create()

						table.insert(var_17_19, var_17_26)
						var_17_26:initWithFile(cc.rect(10, 27, 1, 1), "city/adventure/gym_challenge/bar_3.png")

						local var_17_27 = var_17_1.icon:getBoundingBox().height / 2

						var_17_26:height(var_17_1.pos.y - var_17_18 - var_17_27 + 10):anchorPoint(0.5, 0):xy(var_17_1.pos.x, var_17_18 - 10):addTo(arg_17_0.scrollview)
					end

					var_17_0[var_17_1.id] = var_17_19
				end

				if var_17_2 then
					local var_17_28 = {}

					if #var_17_2.nextTalentIDs == 1 then
						local var_17_29 = var_17_2
						local var_17_30 = var_17_29.icon:getBoundingBox().width / 2
						local var_17_31 = ccui.ImageView:create("city/adventure/gym_challenge/bar_1.png")

						table.insert(var_17_28, var_17_31)
						var_17_31:scaleY(-1):anchorPoint(0.6875, 0.6875):xy(var_17_29.pos.x, iter_17_3.pos.y):addTo(arg_17_0.scrollview)

						local var_17_32 = ccui.Scale9Sprite:create()

						table.insert(var_17_28, var_17_32)
						var_17_32:initWithFile(cc.rect(10, 27, 1, 1), "city/adventure/gym_challenge/bar_3.png")
						var_17_32:height(var_17_29.pos.y - iter_17_3.pos.y - var_17_5 - var_17_30 + 10):anchorPoint(0.5, 0):xy(var_17_31:x(), var_17_31:y() + var_17_5):addTo(arg_17_0.scrollview)

						local var_17_33 = ccui.Scale9Sprite:create()

						table.insert(var_17_28, var_17_33)
						var_17_33:initWithFile(cc.rect(10, 27, 1, 1), "city/adventure/gym_challenge/bar_3.png")
						var_17_33:height(math.abs(iter_17_3.pos.x - var_17_29.pos.x) - iter_17_3.icon:getBoundingBox().width / 2 - var_17_5):setRotation(270):anchorPoint(0.5, 0):xy(var_17_31:x() - var_17_5, var_17_31:y()):addTo(arg_17_0.scrollview)
					else
						local var_17_34 = ccui.Scale9Sprite:create()

						table.insert(var_17_28, var_17_34)
						var_17_34:initWithFile(cc.rect(15, 10, 1, 1), "city/adventure/gym_challenge/bar_3.png")
						var_17_34:height(var_17_2.pos.x - iter_17_3.pos.x - iter_17_3.icon:getBoundingBox().width / 2):setRotation(270):anchorPoint(0.5, 0):xy(var_17_2.pos.x, var_17_18):addTo(arg_17_0.scrollview)

						local var_17_35 = ccui.Scale9Sprite:create()

						table.insert(var_17_28, var_17_35)
						var_17_35:initWithFile(cc.rect(10, 27, 1, 1), "city/adventure/gym_challenge/bar_3.png")

						local var_17_36 = var_17_2.icon:getBoundingBox().height / 2

						var_17_35:height(var_17_2.pos.y - var_17_18 - var_17_36 + 10):anchorPoint(0.5, 0):xy(var_17_2.pos.x, var_17_18 - 10):addTo(arg_17_0.scrollview)
					end

					var_17_0[var_17_2.id] = var_17_28
				end
			elseif iter_17_0 > 1 and iter_17_0 ~= #arg_17_1 then
				local var_17_37 = (arg_17_1[iter_17_0 - 1][1].pos.y + iter_17_3.pos.y) / 2

				if var_17_1 then
					local var_17_38 = {}
					local var_17_39 = ccui.ImageView:create("city/adventure/gym_challenge/bar_1.png")

					table.insert(var_17_38, var_17_39)

					local var_17_40 = var_17_3 == 1 and iter_17_3.pos.x or iter_17_3.pos.x - (var_17_4 / 2 - 5)

					var_17_39:scaleX(1):anchorPoint(0.6875, 0.6875):xy(var_17_40, var_17_37):addTo(arg_17_0.scrollview)

					if #var_17_1.nextTalentIDs == 2 then
						local var_17_41 = ccui.Scale9Sprite:create()

						table.insert(var_17_38, var_17_41)
						var_17_41:initWithFile(cc.rect(15, 10, 1, 1), "city/adventure/gym_challenge/bar_3.png")
						var_17_41:height(var_17_39:x() - var_17_1.pos.x - 22):setRotation(270):anchorPoint(0.5, 0):xy(var_17_39:x() - 22, var_17_37):addTo(arg_17_0.scrollview)

						local var_17_42 = ccui.Scale9Sprite:create()

						table.insert(var_17_38, var_17_42)
						var_17_42:initWithFile(cc.rect(10, 27, 1, 1), "city/adventure/gym_challenge/bar_3.png")

						local var_17_43 = var_17_1.icon:getBoundingBox().height / 2

						var_17_42:height(var_17_1.pos.y - var_17_37 - var_17_43 + 10):anchorPoint(0.5, 0):xy(var_17_1.pos.x, var_17_37 - 10):addTo(arg_17_0.scrollview)
					else
						local var_17_44 = ccui.ImageView:create("city/adventure/gym_challenge/bar_1.png")

						table.insert(var_17_38, var_17_44)
						var_17_44:scale(-1):anchorPoint(0.6875, 0.6875):xy(var_17_1.pos.x, var_17_37):addTo(arg_17_0.scrollview)

						local var_17_45 = ccui.Scale9Sprite:create()

						table.insert(var_17_38, var_17_45)
						var_17_45:initWithFile(cc.rect(15, 10, 1, 1), "city/adventure/gym_challenge/bar_3.png")
						var_17_45:height(var_17_39:x() - var_17_1.pos.x - var_17_5 * 2):setRotation(90):anchorPoint(0.5, 0):xy(var_17_44:x() + var_17_5, var_17_37):addTo(arg_17_0.scrollview)

						local var_17_46 = ccui.Scale9Sprite:create()

						table.insert(var_17_38, var_17_46)
						var_17_46:initWithFile(cc.rect(10, 27, 1, 1), "city/adventure/gym_challenge/bar_3.png")

						local var_17_47 = var_17_1.icon:getBoundingBox().height / 2

						var_17_46:height(var_17_1.pos.y - var_17_37 - var_17_47 - var_17_5 + 10):anchorPoint(0.5, 0):xy(var_17_1.pos.x, var_17_37 + var_17_5):addTo(arg_17_0.scrollview)
					end

					if var_17_3 == 2 then
						local var_17_48 = ccui.Scale9Sprite:create()

						table.insert(var_17_38, var_17_48)
						var_17_48:initWithFile(cc.rect(15, 10, 1, 1), "city/adventure/gym_challenge/bar_5.png")
						var_17_48:height(var_17_37 - 22 - iter_17_3.pos.y - iter_17_3.icon:getBoundingBox().height / 2 + 15):scaleX(-1):anchorPoint(0.5, 1):xy(var_17_39:x(), var_17_37 - 22):addTo(arg_17_0.scrollview)
					else
						local var_17_49 = ccui.Scale9Sprite:create()

						table.insert(var_17_38, var_17_49)
						var_17_49:initWithFile(cc.rect(10, 27, 1, 1), "city/adventure/gym_challenge/bar_3.png")
						var_17_49:height(var_17_37 - 22 - iter_17_3.pos.y - iter_17_3.icon:getBoundingBox().height / 2):scaleX(-1):anchorPoint(0.5, 1):xy(var_17_39:x(), var_17_37 - 22):addTo(arg_17_0.scrollview)
					end

					var_17_0[var_17_1.id] = var_17_38
				end

				if var_17_2 then
					local var_17_50 = {}
					local var_17_51 = ccui.ImageView:create("city/adventure/gym_challenge/bar_1.png")

					table.insert(var_17_50, var_17_51)

					local var_17_52 = var_17_3 == 1 and iter_17_3.pos.x or iter_17_3.pos.x + (var_17_4 / 2 - 5)

					var_17_51:scaleX(-1):anchorPoint(0.6875, 0.6875):xy(var_17_52, var_17_37):addTo(arg_17_0.scrollview)

					if #var_17_2.nextTalentIDs == 2 then
						local var_17_53 = ccui.Scale9Sprite:create()

						table.insert(var_17_50, var_17_53)
						var_17_53:initWithFile(cc.rect(15, 10, 1, 1), "city/adventure/gym_challenge/bar_3.png")
						var_17_53:height(var_17_2.pos.x - var_17_51:x() - 22):setRotation(90):anchorPoint(0.5, 0):xy(var_17_51:x() + 22, var_17_37):addTo(arg_17_0.scrollview)

						local var_17_54 = ccui.Scale9Sprite:create()

						table.insert(var_17_50, var_17_54)
						var_17_54:initWithFile(cc.rect(10, 27, 1, 1), "city/adventure/gym_challenge/bar_3.png")

						local var_17_55 = var_17_2.icon:getBoundingBox().height / 2

						var_17_54:height(var_17_2.pos.y - var_17_37 - var_17_55 + 10):anchorPoint(0.5, 0):xy(var_17_2.pos.x, var_17_37 - 10):addTo(arg_17_0.scrollview)
					else
						local var_17_56 = ccui.ImageView:create("city/adventure/gym_challenge/bar_1.png")

						table.insert(var_17_50, var_17_56)
						var_17_56:scaleY(-1):anchorPoint(0.6875, 0.6875):xy(var_17_2.pos.x, var_17_37):addTo(arg_17_0.scrollview)

						local var_17_57 = ccui.Scale9Sprite:create()

						table.insert(var_17_50, var_17_57)
						var_17_57:initWithFile(cc.rect(15, 10, 1, 1), "city/adventure/gym_challenge/bar_3.png")
						var_17_57:height(var_17_2.pos.x - var_17_51:x() - var_17_5 * 2):setRotation(270):anchorPoint(0.5, 0):xy(var_17_56:x() - var_17_5, var_17_37):addTo(arg_17_0.scrollview)

						local var_17_58 = ccui.Scale9Sprite:create()

						table.insert(var_17_50, var_17_58)
						var_17_58:initWithFile(cc.rect(10, 27, 1, 1), "city/adventure/gym_challenge/bar_3.png")

						local var_17_59 = var_17_2.icon:getBoundingBox().height / 2

						var_17_58:height(var_17_2.pos.y - var_17_37 - var_17_59 - var_17_5 + 10):anchorPoint(0.5, 0):xy(var_17_2.pos.x, var_17_37 + var_17_5):addTo(arg_17_0.scrollview)
					end

					if var_17_3 == 2 then
						local var_17_60 = ccui.Scale9Sprite:create()

						table.insert(var_17_50, var_17_60)
						var_17_60:initWithFile(cc.rect(15, 10, 1, 1), "city/adventure/gym_challenge/bar_5.png")
						var_17_60:height(var_17_37 - 22 - iter_17_3.pos.y - iter_17_3.icon:getBoundingBox().height / 2 + 15):scaleX(1):anchorPoint(0.5, 1):xy(var_17_51:x(), var_17_37 - 22):addTo(arg_17_0.scrollview)
					else
						local var_17_61 = ccui.Scale9Sprite:create()

						table.insert(var_17_50, var_17_61)
						var_17_61:initWithFile(cc.rect(10, 27, 1, 1), "city/adventure/gym_challenge/bar_3.png")
						var_17_61:height(var_17_37 - 22 - iter_17_3.pos.y - iter_17_3.icon:getBoundingBox().height / 2):scaleX(1):anchorPoint(0.5, 1):xy(var_17_51:x(), var_17_37 - 22):addTo(arg_17_0.scrollview)
					end

					var_17_0[var_17_2.id] = var_17_50
				end
			end
		end
	end
end

function var_0_1.refreshShowData(arg_18_0, arg_18_1)
	arg_18_0.bufIcons = {}

	arg_18_0.scrollview:removeAllChildren()

	local var_18_0, var_18_1 = arg_18_0:getDepthData(arg_18_1)

	arg_18_0:drawBufIcon(var_18_0, var_18_1)
	arg_18_0:drawLine(var_18_0)
end

function var_0_1.onTabClick(arg_19_0, arg_19_1, arg_19_2)
	arg_19_0.showTab:set(arg_19_2)
end

function var_0_1.onResetClick(arg_20_0)
	local var_20_0 = arg_20_0.gymDatas:read().gym_talent_reset_times or 0
	local var_20_1 = math.min(var_20_0 + 1, csvSize(gCostCsv.gym_talent_reset_cost))
	local var_20_2 = gCostCsv.gym_talent_reset_cost[var_20_1]
	local var_20_3 = arg_20_0.gymDatas:read()

	if csvSize(var_20_3.gym_talent_trees) == 0 then
		gGameUI:showTip(gLanguageCsv.gymBuffCannotReset)

		return
	end

	local var_20_4 = string.format(gLanguageCsv.gymBuffReset, var_20_2)

	gGameUI:showDialog({
		clearFast = true,
		isRich = true,
		btnType = 2,
		strs = {
			var_20_4
		},
		cb = function()
			if gGameModel.role:read("rmb") >= var_20_2 then
				gGameApp:requestServer("/game/gym/talent/reset", function(arg_22_0)
					return
				end)
			else
				uiEasy.showDialog("rmb")
			end
		end,
		dialogParams = {
			clickClose = false
		}
	})
end

function var_0_1.onAddClick(arg_23_0)
	local var_23_0 = gCostCsv.gym_talent_point_buy_cost[math.min(arg_23_0.buyTimes:read() + 1, csvSize(gCostCsv.gym_talent_point_buy_cost))]

	if gGameModel.daily_record:read("gym_talent_point_buy_times") >= gVipCsv[gGameModel.role:read("vip_level")].gymTalentPointBuyTimes then
		gGameUI:showTip(gLanguageCsv.cardCapacityBuyMax)

		return
	end

	local var_23_1 = string.format(gLanguageCsv.gymBuffBuy, var_23_0, gCommonConfigCsv.gymTalentPointBuyCount)

	gGameUI:showDialog({
		clearFast = true,
		isRich = true,
		btnType = 2,
		strs = {
			var_23_1
		},
		cb = function()
			if gGameModel.role:read("rmb") >= var_23_0 then
				gGameApp:requestServer("/game/gym/talent/point/buy", function(arg_25_0)
					gGameUI:showTip(gLanguageCsv.buySuccess)
				end)
			else
				uiEasy.showDialog("rmb")
			end
		end,
		dialogParams = {
			clickClose = false
		}
	})
end

return var_0_1
