local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("GymLog", var_0_0)
local var_0_2 = 46
local var_0_3 = 40
local var_0_4 = 80
local var_0_5 = {
	gymClosed = 19,
	gymReset = 1
}
local var_0_6 = {
	"gymReset",
	"gymFubenPass",
	"gymAllPass",
	"gymOccupy",
	"gymLeaderWin",
	"gymLeaderFail",
	"crossGymLeaderOccupy",
	"crossGymOccupy",
	"crossGymLeaderWin",
	"crossGymWin",
	"crossGymLeaderFail",
	"crossGymFail",
	"gymLeaderDefenceWin",
	"gymLeaderDefenceFail",
	"crossGymLeaderDefenceWin",
	"crossGymLeaderDefenceFail",
	"crossGymDefenceWin",
	"crossGymDefenceFail",
	"gymClosed",
	"gymGarrison2",
	"gymPassGate2"
}

var_0_1.RESOURCE_FILENAME = "gym_log.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	recordList = {
		varname = "recordList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("logDatas"),
				item = bindHelper.self("item"),
				time = bindHelper.self("lastTime"),
				preloadCenterIndex = bindHelper.self("preloadCenterIndex"),
				itemAction = {
					isAction = true
				},
				preloadBottom = bindHelper.self("preloadBottom"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = var_0_4
					local var_1_1 = arg_1_3.time
					local var_1_2, var_1_3 = time.getHourAndMin(arg_1_3.time)
					local var_1_4 = time.getDate(arg_1_3.time)

					arg_1_1:get("textTime"):text(string.format("[%02d:%02d]", var_1_4.hour, var_1_4.min))

					local var_1_5 = ""
					local var_1_6 = {}

					if var_0_6[arg_1_3.type] == "gymClosed" then
						if arg_1_3.pass_num > 0 then
							var_1_5 = gLanguageCsv[var_0_6[arg_1_3.type]] .. "\n" .. string.format(gLanguageCsv.gymPassGate1, arg_1_3.pass_num)
						else
							var_1_5 = gLanguageCsv[var_0_6[arg_1_3.type]] .. "\n" .. string.format(gLanguageCsv.gymPassGate2, arg_1_3.pass_num)
						end

						if arg_1_3.leader_gym_id then
							local var_1_7 = csv.gym.gym[arg_1_3.leader_gym_id].name
							local var_1_8 = csv.gym.gym[arg_1_3.leader_gym_id].fontColor

							var_1_5 = var_1_5 .. "\n" .. string.format(gLanguageCsv.gymGarrison1, var_1_8 .. var_1_7 .. "#C0xFFFFFF#", "#T44-0.8#")
						end

						if arg_1_3.cross_leader_gym_id then
							local var_1_9 = csv.gym.gym[arg_1_3.cross_leader_gym_id].name
							local var_1_10 = csv.gym.gym[arg_1_3.cross_leader_gym_id].fontColor

							var_1_5 = var_1_5 .. "\n" .. string.format(gLanguageCsv.gymGarrison1, var_1_10 .. gLanguageCsv.crossServer .. var_1_9 .. "#C0xFFFFFF#", "#T45-0.8#")
						end

						if arg_1_3.cross_gym_id then
							local var_1_11 = csv.gym.gym[arg_1_3.cross_gym_id].name
							local var_1_12 = csv.gym.gym[arg_1_3.cross_gym_id].fontColor

							var_1_5 = var_1_5 .. "\n" .. string.format(gLanguageCsv.gymGarrison2, var_1_12 .. gLanguageCsv.crossServer .. var_1_11 .. "#C0xFFFFFF#", "#T45-0.8#")
						end
					elseif arg_1_3.gym_id then
						local var_1_13 = csv.gym.gym[arg_1_3.gym_id].fontColor
						local var_1_14 = csv.gym.gym[arg_1_3.gym_id].name

						if string.find(var_0_6[arg_1_3.type], "cross") then
							var_1_5 = string.format(gLanguageCsv[var_0_6[arg_1_3.type]], var_1_13 .. gLanguageCsv.crossServer .. var_1_14 .. "#C0xFFFFFF#")
						else
							var_1_5 = string.format(gLanguageCsv[var_0_6[arg_1_3.type]], var_1_13 .. var_1_14 .. "#C0xFFFFFF#")
						end

						var_1_5 = string.format(var_1_5, var_1_13 .. var_1_14 .. "#C0xFFFFFF#")

						if arg_1_3.gym_battle_history then
							var_1_5 = var_1_5 .. "#LULgymLog##Icommon/btn/img_ckxq.png-182-54#"
							var_1_6 = arg_1_3.gym_battle_history
						end
					else
						var_1_5 = gLanguageCsv[var_0_6[arg_1_3.type]]
					end

					local var_1_15 = rich.createWithWidth(var_1_5, 40, nil, 2000, 34):addTo(arg_1_1, 10, "text"):anchorPoint(cc.p(0, 1)):xy(cc.p(330, 40)):formatText()

					uiEasy.setUrlHandler(var_1_15, var_1_6)

					local var_1_16 = var_1_15:height()
					local var_1_17 = var_1_0 - var_0_2 + var_1_15:height()

					var_1_15:xy(330, (var_0_4 - var_0_2) / 2 + var_1_16)
					arg_1_1:get("textTime"):y((var_0_4 - var_0_2) / 2 + var_1_16 - var_0_2 / 2)

					if arg_1_3.showDate then
						arg_1_1:get("textDate"):text(var_1_4.month .. "." .. var_1_4.day)
						arg_1_1:get("imgSlider1"):show()

						var_1_17 = var_1_17 + 100

						arg_1_1:get("textDate"):y(var_1_17 - 50)
						arg_1_1:get("imgSlider1"):y(var_1_17 - 50)
					else
						arg_1_1:get("textDate"):hide()
						arg_1_1:get("imgSlider1"):hide()
					end

					if arg_1_3.showTitle then
						arg_1_1:get("imgWeek"):y(var_1_17 + 10)

						var_1_17 = var_1_17 + 60

						arg_1_1:get("imgWeek"):show()

						if arg_1_3.weekType == 1 then
							arg_1_1:get("imgWeek.textNote"):text(gLanguageCsv.lastWeek)
						else
							arg_1_1:get("imgWeek.textNote"):text(gLanguageCsv.thisWeek)
						end
					end

					arg_1_1:height(var_1_17)
					arg_1_1:get("imgSlider2"):height(var_1_17)

					if var_1_1 > arg_1_0.time and arg_1_2 > #arg_1_0.data - 5 then
						arg_1_1:get("imgNew"):y((var_0_4 - var_0_2) / 2 + var_1_16 - var_0_2 / 2):show()
					end
				end
			},
			handlers = {
				detailClick = bindHelper.self("onDetailClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_2_0)
	gGameUI.topuiManager:createView("default", arg_2_0, {
		onClose = arg_2_0:createHandler("onClose")
	}):init({
		subTitle = "CHALLENGE LOG",
		title = "common/txt/txt_bt_daochangrizhi.png"
	})
	arg_2_0:initData()

	arg_2_0.lastTime = userDefault.getForeverLocalKey("gymLogOpenTime", 0)

	if arg_2_0.preloadCenterIndex then
		dataEasy.tryCallFunc(arg_2_0.recordList, "updatePreloadCenterIndex")
	else
		arg_2_0.preloadBottom = true
	end
end

function var_0_1.onCleanup(arg_3_0)
	local var_3_0 = arg_3_0.recordList:getCenterItemInCurrentView()

	if var_3_0 then
		arg_3_0.preloadCenterIndex = arg_3_0.recordList:getIndex(var_3_0) + 1
	end

	arg_3_0.preloadBottom = nil

	var_0_0.onCleanup(arg_3_0)
end

function var_0_1.initData(arg_4_0)
	local var_4_0 = gGameModel.gym:read("record")
	local var_4_1 = var_4_0.last_logs or {}
	local var_4_2 = var_4_0.logs or {}
	local var_4_3 = var_4_0.gym_close_info or {}
	local var_4_4 = var_4_0.last_gym_close_info or {}
	local var_4_5 = {}

	for iter_4_0, iter_4_1 in pairs(var_4_1) do
		local var_4_6 = table.shallowcopy(iter_4_1)

		var_4_6.weekType = 1

		table.insert(var_4_5, var_4_6)
	end

	for iter_4_2, iter_4_3 in pairs(var_4_2) do
		local var_4_7 = table.shallowcopy(iter_4_3)

		var_4_7.weekType = 2

		table.insert(var_4_5, table.shallowcopy(var_4_7))
	end

	local var_4_8 = time.getNumTimestamp(time.getWeekStrInClock(5))
	local var_4_9 = var_4_8 + 18000 - 604800

	table.insert(var_4_5, {
		weekType = 1,
		showTitle = true,
		time = var_4_9,
		type = var_0_5.gymReset
	})

	local var_4_10 = var_4_8 + 18000

	table.insert(var_4_5, {
		weekType = 2,
		showTitle = true,
		time = var_4_10,
		type = var_0_5.gymReset
	})

	local var_4_11 = var_4_8 - 7200 - 900

	if var_4_11 < time.getTime() then
		table.insert(var_4_5, {
			weekType = 1,
			time = var_4_11,
			type = var_0_5.gymClosed,
			pass_num = var_4_4.pass_num or 0,
			leader_gym_id = var_4_4.leader_gym_id,
			cross_leader_gym_id = var_4_4.cross_leader_gym_id,
			cross_gym_id = var_4_4.cross_gym_id
		})
	end

	local var_4_12 = var_4_8 + 604800 - 7200 - 900

	if var_4_12 < time.getTime() then
		table.insert(var_4_5, {
			weekType = 2,
			time = var_4_12,
			type = var_0_5.gymClosed,
			pass_num = var_4_3.pass_num or 0,
			leader_gym_id = var_4_3.leader_gym_id,
			cross_leader_gym_id = var_4_3.cross_leader_gym_id,
			cross_gym_id = var_4_3.cross_gym_id
		})
	end

	table.sort(var_4_5, function(arg_5_0, arg_5_1)
		if arg_5_0.time == arg_5_1.time then
			return arg_5_0.type < arg_5_1.type
		else
			return arg_5_0.time < arg_5_1.time
		end
	end)

	for iter_4_4, iter_4_5 in ipairs(var_4_5) do
		if iter_4_4 == 1 then
			iter_4_5.showDate = true
		elseif time.getDate(iter_4_5.time).yday ~= time.getDate(var_4_5[iter_4_4 - 1].time).yday then
			iter_4_5.showDate = true
		else
			iter_4_5.showDate = false
		end
	end

	arg_4_0.logDatas = idlers.newWithMap(var_4_5)
end

return var_0_1
