
local ActivityLimitDayGiftDialog = class("ActivityLimitDayGiftDialog", Dialog)

ActivityLimitDayGiftDialog.RESOURCE_FILENAME = "activity_limit_day_gift.json"
ActivityLimitDayGiftDialog.RESOURCE_BINDING = {
	["btnClose"] = {
		varname = "btnClose",
		binds = {
			event = "touch",
			methods = {ended = bindHelper.self("onClose")}
		},
	},
	["textCountDown"] = {
		varname = "textCountDown",
		binds = {
			event = "effect",
			data = { outline = { color = ui.NEWCOLORS.OUTLINE.BLACK, size = 4 } }
		},
	},
	["textNode"] = {
		varname = "textNode",
		binds = {
			event = "effect",
			data = { outline = { color = ui.NEWCOLORS.OUTLINE.BLACK, size = 4 } }
		},
	},
	["list"] = "awardList",
	["buyBtn"] = {
		varname = "btnBuy",
		binds = {
			event = "touch",
			methods = { ended = bindHelper.self("onBuyClick") }
		},
	},
	["buyBtn.label"] = {
		binds = {
			event = "effect",
			data = { outline = { color = ui.NEWCOLORS.OUTLINE.YELLOW, size = 4 } }
		},
	},
}

function ActivityLimitDayGiftDialog:onCreate(activityId )
	userDefault.setCurrDayKey("popLimitDayGift", true)
	gGameModel.currday_dispatch:getIdlerOrigin("redHintDaily")
	:modify(function(data)
		data[game.DAILY_REDHINT.limitDayGift] = true
	end, true)

	self.activityId = activityId

	self:initModel()
	self:initData()
	-- self:initCountDown()

	Dialog.onCreate(self,{blackType = 1})
end

-- 初始化model
function ActivityLimitDayGiftDialog:initModel()
	self.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
end
--初始化界面
function ActivityLimitDayGiftDialog:initData()
	-- 每日奖励数据
	self.giftData = {}
	local yyCfg = csv.yunying.yyhuodong[self.activityId]
	local huodongID = yyCfg.huodongID
	for k, v in csvPairs(csv.yunying.directbuygift) do
		if v.huodongID == huodongID then
			self.giftData = {
				csvId = k,
				cfg = v
			}
			self:initGiftData(v)
			break
		end
	end

	idlereasy.when(self.yyhuodongs,function(_, yyhuodong)
		local yydata = yyhuodong[self.activityId]
		local stamps2 = yydata.stamps2 or {}
		local stamps = yydata.stamps or {}
		local buyTimes = stamps[self.giftData.csvId] or 0
		local gayState = 1
		if buyTimes > 0 then
			self.btnBuy:get("label"):text(gLanguageCsv.received)
			gayState = 2
		else
			local payInfo = csv.recharges[self.giftData.cfg.rechargeID]
			self.btnBuy:get("label"):text(string.format(gLanguageCsv.symbolMoney, payInfo.rmbDisplay))
		end

		uiEasy.setBtnShader(self.btnBuy, nil, gayState)

		self:initCountDown(stamps2[self.activityId])
	end)

end

function ActivityLimitDayGiftDialog:initGiftData(data)
	uiEasy.createItemsToList(self, self.awardList, data.item, {margin = 10, scale = 1, onAfterBuild = function()
		self.awardList:setItemAlignCenter()
	end})
end

--倒计时
function ActivityLimitDayGiftDialog:initCountDown(startTime)
	local textTime = self.textCountDown
	local yyCfg = csv.yunying.yyhuodong[self.activityId]
	
	local endTime = startTime + yyCfg.paramMap.countdown * 60
	local function setLabel()
		local remainTime = time.getCutDown(endTime - time.getTime())
		textTime:text(remainTime.str)

		if endTime - time.getTime() <= 0 then
			textTime:text(gLanguageCsv.activityOver)
			self.textNode:hide()
			self:unSchedule(1)
			return false
		end
		return true
	end
	self:enableSchedule()
	self:schedule(function(dt)
		if not setLabel() then
			return false
		end
	end, 1, 0, 1)
end

function ActivityLimitDayGiftDialog:onBuyClick()
	local activityId = self.activityId
	local giftCsv = self.giftData.cfg
	
	gGameApp:payDirect(self, {rechargeId = giftCsv.rechargeID, yyID = activityId, csvID = self.giftData.csvId, name = giftCsv.name, buyTimes = giftCsv.limit}, self.clientBuyTimes)
		:serverCb(function()
			gGameUI:showGainDisplay(giftCsv.item, {raw = false})
		end)
		:doit()
end


return ActivityLimitDayGiftDialog










