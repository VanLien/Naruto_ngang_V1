local var_0_0 = require("app.views.city.activity.view")
local var_0_1 = class("ActivityRmbGoldReward", Dialog)
local var_0_2 = 6
local var_0_3 = 5

var_0_1.RESOURCE_FILENAME = "activity_rmbgold_reward.json"
var_0_1.RESOURCE_BINDING = {
	["bottomPanel.item.cost"] = "cost",
	["topPanel.panelStart"] = "panelStart",
	["topPanel.imgDimond"] = "imgDimond",
	["topPanel.panelStart.leftPanel.textCost"] = "textCost",
	["topPanel.panelEnd.textRate"] = "textEndRate",
	["timePlane.textDayTime"] = "textDayTime",
	["topPanel.textCanReward"] = "textCanReward",
	["topPanel.panelStart.leftPanel.textNeed"] = "textNeed",
	["topPanel.info.imgTip"] = "imgTip",
	["bottomPanel.textSumCost"] = "textSumCost",
	["bottomPanel.textHasCost"] = "textHasCost",
	["bottomPanel.item"] = "item",
	icon3 = "icon3",
	["topPanel.panelStart.textRate"] = "textRate",
	["bottomPanel.barBg"] = "barBg",
	["bottomPanel.barGoldBg"] = "barGoldBg",
	["timePlane.textTimes"] = "textTimes",
	bg = "bg",
	["topPanel.panelEnd.textLast"] = "textLast",
	["topPanel.text2"] = "text2",
	topPanel = "topPanel",
	["topPanel.panelStart.leftPanel.icon2"] = "icon2",
	textInfo = "textInfo",
	["topPanel.text1"] = "text1",
	["topPanel.panelStart.textNowRate"] = "textNowRate",
	["topPanel.panelStart.leftPanel"] = "leftPanel",
	["topPanel.info.textTip"] = "textTip",
	["topPanel.info.textTime"] = "textTime",
	["topPanel.icon1"] = "icon1",
	["topPanel.panelEnd"] = "panelEnd",
	["topPanel.btnSure.get"] = "get",
	["topPanel.textMaxReward"] = "textMaxReward",
	["topPanel.panelStart.leftPanel.textCost1"] = "textCost1",
	bottonTips = "bottonTips",
	["timePlane.imgClock"] = "imgClock",
	["topPanel.textReward"] = "textReward",
	btnTip = {
		varname = "btnTip",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onTips")
			}
		}
	},
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["topPanel.btnSure"] = {
		varname = "btnSure",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSure")
			}
		}
	},
	["bottomPanel.rewardList"] = {
		varname = "rewardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				backupCached = false,
				data = bindHelper.self("boxData"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("icon")
					local var_1_1 = var_1_0:size()
					local var_1_2 = {}
					local var_1_3 = arg_1_3.scoreEnough == true
					local var_1_4 = arg_1_3.boxGet == true

					var_1_2.id, var_1_2.num = csvNext(arg_1_3.cfg.award)

					bind.extend(arg_1_0, var_1_0, {
						class = "icon_key",
						props = {
							noListener = false,
							data = {
								key = var_1_2.id,
								num = var_1_2.num
							},
							onNode = function(arg_2_0)
								if var_1_3 and not var_1_4 then
									uiEasy.sweepingEffect(var_1_0, {
										delayTime = 1,
										scaleX = 3,
										speedTime = 1,
										angle = 20
									})
									arg_1_1:get("iconAwardMask"):setVisible(true)
									var_1_0:setTouchEnabled(false)
								end

								if var_1_3 and var_1_4 then
									local var_2_0 = ccui.Layout:create():size(var_1_1):setBackGroundColorType(1):setBackGroundColor(cc.c3b(0, 0, 0)):setBackGroundColorOpacity(128):addTo(arg_2_0, 10, "iconMask")
									local var_2_1 = ccui.Text:create(gLanguageCsv.received, "font/youmi.ttf", 40):alignCenter(arg_2_0:size()):addTo(arg_2_0, 10, "awardGot")
								end

								arg_2_0:xy(var_1_1.width / 2, var_1_1.height / 2)
								bind.touch(arg_1_0, arg_2_0, {
									methods = {
										ended = functools.partial(arg_1_0.clickBoxGet, arg_1_2, arg_1_1)
									}
								})
								bind.touch(arg_1_0, arg_1_1:get("iconAwardMask"), {
									methods = {
										ended = functools.partial(arg_1_0.clickBoxGet, arg_1_2, arg_1_1)
									}
								})
							end
						}
					})

					if arg_1_3.type == "rmb" then
						arg_1_1:get("imgGet"):texture("activity/rmbgold_reward/sign_gou_bg2.png")
					else
						arg_1_1:get("imgGet"):texture("activity/rmbgold_reward/sign_gou_bg1.png")
					end

					if var_1_3 and not var_1_4 then
						if arg_1_3.type == "rmb" then
							arg_1_1:get("imgNoGet"):texture("activity/rmbgold_reward/logo_zzfz2.png")
						else
							arg_1_1:get("imgNoGet"):texture("activity/rmbgold_reward/logo_zzfj2.png")
						end
					elseif var_1_4 then
						arg_1_1:get("imgNoGet"):setVisible(false)
						arg_1_1:get("imgGet"):setVisible(true)
						arg_1_1:setTouchEnabled(false)
					else
						if arg_1_3.type == "rmb" then
							arg_1_1:get("imgNoGet"):texture("activity/rmbgold_reward/logo_zzfz1.png")
						else
							arg_1_1:get("imgNoGet"):texture("activity/rmbgold_reward/logo_zzfj1.png")
						end

						arg_1_1:get("imgGet"):setVisible(false)
						arg_1_1:setTouchEnabled(false)
					end

					arg_1_1:get("cost"):text(mathEasy.getShortNumber(arg_1_3.cfg.num, 2))
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.clickBoxGet, arg_1_2, arg_1_1)
						}
					})
				end
			},
			handlers = {
				clickBoxGet = bindHelper.self("onBoxGetClick")
			}
		}
	},
	["bottomPanel.bar"] = {
		varname = "bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "activity/rmbgold_reward/line_zzfz1.png",
				data = bindHelper.self("livenessPoint1")
			}
		}
	},
	["bottomPanel.barGold"] = {
		varname = "barGold",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "activity/rmbgold_reward/line_zzfj1.png",
				data = bindHelper.self("livenessPoint1")
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	arg_3_0.activityEnd = false
	arg_3_0.rewardGet = false
	arg_3_0.activityId = arg_3_1
	arg_3_0.huodongID = csv.yunying.yyhuodong[arg_3_0.activityId].huodongID

	local var_3_0 = csv.yunying.yyhuodong[arg_3_0.activityId]

	arg_3_0:initModel()

	arg_3_0.rateData = {}
	arg_3_0.awardData = {}
	arg_3_0.csvId = {}

	for iter_3_0, iter_3_1 in orderCsvPairs(csv.yunying.rmbgoldreturn_award) do
		if csv.yunying.yyhuodong[arg_3_0.activityId].huodongID == iter_3_1.huodongID then
			table.insert(arg_3_0.awardData, iter_3_1)
			table.insert(arg_3_0.csvId, iter_3_0)
		end
	end

	for iter_3_2, iter_3_3 in orderCsvPairs(csv.yunying.rmbgoldreturn_rate) do
		if csv.yunying.yyhuodong[arg_3_0.activityId].huodongID == iter_3_3.huodongID then
			table.insert(arg_3_0.rateData, iter_3_3)
		end
	end

	arg_3_0:resetTimeLabel()

	arg_3_0.showItemIdx = 1
	arg_3_0.maxIdx = 0

	if var_3_0.paramMap.type == "rmb" then
		arg_3_0:initRmb()
	else
		arg_3_0:initGold()
	end

	arg_3_0.textMaxReward:text(mathEasy.getShortNumber(var_3_0.paramMap.limit))
	adapt.oneLineCenter(arg_3_0.textMaxReward, arg_3_0.text1, arg_3_0.text2, cc.p(10, 0))

	local var_3_1 = {}
	local var_3_2 = {}
	local var_3_3 = #arg_3_0.awardData
	local var_3_4 = {}

	arg_3_0.rewardList:setItemsMargin(math.max(0, arg_3_0.rewardList:size().width / var_3_3 - 200))

	for iter_3_4, iter_3_5 in pairs(arg_3_0.awardData) do
		local var_3_5 = {
			cfg = iter_3_5,
			type = var_3_0.paramMap.type,
			id = arg_3_0.csvId[iter_3_4]
		}

		table.insert(var_3_1, var_3_5)
		table.insert(var_3_2, iter_3_5.num)
		table.insert(var_3_4, 100 / var_3_3 * iter_3_4 - 50 / var_3_3 - 1)
	end

	arg_3_0.livenessPoint1 = idler.new(0)
	arg_3_0.boxData = idlertable.new(var_3_1)

	idlereasy.when(arg_3_0.yyhuodongs, function(arg_4_0, arg_4_1)
		local var_4_0 = arg_4_1[arg_3_1] or {}

		arg_3_0.costNum = 0
		arg_3_0.costRate = arg_3_0.rateData[1] and arg_3_0.rateData[1].rate or 0
		arg_3_0.needCost = -1

		if var_3_0.paramMap.type == "rmb" then
			arg_3_0.costNum = var_4_0.info and var_4_0.info.rmb_used or 0
		else
			arg_3_0.costNum = var_4_0.info and var_4_0.info.gold_used or 0
		end

		if var_4_0.info and var_4_0.info.flag then
			cache.setShader(arg_3_0.btnSure, false, "hsl_gray")
			arg_3_0.btnSure:setTouchEnabled(false)
			arg_3_0.get:text(gLanguageCsv.received)

			arg_3_0.rewardGet = true
		elseif arg_3_0.costNum == 0 then
			cache.setShader(arg_3_0.btnSure, false, "hsl_gray")
		end

		for iter_4_0, iter_4_1 in pairs(arg_3_0.awardData) do
			if arg_3_0.costNum >= iter_4_1.num then
				arg_3_0.boxData:proxy()[iter_4_0].scoreEnough = true
			end

			if var_4_0.stamps and var_4_0.stamps[arg_3_0.csvId[iter_4_0]] == 0 then
				arg_3_0.boxData:proxy()[iter_4_0].boxGet = true
			end
		end

		for iter_4_2, iter_4_3 in pairs(arg_3_0.rateData) do
			if arg_3_0.costNum >= iter_4_3.num then
				arg_3_0.costRate = iter_4_3.rate
			end

			if arg_3_0.needCost < 0 and iter_4_3.num > arg_3_0.costNum then
				arg_3_0.needCost = iter_4_3.num - arg_3_0.costNum
			end
		end

		if arg_3_0.needCost < 0 then
			arg_3_0.needCost = 0

			arg_3_0.textNeed:setVisible(false)
			arg_3_0.icon2:setVisible(false)
			arg_3_0.textCost1:setVisible(false)
			arg_3_0.textCost:text(gLanguageCsv.rmbGoldRewardMax)
		end

		arg_3_0.textNeed:text(mathEasy.getShortNumber(arg_3_0.needCost, 2))
		arg_3_0.textHasCost:text(mathEasy.getShortNumber(arg_3_0.costNum, 2))
		arg_3_0.textRate:text(string.format("%d%%", math.floor(arg_3_0.costRate * 100)))
		arg_3_0.textEndRate:text(string.format("%d%%", math.floor(arg_3_0.costRate * 100)))
		arg_3_0.textReward:text(mathEasy.getShortNumber(math.min(math.ceil(arg_3_0.costNum * arg_3_0.costRate), var_3_0.paramMap.limit), 2))
		adapt.oneLinePos(arg_3_0.textReward, arg_3_0.icon1, cc.p(10, 0), "right")
		arg_3_0.livenessPoint1:set(mathEasy.showProgress(var_3_4, var_3_2, arg_3_0.costNum))
	end)
	arg_3_0:fires(150, 200, 300, 70, 0)
	arg_3_0:fires(450, 200, 200, 70, 1)
	arg_3_0:fires(1000, 200, 300, 70, 0.5)
	Dialog.onCreate(arg_3_0, {
		blackType = 1
	})
end

function var_0_1.fires(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = ccui.ImageView:create(arg_5_0.fire1Image):scale(0.5):align(cc.p(0.5, 1), cc.p(arg_5_1, arg_5_2)):addTo(arg_5_0.bg, 100, "fire")
	local var_5_1 = ccui.ImageView:create(arg_5_0.fire2Image):scale(0.5):align(cc.p(0.5, 1), cc.p(arg_5_1, arg_5_2)):addTo(arg_5_0.bg, 100, "fire"):setVisible(false)

	arg_5_1 = arg_5_1 + var_5_0:size().width

	local var_5_2 = {}

	for iter_5_0 = 1, 8 do
		table.insert(var_5_2, var_5_0:clone():addTo(arg_5_0.bg, 100, "fire"):setVisible(false))
	end

	table.insert(var_5_2, var_5_1)

	for iter_5_1 = 1, 7 do
		table.insert(var_5_2, var_5_1:clone():addTo(arg_5_0.bg, 100, "fire"):setVisible(false))
	end

	local var_5_3 = cc.Sequence:create(cc.DelayTime:create(arg_5_5), cc.FadeTo:create(0, 255), cc.MoveTo:create(0.3, cc.p(arg_5_1, arg_5_2 + arg_5_3)), cc.FadeTo:create(0, 0), cc.CallFunc:create(function()
		for iter_6_0, iter_6_1 in pairs(var_5_2) do
			iter_6_1:setVisible(true)

			local var_6_0 = 0
			local var_6_1 = arg_5_4
			local var_6_2 = 0.5

			if iter_6_0 <= 8 then
				var_6_0 = 45 * (iter_6_0 - 1)
			else
				var_6_1 = arg_5_4 * 0.7
				var_6_0 = 45 * (iter_6_0 - 1) + 22.5
				var_6_2 = 0.75
			end

			transition.executeSequence(iter_6_1, true):scaleTo(0, 0):fadeTo(0, 0):moveTo(0, arg_5_1, arg_5_2 + arg_5_3):rotateTo(0, var_6_0):fadeTo(0, 255):scaleTo(0.0001, var_6_2):easeBegin("EXPONENTIALOUT"):moveTo(1.3, arg_5_1 + var_6_1 * math.sin(math.rad(var_6_0)), arg_5_2 + arg_5_3 + var_6_1 * math.cos(math.rad(var_6_0))):scaleTo(1, 0):easeEnd():done()
		end
	end), cc.MoveTo:create(0, cc.p(arg_5_1, arg_5_2)), cc.DelayTime:create(2))
	local var_5_4 = cc.RepeatForever:create(var_5_3)

	var_5_0:runAction(var_5_4)
end

function var_0_1.initRmb(arg_7_0)
	arg_7_0.fire1Image = "activity/rmbgold_reward/img_b2.png"
	arg_7_0.fire2Image = "activity/rmbgold_reward/img_b1.png"

	arg_7_0.imgTip:texture("activity/rmbgold_reward/box_zzfz_1.png")
	arg_7_0.bg:texture("activity/rmbgold_reward/img_zzfz.png")
	arg_7_0.icon1:texture("common/icon/icon_diamond.png")
	arg_7_0.icon2:texture("common/icon/icon_diamond.png")
	arg_7_0.icon3:texture("common/icon/icon_diamond.png")
	arg_7_0.imgClock:texture("activity/rmbgold_reward/logo_time1.png")
	arg_7_0.barGold:setVisible(false)
	arg_7_0.barGoldBg:setVisible(false)

	if #arg_7_0.rateData <= 1 then
		arg_7_0.textInfo:text(gLanguageCsv.rmbRewardFixTips)
		arg_7_0.textNowRate:text(gLanguageCsv.rateFixInfo)
		arg_7_0.textLast:text(gLanguageCsv.rateFixInfo)
		arg_7_0.textEndRate:x(arg_7_0.textEndRate:x() - 70)
		arg_7_0.leftPanel:setVisible(false)
		arg_7_0.btnTip:setVisible(false)
	else
		arg_7_0.textInfo:text(gLanguageCsv.rmbRewardTips)
		arg_7_0.textNowRate:text(gLanguageCsv.rateInfo)
		arg_7_0.leftPanel:setVisible(true)
		arg_7_0.btnTip:setVisible(true)
	end

	arg_7_0.bottonTips:text(gLanguageCsv.rmbRewardBottonTips)

	if arg_7_0.activityEnd then
		arg_7_0.imgTip:texture("activity/rmbgold_reward/box_zzfz_2.png")
		arg_7_0.panelStart:setVisible(false)
		arg_7_0.panelEnd:setVisible(true)
		arg_7_0.btnSure:setVisible(true)
		arg_7_0.text1:setVisible(false)
		arg_7_0.text2:setVisible(false)
		arg_7_0.textMaxReward:setVisible(false)
		text.addEffect(arg_7_0.textTip, {
			color = cc.c4b(255, 255, 255, 255)
		})
		text.addEffect(arg_7_0.textTime, {
			color = cc.c4b(255, 255, 255, 255)
		})
		arg_7_0.textInfo:text(gLanguageCsv.rmbRewardEndTips)
		arg_7_0.bottonTips:text(gLanguageCsv.rmbRewardEndBottonTips)
		arg_7_0.textTip:text(gLanguageCsv.activityEnd)
	end
end

function var_0_1.initGold(arg_8_0)
	arg_8_0.fire1Image = "activity/rmbgold_reward/img_y2.png"
	arg_8_0.fire2Image = "activity/rmbgold_reward/img_y1.png"

	arg_8_0.imgTip:texture("activity/rmbgold_reward/box_zzfj_1.png")
	arg_8_0.bg:texture("activity/rmbgold_reward/img_zzfj.png")
	arg_8_0.icon1:texture("common/icon/icon_gold.png")
	arg_8_0.icon2:texture("common/icon/icon_gold.png")
	arg_8_0.icon3:texture("common/icon/icon_gold.png")
	arg_8_0.imgClock:texture("activity/rmbgold_reward/logo_time2.png")
	arg_8_0.bar:setVisible(false)
	arg_8_0.barBg:setVisible(false)

	if #arg_8_0.rateData <= 1 then
		arg_8_0.textInfo:text(gLanguageCsv.goldRewardFixTips)
		arg_8_0.textNowRate:text(gLanguageCsv.rateFixInfo)
		arg_8_0.textLast:text(gLanguageCsv.rateFixInfo)
		arg_8_0.textEndRate:x(arg_8_0.textEndRate:x() - 70)
		arg_8_0.leftPanel:setVisible(false)
		arg_8_0.btnTip:setVisible(false)
	else
		arg_8_0.textInfo:text(gLanguageCsv.goldRewardTips)
		arg_8_0.textNowRate:text(gLanguageCsv.rateInfo)
		arg_8_0.leftPanel:setVisible(true)
		arg_8_0.btnTip:setVisible(true)
	end

	arg_8_0.bottonTips:text(gLanguageCsv.goldRewardBottonTips)

	if arg_8_0.activityEnd then
		arg_8_0.imgTip:texture("activity/rmbgold_reward/box_zzfj_2.png")
		arg_8_0.panelStart:setVisible(false)
		arg_8_0.panelEnd:setVisible(true)
		arg_8_0.btnSure:setVisible(true)
		arg_8_0.text1:setVisible(false)
		arg_8_0.text2:setVisible(false)
		arg_8_0.textMaxReward:setVisible(false)
		text.addEffect(arg_8_0.textTip, {
			color = cc.c4b(255, 255, 255, 255)
		})
		text.addEffect(arg_8_0.textTime, {
			color = cc.c4b(255, 255, 255, 255)
		})
		arg_8_0.textInfo:text(gLanguageCsv.goldRewardEndTips)
		arg_8_0.bottonTips:text(gLanguageCsv.goldRewardEndBottonTips)
		arg_8_0.textTip:text(gLanguageCsv.activityEnd)
	end
end

function var_0_1.initModel(arg_9_0)
	arg_9_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_9_0.rmbUsed = gGameModel.role:getIdler("rmb_used")
	arg_9_0.goldUsed = gGameModel.role:getIdler("gold_used")
end

function var_0_1.resetTimeLabel(arg_10_0)
	local var_10_0 = gGameModel.role:read("yy_endtime")[arg_10_0.activityId]
	local var_10_1, var_10_2 = time.getActivityOpenDate(arg_10_0.activityId)
	local var_10_3 = csv.yunying.yyhuodong[arg_10_0.activityId]
	local var_10_4 = time.getDate(var_10_2)

	var_10_4.hour = var_10_3.beginTime / 100
	var_10_4.min = var_10_3.beginTime % 100
	var_10_4.sec = 0

	local var_10_5 = time.getDate(math.floor(var_10_0 - 86400 * var_10_3.paramMap.returnDays))

	var_10_5.hour = var_10_3.endTime / 100
	var_10_5.min = var_10_3.endTime % 100
	var_10_5.sec = 0

	local var_10_6 = string.format("%d.%02d.%02d %02d:%02d:%02d", var_10_4.year, var_10_4.month, var_10_4.day, var_10_4.hour, var_10_4.min, var_10_4.sec)
	local var_10_7 = string.format("%d.%02d.%02d %02d:%02d:%02d", var_10_5.year, var_10_5.month, var_10_5.day, var_10_5.hour, var_10_5.min, var_10_5.sec)

	arg_10_0.textTimes:text(string.format("%s-%s", var_10_6, var_10_7))

	local var_10_8 = time.getTimestamp(var_10_5) - time.getTime()

	if var_10_8 <= 0 then
		arg_10_0.activityEnd = true

		arg_10_0.textTip:setVisible(false)
		arg_10_0.textTime:y(arg_10_0.textTime:y() + 24)
		arg_10_0.textTime:text(gLanguageCsv.activityOver)
	else
		bind.extend(arg_10_0, arg_10_0.textTime, {
			class = "cutdown_label",
			props = {
				time = var_10_8,
				endFunc = function()
					arg_10_0.textTip:setVisible(false)
					arg_10_0.textTime:y(arg_10_0.textTime:y() + 24)
					arg_10_0.textTime:text(gLanguageCsv.activityOver)
				end
			}
		})
	end
end

function var_0_1.onBoxGetClick(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_0.boxData:proxy()[arg_12_2]

	if arg_12_0.costNum >= var_12_0.cfg.num and not var_12_0.boxGet then
		local var_12_1 = {
			false
		}

		gGameApp:requestServerCustom("/game/yy/award/get"):params(arg_12_0.activityId, var_12_0.id):onResponse(function(arg_13_0)
			arg_12_3:get("imgNoGet"):setVisible(false)
			arg_12_3:get("imgGet"):setVisible(true)

			var_12_1[1] = true
		end):wait(var_12_1):doit(function(arg_14_0)
			gGameUI:showGainDisplay(arg_14_0)
		end)
	end
end

function var_0_1.onSure(arg_15_0)
	if arg_15_0.costNum > 0 and not arg_15_0.rewardGet then
		gGameApp:requestServer("/2fb1c5cf58867b5bbc9a1b145a86f3a0/rmbgold/return", function(arg_16_0)
			performWithDelay(arg_15_0, function()
				gGameUI:showGainDisplay(arg_16_0)
			end, 0)
		end, arg_15_0.activityId, arg_15_0.huodongID)
	else
		gGameUI:showTip(gLanguageCsv.noRmbGoldRewardGet)
	end
end

function var_0_1.onTips(arg_18_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_18_0:createHandler("getRuleContext"), {
		width = 800
	})
end

function var_0_1.getRuleContext(arg_19_0, arg_19_1)
	local var_19_0 = adaptContext
	local var_19_1 = {
		var_19_0.clone(arg_19_1.title, function(arg_20_0)
			arg_20_0:get("text"):text(gLanguageCsv.rmbGoldRewardRules)
		end),
		gLanguageCsv.ruleInfo
	}

	for iter_19_0, iter_19_1 in pairs(arg_19_0.rateData) do
		table.insert(var_19_1, var_19_0.clone(arg_19_1.rateTips, function(arg_21_0)
			local var_21_0 = arg_21_0:multiget("text1", "text2", "text3")

			var_21_0.text1:text(string.format(gLanguageCsv.ruleRate, gLanguageCsv["symbolNumber" .. iter_19_0]))
			var_21_0.text2:text(mathEasy.getShortNumber(iter_19_1.num, 2))
			var_21_0.text3:text(math.floor(iter_19_1.rate * 100) .. "%")
		end))
	end

	return var_19_1
end

return var_0_1
