--[[
BY RX Scripts © rxscripts.xyz
--]]

if GetCurrentResourceName() ~= 'RxNotify' then return end

local function toVue(action, data)
    SendNUIMessage({
        action = action,
        data = data,
    })
end

---@param title? string
---@param text? string
---@param notifType? 'success' | 'error' | 'info' | 'warn'
---@param length? number
---@param options? table
local function notify(title, text, notifType, length, options)
    if type(length) == 'table' then
        options = length
        length = nil
    end

    notifType = notifType or 'info'
    length = length or Config.DefaultDisplayTime
    if notifType == 'warning' then notifType = 'warn' end
    if notifType == 'inform' then notifType = 'info' end

    if not title then
        if Config.DefaultTitles then
            title = Config.DefaultTitles[notifType]
        else
            title = text
            text = nil
        end
    end

    toVue('notify', {
        title = title,
        text = text,
        type = notifType,
        length = length,
        options = options or {}
    })
end

exports('Notify', notify)

RegisterNetEvent('RxNotify:Notify', function(title, text, type, length, options)
    notify(title, text, type, length, options)
end)

RegisterNUICallback('fetchConfig', function(data, cb)
    cb(Config)
end)