-- RxNotify Override for QBox
--[[
    1. Open `qbx_core/client/functions.lua`
    2. Replace the `Notify` function with the following code.
--]]

function Notify(text, notifyType, duration, subTitle, notifyPosition, notifyStyle, notifyIcon, notifyIconColor)
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

    -- Map type to RxNotify types
    local rxType = notifyType or 'info'
    if rxType == 'warning' then rxType = 'warn' end

    -- Build options table if we have position
    local options = position and { position = position } or nil

    exports["RxNotify"]:Notify(title, description, rxType, duration, options)
end