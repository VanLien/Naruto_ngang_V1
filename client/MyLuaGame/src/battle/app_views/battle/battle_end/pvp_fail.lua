local var_0_0 = class("BattleEndPvpFailView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "battle_end_pvp_fail.json"
var_0_0.RESOURCE_BINDING = {
	playBackPanel = "playBackPanel",
	quitPanel = "quitPanel",
	txt = {
		varname = "txt",
		binds = {
			event = "effect",
			data = {
				italic = true
			}
		}
	},
	["playBackPanel.playBackBg"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlayBackClick")
			}
		}
	},
	["quitPanel.quitBg"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onQuitClick")
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

local var_0_1 = {
	[game.GATE_TYPE.summerChallenge] = function(arg_1_0)
		local var_1_0 = arg_1_0.quitPanel:y() + 200
		local var_1_1 = arg_1_0.quitPanel:x() - (arg_1_0.quitPanel:x() - arg_1_0.playBackPanel:x()) / 2

		arg_1_0.quitPanel:y(var_1_0)
		arg_1_0.quitPanel:x(var_1_1)
		arg_1_0.playBackPanel:hide()
		arg_1_0.txt:hide()
	end
}

function var_0_0.playEffect(arg_2_0)
	local var_2_0 = arg_2_0.isFail
	local var_2_1 = arg_2_0:getResourceNode()
	local var_2_2, var_2_3 = var_2_1:get("title"):xy()

	widget.addAnimation(var_2_1, "effect/gongxihuode.skel", var_2_0 and "jiesuan_shibaitu_new" or "zhandoujiangli_new", 100):anchorPoint(cc.p(0.5, 0, 5)):xy(display.cx, display.cy):addPlay(var_2_0 and "jiesuan_shibaitu_new_loop" or "zhandoujiangli_new_loop"):scale(2)
end

function var_0_0.onCreate(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0.data = arg_3_2
	arg_3_0.results = arg_3_3
	arg_3_0.isFail = arg_3_0.results.result ~= "win"

	if arg_3_0.isFail then
		arg_3_0.imgBg:texture("city/pvp/reward/bg_pvp_lose.png")
	else
		arg_3_0.imgBg:texture("city/pvp/reward/bg_pvp_win.png")
	end

	if arg_3_0.data.gateType == game.GATE_TYPE.gymLeader or arg_3_0.data.gateType == game.GATE_TYPE.gym or arg_3_0.data.gateType == game.GATE_TYPE.crossGym then
		arg_3_0:getResourceNode():get("txt"):text(gLanguageCsv.gymLeaderBattleFail)
	end

	arg_3_0:playEffect()

	local var_3_0 = arg_3_2.roleOut[1]
	local var_3_1 = arg_3_3.mvpPosId
	local var_3_2 = arg_3_3.mvpCardIn

	if var_3_0 and var_3_0[var_3_2] and var_3_0[var_3_2][var_3_1] then
		arg_3_0.bestCardId = var_3_0[var_3_2][var_3_1].roleId
	elseif arg_3_2.roleOut and arg_3_2.roleOut[var_3_1] then
		arg_3_0.bestCardId = arg_3_2.roleOut[var_3_1].roleId
	end

	if arg_3_0.bestCardId then
		arg_3_0:playBestEffect()
	end
end

function var_0_0.playBestEffect(arg_4_0)
	local var_4_0 = arg_4_0:getResourceNode()
	local var_4_1 = csv.unit[arg_4_0.bestCardId].unitRes
	local var_4_2 = string.gsub(var_4_1, ".skel", "_ui.skel")
	local var_4_3 = CSprite.new(var_4_2)

	var_4_3:addTo(var_4_0, 100)
	var_4_3:setAnchorPoint(cc.p(0.5, 1))
	var_4_3:setPosition(display.cx / 3, -188)
	var_4_3:visible(true)
	var_4_3:play("standby_loop")
	var_4_3:retain()
	var_4_3:scale(2)
end

function var_0_0.initModes(arg_5_0, arg_5_1)
	arg_5_0.modes = arg_5_1

	if var_0_1[arg_5_0.data.gateType] then
		var_0_1[arg_5_0.data.gateType](arg_5_0)
	end

	if arg_5_0.modes.isRecord or not arg_5_0.isFail or arg_5_0.data.gateType == game.GATE_TYPE.friendFight then
		local var_5_0 = arg_5_0.quitPanel:y() + 200

		arg_5_0.quitPanel:y(var_5_0)
		arg_5_0.playBackPanel:y(var_5_0)
		arg_5_0.txt:hide()
	end
end

function var_0_0.onPlayBackClick(arg_6_0)
	battleEntrance.battleRecord(arg_6_0.data, arg_6_0.results):show()
end

function var_0_0.onQuitClick(arg_7_0)
	gGameUI:switchUI("city.view")
end

return var_0_0
