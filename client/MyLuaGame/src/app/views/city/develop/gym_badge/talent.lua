local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("gymBadgeTalentView", var_0_0)
local var_0_2 = {
	{
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8
	},
	{
		8
	},
	{
		7,
		8
	},
	{
		5,
		6,
		7,
		8
	},
	{
		4,
		5,
		6,
		7,
		8
	},
	{
		3,
		4,
		5,
		6,
		7,
		8
	}
}
local var_0_3 = {
	[4] = {
		effectName = "huo_effect",
		pointY = 0.5,
		pointX = 0.6,
		scale = 2,
		loopName = "huo_loop",
		xy = cc.p(799, 535)
	},
	[5] = {
		effectName = "long_effect",
		pointY = 0.7,
		pointX = 0.4,
		scale = 2,
		loopName = "long_loop",
		xy = cc.p(1000, 435)
	},
	[2] = {
		effectName = "shui_effect",
		pointY = 0.6,
		pointX = 0.6,
		scale = 2,
		loopName = "shui_loop",
		xy = cc.p(650, 420)
	},
	{
		effectName = "yan_effect",
		pointY = 0.6,
		pointX = 0.4,
		scale = 2,
		loopName = "yan_loop",
		xy = cc.p(775, 300)
	},
	[3] = {
		effectName = "cao_effect",
		pointY = 0.3,
		pointX = 0.5,
		scale = 2,
		loopName = "cao_loop",
		xy = cc.p(755, 680)
	},
	[6] = {
		effectName = "e_effect",
		pointY = 0.5,
		pointX = 0.4,
		scale = 2,
		loopName = "e_loop",
		xy = cc.p(870, 450)
	},
	[8] = {
		effectName = "yao_effect",
		pointY = 0.4,
		pointX = 0.6,
		scale = 2,
		loopName = "yao_loop",
		xy = cc.p(620, 600)
	},
	[7] = {
		effectName = "du_effect",
		pointY = 0,
		pointX = 0,
		scale = 2,
		loopName = "du_loop",
		xy = cc.p(930, 680)
	}
}
local var_0_4 = {
	{
		scale = 1.4,
		scaleBattom = 1.4,
		x = 110,
		y = 45
	},
	{
		scale = 1.3,
		scaleBattom = 1.3,
		x = 88,
		y = 40
	},
	{
		scale = 1.2,
		scaleBattom = 1.2,
		x = 68,
		y = 36
	},
	{
		scale = 1.2,
		scaleBattom = 1.2,
		x = 75,
		y = 40
	},
	{
		scale = 1.3,
		scaleBattom = 1.3,
		x = 88,
		y = 30
	},
	{
		scale = 1.4,
		scaleBattom = 1.4,
		x = 117,
		y = 45
	}
}

var_0_1.RESOURCE_FILENAME = "gym_badge_talent.json"
var_0_1.RESOURCE_BINDING = {
	["leftPanel.top.talentBottom3"] = "talentBottom3",
	["leftPanel.middle.item"] = "leftItem",
	["leftPanel.top.nameBg1"] = "nameBg1",
	["leftPanel.top.talentBottom6"] = "talentBottom6",
	["leftPanel.top.badge"] = "badgeIcon",
	["leftPanel.top.item"] = "natureItem",
	["rightPanel.top"] = "rightTop",
	["rightPanel.bottom.btnPanel.btn.title"] = "title",
	["rightPanel.bottom.costPanel"] = "costPanel",
	["leftPanel.middle"] = "leftMiddle",
	["leftPanel.bottomPanel.item"] = "bottomItem",
	["rightPanel.bottom"] = "rightBottom",
	["rightPanel.bottom.btnPanel"] = "btnPanel",
	["leftPanel.bottomPanel.subList"] = "subList",
	["rightPanel.top.item"] = "rightTalentItem",
	["leftPanel.bottomPanel"] = "leftBottom",
	["leftPanel.top.talentBottom4"] = "talentBottom4",
	leftPanel = "leftPanel",
	["leftPanel.top.name"] = "badgeName",
	["leftPanel.top.talentBottom5"] = "talentBottom5",
	["leftPanel.top.nameBg6"] = "nameBg6",
	["leftPanel.top.nameBg3"] = "nameBg3",
	["rightPanel.bottom.costPanel.item"] = "costItem",
	["leftPanel.top.talentBottom1"] = "talentBottom1",
	["leftPanel.top.nameBg5"] = "nameBg5",
	["leftPanel.top.nameBg2"] = "nameBg2",
	["leftPanel.top.talentBottom2"] = "talentBottom2",
	["leftPanel.top.nameBg4"] = "nameBg4",
	["rightPanel.bottom.btnPanel.fastUpgradePanel.checkBox"] = "checkBox",
	["leftPanel.top"] = "leftTop",
	rightPanel = "rightPanel",
	["leftPanel.top.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("natureData"),
				item = bindHelper.self("natureItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("icon"):texture(ui.ATTR_ICON[arg_1_3])
				end
			},
			handlers = {}
		}
	},
	["leftPanel.top.left"] = {
		varname = "leftBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onLeftBtn")
			}
		}
	},
	["leftPanel.top.right"] = {
		varname = "rightBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRightBtn")
			}
		}
	},
	["leftPanel.top.awakeBtn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAwake")
			}
		}
	},
	["leftPanel.top.awakeBtn.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["leftPanel.middle.list"] = {
		varname = "guardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("guardTeam"),
				item = bindHelper.self("leftItem"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("icon")

					if arg_2_3.icon then
						var_2_0.icon:texture(arg_2_3.icon)
					else
						var_2_0.icon:hide()
					end
				end
			}
		}
	},
	["leftPanel.middle.btn"] = {
		varname = "setBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSet")
			}
		}
	},
	["leftPanel.middle.btn.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["leftPanel.bottomPanel.list"] = {
		varname = "bottomList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 2,
				data = bindHelper.self("natureAddData"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("bottomItem"),
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					arg_3_1:get("txt1"):text(getLanguageAttr(arg_3_3.id))
					arg_3_1:get("num1"):text("+" .. arg_3_3.num)

					if arg_3_3.icon then
						arg_3_1:get("icon"):texture(arg_3_3.icon)
						adapt.oneLinePos(arg_3_1:get("icon"), arg_3_1:get("txt1"), cc.p(15, 0), "left")
						adapt.oneLinePos(arg_3_1:get("txt1"), arg_3_1:get("num1"), cc.p(15, 0), "left")
					else
						arg_3_1:get("icon"):hide()
						adapt.oneLinePos(arg_3_1:get("txt1"), arg_3_1:get("num1"), cc.p(5, 0), "left")
					end
				end
			},
			handlers = {}
		}
	},
	["rightPanel.top.list"] = {
		varname = "talentList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("rightTalent"),
				item = bindHelper.self("rightTalentItem"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("txt1", "txt2", "txt3", "maxIcon", "icon")

					if arg_4_3.name == "Lv." then
						var_4_0.txt1:text(arg_4_3.name .. arg_4_3.num)
						var_4_0.txt2:text(arg_4_3.name .. arg_4_3.num1)
					else
						var_4_0.txt1:text(arg_4_3.name .. "+" .. arg_4_3.num)
						var_4_0.txt2:text(arg_4_3.name .. "+" .. arg_4_3.num1)
					end

					if arg_4_3.isMax then
						var_4_0.maxIcon:show()
						var_4_0.icon:hide()
						var_4_0.txt2:hide()
					else
						var_4_0.maxIcon:hide()
						var_4_0.icon:show()
						var_4_0.txt2:show()
					end

					adapt.oneLinePos(var_4_0.txt1, {
						var_4_0.icon,
						var_4_0.txt2
					}, cc.p(50, 0), "left")
					adapt.oneLinePos(var_4_0.txt1, var_4_0.maxIcon, cc.p(50, 0), "left")
				end
			},
			handlers = {}
		}
	},
	["rightPanel.bottom.btnPanel.fastUpgradePanel"] = {
		varname = "fastUpgradePanel",
		binds = {
			event = "click",
			method = bindHelper.self("onFastUpgradeClick")
		}
	},
	["rightPanel.bottom.costPanel.list"] = {
		varname = "costList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("talentItem"),
				item = bindHelper.self("costItem"),
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = false

					if arg_5_3.targetNum then
						var_5_0 = arg_5_3.num < (arg_5_3.targetNum or 0)
					end

					arg_5_1:get("btnAdd"):visible(var_5_0)
					bind.extend(arg_5_0, arg_5_1, {
						class = "icon_key",
						props = {
							grayState = var_5_0 and 1 or 0,
							data = {
								key = arg_5_3.key,
								num = arg_5_3.num,
								targetNum = arg_5_3.targetNum
							},
							onNode = function(arg_6_0)
								bind.click(arg_5_0, arg_6_0, {
									method = functools.partial(arg_5_0.itemClick, arg_6_0, arg_5_2, arg_5_3)
								})
							end
						}
					})
				end,
				onAfterBuild = function(arg_7_0)
					arg_7_0:setClippingEnabled(false)
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	["rightPanel.bottom.btnPanel.btn"] = {
		varname = "lightBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSetLight")
			}
		}
	}
}

function var_0_1.onCreate(arg_8_0, arg_8_1)
	arg_8_0.badgeNumb = idler.new(arg_8_1.badgeNumb)
	arg_8_0.isView = arg_8_1.isView

	arg_8_0:initModel()
	gGameUI.topuiManager:createView("default", arg_8_0, {
		onClose = arg_8_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_bagua.png"
	})

	arg_8_0.talentItem = idlers.new()
	arg_8_0.guardTeam = idlers.new()
	arg_8_0.natureData = idlers.new()
	arg_8_0.natureAddData = idlers.new()
	arg_8_0.rightTalent = idlers.new()
	arg_8_0.nodeNum = idler.new(1)
	arg_8_0.myNum = idler.new(1)
	arg_8_0.canAwake = false
	arg_8_0.isLightMax = false
	arg_8_0.isLightIn = false
	arg_8_0.checkBoxState = idler.new(false)

	arg_8_0.checkBox:setSelectedState(arg_8_0.checkBoxState:read())

	if not dataEasy.isUnlock(gUnlockCsv.badgeOneKey) then
		arg_8_0.fastUpgradePanel:setVisible(false)
	else
		arg_8_0.fastUpgradePanel:setVisible(true)
	end

	local function var_8_0(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		local var_9_0 = csv.gym_badge.badge
		local var_9_1 = csv.gym_badge.talent
		local var_9_2 = csv.gym_badge.talent_cost
		local var_9_3 = var_9_0[arg_9_2].talentIDs
		local var_9_4 = {}
		local var_9_5 = 0
		local var_9_6 = 1
		local var_9_7 = 2
		local var_9_8 = {}
		local var_9_9 = 0
		local var_9_10 = {}

		for iter_9_0 = 1, 6 do
			table.insert(var_9_8, {
				var_9_3[(arg_9_0 + iter_9_0 - 2) % 6 + 1],
				arg_9_3[var_9_3[(arg_9_0 + iter_9_0 - 2) % 6 + 1]] or 0
			})
		end

		for iter_9_1, iter_9_2 in pairs(var_9_8) do
			local var_9_11 = iter_9_2[1]
			local var_9_12 = iter_9_2[2]
			local var_9_13 = var_9_1[var_9_11].costSeqID
			local var_9_14 = var_9_2[var_9_12]["cost" .. var_9_13]

			if var_9_7 == 1 then
				break
			end

			for iter_9_3, iter_9_4 in ipairs(dataEasy.getItemData(var_9_14)) do
				if var_9_7 == 2 then
					if iter_9_4.key ~= "rmb" and iter_9_4.key ~= "gold" then
						if (arg_9_4[iter_9_4.key] or 0) < iter_9_4.num then
							var_9_7 = -1
						end
					elseif iter_9_4.num > arg_8_0.gold:read() then
						var_9_7 = -1
					end
				end

				if iter_9_4.key ~= "rmb" and iter_9_4.key ~= "gold" then
					local var_9_15 = 0

					for iter_9_5, iter_9_6 in ipairs(var_9_4) do
						if iter_9_4.key == iter_9_6.key then
							if iter_9_4.num + iter_9_6.targetNum > (arg_9_4[iter_9_4.key] or 0) and var_9_7 ~= -1 or csv.gym_badge.badge[arg_9_2].talentMaxLevel <= iter_9_2[2] then
								var_9_7 = 1

								break
							end

							iter_9_6.targetNum = iter_9_4.num + iter_9_6.targetNum
							var_9_6 = var_9_6 + 1

							break
						end

						var_9_15 = var_9_15 + 1
					end

					if var_9_15 == #var_9_4 then
						table.insert(var_9_4, {
							key = iter_9_4.key,
							num = arg_9_4[iter_9_4.key] or 0,
							targetNum = iter_9_4.num
						})
					end
				else
					if var_9_5 + iter_9_4.num > arg_8_0.gold:read() and var_9_7 ~= -1 or csv.gym_badge.badge[arg_9_2].talentMaxLevel <= iter_9_2[2] then
						var_9_7 = 1

						break
					end

					var_9_5 = var_9_5 + iter_9_4.num
				end
			end

			if var_9_7 == 2 then
				var_9_7 = 0
			end

			if var_9_7 ~= 1 then
				var_9_9 = var_9_5
				var_9_10 = var_9_4
			end
		end

		return var_9_9, var_9_10, var_9_6
	end

	local var_8_1 = csv.gym_badge.badge
	local var_8_2 = csv.gym_badge.talent
	local var_8_3 = csv.gym_badge.talent_cost
	local var_8_4 = csv.gym_badge.guard

	idlereasy.any({
		arg_8_0.badges,
		arg_8_0.badgeNumb
	}, function(arg_10_0, arg_10_1, arg_10_2)
		local var_10_0 = 1
		local var_10_1 = arg_10_1 and arg_10_1[arg_10_2] or {}
		local var_10_2 = var_10_1.talents or {}
		local var_10_3 = var_10_1.guards or {}
		local var_10_4 = var_10_1.awake or 0
		local var_10_5 = var_8_1[arg_10_2].preTalentLevel[var_10_4 + 1] or 999
		local var_10_6 = var_8_1[arg_10_2].talentIDs
		local var_10_7 = var_8_1[arg_10_2].guardIDs
		local var_10_8 = 0

		arg_8_0.isLightMax = false

		if var_10_2[var_10_6[6]] then
			if var_10_2[var_10_6[6]] >= var_8_1[arg_10_2].talentMaxLevel then
				arg_8_0.isLightMax = true
			end

			if var_10_5 <= var_10_2[var_10_6[6]] and var_10_4 < var_8_1[arg_10_2].awakeMaxLevel then
				arg_8_0.canAwake = true

				widget.addAnimationByKey(arg_8_0.leftTop:get("bg"), "daoguanhuizhang/huizhang_tianfu.skel", "spine4", "diquan_loop", 0):alignCenter(arg_8_0.leftTop:get("bg"):size()):xy(500, 100):scale(1)
			else
				arg_8_0.leftTop:get("bg"):removeAllChildren()

				arg_8_0.canAwake = false

				for iter_10_0 = 1, 8 do
					arg_8_0.leftTop:get("line" .. iter_10_0):show()
				end
			end
		else
			arg_8_0.leftTop:get("bg"):removeAllChildren()
		end

		arg_8_0.rightTop:get("icon"):texture(var_8_1[arg_10_2].showIcon3)
		widget.addAnimation(arg_8_0.rightTop:get("icon"), "effect/shipinfaguang.skel", "effect_loop", 20):scale(0.4):xy(-50, 0)

		local var_10_9 = var_10_4 ~= 0 and dataEasy.parsePercentStr(dataEasy.getAttrValueString(var_8_1[arg_10_2].attrType1, var_8_1[arg_10_2].awakeTalentAttrs[var_10_4])) or 0
		local var_10_10 = arg_8_0:guardAllTalent(arg_10_2, var_10_3)
		local var_10_11 = 1
		local var_10_12 = var_10_2[var_10_6[6]] or 0
		local var_10_13 = {
			0,
			nil,
			nil,
			nil,
			nil,
			nil,
			0,
			0,
			0,
			0,
			nil,
			nil,
			0
		}

		for iter_10_1, iter_10_2 in ipairs(var_10_6) do
			if var_10_2[iter_10_2] then
				var_10_8 = var_10_8 + 1

				local var_10_14 = var_8_2[iter_10_2].attrType1
				local var_10_15 = var_8_2[iter_10_2].attrType2

				if var_10_14 then
					local var_10_16 = dataEasy.getAttrValueString(var_10_14, var_8_2[iter_10_2].attrNum1[var_10_2[iter_10_2]] * ((100 + var_10_9) / 100) * ((100 + var_10_10) / 100), 0)

					var_10_13[var_10_14] = var_10_13[var_10_14] + var_10_16
				end

				if var_10_15 then
					local var_10_17 = dataEasy.getAttrValueString(var_10_15, var_8_2[iter_10_2].attrNum2[var_10_2[iter_10_2]] * ((100 + var_10_9) / 100) * ((100 + var_10_10) / 100), 0)

					var_10_13[var_10_15] = var_10_13[var_10_15] + var_10_17
				end

				if var_10_12 < var_10_2[iter_10_2] or arg_8_0.isLightMax then
					arg_8_0["talentBottom" .. iter_10_1]:get("num"):text(var_10_2[iter_10_2])
					arg_8_0["talentBottom" .. iter_10_1]:get("battomIcon"):show()
					arg_8_0["talentBottom" .. iter_10_1]:get("icon"):show()

					var_10_11 = var_10_11 + 1
				end
			end

			arg_8_0["nameBg" .. iter_10_1]:get("txt"):text(var_8_2[iter_10_2].name)
		end

		if var_10_8 == 0 then
			var_10_0 = 1
		elseif var_10_8 < 6 then
			var_10_0 = var_10_8 + 1
		else
			local var_10_18 = var_10_2[var_10_6[1]]

			for iter_10_3, iter_10_4 in ipairs(var_10_6) do
				if var_10_2[iter_10_4] ~= var_10_18 then
					var_10_0 = iter_10_3

					break
				end
			end
		end

		arg_8_0.nodeNum:set(var_10_0)
		arg_8_0.myNum:set(var_10_0)
		arg_8_0:setProgress(var_10_0, var_10_2)
		arg_8_0:createSpine(var_10_11, var_10_2, var_10_6)
		adapt.oneLineCenterPos(cc.p(110, 23), {
			arg_8_0.talentBottom1:get("txt"),
			arg_8_0.talentBottom1:get("num")
		}, cc.p(0, 0))
		adapt.oneLineCenterPos(cc.p(85, 23), {
			arg_8_0.talentBottom2:get("txt"),
			arg_8_0.talentBottom2:get("num")
		}, cc.p(0, 0))
		adapt.oneLineCenterPos(cc.p(70, 23), {
			arg_8_0.talentBottom3:get("txt"),
			arg_8_0.talentBottom3:get("num")
		}, cc.p(0, 0))
		adapt.oneLineCenterPos(cc.p(70, 23), {
			arg_8_0.talentBottom4:get("txt"),
			arg_8_0.talentBottom4:get("num")
		}, cc.p(0, 0))
		adapt.oneLineCenterPos(cc.p(95, 23), {
			arg_8_0.talentBottom5:get("txt"),
			arg_8_0.talentBottom5:get("num")
		}, cc.p(0, 0))
		adapt.oneLineCenterPos(cc.p(119, 28), {
			arg_8_0.talentBottom6:get("txt"),
			arg_8_0.talentBottom6:get("num")
		}, cc.p(0, 0))

		local var_10_19 = {}

		for iter_10_5, iter_10_6 in ipairs(var_10_7) do
			local var_10_20

			if var_10_3[iter_10_6] then
				local var_10_21 = gGameModel.cards:find(var_10_3[iter_10_6])

				if var_10_21 then
					var_10_20 = dataEasy.getUnitCsv(var_10_21:read("card_id"), var_10_21:read("skin_id")).iconSimple
				end

				table.insert(var_10_19, {
					icon = var_10_20
				})
			end
		end

		local var_10_22 = matchLanguage({
			"en"
		}) and 450 or 400

		arg_8_0.setBtn:x(var_10_22 + #var_10_19 * 160)
		arg_8_0.guardTeam:update(var_10_19)
		arg_8_0:createNatureAddData(var_10_13, var_10_4, var_8_1, arg_10_2)
		adapt.oneLineCenterPos(cc.p(800, 719), {
			arg_8_0.badgeName,
			arg_8_0.list
		}, cc.p(10, 0))
		arg_8_0.list:y(arg_8_0.list:y() - 40)

		arg_8_0.isLightIn = false
	end)
	idlereasy.when(arg_8_0.badgeNumb, function(arg_11_0, arg_11_1)
		local var_11_0 = var_8_1[arg_11_1].talentIDs

		arg_8_0.natureData:update(var_8_1[arg_11_1].nature)

		if not (arg_11_1 - 1 > 0) or not (arg_11_1 - 1) then
			local var_11_1
		end

		if not (arg_11_1 + 1 <= 8) or not (arg_11_1 + 1) then
			local var_11_2
		end

		arg_8_0.leftTop:removeChildByName("badgeSpine")

		local var_11_3 = widget.addAnimationByKey(arg_8_0.leftTop, "daoguanhuizhang/dghz.skel", "badgeSpine", var_0_3[arg_11_1].loopName, 100):xy(800, 420):scale(2)

		arg_8_0.badgeIcon:onTouch(functools.partial(arg_8_0.onAwake, arg_8_0, arg_11_1))

		for iter_11_0, iter_11_1 in ipairs(var_11_0) do
			arg_8_0["talentBottom" .. iter_11_0]:get("icon"):texture(var_8_1[arg_11_1].showIcon3)
		end

		arg_8_0.leftBtn:visible(arg_11_1 ~= 1)
		arg_8_0.rightBtn:visible(arg_11_1 ~= 8)
	end)

	for iter_8_0 = 1, 6 do
		bind.touch(arg_8_0, arg_8_0["talentBottom" .. iter_8_0], {
			methods = {
				ended = function()
					arg_8_0:onMyNodeClick(iter_8_0)
				end
			}
		})
	end

	idlereasy.any({
		arg_8_0.items,
		arg_8_0.nodeNum,
		arg_8_0.myNum,
		arg_8_0.gold,
		arg_8_0.badgeNumb,
		arg_8_0.badges,
		arg_8_0.checkBoxState
	}, function(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7)
		local var_13_0 = {}
		local var_13_1 = 0
		local var_13_2 = arg_13_6 and arg_13_6[arg_13_5] or {}
		local var_13_3 = var_13_2.talents or {}
		local var_13_4 = var_13_2.guards or {}
		local var_13_5 = var_13_2.awake or 0
		local var_13_6 = var_8_1[arg_13_5].talentIDs
		local var_13_7 = nodetools.multiget(arg_8_0.rightTop, "name", "txt1", "txt2", "num1", "num2", "num3", "num4", "num5", "num6", "txt3", "txt4", "txt5", "txt6", "icon3")
		local var_13_8 = var_13_3[var_13_6[arg_13_3]] or 0
		local var_13_9 = var_8_1[arg_13_5].talentIDs[arg_13_3]
		local var_13_10 = var_8_1[arg_13_5].talentIDs[arg_13_2]
		local var_13_11 = var_8_2[var_13_10].costSeqID
		local var_13_12 = var_8_3[var_13_8]["cost" .. var_13_11]
		local var_13_13 = var_8_2[var_13_9].attrType1
		local var_13_14 = var_8_2[var_13_9].attrType2
		local var_13_15 = var_8_2[var_13_9].attrNum1
		local var_13_16 = var_8_2[var_13_9].attrNum2

		arg_8_0:setBtnState(arg_13_5, arg_13_3, var_13_6)
		var_13_7.name:text(var_8_2[var_13_9].name)

		local var_13_17 = {}
		local var_13_18 = false

		if var_13_3[var_13_6[arg_13_3]] and var_13_3[var_13_6[arg_13_3]] >= var_8_1[arg_13_5].talentMaxLevel then
			var_13_18 = true

			arg_8_0.rightBottom:hide()
			arg_8_0.rightPanel:get("maxBg"):show()
		else
			arg_8_0.rightBottom:show()
			arg_8_0.rightPanel:get("maxBg"):hide()
		end

		table.insert(var_13_17, {
			name = "Lv.",
			num = var_13_8,
			num1 = var_13_8 + 1,
			isMax = var_13_18
		})

		local var_13_19 = var_13_5 ~= 0 and dataEasy.parsePercentStr(dataEasy.getAttrValueString(var_8_1[arg_13_5].attrType1, var_8_1[arg_13_5].awakeTalentAttrs[var_13_5])) or 0
		local var_13_20 = arg_8_0:guardAllTalent(arg_13_5, var_13_4)

		if var_13_13 then
			local var_13_21 = var_13_15[var_13_8] or 0
			local var_13_22 = dataEasy.getAttrValueString(var_13_13, math.floor(var_13_21 * ((100 + var_13_19) / 100) * ((100 + var_13_20) / 100)))
			local var_13_23 = var_13_15 and var_13_15[var_13_8 + 1] or 0
			local var_13_24 = dataEasy.getAttrValueString(var_13_13, math.floor(var_13_23 * ((100 + var_13_19) / 100) * ((100 + var_13_20) / 100)))

			table.insert(var_13_17, {
				num = var_13_22,
				num1 = var_13_24,
				isMax = var_13_18,
				name = getLanguageAttr(var_13_13)
			})
		end

		if var_13_14 then
			local var_13_25 = var_13_16[var_13_8] or 0
			local var_13_26 = dataEasy.getAttrValueString(var_13_13, math.floor(var_13_25 * ((100 + var_13_19) / 100) * ((100 + var_13_20) / 100)))
			local var_13_27 = var_13_16[var_13_8 + 1] or 0
			local var_13_28 = dataEasy.getAttrValueString(var_13_13, math.floor(var_13_27 * ((100 + var_13_19) / 100) * ((100 + var_13_20) / 100)))

			table.insert(var_13_17, {
				num = var_13_26,
				num1 = var_13_28,
				isMax = var_13_18,
				name = getLanguageAttr(var_13_14)
			})
		end

		arg_8_0.rightTalent:update(var_13_17)

		if not arg_13_7 then
			for iter_13_0, iter_13_1 in ipairs(dataEasy.getItemData(var_13_12)) do
				if iter_13_1.key ~= "rmb" and iter_13_1.key ~= "gold" then
					table.insert(var_13_0, {
						key = iter_13_1.key,
						num = arg_13_1[iter_13_1.key] or 0,
						targetNum = iter_13_1.num
					})
				end
			end

			var_13_1 = var_13_12.gold

			arg_8_0.title:text(gLanguageCsv.lightUp)
		else
			arg_8_0.times = 6
			var_13_1, var_13_0, arg_8_0.times = var_8_0(arg_13_2, arg_13_3, arg_13_5, var_13_3, arg_13_1)

			arg_8_0.title:text(gLanguageCsv.lightUp .. arg_8_0.times .. gLanguageCsv.times)
		end

		arg_8_0.item = var_13_0

		local var_13_29 = #var_13_0

		arg_8_0.costList:size(200 * var_13_29, 200)
		arg_8_0.talentItem:update(var_13_0)

		arg_8_0.costGold = var_13_1

		if arg_13_3 == arg_13_2 then
			arg_8_0.lightBtn:setTouchEnabled(true)

			if arg_8_0.costGold > 0 then
				arg_8_0.btnPanel:get("text"):show()
				arg_8_0.btnPanel:get("text"):text(arg_8_0.costGold)

				local var_13_30 = var_13_1 < arg_8_0.costGold and ui.COLORS.NORMAL.RED or ui.COLORS.NORMAL.WHITE

				text.addEffect(arg_8_0.btnPanel:get("text"), {
					color = var_13_30
				})
				arg_8_0.btnPanel:get("text1"):show()
				arg_8_0.btnPanel:get("icon"):show()
				arg_8_0.costPanel:visible(#var_13_0 > 0)
				adapt.oneLineCenterPos(cc.p(163, 214), {
					arg_8_0.btnPanel:get("text1"),
					arg_8_0.btnPanel:get("text"),
					arg_8_0.btnPanel:get("icon")
				}, cc.p(15, 0))
			end

			cache.setShader(arg_8_0.lightBtn, false, "normal")
			text.addEffect(arg_8_0.title, {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		else
			cache.setShader(arg_8_0.lightBtn, false, "hsl_gray")
			text.deleteAllEffect(arg_8_0.title)
		end
	end)
end

function var_0_1.setBtnState(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if arg_14_1 ~= 1 then
		if not arg_14_0:getNextNum(arg_14_1, "left") then
			cache.setShader(arg_14_0.leftBtn, false, "hsl_gray")
		else
			cache.setShader(arg_14_0.leftBtn, false, "normal")
		end
	else
		cache.setShader(arg_14_0.leftBtn, false, "normal")
	end

	if arg_14_1 ~= 8 then
		if not arg_14_0:getNextNum(arg_14_1, "right") then
			cache.setShader(arg_14_0.rightBtn, false, "hsl_gray")
		else
			cache.setShader(arg_14_0.rightBtn, false, "normal")
		end
	else
		cache.setShader(arg_14_0.rightBtn, false, "normal")
	end

	widget.addAnimationByKey(arg_14_0["talentBottom" .. arg_14_2], "daoguanhuizhang/huizhang_tianfu.skel", "spine5", "xuanzhong_loop", 10):xy(var_0_4[arg_14_2].x, var_0_4[arg_14_2].y):scale(var_0_4[arg_14_2].scaleBattom)

	for iter_14_0, iter_14_1 in ipairs(arg_14_3) do
		if iter_14_0 ~= arg_14_2 and arg_14_0["talentBottom" .. iter_14_0]:getChildByName("spine5") then
			arg_14_0["talentBottom" .. iter_14_0]:removeChildByName("spine5")
		end
	end
end

function var_0_1.createSpine(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	for iter_15_0 = arg_15_1, 6 do
		arg_15_0["talentBottom" .. iter_15_0]:get("icon"):hide()

		if arg_15_0["talentBottom" .. iter_15_0]:getChildByName("spine") then
			arg_15_0["talentBottom" .. iter_15_0]:removeChildByName("spine")
		end

		widget.addAnimationByKey(arg_15_0["talentBottom" .. iter_15_0], "daoguanhuizhang/huizhang_tianfu.skel", "spine", "hui_loop", 2):xy(var_0_4[iter_15_0].x, var_0_4[iter_15_0].y):scale(var_0_4[iter_15_0].scale)
		arg_15_0["talentBottom" .. iter_15_0]:get("num"):text(arg_15_2[arg_15_3[iter_15_0]] or 0)
	end
end

function var_0_1.createNatureAddData(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	local var_16_0 = {}

	for iter_16_0, iter_16_1 in pairs(arg_16_1) do
		if iter_16_1 > 0 then
			local var_16_1 = game.ATTRDEF_TABLE[iter_16_0]
			local var_16_2 = ui.ATTR_LOGO[var_16_1]

			table.insert(var_16_0, {
				id = iter_16_0,
				num = math.floor(iter_16_1),
				icon = var_16_2
			})
		end
	end

	if arg_16_2 > 0 then
		local var_16_3 = arg_16_3[arg_16_4].attrType1
		local var_16_4 = arg_16_3[arg_16_4].attrType2

		if var_16_3 then
			local var_16_5 = arg_16_3[arg_16_4].attrNum1[arg_16_2] or 0
			local var_16_6 = dataEasy.getAttrValueString(var_16_3, var_16_5)

			if var_16_5 > 0 then
				table.insert(var_16_0, {
					id = var_16_3,
					num = var_16_6
				})
			end
		end

		if var_16_4 then
			local var_16_7 = arg_16_3[arg_16_4].attrNum2[arg_16_2] or 0
			local var_16_8 = dataEasy.getAttrValueString(var_16_4, var_16_7)

			if var_16_7 > 0 then
				table.insert(var_16_0, {
					id = var_16_4,
					num = var_16_8
				})
			end
		end

		arg_16_0.badgeName:text(arg_16_3[arg_16_4].name .. "+" .. arg_16_2)
	else
		arg_16_0.badgeName:text(arg_16_3[arg_16_4].name)
	end

	table.sort(var_16_0, function(arg_17_0, arg_17_1)
		return arg_17_0.id < arg_17_1.id
	end)

	if itertools.isempty(var_16_0) then
		arg_16_0.leftBottom:get("txt"):text(gLanguageCsv.noAttributeBonusNow)
		arg_16_0.leftBottom:get("txt"):show()
	else
		arg_16_0.leftBottom:get("txt"):hide()
	end

	arg_16_0.natureAddData:update(var_16_0)
end

function var_0_1.initModel(arg_18_0)
	arg_18_0.badges = gGameModel.role:getIdler("badges")
	arg_18_0.items = gGameModel.role:getIdler("items")
	arg_18_0.rmb = gGameModel.role:getIdler("rmb")
	arg_18_0.gold = gGameModel.role:getIdler("gold")
	arg_18_0.level = gGameModel.role:getIdler("level")
end

function var_0_1.onAwake(arg_19_0, arg_19_1, arg_19_2)
	if type(arg_19_1) == "number" then
		if not arg_19_0.leftTop:getChildByName("badgeSpine") then
			return
		end

		if arg_19_2.name == "began" then
			arg_19_0.leftTop:getChildByName("badgeSpine"):scale(1.8)
		elseif arg_19_2.name == "ended" then
			arg_19_0.leftTop:getChildByName("badgeSpine"):scale(2)
			gGameUI:stackUI("city.develop.gym_badge.badge_awake", nil, nil, arg_19_1)
		elseif arg_19_2.name == "cancelled" then
			arg_19_0.leftTop:getChildByName("badgeSpine"):scale(2)
		end
	else
		gGameUI:stackUI("city.develop.gym_badge.badge_awake", nil, nil, arg_19_0.badgeNumb:read())
	end
end

function var_0_1.onMyNodeClick(arg_20_0, arg_20_1)
	arg_20_0.myNum:set(arg_20_1)
end

function var_0_1.onSet(arg_21_0)
	gGameUI:stackUI("city.develop.gym_badge.guard", nil, {
		full = true
	}, arg_21_0.badgeNumb:read())
end

function var_0_1.onSetLight(arg_22_0)
	local var_22_0 = arg_22_0.checkBoxState:read() == true and arg_22_0.times or 1

	if arg_22_0.myNum:read() ~= arg_22_0.nodeNum:read() then
		gGameUI:showTip(gLanguageCsv.setPrevLightFirst)

		return
	end

	if arg_22_0.costGold and arg_22_0.gold:read() < arg_22_0.costGold then
		uiEasy.showDialog("gold", nil, {
			dialog = true
		})

		return
	end

	for iter_22_0, iter_22_1 in ipairs(arg_22_0.item or {}) do
		if iter_22_1.targetNum > iter_22_1.num then
			gGameUI:showTip(gLanguageCsv.branchItemsNotEnough)

			return
		end
	end

	local var_22_1 = csv.gym_badge.badge[arg_22_0.badgeNumb:read()].talentIDs

	if not arg_22_0.isLightMax then
		local var_22_2 = {
			false
		}

		for iter_22_2 = 1, var_22_0 do
			local var_22_3 = (arg_22_0.nodeNum:read() + iter_22_2 - 2) % 6 + 1

			performWithDelay(arg_22_0["talentBottom" .. var_22_3], function()
				if var_22_3 == 1 then
					for iter_23_0, iter_23_1 in ipairs(var_22_1) do
						arg_22_0["talentBottom" .. iter_23_0]:get("icon"):hide()

						if arg_22_0["talentBottom" .. iter_23_0]:getChildByName("spine2") then
							arg_22_0["talentBottom" .. iter_23_0]:removeChildByName("spine2")
						end

						if not arg_22_0["talentBottom" .. iter_23_0]:getChildByName("spine") then
							widget.addAnimationByKey(arg_22_0["talentBottom" .. iter_23_0], "daoguanhuizhang/huizhang_tianfu.skel", "spine", "hui_loop", 2):xy(var_0_4[iter_23_0].x, var_0_4[iter_23_0].y):scale(var_0_4[iter_23_0].scale)
						end
					end
				end

				local var_23_0 = arg_22_0["talentBottom" .. var_22_3]:getChildByName("spine2")

				if not var_23_0 then
					widget.addAnimationByKey(arg_22_0["talentBottom" .. var_22_3], "daoguanhuizhang/huizhang_tianfu.skel", "spine2", "dianliang_effect", 2):xy(var_0_4[var_22_3].x, var_0_4[var_22_3].y):scale(var_0_4[var_22_3].scale)
				else
					var_23_0:show():play("dianliang_effect")
				end
			end, 0.1 * iter_22_2)
		end

		gGameApp:requestServerCustom("/game/badge/talent/level/up"):params(arg_22_0.badgeNumb:read(), var_22_0):onResponse(function(arg_24_0)
			for iter_24_0, iter_24_1 in pairs(arg_22_0.talentList:getChildren()) do
				local var_24_0 = iter_24_1:get("spine")

				if not var_24_0 then
					local var_24_1 = widget.addAnimationByKey(iter_24_1, "effect/shuzisaoguang.skel", "spine", "effect", 122):xy(iter_24_1:get("icon"):xy()):scale(0.5)
				else
					var_24_0:play("effect")
				end
			end

			local var_24_2 = arg_22_0.rightTop:get("upEffect")

			if var_24_2 then
				var_24_2:play("fangguang2")
			else
				local var_24_3 = widget.addAnimationByKey(arg_22_0.rightTop, "koudai_gonghuixunlian/gonghuixunlian.skel", "upEffect", "fangguang2", 10000)

				var_24_3:xy(arg_22_0.rightTop:get("icon"):x(), arg_22_0.rightTop:get("icon"):y() - 80)
				var_24_3:scale(0.8)
			end

			local var_24_4 = arg_22_0.times and 0.7 or 0.5

			performWithDelay(arg_22_0, function()
				var_22_2[1] = true
			end, var_24_4)
		end):wait(var_22_2):doit(function()
			return
		end)

		arg_22_0.isLightIn = true
	else
		gGameUI:showTip(gLanguageCsv.lightAlreadyMax)
	end
end

function var_0_1.onItemClick(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	gGameUI:stackUI("common.gain_way", nil, nil, arg_27_4.key, nil, arg_27_4.targetNum)
end

function var_0_1.setProgress(arg_28_0, arg_28_1, arg_28_2)
	for iter_28_0 = 1, 8 do
		arg_28_0.leftTop:get("line" .. iter_28_0):hide()
	end

	if arg_28_1 == 1 and not arg_28_0.isLightIn and not arg_28_0.isLightMax then
		return
	end

	for iter_28_1, iter_28_2 in pairs(var_0_2[arg_28_1]) do
		arg_28_0.leftTop:get("line" .. iter_28_2):show()
	end

	if arg_28_1 == 1 and not arg_28_0.isLightMax then
		arg_28_0:enableSchedule():schedule(function()
			for iter_29_0 = 1, 8 do
				arg_28_0.leftTop:get("line" .. iter_29_0):hide()
			end
		end, 99999, 0.5)
	end
end

function var_0_1.onLeftBtn(arg_30_0)
	local var_30_0 = arg_30_0:getNextNum(arg_30_0.badgeNumb:read(), "left")

	if var_30_0 then
		arg_30_0.badgeNumb:set(var_30_0)
	else
		arg_30_0:showUnlockTips(arg_30_0.badgeNumb:read() - 1)
	end
end

function var_0_1.onRightBtn(arg_31_0)
	local var_31_0 = arg_31_0:getNextNum(arg_31_0.badgeNumb:read(), "right")

	if var_31_0 then
		arg_31_0.badgeNumb:set(var_31_0)
	else
		arg_31_0:showUnlockTips(arg_31_0.badgeNumb:read() + 1)
	end
end

function var_0_1.showUnlockTips(arg_32_0, arg_32_1)
	if csv.gym_badge.badge[arg_32_1].preBadgeType == 1 then
		gGameUI:showTip(gLanguageCsv.noOpenPleaseToGymView3)
	else
		gGameUI:showTip(gLanguageCsv.noOpenPleaseToGymView4)
	end
end

function var_0_1.getNextNum(arg_33_0, arg_33_1, arg_33_2)
	if arg_33_2 == "left" then
		arg_33_1 = arg_33_1 - 1

		if arg_33_1 <= 0 then
			return nil
		end
	else
		arg_33_1 = arg_33_1 + 1

		if arg_33_1 > 8 then
			return nil
		end
	end

	local var_33_0 = csv.gym_badge.badge
	local var_33_1 = var_33_0[arg_33_1].preBadgeID

	if var_33_1 then
		local var_33_2 = arg_33_0.badges:read() and arg_33_0.badges:read()[var_33_1] or {}

		if var_33_0[arg_33_1].preBadgeType == 1 then
			if (var_33_2.awake or 0) < var_33_0[arg_33_1].preLevel then
				return arg_33_0:getNextNum(arg_33_1, arg_33_2)
			else
				return arg_33_1
			end
		else
			local var_33_3 = csv.gym_badge.badge[var_33_1].talentIDs[6]
			local var_33_4 = var_33_2.talents

			if (var_33_4 and var_33_4[var_33_3] or 0) < var_33_0[arg_33_1].preLevel then
				return arg_33_0:getNextNum(arg_33_1, arg_33_2)
			else
				return arg_33_1
			end
		end
	else
		return arg_33_1
	end
end

function var_0_1.guardAllTalent(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = 0
	local var_34_1 = csv.gym_badge.badge[arg_34_1].guardIDs
	local var_34_2 = (arg_34_0.badges:read() and arg_34_0.badges:read()[arg_34_0.badgeNumb:read()] or {}).guards or {}

	if not itertools.isempty(var_34_2) then
		for iter_34_0, iter_34_1 in ipairs(var_34_1) do
			if var_34_2[iter_34_1] then
				local var_34_3 = gGameModel.cards:find(var_34_2[iter_34_1])
				local var_34_4 = 0
				local var_34_5 = var_34_3:read("card_id")
				local var_34_6 = var_34_3:read("advance")
				local var_34_7 = var_34_3:read("star")
				local var_34_8 = csv.cards[var_34_5]
				local var_34_9 = csv.unit[var_34_8.unitID]
				local var_34_10 = "0%"
				local var_34_11 = "0%"
				local var_34_12 = "0%"
				local var_34_13 = "0%"
				local var_34_14 = "0%"
				local var_34_15 = false

				if itertools.include(csv.gym_badge.badge[arg_34_1].nature, var_34_9.natureType) then
					var_34_15 = true
				end

				if itertools.include(csv.gym_badge.badge[arg_34_1].nature, var_34_9.natureType2) then
					var_34_15 = true
				end

				local var_34_16 = var_34_3:read("nvalue")
				local var_34_17 = 0

				for iter_34_2, iter_34_3 in pairs(var_34_16) do
					var_34_17 = var_34_17 + iter_34_3
				end

				for iter_34_4, iter_34_5 in ipairs(csv.gym_badge.guard_effect) do
					if iter_34_4 == var_34_9.rarity then
						var_34_10 = iter_34_5.rarityAttr
						var_34_11 = iter_34_5.starAttrs[var_34_7]
						var_34_12 = iter_34_5.advanceAttrs[var_34_6]

						if var_34_15 then
							var_34_13 = iter_34_5.rarityAttr
						end

						local var_34_18 = 0

						for iter_34_6, iter_34_7 in orderCsvPairs(iter_34_5.nvalueAttrs) do
							if iter_34_6 <= var_34_17 and var_34_18 <= iter_34_6 then
								var_34_18 = iter_34_6
								var_34_14 = iter_34_7
							end
						end
					end
				end

				var_34_0 = var_34_0 + (dataEasy.parsePercentStr(var_34_10) + dataEasy.parsePercentStr(var_34_11) + dataEasy.parsePercentStr(var_34_12) + dataEasy.parsePercentStr(var_34_13) + dataEasy.parsePercentStr(var_34_14))
			end
		end
	end

	return var_34_0
end

function var_0_1.onFastUpgradeClick(arg_35_0)
	arg_35_0.checkBoxState:set(not arg_35_0.checkBoxState:read())
	arg_35_0.checkBox:setSelectedState(arg_35_0.checkBoxState:read())
end

function var_0_1.onClose(arg_36_0)
	gGameApp:requestServer("/game/badge/refresh")
	arg_36_0.isView:set(true, true)
	var_0_0.onClose(arg_36_0)
end

return var_0_1
