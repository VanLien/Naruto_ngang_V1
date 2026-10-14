local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("UnionRankView", Dialog)
local var_0_2 = "city/union/union_fight/part3/btn_1.png"
local var_0_3 = "city/union/union_fight/part3/btn_2.png"
local var_0_4 = {
	"city/union/union_fight/part3/icon_1.png",
	"city/union/union_fight/part3/icon_2.png",
	"city/union/union_fight/part3/icon_3.png"
}

var_0_1.RESOURCE_FILENAME = "union_rank.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	["up.icon3"] = "icon3",
	bg404 = "bg404",
	down = "down",
	bg2 = "bg2",
	leftitem = "leftitem",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	leftLsit = {
		varname = "leftList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("leftDate"),
				item = bindHelper.self("leftitem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					if arg_1_3.select then
						arg_1_1:get("btn"):visible(true)
						arg_1_1:get("btn"):get("title"):text(arg_1_3.text)
						text.addEffect(arg_1_1:get("btn"):get("title"), {
							outline = {
								color = cc.c4b(59, 51, 59, 255)
							}
						})
					else
						arg_1_1:get("btn"):visible(false)
					end

					arg_1_1:get("name"):text(arg_1_3.text)
					arg_1_1:get("name"):setOpacity(178)
					text.addEffect(arg_1_1:get("name"), {
						outline = {
							size = 2,
							color = cc.c4b(255, 252, 237, 255)
						}
					})
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("clickBtn")
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("rankDate"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true,
					alwaysShow = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					if arg_2_2 <= 3 then
						arg_2_1:get("rank"):texture(var_0_4[arg_2_2])
						arg_2_1:get("randNum"):hide()
					else
						arg_2_1:get("rank"):hide()
						arg_2_1:get("randNum"):text(arg_2_2)
						text.addEffect(arg_2_1:get("randNum"), {
							outline = {
								color = cc.c4b(48, 31, 3, 255)
							}
						})
					end

					arg_2_1:get("name"):text(arg_2_3.name)
					arg_2_1:get("zdl"):text(arg_2_3.point)

					local var_2_0 = arg_2_2 % 2 == 0 and 153 or 77

					arg_2_1:get("bg"):setOpacity(var_2_0)

					if not arg_2_3.isUnion then
						local var_2_1 = {
							event = "extend",
							class = "role_logo",
							props = {
								vip = false,
								level = false,
								logoId = arg_2_3.logo,
								frameId = arg_2_3.frame,
								onNode = function(arg_3_0)
									arg_3_0:xy(50, 50):z(6):scale(0.8)
								end
							}
						}

						arg_2_1:get("icon"):get("iconbg"):hide()
						arg_2_1:get("icon"):get("iconbg2"):hide()
						bind.extend(arg_2_0, arg_2_1:get("icon"):get("icon"), var_2_1)
						arg_2_1:get("icon"):get("iconbg"):hide()
					else
						arg_2_1:get("icon"):get("iconbg"):show()
						arg_2_1:get("icon"):get("icon"):removeAllChildren()
						arg_2_1:get("icon"):get("iconbg"):texture(csv.union.union_logo[arg_2_3.logo].icon)
						arg_2_1:get("icon"):get("iconbg"):setScale(1.8)
						arg_2_1:get("icon"):get("iconbg2"):setScale(0.47)
						arg_2_1:get("icon"):get("iconbg2"):setOpacity(178)
					end

					arg_2_1:get("icon"):get("level"):text(arg_2_3.level)

					local var_2_2 = arg_2_1:get("icon"):get("level"):x()
					local var_2_3 = arg_2_1:get("icon"):get("level"):width()

					arg_2_1:get("icon"):get("level"):x(var_2_2 - var_2_3 / 2)
					arg_2_1:get("icon"):get("txt"):x(arg_2_1:get("icon"):get("txt"):x() - var_2_3 / 2)
					text.addEffect(arg_2_1:get("icon"):get("txt"), {
						outline = {
							color = cc.c4b(108, 82, 49, 255)
						}
					})
					text.addEffect(arg_2_1:get("icon"):get("level"), {
						outline = {
							color = cc.c4b(108, 82, 49, 255)
						}
					})
					arg_2_1:get("icon"):setTouchEnabled(false)
				end
			}
		}
	},
	["up.icon1"] = {
		varname = "icon1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("unionRankFunc")
			}
		}
	},
	["up.icon2"] = {
		varname = "icon2",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("oneSelfFunc")
			}
		}
	},
	["up.icon3.name"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = cc.c4b(255, 243, 224, 255)
					}
				}
			}
		}
	},
	["up.icon2.name"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = cc.c4b(255, 243, 224, 255)
					}
				}
			}
		}
	},
	["up.icon1.name"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = cc.c4b(188, 125, 74, 255)
					}
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0, ...)
	arg_4_0.item:visible(false)
	arg_4_0.leftitem:visible(false)
	arg_4_0.bg404:visible(false)
	arg_4_0.bg2:visible(false)
	arg_4_0.down:visible(false)
	arg_4_0:initModel()
	arg_4_0:updatePenal()
	arg_4_0.paging:addListener(function(arg_5_0, arg_5_1, arg_5_2)
		arg_4_0.leftDate:atproxy(arg_5_1).select = false
		arg_4_0.leftDate:atproxy(arg_5_0).select = true
	end)
	Dialog.onCreate(arg_4_0)
end

function var_0_1.updatePenal(arg_6_0)
	gGameApp:requestServer("/game/union/fight/rank", function(arg_7_0)
		for iter_7_0, iter_7_1 in csvMapPairs(arg_7_0.view) do
			arg_6_0.unionDateTab[iter_7_0] = iter_7_1.union_rank
			arg_6_0.oneSelfDateTab[iter_7_0] = iter_7_1.role_rank
			arg_6_0.oneSelfUnion[iter_7_0] = iter_7_1.my_union_rank
			arg_6_0.oneSelf[iter_7_0] = iter_7_1.my_rank
		end

		arg_6_0.unionDateTab[8] = arg_6_0.unionDateTab[8] or {}

		for iter_7_2, iter_7_3 in pairs(arg_6_0.unionDateTab[8]) do
			iter_7_3.isUnion = true
		end

		arg_6_0.rankDate:update(arg_6_0.unionDateTab[8])

		local var_7_0 = itertools.size(arg_6_0.unionDateTab[8])

		arg_6_0:executeDate(arg_6_0.oneSelfUnion, var_7_0, true)
		arg_6_0.bg404:visible(itertools.size(arg_6_0.unionDateTab[8]) == 0)
		arg_6_0.bg2:visible(itertools.size(arg_6_0.unionDateTab[8]) == 0)
		arg_6_0.down:visible(itertools.size(arg_6_0.unionDateTab[8]) ~= 0)
	end)
end

function var_0_1.initModel(arg_8_0, ...)
	arg_8_0.rankDate = idlers.new({})
	arg_8_0.rank = 2
	arg_8_0.paging = idler.new(1)
	arg_8_0.unionDateTab = {}
	arg_8_0.oneSelfDateTab = {}
	arg_8_0.oneSelfUnion = {}
	arg_8_0.oneSelf = {}
	arg_8_0.name = gGameModel.role:read("name")
	arg_8_0.unName = gGameModel.union:read("name")

	arg_8_0.icon3:hide()

	arg_8_0.leftDate = idlers.newWithMap({
		{
			id = 1,
			text = gLanguageCsv.allRank
		},
		{
			id = 2,
			text = gLanguageCsv.firstRound
		},
		{
			id = 3,
			text = gLanguageCsv.theSecondRound
		},
		{
			id = 4,
			text = gLanguageCsv.thridRound
		},
		{
			id = 5,
			text = gLanguageCsv.theFourthRoundOf
		},
		{
			id = 6,
			text = gLanguageCsv.BattleLine
		}
	})
end

function var_0_1.executeDate(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_0.paging:read()
	local var_9_1 = var_9_0

	if var_9_0 == 1 then
		var_9_1 = 8
	end

	if not arg_9_1[var_9_1][1] or arg_9_2 < arg_9_1[var_9_1][1] or arg_9_2 == 0 or arg_9_1[var_9_1][1] == 0 then
		arg_9_0.down:get("wsb"):text(gLanguageCsv.noRank)
	else
		arg_9_0.down:get("wsb"):text(arg_9_1[var_9_1][1])
	end

	local var_9_2 = arg_9_3 and arg_9_0.unName or arg_9_0.name

	arg_9_0.down:get("name"):text(var_9_2)
	arg_9_0.down:get("zdl"):text(arg_9_1[var_9_1][2])
end

function var_0_1.unionRankFunc(arg_10_0, ...)
	arg_10_0.rank = 2

	local var_10_0 = arg_10_0.paging:read()

	arg_10_0.icon3:hide()
	arg_10_0.icon1:setOpacity(255)
	arg_10_0.icon2:texture(var_0_3)
	arg_10_0:outlinePanel(arg_10_0.icon1, arg_10_0.icon2)

	var_10_0 = var_10_0 == 1 and 8 or var_10_0

	local var_10_1 = arg_10_0.unionDateTab[var_10_0] or {}

	for iter_10_0, iter_10_1 in pairs(var_10_1) do
		iter_10_1.isUnion = true
	end

	arg_10_0.rankDate:update(var_10_1)

	local var_10_2 = itertools.size(var_10_1)

	arg_10_0:executeDate(arg_10_0.oneSelfUnion, var_10_2, true)
	arg_10_0.bg404:visible(itertools.size(var_10_1) == 0)
	arg_10_0.bg2:visible(itertools.size(var_10_1) == 0)
	arg_10_0.down:visible(itertools.size(var_10_1) ~= 0)
end

function var_0_1.oneSelfFunc(arg_11_0, ...)
	arg_11_0.rank = 1

	local var_11_0 = arg_11_0.paging:read()

	arg_11_0.icon3:show()
	arg_11_0.icon1:setOpacity(0)
	arg_11_0.icon2:texture(var_0_2)
	arg_11_0:outlinePanel(arg_11_0.icon2, nil)

	var_11_0 = var_11_0 == 1 and 8 or var_11_0

	local var_11_1 = arg_11_0.oneSelfDateTab[var_11_0] or {}

	arg_11_0.rankDate:update(var_11_1)

	local var_11_2 = itertools.size(var_11_1)

	arg_11_0:executeDate(arg_11_0.oneSelf, var_11_2, false)
	arg_11_0.bg404:visible(itertools.size(var_11_1) == 0)
	arg_11_0.bg2:visible(itertools.size(var_11_1) == 0)
	arg_11_0.down:visible(itertools.size(var_11_1) ~= 0)
end

function var_0_1.outlinePanel(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_1 then
		arg_12_1:get("name"):setTextColor(cc.c4b(253, 247, 229, 255))
		text.addEffect(arg_12_1:get("name"), {
			outline = {
				color = cc.c4b(188, 125, 74, 255)
			}
		})
	end

	if arg_12_2 then
		arg_12_2:get("name"):setTextColor(cc.c4b(202, 130, 84, 255))
		text.addEffect(arg_12_2:get("name"), {
			outline = {
				color = cc.c4b(255, 243, 224, 255)
			}
		})
	end
end

function var_0_1.clickBtn(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if arg_13_3.id ~= arg_13_0.paging:read() then
		arg_13_0.paging:set(arg_13_3.id)

		if arg_13_0.rank == 1 then
			arg_13_0:oneSelfFunc()
		else
			arg_13_0:unionRankFunc()
		end
	end
end

return var_0_1
