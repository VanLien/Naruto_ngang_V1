#!/usr/bin/python
# -*- coding: utf-8 -*-
'''
Copyright (c) 2014 YouMi Information Technology Inc.

server config defines
'''

from nsq_defines import *

PayNotifyHost = 'http://127.0.0.1:28082'

ServerDefs = {
	################
	'payment': {
		'key': 'payment.dev.2',
		'port': 28082,
		'nsq': NSQDefs,
		'game_key_prefix' : ['game.dev.'],
		'dependent': [
			'paymentdb.dev.2',
			'giftdb.dev.2',
		],
	},
}

