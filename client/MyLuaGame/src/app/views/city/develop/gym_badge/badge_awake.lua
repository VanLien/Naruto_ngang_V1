local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("gymBadgeTalentAwakeView", var_0_0)
local var_0_2 = {
	[4] = {
		effectName = "huo_effect",
		pointY = 0.5,
		pointX = 0.6,
		scale = 2,
		loopName = "huo_loop",
		xy = cc.p(310, 580)
	},
	[5] = {
		effectName = "long_effect",
		pointY = 0.7,
		pointX = 0.4,
		scale = 2,
		loopName = "long_loop",
		xy = cc.p(511, 490)
	},
	[2] = {
		effectName = "shui_effect",
		pointY = 0.6,
		pointX = 0.6,
		scale = 2,
		loopName = "shui_loop",
		xy = cc.p(140, 450)
	},
	{
		effectName = "yan_effect",
		pointY = 0.6,
		pointX = 0.4,
		scale = 2,
		loopName = "yan_loop",
		xy = cc.p(286, 350)
	},
	[3] = {
		effectName = "cao_effect",
		pointY = 0.3,
		pointX = 0.5,
		scale = 2,
		loopName = "cao_loop",
		xy = cc.p(266, 735)
	},
	[6] = {
		effectName = "e_effect",
		pointY = 0.5,
		pointX = 0.4,
		scale = 2,
		loopName = "e_loop",
		xy = cc.p(381, 500)
	},
	[8] = {
		effectName = "yao_effect",
		pointY = 0.4,
		pointX = 0.6,
		scale = 2,
		loopName = "yao_loop",
		xy = cc.p(131, 620)
	},
	[7] = {
		effectName = "du_effect",
		pointY = 0,
		pointX = 0,
		scale = 2,
		loopName = "du_loop",
		xy = cc.p(441, 700)
	}
}
local var_0_3 = {
	{
		name = gLanguageCsv.attrHp
	},
	{
		name = gLanguageCsv.attrDamage
	},
	{
		name = gLanguageCsv.attrSpecialDamage
	},
	{
		name = gLanguageCsv.attrDefence
	},
	{
		name = gLanguageCsv.attrSpecialDefence
	},
	{
		name = gLanguageCsv.attrSpeed
	}
}

var_0_1.RESOURCE_FILENAME = "gym_badge_awake.json"
var_0_1.RESOURCE_BINDING = {
	["leftPanel.item"] = "leftItem",
	["rightPanel.costPanel"] = "costPanel",
	["rightPanel.costPanel.item"] = "costItem",
	["rightPanel.btnPanel"] = "btnPanel",
	leftPanel = "leftPanel",
	["rightPanel.topPanel"] = "topPanel",
	rightPanel = "rightPanel",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	title = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	title1 = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	["leftPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("natureData"),
				item = bindHelper.self("leftItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("icon"):texture(ui.ATTR_ICON[arg_1_3])
				end,
				onAfterBuild = function(arg_2_0)
					arg_2_0:setItemAlignCenter()
				end
			}
		}
	},
	["rightPanel.costPanel.list"] = {
		varname = "costList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 2,
				data = bindHelper.self("costData"),
				item = bindHelper.self("costItem"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = false

					if arg_3_3.targetNum then
						var_3_0 = arg_3_3.num < (arg_3_3.targetNum or 0)
					end

					arg_3_1:get("btnAdd"):visible(var_3_0)
					arg_3_1:get("imgMask"):visible(var_3_0)
					bind.extend(arg_3_0, arg_3_1, {
						class = "icon_key",
						props = {
							data = {
								key = arg_3_3.key,
								num = arg_3_3.num,
								targetNum = arg_3_3.targetNum
							},
							onNode = function(arg_4_0)
								bind.click(arg_3_0, arg_4_0, {
									method = functools.partial(arg_3_0.itemClick, arg_4_0, arg_3_2, arg_3_3)
								})
							end
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	["rightPanel.btnPanel.btn"] = {
		varname = "awakeBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAwakeBtn")
			}
		}
	},
	["rightPanel.btnPanel.btn.title"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_5_0, arg_5_1)
	arg_5_0.badgeNumb = arg_5_1

	arg_5_0:initModel()

	arg_5_0.natureData = idlers.new()

	local var_5_0 = csv.gym_badge.badge
	local var_5_1 = var_5_0[arg_5_1].awakeCostSeqID

	arg_5_0.natureData:update(var_5_0[arg_5_1].nature)
	arg_5_0.leftPanel:get("name"):text(var_5_0[arg_5_1].name)

	arg_5_0.costData = idlers.new()

	widget.addAnimationByKey(arg_5_0.leftPanel, "daoguanhuizhang/dghz.skel", "spine" .. arg_5_1, var_0_2[arg_5_1].loopName, 100):xy(cc.p(310, 430)):scale(2.4)

	local var_5_2 = csv.gym_badge.awake_cost

	idlereasy.any({
		arg_5_0.items,
		arg_5_0.badges
	}, function(arg_6_0, arg_6_1, arg_6_2)
		local var_6_0 = arg_6_2 and arg_6_2[arg_5_1] or {}
		local var_6_1 = var_6_0.talents or {}

		if not var_6_0.guards then
			local var_6_2 = {}
		end

		local var_6_3 = var_6_0.awake or 0
		local var_6_4 = var_5_2[var_6_3]["cost" .. var_5_1]
		local var_6_5 = {}
		local var_6_6 = var_5_0[arg_5_1].awakeTalentAttrs
		local var_6_7 = ""
		local var_6_8 = ""

		if var_6_3 == 0 then
			var_6_7 = 0

			local var_6_9 = var_6_6[var_6_3 + 1]

			arg_5_0.leftPanel:get("nameLv"):hide()
		else
			var_6_7 = var_6_6[var_6_3]

			local var_6_10

			var_6_10 = var_6_6[var_6_3 + 1] and var_6_6[var_6_3 + 1] or 0

			arg_5_0.leftPanel:get("nameLv"):text("+" .. var_6_3)
			arg_5_0.leftPanel:get("nameLv"):show()
		end

		arg_5_0.preTalentLevel = var_5_0[arg_5_1].preTalentLevel[var_6_3 + 1] or 999
		arg_5_0.canAwake = 0

		for iter_6_0, iter_6_1 in ipairs(dataEasy.getItemData(var_6_4)) do
			if iter_6_1.key ~= "rmb" and iter_6_1.key ~= "gold" then
				table.insert(var_6_5, {
					key = iter_6_1.key,
					num = arg_6_1[iter_6_1.key] or 0,
					targetNum = iter_6_1.num
				})
			end
		end

		arg_5_0.item = var_6_5

		local var_6_11 = #var_6_5

		arg_5_0.costList:size(200 * var_6_11, 200)
		arg_5_0.costData:update(var_6_5)

		arg_5_0.costGold = var_6_4.gold

		arg_5_0.btnPanel:get("text"):text(arg_5_0.costGold)
		adapt.oneLineCenterPos(cc.p(163, 190), {
			arg_5_0.btnPanel:get("text1"),
			arg_5_0.btnPanel:get("text"),
			arg_5_0.btnPanel:get("icon")
		}, cc.p(6, 0))

		local var_6_12 = var_5_0[arg_5_1].talentIDs

		for iter_6_2, iter_6_3 in ipairs(var_6_12) do
			if var_6_1[iter_6_3] and var_6_1[iter_6_3] >= arg_5_0.preTalentLevel then
				arg_5_0.canAwake = arg_5_0.canAwake + 1
			end
		end

		if arg_5_0.canAwake < 6 then
			arg_5_0.btnPanel:get("txt"):show()
			arg_5_0.btnPanel:get("txt"):text(string.format(gLanguageCsv.badgeNeedToUp, arg_5_0.preTalentLevel))
			text.addEffect(arg_5_0.btnPanel:get("txt"), {
				color = ui.NEWCOLORS.RED1
			})
		else
			arg_5_0.btnPanel:get("txt"):text(string.format(gLanguageCsv.badgeNeedToUp, arg_5_0.preTalentLevel))
			text.addEffect(arg_5_0.btnPanel:get("txt"), {
				color = ui.NEWCOLORS.GREENLIGHT
			})
		end

		arg_5_0.costPanel:visible(#var_6_5 > 0)

		local var_6_13 = {}
		local var_6_14 = string.format(gLanguageCsv.badgeAllTalentUp, var_6_7)
		local var_6_15 = string.gsub(var_6_14, "#C0x5b545b#", "#C0x8A5B0C#")
		local var_6_16 = string.gsub(var_6_15, "#C0x5C9970#", "#C0x01a001#")

		table.insert(var_6_13, {
			str = var_6_16
		})

		local var_6_17 = arg_5_0:getStrsByAwark(var_6_13, var_5_0, arg_5_1, var_6_3)

		beauty.textScroll({
			margin = 20,
			align = "left",
			isRich = true,
			list = arg_5_0.topPanel:get("list1"),
			effect = {
				color = ui.NEWCOLORS.BROWN1
			},
			strs = var_6_17
		})

		if var_6_3 >= var_5_0[arg_5_1].awakeMaxLevel then
			arg_5_0.costPanel:hide()
			arg_5_0.btnPanel:hide()
			arg_5_0.rightPanel:get("maxBg"):show()
			arg_5_0.topPanel:get("title1"):hide()
			arg_5_0.topPanel:get("list2"):hide()
		else
			local var_6_18 = {}
			local var_6_19 = var_6_6[var_6_3 + 1] or 0
			local var_6_20 = string.format(gLanguageCsv.badgeAllTalentUp, var_6_19)
			local var_6_21 = string.gsub(var_6_20, "#C0x5b545b#", "#C0x8A5B0C#")
			local var_6_22 = string.gsub(var_6_21, "#C0x5C9970#", "#C0x01a001#")

			table.insert(var_6_18, {
				str = var_6_22
			})

			local var_6_23 = arg_5_0:getStrsByAwark(var_6_18, var_5_0, arg_5_1, var_6_3 + 1)

			arg_5_0.nextEffStrs = var_6_23

			beauty.textScroll({
				margin = 20,
				align = "left",
				isRich = true,
				list = arg_5_0.topPanel:get("list2"),
				effect = {
					color = ui.NEWCOLORS.BROWN1
				},
				strs = var_6_23
			})
		end

		adapt.oneLineCenterPos(cc.p(310, 120), {
			arg_5_0.leftPanel:get("name"),
			arg_5_0.leftPanel:get("nameLv")
		}, cc.p(6, 0))

		arg_5_0.awake = var_6_3
	end)
	Dialog.onCreate(arg_5_0)
end

function var_0_1.getStrsByAwark(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	for iter_7_0 = 1, math.huge do
		local var_7_0 = arg_7_2[arg_7_3]["attrType" .. iter_7_0]

		if not var_7_0 then
			break
		end

		local var_7_1 = arg_7_2[arg_7_3]["attrNum" .. iter_7_0][arg_7_4]
		local var_7_2 = dataEasy.getAttrValueString(var_7_0, var_7_1 or 0)
		local var_7_3 = getLanguageAttr(var_7_0)
		local var_7_4 = string.format(gLanguageCsv.badgeAllCardsUp, var_7_3, var_7_2)
		local var_7_5 = string.gsub(var_7_4, "#C0x5b545b#", "#C0x8A5B0C#")
		local var_7_6 = string.gsub(var_7_5, "#C0x5C9970#", "#C0x01a001#")

		table.insert(arg_7_1, {
			str = var_7_6
		})
	end

	return arg_7_1
end

function var_0_1.initModel(arg_8_0)
	arg_8_0.badges = gGameModel.role:getIdler("badges")
	arg_8_0.gold = gGameModel.role:getIdler("gold")
	arg_8_0.items = gGameModel.role:getIdler("items")
end

function var_0_1.onAwakeBtn(arg_9_0)
	if arg_9_0.canAwake < 6 then
		gGameUI:showTip(string.format(gLanguageCsv.needAllBadgeLight, arg_9_0.preTalentLevel))

		return
	end

	if arg_9_0.costGold and arg_9_0.gold:read() < arg_9_0.costGold then
		gGameUI:showTip(gLanguageCsv.awakeGoldNotEnough)

		return
	end

	for iter_9_0, iter_9_1 in ipairs(arg_9_0.item) do
		if iter_9_1.targetNum > iter_9_1.num then
			gGameUI:showTip(gLanguageCsv.awakeItemsNotEnough)

			return
		end
	end

	local var_9_0 = arg_9_0.awake
	local var_9_1 = arg_9_0.nextEffStrs

	gGameApp:requestServer("/game/badge/awake", function()
		local var_10_0 = arg_9_0.leftPanel:get("effect")

		if var_10_0 then
			var_10_0:play("fangguang2")
		else
			widget.addAnimationByKey(arg_9_0.leftPanel, "koudai_gonghuixunlian/gonghuixunlian.skel", "effect", "fangguang2", 10000):xy(310, 400)
		end

		gGameUI:stackUI("city.develop.gym_badge.awake_success", nil, {
			clickClose = true,
			blackLayer = true
		}, {
			awake = var_9_0,
			nextEffStrs = var_9_1,
			badgeNumb = arg_9_0.badgeNumb
		})
	end, arg_9_0.badgeNumb)
end

function var_0_1.onItemClick(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	gGameUI:stackUI("common.gain_way", nil, nil, arg_11_4.key, nil, arg_11_4.targetNum)
end

return var_0_1
