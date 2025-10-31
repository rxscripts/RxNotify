--[[
BY RX Scripts © rxscripts.xyz
--]]

Config = {}

-- Default notification position
-- Options: 'tl' (top-left), 'tc' (top-center), 'tr' (top-right),
--          'lc' (left-center), 'rc' (right-center),
--          'bl' (bottom-left), 'bc' (bottom-center), 'br' (bottom-right)
-- Can be overridden per-notification using options.position
Config.Position = 'lc'

-- Default notification duration in milliseconds
Config.DefaultDisplayTime = 3000

-- Default titles shown when no title is provided
Config.DefaultTitles = {
    enabled = true,      -- Set to false to show text as title when no title provided
    success = 'Success',
    warn = 'Warning',
    error = 'Error',
    info = 'Info',
}

-- Notification color scheme (all colors are customizable)
Config.Colors = {
    -- Background and text colors
    background = '#1A1B26',     -- Notification background
    textPrimary = '#F7FAFC',    -- Title text color
    textSecondary = '#A0AEC0',  -- Description text color

    -- Accent colors for each notification type (border & icon)
    success = '#10B981',        -- Green
    warning = '#F59E0B',        -- Amber
    error = '#EF4444',          -- Red
    info = '#3B82F6'            -- Blue (also default type)
}