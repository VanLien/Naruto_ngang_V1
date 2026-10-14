#!/usr/bin/python
# -*- coding: utf-8 -*-
'''
Copyright (c) 2014 YouMi Information Technology Inc.
'''

from __future__ import absolute_import

import copy

import framework
from tornado.gen import coroutine, Return, moment
from game.object.game.fake import FakeTrainer, FakeExplorer, FakeUnionSkills, FakeTalentTree, FakeZawake
from game.object.game.robot import setRobotCard
from framework import nowdatetime_t, nowdate_t, date2int, nowtime_t, period2date, todayinclock5elapsedays, perioddate2int, todayinclock5date2int, int2date, inclock5date, OneDay, int2time, datetimefromtimestamp, datetime2timestamp, weekinclock5date2int,monthinclock5date2int, todayelapsedays, DailyRefreshHour, str2num_t
from framework.csv import csv, ErrDefs, ConstDefs, MergeServ
from framework.log import logger
from framework.object import ReloadHooker
from framework.helper import WeightRandomObject, getL10nCsvValue, addDict
from framework.distributed.helper import node_key2domains, node_key2id

from game import ClientError
from game import globaldata
from game.object import YYHuoDongDefs, DrawSumBoxDefs, RechargeDefs, TargetDefs, PasspostDefs, RetrieveDefs, DrawGemDefs, ReunionDefs, TaskDefs, PlayPassportDefs, SceneDefs, AttrDefs, BraveChallengeDefs, AchievementDefs, YYDispatchDefs, YYVolleyballDefs
from game.object import DrawCardDefs, DrawEquipDefs, DrawItemDefs, ItemDefs
from game.session import Session

from game.globaldata import DailyRecordRefreshTime, YYHuoDongTargetsAwardMailID, YYHuoDongFightRankLevelAwardMailID, YYHuoDongFightRankPointAwardMailID, YYHuoDongLuckyCatMessageMax, YY2048GameMailID, CommonMonthCardMailID, SuperMonthCardMailID, YYHuodongMailID, YYHuoDongRechargeWheelMessageMax, YYHuoDongDouble11LotteryMailID, NormalBraveChallengePlayID
from game.object.game.gm import ObjectGMYYConfig
from game.object.game.gain import ObjectGainAux, ObjectCostAux, ObjectGainEffect as ObjectYYHuoDongEffect
from game.object.game.message import ObjectMessageGlobal
from game.object.game.task import ObjectTasksMap
from game.object.game.huodong import ObjectHuoDongOnceBase, ObjectHuoDongDailyBase, ObjectHuoDongWeekBase
from game.object.game.lottery import ObjectDrawCardRandom, ObjectDrawEquipRandom, ObjectDrawItemRandom, ObjectDrawEffect, ObjectDrawGemRandom
from game.object.game.servrecord import ObjectServerGlobalRecord
from game.object.game.costcsv import ObjectCostCSV
from game.object.game.target import predGen

import math
import random
import datetime
import bisect
import json
from collections import defaultdict

from src import game

#
# ObjectYYHuoDongDecorator
#

class ObjectYYHuoDongDecorator(object):

	# yyhuodong.csv???huodong.csv???
	# self._cfg?ObjectHuoDongBase?
	@property
	def name(self):
		return self._cfg.desc

	@property
	def desc(self):
		return getL10nCsvValue(self._cfg, 'desc')

	@property
	def gmConfig(self):
		if self.id in ObjectGMYYConfig.Singleton.yyhuodong:
			return ObjectGMYYConfig.Singleton.yyhuodong[self.id]
		return None

	@property
	def type(self):
		gm = self.gmConfig
		if gm and 'type' in gm:
			return gm['type']
		return self._cfg.type

	@property
	def displayNoOpen(self):
		gm = self.gmConfig
		if gm and 'displayNoOpen' in gm:
			return gm['displayNoOpen']
		return self._cfg.displayNoOpen

	@property
	def servers(self):
		gm = self.gmConfig
		if gm and 'servers' in gm:
			return gm['servers']
		return self._cfg.servers

	@property
	def languages(self):
		gm = self.gmConfig
		if gm and 'languages' in gm:
			return gm['languages']
		return self._cfg.languages

	@property
	def active(self):
		gm = self.gmConfig
		if gm and 'active' in gm:
			return gm['active']
		return self._cfg.active

	@property
	def huodongID(self):
		gm = self.gmConfig
		if gm and 'huodongID' in gm:
			return gm['huodongID']
		return self._cfg.huodongID

	@property
	def openType(self):
		gm = self.gmConfig
		if gm and 'openType' in gm:
			return gm['openType']
		return self._cfg.openType

	@property
	def openWeekDay(self):
		gm = self.gmConfig
		if gm and 'openWeekDay' in gm:
			return gm['openWeekDay']
		return self._cfg.openWeekDay

	@property
	def openDuration(self):
		gm = self.gmConfig
		if gm and 'openDuration' in gm:
			return gm['openDuration']
		return self._cfg.openDuration

	@property
	def beginDate(self):
		gm = self.gmConfig
		if gm and 'beginDate' in gm:
			return gm['beginDate']
		return self._cfg.beginDate

	@property
	def beginTime(self):
		gm = self.gmConfig
		if gm and 'beginTime' in gm:
			return gm['beginTime']
		return self._cfg.beginTime

	@property
	def endDate(self):
		gm = self.gmConfig
		if gm and 'endDate' in gm:
			return gm['endDate']
		return self._cfg.endDate

	@property
	def endTime(self):
		gm = self.gmConfig
		if gm and 'endTime' in gm:
			return gm['endTime']
		return self._cfg.endTime

	# ?????????
	@property
	def validServerOpenDateRange(self):
		gm = self.gmConfig
		if gm and 'validServerOpenDateRange' in gm:
			return gm['validServerOpenDateRange']
		return self._cfg.validServerOpenDateRange

	@property
	def _validServerOpenDateRangeLeast(self):
		return int2date(self.validServerOpenDateRange[0])

	# ??????
	@property
	def _validServerOpenDateRangeMost(self):
		return int2date(self.validServerOpenDateRange[1])

	# ?????????
	@property
	def validRoleCreatedDateRange(self):
		gm = self.gmConfig
		if gm and 'validRoleCreatedDateRange' in gm:
			return gm['validRoleCreatedDateRange']
		return self._cfg.validRoleCreatedDateRange

	@property
	def _validRoleCreatedDateRangeLeast(self):
		return int2date(self.validRoleCreatedDateRange[0])

	# ??????
	@property
	def _validRoleCreatedDateRangeMost(self):
		return int2date(self.validRoleCreatedDateRange[1])

	# ??????????
	@property
	def relativeDayRange(self):
		gm = self.gmConfig
		if gm and 'relativeDayRange' in gm:
			return gm['relativeDayRange']
		return self._cfg.relativeDayRange

	@property
	def _relativeDayRangeLeast(self):
		return datetime.timedelta(days=self.relativeDayRange[0])

	# ??????
	@property
	def _relativeDayRangeMost(self):
		return datetime.timedelta(days=self.relativeDayRange[1] + 1)

	@property
	def leastLevel(self):
		gm = self.gmConfig
		if gm and 'leastLevel' in gm:
			return gm['leastLevel']
		return self._cfg.leastLevel

	# 0, 1, 2 ? beginDateTime must be in serverDayRange
	# 3, 4 ? now must be in serverDayRange
	@property
	def leastVipLevel(self):
		gm = self.gmConfig
		if gm and 'leastVipLevel' in gm:
			return gm['leastVipLevel']
		return self._cfg.leastVipLevel

	@property
	def serverDayRange(self):
		gm = self.gmConfig
		if gm and 'serverDayRange' in gm:
			return gm['serverDayRange']
		return self._cfg.serverDayRange

	@property
	def _serverDayRangeLeast(self):
		return datetime.timedelta(days=self.serverDayRange[0])

	@property
	def _serverDayRangeMost(self):
		return datetime.timedelta(days=self.serverDayRange[1] + 1)

	@property
	def roleDayRange(self):
		gm = self.gmConfig
		if gm and 'roleDayRange' in gm:
			return gm['roleDayRange']
		return self._cfg.roleDayRange

	@property
	def _roleDayRangeLeast(self):
		return datetime.timedelta(days=self.roleDayRange[0])

	@property
	def _roleDayRangeMost(self):
		return datetime.timedelta(days=self.roleDayRange[1] + 1)

	@property
	def countType(self):
		gm = self.gmConfig
		if gm and 'countType' in gm:
			return gm['countType']
		return self._cfg.countType

	@property
	def paramMap(self):
		if hasattr(self, '_paramMap'):
			return self._paramMap

		gm = self.gmConfig
		if gm and 'paramMap' in gm:
			self._paramMap = self._cfg.paramMap.to_dict()
			self._paramMap.update(gm['paramMap'])
			return self._paramMap
		return self._cfg.paramMap

	def isValid(self, now=None):
		if not self.active:
			return False
		import framework
		if framework.__language__ not in self.languages:
			return False

		# ???????0-5??,????????
		date = globaldata.GameServOpenDatetime.date()
		if date < self._validServerOpenDateRangeLeast or date > self._validServerOpenDateRangeMost:
			return False

		now = now or nowdatetime_t()
		key = MergeServ.getSrcServKeys(Session.server.key)[0]
		domains = node_key2domains(key)
		serverKey, serverIdx = domains[1], int(domains[2])
		if serverKey in self.servers:
			serversRange = self.servers[serverKey]
			if int(serversRange[0]) <= serverIdx <= int(serversRange[1]):
				return now < self.endDateTime
		return False

	# serverDayRange??beginDateTime??????,??????serverDayRange
	# serverDayRange, relativeDayRange ??????????
	# serverDayRange ????????
	# relativeDayRange ?3,4?????
	def isOpen(self, now=None):
		now = now or nowdatetime_t()

		# ??????
		# ??????????
		beginDateTime = ObjectServerGlobalRecord.getYYHuoDongOpenTime(self.id)
		if beginDateTime:
			return True

		openDays = todayinclock5elapsedays(globaldata.GameServOpenDatetime) - todayinclock5elapsedays(min(now, self.beginDateTime))
		openDays = max(openDays, -1) # -1 ?????
		return self.serverDayRange[0] <= openDays <= self.serverDayRange[1]

	# roleDayRange?beginDateTime???????
	# roleDayRange ??????????
	# roleDayRange ????????
	def isRoleOpen(self, level, createdTime, vipLevel):
		# ??????
		if level < self.leastLevel:
			return False

		if vipLevel < self.leastVipLevel:
			return False

		# ??????
		date = inclock5date(datetimefromtimestamp(createdTime))
		if date < self._validRoleCreatedDateRangeLeast or date > self._validRoleCreatedDateRangeMost:
			return False

		# TODO:??????

		openDays = todayinclock5elapsedays(datetimefromtimestamp(createdTime)) - todayinclock5elapsedays(min(nowdatetime_t(), self.beginDateTime))
		openDays = max(openDays, -1) # -1 ?????
		return self.roleDayRange[0] <= openDays <= self.roleDayRange[1]

	# yyhuodong???????beginDateTime?endDateTime
	# ?????????
	def gameBeginDateTime(self, _):
		return self.beginDateTime

	def gameEndDateTime(self, _):
		return self.endDateTime

	def gameEventDelta(self, _, now=None):
		return self.eventDelta(now)


#
# ObjectYYHuoDongOnce
#

class ObjectYYHuoDongOnce(ObjectYYHuoDongDecorator, ObjectHuoDongOnceBase):
	def isValid(self, now=None):
		now = now or nowdatetime_t()
		# beginDateTime + openDuration
		if ObjectHuoDongOnceBase.isValid(self, now):
			# active, servers, endDateTime
			if ObjectYYHuoDongDecorator.isValid(self, now):
				return True
		return False

	def isOpen(self, now=None):
		now = now or nowdatetime_t()
		if ObjectHuoDongOnceBase.isOpen(self, now):
			if ObjectYYHuoDongDecorator.isOpen(self, now):
				# ????????
				ObjectServerGlobalRecord.setYYHuoDongOpenTime(self.id)
				return True
		ObjectServerGlobalRecord.delYYHuoDongOpenTime(self.id)
		return False

#
# ObjectYYHuoDongDaily
#

class ObjectYYHuoDongDaily(ObjectYYHuoDongDecorator, ObjectHuoDongDailyBase):
	def isOpen(self, now=None):
		now = now or nowdatetime_t()
		if ObjectHuoDongDailyBase.isOpen(self, now):
			if ObjectYYHuoDongDecorator.isOpen(self, now):
				# ????????
				ObjectServerGlobalRecord.setYYHuoDongOpenTime(self.id)
				return True
		ObjectServerGlobalRecord.delYYHuoDongOpenTime(self.id)
		return False


#
# ObjectYYHuoDongWeek
#

class ObjectYYHuoDongWeek(ObjectYYHuoDongDecorator, ObjectHuoDongWeekBase):
	def isOpen(self, now=None):
		now = now or nowdatetime_t()
		if ObjectHuoDongWeekBase.isOpen(self, now):
			if ObjectYYHuoDongDecorator.isOpen(self, now):
				# ????????
				ObjectServerGlobalRecord.setYYHuoDongOpenTime(self.id)
				return True
		ObjectServerGlobalRecord.delYYHuoDongOpenTime(self.id)
		return False


#
# ObjectYYHuoDongRelateServerOpen
#

class ObjectYYHuoDongRelateServerOpen(ObjectYYHuoDongOnce):
	'''
	??????
	beginTime,endTime,openDuration???
	'''

	def init(self):
		ObjectYYHuoDongOnce.init(self)

		servBeginDate = inclock5date(globaldata.GameServOpenDatetime) + self._relativeDayRangeLeast
		servEndDate = servBeginDate + self._relativeDayRangeMost - self._relativeDayRangeLeast

		self._beginDateTime = datetime.datetime.combine(max(servBeginDate, self._beginDate), globaldata.DailyRecordRefreshTime)
		self._endDateTime = datetime.datetime.combine(min(servEndDate, self._endDate), globaldata.DailyRecordRefreshTime)

	def isOpen(self, now=None):
		now = now or nowdatetime_t()
		if ObjectYYHuoDongOnce.isOpen(self, now):
			# ??????
			openDays = todayinclock5elapsedays(globaldata.GameServOpenDatetime) - todayinclock5elapsedays(now)
			openDays = max(openDays, 0) # 0 ?????
			opend = (openDays >= self.relativeDayRange[0] and openDays <= self.relativeDayRange[1])
			# print self.id, '????', openDays, self.relativeDayRange, opend
			if opend:
				# ????????
				ObjectServerGlobalRecord.setYYHuoDongOpenTime(self.id)
				return True
		ObjectServerGlobalRecord.delYYHuoDongOpenTime(self.id)
		return False

	# ?????????
	def gameBeginDateTime(self, _):
		return self._beginDateTime

	def gameEndDateTime(self, _):
		return self._endDateTime


#
# ObjectYYHuoDongRelateRoleCreate
#

class ObjectYYHuoDongRelateRoleCreate(ObjectYYHuoDongOnce):
	'''
	????????
	beginTime,endTime,openDuration???

	????????relativeDayRange?isRoleOpen???
	'''

	def isRoleOpen(self, level, createdTime, vipLevel):
		if ObjectYYHuoDongOnce.isRoleOpen(self, level, createdTime, vipLevel):
			# ????????
			# ????5???????
			openDays = todayinclock5elapsedays(datetimefromtimestamp(createdTime))
			# print datetimefromtimestamp(createdTime), openDays
			openDays = max(openDays, 0) # 0 ?????
			# print self.id, '????', openDays, self.relativeDayRange, openDays >= self.relativeDayRange[0] and openDays <= self.relativeDayRange[1]
			return openDays >= self.relativeDayRange[0] and openDays <= self.relativeDayRange[1]
		return False

	# ?????????
	def gameBeginDateTime(self, game):
		beginDateTime = ObjectServerGlobalRecord.getYYHuoDongOpenTime(self.id)
		if beginDateTime:
			roleBeginDate = inclock5date(datetimefromtimestamp(game.role.created_time)) + self._relativeDayRangeLeast
			return datetime.datetime.combine(roleBeginDate, globaldata.DailyRecordRefreshTime)

	def gameEndDateTime(self, game):
		beginDateTime = ObjectServerGlobalRecord.getYYHuoDongOpenTime(self.id)
		if beginDateTime:
			roleEndDate = inclock5date(datetimefromtimestamp(game.role.created_time)) + self._relativeDayRangeMost
			endDate = min(roleEndDate, self._endDate)
			return datetime.datetime.combine(endDate, globaldata.DailyRecordRefreshTime)

	def gameEventDelta(self, game, now=None):
		now = now or nowdatetime_t()
		if not self.isValid(now):
			return None

		if self.isOpen(now) and self.isRoleOpen(game.role.level, game.role.created_time, game.role.vip_level):
			return self.gameEndDateTime(game) - now
		# ???????,?????????????
		return None

#
# ObjectYYBase
#

class ObjectYYBase(ReloadHooker):
	HuoDongMap = {}

	@classmethod
	def classInit(cls):
		cls.HuoDongMap = {}

		huodongIDMap = {}
		cfgs = cls.csv()
		for csvID in cfgs:
			cfg = cfgs[csvID]
			if cfg.huodongID == 0:
				continue
			huodongIDMap.setdefault(cfg.huodongID, []).append(csvID)

		for huodongID, l in huodongIDMap.iteritems():
			cls(huodongID, l)

	@classmethod
	def csv(cls, csvID=None):
		raise NotImplementedError()

	@classmethod
	def getEffect(cls, yyID, csvID, game):
		record = cls.getExistedRecord(yyID, game)
		if record is None or 'stamps' not in record:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		if record['stamps'].get(csvID, None) != 1:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		def _afterGain():
			record['stamps'][csvID] = 0 # ???
		return ObjectYYHuoDongEffect(game, cls.csv(csvID).award, _afterGain)

	# ????yyhuodng??
	@classmethod
	def getOneKeyEffect(cls, yyID, game):
		record = cls.getExistedRecord(yyID, game)
		if record is None or 'stamps' not in record:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		ids = filter(lambda x:record['stamps'][x] == 1, record['stamps'])
		if not ids:
			return None

		def _afterGain():
			for csvID in ids:
				record['stamps'][csvID] = 0 # ???

		eff = ObjectYYHuoDongEffect(game, {}, _afterGain)
		for csvID in ids:
			eff += ObjectGainAux(game, cls.csv(csvID).award)
		return eff

	@classmethod
	def getRecord(cls, yyID, game):
		return game.role.yyhuodongs.setdefault(yyID, {})

	@classmethod
	def getExistedRecord(cls, yyID, game):
		return game.role.yyhuodongs.get(yyID, None)

	@classmethod
	def setRecord(cls, yyID, game, d):
		game.role.yyhuodongs[yyID] = d
		return game.role.yyhuodongs[yyID]

	@classmethod
	def refreshRecord(cls, yyObj, game, init=None):
		record = cls.getRecord(yyObj.id, game)
		if yyObj.countType == YYHuoDongDefs.DailyCount:
			ndi = todayinclock5date2int()
			if ndi != record.get('lastday', None):
				init = init if init else {}
				init['lastday'] = ndi
				record = cls.setRecord(yyObj.id, game, init)
		return record

	@classmethod
	def getHd(cls, yyObj, game):
		return cls.HuoDongMap.get(yyObj.huodongID, None)

	@classmethod
	def getRegainMailEffect(cls, yyObj, game):
		record = cls.getExistedRecord(yyObj.id, game)
		if record is None or 'stamps' not in record:
			return None

		ids = filter(lambda x:record['stamps'][x] == 1, record['stamps'])
		if not ids:
			return None

		def _afterGain():
			for csvID in ids:
				record['stamps'][csvID] = 0 # ???

		eff = ObjectGainAux(game, {})
		for csvID in ids:
			eff += ObjectGainAux(game, cls.csv(csvID).award)

		from game.mailqueue import ObjectMailEffect as ObjectYYHuoDongMailEffect
		subject = csv.mail[YYHuodongMailID].subject % (yyObj.desc,)
		mail = game.role.makeMyMailModel(YYHuodongMailID, subject=subject, attachs=eff.result)
		return ObjectYYHuoDongMailEffect(mail, _afterGain)


#
# ObjectYYFirstRecharge
#

class ObjectYYFirstRecharge(ObjectYYBase):
	'''
	????
	'''
	HuoDongMap = {}

	@classmethod
	def classInit(cls):

		group = {}

		for csvID in csv.yunying.firstcharge:
			cfg = csv.yunying.firstcharge[csvID]
			group.setdefault(cfg.huodongID, []).append(csvID)

		for huodongID, csvIDs in group.items():
			ObjectYYFirstRecharge(huodongID, csvIDs)

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = sorted(csvIDs, key=lambda x: csv.yunying.firstcharge[x].day)
		self.days = [csv.yunying.firstcharge[x].day for x in self.csvIDs]

		ObjectYYFirstRecharge.HuoDongMap[huodongID] = self

	@classmethod
	def isRechargeOK(cls, rechargeID, yyID, csvID):
		cfg = csv.yunying.yyhuodong[yyID]
		hdCfg = csv.yunying.yyhuodong[yyID]
		if not cfg or cfg.huodongID != hdCfg.huodongID:
			return False
		return True

	@classmethod
	def buyRecharge(cls, game, rechargeID, yyID, csvID):
		record = cls.getRecord(yyID, game)
		
		cfg = csv.yunying.firstcharge[csvID]
		
		if cfg.day == 1:
			stamps = record.setdefault('stamps', {})
			stamps[csvID] = 1
			
			info = record.setdefault('info', {})
			dayKey = 'daysum_%s' % rechargeID
			if dayKey not in info:
				info[dayKey] = 1
		
			hd = cls.HuoDongMap.get(csv.yunying.yyhuodong[yyID].huodongID)
			if hd:
				for cid in hd.csvIDs:
					c = csv.yunying.firstcharge[cid]
					if c.rechargeID == rechargeID and c.day > 1:
						if cid not in stamps:
							stamps[cid] = 0  # chua d? ng�y
		
		yyObj = ObjectYYHuoDongFactory.getConfig(yyID)
		
		if yyObj:
			cls.active(yyObj, game)
   
		#logger.info('[FirstRecharge] buyRecharge FINAL=%s', game.role.yyhuodongs.get(yyID))
		return True,  None

	
	@classmethod
	def active(cls, yyObj, game):
		hd = cls.HuoDongMap.get(yyObj.huodongID)
		if hd is None:
			return

		record = cls.getRecord(yyObj.id, game)
		
		stamps = record.setdefault('stamps', {})

		info = record.setdefault('info', {})

		oldDate = info.get('lastday', None)
		nowDate = todayinclock5date2int()
		if oldDate == nowDate:
			return
		info['lastday'] = nowDate 

		rechargeGroups = {}
		for csvID in hd.csvIDs:
			cfg = csv.yunying.firstcharge[csvID]
			rechargeGroups.setdefault(cfg.rechargeID, {})[cfg.day] = csvID

		for rechargeID, dayMap in rechargeGroups.items():
			day1CsvID = dayMap.get(1)
			if not day1CsvID:
				continue
			if day1CsvID not in stamps:
				continue  

			dayKey = 'daysum_%s' % rechargeID
			if dayKey not in info:
				continue

			info[dayKey] = info[dayKey] + 1
			daysum = info[dayKey]

			for day, csvID in dayMap.items():
				if day == 1:
					continue
				if daysum >= day and csvID in stamps and stamps[csvID] == 0:
					stamps[csvID] = 1
					


	@classmethod
	def getEffect(cls, yyID, csvID, game):

		yyObj = ObjectYYHuoDongFactory.getConfig(yyID)
		if yyObj:
			cls.active(yyObj, game)

		record = cls.getExistedRecord(yyID, game)
		if not record:
			raise ClientError('record not found')

		stamps = record.setdefault('stamps', {})

		if stamps.get(csvID, 0) != 1:
			raise ClientError('award not available')

		cfg = csv.yunying.firstcharge[csvID]

		def _afterGain():
			stamps[csvID] = 2

		return ObjectYYHuoDongEffect(game, cfg.award, _afterGain)



#
# ObjectYYLoginWeal
#

class ObjectYYLoginWeal(ObjectYYBase):
	'''
	????

	{lastday: 20160719, daysum: 1}
	'''

	HuoDongMap = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.loginweal
		return csv.yunying.loginweal[csvID]

	@classmethod
	def active(cls, yyObj, game):
		hd = cls.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return

		record = cls.getRecord(yyObj.id, game)
		oldDate = record.get('lastday', None)
		nowDate = todayinclock5date2int()
		record['lastday'] = nowDate
		if oldDate == nowDate:
			return

		stamps = record.setdefault('stamps', {})
		info = record.setdefault('info', {})
		dayRecord = info.get('daysum', 0) + 1
		info['daysum'] = dayRecord

		for i, daySum in enumerate(hd.daySum):
			csvID = hd.csvIDs[i]
			if dayRecord >= daySum:
				if csvID not in stamps:
					stamps[csvID] = 1 # ???
			else:
				break

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = sorted(csvIDs, key=lambda x: csv.yunying.loginweal[x].daySum)
		self.daySum = [csv.yunying.loginweal[x].daySum for x in self.csvIDs]

		ObjectYYLoginWeal.HuoDongMap[huodongID] = self

#
# ObjectYYLoginGift
#

class ObjectYYLoginGift(ObjectYYLoginWeal):
	'''
	????
	'''

	@classmethod
	def active(cls, yyObj, game):
		hd = ObjectYYLoginWeal.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return

		record = cls.getRecord(yyObj.id, game)
		stamps = record.setdefault('stamps', {})

		# 0 ?????????
		# 1 ??????
		isSum = yyObj.paramMap.get('isSum', 0)

		if isSum == 1:
			info = record.setdefault('info', {})
			oldDate = record.get('lastday', None)
			nowDate = todayinclock5date2int()
			record['lastday'] = nowDate
			if oldDate == nowDate:
				return

			dayRecord = info.get('daysum', 0) + 1
			info['daysum'] = dayRecord

			for i, daySum in enumerate(hd.daySum):
				csvID = hd.csvIDs[i]
				if dayRecord >= daySum:
					if csvID not in stamps:
						stamps[csvID] = 1  # ???
				else:
					break

		elif isSum == 2:
			beginDate = yyObj.gameBeginDateTime(game)
			todayIdx = todayinclock5elapsedays(beginDate) + 1 

			for i, daySum in enumerate(hd.daySum):
				csvID = hd.csvIDs[i]
				if todayIdx >= daySum:
					if csvID not in stamps:
						stamps[csvID] = 1  # ???
				else:
					break

		else:
			dayIdx = todayinclock5elapsedays(yyObj.gameBeginDateTime(game))
			if dayIdx > len(hd.csvIDs) - 1:
				return

			csvID = hd.csvIDs[dayIdx]
			if csvID not in stamps:
				stamps[csvID] = 1

	@classmethod
	def canBuy(cls, yyID, csvID, game):
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			return False
		# ????
		if record.get('buy', None):
			return False
		return True

	@classmethod
	def buyRecharge(cls, game, rechargeID, yyID, csvID, **kwargs):
		days = kwargs.get('days', 30)
		record = cls.getRecord(yyID, game)
		nowdate = inclock5date(nowdatetime_t())
		enddate = int2date(record.get('enddate', todayinclock5date2int()))

		if nowdate > enddate or 'lastday' not in record: # ???
			enddate = nowdate + datetime.timedelta(days=days - 1)
			record['enddate'] = date2int(enddate)
			record['lastday'] = date2int(nowdate - OneDay)
		else: # ????????????
			enddate = enddate + datetime.timedelta(days=days)
			record['enddate'] = date2int(enddate)

		award = csv.yunying.yyhuodong[yyID].paramMap['award']
		yyObj = ObjectYYHuoDongFactory.getConfig(yyID)
		if yyObj:
			cls.active(yyObj, game)

		def _afterGain():
			record['buy'] = 1

		return True, ObjectYYHuoDongEffect(game, award, _afterGain).gain()


	@classmethod
	def isRechargeOK(cls, rechargeID, yyID, csvID):
		cfg = csv.yunying.yyhuodong[yyID]
		if not cfg or cfg.paramMap.get('rechargeID', None) != rechargeID:
			return False
		return True

	@classmethod
	def getEffect(cls, yyID, csvID, game):
		record = cls.getExistedRecord(yyID, game)
		if not record:
			raise ClientError('record not found')

		stamps = record.setdefault('stamps', {})
		if stamps.get(csvID, 0) != 1:
			raise ClientError('award not available')

		def _afterGain():
			stamps[csvID] = 0
		award = csv.yunying.loginweal[csvID].award
		return ObjectYYHuoDongEffect(game, award, _afterGain).gain()



#
# ObjectYYLevelAward
#

class ObjectYYLevelAward(ObjectYYBase):
	'''
	????
	'''

	HuoDongMap = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.levelaward
		return csv.yunying.levelaward[csvID]

	@classmethod
	def active(cls, yyObj, game):
		hd = cls.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return
		record = cls.getRecord(yyObj.id, game)
		stamps = record.setdefault('stamps', {})
		for i, needLevel in enumerate(hd.needLevels):
			csvID = hd.csvIDs[i]
			if game.role.level >= needLevel:
				if csvID not in stamps:
					stamps[csvID] = 1 # ???
			else:
				break

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = sorted(csvIDs, key=lambda x: csv.yunying.levelaward[x].needLevel)
		self.needLevels = [csv.yunying.levelaward[x].needLevel for x in self.csvIDs]

		ObjectYYLevelAward.HuoDongMap[huodongID] = self


#
# ObjectYYOnceRechageAward
#

class ObjectYYOnceRechageAward(ObjectYYBase):
	'''
	???????
	'''

	HuoDongMap = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.oncerechage
		return csv.yunying.oncerechage[csvID]

	@classmethod
	def active(cls, yyObj, game, rmb, rechargeID):
		hd = cls.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return

		# ?????
		if rechargeID > 0: # rechargeID ?0???recharge_rmb???QQ???
			cfg = csv.recharges[rechargeID]
			if cfg.type != RechargeDefs.OneOffType:
				return

		record = cls.getRecord(yyObj.id, game)
		stamps = record.setdefault('stamps', {})

		ocsv = csv.yunying.oncerechage
		for csvID in hd.csvIDs:
			needrmb = ocsv[csvID].needRmb
			if needrmb == rmb:
				if csvID not in stamps:
					stamps[csvID] = 1 # ???
				break

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = csvIDs

		ObjectYYOnceRechageAward.HuoDongMap[huodongID] = self


#
# ObjectYYRechargeGift
#

class ObjectYYRechargeGift(ObjectYYBase):
	'''
	????
	'''

	HuoDongMap = {}
	HuodongIDList = []

	@classmethod
	def classInit(cls):
		super(ObjectYYRechargeGift, cls).classInit()

		cls.HuodongIDList = []
		import framework
		now = todayinclock5date2int()
		key = MergeServ.getSrcServKeys(Session.server.key)[0]
		domains = node_key2domains(key)
		serverKey, serverIdx = domains[1], int(domains[2])
		for idx in csv.yunying.rechargegift_huodongid:
			cfg = csv.yunying.rechargegift_huodongid[idx]
			if framework.__language__ not in cfg.languages:
				continue
			srange = cfg.servers.get(serverKey, None)
			if srange and int(srange[0]) <= serverIdx <= int(srange[1]):
				cls.HuodongIDList.append(cfg)

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.rechargegift
		return csv.yunying.rechargegift[csvID]

	@classmethod
	def getHuodongID(cls, yyObj, game):
		if yyObj.paramMap.get('replace', False):
			begin = date2int(yyObj.gameBeginDateTime(game).date()) # ?????????
			for cfg in cls.HuodongIDList:
				if cfg.beginDate <= begin < cfg.endDate:
					return cfg.huodongID
		return yyObj.huodongID

	@classmethod
	def active(cls, yyObj, game, rmb):
		huodongID = cls.getHuodongID(yyObj, game)
		hd = cls.HuoDongMap.get(huodongID, None)
		if hd is None:
			return
		
		 
		record = cls.getRecord(yyObj.id, game)
		stamps = record.setdefault('stamps', {})
		info = record.setdefault('info', {})
		days = 0
		nowDate = todayinclock5date2int()

		if hd.needReset:
			oldDate = record.get('lastday', None)
			days = info.get('daysum', 0)
			# ?????????
			if oldDate != nowDate:
				record['lastday'] = nowDate
				info['rechargesum'] = 0
				info['lastdaysum'] = days
			# ??????1?
			if info['lastdaysum'] < days:
				return
			days += 1 # ???

		rechargesum = info.get('rechargesum', 0) + rmb
		info['rechargesum'] = rechargesum

		if hd.needReset:
			if days in hd.dayAmounts:
				csvID, amount = hd.dayAmounts[days]
				if rechargesum >= amount:
					if csvID not in stamps:
						stamps[csvID] = 1 # ???
						info['daysum'] = days

		else:
			for i, amount in enumerate(hd.amounts):
				csvID = hd.csvIDs[i]
				if rechargesum >= amount:
					if csvID not in stamps:
						stamps[csvID] = 1 # ???
				else:
					break

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.needReset = False
		if len(set([self.csv(x).daySum for x in csvIDs])) > 1:
			self.needReset = True
		if self.needReset:
			self.csvIDs = sorted(csvIDs, key=lambda x: self.csv(x).daySum)
		else:
			self.csvIDs = sorted(csvIDs, key=lambda x: self.csv(x).amount)
		self.amounts = [self.csv(x).amount for x in self.csvIDs]
		self.dayAmounts = {self.csv(x).daySum: (x, self.csv(x).amount) for x in self.csvIDs}

		ObjectYYRechargeGift.HuoDongMap[huodongID] = self


#
# ObjectYYTimeLimitDraw
#

class ObjectYYTimeLimitDraw(ObjectYYBase):
	'''
	????
	'''

	DrawItem = DrawCardDefs.LimitDrawItem
	DrawTypes = {
		DrawCardDefs.LimitRMB1: ('limit_counter_1', 1, 'RMB1', 1),
		DrawCardDefs.LimitRMB10: ('limit_counter_1', 10, 'RMB10', 10),
	}

	@classmethod
	def classInit(cls):
		pass

	@classmethod
	def getEffect(cls, yyID, drawType, game):
		record = cls.getRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		info = record.setdefault('info', {})

		if drawType not in cls.DrawTypes:
			raise ClientError('drawType error')

		counterType, drawItemCount, yyParamKey, drawCount = cls.DrawTypes[drawType]

		drawTimes = info.get(counterType, 0)
		if game.items.getItemCount(cls.DrawItem) < drawItemCount:
			needRMB = csv.yunying.yyhuodong[yyID].paramMap[yyParamKey]
			if game.role.rmb < needRMB:
				raise ClientError(ErrDefs.drawCardRMBNotEnough)

		def _afterGain():
			cost = ObjectCostAux(game, {cls.DrawItem: drawItemCount})
			if not cost.isEnough():
				costRMB = csv.yunying.yyhuodong[yyID].paramMap[yyParamKey]
				cost = ObjectCostAux(game, {'rmb': costRMB})
			cost.cost(src='draw_card_%s' % drawType)
			info[counterType] = info.get(counterType, 0) + drawCount

		grids = []
		eff = ObjectGainAux(game, {})
		for _ in xrange(drawCount):
			drawTimes += 1
			award = ObjectDrawCardRandom.getRandomItems(game, DrawCardDefs.LimitDrawRandomKey(DrawCardDefs.LimitRMB1, yyID), drawTimes, None)
			award = award.to_dict()
			eff += ObjectGainAux(game, award)
			if 'cards' in award:
				continue
			grids.extend(award.items())

		eff = ObjectDrawEffect(game, eff.to_dict(), grids, _afterGain)
		return eff
	

#
# ObjectYYThemeSkinDraw
#

class ObjectYYThemeSkinDraw(ObjectYYBase):
	'''
	????
	'''

	DrawItem = DrawCardDefs.ThemeDrawItem
	DrawTypes = {
		DrawCardDefs.LimitCardRMB1: ('limit_counter_1', 1, 'SKIN1', 1),
		DrawCardDefs.LimitCardRMB10: ('limit_counter_1', 10, 'SKIN10', 10),
	}

	@classmethod
	def classInit(cls):
		pass

	@classmethod
	def getEffect(cls, yyID, drawType, game):
		record = cls.getRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		info = record.setdefault('info', {})

		if drawType not in cls.DrawTypes:
			raise ClientError('drawType error')

		counterType, drawItemCount, yyParamKey, drawCount = cls.DrawTypes[drawType]

		if game.items.getItemCount(cls.DrawItem) < drawItemCount:
			raise ClientError(ErrDefs.drawCardRMBNotEnough)
		
		cfg = csv.yunying.yyhuodong[yyID]
		extra = {}
		extraItemID = cfg.paramMap.get('exchangeItem', 94)
		extraCount = drawCount
		if extraCount > 0:
			# ObjectGainAux(game, {extraItemID: extraCount}).gain(src='theme_skin_draw_extra')
			extra[extraItemID] = extraCount

		def _afterGain():
			cost = ObjectCostAux(game, {cls.DrawItem: drawItemCount})
			if not cost.isEnough():
				raise ClientError(ErrDefs.drawCardRMBNotEnough)
			cost.cost(src='draw_card_%s' % drawType)
			info[counterType] = info.get(counterType, 0) + drawCount
			if extra:
				ObjectGainAux(game, extra).gain(src='theme_skin_draw_extra')
			

		grids = []
		eff = ObjectGainAux(game, {})
		drawTimes = info.get(counterType, 0)
		# logger.info("==drawTimes== %s", drawTimes)
		for _ in xrange(drawCount):
			drawTimes += 1
			award = ObjectDrawCardRandom.getRandomItems(game, DrawCardDefs.LimitDrawRandomKey(DrawCardDefs.LimitCardRMB1, yyID), drawTimes, None)
			award = award.to_dict()
			eff += ObjectGainAux(game, award)
			if 'cards' in award:
				continue
			grids.extend(award.items())


		eff = ObjectDrawEffect(game, eff.to_dict(), grids, _afterGain)
		eff.extra = extra
		return eff


#
# ObjectYYZhutiYingxiongDraw
#

class ObjectYYZhutiYingxiongDraw(ObjectYYBase):
	'''
	????
	'''

	DrawItem = DrawCardDefs.ZhutiYingxiongDraw
	DrawTypes = {
		DrawCardDefs.LimitCardRMB1: ('limit_counter_1', 1, 'draw1', 1),
		DrawCardDefs.LimitCardRMB10: ('limit_counter_1', 10, 'draw10', 10),
	}

	@classmethod
	def classInit(cls):
		pass

	@classmethod
	def getZhutiYingxiongDrawSumBox(cls, yyID, csvID, game):
		record = cls.getRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		if csvID not in csv.draw_count:
			raise ClientError('param error')

		cfg = csv.draw_count[csvID]

		if cfg.drawType not in [DrawSumBoxDefs.EquipType]:
			raise ClientError("sum box not open")
		
		role = game.role
		roleDrawSumBox = role.draw_sum_box.setdefault(cfg.drawType, {})
		# if roleDrawSumBox.get(csvID, 0) == 2:
		# 	raise ClientError('sum box already got')
		def _afterGain():
			roleDrawSumBox[csvID] = 0


		return ObjectYYHuoDongEffect(game, cfg.award, _afterGain)
	
	@classmethod
	def getEffect(cls, yyID, drawType, game):
		record = cls.getRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		info = record.setdefault('info', {})

		if drawType not in cls.DrawTypes:
			raise ClientError('drawType error')

		counterType, drawItemCount, yyParamKey, drawCount = cls.DrawTypes[drawType]

		if game.items.getItemCount(cls.DrawItem) < drawItemCount:
			raise ClientError(ErrDefs.drawCardRMBNotEnough)
		
		extra = {}
		extraItemID = 94
		extraCount = 0
		if extraCount > 0:
			# ObjectGainAux(game, {extraItemID: extraCount}).gain(src='theme_skin_draw_extra')
			extra[extraItemID] = extraCount

		def _afterGain():
			cost = ObjectCostAux(game, {cls.DrawItem: drawItemCount})
			if not cost.isEnough():
				raise ClientError(ErrDefs.drawCardRMBNotEnough)
			cost.cost(src='draw_card_%s' % drawType)
			info[counterType] = info.get(counterType, 0) + drawCount
			if extra:
				ObjectGainAux(game, extra).gain(src='ZhutiYingxiong_draw_extra')
			

		grids = []
		eff = ObjectGainAux(game, {})
		drawTimes = info.get(counterType, 0)
		# logger.info("==drawTimes== %s", drawTimes)
		for _ in xrange(drawCount):
			drawTimes += 1
			award = ObjectDrawCardRandom.getRandomItems(game, DrawCardDefs.LimitDrawRandomKey(DrawCardDefs.LimitCardRMB1, yyID), drawTimes, None)
			award = award.to_dict()
			eff += ObjectGainAux(game, award)
			if 'cards' in award:
				continue
			grids.extend(award.items())


		eff = ObjectDrawEffect(game, eff.to_dict(), grids, _afterGain)
		eff.extra = extra
		return eff


#
# ObjectYYJiuWeiDraw
#

class ObjectYYJiuWeiDraw(ObjectYYBase):
	'''
	????
	'''
	
	DrawItem = DrawItemDefs.JiuWeiDraw
	DrawTypes = {
		DrawItemDefs.LimitExplorerRMB1: ('limit_counter_1', 1, 'draw1', 1),
		DrawItemDefs.LimitExplorerRMB10: ('limit_counter_1', 10, 'draw10', 10),
	}

	@classmethod
	def classInit(cls):
		pass

	@classmethod
	def getJiuWeiDrawSumBox(cls, yyID, csvID, game):
		record = cls.getRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		if csvID not in csv.draw_count:
			raise ClientError('param error')

		cfg = csv.draw_count[csvID]

		if cfg.drawType not in [DrawSumBoxDefs.EquipType]:
			raise ClientError("sum box not open")
		
		role = game.role
		roleDrawSumBox = role.draw_sum_box.setdefault(cfg.drawType, {})
		# if roleDrawSumBox.get(csvID, 0) == 2:
		# 	raise ClientError('sum box already got')
		def _afterGain():
			roleDrawSumBox[csvID] = 0


		return ObjectYYHuoDongEffect(game, cfg.award, _afterGain)
	
	@classmethod
	def getEffect(cls, yyID, drawType, game):
		record = cls.getRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		info = record.setdefault('info', {})

		if drawType not in cls.DrawTypes:
			raise ClientError('drawType error')

		counterType, drawItemCount, yyParamKey, drawCount = cls.DrawTypes[drawType]

		if game.items.getItemCount(cls.DrawItem) < drawItemCount:
			raise ClientError(ErrDefs.drawCardRMBNotEnough)
		
		cfg = csv.yunying.yyhuodong[yyID]
		extra = {}
		extraItemID = cfg.paramMap.get('exchangeItem', None)
		extraCount = drawCount
		if extraCount > 0:
			# ObjectGainAux(game, {extraItemID: extraCount}).gain(src='theme_skin_draw_extra')
			extra[extraItemID] = extraCount

		def _afterGain():
			cost = ObjectCostAux(game, {cls.DrawItem: drawItemCount})
			if not cost.isEnough():
				raise ClientError(ErrDefs.drawCardRMBNotEnough)
			cost.cost(src='draw_item_%s' % drawType)
			info[counterType] = info.get(counterType, 0) + drawCount
			if extra:
				ObjectGainAux(game, extra).gain(src='JiuWei_draw_extra')
			

		grids = []
		eff = ObjectGainAux(game, {})
		drawTimes = info.get(counterType, 0)
		# logger.info("==drawTimes== %s", drawTimes)
		for _ in xrange(drawCount):
			drawTimes += 1
			award = ObjectDrawItemRandom.getRandomItems(game, DrawItemDefs.YYDrawRandomKey(DrawItemDefs.LimitExplorerRMB1, yyID), drawTimes, None)
			award = award.to_dict()
			eff += ObjectGainAux(game, award)
			grids.extend(award.items())


		eff = ObjectDrawEffect(game, eff.to_dict(), grids, _afterGain)
		eff.extra = extra
		return eff

#
# ObjectYYHeldItemDraw
#

class ObjectYYHeldItemDraw(ObjectYYBase):
	'''
	????
	'''
	
	DrawItem = DrawCardDefs.HeldItemDraw
	DrawTypes = {
		DrawCardDefs.HeldItemRMB1: ('limit_counter_1', 1, 'draw1', 1),
		DrawCardDefs.HeldItemRMB10: ('limit_counter_1', 10, 'draw10', 10),
	}

	@classmethod
	def classInit(cls):
		pass

	@classmethod
	def getHeldItemDrawSumBox(cls, yyID, csvID, game):
		record = cls.getRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		if csvID not in csv.draw_count:
			raise ClientError('param error')

		cfg = csv.draw_count[csvID]

		if cfg.drawType not in [DrawSumBoxDefs.EquipType]:
			raise ClientError("sum box not open")
		
		role = game.role
		roleDrawSumBox = role.draw_sum_box.setdefault(cfg.drawType, {})
		# if roleDrawSumBox.get(csvID, 0) == 2:
		# 	raise ClientError('sum box already got')
		def _afterGain():
			roleDrawSumBox[csvID] = 0


		return ObjectYYHuoDongEffect(game, cfg.award, _afterGain)
	
	@classmethod
	def getEffect(cls, yyID, drawType, game):
		record = cls.getRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		info = record.setdefault('info', {})
		
		cfg = csv.yunying.yyhuodong[yyID]
		extra = {}
		costRMB1 = cfg.paramMap.get('rmb1', 500)
		costRMB10 = cfg.paramMap.get('rmb10', 5000)
		# ==== FREE DRAW ====
		if drawType == DrawCardDefs.HeldItemFree1:
			if info.get('free_counter', 0) >= 1:
				raise ClientError(ErrDefs.freeDrawTimerNoCD)  # d� d�ng free
			counterType, drawItemCount, yyParamKey, drawCount = ('limit_counter_1', 1, 'draw1', 1)
		else:
			# ==== NORMAL DRAW ====
			if drawType not in cls.DrawTypes:
				raise ClientError('drawType error')

			counterType, drawItemCount, yyParamKey, drawCount = cls.DrawTypes[drawType]

			drawTimes = info.get(counterType, 0)

		extraItemID = cfg.paramMap.get('exchangeItem', None)
		extraCount = drawCount
		if extraCount > 0:
			# ObjectGainAux(game, {extraItemID: extraCount}).gain(src='theme_skin_draw_extra')
			extra[extraItemID] = extraCount

		def _afterGain():
			if drawType == DrawCardDefs.HeldItemFree1:
				# mark free d� d�ng
				info['free_counter'] = 1
				info[counterType] = info.get(counterType, 0) + 1
			else:
				cost = ObjectCostAux(game, {cls.DrawItem: drawItemCount})
				if cost.isEnough():
					cost.cost(src='draw_item_%s' % drawType)
				else:
					# Tr? RMB theo lo?i
					if drawType == DrawCardDefs.HeldItemRMB1:
						rmbCost = costRMB1
					elif drawType == DrawCardDefs.HeldItemRMB10:
						rmbCost = costRMB10
					else:
						raise ClientError('drawType error')
					
					if game.role.rmb < rmbCost:
						raise ClientError(ErrDefs.drawCardRMBNotEnough)
					
					cost = ObjectCostAux(game, {'rmb': rmbCost})
					cost.cost(src='draw_rmb_%s' % drawType)

				info[counterType] = info.get(counterType, 0) + drawCount

			if extra:
				ObjectGainAux(game, extra).gain(src='HeldItem_draw_extra')
			

		grids = []
		eff = ObjectGainAux(game, {})
		# logger.info("==drawTimes== %s", drawTimes)
		drawTimes = info.get(counterType, 0)
		for _ in xrange(drawCount):
			drawTimes += 1
			award = ObjectDrawCardRandom.getRandomItems(game, DrawCardDefs.LimitDrawRandomKey("limit_helditem_rmb1", yyID), drawTimes, None)
			award = award.to_dict()
			eff += ObjectGainAux(game, award)
			grids.extend(award.items())


		eff = ObjectDrawEffect(game, eff.to_dict(), grids, _afterGain)
		eff.extra = extra
		return eff

#
# ObjectYYLimitExplorDraw
#

class ObjectYYLimitExplorDraw(ObjectYYBase):
	'''
	????
	'''
	
	DrawItem = DrawCardDefs.drawLimitExpItem
	DrawTypes = {
		DrawCardDefs.ExplorerRMB1: ('limit_counter_1', 1, 'draw1', 1),
		DrawCardDefs.ExplorerRMB10: ('limit_counter_1', 10, 'draw10', 10),
	}

	@classmethod
	def classInit(cls):
		pass

	@classmethod
	def getLimitExplorDrawSumBox(cls, yyID, csvID, game):
		record = cls.getRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		if csvID not in csv.draw_count:
			raise ClientError('param error')

		cfg = csv.draw_count[csvID]

		if cfg.drawType not in [DrawSumBoxDefs.EquipType]:
			raise ClientError("sum box not open")
		
		role = game.role
		roleDrawSumBox = role.draw_sum_box.setdefault(cfg.drawType, {})
		# if roleDrawSumBox.get(csvID, 0) == 2:
		# 	raise ClientError('sum box already got')
		def _afterGain():
			roleDrawSumBox[csvID] = 0


		return ObjectYYHuoDongEffect(game, cfg.award, _afterGain)
	
	@classmethod
	def getEffect(cls, yyID, drawType, game):
		record = cls.getRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		info = record.setdefault('info', {})
		
		cfg = csv.yunying.yyhuodong[yyID]
		extra = {}
		costRMB1 = cfg.paramMap.get('rmb1', 500)
		costRMB10 = cfg.paramMap.get('rmb10', 5000)
		# ==== FREE DRAW ====
		if drawType == DrawCardDefs.ExplorerFree1:
			if info.get('free_counter', 0) >= 1:
				raise ClientError(ErrDefs.freeDrawTimerNoCD)  # d� d�ng free
			counterType, drawItemCount, yyParamKey, drawCount = ('limit_counter_1', 1, 'draw1', 1)
		else:
			# ==== NORMAL DRAW ====
			if drawType not in cls.DrawTypes:
				raise ClientError('drawType error')

			counterType, drawItemCount, yyParamKey, drawCount = cls.DrawTypes[drawType]

			drawTimes = info.get(counterType, 0)

		extraItemID = cfg.paramMap.get('exchangeItem', None)
		extraCount = drawCount
		if extraCount > 0:
			# ObjectGainAux(game, {extraItemID: extraCount}).gain(src='theme_skin_draw_extra')
			extra[extraItemID] = extraCount

		def _afterGain():
			if drawType == DrawCardDefs.ExplorerFree1:
				# mark free d� d�ng
				info['free_counter'] = 1
				info[counterType] = info.get(counterType, 0) + 1
			else:
				cost = ObjectCostAux(game, {cls.DrawItem: drawItemCount})
				if cost.isEnough():
					cost.cost(src='draw_item_%s' % drawType)
				else:
					# Tr? RMB theo lo?i
					if drawType == DrawCardDefs.ExplorerRMB1:
						rmbCost = costRMB1
					elif drawType == DrawCardDefs.ExplorerRMB10:
						rmbCost = costRMB10
					else:
						raise ClientError('drawType error')
					
					if game.role.rmb < rmbCost:
						raise ClientError(ErrDefs.drawCardRMBNotEnough)
					
					cost = ObjectCostAux(game, {'rmb': rmbCost})
					cost.cost(src='draw_rmb_%s' % drawType)

				info[counterType] = info.get(counterType, 0) + drawCount

			if extra:
				ObjectGainAux(game, extra).gain(src='LimitExplor_draw_extra')
			

		grids = []
		eff = ObjectGainAux(game, {})
		# logger.info("==drawTimes== %s", drawTimes)
		drawTimes = info.get(counterType, 0)
		for _ in xrange(drawCount):
			drawTimes += 1
			award = ObjectDrawCardRandom.getRandomItems(game, DrawCardDefs.LimitDrawRandomKey("limit_explorer_rmb1", yyID), drawTimes, None)
			award = award.to_dict()
			eff += ObjectGainAux(game, award)
			grids.extend(award.items())


		eff = ObjectDrawEffect(game, eff.to_dict(), grids, _afterGain)
		eff.extra = extra
		return eff

#
# ObjectYYTimeLimitUpDraw
#

class ObjectYYTimeLimitUpDraw(ObjectYYBase):
	'''
	?? Up ??
	'''

	DrawItem = DrawCardDefs.LimitUpDrawItem
	DrawTypes = {
		DrawCardDefs.LimitUpRMB1: ('limit_up_counter_1', 1, 'RMB1'),
		DrawCardDefs.LimitUpRMB10: ('limit_up_counter_10', 10, 'RMB10'),
	}

	@classmethod
	def classInit(cls):
		pass

	@classmethod
	def getEffect(cls, yyID, drawType, game):
		record = cls.getRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		info = record.setdefault('info', {})

		if drawType not in cls.DrawTypes:
			raise ClientError('drawType error')

		counterType, drawItemCount, yyParamKey = cls.DrawTypes[drawType]

		drawTimes = info.get(counterType, 0)
		if game.items.getItemCount(cls.DrawItem) < drawItemCount:
			needRMB = csv.yunying.yyhuodong[yyID].paramMap[yyParamKey]
			if game.role.rmb < needRMB:
				raise ClientError(ErrDefs.drawCardRMBNotEnough)

		def _afterGain():
			cost = ObjectCostAux(game, {cls.DrawItem: drawItemCount})
			if not cost.isEnough():
				costRMB = csv.yunying.yyhuodong[yyID].paramMap[yyParamKey]
				cost = ObjectCostAux(game, {'rmb': costRMB})
			cost.cost(src='draw_card_%s' % drawType)
			info[counterType] = info.get(counterType, 0) + 1
			cls.onGeneralTask(game, counterType)

		return ObjectDrawCardRandom.getRandomItems(game, DrawCardDefs.LimitDrawRandomKey(drawType, yyID), drawTimes+1, _afterGain)

	@classmethod
	def onGeneralTask(cls, game, counterType):
		if counterType == 'limit_up_counter_1':
			counter = 1
		elif counterType == 'limit_up_counter_10':
			counter = 10
		else:
			return

		ObjectYYHuoDongFactory.onGeneralTask(game , TargetDefs.DrawCardUp, counter)
		ObjectYYHuoDongFactory.onGeneralTask(game , TargetDefs.DrawCardUpAndRMB, counter)

		oldCounter = game.lotteryRecord.yyhuodong_counters.get(YYHuoDongDefs.TimeLimitUpDraw, 0)
		game.lotteryRecord.yyhuodong_counters[YYHuoDongDefs.TimeLimitUpDraw] = oldCounter + counter

#
# ObjectYYBreakEgg
#

class ObjectYYBreakEgg(ObjectYYBase):
	'''
	?????
	'''
	HuoDongMap = {}

	# TODO:??

	@classmethod
	def classInit(cls):
		pass

	@classmethod
	def active(cls, yyObj, game, rmb=0):
		# yyid:{pool:{3:True,6:True,10:True},times:1,remainrmb:2}
		record = cls.getRecord(yyObj.id, game)
		if record.get('times', None) is None:
			record['times'] = 0
			record['remainrmb'] = 0
			record['pool'] = cls.makeRandomPool()

		gain_times = game.dailyRecord.breakegg_gain_times
		if gain_times < 10 and rmb > 0:
			rmb = rmb / 10
			remainrmb = record['remainrmb']
			t = min(int(rmb + remainrmb) / 6, 10 - gain_times)
			record['times'] += t
			game.dailyRecord.breakegg_gain_times += t
			record['remainrmb'] = int(rmb + remainrmb) % 6

	@classmethod
	def getEffect(cls, yyID, pos, game):
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		pool = record['pool']
		if record['times'] <= 0:
			raise ClientError('remain times not enough')

		cfg = csv.yunying.yyhuodong[yyID].paramMap
		key = 'rmb' if 'rmb' in cfg else 'gold'
		cost = cfg[key]
		costAux = ObjectCostAux(game, {key: cost})

		if not costAux.isEnough():
			if costAux.lack == ObjectCostAux.LackGold:
				raise ClientError(ErrDefs.goldNotEnough)
			else:
				raise ClientError(ErrDefs.rmbNotEnough)
		# ??????? ,???????.key??? *3 *6 *10
		rate = pool[pos]
		if rate == 0:
			raise ClientError('invalid position')
		gainMap = {key: rate * cost}

		def _afterGain():
			if rate == 10:
				record['pool'] = cls.makeRandomPool()
			else:
				pool[pos] = 0

			record['times'] -= 1
			costAux.cost(src='breakegg')
			game.dailyRecord.breakegg_amount += rate * cost
			ObjectMessageGlobal.newsBreakEggMsg(game.role.name, rate, rate*cost, key)

		return ObjectYYHuoDongEffect(game, gainMap, _afterGain)

	@classmethod
	def makeRandomPool(cls):
		rates = [3, 6, 10]
		random.shuffle(rates)
		return rates


#
# ObjectYYTimeLimitBox
#


class ObjectYYTimeLimitBox(ObjectYYBase):
	'''
	????
	'''
	HuoDongMap = {} # {yyID: True}
	PointMap = {} # {huodongID:[sortCsvIDs]}
	QualifyDayLevel = [] # [(day, limitboxqualify.csv ID)]

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.limitboxpointaward
		return csv.yunying.limitboxpointaward[csvID]

	@classmethod
	def classInit(cls):
		cls.PointMap = {}
		for csvID in csv.yunying.limitboxpointaward:
			cfg = csv.yunying.limitboxpointaward[csvID]
			if cfg.huodongID not in cls.PointMap:
				cls.PointMap[cfg.huodongID] = []
			cls.PointMap[cfg.huodongID].append(csvID)

		for huodongID in cls.PointMap:
			cls.PointMap[huodongID] = sorted(cls.PointMap[huodongID])

		cls.QualifyDayLevel = []
		for csvID in csv.yunying.limitboxqualify:
			cfg = csv.yunying.limitboxqualify[csvID]
			cls.QualifyDayLevel.append((cfg.serverOpenDays, csvID))
		cls.QualifyDayLevel.sort()
		

	@classmethod
	def active(cls, yyObj, _):
		if yyObj.id in cls.HuoDongMap:
			return
		cls.HuoDongMap[yyObj.id] = True

		# ?????????
		# ?????7?21:30(?????+6?
		# ??????????5??? ?????????
		delta = min(cls.getAwardDateTime(yyObj) + datetime.timedelta(seconds=5), yyObj.gameEndDateTime(None)) - nowdatetime_t()
		Session.startYYLimitBoxTimer(yyObj.id, delta)

		# ?????????
		# ????? endtime
		delta = yyObj.gameEndDateTime(None) - nowdatetime_t()
		Session.startYYLimitBoxEndTimer(yyObj.id, delta)
		

	@classmethod
	def hasDrawEnd(cls, yyObj):
		return (min(cls.getAwardDateTime(yyObj), yyObj.gameEndDateTime(None)) - nowdatetime_t()).total_seconds() <= 0

	@classmethod
	def getEffect(cls, yyID, drawType, game):
		yyObj = ObjectYYHuoDongFactory.getRoleOpenConfig(yyID, game.role.level, game.role.created_time, game.role.vip_level)
		if yyObj is None:
			raise ClientError(ErrDefs.huodongNoOpen)
		if cls.hasDrawEnd(yyObj):
			raise ClientError(ErrDefs.yyBoxHasEnd)

		cfg = csv.yunying.yyhuodong[yyID]
		record = cls.getRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		recordInfo = record.setdefault('info', {})
		checkCardCapacity = cfg.paramMap.get("CheckCardCapacity", 1)
		costItem = 0
		if drawType == DrawCardDefs.LimitBoxFree1:
			if checkCardCapacity == 1:
				game.role.checkCardCapacityEnough(1)
			if game.dailyRecord.limit_box_free_counter > 0:
				raise ClientError(ErrDefs.freeDrawTimerNoCD)
			drawTimes = recordInfo.get('limit_counter1', 0)
			costRMB = 0
			costItem = 0
		elif drawType == DrawCardDefs.LimitBoxRMB1:
			if checkCardCapacity == 1:
				game.role.checkCardCapacityEnough(1)
			drawTimes = recordInfo.get('limit_counter1', 0)
			costRMB = cfg.paramMap['RMB1']
			costItem = 1
		elif drawType == DrawCardDefs.LimitBoxRMB10:
			if checkCardCapacity == 1:
				game.role.checkCardCapacityEnough(10)
			drawTimes = recordInfo.get('limit_counter10', 0)
			costRMB = cfg.paramMap['RMB10']
			costItem = 10
		else:
			raise ClientError('draw error')

		if game.role.rmb < costRMB:
			raise ClientError(ErrDefs.drawCardRMBNotEnough)
		if costRMB > 0:
			num = game.role.items.get(541,0)			
			if num>= costItem and costItem > 0:				
				cost = ObjectCostAux(game, {541: costItem})
				cost.cost(src='limit_box_%s' % drawType)
			else:
				cost = ObjectCostAux(game, {'rmb': costRMB})
				cost.cost(src='limit_box_%s' % drawType)

		def _afterGain():
			if drawType == DrawCardDefs.LimitBoxFree1:
				game.dailyRecord.limit_box_free_counter += 1
				recordInfo['limit_counter1'] = recordInfo.get('limit_counter1', 0) + 1
				costRMB = 0
			elif drawType == DrawCardDefs.LimitBoxRMB1:
				recordInfo['limit_counter1'] = recordInfo.get('limit_counter1', 0) + 1
				costRMB = cfg.paramMap['RMB1']
			elif drawType == DrawCardDefs.LimitBoxRMB10:
				recordInfo['limit_counter10'] = recordInfo.get('limit_counter10', 0) + 1
				costRMB = cfg.paramMap['RMB10']
			else:
				raise ClientError('draw error')

			point = recordInfo.get('limit_counter1', 0) * 10 + recordInfo.get('limit_counter10', 0) * 100
			record['box_point'] = point
			for csvID in cls.PointMap[cfg.huodongID]:
				awardCfg = csv.yunying.limitboxpointaward[csvID]
				if point >= awardCfg.pointRequire:
					pointAward = record.setdefault('stamps', {})
					if csvID not in pointAward:
						pointAward[csvID] = 1 #???
				else:
					break

		realDrawType = drawType
		# ??????????????
		if realDrawType == DrawCardDefs.LimitBoxFree1:
			realDrawType = DrawCardDefs.LimitBoxRMB1

		return ObjectDrawCardRandom.getRandomItems(game, DrawCardDefs.LimitDrawRandomKey(realDrawType, yyID), drawTimes + 1, _afterGain)

	@classmethod
	def getAwardDateTime(cls, yyObj):
		# ????????????????,?????None ?????????
		# ????????
		# ?????3?21:30, ?????+2?
		endDT = datetime.datetime.combine(yyObj.gameBeginDateTime(None).date() + OneDay * 6, datetime.time(hour=22, minute=30))
		logger.info("==time end limit box== %s", endDT)
		return endDT

	@classmethod
	def acquireQualify(cls, yyID, game):
		# ????
		yyObj = ObjectYYHuoDongFactory.getRoleOpenConfig(yyID, game.role.level, game.role.created_time, game.role.vip_level)
		if yyObj is None:
			return False

		# qualify = 1 ???
		# qualify = 0 ???
		# qualify not in record ????

		record = cls.getRecord(yyID, game)
		recordInfo = record.setdefault('info', {})
		if 'qualify' in recordInfo:
			return recordInfo['qualify'] == 1
		valinfo = record.setdefault('valinfo', {})
		csvStar = csv.yunying.stargift
		for csvID in csvStar:
			cfg = csvStar[csvID]
			#logger.info("==csv star gift init== %s, cfg.huodongID==%s, yyObj.huodongID==%s", csvID, cfg.huodongID, yyObj.huodongID)
			valinfo[csvID] = valinfo.get(csvID, {})
			if len(valinfo[csvID]) ==0:
				logger.info("==csv star gift value init== %s", csvID)
				valinfo[csvID]['free'] = 1
				valinfo[csvID]['pay'] = 1
		beginDT = yyObj.gameBeginDateTime(None)
		cfg = csv.yunying.yyhuodong[yyID]
		# ????????
		if cfg.paramMap.get('Qualify', 0) != 1:
			return True

		# ?????????
		days = todayinclock5elapsedays(globaldata.GameServOpenDatetime) - todayinclock5elapsedays(beginDT)
		if cfg.paramMap['QualifyServerOpenDays'] >= days:
			return True

		# ??????????(????)
		qualifyPassed = (nowdatetime_t() - beginDT).total_seconds() > cfg.paramMap['QualifyTime'] * 60
		if qualifyPassed:
			# ??????????????????,????????????????
			if game.role.lastLoginDateTime >= beginDT:
				logger.info('%s %s role %d vip %d fighting %d no qualification, last login %s may be checked', cls.__name__, yyID, game.role.uid, game.role.vip_level, game.role.top6_fighting_point, game.role.lastLoginDateTime)
				recordInfo['qualify'] = 0
				return False

		# serverOpenDays[i-1] < x <= serverOpenDays[i]
		idx = min(bisect.bisect_left(cls.QualifyDayLevel, (days, 0)), len(cls.QualifyDayLevel) - 1)
		qualifyCfg = csv.yunying.limitboxqualify[cls.QualifyDayLevel[idx][1]]

		fightPointLimit = getL10nCsvValue(qualifyCfg, 'fightPointLimit')
		vipLimit = getL10nCsvValue(qualifyCfg, 'vipLimit')
		if game.role.vip_level >= vipLimit or game.role.top6_fighting_point >= fightPointLimit:
			recordInfo['qualify'] = 1

		# ?????????????,?????
		if qualifyPassed and 'qualify' not in recordInfo:
			logger.info('%s %s role %d vip %d fighting %d no qualification, last login %s', cls.__name__, yyID, game.role.uid, game.role.vip_level, game.role.top6_fighting_point, game.role.lastLoginDateTime)
			recordInfo['qualify'] = 0

		return recordInfo.get('qualify', 0) == 1
	@classmethod
	def canBuy(cls, yyID, csvID, game):
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			return False
		# ????
		
		stamps = record.setdefault('valinfo', {})
		data = stamps.get(csvID, {})
		if data and data.get('pay', 0) != 1:
			return False
		return True

	@classmethod
	def buyRecharge(cls, game, rechargeID, yyID, csvID):
		record = cls.getRecord(yyID, game)
		stamps = record.setdefault('valinfo', {})
		cfg = csv.yunying.stargift[csvID]
		if cfg.huodongID != csv.yunying.yyhuodong[yyID].huodongID:
			return False, None

		def _afterGain():
			#stamps[csvID] = stamps.get(csvID, 0) + 1 # ????
			stamps[csvID]['pay'] = 2
		return True, ObjectYYHuoDongEffect(game, cfg.buyAward, _afterGain)
	@classmethod
	def claimFree(cls, game, yyID, csvID):
		record = cls.getRecord(yyID, game)
		stamps = record.setdefault('valinfo', {})
		logger.info("==claimFree== yyID:%s, csvID:%s", yyID, csvID)
		cfg = csv.yunying.stargift[csvID]
		if cfg.huodongID != csv.yunying.yyhuodong[yyID].huodongID:
			return False, None
		logger.info("==claimFree condition == yyID:%s, csvID:%s", yyID, csvID)
		if stamps.get(csvID, {}).get('free', 0) != 1:
			return False, None
		logger.info("==claimFree can claim == yyID:%s, csvID:%s", yyID, csvID)
		def _afterGain():
			logger.info("==claim free gift== yyID:%s, csvID:%s", yyID, csvID)
			stamps[csvID]['free'] = 2
		return True, ObjectYYHuoDongEffect(game, cfg.freeAward, _afterGain)

	@classmethod
	def isRechargeOK(cls, rechargeID, yyID, csvID):
		cfg = csv.yunying.yyhuodong[yyID]
		hdCfg = csv.yunying.stargift[csvID]
		if not cfg or not hdCfg:
			return False
		if hdCfg.huodongID != csv.yunying.yyhuodong[yyID].huodongID:
			return False, None
		return True 


#
# ObjectYYMonthlyCard
#

class ObjectYYMonthlyCard(ObjectYYBase):
	'''
	??
	'''
	#{lastday:20180702,enddate:20180702} ???????? enddate
	@classmethod
	def classInit(cls):
		pass

	@classmethod
	def active(cls, yyObj, game):
		cls.refreshRecord(yyObj, game)

	@classmethod
	def refreshRecord(cls, yyObj, game):
		record = cls.getExistedRecord(yyObj.id, game)
		if record is None:
			return
		endday = int2date(record['enddate'])
		nowday = inclock5date(nowdatetime_t())
		if nowday > endday:
			game.privilege.discard(yyObj.paramMap['privilege'])
		else:
			game.privilege.active(yyObj.paramMap['privilege'])

		if 'lastday' not in record:
			logger.warning('some error happened')
			record['lastday'] = date2int(nowday)
			return
		lastday = int2date(record['lastday'])
		if lastday >= nowday or lastday >= endday:
			return

		nowday = min(endday, nowday)
		days = (nowday - lastday).days
		if days:
			mailID = CommonMonthCardMailID if yyObj.paramMap['rechargeID'] == 1 else SuperMonthCardMailID
			award = yyObj.paramMap['award']
			lastdt = datetime.datetime(lastday.year, lastday.month, lastday.day, hour=DailyRefreshHour)
			from game.mailqueue import MailJoinableQueue
			for i in xrange(1, days+1):
				sendTime = datetime2timestamp(lastdt + datetime.timedelta(days=i))
				mail = game.role.makeMyMailModel(mailID, attachs=award, sendTime=sendTime)
				MailJoinableQueue.send(mail)
			record['lastday'] = date2int(nowday)

	@classmethod
	def canBuy(cls, yyID, csvID, game):
		record = cls.getExistedRecord(yyID, game)
		if record is None or not record.get('enddate', 0):
			return True
		else:
			nowdate = inclock5date(nowdatetime_t())
			enddate = int2date(record['enddate'])
			cfg = csv.yunying.yyhuodong[yyID]
			rechargeID = cfg.paramMap['rechargeID']
			days = csv.recharges[rechargeID].param['days']
			if (enddate - nowdate).days < (cfg.paramMap['most'] - 1) * days:
				return True
		return False

	@classmethod
	def buyRecharge(cls, game, rechargeID, yyID, csvID, **kwargs):
		days = kwargs['days']
		record = cls.getRecord(yyID, game)
		nowdate = inclock5date(nowdatetime_t())
		enddate = int2date(record.get('enddate', todayinclock5date2int()))

		if nowdate > enddate or 'lastday' not in record: # ???
			enddate = nowdate + datetime.timedelta(days=days - 1)
			record['enddate'] = date2int(enddate)
			record['lastday'] = date2int(nowdate - OneDay)
		else: # ????????????
			enddate = enddate + datetime.timedelta(days=days)
			record['enddate'] = date2int(enddate)

		privilege = csv.yunying.yyhuodong[yyID].paramMap['privilege']
		game.privilege.active(privilege)
		title = csv.yunying.yyhuodong[yyID].paramMap.get('title', None)
		if title:
			game.role.addTitle(title)
		yyObj = ObjectYYHuoDongFactory.getConfig(yyID)
		if yyObj:
			cls.active(yyObj, game)
		return True, None

	@classmethod
	def isRechargeOK(cls, rechargeID, yyID, csvID):
		cfg = csv.yunying.yyhuodong[yyID]
		if not cfg or cfg.paramMap.get('rechargeID', None) != rechargeID:
			return False
		return True

	@classmethod
	def getEffect(cls, yyID, csvID, game):
		raise ClientError('can not get')

#
# ObjectYYDinnerTime
#

class ObjectYYDinnerTime(ObjectYYBase):
	'''
	??
	'''
	# {lastday:20180702, ok:0}
	@classmethod
	def classInit(cls):
		pass

	@classmethod
	def getEffect(cls, yyID, csvID, game):
		record = cls.getRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		lastday = record.get('lastday', None)
		if lastday == todayinclock5date2int():
			raise ClientError(ErrDefs.yyHuoDongAlreadyGet)

		yyconfig = csv.yunying.yyhuodong[yyID]

		# ???? ?? ????????
		beginTime = yyconfig.beginTime
		openDuration = yyconfig.openDuration
		now = nowdatetime_t()
		todayStart = datetime.datetime.combine(int2date(todayinclock5date2int()), int2time(beginTime))
		todayEnd = todayStart + datetime.timedelta(hours=openDuration)

		# ????????????, ????
		# if todayEnd < globaldata.GameServOpenDatetime:
		# 	raise ClientError(ErrDefs.regainBeforeOpened)

		# ???? ?? ????,???
		if now < todayStart:
			return
		if now >= todayEnd:
			costRMB = ObjectYYRegainStamina.rmb

			cost = ObjectCostAux(game, {'rmb': costRMB})
			if not cost.isEnough():
				raise ClientError(ErrDefs.dailyBuyRMBNotEnough)
			cost.cost(src='yy_dinner')

		def _afterGain():
			record['lastday'] = todayinclock5date2int()

		eff = ObjectYYHuoDongEffect(game, csv.yunying.yyhuodong[yyID].paramMap, _afterGain)
		eff.stamina += game.trainer.staminaGain(yyID)
		return eff


#
# ObjectYYEveryDayLogin
#

class ObjectYYEveryDayLogin(ObjectYYBase):
	'''
	??????
	??????
	'''

	@classmethod
	def classInit(cls):
		pass

	@classmethod
	def active(cls, yyObj, game):
		# ????????active,??getEffect
		return

	@classmethod
	def getEffect(cls, yyID, _, game):
		from game.mailqueue import ObjectMailEffect as ObjectYYHuoDongMailEffect

		record = cls.getRecord(yyID, game)
		oldDate = record.get('lastday', None)
		nowDate = todayinclock5date2int()
		if oldDate == nowDate:
			return None
		mail = game.role.makeMyMailModel(csv.yunying.yyhuodong[yyID].paramMap['mailID'])

		def _afterGain():
			record['lastday'] = nowDate
		return ObjectYYHuoDongMailEffect(mail, _afterGain)


#
# ObjectYYWorldBoss
#

class ObjectYYWorldBoss(ObjectYYBase):
	'''
	??boss
	'''

	WorldBossCfg = {}
	DamageAward = {}

	@classmethod
	def classInit(cls):
		for idx in csv.world_boss.base:
			cfg = csv.world_boss.base[idx]
			cls.WorldBossCfg[cfg.huodongID] = cfg

		for idx in csv.world_boss.damage_award:
			cfg = csv.world_boss.damage_award[idx]
			cls.DamageAward.setdefault(cfg.huodongID, [])
			cls.DamageAward[cfg.huodongID].append([idx, cfg.damage])
		for huodongID in cls.DamageAward.iterkeys():
			cls.DamageAward[huodongID] = sorted(cls.DamageAward[huodongID], key=lambda x: x[1])

	@classmethod
	def getWorldBossCfg(cls, huodongID):
		return cls.WorldBossCfg.get(huodongID, None)

	@classmethod
	def getDamageAward(cls, game, huodongID, damage):
		idx = None
		for item in cls.DamageAward[huodongID]:
			if damage >= item[1]:
				idx = item[0]
			else:
				break
		if idx is None:
			return None
		return ObjectGainAux(game, csv.world_boss.damage_award[idx].award)

	@classmethod
	def active(cls, yyObj, game):
		# ????????active
		return

	@classmethod
	def getEffect(cls, yyID, _, game):
		return None

#
# ObjectYYDoubleDrop
#

class ObjectYYDoubleDrop(ObjectYYBase):
	'''
	????
	'''

	@classmethod
	def classInit(cls):
		pass

	@classmethod
	def active(cls, yyObj, game):
		# ????????active
		return

	@classmethod
	def getEffect(cls, yyID, _, game):
		return None


#
# ObjectYYLimitDrop
#

class ObjectYYLimitDrop(ObjectYYBase):
	'''
	????
	'''

	@classmethod
	def classInit(cls):
		pass

	@classmethod
	def active(cls, yyObj, game):
		# ????????active
		return

	@classmethod
	def getEffect(cls, yyID, _, game):
		return None


#
# ObjectYYClientShow
#

class ObjectYYClientShow(ObjectYYBase):
	'''
	????
	????
	'''

	@classmethod
	def classInit(cls):
		pass

	@classmethod
	def active(cls, yyObj, game):
		# ?????,???active
		return

	@classmethod
	def getEffect(cls, yyID, _, game):
		return None


#
# ObjectYYRechargeReset
#

class ObjectYYRechargeReset(ObjectYYBase):
	'''
	??????
	'''

	@classmethod
	def classInit(cls):
		pass

	@classmethod
	def active(cls, yyObj, game):
		import framework
		for rechargeID in csv.recharges:
			cfg = csv.recharges[rechargeID]
			if framework.__language__ not in cfg.languages:
				continue
			# ????????,????
			if cfg.type == RechargeDefs.OneOffType:
				# ????reset??,????1???+1???
				recharge = game.role.recharges.setdefault(rechargeID, {})
				# 0 ?? ????,????ID
				# >0 ?? ??????ID
				# <0 ?? ??????ID
				reset = recharge.get('reset', 0)
				# id?????????
				if abs(reset) < yyObj.id:
					recharge['reset'] = yyObj.id

	@classmethod
	def getEffect(cls, yyID, _, game):
		return None

#
# ObjectYYGateAward
#

class ObjectYYGateAward(ObjectYYBase):
	'''
	????
	'''

	HuoDongMap = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.gateaward
		return csv.yunying.gateaward[csvID]

	@classmethod
	def active(cls, yyObj, game):
		hd = cls.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return

		record = cls.getRecord(yyObj.id, game)
		stamps = record.setdefault('stamps', {})
		for i, gateID in enumerate(hd.gateIDs):
			csvID = hd.csvIDs[i]
			if game.role.gate_star.get(gateID, {}).get('star', 0) > 0:
				if csvID not in stamps:
					stamps[csvID] = 1 # ???

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = csvIDs
		self.gateIDs = [self.csv(x).gateID for x in self.csvIDs]

		ObjectYYGateAward.HuoDongMap[huodongID] = self


#
# ObjectYYVIPAward
#

class ObjectYYVIPAward(ObjectYYBase):
	'''
	????
	'''

	HuoDongMap = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.vipaward
		return csv.yunying.vipaward[csvID]

	@classmethod
	def active(cls, yyObj, game):
		hd = cls.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return
		record = cls.getRecord(yyObj.id, game)
		stamps = record.setdefault('stamps', {})
		for i, needLevel in enumerate(hd.needLevels):
			csvID = hd.csvIDs[i]
			if game.role.vip_level >= needLevel:
				if csvID not in stamps:
					stamps[csvID] = 1 # ???
			else:
				break

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = sorted(csvIDs, key=lambda x: csv.yunying.vipaward[x].needLevel)
		self.needLevels = [self.csv(x).needLevel for x in self.csvIDs]

		ObjectYYVIPAward.HuoDongMap[huodongID] = self


#
# ObjectYYItemExchange
#

class ObjectYYItemExchange(ObjectYYBase):
	'''
	????

	{lastday: 20160719, stamps: {csvID: ??}}
	'''

	HuoDongMap = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.itemexchange
		return csv.yunying.itemexchange[csvID]

	@classmethod
	def active(cls, yyObj, game):
		hd = cls.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return

		cls.refreshRecord(yyObj, game)

	@classmethod
	def canExchange(cls, csvID, role):
		cfg = csv.yunying.itemexchange[csvID]
		for typ, val in cfg.limit.items():
			if typ == YYHuoDongDefs.ItemExchangeVIPLimit:
				if role.vip_level < val:
					return False
			elif typ == YYHuoDongDefs.ItemExchangeLevelLimit:
				if role.level < val:
					return False
			elif typ == YYHuoDongDefs.ItemExchangePokedexLimit:
				if val not in role.pokedex:
					return False
			elif typ == YYHuoDongDefs.ItemExchangeLogoLimit:
				if val in role.logos:
					return False
			elif typ == YYHuoDongDefs.ItemExchangeSkinlLimit:
				if val in role.skins and not role.skins[val]:
					return False
		return True

	@classmethod
	def getEffect(cls, yyID, csvID, game, count=1):
		record = cls.getRecord(yyID, game)
		stamps = record.setdefault('stamps', {})
		cfg = csv.yunying.itemexchange[csvID]
		if cfg.huodongID != ObjectYYHuoDongFactory.getConfig(yyID).huodongID:
			raise ClientError('huodongID error')
		# ????
		if not cls.canExchange(csvID, game.role):
			raise ClientError(ErrDefs.itemExchangeLimit)
		# ????
		if cfg.exchangeTimes and stamps.get(csvID, 0) + count > cfg.exchangeTimes:
			raise ClientError(ErrDefs.exchangeMax)
		# ????
		# logger.info(record)
		# logger.info("ObjectYYItemExchange %s",cfg.costMap) {6321: 1}
		cost = ObjectCostAux(game, cfg.costMap)
		# logger.info("ObjectYYItemExchange %s csvID: %s",cost ,csvID)
		cost *= count
		# logger.info("ObjectYYItemExchange count %s count: %s",cost ,count)
		if not cost.isEnough():
			if cost.lack == ObjectCostAux.LackGold:
				raise ClientError(ErrDefs.exchangeGoldNotEnough)
			else:
				raise ClientError(ErrDefs.exchangeItemNotEnough)
		cost.cost(src='yy_%d' % yyID)

		def _afterGain():
			stamps[csvID] = stamps.get(csvID, 0) + count
		eff = ObjectYYHuoDongEffect(game, cfg.items, _afterGain)
		eff *= count
		return eff

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = csvIDs

		ObjectYYItemExchange.HuoDongMap[huodongID] = self


#
# ObjectYYRMBCost
#

class ObjectYYRMBCost(ObjectYYBase):
	'''
	????
	'''

	HuoDongMap = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.rmbcost
		return csv.yunying.rmbcost[csvID]

	@classmethod
	def active(cls, yyObj, game, rmb):
		hd = cls.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return
		record = cls.getRecord(yyObj.id, game)
		stamps = record.setdefault('stamps', {})
		info = record.setdefault('info', {})
		rmbsum = info.get('rmbsum', 0) + rmb
		info['rmbsum'] = rmbsum
		for i, amount in enumerate(hd.amounts):
			csvID = hd.csvIDs[i]
			if rmbsum >= amount:
				if csvID not in stamps:
					stamps[csvID] = 1 # ???
			else:
				break

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = sorted(csvIDs, key=lambda x: self.csv(x).amount)
		self.amounts = [self.csv(x).amount for x in self.csvIDs]

		ObjectYYRMBCost.HuoDongMap[huodongID] = self


def targetActive(taskType, csvID, val, valsum, valinfoD, sp=None):
	# ????
	if taskType == TargetDefs.LoginDays:
		oldDate = valinfoD.setdefault(csvID, {}).get('lastday', None)
		nowDate = perioddate2int(globaldata.DailyRecordRefreshTime) # 5???
		if oldDate != nowDate:
			valinfoD[csvID]['lastday'] = nowDate
			valsum = valsum + 1
	# ?????????(??)???????, ??val????quality
	elif taskType == TargetDefs.DispatchTaskQualityDone:
		_, quality = sp().items()[0]
		if val < quality:
			return valsum, False
		valsum = valsum + 1
	# ???????????, ??val??????
	elif taskType == TargetDefs.RandomTowerFloorMax:
		if val <= valsum:
			return valsum, False
		valsum = val
	# ????????????
	elif taskType == TargetDefs.RandomTowerFloorSum:
		_, quality = sp().items()[0]
		if val < quality:
			return valsum, False
		oldDate = valinfoD.setdefault(csvID, {}).get('lastday', None)
		nowDate = perioddate2int(globaldata.DailyRecordRefreshTime) # 5???
		if oldDate != nowDate:
			valinfoD[csvID]['lastday'] = nowDate
			valsum = valsum + 1
	elif val != 0:
		valsum = valsum + val
	return valsum, True

#
# ObjectYYGeneralTask
#

class ObjectYYGeneralTask(ObjectYYBase):
	'''
	??
	'''
	#{csvID:1,valsums:{csvid:count},valinfo:{lastday:20181225}}
	HuoDongMap = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.generaltask
		return csv.yunying.generaltask[csvID]

	@classmethod
	def active(cls, yyObj, game, type, val):
		hd = cls.getHd(yyObj, game)
		if hd is None:
			return

		record = cls.refreshRecord(yyObj, game)
		stamps = record.setdefault('stamps', {})
		valsumsD = record.setdefault('valsums', {})
		valinfoD = record.setdefault('valinfo', {})
		for i, tpred in enumerate(hd.typePreds):
			csvID = hd.csvIDs[i]
			taskType, taskPred = tpred
			# ?????????
			if taskType != type:
				continue
			valsum = valsumsD.get(csvID, 0)
			valsum, ok = targetActive(taskType, csvID, val, valsum, valinfoD, sp=lambda :cls.csv(csvID).taskSpecialParam)
			if not ok:
				continue
			valsumsD[csvID] = valsum
			if csvID not in stamps:
				if taskPred(game, valsum):
					cls.onPredTrue(yyObj, game, csvID)

	@classmethod
	def onPredTrue(cls, yyObj, game, csvID):
		record = cls.getRecord(yyObj.id, game)
		stamps = record.setdefault('stamps', {})
		stamps[csvID] = 1 # ???

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = sorted(csvIDs)
		self.typePreds = [predGen(self.csv(x).taskType, self.csv(x).taskParam, self.csv(x).taskSpecialParam) for x in self.csvIDs]

		self.HuoDongMap[huodongID] = self

#
# ObjectYYLimitTask
#

class ObjectYYLimitTask(ObjectYYGeneralTask):
	DailyTask = {}

	@classmethod
	def classInit(cls):
		cls.DailyTask = {}
		for csvID in csv.yunying.generaltask:
			cfg = csv.yunying.generaltask[csvID]
			cls.DailyTask.setdefault(cfg.huodongID, []).append(csvID)
		for huodongID, csvIDs in cls.DailyTask.iteritems():
			cls(huodongID, csvIDs)
	
	@classmethod
	def getHd(cls, yyObj, game):
		hd = cls.HuoDongMap.get(yyObj.huodongID)
		return cls.HuoDongMap.get(yyObj.huodongID)

	@classmethod
	def refreshRecord(cls, yyObj, game):
		record = cls.getRecord(yyObj.id, game)
		now = todayinclock5date2int()
		if record.get("lastday", None) != now:
			record["lastday"] = now
			record["stamps"] = {}
			record["valsums"] = {}
		return record


	@classmethod
	def active(cls, yyObj, game, type, val):
		record = cls.refreshRecord(yyObj, game)
		return super(ObjectYYLimitTask, cls).active(yyObj, game, type, val)




#
# ObjectYYServerOpen
#

class ObjectYYServerOpen(ObjectYYBase):
	'''
	????
	????????
	'''
	HuoDongMap = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.serveropen
		return csv.yunying.serveropen[csvID]

	'''
	yyhuodongs[yyhuodong.id] = {
		stamps : {
			serveropen.id: 0 ??? 1 ???
		}
		valsums: {
			serveropen.id: ???
		}
		valinfo: {
			serveropen.id: {????}
		}
		targets: {
			all: ???
			cur: ????
		}
	}
	'''
	@classmethod
	def canCount(cls, csvID, day):
		countType = cls.csv(csvID).countType
		if countType == YYHuoDongDefs.ForceCount: # ????
			return True
		daySum = cls.csv(csvID).daySum
		if countType == YYHuoDongDefs.OnDayCount: # ???????
			return day == daySum
		return day >= daySum # ???????

	@classmethod
	def active(cls, yyObj, game, type, val):
		hd = cls.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return

		record = cls.getRecord(yyObj.id, game)
		stamps = record.setdefault('stamps', {})
		valsumsD = record.setdefault('valsums', {})
		valinfoD = record.setdefault('valinfo', {})
		targetsD = record.setdefault('targets', {})

		# ???
		key = csv.yunying.yyhuodong[yyObj.id].paramMap['itemId']
		targetsD['all'] = hd.targetAll(key)
		targetsD.setdefault('cur', 0)

		day = todayinclock5elapsedays(yyObj.gameBeginDateTime(game))
		day += 1

		for i, tpred in enumerate(hd.typePreds):
			csvID = hd.csvIDs[i]
			taskType, taskPred = tpred
			# ?????????
			# ??TaskLoginDays,?????????????????
			if taskType != type and type != TargetDefs.LoginDays:
				continue

			if cls.canCount(csvID, day):
				valsum = valsumsD.get(csvID, 0)
				valsum, ok = targetActive(taskType, csvID, val, valsum, valinfoD, sp=lambda :cls.csv(csvID).taskSpecialParam)
				if not ok:
					continue
				valsumsD[csvID] = valsum

			if day >= cls.csv(csvID).daySum:
				if csvID not in stamps:
					if taskPred(game, valsumsD.get(csvID, 0)):
						stamps[csvID] = 1 # ???

	@classmethod
	def getEffect(cls, yyID, csvID, game):
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		cfg = cls.csv(csvID)
		if cfg.huodongID != ObjectYYHuoDongFactory.getConfig(yyID).huodongID:
			raise ClientError('huodongID error')
		key = csv.yunying.yyhuodong[yyID].paramMap['itemId']
		valinfoD = record.setdefault('valinfo', {})
		targetsD = record.setdefault('targets', {})
		if cfg.taskType == TargetDefs.ItemBuy: # ????
			yyObj = ObjectYYHuoDongFactory.getConfig(yyID)
			day = todayinclock5elapsedays(yyObj.gameBeginDateTime(game))
			day += 1
			if not cls.canCount(csvID, day):
				raise ClientError('day limit')
			old = valinfoD.setdefault(csvID, {}).get('times', 0)
			if old >= cfg.buyMax:
				raise ClientError('buy max')
			cost = ObjectCostAux(game, cfg.costMap)
			if not cost.isEnough():
				raise ClientError('not enough')
			cost.cost(src='yy_%d' % yyID)

			def _afterGain():
				valinfoD[csvID]['times'] = old + 1
				targetsD['cur'] += cfg.award.get(key, 0)
		else:
			if record['stamps'].get(csvID, None) != 1:
				raise ClientError(ErrDefs.yyHuoDongNoActive)

			def _afterGain():
				record['stamps'][csvID] = 0 # ???
				targetsD['cur'] += cfg.award.get(key, 0)

		return ObjectYYHuoDongEffect(game, cfg.award, _afterGain)

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = sorted(csvIDs, key=lambda x: csv.yunying.serveropen[x].daySum)
		self.typePreds = [predGen(self.csv(x).taskType, self.csv(x).taskParam, self.csv(x).taskSpecialParam) for x in self.csvIDs]
		self.count = None

		self.HuoDongMap[huodongID] = self

	def targetAll(self, key):
		if self.count is not None:
			return self.count
		self.count = sum([self.csv(csvID).award.get(key, 0) for csvID in self.csvIDs])
		return self.count


#
# ObjectYYFightRank
#

class ObjectYYFightRank(ObjectYYBase):
	'''
	????
	?????active,?????
	'''
	HuoDongMap = {} # {yyID: True}
	TopSnapShot = {}
	FightRankMap = {}
	FightPointMap = {}

	@classmethod
	def classInit(cls):
		cls.FightRankMap = {}
		for csvID in csv.yunying.fightrankaward:
			cfg = csv.yunying.fightrankaward[csvID]
			if cfg.huodongID not in cls.FightRankMap:
				cls.FightRankMap[cfg.huodongID] = []
			cls.FightRankMap[cfg.huodongID].append(csvID)

		for huodongID in cls.FightRankMap:
			cls.FightRankMap[huodongID] = sorted(cls.FightRankMap[huodongID], key=lambda x: csv.yunying.fightrankaward[x].rank)

		cls.FightPointMap = {}
		for csvID in csv.yunying.fightpointaward:
			cfg = csv.yunying.fightpointaward[csvID]
			if cfg.huodongID not in cls.FightPointMap:
				cls.FightPointMap[cfg.huodongID] = []
			cls.FightPointMap[cfg.huodongID].append(csvID)

		for huodongID in cls.FightPointMap:
			cls.FightPointMap[huodongID] = sorted(cls.FightPointMap[huodongID], key=lambda x: csv.yunying.fightpointaward[x].fightPointRequire, reverse=True)


	@classmethod
	def active(cls, yyObj, _):
		if yyObj.id in cls.HuoDongMap:
			return
		cls.HuoDongMap[yyObj.id] = True

		from game.session import Session

		# ???????
		# ?????7?21:30(?????+6?
		delta = min(cls.getAwardDateTime(yyObj), yyObj.gameEndDateTime(None)) - nowdatetime_t()
		Session.startYYFightRankTimer(yyObj.id, delta)

	@classmethod
	def getEffect(cls, yyID, csvID, game):
		# ????????
		return None

	@classmethod
	def setTop10RankModel(cls, db):
		cls.TopSnapShot = db

	@classmethod
	def getTop10RankModel(cls, yyID):
		# ??? ServerGlobalRecord.fight_rank_history
		return cls.TopSnapShot.get(yyID, None)

	@classmethod
	def onAward(cls, yyID, top10, roleIDPoints):
		from game.object.game.role import ObjectRole

		cls.TopSnapShot[yyID] = top10
		huodongID = csv.yunying.yyhuodong[yyID].huodongID
		mails = []

		# ????
		csvIDs = cls.FightRankMap[huodongID]
		for i, rankModel in enumerate(top10):
			cfg = csv.yunying.fightrankaward[csvIDs[i]]
			if rankModel['fighting_point'] < cfg.fightPointLeast:
				continue

			mail = ObjectRole.makeMailModel(rankModel['role']['id'], YYHuoDongFightRankLevelAwardMailID, attachs=cfg.award)
			mails.append(mail)

		# ????
		csvIDs = cls.FightPointMap[huodongID]
		idx = 0
		cfg = csv.yunying.fightpointaward[csvIDs[idx]]
		for rp in roleIDPoints:
			roleID, point = rp['role']['id'], rp['fighting_point']
			while cfg:
				if point >= cfg.fightPointRequire:
					mail = ObjectRole.makeMailModel(roleID, YYHuoDongFightRankPointAwardMailID, attachs=cfg.award)
					mails.append(mail)
					break

				else:
					idx += 1
					cfg = csv.yunying.fightpointaward[csvIDs[idx]] if idx < len(csvIDs) else None

		return mails

	@classmethod
	def getAwardDateTime(cls, yyObj):
		# ????????????????,?????None
		# ????????
		endDT = datetime.datetime.combine(yyObj.gameEndDateTime(None).date() - OneDay, datetime.time(hour=21, minute=30))
		return endDT


#
# ObjectYYLuckyCat
#

class ObjectYYLuckyCat(ObjectYYBase):
	'''
	???
	'''
	HuoDongMap = {}
	BroadcastMessageRMB = []
	BroadcastMessageGold = []

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.luckycat
		return csv.yunying.luckycat[csvID]

	@classmethod
	def active(cls, yyObj, game):
		hd = cls.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return

		record = cls.getRecord(yyObj.id, game)
		info = record.setdefault('info', {})
		info.setdefault('count', 0)

	@classmethod
	def getEffect(cls, yyID, _, game):
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		huodongID = ObjectYYHuoDongFactory.getConfig(yyID).huodongID
		hd = cls.HuoDongMap.get(huodongID, None)
		if hd is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		info = record.setdefault('info', {})
		count = info.setdefault('count', 0)
		if count > len(hd.csvIDs):
			raise ClientError(ErrDefs.luckyCatMax)

		cfg = cls.csv(hd.csvIDs[count])
		yyCfg = csv.yunying.yyhuodong[yyID]
		coinType = yyCfg.paramMap.get('type', '')
		if coinType not in ['rmb', 'gold']:
			raise ClientError('config error')

		if count != cfg.drawID:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		if cfg.vip > game.role.vip_level:
			raise ClientError(ErrDefs.luckyCatVIPNotEnough)

		rndObj = hd.rndObjs[count]
		gainNum = random.randint(*(rndObj.getRandom()[0]))

		if coinType == 'rmb':
			if cfg.rmbCost > game.role.rmb:
				raise ClientError(ErrDefs.luckyCatRMBNotEnough)
			# ???????
			game.role.setRMBWithoutRecord(game.role.rmb - cfg.rmbCost)
			cls.BroadcastMessageRMB = cls.BroadcastMessageRMB[-YYHuoDongLuckyCatMessageMax:] + [(game.role.name, gainNum)]
		else:
			if cfg.goldCost > game.role.gold:
				raise ClientError(ErrDefs.luckyCatGoldNotEnough)
			# ???????
			game.role.setGoldWithoutRecord(game.role.gold - cfg.goldCost)
			cls.BroadcastMessageGold = cls.BroadcastMessageGold[-YYHuoDongLuckyCatMessageMax:] + [(game.role.name, gainNum)]

		def _afterGain():
			info['count'] = count + 1
		return ObjectYYHuoDongEffect(game, {coinType: gainNum}, _afterGain)

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = sorted(csvIDs, key=lambda x: self.csv(x).drawID)
		self.rndObjs = [
			WeightRandomObject([(self.csv(x)['range%d' % (i+1)], self.csv(x)['weight%d' % (i+1)]) for i in xrange(5)])
			for x in self.csvIDs
		]

		ObjectYYLuckyCat.HuoDongMap[huodongID] = self


#
# ObjectYYCollectCard
#

class ObjectYYCollectCard(ObjectYYGeneralTask):
	'''
	?????
	'''
	HuoDongMap = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.collectcard
		return csv.yunying.collectcard[csvID]

	@classmethod
	def active(cls, yyObj, game):
		super(cls, cls).active(yyObj, game, TargetDefs.HadCard, 0)


#
# ObjectYYDailyBuy
#

class ObjectYYDailyBuy(ObjectYYBase):
	'''
	????
	'''
	HuoDongMap = {}
	ServerBuy = {}
	ServerBegin = {}
	ServerDelta = {}

	@classmethod
	def classInit(cls):
		super(cls, cls).classInit()
		cls.ServerDelta = {}
		cls.ServerBegin = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.dailybuy
		return csv.yunying.dailybuy[csvID]

	@classmethod
	def calcBuyYet(cls, beginDateTime, csvID):
		# ???????
		delta = max(0.0, 1.0 * (nowdatetime_t() - beginDateTime).total_seconds())
		cost = cls.ServerDelta.get(csvID, (0, 0))
		buyYet = int(cost[0] * delta) # ???s
		buyYet = random.randint(max(0, buyYet - cost[1]), buyYet) # ??h??
		cls.ServerBuy[csvID] = max(cls.ServerBuy.get(csvID, 0), buyYet)

	@classmethod
	def active(cls, yyObj, game):
		hd = cls.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return

		if yyObj.id not in cls.ServerBegin:
			cls.ServerBegin[yyObj.id] = yyObj.gameBeginDateTime(game)
			for x in hd.csvIDs:
				delta = 1.0 * (yyObj.endDateTime - yyObj.beginDateTime).total_seconds()
				deltaHour = delta / 3600.0
				cls.ServerDelta[x] = (cls.csv(x).buyMax / delta, int(cls.csv(x).buyMax / deltaHour))
				cls.calcBuyYet(yyObj.gameBeginDateTime(game), x)

		record = cls.getRecord(yyObj.id, game)
		nowIdx = todayinclock5elapsedays(yyObj.gameBeginDateTime(game))
		info = record.setdefault('info', {})
		info['now'] = nowIdx

	@classmethod
	def getEffect(cls, yyID, csvID, game):
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		stamps = record.setdefault('stamps', {})
		info = record.setdefault('info', {})

		# ??
		beginDateTime = cls.ServerBegin[yyID]
		nowIdx = todayinclock5elapsedays(beginDateTime)
		info['now'] = nowIdx
		cls.calcBuyYet(cls.ServerBegin[yyID], csvID)

		cfg = cls.csv(csvID)
		if cfg.huodongID != ObjectYYHuoDongFactory.getConfig(yyID).huodongID:
			raise ClientError('huodongID error')
		if cfg.dayIdx > nowIdx:
			raise ClientError(ErrDefs.dailyBuyPast)

		if cfg.vipLeast > game.role.vip_level:
			raise ClientError(ErrDefs.dailyBuyVIPNotEnough)

		# ?????
		if stamps.get(csvID, 0) > 0:
			raise ClientError(ErrDefs.dailyBuyMax)

		cost = ObjectCostAux(game, {'rmb': cfg.rmbCost})
		if not cost.isEnough():
			raise ClientError(ErrDefs.dailyBuyRMBNotEnough)
		cost.cost(src='yy_daily_buy')

		def _afterGain():
			stamps[csvID] = stamps.get(csvID, 0) + 1 # ????
			cls.ServerBuy[csvID] = cls.ServerBuy.get(csvID, 0) + 1
		return ObjectYYHuoDongEffect(game, cfg.item, _afterGain)

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = sorted(csvIDs, key=lambda x: self.csv(x).dayIdx)

		ObjectYYDailyBuy.HuoDongMap[huodongID] = self


#
# ObjectYYVIPBuy
#

class ObjectYYVIPBuy(ObjectYYBase):
	'''
	VIP??
	'''
	HuoDongMap = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.vipbuy
		return csv.yunying.vipbuy[csvID]

	@classmethod
	def active(cls, yyObj, game):
		hd = cls.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return

		record = cls.getRecord(yyObj.id, game)
		stamps = record.setdefault('stamps', {})
		for i, vip in enumerate(hd.vips):
			csvID = hd.csvIDs[i]
			if game.role.vip_level >= vip:
				if csvID not in stamps:
					stamps[csvID] = 1 # ???
			else:
				break

	@classmethod
	def getEffect(cls, yyID, csvID, game):
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		stamps = record.setdefault('stamps', {})
		if stamps.get(csvID, None) != 1:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		costRMB = cls.csv(csvID).rmb

		cost = ObjectCostAux(game, {'rmb': costRMB})
		if not cost.isEnough():
			raise ClientError(ErrDefs.buyRMBNotEnough)
		cost.cost(src='yy_vip_buy')

		def _afterGain():
			stamps[csvID] = 0 # ???
		return ObjectYYHuoDongEffect(game, cls.csv(csvID).item, _afterGain)

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		# VIP??,id??
		self.csvIDs = sorted(csvIDs, key=lambda x: (self.csv(x).vip, x))
		self.vips = [self.csv(x).vip for x in self.csvIDs]

		ObjectYYVIPBuy.HuoDongMap[huodongID] = self


#
# ObjectYYLevelFund
#

class ObjectYYLevelFund(ObjectYYBase):
	'''
	????

	???????,?????VIP3?1000????
	'''

	HuoDongMap = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.levelfund
		return csv.yunying.levelfund[csvID]

	@classmethod
	def active(cls, yyObj, game):
		hd = cls.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return

		record = cls.getRecord(yyObj.id, game)
		if record.get('buy', None) != 1:
			return
		stamps = record.setdefault('stamps', {})

		for i, needLevel in enumerate(hd.needLevels):
			csvID = hd.csvIDs[i]
			if game.role.level >= needLevel:
				if csvID not in stamps:
					stamps[csvID] = 1 # ???
			else:
				break

	@classmethod
	def buy(cls, yyID, game):
		record = cls.getRecord(yyID, game)
		if record.get('buy', None) == 1:
			raise ClientError(ErrDefs.yyBuyYet)

		paramMap = csv.yunying.yyhuodong[yyID].paramMap

		if game.role.vip_level < paramMap['vip']:
			raise ClientError(ErrDefs.yyBuyVIPNotEnough)

		cost = ObjectCostAux(game, {'rmb': paramMap['rmb']})
		if not cost.isEnough():
			raise ClientError(ErrDefs.buyRMBNotEnough)
		cost.cost(src='yy_level_fund')
		record['buy'] = 1 # ???

	@classmethod
	def getEffect(cls, yyID, csvID, game):
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		stamps = record.setdefault('stamps', {})
		if stamps.get(csvID, None) != 1:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		award = cls.csv(csvID).award
		def _afterGain():
			stamps[csvID] = 0 # ???
		return ObjectYYHuoDongEffect(game, award, _afterGain)

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = sorted(csvIDs, key=lambda x: self.csv(x).needLevel)
		self.needLevels = [self.csv(x).needLevel for x in self.csvIDs]

		ObjectYYLevelFund.HuoDongMap[huodongID] = self


#
# ObjectYYRetrieve
#

class ObjectYYRetrieve(ObjectYYBase):
	'''
	????
	'''
	HuoDongMap = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.retrieve
		return csv.yunying.retrieve[csvID]

	@classmethod
	def active(cls, yyObj, game):
		hd = cls.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return
		cls.refreshRecord(yyObj, game)

	@classmethod
	def getEffect(cls, yyID, game, retrieveType, tab):
		huodongID = ObjectYYHuoDongFactory.getConfig(yyID).huodongID
		hd = cls.HuoDongMap.get(huodongID, None)
		if hd is None:
			return

		record = cls.getRecord(yyID, game)
		if record.get('lastday', None) != todayinclock5date2int():
			raise ClientError("no items retrieve")
		info = record.setdefault('info', {})
		cfg = None
		for i, level in enumerate(hd.levels):
			if info['level'] == level:
				cfg = cls.csv(hd.csvIDs[i])
				break
		if retrieveType not in cfg:
			raise ClientError("retrieveType error")
		awardGain = cfg[retrieveType]
		retrieve_award = record.setdefault('retrieve_award', {})
		retrieve_info = retrieve_award.get(retrieveType, {})
		if retrieve_info.get(tab, 0):
			raise ClientError("can not retrieve again")
		yyCfg = csv.yunying.yyhuodong[yyID]
		freeProportion = yyCfg.paramMap['freeProportion']
		limit = yyCfg.paramMap['limit']
		dayUpd = yyCfg.paramMap['dayUpd']
		rmbUpd = yyCfg.paramMap['rmbUpd']

		days = min(info.get('days', 0), limit)

		eff = ObjectGainAux(game, awardGain)
		# multiple ??
		multiple = (freeProportion/100.0) * dayUpd[days-1]
		eff *= multiple
		if tab == RetrieveDefs.RMB:
			effRmb = ObjectGainAux(game, awardGain)
			multiple = 1.0 * dayUpd[days - 1]
			effRmb *= multiple
			# ?????
			if retrieve_info.get(RetrieveDefs.Free, 0):
				effRmb -= eff
				eff = effRmb
			else:
				eff = effRmb

			cost = ObjectCostAux(game, {'rmb': cfg['cost'][retrieveType]})
			cost.setCeil()  # ????
			cost *= rmbUpd[days-1]
			if not cost.isEnough():
				raise ClientError("cost rmb not enough")
			cost.cost(src='retrieve_cost')

		retrieve_info[tab] = 1
		retrieve_award[retrieveType] = retrieve_info
		record['retrieve_award'] = retrieve_award
		cls.setRecord(yyID, game, record)
		return eff

	# ????
	@classmethod
	def refreshRecord(cls, yyObj, game):
		record = cls.getRecord(yyObj.id, game)
		days = todayinclock5elapsedays(game.role.lastLoginDateTime)
		if record.get('lastday', None) != todayinclock5date2int():
			# ???? 1, ???????,??????
			if days > 1:
				record = {}
				info = record.setdefault('info', {})
				info['days'] = days - 1
				info['level'] = game.role.level
				record['lastday'] = todayinclock5date2int()
			else:
				record = {}
			cls.setRecord(yyObj.id, game, record)
		return record

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = sorted(csvIDs, key=lambda x: self.csv(x).level)
		self.levels = [self.csv(x).level for x in self.csvIDs]
		ObjectYYRetrieve.HuoDongMap[huodongID] = self

#
# ObjectYYItemBuy
#

class ObjectYYItemBuy(ObjectYYBase):
	'''
	????

	{lastday: 20160719, [csvID]: ????}
	yyhuodong.csv??countType????????
	'''
	HuoDongMap = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.itembuy
		return csv.yunying.itembuy[csvID]

	@classmethod
	def active(cls, yyObj, game):
		hd = cls.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return

		record = cls.refreshRecord(yyObj, game)

	@classmethod
	def refreshRecord(cls, yyObj, game):
		record = cls.getRecord(yyObj.id, game)
		ndi = todayinclock5date2int()
		if ndi != record.get('lastday', 0):
			if yyObj.countType == YYHuoDongDefs.DailyCount:
				record = cls.setRecord(yyObj.id, game, {'lastday': ndi})
			else:
				hd = cls.HuoDongMap.get(yyObj.huodongID)
				stamps = record.setdefault('stamps', {})
				for csvid in hd.csvIDs:
					cfg = cls.csv(csvid)
					if cfg.refresh:
						stamps.pop(csvid, 0)
				record['lastday'] = ndi
		return record

	@classmethod
	def getEffect(cls, yyID, csvID, game, count=1):
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		cfg = cls.csv(csvID)
		if cfg.rmbCost > game.role.rmb:
			raise ClientError(ErrDefs.dailyBuyRMBNotEnough)
		if cfg.huodongID != ObjectYYHuoDongFactory.getConfig(yyID).huodongID:
			raise ClientError('huodongID error')

		realCount = 0
		stamps = record.setdefault('stamps', {})
		count = min(count, cfg.buyMax - stamps.get(csvID, 0))
		for i in xrange(count):
			if (realCount + 1)*cfg.rmbCost > game.role.rmb:
				break
			else:
				realCount += 1
		if realCount <= 0:
			raise ClientError(ErrDefs.dailyBuyMax)
		cost = ObjectCostAux(game, {'rmb': realCount * cfg.rmbCost})
		cost.cost(src='yy_item_buy')

		def _afterGain():
			stamps[csvID] = stamps.get(csvID, 0) + realCount # ????
		eff = ObjectYYHuoDongEffect(game, cfg.item, _afterGain)
		eff *= realCount
		return eff

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = csvIDs

		ObjectYYItemBuy.HuoDongMap[huodongID] = self

#
# ObjectYYItemBuy2
#

class ObjectYYItemBuy2(ObjectYYItemBuy):
	'''
	????2(??)

	{[csvID]: ????}
	yyhuodong.csv??countType????????,?????
	?ObjectYYItemBuy????,??????????,????{}??,???????
	'''
	HuoDongMap = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.itembuy2
		return csv.yunying.itembuy2[csvID]

	@classmethod
	def getEffect(cls, yyID, csvID, game, count=1):
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		cfg = cls.csv(csvID)
		cost = ObjectCostAux(game, cfg.costMap)
		if not cost.isEnough():
			raise ClientError(ErrDefs.costNotEnough)

		realCount = 0
		stamps = record.setdefault('stamps', {})
		count = min(count, cfg.buyMax - stamps.get(csvID, 0))
		for i in xrange(count):
			costSum = cost * (i + 1)
			if not costSum.isEnough():
				break
			else:
				realCount += 1
		if realCount <= 0:
			raise ClientError(ErrDefs.dailyBuyMax)
		costSum = cost * realCount
		costSum.cost(src='yy_item_buy2')
		def _afterGain():
			stamps[csvID] = stamps.get(csvID, 0) + realCount # ????
		eff = ObjectYYHuoDongEffect(game, cfg.item, _afterGain)
		eff *= realCount
		return eff

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = csvIDs

		ObjectYYItemBuy2.HuoDongMap[huodongID] = self

#
# ObjectYYClone
#

class ObjectYYClone(ObjectYYBase):
	'''
	??????
	'''

	@classmethod
	def classInit(cls):
		pass

	@classmethod
	def active(cls, yyID):
		cfg = csv.yunying.yyhuodong[yyID]
		# ?????????
		# from game.object.game.clone import ObjectCloneRoomGlobal
		# ObjectCloneRoomGlobal.randomMonster()
		Session.startCloneYYActive({
			'yy_id': yyID,
			'nature': cfg['paramMap']['nature'],
			'monster': cfg['paramMap']['monster'],
		})

	@classmethod
	def onClose(cls):
		# ?????????
		# from game.object.game.clone import ObjectCloneRoomGlobal
		# ObjectCloneRoomGlobal.randomMonster()
		Session.startCloneYYClose()

	@classmethod
	def getEffect(cls, yyID, _, game):
		return None


#
# ObjectYYRegainStamina
#

class ObjectYYRegainStamina(ObjectYYBase):
	'''
	????
	'''
	# {lastday:20180702, ok:0}
	rmb = 0
	@classmethod
	def classInit(cls):
		for yID in csv.yunying.yyhuodong:
			if csv.yunying.yyhuodong[yID].type == YYHuoDongDefs.RegainStamina:
				cls.rmb = csv.yunying.yyhuodong[yID].paramMap['rmb']
				break

#
# ObjectYYDirectBuyGift
#
class ObjectYYDirectBuyGift(ObjectYYBase):
	'''
	????
	'''
	#{csvID:count}
	HuoDongMap = {}
	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.directbuygift
		return csv.yunying.directbuygift[csvID]

	@classmethod
	def active(cls, yyObj, game):
		hd = cls.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return

		record = cls.refreshRecord(yyObj, game)

	@classmethod
	def refreshRecord(cls, yyObj, game):
		logger.info("============ DIRECBUYGIFT =================")

		record = cls.getRecord(yyObj.id, game)
		ndi = todayinclock5date2int()
		wday = weekinclock5date2int()
		mday = monthinclock5date2int()
		lastweek = 0
		lastmonth = 0
		if record.get('lastday', 0) != 0:
			dt = datetime.datetime.combine(int2date( record.get('lastday', 0) ), datetime.time(hour=0))
			lastweek = weekinclock5date2int(dt)
			lastmonth = monthinclock5date2int(dt)
		
		logger.info("wday: %s", wday)
		logger.info("lastweek: %s", lastweek)
		logger.info("lastmonth: %s", lastmonth)
		logger.info("ndi: %s", ndi)
		logger.info("record.get('lastday', 0): %s", record.get('lastday', 0))

		if ndi != record.get('lastday', 0):
			if yyObj.countType == YYHuoDongDefs.DailyCount:
				record = cls.setRecord(yyObj.id, game, {'lastday': ndi})
			else:
				hd = cls.HuoDongMap.get(yyObj.huodongID)
				stamps = record.setdefault('stamps', {})
				for csvid in hd.csvIDs:
					cfg = cls.csv(csvid)
					if cfg.refresh:
						stamps.pop(csvid, 0)

					# add by liemia - baohong
					else:
						if cfg.status == 1:
							if (wday != lastweek):
								stamps.pop(csvid, 0)
						if cfg.status ==2:
							if (mday != lastmonth):
								stamps.pop(csvid,0)
					# end add

				record['lastday'] = ndi				
		
		return record

	@classmethod
	def canBuy(cls, yyID, csvID, game):
		cfg = cls.csv(csvID)
		if cfg.huodongID != ObjectYYHuoDongFactory.getConfig(yyID).huodongID:
			raise ClientError('huodongID error')
		if game.role.level < cfg.levelLimit:
			return False
		record = cls.getExistedRecord(yyID, game)
		if record is not None:
			stamps = record.setdefault('stamps', {})
			return stamps.get(csvID, 0) < cfg.limit
		return False

	@classmethod
	def getEffect(cls, yyID, csvID, game):
		record = cls.getRecord(yyID, game)
		stamps = record.setdefault('stamps', {})
		cfg = cls.csv(csvID)

		if cfg.huodongID != ObjectYYHuoDongFactory.getConfig(yyID).huodongID:
			raise ClientError('huodongID error')

		if game.role.level < cfg.levelLimit:
			raise ClientError("level limit")

		if stamps.get(csvID, 0) >= cfg.limit:
			raise ClientError("buy limit")

		# ??????????????
		if (cfg.rechargeID != -1 and cfg.rmbCost != -1) or (cfg.rechargeID == -1 and cfg.rmbCost == -1):
			raise ClientError("cfg rechargeID adn rmbCost error")

		if cfg.rechargeID != -1:
			raise ClientError("please recharge to buy")

		if cfg.rmbCost > 0:
			cost = ObjectCostAux(game, {'rmb': cfg.rmbCost})
			if not cost.isEnough():
				raise ClientError(ErrDefs.dailyBuyRMBNotEnough)
			cost.cost(src='yy_direct_buy_gift')

		def _afterGain():
			stamps[csvID] = stamps.get(csvID, 0) + 1 # ????
		return ObjectYYHuoDongEffect(game, cfg.item, _afterGain)


	@classmethod
	def buyRecharge(cls, game, rechargeID, yyID, csvID):
		record = cls.getRecord(yyID, game)
		stamps = record.setdefault('stamps', {})
		cfg = cls.csv(csvID)
		if cfg.huodongID != csv.yunying.yyhuodong[yyID].huodongID:
			return False, None

		def _afterGain():
			stamps[csvID] = stamps.get(csvID, 0) + 1 # ????
		return True, ObjectYYHuoDongEffect(game, cfg.item, _afterGain)

	@classmethod
	def isRechargeOK(cls, rechargeID, yyID, csvID):
		cfg = cls.csv(csvID)
		if not cfg or cfg.rechargeID != rechargeID:
			return False
		return True


	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = csvIDs

		ObjectYYDirectBuyGift.HuoDongMap[huodongID] = self


#
# ObjectYYLuxuryDirectBuyGift
#


class ObjectYYLuxuryDirectBuyGift(ObjectYYBase):
	'''
	????,????
	'''
	#{csvID:count}
	HuoDongMap = {}

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = csvIDs

		ObjectYYLuxuryDirectBuyGift.HuoDongMap[huodongID] = self

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.luxurydirectbuygift
		return csv.yunying.luxurydirectbuygift[csvID]

	@classmethod
	def active(cls, yyObj, game):
		hd = cls.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return

		cls.refreshRecord(yyObj, game)

	@classmethod
	def refreshRecord(cls, yyObj, game):
		record = cls.getRecord(yyObj.id, game)
		ndi = todayinclock5date2int()
		if not record:
			roleLevel = game.role.level
			vipLevel = game.role.vip_level
			# ?????s+?????
			cardCount = game.pokedex.countRarityCards(yyObj.paramMap['rarity'])

			stamps = record.setdefault('stamps', {})
			# ???????????
			# ????: 1-?????? 2-vip?? 3-s+????
			for csvid in cls.HuoDongMap.get(yyObj.huodongID).csvIDs:
				cfg = cls.csv(csvid)
				flag = False
				if cfg.targetType == 1 and cfg.targetArg[0] <= roleLevel <= cfg.targetArg[1]:
						flag = True
				elif cfg.targetType == 2 and cfg.targetArg[0] <= vipLevel <= cfg.targetArg[1]:
						flag = True
				elif cfg.targetType == 3 and cfg.targetArg[0] <= cardCount <= cfg.targetArg[1]:
						flag = True
				if flag:
					stamps[csvid] = 0

			record['lastday'] = ndi
		return record

	@classmethod
	def canBuy(cls, yyID, csvID, game):
		cfg = cls.csv(csvID)
		if cfg.huodongID != ObjectYYHuoDongFactory.getConfig(yyID).huodongID:
			raise ClientError('huodongID error')
		record = cls.getExistedRecord(yyID, game)
		if record is not None:
			stamps = record.setdefault('stamps', {})
			if csvID in stamps:
				return stamps.get(csvID, 0) < cfg.limit
		return False

	@classmethod
	def getEffect(cls, yyID, csvID, game):
		record = cls.getRecord(yyID, game)
		stamps = record.setdefault('stamps', {})
		cfg = cls.csv(csvID)

		if cfg.huodongID != ObjectYYHuoDongFactory.getConfig(yyID).huodongID:
			raise ClientError('huodongID error')

		if csvID not in stamps:
			raise ClientError('gift error')

		if stamps.get(csvID, 0) >= cfg.limit:
			raise ClientError("buy limit")

		# ??????????????
		if (cfg.rechargeID != -1 and cfg.rmbCost != -1) or (cfg.rechargeID == -1 and cfg.rmbCost == -1):
			raise ClientError("cfg rechargeID adn rmbCost error")

		if cfg.rechargeID != -1:
			raise ClientError("please recharge to buy")

		if cfg.rmbCost > 0:
			cost = ObjectCostAux(game, {'rmb': cfg.rmbCost})
			if not cost.isEnough():
				raise ClientError(ErrDefs.dailyBuyRMBNotEnough)
			cost.cost(src='yy_luxury_direct_buy_gift')

		def _afterGain():
			stamps[csvID] = stamps.get(csvID, 0) + 1  # ????
		return ObjectYYHuoDongEffect(game, cfg.item, _afterGain)

	@classmethod
	def buyRecharge(cls, game, rechargeID, yyID, csvID):
		record = cls.getRecord(yyID, game)
		stamps = record.setdefault('stamps', {})
		cfg = cls.csv(csvID)
		if cfg.huodongID != csv.yunying.yyhuodong[yyID].huodongID:
			return False, None

		if csvID not in stamps:
			return False, None

		if stamps.get(csvID, 0) >= cfg.limit:
			return False, None

		def _afterGain():
			stamps[csvID] = stamps.get(csvID, 0) + 1  # ????
		return True, ObjectYYHuoDongEffect(game, cfg.item, _afterGain)

	@classmethod
	def isRechargeOK(cls, rechargeID, yyID, csvID):
		cfg = cls.csv(csvID)
		hdCfg = csv.yunying.yyhuodong[yyID]
		if not cfg or cfg.huodongID != hdCfg.huodongID or cfg.rechargeID != rechargeID:
			return False
		return True


#
# ObjectYYLimitBuyGift
#

class ObjectYYLimitBuyGift(ObjectYYBase):
	'''
	????(???,????,?????)
	'''
	HuoDongMap = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.limitbuygift
		return csv.yunying.limitbuygift[csvID]

	@classmethod
	def active(cls, yyObj, game, type, val):
		hd = cls.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return
		record = cls.getRecord(yyObj.id, game)
		stamps = record.setdefault('stamps', {})
		valsumsD = record.setdefault('valsums', {})
		valinfoD = record.setdefault('valinfo', {})# ??? valinfo ?????? {csvid: {'time': timestamp}}

		vipsum = game.role.vipSum
		hd = cls.HuoDongMap.get(yyObj.huodongID)
		groups = set([]) # ???????
		for csvID in valinfoD.keys():
			cfg = cls.csv(csvID)
			if cfg.group > 0:
				groups.add(cfg.group)
		for csvID in hd.csvIDs:
			cfg = cls.csv(csvID)
			active = csvID not in valinfoD # need check active
			for i in xrange(1, 99):
				typ = "targetType%d" % i
				if typ not in cfg or not cfg[typ]:
					break
				typ = cfg[typ]
				arg1 = cfg["targetArg%d_1" % i]
				arg2 = cfg["targetArg%d_2" % i]
				if typ == type: # ??
					valsum = valsumsD.get(csvID, 0) + val
					if type == YYHuoDongDefs.GainCardActive:
						if val == arg2:
							valsum = valsumsD.get(csvID, 0) + 1
							valsumsD[csvID] = valsum
					elif type == YYHuoDongDefs.GainCardRarityActive:
						if val >= arg2:
							valsum = valsumsD.get(csvID, 0) + 1
							valsumsD[csvID] = valsum
					elif val != 0:
						valsumsD[csvID] = valsum

				if active:
					_, pred = cls.predGen(typ, arg1)
					active = pred(game, valsumsD.get(csvID, 0))
			if active:
				if cfg.group > 0 and cfg.group in groups: # ????
					continue
				if cfg.sumRechargeRMB:
					if vipsum < cfg.sumRechargeRMB[0] or vipsum > cfg.sumRechargeRMB[1]: # ???????
						continue
				if cfg.group > 0:
					groups.add(cfg.group)
				valinfoD[csvID] = {'time': int(nowtime_t())} # ??

	@staticmethod
	def predGen(t, p):
		# ??????
		if t == YYHuoDongDefs.RoleLevelActive:
			return (t, lambda g, _: g.role.level >= p)
		# ????????
		elif t == YYHuoDongDefs.PassGateActive:
			return (t, lambda g, _: g.role.getGateStar(p) > 0)
		# ????
		elif t == YYHuoDongDefs.RoleCreatedTimeActive:
			return (t, lambda g, _: todayinclock5elapsedays(datetimefromtimestamp(g.role.created_time)) >= p)
		# vip????
		elif t == YYHuoDongDefs.RoleVipLevelActive:
			return (t, lambda g, _: g.role.vip_level >= p)
		# ?????,????
		elif t == YYHuoDongDefs.ImmediateActive:
			return (t, lambda g, _: True)

		# ???????????
		return (t, lambda _, v: v >= p)

	@classmethod
	def canBuy(cls, yyID, csvID, game, ignoreDuration=False):
		record = cls.getExistedRecord(yyID, game)
		if record is None or 'valinfo' not in record:
			return False
		cfg = cls.csv(csvID)
		active = record['valinfo'].get(csvID, None)
		if not active: # ???
			return False
		if not ignoreDuration:
			if nowtime_t() - active['time'] > cfg.duration * 60: # ???
				return False
		stamps = record.setdefault('stamps', {})
		return csvID not in stamps

	@classmethod
	def getEffect(cls, yyID, csvID, game):
		if not cls.canBuy(yyID, csvID, game):
			raise ClientError('can not buy')

		record = cls.getExistedRecord(yyID, game)
		cfg = cls.csv(csvID)
		if cfg.rechargeID: # ????????
			raise ClientError('recharge error')
		if cfg.rmbCost > game.role.rmb:
			raise ClientError(ErrDefs.dailyBuyRMBNotEnough)

		cost = ObjectCostAux(game, {'rmb': cfg.rmbCost})
		cost.cost(src='yy_limit_buy_gift')

		def _afterGain():
			record['stamps'][csvID] = 0 # ???
		return ObjectYYHuoDongEffect(game, cfg.item, _afterGain)

	@classmethod
	def buyRecharge(cls, game, rechargeID, yyID, csvID):
		if not cls.canBuy(yyID, csvID, game, ignoreDuration=True): # ??????????
			return False, None

		record = cls.getRecord(yyID, game)
		stamps = record.setdefault('stamps', {})
		cfg = cls.csv(csvID)

		def _afterGain():
			record['stamps'][csvID] = 0 # ???
		return True, ObjectYYHuoDongEffect(game, cfg.item, _afterGain)

	@classmethod
	def isRechargeOK(cls, rechargeID, yyID, csvID):
		cfg = cls.csv(csvID)
		if not cfg or cfg.rechargeID != rechargeID:
			return False
		return True

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = csvIDs

		ObjectYYLimitBuyGift.HuoDongMap[huodongID] = self


#
# ObjectYYCustomizeGift
#

class ObjectYYCustomizeGift(ObjectYYBase):
	HuoDongMap = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.customize_gift
		return csv.yunying.customize_gift[csvID]

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = csvIDs
		ObjectYYCustomizeGift.HuoDongMap[huodongID] = self

	@classmethod
	def buyRecharge(cls, game, rechargeID, yyID, csvID):
		cfg = cls.csv(csvID)
		record = cls.getRecord(yyID, game)
		record.setdefault("stamps", {}).setdefault(csvID, 0)
		choose = record.get('choose', {}).get(csvID, [])
		if not cls.canBuy(yyID, csvID, game, choose):
			return False, None

		awards = cfg['awards']
		def _afterGain():
			record['stamps'][csvID] += 1  # ????
		if awards:
			eff = ObjectYYHuoDongEffect(game, awards, _afterGain)
		else:
			eff = ObjectYYHuoDongEffect(game, {}, _afterGain)

		for i in xrange(1, 99):
			opt = "optionalAwards%d" % i
			if opt not in cfg:
				break
			optionalAwards = cfg[opt]
			if not optionalAwards:
				break
			optAwards = optionalAwards[choose[i-1]-1]
			eff += ObjectGainAux(game, optAwards)

		return True, eff

	@classmethod
	def saveChoose(cls, yyID, csvID, game, choose):
		record = cls.getRecord(yyID, game)
		if not choose:  # ?????
			raise ClientError('NoChoose')

		record.setdefault('choose', {})# ???????
		if cls.canBuy(yyID, csvID, game, choose, False):
			record['choose'][csvID] = choose

	# ???????????
	@classmethod
	def canBuy(cls, yyID, csvID, game, choose=None, flag=True):
		cfg = cls.csv(csvID)
		record = cls.getRecord(yyID, game)
		yyObj = cls.HuoDongMap.get(cfg.huodongID, None)
		yyCfg = csv.yunying.yyhuodong[yyID]
		if not yyObj or cfg.huodongID != yyCfg.huodongID:
			raise ClientError("huodongID err")

		buyTimes = record.get("stamps", {}).get(csvID, 0)
		if buyTimes >= cls.csv(csvID).buyTimes:
			return False

		if not choose:# ????????
			choose = record.get('choose', {}).get(csvID, [])

		length = len(choose)
		optCount = 0
		for i in xrange(1, 99):
			optAwards = "optionalAwards%d" % i
			if optAwards not in cfg:
				break
			optionalAwards = cfg[optAwards]
			if not optionalAwards:
				break
			optCount += 1
			if i > length:
				raise ClientError('param err')
			if choose[i-1] > len(optionalAwards) or choose[i-1] < 0:# ??????
				raise ClientError('Choose Err')
			if flag:# ?????
				if not choose[i-1]:
					raise ClientError('Choose Not Enough')

		if optCount < length:
			raise ClientError('param err')

		return True

	@classmethod
	def isRechargeOK(cls, rechargeID, yyID, csvID):
		cfg = cls.csv(csvID)
		hdCfg = csv.yunying.yyhuodong[yyID]
		if not cfg or cfg.huodongID != hdCfg.huodongID or cfg.rechargeID != rechargeID:
			return False

		return True

#
# ObjectYYPassport
#

class ObjectYYPassport(ObjectYYBase):
	"""
	???
	"""
	# ??
	TaskMap = {}  # {huodongID: {weekNum: [csvID]}}
	TargetMap = {}  # {target: [cfg]}

	LevelAwardMap = {}  # {huodongID: {award: {level: csvID}, levelMax: xx, levelSumExp: {level: sumExp}} ...}


	@classmethod
	def awardCsv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.passport_award
		return csv.yunying.passport_award[csvID]

	@classmethod
	def classInit(cls):
		# ?????
		cls.TaskMap = {}
		for i in csv.yunying.passport_task:
			cfg = csv.yunying.passport_task[i]
			if cfg.huodongID == 0:
				continue
			huodongTaskMap = cls.TaskMap.setdefault(cfg.huodongID, {})
			if cfg['periodType'] == PasspostDefs.TaskDaily:
				huodongTaskMap.setdefault(999, []).append(i)
			elif cfg['periodType'] == PasspostDefs.TaskWeek:
				huodongTaskMap.setdefault(cfg['weekParam'], []).append(i)

		# ?????
		cls.LevelAwardMap = {}
		huodongIDMap = {}
		cfgs = cls.awardCsv()
		for csvID in cfgs:
			cfg = cfgs[csvID]
			if cfg.huodongID == 0:
				continue
			huodongIDMap.setdefault(cfg.huodongID, []).append(csvID)

		for huodongID, l in huodongIDMap.iteritems():
			cls.LevelAwardMap[huodongID] = {}
			# ?? award ? levelMax
			award = cls.LevelAwardMap[huodongID].setdefault('award', {})
			levelMax = 0
			for idx in l:
				cfg = cls.awardCsv(idx)
				award[cfg.level] = idx
				if cfg.level > levelMax:
					levelMax = cfg.level
			# ?? levelSumExp
			levelSumExp = {}
			levelSumExp[0] = 0
			for level in range(1, levelMax + 1):
				levelSumExp[level] = levelSumExp[level - 1] + cls.awardCsv(award[level]).needExp

			cls.LevelAwardMap[huodongID]['levelMax'] = levelMax
			cls.LevelAwardMap[huodongID]['levelSumExp'] = levelSumExp

		cls.TargetMap = {}

	@classmethod
	def active(cls, yyObj, game, type, value):
		weekNum = cls.getWeekNum(yyObj)
		record, refreshFlag = cls.refreshRecord(yyObj, game, weekNum)

		if refreshFlag or not cls.TargetMap:
			# ???????????
			cls.TargetMap = {}
			cfgYY = csv.yunying.yyhuodong[yyObj.id]
			huodongID = cfgYY.paramMap['taskHuodongID']
			huodongTaskMap = cls.TaskMap.get(huodongID, {})
			for k, csvIDs in huodongTaskMap.iteritems():
				# ????????
				if k == 999 or k == weekNum:
					for csvID in csvIDs:
						cfg = csv.yunying.passport_task[csvID]
						cls.TargetMap.setdefault(cfg['taskType'], []).append(cfg)

		tasks = record.setdefault('task', {})
		info = record.setdefault('info', {})

		isMaster = cls.checkMaster(record)

		for cfg in cls.TargetMap.get(type, []):
			valsum, flag = tasks.get(cfg.id, (0, PasspostDefs.TaskNoneFlag))
			if flag == PasspostDefs.TaskCloseFlag:
				continue
			valsum, ok = targetActive(type, cfg.id, value, valsum, info, sp=lambda :cfg.taskSpecialParam)
			if not ok:
				continue
			_, pred = predGen(type, cfg['taskParam'], cfg['taskSpecialParam'])
			if pred(game, valsum):
				# ????? ????,??????????,????? ??? ?????
				if cfg.taskAttribute == PasspostDefs.MasterTask and not isMaster:
					flag = PasspostDefs.TaskAchieveFlag
				else:
					flag = PasspostDefs.TaskOpenFlag
			tasks[cfg.id] = (valsum, flag)

	# ??????
	@classmethod
	def getEffect(cls, yyID, csvID, game):
		record = cls.getExistedRecord(yyID, game)

		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		# ?????? csvID
		cfg = cls.awardCsv(csvID)
		normal = record.setdefault('normal_award', {})
		elite = record.setdefault('elite_award', {})

		awards = ObjectGainAux(game, {})
		# ????
		if normal.get(csvID, -1) == 1:
			awards += ObjectGainAux(game, cfg.normalAward)
			normal[csvID] = 0
		if elite.get(csvID, -1) == 1:
			awards += ObjectGainAux(game, cfg.eliteAward)
			elite[csvID] = 0
		return awards

	# ????????
	@classmethod
	def getOneKeyEffect(cls, yyID, game):
		record = cls.getExistedRecord(yyID, game)

		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		normal = record.setdefault('normal_award', {})
		elite = record.setdefault('elite_award', {})

		retAward = []
		# ?????????
		for csvID, v in normal.iteritems():
			if v == 1:
				retAward.append(cls.awardCsv(csvID).normalAward)
			# ????
			if elite.get(csvID, -1) == 1:
				retAward.append(cls.awardCsv(csvID).eliteAward)

		# ?? ????0
		def _afterGain():
			for csvID, v in normal.iteritems():
				if v == 1:
					normal[csvID] = 0
				if elite.get(csvID, -1) == 1:
					elite[csvID] = 0

		eff = ObjectYYHuoDongEffect(game, {}, _afterGain())
		for award in retAward:
			eff += ObjectGainAux(game, award)
		return eff

	# ???????
	@classmethod
	def getTaskAward(cls, yyID, csvID, game):
		record = cls.getExistedRecord(yyID, game)

		tasks = record.setdefault('task', {})
		count, flag = tasks.get(csvID, (0, 0))
		# ??????
		if flag != 1:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		cfgTask = csv.yunying.passport_task[csvID]
		# ?????
		recordExp = record.setdefault('exp', 0)
		recordExp += cfgTask.exp

		oldLevel = newLevel = record.get('level', 1)

		awardHuodongID = csv.yunying.yyhuodong[yyID].huodongID
		levelMax = cls.LevelAwardMap[awardHuodongID]['levelMax']
		levelSumExp = cls.LevelAwardMap[awardHuodongID]['levelSumExp']

		# ???????(??????)
		copyExp = copy.copy(recordExp)
		copyExp = min(copyExp, levelSumExp[levelMax - 1])
		while newLevel < levelMax and levelSumExp[newLevel] <= copyExp:
			newLevel += 1

		# ???????????
		tasks[csvID] = (count, PasspostDefs.TaskCloseFlag)
		record['exp'] = recordExp
		record['level'] = newLevel

		cls.levelAwardOpen(awardHuodongID, record['normal_award'], record['elite_award'], record['buy'], oldLevel, newLevel)

	@classmethod
	def canBuy(cls, yyID, csvID, game):
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			return False
		cfg = csv.yunying.passport_recharge[csvID]
		if cfg.type == PasspostDefs.BuyCardType:
			buy = record.setdefault('buy', {})
			# ??????
			if buy.get('type1', -1) == 1 or buy.get('type2', -1) == 1:
				return False
		elif cfg.type == PasspostDefs.BuyExpType:
			buy = record.setdefault('buy', {})
			# ????????????????
			if buy.get('type1', -1) == -1 and buy.get('type2', -1) == -1:
				return False
		else:
			return False
		return True

	# ??
	@classmethod
	def buyRecharge(cls, game, rechargeID, yyID, csvID):
		record = cls.getExistedRecord(yyID, game)

		errLogBase = 'passport yyID {0} uId {1} roleId {2} csvID {3} '.format(yyID, game.role.uid, game.role.pid, csvID)

		if record is None:
			logger.warning(errLogBase + 'not active')
			return False, None

		cfg = csv.yunying.passport_recharge[csvID]
		huodongID = csv.yunying.yyhuodong[yyID].huodongID

		# 1 ????
		# 2 ??????
		if cfg.type == PasspostDefs.BuyCardType:
			return cls.buyPassportCard(record, huodongID, cfg, errLogBase)
		elif cfg.type == PasspostDefs.BuyExpType:
			return cls.buyPassportExp(record, huodongID, cfg, errLogBase)
		else:
			logger.warning(errLogBase + 'config type %d error' % cfg.type)
			return False, None

	# ?????
	@classmethod
	def buyPassportCard(cls, record, huodongID, cfg, errLogBase):
		buy = record.setdefault('buy', {})

		# ???????????
		# type1 ?????
		# type2 ?????
		if cfg.level == 0:
			choose = PasspostDefs.CommonCardType
		else:
			choose = PasspostDefs.SpecialCardType

		buyType = 'type%d' % choose
		# ??????
		if buy.get('type1', -1) == 1 or buy.get('type2', -1) == 1:
			logger.warning(errLogBase + 'buy multiple times')
			return False, None
		# ?????
		buy[buyType] = 1

		record.setdefault('level', 1)
		record.setdefault('exp', 0)

		# ????????????????
		if choose == PasspostDefs.SpecialCardType:
			oldLevel = record['level']
			record['level'] += cfg.level

			levelMax = cls.LevelAwardMap[huodongID]['levelMax']
			levelSumExp = cls.LevelAwardMap[huodongID]['levelSumExp']

			if record['level'] >= levelMax:
				record['level'] = levelMax
				record['exp'] = levelSumExp[record['level'] - 1]
			else:
				record['exp'] += levelSumExp[record['level'] - 1] - levelSumExp[oldLevel - 1]

		# ????, ?????? 0,???????????????????????
		cls.levelAwardOpen(huodongID, record['normal_award'], record['elite_award'], buy, 0, record['level'])
		# ????????
		cls.refreshMasterTaskStatus(record)
		return True, None

	# ????
	@classmethod
	def buyPassportExp(cls, record, huodongID, cfg, errLogBase):
		buy = record.setdefault('buy', {})

		# ????????????????
		if buy.get('type1', -1) == -1 and buy.get('type2', -1) == -1:
			logger.warning(errLogBase + 'can not buy passport exp')
			return False, None

		levelMax = cls.LevelAwardMap[huodongID]['levelMax']
		levelSumExp = cls.LevelAwardMap[huodongID]['levelSumExp']

		recordExp = record.setdefault('exp', 0)
		oldLevel = newLevel = record.get('level', 1)

		# ?????????
		if oldLevel == levelMax:
			logger.warning(errLogBase + 'level has max')
			return False, None

		recordExp += cfg.exp

		# ???????(??????)
		copyExp = copy.copy(recordExp)
		copyExp = min(copyExp, levelSumExp[levelMax - 1])
		while newLevel < levelMax and levelSumExp[newLevel] <= copyExp:
			newLevel += 1

		record['exp'] = recordExp
		record['level'] = newLevel

		cls.levelAwardOpen(huodongID, record['normal_award'], record['elite_award'], record['buy'], oldLevel, newLevel)
		return True, None

	# ??????
	@classmethod
	def levelAwardOpen(cls, huodongID, normal, elite, buy, oldLevel, newLevel):
		# ?? ??????????
		if buy.get('type1', -1) == 1 or buy.get('type2', -1) == 1:
			canElite = True
		else:
			canElite = False

		# -1 - ???
		# 0 - ???
		# 1 - ???
		for level in xrange(oldLevel + 1, newLevel + 1):
			# ???? ?? ????
			awardCsvID = cls.LevelAwardMap[huodongID]['award'][level]
			cfg = cls.awardCsv(awardCsvID)

			normal.setdefault(awardCsvID, -1)
			elite.setdefault(awardCsvID, -1)
			# ?????? (??? 1)
			if normal[awardCsvID] != 0 and cfg.normalAward:
				normal[awardCsvID] = 1
			# ?????? (??? 1)
			if canElite and elite[awardCsvID] != 0 and cfg.eliteAward:
				elite[awardCsvID] = 1

	# ?????????
	@classmethod
	def getExistedRecord(cls, yyID, game):
		if game.role.passport.get('yy_id', -1) != yyID:
			return None
		return game.role.passport

	# ??????
	@classmethod
	def getRecord(cls, yyID, game):
		# ?????? yyID ????????????
		# ???????????? game.role.passport
		if game.role.passport.get('yy_id', -1) != yyID:
			game.role.passport = {'yy_id': yyID, 'level': 1, 'exp': 0}

			awardHuodongID = csv.yunying.yyhuodong[yyID].huodongID

			normal = game.role.passport.setdefault('normal_award', {})  # ????
			elite = game.role.passport.setdefault('elite_award', {})  # ????
			buy = game.role.passport.setdefault('buy', {})  # ???????

			cls.levelAwardOpen(awardHuodongID, normal, elite, buy, 0, game.role.passport['level'])

		return game.role.passport

	# ???????????
	@classmethod
	def checkMaster(cls, record):
		buy = record.setdefault('buy', {})
		return buy.get('type1', -1) == 1 or buy.get('type2', -1) == 1

	# ??????????
	@classmethod
	def refreshMasterTaskStatus(cls, record):
		tasks = record.get('task', {})
		for taskID, value in tasks.iteritems():
			cfg = csv.yunying.passport_task[taskID]
			if cfg.taskAttribute != PasspostDefs.MasterTask:
				continue

			count, flag = value
			if flag == PasspostDefs.TaskAchieveFlag:
				tasks[taskID] = (count, PasspostDefs.TaskOpenFlag)

	# ????
	@classmethod
	def refreshRecord(cls, yyObj, game, weekNum):
		record = cls.getRecord(yyObj.id, game)
		tasks = record.setdefault('task', {})
		record.setdefault('shop', {})
		if record.get('info', None) is None:
			record['info'] = {}
		refreshFlag = False
		if record.get('last_week', None) != weekinclock5date2int():
			record['last_week'] = weekinclock5date2int()
			record['week_num'] = weekNum
			record['last_day'] = todayinclock5date2int()
			# ???????
			record['task'] = {}
			record['info'] = {}
			refreshFlag = True
		elif record.get('last_day', None) != todayinclock5date2int():
			record['last_day'] = todayinclock5date2int()
			# ??????
			copyTasks = copy.deepcopy(tasks)
			for csvID, _ in copyTasks.iteritems():
				cfg = csv.yunying.passport_task[csvID]
				if cfg['periodType'] == PasspostDefs.TaskDaily:
					tasks.pop(csvID)
			refreshFlag = True
		return record, refreshFlag

	# ????????
	@classmethod
	def getWeekNum(cls, yyObj):
		nw = int2date(weekinclock5date2int())

		startTime = yyObj.beginDateTime
		startWeek = int2date(weekinclock5date2int(startTime))
		# a? b??
		a, b = divmod((nw - startWeek).days, 7)
		return a + 1

	@classmethod
	def getRegainMailEffect(cls, yyObj, game):
		if game.role.passport.get('yy_id', -1) != yyObj.id:
			return None

		normal = game.role.passport.setdefault('normal_award', {})  # ????
		elite = game.role.passport.setdefault('elite_award', {})  # ????

		normalIds = filter(lambda x:normal[x] == 1, normal)
		eliteIds = filter(lambda x:elite[x] == 1, elite)
		if not normalIds and not eliteIds:
			return None

		def _afterGain():
			for csvID in normalIds:
				normal[csvID] = 0
			for csvID in eliteIds:
				elite[csvID] = 0

		eff = ObjectGainAux(game, {})
		for csvID in normalIds:
			eff += ObjectGainAux(game, cls.awardCsv(csvID).normalAward)
		for csvID in eliteIds:
			eff += ObjectGainAux(game, cls.awardCsv(csvID).eliteAward)

		from game.mailqueue import ObjectMailEffect as ObjectYYHuoDongMailEffect
		subject = csv.mail[YYHuodongMailID].subject % (yyObj.desc,)
		mail = game.role.makeMyMailModel(YYHuodongMailID, subject=subject, attachs=eff.result)
		return ObjectYYHuoDongMailEffect(mail, _afterGain)

	@classmethod
	def isRechargeOK(cls, rechargeID, yyID, csvID):
		cfg = csv.yunying.passport_recharge[csvID]
		if not cfg or cfg.rechargeID != rechargeID:
			return False
		return True


#
# ObjectYYPlayPassport
#

class ObjectYYPlayPassport(ObjectYYBase):
	"""
	?????
	"""
	LevelAwardMap = {}  # {huodongID: {award: {level: csvID}, levelMax: xx, levelSumExp: {level: sumExp}} ...}

	@classmethod
	def awardCsv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.playpassport_award
		return csv.yunying.playpassport_award[csvID]

	@classmethod
	def classInit(cls):
		# ?????
		cls.LevelAwardMap = {}
		huodongIDMap = {}
		cfgs = cls.awardCsv()
		for csvID in cfgs:
			cfg = cfgs[csvID]
			if cfg.huodongID == 0:
				continue
			huodongIDMap.setdefault(cfg.huodongID, []).append(csvID)

		for huodongID, l in huodongIDMap.iteritems():
			cls.LevelAwardMap[huodongID] = {}
			# ?? award ? levelMax
			award = cls.LevelAwardMap[huodongID].setdefault('award', {})
			levelMax = 0
			for csvID in l:
				cfg = cls.awardCsv(csvID)
				award[cfg.level] = csvID
				if cfg.level > levelMax:
					levelMax = cfg.level
			# ?? levelSumExp
			levelSumExp = {0: 0}
			for level in range(1, levelMax + 1):
				levelSumExp[level] = levelSumExp[level - 1] + cls.awardCsv(award[level]).needExp

			cls.LevelAwardMap[huodongID]['levelMax'] = levelMax
			cls.LevelAwardMap[huodongID]['levelSumExp'] = levelSumExp

	@classmethod
	def isLoginPassPort(cls, yyObj):
		return yyObj.paramMap['type'] == PlayPassportDefs.Login  # ????

	@classmethod
	def refreshRecord(cls, yyObj, game):
		ndi = todayinclock5date2int()
		record = cls.getRecord(yyObj.id, game)
		if not record:
			record.update({
				'info': {
					'level': 0,  # ??
					'exp': 0,  # ???
					'buy_times': 0,  # ??????, ????
					'buy_level': 0,  # ?????????, ???
					'elite_buy': 0,  # 0 ???, 1 ???
					'last_time': 0,  # ??????????
				},
				'stamps': {},  # ???? 0-??? 1-???
				'stamps1': {},  # ???? 0-??? 1-???
			})
			if not cls.isLoginPassPort(yyObj):
				cls.onTaskChange(game, yyObj, yyObj.paramMap['type'], 0)
		else:
			record.setdefault('stamps', {})  # ????
			record.setdefault('stamps1', {})  # ????
			if ndi != record['info'].get('last_time', None):
				record['info']['buy_times'] = 0
		if ndi != record.get('lastday', None):
			record['lastday'] = ndi
		return record

	@classmethod
	def active(cls, yyObj, game, playtype=0, val=0,  **kwargs):
		cls.refreshRecord(yyObj, game)
		cls.onTaskChange(game, yyObj, playtype, val, **kwargs)

	@classmethod
	def get_play_type(cls, yyObj):
		yyObj.paramMap.get('type')

	# ??????
	@classmethod
	def getEffect(cls, yyID, csvID, game):
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		# ?????? csvID
		cfg = cls.awardCsv(csvID)
		normal = record.setdefault('stamps', {})  # ????
		elite = record.setdefault('stamps1', {})  # ????
		elite_buy = record['info']['elite_buy']

		awards = ObjectGainAux(game, {})
		# ????
		if normal.get(csvID, -1) == 1:
			awards += ObjectGainAux(game, cfg.normalAward)
			normal[csvID] = 0
		if elite_buy and elite.get(csvID, -1) == 1:
			awards += ObjectGainAux(game, cfg.eliteAward)
			elite[csvID] = 0
		return awards

	# ??????
	@classmethod
	def getOneKeyEffect(cls, yyID, game):
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		# ?????? csvID
		normal = record.setdefault('stamps', {})  # ????
		elite = record.setdefault('stamps1', {})  # ????

		retAward = []
		# ?????????
		for csvID, v in normal.iteritems():
			if v == 1:
				retAward.append(cls.awardCsv(csvID).normalAward)
			# ????
			if elite.get(csvID, -1) == 1:
				retAward.append(cls.awardCsv(csvID).eliteAward)

		# ?? ????0
		def _afterGain():
			for csvID, v in normal.iteritems():
				if v == 1:
					normal[csvID] = 0
				if elite.get(csvID, -1) == 1:
					elite[csvID] = 0

		eff = ObjectYYHuoDongEffect(game, {}, _afterGain())
		for award in retAward:
			eff += ObjectGainAux(game, award)
		return eff

	@classmethod
	def canBuy(cls, yyID, csvID, game):
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			return False
		if csvID:
			# ?????
			cfg = csv.yunying.playpassport_recharge[csvID]
			if cfg.huodongID != ObjectYYHuoDongFactory.getConfig(yyID).huodongID:
				raise ClientError('huodongID error')
			if record['info']['elite_buy']:
				# ????
				return False
		else:
			# ???????
			yyObj = ObjectYYHuoDongFactory.getConfig(yyID)
			info = record['info']
			# ??????
			if info['buy_times'] >= yyObj.paramMap['dailyBuyTimes']:
				return False
			# ??????
			huodongID = csv.yunying.yyhuodong[yyID].huodongID
			levelAward = cls.LevelAwardMap[huodongID]
			if info['level'] >= yyObj.paramMap.get('levelLimit', levelAward['levelMax']):
				return False
		return True

	# ?????
	@classmethod
	def buyRecharge(cls, game, rechargeID, yyID, csvID):
		record = cls.getExistedRecord(yyID, game)
		if record['info']['elite_buy']:
			# ????
			return False, None
		errLogBase = 'passport yyID {0} uId {1} roleId {2} csvID {3} '.format(yyID, game.role.uid, game.role.pid, csvID)
		if record is None:
			logger.warning(errLogBase + 'not active')
			return False, None

		normal = record.setdefault('stamps', {})  # ????
		elite = record.setdefault('stamps1', {})  # ????

		# ?????
		record['info']['elite_buy'] = 1
		# ????????
		for csvID in normal:
			elite[csvID] = 1
		return True, None

	@classmethod
	def isRechargeOK(cls, rechargeID, yyID, csvID):
		cfg = csv.yunying.playpassport_recharge[csvID]
		hdCfg = csv.yunying.yyhuodong[yyID]
		if not cfg or cfg.huodongID != hdCfg.huodongID or cfg.rechargeID != rechargeID:
			return False
		return True

	# ????/??
	@classmethod
	def buyPlayPassportLevel(cls, game, yyID, level):
		yyObj = ObjectYYHuoDongFactory.getConfig(yyID)

		record = cls.getExistedRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		info = record['info']
		# ??????
		if info['buy_times'] + level > yyObj.paramMap['dailyBuyTimes']:
			raise ClientError('Times limit')

		huodongID = csv.yunying.yyhuodong[yyID].huodongID
		levelAward = cls.LevelAwardMap[huodongID]

		if info['level'] + level > yyObj.paramMap.get('levelLimit', levelAward['levelMax']):
			# ?????????
			raise ClientError('Level exceeds upper limit')

		rmb = cls.getCost(yyObj.paramMap['type'], info, level)
		cost = ObjectCostAux(game, {'rmb': rmb})
		if not cost.isEnough():
			raise ClientError(ErrDefs.buyRMBNotEnough)
		cost.cost(src='buy_play_passport_level')

		# ???????
		info['buy_times'] += level
		info['buy_level'] += level
		levelSumExp = levelAward['levelSumExp']
		oldLevel = info['level']
		newLevel = info['level'] + level
		info['last_time'] = todayinclock5date2int()
		info['exp'] += levelSumExp[newLevel - 1] - levelSumExp[oldLevel - 1]
		info['level'] = newLevel

		# ????
		cls.levelAwardOpen(huodongID, record, oldLevel, newLevel)

	@classmethod
	def getCost(cls, playPassportType, info, level):
		if playPassportType == PlayPassportDefs.DailyTask:
			rmb = sum(
				[ObjectCostCSV.getPlayPassportBuyCost2(info['buy_level'] + num) for num in xrange(level)])
		elif playPassportType == PlayPassportDefs.RandomTower:
			rmb = sum(
				[ObjectCostCSV.getPlayPassportBuyCost3(info['buy_level'] + num) for num in xrange(level)])
		elif playPassportType == PlayPassportDefs.Gym:
			rmb = sum(
				[ObjectCostCSV.getPlayPassportBuyCost4(info['buy_level'] + num) for num in xrange(level)])
		else:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		return rmb

	# ??????
	@classmethod
	def onTaskChange(cls, game, yyObj, playtype, val, **kwargs):
		if yyObj.paramMap['type'] != playtype:
			# ???????
			return

		record = cls.getExistedRecord(yyObj.id, game)
		if record is None:
			return
		info = record['info']
		huodongID = csv.yunying.yyhuodong[yyObj.id].huodongID
		levelAward = cls.LevelAwardMap[huodongID]

		# ????
		if cls.isLoginPassPort(yyObj):
			if todayinclock5date2int() == record['lastday']:
				return  # ????????

		if info['level'] >= yyObj.paramMap.get('levelLimit', levelAward['levelMax']):
			return  # ???????
		
		cfgCardId = yyObj.paramMap.get('cardId', None)
		cardId = kwargs.get('cardId')
		# ????
		oldLevel = info['level']
		if cfgCardId and cardId:
			info['level'] = min(info['level'] + val, levelAward['levelMax'])
		else:
			# ???
			info['exp'] += val
			
			if cls.isLoginPassPort(yyObj):
				for level in xrange(oldLevel, levelAward['levelMax']):
					if info['exp'] <= levelAward['levelSumExp'][level]:
						break
					info['level'] = level + 1
			else:
				for level in xrange(oldLevel, levelAward['levelMax']):
					if info['exp'] < levelAward['levelSumExp'][level]:
						break
					info['level'] = level + 1

		# ????,???????
		if info['level'] - oldLevel > 0:
			cls.levelAwardOpen(huodongID, record, oldLevel, info['level'])

	# ??????
	@classmethod
	def levelAwardOpen(cls, huodongID, record, oldLevel, newLevel):
		levelAward = cls.LevelAwardMap[huodongID]

		normal = record.setdefault('stamps', {})  # ????
		elite = record.setdefault('stamps1', {})  # ????
		elite_buy = record['info']['elite_buy']

		# 0 - ???
		# 1 - ???
		for level in xrange(oldLevel + 1, newLevel + 1):
			# ???? ?? ????
			awardCsvID = levelAward['award'][level]
			cfg = cls.awardCsv(awardCsvID)
			# ?????? (??? 1)
			if awardCsvID not in normal and cfg.normalAward:
				normal[awardCsvID] = 1
			# ?????? (??? 1)
			if elite_buy and awardCsvID not in elite and cfg.eliteAward:
				elite[awardCsvID] = 1

	# ????
	@classmethod
	def getRegainMailEffect(cls, yyObj, game):
		record = cls.getExistedRecord(yyObj.id, game)
		if record is None:
			return None

		normal = record.setdefault('stamps', {})  # ????
		elite = record.setdefault('stamps1', {})  # ????

		normalIds = filter(lambda x: normal[x] == 1, normal)
		eliteIds = filter(lambda x: elite[x] == 1, elite)
		if not normalIds and not eliteIds:
			return None

		def _afterGain():
			for csvID in normalIds:
				normal[csvID] = 0
			for csvID in eliteIds:
				elite[csvID] = 0

		eff = ObjectGainAux(game, {})
		for csvID in normalIds:
			eff += ObjectGainAux(game, cls.awardCsv(csvID).normalAward)
		for csvID in eliteIds:
			eff += ObjectGainAux(game, cls.awardCsv(csvID).eliteAward)

		from game.mailqueue import ObjectMailEffect as ObjectYYHuoDongMailEffect
		subject = csv.mail[YYHuodongMailID].subject % (yyObj.desc,)
		mail = game.role.makeMyMailModel(YYHuodongMailID, subject=subject, attachs=eff.result)
		return ObjectYYHuoDongMailEffect(mail, _afterGain)


#
# ObjectYYRechargeWheel
#

class ObjectYYRechargeWheel(ObjectYYBase):
	"""
	?????
	"""

	BroadcastMessage = []

	@classmethod
	def active(cls, yyObj, game, rmb=0):
		record = cls.getRecord(yyObj.id, game)
		info = record.setdefault('info', {})

		init = {}
		init['info'] = {
			'free_counter': 0,
			'today_score': 0,
			'total_score': info.get('total_score', 0),
			'draw_counter': info.get('draw_counter', 0),
			'surplus_rmb': 0  # ???????
		}

		record = cls.refreshRecord(yyObj, game, init)
		info = record.setdefault('info', {})

		recharge = yyObj.paramMap['recharge']
		addScore = yyObj.paramMap['addScore']
		dailyScoreMax = yyObj.paramMap['dailyScoreMax']

		surplusRmb = info.get('surplus_rmb', 0)
		addNum, info['surplus_rmb'] = divmod(rmb + surplusRmb, recharge)

		oldTodayScore = info.get('today_score', 0)
		info['today_score'] = min(oldTodayScore + addNum * addScore, dailyScoreMax)
		info['total_score'] += info['today_score'] - oldTodayScore

	@classmethod
	def getEffect(cls, yyID, drawType, game):
		cfg = csv.yunying.yyhuodong[yyID]
		costScore = cfg.paramMap['costScore']
		freeMax = cfg.paramMap['free']

		record = cls.getRecord(yyID, game)
		info = record.setdefault('info', {})
		freeTimes = info.setdefault('free_counter', 0)
		totalScore = info.setdefault('total_score', 0)
		drawCounter = info.setdefault('draw_counter', 0)
		logger.info("ObjectYYRechargeWheel")
		logger.info(yyID)
		logger.info(drawType)
		
		# free ????
		# once ????
		# all ????????????
		if drawType == 'free':
			if freeTimes >= freeMax:
				raise ClientError(ErrDefs.freeDrawTimerNoCD)
			drawCount = 1
		elif drawType == 'once':
			if int(totalScore / costScore) < 1:
				raise ClientError(ErrDefs.rechargeWheelScoreNotEnough)
			drawCount = 1
		elif drawType == 'all':
			# ??
			freeCount = max(freeMax - freeTimes, 0)
			scoreCount = int(totalScore / costScore)
			drawCount = freeCount + scoreCount
			if drawCount < 0:
				raise ClientError(ErrDefs.rechargeWheelScoreNotEnough)
		else:
			raise ClientError('drawType error')

		def _afterGain():
			if drawType == 'free':
				info['free_counter'] += 1
			elif drawType == 'once':
				info['total_score'] -= costScore
			elif drawType == 'all':
				info['free_counter'] = freeMax
				info['total_score'] -= int(totalScore / costScore) * costScore

			info['draw_counter'] = drawCounter

			cls.BroadcastMessage.extend(msgs)
			cls.BroadcastMessage = cls.BroadcastMessage[-YYHuoDongRechargeWheelMessageMax:]

		msgs = []
		grids = []
		eff = ObjectGainAux(game, {})
		for _ in xrange(drawCount):
			drawCounter += 1

			#  choi  l?y by liemiar ch?y
			reDefyyID = yyID
			if cfg.type == 38:
				reDefyyID =1487
			
			award = ObjectDrawEquipRandom.getRandomItems(game, DrawEquipDefs.YYDrawRandomKey(DrawEquipDefs.RechargeWheel, reDefyyID), drawCounter, None)



			award = award.to_dict()
			eff += ObjectGainAux(game, award)
			msgs.append((game.role.name, award))
			if 'cards' in award:
				continue
			grids.extend(award.items())

		eff = ObjectDrawEffect(game, eff.to_dict(), grids, _afterGain)

		return  eff


#
# ObjectYYLivenessWheel
#

class ObjectYYLivenessWheel(ObjectYYGeneralTask):
	"""
	?????
	"""

	@classmethod
	def refreshRecord(cls, yyObj, game, init=None):
		record = cls.getRecord(yyObj.id, game)
		ndi = todayinclock5date2int()
		if ndi != record.get('lastday', None):
			record['lastday'] = ndi
			record['stamps'] = {}
			record['valsums'] = {}
			record['valinfo'] = {}
			info = record.setdefault('info', {})
			info['gain_times'] = 0
			info['free_counter'] = 0
		return record

	@classmethod
	def onPredTrue(cls, yyObj, game, csvID):
		record = cls.getRecord(yyObj.id, game)

		stamps = record.setdefault('stamps', {})
		stamps[csvID] = 1

		info = record.setdefault('info', {})

		maxGainTimes = yyObj.paramMap['maxGainTimes']
		gainTimes = info.get('gain_times', 0)
		totalTimes = info.get('total_times', 0)

		if gainTimes >= maxGainTimes:
			return

		info['gain_times'] = gainTimes + 1
		info['total_times'] = totalTimes + 1

	@classmethod
	def getEffect(cls, yyID, drawType, game):
		record = cls.getRecord(yyID, game)
		info = record.setdefault('info', {})

		totalTimes = info.get('total_times', 0)
		freeCounter = info.get('free_counter', 0)
		drawCounter1 = info.get('draw_counter1', 0)
		drawCounter5 = info.get('draw_counter5', 0)

		freeMax = csv.yunying.yyhuodong[yyID].paramMap.get('free', 1)

		if drawType == DrawEquipDefs.LivenessWheelFree1:
			if freeCounter >= freeMax:
				raise ClientError(ErrDefs.freeDrawTimerNoCD)
			drawTimes = drawCounter1
		elif drawType == DrawEquipDefs.LivenessWheel1:
			if totalTimes < 1:
				raise ClientError(ErrDefs.livenessWheelTimesNotEnough)
			drawTimes = drawCounter1
		elif drawType == DrawEquipDefs.LivenessWheel5:
			if totalTimes < 5:
				raise ClientError(ErrDefs.livenessWheelTimesNotEnough)
			drawTimes = drawCounter5
		else:
			raise ClientError('drawType error')

		def _afterGain():
			if drawType == DrawEquipDefs.LivenessWheelFree1:
				info['free_counter'] = freeCounter + 1
				info['draw_counter1'] = drawCounter1 + 1
			elif drawType == DrawEquipDefs.LivenessWheel1:
				info['total_times'] = totalTimes - 1
				info['draw_counter1'] = drawCounter1 + 1
			elif drawType == DrawEquipDefs.LivenessWheel5:
				info['total_times'] = totalTimes - 5
				info['draw_counter5'] = drawCounter5 + 1

		realDrawType = drawType
		if realDrawType == DrawEquipDefs.LivenessWheelFree1:
			realDrawType = DrawEquipDefs.LivenessWheel1

		return ObjectDrawEquipRandom.getRandomItems(game, DrawEquipDefs.YYDrawRandomKey(realDrawType, yyID), drawTimes + 1, _afterGain)

#
# ObjectYYLuckyEgg
#

class ObjectYYLuckyEgg(ObjectYYItemExchange):
	'''
	???
	'''

	@classmethod
	def drawEgg(cls, yyID, drawType, game):
		record = cls.getRecord(yyID, game)
		info = record.setdefault('info', {})
		counter1 = info.setdefault('lucky_egg_counter1', 0)
		counter10 = info.setdefault('lucky_egg_counter10', 0)
		draw1 = info.setdefault("lucky_egg_draw1_times", 0)
		draw10 = info.setdefault("lucky_egg_draw10_times", 0)

		cfg = csv.yunying.yyhuodong[yyID]

		if drawType == DrawItemDefs.LuckyEggFree1:
			if game.dailyRecord.lucky_egg_free_counter > 0:
				raise ClientError(ErrDefs.freeDrawTimerNoCD)
			drawTimes = counter1
		elif drawType == DrawItemDefs.LuckyEggRMB1:
			draw1limit = cfg.paramMap.get("RMB1LIMIT", 0)
			if draw1limit:
				if draw1 + 1 > draw1limit:
					raise ClientError("draw times limit up")
			if game.items.getItemCount(DrawItemDefs.LuckyEggCoin) < 1:
				costRMB = cfg.paramMap['RMB1']
				if game.role.rmb < costRMB:
					raise ClientError(ErrDefs.luckyEggRMBNotEnough)
			drawTimes = counter1
		elif drawType == DrawItemDefs.LuckyEggRMB10:
			draw10limit = cfg.paramMap.get("RMB10LIMIT", 0)
			if draw10limit:
				if draw10 + 1 > draw10limit:
					raise ClientError("draw times limit up")
			if game.items.getItemCount(DrawItemDefs.LuckyEggCoin) < 10:
				costRMB = cfg.paramMap['RMB10']
				if game.role.rmb < costRMB:
					raise ClientError(ErrDefs.luckyEggRMBNotEnough)
			drawTimes = counter10
		else:
			raise ClientError('draw error')

		def _afterGain():
			if drawType == DrawItemDefs.LuckyEggFree1:
				game.dailyRecord.lucky_egg_free_counter += 1
				info['lucky_egg_counter1'] = counter1 + 1
			elif drawType == DrawItemDefs.LuckyEggRMB1:
				cost = ObjectCostAux(game, {DrawItemDefs.LuckyEggCoin: 1})
				if not cost.isEnough():
					costRMB =cfg.paramMap['RMB1']
					cost = ObjectCostAux(game, {'rmb': costRMB})
				cost.cost(src='lucky_egg_%s' % drawType)
				info['lucky_egg_counter1'] = counter1 + 1
				info["lucky_egg_draw1_times"] = draw1 + 1
			elif drawType == DrawItemDefs.LuckyEggRMB10:
				cost = ObjectCostAux(game, {DrawItemDefs.LuckyEggCoin: 10})
				if not cost.isEnough():
					costRMB =cfg.paramMap['RMB10']
					cost = ObjectCostAux(game, {'rmb': costRMB})
				cost.cost(src='lucky_egg_%s' % drawType)
				info['lucky_egg_counter10'] = counter10 + 1
				info["lucky_egg_draw10_times"] = draw10 + 1

		realDrawType = drawType
		if realDrawType == DrawItemDefs.LuckyEggFree1:
			realDrawType = DrawItemDefs.LuckyEggRMB1

		return ObjectDrawItemRandom.getRandomItems(game, DrawItemDefs.YYDrawRandomKey(realDrawType, yyID), drawTimes + 1, _afterGain)


#
# ObjectYYHuoDongRedPacket
#

class ObjectYYHuoDongRedPacket(ObjectYYBase):
	'''
	??????
	'''

	@classmethod
	def classInit(cls):
		pass

	@classmethod
	def active(cls, yyObj, game):
		# ????????active
		return

	@classmethod
	def getEffect(cls, yyID, _, game):
		return None

#
# ObjectYYHuoDongCrossRedPacket
#
class ObjectYYHuoDongCrossRedPacket(ObjectYYBase):
	'''
	????????
	'''

	@classmethod
	def classInit(cls):
		pass

	@classmethod
	def active(cls, yyObj, game):
		# ????????active
		return

	@classmethod
	def getEffect(cls, yyID, _, game):
		return None

#
# ObjectYYWeeklyCard
#

class ObjectYYWeeklyCard(ObjectYYBase):
	'''
	????
	'''
	HuoDongMap = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.weeklycard
		return csv.yunying.weeklycard[csvID]

	@classmethod
	def active(cls, yyObj, game):
		hd = cls.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return
		record = cls.getRecord(yyObj.id, game)
		if record.get('buy', None):
			stamps = record.setdefault('stamps', {})
			edt = min(yyObj.gameEndDateTime(game), nowdatetime_t())
			day = (inclock5date(edt) - int2date(record['buy'])).days + 1
			for csvID in hd.csvIDs:
				cfg = cls.csv(csvID)
				if cfg.day <= day and csvID not in stamps:
					stamps[csvID] = 1 # ???

	@classmethod
	def isRoleEnd(cls, yyObj, game):
		# ????????????
		hd = cls.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return False
		record = cls.getRecord(yyObj.id, game)
		stamps = record.get('stamps', {})

		# ???????????stamps?,?????
		for csvID in hd.csvIDs:
			if csvID not in stamps:
				return False

		# ??????,?????{len(hd.csvIDs)+1}?????
		today = inclock5date(nowdatetime_t())
		email_date = int2date(record['buy']) + datetime.timedelta(days=len(hd.csvIDs))
		return today >= email_date

	@classmethod
	def canBuy(cls, yyID, csvID, game):
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			return False
		# ????
		if record.get('buy', None):
			return False
		return True

	@classmethod
	def buyRecharge(cls, game, rechargeID, yyID, csvID):
		yyObj = ObjectYYHuoDongFactory.getConfig(yyID)
		record = cls.getRecord(yyID, game)
		if record.get('buy', None):
			return False, None
		record['buy'] = todayinclock5date2int() # ???
		cls.active(yyObj, game) # ??????
		return True, None

	@classmethod
	def isRechargeOK(cls, rechargeID, yyID, csvID):
		cfg = csv.yunying.yyhuodong[yyID]
		if not cfg or cfg.paramMap.get('recharge', None) != rechargeID:
			return False
		return True

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = csvIDs

		ObjectYYWeeklyCard.HuoDongMap[huodongID] = self

#
# ObjectYYDrawGemLimit
#
class ObjectYYDrawGemLimit(ObjectYYBase):
	'''
	????
	'''
	DrawTypes = {
		DrawGemDefs.LimitUpGemFree1: ('limit_up_gem_counter_1', 0, '', 1),
		DrawGemDefs.LimitUpGemRMB1: ('limit_up_gem_counter_1', 1, 'RMB1', 1),
		DrawGemDefs.LimitUpGemRMB10: ('limit_up_gem_counter_10', 10, 'RMB10', 10),
	}
	DrawLimit = DrawGemDefs.DrawLimit
	ExchangeLimit = 'exchangeTimes'  # ????????
	ExchangeMap = {}  # {'suitID': {(suitID, quality): [csvID,...]}, 'suitNo': {(suitNo, quality): [csvID,...]}, 'blank': {(None, quality): [csvID,...]}}

	@classmethod
	def classInit(cls):
		cls.ExchangeMap = {'suitID': {}, 'suitNo': {}, 'blank': {}}
		for i in csv.gem.gem:
			cfg = csv.gem.gem[i]
			# ???????? ?? ?????
			if cfg.quality < 4 or not cfg.suitID or not cfg.suitNo:
				continue
			suitIDs = cls.ExchangeMap['suitID'].setdefault((cfg.suitID, cfg.quality), [])
			suitIDs.append(i)
			suitNos = cls.ExchangeMap['suitNo'].setdefault((cfg.suitNo, cfg.quality), [])
			suitNos.append(i)
			blanks = cls.ExchangeMap['blank'].setdefault((None, cfg.quality), [])
			blanks.append(i)

	@classmethod
	def exchangeCfg(cls, huodongID, quality):
		for i in csv.yunying.gem_exchange:
			cfg = csv.yunying.gem_exchange[i]
			if cfg.huodongID == huodongID and cfg.quality == quality:
				return cfg

	@classmethod
	def active(cls, yyObj, game):
		cls.refreshRecord(yyObj, game)

	@classmethod
	def getEffect(cls, yyID, drawType, game):
		record = cls.getRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		info = record.setdefault('info', {})
		drawCounter = info.setdefault('draw_counter', 0)

		counterType, drawItemCount, yyParamKey, drawCount = cls.DrawTypes[drawType]
		drawTimes = info.get(counterType, 0)

		realDrawType = drawType
		if drawType == DrawGemDefs.LimitUpGemFree1:
			if game.dailyRecord.limit_up_gem_free_count > 0:
				raise ClientError(ErrDefs.freeDrawTimerNoCD)
			realDrawType = DrawGemDefs.LimitUpGemRMB1
			game.dailyRecord.limit_up_gem_free_count += 1
		else:
			costRmb = csv.yunying.yyhuodong[yyID].paramMap[yyParamKey]
			cost = ObjectCostAux(game, {'rmb': costRmb})

			if not cost.isEnough():
				raise ClientError(ErrDefs.drawGemRMBNotEnough)

			if drawCounter + drawCount > csv.yunying.yyhuodong[yyID].paramMap[cls.DrawLimit]:
				raise ClientError(ErrDefs.rmbDrawGemLimitUp)

			cost.cost(src='draw_gem_%s' % drawType)

		def _afterGain():
			info[counterType] = info.get(counterType, 0) + 1
			info['draw_counter'] = drawCounter + drawItemCount
			cls.onGeneralTask(game, counterType)

		return ObjectDrawGemRandom.getRandomItems(game, DrawGemDefs.LimitDrawRandomKey(realDrawType, yyID), drawTimes + 1, _afterGain)

	@classmethod
	def onGeneralTask(cls, game, counterType):
		if counterType == 'limit_up_gem_counter_1':
			counter = 1
		elif counterType == 'limit_up_gem_counter_10':
			counter = 10
		else:
			return

		ObjectYYHuoDongFactory.onGeneralTask(game, TargetDefs.DrawGemUp, counter)
		ObjectYYHuoDongFactory.onGeneralTask(game, TargetDefs.DrawGemUpAndRMB, counter)

	@classmethod
	def refreshRecord(cls, yyObj, game):
		record = cls.getRecord(yyObj.id, game)
		info = record.setdefault('info', {})
		info.setdefault('exchange_counter', 0)
		if record.get('lastday', None) != todayinclock5date2int():
			# ????up???????
			info['draw_counter'] = 0
			record['lastday'] = todayinclock5date2int()
		else:
			info.setdefault('draw_counter', 0)
		return record

	@classmethod
	def getExchangeBaseCost(cls, yyObj, game):
		record = cls.getRecord(yyObj.id, game)
		times = record.get('info', {}).get('exchange_counter', 0)
		lst = yyObj.paramMap['cost']
		maxT = min(len(lst) - 1, times)
		return lst[maxT]

	@classmethod
	def exchangeGem(cls, game, gems, flag, key, yyID):
		yyCfg = csv.yunying.yyhuodong[yyID]
		record = cls.getRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		info = record.setdefault('info', {})

		cfg = cls.exchangeCfg(yyCfg.huodongID, key[1])
		if not cfg:
			raise ClientError('gem exchange cfg error')

		costRmb = cls.getExchangeBaseCost(yyCfg, game) + cfg.cost
		cost = ObjectCostAux(game, {'rmb': costRmb})
		cost.setCostGems(gems)
		if not cost.isEnough():
			raise ClientError('gem exchange cost not enough')

		returnItems = ObjectGainAux(game, {})
		pool = set(copy.deepcopy(cls.ExchangeMap[flag][key]))
		from game.object.game import ObjectGemRebirth
		for gem in gems:
			if gem.gem_id in pool:
				# ????????
				pool.remove(gem.gem_id)

			# ??????,?????????
			if gem.level > 1:
				rebirthObj = ObjectGemRebirth(game, gem)
				eff = rebirthObj.getEffect(ConstDefs.gemRebirthRetrunProportion)
				rebirthObj.rebirth()
				returnItems += eff

		returnItems += ObjectGainAux(game, cfg.compensate)

		# 3?2 ?? 2?1
		exchangeNum = len(gems) - 1
		for _ in xrange(exchangeNum):
			csvID = random.choice(list(pool))
			returnItems += ObjectGainAux(game, {csvID: 1})

		# ??????
		cost.cost(src='gem_exchange')
		info['exchange_counter'] = info.get('exchange_counter', 0) + 1
		return returnItems

#
# ObjectYYBaoZongzi
#

class ObjectYYBaoZongzi(ObjectYYBase):

	TaskMap = {} # {huodongID: [[csvID, taskParam]...]}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.bao_zongzi_task
		return csv.yunying.bao_zongzi_task[csvID]

	@classmethod
	def classInit(cls):
		cls.TaskMap = {}
		for idx in csv.yunying.bao_zongzi_task:
			cfg = csv.yunying.bao_zongzi_task[idx]
			cls.TaskMap.setdefault(cfg.huodongID, [])
			cls.TaskMap[cfg.huodongID].append([idx, cfg.taskParam])
		for huodongID, tasks in cls.TaskMap.iteritems():
			cls.TaskMap[huodongID] = sorted(tasks, key=lambda x: x[1])

	@classmethod
	def baoZongzi(cls, yyID, plans, game):
		def _afterGain():
			record = cls.getRecord(yyID, game)
			info = record.setdefault('info', {})
			info.setdefault('counter', 0)
			for v in plans.itervalues():
				info['counter'] += v

			stamps = record.setdefault('stamps', {})
			for taskCsvID, taskParam in cls.TaskMap[huodongID]:
				if taskCsvID in stamps:
					continue
				if info['counter'] >= taskParam:
					stamps[taskCsvID] = 1
				else:
					break

		cost = ObjectCostAux(game, {})
		eff = ObjectYYHuoDongEffect(game, {}, _afterGain)
		huodongID = csv.yunying.yyhuodong[yyID].huodongID

		for csvID, count in plans.iteritems():
			if csvID not in csv.yunying.bao_zongzi_recipe:
				raise ClientError('csvID is not exist')
			cfg = csv.yunying.bao_zongzi_recipe[csvID]
			if cfg.huodongID != huodongID:
				raise ClientError('csvID error')
			cost += ObjectCostAux(game, cfg.mainItem) * count
			cost += ObjectCostAux(game, cfg.minorItem) * count
			eff += ObjectGainAux(game, cfg.compoundItem) * count

		if not cost.isEnough():
			raise ClientError('cost item no enough')
		cost.cost(src='yy_bao_zongzi')

		return eff


#
# ObjectYYReunion
#
class ObjectYYReunion(ObjectYYBase):

	'''
	????
	'''
	TaskMap = {} # {huodongID: {target: [cfg]}}
	ReunionTaskMap = {}  # {huodongID: [csvID]}

	# ????????????
	InvalidTaskTypes = set([TargetDefs.DispatchTaskQualityDone, TargetDefs.RandomTowerFloorSum])

	@classmethod
	def classInit(cls):
		cls.TaskMap = {}
		cls.ReunionTaskMap = {}
		for csvID in cls.csv():
			cfg = cls.csv(csvID)
			if cfg.huodongID == 0:
				continue
			cls.TaskMap.setdefault(cfg.huodongID, {}).setdefault(cfg.taskType, []).append(cfg)
			if cfg.themeType == ReunionDefs.Reunion:
				cls.ReunionTaskMap.setdefault(cfg.huodongID, []).append(csvID)

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.reunion_task
		return csv.yunying.reunion_task[csvID]

	@classmethod
	def getRecord(cls, game):
		return game.role.reunion

	@classmethod
	def active(cls, yyObj, game, typ, val):
		# ???????????
		roleType = game.role.reunion.get('role_type', None)
		if game.role.isReunionRoleOpen and roleType != ReunionDefs.ReunionRole:
			return

		yyID = cls.getYYactiveYYID(game)
		if yyID is None or yyObj is None or (yyID != yyObj.id):
			return
		# huodongID: ?????
		huodongID = csv.yunying.yyhuodong[yyObj.id].huodongID

		reunion = game.reunionRecord
		# ???
		reunion.targets['all'] = len(cls.ReunionTaskMap.get(huodongID, []))
		reunion.targets.setdefault('cur', 0)

		# ????????????
		today = todayinclock5date2int()  # 5???
		if today != reunion.last_date and roleType == ReunionDefs.ReunionRole:
			reunion.login_days += 1
			reunion.last_date = today

		stamps = game.role.reunion.setdefault('stamps', {})  # ???????????
		valsumsD = reunion.valsums  # ???? {taskType: [count ????, count ????]}
		valinfoD = reunion.valinfo  # ????????

		if typ in cls.InvalidTaskTypes:
			return

		# ???????????,??????????type??
		valsum, vice = valsumsD.get(typ, [0, 0])
		valsum, ok = targetActive(typ, typ, val, valsum, valinfoD)
		if ok:
			valsumsD[typ] = [valsum, valsum]
		for ind, cfg in enumerate(cls.TaskMap.get(huodongID, {}).get(typ, [])):
			flag = stamps.get(cfg.id, ReunionDefs.TaskNoneFlag)
			if flag == ReunionDefs.TaskCloseFlag:
				continue
			_, pred = predGen(typ, cfg['taskParam'], cfg['taskSpecialParam'])
			if pred(game, valsum):
				stamps[cfg.id] = ReunionDefs.TaskOpenFlag

	@classmethod
	def addLoginDays(cls, date, reunion):
		reunion.login_days += 1
		reunion.last_date = date

	@classmethod
	def cloneTodayDateInt(cls):
		'''
		12? ??????
		'''
		now = nowdatetime_t()
		if now.hour >= 12:
			return date2int(now.date())
		else:
			return date2int((now - OneDay).date())

	@classmethod
	def getYYactiveYYID(cls, game):
		role = game.role
		yyIDs = [yyID for yyID in ObjectYYHuoDongFactory.getYYReunionOpenIDs() if ObjectYYHuoDongFactory.HuoDongMap[yyID].isRoleOpen(role.level, role.created_time, role.vip_level)]
		if not yyIDs:
			return None

		if role.reunionYYID is not None:
			return role.reunionYYID

		now = nowtime_t()
		record = role.reunion
		info = record.get('info', {})

		# ????????
		if now <= info.get('end_time', 0):
			role.reunionYYID = info['yyID']
			return role.reunionYYID

		needRefresh = False
		reunionCfgs = [csv.yunying.yyhuodong[idx] for idx in yyIDs]
		reunionCfgs.sort(key=lambda x: x.paramMap['offline'], reverse=True)
		if not info:
			last_time = datetimefromtimestamp(role.last_login_time)
			days = todayelapsedays(last_time)
			for cfg in reunionCfgs:
				if days >= cfg.paramMap['offline']:
					needRefresh = True
					reunionCfg = cfg
					break
		else:
			# ?????????????,?????????????????
			last_time = datetimefromtimestamp(max(role.last_login_time, game.reunionRecord.end_time))
			days = todayelapsedays(last_time)

			for cfg in reunionCfgs:
				if days >= cfg.paramMap['offline'] and info.get('cd', {}).get(cfg.id, 0) <= now:
					needRefresh = True
					reunionCfg = cfg
					break

		if needRefresh:
			end_dt = datetimefromtimestamp(now) + OneDay * reunionCfg.paramMap['duration']
			record.setdefault('cd', {})[reunionCfg.id] = datetime2timestamp(end_dt + OneDay * reunionCfg.paramMap['cd'])
			# ?????????
			game.role.reunion = {
				'info': {'days': days, 'reunion_time': now, 'end_time': datetime2timestamp(end_dt), 'yyID': reunionCfg.id, 'huodongID': reunionCfg.huodongID, 'role_id': role.id, 'gate': role.currentGateID},
				'role_type': ReunionDefs.ReunionRole,
				'cd': copy.deepcopy(record.get('cd', {}))
			}
			# ???? ???????
			game.reunionRecord.initReunionRecord(reunionCfg.id, datetime2timestamp(end_dt))
			# ??????
			cls.refreshReunionGift(game, reunionCfg.huodongID, game.reunionRecord)
			role.reunionYYID = reunionCfg.id
			return reunionCfg.id
		role.reunionYYID = 0
		return None

	@classmethod
	def getEffect(cls, yyID, csvID, game, awardType):
		if not game.role.isReunionRoleOpen:
			raise ClientError('role not open')

		record = game.role.reunion
		info = record.get('info', {})
		if yyID != info['yyID']:
			raise ClientError('yyID error')

		roleType = record['role_type']
		# ??????????????????
		if roleType == ReunionDefs.SeniorRole and awardType in (ReunionDefs.ReunionGift, ReunionDefs.TaskAward):
			raise ClientError('role type error')

		# ????
		if awardType == ReunionDefs.TaskAward:
			reunion = game.reunionRecord
			if record['stamps'].get(csvID, None) != ReunionDefs.TaskOpenFlag:
				raise ClientError('task not complete')
			cfg = cls.csv(csvID)
			award = cfg.award

			def _afterGain():
				record['stamps'][csvID] = ReunionDefs.TaskCloseFlag
				if cfg.isSync:
					game.reunionRecord.stamps[csvID] = ReunionDefs.TaskCloseFlag
				if cfg.themeType == ReunionDefs.Reunion and roleType == ReunionDefs.ReunionRole:
					reunion.targets['cur'] = reunion.targets.get('cur', 0) + 1
					reunion.bind_point += cfg.point

					# ??????
					cls.refreshPointBox(game, cfg.huodongID, reunion.bind_point)

					# ???????????
					from game.object.game import ObjectGame
					bindRoleGame = ObjectGame.getByRoleID(reunion.bind_role_db_id, safe=False)
					if bindRoleGame:
						ObjectYYReunion.refreshPointBox(bindRoleGame, cfg.huodongID, reunion.bind_point)

		# ????
		elif awardType == ReunionDefs.PointAward:
			pointBox = record['point_box']
			if pointBox.get(csvID, None) != ReunionDefs.TaskOpenFlag:
				raise ClientError(ErrDefs.yyHuoDongNoActive)

			cfg = csv.yunying.reunion_point_box[csvID]
			award = cfg.award2 if roleType == ReunionDefs.ReunionRole else cfg.award1

			def _afterGain():
				pointBox[csvID] = ReunionDefs.TaskCloseFlag

		# ????
		elif awardType == ReunionDefs.BindAward:
			gift = record['gift']
			giftID, flag = gift.get('bind', [None, None])
			if flag != ReunionDefs.TaskOpenFlag or giftID != csvID:
				raise ClientError(ErrDefs.yyHuoDongNoActive)

			award = csv.yunying.reunion_gift[csvID].item

			def _afterGain():
				gift['bind'] = [csvID, ReunionDefs.TaskCloseFlag]

		# ????
		elif awardType == ReunionDefs.ReunionGift:
			gift = record['gift']
			giftID, flag = gift.get('reunion', [None, None])
			if flag != ReunionDefs.TaskOpenFlag or giftID != csvID:
				raise ClientError(ErrDefs.yyHuoDongNoActive)

			award = csv.yunying.reunion_gift[csvID].item

			def _afterGain():
				gift['reunion'] = [csvID, ReunionDefs.TaskCloseFlag]

		return ObjectYYHuoDongEffect(game, award, _afterGain)

	@classmethod
	def refreshRoleReunion(cls, game, reunion):
		roleType = game.role.reunion.get('role_type', None)
		if not roleType:
			return
		huodongID = game.role.reunion['info']['huodongID']
		if roleType == ReunionDefs.ReunionRole:  # ????
			# ????????
			cls.refreshReunionTask(game, huodongID, reunion)
		# ???????????
		cls.refreshPointBox(game, huodongID, reunion.bind_point)
		# ???????????
		cls.refreshReunionGift(game, huodongID, reunion)

	@classmethod
	def refreshReunionTask(cls, game, huodongID, reunion, typ=None):
		record = game.role.reunion
		stamps = record.setdefault('stamps', {})
		typList = [typ, ] if typ else [TargetDefs.ReunionFriend, TargetDefs.CooperateClone]
		for taskType in typList:
			valsum = min(reunion.valsums.get(taskType, [0, 0]))
			for cfg in cls.TaskMap.get(huodongID, {}).get(taskType, []):
				flag = stamps.get(cfg.id, ReunionDefs.TaskNoneFlag)
				if flag == ReunionDefs.TaskCloseFlag:
					continue

				_, pred = predGen(taskType, cfg['taskParam'], cfg['taskSpecialParam'])
				if pred(game, valsum):
					stamps[cfg.id] = ReunionDefs.TaskOpenFlag

	@classmethod
	def refreshPointBox(cls, game, huodongID, point):
		record = game.role.reunion
		pointBox = record.setdefault('point_box', {})
		for csvID in csv.yunying.reunion_point_box:
			cfg = csv.yunying.reunion_point_box[csvID]
			if cfg.huodongID != huodongID:
				continue
			if pointBox.get(csvID, ReunionDefs.TaskNoneFlag) in (ReunionDefs.TaskOpenFlag, ReunionDefs.TaskCloseFlag):
				continue
			if cfg.pointNode <= point:
				pointBox[csvID] = ReunionDefs.TaskOpenFlag

	@classmethod
	def refreshReunionGift(cls, game, huodongID, reunion):
		record = game.role.reunion

		roleType = record['role_type']
		gift = record.setdefault('gift', {})
		for csvID in csv.yunying.reunion_gift:
			cfg = csv.yunying.reunion_gift[csvID]
			if cfg.huodongID != huodongID:
				continue

			if cfg.type == ReunionDefs.ReunionGift:
				if roleType == ReunionDefs.SeniorRole:
					continue
				# ???? ???????? ??????
				gift['reunion'] = [csvID, gift.get('reunion', [csvID, ReunionDefs.TaskOpenFlag])[1]]
			elif cfg.type == ReunionDefs.BindAward:
				_, flag = gift.get('bind', [None, ReunionDefs.TaskNoneFlag])
				# ??? ? ???
				if flag in (ReunionDefs.TaskOpenFlag, ReunionDefs.TaskCloseFlag):
					continue
				if cfg.target == roleType and reunion.bind_role_db_id:
					gift['bind'] = [csvID, ReunionDefs.TaskOpenFlag]

	@classmethod
	def acceptBindInvitation(cls, game, yyID, huodongID, reunion):
		'''
		????????
		'''
		role = game.role
		if reunion.role_db_id == game.role.id:
			raise ClientError('can not bind yourself')
		if yyID != reunion.yyID:
			raise ClientError('yyID error')

		now = nowtime_t()
		if now < reunion.end_time:
			if reunion.bind_role_db_id:
				raise ClientError('bind invitation invalid')
			if role.id in reunion.bind_history:
				raise ClientError('can not bind again')

			reunion.bind_role_db_id = role.id
			reunion.bind_history.append(role.id)
			if not reunion.game:
				reunion.save_async(forget=True)

			role.reunion = {
				'info': {'yyID': yyID, 'huodongID': huodongID, 'role_id': reunion.role_db_id, 'end_time': reunion.end_time},
				'bind_cd': reunion.countBindCD() * 24 * 3600 + reunion.end_time,
				'role_type': ReunionDefs.SeniorRole,
				'cd': copy.deepcopy(role.reunion.get('cd', {}))
			}
			ObjectYYReunion.refreshReunionGift(game, huodongID, reunion)

			# ???????????
			from game.object.game import ObjectGame
			bindRoleGame = ObjectGame.getByRoleID(reunion.role_db_id, safe=False)
			if bindRoleGame:
				ObjectYYReunion.refreshReunionGift(bindRoleGame, huodongID, reunion)
		else:
			raise ClientError('bind invitation expired')

	@classmethod
	def canBuy(cls, yyID, csvID, game):
		if not game.role.isReunionRoleOpen:
			return False

		record = game.role.reunion
		if record['role_type'] != ReunionDefs.ReunionRole:
			return False
		if record['info']['yyID'] != yyID:
			return False

		recharge = record.setdefault('recharge', {})
		times, date = recharge.get(csvID, (0, 0))
		cfg = csv.yunying.reunion_recharge[csvID]
		if cfg.huodongID != ObjectYYHuoDongFactory.getConfig(yyID).huodongID:
			raise ClientError('huodongID error')
		if cfg.limitType == ReunionDefs.DayLimit:
			now = todayinclock5date2int()
			if date != now:
				recharge.pop(csvID, None)
				return True
			return times + 1 <= cfg.limitNum
		elif cfg.limitType == ReunionDefs.ActLimit:
			return times + 1 <= cfg.limitNum
		elif cfg.limitType == ReunionDefs.NoLimit:
			return True

	@classmethod
	def buyRecharge(cls, game, rechargeID, yyID, csvID):
		if not cls.canBuy(yyID, csvID, game):
			return False, None

		record = game.role.reunion
		recharge = record['recharge']
		cfg = csv.yunying.reunion_recharge[csvID]
		if cfg.huodongID != csv.yunying.yyhuodong[yyID].huodongID:
			return False, None

		def _afterGain():
			if cfg.limitType == ReunionDefs.DayLimit:
				times, date = recharge.get(csvID, (0, todayinclock5date2int()))
			else:
				times, date = recharge.get(csvID, (0, 0))
			recharge[csvID] = (times + 1, date)

		return True, ObjectYYHuoDongEffect(game, cfg.item, _afterGain)

	@classmethod
	def isRechargeOK(cls, rechargeID, yyID, csvID):
		cfg = csv.yunying.reunion_recharge[csvID]
		if not cfg or cfg.rechargeID != rechargeID:
			return False
		return True


#
# ObjectYYFlop
#

class ObjectYYFlop(ObjectYYGeneralTask):

	GrandPrizeMap = {} # {roundID: {csvID:weight...}}
	RoundsMap = {} # {roundID: {csvID:weight...}}
	HuoDongMap = {}
	AwardMaxCount = 16
	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.flop_task
		return csv.yunying.flop_task[csvID]

	@classmethod
	def classInit(cls):
		super(ObjectYYFlop, cls).classInit()
		for idx in csv.yunying.flop_rounds:
			cfg = csv.yunying.flop_rounds[idx]
			for roundID in cfg.rounds:
				cls.RoundsMap.setdefault(cfg.huodongID, {})
				cls.RoundsMap[cfg.huodongID].setdefault(roundID, {})
				cls.RoundsMap[cfg.huodongID][roundID][idx] = cfg.weight
				if cfg.type == 1:
					cls.GrandPrizeMap.setdefault(cfg.huodongID, {})
					cls.GrandPrizeMap[cfg.huodongID][roundID] = idx

	@classmethod
	def refreshRecord(cls, yyObj, game, init=None):
		record = cls.getRecord(yyObj.id, game)
		ndi = todayinclock5date2int()
		if ndi != record.get('lastday', None):
			record['lastday'] = ndi
			info = record.setdefault('info', {
				'cost_task_times': 0,
				'task_times': 0,
				'roundID': 1,
			})
			record.setdefault('stamps', {})
			info['cost_free_times'] = 0
			record['valinfo'] = {}
			record['valsums'] = {}
		return record
	@classmethod
	def nextRound(cls, yyID, game):
		record = cls.getRecord(yyID, game)
		record['info']['roundID'] += 1
		record['stamps'] = {}

	@classmethod
	def getEffect(cls, yyID, huodongID, game, pos):
		record = cls.getRecord(yyID, game)
		stampsD = record.setdefault('stamps', {})

		costTaskTimes = record['info']['cost_task_times']
		costFreeTimes = record['info']['cost_free_times']
		freeMax = csv.yunying.yyhuodong[yyID].paramMap.get('free', 1)
		taskTimes = record['info']['task_times']
		roundID = record['info']['roundID']

		if roundID > len(cls.RoundsMap[huodongID]):
			raise ClientError('end of activity')
		if costFreeTimes >= freeMax and costTaskTimes >= taskTimes:
			raise ClientError('not enough times')
		if stampsD.get(pos,False):
			raise ClientError('pos error')
		# ???????
		if len(stampsD) == cls.AwardMaxCount - 1:
			csvID = cls.GrandPrizeMap[huodongID][roundID]
		else:
			pool = copy.deepcopy(cls.RoundsMap[huodongID][roundID])
			for csvID in stampsD.values():
				if csvID in pool:
					# ????????
					del pool[csvID]
			csvID, _ = WeightRandomObject.onceRandom(pool)

		cfg = csv.yunying.flop_rounds[csvID]
		if not cfg:
			raise ClientError('flop_rounds cfg error')
		stampsD[pos] = csvID
		returnItems = ObjectGainAux(game, cfg.award)
		if freeMax > costFreeTimes:
			record['info']['cost_free_times'] = costFreeTimes + 1
		elif taskTimes > costTaskTimes:
			record['info']['cost_task_times'] = costTaskTimes + 1
		if len(stampsD) >= cls.AwardMaxCount or cls.GrandPrizeMap[huodongID][roundID] in stampsD.values():
			cls.nextRound(yyID, game)
		return returnItems

	@classmethod
	def active(cls, yyObj, game, type, val):
		hd = cls.getHd(yyObj, game)
		if hd is None:
			return

		record = cls.refreshRecord(yyObj, game)
		valsumsD = record.setdefault('valsums', {})
		valinfoD = record.setdefault('valinfo', {})
		for i, tpred in enumerate(hd.typePreds):
			csvID = hd.csvIDs[i]
			taskType, taskPred = tpred
			# ?????????
			if taskType != type:
				continue
			valsum = valsumsD.get(csvID, 0)
			valsum, ok = targetActive(type, csvID, val, valsum, valinfoD, sp=lambda :cls.csv(csvID).taskSpecialParam)
			if not ok:
				continue
			valsumsD[csvID] = valsum
			if taskPred(game, valsum):
				taskCfg = csv.yunying.flop_task[csvID]
				nowTimes = min(valsumsD[csvID]/taskCfg.taskParam, taskCfg.times)
				valtimes = valinfoD.get(csvID, {'count':0})
				if nowTimes > valtimes['count']:
					record['info']['task_times'] += (nowTimes - valtimes['count'])*taskCfg.award
					valinfoD[csvID] = {'count':nowTimes}

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = sorted(csvIDs)
		self.typePreds = [predGen(self.csv(x).taskType, self.csv(x).taskParam, self.csv(x).taskSpecialParam) for x in self.csvIDs]

		ObjectYYFlop.HuoDongMap[huodongID] = self

#
## ObjectYYQualityExchange
#

class ObjectYYQualityExchange(ObjectYYBase):
	'''
	????

	{lastday: 20160719, stamps: {csvID: ??}}
	'''

	HuoDongMap = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.qualityexchange
		return csv.yunying.qualityexchange[csvID]

	@classmethod
	def active(cls, yyObj, game):
		hd = cls.HuoDongMap.get(yyObj.huodongID, None)
		if hd is None:
			return

		cls.refreshRecord(yyObj, game)

	@classmethod
	def getEffect(cls, yyID, csvID, game, costID, targetID=0, count=1):
		record = cls.getRecord(yyID, game)
		stamps = record.setdefault('stamps', {})
		cfg = csv.yunying.qualityexchange[csvID]
		if not cfg:
			raise ClientError('csvID error')
		if cfg.huodongID != ObjectYYHuoDongFactory.getConfig(yyID).huodongID:
			raise ClientError('huodongID error')
		vipTimes = 0
		if cfg.type == 1:
			heldItem = game.heldItems.getHeldItem(costID)
			if heldItem is None or not heldItem.exist_flag:
				raise ClientError('heldItemID error')
			csvHeldItem = csv.held_item.items[heldItem.held_item_id]
			if csvHeldItem is None or csvHeldItem.quality != cfg.quality:
				raise ClientError('quality error')
			vipTimes += game.role.heldItemExchangeTimes.get(cfg.quality, 0)
		elif cfg.type == 2:
			csvFrag = csv.fragments[costID]
			if not csvFrag or csvFrag.quality != cfg.quality:
				raise ClientError('fragID error')
			vipTimes += game.role.fragExchangeTimes.get(cfg.quality, 0)
		else:
			raise ClientError('costID error')

		exchangeTimes = csv.yunying.yyhuodong[yyID].paramMap.get('quality', {}).get(cfg.quality,0)
		# ????
		if exchangeTimes <= 0 or stamps.get(cfg.quality, 0) + count > exchangeTimes + vipTimes:
			raise ClientError(ErrDefs.exchangeMax)
		if targetID < 0 or len(cfg.items) < targetID + 1:
			raise ClientError('targetID error')
		# ????
		cost = ObjectCostAux(game, cfg.costMap)
		if cfg.type == 1:
			cost.setCostHeldItems([heldItem])
		else:
			cost += ObjectCostAux(game, {costID:cfg.count})
		cost *= count
		if not cost.isEnough():
			if cost.lack == ObjectCostAux.LackRMB:
				raise ClientError(ErrDefs.rmbNotEnough)
			else:
				raise ClientError(ErrDefs.exchangeItemNotEnough)
		cost.cost(src='yy_%d' % yyID)

		def _afterGain():
			stamps[cfg.quality] = stamps.get(cfg.quality, 0) + count
		eff = ObjectYYHuoDongEffect(game, cfg.items[targetID], _afterGain)
		eff *= count
		return eff

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = csvIDs

		ObjectYYQualityExchange.HuoDongMap[huodongID] = self


#
#
#

class ObjectYYHalloweenSprites(ObjectYYBase):
	'''????????????'''


	pumpkinCartID = 0

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = csvIDs

		ObjectYYHalloweenSprites.HuoDongMap[huodongID] = self

	@classmethod
	def getEffect(cls, yyID, csvID, game):
		'''
		yyID: ??ID,??????????????
		csvID: ???ID;??? 0,?????ID
		game: ????
		'''

		record = cls.getExistedRecord(yyID, game)
		yyObj = ObjectYYHuoDongFactory.getConfig(yyID)
		huodongID = yyObj.huodongID

		# stamps ??????????? key ?????,
		# ?? stamps[key]
		# 	= 0 ?? key ???
		# 	= 1 ?? key ???????
		if 'stamps' not in record:
			raise ClientError("Bad stamps")

		stamps = record['stamps']
		cfg = cls.csv(csvID)

		if csvID != cls.pumpkinCartID and cfg.huodongID != huodongID:  # ?????
			raise ClientError("Wrong sprite huodingID")
		if csvID not in stamps:  # ID ???
			raise ClientError(ErrDefs.badHalloweenSpriteID)
		elif stamps[csvID] != 1:  # ???
			if csvID == cls.pumpkinCartID:  # ?????????????
				raise ClientError('Pumpkin cart has already been sent')
			else:  # ??????
				raise ClientError(ErrDefs.halloweenSpriteRepeats)

		# ????????
		if csvID == cls.pumpkinCartID:  # ???
			eff = ObjectYYHuoDongEffect(game, yyObj.paramMap['awards'], cb=None)
			stamps[csvID] = 0  # ???
		else:
			eff = ObjectYYHuoDongEffect(game, cfg.award, cb=None)
			stamps[csvID] = 0  # ???

			# ?????????
			pumpkinCartReady = True
			for k,v in stamps.items():
				if k != cls.pumpkinCartID:  # ???????????,?????????
					if v:  # ???????
						pumpkinCartReady = False
			if pumpkinCartReady:
				stamps[cls.pumpkinCartID] = 1


		return eff

	@classmethod
	def active(cls, yyObj, game):
		'''
		?????????????
		'''

		record = cls.refreshRecord(yyObj, game)
		huodongID = yyObj.huodongID
		stamps = record.setdefault('stamps', {})
		if stamps:  # ????,????????
			return

		cfgs = [cls.csv(cfgID) for cfgID in cls.HuoDongMap[huodongID].csvIDs]

		selected1 = WeightRandomObject.onceSample(  # ??????
			weights=[(cfg.id, cfg.weight) for cfg in cfgs if cfg.type == 1],
			num=ConstDefs.halloweenSpriteNum1
		)
		selected2 = WeightRandomObject.onceSample(  # ??????
			weights=[(cfg.id, cfg.weight) for cfg in cfgs if cfg.type == 2],
			num=ConstDefs.halloweenSpriteNum2
		)
		stamps.update({k: 1 for k,v in (selected1+selected2)})  # ?????,??????

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.halloween_sprites
		else:
			return csv.yunying.halloween_sprites[csvID]

# ObjectYYHuoDongBoss
#

class ObjectYYHuoDongBoss(ObjectYYBase):
	"""
	??boss
	{
		weight: ????
		last_time: ??????
	}

	{
		id:
		gateID: ??id  huodongboss.csv scene_conf.csv
		start_time: ????
		owner: ???
		win_roles: []
		owner_win: False
	}
	"""

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.huodongboss_config
		return csv.yunying.huodongboss_config[csvID]

	@classmethod
	def csvFromYYID(cls, yyID):
		yy = ObjectYYHuoDongFactory.HuoDongMap.get(yyID, None)
		if yy is None:
			return
		hd = cls.HuoDongMap.get(yy.huodongID, None)  # huodongboss_config
		if hd is None:
			return
		return cls.csv(hd.csvID)

	@classmethod
	def activeHuoDongBoss(cls, yyID, game, stamina):
		cfg = csv.yunying.yyhuodong[yyID]
		if not cfg:
			return
		hd = cls.HuoDongMap.get(cfg.huodongID, None)
		if hd is None:
			return

		cfg = cls.csv(hd.csvID)
		if game.dailyRecord.huodong_boss_count >= cfg.dailyCountLimit:
			return

		record = cls.getRecord(yyID, game)
		info = record.setdefault('info', {})
		huodongBoss = record.setdefault('huodong_boss', {})
		# ??cd
		if nowtime_t() - huodongBoss.get('last_time', 0) < cfg.cd * 60:
			return

		huodongBoss['weight'] = huodongBoss.get('weight', 0) + sum([random.uniform(cfg.staminaWeightMin, cfg.staminaWeightMax) for i in xrange(stamina)])
		if huodongBoss['weight'] < 1.0:
			return

		gateCfg = hd.rndObj.getRandom()
		bossData = cls.addYYHuoDongBoss(game, gateCfg.id)
		logger.info('role uid %s active huodongboss gateID %s uid %s', game.role.uid, gateCfg.id, bossData['uid'])

		huodongBoss['weight'] -= 1
		huodongBoss['last_time'] = nowtime_t()

		# yy record???????
		info['huodong_boss_count'] = info.get('huodong_boss_count', 0) + 1
		game.dailyRecord.huodong_boss_count += 1

		return bossData

	@classmethod
	def addYYHuoDongBoss(cls, game, gateID):
		import binascii, os
		uid = binascii.hexlify(os.urandom(16))
		boss = {
			'uid': uid,
			'owner': cls.makeHuoDongBossRoleModel(game.role),
			'gate_id': gateID,
			'win_roles': [],
			'owner_win': False,
			'start_time': nowtime_t(),
		}
		return boss

	@classmethod
	def makeHuoDongBossRoleModel(cls, role):
		return {
			'role_id': role.id,
			'game_key': role.areaKey,
			'name': role.name,
			'logo': role.logo,
			'frame': role.frame,
			'level': role.level,
			'fight_point': role.top6_fighting_point,
		}

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvID = csvIDs[0]
		hdCfg = self.csv(self.csvID)

		gates = []
		for gateID in csv.yunying.huodongboss:
			cfg = csv.yunying.huodongboss[gateID]
			if cfg.gateLibID == hdCfg.gateLibID:
				gates.append(cfg)
		if not gates:
			return
		self.rndObj = WeightRandomObject(gates, lambda cfg: cfg.weight)

		ObjectYYHuoDongBoss.HuoDongMap[huodongID] = self


#
## ObjectYYDouble11
#

class ObjectYYDouble11(ObjectYYBase):
	'''
	???
	'''

	GameMap = {} # ???? {huodongID: [gameCfg...]}
	LotteryWeightMap = {} # ???? {huodongID: {cfg.id: weight}}

	# ??????????????????
	# {yyID: "win":{gameCsvID: {lotteryCsvID: num}}, "fail": {gameCsvID: {lotteryCsvID: [num....]}}}
	LotteryInfo = {}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.double11_lottery
		return csv.yunying.double11_lottery[csvID]

	@classmethod
	def classInit(cls):
		cls.GameMap = {}
		gameTmp = {}
		for idx in csv.yunying.double11_game:
			cfg = csv.yunying.double11_game[idx]
			gameTmp.setdefault(cfg.huodongID, [])
			gameTmp[cfg.huodongID].append((cfg.game, cfg))
		for huodongID, games in gameTmp.iteritems():
			cls.GameMap[huodongID] = [item[1] for item in sorted(games, key=lambda x:x[0])]

		cls.LotteryWeightMap = {}
		for idx in csv.yunying.double11_lottery:
			cfg = csv.yunying.double11_lottery[idx]

			cls.LotteryWeightMap.setdefault(cfg.huodongID, {})
			cls.LotteryWeightMap[cfg.huodongID][cfg.id] = cfg.weight

		# ????????
		for huodongID, weights in cls.LotteryWeightMap.iteritems():
			weights[-1] = 100 - sum(weights.values())
			cls.LotteryWeightMap[huodongID] = weights

		# ????????? main ??????????????
		cls.LotteryInfo = {}

	@classmethod
	def getLotteryInfo(cls, yyID):
		if yyID not in cls.LotteryInfo:
			yyObj = ObjectYYHuoDongFactory.getConfig(yyID)

			# ?????
			gameNumSum = (yyObj.gameEndDateTime(None) - yyObj.gameBeginDateTime(None)).days * len(yyObj.paramMap['gameTime'])

			huodongID = csv.yunying.yyhuodong[yyID].huodongID
			gameCsvIDs = [cfg.id for cfg in cls.GameMap[huodongID][:gameNumSum]]
			lotteryCsvIDs = [csvID for csvID in cls.LotteryWeightMap[huodongID] if csvID != -1]
			numPond = range(100)

			# ????????????????
			winInfo = ObjectServerGlobalRecord.setYYHuodongDouble11LotteryInfo(yyID, gameCsvIDs, lotteryCsvIDs, numPond)

			# ?????,???????????????
			cls.LotteryInfo.setdefault(yyID, {})
			cls.LotteryInfo[yyID]['win'] = winInfo
			cls.LotteryInfo[yyID]['fail'] = {}
			for gameCSvID, winLotteryInfo in winInfo.iteritems():
				cls.LotteryInfo[yyID]['fail'][gameCSvID] = [v for v in range(100) if v not in winLotteryInfo.values()]

		return cls.LotteryInfo[yyID]

	@classmethod
	def getGameTimeDT(cls, now, timeInterval):
		date = now.date()
		startTime = datetime.datetime.combine(date,datetime.time(hour=timeInterval[0] / 100, minute=timeInterval[0] % 100))

		if timeInterval[1] / 100 == 0:
			date = (now + OneDay).date()

		endTime = datetime.datetime.combine(date,datetime.time(hour=timeInterval[1] / 100, minute=timeInterval[1] % 100))

		return startTime, endTime

	@classmethod
	def getGameCfg(cls, yyObj, now):
		gameTime = yyObj.paramMap['gameTime']

		todayNum = -1

		for i, timeInterval in enumerate(gameTime):
			startTime, endTime = cls.getGameTimeDT(now, timeInterval)
			if now >= startTime and now <= endTime:
				todayNum = i
				break

		# ?????????
		if todayNum == -1:
			return None, None

		days = todayinclock5elapsedays(yyObj.gameBeginDateTime(None))
		gameNum = days * len(gameTime) + todayNum

		if gameNum >= len(cls.GameMap[yyObj.huodongID]):
			return None, None

		return cls.GameMap[yyObj.huodongID][gameNum], todayNum

	@classmethod
	def gameStart(cls, yyID, game):
		now = nowdatetime_t()
		yyObj = ObjectYYHuoDongFactory.getConfig(yyID)
		gameCfg, _ = cls.getGameCfg(yyObj, now)

		if not gameCfg:
			raise ClientError(ErrDefs.double11GameNotOpen)

		record = cls.getRecord(yyID, game)
		double11 = record.get('double11', None)

		if double11 is not None and gameCfg.id in double11:
			raise ClientError('has played')

		game.role.yyDouble11GameStartTime = datetime2timestamp(now)

	@classmethod
	def gameEnd(cls, yyID, game, count):
		if game.role.yyDouble11GameStartTime == 0:
			raise ClientError('do not start maybe cheat')

		startTime = datetimefromtimestamp(game.role.yyDouble11GameStartTime)
		useTime = nowtime_t() - game.role.yyDouble11GameStartTime
		game.role.yyDouble11GameStartTime = 0

		yyObj = ObjectYYHuoDongFactory.getConfig(yyID)
		if useTime > yyObj.paramMap['playTimeMax']:
			raise ClientError(ErrDefs.cheatError)

		redPacketNumLimit = yyObj.paramMap['redPacketNumLimit']
		if count > redPacketNumLimit:
			logger.warning("role %d yyID %d double11 red packet count %d cheat can max %d", game.role.uid, yyID, count, redPacketNumLimit)
			raise ClientError(ErrDefs.cheatError)

		gameCfg, todayNum = cls.getGameCfg(yyObj, startTime)
		if not gameCfg:
			logger.warning("role %s startTime %s not find gameCfg", game.role.uid, startTime)
			raise ClientError('not find game')

		lotteryInfo = cls.getLotteryInfo(yyObj.id)
		lotteryCsvID, _ = WeightRandomObject.onceRandom(cls.LotteryWeightMap[yyObj.huodongID])
		# -1 ??????
		if lotteryCsvID != -1:
			cardNum = lotteryInfo['win'][gameCfg.id][lotteryCsvID]
		else:
			cardNum = random.choice(lotteryInfo['fail'][gameCfg.id])

		_, endTime = cls.getGameTimeDT(startTime, yyObj.paramMap['gameTime'][todayNum])
		gameEndTime = int(datetime2timestamp(endTime))

		record = cls.getRecord(yyID, game)
		double11 = record.setdefault('double11', {})
		double11[gameCfg.id] = {
			'red_packet_num': count,
			'card_status': 1, # 1 ??,2 ??,-1 ??
			'card_num': cardNum,
			'lottery_csv_id': lotteryCsvID,
			'game_end_time': gameEndTime, # ??????,????????
		}

		return ObjectGainAux(game, {gameCfg.itemID: count}) if count > 0 else None

	@classmethod
	def cardOpen(cls, yyID, gameCsvID, game):
		record = cls.getRecord(yyID, game)
		double11 = record.get('double11', None)

		if not double11 or gameCsvID not in double11:
			raise ClientError('has not card')

		# 1 ??
		# 2 ??
		# -1 ????
		if double11[gameCsvID]['card_status'] == 2:
			raise ClientError('has opened')

		double11[gameCsvID]['card_status'] = 2

	@classmethod
	def getRegainMailEffect(cls, yyObj, game):
		record = cls.getExistedRecord(yyObj.id, game)
		if not record:
			return None
		double11 = record.get('double11', None)
		if not double11:
			return None

		nt = nowtime_t()
		gameCsvID = None
		for csvID, info in double11.iteritems():
			# ??????,???
			if info['game_end_time'] > nt:
				continue
			if info['card_status'] == -1:
				continue
			gameCsvID = csvID

			# ????????????
			break

		if not gameCsvID:
			return None

		# ????
		gameInfo = double11[gameCsvID]

		# ????????
		if gameInfo['lottery_csv_id'] == -1:
			gameInfo['card_status'] = -1
			return None

		def _afterGain():
			gameInfo['card_status'] = -1

		gameNum = csv.yunying.double11_game[gameCsvID].game # ??
		lotteryCfg = cls.csv(gameInfo['lottery_csv_id'])
		eff = ObjectGainAux(game, lotteryCfg.award)
		lotteryName = getL10nCsvValue(lotteryCfg, 'name')

		from game.mailqueue import ObjectMailEffect as ObjectYYHuoDongMailEffect
		subject = csv.mail[YYHuoDongDouble11LotteryMailID].subject
		content = csv.mail[YYHuoDongDouble11LotteryMailID].content % (gameNum, double11[gameCsvID]['card_num'], lotteryName)
		mail = game.role.makeMyMailModel(YYHuoDongDouble11LotteryMailID, subject=subject, content=content, attachs=eff.result)
		return ObjectYYHuoDongMailEffect(mail, _afterGain)


# ObjectYYHuoDongCloth
#
class ObjectYYHuoDongCloth(ObjectYYBase):
	"""
	????
	stamps : ????
	targets: ????
	info: {level: 1, total_exp: 0, exp: 0}
	"""
	ClothPartMap = {}  # {huodongID:{part: [(csvID, bool), ]}
	LevelMap = {}  # {huodongID: {level: cfg}}
	DefaultLevel = {}  # {huodongID: level}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.huodongcloth_level
		return csv.yunying.huodongcloth_level[csvID]

	@classmethod
	def classInit(cls):
		cls.ClothPartMap = {}
		cls.LevelMap = {}
		cls.DefaultLevel = {}
		for csvID in cls.csv():
			cfg = cls.csv(csvID)
			if cfg.huodongID == 0:
				continue
			levels = cls.LevelMap.setdefault(cfg.huodongID, {})
			levels[cfg.level] = cfg

		for csvID in csv.yunying.huodongcloth_part:
			cfg = csv.yunying.huodongcloth_part[csvID]
			if cfg.huodongID == 0:
				continue
			cls.ClothPartMap.setdefault(cfg.huodongID, {}).setdefault(cfg.belongPart, []).append((csvID, cfg.isDefault))

		for huodongID, levels in cls.LevelMap.iteritems():
			cls.DefaultLevel[huodongID] = min(levels.keys())

	@classmethod
	def addExp(cls, yyID, exp, game):
		record = cls.getRecord(yyID, game)
		info = record['info']
		stamps = record['stamps']

		yyObj = ObjectYYHuoDongFactory.getConfig(yyID)
		level = info['level']

		info['total_exp'] += exp
		exp += info['exp']

		levelSeq = cls.LevelMap[yyObj.huodongID]
		levelMax = max(levelSeq)

		levelCfg = levelSeq[level]
		while level < levelMax and exp >= levelCfg.needExp:
			level += 1
			exp -= levelCfg.needExp
			levelCfg = levelSeq[level]
			if levelCfg.award:
				stamps[levelCfg.id] = TaskDefs.taskOpenFlag
			if levelCfg.unlockPart:
				for csvID, isDefault in cls.ClothPartMap[yyObj.huodongID][levelCfg.unlockPart]:
					if isDefault:
						record['targets'][str(levelCfg.unlockPart)] = csvID
						break
		info['exp'] = exp
		info['level'] = level
		return record

	@classmethod
	def refreshRecord(cls, yyObj, game, init=None):
		record = cls.getRecord(yyObj.id, game)
		info = record.setdefault('info', {})
		stamps = record.setdefault('stamps', {})  # ????
		targets = record.setdefault('targets', {})  # ????

		# ????
		level = info.setdefault('level', cls.DefaultLevel[yyObj.huodongID])
		info.setdefault('total_exp', 0)
		info.setdefault('exp', 0)

		levelCfg = cls.LevelMap[yyObj.huodongID][level]
		if level == cls.DefaultLevel[yyObj.huodongID]:
			if levelCfg.award and levelCfg.id not in stamps:
				stamps[levelCfg.id] = TaskDefs.taskOpenFlag
			if levelCfg.unlockPart:
				for csvID, isDefault in cls.ClothPartMap[yyObj.huodongID][levelCfg.unlockPart]:
					if isDefault and str(levelCfg.unlockPart) not in targets:
						# ???????????
						targets[str(levelCfg.unlockPart)] = csvID
						break
		return record

	@classmethod
	def decorate(cls, yyID, csvID, part, game):
		record = cls.getRecord(yyID, game)
		if str(part) not in record['targets']:
			raise ClientError('part locked')

		yyObj = ObjectYYHuoDongFactory.getConfig(yyID)
		if csvID not in [i[0] for i in cls.ClothPartMap[yyObj.huodongID][int(part)]]:
			raise ClientError('part csvID error')

		record['targets'][str(part)] = csvID


# ObjectYYSnowBall
#
class ObjectYYSnowBall(ObjectYYBase):
	"""
	???
	stamps: {csvID: 1} ??
	info: {times: ??????}
	"""
	AwardMap = {}  # {huodongID: {type: [csvID,]}}

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.snowball_award
		return csv.yunying.snowball_award[csvID]

	@classmethod
	def classInit(cls):
		cls.AwardMap = {}
		for csvID in cls.csv():
			cfg = cls.csv(csvID)
			cls.AwardMap.setdefault(cfg.huodongID, {}).setdefault(cfg.type, {})
			# type 1-?? 2-??
			cls.AwardMap[cfg.huodongID][cfg.type][cfg.num] = cfg.id

	@classmethod
	def active(cls, yyObj, _):
		if yyObj.id in cls.HuoDongMap:
			return
		cls.HuoDongMap[yyObj.id] = True

		from game.session import Session

		# ?????????
		# ????? endtime
		delta = yyObj.gameEndDateTime(None) - nowdatetime_t()
		Session.startYYSnowBallEndTimer(yyObj.id, delta)

	@classmethod
	def startSnowBallGame(cls, yyID, game):
		record = cls.getRecord(yyID, game)
		yyCfg = ObjectYYHuoDongFactory.getConfig(yyID)
		if record['info']['times'] >= yyCfg.paramMap['times'] + record['info'].get('buy_times', 0):
			raise ClientError('snowball play times limit up')
		record['info']['start'] = 1

	@classmethod
	def endSnowBallGame(cls, yyObj, point, playTime, role, game):
		record = cls.getRecord(yyObj.id, game)
		info = record['info']
		if info.get('start', 0) == 0:
			raise ClientError('game not start')

		# ?????, ??playTime??????
		if playTime > yyObj.paramMap['playTimeMax']:
			raise ClientError(ErrDefs.cheatError)

		stamps = record['stamps']
		info['total_point'] += point
		info['times'] += 1

		# ?????????
		needRefresh = False
		if point > info['top_point'] or (point == info['top_point'] and int(playTime) > info['top_time']):
			info['top_point'] = point
			info['top_time'] = int(playTime)  # ??? ???? ?
			info['top_role'] = role
			needRefresh = True

		# ?? ????????0??????
		signAward = cls.AwardMap[yyObj.huodongID][1]
		if point > 0 and not info['sign']:
			info['days'] += 1
			info['sign'] = 1
			awardID = signAward.get(info['days'], None)
			if awardID:
				stamps[awardID] = TaskDefs.taskOpenFlag

		# ????
		pointAward = cls.AwardMap[yyObj.huodongID][2]
		for num in sorted(pointAward):
			if info['total_point'] < num:
				break
			csvID = pointAward[num]
			if info['total_point'] >= num and csvID not in stamps:
				stamps[csvID] = TaskDefs.taskOpenFlag

		info['start'] = 0
		return needRefresh

	@classmethod
	def refreshRecord(cls, yyObj, game, init=None):
		record = cls.getRecord(yyObj.id, game)
		info = record.setdefault('info', {'isGuide': 0, 'top_point': 0, 'top_time': 0, 'top_role': 0, 'rank': 0, 'days': 0})
		record.setdefault('stamps', {})

		lastDay = record.get('lastday', None)
		now = todayinclock5date2int()
		if lastDay != now:
			record['lastday'] = now
			info['times'] = 0  # ??
			info['buy_times'] = 0  # ????
			info['sign'] = 0  # ??????
			info['total_point'] = 0  # ?????
			cls.resetPointAward(record, yyObj.huodongID)

		# snowball_fix
		signAward = cls.AwardMap[yyObj.huodongID][1]
		csvIDs = []
		for day in xrange(1, info["days"] + 1):
			awardID = signAward.get(day, None)
			if awardID and awardID not in record['stamps']:
				record['stamps'][awardID] = 0
				csvIDs.append(awardID)
		if csvIDs:
			from framework.helper import objectid2string
			logger.info("role %s %s snowball_fix %s", game.role.uid, objectid2string(game.role.id), csvIDs)
		return record

	# ??????
	@classmethod
	def resetPointAward(cls, record, huodongID):
		awards = {}
		signCsvIDs = set(cls.AwardMap[huodongID][1].values())
		for csvID, flag in record['stamps'].iteritems():
			if csvID in signCsvIDs:
				awards[csvID] = flag
		record['stamps'] = awards

	@classmethod
	def getSnowBallBuyCost(cls, yyObj, times):
		lst = yyObj.paramMap['buyCost']
		maxT = min(len(lst) - 1, times)
		return lst[maxT]

	@classmethod
	def getEffect(cls, yyID, csvID, game):
		record = cls.getExistedRecord(yyID, game)
		if record is None or 'stamps' not in record:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		csvIDs = []
		# ?????? -1???? -2 ????
		if csvID in [-1, -2]:
			yyObj = ObjectYYHuoDongFactory.getConfig(yyID)
			# awardType = abs(csvID)
			for csvID in cls.AwardMap[yyObj.huodongID][abs(csvID)].itervalues():
				if record['stamps'].get(csvID, None) == 1:
					csvIDs.append(csvID)
			if not csvIDs:
				raise ClientError('one key no award')
		# ????
		elif csvID > 0:
			if record['stamps'].get(csvID, None) != 1:
				raise ClientError('no award')
			csvIDs = [csvID, ]

		def _afterGain():
			for csvID in csvIDs:
				record['stamps'][csvID] = 0  # ???

		awards = {}
		for csvID in csvIDs:
			awards = addDict(awards, cls.csv(csvID).award)
		return ObjectYYHuoDongEffect(game, awards, _afterGain)


# ObjectYYSpriteUnfreeze
#
class ObjectYYSpriteUnfreeze(ObjectYYBase):
	"""
	??????
	"""
	@classmethod
	def classInit(cls):
		pass

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.city_sprites
		return csv.city_sprites[csvID]

	@classmethod
	def active(cls, yyObj, game):
		cls.refreshRecord(yyObj, game)

	@classmethod
	def getEffect(cls, yyID, csvID, game):
		record = cls.getExistedRecord(yyID, game)
		if record is None or 'stamps' not in record:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		if record['stamps'].get(csvID, None) != 1:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		def _afterGain():
			record['stamps'][csvID] = 0  # ???

		return ObjectYYHuoDongEffect(game, cls.csv(csvID).unfreezeAward, _afterGain)

	@classmethod
	def refreshRecord(cls, yyObj, game):
		record = cls.getRecord(yyObj.id, game)
		record.setdefault("stamps", {})

		lastDay = record.get('lastday', None)
		now = todayinclock5date2int()
		if lastDay != now:
			record['lastday'] = now
			record['stamps'] = {csvID: 1 for csvID in yyObj.paramMap['sprites']}


#
# ObjectYYSkyscraper
#
class ObjectYYSkyscraper(ObjectYYBase):
	"""
	????
	stamps: {csvID: 1} ??
	info: {times: ??????}
	"""

	MedalPoints = {}  # ???????
	FloorMap = {}

	@classmethod
	def classInit(cls):
		cls.MedalPoints = {}
		cls.FloorMap = {}

		for idx in sorted(csv.yunying.skyscraper_medals.keys()):
			medal = csv.yunying.skyscraper_medals[idx]
			hd = cls.MedalPoints.setdefault(medal.huodongID, {0:0})
			hd[idx] = hd[idx-1] + medal.points

		for idx in sorted(csv.yunying.skyscraper_floors.keys()):
			floor = csv.yunying.skyscraper_floors[idx]
			hd = cls.FloorMap.setdefault(floor.huodongID, [])
			hd.append(floor)

	@classmethod
	def startSkyscraperGame(cls, yyID, game):
		yyObj = ObjectYYHuoDongFactory.getConfig(yyID)
		cls.refreshRecord(yyObj, game)
		record = cls.getRecord(yyID, game)
		if record['info']['times'] >= yyObj.paramMap['times'] + record['info'].get('buy_times', 0):
			raise ClientError('skyscraper play times limit up')
		record['info']['start'] = todayinclock5date2int()

	@classmethod
	def endSkyscraperGame(cls, yyObj, points, floors, perfections, game):
		'''
		point: ??
		floors: ??
		perfections: ????

		??????????(???????)?????,??true
		'''

		ret = False

		cls.refreshRecord(yyObj, game)
		record = cls.getRecord(yyObj.id, game)
		info = record['info']
		if info.get('start', 0) == 0:
			raise ClientError('game did not start')
		startTime = info['start']
		info['start'] = 0

		if points > info['high_points'] or floors > info['high_floors']:
			ret = True

		info['high_points'] = max(info['high_points'], points)
		info['high_floors'] = max(info['high_floors'], floors)

		if startTime != todayinclock5date2int():
			# ???5?,??????????????
			return ret

		info['points'] += points
		info['floors'] += floors
		info['perfections'] += perfections
		info['times'] += 1

		record.setdefault('stamps', {})  # ????
		record.setdefault('stamps1', {})  # ????
		# ??
		for idx in csv.yunying.skyscraper_tasks:
			task = csv.yunying.skyscraper_tasks[idx]
			if task.huodongID != yyObj.huodongID:
				continue
			if task.type not in [1,2,3]:
				raise ClientError('csv task type not recognized')

			if task.type == 1 and info['floors'] >= task.params and task.id not in record['stamps']:
				record['stamps'][task.id] = 1
			elif task.type == 2 and info['points'] >= task.params and task.id not in record['stamps']:
				record['stamps'][task.id] = 1
			elif task.type == 3 and info['perfections'] >= task.params and task.id not in record['stamps']:
				record['stamps'][task.id] = 1

		return ret

	@classmethod
	def refreshRecord(cls, yyObj, game):
		record = cls.getRecord(yyObj.id, game)

		record.setdefault('stamps', {})  # ????
		record.setdefault('stamps1', {})  # ????

		# ????
		info = record.setdefault('info', {
			'task_points': 0,  # ????(??????)
			'high_points': 0,  # ????
			'high_floors': 0,  # ????
			})

		# ????????stamps
		lastDay = record.get('lastday', None)
		now = todayinclock5date2int()
		if lastDay != now:
			record['lastday'] = now
			info['buy_times'] = 0  # ????
			info['times'] = 0  # ????
			info['points'] = 0  # ?????
			info['floors'] = 0  # ?????
			info['perfections'] = 0  # ???????
			record['stamps'] = {}  # ????

		return record

	@classmethod
	def getEffect(cls, yyID, csvID, awardType, game):
		'''?????????

		awardType:
			0: ??
			1: ??
		'''

		if awardType not in [0, 1]:
			raise ClientError('bad award type')
		stampName = 'stamps' if awardType == 0 else 'stamps1'
		record = cls.getExistedRecord(yyID, game)
		if record is None or stampName not in record:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		if record[stampName].get(csvID, None) != 1:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		cfg = csv.yunying.skyscraper_tasks if awardType == 0 else csv.yunying.skyscraper_medals

		def _afterGain():
			record[stampName][csvID] = 0 # ???
			if awardType == 0:  # ??????
				record['info']['task_points'] += cfg[csvID].points
				cls.refreshMedal(yyID, game)

		return ObjectYYHuoDongEffect(game, cfg[csvID].award, _afterGain)

	@classmethod
	def refreshMedal(cls, yyID, game):
		# ?????????,?????????,?????
		record = cls.getExistedRecord(yyID, game)
		record.setdefault('stamps1', {})  # ????
		huodongID = csv.yunying.yyhuodong[yyID].huodongID
		info = record['info']
		for idx in cls.MedalPoints[huodongID]:
			if idx == 0:
				continue
			if info['task_points'] >= cls.MedalPoints[huodongID][idx] and idx not in record['stamps1']:
				record['stamps1'][idx] = 1

	@classmethod
	def getRegainMailEffect(cls, yyObj, game):
		# ??????

		record = cls.getExistedRecord(yyObj.id, game)
		if record is None or 'stamps1' not in record:
			return None

		cfg = csv.yunying.skyscraper_medals
		ids = filter(lambda x:record['stamps1'][x] == 1, record['stamps1'])
		if not ids:
			return None

		def _afterGain():
			for csvID in ids:
				record['stamps1'][csvID] = 0 # ???

		eff = ObjectGainAux(game, {})
		for csvID in ids:
			eff += ObjectGainAux(game, cfg[csvID].award)

		from game.mailqueue import ObjectMailEffect as ObjectYYHuoDongMailEffect
		subject = csv.mail[YYHuodongMailID].subject % (yyObj.desc,)
		mail = game.role.makeMyMailModel(YYHuodongMailID, subject=subject, attachs=eff.result)
		return ObjectYYHuoDongMailEffect(mail, _afterGain)

	@classmethod
	def getOneKeyEffect(cls, yyID, game):
		# ???????

		record = cls.getExistedRecord(yyID, game)
		if record is None or 'stamps' not in record:
			raise ClientError(ErrDefs.yyHuoDongNoActive)


		cfg = csv.yunying.skyscraper_tasks
		ids = filter(lambda x:record['stamps'][x] == 1, record['stamps'])
		if not ids:
			return None

		def _afterGain():
			for csvID in ids:
				record['stamps'][csvID] = 0 # ???
				record['info']['task_points'] += cfg[csvID].points
			cls.refreshMedal(yyID, game)

		eff = ObjectYYHuoDongEffect(game, {}, _afterGain)
		for csvID in ids:
			eff += ObjectGainAux(game, cfg[csvID].award)
		return eff

	@classmethod
	def active(cls, yyObj, game):
		cls.refreshRecord(yyObj, game)

	@classmethod
	def getBuyCost(cls, yyObj, times):
		lst = yyObj.paramMap['buyCost']
		maxT = min(len(lst) - 1, times)
		return lst[maxT]


#
# ObjectYYJifu
#

class ObjectYYJifu(ObjectYYGeneralTask):

	HuoDongMap = {}
	LinkTaskParam = {
		1:[1,2,3,4],
		2:[5,6,7,8],
		3:[9,10,11,12],
		4:[13,14,15,16],
		5:[1,6,11,16],
		6:[4,8,12,16],
		7:[3,7,11,15],
		8:[2,6,10,14],
		9:[1,5,9,13]
	}
	AwardMap = {}
	TaskMap = {}
	BoardIdMap = {}
	# ????ID
	MaxAwardID = 0

	@classmethod
	def classInit(cls):
		super(ObjectYYJifu, cls).classInit()
		for idx in csv.yunying.jifu_award:
			cfg = csv.yunying.jifu_award[idx]
			cls.AwardMap.setdefault(cfg.huodongID, {})
			cls.AwardMap[cfg.huodongID][cfg.awardID] = cfg

		for idx in csv.yunying.jifu_task:
			cfg = csv.yunying.jifu_task[idx]
			cls.TaskMap.setdefault(cfg.huodongID, {})
			cls.TaskMap[cfg.huodongID][cfg.boardID] = cfg

		for awardID,boardIdList in cls.LinkTaskParam.iteritems():
			for boardID in boardIdList:
				cls.BoardIdMap.setdefault(boardID, [])
				if awardID not in cls.BoardIdMap[boardID]:
					cls.BoardIdMap[boardID].append(awardID)

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.jifu_task
		return csv.yunying.jifu_task[csvID]

	# ??????
	@classmethod
	def getEffect(cls, yyID, csvID, game):
		record = cls.getRecord(yyID, game)
		stampsD = record.setdefault('stamps', {})

		if stampsD.get(csvID, -1) != 1:
			raise ClientError('csvID error')
		yyCfg = csv.yunying.yyhuodong[yyID]
		cfg = cls.csv(csvID)
		if not cfg or yyCfg.huodongID != cfg.huodongID:
			raise ClientError('jifu_task cfg error')

		def _afterGain():
			# ???????
			stampsD[csvID] = 0
			cls.checkLinkAward(yyID, game, csvID)

		return ObjectYYHuoDongEffect(game, cfg.award, _afterGain)

	# ???????? ??????
	@classmethod
	def checkLinkAward(cls, yyID, game, csvID):
		record = cls.getRecord(yyID, game)
		linkAward = record.setdefault('link_award', {})
		stampsD = record.setdefault('stamps', {})
		boardID = cls.csv(csvID).boardID
		huodongID = csv.yunying.yyhuodong[yyID].huodongID
		for awardID in cls.BoardIdMap[boardID]:
			# ??????? ????
			if awardID not in cls.AwardMap[huodongID] or linkAward.get(awardID, -1) != -1:
				continue
			canGet = True
			for boardID in cls.LinkTaskParam[awardID]:
				cfg = cls.TaskMap[huodongID][boardID]
				if stampsD.get(cfg.id, -1) != 0:
					canGet = False
					break
			if canGet:
				# ???????
				linkAward[awardID] = 1

		if cls.MaxAwardID not in linkAward and len(linkAward) >= len(cls.AwardMap[huodongID]):
			# ???????
			linkAward[cls.MaxAwardID] = 1

	# ?????? ??????
	@classmethod
	def getLinkAwardEffect(cls, yyID, game, awardID):
		record = cls.getRecord(yyID, game)
		linkAward = record.setdefault('link_award', {})

		if linkAward.get(awardID, -1) != 1:
			raise ClientError('task not completed')

		award = cls.getLinkAward(yyID, awardID)
		if len(award) == 0:
			raise ClientError('not award')

		def _afterGain():
			# ???????
			linkAward[awardID] = 0

		return ObjectYYHuoDongEffect(game, award, _afterGain)

	# ?????? ??????
	@classmethod
	def getLinkAward(cls, yyID, awardID):
		yyCfg = csv.yunying.yyhuodong[yyID]
		award = {}
		# ??????
		if awardID == cls.MaxAwardID:
			award = yyCfg.paramMap['maxAward']
		else:
			awardCfg = cls.AwardMap[yyCfg.huodongID][awardID]
			award = awardCfg.award
		return award

	# ???????????????
	@classmethod
	def getRegainMailEffect(cls, yyObj, game):
		record = cls.getExistedRecord(yyObj.id, game)
		if record is None:
			return None
		linkAward = record.setdefault('link_award', {})
		stamps = record.setdefault('stamps', {})

		# ????
		taskIds = filter(lambda x:stamps[x] == 1, stamps) or []

		eff = ObjectGainAux(game, {})
		for csvID in taskIds:
			stamps[csvID] = 0 # ???
			eff += ObjectGainAux(game, cls.csv(csvID).award)
			cls.checkLinkAward(yyObj.id, game, csvID)

		# ????
		linkIds = filter(lambda x:linkAward[x] == 1, linkAward) or []

		if not taskIds and not linkIds:
			return None

		for awardID in linkIds:
			linkAward[awardID] = 0
			eff += ObjectGainAux(game, cls.getLinkAward(yyObj.id, awardID))

		from game.mailqueue import ObjectMailEffect as ObjectYYHuoDongMailEffect
		subject = csv.mail[YYHuodongMailID].subject % (yyObj.desc,)
		mail = game.role.makeMyMailModel(YYHuodongMailID, subject=subject, attachs=eff.result)
		return ObjectYYHuoDongMailEffect(mail)

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = sorted(csvIDs)
		self.typePreds = [predGen(self.csv(x).taskType, self.csv(x).taskParam, self.csv(x).taskSpecialParam) for x in self.csvIDs]

		ObjectYYJifu.HuoDongMap[huodongID] = self


#
# ObjectYYHuoDongRMBGoldReturn
#

class ObjectYYHuoDongRMBGoldReturn(ObjectYYBase):
	'''
	??????
	'''

	# ??huodongID??????
	AwardMap = {}
	RateMap = {}

	@classmethod
	def classInit(cls):
		cls.AwardMap = {}
		cls.RateMap = {}
		awardCsv = csv.yunying.rmbgoldreturn_award
		rateCsv = csv.yunying.rmbgoldreturn_rate

		for idx,num,huodongID in sorted([(idx, awardCsv[idx].num, awardCsv[idx].huodongID) for idx in awardCsv], key=lambda x:x[1]):
			cls.AwardMap.setdefault(huodongID, []).append((idx,num))
		for idx,num,huodongID in sorted([(idx, rateCsv[idx].num, rateCsv[idx].huodongID) for idx in rateCsv], key=lambda x:x[1]):
			cls.RateMap.setdefault(huodongID, []).append((idx,num))

	@classmethod
	def isReturnTime(cls, yyObj, game):
		now = nowdatetime_t()
		return now > yyObj.gameEndDateTime(game) - datetime.timedelta(days=yyObj.paramMap['returnDays'])

	@classmethod
	def active(cls, yyObj, game, rmb=0, gold=0):
		if cls.isReturnTime(yyObj, game):
			return

		yyID = yyObj.id
		record = cls.getRecord(yyID, game)
		huodongID = yyObj.huodongID

		yyType = yyObj.paramMap['type']
		if yyType not in ['rmb', 'gold']:
			raise ClientError('type of yyhuodong not recognized')

		info = record.setdefault('info', {})
		info['rmb_used'] = info.get('rmb_used', 0) + rmb
		info['gold_used'] = info.get('gold_used', 0) + gold

		num = info['%s_used'%yyType]
		stamps = record.setdefault('stamps', {})

		# ???????,??????
		for idx,cfgNum in cls.AwardMap[huodongID]:
			if cfgNum > num:
				break
			if idx not in stamps:
				stamps[idx] = 1

	@classmethod
	def getReturn(cls, yyID, game):
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		info = record.setdefault('info', {})
		award = cls.getReturnAward(yyID, game)
		if not award:
			info['flag'] = 1 # ????
			return None

		def _afterGain():
			info['flag'] = 1 # ????
		return ObjectYYHuoDongEffect(game, award, _afterGain)

	@classmethod
	def getReturnAward(cls, yyID, game):
		record = cls.getExistedRecord(yyID, game)
		info = record.setdefault('info', {})
		if info.get('flag', 0):
			return None

		cfg = csv.yunying.yyhuodong[yyID]
		yyType = cfg.paramMap['type']
		limit = cfg.paramMap['limit']
		num = info.get('%s_used'%yyType, 0)

		rate = 0
		for idx,cfgNum in cls.RateMap[cfg.huodongID]:
			if cfgNum > num:
				break
			rate = csv.yunying.rmbgoldreturn_rate[idx].rate

		from math import ceil
		num = min(int(ceil(num * rate)), limit)
		if num <= 0: # ????????????????????
			return None
		return {yyType: num}

	def __init__(self, huodongID, csvIDs):
		self.huodongID = huodongID
		self.csvIDs = csvIDs

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.rmbgoldreturn_award
		return csv.yunying.rmbgoldreturn_award[csvID]

	@classmethod
	def getRegainMailEffect(cls, yyObj, game):
		# ??????????
		record = cls.getExistedRecord(yyObj.id, game)
		if record is None or 'stamps' not in record:
			return None
		info = record.setdefault('info', {})

		ids = filter(lambda x:record['stamps'][x] == 1, record['stamps'])
		if not ids and info.get('flag', 0): # ????????????
			return None

		def _afterGain():
			info['flag'] = 1
			for csvID in ids:
				record['stamps'][csvID] = 0 # ???

		award = cls.getReturnAward(yyObj.id, game)
		if award:
			eff = ObjectGainAux(game, award)
		else:
			eff = ObjectGainAux(game, {})
		for csvID in ids:
			eff += ObjectGainAux(game, cls.csv(csvID).award)

		from game.mailqueue import ObjectMailEffect as ObjectYYHuoDongMailEffect
		subject = csv.mail[YYHuodongMailID].subject % (yyObj.desc,)
		mail = game.role.makeMyMailModel(YYHuodongMailID, subject=subject, attachs=eff.result)
		return ObjectYYHuoDongMailEffect(mail, _afterGain)


#
# ObjectYYHuoDongGridWalk
#

class ObjectYYHuoDongGridWalk(ObjectYYGeneralTask):
	'''
	???
	'''

	# ??huodongID??????
	GridMap = {}
	EventMap = {}
	ShopItemMap = {}  # ShopItemMap[huodongID][type][csvID]
	TreasureMap = {}  # TeasureMap[huodongID] = cfg
	MaxHistoryLen = 6
	COIN_ID = 8102
	COUPON_ID = 8111
	TREASURE_TYPE = 99

	@classmethod
	def classInit(cls):
		cls.GridMap = {}
		cls.EventMap = {}
		cls.ShopItemMap = {}
		cls.TreasureMap = {}

		for idx in csv.yunying.grid_walk_map:
			cfg = csv.yunying.grid_walk_map[idx]
			cls.GridMap.setdefault(cfg.huodongID, {})[cfg.index] = cfg
		for idx in csv.yunying.grid_walk_events:
			cfg = csv.yunying.grid_walk_events[idx]
			cls.EventMap.setdefault(cfg.huodongID, {})[idx] = cfg
			if cfg.type == cls.TREASURE_TYPE:
				cls.TreasureMap[cfg.huodongID] = cfg
		for idx in csv.yunying.grid_walk_shop:
			cfg = csv.yunying.grid_walk_shop[idx]
			cls.ShopItemMap.setdefault(cfg.huodongID, {}).setdefault(cfg.type, {})[idx] = cfg

		super(ObjectYYHuoDongGridWalk, cls).classInit()

	@classmethod
	def itemUse(cls, yyObj, game, itemID):
		'????,?????????'

		if not ItemDefs.isGridWalkItem(itemID):
			raise ClientError('item error')

		record = game.role.grid_walk
		huodongID = yyObj.huodongID
		item = csv.items[itemID]
		itemEvent = item.specialArgsMap['event']
		action = cls.getThisAction(yyObj, game)

		if itemEvent not in (1, 2, 3, 5):  # ??????
			raise ClientError('itemEvent not recognized')

		cost = ObjectCostAux(game, {itemID:1})
		if not cost.isEnough():
			raise ClientError('not enough items')
		cost.cost(src='yy_gridwalk_item_cost')

		if itemEvent == 3:  # ???
			die_rolled = random.choice(item.specialArgsMap['points'])
			steps = die_rolled

			if item.specialArgsMap.get('coin', 0) == 1:  # ?????
				coinGain = steps
				eff = ObjectGainAux(game, {cls.COIN_ID: coinGain})
				eff.gain(src='yy_gridwalk_item_gain')

			itemUsed = action['item_used']
			if itemUsed is not None:
				if csv.items[itemUsed].specialArgsMap['event'] == 5:  # ??????
					steps += csv.items[itemUsed].specialArgsMap['steps']

			record['action']['die_rolled'] = die_rolled
			record['action']['die_used'] = itemID
			record['action']['end_direction_up'] = record['direction_up']

			cls.walk(yyObj, game, steps)
		else:
			if action['item_used'] and not action['die_used']:
				raise ClientError('double item use')

			if itemEvent == 1:  # ??
				record['pos'] = record['treasure'] - 1 if record['direction_up'] else record['treasure'] + 1
				record['pos'] = (len(cls.GridMap[huodongID])+record['pos']-1) % len(cls.GridMap[huodongID]) + 1
			elif itemEvent == 2:  # ????
				record['direction_up'] = not record['direction_up']
			elif itemEvent == 5:   # ??????
				pass  # ????????

			record['action']['item_used'] = itemID

	@classmethod
	def walk(cls, yyObj, game, steps):
		record = game.role.grid_walk
		action = record['action']
		huodongID = yyObj.huodongID
		passedTreasure = None  # ????????,?????????????????????

		while steps > 0:
			steps -= 1
			record['pos'] += 1 if record['direction_up'] else -1
			record['pos'] = (record['pos'] + len(cls.GridMap[huodongID]) - 1) % len(cls.GridMap[huodongID]) + 1
			grid = cls.GridMap[huodongID][record['pos']]
			event = cls.EventMap[huodongID].get(grid.event, None)
			if record['pos'] == record['treasure']:  # ??????
				passedTreasure = len(action['events'])
				cls.onTreasure(yyObj, game) # ?????????????
			elif event:
				if event.trigger == 1 or (event.trigger == 2 and steps == 0):  # ????????????
					steps = cls.onEvent(yyObj, game, event, steps)
			elif steps == 0:  # ???????
				action['events'].append({'csv_id': 0, 'index': record['pos'], 'is_event':False, 'params': {}})

		if passedTreasure is not None:
			# ?????????????
			eventRecord = action['events'][passedTreasure]
			record['treasure'] = cls.nextTreasure(yyObj, game)
			eventRecord['params']['pos'] = record['treasure']

		action['end_pos'] = record['pos']

	@classmethod
	def onEvent(cls, yyObj, game, event, steps):
		'????'

		record = game.role.grid_walk
		huodongID = yyObj.huodongID
		action = record['action']
		action['events'].append({'csv_id': event.id, 'index': record['pos'], 'is_event':True, 'params': {}})
		eventRecord = action['events'][-1]

		if event.type in (3, 4):  # ???+????-
			pass
		elif event.type == 5:  # ????
			steps += event.params['num']
		elif event.type in (1, 2):  # ????????
			choices = [(n, x[2]) for n,x in enumerate(event.params['items'])]
			awardIndex, _ = WeightRandomObject.onceRandom(choices)
			eventRecord['params']['outcome'] = awardIndex
		elif event.type == 6:  # ??
			choices = cls.ShopItemMap[huodongID][1].values()  # ?????
			selected = WeightRandomObject.onceSample(choices, 3, wgetter=lambda x:x.weight)  # ??????3?
			for n,shopItem in enumerate(selected):
				eventRecord['params']['outcome%d'%(n+1)] = shopItem.id

			hasResource = random.random() < event.params['num']  # ??????
			if hasResource:
				choices = cls.ShopItemMap[huodongID][2].values()  # ?????
				shopItem = WeightRandomObject.onceRandom(choices, wgetter=lambda x:x.weight)
				eventRecord['params']['outcome0'] = shopItem.id
			else:
				eventRecord['params']['outcome0'] = 0
		else:
			raise ClientError('event type err')

		return steps

	@classmethod
	def onTreasure(cls, yyObj, game):
		'????'

		record = game.role.grid_walk
		huodongID = yyObj.huodongID
		event = cls.TreasureMap[huodongID]
		action = record['action']
		action['events'].append({'csv_id': event.id, 'index': record['pos'], 'is_event':True, 'params': {}})
		eventRecord = action['events'][-1]

		# ??????
		record = cls.refreshRecord(yyObj, game)  # yy record
		valsumsD = record.setdefault('valsums', {})
		stamps = record.setdefault('stamps', {})
		for csvID in cls.csv():
			cfg = cls.csv(csvID)
			if cfg.taskType != 0:
				continue

			valsumsD[csvID] = valsumsD.get(csvID, 0) + 1
			if valsumsD[csvID] >= cfg.taskParam:
				if csvID not in stamps:
					stamps[csvID] = 1

	@classmethod
	def shop(cls, yyObj, game, csvID, eventIndex, couponUsed):
		'''????

		eventIndex: ????????????????????
		couponUsed: ?????????
		'''

		record = game.role.grid_walk
		huodongID = yyObj.huodongID
		action = record['action']

		if eventIndex >= len(action['events']):
			raise ClientError('bad eventIndex')
		event = action['events'][eventIndex]
		if cls.EventMap[huodongID][event['csv_id']].type != 6:  # ????
			raise ClientError('bad eventIndex')
		for i in range(eventIndex):
			e = action['events'][i]
			if e['csv_id'] == 0:  # ???
				continue
			eventCfg = cls.EventMap[huodongID][e['csv_id']]
			if eventCfg.type == 6 and 'bought' not in e['params']:  # ?? ????
				# ?????????
				raise ClientError('bad eventIndex')

		if csvID == 0:  # ????
			event['params']['bought'] = 0
			return None

		cfg = csv.yunying.grid_walk_shop[csvID]
		if cfg.huodongID != huodongID:
			raise ClientError('wrong huodongID')
		# TODO: ????????????

		# ????
		if couponUsed:
			cost = ObjectCostAux(game, {cls.COUPON_ID:1})
		else:
			cost = ObjectCostAux(game, cfg.prices)
		if not cost.isEnough():
			raise ClientError('not enough resources')
		cost.cost(src='yy_gridwalk_shop_buy')

		# ????????
		event['params']['bought'] = csvID
		eff = ObjectGainAux(game, cfg.items)
		return eff

	@classmethod
	def newAction(cls):
		return {
			'item_used': None,
			'end_pos': None,
			'end_direction_up': None,
			'die_used': None,
			'die_rolled': None,
			'events': [],
		}

	@classmethod
	def getThisAction(cls, yyObj, game):
		'???????,???????????????'

		record = game.role.grid_walk
		action = record['action']
		if action['die_rolled']:  # ???????
			# ?????????
			if action['item_used']:
				record['history'].append({'index':0, 'csv_id':action['item_used'], 'is_event':False, 'params':{}})
			if action['die_rolled']:
				record['history'].append({'index':0, 'csv_id':action['die_used'], 'is_event':False, 'params':{'outcome': action['die_rolled']}})
			record['history'].extend(action['events'])
			while len(record['history']) > cls.MaxHistoryLen:
				record['history'].pop(0)

			# ??????
			record['event_pos'] = 0
			record['action'] = cls.newAction()
		return record['action']

	@classmethod
	def nextTreasure(cls, yyObj, game):
		'?????????'

		huodongID = yyObj.huodongID
		record = game.role.grid_walk
		event = cls.TreasureMap[huodongID]
		treasurePos = (record['pos'] + event.params['dist']) if record['direction_up'] else (record['pos'] - event.params['dist'])
		treasurePos = (len(cls.GridMap[huodongID])+treasurePos-1) % len(cls.GridMap[huodongID]) + 1
		while 1:
			grid = cls.GridMap[huodongID][treasurePos]
			event = cls.EventMap[huodongID].get(grid.event, None)
			if event is None:
				break
			elif event.type in (3, 4):  # ???????????????
				break
			treasurePos += 1 if record['direction_up'] else -1
			treasurePos = (len(cls.GridMap[huodongID]) + treasurePos - 1) % len(cls.GridMap[huodongID]) + 1
		return treasurePos

	@classmethod
	def runEffect(cls, yyObj, game, ignore=False):
		'''????effect

		ignore: ???False,???????????????????'''

		eff = None
		effTreasure = None
		record = game.role.grid_walk
		huodongID = yyObj.huodongID
		for i in xrange(record['event_pos'], len(record['action']['events'])):
			record['event_pos'] = i + 1
			award = cost = None
			event = record['action']['events'][i]
			if event['csv_id'] == 0:
				continue

			cfg = cls.EventMap[huodongID][event['csv_id']]
			if cfg.type == 3:  # ???+
				award = {cls.COIN_ID: cfg.params['num']}
			elif cfg.type == 4:  # ???-
				num = min(game.items.getItemCount(cls.COIN_ID), cfg.params['num'])
				if num > 0:
					cost = {cls.COIN_ID: num}
			elif cfg.type == 1:  # ????
				awardID, awardNum, _ = cfg.params['items'][event['params']['outcome']]
				award = {awardID: awardNum}
			elif cfg.type == 2:  # ???
				awardID, awardNum, _ = cfg.params['items'][event['params']['outcome']]
				num = min(game.items.getItemCount(awardID), awardNum)
				if num > 0:
					cost = {awardID: num}
			elif cfg.type == 99:  # ??
				effTreasure = ObjectGainAux(game, cfg.params['awards'])

			if award is not None:
				if eff:
					eff += ObjectGainAux(game, award)
				else:
					eff = ObjectGainAux(game, award)
			elif cost is not None:
				cost = ObjectCostAux(game, cost)
				cost.cost(src='yy_gridwalk_runeffect_cost')

			if cfg.type == 6 and not ignore:  # ??
				break

		return eff, effTreasure

	@classmethod
	def refreshRecord(cls, yyObj, game, init=None):
		if game.role.grid_walk is None:
			game.role.grid_walk = {}
		record = game.role.grid_walk
		if not record or (record and record['yy_id'] != yyObj.id):
			record['yy_id'] = yyObj.id
			record['direction_up'] = True
			record['pos'] = 1
			record['treasure'] = cls.nextTreasure(yyObj, game)
			record['history'] = []
			record['action'] = cls.newAction()
			record['event_pos'] = 0

		record = cls.getRecord(yyObj.id, game)
		ndi = todayinclock5date2int()
		if ndi != record.get('lastday', None):
			# ????????
			tasksCsv = cls.csv()
			initStamps = {csvID:record['stamps'][csvID] for csvID in tasksCsv if tasksCsv[csvID].taskType == 0 and csvID in record.get('stamps', {})}
			initValsums = {csvID:record['valsums'][csvID] for csvID in tasksCsv if tasksCsv[csvID].taskType == 0 and csvID in record.get('valsums', {})}
			initValinfo = {csvID:record['valinfo'][csvID] for csvID in tasksCsv if tasksCsv[csvID].taskType == 0 and csvID in record.get('valinfo', {})}
			init = init if init else {'stamps':initStamps, 'valsums':initValsums, 'valinfo':initValinfo}  # ???????
			init['lastday'] = ndi
			record = cls.setRecord(yyObj.id, game, init)
		return record

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.grid_walk_tasks
		return csv.yunying.grid_walk_tasks[csvID]

	@classmethod
	def getRegainMailEffect(cls, yyObj, game):
		record = cls.getExistedRecord(yyObj.id, game)
		if record is None or 'stamps' not in record:
			return None

		ids = filter(lambda x:record['stamps'][x] == 1 and cls.csv(x).taskType == 0, record['stamps'])
		if not ids:
			return None

		def _afterGain():
			for csvID in ids:
				record['stamps'][csvID] = 0 # ???

		eff = ObjectGainAux(game, {})
		for csvID in ids:
			eff += ObjectGainAux(game, cls.csv(csvID).award)

		from game.mailqueue import ObjectMailEffect as ObjectYYHuoDongMailEffect
		subject = csv.mail[YYHuodongMailID].subject % (yyObj.desc,)
		mail = game.role.makeMyMailModel(YYHuodongMailID, subject=subject, attachs=eff.result)
		return ObjectYYHuoDongMailEffect(mail, _afterGain)

#
# ObjectYYHuoDongMonopoly
#

class ObjectYYHuoDongMonopoly(ObjectYYGeneralTask):
	'''
	???
	'''

	# ??huodongID??????
	GridMap = {}
	MaxHistoryLen = 6

	@classmethod
	def classInit(cls):
		cls.GridMap = {}

		for idx in csv.yunying.grid_walk_map:
			cfg = csv.yunying.grid_walk_map[idx]
			cls.GridMap.setdefault(cfg.huodongID, {})[cfg.index] = cfg

		super(ObjectYYHuoDongMonopoly, cls).classInit()

	

	@classmethod
	def newAction(cls):
		return {
			'item_used': None,
			'end_pos': None,
			'end_direction_up': None,
			'die_used': None,
			'die_rolled': None,
			'events': [],
		}

	@classmethod
	def getThisAction(cls, yyObj, game):
		'???????,???????????????'
		record = game.role.monopoly
		action = record['action']

		if action['die_rolled']:
			if action['item_used']:
				record['history'].append({
					'index': 0,
					'csv_id': action['item_used'],
					'is_event': False,
					'params': {}
				})
			if action['die_rolled']:
				record['history'].append({
					'index': 0,
					'csv_id': action['die_used'],
					'is_event': False,
					'params': {'outcome': action['die_rolled']}
				})
			record['history'].extend(action['events'])
			while len(record['history']) > cls.MaxHistoryLen:
				record['history'].pop(0)

			record['event_pos'] = 0
			record['action'] = cls.newAction()
		return record['action']

	@classmethod
	def refreshRecord(cls, yyObj, game, init=None):
		# ensure property exists in role._db
		if 'monopoly' not in game.role._db or game.role.monopoly is None:
			game.role.monopoly = {}

		record = game.role.monopoly

		# init when empty or different yy activity
		if not record or record.get('yy_id') != yyObj.id:
			record = {
				'yy_id': yyObj.id,
				'pos': 1,
				'action': cls.newAction(),
				'event_pos': 0,
				'history': [],
				'cycle': 0,
				'rewarded': [],
			}
			# write back to role so DB wrapper sees it
			game.role.monopoly = record

		# make sure required keys always exist (handles old partial records)
		record.setdefault('yy_id', yyObj.id)
		record.setdefault('pos', 1)

		if 'action' not in record or not isinstance(record['action'], dict):
			record['action'] = cls.newAction()
		else:
			act = record['action']
			act.setdefault('steps', 0)
			act.setdefault('end_pos', None)
			act.setdefault('events', [])

		record.setdefault('event_pos', 0)
		record.setdefault('history', [])
		record.setdefault('cycle', 0)
		record.setdefault('rewarded', [])

		# daily rollover handling (keep previous behavior, but robust)
		ndi = todayinclock5date2int()
		if ndi != record.get('lastday', None):
			tasksCsv = cls.csv().to_dict()
			initStamps = {}
			initValsums = {}
			initValinfo = {}
			if tasksCsv:
				for csvID, cfg in tasksCsv.items():
					# only keep milestone/taskType==0 as original logic intended
					if getattr(cfg, 'taskType', None) == 0 and csvID in record.get('stamps', {}):
						initStamps[csvID] = record['stamps'][csvID]
						initValsums[csvID] = record.get('valsums', {}).get(csvID, 0)
						initValinfo[csvID] = record.get('valinfo', {}).get(csvID, {})
			init = init if init else {'stamps': initStamps, 'valsums': initValsums, 'valinfo': initValinfo}
			init['lastday'] = ndi
			# setRecord should persist correctly and return the new record
			record = cls.setRecord(yyObj.id, game, init)
			record.setdefault('yy_id', yyObj.id)
			record.setdefault('pos', 1)
			record.setdefault('action', cls.newAction())
			record.setdefault('event_pos', 0)
			record.setdefault('history', [])
			record.setdefault('cycle', 0)
			record.setdefault('rewarded', [])

		return record

	@classmethod
	def itemUse(cls, yyObj, game, itemID, count=1):
		record = cls.refreshRecord(yyObj, game)
		huodongID = yyObj.huodongID
		action = cls.getThisAction(yyObj, game)

		# Tr? item
		cost = ObjectCostAux(game, {itemID: count})
		if not cost.isEnough():
			raise ClientError('not enough items')
		cost.cost(src='yy_monopoly_item_cost')

		action['item_used'] = itemID
		action['die_used'] = itemID

		total_steps = 0
		for _ in range(count):
			steps = random.randint(1, 6)
			total_steps += steps

		for _ in range(total_steps):
			record['pos'] = (record['pos'] % len(cls.GridMap[huodongID])) + 1

		cfg = cls.GridMap[huodongID][record['pos']]
		action['events'] = [{
			'csv_id': cfg.id,
			'index': record['pos'],
			'is_event': False,
			'params': {},
		}]
		action['die_rolled'] = total_steps
		action['end_pos'] = record['pos']

		# T�nh rewards th?t
		effect = cls.runEffect(yyObj, game)
  
		yyCfg = csv.yunying.yyhuodong[yyObj.id]
		extraItemID = yyCfg.paramMap.get('exchangeItem', None)
		extra = {}
		if extraItemID:
			extra[extraItemID] = count  # m?i lu?t d�ng item du?c count item extra

		return effect, extra

	@classmethod
	def runEffect(cls, yyObj, game, ignore=False):
		record = game.role.monopoly
		huodongID = yyObj.huodongID

		eff = ObjectGainAux(game, {})
		grids_list = []

		events = record['action']['events']
		start_pos = record.get('event_pos', 0)

		for i in range(start_pos, len(events)):
			event = events[i]
			record['event_pos'] = i + 1

			try:
				cfg = cls.GridMap[huodongID][event['index']]
			except Exception as e:
				logger.error("GridMap lookup failed: %s", e)
				cfg = None

			if cfg and getattr(cfg, 'awards', None):
				eff += ObjectGainAux(game, cfg.awards)
				for itemID, num in cfg.awards.items():
					grids_list.append((itemID, num))

		return eff


	@classmethod
	def getLapTasks(cls):
		data = cls.csv().to_dict()
		

		if not data:
			return {}
		return {
			csvID: cfg
			for csvID, cfg in data.items()
			if not getattr(cfg, 'taskType', None)  # milestone
		}

	@classmethod
	def makeTaskList(cls, game):
		# task thu?ng
		tasks = {csvID: cfg for csvID, cfg in cls.csv().items() if cfg.taskType}
		return tasks

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.grid_walk_tasks
		return csv.yunying.grid_walk_tasks[csvID]

	@classmethod
	def getRegainMailEffect(cls, yyObj, game):
		record = cls.getExistedRecord(yyObj.id, game)
		if record is None or 'stamps' not in record:
			return None

		ids = list(filter(lambda x: record['stamps'][x] == 1, record['stamps']))
		if not ids:
			return None

		def _afterGain():
			for csvID in ids:
				record['stamps'][csvID] = 0

		eff = ObjectGainAux(game, {})
		for csvID in ids:
			eff += ObjectGainAux(game, cls.csv(csvID).award)

		from game.mailqueue import ObjectMailEffect as ObjectYYHuoDongMailEffect
		subject = csv.mail[YYHuodongMailID].subject % (yyObj.desc,)
		mail = game.role.makeMyMailModel(YYHuodongMailID, subject=subject, attachs=eff.result)
		return ObjectYYHuoDongMailEffect(mail, _afterGain)

#
# ObjectYYBraveChallenge
#

class ObjectYYBraveChallenge(ObjectYYBase):
	'''
	????
	'''
	AchievementMap = {}  # {groupID: type: [(csvID, target1, target2)...]}}
	StarAttrAdd = {}
	OpenTime = {}  # ????????

	# ??????
	Trainer = None
	Explorer = None
	UnionSkills = None
	TalentTree = None

	# cache
	NormalBraveChallengeStartTime = 0

	@classmethod
	def classInit(cls):
		cls.AchievementMap = {}

		for csvID in csv.brave_challenge.achievement:
			cfg = csv.brave_challenge.achievement[csvID]
			cls.AchievementMap.setdefault(cfg.groupID, {}).setdefault(cfg.targetType, []).append([csvID, cfg.targetArg1, cfg.targetArg2])

		trainer_attr_skills = {}
		explorers = {}
		components = {}
		union_skills = {}
		talentTree = {}
		for i in csv.brave_challenge.team:
			cfg = csv.brave_challenge.team[i]
			if cfg.system == "union_skill":
				union_skills[cfg.csvID] = cfg.level
			elif cfg.system == "explorer":
				explorers[cfg.csvID] = {"advance": cfg.level}
			elif cfg.system == "component":
				components[cfg.csvID] = cfg.level
			elif cfg.system == "attr_skills":
				trainer_attr_skills[cfg.csvID] = cfg.level
			elif cfg.system == "talent":
				tree = {}
				for csvID in csv.talent:
					if csv.talent[csvID].treeID == cfg.csvID:
						tree[csvID] = cfg.level
				talentTree[cfg.csvID] = tree
		cls.Trainer = FakeTrainer(trainer_attr_skills)
		cls.Explorer = FakeExplorer(explorers, components)
		cls.UnionSkills = FakeUnionSkills(union_skills)
		cls.TalentTree = FakeTalentTree(talentTree)

		cls.StarAttrAdd = {}
		for i in csv.brave_challenge.cards:
			cfg = csv.brave_challenge.cards[i]
			cardCfg = csv.cards[cfg.cardID]
			mega = 1 if cardCfg.megaIndex else 0
			for idx, star in enumerate(cfg.starUnlock):
				cls.StarAttrAdd[(cardCfg.cardMarkID, mega, star)] = cfg.addAttributes[idx]

		cls.OpenTime = {}
		for i in csv.brave_challenge.open:
			cfg = csv.brave_challenge.open[i]
			cls.OpenTime[framework.__language__] = cfg.startTime


	@classmethod
	def getRecord(cls, yyID, game):
		if yyID == NormalBraveChallengePlayID:
			record = game.role.normal_brave_challenge
		else:
			record = game.role.yyhuodongs.setdefault(yyID, {})
		return record

	@classmethod
	def getBaseCfg(cls, yyID):
		if yyID == NormalBraveChallengePlayID:
			baseCfg = csv.brave_challenge.base[ObjectServerGlobalRecord.Singleton.normal_brave_challenge.get('baseCfgID', 0)]
		else:
			baseCfg = csv.brave_challenge.base[1]
		return baseCfg

	@classmethod
	def getGameBeginDateTime(cls, game, yyID):
		if yyID == NormalBraveChallengePlayID:
			if cls.NormalBraveChallengeStartTime:
				gameBeginDateTime = cls.NormalBraveChallengeStartTime
			else:
				gameBeginDateTime = datetime.datetime.combine(
					int2date(ObjectServerGlobalRecord.Singleton.normal_brave_challenge['startTime']),
					globaldata.DailyRecordRefreshTime
				)
				cls.NormalBraveChallengeStartTime = gameBeginDateTime
		else:
			yyObj = ObjectYYHuoDongFactory.getConfig(yyID)
			gameBeginDateTime = yyObj.gameBeginDateTime(game)
		return gameBeginDateTime

	# ??????????
	@classmethod
	def isTimesLimit(cls, game, yyID):
		record = cls.getRecord(yyID, game)
		baseCfg = cls.getBaseCfg(yyID)
		if 0 < baseCfg.timesLimit + record['info']['buyTimes'] <= record['info']['times']:
			return True
		return False

	@classmethod
	def addTimes(cls, game, yyID):
		record = cls.getRecord(yyID, game)
		record['info']['times'] += 1

	@classmethod
	def checkBuyTimes(cls, game, yyID):
		record = cls.getRecord(yyID, game)
		baseCfg = cls.getBaseCfg(yyID)
		if record['info']['buyTimes'] < baseCfg.buyTimes:
			return True
		return False

	@classmethod
	def addBuyTimes(cls, game, yyID):
		record = cls.getRecord(yyID, game)
		record['info']['buyTimes'] += 1

	@classmethod
	def isTodayFirst(cls, game, yyID):
		record = cls.getRecord(yyID, game)
		baseCfg = cls.getBaseCfg(yyID)
		info = record.setdefault('info', {})

		# ??????????????
		if baseCfg.isDailyBadge and not info.get('dailyBadge', 1):
			info['dailyBadge'] = 1
			# ??????????2??
			weight = 0
			dt = cls.getGameBeginDateTime(game, yyID)
			days = todayinclock5elapsedays(dt) + 1
			for start, end, weight in baseCfg.dailyWeightUp:
				if start <= days < end:
					break
			return True, weight
		return False, 0

	@classmethod
	@coroutine
	def onBraveChallengeEvent(cls, event, data, sync):
		logger.info("ObjectYYBraveChallenge.onEvent %s, %d", event, data.get('playType', -1))

		ret = {}
		# playType ????  0: ????  1: ?????
		if data['playType'] == 0:
			if event == 'yy_info':
				baseCfg = cls.getBaseCfg(NormalBraveChallengePlayID)
				if baseCfg:
					ret = {
						'yyID': NormalBraveChallengePlayID,
						'baseCfg': baseCfg.id,
						'beginDate':  ObjectServerGlobalRecord.Singleton.normal_brave_challenge.get('startTime', 0),
						'isDailyUnlockCard': baseCfg.isDailyUnlockCard,
					}

			elif event == 'calc_cards':
				cards = yield cls.calcCards(data["csvIDs"])
				ret = {
					'cards': cards,
					'yyID': NormalBraveChallengePlayID,
				}
		else:
			if event == 'yy_info':
				yyID = ObjectYYHuoDongFactory.getBraveChallengeOpenID()
				ret = {
					'yyID': yyID,
					'baseCfg': 1,
				}
				if yyID:
					baseCfg = cls.getBaseCfg(yyID)
					cfg = csv.yunying.yyhuodong[yyID]
					ret.update({
						'beginDate': cfg.beginDate,
						'isDailyUnlockCard': baseCfg.isDailyUnlockCard
					})
			elif event == 'calc_cards':
				cards = yield cls.calcCards(data["csvIDs"])
				ret = {
					'cards': cards,
					'yyID': ObjectYYHuoDongFactory.getBraveChallengeOpenID(),
				}

		raise Return(ret)

	@classmethod
	def activeBraveChallenge(cls, yyID):
		Session.startBraveChallengeYYActive(yyID)

	@classmethod
	def refreshRecord(cls, yyID, game, init=None):
		baseCfg = cls.getBaseCfg(yyID)
		if not baseCfg:
			ObjectServerGlobalRecord.refreshNormalBraveChallenge()
			return
		record = cls.getRecord(yyID, game)
		ndi = todayinclock5date2int()

		if yyID == NormalBraveChallengePlayID:
			startTime = ObjectServerGlobalRecord.refreshNormalBraveChallenge()
			# ???? and ??????????
			if startTime != 0 and startTime != record.get('info', {}).get('startTime', 0):
				if record:
					record.clear()
					day = (int2date(ndi) - int2date(startTime)).days + 1
					info = record.setdefault('info', {
						'times': max(0, baseCfg.timesLimit - baseCfg.addTimes*day),  # ???????(??????)
					})
				else:
					# ????????????????
					info = record.setdefault('info', {
						'times': baseCfg.timesLimit - baseCfg.addTimes,  # ???????(??????)
					})
				info.update({
					"gold": 0,
					'buyTimes': 0,  # ?????(??????)
					'dailyBadge': 0,  # ??????
					'startTime': startTime,  # ????????
				})
				record['lastday'] = ndi
				cls.NormalBraveChallengeStartTime = datetime.datetime.combine(int2date(startTime), globaldata.DailyRecordRefreshTime)
			info = record.get('info', {})
		else:
			info = record.setdefault('info', {
				"gold": 0,
				'times': 0,  # ???????(??????)
				'buyTimes': 0,  # ?????(??????)
				'dailyBadge': 0,  # ??????
			})

		if ndi != record.get('lastday', None):
			if baseCfg.isDailyRecover:  # ?????
				if record.get('lastday', None):
					day = (int2date(ndi) - int2date(record['lastday'])).days
				else:
					day = 0
				info['times'] = max(0, info.get('times', 0) - baseCfg.addTimes*day - info.get("buyTimes", 0))  # ??????
			else:  # ????
				info['times'] = 0
			info['dailyBadge'] = 0  # ??????
			info['buyTimes'] = 0
			record['lastday'] = ndi

		return record

	@classmethod
	def active(cls, yyObj, game, typ, val):
		if yyObj is None:  # ????
			if not game.role.normal_brave_challenge_record_db_id:
				return
			yyID = NormalBraveChallengePlayID
		else:  # ?????
			if not game.role.brave_challenge_record_db_id:
				return
			yyID = yyObj.id

		record = cls.refreshRecord(yyID, game)
		baseCfg = cls.getBaseCfg(yyID)
		stampsD = record.setdefault("stamps", {})
		valSumsD = record.setdefault("valsums", {})
		for csvID, target1, target2 in cls.AchievementMap.get(baseCfg.achiSeqID, {}).get(typ, []):
			if stampsD.get(csvID, None) is not None:
				continue
			flag = False
			# ????
			if typ in BraveChallengeDefs.TypeCount:
				valSumsD[csvID] = valSumsD.get(csvID, 0) + val
				if valSumsD[csvID] >= target1:
					flag = True
			# ??????
			elif typ == BraveChallengeDefs.UnlockCard:
				if target1 == val:
					flag = True
			# ???????
			elif typ == BraveChallengeDefs.PassRound:
				if valSumsD.get(csvID, 0) == 0 or valSumsD[csvID] > val:
					valSumsD[csvID] = val
				if valSumsD[csvID] <= target1:
					flag = True
			if flag:
				stampsD[csvID] = 1
		return

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.brave_challenge.achievement
		return csv.brave_challenge.achievement[csvID]

	@classmethod
	def getBuyCost(cls, game, yyID):
		record = cls.getRecord(yyID, game)
		baseCfg = cls.getBaseCfg(yyID)
		times = record['info']['buyTimes']
		lst = baseCfg.buyCost
		maxT = min(len(lst) - 1, times)
		return lst[maxT]

	@classmethod
	def getGold(cls, yyID, game, award):
		record = cls.getRecord(yyID, game)
		baseCfg = cls.getBaseCfg(yyID)

		info = record.setdefault("info", {"gold": 0})
		# ??????
		eff = ObjectGainAux(game, award)
		if info["gold"] + award.get("gold", 0) > baseCfg.goldLimit:
			eff.gold = baseCfg.goldLimit - info["gold"]
		info["gold"] += eff.gold
		return eff

	@classmethod
	def getEffect(cls, yyID, csvID, game):
		record = cls.getRecord(yyID, game)
		if record is None or 'stamps' not in record:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		if record['stamps'].get(csvID, None) != 1:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		if not record['stamps'].get(csvID, 0):
			raise ClientError(ErrDefs.yyHuoDongAlreadyGet)

		def _afterGain():
			record['stamps'][csvID] = 0 # ???
		return ObjectYYHuoDongEffect(game, cls.csv(csvID).award, _afterGain)

	@classmethod
	@coroutine
	def calcCards(cls, csvIDs):
		"""
		??????
		"""
		from game.object.game import ObjectCard

		cards = {}  # {cardID: {}}
		fakeCard = ObjectCard(None, None)
		fakeCard.new_deepcopy()
		for csvID in csvIDs:
			cfg = csv.brave_challenge.cards[csvID]
			cardID = cfg.cardID
			if cardID not in csv.cards:
				continue

			setRobotCard(fakeCard, cardID, cfg.advance, cfg.star, cfg.level,
				character=0,
				nvalue=cfg.nvalue,
				abilities=cfg.abilities,
				skillLevels=cfg.skillLevels,
				equipStar=cfg.equipStar,
				equipLevel=cfg.equipLevel,
				equipAwake=cfg.equipAwake,
				equipAdvance=cfg.equipAdvance)
			cardCfg = csv.cards[cardID]
			fetters = cardCfg.fetterList if cfg.fetters else None
			ObjectCard.calcStarEffectAttrsAddition(fakeCard)
			ObjectCard.calcFettersAttrsAddition(fakeCard, fetters)
			ObjectCard.calcTrainerAttrSkillAddition(fakeCard, cls.Trainer)
			ObjectCard.calcExplorerAttrsAddition(fakeCard, cls.Explorer)
			ObjectCard.calcExplorerComponentAttrsAddition(fakeCard, cls.Explorer)
			ObjectCard.calcUnionSkillAttrsAddition(fakeCard, cls.UnionSkills)
			ObjectCard.calcTalentAttrsAddition(fakeCard, cls.TalentTree)
			ObjectCard.calcZawakeAttrsAddition(fakeCard, FakeZawake(cardCfg.zawakeID, cfg.zawake))
			model = fakeCard.battleModel(False, False, SceneDefs.BraveChallenge, explorer=cls.Explorer)
			for attr in AttrDefs.attrsEnum[1:]:
				if attr in cfg and cfg[attr]:
					constVal, percentVal = str2num_t(cfg[attr])
					if constVal > 0:
						model["attrs"][attr] += constVal
					if percentVal > 0:
						model["attrs"][attr] *= percentVal
			model["fighting_point"] = ObjectCard.calcFightingPoint(fakeCard, model["attrs"])
			cards[csvID] = model
			yield moment
		raise Return(cards)

	# ?????
	@classmethod
	def extraAttrBonus(cls, yyID, game, cards):
		# ??????
		cardAttrs = {}

		baseCfg = cls.getBaseCfg(yyID)
		if baseCfg.isStarAttrAdd:
			for csvID in cards:
				if not csvID:
					continue
				cardCfg = csv.cards[csv.brave_challenge.cards[csvID].cardID]
				# ??????
				cards = game.cards.getCardsByMarkID(cardCfg.cardMarkID)  # ???????
				if cardCfg.megaIndex:
					cards = filter(lambda c: bool(cardCfg.megaIndex) == c.isMega, cards)
				if not cards:
					continue
				isMega = 1 if bool(cardCfg.megaIndex) else 0
				maxStar = max(map(lambda c: c.star, cards))
				# ?????????
				addAttr = cls.getStarAttrCfg(cardCfg.cardMarkID, isMega, maxStar)
				if not addAttr:
					continue
				model = cardAttrs.setdefault(csvID, {})
				constVal, percentVal = str2num_t(addAttr)
				for attr in ['hp', 'damage', 'specialDamage', 'defence', 'specialDefence', 'speed']:
					if constVal > 0:
						model[attr] = (0, constVal)
					if percentVal > 0:
						model[attr] = (1, percentVal)
		return cardAttrs

	@classmethod
	def getStarAttrCfg(cls, cardMarkID, isMega, maxStar):
		for star in xrange(maxStar, 0, -1):
			key = (cardMarkID, isMega, star)
			if key in cls.StarAttrAdd:
				return cls.StarAttrAdd[key]
		return None

	@classmethod
	def transform2list(cls, d, least=6):
		if isinstance(d, dict):
			return [d.get(i, 0) for i in xrange(1, least + 1)]
		else:
			if len(d) < least:
				d += [0 for _ in xrange(least - len(d))]
			return d


#
# ObjectYYHorseRace
#
class ObjectYYHorseRace(ObjectYYBase):
	"""
	??
	"""

	PointAwardMap = {}  # {huodongID: {csvID: cfg}}
	BetAwardMap = {}  # {(huodongID, rank): cfg}

	@classmethod
	def classInit(cls):
		cls.PointAwardMap = {}
		cls.BetAwardMap = {}

		for idx in sorted(csv.yunying.horse_race_point_award.keys()):
			cfg = csv.yunying.horse_race_point_award[idx]
			hd = cls.PointAwardMap.setdefault(cfg.huodongID, {})
			hd[idx] = cfg

		for idx in sorted(csv.yunying.horse_race_bet_award.keys()):
			cfg = csv.yunying.horse_race_bet_award[idx]
			cls.BetAwardMap.setdefault((cfg.huodongID, cfg.rank), cfg)

	@classmethod
	def onClose(cls):
		# ?????????
		ObjectServerGlobalRecord.setHorseRaceCrossKey("")

	@classmethod
	def getPointAwardEffect(cls, yyID, game, csvID):
		'''
		??????
		'''
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		horseRace = record.setdefault('horse_race', {})
		pointAward = horseRace.setdefault('point_award', {})
		flag = pointAward.get(csvID, -1)
		if flag == -1:
			raise ClientError('no award')
		elif flag == 0:
			raise ClientError('do not get award again')

		yyCfg = csv.yunying.yyhuodong[yyID]
		awardCfg = cls.PointAwardMap[yyCfg.huodongID][csvID]

		def _afterGain():
			pointAward[csvID] = 0

		return ObjectYYHuoDongEffect(game, awardCfg.award, _afterGain)

	@classmethod
	def getBetAwardEffect(cls, yyID, game, date, play):
		'''
		??????
		'''
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		horseRace = record.setdefault('horse_race', {})
		betAward = horseRace.setdefault('bet_award', {})
		dateBetAward = betAward.get(date, {})
		idx, rank, flag = dateBetAward.get(play, (0, 0, -1))
		if flag == -1:
			raise ClientError('no award')
		elif flag == 0:
			raise ClientError('do not get award again')

		yyCfg = csv.yunying.yyhuodong[yyID]
		cfg = cls.BetAwardMap[(yyCfg.huodongID, rank)]

		def _afterGain():
			dateBetAward[play] = (idx, rank, 0)
			betAward[date] = dateBetAward

		return ObjectYYHuoDongEffect(game, cfg.award, _afterGain)

	@classmethod
	def refreshBetAward(cls, yyID, game, history):
		'''
		??????
		'''
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		horseRace = record.setdefault('horse_race', {})
		betAward = horseRace.setdefault('bet_award', {})
		point = horseRace.setdefault('point', 0)
		yyCfg = csv.yunying.yyhuodong[yyID]
		isAdd = False
		for date, dateBetAward in betAward.iteritems():
			for play, awards in dateBetAward.iteritems():
				idx, rank, flag = awards
				# ???????? (?????? ???)
				if flag == -1:
					playCards = history.get(date, {}).get(play, [])
					if playCards:  # ????????
						cardObj = playCards[idx]
						rank = cardObj.get('result', 0)
						betAward[date][play] = (idx, rank, 1)
						# ?????
						cfg = cls.BetAwardMap[(yyCfg.huodongID, rank)]
						point = point + cfg.point
						isAdd = True
						game.achievement.onYYCount(yyID, AchievementDefs.HorseBetRightTimes, 1, rank)
		if isAdd:
			horseRace['point'] = point
			# ??????
			pointAward = horseRace.setdefault('point_award', {})
			for csvID, cfgPoint in cls.PointAwardMap[yyCfg.huodongID].iteritems():
				if point >= cfgPoint.point and (csvID not in pointAward):
					pointAward[csvID] = 1
		return isAdd, point

	@classmethod
	def isCanBetCard(cls, yyID, game, date, play):
		'''
		?? ????
		'''
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		horseRace = record.get('horse_race', {})
		betAward = horseRace.get('bet_award', {})
		dateBetAward = betAward.get(date, {})
		if play in dateBetAward:
			raise ClientError("can not bet again")

	@classmethod
	def setBetCard(cls, yyID, game, date, play, idx):
		'''
		???? idx??
		'''
		record = cls.getExistedRecord(yyID, game)
		if record is None:
			raise ClientError(ErrDefs.yyHuoDongNoActive)
		horseRace = record.setdefault('horse_race', {})
		betAward = horseRace.setdefault('bet_award', {})

		dateBetAward = betAward.setdefault(date, {})
		dateBetAward[play] = (idx, 0, -1)

	@classmethod
	def getRegainMailEffect(cls, yyObj, game):
		'''
		???? ????????
		'''
		yyID = yyObj.id
		yyCfg = csv.yunying.yyhuodong[yyID]
		eff = ObjectGainAux(game, {})
		hasAward = False

		record = cls.getExistedRecord(yyID, game)
		if record is None:
			return None
		horseRace = record.setdefault('horse_race', {})
		betAward = horseRace.setdefault('bet_award', {})
		for date, dateBetAward in betAward.iteritems():
			for play, awards in dateBetAward.iteritems():
				idx, rank, flag = awards
				if flag == 1:
					cfg = cls.BetAwardMap[(yyCfg.huodongID, rank)]
					eff += ObjectGainAux(game, cfg.award)
					hasAward = True
		pointAward = horseRace.setdefault('point_award', {})
		for csvID, cfg in cls.PointAwardMap[yyCfg.huodongID].iteritems():
			flag = pointAward.get(csvID, -1)
			if flag == 1:
				eff += ObjectGainAux(game, cfg.award)
				hasAward = True

		if not hasAward:
			return None

		def _afterGain():
			for date, dateBetAward in betAward.iteritems():
				for play, awards in dateBetAward.iteritems():
					idx, rank, flag = awards
					betAward[date][play] = (idx, rank, 0)
			for csvID in pointAward:
				pointAward[csvID] = 0

		from game.mailqueue import ObjectMailEffect as ObjectYYHuoDongMailEffect
		subject = csv.mail[YYHuodongMailID].subject % (yyObj.desc,)
		mail = game.role.makeMyMailModel(YYHuodongMailID, subject=subject, attachs=eff.result)
		return ObjectYYHuoDongMailEffect(mail, _afterGain)


#
# ObjectYYDispatch
#
class ObjectYYDispatch(ObjectYYGeneralTask):
	"""
	??
	"""
	StartTaskMap = {}  # {huodongID: [csvID,...]}
	PreTaskMap = {}  # {huodongID: {preID: [csvID,...]}}
	DispatchTask = {}  # {huodongID: {type: [[csvID, target],...]}}
	DailyTask = {} # {huodongID: [csvID,...]}

	@classmethod
	def classInit(cls):
		cls.StartTaskMap = {}
		cls.PreTaskMap = {}
		cls.DispatchTask = {}
		cls.DailyTask = {}

		for csvID in csv.yunying.dispatch:
			cfg = csv.yunying.dispatch[csvID]
			if cfg.preID == 0:
				cls.StartTaskMap.setdefault(cfg.huodongID, []).append(csvID)
			else:
				cls.PreTaskMap.setdefault(cfg.huodongID, {}).setdefault(cfg.preID, []).append(csvID)

		for csvID in csv.yunying.dispatch_task:
			cfg = csv.yunying.dispatch_task[csvID]
			if cfg.type == YYDispatchDefs.DailyType:
				cls.DailyTask.setdefault(cfg.huodongID, []).append(csvID)
			else:
				cls.DispatchTask.setdefault(cfg.huodongID, {}).setdefault(cfg.type, []).append([csvID, cfg.taskParam])

		for huodongID, csvIDs in cls.DailyTask.iteritems():
			cls(huodongID, csvIDs)

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.dispatch_task
		return csv.yunying.dispatch_task[csvID]

	@classmethod
	def refreshRecord(cls, yyObj, game):
		record = cls.getRecord(yyObj.id, game)
		dispatch = record.setdefault("dispatch", {})
		if not dispatch:
			for csvID in cls.StartTaskMap[yyObj.huodongID]:
				dispatch[csvID] = {"status": YYDispatchDefs.DispatchEnd, "times": 0, "cards": [], "end_time": 0, "extra": False, "cd_time": 0}

		# ???????
		if game.role.yyDispatchCards is None:
			game.role.yyDispatchCards = set()
			for _, task in record["dispatch"].iteritems():
				for card in task["cards"]:
					game.role.yyDispatchCards.add(card["id"])

		# ??????
		now = todayinclock5date2int()
		if record.get("lastday", None) != now:
			stamps = record.setdefault('stamps', {})
			valsumsD = record.setdefault('valsums', {})
			record["lastday"] = now
			for csvID in cls.DailyTask[yyObj.huodongID]:
				# ????????????
				if csvID in stamps:
					stamps.pop(csvID)
				if csvID in valsumsD:
					valsumsD.pop(csvID)
		return record

	@classmethod
	def getRegainMailEffect(cls, yyObj, game):
		record = cls.getExistedRecord(yyObj.id, game)
		if record is None:
			return None

		stamps = record.get("stamps", {})
		dispatch = record.get("dispatch", {})

		ids = filter(lambda x: stamps[x] == 1, stamps)
		endTime = datetime2timestamp(yyObj.gameEndDateTime(""))
		taskIDs = filter(lambda x: dispatch[x]["status"] == YYDispatchDefs.DispatchStart and dispatch[x]["end_time"] < endTime, dispatch)

		if not (ids or taskIDs):
			return None

		def _afterGain():
			for csvID in ids:
				record["stamps"][csvID] = 0
			for taskID in taskIDs:
				task = dispatch[taskID]
				task["status"] = YYDispatchDefs.DispatchEnd
				task["cards"] = []
				task["times"] += 1
				task["extra"] = False
				task["end_time"] = 0

		eff = ObjectGainAux(game, {})
		for csvID in ids:
			eff += ObjectGainAux(game, cls.csv(csvID).award)

		for taskID in taskIDs:
			cfg = csv.yunying.dispatch[taskID]
			eff += ObjectGainAux(game, cfg.award)
			if dispatch[taskID]["extra"]:
				eff += ObjectGainAux(game, cfg.extraAward)

		from game.mailqueue import ObjectMailEffect as ObjectYYHuoDongMailEffect
		subject = csv.mail[YYHuodongMailID].subject % (yyObj.desc,)
		mail = game.role.makeMyMailModel(YYHuodongMailID, subject=subject, attachs=eff.result)
		return ObjectYYHuoDongMailEffect(mail, _afterGain)

	@classmethod
	def onTaskActive(cls, yyObj, game, typ, val):
		record = cls.refreshRecord(yyObj, game)
		stampsD = record.setdefault("stamps", {})
		valSumsD = record.setdefault("valsums", {})
		for csvID, target in cls.DispatchTask.get(yyObj.huodongID, {}).get(typ, []):
			if csvID in stampsD:
				continue
			flag = False
			if typ == YYDispatchDefs.DispatchType:
				if target == val:
					flag = True
			else:
				valSumsD[csvID] = valSumsD.get(csvID, 0) + val
				if valSumsD[csvID] >= target:
					flag = True
			if flag:
				stampsD[csvID] = 1

	@classmethod
	def checkDispatchTarget(cls, game, cardIDs, typ, params):
		cards = game.cards.getCards(cardIDs)
		target = params[0]
		if typ == YYDispatchDefs.CardCount:
			return len(cards) >= target
		elif typ == YYDispatchDefs.CardMarkID:
			card = game.cards.getCard(cardIDs[0])
			if card and card.markID == target:
				return True
		elif typ == YYDispatchDefs.CardNature2:
			natures = set()
			for card in cards:
				natures.add(card.natureType)
				if card.natureType2:
					natures.add(card.natureType2)
			return natures.issuperset(set(params))
		elif typ == YYDispatchDefs.CardGender:
			# params[:-1]????? params[-1]???
			genders = set(params[:-1])
			count = 0
			for card in cards:
				if card.gender in genders:
					count += 1
				if count >= params[-1]:
					return True
		else:
			num = 0
			count = params[1]
			for card in cards:
				flag = typ == YYDispatchDefs.CardNature and (card.natureType == target or card.natureType2 == target)
				cfg = csv.pokedex[card.card_id]
				flag = typ == YYDispatchDefs.HeightHigh and cfg.heightAndWeight[0] >= target if not flag else flag
				flag = typ == YYDispatchDefs.HeightLow and cfg.heightAndWeight[0] <= target if not flag else flag
				flag = typ == YYDispatchDefs.WeightHeavy and cfg.heightAndWeight[1] >= target if not flag else flag
				flag = typ == YYDispatchDefs.WeightLight and cfg.heightAndWeight[1] <= target if not flag else flag
				flag = typ == YYDispatchDefs.CardFeel and game.role.card_feels.get(card.markID, {"level": 0}) >= target if not flag else flag
				flag = typ == YYDispatchDefs.CardRarity and card.rarity >= target if not flag else flag
				if flag:
					num += 1
				if num >= count:
					return True
		return False

	@classmethod
	def makeDispatchCardModel(cls, game, cardIDs):
		ret = []
		for cardID in cardIDs:
			card = game.cards.getCard(cardID)
			if not card:
				ret.append({})
			else:
				model = {
					"id": card.id,
					"card_id": card.card_id,
					"advance": card.advance,
					"star": card.star,
					"level": card.level,
					"skin_id": card.skin_id
				}
				ret.append(model)
		return ret

	@classmethod
	def beginDispatch(cls, game, yyObj, csvID, cardIDs):
		record = cls.getRecord(yyObj.id, game)
		dispatch = record["dispatch"]
		task = dispatch.get(csvID, None)
		if not task:
			raise ClientError("dispatch task not unlock")

		cfg = csv.yunying.dispatch[csvID]
		num = len(filter(lambda x: dispatch[x]["status"] == YYDispatchDefs.DispatchStart, dispatch))
		# ??????????????
		if cfg.type != YYDispatchDefs.AwardBox and yyObj.paramMap["number"] <= num:
			raise ClientError("dispatch number limit up")
		if cfg.times <= task["times"]:
			raise ClientError("dispatch times limit up")
		if task["status"] == YYDispatchDefs.DispatchStart:
			raise ClientError("dispatch already start")
		if task["cd_time"] > nowtime_t():
			raise ClientError("dispatch in cd")
		if cfg.type != YYDispatchDefs.AwardBox and not cardIDs[0]:
			raise ClientError("dispatch leader miss")
		cardIDs = [cardID for cardID in cardIDs if cardID is not None]
		if len(set(cardIDs)) != len(cardIDs) or game.role.yyDispatchCards & set(cardIDs):
			raise ClientError("dispatch cards error")

		cost = ObjectCostAux(game, cfg.cost)
		if not cost.isEnough():
			raise ClientError("dispatch cost not enough")

		for i in xrange(1, 5):
			targetKey = "target%d" % i
			paramKey = "params%d" % i
			if targetKey not in cfg or not cfg[targetKey]:
				break
			typ = cfg[targetKey]
			params = cfg[paramKey]
			if not cls.checkDispatchTarget(game, cardIDs, typ, params):
				raise ClientError("dispatch not satisfied")

		if cost:
			cost.cost(src="yyDispatch_%d" % yyObj.id)

		if cfg.spTarget:
			task["extra"] = cls.checkDispatchTarget(game, cardIDs, cfg.spTarget, cfg.spParams)
		task["status"] = YYDispatchDefs.DispatchStart
		task["cards"] = cls.makeDispatchCardModel(game, cardIDs)
		task["end_time"] = nowtime_t() + cfg.duration * 60 - cfg.extraTime * 60
		game.role.yyDispatchCards.update(cardIDs)

	@classmethod
	def endDispatch(cls, game, yyObj, csvID, flag):
		record = cls.getRecord(yyObj.id, game)
		dispatch = record["dispatch"]
		cfg = csv.yunying.dispatch[csvID]
		task = dispatch.get(csvID, None)
		if not task:
			raise ClientError("dispatch task not unlock")

		if task["status"] != YYDispatchDefs.DispatchStart:
			raise ClientError("dispatch not start")
		if not flag and task["end_time"] > nowtime_t():
			raise ClientError("dispatch not finish")

		eff = ObjectGainAux(game, {})
		if flag:
			eff += ObjectGainAux(game, cfg.cost)  # ??????????
		else:
			eff += ObjectGainAux(game, cfg.award)
			if task["extra"]:
				eff += ObjectGainAux(game, cfg.extraAward)
				# ??????
				cls.onTaskActive(yyObj, game, YYDispatchDefs.ExtraType, 1)

			# ??
			for taskID in cls.PreTaskMap[yyObj.huodongID].get(csvID, []):
				if dispatch.get(taskID, None):
					continue
				dispatch[taskID] = {"status": YYDispatchDefs.DispatchEnd, "times": 0, "cards": [], "end_time": 0, "extra": False, "cd_time": 0}

			# ??????
			cls.onTaskActive(yyObj, game, YYDispatchDefs.DispatchType, csvID)
			# ????????
			if cfg.type == YYDispatchDefs.BranchDispatch:
				cls.onTaskActive(yyObj, game, YYDispatchDefs.BranchType, 1)
			# ???????
			itemID = yyObj.paramMap.get("item", None)
			if itemID:
				cls.onTaskActive(yyObj, game, YYDispatchDefs.CostType, cfg.cost.get(itemID, 0))

		def _afterGain():
			for card in task["cards"]:
				game.role.yyDispatchCards.remove(card["id"])
			if not flag:
				task["times"] += 1
				task["cd_time"] = task["end_time"] + cfg.cd * 60
			task["cards"] = []
			task["end_time"] = 0
			task["status"] = YYDispatchDefs.DispatchEnd
			task["extra"] = False
		return ObjectYYHuoDongEffect(game, eff.result, _afterGain)



#
# ObjectYYVolleyball
#
class ObjectYYVolleyball(ObjectYYBase):
	'''
	????
	'''

	Tasks = {}  # {huodongID: {targetType: [cfg,...]}}

	@classmethod
	def classInit(cls):
		cls.Tasks = {}

		for csvID in csv.yunying.volleyball_tasks:
			cfg = csv.yunying.volleyball_tasks[csvID]
			cls.Tasks.setdefault(cfg.huodongID, {}).setdefault(cfg.targetType, []).append(cfg)

	@classmethod
	def refreshRecord(cls, yyObj, game):

		ndi = todayinclock5date2int()
		record = cls.getRecord(yyObj.id, game)
		record.setdefault('info', {
			'start_time': 0,
		})

		# ??????
		if ndi != record.get('lastday', None):
			stampsD = record.setdefault('stamps', {})
			valsumsD = record.setdefault('valsums', {})
			valsums1D = record.setdefault('valsums1', {})
			record['lastday'] = ndi
			for cfgL in cls.Tasks[yyObj.huodongID].itervalues():
				for cfg in cfgL:
					if cfg.type == 1:
						stampsD.pop(cfg.id, None)
						if cfg.targetType in YYVolleyballDefs.cardIDTypes:
							valsums1D.pop(cfg.targetType, None)
						else:
							valsumsD.pop(cfg.targetType, None)

		return record

	@classmethod
	def active(cls, yyObj, game):
		cls.refreshRecord(yyObj, game)

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.volleyball_tasks
		return csv.yunying.volleyball_tasks[csvID]

	@classmethod
	def recordStartTime(cls, yyID, game):  # ????????,?????
		record = cls.getRecord(yyID, game)
		record['info']['start_time'] = int(nowtime_t())

	@classmethod
	def isCheat(cls, yyObj, game, clientDuration):  # ?????,????????????????????????????
		record = cls.getExistedRecord(yyObj.id, game)
		# start_time?????,?0,??????
		startTime = record['info']['start_time']
		if not startTime:
			return True
		if not clientDuration:
			return True

		# ??start_time
		record['info']['start_time'] = 0
		serverDuration = int(nowtime_t()) - startTime
		if abs(serverDuration - clientDuration) > yyObj.paramMap.get('maxDeltaS', 20):
			return True
		return False

	@classmethod
	def refreshTasks(cls, yyObj, game, result, tasks):
		record = cls.refreshRecord(yyObj, game)
		stampsD = record.setdefault('stamps', {})  # ??
		valSumsD = record.setdefault('valsums', {})  # ????????valsums,??????ID???valsums1
		valSums1D = record.setdefault('valsums1', {})  # {targetType:{cardID:num}}

		valSumsD[YYVolleyballDefs.dailyNum] = valSumsD.get(YYVolleyballDefs.dailyNum, 0) + 1
		valSumsD[YYVolleyballDefs.numOfParticipation] = valSumsD.get(YYVolleyballDefs.numOfParticipation, 0) + 1

		if result == 'win':
			valSumsD[YYVolleyballDefs.dailyVictory] = valSumsD.get(YYVolleyballDefs.dailyVictory, 0) + 1
			valSumsD[YYVolleyballDefs.allVictory] = valSumsD.get(YYVolleyballDefs.allVictory, 0) + 1

		for typ, _ in tasks.iteritems():
			if typ not in YYVolleyballDefs.tasksTypes:
				raise ClientError("tasks'type is incorrect")

		for typ, val in tasks.iteritems():
			if typ in YYVolleyballDefs.cardIDTypes:
				for cfg in cls.Tasks[yyObj.huodongID][typ]:
					if val == cfg.targetArg2 and result == 'win':
						targetType = valSums1D.setdefault(typ, {})
						targetType[val] = targetType.get(val, 0) + 1
			else:
				valSumsD[typ] = valSumsD.get(typ, 0) + val

		# ??????
		for tarTyp, cfgL in cls.Tasks[yyObj.huodongID].iteritems():
			for cfg in cfgL:
				if cfg.id in stampsD:
					continue
				# ????ID????
				if tarTyp not in YYVolleyballDefs.cardIDTypes:
					if cfg.targetArg <= valSumsD.get(tarTyp, 0):
						stampsD[cfg.id] = 1
				else:
					if cfg.targetArg <= valSums1D.get(tarTyp, {}).get(cfg.targetArg2, 0):
						stampsD[cfg.id] = 1

		total = 0  # ??????
		count = 0  # ????????
		for tarTyp, cfgL in cls.Tasks[yyObj.huodongID].iteritems():
			for cfg in cfgL:
				if cfg.type == 1:
					continue
				total += 1
				if tarTyp == YYVolleyballDefs.allSumTaskDone:
					continue
				if cfg.id in stampsD:
					count += 1

		# ?????????????
		cfgL = cls.Tasks[yyObj.huodongID][YYVolleyballDefs.allSumTaskDone]
		cfg = cfgL[0]
		if cfg.id not in stampsD:
			if (total - count) == len(cfgL):
				stampsD[cfg.id] = 1

		valSumsD[YYVolleyballDefs.allSumTaskDone] = count

		return valSumsD.get(YYVolleyballDefs.allVictory, 0)


#
# ObjectYYShavedIce
#
class ObjectYYShavedIce(ObjectYYBase):
	"""
	????
	"""
	Grades = {"perfect": 1, "good": 2, "bad1": 3, "bad2": 4, "bad3": 5}

	@classmethod
	def classInit(cls):
		cls.HuoDongMap = {}

		for csvID in csv.yunying.shaved_ice_base:
			cfg = csv.yunying.shaved_ice_base[csvID]
			if cfg.huodongID == 0:
				continue
			cls(cfg.huodongID, cfg)

	def __init__(self, huodongID, base):
		self.demands = []  # [csvID,...]
		self.cards = []  # [[csvID, weight],...]
		self.items = []  # [[csvID, weight],...]
		self.awards = []  # [cfg,...]

		for csvID in ObjectYYShavedIce.csv():
			cfg = ObjectYYShavedIce.csv(csvID)
			if cfg.huodongID != huodongID:
				continue
			self.demands.append(csvID)

		for csvID in csv.yunying.shaved_ice_cards:
			cfg = csv.yunying.shaved_ice_cards[csvID]
			if cfg.huodongID != huodongID:
				continue
			self.cards.append([csvID, cfg.weight])

		for csvID in csv.yunying.shaved_ice_items:
			cfg = csv.yunying.shaved_ice_items[csvID]
			if cfg.huodongID != huodongID:
				continue
			self.items.append([csvID, cfg.weight])

		for csvID in sorted(csv.yunying.shaved_ice_stage_award.keys(), key=lambda x: csv.yunying.shaved_ice_stage_award[x].score[0]):
			cfg = csv.yunying.shaved_ice_stage_award[csvID]
			if cfg.huodongID != huodongID:
				continue
			self.awards.append(cfg)

		self.base = base
		ObjectYYShavedIce.HuoDongMap[huodongID] = self

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.shaved_ice_demand
		return csv.yunying.shaved_ice_demand[csvID]

	@classmethod
	def prepare(cls, game, yyObj):
		demands = {}
		hd = cls.getHd(yyObj, game)
		guests = WeightRandomObject.onceSample(hd.cards, len(hd.demands))
		choices = WeightRandomObject.onceSample(hd.items, yyObj.paramMap["choiceNum"])
		choices = [i[0] for i in choices]
		for idx, csvID in enumerate(hd.demands):
			cfg = cls.csv(csvID)
			guest, _ = guests[idx]
			demands[cfg.index] = {
				"guest": guest,
				"demand": random.sample(choices, cfg.itemNum),
				"csvID": csvID,
			}
		game.role.shaved_ice_demands = demands
		game.role.shaved_ice = {}
		game.role.shaved_ice_score = 0
		return {
			"choices": choices,
			"demands": demands,
		}

	@classmethod
	def startDemand(cls, game, idx):
		if idx in game.role.shaved_ice:
			raise ClientError("this demand expired")

		if idx not in game.role.shaved_ice_demands:
			raise ClientError("no this demand")

		game.role.shaved_ice_start_time = nowtime_t()

	@classmethod
	def endDemand(cls, game, idx, choices, yyObj, costTime):
		# realTime = nowtime_t() - game.role.shaved_ice_start_time
		# if realTime / costTime > 1.5 and (realTime - costTime) > 1:
		# 	raise ClientError(ErrDefs.cheatError)

		demand = game.role.shaved_ice_demands.get(idx, None)
		if not demand:
			raise ClientError("not this demand")

		if choices == demand["demand"]:
			typ = cls.Grades["perfect"]
		else:
			choices = set(choices)
			errNum = len(choices.difference(set(demand["demand"])))
			if errNum == 0:
				typ = cls.Grades["good"]
			else:
				typ = cls.Grades.get("bad%d" % errNum, 5)

		hd = cls.getHd(yyObj, game)
		cfg = hd.base
		ret = {
			"score": cfg.score[typ] if typ in cfg.score else 0,
			"time": cfg.time[typ] if typ in cfg.score else 0,
			"type": typ,
		}
		game.role.shaved_ice[idx] = ret["score"]
		game.role.shaved_ice_score += ret["score"]
		logger.info("uid %s shavedice yyID %s idx %s awardtime %s score %s", game.role.uid, idx, yyObj.id, ret["time"], ret["score"])
		return ret

	@classmethod
	def quitGame(cls, game, yyObj, score):
		hd = cls.getHd(yyObj, game)
		eff = ObjectGainAux(game, {})
		for cfg in hd.awards:
			if cfg.score[0] <= score < cfg.score[1]:
				eff += ObjectGainAux(game, cfg.award)
				eff += ObjectGainAux(game, cfg.randomAward)

		game.role.shaved_ice_demands = None
		game.role.shaved_ice = None
		game.role.shaved_ice_score = None

		return eff

	@classmethod
	def getBuyCost(cls, yyObj, times):
		lst = yyObj.paramMap["buyCost"]
		maxT = min(len(lst) - 1, times)
		return lst[maxT]

	@classmethod
	def active(cls, yyObj, game):
		cls.refreshRecord(yyObj, game)

	@classmethod
	def refreshRecord(cls, yyObj, game):
		record = cls.getRecord(yyObj.id, game)
		info = record.setdefault("info", {"buy_times": 0, "times": 0})

		lastDay = record.get("lastday", None)
		now = todayinclock5date2int()
		if lastDay != now:
			record["lastday"] = now
			info["times"] = 0
			info["buy_times"] = 0
		return record


#
# ObjectYYSummerChallenge
#
class ObjectYYSummerChallenge(ObjectYYBase):
	"""
	????
	"""
	# ??????
	Trainer = None
	Explorer = None
	UnionSkills = None
	TalentTree = None

	@classmethod
	def classInit(cls):
		cls.HuoDongMap = {}

		trainer_attr_skills = {}
		explorers = {}
		components = {}
		union_skills = {}
		talentTree = {}
		for i in csv.summer_challenge.team:
			cfg = csv.summer_challenge.team[i]
			if cfg.system == "union_skill":
				union_skills[cfg.csvID] = cfg.level
			elif cfg.system == "explorer":
				explorers[cfg.csvID] = {"advance": cfg.level}
			elif cfg.system == "component":
				components[cfg.csvID] = cfg.level
			elif cfg.system == "attr_skills":
				trainer_attr_skills[cfg.csvID] = cfg.level
			elif cfg.system == "talent":
				tree = {}
				for csvID in csv.talent:
					if csv.talent[csvID].treeID == cfg.csvID:
						tree[csvID] = cfg.level
				talentTree[cfg.csvID] = tree
		cls.Trainer = FakeTrainer(trainer_attr_skills)
		cls.Explorer = FakeExplorer(explorers, components)
		cls.UnionSkills = FakeUnionSkills(union_skills)
		cls.TalentTree = FakeTalentTree(talentTree)

		gateMap = {}
		for gateID in sorted(csv.summer_challenge.gates, key=lambda x:csv.summer_challenge.gates[x].floor):
			cfg = csv.summer_challenge.gates[gateID]
			gateMap.setdefault(cfg.gateSeq, []).append(gateID)
			cls.HuoDongMap.setdefault(csvID, []).append(gateID)

		for csvID in csv.summer_challenge.base:
			base = csv.summer_challenge.base[csvID]
			cls.HuoDongMap[csvID] = gateMap.get(base.gateSeqID)

	@classmethod
	@coroutine
	def onSummerChallengeEvent(cls, event, data, sync):
		logger.info("ObjectYYSummerChallenge.onEvent %s", event)

		ret = {}
		if event == "yy_info":
			ret["yyID"] = ObjectYYHuoDongFactory.getSummerChallengeOpenID()
		elif event == "calc_cards":
			cards = yield cls.calcCards(data["csvIDs"])
			ret["cards"] = cards
			ret["yyID"] = ObjectYYHuoDongFactory.getSummerChallengeOpenID()
		raise Return(ret)

	@classmethod
	def activeSummerChallenge(cls, yyID):
		Session.startSummerChallengeYYActive(yyID)

	@classmethod
	@coroutine
	def calcCards(cls, csvIDs):
		"""
		??????
		"""
		from game.object.game import ObjectCard

		cards = {}  # {cardID: {}}
		fakeCard = ObjectCard(None, None)
		fakeCard.new_deepcopy()
		for csvID in csvIDs:
			cfg = csv.summer_challenge.cards[csvID]
			cardID = cfg.cardID
			if cardID not in csv.cards:
				continue

			setRobotCard(fakeCard, cardID, cfg.advance, cfg.star, cfg.level,
				character=0,
				nvalue=cfg.nvalue,
				abilities=cfg.abilities,
				skillLevels=cfg.skillLevels,
				equipStar=cfg.equipStar,
				equipLevel=cfg.equipLevel,
				equipAwake=cfg.equipAwake,
				equipAdvance=cfg.equipAdvance)
			fetters = csv.cards[cardID].fetterList if cfg.fetters else None
			ObjectCard.calcStarEffectAttrsAddition(fakeCard)
			ObjectCard.calcFettersAttrsAddition(fakeCard, fetters)
			ObjectCard.calcTrainerAttrSkillAddition(fakeCard, cls.Trainer)
			ObjectCard.calcExplorerAttrsAddition(fakeCard, cls.Explorer)
			ObjectCard.calcExplorerComponentAttrsAddition(fakeCard, cls.Explorer)
			ObjectCard.calcUnionSkillAttrsAddition(fakeCard, cls.UnionSkills)
			ObjectCard.calcTalentAttrsAddition(fakeCard, cls.TalentTree)
			model = fakeCard.battleModel(False, False, SceneDefs.SummerChallenge, explorer=cls.Explorer)
			model["unit_id"] = cfg.unitID
			# ????
			if cfg.skills:
				model["skills"] = cfg.skills
			for attr in AttrDefs.attrsEnum[1:]:
				if attr in cfg and cfg[attr]:
					constVal, percentVal = str2num_t(cfg[attr])
					if constVal > 0:
						model["attrs"][attr] += constVal
					if percentVal > 0:
						model["attrs"][attr] *= percentVal
			model["fighting_point"] = ObjectCard.calcFightingPoint(fakeCard, model["attrs"])
			cards[csvID] = model
			yield moment
		raise Return(cards)

	@classmethod
	def active(cls, yyObj, game):
		cls.refreshRecord(yyObj, game)

	@classmethod
	def refreshRecord(cls, yyObj, game, init=None):
		record = cls.getRecord(yyObj.id, game)

	@classmethod
	def checkBattle(cls, yyObj, game, cards, gateID):
		record = cls.getRecord(yyObj.id, game)

		if gateID in record.setdefault("stamps", {}):
			raise ClientError("this gate already pass")

		dt = yyObj.gameBeginDateTime(game)
		days = todayinclock5elapsedays(dt)

		cfg = csv.summer_challenge.gates[gateID]
		if cfg.openDay > (days + 1):
			raise ClientError("gate not open")

		# ??????
		if cfg.floor > 1:
			preGateID = cls.HuoDongMap[yyObj.paramMap["base"]][cfg.floor-2]
			if not record["stamps"].get(preGateID, 0):
				raise ClientError("pre gate not pass")

		# ????
		for cardID, pos in cfg.autoCards.iteritems():
			if cardID not in cards:
				raise ClientError("card %s must in deployments" % cardID)
			if pos and pos != (cards.index(cardID) + 1):
				raise ClientError("card %s position must be %s" % (cardID, pos))
		for idx, cardID in enumerate(cards):
			if not cardID:
				continue
			if cardID not in cfg.cards and cardID not in cfg.autoCards:
				raise ClientError("card %s can not use" % cardID)
			if cfg.deployLock[idx]:
				raise ClientError("delpoy position not allowed")

		return {
			"gateID": gateID,
			"cards": cards,
			"buffs": record.get("stamps1", {}).keys()
		}


#
# ObjectYYMidAutumnDraw
#
class ObjectYYMidAutumnDraw(ObjectYYGeneralTask):
	"""
	????
	"""

	RoundsMap = {}  # {huodongID:[cfg, ...]}

	@classmethod
	def drawCsv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.mid_autumn_draw
		return csv.yunying.mid_autumn_draw[csvID]

	@classmethod
	def classInit(cls):
		super(ObjectYYMidAutumnDraw, cls).classInit()
		cls.RoundsMap = {}
		for csvID in sorted(cls.drawCsv().keys()):
			cfg = cls.drawCsv(csvID)
			cls.RoundsMap.setdefault(cfg.huodongID, []).append(cfg)

	@classmethod
	def csv(cls, csvID=None):
		if csvID is None:
			return csv.yunying.mid_autumn_draw_tasks
		return csv.yunying.mid_autumn_draw_tasks[csvID]

	@classmethod
	def refreshRecord(cls, yyObj, game, init=None):
		record = cls.getRecord(yyObj.id, game)

		info = record.setdefault('info', {})
		info.setdefault('draw_times', 0)        # ???????
		info.setdefault('round_counter', 1)     # ????
		record.setdefault('stamps1', {})    # ????????????????

		ndi = todayinclock5date2int()
		if ndi != record.get('lastday', None):
			record['lastday'] = ndi
			# ?????????
			record['stamps'] = {}
			record['valsums'] = {}
			record['valinfo'] = {}

		return record

	@classmethod
	def getTaskAward(cls, yyID, game, csvID):
		record = cls.getExistedRecord(yyID, game)

		stamps = record.setdefault('stamps', {})
		info = record.setdefault('info', {})

		if stamps.get(csvID, -1) != 1:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		oldTimes = info['draw_times']
		info['draw_times'] += cls.csv(csvID).addTimes    # ????
		stamps[csvID] = 0       # ???????

		return info['draw_times'] - oldTimes

	@classmethod
	def getOneKeyTaskAward(cls, yyID, game):
		record = cls.getExistedRecord(yyID, game)
		if record is None or 'stamps' not in record:
			raise ClientError(ErrDefs.yyHuoDongNoActive)

		stamps = record.setdefault('stamps', {})
		info = record.setdefault('info', {})

		ids = filter(lambda x: stamps[x] == 1, stamps)
		if not ids:
			return 0

		oldTimes = info['draw_times']

		for csvID in ids:
			info['draw_times'] += cls.csv(csvID).addTimes
			stamps[csvID] = 0

		return info['draw_times'] - oldTimes

	@classmethod
	def getEffect(cls, yyID, drawType, game):
		yyObj = ObjectYYHuoDongFactory.getConfig(yyID)
		record = cls.getRecord(yyID, game)
		info = record.get('info', {})
		stamps1 = record.setdefault('stamps1', {})

		drawTimes = info.get('draw_times', 0)
		roundNum = info['round_counter']

		if drawTimes <= 0:
			raise ClientError(ErrDefs.DrawTimesNotEnough)

		# ?????????
		cfg = cls.RoundsMap[yyObj.huodongID][roundNum - 1]

		# ???????????
		if stamps1.get(roundNum, 0) >= cfg.bestPoolMaxTimes:
			hit = False
		else:
			# ???????
			hit = False
			if random.randint(0, 99) < cfg.bestPoolProb:
				hit = True

		pool = cfg.bestPoolID if hit else cfg.commonPoolID

		def _afterGain():
			if hit:
				record['stamps1'][roundNum] = stamps1.get(roundNum, 0) + 1  # ??????????
				info['round_counter'] = 1   # ????
				info['hit'] = 1
			else:
				info['round_counter'] += 1
				info['hit'] = 0

			info['draw_times'] -= 1     # ??????

		eff = ObjectYYHuoDongEffect(game, pool, _afterGain)
		return eff

	@classmethod
	def recordDraw(cls, yyID, game, result):
		record = cls.getExistedRecord(yyID, game)
		info = record.get('info', {})
		store = record.setdefault('mid_autumn_draw', [])

		result['hit'] = info['hit']

		store.append(result)

		return info['hit']


#
# ObjectYYHuoDongFactory
#

class ObjectYYHuoDongFactory(ReloadHooker):

	HuoDongMap = {} # {csv_id: yyObj}
	OpenIDSet = set() # (csv_id)
	OpenTypeMap = {} # {type: [csv_id]}

	DoubleDropYYID = None
	LimitDropYYID = None
	FightRankYYID = None
	YYCloneYYID = None
	WorldBossYYID = None
	ClassInitTimes = 0
	LastWordBossYYID = None
	DinnerID = None
	RegainAwardYYObjs = None # ?????????
	HuoDongRedPacketYYID = None
	ReunionYYID = None
	HuoDongBossYYID = None
	HuoDongCrossRedPacketYYID = None
	HorseRaceYYID = None
	BraveChallengeYYID = None
	SummerChallengeYYID = None

	NoRoleActiveYYID = {} # YYCloneYYID,HuoDongRedPacketYYID,BraveChallengeYYID,HorseRaceYYID

	LeastLevels = None # ????????

	ClassMap = {
		YYHuoDongDefs.FirstRecharge: ObjectYYFirstRecharge,
		YYHuoDongDefs.LoginWeal: ObjectYYLoginWeal,
		YYHuoDongDefs.LevelAward: ObjectYYLevelAward,
		YYHuoDongDefs.RechargeGift: ObjectYYRechargeGift,
		YYHuoDongDefs.TimeLimitDraw: ObjectYYTimeLimitDraw,
		YYHuoDongDefs.MonthlyCard: ObjectYYMonthlyCard,
		YYHuoDongDefs.DinnerTime: ObjectYYDinnerTime,
		YYHuoDongDefs.ClientShow: ObjectYYClientShow,
		YYHuoDongDefs.GateAward: ObjectYYGateAward,
		YYHuoDongDefs.VIPAward: ObjectYYVIPAward,
		# YYHuoDongDefs.AllLifeCard: ObjectYYAllLifeCard,
		YYHuoDongDefs.DoubleDrop: ObjectYYDoubleDrop,
		YYHuoDongDefs.LimitDrop: ObjectYYLimitDrop,
		YYHuoDongDefs.ItemExchange: ObjectYYItemExchange,
		YYHuoDongDefs.RMBCost: ObjectYYRMBCost,
		YYHuoDongDefs.GeneralTask: ObjectYYGeneralTask,
		YYHuoDongDefs.ServerOpen: ObjectYYServerOpen,
		YYHuoDongDefs.FightRank: ObjectYYFightRank,
		YYHuoDongDefs.LuckyCat: ObjectYYLuckyCat,
		YYHuoDongDefs.CollectCard: ObjectYYCollectCard,
		YYHuoDongDefs.DailyBuy: ObjectYYDailyBuy,
		YYHuoDongDefs.TimeLimitBox: ObjectYYTimeLimitBox,
		YYHuoDongDefs.VIPBuy: ObjectYYVIPBuy,
		YYHuoDongDefs.LevelFund: ObjectYYLevelFund,
		YYHuoDongDefs.ItemBuy: ObjectYYItemBuy,
		YYHuoDongDefs.ItemBuy2: ObjectYYItemBuy2,
		YYHuoDongDefs.YYClone: ObjectYYClone,
		YYHuoDongDefs.BreakEgg: ObjectYYBreakEgg,
		YYHuoDongDefs.WorldBoss: ObjectYYWorldBoss,
		YYHuoDongDefs.RegainStamina: ObjectYYRegainStamina,
		YYHuoDongDefs.OnceRechageAward: ObjectYYOnceRechageAward,
		YYHuoDongDefs.RechargeReset: ObjectYYRechargeReset,
		YYHuoDongDefs.DirectBuyGift: ObjectYYDirectBuyGift,
		YYHuoDongDefs.LimitBuyGift: ObjectYYLimitBuyGift,
		YYHuoDongDefs.CustomizeGift: ObjectYYCustomizeGift,
		YYHuoDongDefs.Passport: ObjectYYPassport,
		YYHuoDongDefs.TimeLimitUpDraw: ObjectYYTimeLimitUpDraw,
		YYHuoDongDefs.LoginGift: ObjectYYLoginGift,
		YYHuoDongDefs.RechargeWheel: ObjectYYRechargeWheel,
		YYHuoDongDefs.LivenessWheel: ObjectYYLivenessWheel,
		YYHuoDongDefs.LuckyEgg: ObjectYYLuckyEgg,
		YYHuoDongDefs.Retrieve: ObjectYYRetrieve,
		YYHuoDongDefs.HuoDongRedPacket: ObjectYYHuoDongRedPacket,
		YYHuoDongDefs.WeeklyCard: ObjectYYWeeklyCard,
		YYHuoDongDefs.TimeLimitUpDrawGem: ObjectYYDrawGemLimit,
		YYHuoDongDefs.BaoZongzi: ObjectYYBaoZongzi,
		YYHuoDongDefs.Reunion: ObjectYYReunion,
		YYHuoDongDefs.Flop: ObjectYYFlop,
		YYHuoDongDefs.QualityExchange: ObjectYYQualityExchange,
		YYHuoDongDefs.HalloweenSprites: ObjectYYHalloweenSprites,
		YYHuoDongDefs.HuoDongBoss: ObjectYYHuoDongBoss,
		YYHuoDongDefs.Double11: ObjectYYDouble11,
		YYHuoDongDefs.HuoDongCloth: ObjectYYHuoDongCloth,
		YYHuoDongDefs.SnowBall: ObjectYYSnowBall,
		YYHuoDongDefs.Skyscraper: ObjectYYSkyscraper,
		YYHuoDongDefs.SpriteUnfreeze: ObjectYYSpriteUnfreeze,
		YYHuoDongDefs.Jifu: ObjectYYJifu,
		YYHuoDongDefs.HuoDongCrossRedPacket: ObjectYYHuoDongCrossRedPacket,
		YYHuoDongDefs.RMBGoldReturn: ObjectYYHuoDongRMBGoldReturn,
		YYHuoDongDefs.GridWalk: ObjectYYHuoDongGridWalk,
		YYHuoDongDefs.PlayPassport: ObjectYYPlayPassport,
		YYHuoDongDefs.HorseRace: ObjectYYHorseRace,
		YYHuoDongDefs.BraveChallenge: ObjectYYBraveChallenge,
		YYHuoDongDefs.LuxuryDirectBuyGift: ObjectYYLuxuryDirectBuyGift,
		YYHuoDongDefs.Dispatch: ObjectYYDispatch,
		YYHuoDongDefs.ShavedIce: ObjectYYShavedIce,
		YYHuoDongDefs.SummerChallenge: ObjectYYSummerChallenge,
		YYHuoDongDefs.Volleyball: ObjectYYVolleyball,
		YYHuoDongDefs.MidAutumnDraw: ObjectYYMidAutumnDraw,
		YYHuoDongDefs.ThemeSkin : ObjectYYThemeSkinDraw,
		YYHuoDongDefs.ZhutiYingxiong : ObjectYYZhutiYingxiongDraw,
		YYHuoDongDefs.JiuWei : ObjectYYJiuWeiDraw,
		YYHuoDongDefs.HeldItem : ObjectYYHeldItemDraw,
		YYHuoDongDefs.LimitTask: ObjectYYLimitTask,
		YYHuoDongDefs.LimitExplor: ObjectYYLimitExplorDraw,
		YYHuoDongDefs.MonopolyWalk: ObjectYYHuoDongMonopoly,
	}

	@classmethod
	def classInit(cls):
		# print ObjectYYHuoDongWeek.mro()

		cls.HuoDongMap = {}
		cls.OpenIDSet = set()
		cls.OpenTypeMap = {}
		cls.DoubleDropYYID = []
		cls.LimitDropYYID = []
		cls.FightRankYYID = []
		cls.YYCloneYYID = []
		cls.WorldBossYYID = []
		cls.DinnerID = []
		cls.RegainAwardYYObjs = []
		cls.ClassInitTimes += 1
		cls.HuoDongRedPacketYYID = []
		cls.ReunionYYID = []
		cls.HuoDongBossYYID = []
		cls.HuoDongCrossRedPacketYYID = []
		cls.HorseRaceYYID = []
		cls.BraveChallengeYYID = []
		cls.SummerChallengeYYID = []

		cls.NoRoleActiveYYID = {}
		cls.LeastLevels = set()

		ObjectYYFirstRecharge.classInit()
		ObjectYYLoginWeal.classInit()
		ObjectYYLevelAward.classInit()
		ObjectYYRechargeGift.classInit()
		ObjectYYTimeLimitDraw.classInit()
		ObjectYYMonthlyCard.classInit()
		ObjectYYDinnerTime.classInit()
		ObjectYYEveryDayLogin.classInit()
		ObjectYYClientShow.classInit()
		ObjectYYGateAward.classInit()
		ObjectYYVIPAward.classInit()
		# ObjectYYAllLifeCard.classInit()
		ObjectYYDoubleDrop.classInit()
		ObjectYYLimitDrop.classInit()
		ObjectYYItemExchange.classInit()
		ObjectYYRMBCost.classInit()
		ObjectYYServerOpen.classInit()
		ObjectYYGeneralTask.classInit()
		ObjectYYFightRank.classInit()
		ObjectYYLuckyCat.classInit()
		ObjectYYCollectCard.classInit()
		ObjectYYDailyBuy.classInit()
		ObjectYYTimeLimitBox.classInit()
		ObjectYYVIPBuy.classInit()
		ObjectYYLevelFund.classInit()
		ObjectYYItemBuy.classInit()
		ObjectYYItemBuy2.classInit()
		ObjectYYClone.classInit()
		ObjectYYWorldBoss.classInit()
		ObjectYYRegainStamina.classInit()
		ObjectYYOnceRechageAward.classInit()
		ObjectYYRechargeReset.classInit()
		ObjectYYDirectBuyGift.classInit()
		ObjectYYLimitBuyGift.classInit()
		ObjectYYCustomizeGift.classInit()
		ObjectYYPassport.classInit()
		ObjectYYRetrieve.classInit()
		ObjectYYWeeklyCard.classInit()
		ObjectYYDrawGemLimit.classInit()
		ObjectYYBaoZongzi.classInit()
		ObjectYYReunion.classInit()
		ObjectYYFlop.classInit()
		ObjectYYQualityExchange.classInit()
		ObjectYYHalloweenSprites.classInit()
		ObjectYYHuoDongBoss.classInit()
		ObjectYYDouble11.classInit()
		ObjectYYHuoDongCloth.classInit()
		ObjectYYSnowBall.classInit()
		ObjectYYSkyscraper.classInit()
		ObjectYYJifu.classInit()
		ObjectYYHuoDongGridWalk.classInit()
		ObjectYYHuoDongRMBGoldReturn.classInit()
		ObjectYYPlayPassport.classInit()
		ObjectYYHorseRace.classInit()
		ObjectYYBraveChallenge.classInit()
		ObjectYYLuxuryDirectBuyGift.classInit()
		ObjectYYDispatch.classInit()
		ObjectYYShavedIce.classInit()
		ObjectYYSummerChallenge.classInit()
		ObjectYYVolleyball.classInit()
		ObjectYYMidAutumnDraw.classInit()
		ObjectYYThemeSkinDraw.classInit()
		ObjectYYZhutiYingxiongDraw.classInit()
		ObjectYYJiuWeiDraw.classInit()
		ObjectYYHeldItemDraw.classInit()
		ObjectYYLimitTask.classInit()
		ObjectYYLimitExplorDraw.classInit()
		ObjectYYHuoDongMonopoly.classInit()

		for idx in csv.yunying.yyhuodong:
			cfg = csv.yunying.yyhuodong[idx]
			# gmtool?type??,?openType??
			gmType = ObjectGMYYConfig.Singleton.yyhuodong.get(idx, {}).get('type', cfg.type)
			gmOpenType = ObjectGMYYConfig.Singleton.yyhuodong.get(idx, {}).get('openType', cfg.openType)

			if gmType == YYHuoDongDefs.DoubleDrop:
				cls.DoubleDropYYID.append(idx)
			# ?????????
			elif gmType == YYHuoDongDefs.LimitDrop:
				cls.LimitDropYYID.append(idx)
			# ??????,???????????
			elif gmType == YYHuoDongDefs.FightRank:
				cls.FightRankYYID.append(idx)
			# ????????
			elif gmType == YYHuoDongDefs.YYClone:
				cls.YYCloneYYID.append(idx)
				cls.NoRoleActiveYYID.setdefault(YYHuoDongDefs.YYClone, []).append(idx)
			# ??boss??
			elif gmType == YYHuoDongDefs.WorldBoss:
				cls.WorldBossYYID.append(idx)
			# ??
			elif gmType == YYHuoDongDefs.DinnerTime:
				cls.DinnerID.append(idx)
			# ????
			elif gmType == YYHuoDongDefs.HuoDongRedPacket:
				cls.HuoDongRedPacketYYID.append(idx)
				cls.NoRoleActiveYYID.setdefault(YYHuoDongDefs.HuoDongRedPacket, []).append(idx)
			elif gmType == YYHuoDongDefs.Reunion:
				cls.ReunionYYID.append(idx)
			elif gmType == YYHuoDongDefs.HuoDongBoss:
				cls.HuoDongBossYYID.append(idx)
			elif gmType == YYHuoDongDefs.HuoDongCrossRedPacket:
				cls.HuoDongCrossRedPacketYYID.append(idx)
			elif gmType == YYHuoDongDefs.HorseRace:
				cls.HorseRaceYYID.append(idx)
				cls.NoRoleActiveYYID.setdefault(YYHuoDongDefs.HorseRace, []).append(idx)
			elif gmType == YYHuoDongDefs.BraveChallenge:
				cls.BraveChallengeYYID.append(idx)
				cls.NoRoleActiveYYID.setdefault(YYHuoDongDefs.BraveChallenge, []).append(idx)
			elif gmType == YYHuoDongDefs.SummerChallenge:
				cls.SummerChallengeYYID.append(idx)
				cls.NoRoleActiveYYID.setdefault(YYHuoDongDefs.SummerChallenge, []).append(idx)

			# ????????
			if gmOpenType == YYHuoDongDefs.OnceOpen:
				obj = ObjectYYHuoDongOnce(cfg)
			if gmOpenType == YYHuoDongDefs.DailyOpen:
				obj = ObjectYYHuoDongDaily(cfg)
			elif gmOpenType == YYHuoDongDefs.WeekOpen:
				obj = ObjectYYHuoDongWeek(cfg)
			elif gmOpenType == YYHuoDongDefs.RelateServerOpen:
				obj = ObjectYYHuoDongRelateServerOpen(cfg)
			elif gmOpenType == YYHuoDongDefs.RelateRoleCreate:
				obj = ObjectYYHuoDongRelateRoleCreate(cfg)

			# ???????????,?????????

			if cfg.type in (YYHuoDongDefs.ServerOpen, YYHuoDongDefs.GeneralTask, YYHuoDongDefs.RechargeGift,
							YYHuoDongDefs.TimeLimitBox, YYHuoDongDefs.LoginGift, YYHuoDongDefs.WeeklyCard,
							YYHuoDongDefs.Passport, YYHuoDongDefs.Double11, YYHuoDongDefs.HuoDongCloth,
							YYHuoDongDefs.SnowBall, YYHuoDongDefs.Jifu, YYHuoDongDefs.RMBGoldReturn,
							YYHuoDongDefs.Skyscraper, YYHuoDongDefs.GridWalk, YYHuoDongDefs.PlayPassport,
							YYHuoDongDefs.HorseRace, YYHuoDongDefs.Dispatch, YYHuoDongDefs.Volleyball, ):
				cls.RegainAwardYYObjs.append(obj)


			obj.init()
			if obj.isValid():
				cls.HuoDongMap[cfg.id] = obj
				cls.LeastLevels.add(obj.leastLevel)

		Session.onHuoDongRefresh()
		cls.setYYLastWorldBossOpenID()

	@classmethod
	def getConfig(cls, yyID):
		return cls.HuoDongMap.get(yyID, None)

	@classmethod
	def getDinnerClass(cls, yyID, roleLevel, roleCreatedTime, roleVipLevel):
		yy = cls.getConfig(yyID)
		if yy and yy.isRoleOpen(roleLevel, roleCreatedTime, roleVipLevel):
			return cls.ClassMap.get(yy.type)
		return None

	@classmethod
	def getOpenConfig(cls, yyID):
		if yyID not in cls.OpenIDSet:
			return None	
		return cls.HuoDongMap.get(yyID, None)

	@classmethod
	def getRoleOpenConfig(cls, yyID, roleLevel, roleCreatedTime, roleVipLevel):
		yy = cls.getOpenConfig(yyID)
		if yy and yy.isRoleOpen(roleLevel, roleCreatedTime, roleVipLevel):
			return yy
		return None

	@classmethod
	def getRoleOpenClass(cls, yyID, roleLevel, roleCreatedTime, roleVipLevel):
		yy = cls.getOpenConfig(yyID)
		if yy and yy.isRoleOpen(roleLevel, roleCreatedTime, roleVipLevel):
			return cls.ClassMap.get(yy.type)
		return None

	# ??????
	@classmethod
	def getRoleRegainMails(cls, game):
		nt = nowdatetime_t()
		ret = []
		for yyObj in cls.RegainAwardYYObjs:
			edt = yyObj.gameEndDateTime(game)
			if edt:
				if yyObj.type == YYHuoDongDefs.WeeklyCard:
					# ?????????????,?????????
					cls.ClassMap[yyObj.type].active(yyObj, game)
				flag = nt > edt  # ??
				if not flag and yyObj.type == YYHuoDongDefs.WeeklyCard:
					flag = ObjectYYWeeklyCard.isRoleEnd(yyObj, game)

				# ?????????????????????????
				if yyObj.type == YYHuoDongDefs.Double11:
					flag = True

				if flag:
					eff = cls.ClassMap[yyObj.type].getRegainMailEffect(yyObj, game)
					if eff:
						ret.append(eff)
		return ret

	@classmethod
	def getRoleOpenList(cls, roleLevel, roleCreatedTime, roleVipLevel):
		ret = []
		for yyID in cls.OpenIDSet:
			yy = cls.HuoDongMap[yyID]
			if yy.isRoleOpen(roleLevel, roleCreatedTime, roleVipLevel):
				ret.append(yyID)
		return ret

	@classmethod
	def getEventDeltaTimes(cls, yyIDs, game):
		ret = {}
		now = nowdatetime_t()
		for yyID in yyIDs:
			yy = cls.HuoDongMap[yyID]
			# print yy.id, yy.name, yy.gameEventDelta(game, now) + now
			delta = yy.gameEventDelta(game, now)
			if delta:
				ret[yyID] = delta.total_seconds()
		return ret

	@classmethod
	def getEventHuodongIDs(cls, yyIDs, game):
		ret = {}
		for yyID in yyIDs:
			yy = cls.HuoDongMap[yyID]
			# ???????????
			if yy.type == YYHuoDongDefs.RechargeGift and yy.paramMap.get('replace', False):
				ret[yyID] = ObjectYYRechargeGift.getHuodongID(yy, game)
		return ret

	@classmethod
	def getViews(cls, yyIDs=None):
		ret = {
			'luckycat_message_rmb': ObjectYYLuckyCat.BroadcastMessageRMB,
			'luckycat_message_gold': ObjectYYLuckyCat.BroadcastMessageGold,
			'dailybuy_max': ObjectYYDailyBuy.ServerBuy,
			'recharge_wheel_message': ObjectYYRechargeWheel.BroadcastMessage,
		}
		return ret

	@classmethod
	def getDoubleDropOpenID(cls, _type, gateID=None):
		for id in cls.DoubleDropYYID:
			cfg = csv.yunying.yyhuodong[id]
			if 'type' in cfg.paramMap and cfg.paramMap['type'] == _type:
				if gateID:
					start = cfg.paramMap.get('start', None)
					end = cfg.paramMap.get('end', None)
					if start and end and start <= gateID <= end and id in cls.OpenIDSet:
						return id

					interval = cfg.paramMap.get('interval', None)
					# ??????????interval??,???????????
					if interval:
						for i in xrange(len(interval)):
							start, end = interval[i]
							if start <= gateID <= end and id in cls.OpenIDSet:
								return id
				elif id in cls.OpenIDSet:
					return id
		return None

	@classmethod
	def getReunionCatchUpCfg(cls, role, _type, gateID=None):
		'''
		?? ???????????
		'''
		if not role.isReunionRoleOpen:
			return

		if role.reunion['role_type'] != ReunionDefs.ReunionRole:
			return

		huodongID = role.reunion['info']['huodongID']
		for csvID in csv.yunying.reunion_catchup:
			cfg = csv.yunying.reunion_catchup[csvID]
			if cfg.huodongID != huodongID:
				continue

			if 'type' in cfg.params and cfg.params['type'] == _type:
				if gateID:
					start = cfg.params.get('start', None)
					end = cfg.params.get('end', None)
					if start and end and start <= gateID <= end:
						return cfg

					interval = cfg.params.get('interval', None)
					# ??????????interval??,???????????
					if interval:
						for i in xrange(len(interval)):
							start, end = interval[i]
							if start <= gateID <= end:
								return cfg
				else:
					return cfg
		return

	@classmethod
	def isLimitDropOpen(cls):
		for id in cls.LimitDropYYID:
			if id in cls.OpenIDSet:
				return True
		return False

	@classmethod
	def getLimitDropExtraVersions(cls):
		# ??????,???version,????
		ret = set()
		for id in cls.LimitDropYYID:
			if id in cls.OpenIDSet:
				cfg = csv.yunying.yyhuodong[id]
				if 'extraVersion' in cfg.paramMap:
					ret.add(cfg.paramMap['extraVersion'])
		return ret

	@classmethod
	def getYYCloneOpenID(cls):
		for id in cls.YYCloneYYID:
			if id in cls.OpenIDSet:
				return id
		return None

	@classmethod
	def getYYWorldBossOpenID(cls):
		for id in cls.WorldBossYYID:
			if id in cls.OpenIDSet:
				return id
		return None

	@classmethod
	def getYYHuoDongRedPacketID(cls):
		for idx in cls.HuoDongRedPacketYYID:
			if idx in cls.OpenIDSet:
				return idx
		return None

	@classmethod
	def getYYHuoDongCrossRedPacketID(cls):
		for idx in cls.HuoDongCrossRedPacketYYID:
			if idx in cls.OpenIDSet:
				return idx
		return None

	@classmethod
	def getYYHuoDongBossOpenID(cls):
		for id in cls.HuoDongBossYYID:
			if id in cls.OpenIDSet:
				return id
		return None

	@classmethod
	def setYYLastWorldBossOpenID(cls):
		cls.LastWordBossYYID = cls.getYYWorldBossOpenID()

	@classmethod
	def getYYLastWorldBossOpenID(cls):
		return cls.LastWordBossYYID

	@classmethod
	def getYYReunionOpenIDs(cls):
		ret = set()
		for id in cls.ReunionYYID:
			if id in cls.OpenIDSet:
				ret.add(id)
		return ret

	@classmethod
	def getYYHorseRaceID(cls):
		for idx in cls.HorseRaceYYID:
			if idx in cls.OpenIDSet:
				return idx
		return None

	@classmethod
	def getBraveChallengeOpenID(cls):
		for idx in cls.BraveChallengeYYID:
			if idx in cls.OpenIDSet:
				return idx
		return None

	@classmethod
	def getSummerChallengeOpenID(cls):
		for idx in cls.SummerChallengeYYID:
			if idx in cls.OpenIDSet:
				return idx
		return None

	@classmethod
	def refreshAndEventDelta(cls):
		'''
		?session?delta????
		'''
		ret = None
		now = nowdatetime_t()
		oldHuoDongMap = cls.HuoDongMap
		oldOpenIDSet = cls.OpenIDSet
		cls.HuoDongMap = {}
		cls.OpenIDSet = set()
		cls.OpenTypeMap = {}

		for yyID in sorted(oldHuoDongMap.keys()):
			obj = oldHuoDongMap[yyID]
			openFlag = False
			if obj.isValid(now):
				cls.HuoDongMap[yyID] = obj
				openFlag = obj.isOpen(now)
				if openFlag:
					cls.OpenIDSet.add(yyID)
					cls.OpenTypeMap.setdefault(obj.type, []).append(yyID)
				delta = obj.eventDelta(now)
				logger.info('delta %d %s %s %s', yyID, obj.name, openFlag, delta)

				if delta:
					if ret is None:
						ret = delta
					elif ret > delta:
						ret = delta

		cls.onYYHuoDongsRefresh(oldOpenIDSet)
		ObjectTasksMap.onYYHuoDongsEvent()
		return ret

	@classmethod
	def refreshReunionRecord(cls, game, reunion, typ, val):
		role = game.role
		if not role.isReunionRoleOpen:
			return

		roleType = role.reunion['role_type']
		count, vice = reunion.valsums.setdefault(typ, [0, 0])
		# ??????
		if typ == TargetDefs.CooperateClone:
			lastday = reunion.valinfo.setdefault(typ, {}).get('lastday', None)
			if lastday != ObjectYYReunion.cloneTodayDateInt():
				reunion.valinfo[typ]['lastday'] = ObjectYYReunion.cloneTodayDateInt()
				tmp = min(count, vice)
				reunion.valsums[typ] = [tmp, tmp]
				count, vice = tmp, tmp
			if roleType == ReunionDefs.ReunionRole:
				reunion.valsums[typ] = [count + 1, vice]
			elif roleType == ReunionDefs.SeniorRole:
				reunion.valsums[typ] = [count, vice + 1]
		# ?????????
		elif typ == TargetDefs.ReunionFriend:
			if roleType == ReunionDefs.ReunionRole:
				valsum = 1 if game.society.isFriend(reunion.bind_role_db_id) else 0
			elif roleType == ReunionDefs.SeniorRole:
				valsum = 1 if game.society.isFriend(role.reunion['info']['role_id']) else 0
			reunion.valsums[typ] = [valsum, valsum]
 
		if not reunion.game:
			reunion.save_async(forget=True)

		# ????????
		if roleType == ReunionDefs.ReunionRole:
			ObjectYYReunion.refreshReunionTask(game, role.reunion['info']['huodongID'], reunion, typ)
		elif roleType == ReunionDefs.SeniorRole:
			from game.object.game import ObjectGame
			bindRoleGame = ObjectGame.getByRoleID(reunion.role_db_id, safe=False)
			if bindRoleGame:
				ObjectYYReunion.refreshReunionTask(bindRoleGame, role.reunion['info']['huodongID'], reunion, typ)

	@classmethod
	def isRechargeOK(cls, rechargeID, yyID, csvID, **kwargs):
		cfg = csv.yunying.yyhuodong[yyID]
		if not cfg:
			return False
		ok = cls.ClassMap[cfg.type].isRechargeOK(rechargeID, yyID, csvID, **kwargs)
		if not ok:
			return False
		return True

	@classmethod
	def buyRecharge(cls, game, rechargeID, yyID, csvID, **kwargs):
		cfg = csv.yunying.yyhuodong[yyID]
		if not cfg:
			return False, None
		future = None
		ok, eff = cls.ClassMap[cfg.type].buyRecharge(game, rechargeID, yyID, csvID, **kwargs)
		if not ok:
			return False, None
		if eff:
			from game.handler.inl import effectAutoGain
			from game.server import Server
			from tornado.concurrent import Future
			dbcGame = Server.Singleton.dbcGame
			future = Future()
			fu = effectAutoGain(eff, game, dbcGame, src='buy_recharge_%d_%d' % (yyID, csvID), yy_id=yyID)
			fu.add_done_callback(lambda _: future.set_result(eff.result))
		return True, future

	@classmethod
	def _activeOpen(cls, type, game, *args, **kwargs):
		if type in cls.OpenTypeMap:
			for yyID in cls.OpenTypeMap[type]:
				yy = cls.HuoDongMap[yyID]
				if yy.isRoleOpen(game.role.level, game.role.created_time, game.role.vip_level):
					cls.ClassMap[type].active(yy, game, *args, **kwargs)

		# ServerOpen???GeneralTask????
		if type == YYHuoDongDefs.GeneralTask:
			cls._activeOpen(YYHuoDongDefs.ServerOpen, game, *args, **kwargs)
			cls._activeOpen(YYHuoDongDefs.Passport, game, *args, **kwargs)
			cls._activeOpen(YYHuoDongDefs.LivenessWheel, game, *args, **kwargs)
			cls._activeOpen(YYHuoDongDefs.Reunion, game, *args, **kwargs)
			cls._activeOpen(YYHuoDongDefs.Flop, game, *args, **kwargs)
			cls._activeOpen(YYHuoDongDefs.Jifu, game, *args, **kwargs)
			cls._activeOpen(YYHuoDongDefs.GridWalk, game, *args, **kwargs)
			cls._activeOpen(YYHuoDongDefs.Dispatch, game, *args, **kwargs)
			cls._activeOpen(YYHuoDongDefs.MidAutumnDraw, game, *args, **kwargs)
			cls._activeOpen(YYHuoDongDefs.LimitTask, game, *args, **kwargs)

	@classmethod
	def _activeOpenNoRole(cls, type, *args):
		if type in cls.OpenTypeMap:
			for yyID in cls.OpenTypeMap[type]:
				yy = cls.HuoDongMap[yyID]
				cls.ClassMap[type].active(yy, None, *args)

	@classmethod
	def _generalTaskNoCountActiveOpen(cls, game):
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.Vip, 0)
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.Level, 0)
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.Gate, 0)
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.CardsTotal, 0)
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.CardAdvanceCount, 0)
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.CardStarCount, 0)
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.EquipAdvanceCount, 0)
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.EquipStarCount, 0)
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.ArenaRank, 0)
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.LoginDays, 0)
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.CompleteImmediate, 0)
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.Explorer, 0)

	@classmethod
	def onRecharge(cls, game, rmb, rechargeID=0):
		cls._activeOpen(YYHuoDongDefs.FirstRecharge, game)
		cls._activeOpen(YYHuoDongDefs.RechargeGift, game, rmb)
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.RechargeRmb, rmb)
		cls._activeOpen(YYHuoDongDefs.BreakEgg, game, rmb)
		cls._activeOpen(YYHuoDongDefs.OnceRechageAward, game, rmb, rechargeID)
		cls._activeOpen(YYHuoDongDefs.RechargeWheel, game, rmb)

	@classmethod
	def onRMBCost(cls, game, rmb):
		cls._activeOpen(YYHuoDongDefs.RMBCost, game, rmb)
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.CostRmb, rmb)
		cls._activeOpen(YYHuoDongDefs.RMBGoldReturn, game, rmb, 0) # gold=0

	@classmethod
	def onGoldCost(cls, game, gold):
		cls._activeOpen(YYHuoDongDefs.RMBGoldReturn, game, 0, gold)  # rmb=0

	@classmethod
	def onLogin(cls, game):
		if YYHuoDongDefs.EveryDayLogin in cls.OpenTypeMap:
			for yyID in cls.OpenTypeMap[YYHuoDongDefs.EveryDayLogin]:
				# ??????????
				yy = cls.HuoDongMap[yyID]
				if yy.isRoleOpen(game.role.level, game.role.created_time, game.role.vip_level):
					eff = ObjectYYEveryDayLogin.getEffect(yyID, None, game)
					if eff:
						eff.gain(src='yy_%d' % yyID)

		cls.onNewCard(game)
		
		cls._activeOpen(YYHuoDongDefs.FirstRecharge, game)
		cls._activeOpen(YYHuoDongDefs.LoginWeal, game)
		cls._activeOpen(YYHuoDongDefs.LoginGift, game)
		cls._activeOpen(YYHuoDongDefs.LevelAward, game)
		cls._activeOpen(YYHuoDongDefs.LevelFund, game)
		cls._activeOpen(YYHuoDongDefs.VIPAward, game)
		cls._activeOpen(YYHuoDongDefs.VIPBuy, game)
		cls._activeOpen(YYHuoDongDefs.GateAward, game)
		cls._activeOpen(YYHuoDongDefs.BreakEgg, game)
		cls._activeOpen(YYHuoDongDefs.RechargeReset, game)
		cls._activeOpen(YYHuoDongDefs.MonthlyCard, game)
		cls._activeOpen(YYHuoDongDefs.RechargeWheel, game)
		cls._activeOpen(YYHuoDongDefs.Retrieve, game)
		cls._activeOpen(YYHuoDongDefs.WeeklyCard, game)
		cls._activeOpen(YYHuoDongDefs.Reunion, game, TargetDefs.LoginDays, 0)
		cls._activeOpen(YYHuoDongDefs.QualityExchange, game)
		cls._activeOpen(YYHuoDongDefs.HalloweenSprites, game)
		cls._generalTaskNoCountActiveOpen(game)

		cls._activeOpen(YYHuoDongDefs.LimitBuyGift, game, YYHuoDongDefs.RoleLevelActive, 0)
		cls._activeOpen(YYHuoDongDefs.LimitBuyGift, game, YYHuoDongDefs.RoleVipLevelActive, 0)
		cls._activeOpen(YYHuoDongDefs.LimitBuyGift, game, YYHuoDongDefs.RoleCreatedTimeActive, 0)
		cls._activeOpen(YYHuoDongDefs.LimitBuyGift, game, YYHuoDongDefs.ImmediateActive, 0)
		cls._activeOpen(YYHuoDongDefs.LimitBuyGift, game, YYHuoDongDefs.PassGateActive, 0)
		cls._activeOpen(YYHuoDongDefs.TimeLimitUpDrawGem, game)
		cls._activeOpen(YYHuoDongDefs.SpriteUnfreeze, game)
		cls._activeOpen(YYHuoDongDefs.Skyscraper, game)
		cls._activeOpen(YYHuoDongDefs.PlayPassport, game)
		cls._activeOpen(YYHuoDongDefs.LuxuryDirectBuyGift, game)
		cls._activeOpen(YYHuoDongDefs.ShavedIce, game)
		cls._activeOpen(YYHuoDongDefs.SummerChallenge, game)
		cls._activeOpen(YYHuoDongDefs.Volleyball, game)
		cls._activeOpen(YYHuoDongDefs.BraveChallenge, game, 0, 0)

	@classmethod
	def onLevelUp(cls, game):
		cls._activeOpen(YYHuoDongDefs.LevelAward, game)
		cls._activeOpen(YYHuoDongDefs.LevelFund, game)
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.Level, 0)
		cls._activeOpen(YYHuoDongDefs.LimitBuyGift, game, YYHuoDongDefs.RoleLevelActive, 0)
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.CompleteImmediate, 0)

		if game.role.level in cls.LeastLevels: # ??????????????
			cls.onLogin(game)

	@classmethod
	def onVIPLevelUp(cls, game):
		cls._activeOpen(YYHuoDongDefs.VIPAward, game)
		cls._activeOpen(YYHuoDongDefs.VIPBuy, game)
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.Vip, 0)
		cls._activeOpen(YYHuoDongDefs.LimitBuyGift, game, YYHuoDongDefs.RoleVipLevelActive, 0)

	@classmethod
	def onGateStarChange(cls, game):
		cls._activeOpen(YYHuoDongDefs.GateAward, game)
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.Gate, 0)
		cls._activeOpen(YYHuoDongDefs.LimitBuyGift, game, YYHuoDongDefs.PassGateActive, 0)

	# 0=wait, 1=active, 2=close
	@classmethod
	def _activeOrClose(cls, typ, oldOpenIDSet):
		cur = None
		if typ not in cls.NoRoleActiveYYID:
			return 0, cur
		for idx in cls.NoRoleActiveYYID[typ]:
			if idx in cls.OpenIDSet:
				cur = idx
				break
		if cur and not oldOpenIDSet: # ???????,oldOpenIDSet??
			return 1, cur
		old = len(set(cls.NoRoleActiveYYID[typ]) & oldOpenIDSet) > 0
		if not old and cur: # ????
			return 1, cur
		if old and not cur: # ????
			return 2, cur
		return 0, cur

	@classmethod
	def onYYHuoDongsRefresh(cls, oldOpenIDSet):
		# ????????????
		# ??game
		cls._activeOpenNoRole(YYHuoDongDefs.FightRank)
		cls._activeOpenNoRole(YYHuoDongDefs.TimeLimitBox)
		cls._activeOpenNoRole(YYHuoDongDefs.SnowBall)

		# YYHuoDongDefs.YYClone
		# 24=?????? ???????????
		# ??????????????
		flag, cur = cls._activeOrClose(YYHuoDongDefs.YYClone, oldOpenIDSet)
		if flag == 1:
			ObjectYYClone.active(cur)
		elif flag == 2:
			ObjectYYClone.onClose()

		# YYHuoDongDefs.HuoDongRedPacket
		# 44=???? ?????????
		flag, cur = cls._activeOrClose(YYHuoDongDefs.HuoDongRedPacket, oldOpenIDSet)
		if flag == 1 or flag == 2:
			ObjectServerGlobalRecord.clearYYHuoDongRedPacket()

		# YYHuoDongDefs.BraveChallenge
		# 61=????
		flag, cur = cls._activeOrClose(YYHuoDongDefs.BraveChallenge, oldOpenIDSet)
		if flag == 1:
			ObjectYYBraveChallenge.activeBraveChallenge(cur)
		elif flag == 2:
			pass

		# YYHuoDongDefs.HorseRace
		# 62=?? ???????
		flag, cur = cls._activeOrClose(YYHuoDongDefs.HorseRace, oldOpenIDSet)
		if flag == 1:
			pass
		elif flag == 2:
			ObjectYYHorseRace.onClose()

		# YYHuoDongDefs.SummerChallenge
		# 67=????
		flag, cur = cls._activeOrClose(YYHuoDongDefs.SummerChallenge, oldOpenIDSet)
		if flag == 1:
			ObjectYYSummerChallenge.activeSummerChallenge(cur)
		elif flag == 2:
			pass

	@classmethod
	def onActiveGet(cls, game):
		# cls._activeOpen(YYHuoDongDefs.AllLifeCard, game)

		# costMap?????,??????
		cls._activeOpen(YYHuoDongDefs.ItemExchange, game)
		# ????huodongID?game?
		cls._activeOpen(YYHuoDongDefs.LuckyCat, game)
		# ????????,??????????????
		cls._activeOpen(YYHuoDongDefs.DailyBuy, game)
		# ????????
		cls._activeOpen(YYHuoDongDefs.ItemBuy, game)
		# ????????
		cls._activeOpen(YYHuoDongDefs.ItemBuy2, game)
		# ????,?????,??????
		cls._activeOpen(YYHuoDongDefs.RechargeGift, game, 0)
		# ????
		cls._activeOpen(YYHuoDongDefs.DirectBuyGift, game)
		# ?????,????????????,???????
		if cls.ClassInitTimes > 1:
			cls.onLogin(game)

	@classmethod
	def onHuoDongBoss(cls, game, stamina):
		huodongbossYYID = cls.getYYHuoDongBossOpenID()
		if not huodongbossYYID:
			return
		hdCls = cls.getRoleOpenClass(huodongbossYYID, game.role.level, game.role.created_time, game.role.vip_level)
		if not hdCls:
			return
		if stamina == 0:
			return

		rpc = ObjectServerGlobalRecord.huodongboss_cross_client()
		if not rpc:
			return

		bossData = ObjectYYHuoDongBoss.activeHuoDongBoss(huodongbossYYID, game, stamina)
		if bossData:
			rpc.call_async('HuoDongBossAdd', game.role.areaKey, bossData)

	@classmethod
	def onNewCard(cls, game, cards=None):
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.HadCard, 0)
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.CardsTotal, 0)
		cls._activeOpen(YYHuoDongDefs.CollectCard, game)
		if cards:
			for card in cards:
				cls._activeOpen(YYHuoDongDefs.LimitBuyGift, game, YYHuoDongDefs.GainCardActive, card.markID)
				cls._activeOpen(YYHuoDongDefs.LimitBuyGift, game, YYHuoDongDefs.GainCardRarityActive, card.rarity)

	@classmethod
	def onNewDayClock5(cls, game):
		cls._activeOpen(YYHuoDongDefs.MonthlyCard, game)
		cls._activeOpen(YYHuoDongDefs.LimitBuyGift, game, YYHuoDongDefs.RoleCreatedTimeActive, 0)
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, TargetDefs.CompleteImmediate, 0)
		cls._activeOpen(YYHuoDongDefs.Retrieve, game)
		cls._activeOpen(YYHuoDongDefs.WeeklyCard, game)
		cls._activeOpen(YYHuoDongDefs.HalloweenSprites, game)
		cls._activeOpen(YYHuoDongDefs.Skyscraper, game)
		cls._activeOpen(YYHuoDongDefs.Volleyball, game)
		cls._activeOpen(YYHuoDongDefs.BraveChallenge, game, 0, 0)
		cls.onVIPOrFightPointChanged(game) # ???5?,????????
		cls.onActiveGet(game)

	@classmethod
	def onGeneralTask(cls, game, type, val):
		cls._activeOpen(YYHuoDongDefs.GeneralTask, game, type, val)
		# ??????? TargetDefs, ??????,????????????
		game.role.onGrowGuideTask(type, val) # ????
		game.title.onCount(type, val) # ??

	@classmethod
	def onItemGain(cls, game):
		cls._activeOpen(YYHuoDongDefs.ItemExchange, game)

	@classmethod
	def onVIPOrFightPointChanged(cls, game):
		for yyID in cls.OpenTypeMap.get(YYHuoDongDefs.TimeLimitBox, []):
			hdCls = cls.getRoleOpenClass(yyID, game.role.level, game.role.created_time, game.role.vip_level)
			if hdCls:
				hdCls.acquireQualify(yyID, game)

	@classmethod
	def onTaskChange(cls, game, *args, **kwargs):
		cls._activeOpen(YYHuoDongDefs.PlayPassport, game, *args, **kwargs)

	@classmethod
	def onBraveChallengeAchievement(cls, game, typ, val):
		cls._activeOpen(YYHuoDongDefs.BraveChallenge, game, type, val)
