--
-- Copyright (c) 2014 YouMi Information Technology Inc.
-- Copyright (c) 2017 TianJi Information Technology Inc.
--
-- Widget缓存
--

local WidgetCache = {}

local guiReader = ccs.GUIReader:getInstance()
local textureCache = display.director:getTextureCache()


function WidgetCache.getWidget(res)
-- cc.CSLoader:createNode(resourceFilename)
	-- cocos studio 1.6
    print("resName:"..res)
    local raw
    local suf = string.sub(res, -4)
    if suf == ".csb" then
        raw = guiReader:widgetFromBinaryFile(res)
    else
        if cc.FileUtils:getInstance():isFileExist(res) then
            raw = guiReader:widgetFromJsonFile(res)
        else
            res = string.sub(res, 1, -6) .. ".csb"
            raw = guiReader:widgetFromBinaryFile(res)
        end
    end
	translateUI(raw)
	-- adaptBtnTitle(raw)
	adaptUI(raw, res)
	return raw
end

return WidgetCache
