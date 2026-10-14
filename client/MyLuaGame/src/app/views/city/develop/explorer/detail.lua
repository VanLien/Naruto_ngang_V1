local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("ExploreDetailView", Dialog)
local var_0_2 = require("app.views.city.develop.explorer.tools")

var_0_1.RESOURCE_FILENAME = "explore_detail_view.json"
var_0_1.RESOURCE_BINDING = {
	name = "nodeName",
	left = "leftName",
	rightList = "rightList",
	pos = "pos",
	leftList = "leftList",
	item1 = "item1",
	activeTip = "activeTip",
	arrow = "arrow",
	right = "rightName",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	title = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	title1 = {
		varname = "title1",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	bottomList = {
		varname = "listview",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 20,
				padding = 20,
				data = bindHelper.self("upgradeData"),
				dataOrderCmp = dataEasy.sortItemCmp,
				item = bindHelper.self("item1"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("add", "mask")

					bind.extend(arg_1_0, arg_1_1, {
						class = "icon_key",
						props = {
							data = {
								key = arg_1_3.id,
								num = arg_1_3.num,
								targetNum = arg_1_3.targetNum
							},
							grayState = arg_1_3.targetNum > arg_1_3.num and 3 or 0,
							onNode = function(arg_2_0)
								if arg_1_3.targetNum > arg_1_3.num then
									bind.click(arg_1_0, arg_2_0, {
										method = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
									})
								end
							end
						}
					})
					var_1_0.mask:hide()
					var_1_0.add:visible(arg_1_3.targetNum > arg_1_3.num)
				end,
				onAfterBuild = function(arg_3_0)
					arg_3_0:setClippingEnabled(false)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemMaskClick")
			}
		}
	},
	btn = {
		varname = "btn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnClick")
			}
		}
	},
	["btn.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1)
	arg_4_0:initModel()

	arg_4_0.detailSendParams = arg_4_1
	arg_4_0.data = arg_4_1()
	arg_4_0.minLevel = var_0_2.getMinComponentLevel(arg_4_0.data.components)

	arg_4_0.nodeName:text(arg_4_0.data.cfg.name)
	text.addEffect(arg_4_0.nodeName, {
		color = ui.COLORS.QUALITY[arg_4_0.data.cfg.quality]
	})

	if arg_4_0.data.advance == 0 then
		arg_4_0.title1:text(gLanguageCsv.active)
		arg_4_0.leftName:text(gLanguageCsv.notActivatedTip)
		arg_4_0.rightName:text("+1")
		text.addEffect(arg_4_0.leftName, {
			color = ui.COLORS.NORMAL.GRAY
		})
		arg_4_0.activeTip:visible(arg_4_0.minLevel == 0)
		arg_4_0.btn:get("title"):text(gLanguageCsv.spaceActive)
		arg_4_0.activeTip:text(gLanguageCsv.collectAllComponentsCanActive)
	else
		text.addEffect(arg_4_0.leftName, {
			color = ui.COLORS.NORMAL.DEFAULT
		})
		arg_4_0.leftName:text("+" .. arg_4_0.data.advance)
		arg_4_0.leftName:setFontSize(60)
		arg_4_0.rightName:text("+" .. arg_4_0.data.advance + 1)
		arg_4_0.btn:get("title"):text(gLanguageCsv.spaceAdvance)

		local var_4_0 = false

		if arg_4_0.data.advance >= arg_4_0.minLevel then
			arg_4_0.activeTip:text(string.format(gLanguageCsv.allComponentsNeedLevelCondition, arg_4_0.data.advance + 1))

			var_4_0 = true
		end

		arg_4_0.activeTip:visible(var_4_0)
		arg_4_0.title1:text(gLanguageCsv.talentAdvance)
	end

	adapt.setTextAdaptWithSize(arg_4_0.activeTip, {
		margin = -8,
		horizontal = "center",
		vertical = "center",
		size = cc.size(550, 200)
	})

	if matchLanguage({
		"cn",
		"tw"
	}) then
		adapt.oneLinePos(arg_4_0.nodeName, {
			arg_4_0.leftName,
			arg_4_0.arrow,
			arg_4_0.rightName
		}, {
			cc.p(10, 0)
		})
	else
		arg_4_0.nodeName:y(arg_4_0.nodeName:y() + 60)
		arg_4_0.leftName:x(arg_4_0.nodeName:x())
		adapt.oneLinePos(arg_4_0.leftName, {
			arg_4_0.arrow,
			arg_4_0.rightName
		}, {
			cc.p(10, 0)
		})
	end

	if string.find(arg_4_0.data.cfg.res, "skel") then
		widget.addAnimationByKey(arg_4_0.pos, arg_4_0.data.cfg.res, "explorer", "effect_loop", 1011):xy(300, 100):scale(2)
	else
		local var_4_1 = ccui.ImageView:create(arg_4_0.data.cfg.res):alignCenter(arg_4_0.pos:size()):addTo(arg_4_0.pos, 1)
	end

	var_0_2.effectShow(arg_4_0.leftList, arg_4_0.rightList, arg_4_0.data)

	local var_4_2 = {}

	arg_4_0.isCanUp = true

	for iter_4_0, iter_4_1 in csvMapPairs(csv.explorer.explorer_advance[arg_4_0.data.advance + 1]["costItemMap" .. arg_4_0.data.cfg.advanceCostSeq]) do
		table.insert(var_4_2, {
			id = iter_4_0,
			targetNum = iter_4_1,
			num = dataEasy.getNumByKey(iter_4_0)
		})

		if arg_4_0.isCanUp then
			arg_4_0.isCanUp = iter_4_1 <= dataEasy.getNumByKey(iter_4_0)
		end
	end

	arg_4_0.upgradeData = idlertable.new(var_4_2)

	Dialog.onCreate(arg_4_0)
end

function var_0_1.initModel(arg_5_0)
	arg_5_0.items = gGameModel.role:getIdler("items")
	arg_5_0.coin4 = gGameModel.role:getIdler("coin4")
end

function var_0_1.sendParams(arg_6_0)
	return arg_6_0.data
end

function var_0_1.onBtnClick(arg_7_0)
	if arg_7_0.data.advance >= arg_7_0.minLevel then
		gGameUI:showTip(gLanguageCsv.oneOrMoreNotReachCondition)

		return
	end

	if not arg_7_0.isCanUp then
		gGameUI:showTip(gLanguageCsv.inadequateProps)

		return
	end

	gGameApp:requestServer("/game/explorer/advance", function(arg_8_0)
		local var_8_0 = arg_7_0.detailSendParams()

		var_0_0.onClose(arg_7_0)
		gGameUI:stackUI("city.develop.explorer.success", nil, nil, var_8_0)
	end, arg_7_0.data.id)
end

function var_0_1.onItemMaskClick(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	gGameUI:stackUI("common.gain_way", nil, {
		dialog = true
	}, arg_9_3.id, nil, arg_9_3.targetNum)
end

return var_0_1
