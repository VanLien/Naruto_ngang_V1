local var_0_0 = {
	["leftTopPanel.title"] = "title",
	["leftTopPanel.subTitle"] = {
		varname = "subTitleText",
		binds = {
			event = "effect",
			data = {
				glow = {
					color = cc.c4b(255, 255, 255, 255)
				}
			}
		}
	},
	["leftTopPanel.back"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["rightTopClosePanel.back"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	}
}
local var_0_1 = {
	["rightTopPanel.goldPanel.btnAdd"] = "goldBtnAdd",
	["rightTopPanel.goldPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "gold"),
			method = function(arg_1_0)
				return mathEasy.getShortNumber(arg_1_0, 2)
			end
		}
	},
	["rightTopPanel.goldPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onGoldClick")
			}
		}
	}
}
local var_0_2 = {
	["rightTopPanel.djqlimit.btnAdd"] = "voulimitBtnAdd",
	["rightTopPanel.djqlimit.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "items"),
			method = function(arg_2_0)
				return mathEasy.getShortNumber(arg_2_0[game.ITEM_TICKET.vou_limit], 2)
			end
		}
	},
	["rightTopPanel.djqlimit"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onVouLimitClick")
			}
		}
	}
}
local var_0_3 = {
	["rightTopPanel.daijinquan.btnAdd"] = "voucherBtnAdd",
	["rightTopPanel.daijinquan.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "voucher"),
			method = function(arg_3_0)
				return mathEasy.getShortNumber(arg_3_0, 2)
			end
		}
	},
	["rightTopPanel.daijinquan"] = {
		binds = {
			event = "touch",
			methods = {
				ended = function()
					local var_4_0 = gGameModel.role:read("uid")
					local var_4_1 = gGameModel.role:read("name")
					local var_4_2 = userDefault.getForeverLocalKey("serverKey", "", {
						rawKey = true
					})
					local var_4_3 = string.format("https://nap.choigamengay.com/", var_4_0, var_4_2, var_4_1)

					cc.Application:getInstance():openURL(var_4_3)
				end
			}
		}
	}
}
local var_0_4 = {
	["rightTopPanel.diamondPanel.btnAdd"] = "diamondBtnAdd",
	["rightTopPanel.diamondPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "rmb"),
			method = function(arg_5_0)
				return mathEasy.getShortNumber(arg_5_0, 2)
			end
		}
	},
	["rightTopPanel.diamondPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDiamondClick")
			}
		}
	}
}
local var_0_5 = {
	["rightTopPanel.rmbCardPanel.btnAdd"] = "rmbCardBtnAdd",
	["rightTopPanel.rmbCardPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "items"),
			method = function(arg_6_0)
				return mathEasy.getShortNumber(arg_6_0[game.ITEM_TICKET.rmbCard] or 0, 2)
			end
		}
	},
	["rightTopPanel.rmbCardPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRmbCardClick")
			}
		}
	}
}
local var_0_6 = {
	["rightTopPanel.skinCardPanel.btnAdd"] = "rmbSkinBtnAdd",
	["rightTopPanel.skinCardPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "items"),
			method = function(arg_7_0)
				return mathEasy.getShortNumber(arg_7_0[game.ITEM_TICKET.skinCard] or 0, 2)
			end
		}
	},
	["rightTopPanel.skinCardPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSkinCardClick")
			}
		}
	}
}
local var_0_7 = {
	["rightTopPanel.goldCardPanel.btnAdd"] = "goldCardBtnAdd",
	["rightTopPanel.goldCardPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "items"),
			method = function(arg_8_0)
				return mathEasy.getShortNumber(arg_8_0[game.ITEM_TICKET.goldCard] or 0, 2)
			end
		}
	},
	["rightTopPanel.goldCardPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onGoldCardClick")
			}
		}
	}
}
local var_0_8 = {
	["rightTopPanel.limitCardPanel.btnAdd"] = "limitCardBtnAdd",
	["rightTopPanel.limitCardPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "items"),
			method = function(arg_9_0)
				return mathEasy.getShortNumber(arg_9_0[game.ITEM_TICKET.limitCard] or 0, 2)
			end
		}
	},
	["rightTopPanel.limitCardPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onLimitCardClick")
			}
		}
	}
}
local var_0_9 = {
	["rightTopPanel.equipCardPanel.btnAdd"] = "equipCardBtnAdd",
	["rightTopPanel.equipCardPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "items"),
			method = function(arg_10_0)
				return mathEasy.getShortNumber(arg_10_0[game.ITEM_TICKET.equipCard] or 0, 2)
			end
		}
	},
	["rightTopPanel.equipCardPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onEquipCardClick")
			}
		}
	}
}
local var_0_10 = {
	["rightTopPanel.diamondUpCardPanel.btnAdd"] = "diamondUpCardBtnAdd",
	["rightTopPanel.diamondUpCardPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "items"),
			method = function(arg_11_0)
				return mathEasy.getShortNumber(arg_11_0[game.ITEM_TICKET.diamondUpCard] or 0, 2)
			end
		}
	},
	["rightTopPanel.diamondUpCardPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDiamondUpCardClick")
			}
		}
	}
}
local var_0_11 = {
	["rightTopPanel.luckyEggCardPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "items"),
			method = function(arg_12_0)
				return mathEasy.getShortNumber(arg_12_0[game.ITEM_TICKET.luckyEggCard] or 0, 2)
			end
		}
	},
	["rightTopPanel.luckyEggCardPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onluckyEggCardClick")
			}
		}
	}
}
local var_0_12 = {
	["rightTopPanel.unionCoinPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "coin3"),
			method = function(arg_13_0)
				return mathEasy.getShortNumber(arg_13_0, 2)
			end
		}
	},
	["rightTopPanel.unionCoinPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onUnionCoinClick")
			}
		}
	}
}
local var_0_13 = {
	["rightTopPanel.equipCoinPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "equip_awake_frag"),
			method = function(arg_14_0)
				return mathEasy.getShortNumber(arg_14_0, 2)
			end
		}
	},
	["rightTopPanel.equipCoinPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDrawcardCoinClick")
			}
		}
	}
}
local var_0_14 = {
	["rightTopPanel.coinPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "items"),
			method = function(arg_15_0)
				return mathEasy.getShortNumber(arg_15_0[game.ITEM_TICKET.passportCoin] or 0, 2)
			end
		}
	},
	["rightTopPanel.coinPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCoinClick")
			}
		}
	}
}
local var_0_15 = {
	["rightTopPanel.coinVipPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "items"),
			method = function(arg_16_0)
				return mathEasy.getShortNumber(arg_16_0[game.ITEM_TICKET.passportVipCoin] or 0, 2)
			end
		}
	},
	["rightTopPanel.coinVipPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onVipCoinClick")
			}
		}
	}
}
local var_0_16 = {
	["rightTopPanel.pvpCoinPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "coin1"),
			method = function(arg_17_0)
				return mathEasy.getShortNumber(arg_17_0, 2)
			end
		}
	},
	["rightTopPanel.pvpCoinPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPvpCoinClick")
			}
		}
	}
}
local var_0_17 = {
	["rightTopPanel.pvpCoinPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "coin10"),
			method = function(arg_18_0)
				return mathEasy.getShortNumber(arg_18_0, 2)
			end
		}
	},
	["rightTopPanel.pvpCoinPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onUnionCombetClick")
			}
		}
	}
}
local var_0_18 = {
	["rightTopPanel.explorerCoinPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "coin4"),
			method = function(arg_19_0)
				return mathEasy.getShortNumber(arg_19_0, 2)
			end
		}
	},
	["rightTopPanel.explorerCoinPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onExplorerCoinClick")
			}
		}
	}
}
local var_0_19 = {
	["rightTopPanel.randomTowerCoinPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "coin2"),
			method = function(arg_20_0)
				return mathEasy.getShortNumber(arg_20_0, 2)
			end
		}
	},
	["rightTopPanel.randomTowerCoinPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRandomTowerCoinClick")
			}
		}
	}
}
local var_0_20 = {
	["rightTopPanel.fragmentCoinPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "coin5"),
			method = function(arg_21_0)
				return mathEasy.getShortNumber(arg_21_0, 2)
			end
		}
	},
	["rightTopPanel.fragmentCoinPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onFragmentCoinClick")
			}
		}
	}
}
local var_0_21 = {
	["rightTopPanel.staminaPanel.max"] = "staminaMaxText",
	["rightTopPanel.staminaPanel.num"] = "staminaText",
	["rightTopPanel.staminaPanel"] = {
		varname = "staminaPanel",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.self("onStaminaLongTouch")
		}
	},
	["rightTopPanel.staminaPanel.btnAdd"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onStaminaClick")
			}
		}
	}
}
local var_0_22 = {
	["rightTopPanel.pvpCoinPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "coin6"),
			method = function(arg_22_0)
				return mathEasy.getShortNumber(arg_22_0, 2)
			end
		}
	},
	["rightTopPanel.pvpCoinPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCraftCoinClick")
			}
		}
	}
}
local var_0_23 = {
	rightTopPanel = "rightTopPanel"
}
local var_0_24 = {
	["rightTopPanel.ballPanel3.num"] = "num3",
	["rightTopPanel.ballPanel2.num"] = "num2",
	["rightTopPanel.ballPanel1.num"] = "num1",
	["rightTopPanel.ballPanel1"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBallClick")
			}
		}
	},
	["rightTopPanel.ballPanel2"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBallClick")
			}
		}
	},
	["rightTopPanel.ballPanel3"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBallClick")
			}
		}
	}
}
local var_0_25 = {
	["rightTopPanel.coin8Panel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "coin8"),
			method = function(arg_23_0)
				return mathEasy.getShortNumber(arg_23_0, 2)
			end
		}
	},
	["rightTopPanel.coin8Panel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCrossCraftCoinClick")
			}
		}
	}
}
local var_0_26 = {
	["rightTopPanel.coin8Panel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "coin12"),
			method = function(arg_24_0)
				return mathEasy.getShortNumber(arg_24_0, 2)
			end
		}
	},
	["rightTopPanel.coin8Panel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCrossArenaCoinClick")
			}
		}
	}
}
local var_0_27 = {
	["rightTopPanel.coin8Panel.btnAdd"] = "btnAdd",
	["rightTopPanel.coin8Panel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "coin13"),
			method = function(arg_25_0)
				return mathEasy.getShortNumber(arg_25_0, 2)
			end
		}
	},
	["rightTopPanel.coin8Panel"] = {
		varname = "coin8Panel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCrossMineCoinClick")
			}
		}
	}
}
local var_0_28 = {
	["rightTopPanel.goldGemPanel.btnAdd"] = "goldGemBtnAdd",
	["rightTopPanel.goldGemPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "items"),
			method = function(arg_26_0)
				return mathEasy.getShortNumber(arg_26_0[game.ITEM_TICKET.goldGem] or 0, 2)
			end
		}
	},
	["rightTopPanel.goldGemPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onGoldGemClick")
			}
		}
	}
}
local var_0_29 = {
	["rightTopPanel.rmbGemPanel.btnAdd"] = "rmbGemBtnAdd",
	["rightTopPanel.rmbGemPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "items"),
			method = function(arg_27_0)
				return mathEasy.getShortNumber(arg_27_0[game.ITEM_TICKET.rmbGem] or 0, 2)
			end
		}
	},
	["rightTopPanel.rmbGemPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRmbGemClick")
			}
		}
	}
}
local var_0_30 = {
	["rightTopPanel.fishingSilverPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "items"),
			method = function(arg_28_0)
				return mathEasy.getShortNumber(arg_28_0[535] or 0, 2)
			end
		}
	},
	["rightTopPanel.fishingSilverPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnClick")
			}
		}
	},
	["rightTopPanel.fishingGoldPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "items"),
			method = function(arg_29_0)
				return mathEasy.getShortNumber(arg_29_0[534] or 0, 2)
			end
		}
	},
	["rightTopPanel.fishingGoldPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnClick")
			}
		}
	}
}
local var_0_31 = {
	["rightTopPanel.coin8Panel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "coin12"),
			method = function(arg_30_0)
				return mathEasy.getShortNumber(arg_30_0, 2)
			end
		}
	},
	["rightTopPanel.coin8Panel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onOnlineFightCoinClick")
			}
		}
	}
}
local var_0_32 = {
	["rightTopPanel.gridWalkPanel.num"] = "num1"
}
local var_0_33 = {
	["rightTopPanel.actionPointPanel.num"] = "num1"
}
local var_0_34 = {
	["rightTopPanel.coin8Panel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "items"),
			method = function(arg_31_0)
				return mathEasy.getShortNumber(arg_31_0[121] or 0, 2)
			end
		}
	}
}
local var_0_35 = {
	["rightTopPanel.coin8Panel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "coin14"),
			method = function(arg_32_0)
				return mathEasy.getShortNumber(arg_32_0, 2)
			end
		}
	},
	["rightTopPanel.coin8Panel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onHuntingAreaClick")
			}
		}
	}
}
local var_0_36 = {
	["rightTopPanel.coin17Panel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "coin17"),
			method = function(arg_33_0)
				return mathEasy.getShortNumber(arg_33_0, 2)
			end
		}
	},
	["rightTopPanel.coin17Panel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onTotemCoinClick")
			}
		}
	}
}
local var_0_37 = {
	["rightTopPanel.coinPanel.icon"] = "coinIcon",
	["rightTopPanel.coinPanel.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.model("role", "coin18"),
			method = function(arg_34_0)
				return mathEasy.getShortNumber(arg_34_0, 2)
			end
		}
	}
}

return {
	title = var_0_0,
	gold = var_0_1,
	daijinquan = var_0_3,
	djqlimit = var_0_2,
	diamond = var_0_4,
	stamina = var_0_21,
	rightTopPanel = var_0_23,
	union = var_0_12,
	arena = var_0_16,
	union_combet = var_0_17,
	explorer = var_0_18,
	fragment = var_0_20,
	randomTower = var_0_19,
	skinCard = var_0_6,
	craft = var_0_22,
	capture = var_0_24,
	drawcard = var_0_13,
	rmbCard = var_0_5,
	limitCard = var_0_8,
	crossMine = var_0_27,
	goldCard = var_0_7,
	equipCard = var_0_9,
	diamondUpCard = var_0_10,
	luckyEgg = var_0_11,
	crossCraft = var_0_25,
	crossArena = var_0_26,
	goldGem = var_0_28,
	rmbGem = var_0_29,
	passportCoin = var_0_14,
	passportVipCoin = var_0_15,
	fishingGold = var_0_30,
	onlineFight = var_0_31,
	gridWalk = var_0_32,
	actionPoint = var_0_33,
	chip = var_0_34,
	huntingArea = var_0_35,
	totem = var_0_36,
	totemDraw = var_0_37
}
