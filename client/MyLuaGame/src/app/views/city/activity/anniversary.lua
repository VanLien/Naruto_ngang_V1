local var_0_0 = class("ActivityAnniversaryView", cc.load("mvc").ViewBase)
local var_0_1 = game.YYHUODONG_TYPE_ENUM_TABLE

local function var_0_2(arg_1_0, arg_1_1)
	local var_1_0 = time.getCutDown(arg_1_1, true, true)

	if matchLanguage({
		"en"
	}) then
		adapt.setTextScaleWithWidth(arg_1_0, gLanguageCsv.activityTime .. var_1_0.daystr .. " " .. var_1_0.hourstr .. " " .. var_1_0.minstr, 600)
	else
		adapt.setTextScaleWithWidth(arg_1_0, gLanguageCsv.activityTime .. var_1_0.date_str, 450)
	end
end

var_0_0.RESOURCE_FILENAME = "activity_anniversary.json"
var_0_0.RESOURCE_BINDING = {
	signIn = "signIn",
	shop = "shop",
	gridWalk = "gridWalk",
	countdownPanel = "countdownPanel",
	horseRace = "horseRace",
	braveChallenge = "braveChallenge",
	["countdownPanel.time"] = "countdown"
}
var_0_0.RESOURCE_STYLES = {
	full = true
}

function var_0_0.onCreate(arg_2_0, arg_2_1)
	arg_2_0:createTitle()
	arg_2_0:enableSchedule()

	arg_2_0.isRunning = true

	local var_2_0 = widget.addAnimation(arg_2_0:getResourceNode(), "activityheji/znqrk.skel", "effect_ruchang", 0):scale(2):alignCenter(display.sizeInView)

	var_2_0:addPlay("effect_loop")
	arg_2_0:createTable()

	local var_2_1

	for iter_2_0, iter_2_1 in ipairs(arg_2_1) do
		local var_2_2 = csv.yunying.yyhuodong[iter_2_1.id]

		if arg_2_0.tb[var_2_2.type] then
			arg_2_0.tb[var_2_2.type].data = iter_2_1
		elseif var_2_2.type == var_0_1.LoginGift then
			local var_2_3 = 0
			local var_2_4 = iter_2_1.id
			local var_2_5 = gGameModel.role:read("yy_endtime")

			if var_2_5[var_2_4] then
				var_2_3 = var_2_5[var_2_4] - time.getTime()
			end

			if var_2_3 > 0 then
				local var_2_6 = {}
				local var_2_7 = csv.yunying.yyhuodong[var_2_4].huodongID

				for iter_2_2, iter_2_3 in csvPairs(csv.yunying.loginweal) do
					if iter_2_3.huodongID == var_2_7 then
						var_2_6[iter_2_3.daySum] = {
							award = iter_2_3.award,
							id = iter_2_2
						}
					end
				end

				local var_2_8 = (gGameModel.role:read("yyhuodongs")[var_2_4] or {}).stamps or {}

				if var_2_6[1] and var_2_8[var_2_6[1].id] == 1 then
					var_2_1 = {
						data = var_2_6[1].award,
						cb = function()
							gGameApp:requestServer("/game/yy/award/get", function(arg_4_0)
								gGameUI:showGainDisplay(arg_4_0)
							end, var_2_4, var_2_6[1].id)
						end
					}
				end
			end
		end
	end

	arg_2_0:refreshPanel()

	for iter_2_4, iter_2_5 in pairs(arg_2_0.tb) do
		iter_2_5.node:hide()
	end

	arg_2_0.countdownPanel:hide()
	var_2_0:setTimeScale(0)
	performWithDelay(arg_2_0, function()
		var_2_0:setTimeScale(1)
	end, 0.016666666666666666)
	performWithDelay(arg_2_0, function()
		for iter_6_0, iter_6_1 in pairs(arg_2_0.tb) do
			iter_6_1.node:show()
		end

		if var_2_1 then
			gGameUI:stackUI("city.activity.anniversary_login_gift", nil, {
				blackLayer = true
			}, var_2_1)
		end
	end, 0.6666666666666666)
	performWithDelay(arg_2_0, function()
		arg_2_0.countdownPanel:scaleY(0.3):show()
		transition.executeSequence(arg_2_0.countdownPanel):easeBegin("ELASTICOUT"):scaleTo(2, 1, 1):easeEnd():done()
	end, 1.3)
end

function var_0_0.refreshPanel(arg_8_0)
	local var_8_0
	local var_8_1

	for iter_8_0, iter_8_1 in pairs(arg_8_0.tb) do
		local var_8_2 = iter_8_1.node
		local var_8_3 = var_8_2:get("icon")

		if not iter_8_1.iconPos then
			iter_8_1.iconPos = cc.p(var_8_3:xy())
		end

		var_8_3:stopAllActions()
		var_8_3:xy(iter_8_1.iconPos)
		var_8_3:removeChildByName("lock")

		local var_8_4 = ccui.ImageView:create("activity/anniversary/logo_lock.png"):anchorPoint(0.5, 0.5):scale(0.5):xy(iter_8_1.redHintPos.x - 10, iter_8_1.redHintPos.y - 10):addTo(var_8_3, 2, "icon"):hide()

		if iter_8_1.data then
			local var_8_5 = 0
			local var_8_6 = iter_8_1.data.id
			local var_8_7 = gGameModel.role:read("yy_endtime")

			if var_8_7[var_8_6] then
				var_8_5 = var_8_7[var_8_6] - time.getTime()
			end

			if var_8_5 <= 0 then
				iter_8_1.isOver = true

				var_8_4:show()
			else
				var_8_1 = not var_8_1 and var_8_5 or math.min(var_8_1, var_8_5)
				var_8_0 = not var_8_0 and var_8_5 or math.max(var_8_0, var_8_5)

				local var_8_8 = iter_8_1.iconPos.x
				local var_8_9 = iter_8_1.iconPos.y

				arg_8_0:iconRunAction(var_8_3, var_8_8, var_8_9)

				if iter_8_1.data.redHint then
					function iter_8_1.data.redHint.props.onNode(arg_9_0)
						arg_9_0:scale(0.5):xy(180, 100)

						if iter_8_1.redHintPos then
							arg_9_0:xy(iter_8_1.redHintPos)
						end
					end

					bind.extend(arg_8_0, var_8_3, iter_8_1.data.redHint)
				end
			end
		else
			var_8_4:show()
		end

		arg_8_0:bindClick(var_8_2, iter_8_1.data, iter_8_1.isOver)
	end

	arg_8_0:unSchedule(1)

	if not var_8_0 then
		arg_8_0.countdown:text(gLanguageCsv.activityOver)
	else
		var_0_2(arg_8_0.countdown, var_8_0)
		arg_8_0:schedule(function()
			if var_8_0 <= 0 then
				arg_8_0:refreshPanel()

				return false
			end

			var_0_2(arg_8_0.countdown, var_8_0)

			var_8_0 = var_8_0 - 1
		end, 1, 0, 1)
		performWithDelay(arg_8_0.countdown, function()
			arg_8_0:refreshPanel()
		end, var_8_1)
	end
end

function var_0_0.createTitle(arg_12_0)
	local var_12_0 = gGameUI.topuiManager:createView("default", arg_12_0, {
		onClose = arg_12_0:createHandler("onClose")
	}):init({
		subTitle = "ANNIVERSARY",
		title = gLanguageCsv.anniversary
	})
end

function var_0_0.iconRunAction(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if arg_13_0.isRunning then
		local var_13_0 = 3
		local var_13_1 = 10
		local var_13_2 = cc.Sequence:create(cc.MoveTo:create(var_13_0 / 4, cc.p(arg_13_2, arg_13_3 + var_13_1)), cc.MoveTo:create(var_13_0 / 2, cc.p(arg_13_2, arg_13_3 - var_13_1)), cc.MoveTo:create(var_13_0 / 4, cc.p(arg_13_2, arg_13_3)))

		arg_13_1:runAction(cc.RepeatForever:create(var_13_2))
	end
end

function var_0_0.bindClick(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	bind.click(arg_14_0, arg_14_1, {
		method = function()
			if arg_14_2 then
				if arg_14_3 then
					gGameUI:showTip(gLanguageCsv.activityOver)
				else
					arg_14_0:onItemClick(arg_14_2)
				end
			else
				gGameUI:showTip(gLanguageCsv.huodongNoOpen)
			end
		end
	})
end

function var_0_0.createTable(arg_16_0)
	arg_16_0.tb = {
		[var_0_1.gridWalk] = {
			node = arg_16_0.gridWalk,
			redHintPos = cc.p(155, 82)
		},
		[var_0_1.braveChallenge] = {
			node = arg_16_0.braveChallenge,
			redHintPos = cc.p(160, 86)
		},
		[var_0_1.horseRace] = {
			node = arg_16_0.horseRace,
			redHintPos = cc.p(170, 88)
		},
		[var_0_1.itemBuy2] = {
			node = arg_16_0.shop,
			redHintPos = cc.p(154, 78)
		},
		[var_0_1.playPassport] = {
			node = arg_16_0.signIn,
			redHintPos = cc.p(162, 74)
		}
	}
end

function var_0_0.onItemClick(arg_17_0, arg_17_1)
	if arg_17_1.func then
		arg_17_1.func(function(...)
			local var_18_0 = clone(arg_17_1.params or {})

			for iter_18_0, iter_18_1 in ipairs({
				...
			}) do
				table.insert(var_18_0, iter_18_1)
			end

			gGameUI:stackUI(arg_17_1.viewName, nil, arg_17_1.styles, unpack(var_18_0))
		end, arg_17_1.params or {})
	elseif arg_17_1.viewName then
		gGameUI:stackUI(arg_17_1.viewName, nil, arg_17_1.styles, unpack(arg_17_1.params or {}))
	end
end

return var_0_0
