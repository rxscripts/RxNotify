-- RxNotify Override for ESX
--[[
    1. Copy the file `ESX/rxnotify.lua` to your `es_extended` resource folder
    2. Open `es_extended/fxmanifest.lua`
    3. Add the following line at the **bottom** of the file (to ensure it loads last):
    ```lua
    client_script 'rxnotify.lua'
    ```
    4. Restart your server.
--]]

local originalShowNotification = ESX.ShowNotification
ESX.ShowNotification = function(message, notifyType, length)
    if GetResourceState("RxNotify") == "started" then
        exports["RxNotify"]:Notify(nil, message, notifyType, length)
    else
        originalShowNotification(message, notifyType, length)
    end
end