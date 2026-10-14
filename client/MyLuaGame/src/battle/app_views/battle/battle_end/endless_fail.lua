local var_0_0 = require("battle.app_views.battle.battle_end.pve_fail")
local var_0_1 = class("BattleEndlessFailView", var_0_0)

;({}).binds = {
	event = "effect",
	data = {
		outline = {
			color = ui.NEWCOLORS.OUTLINE.YELLOW1
		}
	}
}
var_0_1.RESOURCE_FILENAME = "battle_end_pve_fail.json"
var_0_1.RESOURCE_BINDING = {
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
	}
}

function var_0_1.playRecord(arg_1_0)
	arg_1_0.battleView.entrance:restart()
end

function var_0_1.showMvpInfo(arg_2_0)
	local var_2_0 = arg_2_0:getResourceNode()
	local var_2_1 = CSprite.new("effect/gongxihuode.skel")

	var_2_1:addTo(var_2_0, 99)
	var_2_1:setAnchorPoint(cc.p(0.5, 1))
	var_2_1:setPosition(display.cx, display.cy)
	var_2_1:visible(true)
	var_2_1:play("jiesuan_shibaitu_new")
	var_2_1:addPlay("jiesuan_shibaitu_new_loop")
	var_2_1:retain()
	var_2_1:scale(2)

	local var_2_2 = arg_2_0.data
	local var_2_3 = arg_2_0:getResourceNode()

	arg_2_0.bestCardId = var_2_2.roleOut[arg_2_0.results.mvpPosId].roleId

	local var_2_4 = csv.unit[arg_2_0.bestCardId].unitRes
	local var_2_5 = string.gsub(var_2_4, ".skel", "_ui.skel")
	local var_2_6 = CSprite.new(var_2_5)

	var_2_6:addTo(var_2_3, 100)
	var_2_6:setAnchorPoint(cc.p(0.5, 1))
	var_2_6:setPosition(display.cx / 4, -188)
	var_2_6:play("standby_loop")
	var_2_6:scale(2)
end

return var_0_1
