#!/usr/bin/python
# -*- coding: utf-8 -*-

from framework.log import logger
from framework.helper import toUTF8Dict, objectid2string
from tornado.gen import coroutine, Return
from payment.sdk.base import SDKBase

import json
import time
import hashlib
import urlparse



# DINGURL = "http://180.93.98.5/naruto/api/public/package/check"
# DINGURLBUY = "http://180.93.98.5/naruto/api/public/package/buy"

DINGURL = "http://api.langla.mobi/package/check"
DINGURLBUY = "http://api.langla.mobi/package/buy"

DINGHEADERS = {
	'Content-Type': 'application/json; charset=UTF-8'
}




class SDKTest(SDKBase):
	# Channel = 'test'
	Channel = 'luo'
	ReturnOK = '{"ret":0,"data":"Ok"}'
	ReturnErr = '{"ret":-1,"data":"Err"}'
	CodeCache = set([])
	@classmethod
	def parseData(cls, cfg, data):
		d = dict(urlparse.parse_qsl(data))
		
		logger.info('channel `{channel}` ch_account `{account}` status `{orderStatus}` order `{orderId}` {amount} coming'.format(channel=cls.Channel, account=objectid2string(d['accountId']), **d))
		return d

	@classmethod
	def getOrderID(cls, d):
	
		return d['orderId']

	@classmethod
	def getOrderResult(cls, d):
		
		return True if int(d["orderStatus"]) == 1 else False

	@classmethod
	def getClientInfo(cls, d):
		
		return d['game_extra']

	@classmethod
	def getOrderAmount(cls, d):
		
		return d['amount']

	@classmethod
	def getOrderErrMsg(cls, d):
		
		return ""

	@classmethod
	@coroutine
	def fetchChannelOrderID(cls, cfg, d, myOrderID):
		
		raise Exception('not implemented')

	@classmethod
	def makeReturnDict(cls, myOrderID, d):
		
		raise Exception('not implemented')

	@classmethod
	@coroutine
	def createCallback(cls, handler, GET=True):
		if cls.HttpClient is None:			
			raise Exception('no http client')

		if GET:
			data = handler.request.query
		else:
			data = handler.request.body
		d = dict(urlparse.parse_qsl(data))

		ret = binascii.hexlify(os.urandom(4))
		cls.CodeCache.add(ret)
		logger.info("params `%s` code `%s`", data, ret)

		try:
			ding = {
				"msgtype": "text",
				"text": {
					"content": "%s 支付验证码 " % d['amount'] + ret
				},
			}
			response = yield cls.HttpClient.fetch(DINGURL, method="POST", headers=DINGHEADERS, body=json.dumps(ding))
			logger.info(response)
		except:
			cls.initHttpClient()
			raise

		raise Return("code see test sdk")

	@classmethod
	@coroutine
	def payCallback(cls, handler, GET=True):
		cfg = handler.application.sdkConfig[cls.Channel]
		logger.info(handler.application.sdkConfig[cls.Channel])
		if GET:
			data = handler.request.query
		else:
			data = handler.request.body
		d = dict(urlparse.parse_qsl(data))

		if type(cls.HttpClient) is None or type(cls.HttpClient) is type(None):
			cls.initHttpClient()
		
  		# code = d.get('code', None)
		# if code not in cls.CodeCache:
		# 	raise Exception('code error')
		# cls.CodeCache.discard(code)

		# thêm vào queue 
		ret ={"ret":-100,"data":"not Ok"}
		#"content": "钻石%s 支付验证码 %s 已被 %s 使用" % (d['amount'], d['code'], d['game_extra'])	,
		try:
			gex = d['game_extra']
			gex = gex.replace('[','').replace(']','').replace('"','')
			gex  = gex.split(",")
			ding = {
				"access_token":"eyJhbGciOiJIUzI1NiIsInR5cGUiOiJKV1QifQ.eyJhY2NvdW50Ijoic2VydmVyIiwicGFzc3dvcmQiOiJAJFRva3VkYTEyMyIsImNyZWF0ZWRfYXQiOiIxNjEwMjAyMiIsImV4cGlyZWRfYXQiOiIzMTEyMjAyMiJ9.knEOsmS1wW0wQPDdAR29jWpAKYcunEMzlV7Ol1fefvM",
				"package_id":gex[3],
				"account_id":gex[0],
			}
			logger.info(ding)  	
			logger.info(DINGURL) 
			response = yield cls.HttpClient.fetch(DINGURLBUY, method="POST", headers=DINGHEADERS, body=json.dumps(ding))			
			# # response = yield cls.HttpClient.fetch(DINGURL, method="GET", headers=DINGHEADERS)
			# # response = yield cls.HttpClient.fetch(DINGURL, None,True, dic HTTPRequest)
			logger.info("test")
			logger.info(response)
			data_body = json.loads(response.body)
			if(data_body['code']==0):
				ret = yield cls.recordPay(cfg, data, handler.application.myOrderCache, handler.application.orderCache, handler.application.dbcPay, handler.application.payQueue)
				logger.info(ret)
				ret = json.loads(ret)
				if(ret['ret']==0):
					raise Return({"ret":0,"data":data_body['message']})
				else:
					raise Return({"ret":ret['ret'],"data":data_body['message']})
			else:
				logger.info(data_body['message'])
				raise Return({"ret":-100,"data":data_body['message']})
			
		except:
			cls.initHttpClient()
			raise

		raise Return(ret)


		


