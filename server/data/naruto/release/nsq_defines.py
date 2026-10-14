#!/usr/bin/python
# -*- coding: utf-8 -*-
'''
Copyright (c) 2014 YouMi Information Technology Inc.
Copyright (c) 2016 TianJi Information Technology Inc.

nsq default config defines
'''


NSQDefs = {
	'reader': {
		'max_in_flight': 10,
		'nsqd_tcp_addresses': ['180.93.98.5:4150', '180.93.98.5:4151'],
		'output_buffer_size': 16 * 1024, # default 16kb
		# 'output_buffer_timeout': 25, # default 250ms
		'output_buffer_timeout': 30, # default 250ms
	},
	'writer': {
		'reconnect_interval': 5.0,
		'nsqd_tcp_addresses': ['180.93.98.5:4150', '180.93.98.5:4151'],
	},
}


DEVNSQDefs = {
	'reader': {
		'max_in_flight': 10,
		'nsqd_tcp_addresses': ['110.172.29.223:4150', '110.172.29.223:4151'],
		'output_buffer_size': 16 * 1024, # default 16kb
		# 'output_buffer_timeout': 25, # default 250ms
		'output_buffer_timeout': 30, # default 250ms
	},
	'writer': {
		'reconnect_interval': 5.0,
		'nsqd_tcp_addresses': ['110.172.29.223:4150', '110.172.29.223:4151'],
	},
}

TRIALNSQDefs = {
		'reader': {
				'nsqd_tcp_addresses': '127.0.0.1:5150',
				'output_buffer_size': 16 * 1024, # default 16kb
				'output_buffer_timeout': 25, # default 250ms
		},
		'writer': {
				'nsqd_tcp_addresses': '127.0.0.1:5150',
		},
}

CNNSQDefs = {
	'reader': {
		'max_in_flight': 10,
		'nsqd_tcp_addresses': ['127.0.0.1:4152', '127.0.0.1:4153'],
		'output_buffer_size': 16 * 1024, # default 16kb
		'output_buffer_timeout': 25, # default 250ms
	},
	'writer': {
		'reconnect_interval': 5.0,
		'nsqd_tcp_addresses': ['127.0.0.1:4152', '127.0.0.1:4153'],
	},
}

KRNSQDefs = {
	'reader': {
		'max_in_flight': 10,
		'nsqd_tcp_addresses': ['192.168.1.7:4150'],
		'output_buffer_size': 16 * 1024, # default 16kb
		'output_buffer_timeout': 25, # default 250ms
	},
	'writer': {
		'reconnect_interval': 5.0,
		'nsqd_tcp_addresses': ['192.168.1.7:4150'],
	},
}

ENNSQDefs = {
	'reader': {
		'max_in_flight': 10,
		'nsqd_tcp_addresses': ['15.235.218.69:4150', '15.235.218.69:4151'],
		'output_buffer_size': 16 * 1024, # default 16kb
		# 'output_buffer_timeout': 25, # default 250ms
		'output_buffer_timeout': 30, # default 250ms
	},
	'writer': {
		'reconnect_interval': 5.0,
		'nsqd_tcp_addresses': ['15.235.218.69:4150', '15.235.218.69:4151'],
	},
}

TWNSQDefs = {
	'reader': {
		'max_in_flight': 10,
		'nsqd_tcp_addresses': ['172.19.0.15:4150'],
		'output_buffer_size': 16 * 1024, # default 16kb
		'output_buffer_timeout': 25, # default 250ms
	},
	'writer': {
		'reconnect_interval': 5.0,
		'nsqd_tcp_addresses': ['172.19.0.15:4150'],
	},
}

THNSQDefs = {
	'reader': {
		'max_in_flight': 10,
		'nsqd_tcp_addresses': ['15.235.181.86:4150', '15.235.181.86:4151'],
		'output_buffer_size': 16 * 1024, # default 16kb
		# 'output_buffer_timeout': 25, # default 250ms
		'output_buffer_timeout': 30, # default 250ms
	},
	'writer': {
		'reconnect_interval': 5.0,
		'nsqd_tcp_addresses': ['15.235.181.86:4150', '15.235.181.86:4151'],
	},
}
