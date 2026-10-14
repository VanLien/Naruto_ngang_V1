local var_0_0 = require("app.views.city.setting.view")
local var_0_1 = var_0_0.BTN_TYPE
local var_0_2 = var_0_0.BTN_DATA
local var_0_3 = {
	OPEN = 100,
	CLOSE = 0
}

local function var_0_4(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = var_0_2[arg_1_1]

	if arg_1_1 == var_0_1.BTN then
		arg_1_0:texture(arg_1_2 and var_1_0.resNormal or var_1_0.resSelected)

		local var_1_1 = arg_1_0:get("btnImg")

		if arg_1_2 then
			var_1_1:xy(30, 30)
		else
			var_1_1:xy(100, 30)
		end
	elseif arg_1_1 == var_0_1.RADIO then
		arg_1_0:get("btnImg"):visible(arg_1_2)
	end
end

local var_0_5 = cc.load("mvc").ViewBase
local var_0_6 = class("SettingVoiceView", var_0_5)

var_0_6.RESOURCE_FILENAME = "setting_voice.json"
var_0_6.RESOURCE_BINDING = {
	["centerPanel.item"] = "listItem",
	centerPanel = "centerPanel",
	["centerPanel.itemBattleVoice.slider"] = "btSlider",
	["centerPanel.itemBgVoice.slider"] = "bgSlider",
	["centerPanel.slidrBg"] = "sliderBg",
	["centerPanel.text"] = "bottomText",
	["centerPanel.itemBgVoice.btn"] = {
		varname = "itemBgVoiceBtn",
		binds = {
			event = "click",
			method = bindHelper.self("onBgVoiceOpen")
		}
	},
	["centerPanel.itemBattleVoice.btn"] = {
		varname = "itemBattleVoiceBtn",
		binds = {
			event = "click",
			method = bindHelper.self("onBattleVocieOpen")
		}
	},
	["centerPanel.musicList"] = {
		varname = "musicList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 8,
				data = bindHelper.self("listData"),
				item = bindHelper.self("listItem"),
				sliderBg = bindHelper.self("sliderBg"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("switch", "musicName", "voiceImg", "check")

					var_2_0.musicName:text(arg_2_3.cfg.name)
					var_2_0.voiceImg:visible(arg_2_3.inTest)
					var_2_0.check:setSelectedState(arg_2_3.selected)
					var_2_0.switch:setSelectedState(arg_2_3.inTest)
					bind.touch(arg_2_0, arg_2_1, {
						methods = {
							ended = functools.partial(arg_2_0.playMusic, arg_2_2, arg_2_3)
						}
					})
					var_2_0.switch:onEvent(functools.partial(arg_2_0.playTestMusic, arg_2_2, arg_2_3))
				end,
				onBeforeBuild = function(arg_3_0)
					if arg_3_0.sliderBg:visible() then
						local var_3_0, var_3_1 = arg_3_0:xy()
						local var_3_2 = arg_3_0:size()
						local var_3_3, var_3_4 = arg_3_0.sliderBg:xy()
						local var_3_5 = arg_3_0.sliderBg:size()

						arg_3_0:setScrollBarEnabled(true)
						arg_3_0:setScrollBarColor(cc.c3b(245, 156, 2))
						arg_3_0:setScrollBarOpacity(255)
						arg_3_0:setScrollBarAutoHideEnabled(false)
						arg_3_0:setScrollBarPositionFromCorner(cc.p(var_3_0 + var_3_2.width - var_3_3, (var_3_2.height - var_3_5.height) / 2 + 5))
						arg_3_0:setScrollBarWidth(var_3_5.width)
						arg_3_0:refreshView()
					else
						arg_3_0:setScrollBarEnabled(false)
					end
				end
			},
			handlers = {
				playMusic = bindHelper.self("onPlayMusic"),
				playTestMusic = bindHelper.self("onPlayTestMusic")
			}
		}
	}
}

local function var_0_7(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	arg_4_0:set(arg_4_4())
	idlereasy.when(arg_4_0, function(arg_5_0, arg_5_1)
		local var_5_0 = arg_5_1 == var_0_3.CLOSE

		arg_4_1:setPercent(arg_5_1)
		var_0_4(arg_4_2, var_0_1.BTN, var_5_0)
		arg_4_3(arg_5_1)
	end)
	arg_4_1:addEventListener(function(arg_6_0, arg_6_1)
		if arg_6_1 == ccui.SliderEventType.percentChanged then
			arg_4_0:set(arg_6_0:getPercent())
		end
	end)
end

function var_0_6.onCreate(arg_7_0)
	arg_7_0.bgVoiceState = idler.new()

	var_0_7(arg_7_0.bgVoiceState, arg_7_0.bgSlider, arg_7_0.itemBgVoiceBtn, function(arg_8_0)
		local var_8_0 = arg_8_0 / 100

		audio.setMusicVolume(var_8_0)
		userDefault.setForeverLocalKey("musicVolume", arg_8_0, {
			rawKey = true
		})
	end, function()
		return userDefault.getForeverLocalKey("musicVolume", 100, {
			rawKey = true
		})
	end)

	arg_7_0.battleVoiceState = idler.new()

	var_0_7(arg_7_0.battleVoiceState, arg_7_0.btSlider, arg_7_0.itemBattleVoiceBtn, function(arg_10_0)
		local var_10_0 = arg_10_0 / 100

		audio.setSoundsVolume(var_10_0)
		userDefault.setForeverLocalKey("effectVolume", arg_10_0, {
			rawKey = true
		})
	end, function()
		return userDefault.getForeverLocalKey("effectVolume", 100, {
			rawKey = true
		})
	end)
	arg_7_0.sliderBg:setVisible(csvSize(csv.citysound) > 3)

	local var_7_0 = userDefault.getForeverLocalKey("musicIdx", 1)
	local var_7_1 = {}

	for iter_7_0, iter_7_1 in orderCsvPairs(csv.citysound) do
		table.insert(var_7_1, {
			inTest = false,
			cfg = iter_7_1,
			selected = var_7_0 == iter_7_0
		})
	end

	arg_7_0.listData = idlers.newWithMap(var_7_1)
end

function var_0_6.onBattleVocieOpen(arg_12_0)
	local var_12_0 = arg_12_0.battleVoiceState:read() > var_0_3.CLOSE

	arg_12_0.battleVoiceState:set(var_12_0 and var_0_3.CLOSE or var_0_3.OPEN)
end

function var_0_6.onBgVoiceOpen(arg_13_0)
	local var_13_0 = arg_13_0.bgVoiceState:read() > var_0_3.CLOSE

	arg_13_0.bgVoiceState:set(var_13_0 and var_0_3.CLOSE or var_0_3.OPEN)
end

function var_0_6.onCleanup(arg_14_0)
	if arg_14_0.inTest then
		local var_14_0 = userDefault.getForeverLocalKey("musicIdx", 1)

		audio.playMusic(csv.citysound[var_14_0].path)
	end

	var_0_5.onCleanup(arg_14_0)
end

function var_0_6.onPlayMusic(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	for iter_15_0, iter_15_1 in arg_15_0.listData:pairs() do
		local var_15_0 = iter_15_1:proxy()

		var_15_0.inTest = false
		var_15_0.selected = iter_15_0 == arg_15_2
	end

	audio.playMusic(arg_15_3.cfg.path, true, true)
	userDefault.setForeverLocalKey("musicIdx", arg_15_2)
end

function var_0_6.onPlayTestMusic(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0

	for iter_16_0, iter_16_1 in arg_16_0.listData:pairs() do
		local var_16_1 = iter_16_1:proxy()

		if iter_16_0 == arg_16_2 then
			var_16_1.inTest = not var_16_1.inTest
			arg_16_0.inTest = var_16_1.inTest
		else
			var_16_1.inTest = false
		end

		if var_16_1.selected then
			var_16_0 = var_16_1
		end
	end

	if arg_16_0.inTest then
		audio.playMusic(arg_16_3.cfg.path, true, true)
	else
		audio.playMusic(var_16_0.cfg.path)
	end
end

return var_0_6
