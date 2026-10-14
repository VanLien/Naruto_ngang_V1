local account_name = ""
local userAccount = ""
local countPay = "0"
local momo_account = ""
local bank_account = "3052525299999"
local flagSelectMoney = false;
local PAYMENT_TYPE = {
    CARD = 1,
    BANK = 2,
    MOMO = 3,
    HISTORY = 4
}
local PANEL_NAME = {"cardPanel", "momoPanel", "bankPanel", "historyPanel"}
local ATTR_VAL_TYPE = {"battle_fighting_point", "last_time", "level"}

local SHOW_TEXT = {
    [1] = gLanguageCsv.whereMyFriend,
    [2] = gLanguageCsv.noOneApply,
    [4] = "Bạn chưa nạp tiền vào game ^^"
}

local SHOW_REUNION = {
    UNSHOW = 0,
    SHOW_REUNION = 1,
    SHOW_SENIRO = 2
}
local function reformatInt(num)
    return tostring(num):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

local ViewBase = cc.load("mvc").ViewBase
local PaymentView = class("PaymentView", Dialog)

PaymentView.RESOURCE_FILENAME = "custom_payment.json"
PaymentView.RESOURCE_BINDING = {
    ["leftPanel.panel"] = "leftPanel",
    ["leftPanel.panel.cardPanel"] = "cardPanel",
    ["leftPanel.panel.bankPanel"] = "bankPanel",

    ["leftPanel.panel.momoPanel"] = "momoPanel",
    ["leftPanel.panel.historyPanel"] = "historyPanel",
    ["leftPanel.panel.btnClose"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onClose")
            }
        }
    },
    ["leftPanel.panel.cardPanel.btnPayment"] = {
        varname = "btnPayment",
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onSubmitPaymentClick")
            }
        }
    },
    ["leftPanel.panel.cardPanel.btnPayment.txt"] = {
        binds = {
            event = "effect",
            data = {
                glow = {
                    color = ui.COLORS.GLOW.WHITE
                }
            }
        }
    },
    ["leftPanel.panel.cardPanel.pin.nameInput"] = {
        varname = "pinInput",
        binds = {
            event = "text",
            method = function(val)
                -- print(string.format("onPinInput change -%s", val))
            end
        }
    },
    ["leftPanel.panel.cardPanel.serial.nameInput"] = {
        varname = "serialInput",
        binds = {
            event = "text",
            method = function(val)
                -- print(string.format("onSerialInput change -%s", val))
            end
        }
    },
    ["leftPanel.panel.cardPanel.pin.btnDelete"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onPinDeleteClick")
            }
        }
    },
    ["leftPanel.panel.cardPanel.pin.btnPaste"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onPinPasteClick")
            }
        }
    },
    ["leftPanel.panel.cardPanel.serial.btnDelete"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onSerialDeleteClick")
            }
        }
    },
    ["leftPanel.panel.cardPanel.serial.btnPaste"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onSerialPasteClick")
            }
        }
    },
    ["leftPanel.panel.duckPanel"] = "duckPanel",
    ["leftPanel.panel.duckPanel.txt"] = "iconText",
    ["leftItem"] = "leftItem",
    ["leftPanel.panel.leftList"] = {
        binds = {
            event = "extend",
            class = "listview",
            props = {
                data = bindHelper.self("btnsAttr"),
                item = bindHelper.self("leftItem"),
                padding = 5,
                onItem = function(list, node, k, v)
                    local normal = node:get("normal")
                    local selected = node:get("selected")
                    if k < 3 then
                        local showProps = {
                            class = "red_hint",
                            props = {
                                state = v.select ~= true,
                                specialTag = k == 1 and "friendStaminaRecv" or "friendReqs",
                                onNode = function(node)
                                    node:xy(50, 255)
                                end
                            }
                        }
                        bind.extend(list, normal, showProps)
                    end
                    local panel
                    if v.select then
                        normal:hide()
                        panel = selected:show()
                        panel:get("txt"):getVirtualRenderer():setLineSpacing(-10)
                    else
                        selected:hide()
                        panel = normal:show()
                        panel:get("txt"):getVirtualRenderer():setLineSpacing(-10)
                    end

                    local maxHeight = panel:size().height - 40
                    adapt.setAutoText(panel:get("txt"), v.name, maxHeight)

                    selected:setTouchEnabled(false)
                    bind.touch(list, normal, {
                        methods = {
                            ended = functools.partial(list.clickCell, k)
                        }
                    })
                end
            },
            handlers = {
                clickCell = bindHelper.self("onLeftButtonClick")
            }
        }
    },
    ["leftPanel.panel.bankPanel.txt_host_name"] = "txt_bank_host_name",

    ["leftPanel.panel.bankPanel.comment.txt"] = {
        binds = {
            event = "text",
            idler = bindHelper.model("account", "pay_id"),
            method = function(val)
                account_name = val
                return string.format("LLA %s", val)
            end
        }
    },

    ["leftPanel.panel.momoPanel.txt_host_name"] = "txt_momo_host_name",

    ["leftPanel.panel.momoPanel.comment.txt"] = {
        binds = {
            event = "text",
            idler = bindHelper.model("account", "pay_id"),
            method = function(val)
                account_name = val
                return string.format("LLA %s", val)
            end
        }
    },
    ["leftPanel.panel.item2"] = "itemProvider",
    ["leftPanel.panel.cardPanel.list"] = {
        varname = "providerList",
        binds = {
            event = "extend",
            class = "listview",
            props = {
                data = bindHelper.self("listData"),
                item = bindHelper.self("itemProvider"),
                margin = 8,
                onItem = function(list, node, k, v)
                    local children = node:multiget("name", "check")
                    children.name:text(v.name)
                    children.check:setSelectedState(v.selected)
                    bind.touch(list, node, {
                        methods = {
                            ended = functools.partial(list.chooseProvider, k, v)
                        }
                    })
                end,
                onBeforeBuild = function(list)
                end
            },
            handlers = {
                chooseProvider = bindHelper.self("onChooseProvider")
            }
        }
    },
    ["leftPanel.panel.cardPanel.money"] = {
        varname = "moneyList",
        binds = {
            event = "extend",
            class = "listview",
            props = {
                data = bindHelper.self("listMoney"),
                item = bindHelper.self("itemProvider"),
                margin = 8,
                onItem = function(list, node, k, v)
                    local children = node:multiget("name", "check")
                    children.name:text(reformatInt(v.name))
                    children.check:setSelectedState(v.selected)
                    bind.touch(list, node, {
                        methods = {
                            ended = functools.partial(list.chooseMoney, k, v)
                        }
                    })
                end,
                onBeforeBuild = function(list)
                end
            },
            handlers = {
                chooseMoney = bindHelper.self("onChooseMoney")
            }
        }
    },
    ["leftPanel.panel.momoPanel.stk.btnCopy"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onCopyMomoAccount")
            }
        }
    },
    ["leftPanel.panel.bankPanel.stk.btnCopy"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onCopyBankAccount")
            }
        }
    },
    ["leftPanel.panel.bankPanel.comment.btnCopy"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onCopyComment")
            }
        }
    },
    ["leftPanel.panel.momoPanel.comment.btnCopy"] = {
        binds = {
            event = "touch",
            methods = {
                ended = bindHelper.self("onCopyComment")
            }
        }
    },

    ["leftPanel.panel.bankPanel.img"] = "bank_icon",
    ["leftPanel.panel.bankPanel.img_qrBank"] = "bank_icon_qr",
    ["leftPanel.panel.momoPanel.img_qrMomo"] = "momo_icon_qr",
    ["leftPanel.panel.bankPanel.description"] = "bank_description",
    ["leftPanel.panel.bankPanel.stk.txt"] = "stkBank",
    ["leftPanel.panel.momoPanel.stk.txt"] = "stkMomo",
    ["leftPanel.panel.item1"] = "itemHistory",
    ["leftPanel.panel.historyPanel.list"] = {
        varname = "historyList", ---
        binds = {
            event = "extend",
            class = "listview",
            props = {
                data = bindHelper.self("listHistory"),
                item = bindHelper.self("itemHistory"),
                margin = 8,
                asyncPreload = 1,
                onItem = function(list, node, k, v)
                    local children = node:multiget("type", "provider", "money", "created_at")
                    children.type:text(k)
                    children.provider:text(v.provider)
                    children.money:text(reformatInt(v.money))
                    children.created_at:text(v.created_at)
                    -- children.check:setSelectedState(v.selected)
                    -- bind.touch(list, node, {methods = {ended = functools.partial(list.chooseMoney, k, v)}})
                end
            },
            handlers = {}
        }
    },
    ["leftPanel.panel.historyPanel.name"] = {
        varname = "paymentName",
        binds = {
            event = "text",
            idler = bindHelper.model("account", "name"),
            method = function(val)
                -- account_name = val
                userAccount = val
                return string.format(val)
            end
        }
    },
    ["leftPanel.panel.historyPanel.payid"] = {
        varname = "payId",
        binds = {
            event = "text",
            idler = bindHelper.model("account", "pay_id"),
            method = function(val)
                -- account_name = val
                return string.format(val)
            end
        }
    },

    ["leftPanel.panel.historyPanel.counter"] = {
        varname = "paymentCounter"
        -- binds = {
        --     event = "text",
        --     idler = bindHelper.model("account", 'name'),
        --     method = function(val)
        --         account_name = val
        --         return string.format(val)
        --     end
        -- }
    },
    ["leftPanel.panel.historyPanel.money"] = {
        varname = "totalMoney",
        binds = {
            event = "text",
            idler = bindHelper.model("account", "money"),
            method = function(val)
                return string.format(" %s VNĐ", reformatInt(val))
            end
        }
    }
}

local storeData = {}

local director = cc.Director:getInstance()
PaymentView.director = director
PaymentView.textureCache = director:getTextureCache()

function PaymentView:onCleanup()
    self._showType = self.leftButtonTab:read()
    -- self._myShowFriend = self.myShowFriend:read()
    -- self._dropAttrTab = self.dropAttrTab:read()
    -- self._btnSelectAscOrder = self.btnSelectAscOrder:read()
    self._data = self.datas[self._showType]

    ViewBase.onCleanup(self)
end
function PaymentView:onClose()
    ViewBase.onClose(self)
end
local isFirst = false
-- local listHistory = {}
-- 1.我的好友 2.好友申请 3.添加好友

function PaymentView:onSyncConfig(callback)
    -- account=thapta&provider=1&serial=dfdddf&pin=12344562&money=50000
    gGameApp.net:sendHttpRequest("POST", PAYMENT_CONFIG, "", cc.XMLHTTPREQUEST_RESPONSE_STRING, function(xhr)
        if xhr.status == 200 then
            local obj = json.decode(xhr.response)

            if obj.code == 0 then
                if (callback ~= nil) then
                    callback(1, obj.message)
                end
            else
                if (callback ~= nil) then
                    callback(-1, {})
                end
            end
        else
            gGameUI:showTip("Mạng không ổn định vui lòng liên hệ nhóm Báo Hồng")
        end
    end)
end

local tbConfig = nil
function PaymentView:onCreate(showType, data)
    flagSelectMoney = false;
    tbConfig = nil
    self.listHistory = self.listHistory or idlers.newWithMap({})
    self:syncPayHis()
    self.stkBank:text(bank_account)
    self.stkMomo:text(momo_account)

    self.datas = {}
    showType = self._showType or showType
    if showType == nil then
        self._showType = self.initPaymentShowType()
        showType = self.initPaymentShowType()
    end

    self.originX = self.leftPanel:x()
    self.pinInput:setPlaceHolderColor(ui.COLORS.DISABLED.KHAKI)
    self.pinInput:setPlaceHolder("Nhập Pin của thẻ cào")
    self.pinInput:setTextColor(ui.COLORS.NORMAL.DEFAULT)
    self.serialInput:setPlaceHolderColor(ui.COLORS.DISABLED.KHAKI)
    self.serialInput:setPlaceHolder("Nhập Serial của thẻ cào")
    self.serialInput:setTextColor(ui.COLORS.NORMAL.DEFAULT)

    self.pinInput:setCursorEnabled(true)
    self.serialInput:setCursorEnabled(true)

    -- self.bank_icon:removeSelf()
    local leftButtonName = {{
        name = "CARD",
        enter = false
    }, {
        name = "BANK +20%",
        enter = false
    }, {
        name = "MOMO +15%",
        enter = false
    }, {
        name = "Lịch Sử",
        enter = false
    }}
    leftButtonName[1].enter = true
    self.btnsAttr = idlers.newWithMap(leftButtonName)

    ----------------------------------------------------------------
    local listData = {}
    local firstProvider = 1
    local providerData = {"Viettel", "Mobiphone", "Vinaphone"}
    for k, v in ipairs(providerData) do
        table.insert(listData, {
            name = v,
            selected = (firstProvider == k)
        })
    end
    self.listData = idlers.newWithMap(listData)
    ----------------------------------------------------------------
    ----------------------------------------------------------------
    local listMoney = {}
    local firstMoney = 9
    local moneyData = {10000, 20000, 30000, 50000, 100000, 200000, 300000, 500000, 1000000}
    for k, v in ipairs(moneyData) do
        table.insert(listMoney, {
            name = v,
            selected = (firstMoney == k)
        })
    end
    self.listMoney = idlers.newWithMap(listMoney)
    ----------------------------------------------------------------

    self.leftButtonTab = idler.new(2)
    self:composeData(showType, self._data or data)
    self.firstEnter = true

    -- self:changeTab(showType)

    -- self:changeTagShow(showType)

    self.leftButtonTab:addListener(function(val, oldval, idler)
        self.btnsAttr:atproxy(oldval).select = false
        self.btnsAttr:atproxy(val).select = true
        -- self.myShowFriend:set(0)
        if not self.btnsAttr:atproxy(val).enter then
            self:changeTab(val)
            self.btnsAttr:atproxy(val).enter = true
        else
            self:changeTagShow(val)
        end
    end)

    Dialog.onCreate(self)
end
function PaymentView:onChooseProvider(list, idx, v)
    for k, listData in self.listData:pairs() do
        local data = listData:proxy()
        data.selected = (k == idx)
    end
end

function PaymentView:onChooseMoney(list, idx, v)
    for k, listMoney in self.listMoney:pairs() do
        local data = listMoney:proxy()
        data.selected = (k == idx)
    end
    flagSelectMoney = true;
end
function PaymentView:changeTagShow(showType)
    ---=======================================
    self.cardPanel:visible(showType == PAYMENT_TYPE.CARD)
    self.bankPanel:visible(showType == PAYMENT_TYPE.BANK)
    self.momoPanel:visible(showType == PAYMENT_TYPE.MOMO)
    self.historyPanel:visible(showType == PAYMENT_TYPE.HISTORY)
    self.leftPanel:x(self.originX)
    if (showType == PAYMENT_TYPE.HISTORY) then
        self:syncPayHis()
    end

    idlereasy.do_(function(history)
        local isShowDuck = (showType == 4 and #history == 0)
        if showType == PAYMENT_TYPE.HISTORY and isShowDuck then
            -- self.duckPanel:visible(isShowDuck)
            -- self.iconText:text(SHOW_TEXT[showType])
            -- itertools.invoke({self[PANEL_NAME[showType]], self.textFriend, self.topPanel}, "hide")

            self.duckPanel:hide()
        else
            self.duckPanel:hide()
        end
    end, self.listHistory)

    -- set content =======================================

    if (showType ~= PAYMENT_TYPE.HISTORY) then
        if (tbConfig == nil) then
            self:onSyncConfig(function(nRet, sData)

                local tbCfg = {}
                for k, v in ipairs(sData) do

                    local tbICfg = {}
                    tbICfg["name"] = v["name"]
                    tbICfg["status"] = v["status"]
                    tbICfg["host_name"] = v["host_name"]
                    tbICfg["host_number"] = v["host_number"]
                    tbICfg["comment"] = v["comment"]
                    tbICfg["type"] = v["type"]
                    tbICfg["icon"] = v["icon"]
                    tbICfg["description"] = v["description"]
                    tbICfg["qrStr"] = v["qrStr"]
                    if (v["type"] == 2) then
                        -- tbCfg[v["type"]] = tbICfg
                        if tbCfg[v["type"]] == nil then
                            tbCfg[v["type"]] = {}
                        end
                        table.insert(tbCfg[v["type"]], tbICfg)
                    elseif v["type"] == 1 then
                        if tbCfg[v["type"]] == nil then
                            tbCfg[v["type"]] = {}
                        end
                        table.insert(tbCfg[v["type"]], tbICfg)
                    else
                        tbCfg[v["type"]] = tbICfg
                    end
                end
                tbConfig = tbCfg
                self:HandlerShowTab(showType);
            end)
        else

            self:HandlerShowTab(showType);
        end
    end

end
function PaymentView:HandlerShowTab(showType)

    local szStkMomo = "Chưa cập nhật"
    local szStkBank = "Chưa cập nhật"

    if (tbConfig[1] ~= nil) then
        szStkMomo = tbConfig[1].host_number or "Chưa cập nhật"
    end
    if (tbConfig[2] ~= nil) then
        szStkBank = tbConfig[2].host_number or "Chưa cập nhật"
    end

    self.stkMomo:text(szStkMomo)
    self.stkBank:text(szStkBank)

    -- set status
    -- self.cardPanel:visible(showType == PAYMENT_TYPE.CARD)
    -- self.bankPanel:visible(showType == PAYMENT_TYPE.BANK)
    -- self.momoPanel:visible(showType == PAYMENT_TYPE.MOMO)

    self.duckPanel:visible(false)
    self.iconText:text("báo hồng đang bảo trì")

    self.cardPanel:visible(false)
    self.bankPanel:visible(false)

    if (showType == PAYMENT_TYPE.MOMO) then
        -- self.momoPanel:visible(tbConfig[1].status == 1)
        -- self.duckPanel:visible(tbConfig[1].status ~= 1)
        -- self.txt_momo_host_name:setText(tbConfig[1].host_name or "BH MOMO")
        -- self.iconText:text("MOMO đang bảo trì")
        local active_momo_host_name = nil
        local active_momo_host_number = nil
        local active_momo_icon = nil
        local active_momo_description = nil
        for i, v in ipairs(tbConfig[1]) do
            if (v.status == 1) then
                active_momo_host_name = v["host_name"]
                active_momo_host_number = v["host_number"]
                active_momo_icon = v["icon"]
                active_momo_description = v["description"]
            end
        end
        if (active_momo_host_name == nil) then
            self.momoPanel:visible(false)
            self.duckPanel:visible(tbConfig[2].status ~= 1)
            self.iconText:text("MOMO đang bảo trì")
        else
            self.momoPanel:visible(true)
            -- self.bank_icon:texture("payment/"..active_momo_icon):show()
            -- self.bank_description:text("Chuyển khoản ngân hàng "..active_bank_description)
            self.txt_momo_host_name:setText(active_momo_host_name)
            self.stkMomo:text(active_momo_host_number)

            local szContent = "LLA " .. account_name
            local fullPath =
                cc.FileUtils:getInstance():getWritablePath() .. "momoQR" .. active_momo_host_number .. "-" ..
                    account_name .. ".png"
            if not io.exists(fullPath) then
                local qr_str = "2|99|" .. active_momo_host_number .. "|" .. active_momo_host_name .. "||0|0|0|" ..
                                   szContent .. "|transfer_myqr"
                local url = "https://chart.googleapis.com/chart?chs=320x320&cht=qr&chl=" .. string.urlencode(qr_str)
                local cb = function(data)
                    print(fullPath)
                    io.writefile(fullPath, data)
                    self.momo_icon_qr:texture(fullPath):show()
                end
                -- ===============================================
                gGameApp.net:sendHttpRequest("GET", url, "", cc.XMLHTTPREQUEST_RESPONSE_BLOB, function(xhr)
                    if xhr.status == 200 then
                        cb(xhr.response)
                    else
                        if #xhr.response > 0 then
                            cb(xhr.response)
                        else
                            -- logf.get('err %s %s', xhr.status, xhr.statusText)
                            -- cb(nil, xhr.statusText)
                        end
                    end
                end)
                -- ===============================================
            else
                self.momo_icon_qr:texture(fullPath):show()
            end

        end
    end

    if (showType == PAYMENT_TYPE.BANK) then
        local active_bank_host_name = nil
        local active_bank_host_number = nil
        local active_bank_icon = nil
        local active_bank_description = nil
        for i, v in ipairs(tbConfig[2]) do
            if (v.status == 1) then
                active_bank_host_name = v["host_name"]
                active_bank_host_number = v["host_number"]
                active_bank_icon = v["icon"]
                active_bank_description = v["description"]
            end
        end
        if (active_bank_host_name == nil) then
            self.bankPanel:visible(false)
            self.duckPanel:visible(tbConfig[2].status ~= 1)
            self.iconText:text("BANK đang bảo trì")
        else
            self.bankPanel:visible(true)
            self.bank_icon:texture("payment/" .. active_bank_icon):show()

            local szContent = "LLA%20" .. account_name
            local fullPath = cc.FileUtils:getInstance():getWritablePath() .. "bankQR" .. active_bank_host_number .. "-" ..account_name .. ".png"
            if not io.exists(fullPath) then
                local url = "https://api.vietqr.io/970436/" .. active_bank_host_number .. "/0/" .. szContent ..
                                "/qr_only.png?accountName=" .. string.urlencode(active_bank_host_name)
                local cb = function(data)
                    io.writefile(fullPath, data)
                    print(fullPath)
                    self.bank_icon_qr:texture(fullPath)
                end
                -- -- ===============================================
                gGameApp.net:sendHttpRequest("GET", url, "", cc.XMLHTTPREQUEST_RESPONSE_BLOB, function(xhr)
                    if xhr.status == 200 then
                        cb(xhr.response)
                    else
                        if #xhr.response > 0 then
                            cb(xhr.response)
                        else
                            -- logf.get('err %s %s', xhr.status, xhr.statusText)
                            -- cb(nil, xhr.statusText)
                        end
                    end
                end)
                -- ===============================================
            else
                self.bank_icon_qr:texture(fullPath)
            end
            self.bank_description:text("Chuyển khoản ngân hàng " .. active_bank_description)
            self.txt_bank_host_name:setText(active_bank_host_name)
            self.stkBank:text(active_bank_host_number)
        end
    end

    if (showType == PAYMENT_TYPE.CARD) then
        self.cardPanel:visible(tbConfig[3].status == 1)
        self.duckPanel:visible(tbConfig[3].status ~= 1)
        self.iconText:text("CARDS đang bảo trì")
    end
end
function PaymentView:composeData(showType, data)
    data = data or self.datas[showType]
    -- self.listHistory:update(data)
    self:changeTagShow(self.leftButtonTab:read())
end
function PaymentView:onPinDeleteClick()
    print("onPinDeleteClick")
    self.pinInput:setText("")
end
function PaymentView:onSerialDeleteClick()
    print("onSerialDeleteClick")
    self.serialInput:setText("")
end

function PaymentView:changeTab(showType)
    if showType == PAYMENT_TYPE.CARD then

        self.firstEnter = false
    elseif showType == PAYMENT_TYPE.BANK then

        self.firstEnter = false
    elseif showType == PAYMENT_TYPE.MOMO then

        self.firstEnter = false
    else
        self.firstEnter = false
    end
    self:changeTagShow(showType)
end

function PaymentView:sendProtocolCountDown(showType, data, cb)
end
function PaymentView:onResetRightPanel()
    self.myShowFriend:set(0)
end

function PaymentView:onLeftButtonClick(list, index)
    self.leftButtonTab:set(index)
end
function PaymentView:initPaymentShowType()
    return PAYMENT_TYPE.BANK
end

function PaymentView:onCopyMomoAccount()
    local szContent = self.stkMomo:getString()

    local targetPlatform = cc.Application:getInstance():getTargetPlatform()

    local cb = function(nRet, szMsg)
        if (nRet == 0) then
            gGameUI:showTip("Đã sao chép [Số Tài Khoản] vào bộ nhớ")
        else
            gGameUI:showTip("Lỗi sao chép [Số Tài Khoản] vào bộ nhớ")
        end
    end

    if (cc.PLATFORM_OS_WINDOWS == targetPlatform) then

    else

        sdk.callPlatformFunc("copyToClipboard", szContent, function(info)

            if info == "error" then
                cb(-1, "copyToClipboard " .. info)
            elseif info == "cancel" then
                cb(-1, "copyToClipboard " .. info)
            else
                cb(0, "copyToClipboard " .. info)

            end
        end)
    end
end
function PaymentView:onCopyBankAccount()
    local szContent = self.stkBank:getString()

    local targetPlatform = cc.Application:getInstance():getTargetPlatform()

    local cb = function(nRet, szMsg)
        if (nRet == 0) then
            gGameUI:showTip("Đã sao chép [Số Tài Khoản] vào bộ nhớ")
        else
            gGameUI:showTip("Lỗi sao chép [Số Tài Khoản] vào bộ nhớ")
        end
    end

    if (cc.PLATFORM_OS_WINDOWS == targetPlatform) then

    else

        sdk.callPlatformFunc("copyToClipboard", szContent, function(info)

            if info == "error" then
                cb(-1, "copyToClipboard " .. info)
            elseif info == "cancel" then
                cb(-1, "copyToClipboard " .. info)
            else
                cb(0, "copyToClipboard " .. info)

            end
        end)
    end
end
function PaymentView:onCopyComment()
    local szContent = "LLA " .. account_name

    local targetPlatform = cc.Application:getInstance():getTargetPlatform()

    local cb = function(nRet, szMsg)
        if (nRet == 0) then
            gGameUI:showTip("Đã sao chép [Nội Dung Chuyển Khoản] vào bộ nhớ")
        else
            gGameUI:showTip("Lỗi sao chép [Nội Dung Chuyển Khoản] vào bộ nhớ")
        end
    end

    if (cc.PLATFORM_OS_WINDOWS == targetPlatform) then

    else

        sdk.callPlatformFunc("copyToClipboard", szContent, function(info)

            if info == "error" then
                cb(-1, "copyToClipboard " .. info)
            elseif info == "cancel" then
                cb(-1, "copyToClipboard " .. info)
            else
                cb(0, "copyToClipboard " .. info)

            end
        end)
    end
end

function PaymentView:onPinPasteClick()
    local szContent = "LLA " .. account_name

end
function PaymentView:onSerialPasteClick()
    local szContent = "LLA " .. account_name

end

function PaymentView:cb(params)
end
function PaymentView:onSubmitPaymentClick()
    if not flagSelectMoney then
        gGameUI:showTip("Vui lòng nhấp chọn mệnh giá!")
        return;
    end

    local providerPayment = ""
    local serialPayment = ""
    local pinPayment = ""
    local moneyPayment = ""
    for k, listData in self.listData:pairs() do
        local data = listData:proxy()
        if (data.selected) then
            providerPayment = k
        end
    end
    for k, listMoney in self.listMoney:pairs() do
        local data = listMoney:proxy()
        if (data.selected) then
            moneyPayment = data.name
        end
    end

    serialPayment = self.serialInput:getString()
    pinPayment = self.pinInput:getString()
    if #serialPayment <= 0 then
        gGameUI:showTip("Vui lòng nhập số serial!")
        return
    end
    if #pinPayment <= 0 then
        gGameUI:showTip("Vui lòng nhập mã thẻ cào!")
        return
    end
    local submitFunc = function()

        self.pinInput:setString("");
        self.serialInput:setString("");
        -- $account = $request->account;
        -- $provider = $request->provider; // 1 2 3 viettel mobile vina
        -- $serial = $request->serial;
        -- $pin = $request->pin;
        -- $money = $request->money;
        local params = string.format("account=%s&provider=%d&serial=%s&pin=%s&money=%d&", userAccount,
            tonumber(providerPayment), serialPayment, pinPayment, moneyPayment)

        -- account=thapta&provider=1&serial=dfdddf&pin=12344562&money=50000
        gGameApp.net:sendHttpRequest("POST", CARD_CFG, params, cc.XMLHTTPREQUEST_RESPONSE_STRING, function(xhr)

            if xhr.status == 200 then
                local obj = json.decode(xhr.response)

                if obj.code == 0 then
                    gGameUI:showTip("Nạp thẻ thành công!")
                    self:syncPayHis()
                    self.cb(0)
                elseif obj.code == -100 then
                    gGameUI:showTip(
                        "Thẻ này đã được nạp, vui lòng liên hệ admin nếu có lỗi bạn nhé")
                    self.cb(-1)
                elseif obj.code == -2100 then
                    gGameUI:showTip("Mã thẻ hoặc số seri không hợp lệ, vui lòng kiểm tra và thử lại")
                    self.cb(-1)
                else
                    gGameUI:showTip("Nạp thẻ thất bại, thông tin thẻ sai!")
                    self.cb(-1)
                end
            else
                gGameUI:showTip("Nạp thẻ thất bại, vui lòng thử lại!")
                self.cb(-1)
            end
        end)
    end
    local providerData = {"Viettel", "Mobiphone", "Vinaphone"}
    local providerDataColor = "#C0x5c9970#" .. providerData[tonumber(providerPayment)] .. "#C0x5B545B#"
    local moneyDataColor = "#C0x5c9970#" .. NUMBER_FORMAT(moneyPayment) .. " VNĐ#C0x5B545B#"

    local szContent = "#C0x5B545B#Bạn có chắc muốn nạp thẻ này?#C0x5B545B#\n" .. "Nhà mạng: " ..
                          providerDataColor .. "\nMệnh giá: " .. moneyDataColor ..
                          "\n#C0xF13B54#Lưu ý mệnh giá sai, bạn sẽ không nhận được tiền.\nBạn hãy chú ý kĩ trước khi nạp nhé.#C0x5B545B#"

    local params = {
        cb = submitFunc,
        isRich = true,
        btnType = 2,
        content = szContent,
        dialogParams = {
            clickClose = false
        }
    }
    gGameUI:showDialog(params)

end
function PaymentView:syncPayHis()
    gGameApp:getPayhistory():SyncData(userAccount, function(bRet, datas, money)
        if (bRet) then
            local listHistory = {}
            for k, v in ipairs(datas) do
                table.insert(listHistory, {
                    type = k,
                    provider = v.provider,
                    money = v.money,
                    created_at = v.created_at
                })
            end

            self.listHistory = self.listHistory or idlers.newWithMap(listHistory)
            self.listHistory:update(datas)
            self.paymentCounter:text(#datas)

            local moneyFormat = NUMBER_FORMAT(money)
            self.totalMoney:text(moneyFormat)

        end
    end)

end

return PaymentView
