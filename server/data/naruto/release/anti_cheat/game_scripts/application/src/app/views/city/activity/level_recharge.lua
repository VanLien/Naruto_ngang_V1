-- @Date:   2019-05-30
-- @Desc:
-- @Last Modified time: 2019-06-12
local YY_TYPE = game.YYHUODONG_TYPE_ENUM_TABLE
local STATE_TYPE = {
    canReceive = 1,
    noReach = 0,
    received = 2
}

local ActivityLevelRecharge = class("ActivityLevelRecharge", Dialog)
ActivityLevelRecharge.RESOURCE_FILENAME = "activity_level_recharge.json"
ActivityLevelRecharge.RESOURCE_BINDING = {
    ["page1"] = "page1",
    ["page2"] = "page2",
    ["page3"] = "page3",
    ["page4"] = "page4",
    ["page5"] = "page5",
    ["page6"] = "page6",
    ["page7"] = "page7",
    ["page8"] = "page8",
    ["pageview"] = "pageview",
    ["btnLeft"] = "btnLeft",
    ["btnRight"] = "btnRight",
    ["page1.btnClose"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onClose")
            }
        }
    },
    ["page2.btnClose"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onClose")
            }
        }
    },
    ["page3.btnClose"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onClose")
            }
        }
    },
    ["page4.btnClose"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onClose")
            }
        }
    },
    ["page5.btnClose"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onClose")
            }
        }
    },
    ["page6.btnClose"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onClose")
            }
        }
    },
    ["page7.btnClose"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onClose")
            }
        }
    },
    ["page8.btnClose"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onClose")
            }
        }
    },
    ["page1.buyBtn"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onBuy")
            }
        }
    },
    ["page2.buyBtn"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onBuy")
            }
        }
    },
    ["page3.buyBtn"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onBuy")
            }
        }
    },
    ["page4.buyBtn"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onBuy")
            }
        }
    },
    ["page5.buyBtn"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onBuy")
            }
        }
    },
    ["page6.buyBtn"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onBuy")
            }
        }
    },
    ["page7.buyBtn"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onBuy")
            }
        }
    },
    ["page8.buyBtn"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onBuy")
            }
        }
    },
    ["dot0"] = "dot0",
    ["dot1"] = "dot1",
    ["dot2"] = "dot2",
    ["dot3"] = "dot3",
    ["dot4"] = "dot4",
    ["dot5"] = "dot5",
    ["dot6"] = "dot6",
    ["dot7"] = "dot7",
    ["btnLeft"] = {
        varname = "btnLeft",
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onBeforeIndex")
            }
        }
    },
    ["btnRight"] = {
        varname = "btnRight",
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onAfterIndex")
            }
        }
    },
    ["page1.mask"] = "mask1",
    ["page2.mask"] = "mask2",
    ["page3.mask"] = "mask3",
    ["page4.mask"] = "mask4",
    ["page5.mask"] = "mask5",
    ["page6.mask"] = "mask6",
    ["page7.mask"] = "mask7",
    ["page8.mask"] = "mask8"

}

function ActivityLevelRecharge:onCreate()
    -- gGameModel.currday_dispatch:getIdlerOrigin("firstRecharge"):set(true)
    self.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")

    local yyhuodongs = self.yyhuodongs:read()

    local activityIDs = {}
    for _, id in ipairs(gGameModel.role:read("yy_open")) do
        -- local id = 190010
        local huodong = yyhuodongs[id] or {}
        local cfg = csv.yunying.yyhuodong[id]
        -- if cfg.independent == 1 and cfg.type == YY_TYPE.levelRecharge and huodong.flag ~= 2 then
        if cfg.type == YY_TYPE.levelRecharge then
            table.insert(activityIDs, {
                id = id,
                state = huodong.flag,
                sortWeight = cfg.sortWeight
            })
        end
    end

    table.sort(activityIDs, function(a, b)
        if a.sortWeight ~= b.sortWeight then
            return a.sortWeight < b.sortWeight
        end
        return a.id < b.id
    end)

    self.page1:retain()
    self.page1:removeFromParent()
    self.page2:retain()
    self.page2:removeFromParent()
    self.page3:retain()
    self.page3:removeFromParent()
    self.page4:retain()
    self.page4:removeFromParent()
    self.page5:retain()
    self.page5:removeFromParent()
    self.page6:retain()
    self.page6:removeFromParent()
    self.page7:retain()
    self.page7:removeFromParent()
    self.page8:retain()
    self.page8:removeFromParent()
    self.activityIDs = activityIDs
    self.isInserPage = false
    self.pages = {}
    self.listPos = {{
        x = self.page1:get("list"):x(),
        y = self.page1:get("list"):y()
    }, {
        x = self.page2:get("list"):x(),
        y = self.page2:get("list"):y()
    }, {
        x = self.page3:get("list"):x(),
        y = self.page3:get("list"):y()
    }, {
        x = self.page4:get("list"):x(),
        y = self.page4:get("list"):y()
    }, {
        x = self.page5:get("list"):x(),
        y = self.page5:get("list"):y()
    }, {
        x = self.page6:get("list"):x(),
        y = self.page6:get("list"):y()
    }, {
        x = self.page7:get("list"):x(),
        y = self.page7:get("list"):y()
    }, {
        x = self.page8:get("list"):x(),
        y = self.page8:get("list"):y()
    }}
    self.states = {idler.new(STATE_TYPE.noReach), idler.new(STATE_TYPE.noReach), idler.new(STATE_TYPE.noReach),
                   idler.new(STATE_TYPE.noReach), idler.new(STATE_TYPE.noReach), idler.new(STATE_TYPE.noReach)}

    self.dataAward = {}

    idlereasy.when(self.yyhuodongs, function(_, val)
        self:doGetConfig(function(nRet, msg)
            self:onGetConfigCallback(nRet, msg)
        end)
    end --- end when function
    )

    self.curPage = idler.new(0)
    local container = self.pageview:getInnerContainer()
    local width = container:size().width
    local totalPage = #self.pageview:getPages()
    self.isEnter = false
    self.pageview:onScroll(function(event)
        local x = container:getPositionX()
        local xPos = {}
        itertools.invoke({self.mask1, self.mask2, self.mask3, self.mask4, self.mask5, self.mask6, self.mask7, self.mask8}, "show")
        if event.name == "AUTOSCROLL_ENDED" then
            for i = 1, totalPage do
                local baseX = -width * (i - 1)
                if math.abs(x - baseX) <= 6 then
                    self.isEnter = true
                    itertools.invoke({self.mask1, self.mask2, self.mask3, self.mask4, self.mask5, self.mask6, self.mask7, self.mask8}, "hide")
                    if self.curPage:read() ~= self.pageview:getCurPageIndex() then
                        self.curPage:set(self.pageview:getCurPageIndex())
                    end
                    return
                end
            end
        end
        if self.isEnter or event.name == "AUTOSCROLL_BEGAN" then
            self.isEnter = false
            itertools.invoke({self.mask1, self.mask2, self.mask3, self.mask4, self.mask5, self.mask6, self.mask7, self.mask8}, "hide")
        end
    end)
    self.curPage:addListener(function(val, oldval, _)
        if totalPage > 1 then
            local oldDot = self["dot" .. oldval]
            local newDot = self["dot" .. val]
            itertools.invoke({oldDot, oldval == val and self.dot1 or newDot}, "show")
            oldDot:texture("common/icon/logo_normal_fy.png")
            newDot:texture("common/icon/logo_highlight_fy.png")
        end

        self.btnRight:visible(true)
        self.btnLeft:visible(true)
        self.pageview:scrollToPage(val)
    end)
    Dialog.onCreate(self, {
        blackType = 1
    })
end -- onCreate

function ActivityLevelRecharge:onGetConfigCallback(nRet, msg)

    -- ========================================================
    local sizes = {
        [3] = cc.size(610, 215),
        [4] = cc.size(808, 215),
        [5] = cc.size(910, 195),
        [6] = cc.size(910, 195)
    }

    local data = msg

    local dataAward = {}
    local dataTime = {}

    local dataStatus = {}
    local dataTotalPay = {}

    self:doGetStatus(function(nRetStatus, szMsgStatus, szTotalPay)
        dataStatus = szMsgStatus
        dataTotalPay = szTotalPay

        for k, v in pairs(data or {}) do
            local tbAw = json.decode(v["award"])
            local tbAwNew = {}
            for k1, v1 in pairs(tbAw) do
                local nK = tonumber(k1)
                if (nK ~= nil) then
                    tbAwNew[nK] = v1
                else
                    tbAwNew[k1] = v1
                end
            end

            dataAward[v["package"]] = tbAwNew

            dataTime[v["package"]] = dataTime[v["package"]] or {}
            dataTime[v["package"]]["beginDate"] = v["beginDate"]
            dataTime[v["package"]]["endDate"] = v["endDate"]

        end

        self.dataAward = dataAward
        self.dataTime = dataTime

        --- corect dataAward
        -- ========================================================
        for i, v in ipairs(self.activityIDs) do
            local cfg = csv.yunying.yyhuodong[v.id] -- co config
            local page = self["page" .. cfg.clientParam.page]
            -- if v.state ~= 2 then
            if not self.isInserPage then
                self.pageview:addPage(page)
                self.pages[i] = page
            end
            page:get("placard"):texture(cfg.clientParam.resBg)
            local list = page:get("list")
            local num = csvSize(cfg.paramMap.award)

            page:get("bg"):size(sizes[num])

            if num == 4 then
                list:x(self.listPos[cfg.clientParam.page].x)
            elseif num == 3 then
                list:x(self.listPos[cfg.clientParam.page].x + 100)
            elseif num == 5 then
                list:xy(self.listPos[cfg.clientParam.page].x - 50, self.listPos[cfg.clientParam.page].y - 12)
            end

            local txtTime = page:get("txt_time")
            local txtTotalPay = page:get("txt_totalpay")

            local tbInfo = self.dataTime[v.id] or self.dataTime[tostring(v.id)] or {}
            txtTime:text(string.format("Thời gian: %s 00:00 đến %s 23:59", tbInfo.beginDate, tbInfo.endDate))

            if (tbInfo.beginDate == nil or tbInfo.endDate == nil) then
                txtTime:text("Thời gian: Hoạt động chưa mở")
            end

            local totalPay = dataTotalPay[tostring(v.id)] or 0
            txtTotalPay:text(string.format("Bạn đã tích lũy: %s VNĐ", NUMBER_FORMAT(totalPay)))

            local btn = page:get("buyBtn")
            local label = btn:get("label")

            -- uiEasy.createItemsToList(self, list, cfg.paramMap.award, {scale = num == 5 and 0.9 or 1})

            -- uiEasy.createItemsToList(self, list, self.dataAward[tostring(v.id)] or {}, {scale = num == 5 and 0.9 or 1})
            local tbAward = self.dataAward[v.id] or self.dataAward[tostring(v.id)] or {}
            uiEasy.createItemsToList(self, list, tbAward, {
                scale = num == 5 and 0.9 or 1
            })

            text.addEffect(label, {
                glow = {
                    color = ui.COLORS.GLOW.WHITE
                }
            })

            local status = dataStatus[tostring(v.id)] or 0 -- status | 0: chưa hoàn thành | 1: hoàn thành chưa nhận | 2: đã nhận 

            if (status <= 0) then
                label:text("Chưa hoàn thành")
                btn:setTouchEnabled(false)
                cache.setShader(btn, false, "hsl_gray")
            elseif (status == 1) then
                label:text("Nhận ngay")
                btn:setTouchEnabled(true)
                cache.setShader(btn, false, "normal")
            elseif (status == 2) then
                label:text("Đã nhận")
                btn:setTouchEnabled(false)
                cache.setShader(btn, false, "hsl_gray")
            else
                label:text("Đã kết thúc")
                btn:setTouchEnabled(false)
                cache.setShader(btn, false, "hsl_gray")
            end

            page:show()
            -- else
            -- page:hide()
            -- end
        end
        self.isInserPage = true
    end) --- end status callback function	
end
function ActivityLevelRecharge:onBeforeIndex()
    local index = self.pageview:getCurPageIndex() - 1
    if index < 0 then
        index = 0
    end
    self.curPage:set(index)
end

function ActivityLevelRecharge:onAfterIndex()
    local index = self.pageview:getCurPageIndex() + 1
    if index > 5 then
        index = 5
    end
    self.curPage:set(index)
end

function ActivityLevelRecharge:onBuy()

    local curAccount = userDefault.getForeverLocalKey("account", nil, {
        rawKey = true
    })
    local index
    local id
    if itertools.size(self.pages) > 1 then
        index = self.pageview:getCurPageIndex() + 1
    else
        index = next(self.pages)
    end

    id = self.activityIDs[index].id
    -- local szMsg = string.format("Tài khoản [%s] đang muốn nhận quà trang: %s | ID Hoạt Động: %s", curAccount, index, id)
    -- gGameUI:showTip(szMsg)

    -- bắn về API để check và send mail -- báo hồng
    local page = self["page" .. index]
    local btn = page:get("buyBtn")
    local label = btn:get("label")
    label:text("Đang xử lí")
    btn:setTouchEnabled(false)
    cache.setShader(btn, false, "hsl_gray")
    self:doGetReward(curAccount, index, id, function(nRet, szMsg)
        if (nRet == 1) then
            gGameUI:showTip("Nhận quà thành công!")
            label:text("Đã nhận")
            btn:setTouchEnabled(false)
            cache.setShader(btn, false, "hsl_gray")
        else
            if (szMsg ~= nil) then
                gGameUI:showTip(szMsg)

            end
            label:text("Nhận ngay")
            btn:setTouchEnabled(true)
            cache.setShader(btn, false, "normal")
        end
    end)
end
function ActivityLevelRecharge:doGetReward(accountName, pageIndex, activityId, callback)

    -- local szMsg =
    -- 	string.format("Gọi API => accountName: %s | pageIndex: %s | activityId: %s", accountName, pageIndex, activityId)
    -- acc..pass_md5.. md5
    local params = string.format("account=%s&role_id=%s&activityId=%s&server_key=%s&", gGameModel.account:read("name"),
        stringz.bintohex(gGameModel.role:read("id")), activityId, gGameApp.serverInfo.key)

    -- gGameUI:showTip(szMsg)
    gGameApp.net:sendHttpRequest("POST", LEVEL_RECHARGE_CFG .. "getReward", params, cc.XMLHTTPREQUEST_RESPONSE_STRING,
        function(xhr)
            if xhr.status == 200 then
                local res = json.decode(xhr.response)
                if (res.code == 0) then
                    if (callback ~= nil) then
                        callback(1,
                            "Bạn đã nhận quà tích nạp thành công, vui lòng mở mail để nhận phần thưởng bạn nhé.")
                    end
                elseif (res.code == -101) then
                    if (callback ~= nil) then
                        callback(-1, "Bạn chưa đủ điều kiện để nhận tích nạp.")
                    end
                elseif (res.code == -102) then
                    if (callback ~= nil) then
                        callback(-1, "Bạn đã nhận quà tích nạp này rồi.")
                    end
                else
                    if (callback ~= nil) then
                        callback(-1, res.message)
                    end
                end
            else
                if (callback ~= nil) then
                    callback(-1,
                        "Đã có lỗi xảy ra, vui lòng thử lại hoặc liên hệ admin để được hỗ trợ.")
                end
            end
            -- self.canSendRedeemCode = true
        end)
end

function ActivityLevelRecharge:doGetConfig(callback)
    -- acc..pass_md5.. md5
    local params = string.format("account=%s&", gGameModel.account:read("name"))

    gGameApp.net:sendHttpRequest("POST", LEVEL_RECHARGE_CFG .. "getRewardConfig", params,
        cc.XMLHTTPREQUEST_RESPONSE_STRING, function(xhr)
            if xhr.status == 200 then
                local res = json.decode(xhr.response)
                if (res.code == 0) then
                    if (callback ~= nil) then
                        callback(1, res.message)
                    end
                else
                    if (callback ~= nil) then
                        callback(-1, "Báo hồng 1")
                    end
                end
            else
                if (callback ~= nil) then
                    callback(-1, "Báo hồng 2")
                end
            end
            -- self.canSendRedeemCode = true
        end)
end

function ActivityLevelRecharge:doGetStatus(callback)
    -- acc..pass_md5.. md5

    local params = string.format("account=%s&", gGameModel.account:read("name"))

    gGameApp.net:sendHttpRequest("POST", LEVEL_RECHARGE_CFG .. "getStatus", params, cc.XMLHTTPREQUEST_RESPONSE_STRING,
        function(xhr)
            if xhr.status == 200 then
                local res = json.decode(xhr.response)
                if (res.code == 0) then
                    if (callback ~= nil) then
                        callback(1, res.message, res.totalpay)
                    end
                else
                    if (callback ~= nil) then
                        callback(-1, "Báo hồng 1")
                    end
                end
            else
                if (callback ~= nil) then
                    callback(-1, "Báo hồng 2")
                end
            end
            -- self.canSendRedeemCode = true
        end)
end

function ActivityLevelRecharge:doGetTotalPay(callback)
    -- acc..pass_md5.. md5

    local params = string.format("account=%s&", gGameModel.account:read("name"))

    gGameApp.net:sendHttpRequest("POST", LEVEL_RECHARGE_CFG .. "getTotalPay", params, cc.XMLHTTPREQUEST_RESPONSE_STRING,
        function(xhr)
            if xhr.status == 200 then
                local res = json.decode(xhr.response)
                if (res.code == 0) then
                    if (callback ~= nil) then
                        callback(1, res.message)
                    end
                else
                    if (callback ~= nil) then
                        callback(-1, "Báo hồng 1")
                    end
                end
            else
                if (callback ~= nil) then
                    callback(-1, "Báo hồng 2")
                end
            end
            -- self.canSendRedeemCode = true
        end)
end

return ActivityLevelRecharge
