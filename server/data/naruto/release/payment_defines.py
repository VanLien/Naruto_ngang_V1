#!/usr/bin/python
# -*- coding: utf-8 -*-
'''
Copyright (c) 2014 YouMi Information Technology Inc.

server config defines
'''

from nsq_defines import *

PayNotifyHost = 'http://180.93.98.5:28081'

ServerDefs = {
	################
	'payment.dev.1': {
		'key': 'payment.dev.1',
		'port': 28081,
		'nsq': DEVNSQDefs,
		'game_key_prefix' : ['game.cn.', "game.vn.", "game.en.","game.dev."],
		'dependent': [
			'paymentdb.dev.1',
			'giftdb.dev.1',
			'game.shenhe.1',
			'game.dev.1',
		],
	},
    

	'payment.vn.1': {
		'key': 'payment.vn.1',
		'port': 28081,
		'nsq': NSQDefs,
		'game_key_prefix' : ['game.cn.', "game.vn.", "game.en.","game.dev."],
		'dependent': [
			'paymentdb.vn.1',
			'giftdb.vn.1',
			# 'game.shenhe.1',
			
		],
	},
    'payment.en.1': {
		'key': 'payment.en.1',
		'port': 28081,
		'nsq': ENNSQDefs,
		'game_key_prefix' : ['game.cn.', "game.vn.", "game.en.","game.dev."],
		'dependent': [
			'paymentdb.en.1',
			'giftdb.en.1',
			# 'game.shenhe.1',
			
		],
	},
    'payment.th.1': {
		'key': 'payment.th.1',
		'port': 28081,
		'nsq': THNSQDefs,
		'game_key_prefix' : ['game.cn.', "game.vn.", "game.en.","game.dev.","game.th."],
		'dependent': [
			'paymentdb.th.1',
			'giftdb.th.1',
			# 'game.shenhe.1',
			
		],
	},
    
    
	
}

