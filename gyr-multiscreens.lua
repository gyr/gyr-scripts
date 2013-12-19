local io = require("io")
local awful = require("awful")
local naughty = require("naughty")
--local mouse = require("mouse")
local unpack = unpack
local timer = timer

module("multiscreens")

-- Build available choices
local function menu()
    local menu = {}
    local xrandr = io.popen("xrandr -q")
    if xrandr then
        for line in xrandr:lines() do
            output = line:match("LVDS1 connected ")
            if output then
                menu[#menu + 1] = { 'Only <span weight="bold">laptop (LVDS1 1600x900)</span>',
                    "/home/gyr/.gyr.d/scripts/gyr-monitor-set-resolution -l",
                    "/usr/share/icons/gnome/16x16/devices/display.png"}
            end
            output = line:match("VGA1 connected ")
            if output then
                menu[#menu + 1] = { 'Only <span weight="bold">monitor (VGA1 1920x1080)</span>',
                    "/home/gyr/.gyr.d/scripts/gyr-monitor-set-resolution -e",
                    "/usr/share/icons/gnome/16x16/devices/display.png"}
                menu[#menu + 1] = { '<span weight="bold">presentation (LVDS1+VGA1 1024x768)</span>',
                    "/home/gyr/.gyr.d/scripts/gyr-monitor-set-resolution -p",
                    "/usr/share/icons/gnome/16x16/devices/display.png"}
                menu[#menu + 1] = { '<span weight="bold">dual monitor (LVDS1+VGA1 1920x1080)</span>',
                    "/home/gyr/.gyr.d/scripts/gyr-monitor-set-resolution -a",
                    "/usr/share/icons/gnome/16x16/devices/display.png"}
            end
        end
        xrandr:close()
    end

    return menu
end

-- Display xrandr notifications from choices
local state = { iterator = nil,
    timer = nil,
    cid = nil }
function xrandr()
    -- Stop any previous timer
    if state.timer then
        state.timer:stop()
        state.timer = nil
    end

    -- Build the list of choices
    if not state.iterator then
        state.iterator = awful.util.table.cycle(menu(),
            function() return true end)
    end

    -- Select one and display the appropriate notification
    local next  = state.iterator()
    local label, action, icon
    if not next then
        label, icon = "Keep the current configuration", "/usr/share/icons/gnome/16x16/devices/display.png"
        state.iterator = nil
    else
        label, action, icon = unpack(next)
    end
    state.cid = naughty.notify({ text = label,
        icon = icon,
        timeout = 4,
        --screen = mouse.screen, -- Important, not all screens may be visible
        --font = "Free Sans 18",
        replaces_id = state.cid }).id

    -- Setup the timer
    state.timer = timer { timeout = 4 }
    state.timer:add_signal("timeout",
        function()
            state.timer:stop()
            state.timer = nil
            state.iterator = nil
            if action then
                awful.util.spawn(action, false)
            end
        end)
    state.timer:start()
end
