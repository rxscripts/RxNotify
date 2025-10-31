-- RxNotify Override for ESX

local originalShowNotification = ESX.ShowNotification
ESX.ShowNotification = function(message, notifyType, length)
    if GetResourceState("RxNotify") == "started" then
        exports["RxNotify"]:Notify(nil, message, notifyType, length)
    else
        originalShowNotification(message, notifyType, length)
    end
end