local var_0_0 = 20
local var_0_1 = {
	OPEN = 3,
	DEL = 2,
	REFRESH = 4,
	SEND = 1
}
local var_0_2 = {
	"common/icon/logo_arrow_green.png",
	"city/card/comment/logo_line.png",
	"common/icon/logo_arrow_red.png"
}
local var_0_3 = cc.load("mvc").ViewBase
local var_0_4 = class("CardCommentView", var_0_3)

var_0_4.RESOURCE_FILENAME = "card_comment.json"
var_0_4.RESOURCE_BINDING = {
	["center.star"] = "star",
	["right.item.top"] = "textItemTop",
	["center.starDesc"] = "starDesc",
	["center.pageItem"] = "pageItem",
	["right.item.list"] = "textItemList",
	["right.item.bottom.btnLike"] = "btnLike",
	["center.scoreBg.img"] = "scoreImg",
	center = "center",
	["right.textInput"] = "textInput",
	["right.noComment"] = "noComment",
	mask = "mask",
	["right.btnComment"] = "btnComment",
	["right.item"] = "commentItem",
	["right.item.bg"] = "textItemBg",
	["right.item.head"] = "textItemHead",
	["right.item.bottom.btnDislike"] = "btnDislike",
	["right.list"] = {
		varname = "commentList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				disableOnScroll = true,
				data = bindHelper.self("commentData"),
				item = bindHelper.self("commentItem"),
				scrollState = bindHelper.self("scrollState"),
				preloadCenter = bindHelper.self("preloadCenter"),
				isEnd = bindHelper.self("isEnd"),
				itemAction = {
					isAction = true
				},
				onBeforeBuild = function(arg_1_0)
					arg_1_0.scrollState:set(false)
					arg_1_0:setRenderHint(0)
				end,
				onAfterBuild = function(arg_2_0)
					arg_2_0.scrollState:set(true)
				end,
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					if arg_3_2 == itertools.size(arg_3_0.data) then
						arg_3_0.isEnd:set(true)
					end

					local var_3_0 = arg_3_1:multiget("head", "list", "top", "bottom", "bg")
					local var_3_1 = var_3_0.head:multiget("head", "lv", "lv1")
					local var_3_2 = var_3_0.top:multiget("name", "vip", "btnDel", "tag", "tag2")
					local var_3_3 = var_3_0.bottom:multiget("btnMore", "time", "txtLike", "txtDislike", "btnLike", "btnDislike")

					bind.extend(arg_3_0, var_3_1.head, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_3_3.logo,
							frameId = arg_3_3.frame,
							onNode = function(arg_4_0)
								arg_4_0:xy(104, 95):z(6):scale(0.9)
							end
						}
					})
					var_3_1.lv1:text(arg_3_3.level)
					adapt.oneLinePos(var_3_1.lv, var_3_1.lv1, cc.p(0, 0), "left")
					var_3_2.name:text(arg_3_3.name)
					var_3_2.vip:hide()
					adapt.oneLinePos(var_3_2.name, var_3_2.vip, cc.p(10, 0), "left")
					var_3_2.tag:hide()
					var_3_2.tag2:hide()
					var_3_2.btnDel:hide()

					if arg_3_3.key == "hot" then
						var_3_2.tag:texture("city/card/comment/logo_hot_pl.png"):show()

						if gGameModel.role:read("id") == arg_3_3.val.role_db_id then
							var_3_2.tag2:texture("city/card/comment/logo_zi_pl.png"):show()
							var_3_2.btnDel:show()
						end
					elseif arg_3_3.key == "my" then
						var_3_2.tag:texture("city/card/comment/logo_zi_pl.png"):show()
						var_3_2.btnDel:show()
					end

					local var_3_4, var_3_5 = beauty.textScroll({
						align = "left",
						list = var_3_0.list,
						strs = arg_3_3.val.content
					})

					var_3_0.list:setTouchEnabled(false)

					local var_3_6 = var_3_4:size().height
					local var_3_7 = var_3_3.btnMore:get("normal")
					local var_3_8 = var_3_3.btnMore:get("select")

					if var_3_5 > arg_3_3.listH then
						if var_3_6 > arg_3_3.listH then
							var_3_7:hide()
							var_3_8:show()
						else
							var_3_7:show()
							var_3_8:hide()
						end
					else
						var_3_7:hide()
						var_3_8:hide()
					end

					local function var_3_9()
						arg_3_1:height(arg_3_3.nodeH + (var_3_5 - arg_3_3.listH))
						var_3_0.bg:height(arg_3_3.bgH + (var_3_5 - arg_3_3.listH))
						var_3_0.bg:y(arg_3_3.bgY + (var_3_5 - arg_3_3.listH))
						var_3_4:height(var_3_5)
						var_3_0.top:y(arg_3_3.topY + (var_3_5 - arg_3_3.listH))
						var_3_0.head:y(arg_3_3.headY + (var_3_5 - arg_3_3.listH))
						arg_3_0:refreshView()
						var_3_8:show()
						var_3_7:hide()
					end

					bind.click(arg_3_1, var_3_7, {
						method = function()
							var_3_9()

							arg_3_3.switch = true
						end
					})

					if arg_3_3.switch then
						var_3_9()
					end

					bind.click(arg_3_1, var_3_8, {
						method = function()
							arg_3_1:height(arg_3_3.nodeH)
							var_3_0.bg:height(arg_3_3.bgH)
							var_3_0.bg:y(arg_3_3.bgY)
							var_3_4:height(arg_3_3.listH)
							var_3_0.top:y(arg_3_3.topY)
							var_3_0.head:y(arg_3_3.headY)
							arg_3_0:refreshView()
							var_3_7:show()
							var_3_8:hide()

							arg_3_3.switch = false
						end
					})

					local var_3_10 = time.getDate(arg_3_3.val.time)

					var_3_3.time:text(var_3_10.year .. "-" .. var_3_10.month .. "-" .. var_3_10.day .. "  " .. var_3_10.hour .. ":" .. var_3_10.min)
					var_3_3.txtLike:text(arg_3_3.val.like)
					var_3_3.txtDislike:text(arg_3_3.val.dislike)

					local var_3_11 = {
						listH = arg_3_3.listH,
						nodeH = arg_3_3.nodeH,
						bgH = arg_3_3.bgH,
						bgY = arg_3_3.bgY,
						topY = arg_3_3.topY,
						headY = arg_3_3.headY
					}

					bind.touch(arg_3_1, var_3_2.btnDel, {
						methods = {
							ended = functools.partial(arg_3_0.btnDelClick, arg_3_1, var_3_0, var_3_4, var_3_11, arg_3_3)
						}
					})

					if gGameModel.role:read("id") ~= arg_3_3.val.role_db_id then
						bind.touch(arg_3_1, var_3_1.head, {
							methods = {
								ended = functools.partial(arg_3_0.headClick, var_3_0.head, arg_3_2, arg_3_3)
							}
						})
					end

					var_3_3.btnLike:get("select"):visible(arg_3_3.like)
					var_3_3.btnLike:get("normal"):visible(not arg_3_3.like)
					var_3_3.btnDislike:get("select"):visible(arg_3_3.dislike)
					var_3_3.btnDislike:get("normal"):visible(not arg_3_3.dislike)
					bind.touch(arg_3_1, var_3_3.btnLike, {
						methods = {
							ended = functools.partial(arg_3_0.likeClick, arg_3_2, arg_3_3, arg_3_3.like)
						}
					})
					bind.touch(arg_3_1, var_3_3.btnDislike, {
						methods = {
							ended = functools.partial(arg_3_0.dislikeClick, arg_3_2, arg_3_3, arg_3_3.dislike)
						}
					})
				end
			},
			handlers = {
				btnDelClick = bindHelper.self("onBtnDel"),
				headClick = bindHelper.self("onHeadClick"),
				likeClick = bindHelper.self("onLikeClick"),
				dislikeClick = bindHelper.self("onDislikeClick")
			}
		}
	},
	["center.pageList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("evolutionDatas"),
				item = bindHelper.self("pageItem"),
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					arg_8_1:get("normal"):visible(arg_8_3.select ~= true)
					arg_8_1:get("select"):visible(arg_8_3.select == true)
				end,
				onAfterBuild = function(arg_9_0)
					arg_9_0:setItemAlignCenter()
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	["left.btnRank"] = {
		varname = "btnRank",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRank")
			}
		}
	},
	["left.btnRank.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["center.scoreBg.txt1"] = {
		varname = "scoreTxt1"
	},
	["center.scoreBg.txt2"] = {
		varname = "scoreTxt2"
	},
	["center.scoreBg.txt3"] = {
		varname = "scoreTxt3"
	},
	["right.btnComment.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_4.onCreate(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	gGameUI.topuiManager:createView("title", arg_10_0, {
		onClose = arg_10_0:createHandler("onClose")
	}):init({
		subTitle = "COMMENT",
		title = gLanguageCsv.comment
	})

	arg_10_0.cardId = arg_10_1
	arg_10_0.score = arg_10_3
	arg_10_0.data = arg_10_2
	arg_10_0.textItemListH = arg_10_0.textItemList:size().height
	arg_10_0.itemListH = arg_10_0.commentItem:size().height
	arg_10_0.textItemBgH = arg_10_0.textItemBg:size().height
	arg_10_0.textItemBgY = arg_10_0.textItemBg:y()
	arg_10_0.textItemTopY = arg_10_0.textItemTop:y()
	arg_10_0.textItemHeadY = arg_10_0.textItemHead:y()

	arg_10_0.commentItem:get("list"):setScrollBarEnabled(false)

	arg_10_0.preloadCenter = idler.new(0)
	arg_10_0.isEnd = idler.new(false)

	arg_10_0:initModel()
	idlereasy.when(arg_10_0.cardCommentCounter, function(arg_11_0, arg_11_1)
		local var_11_0 = {}

		for iter_11_0, iter_11_1 in pairs(arg_11_1) do
			local var_11_1 = csv.cards[iter_11_0]

			if not var_11_0[var_11_1.cardMarkID] then
				var_11_0[var_11_1.cardMarkID] = 0
			end

			var_11_0[var_11_1.cardMarkID] = var_11_0[var_11_1.cardMarkID] + iter_11_1
		end

		arg_10_0.commentCounter = var_11_0
	end)

	arg_10_0.evolutionDatas = idlers.new()
	arg_10_0.commentData = idlers.new()
	arg_10_0.isCanDown = true
	arg_10_0.scrollState = idler.new(true)
	arg_10_0.commentState = var_0_1.OPEN

	arg_10_0:commentListData()
	idlereasy.when(arg_10_0.commentData, function(arg_12_0, arg_12_1)
		arg_10_0.noComment:visible(not arg_10_2.my[1] and not arg_10_2.new[1] and not arg_10_2.hot[1])
	end)
	arg_10_0:initCard()
	arg_10_0:initComment()

	local var_10_0 = arg_10_0.commentList:getInnerContainer()

	arg_10_0.commentList:onScroll(function(arg_13_0)
		local var_13_0 = var_10_0:getPositionY()

		if (arg_13_0.name == "SCROLL_TO_TOP" or arg_13_0.name == "SCROLL_TO_BOTTOM") and arg_10_0.commentList.quickFor then
			arg_10_0.commentList:quickFor()
			arg_10_0.scrollState:set(true)
		elseif var_13_0 >= -10 and arg_10_0.scrollState:read() and not arg_10_0.isRequest then
			if arg_10_0.isCanDown then
				arg_10_0.isEnd:set(false)

				arg_10_0.commentState = var_0_1.OPEN

				arg_10_0:sendProtocol()
			elseif arg_10_0.isEnd:read() then
				gGameUI:showTip(gLanguageCsv.noMoreComment)
			end
		end
	end)
end

function var_0_4.initData(arg_14_0, arg_14_1)
	if arg_14_0.commentState == var_0_1.OPEN then
		arg_14_0.isCanDown = #arg_14_1.new == var_0_0
	end

	if arg_14_0.commentState == var_0_1.REFRESH then
		arg_14_0.data.new = {}
	end

	arg_14_0.data.hot = arg_14_1.hot
	arg_14_0.data.my = arg_14_1.my

	for iter_14_0, iter_14_1 in ipairs(arg_14_1.new) do
		table.insert(arg_14_0.data.new, iter_14_1)
	end

	for iter_14_2, iter_14_3 in pairs(arg_14_1.like) do
		arg_14_0.data.like[iter_14_2] = iter_14_3
	end

	for iter_14_4, iter_14_5 in pairs(arg_14_1.dislike) do
		arg_14_0.data.dislike[iter_14_4] = iter_14_5
	end

	for iter_14_6, iter_14_7 in pairs(arg_14_1.roles) do
		arg_14_0.data.roles[iter_14_6] = iter_14_7
	end

	arg_14_0:commentListData()
end

function var_0_4.sendProtocol(arg_15_0)
	if arg_15_0.commentState == var_0_1.OPEN then
		arg_15_0.isCanDown = false
	end

	arg_15_0.isRequest = true

	local var_15_0 = #arg_15_0.data.new
	local var_15_1 = arg_15_0.commentState == var_0_1.OPEN and var_0_0 or 0

	if arg_15_0.commentState == var_0_1.REFRESH then
		var_15_0 = 0
		var_15_1 = #arg_15_0.data.new
	end

	gGameApp:requestServer("/game/card/comment/list", function(arg_16_0)
		performWithDelay(arg_15_0, function()
			arg_15_0.isRequest = false
		end, 0.1)
		arg_15_0:initData(arg_16_0.view)
	end, arg_15_0.cardId, var_15_0, var_15_1)
end

function var_0_4.initCard(arg_18_0)
	local var_18_0 = arg_18_0.cardId
	local var_18_1 = arg_18_0.center:multiget("cardIcon", "rare", "name", "iconAttr1", "iconAttr2")
	local var_18_2 = csv.cards[var_18_0].unitID
	local var_18_3 = csv.unit[var_18_2]
	local var_18_4 = csv.cards[arg_18_0.cardId]
	local var_18_5 = {}

	for iter_18_0, iter_18_1 in orderCsvPairs(csv.cards) do
		if matchLanguage(iter_18_1.languages) and iter_18_1.cardMarkID == var_18_4.cardMarkID and iter_18_1.canDevelop and gHandbookCsv[iter_18_0].isOpen then
			table.insert(var_18_5, {
				existCards = existCards,
				selectDevelop = iter_18_1.develop,
				cfg = iter_18_1,
				id = iter_18_0
			})
		end
	end

	table.sort(var_18_5, function(arg_19_0, arg_19_1)
		return arg_19_0.id < arg_19_1.id
	end)
	arg_18_0.evolutionDatas:update(var_18_5)

	local var_18_6 = 0

	for iter_18_2, iter_18_3 in ipairs(var_18_5) do
		if iter_18_3.id == var_18_4.id then
			var_18_6 = iter_18_2
		end
	end

	arg_18_0.selectEvolution = idler.new(var_18_6)

	arg_18_0.selectEvolution:addListener(function(arg_20_0, arg_20_1)
		local var_20_0 = arg_18_0.evolutionDatas:atproxy(arg_20_0)
		local var_20_1 = arg_18_0.evolutionDatas:atproxy(arg_20_1)

		if var_20_1 then
			var_20_1.select = false
		end

		if var_20_0 then
			itertools.invoke(var_18_1, "show")

			local var_20_2 = csv.unit[var_20_0.cfg.unitID]
			local var_20_3 = var_18_1.cardIcon:size()

			var_18_1.cardIcon:removeAllChildren()

			local var_20_4 = string.gsub(var_20_2.unitRes, ".skel", "_ui.skel")

			widget.addAnimation(var_18_1.cardIcon, var_20_4, "standby_loop", 1):xy(var_20_3.width / 2, -180):scale(var_20_2.scaleU * 0.7):setSkin(var_20_2.skin)
			var_18_1.name:text(var_20_0.cfg.name)
			var_18_1.rare:texture(ui.RARITY_ICON[var_20_2.rarity])
			adapt.oneLineCenterPos(cc.p(290, var_18_1.name:y()), {
				var_18_1.rare,
				var_18_1.name,
				var_18_1.iconAttr1
			}, cc.p(15, 0))
			var_18_1.iconAttr1:texture(ui.ATTR_ICON[var_20_2.natureType])
			var_18_1.iconAttr2:hide()

			if var_20_2.natureType2 then
				var_18_1.iconAttr2:texture(ui.ATTR_ICON[var_20_2.natureType2]):show()
				adapt.oneLinePos(var_18_1.iconAttr1, var_18_1.iconAttr2, cc.p(15, 0), "left")
			end

			arg_18_0.noComment:get("img1.txt"):text(string.format(gLanguageCsv.noComment, var_20_0.cfg.name))
			arg_18_0.noComment:get("img1.txt"):size(457, 140)

			var_20_0.select = true
		else
			itertools.invoke(var_18_1, "hide")
		end
	end)
	arg_18_0:initPrivilegeListener()
	arg_18_0:initGrade()
end

function var_0_4.onBtnRank(arg_21_0)
	gGameApp:requestServer("/game/card/fight/rank", function(arg_22_0)
		gGameUI:stackUI("city.card.comment_rank", nil, nil, arg_21_0.cardId, arg_22_0.view)
	end, arg_21_0.cardId, 0, 20)
end

function var_0_4.initPrivilegeListener(arg_23_0)
	uiEasy.addTouchOneByOne(arg_23_0.mask, {
		ended = function(arg_24_0, arg_24_1, arg_24_2)
			if math.abs(arg_24_1) > 100 and math.abs(arg_24_1) > math.abs(arg_24_2) then
				local var_24_0 = arg_24_1 > 0 and -1 or 1

				arg_23_0.selectEvolution:modify(function(arg_25_0)
					arg_25_0 = cc.clampf(arg_25_0 + var_24_0, 1, arg_23_0.evolutionDatas:size())

					return true, arg_25_0
				end)
			end
		end
	})
end

function var_0_4.initGrade(arg_26_0)
	arg_26_0.scoreTxt2:text(mathEasy.getPreciseDecimal(arg_26_0.score.score, 1))

	if arg_26_0.score.score > arg_26_0.score.last_score then
		arg_26_0.scoreImg:texture(var_0_2[1])
	elseif arg_26_0.score.score == arg_26_0.score.last_score then
		arg_26_0.scoreImg:texture(var_0_2[2])
	elseif arg_26_0.score.score < arg_26_0.score.last_score then
		arg_26_0.scoreImg:texture(var_0_2[3])
	end

	adapt.oneLineCenter(arg_26_0.scoreTxt2, arg_26_0.scoreTxt1, arg_26_0.scoreTxt3, cc.p(10, 0))
	adapt.oneLinePos(arg_26_0.scoreTxt3, arg_26_0.scoreImg, cc.p(5, -5))

	local var_26_0 = {
		"common/icon/icon_star_d.png",
		"common/icon/icon_star.png"
	}
	local var_26_1 = {
		gLanguageCsv.oneStarGrade,
		gLanguageCsv.twoStarGrade,
		gLanguageCsv.threeStarGrade,
		gLanguageCsv.fourStarGrade,
		gLanguageCsv.fiveStarGrade
	}
	local var_26_2 = arg_26_0.score.my_score
	local var_26_3 = csv.cards[arg_26_0.cardId].cardMarkID
	local var_26_4 = false

	for iter_26_0, iter_26_1 in orderCsvPairs(csv.cards) do
		if iter_26_1.cardMarkID == var_26_3 and arg_26_0.pokedex:read()[iter_26_0] then
			var_26_4 = true

			break
		end
	end

	for iter_26_2 = 1, 5 do
		local function var_26_5(arg_27_0)
			for iter_27_0 = 1, arg_27_0 do
				arg_26_0.star:get("star" .. iter_27_0):texture(var_26_0[2])
			end
		end

		local function var_26_6(arg_28_0, arg_28_1)
			for iter_28_0 = arg_28_0 + 1, arg_28_1 do
				arg_26_0.star:get("star" .. iter_28_0):texture(var_26_0[1])
			end
		end

		var_26_5(var_26_2 / 2)
		arg_26_0.starDesc:text(var_26_1[var_26_2 / 2])
		bind.click(arg_26_0, arg_26_0.star:get("star" .. iter_26_2), {
			method = function()
				if var_26_4 == false then
					gGameUI:showTip(gLanguageCsv.cardNotActivateCantGrade)

					return
				end

				local var_29_0 = 0

				for iter_29_0, iter_29_1 in pairs(arg_26_0.cardScoreCounter:read()) do
					if iter_29_0 == var_26_3 then
						var_29_0 = iter_29_1
					end
				end

				if var_29_0 >= gCommonConfigCsv.cardScoreDailyChangeTimes then
					gGameUI:showTip(gLanguageCsv.tomorrowCanChangeGrade)

					return
				end

				var_26_5(iter_26_2)
				var_26_6(iter_26_2, 5)
				arg_26_0.starDesc:text(var_26_1[iter_26_2])
				gGameUI:showDialog({
					fontSize = 50,
					clearFast = true,
					btnType = 2,
					strs = {
						string.format(gLanguageCsv.confirmWithCardScore, iter_26_2 * 2)
					},
					cb = function()
						gGameApp:requestServer("/game/card/score/send", function(arg_31_0)
							gGameUI:showTip(gLanguageCsv.gradeComplete)
						end, arg_26_0.cardId, iter_26_2 * 2)
					end,
					closeCb = function()
						var_26_5(var_26_2 / 2)
						var_26_6(var_26_2 / 2, 5)

						if var_26_2 == 0 then
							arg_26_0.starDesc:text(gLanguageCsv.noGrade)
						else
							arg_26_0.starDesc:text(var_26_1[var_26_2 / 2])
						end
					end,
					cancelCb = function()
						var_26_5(var_26_2 / 2)
						var_26_6(var_26_2 / 2, 5)

						if var_26_2 == 0 then
							arg_26_0.starDesc:text(gLanguageCsv.noGrade)
						else
							arg_26_0.starDesc:text(var_26_1[var_26_2 / 2])
						end
					end
				})
			end
		})
	end
end

function var_0_4.initComment(arg_34_0)
	local var_34_0 = arg_34_0.cardId

	blacklist:addListener(arg_34_0.textInput, "*")
	arg_34_0.textInput:setPlaceHolder(string.format(gLanguageCsv.pleaseCommentOn, gCommonConfigCsv.cardCommentWordCount))
	arg_34_0.textInput:setTextColor(ui.COLORS.NORMAL.WHITE)
	arg_34_0.textInput:setMaxLengthEnabled(true)
	arg_34_0.textInput:setMaxLength(gCommonConfigCsv.cardCommentWordCount)
	bind.touch(arg_34_0, arg_34_0.btnComment, {
		methods = {
			ended = function()
				local var_35_0 = dataEasy.isUnlock(gUnlockCsv.cardPostComment)
				local var_35_1 = csv.unlock[gUnlockCsv.cardPostComment]

				if not var_35_0 then
					gGameUI:showTip(string.format(gLanguageCsv.nowLevelCantComment, var_35_1.startLevel))

					return
				end

				local var_35_2 = csv.cards[var_34_0].cardMarkID

				if (arg_34_0.commentCounter[var_35_2] or 0) >= gCommonConfigCsv.cardCommentDailyMarkSendTimes then
					gGameUI:showTip(string.format(gLanguageCsv.onedayCanCommentTimes, gCommonConfigCsv.cardCommentDailyMarkSendTimes))

					return
				end

				if itertools.size(arg_34_0.commentCounter) >= gCommonConfigCsv.cardCommentDailyMarkNum and not arg_34_0.commentCounter[var_35_2] then
					gGameUI:showTip(string.format(gLanguageCsv.onedayDifferentCanCommentTimes, gCommonConfigCsv.cardCommentDailyMarkNum))

					return
				end

				local var_35_3 = arg_34_0.textInput:getStringValue()

				if var_35_3 == nil or var_35_3 == "" then
					gGameUI:showTip(gLanguageCsv.canNotEmpty)
				else
					gGameApp:requestServer("/game/card/comment/send", function(arg_36_0)
						gGameUI:showTip(gLanguageCsv.commentIsSucceed)
						arg_34_0.textInput:text("")

						arg_34_0.commentState = var_0_1.SEND

						arg_34_0:sendProtocol()
					end, var_34_0, var_35_3)
				end
			end
		}
	})
end

function var_0_4.commentListData(arg_37_0)
	local var_37_0 = arg_37_0.data
	local var_37_1 = {}

	local function var_37_2(arg_38_0, arg_38_1)
		if arg_38_0 then
			for iter_38_0, iter_38_1 in ipairs(arg_38_0) do
				local var_38_0 = var_37_0.roles[iter_38_1.role_db_id]

				if var_38_0 then
					local var_38_1 = false

					if arg_37_0.commentData:at(#var_37_1 + 1) then
						var_38_1 = arg_37_0.commentData:at(#var_37_1 + 1):read().switch
					end

					table.insert(var_37_1, {
						key = arg_38_1,
						val = iter_38_1,
						level = var_38_0.level,
						logo = var_38_0.logo,
						frame = var_38_0.frame,
						vip = var_38_0.vip,
						name = var_38_0.name,
						game_key = var_38_0.game_key,
						like = var_37_0.like[iter_38_1.id] ~= nil,
						dislike = var_37_0.dislike[iter_38_1.id] ~= nil,
						listH = arg_37_0.textItemListH,
						nodeH = arg_37_0.itemListH,
						bgH = arg_37_0.textItemBgH,
						bgY = arg_37_0.textItemBgY,
						topY = arg_37_0.textItemTopY,
						headY = arg_37_0.textItemHeadY,
						switch = var_38_1
					})
				end
			end
		end
	end

	var_37_2(var_37_0.hot, "hot")
	var_37_2(var_37_0.my, "my")
	var_37_2(var_37_0.new, "new")

	if arg_37_0.commentState == var_0_1.SEND then
		arg_37_0.preloadCenter:set(math.min(#var_37_0.hot + 1, #var_37_1))
	else
		dataEasy.tryCallFunc(arg_37_0.commentList, "updatePreloadCenterIndex")
	end

	arg_37_0.commentData:update(var_37_1)
	gGameUI:disableTouchDispatch(0.01)
end

function var_0_4.onBtnDel(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6)
	gGameUI:showDialog({
		fontSize = 50,
		clearFast = true,
		btnType = 2,
		strs = {
			gLanguageCsv.confirmWithDeleteComment
		},
		cb = function()
			gGameApp:requestServer("/game/card/comment/del", function(arg_41_0)
				gGameUI:showTip(gLanguageCsv.commentIsDelete)

				arg_39_0.commentState = var_0_1.DEL

				arg_39_0:sendProtocol()
				arg_39_2:height(arg_39_5.nodeH)
				arg_39_3.bg:height(arg_39_5.bgH)
				arg_39_3.bg:y(arg_39_5.bgY)
				arg_39_4:height(arg_39_5.listH)
				arg_39_3.top:y(arg_39_5.topY)
				arg_39_3.head:y(arg_39_5.headY)
				arg_39_1:refreshView()
			end, arg_39_6.val.id)
		end
	})
end

function var_0_4.onHeadClick(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
	if userDefault.getForeverLocalKey("serverKey", nil, {
		rawKey = true
	}) ~= arg_42_4.game_key then
		gGameUI:showTip(gLanguageCsv.disserentServerCantViewing)

		return
	end

	local var_42_0, var_42_1 = arg_42_2:xy()
	local var_42_2 = arg_42_2:getParent():convertToWorldSpace(cc.p(var_42_0 - 100, var_42_1))
	local var_42_3 = {
		role = {
			vip = arg_42_4.vip,
			name = arg_42_4.name,
			logo = arg_42_4.logo,
			frame = arg_42_4.frame,
			level = arg_42_4.level,
			id = arg_42_4.val.role_db_id
		}
	}

	gGameUI:stackUI("city.chat.personal_info", nil, nil, var_42_2, var_42_3)
end

function var_0_4.updateLike(arg_43_0, arg_43_1, arg_43_2)
	arg_43_0.commentData:at(arg_43_1):modify(function(arg_44_0)
		if arg_43_2 == "revokeLike" and arg_44_0.like then
			arg_44_0.val.like = arg_44_0.val.like - 1
			arg_44_0.like = false
		elseif arg_43_2 == "like" and not arg_44_0.like then
			arg_44_0.val.like = arg_44_0.val.like + 1
			arg_44_0.like = true

			if arg_44_0.dislike then
				arg_44_0.val.dislike = arg_44_0.val.dislike - 1
				arg_44_0.dislike = false
			end
		elseif arg_43_2 == "revokeDislike" and arg_44_0.dislike then
			arg_44_0.val.dislike = arg_44_0.val.dislike - 1
			arg_44_0.dislike = false
		elseif arg_43_2 == "dislike" and not arg_44_0.dislike then
			arg_44_0.val.dislike = arg_44_0.val.dislike + 1
			arg_44_0.dislike = true

			if arg_44_0.like then
				arg_44_0.val.like = arg_44_0.val.like - 1
				arg_44_0.like = false
			end
		end
	end, true)
end

function var_0_4.refreshErr(arg_45_0, arg_45_1)
	arg_45_0.commentState = var_0_1.REFRESH

	arg_45_0:sendProtocol()
end

function var_0_4.onLikeClick(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
	if arg_46_4 then
		arg_46_4 = false

		gGameApp:requestServerCustom("/game/card/comment/evaluate"):onErrClose(function()
			arg_46_0:refreshErr(arg_46_3)
		end):params(arg_46_3.val.id, "revokeLike"):doit()
		arg_46_0:updateLike(arg_46_2, "revokeLike")
	else
		arg_46_4 = true

		gGameApp:requestServerCustom("/game/card/comment/evaluate"):onErrClose(function()
			arg_46_0:refreshErr(arg_46_3)
		end):params(arg_46_3.val.id, "like"):doit()
		arg_46_0:updateLike(arg_46_2, "like")
	end
end

function var_0_4.onDislikeClick(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
	if arg_49_4 then
		arg_49_4 = false

		gGameApp:requestServerCustom("/game/card/comment/evaluate"):onErrClose(function()
			arg_49_0:refreshErr(arg_49_3)
		end):params(arg_49_3.val.id, "revokeDislike"):doit()
		arg_49_0:updateLike(arg_49_2, "revokeDislike")
	else
		arg_49_4 = true

		gGameApp:requestServerCustom("/game/card/comment/evaluate"):onErrClose(function()
			arg_49_0:refreshErr(arg_49_3)
		end):params(arg_49_3.val.id, "dislike"):doit()
		arg_49_0:updateLike(arg_49_2, "dislike")
	end
end

function var_0_4.initModel(arg_52_0)
	arg_52_0.myID = gGameModel.role:getIdler("id")
	arg_52_0.cardCommentCounter = gGameModel.daily_record:getIdler("card_comment_counter")
	arg_52_0.cardScoreCounter = gGameModel.daily_record:getIdler("card_score_counter")
	arg_52_0.pokedex = gGameModel.role:getIdler("pokedex")
end

return var_0_4
