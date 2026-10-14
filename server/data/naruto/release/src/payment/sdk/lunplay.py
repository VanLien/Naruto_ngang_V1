#!/usr/bin/python
# -*- coding: utf-8 -*-

from framework.log import logger
from framework.helper import toUTF8Dict
from tornado.gen import coroutine
from payment.sdk.base import SDKBase
from payment.clientdata import ClientData

import json
import hashlib
import urlparse
import base64

# 价格台币
TWRechargeMap = {
    1: 170,
    2: 430,

    102: 33,
    103: 70,
    104: 100,
    105: 130,
    106: 170,
    107: 290,
    108: 490,
    109: 670,
    110: 870,
    111: 990,
    112: 1690,
    113: 3290,

    4101: 33,
    4102: 70,
    4103: 100,
    4104: 130,
    4105: 170,
    4106: 290,
    4107: 430,
    4108: 490,
    4109: 670,
    4110: 870,
    4111: 990,
    4112: 1690,
    4113: 3290,
}

# lp_en, 价格美金
ENRechargeMap = {
    1: 2,
    2: 5,
    10: 9,

    102: 1,
    103: 2,
    104: 3,
    105: 4,
    106: 5,
    107: 9,
    108: 15,
    109: 20,
    110: 26,
    111: 30,
    112: 50,
    113: 100,

    3101: 1,
    3102: 2,
    3103: 3,
    3104: 5,
    3105: 9,
    3106: 15,
    3107: 30,
    3108: 50,
    3109: 100,
}
VNRechargeMap ={
    1: 50000,
    2: 100000,

    102: 10000,
    103: 20000,
    104: 30000,
    105: 40000,
    106: 50000,
    107: 100000,
    108: 150000,
    109: 200000,
    110: 250000,
    111: 300000,
    112: 500000,
    113: 1000000,
    3101: 10000,
    3102: 20000,
    3103: 50000,
    3104: 100000,
    3105: 200000,
    3106: 500000,
    3107:  1000000,
    3108:  2000000,
    3109:  5000000,

    
}

THRechargeMap ={
    1: 60,
    2: 150,
    10: 300,

    102: 30,
    103: 60,
    104: 90,
    105: 120,
    106: 150,
    107: 300,
    108: 450,
    109: 600,
    110: 750,
    111: 900,
    112: 1500,
    113: 3000,

    3101: 30,
    3102: 60,
    3103: 90,
    3104: 150,
    3105: 300,
    3106: 450,
    3107: 900,
    3108: 1500,
    3109: 3000,

    
}


class SDKLunplay(SDKBase):
    Channel = 'lp'
    ReturnOK = json.dumps({"code": 0, "content": "充值成功"})
    ReturnErr = json.dumps({"code": -255, "content": "fail"})
    HttpClient = None
    RechargeMap = TWRechargeMap

    @classmethod
    def parseData(cls, cfg, data):
        #d = dict(urlparse.parse_qsl(data))
        #logger.info("data %s",data)
        d = json.loads(data)

        #logger.info("money %s",d["money"])
        sign = d['order'] + cfg['key2'] + d['time']
        sign = sign.encode('utf-8')
        sign = hashlib.md5(sign).hexdigest()
        

        #logger.info("%s %s %s",d['order'] , cfg['key2'] , d['time'])

        #logger.info("sign %s , dsign %s",sign,d['sign'])
        if sign != d['sign']:
            logger.error('%s sign error %s', cls.Channel, data)
            raise Exception('sign error')



        #logger.info("parseData %s",d)
        #logger.info('[thapta ] channel `{channel}` agent `{agent}` passport `{passport}` server `{server}` order `{order}` money `{money}` sign `{sign}` time `{time}` param `{param}` goodid `{goodid}` repro `{repro}`'.format(channel=cls.Channel, repro=d.get('rePro', 0), **d))
        return d
        # if 'rePro' in d:
        #     sign = d['passport'] + d['order'] + cfg['key2'] + d['server'] + d['time'] + d['agent'] + d['money'] + d['goodid'] + d['rePro']
        # else:
        #     sign = d['passport'] + d['order'] + cfg['key2'] + d['server'] + d['time'] + d['agent'] + d['money'] + d['goodid']
        # sign = hashlib.md5(sign).hexdigest()

        # if sign != d['sign']:
        #     logger.error('%s sign error %s', cls.Channel, data)
        #     raise Exception('sign error')

        # return d

    @classmethod
    def getOrderResult(cls, d):
        return True

    @classmethod
    def getOrderID(cls, d):
        #logger.info('getOrderID %s', d)
        return d['order']

    @classmethod
    def getClientInfo(cls, d):
        if d['param'][0] == '[' and d['param'][-1] == ']':
             data = d['param']
        else:
            data = base64.b64decode(d['param'])

        cdata = ClientData(data)

        if float(d['money']) != float(cls.RechargeMap[cdata.rechargeID]):
            logger.error('%s %s recharge amount error', cls.Channel, cls.getOrderID(d))
            return None
        return data

    @classmethod
    def getOrderAmount(cls, d):
        return float(d['money'])

    @classmethod
    def getOrderErrMsg(cls, d):
        return ''

    @classmethod
    def parseDataReProToGame(cls, data):
        d = dict(urlparse.parse_qsl(data))
        rePro = int(d.get('rePro', 0))
        if rePro < 0 or rePro > 100:
            logger.warning('%s %s rePro error, got %s', cls.Channel, d['order'], rePro)
            rePro = 0
        dd = {
            'rePro': rePro,
        }
        return dd

class SDKLunplayVN(SDKLunplay):
    Channel = 'lp_vn'
    ReturnOK = json.dumps({"code": 0, "content": "充值成功"})
    ReturnErr = json.dumps({"code": -255, "content": "fail"})
    HttpClient = None
    RechargeMap = VNRechargeMap

class SDKLunplayKR(SDKLunplay):
    Channel = 'lp_kr'
    ReturnOK = json.dumps({"code": 0, "content": "充值成功"})
    ReturnErr = json.dumps({"code": -255, "content": "fail"})
    HttpClient = None
    RechargeMap = TWRechargeMap

class SDKLunplayEN(SDKLunplay):
    Channel = 'lp_en'
    ReturnOK = json.dumps({"code": 0, "content": "充值成功"})
    ReturnErr = json.dumps({"code": -255, "content": "fail"})
    HttpClient = None
    RechargeMap = ENRechargeMap
    import framework
    language = framework.__language__
    if language == 'th':
        RechargeMap = THRechargeMap
        


class SDKLunplayGift(SDKLunplay):
    Channel = 'lp_gift'
    ReturnOK = json.dumps({"code": 0, "msg": "充值成功"})
    ReturnErr = json.dumps({"code": -255, "msg": "fail"})
    HttpClient = None
    ClientInfo = ['000000000000000000000000','000000000000000000000000',"",0,0,0]

    @classmethod
    def parseData(cls, cfg, data):
        d = dict(urlparse.parse_qsl(data))
        logger.info('channel `{channel}` ck `{ck}` t `{t}` itemCode `{itemCode}` orderID `{orderID}` passport `{passport}` gameCode `{gameCode}` money `{money}` giftID `{giftID}`'.format(channel=cls.Channel, **d))
        ck = d['itemCode'] + d['orderID'] + d['t'] + cfg['key2'] + d['passport'] + d['gameCode'] + d['money'] + d['giftID']
        ck = hashlib.md5(ck).hexdigest()

        if ck != d['ck']:
            logger.error('%s ck error %s', cls.Channel, data)
            raise Exception('ck error')
        return d

    @classmethod
    def getOrderID(cls, d):
        return d['orderID']

    @classmethod
    def getClientInfo(cls, d):
        return cls.ClientInfo

    @classmethod
    def getReturnOK(cls, d):
        ret = {"code": 3, "msg": "查询成功"}
        ret['cardNum'] = d
        return json.dumps(ret)

