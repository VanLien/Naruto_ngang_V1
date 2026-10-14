#!/usr/bin/python
# -*- coding: utf-8 -*-

import copy
import hashlib
import datetime
import binascii

from bson.objectid import ObjectId


def calc_md5(pwd):
	md5 = hashlib.md5()
	md5.update(pwd)
	return md5.hexdigest()


def datetime2str(d, f='S'):
    if f == 'S':
        return d.strftime("%Y-%m-%d %H:%M:%S")
    elif f == 'M':
        return d.strftime("%Y-%m-%d %H:%M")
    elif f == 'H':
        return d.strftime("%Y-%m-%d %H")
    elif f == 'd':
        return d.strftime("%Y-%m-%d")

def str2datetime(s, f='S'):
    if f == 'S':
        return datetime.datetime.strptime(s, "%Y-%m-%d %H:%M:%S")
    elif f == 'd':
        return datetime.datetime.strptime(s, "%Y-%m-%d")

def hexlifyDictField(dl):
    dlc = copy.deepcopy(dl)
    if isinstance(dlc, list):
        for d in dlc:
        	_hexlify(d)
    else:
        _hexlify(dlc)
    return dlc

def _hexlify(d):
    for k, v in d.items():
        if isinstance(v, ObjectId):
            d[k] = binascii.hexlify(v.binary)
        elif k in ('id', 'account_id', 'union_db_id', 'db_id', 'role_db_id', 'record_id') and v:
            d[k] = binascii.hexlify(v)


############
# statistics helper
############

# RechargeMap = [0, 0, 0, 648, 328, 198, 98, 60, 30, 6, 0, 0, 0, 0, 0, 0, 0]
RechargeMap = {
    1: 0,
    2: 0,
    3: 648,
    4: 328,
    5: 198,
    6: 98,
    7: 60,
    8: 30,
    9: 6,

    1001: 648,
    1002: 328,
    1003: 198,
    1004: 98,
    1005: 60,
    1006: 30,
    1007: 6,
    102:0.43,
    103:0.87,
    104:1.3,
    105:1.74,
    106:2.17,
    107:4.35,
    108:6.52,
    109:8.7,
    110:10.87,
    111:13.04,
    112:21.74,
    113:43.48,
    3101:0.43,
    3102:0.87,
    3103:2.17,
    3104:4.35,
    3105:8.7,
    3106:21.74,
    3107:43.48,
    3108:86.96,
    3109:217.39
}
TWRechargeMap = [0, 0, 0, 99.99, 48.99, 28.99, 14.99, 9.99, 4.99, 0.99, 0, 0, 0, 0, 0, 0, 0]
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
VNRechargeMap = {
    1: 0,
    2: 0,
    3: 99.99,
    4: 48.99,
    5: 28.99,
    6: 14.99,
    7: 9.99,
    8: 4.99,
    9: 0.99,

    21:     0.99,
    22:     1.99,
    23:     4.99,
    24:     9.99,
    25:     24.99,
    26:     49.99,
    27:     99.99,

    31:     0.42,
    32:     0.84,
    33:     1.26,
    34:     2.10,
    35:     2.52,
    36:     4.20,
    37:     8.40,
    38:     12.60,
    39:     21.00,
    40:     42.00,
    41:     84.00,
    42:     210.00,
    43:     420.00,
    102:0.43,
    103:0.87,
    104:1.3,
    105:1.74,
    106:2.17,
    107:4.35,
    108:6.52,
    109:8.7,
    110:10.87,
    111:13.04,
    112:21.74,
    113:43.48,
    3101:0.43,
    3102:0.87,
    3103:2.17,
    3104:4.35,
    3105:8.7,
    3106:21.74,
    3107:43.48,
    3108:86.96,
    3109:217.39
}
THRechargeMap = {
    1: 60,
    2: 150,
    10: 900,

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
    3109: 3000
}
# orders {xxx: PayOrder.Model}

def sumRecharges(orders, language):
    import framework
    language = framework.__language__
    if language == 'cn':
        recharges = [RechargeMap[d['recharge_id']] for d in orders.itervalues() if d['recharge_id'] in RechargeMap]
    elif language == 'tw':
        recharges = [TWRechargeMap[d['recharge_id']] for d in orders.itervalues()]
    elif language == 'en':
        recharges = [ENRechargeMap[d['recharge_id']] for d in orders.itervalues()]
    elif language == 'vn':
        recharges = [VNRechargeMap[d['recharge_id']] for d in orders.itervalues() if d['recharge_id'] in VNRechargeMap]
    elif language == 'th':
        recharges = [THRechargeMap[d['recharge_id']] for d in orders.itervalues() if d['recharge_id'] in THRechargeMap]

    s = sum(recharges)
    # 保留小数点后2位
    if isinstance(s, float):
        s = round(s, 2)
    return s

RechargeConvertMap = {
    'cn': RechargeMap,
    'tw': TWRechargeMap,
    'en': ENRechargeMap,
    'vn': VNRechargeMap,
    'th': THRechargeMap
}
def convertRecharge(recharge_id, language):
    return RechargeConvertMap[language][recharge_id]

# TODO: 混服后会影响到server_key
def getServerArea(servKey):
    s = filter(lambda c: c.isdigit(), servKey)
    try:
        return int(s)
    except:
        return None

def getServerLanguageByKey(servKey):
    import framework
    return framework.__language__

    if servKey.find('_qq') >= 0:
        return 'cn'
    try:
        serverLanguage = servKey.split('_')[1][:2]
    except IndexError as e:
        if servKey == "game":
            return 'cn'
        else:
            raise e
    return serverLanguage

# mofang_iy, mofang_ay: en
# mofang_if, mofang_af, mofang_google: tw
# tutu: en
# funtap_ios, funtap_android: vn
def getServerLanguageByChannel(channel, subChannel):
    import framework
    return framework.__language__

    if channel.find('mofang') >= 0:
        # mofang_af, mofang_iy
        # channel无法区分，得靠subChannel
        if subChannel[-1] == 'y':
            return 'en'
        elif subChannel[-2:] == 'th':
            return 'th'
        return 'tw'
    elif channel.find('funtap') >= 0:
        return 'vn'
    elif channel == 'tutu':
        return 'en'
    elif channel.find('mrgl') >= 0:
        return 'en'
    return 'cn'

def slimOrder(order):
    return {
        '_id': order._id,
        # 'account_id': order.account_id,
        'server_key': order.server_key,
        # 'role_id': order.role_id,
        # 'time': order.time,
        # 'channel': order.channel,
        'recharge_id': order.recharge_id,
    }


# serv key name helper
# copy from framework.distributed.helper
from framework.distributed.helper import serv_key2domains, node_domains2key

ServNameKeyMap = {
    'game.dev.1': 'game_dev1',
    'game.dev.2': 'game_dev2',
    'game.dev.3': 'game_dev3',
    'game.dev.4': 'game_dev4',
    'game.dev.5': 'game_dev5',
    'game.dev.6': 'game_dev6',

    'game_dev1': 'game.dev.1',
    'game_dev2': 'game.dev.2',
    'game_dev3': 'game.dev.3',
    'game_dev4': 'game.dev.4',
    'game_dev5': 'game.dev.5',
    'game_dev6': 'game.dev.6',
}

def servName2ServKey(servName):
    if servName in ServNameKeyMap:
        return ServNameKeyMap[servName]
    domains = serv_key2domains(servName)
    return node_domains2key(domains)

def servKey2ServName(nodekey):
    if nodekey in ServNameKeyMap:
        return ServNameKeyMap[nodekey]
    servName = ''
    domains = nodekey.split('.')
    if len(domains) == 3:
        servName = '%s_%s%02d' % (domains[0], domains[1], int(domains[2]))
    elif len(domains) == 2:
        servName = '%s_qq%02d' % (domains[0], int(domains[1]))
    else:
        raise Exception('error nodekey %s', nodekey)
    return servName

def roleKey2RedisZKey(roleKey):
    return '_'.join((roleKey[0], str(roleKey[1])))

def redisZKey2RoleKey(key):
    domains = key.split('_')
    return (domains[0], int(domains[1]))

def is_key(key):
    if key.find('_') == -1:
        return True
    return False

def objectid2str(_id):
    if isinstance(_id, ObjectId):
        s = binascii.hexlify(_id.binary)
        return s
    return _id

def str2objectid(s):
    assert len(s) == 24, '%s length is not 24'% s
    return ObjectId(s)

# copy from framework.csv.MergeServ
class MergeServ(object):
    DestServMerge = {} # {gamemerge.1: [game.1, ...]}
    DestServAreas = {} # {gamemerge.1: [1, 2, 3]}
    SrcServMerge = {} # {game.1 : gamemerge.1}
    ServCfg = {} # {gamemerge.1: cfg}

    @classmethod
    def classInit(cls):
        cls.DestServMerge = {}
        cls.DestServAreas = {}
        cls.SrcServMerge = {}
        cls.ServCfg = {}
        mergemap = {}

        mergesDestL = []
        for idx in sorted(csv.server.merge.keys()):
            cfg = csv.server.merge[idx]
            if cfg.realityMerge != 1:
                continue
            mergemap[cfg.destServer] = cfg.servers
            cls.ServCfg[cfg.destServer] = cfg
            mergesDestL.append(cfg.destServer)

        def destServ2SrcServ(dest):
            srcServ = mergemap[dest]
            servs = []
            for serv in srcServ:
                if serv in mergemap:
                    if serv != dest:
                        servs.extend(destServ2SrcServ(serv))
                    else:
                        servs.append(serv)
                else:
                    servs.append(serv)
            return servs

        for dest in mergesDestL:
            srcs = destServ2SrcServ(dest)
            cls.DestServMerge[dest] = srcs
            cls.DestServAreas[dest] = [int(key.split('.')[-1]) for key in srcs]
            for src in srcs:
                cls.SrcServMerge[src] = dest

    @classmethod
    def getMergeServKey(cls, srcKey):
        return cls.SrcServMerge.get(srcKey, srcKey)

    @classmethod
    def getSrcServKeys(cls, mergeKey):
        return cls.DestServMerge.get(mergeKey, [mergeKey])

    @classmethod
    def getSrcServAreas(cls, mergeKey):
        return cls.DestServAreas.get(mergeKey, [int(mergeKey.split('.')[-1])])

    @classmethod
    def getServCfg(cls, servKey):
        return cls.ServCfg.get(servKey, None)

    @classmethod
    def inSubServer(cls, destKey, srcKey):
        return srcKey in cls.DestServMerge.get(destKey, [])

    @classmethod
    def isServMerged(cls, servKey):
        if servKey not in cls.DestServMerge:
            return False
        srcKeys = cls.DestServMerge.get(servKey)
        if len(srcKeys) > 1 or srcKeys[0] != servKey:
            return True
        return False

    @classmethod
    def slimServNames(cls, servNames):
        from framework.distributed.helper import servName2ServKey

        key2name = {}
        keys = set()
        for name in servNames:
            key = servName2ServKey(name)
            key2name[key] = name
            keys.add(cls.getMergeServKey(key))
        retKeys = []
        for key in keys:
            retKeys.append(cls.getSrcServKeys(key)[0])
        retNames = [key2name[key] for key in retKeys]
        return retNames
