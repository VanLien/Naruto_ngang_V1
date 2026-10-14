local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("StrangeMeteorView", cc.load("mvc").ViewBase)
local var_0_2 = require("app.views.city.card.helditem.tools")
local var_0_3 = require("app.views.city.develop.strange_meteor.tools")
local var_0_4 = {
	"yunshi_5_loop",
	"yunshi_4_loop",
	"yunshi_2_loop",
	"yunshi_3_loop",
	"yunshi_1_loop"
}
local var_0_5 = {
	cc.c4b(92, 153, 112, 255),
	cc.c4b(61, 138, 153, 255),
	cc.c4b(138, 92, 153, 255),
	cc.c4b(230, 153, 0, 255),
	cc.c4b(241, 59, 84, 255)
}

var_0_1.RESOURCE_FILENAME = "strange_meteor.json"
var_0_1.RESOURCE_BINDING = {
	meteorItem2 = "meteorItem2",
	meteorItem1 = "meteorItem1",
	meteorItem5 = "meteorItem5",
	meteorItem4 = "meteorItem4",
	bg = "bg",
	meteorItem3 = "meteorItem3",
	rule = {
		varname = "rule",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0)
	userDefault.setCurrDayKey("meteoriteDailyRedHintTags", true)
	gGameUI.topuiManager:createView("default", arg_1_0, {
		onClose = arg_1_0:createHandler("onClose")
	}):init({
		subTitle = "STRANGEMETEOR",
		title = "common/txt/txt_bt_ssshy.png"
	})
	arg_1_0:initModel()
	idlereasy.when(arg_1_0.meteorites, function()
		arg_1_0:initData()
		arg_1_0:initMeteor()
	end)
	text.addEffect(arg_1_0.rule:get("name"), {
		outline = {
			color = ui.COLORS.NORMAL.WHITE
		}
	})
end

function var_0_1.initModel(arg_3_0)
	arg_3_0.meteorites = gGameModel.role:getIdler("meteorites")
	arg_3_0.meteorData = idlers.new()
end

function var_0_1.initData(arg_4_0)
	arg_4_0.meteorObject = {
		arg_4_0.meteorItem1,
		arg_4_0.meteorItem2,
		arg_4_0.meteorItem3,
		arg_4_0.meteorItem4,
		arg_4_0.meteorItem5
	}
	arg_4_0.METEOR_CLICK_DATA = {
		{
			r = 500,
			x = arg_4_0.meteorItem1:x(),
			y = arg_4_0.meteorItem1:y()
		},
		{
			r = 500,
			x = arg_4_0.meteorItem2:x(),
			y = arg_4_0.meteorItem2:y()
		},
		{
			r = 500,
			x = arg_4_0.meteorItem3:x(),
			y = arg_4_0.meteorItem3:y()
		},
		{
			r = 500,
			x = arg_4_0.meteorItem4:x(),
			y = arg_4_0.meteorItem4:y()
		},
		{
			r = 500,
			x = arg_4_0.meteorItem5:x(),
			y = arg_4_0.meteorItem5:y()
		}
	}

	local var_4_0 = {}
	local var_4_1 = gGameModel.role:read("level")

	for iter_4_0, iter_4_1 in orderCsvPairs(csv.meteorite.base) do
		local var_4_2 = arg_4_0.meteorites:read()[iter_4_0] or {}
		local var_4_3 = math.huge

		if iter_4_0 >= 2 then
			var_4_3 = not arg_4_0.meteorites:read()[iter_4_0 - 1] and 0 or arg_4_0.meteorites:read()[iter_4_0 - 1].level
		end

		local var_4_4 = false

		if var_4_1 >= iter_4_1.unlockLevel and var_4_3 >= iter_4_1.preLevel then
			var_4_4 = true
		end

		var_4_0[iter_4_0] = {
			id = iter_4_0,
			cfg = iter_4_1,
			unlock = var_4_4,
			meteorites = var_4_2
		}
	end

	arg_4_0.meteorData:update(var_4_0)
end

function var_0_1.initMeteor(arg_5_0)
	for iter_5_0, iter_5_1 in arg_5_0.meteorData:pairs() do
		local var_5_0 = iter_5_1:read()
		local var_5_1 = arg_5_0.meteorObject[iter_5_0]
		local var_5_2 = var_5_0.cfg
		local var_5_3 = var_5_0.meteorites
		local var_5_4 = var_5_1:multiget("lock", "name", "txtLv", "extraPanel", "icon")
		local var_5_5 = var_5_3.level or 0

		arg_5_0:setUiShow(var_5_0, var_5_5, var_5_4, var_5_1, iter_5_0)

		for iter_5_2, iter_5_3 in csvMapPairs(var_5_2.unlockParams) do
			if (iter_5_2 == 1 or iter_5_2 == 2) and var_5_5 < iter_5_3 then
				var_5_4.extraPanel:get("heldItem" .. iter_5_2):get("lock"):show()
			end
		end

		for iter_5_4, iter_5_5 in csvMapPairs(var_5_2.open) do
			if (iter_5_4 == 1 or iter_5_4 == 2) and iter_5_5 == 1 then
				var_5_4.extraPanel:get("heldItem" .. iter_5_4):get("lock"):show()
			end
		end

		arg_5_0.spriteImage(arg_5_0, var_5_3, var_5_4)
		arg_5_0.carryItem(arg_5_0, var_5_3, var_5_2, var_5_4)
		bind.click(arg_5_0, var_5_1, {
			method = function()
				arg_5_0.onItemClick(arg_5_0, iter_5_0, var_5_0)
			end
		})
		arg_5_0.meteoriteUiHide(arg_5_0, var_5_1, var_5_0, iter_5_0)
		arg_5_0.operateTest(arg_5_0, iter_5_0)
	end
end

function var_0_1.spriteImage(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0

	if arg_7_1 and arg_7_1.card then
		local var_7_1 = gGameModel.cards:find(arg_7_1.card)

		if var_7_1 then
			var_7_0 = var_7_1.read(var_7_1, "card_id", "skin_id")
		end
	end

	if var_7_0 then
		local var_7_2 = dataEasy.getUnitCsv(var_7_0.card_id, var_7_0.skin_id)
		local var_7_3 = string.gsub(var_7_2.unitRes, ".skel", "_ui.skel")

		arg_7_2.extraPanel:get("spriteItem"):get("imageItem"):show()

		local var_7_4 = widget.addAnimation(arg_7_2.extraPanel:get("spriteItem"):get("imageItem"), var_7_3, battle.SpriteActionTable.standby):anchorPoint(0.5, 0):xy(20, -100):scale(0.7)
	else
		arg_7_2.extraPanel:get("spriteItem"):get("imageItem"):hide()
	end
end

function var_0_1.carryItem(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = {}

	if arg_8_1 then
		var_8_0 = arg_8_1.helditems or {}
	end

	if var_8_0[1] then
		local var_8_1 = gGameModel.held_items:find(var_8_0[1]):read("held_item_id")
		local var_8_2 = csv.held_item.items[var_8_1].icon

		arg_8_3.extraPanel:get("heldItem1"):get("imageItem"):texture(var_8_2):show():scale(1.1)
	else
		arg_8_3.extraPanel:get("heldItem1"):get("imageItem"):hide()
	end

	if arg_8_2.helditemNum >= 2 then
		if var_8_0[2] then
			local var_8_3 = gGameModel.held_items:find(var_8_0[2]):read("held_item_id")
			local var_8_4 = csv.held_item.items[var_8_3].icon

			arg_8_3.extraPanel:get("heldItem2"):get("imageItem"):texture(var_8_4):show():scale(1.1)
		else
			arg_8_3.extraPanel:get("heldItem2"):get("imageItem"):hide()
		end
	end
end

function var_0_1.meteoriteUiHide(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_1:get("icon")

	arg_9_0:getResourceNode():removeChildByName("spineMeteor" .. arg_9_3)

	local var_9_1 = cc.Sprite:create("city/develop/strange_meteor/img_qyys_bg_" .. arg_9_3 .. ".png")

	var_9_1:setAnchorPoint(0.5, 0.5)
	var_9_1:setZOrder(-1)
	var_9_1:xy(arg_9_0.meteorObject[arg_9_3]:size().width / 2, arg_9_0.meteorObject[arg_9_3]:size().height / 2)
	arg_9_0.meteorObject[arg_9_3]:addChild(var_9_1)
	var_9_0.show(var_9_0)

	local var_9_2 = cc.Sprite:create("city/develop/strange_meteor/img_qyys_yun.png"):xy(arg_9_0.meteorObject[arg_9_3]:size().width / 2, 200):setAnchorPoint(0.5, 0.5):scale(1.2):setZOrder(5)

	arg_9_0.meteorObject[arg_9_3]:addChild(var_9_2)
end

function var_0_1.operateTest(arg_10_0, arg_10_1)
	arg_10_0:getResourceNode():removeChildByName("test" .. arg_10_1)

	if dev.DEBUG_SHOW then
		local var_10_0 = arg_10_0.METEOR_CLICK_DATA[arg_10_1]

		arg_10_0.drawNode = cc.DrawNode:create()

		arg_10_0.drawNode:drawCircle(cc.p(var_10_0.x, var_10_0.y), var_10_0.r, 180, 10000, false, 1, 1, cc.c4b(255, 0, 0, 1)):addTo(arg_10_0:getResourceNode(), 100, "test" .. arg_10_1)
	end
end

function var_0_1.setUiShow(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	local var_11_0 = arg_11_1.cfg
	local var_11_1 = {
		{
			{
				250,
				30
			}
		},
		{
			{
				150,
				30
			},
			{
				350,
				30
			}
		}
	}

	arg_11_3.name:text(var_11_0.name)
	arg_11_3.txtLv:text(arg_11_2)
	arg_11_3.lock:visible(not arg_11_1.unlock)
	arg_11_3.extraPanel:get("heldItem2"):visible(var_11_0.helditemNum >= 2)
	arg_11_3.extraPanel:get("heldItem1"):scale(1.5)
	arg_11_3.extraPanel:get("heldItem2"):scale(1.5)

	if var_11_0.helditemNum >= 2 then
		printtable(var_11_1[var_11_0.helditemNum][2])
		arg_11_3.extraPanel:get("heldItem1"):xy(var_11_1[var_11_0.helditemNum][1][1], var_11_1[var_11_0.helditemNum][1][2])
		arg_11_3.extraPanel:get("heldItem2"):xy(var_11_1[var_11_0.helditemNum][2][1], var_11_1[var_11_0.helditemNum][2][2])
	else
		arg_11_3.extraPanel:get("heldItem1"):xy(var_11_1[var_11_0.helditemNum][1][1], var_11_1[var_11_0.helditemNum][1][2])
	end

	arg_11_3.extraPanel:get("bg"):width(var_11_0.helditemNum >= 2 and 260 or 185):setCapInsets(cc.rect(111, 40, 1, 1))
	itertools.invoke({
		arg_11_3.extraPanel:get("spriteItem"):get("img_add"),
		arg_11_3.extraPanel:get("heldItem1"):get("img_add"),
		arg_11_3.extraPanel:get("heldItem2"):get("img_add")
	}, "visible", false)
	itertools.invoke({
		arg_11_3.extraPanel:get("spriteItem"):get("lock"),
		arg_11_3.extraPanel:get("heldItem1"):get("lock"),
		arg_11_3.extraPanel:get("heldItem2"):get("lock")
	}, "visible", false)
	arg_11_3.extraPanel:get("spriteItem"):setTouchEnabled(false)
	arg_11_3.extraPanel:get("heldItem1"):setTouchEnabled(false)
	arg_11_3.extraPanel:get("heldItem2"):setTouchEnabled(false)
	arg_11_3.extraPanel:get("spriteItem"):get("bg"):setOpacity(128)
	arg_11_3.extraPanel:get("heldItem1"):get("bg"):setOpacity(128)
	arg_11_3.extraPanel:get("heldItem2"):get("bg"):setOpacity(128)
	text.addEffect(arg_11_3.name, {
		outline = {
			color = var_0_5[arg_11_5]
		}
	})
	text.addEffect(arg_11_3.txtLv, {
		outline = {
			color = ui.COLORS.NORMAL.DEFAULT
		}
	})
	adapt.oneLinePos(arg_11_4:get("txtLvNote"), arg_11_3.txtLv, cc.p(20, 0))
	arg_11_3.extraPanel:get("spriteItem"):get("lock"):visible(not arg_11_1.unlock)
	itertools.invoke({
		arg_11_3.extraPanel,
		arg_11_4:get("lvBg"),
		arg_11_4:get("txtLvNote"),
		arg_11_4:get("name"),
		arg_11_4:get("txtLv")
	}, "visible", arg_11_1.unlock)
end

function var_0_1.onRuleClick(arg_12_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_12_0:createHandler("getRuleContext"), {
		width = 1500
	})
end

function var_0_1.getRuleContext(arg_13_0, arg_13_1)
	local var_13_0 = adaptContext

	return {
		var_13_0.clone(arg_13_1.title, function(arg_14_0)
			arg_14_0:get("text"):text(gLanguageCsv.meteorRuleTitle)
		end),
		var_13_0.noteText(128401, 128500)
	}
end

function var_0_1.onItemClick(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0.METEOR_CLICK_DATA[arg_15_1]
	local var_15_1 = arg_15_0.meteorObject[arg_15_1]:getTouchBeganPosition()

	if not var_0_3.isClickPositionInCircle(var_15_1.x, var_15_1.y, var_15_0.x, var_15_0.y, var_15_0.r) then
		return
	end

	if arg_15_2.unlock then
		gGameUI:stackUI("city.develop.strange_meteor.detail", nil, nil, arg_15_1)
	else
		gGameUI:stackUI("city.develop.strange_meteor.unlock_tips", nil, {
			clickClose = true
		}, arg_15_1)
	end
end

function var_0_1.onClose(arg_16_0)
	gGameApp:requestServer("/game/meteorite/refresh", function()
		var_0_0.onClose(arg_16_0)
	end)
end

return var_0_1
