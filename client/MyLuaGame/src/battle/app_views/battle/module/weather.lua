local var_0_0 = class("WeatherInfo", battleModule.CBase)

function var_0_0.ctor(arg_1_0, arg_1_1)
	battleModule.CBase.ctor(arg_1_0, arg_1_1)

	arg_1_0.weatherLayer = arg_1_0.parent.weatherLayer
	arg_1_0.weatherInfo = arg_1_0.parent.UIWidgetMid:get("widgetPanel.weatherInfo")
	arg_1_0.weatherView = arg_1_0.parent.UIWidgetMid:get("widgetPanel.topinfo.weather")
	arg_1_0.effect = nil
	arg_1_0.curWeatherId = nil

	arg_1_0:init()

	arg_1_0.originSize = arg_1_0.weatherView:getContentSize()
end

function var_0_0.init(arg_2_0)
	arg_2_0.weatherInfo:setVisible(false)

	local var_2_0

	arg_2_0.weatherView:addTouchEventListener(function(arg_3_0, arg_3_1)
		if arg_3_1 == ccui.TouchEventType.began then
			var_2_0 = performWithDelay(arg_2_0.weatherLayer, function()
				var_2_0 = nil

				arg_2_0:initInfoPanel(true)
				arg_2_0.weatherInfo:setVisible(true)
			end, 0.4)
		elseif arg_3_1 == ccui.TouchEventType.ended or arg_3_1 == ccui.TouchEventType.canceled then
			arg_2_0.weatherLayer:stopAction(var_2_0)

			var_2_0 = nil

			arg_2_0:initInfoPanel(false)
			arg_2_0.weatherInfo:setVisible(false)
		end
	end)
end

function var_0_0.initInfoPanel(arg_5_0, arg_5_1)
	arg_5_0.weatherInfo:setVisible(arg_5_1)

	if not arg_5_1 then
		return
	end

	local var_5_0 = csv.weather[arg_5_0.curWeatherId]

	arg_5_0.weatherInfo:get("name"):setString(var_5_0.name)

	if arg_5_0.model.lifeRound > 99 then
		nodetools.get(arg_5_0.weatherInfo, "desc"):setString(gLanguageCsv.forever)
	else
		nodetools.get(arg_5_0.weatherInfo, "desc"):setString(string.format(gLanguageCsv.leftRounds, arg_5_0.model.lifeRound))
	end

	local var_5_1 = arg_5_0.weatherInfo:get("describe")

	var_5_1:removeAllChildren()

	local var_5_2 = var_5_1:getContentSize()
	local var_5_3 = rich.createWithWidth(string.format("#C0x5b545b#%s", var_5_0.describe), 42, nil, var_5_2.width)

	var_5_3:setAnchorPoint(cc.p(0, 1))
	var_5_1:add(var_5_3)

	local var_5_4 = arg_5_0.weatherInfo:get("bg")
	local var_5_5 = var_5_4:getContentSize()
	local var_5_6 = var_5_3:getContentSize().height
	local var_5_7 = var_5_1:getPositionY() + var_5_6 + 5

	var_5_4:setContentSize(cc.size(var_5_5.width, var_5_7 > arg_5_0.originSize.height and var_5_7 or arg_5_0.originSize.height))
end

function var_0_0.onWeatherRefresh(arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_2.isShow then
		arg_6_0.weatherView:setVisible(false)

		if arg_6_0.effect then
			arg_6_0.effect:play("effect_danchu")
		end

		arg_6_0.curWeatherId = nil
	else
		arg_6_0.cfg = csv.weather[arg_6_2.weatherCfgId]

		if arg_6_2.weatherCfgId ~= arg_6_0.curWeatherId then
			if arg_6_0.effect then
				arg_6_0.effect:play("effect_danchu")
				performWithDelay(arg_6_0.weatherLayer, function()
					arg_6_0:onShowWeatherAnimation(arg_6_0.cfg.effectRes)
				end, 1)
			else
				arg_6_0:onShowWeatherAnimation(arg_6_0.cfg.effectRes)
			end
		end

		arg_6_0.weatherView:get("icon"):loadTexture(arg_6_0.cfg.iconRes)
		arg_6_0.weatherView:setVisible(true)

		arg_6_0.model = arg_6_2
		arg_6_0.curWeatherId = arg_6_0.model.weatherCfgId

		nodetools.get(arg_6_0.weatherView, "weatherDesc"):setString(arg_6_0.cfg and arg_6_0.cfg.name)

		if arg_6_0.model.lifeRound > 99 then
			nodetools.get(arg_6_0.weatherView, "roundDesc"):setString(gLanguageCsv.forever)
		else
			nodetools.get(arg_6_0.weatherView, "roundDesc"):setString(string.format(gLanguageCsv.leftRounds, arg_6_0.model.lifeRound))
		end
	end
end

function var_0_0.onShowWeatherAnimation(arg_8_0, arg_8_1)
	if arg_8_0.effect then
		arg_8_0.effect:removeFromParent()
	end

	if not arg_8_1 then
		return
	end

	arg_8_0.effect = newCSprite(arg_8_1)

	arg_8_0.effect:xy(display.cx, display.cy):scale(2):play("effect_danru")
	performWithDelay(arg_8_0.weatherLayer, function()
		arg_8_0.effect:play("effect_loop")
	end, 1)
	arg_8_0.weatherLayer:add(arg_8_0.effect, 9999)
end

return var_0_0
