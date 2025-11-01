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

**Note:** Make sure to add the `client_script` line at the **bottom** of the fxmanifest.lua file so it loads after all other client scripts and properly overrides the framework's notification functions.

## QBCore Installation

1. Copy the file `QBCore/rxnotify.lua` to your `qb-core` resource folder
2. Open `qb-core/fxmanifest.lua`
3. Add the following line at the **bottom** of the file (to ensure it loads last):
   ```lua
   client_script 'rxnotify.lua'
   ```
4. Restart your server.

**Note:** Make sure to add the `client_script` line at the **bottom** of the fxmanifest.lua file so it loads after all other client scripts and properly overrides the framework's notification functions.

## QBox Installation

1. Open `qbx_core/server/functions.lua`
2. Replace the `Notify` function with the code in `rxnotify_server.lua`
3. Open `qbx_core/client/functions.lua`
4. Replace the `Notify` function with the code in `rxnotify_client.lua`

**Note:** QBox requires both server-side and client-side function replacements for RxNotify to work properly.

---

After installation, all framework notifications will automatically use RxNotify!
