local var_0_0 = class("AttributeFilterView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "common_influence_attr.json"
var_0_0.RESOURCE_BINDING = {
	sm = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_1_0)
					arg_1_0:atrributeBtn(1)
				end)
			}
		}
	},
	speed = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_2_0)
					arg_2_0:atrributeBtn(13)
				end)
			}
		}
	},
	wg = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_3_0)
					arg_3_0:atrributeBtn(7)
				end)
			}
		}
	},
	wf = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_4_0)
					arg_4_0:atrributeBtn(9)
				end)
			}
		}
	},
	tg = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_5_0)
					arg_5_0:atrributeBtn(8)
				end)
			}
		}
	},
	tf = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_6_0)
					arg_6_0:atrributeBtn(10)
				end)
			}
		}
	},
	btn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("btnClose")
			}
		}
	},
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("btnClose")
			}
		}
	}
}

function var_0_0.onCreate(arg_7_0, arg_7_1)
	arg_7_0.isShow = arg_7_1.panelState
	arg_7_0.selectDatas = arg_7_1.selectDatas
end

function var_0_0.atrributeBtn(arg_8_0, arg_8_1)
	arg_8_0.selectDatas:set(arg_8_1)
	arg_8_0.isShow:set(false)
end

function var_0_0.btnClose(arg_9_0)
	arg_9_0.isShow:set(false)
end

return var_0_0
