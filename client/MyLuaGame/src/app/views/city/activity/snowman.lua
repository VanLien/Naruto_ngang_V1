local var_0_0 = {
	shoutao = 1,
	weijin = 2,
	maozi = 3
}
local var_0_1 = {
	event = "effect",
	data = {
		outline = {
			size = 3,
			color = cc.c4b(116, 59, 29, 255)
		}
	}
}
local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("ActivitySnowmanView", var_0_2)

var_0_3.RESOURCE_FILENAME = "activity_snowman.json"
var_0_3.RESOURCE_BINDING = {
	["bottomPanel.progressNum"] = "progressNum",
	["leftPanel.subPanel.subItem"] = "subItem",
	timeText = "timeText",
	["bottomPanel.icon"] = "snowIcon",
	["leftPanel.mainItem"] = "mainItem",
	bg = "bg",
	snowmanPanel = "snowmanPanel",
	time = "time",
	leftList = "leftList",
	bottomPanel = "bottomPanel",
	["leftPanel.subPanel"] = "subPanel",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["bottomPanel.progress"] = {
		varname = "progressBar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				data = bindHelper.self("curPagePro")
			}
		}
	},
	["bottomPanel.degreeText"] = {
		varname = "degreeText",
		binds = var_0_1
	},
	["bottomPanel.degreeNum"] = {
		varname = "degreeNum",
		binds = var_0_1
	},
	["bottomPanel.haveText"] = {
		varname = "haveText",
		binds = var_0_1
	},
	["bottomPanel.haveNum"] = {
		varname = "haveNum",
		binds = var_0_1
	},
	["bottomPanel.btnUpgrade.txt"] = {
		binds = var_0_1
	},
	["bottomPanel.btnUpgrade"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onUpgrade")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					state = bindHelper.self("upgradeRedHint"),
					onNode = function(arg_1_0)
						arg_1_0:xy(295, 145)
					end
				}
			}
		}
	},
	["leftPanel.mainList"] = {
		varname = "mainList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("mainClothDatas"),
				item = bindHelper.self("mainItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("selected", "cloth", "Mask")

					var_2_0.selected:visible(arg_2_3.isSel == true)

					for iter_2_0, iter_2_1 in orderCsvPairs(arg_2_3) do
						if iter_2_1.isSel == true then
							var_2_0.cloth:texture(iter_2_1.icon)
						end

						var_2_0.Mask:visible(iter_2_1.isUnlock)
						bind.touch(arg_2_0, arg_2_1, {
							methods = {
								ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3, iter_2_1.isUnlock, iter_2_1.needLevel)
							}
						})
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onMainItemClick")
			}
		}
	},
	["leftPanel.subPanel.subList"] = {
		varname = "subList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("subClothDatas"),
				item = bindHelper.self("subItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					arg_3_1:multiget("subIcon", "line").subIcon:texture(arg_3_3.icon)
					bind.touch(arg_3_0, arg_3_1, {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onSubItemClick")
			}
		}
	},
	btnRule = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRules")
			}
		}
	},
	btnAward = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onAward")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					state = bindHelper.self("awardRedHint"),
					onNode = function(arg_4_0)
						arg_4_0:xy(330, 140)
					end
				}
			}
		}
	}
}

function var_0_3.onCreate(arg_5_0, arg_5_1)
	arg_5_0:initModel()

	arg_5_0.activityId = arg_5_1

	local var_5_0 = csv.yunying.yyhuodong[arg_5_1]
	local var_5_1 = var_5_0.huodongID

	arg_5_0.huodongID = var_5_1
	arg_5_0.snowBallId = var_5_0.paramMap.items[1]
	arg_5_0.yyCfg = var_5_0
	arg_5_0.subListVisible = false

	arg_5_0.subPanel:visible(arg_5_0.subListVisible)

	for iter_5_0, iter_5_1 in ipairs(var_5_0.paramMap.items) do
		if iter_5_1 then
			arg_5_0.snowBallId = iter_5_1

			break
		end
	end

	arg_5_0.selIdx:addListener(function(arg_6_0, arg_6_1)
		if arg_5_0.mainClothDatas:atproxy(arg_6_1) then
			arg_5_0.mainClothDatas:atproxy(arg_6_1).isSel = false
		end

		if arg_5_0.mainClothDatas:atproxy(arg_6_0) then
			arg_5_0.mainClothDatas:atproxy(arg_6_0).isSel = true
		end
	end)
	arg_5_0:updateTime()
	bind.click(arg_5_0, arg_5_0.snowIcon, {
		method = function()
			local var_7_0 = {
				key = arg_5_0.snowBallId
			}

			gGameUI:showItemDetail(arg_5_0.snowIcon, var_7_0)
		end
	})
	idlereasy.when(arg_5_0.yyhuodongs, function(arg_8_0, arg_8_1)
		local var_8_0 = arg_5_0.yyhuodongs:read()[arg_5_1] or {}

		arg_5_0.yyData = var_8_0
		arg_5_0.info = var_8_0.info

		arg_5_0.snowLevel:set(arg_5_0.info.level)
		arg_5_0.degreeNum:text(arg_5_0.info.level)
		arg_5_0.haveNum:text(dataEasy.getNumByKey(arg_5_0.snowBallId))

		if dataEasy.getNumByKey(arg_5_0.snowBallId) > 0 then
			arg_5_0.upgradeRedHint:set(true)
		else
			arg_5_0.upgradeRedHint:set(false)
		end

		arg_5_0.awardRedHint:set(false)

		for iter_8_0, iter_8_1 in pairs(var_8_0.stamps) do
			if iter_8_1 == 1 then
				arg_5_0.awardRedHint:set(true)

				break
			end
		end

		adapt.oneLinePos(arg_5_0.degreeText, arg_5_0.degreeNum, cc.p(5, 0))
		adapt.oneLinePos(arg_5_0.haveText, {
			arg_5_0.haveNum,
			arg_5_0.snowIcon
		}, {
			cc.p(-15, 0),
			cc.p(5, 0)
		})

		for iter_8_2, iter_8_3 in orderCsvPairs(csv.yunying.huodongcloth_level) do
			if iter_8_3.huodongID == var_5_1 and iter_8_3.level == arg_5_0.info.level then
				arg_5_0.curLevelMax = iter_8_3.needExp

				break
			end
		end

		if arg_5_0.info.exp > arg_5_0.curLevelMax then
			arg_5_0.progressNum:text(arg_5_0.curLevelMax .. "/" .. arg_5_0.curLevelMax)
		else
			arg_5_0.progressNum:text(arg_5_0.info.exp .. "/" .. arg_5_0.curLevelMax)
		end

		arg_5_0.curPagePro:set(math.min(100, arg_5_0.info.exp / arg_5_0.curLevelMax * 100))
		arg_5_0:initClothDatas()
	end)
end

function var_0_3.initModel(arg_9_0)
	arg_9_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_9_0.curPagePro = idler.new(0)
	arg_9_0.snowLevel = idler.new(0)
	arg_9_0.mainClothDatas = idlers.newWithMap({})
	arg_9_0.subClothDatas = idlers.newWithMap({})
	arg_9_0.selIdx = idler.new(1)
	arg_9_0.upgradeRedHint = idler.new(false)
	arg_9_0.awardRedHint = idler.new(false)
end

function var_0_3.initClothDatas(arg_10_0)
	local var_10_0 = {}
	local var_10_1 = arg_10_0.yyData.targets

	for iter_10_0, iter_10_1 in orderCsvPairs(csv.yunying.huodongcloth_level) do
		if iter_10_1.huodongID == arg_10_0.huodongID and iter_10_1.unlockPart then
			if iter_10_1.unlockPart > 0 and iter_10_1.unlockPart <= 100 then
				var_10_0[iter_10_1.unlockPart] = {}

				for iter_10_2, iter_10_3 in orderCsvPairs(csv.yunying.huodongcloth_part) do
					if iter_10_3.huodongID == arg_10_0.huodongID and iter_10_3.belongPart == iter_10_1.unlockPart then
						local var_10_2 = iter_10_3.isDefault

						if var_10_1[tostring(iter_10_1.unlockPart)] then
							var_10_2 = var_10_1[tostring(iter_10_1.unlockPart)] == iter_10_2 and true or false
						end

						table.insert(var_10_0[iter_10_1.unlockPart], {
							id = iter_10_2,
							icon = iter_10_3.icon,
							showType = iter_10_3.showType,
							res = iter_10_3.res,
							isSel = var_10_2,
							lookPos = iter_10_3.lookPos,
							needLevel = iter_10_1.level,
							isUnlock = arg_10_0.snowLevel:read() < iter_10_1.level
						})

						if arg_10_0.snowLevel:read() < iter_10_1.level then
							if iter_10_1.unlockPart == var_0_0.maozi then
								arg_10_0.snowmanPanel:get("maozi"):visible(false)
							elseif iter_10_1.unlockPart == var_0_0.shoutao then
								arg_10_0.snowmanPanel:get("shoutao"):visible(false)
							elseif iter_10_1.unlockPart == var_0_0.weijin then
								arg_10_0.snowmanPanel:get("weijin"):visible(false)
							end
						elseif iter_10_1.unlockPart == var_0_0.maozi and var_10_2 then
							arg_10_0.snowmanPanel:get("maozi"):visible(true)
							arg_10_0.snowmanPanel:get("maozi"):texture(iter_10_3.res)
						elseif iter_10_1.unlockPart == var_0_0.shoutao and var_10_2 then
							arg_10_0.snowmanPanel:get("shoutao"):visible(true)
							arg_10_0.snowmanPanel:get("shoutao"):texture(iter_10_3.res)
						elseif iter_10_1.unlockPart == var_0_0.weijin and var_10_2 then
							arg_10_0.snowmanPanel:get("weijin"):visible(true)
							arg_10_0.snowmanPanel:get("weijin"):texture(iter_10_3.res)
						end
					end
				end
			else
				for iter_10_4, iter_10_5 in orderCsvPairs(csv.yunying.huodongcloth_part) do
					if arg_10_0.snowLevel:read() >= iter_10_1.level and iter_10_5.huodongID == arg_10_0.huodongID and iter_10_5.belongPart == iter_10_1.unlockPart then
						local var_10_3 = arg_10_0.snowmanPanel:get("decoration" .. iter_10_4)
						local var_10_4 = iter_10_5.lookPos.x
						local var_10_5 = iter_10_5.lookPos.y

						if not var_10_3 then
							var_10_3 = ccui.Layout:create():xy(cc.p(750, 400)):size(650, 350):addTo(arg_10_0.snowmanPanel, iter_10_5.zOrder, "decoration" .. iter_10_4)

							if iter_10_5.showType == "pic" then
								ccui.ImageView:create(iter_10_5.res):xy(var_10_4, var_10_5):addTo(var_10_3, 4, "decoration"):scale(2)
							else
								widget.addAnimationByKey(var_10_3, iter_10_5.res, "decoration", "night_loop", 120):scale(2):xy(var_10_4, var_10_5)
							end
						else
							var_10_3:xy(cc.p(750, 400))
						end
					end
				end
			end
		end
	end

	if #var_10_0 ~= 0 then
		local var_10_6 = math.min(#var_10_0, arg_10_0.selIdx:read())

		arg_10_0.selIdx:set(var_10_6, true)

		var_10_0[arg_10_0.selIdx:read()].isSel = true
	end

	arg_10_0.mainClothDatas:update(var_10_0)
end

function var_0_3.onRules(arg_11_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_11_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_3.getRuleContext(arg_12_0, arg_12_1)
	local var_12_0 = adaptContext

	return {
		var_12_0.clone(arg_12_1.title, function(arg_13_0)
			arg_13_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_12_0.noteText(153),
		var_12_0.noteText(109001, 109020)
	}
end

function var_0_3.onUpgrade(arg_14_0)
	if dataEasy.getNumByKey(arg_14_0.snowBallId) == 0 then
		gGameUI:showTip(gLanguageCsv.inadequateProps)

		return
	end

	gGameApp:requestServer("/game/yy/cloth/item/use", function(arg_15_0)
		gGameUI:showGainDisplay(arg_15_0.view.result)
	end, arg_14_0.activityId)
end

function var_0_3.onAward(arg_16_0)
	gGameUI:stackUI("city.activity.snowman_reward", nil, nil, arg_16_0.activityId)
end

function var_0_3.updateTime(arg_17_0)
	local var_17_0 = gGameModel.role:read("yy_endtime")[arg_17_0.activityId] - time.getTime()

	bind.extend(arg_17_0, arg_17_0.time, {
		class = "cutdown_label",
		props = {
			time = var_17_0,
			endFunc = function()
				arg_17_0.time:text(gLanguageCsv.activityOver)
			end
		}
	})
end

function var_0_3.onMainItemClick(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	if arg_19_4 then
		gGameUI:showTip(string.format(gLanguageCsv.snowNeedLevel, arg_19_5))

		return
	end

	if arg_19_0.selIdx:read() == arg_19_2 then
		arg_19_0.subListVisible = not arg_19_0.subListVisible
	else
		arg_19_0.subListVisible = true

		arg_19_0.selIdx:set(arg_19_2)
	end

	arg_19_0.subPanel:visible(arg_19_0.subListVisible)

	local var_19_0 = {}
	local var_19_1 = arg_19_0.mainClothDatas:atproxy(arg_19_2)

	for iter_19_0, iter_19_1 in pairs(var_19_1) do
		if type(iter_19_1) == "table" and iter_19_0 ~= "__sorted" then
			local var_19_2 = table.shallowcopy(iter_19_1)

			table.insert(var_19_0, table.shallowcopy(var_19_2))
		end
	end

	arg_19_0.subClothDatas:update(var_19_0)
end

function var_0_3.onSubItemClick(arg_20_0, arg_20_1, arg_20_2)
	if arg_20_0.yyData.targets[tostring(arg_20_0.selIdx:read())] == arg_20_2.id then
		return
	end

	gGameApp:requestServer("/game/yy/cloth/decorate", function(arg_21_0)
		return
	end, arg_20_0.activityId, arg_20_0.selIdx:read(), arg_20_2.id)
end

function var_0_3.onClose(arg_22_0)
	var_0_2.onClose(arg_22_0)
end

return var_0_3
