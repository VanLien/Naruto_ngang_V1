local var_0_0 = {
	"fightingRankList",
	"commentRankList"
}
local var_0_1 = {
	TAB = 1,
	SCROLL = 2
}
local var_0_2 = 20
local var_0_3 = class("CommentRankView", Dialog)

var_0_3.RESOURCE_FILENAME = "card_comment_rank.json"
var_0_3.RESOURCE_BINDING = {
	["right.fightingRank.left"] = "fightingRankLeft",
	["left.item"] = "btnItem",
	["right.commentRank.right.item"] = "commentRankItem",
	["right.fightingRank.right.item"] = "fightingRankItem",
	["right.commentRank"] = "commentRank",
	["right.fightingRank"] = "fightingRank",
	["right.commentRank.left.pageItem"] = "pageItem",
	["right.commentRank.left.mask"] = "mask",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["left.item.selected.txt"] = {
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
	["left.list"] = {
		varname = "btnList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("btnDatas"),
				item = bindHelper.self("btnItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("normal")
					local var_1_1 = arg_1_1:get("selected")

					var_1_1:visible(arg_1_3.selected)
					var_1_0:visible(not arg_1_3.selected)
					var_1_0:get("txt"):text(arg_1_3.txt)
					var_1_1:get("txt"):text(arg_1_3.txt)

					local var_1_2 = var_1_0:getSize().height - 40

					adapt.setAutoText(var_1_0:get("txt"), arg_1_3.name, var_1_2)
					adapt.setAutoText(var_1_1:get("txt"), arg_1_3.name, var_1_2)
					var_1_1:get("txt"):getVirtualRenderer():setLineSpacing(-10)
					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onSelectClick")
			}
		}
	},
	["right.fightingRank.right.list"] = {
		varname = "fightingRankList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showData1"),
				item = bindHelper.self("fightingRankItem"),
				scrollState = bindHelper.self("scrollState"),
				itemAction = {
					isAction = true
				},
				onBeforeBuild = function(arg_2_0)
					arg_2_0.scrollState:set(false)
				end,
				onAfterBuild = function(arg_3_0)
					arg_3_0.scrollState:set(true)
				end,
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("rank", "txtRank", "head", "name", "vip", "lv", "lv1", "fighting", "card")

					if arg_4_2 <= 3 then
						var_4_0.rank:show()
						var_4_0.txtRank:hide()

						if arg_4_2 == 1 then
							var_4_0.rank:texture("city/rank/icon_jp.png")
						elseif arg_4_2 == 2 then
							var_4_0.rank:texture("city/rank/icon_yp.png")
						else
							var_4_0.rank:texture("city/rank/icon_tp.png")
						end
					else
						var_4_0.rank:hide()
						var_4_0.txtRank:show()
						var_4_0.txtRank:text(arg_4_2)
					end

					bind.extend(arg_4_0, var_4_0.head, {
						class = "role_logo",
						props = {
							level = false,
							vip = false,
							onNode = function(arg_5_0)
								arg_5_0:scale(0.8)
							end,
							logoId = arg_4_3.role.logo,
							frameId = arg_4_3.role.frame
						}
					})
					var_4_0.name:text(arg_4_3.role.name)
					var_4_0.lv1:text(arg_4_3.role.level)
					adapt.oneLinePos(var_4_0.lv, var_4_0.lv1, cc.p(5, 0))

					if arg_4_3.role.vip == false or arg_4_3.role.vip <= 0 then
						var_4_0.vip:hide()
					else
						var_4_0.vip:texture("common/icon/vip/icon_vip" .. arg_4_3.role.vip .. ".png")
					end

					var_4_0.fighting:text(arg_4_3.card.fighting_point)
					adapt.oneLinePos(var_4_0.name, var_4_0.vip, cc.p(5, 0))

					local var_4_1 = dataEasy.getUnitId(arg_4_3.card.card_id, arg_4_3.card.skin_id)
					local var_4_2 = csv.unit[var_4_1]

					bind.extend(arg_4_0, var_4_0.card, {
						class = "card_icon",
						props = {
							unitId = var_4_1,
							rarity = var_4_2.rarity,
							star = arg_4_3.card.star,
							advance = arg_4_3.card.advance,
							levelProps = {
								data = arg_4_3.card.level
							},
							onNode = function(arg_6_0)
								arg_6_0:scale(0.8)
								arg_6_0:xy(10, 10)
							end
						}
					})

					if gGameModel.role:read("id") ~= arg_4_3.role.id then
						bind.touch(arg_4_0, var_4_0.head, {
							methods = {
								ended = functools.partial(arg_4_0.headClick, var_4_0.head, arg_4_2, arg_4_3)
							}
						})
						bind.touch(arg_4_0, var_4_0.card, {
							methods = {
								ended = functools.partial(arg_4_0.clickCell, arg_4_2, arg_4_3)
							}
						})
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onClickItem"),
				headClick = bindHelper.self("onHeadClick")
			}
		}
	},
	["right.commentRank.right.list"] = {
		varname = "commentRankList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showData2"),
				item = bindHelper.self("commentRankItem"),
				scrollState = bindHelper.self("scrollState"),
				itemAction = {
					isAction = true
				},
				onBeforeBuild = function(arg_7_0)
					arg_7_0.scrollState:set(false)
				end,
				onAfterBuild = function(arg_8_0)
					arg_8_0.scrollState:set(true)
				end,
				onItem = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
					local var_9_0 = arg_9_1:multiget("rank", "txtRank", "card", "name", "score", "iconAttr1", "iconAttr2", "imgCompare")

					if arg_9_2 <= 3 then
						var_9_0.rank:show()
						var_9_0.txtRank:hide()

						if arg_9_2 == 1 then
							var_9_0.rank:texture("city/rank/icon_jp.png")
						elseif arg_9_2 == 2 then
							var_9_0.rank:texture("city/rank/icon_yp.png")
						else
							var_9_0.rank:texture("city/rank/icon_tp.png")
						end
					else
						var_9_0.rank:hide()
						var_9_0.txtRank:show()
						var_9_0.txtRank:text(arg_9_2)
					end

					local var_9_1 = {}

					for iter_9_0, iter_9_1 in csvPairs(csv.cards) do
						if matchLanguage(iter_9_1.languages) and iter_9_1.cardMarkID == arg_9_3.mark_id and csv.unit[iter_9_1.unitID] then
							table.insert(var_9_1, iter_9_1.unitID)
						end
					end

					local var_9_2 = csv.unit[math.max(unpack(var_9_1))]
					local var_9_3 = var_9_2.cardID
					local var_9_4 = var_9_2.rarity

					bind.extend(arg_9_0, var_9_0.card, {
						class = "card_icon",
						props = {
							cardId = var_9_3,
							rarity = var_9_4,
							onNode = function(arg_10_0)
								arg_10_0:scale(0.8)
								arg_10_0:xy(0, 0)
							end
						}
					})
					var_9_0.name:text(var_9_2.name)
					var_9_0.iconAttr1:texture(ui.ATTR_ICON[var_9_2.natureType])
					var_9_0.iconAttr2:hide()

					if var_9_2.natureType2 then
						var_9_0.iconAttr2:texture(ui.ATTR_ICON[var_9_2.natureType2]):show()
					end

					var_9_0.score:text(mathEasy.getPreciseDecimal(arg_9_3.score, 1))

					if arg_9_3.rank == arg_9_3.last_rank then
						var_9_0.imgCompare:texture("city/card/comment/logo_line.png")
					elseif arg_9_3.rank >= arg_9_3.last_rank then
						var_9_0.imgCompare:texture("common/icon/logo_arrow_red.png")
					else
						var_9_0.imgCompare:texture("common/icon/logo_arrow_green.png")
					end
				end
			}
		}
	},
	["right.commentRank.left.pageList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("evolutionDatas"),
				item = bindHelper.self("pageItem"),
				onItem = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
					arg_11_1:get("normal"):visible(arg_11_3.select ~= true)
					arg_11_1:get("select"):visible(arg_11_3.select == true)
				end,
				onAfterBuild = function(arg_12_0)
					arg_12_0:setItemAlignCenter()
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	["right.commentRank.left.scoreBg.txt1"] = {
		varname = "scoreTxt1"
	},
	["right.commentRank.left.scoreBg.txt2"] = {
		varname = "scoreTxt2"
	},
	["right.commentRank.left.scoreBg.txt3"] = {
		varname = "scoreTxt3"
	}
}

function var_0_3.onCreate(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0.cardId = arg_13_1
	arg_13_0.myrank = arg_13_2.rank
	arg_13_0.fightData = arg_13_2.ranks

	arg_13_0:initModel()

	if arg_13_0.fightData and table.maxn(arg_13_0.fightData) > 3 then
		local var_13_0 = {}

		for iter_13_0 = 1, 3 do
			var_13_0[iter_13_0] = arg_13_0.fightData[iter_13_0]
		end

		arg_13_0.fightData = var_13_0
	end

	arg_13_0.fightingRankList:setScrollBarEnabled(false)
	arg_13_0.commentRankList:setScrollBarEnabled(false)
	arg_13_0.commentRank:get("left"):hide()

	arg_13_0.isFightCanDown = true
	arg_13_0.isScoreCanDown = true
	arg_13_0.scrollState = idler.new(true)
	arg_13_0.datas = {}

	local var_13_1 = arg_13_0.fightData

	for iter_13_1 = 1, #var_0_0 do
		arg_13_0.datas[iter_13_1] = iter_13_1 == 1 and var_13_1 or {}
		arg_13_0["showData" .. iter_13_1] = idlers.newWithMap(arg_13_0.datas[iter_13_1])
	end

	arg_13_0.btnDatas = idlers.new(btnDatas)
	arg_13_0.showTab = idler.new(arg_13_0.fightData and arg_13_0.fightData[1] and 1 or 2)
	arg_13_0.evolutionDatas = idlers.new({})
	arg_13_0.scoreData = idlers.new({})
	arg_13_0.rankState = var_0_1.SCROLL

	local var_13_2 = {
		{
			selected = false,
			type = "fight",
			txt = gLanguageCsv.cardFightingRank
		},
		{
			selected = false,
			type = "score",
			txt = gLanguageCsv.cardCommentRank
		}
	}

	arg_13_0.btnDatas:update(var_13_2)
	arg_13_0.showTab:addListener(function(arg_14_0, arg_14_1, arg_14_2)
		arg_13_0.btnDatas:atproxy(arg_14_1).selected = false
		arg_13_0.btnDatas:atproxy(arg_14_0).selected = true

		arg_13_0.fightingRank:visible(arg_14_0 == 1)
		arg_13_0.commentRank:visible(arg_14_0 == 2)

		arg_13_0.rankState = var_0_1.TAB

		if arg_13_0.btnDatas:atproxy(arg_14_0).type and #arg_13_0.datas[arg_14_0] == 0 then
			arg_13_0:sendProtocol(arg_13_0.btnDatas:atproxy(arg_14_0).type, 0, arg_14_0, arg_13_0[var_0_0[arg_14_0]])
		end

		for iter_14_0, iter_14_1 in ipairs(var_0_0) do
			if iter_14_0 == arg_14_0 then
				arg_13_0[iter_14_1]:jumpToItem(0, cc.p(0, 1), cc.p(0, 1))
			end
		end
	end)

	if arg_13_0.fightData and arg_13_0.fightData[1] then
		arg_13_0:showFightingPanel()
	end

	for iter_13_2, iter_13_3 in ipairs(var_0_0) do
		local var_13_3 = arg_13_0[iter_13_3]:getInnerContainer()

		arg_13_0[iter_13_3]:onScroll(function(arg_15_0)
			if var_13_3:getPositionY() >= -10 and arg_13_0.scrollState:read() and not arg_13_0.isRequest and arg_13_0.btnDatas:atproxy(iter_13_2).type then
				if arg_13_0.isFightCanDown and arg_13_0.btnDatas:atproxy(iter_13_2).type == "fight" or arg_13_0.isScoreCanDown and arg_13_0.btnDatas:atproxy(iter_13_2).type == "score" then
					arg_13_0.rankState = var_0_1.SCROLL

					arg_13_0:sendProtocol(arg_13_0.btnDatas:atproxy(iter_13_2).type, #arg_13_0.datas[iter_13_2], iter_13_2, arg_13_0[iter_13_3])
				else
					gGameUI:showTip(gLanguageCsv.noMoreComment)
				end
			end
		end)
	end

	Dialog.onCreate(arg_13_0)
end

function var_0_3.initModel(arg_16_0)
	arg_16_0.roleName = gGameModel.role:read("name")
	arg_16_0.level = gGameModel.role:read("level")
	arg_16_0.vipLevel = gGameModel.role:read("vip_level")
	arg_16_0.roleId = gGameModel.role:read("id")
	arg_16_0.cards = gGameModel.role:read("cards")
end

function var_0_3.onSelectClick(arg_17_0, arg_17_1, arg_17_2)
	if not arg_17_0.fightData or not arg_17_0.fightData[1] then
		gGameUI:showTip(gLanguageCsv.cantViewFightingRank)
	else
		arg_17_0.showTab:set(arg_17_2)
	end
end

function var_0_3.initData(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	if arg_18_0.rankState == var_0_1.SCROLL then
		if arg_18_5 == "fight" and #arg_18_1 < var_0_2 then
			arg_18_0.isFightCanDown = false
		elseif arg_18_5 == "score" and #arg_18_1 < var_0_2 then
			arg_18_0.isScoreCanDown = false
		end
	end

	if arg_18_2 == 0 then
		arg_18_0.datas[arg_18_3] = arg_18_1
	else
		for iter_18_0, iter_18_1 in ipairs(arg_18_1) do
			table.insert(arg_18_0.datas[arg_18_3], iter_18_1)
		end
	end

	arg_18_0["showData" .. arg_18_3]:update(arg_18_0.datas[arg_18_3])
	gGameUI:disableTouchDispatch(0.01)

	local var_18_0 = arg_18_0.showTab:read() == 1 and 3 or 4

	arg_18_4:jumpToItem(arg_18_2 - var_18_0, cc.p(0, 1), cc.p(0, 1))
end

function var_0_3.sendProtocol(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	arg_19_0.isRequest = true

	local var_19_0 = 200

	if arg_19_1 == "fight" then
		-- block empty
	elseif arg_19_1 == "score" then
		gGameApp:requestServer("/game/card/score/rank", function(arg_20_0)
			if arg_19_2 == 0 then
				arg_19_0.scoreOne = arg_20_0.view.ranks[1]

				arg_19_0:showCommentPanel()
			end

			performWithDelay(arg_19_0, function()
				arg_19_0.isRequest = false
			end, 0.1)
			arg_19_0:initData(arg_20_0.view.ranks, arg_19_2, arg_19_3, arg_19_4, arg_19_1)
		end, arg_19_2, var_19_0 < arg_19_2 + var_0_2 and var_19_0 - arg_19_2 or var_0_2)
	end
end

function var_0_3.showFightingPanel(arg_22_0)
	arg_22_0.fightOne = arg_22_0.fightData[1]

	local var_22_0 = dataEasy.getUnitCsv(arg_22_0.fightOne.card.card_id, arg_22_0.fightOne.card.skin_id)
	local var_22_1 = arg_22_0.fightingRank:get("left"):multiget("cardName", "cardIcon", "roleName", "lv", "lv1", "fighting", "fighting1")

	var_22_1.cardName:text(var_22_0.name)
	var_22_1.roleName:text(arg_22_0.fightOne.role.name)
	var_22_1.lv1:text(arg_22_0.fightOne.role.level)
	adapt.oneLineCenterPos(cc.p(370, 120), {
		var_22_1.roleName,
		var_22_1.lv,
		var_22_1.lv1
	}, cc.p(10, 0))
	var_22_1.fighting1:text(arg_22_0.fightOne.card.fighting_point)
	adapt.oneLinePos(var_22_1.fighting, var_22_1.fighting1)

	local var_22_2 = var_22_1.cardIcon
	local var_22_3 = var_22_2:size()
	local var_22_4 = gRoleFigureCsv[arg_22_0.fightOne.role.figure]
	local var_22_5 = string.gsub(var_22_0.unitRes, ".skel", "_ui.skel")

	widget.addAnimationByKey(var_22_2, var_22_5, "card", "standby_loop", -1):xy(var_22_3.width / 2, 130):scale(var_22_0.scaleU * 0.5):setSkin(var_22_0.skin)

	if gGameModel.role:read("id") ~= arg_22_0.fightOne.role.id then
		bind.touch(arg_22_0, var_22_2, {
			methods = {
				ended = function()
					arg_22_0:onHeadClick(nil, var_22_2, nil, arg_22_0.fightOne)
				end
			}
		})
	end

	bind.extend(arg_22_0, var_22_2, {
		event = "extend",
		class = "role_title",
		props = {
			data = arg_22_0.fightOne.role.title,
			onNode = function(arg_24_0)
				arg_24_0:xy(var_22_3.width / 2, var_22_3.height - 50)
				arg_24_0:scale(1.2)
				arg_24_0:z(3)
			end
		}
	})

	local var_22_6 = arg_22_0.fightingRank:get("right.myRank"):multiget("txtRank", "rank", "head", "name", "vip", "lv", "lv1", "fighting", "card")

	bind.extend(arg_22_0, var_22_6.head, {
		class = "role_logo",
		props = {
			level = false,
			vip = false,
			onNode = function(arg_25_0)
				arg_25_0:scale(0.8)
			end,
			logoId = gGameModel.role:read("logo"),
			frameId = gGameModel.role:read("frame")
		}
	})
	var_22_6.name:text(arg_22_0.roleName)

	if arg_22_0.myrank > 0 then
		var_22_6.txtRank:text(arg_22_0.myrank)

		if arg_22_0.myrank <= 3 then
			var_22_6.rank:show()
			var_22_6.txtRank:hide()

			if arg_22_0.myrank == 1 then
				var_22_6.rank:texture("city/rank/icon_jp.png")
			elseif arg_22_0.myrank == 2 then
				var_22_6.rank:texture("city/rank/icon_yp.png")
			else
				var_22_6.rank:texture("city/rank/icon_tp.png")
			end
		else
			var_22_6.rank:hide()
			var_22_6.txtRank:show()
			var_22_6.txtRank:text(arg_22_0.myrank)
			text.addEffect(var_22_6.txtRank, {
				color = cc.c4b(91, 84, 91, 255)
			})
			var_22_6.txtRank:setFontSize(60)
		end
	else
		var_22_6.rank:hide()
	end

	local var_22_7 = 0
	local var_22_8

	for iter_22_0, iter_22_1 in pairs(arg_22_0.cards) do
		local var_22_9 = gGameModel.cards:find(iter_22_1)

		if csv.cards[arg_22_0.cardId].cardMarkID == csv.cards[var_22_9:read("card_id")].cardMarkID and var_22_7 < var_22_9:read("fighting_point") then
			var_22_8 = var_22_9:read("card_id", "skin_id", "fighting_point", "level", "star", "advance")
			var_22_7 = var_22_8.fighting_point
		end
	end

	if var_22_7 == 0 then
		var_22_6.fighting:text(gLanguageCsv.commentFightingRankTip)
	else
		var_22_6.fighting:text(var_22_7)

		local var_22_10 = dataEasy.getUnitId(var_22_8.card_id, var_22_8.skin_id)
		local var_22_11 = csv.unit[var_22_10]

		bind.extend(arg_22_0, var_22_6.card, {
			class = "card_icon",
			props = {
				unitId = var_22_10,
				rarity = var_22_11.rarity,
				star = var_22_8.star,
				advance = var_22_8.advance,
				levelProps = {
					data = var_22_8.level
				},
				onNode = function(arg_26_0)
					arg_26_0:scale(0.8)
					arg_26_0:xy(10, 10)
				end
			}
		})
	end

	if arg_22_0.vipLevel == false or arg_22_0.vipLevel <= 0 then
		var_22_6.vip:hide()
	else
		var_22_6.vip:texture(ui.VIP_ICON[arg_22_0.vipLevel]):show()
	end

	var_22_6.lv1:text(arg_22_0.level)
	adapt.oneLinePos(var_22_6.name, var_22_6.vip, cc.p(3, 0), "left")
	adapt.oneLinePos(var_22_6.lv, var_22_6.lv1, cc.p(0, 0), "left")
end

function var_0_3.showCommentPanel(arg_27_0)
	arg_27_0.commentRank:get("left"):show()

	local var_27_0 = csv.cards[arg_27_0.scoreOne.mark_id].unitID
	local var_27_1 = csv.unit[var_27_0]
	local var_27_2 = arg_27_0.commentRank:get("left"):multiget("cardIcon", "rare", "name", "iconAttr1", "iconAttr2", "scoreBg")

	arg_27_0.scoreTxt2:text(mathEasy.getPreciseDecimal(arg_27_0.scoreOne.score, 1))

	if arg_27_0.scoreOne.rank == arg_27_0.scoreOne.last_rank then
		var_27_2.scoreBg:get("img"):texture("city/card/comment/logo_line.png")
	elseif arg_27_0.scoreOne.rank >= arg_27_0.scoreOne.last_rank then
		var_27_2.scoreBg:get("img"):texture("common/icon/logo_arrow_red.png")
	else
		var_27_2.scoreBg:get("img"):texture("common/icon/logo_arrow_green.png")
	end

	adapt.oneLineCenter(arg_27_0.scoreTxt2, arg_27_0.scoreTxt1, arg_27_0.scoreTxt3, cc.p(10, 0))
	adapt.oneLinePos(arg_27_0.scoreTxt3, var_27_2.scoreBg:get("img"), cc.p(5, -5))

	local var_27_3 = csv.cards[arg_27_0.scoreOne.mark_id]
	local var_27_4 = {}

	for iter_27_0, iter_27_1 in orderCsvPairs(csv.cards) do
		if matchLanguage(iter_27_1.languages) and iter_27_1.cardMarkID == var_27_3.cardMarkID and iter_27_1.canDevelop then
			table.insert(var_27_4, {
				cfg = iter_27_1,
				id = iter_27_0
			})
		end
	end

	table.sort(var_27_4, function(arg_28_0, arg_28_1)
		return arg_28_0.id < arg_28_1.id
	end)
	arg_27_0.evolutionDatas:update(var_27_4)

	local var_27_5 = 0

	for iter_27_2, iter_27_3 in ipairs(var_27_4) do
		if iter_27_3.id == var_27_3.id then
			var_27_5 = iter_27_2
		end
	end

	arg_27_0.selectEvolution = idler.new(var_27_5)

	arg_27_0.selectEvolution:addListener(function(arg_29_0, arg_29_1)
		local var_29_0 = arg_27_0.evolutionDatas:atproxy(arg_29_0)
		local var_29_1 = arg_27_0.evolutionDatas:atproxy(arg_29_1)

		if var_29_1 then
			var_29_1.select = false
		end

		if var_29_0 then
			local var_29_2 = csv.unit[var_29_0.cfg.unitID]
			local var_29_3 = var_27_2.cardIcon:size()

			var_27_2.cardIcon:removeAllChildren()

			local var_29_4 = string.gsub(var_29_2.unitRes, ".skel", "_ui.skel")

			widget.addAnimation(var_27_2.cardIcon, var_29_4, "standby_loop", 1):xy(var_29_3.width / 2, 130):scale(var_29_2.scaleU * 0.5):setSkin(var_29_2.skin)
			var_27_2.rare:texture(ui.RARITY_ICON[var_27_1.rarity])
			var_27_2.name:text(var_29_0.cfg.name)
			var_27_2.iconAttr1:texture(ui.ATTR_ICON[var_27_1.natureType])
			var_27_2.iconAttr2:hide()

			if var_27_1.natureType2 then
				var_27_2.iconAttr2:texture(ui.ATTR_ICON[var_27_1.natureType2]):show()
			end

			adapt.oneLineCenterPos(cc.p(380, var_27_2.name:y()), {
				var_27_2.rare,
				var_27_2.name,
				var_27_2.iconAttr1,
				var_27_2.iconAttr2
			}, cc.p(15, 0))

			var_29_0.select = true
		end
	end)
	arg_27_0:initPrivilegeListener()
end

function var_0_3.initPrivilegeListener(arg_30_0)
	uiEasy.addTouchOneByOne(arg_30_0.mask, {
		ended = function(arg_31_0, arg_31_1, arg_31_2)
			if math.abs(arg_31_1) > 100 and math.abs(arg_31_1) > math.abs(arg_31_2) then
				local var_31_0 = arg_31_1 > 0 and -1 or 1

				arg_30_0.selectEvolution:modify(function(arg_32_0)
					arg_32_0 = cc.clampf(arg_32_0 + var_31_0, 1, arg_30_0.evolutionDatas:size())

					return true, arg_32_0
				end)
			end
		end
	})
end

function var_0_3.onHeadClick(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
	local var_33_0, var_33_1 = arg_33_2:xy()
	local var_33_2 = arg_33_2:getParent():convertToWorldSpace(cc.p(var_33_0 - 100, var_33_1))

	gGameUI:stackUI("city.chat.personal_info", nil, nil, var_33_2, arg_33_4)
end

function var_0_3.onClickItem(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	if arg_34_3.cardId == -1 then
		return
	end

	gGameApp:requestServer("/game/card_info", function(arg_35_0)
		gGameUI:stackUI("city.card.info", nil, nil, arg_35_0.view)
	end, arg_34_3.card.id)
end

return var_0_3
