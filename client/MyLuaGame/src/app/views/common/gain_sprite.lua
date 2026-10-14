local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("GainSpriteView", var_0_0)

var_0_1.RESOURCE_FILENAME = "common_gain_sprite.json"
var_0_1.RESOURCE_BINDING = {
	["down.rarity"] = "rarity",
	["left.nature"] = "nature",
	["down.attr2"] = "attr2",
	["left.skillName"] = "skillName",
	["down.bottomPanel.cardName"] = "cardName",
	["down.bottomPanel.cardNote"] = "cardNote",
	["left.icon"] = "icon",
	titlePanel = "titlePanel",
	["left.skillAttr"] = "skillAttr",
	["left.skillContent"] = "skillContent",
	["down.name"] = "txtName",
	["down.attr1"] = "attr1",
	["down.bottomPanel"] = "bottomPanel",
	["down.bottomPanel.pos"] = "pos",
	btnJump = {
		varname = "btnJump",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onJump")
			}
		}
	},
	["btnJump.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	left = {
		varname = "leftPanel",
		binds = {
			event = "visible",
			idler = bindHelper.self("isShowPanel")
		}
	},
	down = {
		varname = "downPanel",
		binds = {
			event = "visible",
			idler = bindHelper.self("isShowPanel")
		}
	},
	cardImg = {
		varname = "cardImg",
		binds = {
			event = "visible",
			idler = bindHelper.self("isShowPanel")
		}
	},
	effect = {
		varname = "effect",
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0.panel = ccui.Layout:create():addTo(arg_1_0:getResourceNode(), 100, "mask"):setAnchorPoint(cc.p(0.5, 0.5)):size(cc.size(display.maxWidth, display.height)):alignCenter(arg_1_0:getResourceNode():size()):setTouchEnabled(true):show()

	audio.playEffectWithWeekBGM("card_gain.mp3")

	arg_1_0.isShowPanel = idler.new(false)

	performWithDelay(arg_1_0.effect, function()
		arg_1_0.leftPanel:scaleX(0)
		arg_1_0.downPanel:scaleX(0)
		arg_1_0.isShowPanel:set(true)
		transition.executeSequence(arg_1_0.leftPanel):scaleXTo(0.5, 1.1):scaleXTo(0.1, 1):done()
		transition.executeSequence(arg_1_0.downPanel):scaleXTo(0.5, 1.1):scaleXTo(0.1, 1):done()
	end, 0.6666666666666666)

	arg_1_2 = arg_1_2 or {}

	if arg_1_4 then
		arg_1_0.cb = arg_1_4
	end

	local var_1_0 = gGameModel.cards:find(arg_1_1.dbid or arg_1_1.db_id):read("card_id", "character", "nvalue", "name", "advance")

	arg_1_0.nature:text(csv.character[var_1_0.character].name)

	local var_1_1 = csv.cards[var_1_0.card_id]
	local var_1_2 = csv.unit[var_1_1.unitID]
	local var_1_3 = var_1_2.skillList
	local var_1_4 = csv.skill[var_1_3[itertools.size(var_1_3)]]

	arg_1_0.skillContent:hide()
	beauty.textScroll({
		size = arg_1_0.skillContent:size(),
		strs = var_1_4.simDesc
	}):xy(arg_1_0.skillContent:box()):z(arg_1_0.skillContent:z()):addTo(arg_1_0.skillContent:parent())
	arg_1_0.skillName:text(var_1_4.skillName)
	arg_1_0.icon:texture(ui.SKILL_ICON[var_1_4.skillNatureType])
	arg_1_0.skillAttr:texture(ui.SKILL_TEXT_ICON[var_1_4.skillNatureType])
	arg_1_0.rarity:texture(ui.RARITY_ICON[var_1_2.rarity])

	local var_1_5 = arg_1_0.cardImg:size()
	local var_1_6 = string.gsub(var_1_2.unitRes, ".skel", "_ui.skel")

	widget.addAnimation(arg_1_0.cardImg, var_1_6, "standby_loop", 5):xy(var_1_5.width / 2, -150):scale(var_1_2.scaleU * 0.8):setSkin(var_1_2.skin)
	uiEasy.setIconName("card", var_1_0.card_id, {
		space = true,
		node = arg_1_0.txtName,
		name = var_1_0.name,
		advance = var_1_0.advance
	})
	arg_1_0.attr2:visible(var_1_2.natureType2 ~= nil)

	if var_1_2.natureType2 then
		arg_1_0.attr2:texture(ui.ATTR_ICON[var_1_2.natureType2])
	end

	arg_1_0.attr1:texture(ui.ATTR_ICON[var_1_2.natureType])

	arg_1_0.nvalue = var_1_0.nvalue
	arg_1_1.new = arg_1_1.new or arg_1_1.first

	if arg_1_1.new and not arg_1_2[var_1_0.card_id] then
		arg_1_2[var_1_0.card_id] = true

		arg_1_0.cardName:text(csv.cards[var_1_0.card_id].name)
		adapt.oneLineCenterPos(cc.p(arg_1_0.pos:xy()), {
			arg_1_0.cardName,
			arg_1_0.cardNote
		}, cc.p(10, 0))
	else
		arg_1_0.bottomPanel:hide()
	end

	adapt.oneLinePos(arg_1_0.txtName, arg_1_0.rarity, cc.p(8, 0), "right")
	adapt.oneLinePos(arg_1_0.txtName, {
		arg_1_0.attr1,
		arg_1_0.attr2
	}, cc.p(8, 0))
	performWithDelay(arg_1_0, function()
		arg_1_0.panel:hide()
	end, 1)
	arg_1_0.btnJump:visible(false)
	performWithDelay(arg_1_0, function()
		local var_4_0 = userDefault.getForeverLocalKey("isJumpSpriteView", false)
		local var_4_1 = arg_1_3

		if arg_1_3 == nil then
			var_4_1 = not var_4_0
		end

		arg_1_0.btnJump:visible(var_4_1)
	end, 0.9)

	if matchLanguage(var_1_1.languages) == false then
		errorInWindows("配置可获取到整卡 %s, 但 csv.cards (%s) 未开放", var_1_0.card_id, LOCAL_LANGUAGE)
	end
end

function var_0_1.onJump(arg_5_0)
	userDefault.setForeverLocalKey("isJumpSpriteView", true)
	arg_5_0:onClose()
end

function var_0_1.onClose(arg_6_0)
	arg_6_0:addCallbackOnExit(arg_6_0.cb)
	var_0_0.onClose(arg_6_0)
end

return var_0_1
