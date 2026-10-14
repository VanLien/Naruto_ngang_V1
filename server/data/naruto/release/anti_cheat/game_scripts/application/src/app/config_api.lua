local ConfigAPI = {}
local crypto = require("crypto") 

function createSignature(username, device)
    local raw = string.format("username=%s&device=%s&key=%s", username, device, timestamp, CLIENT_KEY)
    local sign = crypto.digest("sha256", raw)
    return sign
end

function ConfigAPI.getUserInfo(cb)
    local token = cc.UserDefault:getInstance():getStringForKey("accessToken", "")
    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr:open("GET", GET_INFORMATION_CONFIG)
    xhr.timeout = 10
    xhr:setRequestHeader("Content-Type", "application/json")
    xhr:setRequestHeader("Authorization", "Bearer " .. token)
    xhr:setRequestHeader("Accept", "application/json")

    xhr:registerScriptHandler(function()
        print("XHR readyState:", xhr.readyState)
        print("XHR status:", xhr.status)
        print("XHR response:", xhr.response)

        if xhr.readyState ~= 4 then
            return
        end
        
        if xhr.status == 200 then
            local response = json.decode(xhr.response)
            if response and response.data then
                if cb then cb(true, response) end
            else
                if cb then cb(false, { message = "Không có data" }) end
            end
        else
            if cb then cb(false, { message = "HTTP status " .. xhr.status, response = xhr.response }) end
        end
    end)

    xhr:send()
end

function ConfigAPI.sendUserInfo(cb)
    local platform_post = 3
    if device.platform == "android" then
        platform_post = 1
    elseif device.platform == "ios" then
        platform_post = 2
    end

    local username = cc.UserDefault:getInstance():getStringForKey("username", "")
    local token = cc.UserDefault:getInstance():getStringForKey("accessToken", "")
    local timestamp = os.time()
    local CLIENT_KEY = "YOUR_CLIENT_KEY"  -- thay bằng key anh đang dùng

    local signature = createSignature(username, platform_post, timestamp, CLIENT_KEY)

    -- Param dạng form-urlencoded
    local params = string.format("username=%s&device=%s&timestamp=%s&signature=%s",
        username, platform_post, timestamp, signature)

    local headers = {
        ["Content-Type"] = "application/x-www-form-urlencoded",
        ["Authorization"] = "Bearer " .. token,
        ["Accept"] = "application/json",
    }

    gGameApp.net:sendHttpRequest("POST", globals.SEND_INFORMATION_CONFIG, params, cc.XMLHTTPREQUEST_RESPONSE_STRING, function(xhr)
        print("POST XHR status:", xhr.status)
        print("POST XHR response:", xhr.response)

        if xhr.status == 200 then
            local response = json.decode(xhr.response)
            if cb then cb(true, response) end
        else
            if cb then cb(false, { message = "HTTP status " .. xhr.status, response = xhr.response }) end
        end
    end, headers)
end

return ConfigAPI