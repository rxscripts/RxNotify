-- RxNotify Override for QBox
--[[
    1. Open `qbx_core/server/functions.lua`
    2. Replace the `Notify` function with the following code.
--]]

function Notify(source, text, notifyType, duration, subTitle, notifyPosition, notifyStyle, notifyIcon, notifyIconColor)
    local title, description
    if type(text) == 'table' then
        title = text.text or 'Placeholder'
        description = text.caption or nil
    elseif subTitle then
        title = text
        description = subTitle
    else
        description = text
    end

    -- Map position if provided
    local position = nil
    if notifyPosition then
        position = positionMap[notifyPosition] or notifyPosition
    end

    TriggerClientEvent('RxNotify:Notify', source, title, description, notifyType, duration,
        { position = position })
end