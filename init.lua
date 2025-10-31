--[[
BY RX Scripts © rxscripts.xyz
--]]

function Error(str, ...)
    if ... then
        print("^7(^1ERROR^7) "..string.format(str, ...).."^7")
    else
        print("^7(^1ERROR^7) "..str.."^7")
    end
end

function Success(str, ...)
    if ... then
        print("^7(^2SUCCESS^7) "..string.format(str, ...).."^7")
    else
        print("^7(^2SUCCESS^7) "..str.."^7")
    end
end

function Warning(str, ...)
    if ... then
        print("^7(^3WARNING^7) "..string.format(str, ...).."^7")
    else
        print("^7(^3WARNING^7) "..str.."^7")
    end
end

if GetCurrentResourceName() ~= 'RxNotify' then
    CreateThread(function()
        Error("Please ensure that the resource name is RxNotify, changing the resource name will break the script!")
        Wait(1000 * 30)
    end)
else
    Success("Initialized ^1" .. GetCurrentResourceName() .." ^7by ^1rxscripts.xyz")
end