local var_0_0 = {
	elite = 2,
	normal = 1
}
local var_0_1 = {
	[1] = "city/adventure/hunting/img_sldd_1.png",
	[2] = "city/adventure/hunting/img_sldd_2.png"
}
local var_0_2 = {
	[1] = "city/adventure/hunting/img_sldd0%d.png",
	[2] = "city/adventure/hunting/img_sldd0%d_02.png"
}
local var_0_3 = {
	[1] = "city/adventure/hunting/mask_sldd%d_01.png",
	[2] = "city/adventure/hunting/mask_sldd%d_02.png"
}
local var_0_4 = {
	gate = 1,
	HP = 3,
	box = 2,
	mul = 4
}
local var_0_5 = {
	"standby_loop",
	"run_loop",
	"standby_loop"
}
local var_0_6 = {
	charizard = {
		scale = 2,
		res = "naruto_gaara00/gaara00.skel",
		x = 150,
		y = 0
	},
	bulbasaur = {
		scale = 2,
		res = "naruto_gai00/gai00.skel",
		x = 430,
		y = -20
	},
	squirtle = {
		scale = 2,
		res = "naruto_haku00/haku00.skel",
		x = 660,
		y = 0
	},
	pikachu = {
		scale = 2,
		res = "naruto_kakashi00/kakashi00.skel",
		x = 890,
		y = 0
	}
}
local var_0_7 = {
	"city/adventure/hunting/icon_zd1.png",
	"city/adventure/hunting/icon_box.png",
	"city/adventure/hunting/icon_jiuyuan.png",
	"city/adventure/hunting/icon_zd2.png"
}
local var_0_8 = {
	"city/adventure/hunting/icon_zd1.png",
	"city/adventure/hunting/icon_zd2.png",
	"city/adventure/hunting/icon_boss.png"
}
local var_0_9 = {
	{
		scale = 1.5,
		res = "city/adventure/hunting/icon_zd1_red.png"
	},
	{
		scale = 1.5,
		res = "city/adventure/hunting/icon_zd2_red.png"
	},
	{
		scale = 1.5,
		res = "city/adventure/hunting/icon_boss.png"
	}
}
local var_0_10 = 3
local var_0_11 = {
	{
		scale = 2.5,
		res = "koudai_xiaozhibanpikaqiu/hero_xiaozhibanpikaqiu.skel",
		action = "standby_loop",
		y = -550,
		x = 3000,
		spineName = "gate"
	},
	{
		scale = 2.5,
		res = "effect/jiedianjiangli.skel",
		action = "effect_loop",
		y = -550,
		x = 3000,
		spineName = "box"
	},
	{
		scale = 2.5,
		res = "naruto_tsunade00/tsunade00.skel",
		action = "standby_loop",
		y = -550,
		x = 3000,
		spineName = "supply"
	},
	{
		scale = 2.5,
		res = "naruto_jiraiya00/jiraiya00.skel",
		action = "standby_loop",
		y = -550,
		x = 3000,
		spineName = "mul"
	}
}
local var_0_12 = cc.load("mvc").ViewBase
local var_0_13 = class("HuntingRouteView", var_0_12)

var_0_13.RESOURCE_FILENAME = "hunting_route.json"
var_0_13.RESOURCE_BINDING = {
	spinePanel = "spinePanel",
	buffPanel = "buffPanel",
	["buffPanel.coverPanel"] = "buffCoverPanel",
	circlePanel = "circlePanel",
	["buffPanel.item"] = "buffItem",
	rightBottomPanel = "rightBottomPanel",
	["buffPanel.coverPanel.actionNode"] = "buffActionNode",
	runSpine = "runSpine",
	["coverProPanel.bgRight"] = "bgRight",
	["coverProPanel.prograssPanel.proPanel1"] = "proPanel1",
	bg = "bg",
	["coverProPanel.prograssPanel"] = "prograssPanel",
	["coverProPanel.bgLeft"] = "bgLeft",
	["buffPanel.buffBtn"] = {
		varname = "buffBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBuffBtnClick")
			}
		}
	},
	["buffPanel.buffBtn.textNote"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.NEWCOLORS.OUTLINE.BROWN2,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightBottomPanel.btnTask.text"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.NEWCOLORS.OUTLINE.BROWN2,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["buffPanel.coverPanel.list"] = {
		varname = "buffList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("buffDatas"),
				item = bindHelper.self("buffItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("icon"):texture(arg_1_3.icon)

					if arg_1_2 == 1 then
						arg_1_1:width(270)
						arg_1_1:get("icon"):x(195)
						arg_1_1:get("bg"):x(195)
					end

					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.itemClick, arg_1_0, arg_1_1, arg_1_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	["rightBottomPanel.btnTask"] = {
		varname = "event",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onEndClick")
			}
		}
	}
}

function var_0_13.onCreate(arg_2_0, arg_2_1)
	arg_2_0.route = arg_2_1

	gGameUI.topuiManager:createView("hunting", arg_2_0, {
		onClose = arg_2_0:createHandler("onClose")
	}):init({
		subTitle = "HUNTINGAREA",
		title = "common/txt/txt_bt_renzheyuanzheng.png"
	})
	arg_2_0:initUnderground(arg_2_1)
	arg_2_0:initRoundData()
	arg_2_0:initProgress()
	arg_2_0:initSpine()
	arg_2_0:initModel()
	arg_2_0:initBuffDatas()
	arg_2_0:initPanel()
end

function var_0_13.initRoundData(arg_3_0)
	local var_3_0 = gGameModel.hunting:read("hunting_route")[arg_3_0.route].version or 0

	arg_3_0.routeData = {}

	local var_3_1 = 1

	for iter_3_0, iter_3_1 in orderCsvPairs(csv.cross.hunting.route) do
		if iter_3_1.routeTag == arg_3_0.route and var_3_0 == iter_3_1.version then
			arg_3_0.routeData[iter_3_0] = {
				count = var_3_1,
				type = iter_3_1.type,
				boxDropLibs = iter_3_1.boxDropLibs,
				supplyGroup = iter_3_1.supplyGroup,
				gateIDs = iter_3_1.gateIDs
			}

			if var_3_1 == 1 then
				arg_3_0.minId = iter_3_0
			end

			var_3_1 = var_3_1 + 1
		end
	end
end

function var_0_13.initUnderground(arg_4_0, arg_4_1)
	arg_4_0.bg:get("norbg"):visible(arg_4_1 == 1)
	arg_4_0.bg:get("exbg"):visible(arg_4_1 ~= 1)

	for iter_4_0 = 1, 6 do
		for iter_4_1 = 1, 5 do
			arg_4_0.circlePanel:get("bottomPanel" .. iter_4_0):get("bg" .. iter_4_1):texture(string.format(var_0_2[arg_4_1], iter_4_1))
		end
	end

	arg_4_0.bgLeft:texture(string.format(var_0_3[1], arg_4_1))
	arg_4_0.bgRight:texture(string.format(var_0_3[2], arg_4_1))
end

function var_0_13.initModel(arg_5_0)
	arg_5_0.buffDatas = idlers.newWithMap({})
	arg_5_0.delayTime = 0
	arg_5_0.lastFlag = 0
	arg_5_0.clientRouteInfoFlag = idler.new(true)

	idlereasy.any({
		arg_5_0.clientRouteInfoFlag
	}, function()
		local var_6_0 = gGameModel.hunting:read("hunting_route")

		if var_6_0[arg_5_0.route].node == 0 then
			arg_5_0:onClose()

			return
		elseif var_6_0[arg_5_0.route].node == arg_5_0.minId + itertools.size(arg_5_0.routeData) then
			arg_5_0.curNode = arg_5_0.minId + itertools.size(arg_5_0.routeData)

			arg_5_0:initSpine(3)
			arg_5_0:initPanel()
			arg_5_0:checkCurIndex()
			arg_5_0:initBuffDatas()

			return
		end

		arg_5_0:initBuffDatas()

		local var_6_1 = var_6_0[arg_5_0.route].board_id or 0

		if arg_5_0.curNode == var_6_0[arg_5_0.route].node and arg_5_0.routeData[arg_5_0.curNode].type == var_0_4.mul and var_6_0[arg_5_0.route].board_id and var_6_1 ~= arg_5_0.boardId then
			arg_5_0.boardId = var_6_1

			arg_5_0:initEventSpine(3)
		elseif arg_5_0.curNode ~= var_6_0[arg_5_0.route].node or var_6_0[arg_5_0.route].board_id and var_6_1 ~= arg_5_0.boardId then
			arg_5_0.curNode = var_6_0[arg_5_0.route].node
			arg_5_0.boardId = var_6_1

			arg_5_0:initPanel()
			arg_5_0:initEventSpine(1)
			arg_5_0:checkCurIndex()
			performWithDelay(arg_5_0, function()
				arg_5_0:updatePerformance()
			end, arg_5_0.delayTime)
		elseif arg_5_0.curNode == var_6_0[arg_5_0.route].node and (arg_5_0.routeData[arg_5_0.curNode].type == var_0_4.gate or var_6_1 > 2) and arg_5_0.lastFlag ~= 1 then
			arg_5_0:initEventSpine(2)
			arg_5_0:checkCurIndex(2)
		end

		if itertools.size(var_6_0[arg_5_0.route].board_buffs or {}) > 0 then
			arg_5_0:checkCurIndex()
			performWithDelay(arg_5_0, function()
				arg_5_0.isOpen = false

				arg_5_0:onBuffBtnClick()
				gGameUI:stackUI("city.adventure.hunting.select_buff", nil, {
					blackLayer = true
				}, {
					route = arg_5_0.route,
					node = arg_5_0.curNode,
					cb = arg_5_0:createHandler("playBuffSpine")
				})
			end, 0.016666666666666666)
		end
	end)
end

function var_0_13.playBuffSpine(arg_9_0)
	arg_9_0.buffBtn:removeChildByName("effect")

	local var_9_0 = widget.addAnimationByKey(arg_9_0.buffBtn, "random_tower/new_jiacheng.skel", "effect", "effect", 10):xy(70, 70):scale(2)

	arg_9_0.clientRouteInfoFlag:notify()
end

function var_0_13.initBuffDatas(arg_10_0)
	local var_10_0 = {}
	local var_10_1 = gGameModel.hunting:read("hunting_route")

	if itertools.size(var_10_1[arg_10_0.route].buffs) > 0 then
		for iter_10_0, iter_10_1 in ipairs(var_10_1[arg_10_0.route].buffs) do
			local var_10_2 = csv.cross.hunting.buffs[iter_10_1]

			table.insert(var_10_0, {
				name = var_10_2.name,
				desc = var_10_2.desc,
				quality = var_10_2.quality,
				icon = var_10_2.icon
			})
		end
	end

	arg_10_0.buffDatas:update(var_10_0)

	local var_10_3 = 1500
	local var_10_4 = itertools.size(var_10_0)
	local var_10_5 = var_10_4 > 6 and var_10_3 or var_10_4 * 200 + 170
	local var_10_6 = arg_10_0.buffCoverPanel:get("actionNode.bg")

	var_10_6:width(var_10_5)
	arg_10_0.buffCoverPanel:get("actionNode"):x(-var_10_5)
	arg_10_0.buffList:width(var_10_5 - 95)
	arg_10_0.buffList:xy(0, -arg_10_0.buffList:height() / 2)
	arg_10_0.buffList:retain()
	arg_10_0.buffList:removeFromParent()

	local var_10_7 = var_10_6:size()
	local var_10_8 = cc.ClippingNode:create():setStencil(var_10_6):setInverted(false):setAlphaThreshold(0.2):xy(cc.p(0, 0)):add(arg_10_0.buffList, 100):addTo(arg_10_0.buffActionNode, 3, "clipper")

	arg_10_0.buffList:release()
end

function var_0_13.initSpine(arg_11_0, arg_11_1)
	local var_11_0 = widget.addAnimationByKey(arg_11_0.runSpine, "loading/loading_dog.skel", "effect", "effect_loop", 10):xy(0, 10):scale(1.3)

	arg_11_0.spinePanel:removeAllChildren()

	if arg_11_1 then
		for iter_11_0, iter_11_1 in pairs(var_0_6) do
			local var_11_1 = widget.addAnimationByKey(arg_11_0.spinePanel, iter_11_1.res, iter_11_0, var_0_5[arg_11_1], 1000):scale(iter_11_1.scale):xy(iter_11_1.x, iter_11_1.y)
		end
	end
end

function var_0_13.initProgress(arg_12_0)
	arg_12_0.bar = {}
	arg_12_0.prograssData = {}

	local var_12_0 = 0

	arg_12_0.bar[arg_12_0.minId] = arg_12_0.prograssPanel:get("proPanel1")

	for iter_12_0, iter_12_1 in pairs(arg_12_0.routeData) do
		if iter_12_1.count == itertools.size(arg_12_0.routeData) then
			local var_12_1 = arg_12_0.prograssPanel:get("proPanel3"):clone():show():addTo(arg_12_0.prograssPanel, 5, "bar" .. iter_12_0):xy(arg_12_0.prograssPanel:get("proPanel2"):x() + 252 * (iter_12_1.count - 2) + 170, arg_12_0.prograssPanel:get("proPanel2"):y())

			if arg_12_0.routeData[iter_12_0].type == var_0_4.mul then
				var_12_1:get("txt"):visible(true)
				var_12_1:get("icon"):visible(false)
			else
				if arg_12_0.routeData[iter_12_0].type == var_0_4.gate then
					local var_12_2 = arg_12_0.routeData[iter_12_0].gateIDs[1]

					var_12_1:get("icon"):texture(var_0_8[csv.cross.hunting.gate[var_12_2].type])
				else
					var_12_1:get("icon"):texture(var_0_7[arg_12_0.routeData[iter_12_0].type])
				end

				var_12_1:get("txt"):visible(false)
				var_12_1:get("icon"):visible(true)
			end

			arg_12_0.bar[iter_12_0 + 1] = var_12_1
		else
			local var_12_3 = arg_12_0.prograssPanel:get("proPanel2"):clone():show():addTo(arg_12_0.prograssPanel, 5, "bar" .. iter_12_0):xy(arg_12_0.prograssPanel:get("proPanel2"):x() + 253 * (iter_12_1.count - 1) - 2, arg_12_0.prograssPanel:get("proPanel2"):y())

			var_12_3:get("icon"):visible(arg_12_0.routeData[iter_12_0].type ~= var_0_4.mul)

			if arg_12_0.routeData[iter_12_0].type == var_0_4.gate then
				local var_12_4 = arg_12_0.routeData[iter_12_0].gateIDs[1]

				var_12_3:get("icon"):texture(var_0_8[csv.cross.hunting.gate[var_12_4].type])
			else
				var_12_3:get("icon"):texture(var_0_7[arg_12_0.routeData[iter_12_0].type])
			end

			var_12_3:get("txt"):visible(arg_12_0.routeData[iter_12_0].type == var_0_4.mul)

			arg_12_0.bar[iter_12_0 + 1] = var_12_3
		end
	end

	local var_12_5 = arg_12_0.runSpine:x()
	local var_12_6 = arg_12_0.prograssPanel:x()

	for iter_12_2 = arg_12_0.minId, arg_12_0.minId + itertools.size(arg_12_0.routeData) - 1 do
		if var_12_0 == 0 then
			var_12_0 = var_12_0 + 1
			arg_12_0.prograssData[var_12_0] = {
				percent = 0,
				prograssIndex = arg_12_0.minId,
				round = iter_12_2,
				panelX = var_12_6,
				spineX = var_12_5
			}
		end

		if arg_12_0.routeData[iter_12_2].count == itertools.size(arg_12_0.routeData) then
			var_12_0 = var_12_0 + 1
			arg_12_0.prograssData[var_12_0] = {
				percent = 100,
				prograssIndex = iter_12_2 + 1,
				round = iter_12_2,
				panelX = var_12_6,
				spineX = var_12_5 + 250
			}
		else
			local var_12_7 = arg_12_0.routeData[iter_12_2].count > 3 and arg_12_0.routeData[iter_12_2].count < itertools.size(arg_12_0.routeData) - 2 and 0 or 250
			local var_12_8 = arg_12_0.routeData[iter_12_2].count > 3 and arg_12_0.routeData[iter_12_2].count < itertools.size(arg_12_0.routeData) - 2 and 250 or 0

			var_12_5 = var_12_5 + var_12_7
			var_12_6 = var_12_6 - var_12_8
			var_12_0 = var_12_0 + 1
			arg_12_0.prograssData[var_12_0] = {
				percent = 100,
				prograssIndex = iter_12_2,
				round = iter_12_2,
				panelX = var_12_6,
				spineX = var_12_5
			}
			var_12_0 = var_12_0 + 1
			arg_12_0.prograssData[var_12_0] = {
				percent = 32,
				prograssIndex = iter_12_2 + 1,
				round = iter_12_2,
				panelX = var_12_6,
				spineX = var_12_5
			}
		end
	end

	arg_12_0.prograssPanel:get("proPanel2"):hide()
end

function var_0_13.refreshProgress(arg_13_0, arg_13_1)
	arg_13_0.runSpine:x(arg_13_0.prograssData[arg_13_1].spineX)
	arg_13_0.prograssPanel:x(arg_13_0.prograssData[arg_13_1].panelX)

	if arg_13_1 == 1 then
		arg_13_0.bar[arg_13_0.minId]:get("pro"):setPercent(0)
	elseif arg_13_1 >= 2 then
		for iter_13_0 = arg_13_0.minId, arg_13_0.prograssData[arg_13_1].prograssIndex - 1 do
			arg_13_0.bar[iter_13_0]:get("pro"):setPercent(100)
		end

		arg_13_0.bar[arg_13_0.prograssData[arg_13_1].prograssIndex]:get("pro"):setPercent(arg_13_0.prograssData[arg_13_1].percent)
	end
end

function var_0_13.initEventSpine(arg_14_0, arg_14_1)
	if arg_14_1 == 2 then
		if arg_14_0.lastFlag == 1 or arg_14_0.lastFlag == 3 then
			return
		else
			arg_14_0:initSpine(1)
		end
	end

	arg_14_0.lastFlag = arg_14_1
	arg_14_0.eventID = arg_14_0.routeData[arg_14_0.curNode].type

	if arg_14_0.eventID == var_0_4.mul and arg_14_0.boardId > 0 then
		if arg_14_0.boardId == 1 then
			arg_14_0.eventID = var_0_4.box
		elseif arg_14_0.boardId == 2 then
			arg_14_0.eventID = var_0_4.HP
		else
			arg_14_0.eventID = var_0_4.gate
		end
	end

	arg_14_0:checkCurIndex()

	local function var_14_0()
		arg_14_0.bg:removeChildByName("eventPanel")

		if arg_14_1 == 1 or arg_14_1 == 3 then
			arg_14_0.bg:removeChildByName("gatePanel")
		end

		if arg_14_1 ~= 3 then
			arg_14_0.bg:setRotation(0)
		end

		local var_15_0 = var_0_11[arg_14_0.eventID].x
		local var_15_1 = var_0_11[arg_14_0.eventID].y
		local var_15_2 = (arg_14_1 == 3 and 1000 or 0) + (arg_14_0.curProIndex - 1) * 500
		local var_15_3 = arg_14_1 == 2 and 0 or 0

		var_15_3 = arg_14_1 == 3 and 0 or var_15_3

		if arg_14_0.eventID == var_0_4.gate then
			local var_15_4 = arg_14_0.boardId > 0 and arg_14_0.boardId or arg_14_0.routeData[arg_14_0.curNode].gateIDs[1]

			performWithDelay(arg_14_0, function()
				gGameApp:requestServer("/game/hunting/battle/info", function(arg_17_0)
					arg_14_0.gateDatas = arg_17_0.view or {}

					local var_17_0 = arg_17_0.view.defence_role_info or {}
					local var_17_1 = 0
					local var_17_2

					for iter_17_0, iter_17_1 in pairs(var_17_0.defence_card_attrs) do
						local var_17_3 = csv.cards[iter_17_1.card_id].unitID
						local var_17_4 = csv.unit[var_17_3].unitRes

						var_17_2 = var_17_1 < iter_17_1.fighting_point and var_17_3 or var_17_2
						var_17_1 = var_17_1 < iter_17_1.fighting_point and iter_17_1.fighting_point or var_17_1
					end

					local var_17_5 = var_0_11[arg_14_0.eventID].x
					local var_17_6 = var_0_11[arg_14_0.eventID].y
					local var_17_7 = arg_14_1 == 2 and 0 or 0

					var_17_7 = arg_14_1 == 3 and 0 or var_17_7

					local var_17_8 = arg_14_0.bg:get("gatePanel")

					if arg_14_1 == 2 and var_17_8 then
						var_17_8:xy(var_17_5 + var_15_2, var_17_6)
					else
						local var_17_9 = ccui.Layout:create():size(600, 800):addTo(arg_14_0.bg, 10, "gatePanel"):anchorPoint(0, 0):xy(var_17_5 + var_15_2, var_17_6)

						var_17_9:setTouchEnabled(true)
						var_17_9:setRotation(var_17_7)

						local var_17_10 = widget.addAnimationByKey(arg_14_0.bg:get("gatePanel"), csv.unit[var_17_2].unitRes, var_0_11[arg_14_0.eventID].spineName, var_0_11[arg_14_0.eventID].action, 10):xy(150, 0):anchorPoint(0, 0):scale(var_0_11[arg_14_0.eventID].scale):scaleX(var_0_11[arg_14_0.eventID].scale * -1)

						var_17_10:setSkin(csv.unit[var_17_2].skin)

						local var_17_11 = cc.Sprite:create("city/adventure/hunting/logo_sldd.png"):anchorPoint(0.5, 0.5):addTo(var_17_10, 10, "iconBg"):xy(0, 100 + csv.unit[var_17_2].everyPos.headPos.y):scale(0.3)
						local var_17_12 = var_0_9[csv.cross.hunting.gate[arg_14_0.routeData[arg_14_0.curNode].gateIDs[1]].type]
						local var_17_13 = cc.Sprite:create(var_17_12.res):anchorPoint(0.5, 0.5):addTo(var_17_10:get("iconBg"), 10, "icon"):xy(80, 110):scale(var_17_12.scale)

						if arg_14_1 == 3 then
							local var_17_14 = arg_14_0.bg:get("gatePanel")
							local var_17_15 = cc.Sequence:create(cc.MoveTo:create(var_0_10 - 1, cc.p(var_17_14:x() - 1000, var_17_14:y())))

							var_17_14:get("gate"):play("run_loop")
							var_17_14:runAction(var_17_15)
							performWithDelay(arg_14_0, function()
								var_17_14:get("gate"):play("standby_loop")
							end, var_0_10 - 1)
						end

						bind.click(arg_14_0, var_17_9, {
							method = function()
								arg_14_0:onNodeClick()
							end
						})
					end
				end, arg_14_0.route, arg_14_0.curNode, var_15_4)
			end, 0.016666666666666666)
		else
			local var_15_5 = ccui.Layout:create():size(600, 800):addTo(arg_14_0.bg, 10, "eventPanel"):anchorPoint(0, 0):xy(var_15_0 + var_15_2, var_15_1)

			var_15_5:setRotation(var_15_3)
			var_15_5:setTouchEnabled(false)
			bind.click(arg_14_0, var_15_5, {
				method = function()
					arg_14_0:onNodeClick()
				end
			})
			performWithDelay(arg_14_0, function()
				var_15_5:setTouchEnabled(true)
			end, var_0_10)

			local var_15_6 = widget.addAnimationByKey(arg_14_0.bg:get("eventPanel"), var_0_11[arg_14_0.eventID].res, var_0_11[arg_14_0.eventID].spineName, var_0_11[arg_14_0.eventID].action, 10):xy(150, 0):anchorPoint(0, 0):scale(var_0_11[arg_14_0.eventID].scale):scaleX(var_0_11[arg_14_0.eventID].scale * -1)

			if arg_14_0.eventID == var_0_4.box then
				local var_15_7 = cc.Sprite:create("common/icon/icon_box_sldd.png"):anchorPoint(0.5, 0):addTo(var_15_6, 10, "iconBg"):xy(0, 0):scale(1):scaleX(-1)

				arg_14_0.isBoxToOpen = true

				performWithDelay(arg_14_0, function()
					if arg_14_0.dialog == nil then
						arg_14_0:onNodeClick()

						arg_14_0.isBoxToOpen = false
					end
				end, var_0_10)
			else
				local var_15_8 = cc.Sprite:create("city/adventure/hunting/logo_sldd.png"):anchorPoint(0.5, 0.5):addTo(var_15_6, 10, "iconBg"):xy(0, 120):scale(0.3)
			end

			if arg_14_0.eventID == var_0_4.mul then
				local var_15_9 = cc.Sprite:create("city/adventure/hunting/shijian.png"):anchorPoint(0.5, 0.5):addTo(var_15_6:get("iconBg"), 10, "icon"):xy(80, 110):scale(1.5)
			elseif arg_14_0.eventID == var_0_4.HP then
				local var_15_10 = cc.Sprite:create("city/adventure/hunting/img_box_jy.png"):anchorPoint(0.5, 0.5):addTo(var_15_6:get("iconBg"), 10, "icon"):xy(80, 110)

				if arg_14_1 == 3 then
					local var_15_11 = arg_14_0.bg:get("eventPanel")
					local var_15_12 = cc.Sequence:create(cc.MoveTo:create(var_0_10 - 1, cc.p(var_15_11:x() - 1000, var_15_11:y())))

					var_15_11:get("supply"):play("run_loop")
					var_15_11:runAction(var_15_12)
					performWithDelay(arg_14_0, function()
						var_15_11:get("supply"):play("standby_loop")
					end, var_0_10 - 1)
				end
			end
		end
	end

	local var_14_1 = arg_14_0.bg:get("eventPanel") and arg_14_0.bg:get("eventPanel"):get("mul")

	if arg_14_0.routeData[arg_14_0.curNode].type == var_0_4.mul and var_14_1 then
		arg_14_0.delayTime = 1.5

		arg_14_0.bg:get("eventPanel"):setTouchEnabled(false)
		var_14_1:play("run_loop")
		var_14_1:scaleX(var_0_11[arg_14_0.eventID].scale)

		local var_14_2 = cc.Sequence:create(cc.MoveTo:create(arg_14_0.delayTime, cc.p(var_14_1:x() + 800, var_14_1:y())), cc.CallFunc:create(var_14_0))

		var_14_1:runAction(var_14_2)
	else
		arg_14_0.delayTime = 0

		var_14_0()
	end

	if arg_14_1 == 2 then
		arg_14_0.bg:x(-(arg_14_0.curProIndex - 1) * 500 - 1000)
	end
end

function var_0_13.initPanel(arg_24_0)
	if arg_24_0.curNode > arg_24_0.minId + itertools.size(arg_24_0.routeData) - 1 then
		arg_24_0.rightBottomPanel:get("clearance"):visible(true)
		arg_24_0.rightBottomPanel:get("proBg"):visible(false)
		arg_24_0.rightBottomPanel:get("proText"):visible(false)
		arg_24_0.rightBottomPanel:removeChildByName("richText")
	else
		local var_24_0 = string.format(gLanguageCsv.huntingRouteDetail, arg_24_0.routeData[arg_24_0.curNode].count, itertools.size(arg_24_0.routeData))

		arg_24_0.rightBottomPanel:get("proText"):hide()
		arg_24_0.rightBottomPanel:removeChildByName("richText")

		local var_24_1 = rich.createByStr(var_24_0, 36, nil):xy(arg_24_0.rightBottomPanel:get("proText"):x(), arg_24_0.rightBottomPanel:get("proText"):y()):anchorPoint(0.5, 0.5):addTo(arg_24_0.rightBottomPanel, 100, "richText")

		arg_24_0.rightBottomPanel:get("clearance"):visible(false)
		arg_24_0.rightBottomPanel:get("proBg"):visible(true)
	end
end

function var_0_13.checkCurIndex(arg_25_0, arg_25_1)
	local var_25_0 = 1

	for iter_25_0, iter_25_1 in ipairs(arg_25_0.prograssData) do
		if arg_25_0.curNode == arg_25_0.minId + itertools.size(arg_25_0.routeData) then
			var_25_0 = itertools.size(arg_25_0.prograssData)

			break
		elseif iter_25_1.prograssIndex == arg_25_0.curNode and iter_25_1.round == arg_25_0.curNode - 1 then
			var_25_0 = iter_25_0

			break
		end
	end

	var_25_0 = arg_25_1 == 2 and var_25_0 + 1 or var_25_0

	arg_25_0:refreshProgress(var_25_0)

	arg_25_0.curProIndex = var_25_0
end

function var_0_13.updatePerformance(arg_26_0)
	local var_26_0 = arg_26_0.prograssData[arg_26_0.curProIndex].percent
	local var_26_1 = arg_26_0.prograssData[arg_26_0.curProIndex + 1].percent
	local var_26_2 = var_26_1 - var_26_0
	local var_26_3 = arg_26_0.bar[arg_26_0.prograssData[arg_26_0.curProIndex].prograssIndex]:get("pro")

	arg_26_0.prograssPanel:scheduleUpdate(function(arg_27_0)
		local var_27_0 = var_26_3:getPercent()

		if var_27_0 >= var_26_1 then
			arg_26_0.prograssPanel:unscheduleUpdate()
		else
			var_26_3:setPercent(var_27_0 + arg_27_0 * var_26_2 / var_0_10)
		end
	end)

	local var_26_4 = cc.Sequence:create(cc.MoveTo:create(var_0_10, cc.p(arg_26_0.prograssData[arg_26_0.curProIndex + 1].spineX, arg_26_0.runSpine:y())))

	arg_26_0.runSpine:runAction(var_26_4)

	local var_26_5 = cc.Sequence:create(cc.MoveTo:create(var_0_10, cc.p(arg_26_0.prograssData[arg_26_0.curProIndex + 1].panelX, arg_26_0.prograssPanel:y())))

	arg_26_0.prograssPanel:runAction(var_26_5)
	arg_26_0:initSpine(2)
	performWithDelay(arg_26_0, function()
		arg_26_0:initSpine(1)

		if arg_26_0.bg:get("eventPanel") then
			bind.click(arg_26_0, arg_26_0.bg:get("eventPanel"), {
				method = function()
					arg_26_0:onNodeClick()
				end
			})
		end
	end, var_0_10)

	local var_26_6 = cc.EaseInOut:create(cc.RotateTo:create(var_0_10, -36), var_0_10)

	arg_26_0.circlePanel:runAction(var_26_6)
	arg_26_0.bg:x(-(arg_26_0.curProIndex - 1) * 500)

	local var_26_7 = cc.Sequence:create(cc.MoveTo:create(var_0_10, cc.p(arg_26_0.bg:x() - 1000, arg_26_0.bg:y())))

	arg_26_0.bg:runAction(var_26_7)
end

function var_0_13.onNodeClick(arg_30_0)
	local var_30_0 = arg_30_0.curNode

	if arg_30_0.eventID == var_0_4.gate then
		if arg_30_0.curNode < arg_30_0.minId + itertools.size(arg_30_0.routeData) then
			local var_30_1 = arg_30_0.boardId > 0 and arg_30_0.boardId or arg_30_0.routeData[arg_30_0.curNode].gateIDs[1]

			gGameUI:stackUI("city.adventure.hunting.gate_detail", nil, nil, arg_30_0.gateDatas, var_30_1, arg_30_0.route, var_30_0, arg_30_0:createHandler("onClientRouteRefresh"))
		end
	elseif arg_30_0.eventID == var_0_4.box then
		gGameUI:stackUI("city.adventure.hunting.open_box", nil, {
			blackLayer = true,
			clickClose = true
		}, arg_30_0.route, var_30_0, arg_30_0:createHandler("onClientRouteRefresh"))
	elseif arg_30_0.eventID == var_0_4.HP then
		local var_30_2 = csv.cross.hunting.route[var_30_0].supplyGroup or 1

		gGameUI:stackUI("city.adventure.hunting.supply", nil, {
			blackLayer = true
		}, {
			route = arg_30_0.route,
			node = var_30_0,
			group = var_30_2
		}, arg_30_0:createHandler("onClientRouteRefresh"))
	elseif arg_30_0.eventID == var_0_4.mul then
		gGameUI:stackUI("city.adventure.hunting.select_event", nil, {
			blackLayer = true
		}, var_30_0, arg_30_0:createHandler("onClientRouteRefresh"))
	end
end

function var_0_13.onClientRouteRefresh(arg_31_0)
	arg_31_0.clientRouteInfoFlag:notify()
end

function var_0_13.onEndClick(arg_32_0)
	local function var_32_0()
		gGameApp:requestServer("/game/hunting/route/end", function(arg_34_0)
			arg_32_0:onClose()
		end, arg_32_0.route)
	end

	local function var_32_1()
		arg_32_0.dialog = nil

		if arg_32_0.isBoxToOpen then
			arg_32_0:onNodeClick()
		end

		arg_32_0.isBoxToOpen = false
	end

	local var_32_2 = {
		isRich = false,
		btnType = 2,
		cb = var_32_0,
		closeCb = var_32_1,
		cancelCb = var_32_1,
		content = gLanguageCsv.huntingExitGame,
		dialogParams = {
			clickClose = false
		}
	}

	arg_32_0.dialog = gGameUI:stackUI("common.prompt_box", nil, nil, var_32_2)
end

function var_0_13.onBuffBtnClick(arg_36_0)
	local var_36_0 = gGameModel.hunting:read("hunting_route")[arg_36_0.route].buffs or {}

	if itertools.size(var_36_0) == 0 then
		gGameUI:showTip(gLanguageCsv.huntingNoBuff)

		return
	end

	local var_36_1 = arg_36_0.buffActionNode:y()
	local var_36_2

	if arg_36_0.isOpen then
		var_36_2 = cc.p(-arg_36_0.buffCoverPanel:get("actionNode.bg"):width(), 100)
	else
		var_36_2 = cc.p(0, 100)
	end

	local var_36_3 = cc.Sequence:create(cc.MoveTo:create(0.5, var_36_2), cc.CallFunc:create(function()
		arg_36_0.isOpen = not arg_36_0.isOpen
	end))

	arg_36_0.buffActionNode:stopAllActions()
	arg_36_0.buffActionNode:runAction(var_36_3)
end

function var_0_13.onItemClick(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
	if gGameUI.itemDetailView then
		gGameUI.itemDetailView:onClose()
	end

	local var_38_0 = "city.adventure.hunting.buff_detail"
	local var_38_1 = "horizontal"
	local var_38_2 = {
		"baseNode"
	}
	local var_38_3 = tip.create(var_38_0, nil, {
		dir = "top",
		offy = 150,
		relativeNode = arg_38_3,
		canvasDir = var_38_1,
		childsName = var_38_2
	}, arg_38_4)

	var_38_3:onNodeEvent("exit", functools.partial(gGameUI.unModal, gGameUI, var_38_3))
	gGameUI:doModal(var_38_3)

	gGameUI.itemDetailView = var_38_3
end

return var_0_13
