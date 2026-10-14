local MultitaskDownload = class("MultitaskDownload")


--- 构造方法
-- @tab taskList 任务列表
-- @usage {{url=XXX, size=XXXbyte},{url=XXX, size=XXXbyte}}
function MultitaskDownload:ctor(taskList)
    self.__taskList = taskList
    self.__curTaskIndex = 1
    self.__allSizeCache = {}
    local size = 0
    for index, task in ipairs(taskList) do
        size = size + task.size
        self.__allSizeCache[index] = size
    end
    self.__totalSize = size
end

--- 设置单个任务下载成功时的回调方法
-- @func funcOneTaskSuccess 单个任务下载成功时的回调方法
-- @usage funcOneTaskSuccess(taskIndex)
-- taskIndex: 下载任务的序号（从1开始）
function MultitaskDownload:setOneTaskSuccessCallback(funcOneTaskSuccess)
    self.__funcOneTaskSuccess = funcOneTaskSuccess
end

--- 设置下载进度变化的回调方法
-- @func funcDownloadProgress 下载进度变化的回调方法
-- @usage funcDownloadProgress(percent, index, taskPercent)
-- percent: 当前总下载量占所有下载总量的百分比（0-100）
-- taskIndex: 当前下载任务的序号（从1开始）
-- taskPercent: 当前任务下载量占当前任务总量的百分比

function MultitaskDownload:setDownloadProgressCallback(funcDownloadProgress)
    self.__funcDownloadProgress = funcDownloadProgress
end

--- 设置下载成功的回调方法（所有的任务都已完成）
-- @func funcDownloadSuccess 下载成功的回调方法
function MultitaskDownload:setDownloadSuccessCallback(funcDownloadSuccess)
    self.__funcDownloadSuccess = funcDownloadSuccess
end

--- 设置下载失败的回调方法 (只触发一次，失败后不再继续)
-- @func funcDownloadFail 下载失败的回调方法
-- @usage funcDownloadFail(errorCode, errorInfo)
function MultitaskDownload:setDownloadFailCallback(funcDownloadFail)
    self.__funcDownloadFail = funcDownloadFail
end

--- 开始下载
function MultitaskDownload:start()
    if #self.__taskList == 0 then
        if self.__funcDownloadSuccess then
            self.__funcDownloadSuccess()
        end
        return
    end

    local task = self.__taskList[self.__curTaskIndex]
    self:releaseUpdateManager()

    self.updateManager = UpdateManager:new(task.url,task.md5,path.UPDATE_PATH)
    self.updateManager:retain()
    self.updateManager:setDelegate(function(errorCode, errorInfo)
        self.__percent = 0
        if self.__funcDownloadFail then
            self.__funcDownloadFail(errorCode, errorInfo)
        end
        self:releaseUpdateManager()
    end, cc.ASSETSMANAGER_PROTOCOL_ERROR)

    self.updateManager:setDelegate(function(taskPercent)
        local taskSuccessSize
        if self.__curTaskIndex == 1 then
            taskSuccessSize = 0
        else
            taskSuccessSize = self.__allSizeCache[self.__curTaskIndex-1]
        end
        local task = self.__taskList[self.__curTaskIndex]
        self.__downloadSize = taskSuccessSize + task.size*taskPercent/100
        local percent = self.__downloadSize*100/self.__totalSize
        if self.__funcDownloadProgress then
            if percent>=0 and percent<=100 then
                self.__percent = percent
                self.__funcDownloadProgress(percent, self.__curTaskIndex, taskPercent)
            end
        end
    end, cc.ASSETSMANAGER_PROTOCOL_PROGRESS)

    self.updateManager:setDelegate(function()
        if self.__funcOneTaskSuccess then
            self.__funcOneTaskSuccess(self.__curTaskIndex)
        end
        if self.__curTaskIndex >= #self.__taskList then
            self.__percent = 100
            if self.__funcDownloadSuccess then
                self.__funcDownloadSuccess()
            end
            self:releaseUpdateManager()
            return
        end
        self.__curTaskIndex = self.__curTaskIndex+1
        local task = self.__taskList[self.__curTaskIndex]
        self.updateManager:setVersionFileUrl(task.md5)
        self.updateManager:setPackageUrl(task.url)
        self.updateManager:update()
    end, cc.ASSETSMANAGER_PROTOCOL_SUCCESS)
    self.__percent = 0
    self.updateManager:update()
end

function MultitaskDownload:getPercent()
    return self.__percent
end

-- 不要调用这个方法！
function MultitaskDownload:releaseUpdateManager()
    if self.updateManager then
        self.updateManager:release()
        self.updateManager = nil
    end
end

function MultitaskDownload:startTask(taskIndex)
    local task = self.__taskList[taskIndex]
    self.updateManager:setVersionFileUrl(task.md5)
    self.updateManager:setPackageUrl(task.url)
end

--- 返回当前任务序号
-- @return number 任务序号（从1开始）
function MultitaskDownload:getCurTaskIndex()
    return self.__curTaskIndex
end

--- 返回所有任务的总大小
-- @return number 所有任务的总大小(byte)
function MultitaskDownload:getTotalSize()
    return self.__totalSize
end

--- 返回已下载的大小
-- @return number 已下载的大小(byte)
function MultitaskDownload:getDownloadSize()
    return self.__downloadSize
end

return MultitaskDownload

