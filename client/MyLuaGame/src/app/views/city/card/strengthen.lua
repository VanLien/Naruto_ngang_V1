local var_0_0 = require("app.views.city.zawake.tools")
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("CardStrengthenView", var_0_1)
local var_0_3 = {
	STRENGTHEN = 1,
	DECORATION = 2
}
local var_0_4 = {
	"advance",
	"effortValue",
	"equipStar",
	"equipStrengthen",
	"equipAwake",
	"equipSignet",
	"star",
	"skill",
	"nvalue",
	"cardFeel",
	"cardDevelop",
	"gemFreeExtract",
	"canZawake"
}
local var_0_5 = {
	"star"
}
local var_0_6 = {
	{
		{
			key = "attribute",
			icon2 = "city/card/system/icon_sx_2.png",
			viewName = "city.card.attribute",
			icon = "city/card/system/icon_sx.png",
			name = gLanguageCsv.attribute
		},
		{
			key = "nvalue",
			unlockKey = "cardNValueRecast",
			viewName = "city.card.nvalue",
			icon = "city/card/system/icon_xl.png",
			icon2 = "city/card/system/icon_xl_2.png",
			name = gLanguageCsv.nvalue,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "nvalue",
					listenData = {
						selectDbId = bindHelper.parent("selectDbId")
					},
					onNode = function(arg_1_0)
						arg_1_0:xy(266, 120):z(10)
					end
				}
			}
		},
		{
			key = "advance",
			icon2 = "city/card/system/icon_tp_2.png",
			viewName = "city.card.advance",
			icon = "city/card/system/icon_tp.png",
			name = gLanguageCsv.advance,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "advance",
					listenData = {
						selectDbId = bindHelper.parent("selectDbId")
					},
					onNode = function(arg_2_0)
						arg_2_0:xy(266, 120):z(10)
					end
				}
			}
		},
		{
			key = "star",
			icon2 = "city/card/system/icon_xj_2.png",
			viewName = "city.card.star",
			icon = "city/card/system/icon_xj.png",
			name = gLanguageCsv.star,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "star",
					listenData = {
						selectDbId = bindHelper.parent("selectDbId")
					},
					onNode = function(arg_3_0)
						arg_3_0:xy(266, 120):z(10)
					end
				}
			}
		},
		{
			key = "skill",
			icon2 = "city/card/system/icon_jn_2.png",
			viewName = "city.card.skill",
			icon = "city/card/system/icon_jn.png",
			name = gLanguageCsv.skill,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "skill",
					listenData = {
						selectDbId = bindHelper.parent("selectDbId")
					},
					onNode = function(arg_4_0)
						arg_4_0:xy(266, 120):z(10)
					end
				}
			}
		},
		{
			unlockKey = "cardEffort",
			key = "effortvalue",
			viewName = "city.card.effortvalue",
			icon = "city/card/system/icon_py.png",
			icon2 = "city/card/system/icon_py_2.png",
			name = gLanguageCsv.effortvalue,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "effortValue",
					listenData = {
						selectDbId = bindHelper.parent("selectDbId")
					},
					onNode = function(arg_5_0)
						arg_5_0:xy(266, 120):z(10)
					end
				}
			}
		},
		{
			unlockKey = "cardAbility",
			key = "ability",
			icon2 = "city/card/system/icon_qn_2.png",
			viewName = "city.card.ability.view",
			icon = "city/card/system/icon_qn.png",
			name = gLanguageCsv.ability
		},
		{
			unlockKey = "chip",
			key = "chip",
			viewName = "city.card.chip",
			icon = "city/card/system/icon_mj.png",
			icon2 = "city/card/system/icon_mj_2.png",
			name = gLanguageCsv.chip,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "cityChipFreeExtract",
					onNode = function(arg_6_0)
						arg_6_0:xy(266, 120):z(10)
					end
				}
			}
		}
	},
	{
		{
			viewName = "city.card.equip.strengthen",
			key = "equipStrengthen",
			name = gLanguageCsv.equipStrengthen,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "equipStrengthen",
					listenData = {
						selectDbId = bindHelper.parent("selectDbId")
					},
					onNode = function(arg_7_0)
						arg_7_0:xy(270, 118):z(10)
					end
				}
			}
		},
		{
			unlockKey = "equipStarAdd",
			key = "starUp",
			viewName = "city.card.equip.star",
			name = gLanguageCsv.starUp,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "equipStar",
					listenData = {
						selectDbId = bindHelper.parent("selectDbId")
					},
					onNode = function(arg_8_0)
						arg_8_0:xy(270, 118):z(10)
					end
				}
			}
		},
		{
			unlockKey = "equipAwak",
			key = "awake",
			viewName = "city.card.equip.awake",
			name = gLanguageCsv.awake,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "equipAwake",
					listenData = {
						selectDbId = bindHelper.parent("selectDbId")
					},
					onNode = function(arg_9_0)
						arg_9_0:xy(270, 118):z(10)
					end
				}
			}
		},
		{
			unlockKey = "equipSignet",
			key = "signet",
			viewName = "city.card.equip.signet",
			name = gLanguageCsv.signet,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "equipSignet",
					listenData = {
						selectDbId = bindHelper.parent("selectDbId")
					},
					onNode = function(arg_10_0)
						arg_10_0:xy(270, 118):z(10)
					end
				}
			}
		}
	}
}
local var_0_7 = {}

for iter_0_0, iter_0_1 in pairs(var_0_3) do
	for iter_0_2, iter_0_3 in pairs(var_0_6[iter_0_1]) do
		var_0_7[iter_0_3.key] = iter_0_1
	end
end

local var_0_8 = {
	{
		attr = "fight",
		name = gLanguageCsv.fighting
	},
	{
		attr = "level",
		name = gLanguageCsv.level
	},
	{
		attr = "rarity",
		name = gLanguageCsv.rarity
	},
	{
		attr = "star",
		name = gLanguageCsv.star
	},
	{
		attr = "getTime",
		name = gLanguageCsv.getTime
	}
}
local var_0_9 = {
	"standby_loop",
	"attack",
	"win_loop",
	"run_loop",
	"skill1"
}
local var_0_10 = {
	{
		key = "feel",
		unlockKey = "cardLike",
		icon = "city/card/system/icon_liking.png",
		click = "onSkinClick",
		txt = gLanguageCsv.like
	},
	{
		key = "reborn",
		unlockKey = "cardReborn",
		icon = "city/card/system/icon_renascence.png",
		click = "onRebornClick",
		txt = gLanguageCsv.reborn
	}
}
local var_0_11 = {
	nil,
	40,
	40,
	30,
	10
}

var_0_2.RESOURCE_FILENAME = "card_strengthen.json"
var_0_2.RESOURCE_BINDING = {
	["left.btnItem"] = "leftBtnItem",
	bg_neirong = "bgnr",
	["left.imgFlag"] = "imgFlag",
	["left.btnHeldItem1"] = "btnHeldItemBg",
	item = "item",
	btnItem = "btnItem",
	right = "panelRight",
	["left.fight.textFightPoint"] = "textFightPoint",
	left = "left",
	starItem = "starItem",
	attrItem = "attrItem",
	["btnItem.btnClick.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["right.list"] = {
		varname = "msgList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 9,
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("btnItem"),
				curState = bindHelper.self("curState"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
					arg_11_1:name(arg_11_3.key)

					local var_11_0 = arg_11_1:get("btnClick")
					local var_11_1 = arg_11_1:get("btnNormal")

					var_11_0:visible(arg_11_3.select or false)
					var_11_0:loadTextureNormal(arg_11_3.icon2)
					var_11_1:visible(not arg_11_3.select)
					var_11_1:loadTextureNormal(arg_11_3.icon)

					if arg_11_3.redHint then
						arg_11_0.state = arg_11_3.select ~= true

						bind.extend(arg_11_0, var_11_1, arg_11_3.redHint)
					end

					uiEasy.updateUnlockRes(arg_11_3.unlockKey, arg_11_1, {
						justRemove = not arg_11_3.unlockKey,
						pos = cc.p(196, 110)
					}):anonyOnly(arg_11_0, arg_11_0:getIdx(arg_11_2))
					bind.touch(arg_11_0, var_11_1, {
						methods = {
							ended = functools.partial(arg_11_0.clickCell, arg_11_2, arg_11_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabItemClick")
			}
		}
	},
	["left.btnList"] = {
		varname = "btnList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				padding = 1,
				data = bindHelper.self("leftBtnDatas"),
				item = bindHelper.self("leftBtnItem"),
				margin = bindHelper.self("leftBtnMargin"),
				onItem = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
					arg_12_1:name(arg_12_3.key)
					arg_12_1:loadTextureNormal(arg_12_3.icon)
					uiEasy.updateUnlockRes(arg_12_3.unlockKey, arg_12_1, {
						scale = 0.5,
						justRemove = not arg_12_3.unlockKey,
						pos = cc.p(65, 75)
					}):anonyOnly(arg_12_0, arg_12_0:getIdx(arg_12_2))

					if arg_12_3.key == "develop" then
						bind.extend(arg_12_0, arg_12_1, {
							class = "red_hint",
							props = {
								specialTag = "cardDevelop",
								state = true,
								listenData = {
									selectDbId = bindHelper.parent("selectDbId")
								},
								onNode = function(arg_13_0)
									arg_13_0:xy(80, 75)
									arg_13_0:scale(0.5)
								end
							}
						})
					end

					if arg_12_3.key == "feel" then
						bind.extend(arg_12_0, arg_12_1, {
							class = "red_hint",
							props = {
								specialTag = "cardFeel",
								state = true,
								listenData = {
									selectDbId = bindHelper.parent("selectDbId")
								},
								onNode = function(arg_14_0)
									arg_14_0:xy(80, 75)
									arg_14_0:scale(0.5)
								end
							}
						})
					end

					bind.touch(arg_12_0, arg_12_1, {
						methods = {
							ended = functools.partial(arg_12_0.clickCell, arg_12_3)
						}
					})
				end,
				onAfterBuild = function(arg_15_0)
					arg_15_0:setItemAlignCenter()
				end
			},
			handlers = {
				clickCell = bindHelper.self("onLeftBtnItemClick")
			}
		}
	},
	["cardPanel.list"] = {
		varname = "cardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				addLimit = true,
				padding = 6,
				data = bindHelper.self("cardDatas"),
				item = bindHelper.self("item"),
				dataOrderCmpGen = bindHelper.self("onSortCardList", true),
				onItem = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
					arg_16_1:setName("item" .. arg_16_0:getIdx(arg_16_2))

					local var_16_0 = arg_16_1:size()

					bind.extend(arg_16_0, arg_16_1, {
						class = "card_icon",
						props = {
							unitId = arg_16_3.unitId,
							advance = arg_16_3.advance,
							star = arg_16_3.star,
							rarity = arg_16_3.rarity,
							lock = arg_16_3.lock,
							selected = arg_16_3.isSel,
							levelProps = {
								data = arg_16_3.level
							},
							params = {
								starScale = 0.33,
								starInterval = 15
							},
							onNode = function(arg_17_0)
								arg_17_0:xy(65, 0):scale(1.12)
								arg_17_0:get("frame"):scale(1.07)
								arg_17_0:get("rarity"):align(cc.p(0.5, 0.5)):xy(38, 162):scale(0.7)
								arg_17_0:get("imgSel"):scale(1.03)

								local var_17_0 = arg_17_0:size()
								local var_17_1 = arg_17_0:get("lock")

								var_17_1:texture("common/btn/icon_s1.png")
								var_17_1:x(var_17_1:x() - var_17_0.width - 10)
								var_17_1:y(var_17_1:y() - 30)
								var_17_1:scale(0.8928571428571428)
							end
						}
					})
					bind.extend(arg_16_0, arg_16_1:get("redHint"), {
						class = "red_hint",
						props = {
							specialTag = arg_16_3.battle == 1 and var_0_4 or var_0_5,
							listenData = {
								selectDbId = arg_16_3.dbid
							}
						}
					})

					local var_16_1

					var_16_1 = arg_16_1:get("battle") and 1 or 2

					arg_16_1:get("imgFlag"):visible(arg_16_3.battle == 1)
					bind.touch(arg_16_0, arg_16_1, {
						methods = {
							ended = function()
								return arg_16_0.clickCell(arg_16_2, arg_16_3)
							end
						}
					})
				end,
				preloadCenter = bindHelper.self("selectDbId")
			},
			handlers = {
				clickCell = bindHelper.self("onCardItemClick")
			}
		}
	},
	["left.attrList"] = {
		varname = "attrList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("attrItem"),
				onItem = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
					arg_19_1:get("imgIcon"):texture(ui.ATTR_ICON[arg_19_3])
				end
			}
		}
	},
	cardPanel = {
		varname = "cardPanel",
		binds = {
			event = "extend",
			class = "sort_menus",
			props = {
				width = 309,
				expandUp = true,
				data = bindHelper.self("sortDatas"),
				btnClick = bindHelper.self("onSortMenusBtnClick", true),
				onNode = function(arg_20_0)
					arg_20_0:xy(-1103, -475):z(18)
				end
			}
		}
	},
	["left.textName"] = {
		varname = "cardNameTxt",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["left.btnLock"] = {
		varname = "btnLock",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onLockClick")
			}
		}
	},
	["left.starList"] = {
		varname = "starList",
		binds = {
			event = "extend",
			margin = 20,
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("starDatas"),
				item = bindHelper.self("starItem"),
				onItem = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
					arg_21_1:get("imgStar"):texture(arg_21_3.icon):scale(0.75)
				end
			}
		}
	},
	["left.heroNode"] = {
		varname = "heroNode"
	},
	["left.btnHeldItem"] = {
		varname = "btnHeldItem",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onAddClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					listenData = {
						selectDbId = bindHelper.self("selectDbId")
					},
					specialTag = {
						"heldItem",
						"heldItemLevelUp",
						"heldItemAdvanceUp"
					},
					onNode = function(arg_22_0)
						arg_22_0:xy(144, 140)
					end
				}
			}
		}
	},
	["left.btnHeldItem.imgBG"] = {
		varname = "heldItemImgBg",
		binds = {
			event = "texture",
			idler = bindHelper.self("heldItemBg")
		}
	},
	["left.btnHeldItem.imgIcon"] = {
		varname = "heleItemIcon",
		binds = {
			event = "texture",
			idler = bindHelper.self("heldItemIcon")
		}
	},
	["left.btnEquip.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["left.zawake"] = {
		varname = "btnZawake",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onZawakeClick")
			}
		}
	},
	["left.gem"] = {
		varname = "btnGem",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onGemClick")
			}
		}
	},
	["left.manuals.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["left.manuals"] = {
		varname = "manuals",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onManualsClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "battleManuals",
					onNode = function(arg_23_0)
						arg_23_0:xy(85, 85)
						arg_23_0:scale(0.5)
					end
				}
			}
		}
	},
	["left.gem.btn"] = {
		binds = {
			event = "extend",
			class = "red_hint",
			props = {
				specialTag = "gemFreeExtract",
				listenData = {
					selectDbId = bindHelper.self("selectDbId")
				},
				onNode = function(arg_24_0)
					arg_24_0:xy(85, 85)
					arg_24_0:scale(0.5)
				end
			}
		}
	},
	["left.zawake.btn"] = {
		binds = {
			event = "extend",
			class = "red_hint",
			props = {
				specialTag = "canZawake",
				listenData = {
					selectDbId = bindHelper.self("selectDbId")
				},
				onNode = function(arg_25_0)
					arg_25_0:xy(145, 132)
					arg_25_0:scale(0.8)
				end
			}
		}
	},
	["left.gem.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["left.zawake.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["left.btnEquip"] = {
		varname = "btnEquip",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onEquipClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					state = true,
					listenData = {
						selectDbId = bindHelper.self("selectDbId")
					},
					specialTag = {
						"equipStar",
						"equipStrengthen",
						"equipAwake",
						"equipSignet"
					},
					onNode = function(arg_26_0)
						arg_26_0:xy(190, 200)
					end
				}
			}
		}
	}
}
var_0_2.RESOURCE_STYLES = {
	full = true
}

function var_0_2.onCreate(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	arg_27_0.closeHandler = arg_27_3

	arg_27_0:initModel()

	arg_27_0.heldItemListen = dataEasy.getListenShow(gUnlockCsv.heldItem)
	arg_27_2 = arg_27_2 or arg_27_0:getSelectedCardDBID()
	arg_27_0.dressState = idler.new(false)
	arg_27_0.selectDbId = idler.new(arg_27_0._selectDbId or arg_27_2)
	arg_27_0.cardActionState = idler.new(1)

	local var_27_0 = var_0_7[arg_27_1] or var_0_3.STRENGTHEN

	arg_27_0.curState = idler.new(arg_27_0._curState or var_27_0)
	arg_27_0.leftBtnMargin = idler.new(0)
	arg_27_0.leftBtnDatas = idlertable.new({})
	arg_27_0.tabDatas = idlers.new()

	arg_27_0:initTabDatasListeners()
	arg_27_0:updateTabDatas()
	arg_27_0.btnGem:get("textNote"):text(gLanguageCsv.gemTitle)
	uiEasy.updateUnlockRes(gUnlockCsv.cardUnlock, arg_27_0.btnLock, {
		pos = cc.p(90, 90)
	})
	uiEasy.updateUnlockRes(gUnlockCsv.equip, arg_27_0.btnEquip, {
		pos = cc.p(140, 170)
	})
	uiEasy.updateUnlockRes(gUnlockCsv.heldItem, arg_27_0.btnHeldItem, {
		pos = cc.p(120, 110)
	})
	uiEasy.updateUnlockRes(gUnlockCsv.gem, arg_27_0.btnGem, {
		pos = cc.p(140, 170)
	})
	uiEasy.updateUnlockRes(gUnlockCsv.zawake, arg_27_0.btnZawake, {
		pos = cc.p(155, 165)
	})
	dataEasy.getListenShow(gUnlockCsv.cardUnlock, function(arg_28_0)
		arg_27_0.btnLock:visible(arg_28_0)
	end)
	idlereasy.any({
		dataEasy.getListenShow(gUnlockCsv.gem),
		arg_27_0.curState
	}, function(arg_29_0, arg_29_1, arg_29_2)
		arg_27_0.btnGem:visible(arg_29_1 and arg_29_2 ~= var_0_3.DECORATION)
	end)

	arg_27_0.heldItemBg = idler.new("common/btn/btn_d.png")
	arg_27_0.heldItemIcon = idler.new("city/card/helditem/icon_jiahao.png")

	local var_27_1 = 0

	idlereasy.any({
		arg_27_0.heldItemListen,
		arg_27_0.curState,
		gGameModel.role:getIdler("items")
	}, function(arg_30_0, arg_30_1, arg_30_2)
		var_27_1 = var_27_1 + 1

		performWithDelay(arg_27_0, function()
			if var_27_1 > 0 then
				var_27_1 = 0

				if arg_30_1 and arg_30_2 ~= var_0_3.DECORATION then
					arg_27_0.btnHeldItem:visible(true)
					arg_27_0.btnHeldItemBg:visible(false)

					local var_31_0 = arg_27_0.selectDbId:read()
					local var_31_1 = gGameModel.cards:find(var_31_0):read("held_item")

					arg_27_0:onResetHeldItemIcon(var_31_1)
				else
					arg_27_0.btnHeldItem:visible(false)
					arg_27_0.btnHeldItemBg:visible(false)
				end
			end
		end, 0)
	end)
	arg_27_0.manuals:visible(dataEasy.isShow(gUnlockCsv.battleManuals))

	if arg_27_1 and not tonumber(arg_27_1) then
		local var_27_2 = arg_27_1

		arg_27_1 = nil

		for iter_27_0, iter_27_1 in arg_27_0.tabDatas:ipairs() do
			if iter_27_1:proxy().key == var_27_2 then
				arg_27_1 = iter_27_0

				break
			end
		end
	end

	arg_27_1 = tonumber(arg_27_1) or 1
	arg_27_0.selectTabKey = idler.new(arg_27_0._selectTabKey or arg_27_1)
	arg_27_0.selectTabPair = idlertable.new({
		state = arg_27_0.curState:read(),
		idx = arg_27_0.selectTabKey:read()
	})
	arg_27_0.rightTabView = {
		[var_0_3.STRENGTHEN] = {},
		[var_0_3.DECORATION] = {}
	}
	arg_27_0.rightCurrIdx = arg_27_0._rightCurrIdx or {
		[var_0_3.STRENGTHEN] = arg_27_0.selectTabKey:read(),
		[var_0_3.DECORATION] = 1
	}
	arg_27_0.equipIndex = idler.new(1)

	arg_27_0.curState:addListener(handler(arg_27_0, "onCurStateChanged"))
	arg_27_0.selectTabPair:addListener(handler(arg_27_0, "onSelectPairChanged"))

	arg_27_0.cardDatas = idlers.new()
	arg_27_0.tabOrder = idler.new(true)
	arg_27_0.seletSortKey = idler.new(1)
	arg_27_0.sortDatas = idlertable.new(itertools.map(var_0_8, function(arg_32_0, arg_32_1)
		return arg_32_1.name
	end))
	arg_27_0.cardsChanged = idler.new(true)

	idlereasy.any({
		arg_27_0.battleCards,
		arg_27_0.cards,
		arg_27_0.cardsChanged
	}, function(arg_33_0, arg_33_1, arg_33_2)
		local var_33_0 = arg_27_0.selectDbId:read()

		if not var_33_0 or not itertools.include(arg_33_2, var_33_0) then
			var_33_0 = arg_27_0:getSelectedCardDBID()

			arg_27_0.selectDbId:set(var_33_0)
		end

		local var_33_1 = itertools.map(itertools.ivalues(arg_33_1), function(arg_34_0, arg_34_1)
			return arg_34_1, arg_34_0
		end)
		local var_33_2
		local var_33_3 = {}

		for iter_33_0, iter_33_1 in ipairs(arg_33_2) do
			local var_33_4 = gGameModel.cards:find(iter_33_1)

			if var_33_4 then
				local var_33_5 = var_33_4:read("card_id", "unit_id", "skin_id", "fighting_point", "level", "star", "advance", "locked", "name", "created_time", "equips", "effort_values")
				local var_33_6 = var_33_1[iter_33_1] and 1 or 2
				local var_33_7 = csv.cards[var_33_5.card_id]
				local var_33_8 = dataEasy.getUnitId(var_33_5.card_id, var_33_5.skin_id)
				local var_33_9 = csv.unit[var_33_8]

				var_33_3[iter_33_1] = {
					num = 1,
					id = var_33_5.card_id,
					markId = var_33_7.cardMarkID,
					name = var_33_5.name,
					unitId = var_33_8,
					rarity = var_33_9.rarity,
					fight = var_33_5.fighting_point,
					level = var_33_5.level,
					star = var_33_5.star,
					getTime = var_33_5.created_time,
					dbid = iter_33_1,
					advance = var_33_5.advance,
					lock = var_33_5.locked or false,
					battle = var_33_6,
					isSel = var_33_0 == iter_33_1,
					equips = var_33_5.equips,
					effortValue = var_33_5.effort_values
				}
			end
		end

		arg_27_0.cardDatas:update(var_33_3, function(arg_35_0)
			return arg_35_0.dbid
		end)
	end)
	idlereasy.view_defer(arg_27_0, "any", {
		arg_27_0.seletSortKey,
		arg_27_0.tabOrder
	}, function(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
		dataEasy.tryCallFunc(arg_27_0.cardList, "filterSortItems", not arg_27_0.sortMenusClick)
	end)
	arg_27_0.selectDbId:addListener(handler(arg_27_0, "onSelectDbIdChanged"))
	idlereasy.any({
		dataEasy.getListenShow(gUnlockCsv.zawake),
		arg_27_0.curState,
		arg_27_0.selectDbId,
		arg_27_0.cardId
	}, function(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
		if arg_37_1 and arg_37_2 ~= var_0_3.DECORATION and dataEasy.isInServer("zawake") and arg_27_0:getZawakeID(arg_37_3) then
			arg_27_0.btnZawake:show()

			return
		end

		arg_27_0.btnZawake:hide()
	end)
	arg_27_0:initLeftBtnDatasListeners()

	arg_27_0.cardSprite = nil

	local function var_27_3(arg_38_0)
		if arg_27_0.cardSprite then
			arg_27_0.cardSprite:removeFromParent()
		end

		local var_38_0 = arg_27_0.heroNode:getContentSize()
		local var_38_1 = string.gsub(arg_38_0.unitRes, ".skel", "_ui.skel")

		arg_27_0.cardSprite = widget.addAnimation(arg_27_0.heroNode, var_38_1, var_0_9[1], 5):xy(var_38_0.width / 2, -450)

		arg_27_0.cardSprite:scale(arg_38_0.scaleU * 0.7)
		arg_27_0.cardSprite:setSkin(arg_38_0.skin)
	end

	idlereasy.when(arg_27_0.locked, function(arg_39_0, arg_39_1)
		arg_27_0.btnLock:get("lockImg"):texture(arg_39_1 and "common/btn/btn_s.png" or "common/btn/btn_ks.png")
	end)

	arg_27_0.starDatas = idlertable.new({})

	idlereasy.when(arg_27_0.star, handler(arg_27_0, "onCardStarChanged"))
	idlereasy.any({
		arg_27_0.fightNum,
		arg_27_0.level,
		arg_27_0.advance
	}, function(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
		local var_40_0 = arg_27_0.cardDatas:atproxy(arg_27_0.selectDbId)

		var_40_0.fightNum = arg_40_1
		var_40_0.level = arg_40_2
		var_40_0.advance = arg_40_3

		arg_27_0.textFightPoint:setString(arg_40_1)
	end)

	arg_27_0.attrDatas = idlers.newWithMap({})

	idlereasy.any({
		arg_27_0.cardId,
		arg_27_0.skinId
	}, functools.handler(arg_27_0, "onCardUnitIDChanged", var_27_3))
	idlereasy.any({
		arg_27_0.cardId,
		arg_27_0.skinId,
		arg_27_0.cardName,
		arg_27_0.advance
	}, function(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
		uiEasy.setIconName("card", arg_41_1, {
			space = true,
			node = arg_27_0.cardNameTxt,
			name = arg_41_3,
			advance = arg_41_4
		})

		local var_41_0 = arg_27_0.cardDatas:atproxy(arg_27_0.selectDbId)
		local var_41_1 = csv.cards[arg_41_1]
		local var_41_2 = csv.unit[var_41_1.unitID]

		var_41_0.id = arg_41_1
		var_41_0.rarity = var_41_2.rarity
		var_41_0.unitId = dataEasy.getUnitId(arg_41_1, arg_41_2)

		arg_27_0:updateLeftBtnDatas()
	end)

	local var_27_4 = gGameUI:getConvertPos(arg_27_0.left)

	arg_27_0.effect = widget.addAnimation(arg_27_0, "effect/shengji.skel", "effect", 3):xy(var_27_4.x, var_27_4.y - 400):hide()
	arg_27_0.img = ccui.ImageView:create("battle/txt_pz.png"):addTo(arg_27_0, 10):scale(2):xy(var_27_4.x, var_27_4.y + 100):hide()

	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_27_0.left,
			"pos",
			"center"
		},
		{
			arg_27_0.bgnr,
			"pos",
			"right"
		},
		{
			arg_27_0.panelRight,
			"pos",
			"right"
		}
	})
end

function var_0_2.initModel(arg_42_0)
	arg_42_0.cards = gGameModel.role:getIdler("cards")
	arg_42_0.battleCards = gGameModel.role:getIdler("battle_cards")
	arg_42_0.roleLevel = gGameModel.role:getIdler("level")
end

function var_0_2.onCleanup(arg_43_0)
	arg_43_0._selectDbId = arg_43_0.selectDbId:read()
	arg_43_0._selectTabKey = arg_43_0.selectTabKey:read()
	arg_43_0._curState = arg_43_0.curState:read()
	arg_43_0._rightCurrIdx = arg_43_0.rightCurrIdx

	var_0_1.onCleanup(arg_43_0)
end

function var_0_2.onCurStateChanged(arg_44_0, arg_44_1, arg_44_2)
	if arg_44_0.topView then
		gGameUI.topuiManager:removeView(arg_44_0.topView)
	end

	arg_44_0:updateTabDatas()
	arg_44_0.btnEquip:visible(arg_44_1 ~= var_0_3.DECORATION)
	arg_44_0.btnList:visible(arg_44_1 ~= var_0_3.DECORATION)

	if arg_44_1 == var_0_3.DECORATION then
		arg_44_0.topView = gGameUI.topuiManager:createView("default", arg_44_0, {
			onClose = arg_44_0:createHandler("onCloseDecoration")
		}):init({
			subTitle = "ORNAMENTS",
			title = "common/txt/txt_bt_shipin.png"
		})

		if not arg_44_0.equipView then
			arg_44_0.equipView = gGameUI:createView("city.card.equip.view", arg_44_0):init(arg_44_0:createHandler("sendParamsEquip"))
		else
			arg_44_0.equipIndex:set(1)
			arg_44_0.equipView:show()
		end
	else
		arg_44_0.topView = gGameUI.topuiManager:createView("default", arg_44_0, {
			onClose = arg_44_0:createHandler("onClose")
		}):init({
			subTitle = "STRENGTHEN",
			title = "common/txt/txt_bt_renzhepeiyang.png"
		})

		if arg_44_0.equipView then
			arg_44_0.equipView:hide()
		end
	end

	local var_44_0 = arg_44_0.rightCurrIdx[arg_44_1] or 1

	arg_44_0.selectTabKey:set(var_44_0)
	arg_44_0.selectTabPair:set({
		state = arg_44_1,
		idx = var_44_0
	})
end

function var_0_2.onSelectPairChanged(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_1.state
	local var_45_1 = arg_45_1.idx
	local var_45_2 = arg_45_2 and arg_45_2.idx

	if arg_45_2 then
		local var_45_3 = arg_45_2.state
		local var_45_4 = arg_45_0.rightTabView[var_45_3][var_45_2]

		if var_45_4 then
			var_45_4:hide()

			if var_45_2 ~= var_45_1 or var_45_3 ~= var_45_0 then
				arg_45_0.rightTabView[var_45_3][var_45_2] = nil

				var_45_4:onClose()
			end
		end
	end

	local var_45_5 = arg_45_0.tabDatas:atproxy(var_45_2)
	local var_45_6 = arg_45_0.tabDatas:atproxy(var_45_1)
	local var_45_7 = var_45_6.viewName
	local var_45_8 = var_45_6.key

	dataEasy.setTodayCheck(var_45_8, arg_45_0.selectDbId:read())

	local var_45_9 = arg_45_0.rightTabView[var_45_0][var_45_1]

	if not var_45_9 and var_45_7 then
		var_45_9 = gGameUI:createView(var_45_7, arg_45_0)
		arg_45_0.rightTabView[var_45_0][var_45_1] = var_45_9

		if var_45_9:x() == 0 then
			adapt.centerWithScreen(nil, "right", nil, {
				{
					var_45_9,
					"pos",
					"right"
				}
			})
		end

		if var_45_0 == var_0_3.DECORATION then
			var_45_9:init(arg_45_0:createHandler("sendParamsEquip"))
		elseif var_45_1 == 1 or var_45_1 == 3 then
			var_45_9:init(arg_45_0:createHandler("selectDbId"), arg_45_0:createHandler("playAction"))
		elseif var_45_1 == 6 then
			local var_45_10 = {}

			for iter_45_0, iter_45_1 in pairs({
				arg_45_0.cardList,
				arg_45_0.msgList
			}) do
				local var_45_11 = iter_45_1:box()
				local var_45_12 = iter_45_1:parent():convertToWorldSpace(cc.p(var_45_11.x, var_45_11.y))

				var_45_11.x = var_45_12.x
				var_45_11.y = var_45_12.y

				table.insert(var_45_10, var_45_11)
			end

			var_45_9:init(arg_45_0:createHandler("selectDbId"), var_45_10)
		else
			var_45_9:init(arg_45_0:createHandler("selectDbId"))
		end
	end

	if var_45_9 then
		arg_45_0.rightCurrIdx[var_45_0] = var_45_1

		var_45_9:show()
	end

	if var_45_5 then
		var_45_5.select = false
	end

	var_45_6.select = true

	local var_45_13 = arg_45_0.cardActionState:read()

	if arg_45_0.cardSprite and var_45_13 ~= 1 and var_45_9 then
		local var_45_14 = arg_45_0.heroNode:getContentSize()

		arg_45_0.cardSprite:retain()
		arg_45_0.cardSprite:removeFromParent()
		arg_45_0.cardSprite:addTo(arg_45_0.heroNode, 2):xy(var_45_14.width / 2, -450)
		arg_45_0.cardSprite:release()
		arg_45_0.cardSprite:show()
	end
end

function var_0_2.onSelectDbIdChanged(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = arg_46_0.cardDatas:atproxy(arg_46_2)

	if var_46_0 then
		var_46_0.isSel = false
	end

	arg_46_0.cardDatas:atproxy(arg_46_1).isSel = true

	local var_46_1 = arg_46_0.selectTabKey:read()
	local var_46_2 = arg_46_0.tabDatas:at(var_46_1) and arg_46_0.tabDatas:at(var_46_1).key

	dataEasy.setTodayCheck(var_46_2, arg_46_1)
	arg_46_0:changeCard(arg_46_1)
end

function var_0_2.changeCard(arg_47_0, arg_47_1)
	local var_47_0 = gGameModel.cards:find(arg_47_1)

	gGameModel.cards:removeNewFlag(arg_47_1)

	arg_47_0.cardId = idlereasy.assign(var_47_0:getIdler("card_id"), arg_47_0.cardId)
	arg_47_0.fightNum = idlereasy.assign(var_47_0:getIdler("fighting_point"), arg_47_0.fightNum)
	arg_47_0.cardName = idlereasy.assign(var_47_0:getIdler("name"), arg_47_0.cardName)
	arg_47_0.unitId = idlereasy.assign(var_47_0:getIdler("unit_id"), arg_47_0.unitId)
	arg_47_0.skinId = idlereasy.assign(var_47_0:getIdler("skin_id"), arg_47_0.skinId)
	arg_47_0.star = idlereasy.assign(var_47_0:getIdler("star"), arg_47_0.star)
	arg_47_0.advance = idlereasy.assign(var_47_0:getIdler("advance"), arg_47_0.advance)
	arg_47_0.locked = idlereasy.assign(var_47_0:getIdler("locked"), arg_47_0.locked)
	arg_47_0.level = idlereasy.assign(var_47_0:getIdler("level"), arg_47_0.level)

	local var_47_1 = var_47_0:read("held_item")

	arg_47_0.cardActionState:set(3, true)

	local var_47_2 = dataEasy.getUnitCsv(arg_47_0.cardId:read(), arg_47_0.skinId:read())

	arg_47_0.imgFlag:texture(ui.RARITY_ICON[var_47_2.rarity])
	arg_47_0:onResetHeldItemIcon(var_47_1)
	arg_47_0:updateLeftBtnDatas()
end

function var_0_2.onCardStarChanged(arg_48_0, arg_48_1, arg_48_2)
	arg_48_0.cardDatas:atproxy(arg_48_0.selectDbId).star = arg_48_2

	local var_48_0 = {}
	local var_48_1 = arg_48_2 - 6

	for iter_48_0 = 1, 6 do
		local var_48_2 = "common/icon/icon_stardi.png"

		if iter_48_0 <= arg_48_2 then
			var_48_2 = dataEasy.getStarRes(arg_48_2, iter_48_0)
		end

		table.insert(var_48_0, {
			icon = var_48_2
		})
	end

	arg_48_0.starDatas:set(var_48_0)
end

function var_0_2.onCardUnitIDChanged(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
	local var_49_0 = {}
	local var_49_1 = dataEasy.getUnitCsv(arg_49_3, arg_49_4)

	arg_49_1(var_49_1)
	table.insert(var_49_0, var_49_1.natureType)

	if var_49_1.natureType2 then
		table.insert(var_49_0, var_49_1.natureType2)
	end

	arg_49_0.attrDatas:update(var_49_0)
end

function var_0_2.initLeftBtnDatasListeners(arg_50_0)
	local var_50_0 = handler(arg_50_0, "updateLeftBtnDatas")

	for iter_50_0, iter_50_1 in ipairs(var_0_10) do
		if iter_50_1.unlockKey then
			dataEasy.getListenUnlock(iter_50_1.unlockKey, var_50_0)
		end
	end
end

function var_0_2.updateLeftBtnDatas(arg_51_0)
	local var_51_0 = {}

	for iter_51_0, iter_51_1 in ipairs(var_0_10) do
		local var_51_1 = true

		if iter_51_1.unlockKey then
			var_51_1 = dataEasy.isShow(iter_51_1.unlockKey)
		end

		if var_51_1 and iter_51_1.key == "skin" then
			if arg_51_0.cardId then
				var_51_1 = dataEasy.isShowSkinIcon(arg_51_0.cardId:read())
			else
				var_51_1 = false
			end
		end

		if var_51_1 then
			table.insert(var_51_0, iter_51_1)
		end
	end

	arg_51_0.leftBtnMargin:set(var_0_11[#var_51_0] or 0)
	arg_51_0.leftBtnDatas:set(var_51_0)
end

function var_0_2.initTabDatasListeners(arg_52_0)
	local var_52_0 = handler(arg_52_0, "updateTabDatas")

	for iter_52_0, iter_52_1 in pairs(var_0_6) do
		for iter_52_2, iter_52_3 in pairs(iter_52_1) do
			if iter_52_3.unlockKey then
				dataEasy.getListenShow(iter_52_3.unlockKey, var_52_0)
			end
		end
	end
end

function var_0_2.updateTabDatas(arg_53_0)
	local var_53_0 = {}
	local var_53_1 = arg_53_0.curState:read()

	for iter_53_0, iter_53_1 in pairs(var_0_6[var_53_1]) do
		local var_53_2 = true

		if iter_53_1.unlockKey then
			var_53_2 = dataEasy.isShow(iter_53_1.unlockKey)
		end

		if var_53_2 then
			var_53_0[iter_53_0] = clone(iter_53_1)
		end
	end

	arg_53_0.tabDatas:update(var_53_0)
end

function var_0_2.sendParamsEquip(arg_54_0)
	return arg_54_0.selectDbId, arg_54_0.equipIndex, arg_54_0.selectTabKey, arg_54_0.curState
end

function var_0_2.onTabItemClick(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	if arg_55_3.unlockKey and not dataEasy.isUnlock(arg_55_3.unlockKey) then
		gGameUI:showTip(dataEasy.getUnlockTip(arg_55_3.unlockKey))
	else
		arg_55_0.selectTabKey:set(arg_55_2)
		arg_55_0.selectTabPair:modify(function(arg_56_0)
			return true, {
				state = arg_56_0.state,
				idx = arg_55_2
			}
		end)
	end
end

function var_0_2.onCardItemClick(arg_57_0, arg_57_1, arg_57_2, arg_57_3)
	arg_57_0.selectDbId:set(arg_57_3.dbid)
end

function var_0_2.onLockClick(arg_58_0)
	if not dataEasy.isUnlock(gUnlockCsv.cardUnlock) then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.cardUnlock))

		return
	end

	gGameApp:requestServer("/game/card/locked/switch", function(arg_59_0)
		gGameUI:showTip(not arg_58_0.locked:read() and gLanguageCsv.unlockSuccess or gLanguageCsv.lockSuccess)

		arg_58_0.cardDatas:atproxy(arg_58_0.selectDbId).lock = arg_58_0.locked:read()
	end, arg_58_0.selectDbId)
end

function var_0_2.onChangeNameClick(arg_60_0)
	local var_60_0 = gGameModel.cards:find(arg_60_0.selectDbId:read())

	gGameUI:stackUI("city.card.changename", nil, nil, {
		typ = "card",
		name = var_60_0:read("name"),
		cost = gCommonConfigCsv.cardRenameRMBCost,
		titleTxt = gLanguageCsv.spriteRename,
		requestParams = {
			arg_60_0.selectDbId:read()
		},
		cb = function()
			gGameUI:showTip(gLanguageCsv.spriteRenameSuccess)
		end
	})
end

function var_0_2.onCardClick(arg_62_0)
	local var_62_0 = arg_62_0.cardActionState:read()
	local var_62_1

	repeat
		var_62_1 = math.random(2, #var_0_9)
	until var_62_1 ~= var_62_0

	arg_62_0.cardActionState:set(var_62_1, true)
end

function var_0_2.onLeftBtnItemClick(arg_63_0, arg_63_1, arg_63_2)
	if arg_63_2.unlockKey and not dataEasy.isUnlock(arg_63_2.unlockKey) then
		gGameUI:showTip(dataEasy.getUnlockTip(arg_63_2.unlockKey))

		return
	end

	arg_63_0[arg_63_2.click](arg_63_0)
end

function var_0_2.onResetHeldItemIcon(arg_64_0, arg_64_1)
	arg_64_0.btnHeldItem:removeChildByName("exclusive")
	arg_64_0.btnHeldItem:removeChildByName("textLv")
	arg_64_0.btnHeldItem:removeChildByName("textLvNum")

	local var_64_0 = "common/btn/btn_d.png"
	local var_64_1 = "city/card/helditem/icon_jiahao.png"
	local var_64_2 = 0.7
	local var_64_3 = false

	if arg_64_1 then
		var_64_3 = true

		local var_64_4 = gGameModel.held_items:find(arg_64_1):read("level", "held_item_id")
		local var_64_5 = csv.held_item.items[var_64_4.held_item_id]

		var_64_1 = var_64_5.icon

		local var_64_6 = var_64_5.quality

		var_64_0 = string.format("city/card/helditem/panel_icon_%d.png", var_64_6)

		if csvSize(var_64_5.exclusiveCards) > 0 then
			ccui.ImageView:create("common/icon/txt_zs.png"):xy(61, 130):addTo(arg_64_0.btnHeldItem, 6, "exclusive")
		end

		local var_64_7 = cc.Label:createWithTTF("Lv", ui.FONT_PATH, 30):xy(61, 0):addTo(arg_64_0.btnHeldItem, 8, "textLv")
		local var_64_8 = cc.Label:createWithTTF(var_64_4.level, ui.FONT_PATH, 38):xy(61, 0):addTo(arg_64_0.btnHeldItem, 8, "textLvNum")

		var_64_2 = 1

		adapt.oneLineCenterPos(cc.p(61, -10), {
			var_64_7,
			var_64_8
		}, cc.p(5, 3))
		text.addEffect(var_64_7, {
			outline = {
				color = ui.NEWCOLORS.OUTLINE.BLACK
			}
		})
		text.addEffect(var_64_8, {
			outline = {
				color = ui.NEWCOLORS.OUTLINE.BLACK
			}
		})

		if arg_64_0.btnHeldItem:get("spine") then
			arg_64_0.btnHeldItem:get("spine"):show()
			arg_64_0.btnHeldItem:get("spine"):play("effect_loop")
			arg_64_0.btnHeldItem:get("spine"):scale(0.7)
		else
			widget.addAnimationByKey(arg_64_0.btnHeldItem, "effect/yuanxingsaoguang.skel", "spine", "effect_loop", 100):xy(arg_64_0.btnHeldItem:size().width / 2, arg_64_0.btnHeldItem:size().height / 2):scale(0.7)
		end

		arg_64_0.heldItemImgBg:scale(0.7)
	else
		if arg_64_0.btnHeldItem:get("spine") then
			arg_64_0.btnHeldItem:get("spine"):hide()
		end

		arg_64_0.heldItemImgBg:scale(1)
	end

	arg_64_0.dressState:set(var_64_3, true)
	arg_64_0.heldItemBg:set(var_64_0)
	arg_64_0.heldItemIcon:set(var_64_1)
	arg_64_0.heleItemIcon:scale(var_64_2)
end

function var_0_2.onAddClick(arg_65_0)
	if not dataEasy.isUnlock(gUnlockCsv.heldItem) then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.heldItem))

		return
	end

	gGameUI:stackUI("city.card.helditem.bag", nil, nil, arg_65_0.selectDbId:read(), arg_65_0:createHandler("onResetHeldItemIcon"))
end

function var_0_2.onEquipClick(arg_66_0)
	if not dataEasy.isUnlock(gUnlockCsv.equip) then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.equip))

		return
	end

	arg_66_0.curState:set(var_0_3.DECORATION)
end

function var_0_2.onZawakeClick(arg_67_0)
	if not dataEasy.isUnlock(gUnlockCsv.zawake) then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.zawake))

		return
	end

	local var_67_0 = arg_67_0:getZawakeID(arg_67_0.selectDbId:read())

	gGameUI:stackUI("city.zawake.view", nil, nil, {
		zawakeID = var_67_0,
		cb = arg_67_0:createHandler("onZawakeSelectDbIdChange")
	})
end

function var_0_2.onZawakeSelectDbIdChange(arg_68_0, arg_68_1)
	arg_68_0.selectDbId:set(arg_68_1)
	dataEasy.tryCallFunc(arg_68_0.cardList, "forceUpdate", true)
end

function var_0_2.onGemClick(arg_69_0)
	if not dataEasy.isUnlock(gUnlockCsv.gem) then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.gem))

		return
	end

	gGameUI:stackUI("city.card.gem.view", nil, nil, arg_69_0.selectDbId:read())
end

function var_0_2.onAccClick(arg_70_0)
	return
end

function var_0_2.onEvoClick(arg_71_0)
	gGameUI:stackUI("city.card.evolution_base", nil, nil, arg_71_0.selectDbId:read())
end

function var_0_2.onSkinClick(arg_72_0)
	local var_72_0 = csv.cards[arg_72_0.cardId:read()].feelItems

	if csvSize(var_72_0) <= 0 then
		gGameUI:showTip(gLanguageCsv.notDevelopFeel)

		return
	end

	gGameUI:stackUI("city.card.feel.view", nil, nil, arg_72_0.cardId:read())
end

function var_0_2.onRebornClick(arg_73_0)
	if not gGameUI:goBackInStackUI("city.card.rebirth.view") then
		gGameUI:stackUI("city.card.rebirth.view", nil, nil, 1, arg_73_0:createHandler("resetSelDbId"), arg_73_0:createHandler("cardsChanged"))
	end
end

function var_0_2.onSwapClick(arg_74_0)
	gGameUI:stackUI("city.card.property_swap.view", nil, nil, nil, arg_74_0.selectDbId:read())
end

function var_0_2.onCardSkinClick(arg_75_0)
	gGameUI:stackUI("city.card.skin.view", nil, nil, arg_75_0.selectDbId:read())
end

function var_0_2.onManualsClick(arg_76_0)
	gGameUI:stackUI("city.card.helditem.battle_manuals")
end

function var_0_2.onSortCardList(arg_77_0, arg_77_1)
	local var_77_0 = arg_77_0.seletSortKey:read()
	local var_77_1 = var_0_8[var_77_0].attr
	local var_77_2 = arg_77_0.tabOrder:read()

	return function(arg_78_0, arg_78_1)
		if arg_78_0.battle ~= arg_78_1.battle then
			return arg_78_0.battle < arg_78_1.battle
		end

		local var_78_0 = arg_78_0[var_77_1]
		local var_78_1 = arg_78_1[var_77_1]

		if var_78_0 ~= var_78_1 then
			if var_77_2 then
				return var_78_1 < var_78_0
			else
				return var_78_0 < var_78_1
			end
		end

		if arg_78_0.markId ~= arg_78_1.markId then
			return arg_78_0.markId < arg_78_1.markId
		end

		return arg_78_0.fight > arg_78_1.fight
	end
end

function var_0_2.onSortMenusBtnClick(arg_79_0, arg_79_1, arg_79_2, arg_79_3, arg_79_4, arg_79_5)
	arg_79_0.sortMenusClick = true

	if arg_79_5 == arg_79_3 then
		arg_79_0.tabOrder:modify(function(arg_80_0)
			return true, not arg_80_0
		end)
	else
		arg_79_0.tabOrder:set(true)
	end

	arg_79_0.seletSortKey:set(arg_79_3)

	arg_79_0.sortMenusClick = false
end

function var_0_2.getZawakeID(arg_81_0, arg_81_1)
	local var_81_0 = gGameModel.cards:find(arg_81_1)

	if not var_81_0 then
		return
	end

	local var_81_1 = var_81_0:read("card_id")
	local var_81_2 = csv.cards[var_81_1].zawakeID

	if var_0_0.isOpenByStage(var_81_2) then
		return var_81_2
	end
end

function var_0_2.getSelectedCardDBID(arg_82_0)
	local var_82_0 = arg_82_0.battleCards:read()
	local var_82_1 = arg_82_0.cards:read()
	local var_82_2 = itertools.map(itertools.ivalues(var_82_0), function(arg_83_0, arg_83_1)
		return arg_83_1, arg_83_0
	end)
	local var_82_3 = {}

	for iter_82_0, iter_82_1 in ipairs(var_82_1) do
		local var_82_4 = gGameModel.cards:find(iter_82_1):read("card_id", "fighting_point")
		local var_82_5 = var_82_2[iter_82_1] and 1 or 2
		local var_82_6 = csv.cards[var_82_4.card_id]

		table.insert(var_82_3, {
			id = var_82_4.card_id,
			fight = var_82_4.fighting_point,
			dbid = iter_82_1,
			battle = var_82_5
		})
	end

	table.sort(var_82_3, function(arg_84_0, arg_84_1)
		if arg_84_0.battle ~= arg_84_1.battle then
			return arg_84_0.battle < arg_84_1.battle
		end

		local var_84_0 = arg_84_0.fight
		local var_84_1 = arg_84_1.fight

		if var_84_0 ~= var_84_1 then
			return var_84_1 < var_84_0
		end

		return arg_84_0.id < arg_84_1.id
	end)

	return var_82_3[1] and var_82_3[1].dbid
end

function var_0_2.onCloseDecoration(arg_85_0)
	arg_85_0.curState:set(var_0_3.STRENGTHEN)
end

function var_0_2.playAction(arg_86_0, arg_86_1, arg_86_2)
	if arg_86_1 == nil then
		arg_86_1 = true
	end

	arg_86_0.cardActionState:set(3, arg_86_1)
	arg_86_0.effect:visible(true)
	arg_86_0.effect:play("effect")
	performWithDelay(arg_86_0.left, function()
		arg_86_0.effect:visible(false)
	end, 1)

	if arg_86_2 then
		local var_86_0 = gGameUI:getConvertPos(arg_86_0.left)

		arg_86_0.img:show():xy(var_86_0.x, var_86_0.y - 200)
		transition.executeSequence(arg_86_0.img):moveBy(0.45, 0, 100):func(function()
			arg_86_0.img:hide()
		end):done()
	end
end

function var_0_2.resetSelDbId(arg_89_0)
	local var_89_0 = arg_89_0:getSelectedCardDBID()

	arg_89_0.selectDbId:set(var_89_0)

	arg_89_0.cardDatas:atproxy(var_89_0).isSel = true
end

function var_0_2.onClose(arg_90_0)
	local var_90_0 = arg_90_0.closeHandler

	var_0_1.onClose(arg_90_0)

	if var_90_0 then
		var_90_0()
	end
end

return var_0_2
