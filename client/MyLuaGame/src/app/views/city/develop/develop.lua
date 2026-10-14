local function var_0_0()
	return {
		{
			key = "title_book",
			unlockKey = "title",
			viewName = "city.develop.title_book.view",
			icon = "city/main/icon_chp@.png",
			name = gLanguageCsv.titleBook
		},
		{
			key = "trainer",
			unlockKey = "trainer",
			viewName = "city.develop.trainer.view",
			icon = "city/main/icon_mxzz.png",
			name = gLanguageCsv.training,
			styles = {
				full = true
			}
		},
		{
			icon = "city/main/icon_tf@.png",
			key = "talent",
			unlockKey = "talent",
			viewName = "city.develop.talent.view",
			bg = "city/panel_icon2.png",
			name = gLanguageCsv.talent,
			styles = {
				full = true
			}
		},
		{
			unlockKey = "explorer",
			key = "explore",
			viewName = "city.develop.explorer.view",
			icon = "city/main/icon_txq.png",
			name = gLanguageCsv.explorer,
			styles = {
				full = true
			}
		},
		{
			key = "gem",
			unlockKey = "gem",
			viewName = "city.card.gem.view",
			icon = "city/card/gem/icon_fsxq1.png",
			name = gLanguageCsv.gemTitle
		},
		{
			key = "gymBadge",
			unlockKey = "badge",
			viewName = "city.develop.gym_badge.view",
			icon = "city/develop/gym_badge/icon_hz.png",
			name = gLanguageCsv.badgeTitle,
			styles = {
				full = true
			}
		},
		{
			key = "zawake",
			unlockKey = "zawake",
			viewName = "city.zawake.view",
			icon = "city/zawake/icon_zjx11.png",
			name = gLanguageCsv.zawake,
			styles = {
				full = true
			},
			func = function(arg_2_0)
				local var_2_0 = require("app.views.city.zawake.tools").getFightPointMaxCard()

				if var_2_0 then
					arg_2_0({
						zawakeID = var_2_0
					})
				else
					gGameUI:showTip(gLanguageCsv.noZawakeCard)
				end
			end
		},
		{
			key = "chip",
			unlockKey = "chip",
			viewName = "city.card.chip.bag",
			icon = "city/card/chip/icon_chip.png",
			name = gLanguageCsv.chip,
			styles = {
				full = true
			}
		},
		{
			key = "totem",
			unlockKey = "totem",
			viewName = "city.develop.totem.view",
			icon = "city/main/icon_zc_tt.png",
			name = gLanguageCsv.totem,
			styles = {
				full = true
			}
		},
		{
			key = "meteorite",
			unlockKey = "meteorite",
			viewName = "city.develop.strange_meteor.view",
			icon = "city/main/icon_zc_ys.png",
			name = gLanguageCsv.strange_meteor,
			styles = {
				full = true
			}
		}
	}
end

local var_0_1 = class("DevelopView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "develop.json"
var_0_1.RESOURCE_BINDING = {
	["ScrollView.btns.bgBG.imgBG"] = "imgBG",
	["ScrollView.btns.bgTF.imgTF"] = "imgTF",
	["ScrollView.btns.bgLH.imgLH"] = "imgLH",
	["ScrollView.btns.bgZH.imgZH"] = "imgZH",
	ScrollView = "ScrollView",
	["ScrollView.btns.bgBook.imgBook"] = "imgBook",
	["ScrollView.btns.bgSSSHY.imgSSSHY"] = "imgSSSHY",
	["ScrollView.btns.bgYJ.imgYJ"] = "imgYJ",
	["ScrollView.btns.bgMJ.imgMJ"] = "imgMJ",
	["ScrollView.btns.bgCH.imgCH"] = "imgCH",
	["ScrollView.btns"] = "btns",
	["ScrollView.btns.bgCH"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_3_0)
						return arg_3_0:onItemClick(nil, arg_3_0.devBtns[1])
					end)
				}
			}
		}
	},
	["ScrollView.btns.bgBook"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_4_0)
						return arg_4_0:onItemClick(nil, arg_4_0.devBtns[2])
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "cityTrainer",
					onNode = function(arg_5_0)
						arg_5_0:xy(152, 152)
					end
				}
			}
		}
	},
	["ScrollView.btns.bgTF"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_6_0)
						return arg_6_0:onItemClick(nil, arg_6_0.devBtns[3])
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "cityTalent",
					onNode = function(arg_7_0)
						arg_7_0:xy(152, 152)
					end
				}
			}
		}
	},
	["ScrollView.btns.bgBG"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_8_0)
						return arg_8_0:onItemClick(nil, arg_8_0.devBtns[6])
					end)
				}
			}
		}
	},
	["ScrollView.btns.bgYJ"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_9_0)
						return arg_9_0:onItemClick(nil, arg_9_0.devBtns[5])
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "mail",
					onNode = function(arg_10_0)
						arg_10_0:xy(120, 116)
					end
				}
			}
		}
	},
	["ScrollView.btns.bgLH"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_11_0)
						return arg_11_0:onItemClick(nil, arg_11_0.devBtns[4])
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = {
						"explorerTotal",
						"explorerFind"
					},
					onNode = function(arg_12_0)
						arg_12_0:xy(152, 152)
					end
				}
			}
		}
	},
	["ScrollView.btns.bgMJ"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_13_0)
						return arg_13_0:onItemClick(nil, arg_13_0.devBtns[8])
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "cityChipFreeExtract",
					onNode = function(arg_14_0)
						arg_14_0:xy(152, 152)
					end
				}
			}
		}
	},
	["ScrollView.btns.bgZH"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_15_0)
						return arg_15_0:onItemClick(nil, arg_15_0.devBtns[9])
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = {
						"totemGroup",
						"totemAwardAllGet",
						"totemFree"
					},
					onNode = function(arg_16_0)
						arg_16_0.xy(arg_16_0, 152, 152)
					end
				}
			}
		}
	},
	["ScrollView.btns.bgSSSHY"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.defer(function(arg_17_0)
						return arg_17_0:onItemClick(nil, arg_17_0.devBtns[10])
					end)
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "meteorite",
					onNode = function(arg_18_0)
						arg_18_0.xy(arg_18_0, 152, 152)
					end
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_19_0, arg_19_1)
	arg_19_0.ScrollView:setScrollBarEnabled(false)

	arg_19_0.devBtns = var_0_0()
	arg_19_0.devBtns[1].node = arg_19_0.imgCH
	arg_19_0.devBtns[2].node = arg_19_0.imgBook
	arg_19_0.devBtns[3].node = arg_19_0.imgTF
	arg_19_0.devBtns[4].node = arg_19_0.imgLH
	arg_19_0.devBtns[5].node = arg_19_0.imgYJ
	arg_19_0.devBtns[6].node = arg_19_0.imgBG
	arg_19_0.devBtns[8].node = arg_19_0.imgMJ
	arg_19_0.devBtns[9].node = arg_19_0.imgZH
	arg_19_0.devBtns[10].node = arg_19_0.imgSSSHY

	arg_19_0:initModel()
	gGameUI.topuiManager:createView("default", arg_19_0, {
		onClose = arg_19_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_yangcheng.png"
	})
end

function var_0_1.initModel(arg_20_0)
	for iter_20_0, iter_20_1 in pairs(arg_20_0.devBtns) do
		if arg_20_0.devBtns[iter_20_0].node then
			uiEasy.updateUnlockRes(iter_20_1.unlockKey, arg_20_0.devBtns[iter_20_0].node, {
				pos = cc.p(arg_20_0.imgBook:width() - 120, 100)
			})
		end
	end
end

function var_0_1.onItemClick(arg_21_0, arg_21_1, arg_21_2)
	if not dataEasy.isUnlock(arg_21_2.unlockKey) then
		gGameUI:showTip(dataEasy.getUnlockTip(arg_21_2.unlockKey))

		return
	end

	gGameUI:stackUI(arg_21_2.viewName, nil, arg_21_2.styles, arg_21_2)
end

return var_0_1
