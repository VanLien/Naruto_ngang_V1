local var_0_0 = class("BattleEndFailView", cc.load("mvc").ViewBase)

;({}).binds = {
	event = "effect",
	data = {
		outline = {
			color = ui.NEWCOLORS.OUTLINE.YELLOW1
		}
	}
}
;({}).binds = {
	event = "effect",
	data = {
		outline = {
			color = ui.COLORS.NORMAL.WHITE
		}
	}
}
var_0_0.RESOURCE_FILENAME = "battle_end_pve_fail.json"
var_0_0.RESOURCE_BINDING = {
	exitText = "exitText",
	eggBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onEggBtnClick")
			}
		}
	},
	promoteBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPromoteBtnClick")
			}
		}
	},
	strengthBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onStrengthBtnClick")
			}
		}
	},
	backBtn = {
		varname = "backBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBackBtnClick")
			}
		}
	},
	againBtn = {
		varname = "againBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAgainBtnClick")
			}
		}
	},
	dungeonsBtn = {
		varname = "dungeonsBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDungeonsBtnClick")
			}
		}
	},
	reStartBtn = {
		varname = "reStartBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onReStartBtnClick")
			}
		}
	},
	backCityBtn = {
		varname = "backCityBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBackCityBtnClick")
			}
		}
	},
	bkg = {
		varname = "bkg",
		binds = {
			event = "click",
			method = bindHelper.self("onBgClick")
		}
	},
	roundNums = {
		varname = "roundNums",
		binds = {
			event = "extend",
			class = "text_atlas",
			props = {
				pathName = "frhd_num",
				isEqualDist = false,
				align = "center",
				data = bindHelper.self("rounds")
			}
		}
	}
}

function var_0_0.playEndEffect(arg_1_0)
	local var_1_0 = arg_1_0:getResourceNode()
	local var_1_1 = CSprite.new("effect/gongxihuode.skel")

	var_1_1:addTo(var_1_0, 100)
	var_1_1:setAnchorPoint(cc.p(0.5, 1))
	var_1_1:setPosition(var_1_0:get("title"):getPosition())
	var_1_1:visible(true)
	var_1_1:play("jiesuan_shibaizi")
	var_1_1:addPlay("jiesuan_shibaizi_loop")
	var_1_1:retain()

	local var_1_2 = CSprite.new("effect/gongxihuode.skel")

	var_1_2:addTo(var_1_0, 99)
	var_1_2:setAnchorPoint(cc.p(0.5, 1))
	var_1_2:setPosition(var_1_0:get("title"):getPosition())
	var_1_2:visible(true)
	var_1_2:play("jiesuan_shibaitu")
	var_1_2:addPlay("jiesuan_shibaitu_loop")
	var_1_2:retain()
end

function var_0_0.initMode(arg_2_0, arg_2_1)
	arg_2_1 = arg_2_1 or 1

	local var_2_0 = {
		{
			arg_2_0.backBtn,
			arg_2_0.againBtn,
			arg_2_0.dungeonsBtn
		},
		{
			arg_2_0.reStartBtn,
			arg_2_0.backCityBtn
		},
		{
			arg_2_0.bkg,
			arg_2_0.exitText
		}
	}

	for iter_2_0, iter_2_1 in pairs(var_2_0[arg_2_1]) do
		iter_2_1:show()
	end

	arg_2_0.bkg:setTouchEnabled(arg_2_1 == 3)
end

function var_0_0.onCreate(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	audio.playEffectWithWeekBGM("battle_false.mp3")

	arg_3_0.battleView = arg_3_1
	arg_3_0.sceneID = arg_3_1.sceneID
	arg_3_0.data = arg_3_1.data
	arg_3_0.results = arg_3_3

	arg_3_0:initMode(arg_3_4)

	if arg_3_0.data.gateType == game.GATE_TYPE.braveChallenge then
		arg_3_0:getResourceNode():get("round"):text(gLanguageCsv.round .. " :"):show()

		arg_3_0.rounds = arg_3_3.round

		arg_3_0.roundNums:show()
	end

	arg_3_0:showMvpInfo()
end

function var_0_0.showMvpInfo(arg_4_0)
	local var_4_0 = arg_4_0.data
	local var_4_1 = arg_4_0:getResourceNode()
	local var_4_2 = var_4_0.roleOut[1]
	local var_4_3 = arg_4_0.results.mvpPosId
	local var_4_4 = arg_4_0.results.mvpCardIn

	if var_4_2 and var_4_2[var_4_4] and var_4_2[var_4_4][var_4_3] then
		arg_4_0.bestCardId = var_4_2[var_4_4][var_4_3].roleId
	elseif var_4_0.roleOut and var_4_0.roleOut[var_4_3] then
		arg_4_0.bestCardId = var_4_0.roleOut[var_4_3].roleId
	end

	if arg_4_0.bestCardId then
		local var_4_5 = csv.unit[arg_4_0.bestCardId].unitRes
		local var_4_6 = string.gsub(var_4_5, ".skel", "_ui.skel")
		local var_4_7 = CSprite.new("effect/gongxihuode.skel")

		var_4_7:addTo(var_4_1, 99)
		var_4_7:setAnchorPoint(cc.p(0.5, 1))
		var_4_7:setPosition(display.cx, display.cy)
		var_4_7:visible(true)
		var_4_7:play("jiesuan_shibaitu_new")
		var_4_7:addPlay("jiesuan_shibaitu_new_loop")
		var_4_7:retain()

		local var_4_8 = CSprite.new(var_4_6)

		var_4_8:addTo(var_4_1, 100)
		var_4_8:setAnchorPoint(cc.p(0.5, 1))
		var_4_8:setPosition(display.cx / 4, -141)
		var_4_8:visible(true)
		var_4_8:play("standby_loop")
		var_4_8:retain()
		var_4_7:scale(2)
		var_4_8:scale(2)
	end
end

function var_0_0.playRecord(arg_5_0)
	local var_5_0 = arg_5_0.data
	local var_5_1 = arg_5_0.battleView.entrance

	if var_5_0.gateType == game.GATE_TYPE.normal then
		var_5_1:restart()
	end
end

function var_0_0.backToCity(arg_6_0)
	gGameUI:cleanStash()
	gGameUI:switchUI("city.view")
end

function var_0_0.backToList(arg_7_0)
	gGameUI:switchUI("city.view")
end

function var_0_0.onEggBtnClick(arg_8_0)
	gGameUI:switchUI("city.view")
	gGameUI:stackUI("city.drawcard.view")
end

function var_0_0.onPromoteBtnClick(arg_9_0)
	gGameUI:cleanStash()
	gGameUI:switchUI("city.view")
	jumpEasy.jumpTo("strengthen")
end

function var_0_0.onStrengthBtnClick(arg_10_0)
	gGameUI:cleanStash()
	gGameUI:switchUI("city.view")
	jumpEasy.jumpTo("strengthen")
end

function var_0_0.onBackBtnClick(arg_11_0)
	arg_11_0:backToCity()
end

function var_0_0.onAgainBtnClick(arg_12_0)
	arg_12_0:playRecord()
end

function var_0_0.onDungeonsBtnClick(arg_13_0)
	arg_13_0:backToList()
end

function var_0_0.onReStartBtnClick(arg_14_0)
	arg_14_0:playRecord()
end

function var_0_0.onBackCityBtnClick(arg_15_0)
	arg_15_0:backToList()
end

function var_0_0.onBgClick(arg_16_0)
	arg_16_0:backToList()
end

return var_0_0
