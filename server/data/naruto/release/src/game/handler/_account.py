#!/usr/bin/python
# -*- coding: utf-8 -*-
'''
Copyright (c) 2014 YouMi Information Technology Inc.

Account Handlers
'''
from tornado.gen import coroutine, Return
from tornado.httpclient import AsyncHTTPClient, HTTPRequest
import json
from game import ClientError
from game.handler.task import RequestHandlerTask
from game.globaldata import GetInfoConfigUrl, UpdateDeviceInfoConfigUrl

class GameGetUserInfo(RequestHandlerTask):
    url = r'/game/get-user-info'

    @coroutine
    def run(self):
        username = self.input.get('username', '')

        headers = {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
        }

        url = GetInfoConfigUrl + "?username={}".format(username)

        client = AsyncHTTPClient()
        req = HTTPRequest(
            url=url,
            method="GET",
            headers=headers, 
            request_timeout=10
        )

        try:
            resp = yield client.fetch(req)
            self.write({"view": json.loads(resp.body)})
        except Exception as e:
            raise ClientError("Call mangawar error: {}".format(str(e)))

class GameUpdateDeviceInfo(RequestHandlerTask):
    url = r'/game/update-device-info'

    @coroutine
    def run(self):
        username = self.input.get('username', '')
        device = self.input.get('device', 3)
        token = self.input.get('token', '')

        if not token:
            raise ClientError("Token missing")

        headers = {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer {}'.format(token),
            'Accept': 'application/json',
        }

        data = {
            "device": device,
            "username": username
        }

        url = UpdateDeviceInfoConfigUrl

        client = AsyncHTTPClient()
        req = HTTPRequest(
            url=url,
            method="POST",
            headers=headers,
            body=json.dumps(data),
            request_timeout=10
        )

        try:
            resp = yield client.fetch(req)
            self.write({"view": json.loads(resp.body)})
        except Exception as e:
            raise ClientError("Call mangawar error: {}".format(str(e)))

 