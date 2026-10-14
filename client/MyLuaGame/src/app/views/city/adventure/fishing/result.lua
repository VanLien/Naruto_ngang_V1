local var_0_0 = class("FishingResultView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "fishing_result.json"
var_0_0.RESOURCE_BINDING = {
	["fishItem.list"] = "descList",
	item = "item",
	fishItem = "fishItem",
	pos = "skelPos",
	["fishItem.iconPos"] = "iconPos",
	["fishItem.imgNew"] = "imgNew",
	["fishItem.imgTipPos"] = "imgTipPos",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("datas"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					if arg_1_3.id ~= nil then
						local var_1_0 = csv.cards[arg_1_3.id].unitID
						local var_1_1 = csv.cards[arg_1_3.id].star
						local var_1_2 = csv.unit[var_1_0].rarity

						bind.extend(arg_1_0, arg_1_1, {
							class = "card_icon",
							props = {
								unitId = var_1_0,
								rarity = var_1_2,
								star = var_1_1
							},
							bind.touch(arg_1_0, arg_1_1, {
								methods = {
									ended = functools.partial(arg_1_0.itemClick, arg_1_1, arg_1_2, arg_1_3)
								}
							})
						})
					else
						bind.extend(arg_1_0, arg_1_1, {
							class = "icon_key",
							props = {
								data = {
									key = arg_1_3.key,
									num = arg_1_3.num
								}
							}
						})
					end
				end,
				onAfterBuild = function(arg_2_0)
					arg_2_0:setItemAlignCenter()
				end
			},
			handlers = {
				itemClick = bindHelper.self("onitemClick")
			}
		}
	},
	["fishItem.name"] = {
		varname = "fishName",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["fishItem.length"] = {
		varname = "length",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["fishItem.numLength"] = {
		varname = "numLength",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	score = {
		varname = "score",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	score1 = {
		varname = "score1",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	score2 = {
		varname = "score2",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0:initSkel()
	performWithDelay(arg_3_0, function()
		arg_3_0.skel:play("effect_loop")
	end, 0.8)

	arg_3_0.datas = idlers.newWithMap({})

	local var_3_0 = csv.fishing.fish[arg_3_1]

	if var_3_0.showType == "pic" then
		ccui.ImageView:create(var_3_0.res):xy(arg_3_0.iconPos:xy()):scale(var_3_0.scale):addTo(arg_3_0.fishItem, 1, "icon")
	elseif var_3_0.showType == "spine" then
		widget.addAnimationByKey(arg_3_0.fishItem, var_3_0.res, "fish", "standby_loop", 1):anchorPoint(cc.p(0.5, 0)):xy(arg_3_0.iconPos:x(), arg_3_0.iconPos:y() - 150):scale(var_3_0.scale)
	end

	arg_3_0.fishName:text(var_3_0.name)
	arg_3_0.numLength:text(arg_3_2 .. "cm")
	adapt.oneLinePos(arg_3_0.length, arg_3_0.numLength, cc.p(3, 0), "left")

	if arg_3_2 == 0 then
		itertools.invoke({
			arg_3_0.length,
			arg_3_0.numLength
		}, "hide")
	end

	if arg_3_4 < arg_3_2 then
		arg_3_0.imgNew:show()
	end

	local var_3_1 = ccui.ImageView:create(ui.RARITY_ICON[var_3_0.rare]):xy(arg_3_0.imgTipPos:xy()):scale(1):addTo(arg_3_0.fishItem, 2, "rarity")

	beauty.textScroll({
		align = "center",
		list = arg_3_0.descList,
		strs = {
			fontPath = "font/youmi.ttf",
			str = var_3_0.desc
		},
		effect = {
			color = cc.c4b(255, 252, 237, 255)
		}
	})

	if arg_3_5 == game.FISHING_GAME then
		itertools.invoke({
			arg_3_0.score1,
			arg_3_0.score2
		}, "show")

		local var_3_2 = gGameModel.fishing:read("point") - arg_3_6

		arg_3_0.score2:text(var_3_2)
		adapt.oneLinePos(arg_3_0.score1, arg_3_0.score2, cc.p(3, 0), "left")
		adapt.oneLinePos(arg_3_0.score1, arg_3_0.score, cc.p(10, 0), "right")
	end

	local var_3_3 = {}

	if arg_3_3.cards ~= nil then
		table.insert(var_3_3, arg_3_3.cards[1])
	else
		for iter_3_0, iter_3_1 in csvMapPairs(arg_3_3) do
			local var_3_4 = {
				key = iter_3_0,
				num = iter_3_1
			}

			table.insert(var_3_3, var_3_4)
		end
	end

	arg_3_0.datas:update(var_3_3)
end

function var_0_0.onitemClick(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	gGameUI:showItemDetail(arg_5_2, {
		key = "card",
		num = arg_5_4.id
	})
end

function var_0_0.initSkel(arg_6_0)
	arg_6_0.skel = widget.addAnimationByKey(arg_6_0.skelPos, "diaoyuchenggong/diaoyuchenggong.skel", "diaoyu", "effect", 1):scale(2)
end

return var_0_0
