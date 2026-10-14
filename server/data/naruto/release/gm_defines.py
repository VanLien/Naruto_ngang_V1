#!/usr/bin/python
# -*- coding: utf-8 -*-
'''
Copyright (c) 2014 YouMi Information Technology Inc.

server config defines
'''

from nsq_defines import *


ServerDefs = {
    'gm': {
                'key': 'gm.vn.1',
                'nsq': NSQDefs,
                'http_port': 39081,
                'game_key_prefix': ['game.vn.', 'gamemerge.vn.'],
                'dependent': [
                        'accountdb.vn.1',
                        'giftdb.vn.1',     
                        'card_comment.vn.1',                        
                ],
                'mongo': {
                    'port': 27018,
                    'dbname': 'gm_web'
                },
                'account_mongo': {
                        'port': 27018,
                        'dbname': 'account'
                },
                'payorder_mongo': {
                        'port': 27018,
                        'dbname': 'account'
                },
                'login_log_path': '/data/naruto/deploy/childlog',
                'debug': False,
        },
        'gm_dev': {
                'key': 'gm.dev.1',
                'nsq': DEVNSQDefs,
                'game_key_prefix': ['game.dev.','game.vn.', 'gamemerge.vn.', 'gamemerge.dev.'],
                'http_port': 39081,
                'dependent': [
                        'accountdb.dev.1',
                        'giftdb.dev.1', 
                        'card_comment.dev.1',                         
                ],
                'mongo': {
                    'port': 27018,
                    'dbname': 'gm_web'
                },
                'account_mongo': {
                        'port': 27018,
                        'dbname': 'account'
                },
                'payorder_mongo': {
                        'port': 27018,
                        'dbname': 'account'
                },
                'login_log_path': '/data/naruto/deploy/childlog',
                'debug': False,
        },

        'gm_en': {
                'key': 'gm.en.1',
                'nsq': ENNSQDefs,
                'game_key_prefix': ['game.dev.','game.en.', 'gamemerge.en.','game.vn.', 'gamemerge.vn.'],
                'http_port': 39081,
                'dependent': [
                        'accountdb.en.1',
                        'giftdb.en.1', 
                        'card_comment.en.1',                         
                ],
                'mongo': {
                    'port': 27018,
                    'dbname': 'gm_web'
                },
                'account_mongo': {
                        'port': 27018,
                        'dbname': 'account'
                },
                'payorder_mongo': {
                        'port': 27018,
                        'dbname': 'account'
                },
                'login_log_path': '/data/naruto/deploy/childlog',
                'debug': False,
        },
        'gm_th': {
                'key': 'gm.th.1',
                'nsq': THNSQDefs,
                'game_key_prefix': ['game.dev.','game.en.', 'gamemerge.en.','game.vn.', 'gamemerge.vn.','game.th.','gamemerge.th.'],
                'http_port': 39081,
                'dependent': [
                        'accountdb.th.1',
                        'giftdb.th.1', 
                        'card_comment.th.1',                         
                ],
                'mongo': {
                    'port': 27018,
                    'dbname': 'gm_web'
                },
                'account_mongo': {
                        'port': 27018,
                        'dbname': 'account'
                },
                'payorder_mongo': {
                        'port': 27018,
                        'dbname': 'account'
                },
                'login_log_path': '/data/naruto/deploy/childlog',
                'debug': False,
        },
	

}

