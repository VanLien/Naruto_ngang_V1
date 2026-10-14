local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("TotemView", var_0_0)
local var_0_2 = require("app.views.city.develop.totem.tools")

var_0_1.RESOURCE_FILENAME = "totem_view.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	bg = "bg",
	leaf = "leaf",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				padding = 0,
				backupCached = false,
				margin = bindHelper.self("margin"),
				data = bindHelper.self("showData"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("bg", "name", "num", "effect", "lock")
					local var_1_1 = cc.Sprite:create(string.format("city/develop/totem/fang%d.png", arg_1_2))

					var_1_1:setScale(2)
					var_1_1:xy(250, 280)
					var_1_0.effect:addChild(var_1_1)
					var_1_0.name:text(arg_1_3.name)
					var_1_0.num:text(string.format("%s/%s", arg_1_3.activeStone, arg_1_3.sum))

					if arg_1_2 % 2 ~= 0 then
						arg_1_1:y(250)
					end

					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.clickItem, arg_1_2)
						}
					})
					text.addEffect(var_1_0.name, {
						outline = {
							size = 5,
							color = cc.c4b(255, 84, 0, 255)
						}
					})
					text.addEffect(var_1_0.num, {
						outline = {
							size = 5,
							color = cc.c4b(91, 84, 91, 255)
						}
					})
					bind.extend(arg_1_0, arg_1_1, {
						class = "red_hint",
						props = {
							specialTag = "totemGroup",
							listenData = {
								group = arg_1_3.id
							},
							state = arg_1_3.unlock,
							onNode = function(arg_2_0)
								arg_2_0:xy(520, 460)
							end
						}
					})

					if arg_1_3.unlock == false then
						var_1_0.lock:show()
						var_1_1:setScale(0)
						cache.setShader(var_1_1, false, "gray")
						bind.touch(arg_1_0, arg_1_1, {
							methods = {
								ended = function()
									local var_3_0 = csv.totem.symbol_group[arg_1_3.id].unlockEnergy

									gGameUI:showTip(string.format(gLanguageCsv.totemUnlockTips, var_3_0))
								end
							}
						})
					else
						var_1_0.lock:hide()
						var_1_1:setScale(1)
						cache.setShader(var_1_1, false, "normal")
						bind.touch(arg_1_0, arg_1_1, {
							methods = {
								ended = functools.partial(arg_1_0.clickItem, arg_1_2)
							}
						})

						if arg_1_3.playUnlockAnim then
							widget.addAnimation(arg_1_1, "xunlianshi1/xunblianshi1.skel", "jiesuo", 100):xy(arg_1_1:size().width / 2, arg_1_1:size().height / 2 - 100)
						end
					end
				end,
				onAfterBuild = function(arg_4_0)
					arg_4_0.setItemAlignCenter(arg_4_0)
				end
			},
			handlers = {
				clickItem = bindHelper.self("onItemClick")
			}
		}
	},
	collection = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onCollection")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "totemAwardAllGet",
					onNode = function(arg_5_0)
						arg_5_0.xy(arg_5_0, 170, 75)
					end
				}
			}
		}
	},
	book = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBook")
			}
		}
	},
	shop = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShop")
			}
		}
	},
	decompose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDecompose")
			}
		}
	},
	rule = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRule")
			}
		}
	},
	draw = {
		varname = "btnDraw",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onDraw")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "totemFree",
					onNode = function(arg_6_0)
						arg_6_0.xy(arg_6_0, arg_6_0.x(arg_6_0) - 15, arg_6_0.y(arg_6_0) - 5)
					end
				}
			}
		}
	},
	["collection.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["book.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["rule.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["shop.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["decompose.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["draw.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_7_0)
	arg_7_0.totemsData = gGameModel.totem:getIdler("totem_insetted")
	arg_7_0.showData = idlers.new({})
	arg_7_0.tUnlock = {}

	gGameUI.topuiManager:createView("default", arg_7_0, {
		onClose = arg_7_0:createHandler("onClose")
	}):init({
		subTitle = "TOTEM",
		title = "common/txt/txt_bt_zuhui.png"
	})
	idlereasy.when(arg_7_0.totemsData, function(arg_8_0, arg_8_1)
		arg_7_0:initModel(arg_8_1)
	end)

	local var_7_0 = cc.Sprite:create("city/develop/totem/bg.png")

	var_7_0:setScale(2)
	arg_7_0.bg:addChild(var_7_0)
	arg_7_0.leaf:setTouchEnabled(false)
	dataEasy.getListenUnlock(gUnlockCsv.totemDraw, function(arg_9_0)
		arg_7_0.btnDraw:visible(arg_9_0)
	end)
	performWithDelay(arg_7_0, function()
		arg_7_0:refreshUnlock()
	end, 0)
end

function var_0_1.refreshUnlock(arg_11_0)
	arg_11_0.unlockPlayIndex = 1

	local var_11_0 = gGameModel.totem:read("totem_insetted")
	local var_11_1 = var_0_2.getActivateTotemEnergy(var_11_0)

	for iter_11_0, iter_11_1 in orderCsvPairs(csv.totem.symbol_group) do
		local var_11_2 = false

		if var_11_1 >= iter_11_1.unlockEnergy then
			var_11_2 = true
		end

		if arg_11_0.showData:atproxy(iter_11_0) then
			arg_11_0.showData:atproxy(iter_11_0).unlock = var_11_2

			if arg_11_0.tUnlock[iter_11_0] == false and var_11_2 == true then
				arg_11_0.showData:atproxy(iter_11_0).playUnlockAnim = true
				arg_11_0.unlockPlayIndex = iter_11_0
			end
		end
	end

	arg_11_0.list:jumpToItem(arg_11_0.unlockPlayIndex - 1, cc.p(0, 1), cc.p(0, 1))
end

function var_0_1.initModel(arg_12_0, arg_12_1)
	local var_12_0 = {}
	local var_12_1 = gGameModel.totem:read("totem_insetted")
	local var_12_2 = var_0_2.getActivateTotemEnergy(var_12_1)

	for iter_12_0, iter_12_1 in orderCsvPairs(csv.totem.symbol_group) do
		local var_12_3 = 0
		local var_12_4 = 0

		for iter_12_2, iter_12_3 in orderCsvPairs(csv.totem.symbol) do
			if iter_12_3.symbolGroupType == iter_12_1.id then
				var_12_3 = var_12_3 + 1

				if arg_12_1[iter_12_3.id] and itertools.size(iter_12_3.totemGroup1) <= itertools.size(arg_12_1[iter_12_3.id]) then
					var_12_4 = var_12_4 + 1
				end
			end
		end

		if var_12_2 >= iter_12_1.showEnergy then
			table.insert(var_12_0, {
				id = iter_12_1.id,
				name = iter_12_1.name,
				activeStone = var_12_4,
				sum = var_12_3
			})
		end
	end

	arg_12_0.showData:update(var_12_0)

	if itertools.size(var_12_0) < 5 then
		arg_12_0.list:setTouchEnabled(false)

		arg_12_0.margin = 155
	else
		arg_12_0.list:setTouchEnabled(true)

		arg_12_0.margin = 105
	end
end

function var_0_1.onItemClick(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0.tUnlock = {}

	for iter_13_0, iter_13_1 in arg_13_0.showData:pairs() do
		arg_13_0.tUnlock[iter_13_0] = iter_13_1.read(iter_13_1).unlock
	end

	gGameUI:stackUI("city.develop.totem.totem_inset", nil, {
		full = true
	}, {
		id = arg_13_2,
		cb = arg_13_0:createHandler("refreshUnlock")
	})
end

function var_0_1.onCollection(arg_14_0)
	gGameUI:stackUI("city.develop.totem.collect", nil, {
		full = true
	})
end

function var_0_1.onBook(arg_15_0)
	gGameUI:stackUI("city.develop.totem.bag", nil, {})
end

function var_0_1.onDecompose(arg_16_0)
	gGameUI:stackUI("city.develop.totem.decompose", nil, {
		full = true
	})
end

function var_0_1.onShop(arg_17_0)
	if not gGameUI:goBackInStackUI("city.shop") then
		gGameApp:requestServer("/game/totem/shop/get", function(arg_18_0)
			gGameUI:stackUI("city.shop", nil, {
				full = true
			}, game.SHOP_INIT.TOTEM_SHOP)
		end)
	end
end

function var_0_1.onRule(arg_19_0)
	gGameUI:stackUI("common.rule", nil, {}, arg_19_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_1.onDraw(arg_20_0)
	gGameUI:stackUI("city.develop.totem.draw", nil, {
		full = true
	})
end

function var_0_1.getRuleContext(arg_21_0, arg_21_1)
	local var_21_0 = adaptContext

	return {
		var_21_0.clone(arg_21_1.title, function(arg_22_0)
			arg_22_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_21_0.noteText(165),
		var_21_0.noteText(125801, 125804)
	}
end

return var_0_1
