local var_0_0 = require("app.views.city.activity.brave_challenge.adapt")
local var_0_1 = {
	CAN_NOT_GOTTEN = 2,
	CAN_GOTTEN = 1,
	GOTTEN = 0
}
local var_0_2 = class("BraveChallengeAchvView", Dialog)

var_0_2.RESOURCE_FILENAME = "activity_brave_challenge_achievement.json"
var_0_2.RESOURCE_BINDING = {
	rankItem = "rankItem",
	["leftPanel.tabItem"] = "tabItem",
	rewardPanel1 = "rewardPanel1",
	["topPanel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["leftPanel.tabList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("tabItem"),
				showTab = bindHelper.self("showTab"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("normal")
					local var_1_1 = arg_1_1:get("selected")
					local var_1_2

					if arg_1_3.select then
						var_1_0:hide()

						var_1_2 = var_1_1:show()
					else
						var_1_1:hide()

						var_1_2 = var_1_0:show()
					end

					if arg_1_3.redHint then
						bind.extend(arg_1_0, arg_1_1, {
							class = "red_hint",
							props = {
								state = arg_1_0.showTab:read() ~= arg_1_2,
								specialTag = arg_1_3.redHint,
								listenData = {
									activityId = arg_1_3.id,
									sign = arg_1_3.sign,
									type = arg_1_3.type
								},
								onNode = function(arg_2_0)
									arg_2_0:xy(arg_1_1:width() - 10, arg_1_1:height() - 5)
								end
							}
						})
					end

					var_1_2:get("txt"):text(arg_1_3.name)
					var_1_1:setTouchEnabled(false)
					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	["rewardPanel1.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("achvDatas1"),
				item = bindHelper.self("rankItem"),
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("achvDesc", "btnGet", "list", "got")

					var_3_0.achvDesc:text(arg_3_3.desc)

					if next(arg_3_3.award) ~= nil then
						uiEasy.createItemsToList(arg_3_0, var_3_0.list, arg_3_3.award, {
							scale = 0.8
						})
					end

					var_3_0.list:setScrollBarEnabled(false)
					bind.touch(arg_3_0, var_3_0.btnGet, {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_3.csvId)
						}
					})
					var_3_0.got:visible(arg_3_3.get == var_0_1.GOTTEN)
					var_3_0.btnGet:visible(arg_3_3.get ~= var_0_1.GOTTEN)
					var_3_0.btnGet:get("txt"):text(arg_3_3.get == var_0_1.GOTTEN and gLanguageCsv.received or gLanguageCsv.spaceReceive)

					if arg_3_3.get ~= var_0_1.GOTTEN and arg_3_3.get ~= var_0_1.CAN_GOTTEN and arg_3_3.achType == 1 then
						if arg_3_3.targetType == 3 then
							var_3_0.btnGet:get("txt"):text("0/1")
						else
							var_3_0.btnGet:get("txt"):text(arg_3_3.progress .. "/" .. arg_3_3.targetArg1)
						end
					end

					uiEasy.setBtnShader(var_3_0.btnGet, var_3_0.btnGet:get("txt"), arg_3_3.get)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onGetBtn")
			}
		}
	}
}

function var_0_2.onCreate(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:initModel()

	arg_4_0.baseInfo = arg_4_2
	arg_4_0.activityId = arg_4_1
	arg_4_0.showTab = idler.new(1)
	arg_4_0.achvDatas1 = idlers.new()
	arg_4_0.achvDatas2 = idlers.new()
	arg_4_0.tabDatas = idlers.newWithMap({
		{
			redHint = "braveChallengeAch",
			type = 1,
			name = gLanguageCsv.achievement,
			id = arg_4_0.activityId,
			sign = var_0_0.typ
		},
		{
			redHint = "braveChallengeAch",
			type = 2,
			name = gLanguageCsv.specialAchievement,
			id = arg_4_0.activityId,
			sign = var_0_0.typ
		}
	})

	local var_4_0 = var_0_0.typ == game.BRAVE_CHALLENGE_TYPE.anniversary

	arg_4_0.idler = var_4_0 and arg_4_0.yyhuodongs or arg_4_0.commonBCData

	idlereasy.when(arg_4_0.idler, function(arg_5_0, arg_5_1)
		local var_5_0 = arg_5_1 or {}

		if var_4_0 then
			var_5_0 = arg_5_1[arg_4_0.activityId] or {}
		end

		local var_5_1 = var_5_0.valsums or {}
		local var_5_2 = {}
		local var_5_3 = {}

		for iter_5_0, iter_5_1 in orderCsvPairs(csv.brave_challenge.achievement) do
			if iter_5_1.groupID == arg_4_0.baseInfo.achiSeqID then
				local var_5_4 = table.shallowcopy(iter_5_1)

				var_5_4.csvId = iter_5_0
				var_5_4.get = (var_5_0.stamps or {})[iter_5_0]
				var_5_4.progress = var_5_1[iter_5_0] or 0
				var_5_4.achType = iter_5_1.type

				if iter_5_1.type == 1 then
					table.insert(var_5_2, var_5_4)
				else
					table.insert(var_5_3, var_5_4)
				end
			end
		end

		arg_4_0.datas = {
			var_5_2,
			var_5_3
		}

		arg_4_0.achvDatas1:update(arg_4_0.datas[arg_4_0.showTab:read()])
	end)
	arg_4_0.showTab:addListener(function(arg_6_0, arg_6_1)
		arg_4_0.tabDatas:atproxy(arg_6_1).select = false
		arg_4_0.tabDatas:atproxy(arg_6_0).select = true

		arg_4_0.achvDatas1:update(arg_4_0.datas[arg_6_0])
	end)
	arg_4_0.rewardPanel1:show()
	Dialog.onCreate(arg_4_0)
end

function var_0_2.initModel(arg_7_0)
	arg_7_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_7_0.commonBCData = gGameModel.role:getIdler("normal_brave_challenge")
end

function var_0_2.onTabClick(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0.showTab:set(arg_8_2)
end

function var_0_2.onGetBtn(arg_9_0, arg_9_1, arg_9_2)
	gGameApp:requestServer(var_0_0.url("award"), function(arg_10_0)
		gGameUI:showGainDisplay(arg_10_0)
	end, arg_9_0.activityId, arg_9_2)
end

function var_0_2.onSortCards(arg_11_0, arg_11_1)
	return function(arg_12_0, arg_12_1)
		local var_12_0 = arg_12_0.get or 0.5
		local var_12_1 = arg_12_1.get or 0.5

		if var_12_0 ~= var_12_1 then
			return var_12_1 < var_12_0
		end

		return arg_12_0.csvId < arg_12_1.csvId
	end
end

return var_0_2
