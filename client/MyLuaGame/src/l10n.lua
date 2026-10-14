globals.LOCAL_LANGUAGE = 'cn'

-- 多语言登录外网 updater 界面语言显示
local targetPlatform = cc.Application:getInstance():getTargetPlatform()
if cc.PLATFORM_OS_WINDOWS == targetPlatform then
	require "src.app.defines.dev_defines"
	if dev.ONLINE_VERSION_LANGUAGE then
		local language = dev.ONLINE_VERSION_LANGUAGE
		if string.sub(language, 1, 1) == "_" then
			language = string.sub(language, 2)
			LOCAL_LANGUAGE = language
		end
	end
end

--print('LOCAL_LANGUAGE', LOCAL_LANGUAGE)

globals.LanguageTexts = {
	cn = {
        notice = "公告",
        checkUpdate = '检查更新中...',
        downloading = '正在下载安装中... 文件数量:%6d / %6d  文件大小:%7dK / %7dK',
        downloadingM = '正在下载安装中... 文件数量: %d / %d  文件大小: %.2fM / %.2fM',
        noConnected = '无法连接',
		networkErr = '网络状况异常，请检查网络，并点击确定重试！',
        reConnect = '请重新连接',
		versionErr = '游戏版本异常，请重新启动游戏！',
        updateReboot = '游戏版本重大更新，请重新启动游戏！',
        downloadErr = '游戏更新下载失败，\n点击确定按钮重试！',
        unzipFailed = '解压失败',
        oldApp = '版本过旧\n需要重新下载最新的客户端',
        loginUpdating = '登录服务器正在更新中，请稍等',
        umcompress = '正在解压中，请稍等',
        wifiTip = '资源较大，请在wifi环境下下载资源 土豪请随意',
        tips = '提 示',
        boxTextTip = '下次不再弹出提示',
        sure = '确 定',
        notRemindMe = '今日不再提醒',
        ok = '我知道了',
        loadSucc = '启动游戏中',
		placardActivity = '开服公告',
        placardUpdate = '更新内容'
	},
	tw = {
		notice = "公告",
		checkUpdate = '检查更新中...',
		downloading = '正在下载安装中... 文件数量:%6d / %6d  文件大小:%7dK / %7dK',
		downloadingM = '正在下载安装中... 文件数量: %d / %d  文件大小: %.2fM / %.2fM',
		noConnected = '无法连接',
		reConnect = '請重新連接',
		unzipFailed = '解压失败',
		oldApp = '版本过旧\n需要重新下载最新的客户端',
		loginUpdating = '登录服务器正在更新中，请稍等',
		umcompress = '正在解壓中，請稍等',
		wifiTip = '資源較大，請在wifi環境下下載資源 土豪請隨意',
		tips = '提 示',
		boxTextTip = '下次不再彈出提示',
		sure = '確 定',
		placardActivity = '开服公告',
        placardUpdate = '更新内容',
		notRemindMe = '今日不再提醒',
		ok = '我知道了',
	},
	en = {
		notice = "Notice",
		checkUpdate = 'Checking update...',
		downloading = 'Downloading... file:%6d / %6d  size:%7dK / %7dK',
		downloadingM = 'Downloading... file:%d / %d  size:%.2fM / %.2fM',
		noConnected = 'No network',
		reConnect = 'Please retry connect',
		unzipFailed = 'Uncompress failed',
		oldApp = 'Old client version\nPlease download new client',
		loginUpdating = 'Server updateing, please wait a moment',
		umcompress = 'Extracting, please wait a moment',
		wifiTip = 'Your network not in WIFI, are you confirm to update?',
		tips = 'Tips',
		boxTextTip = 'Don\'t prompt again',
		sure = 'Sure',
		placardActivity = 'Event',
		placardUpdate = 'Reminder',
		notRemindMe = 'Don\'t remind me again today',
		ok = 'Okey',
	},
	vn = {
		notice = "公告",
		checkUpdate = 'Kiểm tra bản cập nhật...',
		downloading = 'Đang tải... file:%6d / %6d  size:%7dK / %7dK',
		downloadingM = 'Đang tải... file:%d / %d  size:%.2fM / %.2fM',
		noConnected = 'Không có mạng',
		reConnect = 'Vui lòng kết nối lại',
		unzipFailed = 'Giải nén không thành công',
		oldApp = 'Phiên bản hiện tại đã cũ\nXin vui lòng tải lại phiên bản mới',
		loginUpdating = 'Đang cập nhật máy chủ, vui lòng đợi trong giây lát',
		umcompress = 'Đang giải nén, vui lòng đợi trong giây lát',
		wifiTip = 'Bạn đang không sử dụng WIFI, kích thước của bản cập nhật này là% 0.2fM. Bạn có muốn sử dụng truy cập di động để cập nhật không?',
		tips = 'Mẹo',
		boxTextTip = 'Không nhắc lại',
		sure = 'Chắc chắn rồi',
		notRemindMe = 'Không nhắc lại vào hôm nay',
		ok = 'OK',
	},
	kr = {
		notice = "공지",
		checkUpdate = '업데이트 점검 중...',
		downloading = '다운로드하는 중... 파일 수량: %d / %d  파일 크기: %dK / %dK',
		downloadingM = '다운로드하는 중... 파일 수량: %d / %d  파일 크기: %.2fM / %.2fM',
		noConnected = '업데이트 불가, 네트워크를 확인하세요',
		reConnect = '나머지 %d개 파일 업데이트되지 않았습니다，다시 시도하시겠습니까？',
		unzipFailed = '압축 풀기 실패',
		oldApp = '최신의 버전 설치하세요',
		loginUpdating = '서버 업데이트 점검 중,잠시 기다려 주세요',
		umcompress = '압축을 푸는 중 잠시 기다려 주세요',
		wifiTip = '현재 Wi-Fi가 아닌 환경에서이 업데이트의 파일 크기는 %0.2fM입니다. 업데이트를위한 데이터 사용하시겠습니까.？',
		placardActivity = '이벤트 공지',
		placardUpdate = '업데이트 내용',
		tips = '알 림',
		boxTextTip = '오늘 그만 보기',
		sure = '확 인',
		notRemindMe = '오늘은 그만 보기',
		ok = '확인',
	},
}

globals.Language = LanguageTexts[LOCAL_LANGUAGE]
if Language == nil then
	globals.Language = LanguageTexts.cn
end
globals.Language = setmetatable(Language, {__index = function()
	return "text_placeholder"
end})
--默认东八区时间
globals.UNIVERSAL_TIMEDELTA = 8 * 3600
if LOCAL_LANGUAGE == 'en' then
	--西五区时间
	UNIVERSAL_TIMEDELTA = 8 * 3600
elseif LOCAL_LANGUAGE == 'vn' then
	--东七区时间
	UNIVERSAL_TIMEDELTA = 7 * 3600
elseif LOCAL_LANGUAGE == 'kr' then
	--东九区时间
	UNIVERSAL_TIMEDELTA = 9 * 3600
end
