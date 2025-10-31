# RxNotify Framework Installation

To integrate RxNotify with your framework, follow these steps:

## ESX Installation

1. Copy the file `ESX/rxnotify.lua` to your `es_extended` resource folder
2. Open `es_extended/fxmanifest.lua`
3. Add the following line at the **bottom** of the file (to ensure it loads last):
   ```lua
   client_script 'rxnotify.lua'
   ```
4. Restart your server.

## QBCore Installation

1. Copy the file `QBCore/rxnotify.lua` to your `qb-core` resource folder
2. Open `qb-core/fxmanifest.lua`
3. Add the following line at the **bottom** of the file (to ensure it loads last):
   ```lua
   client_script 'rxnotify.lua'
   ```
4. Restart your server.

## QBox Installation

1. Copy the file `QBox/rxnotify.lua` to your `qbx_core` (or `qbx-core`) resource folder
2. Open `qbx_core/fxmanifest.lua`
3. Add the following line at the **bottom** of the file (to ensure it loads last):
   ```lua
   client_script 'rxnotify.lua'
   ```
4. Restart your server.

---

**Important:** Make sure to add the `client_script` line at the **bottom** of the fxmanifest.lua file so it loads after all other client scripts and properly overrides the framework's notification functions.

After installation, all framework notifications will automatically use RxNotify!
