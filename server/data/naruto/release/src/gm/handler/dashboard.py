# -*- coding: utf-8 -*-

from __future__ import absolute_import

from tornado.gen import coroutine
from tornado.web import HTTPError

from .base import BaseHandler, AuthedHandler
from ..object.session import Session, SESSION_KEY
from ..object.scheme import User
from gm.util import calc_md5, datetime2str
from framework.csv import csv
import json
import time
import datetime
import traceback
class LoginHandler(BaseHandler):
	url = "/login"

	@coroutine
	def get(self):
		self.render_page("login.html", error="")

	@coroutine
	def post(self):
		username = self.get_argument("username")
		password = self.get_argument("password")
		
		pass_md5 = calc_md5(password)

		if Session.existSession(username):
			session = Session.getSession(username)
			if session.pass_md5 == pass_md5:
				sessionID = session.resetIdent()
				self.set_secure_cookie(SESSION_KEY, sessionID)
				self.redirect("/")
			else:
				self.render("login.html", error=self.translate(u"用户名或密码不正确"), userLocale=self.language)
		else:
			account = User.find_one(self.mongo_client, {"name": username})
			if not account or account["pass_md5"] != pass_md5:
				self.render("login.html", error=self.translate(u"用户名或密码不正确"), userLocale=self.language)
			else:
				session = Session(account)
				# 给账户设置一个默认的语言，framework.__language__
				# session.setLanguage(self.language)
				self.set_secure_cookie(SESSION_KEY, session.sessionID)
				self.redirect("/")


class LogoutHandler(AuthedHandler):
	url = "/logout"

	@coroutine
	def get(self):
		self.current_user.logout()
		self.clear_cookie(SESSION_KEY)
		self.redirect("/login")


class HomePageHandler(AuthedHandler):
	url = "/"
	QueryLimit = [0, time.time()]
	QueryResult = ['x', 0, 0, 0] # activate, sign, recharge, amount

	@coroutine
	def get(self):
		if self.QueryLimit[0] > 0 and time.time() - self.QueryLimit[1] < 5*60:
			self.render_page("dashboard.html", overview=QueryResult)
			return
		self.QueryResult[1] = self.mongo_client.Account.count()
		self.QueryResult[2] = self.mongo_client.Account.count({'first_pay_time': {'$gt': 0.0}})
		orderAmount = self.mongo_client.Cursor.find_one({'cur_name': 'cur_order_amount'})
		self.QueryResult[3] = orderAmount['cur_value'] if orderAmount else 0.0
		self.render_page("dashboard.html", overview=self.QueryResult)


class languageSetHandler(AuthedHandler):
	url = "/lanauge_set"

	@coroutine
	def get(self):
		language = self.get_argument("lang")
		self.current_user.setLanguage(language)
		referer = self.request.headers.get("Referer", None)
		if referer:
			self.redirect(referer)
		else:
			self.redirect("/")


class AccountCreationHandler(AuthedHandler):
	url = "/create_account"

	@coroutine
	def get(self):
		name = self.get_argument("name")
		if not Session.existSession(name):
			account = User.find_one(self.mongo_client, {"name": name})
			if not account:
				self.write_json({"ret": True,})
				return
		self.write_json({"ret": False,})

	@coroutine
	def post(self):
		if self.current_user.permission < 999:
			raise HTTPError(504, "NOT Enough Permisson")

		requestData = self.get_json_data()
		pass_md5 = calc_md5(requestData['pwd'])
		nowS = datetime2str(datetime.datetime.now())

		data = {
			"name": requestData["name"],
			"pass_md5": pass_md5,
			"permission_level": int(requestData["level"]),
			"create_time": nowS,
			"last_time": nowS
		}

		User.insert_one(self.mongo_client, data)

		self.write_json({"ret": True, "data": "success"})

class Test(BaseHandler):
	url = '/test'

	def get(self):
		self.render_page('_send_mail.html',"admin","game.dev.1","luo","vn")
class CustomSendNotification(BaseHandler):
	url = '/custom_send_notification'

	@coroutine
	def get(self):
		paramData = self.get_json_data()
		username = paramData["username"]
		password = paramData["password"]
		message = paramData["message"]
		servName = paramData['servName']
		messType = paramData['type']
		isAuthenticated = False
		try:
			pass_md5 = calc_md5(password)
			# self.write_json({"ret": True, "data": username,"pass_md5":str(pass_md5)})
			if Session.existSession(username):
				#self.write_json({"ret": False, "data": "k vao"})
				session = Session.getSession(username)
				if session.pass_md5 == pass_md5:
					sessionID = session.resetIdent()
					self.set_secure_cookie(SESSION_KEY, sessionID)
					self.session = Session.getSession(username)
					isAuthenticated = True

				else:
					self.write_json({"ret": False, "data": "not found account"})
			else:
				
				account = User.find_one(self.mongo_client, {"name": username})
				if not account or account["pass_md5"] != pass_md5:
					self.write_json({"ret": False, "data": "not found account"})
				else:
					session = Session(account)
					self.set_secure_cookie(SESSION_KEY, session.sessionID)
					self.session = Session(account)
					isAuthenticated = True
		
		except Exception as error:
			traceback.print_exc()	
		#self.write({"ok":isAuthenticated})	
			
		# if isAuthenticated is True:
			
		# 	retS, retF = [], []			
		r = yield self.userGMRPC.gmSendMessage(Session.getSession(username),servName,messType, None, message,0) # send personal mail			
		self.write({"ok":True,"ret": r})		
		# else:
		# 	raise HTTPError(404, reason="wrong news")
		
class CustomSendMail(BaseHandler):
	url = '/custom_send_mail'

	# def get(self):
	# 	username = self.get_argument("username")
	# 	password = self.get_argument("password")
	# 	self.write_json({"ret": True, "data": username,"password":password})

	@coroutine
	def get(self):
		paramData = self.get_json_data()
		username = paramData["username"]
		password = paramData["password"]
		
		try:
			pass_md5 = calc_md5(password)
			# self.write_json({"ret": True, "data": username,"pass_md5":str(pass_md5)})
			if Session.existSession(username):
				#self.write_json({"ret": False, "data": "k vao"})
				session = Session.getSession(username)
				if session.pass_md5 == pass_md5:
					sessionID = session.resetIdent()
					self.set_secure_cookie(SESSION_KEY, sessionID)
					
					#self.write_json({"ret": True, "data": str(Session.getSession(username))})
				else:
					self.write_json({"ret": False, "data": "not found account"})
			else:
				
				account = User.find_one(self.mongo_client, {"name": username})
				if not account or account["pass_md5"] != pass_md5:
					self.write_json({"ret": False, "data": "not found account"})
					#self.write_json({"ret": False, "data": None})
				else:
					#self.write_json({"ret": False, "data": "find account"})
					session = Session(account)
					# 给账户设置一个默认的语言，framework.__language__
					# session.setLanguage(self.language)
					self.set_secure_cookie(SESSION_KEY, session.sessionID)
					
					#self.write_json({"ret": True, "data": str(Session(account))})
			#			
		except Exception as error:
			traceback.print_exc()
		mailType = paramData['mailType']
		mailAddressee = paramData['receive'] or False
		mailSender = paramData['sender'] or False
		mailTitle = paramData['subject'] or False
		mailContent = paramData['content'] or False

		# 全服邮件发送邮件模板不能转，默认第一个模板。
		try:
			mailTemplate = int(paramData.get('mailTemp', False))
		except Exception as e:
			mailTemplate = 1

		# 附件
		mailAttach = json.loads(paramData.get('attachs'))

		for k, v in mailAttach.items():
			print(k,v)
			try:
				newk = int(k)
			except ValueError:
				pass
			else:
				mailAttach.pop(k, None)
				mailAttach[newk] = v

		if paramData['servName'] == "allservers":
			servName = "__@global@__"
		else:
			servName = paramData['servName']

		if mailType == "role":
			mailAddresseeList = mailAddressee.split(';')
			retS, retF = [], []
			for roleID in mailAddresseeList:
				r = yield self.userGMRPC.gmSendMail(Session.getSession(username), servName, roleID, mailTemplate, mailSender, mailTitle, mailContent, mailAttach) # send personal mail
				if r:
					retS.append(roleID)
				else:
					retF.append(roleID)
			self.write({'retF': retF, 'retS': retS})		
		else:
			raise HTTPError(404, reason="wrong mailtype")

class CustomGetOnlineRole(BaseHandler):
	url = r'/custom_get_online_role'

	# def get(self):
	# 	username = self.get_argument("username")
	# 	password = self.get_argument("password")
	# 	self.write_json({"ret": True, "data": username,"password":password})

	@coroutine
	def get(self):
		paramData = self.get_json_data()
		username = paramData["username"]
		password = paramData["password"]
		servName = paramData['servName']
		try:
			pass_md5 = calc_md5(password)
			if Session.existSession(username):
				session = Session.getSession(username)
				if session.pass_md5 == pass_md5:
					sessionID = session.resetIdent()
					self.set_secure_cookie(SESSION_KEY, sessionID)
					
				else:
					self.write_json({"ret": False, "data": "not found account"})
			else:
				
				account = User.find_one(self.mongo_client, {"name": username})
				if not account or account["pass_md5"] != pass_md5:
					self.write_json({"ret": False, "data": "not found account"})
				else:
					session = Session(account)

					self.set_secure_cookie(SESSION_KEY, session.sessionID)
     
					
		except Exception as error:
			traceback.print_exc()		
		r = yield self.userGMRPC.CustomGmGetOnlineRoles(Session.getSession(username), servName)
		self.write({'ret': str(r)})	
  
class CustomGmGetServerOnline(BaseHandler):
	url = r'/custom_get_server_online'

	# def get(self):
	# 	username = self.get_argument("username")
	# 	password = self.get_argument("password")
	# 	self.write_json({"ret": True, "data": username,"password":password})

	@coroutine
	def get(self):
		paramData = self.get_json_data()
		username = paramData["username"]
		password = paramData["password"]
		serverCount = paramData['serverCount']
		
		try:
			pass_md5 = calc_md5(password)
			if Session.existSession(username):
				session = Session.getSession(username)
				if session.pass_md5 == pass_md5:
					sessionID = session.resetIdent()
					self.set_secure_cookie(SESSION_KEY, sessionID)
					
				else:
					self.write_json({"ret": False, "data": "not found account"})
			else:
				
				account = User.find_one(self.mongo_client, {"name": username})
				if not account or account["pass_md5"] != pass_md5:
					self.write_json({"ret": False, "data": "not found account"})
				else:
					session = Session(account)

					self.set_secure_cookie(SESSION_KEY, session.sessionID)
     
					
		except Exception as error:
			traceback.print_exc()		
		r = yield self.userGMRPC.CustomGmGetServerOnline(Session.getSession(username), serverCount)
		self.write({'ret': str(r)})		
class CustomGmGetServerReleaseOnline(BaseHandler):
	url = r'/custom_get_server_release_online'

	# def get(self):
	# 	username = self.get_argument("username")
	# 	password = self.get_argument("password")
	# 	self.write_json({"ret": True, "data": username,"password":password})

	@coroutine
	def get(self):
		paramData = self.get_json_data()
		username = paramData["username"]
		password = paramData["password"]
		serverCount = paramData['serverCount']
		try:
			pass_md5 = calc_md5(password)
			if Session.existSession(username):
				session = Session.getSession(username)
				if session.pass_md5 == pass_md5:
					sessionID = session.resetIdent()
					self.set_secure_cookie(SESSION_KEY, sessionID)
					
				else:
					self.write_json({"ret": False, "data": "not found account"})
			else:
				
				account = User.find_one(self.mongo_client, {"name": username})
				if not account or account["pass_md5"] != pass_md5:
					self.write_json({"ret": False, "data": "not found account"})
				else:
					session = Session(account)

					self.set_secure_cookie(SESSION_KEY, session.sessionID)    				
		except Exception as error:
			traceback.print_exc()		
		r = yield self.userGMRPC.CustomGmGetServerReleaseOnline(Session.getSession(username), serverCount)
		self.write({'ret': str(r)})		



class GenFullCardHandler(BaseHandler):
	url = r'/gen_full_card_handler'

	@coroutine
	def get(self):
		paramData = self.get_json_data()
		username = paramData["username"]
		password = paramData["password"]
		
		try:
			pass_md5 = calc_md5(password)
			# self.write_json({"ret": True, "data": username,"pass_md5":str(pass_md5)})
			if Session.existSession(username):
				#self.write_json({"ret": False, "data": "k vao"})
				session = Session.getSession(username)
				if session.pass_md5 == pass_md5:
					sessionID = session.resetIdent()
					self.set_secure_cookie(SESSION_KEY, sessionID)
					
					#self.write_json({"ret": True, "data": str(Session.getSession(username))})
				else:
					self.write_json({"ret": False, "data": "not found account"})
			else:
				
				account = User.find_one(self.mongo_client, {"name": username})
				if not account or account["pass_md5"] != pass_md5:
					self.write_json({"ret": False, "data": "not found account"})
					#self.write_json({"ret": False, "data": None})
				else:
					#self.write_json({"ret": False, "data": "find account"})
					session = Session(account)
					# 给账户设置一个默认的语言，framework.__language__
					# session.setLanguage(self.language)
					self.set_secure_cookie(SESSION_KEY, session.sessionID)
					
					#self.write_json({"ret": True, "data": str(Session(account))})
			#			
		except Exception as error:
			traceback.print_exc()
		roleID = paramData['roleID']
		serverName = paramData['serverName']
		access_token = paramData['access_token']
		if access_token=="vlxx":
			self.write({'ret': False, 'msg': 'gen full card ok','roleID': roleID})
			ret = yield self.userGMRPC.gmCreateFullCardForRole(Session.getSession(username), serverName,roleID,[{'id':2}])
			self.write({'result': ret})
		else:
			self.write({'ret': False, 'msg': 'gen full card not ok'})
	@coroutine
	def post(self):
		# name, type, arg, msg, ptime
		# ret = yield self.userGMRPC.gmSendMessage(self.session,)
		self.write({'ret': False, 'msg': 'post ok'})
		pass

from tornado.gen import with_timeout
from datetime import timedelta
class GetServerPlayerCountHandler(BaseHandler):
    url = r'/get_server_player_count'

    @coroutine
    def get(self):
        paramData = self.get_json_data()
        username = paramData["username"]
        password = paramData["password"]
        serverName = paramData.get('serverName', 'allservers')

        try:
            pass_md5 = calc_md5(password)
            if Session.existSession(username):
                session = Session.getSession(username)
                if session.pass_md5 == pass_md5:
                    sessionID = session.resetIdent()
                    self.set_secure_cookie(SESSION_KEY, sessionID)
                else:
                    self.write_json({"ret": False, "data": "not found account"})
            else:
                account = User.find_one(self.mongo_client, {"name": username})
                if not account or account["pass_md5"] != pass_md5:
                    self.write_json({"ret": False, "data": "not found account"})
                else:
                    session = Session(account)
                    self.set_secure_cookie(SESSION_KEY, session.sessionID)

        except Exception as error:
            traceback.print_exc()
            self.write_json({"ret": False, "data": "server error"})

        try:
            if serverName == "allservers":
                serverName = "__@global@__"
            result = yield with_timeout(timedelta(seconds=30), 
                                       self.userGMRPC.CustomGmGetServerPlayerCount(Session.getSession(username), serverName))
            self.write_json({"ret": True, "data": result})
        except Exception as error:
            traceback.print_exc()
            self.write_json({"ret": False, "data": "failed to fetch player count: %s" % str(error)})
