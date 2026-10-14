local var_0_0 = class("BattleEndPvpRewardView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "battle_end_pvp_reward.json"
var_0_0.RESOURCE_BINDING = {
	title = "title",
	item = "item",
	["item.imgCardBack"] = "imgCardBack",
	["item.awardPanel.imgCard"] = "imgCard",
	textContinue = "textContinue",
	imgBg = {
		varname = "imgBg",
		binds = {
			event = "click",
			method = bindHelper.self("onCloseClick")
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 3,
				data = bindHelper.self("listData"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("imgCardBack", "awardPanel")

					arg_1_0.initItem(arg_1_1, arg_1_2)
					bind.touch(arg_1_0, var_1_0.imgCardBack, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick"),
				initItem = bindHelper.self("initItem")
			}
		}
	}
}

function var_0_0.playEffect(arg_2_0)
	local var_2_0 = arg_2_0:getResourceNode()

	arg_2_0.selEffect = CSprite.new("effect/gongxihuode.skel")

	arg_2_0.selEffect:addTo(var_2_0, 100)
	arg_2_0.selEffect:setAnchorPoint(cc.p(0.5, 1))

	local var_2_1, var_2_2 = arg_2_0.title:xy()

	arg_2_0.selEffect:xy(var_2_1, var_2_2)
	arg_2_0.selEffect:visible(true)

	if arg_2_0.isBattleWin then
		arg_2_0.selEffect:play("zhandoujiangli")
		arg_2_0.selEffect:addPlay("zhandoujiangli_loop")
	else
		arg_2_0.selEffect:play("zhandoujiangli2")
		arg_2_0.selEffect:addPlay("zhandoujiangli2_loop")
	end

	arg_2_0.selEffect:retain()
end

function var_0_0.onCreate(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1.serverData.view
	local var_3_1 = var_3_0.result

	arg_3_0.awardTb = var_3_0.award
	arg_3_0.showItemTb = var_3_0.show
	arg_3_0.isBattleWin = var_3_1 == "win"

	arg_3_0.imgCard:hide()

	if arg_3_0.isBattleWin then
		arg_3_0.imgCardBack:texture("city/pvp/reward/img_kapai01@.png")
		arg_3_0.imgCard:texture("city/pvp/reward/img_kapai02@.png")
		arg_3_0.imgBg:texture("city/pvp/reward/bg_pvp_win.png")
	else
		arg_3_0.imgCardBack:texture("city/pvp/reward/img_kapai_defeat01@.png")
		arg_3_0.imgCard:texture("city/pvp/reward/img_kapai_defeat02@.png")
		arg_3_0.imgBg:texture("city/pvp/reward/bg_pvp_lose.png")
	end

	arg_3_0.imgCardBack:y(arg_3_0.imgCardBack:y() - 25)
	arg_3_0:playEffect()

	arg_3_0.listData = {
		{
			key = 1
		},
		{
			key = 2
		},
		{
			key = 3
		}
	}
end

function var_0_0.setCanJump(arg_4_0)
	arg_4_0.canJump = arg_4_0.canJump or 0
	arg_4_0.canJump = arg_4_0.canJump + 1

	if arg_4_0.canJump >= 3 then
		arg_4_0.textContinue:text(gLanguageCsv.click2Continue)
	end
end

function var_0_0.initItem(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_0.items = arg_5_0.items or {}
	arg_5_0.items[arg_5_3] = arg_5_2
end

function var_0_0.onItemClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_0.clickClose then
		return
	end

	arg_6_0.clickClose = true

	local var_6_0 = 1

	for iter_6_0, iter_6_1 in pairs(arg_6_0.items) do
		if iter_6_0 ~= arg_6_2 then
			local var_6_1 = var_6_0

			var_6_0 = var_6_0 + 1

			performWithDelay(iter_6_1, function()
				arg_6_0:showEffectOnItem(arg_6_1, iter_6_1, arg_6_0.showItemTb[var_6_1], false)
			end, 1)
		else
			arg_6_0:showEffectOnItem(arg_6_1, iter_6_1, arg_6_0.awardTb, true)
		end
	end
end

function var_0_0.showEffectOnItem(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0, var_8_1 = next(arg_8_3)
	local var_8_2 = arg_8_2:multiget("imgCardBack", "awardPanel")
	local var_8_3 = var_8_2.awardPanel:multiget("imgCard", "itemPanel", "awardName", "selectBox")

	var_8_2.imgCardBack:setTouchEnabled(false)
	bind.extend(arg_8_1, var_8_3.itemPanel, {
		class = "icon_key",
		props = {
			data = {
				key = var_8_0,
				num = var_8_1 or 0
			},
			onNode = function(arg_9_0)
				arg_9_0:setTouchEnabled(false)
			end
		}
	})
	var_8_3.awardName:text(dataEasy.getCfgByKey(var_8_0).name)
	var_8_3.awardName:hide()

	local var_8_4 = beauty.singleTextLimitWord(dataEasy.getCfgByKey(var_8_0).name, {
		fontSize = var_8_3.awardName:getFontSize()
	}, {
		width = 350
	}):anchorPoint(0.5, 0.5):xy(var_8_3.awardName:xy()):addTo(var_8_2.awardPanel, var_8_3.awardName:z()):color(cc.c3b(255, 255, 255))

	text.addEffect(var_8_4, {
		outline = {
			color = ui.NEWCOLORS.OUTLINE.BLACK
		}
	})
	var_8_2.imgCardBack:scale(2)
	var_8_2.awardPanel:scale(0, 1)
	transition.executeSequence(var_8_2.imgCardBack):func(function()
		if arg_8_4 then
			local var_10_0, var_10_1 = arg_8_2:xy()
			local var_10_2, var_10_3 = arg_8_1:xy()

			widget.addAnimation(arg_8_1:parent(), "effect/gongxihuode.skel", arg_8_0.isBattleWin and "fanpai" or "fanpai2", 1):anchorPoint(cc.p(0, 0)):xy(var_10_0 + var_10_2, var_10_1 + var_10_3)
			audio.playEffectWithWeekBGM("flop.mp3")
		else
			var_8_3.imgCard:show()
		end
	end):delay(arg_8_4 and 0.6 or 0):func(function()
		var_8_3.itemPanel:show()
	end):scaleTo(0.2, 0, 2):func(function()
		transition.executeSequence(var_8_2.awardPanel):scaleTo(0.2, 1, 1):done()
	end):delay(0.5):func(function()
		arg_8_0:setCanJump()
	end):done()
end

function var_0_0.onCloseClick(arg_14_0)
	if not arg_14_0.canJump or arg_14_0.canJump < 3 then
		return
	end

	local var_14_0 = arg_14_0.showEndView

	arg_14_0:onClose()
	var_14_0()
end

return var_0_0
