--[[
BY RX Scripts © rxscripts.xyz
--]]

fx_version 'cerulean'
games { 'gta5' }

author 'Rejox | rxscripts.xyz'
description 'RX Notification System'
version '1.0.0'
repository 'RxNotify'
github 'rxscripts'

server_script 'versioncontrol.lua'

shared_script {
  'config.lua',
  'init.lua',
}

client_scripts {
  'client/main.lua',
}

ui_page 'web/dist/index.html'

files {
  'web/dist/index.html',
  'web/dist/assets/*.*',
}

lua54 'yes'