local var_0_0 = class("BattleEndJFView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "battle_end_jf.json"
var_0_0.RESOURCE_BINDING = {
	["imgRankBg.imgUp"] = "upIcon",
	["imgRankBg.rank"] = "myNum",
	["imgRankBg.bg"] = "rankBg",
	["imgRankBg.rankUp"] = "changeNum",
	["imgRankBg.tip"] = "numTipType",
	playBackPanel = "playBackPanel",
	imgRankBg = "imgRankRoot",
	exitPanel = "exitPanel",
	["playBackPanel.playBackBg"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlayBackClick")
			}
		}
	},
	["playBackPanel.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["exitPanel.exitBg"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onQuitClick")
			}
		}
	},
	["exitPanel.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	imgBg = {
		varname = "imgBg",
		binds = {
			event = "click",
			method = bindHelper.self("onQuitClick")
		}
	}
}

function var_0_0.playEffect(arg_1_0)
	local var_1_0 = arg_1_0.isFail
	local var_1_1 = arg_1_0:getResourceNode()
	local var_1_2, var_1_3 = var_1_1:get("title"):xy()

	widget.addAnimation(var_1_1, "effect/gongxihuode.skel", var_1_0 and "zhandoushibai" or "zhandoushengli", 100):anchorPoint(cc.p(0.5, 1)):xy(var_1_2, var_1_3):addPlay(var_1_0 and "zhandoushibai_loop" or "zhandoushengli_loop")
end

function var_0_0.onCreate(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	arg_2_0.cb = arg_2_4
	arg_2_0.data = arg_2_2
	arg_2_0.results = arg_2_3
	arg_2_0.isFail = arg_2_0.results.result ~= "win"

	if arg_2_0.isFail then
		arg_2_0.imgBg:texture("city/pvp/reward/bg_pvp_lose.png")
		arg_2_0.rankBg:texture("battle/online_fight/img_lose_bg.png")
		text.addEffect(arg_2_0.numTipType, {
			italic = {},
			outline = {
				color = cc.c4b(97, 117, 156, 255)
			}
		})
	else
		arg_2_0.imgBg:texture("city/pvp/reward/bg_pvp_win.png")
		arg_2_0.rankBg:texture("battle/online_fight/img_win_bg.png")
		text.addEffect(arg_2_0.numTipType, {
			italic = {},
			outline = {
				color = cc.c4b(235, 99, 54, 255)
			}
		})
	end

	if arg_2_0.results.fromRecord then
		arg_2_0.imgRankRoot:visible(false)
		arg_2_0.playBackPanel:y(arg_2_0.playBackPanel:y() + 70)
		arg_2_0.exitPanel:y(arg_2_0.exitPanel:y() + 70)
	else
		local var_2_0 = arg_2_3.serverData.view

		arg_2_0.changeNum:visible(true)
		arg_2_0.upIcon:visible(true)

		if var_2_0.rank_move >= 0 then
			arg_2_0.upIcon:texture("common/icon/logo_arrow_green.png")
		else
			arg_2_0.upIcon:texture("common/icon/logo_arrow_red.png")
		end

		arg_2_0.myNum:text(var_2_0.rank)
		arg_2_0.changeNum:text(math.abs(var_2_0.rank_move))
	end

	arg_2_0:playEffect()

	if arg_2_3.from == "ban_embattle" then
		ccui.ImageView:create("battle/scene/bg_dzjjc.png"):scale(2):xy(display.sizeInView.width / 2, display.sizeInView.height / 2):addTo(arg_2_0:getResourceNode(), 0)
	end
end

function var_0_0.onPlayBackClick(arg_3_0)
	if arg_3_0.results.from == "ban_embattle" then
		gGameUI:showTip(gLanguageCsv.noPlayBack)

		return
	end

	local var_3_0 = arg_3_0.data

	if not arg_3_0.data.play_record_id or not arg_3_0.data.cross_key then
		local var_3_1

		if arg_3_0.results.serverData.view.pattern == 1 then
			var_3_1 = table.deepcopy(gGameModel.cross_online_fight:read("unlimited_history"), true)
		else
			var_3_1 = table.deepcopy(gGameModel.cross_online_fight:read("limited_history"), true)
		end

		table.sort(var_3_1, function(arg_4_0, arg_4_1)
			return arg_4_0.time > arg_4_1.time
		end)

		var_3_0 = var_3_1[1]
	end

	gGameModel:playRecordBattle(var_3_0.play_record_id, var_3_0.cross_key, "/game/cross/online/playrecord/get", 0)
end

function var_0_0.onQuitClick(arg_5_0)
	if arg_5_0.cb then
		arg_5_0:addCallbackOnExit(arg_5_0.cb)
		arg_5_0:onClose()
	else
		gGameUI:switchUI("city.view")
	end
end

return var_0_0
