-- RxNotify Override for QBCore
--[[
    1. Copy the file `QBCore/rxnotify.lua` to your `qb-core` resource folder
    2. Open `qb-core/fxmanifest.lua`
    3. Add the following line at the **bottom** of the file (to ensure it loads last):
    ```lua
    client_script 'rxnotify.lua'
    ```
    4. Restart your server.
--]]

local originalNotify = QBCore.Functions.Notify
QBCore.Functions.Notify = function(text, texttype, length)
    if GetResourceState("RxNotify") == "started" then
        local msg = text
        local title = nil

        if type(text) == 'table' then
            msg = text.text or text.caption or ''
            title = text.title
        end

        local notifyType = texttype or 'info'
        if notifyType == 'primary' then notifyType = 'info' end
        if notifyType == 'warning' then notifyType = 'warn' end

        exports["RxNotify"]:Notify(title, msg, notifyType, length)
    else
        originalNotify(text, texttype, length)
    end
end