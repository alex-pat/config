-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local lain = require("lain")
local vicious = require("vicious")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
   naughty.notify({ preset = naughty.config.presets.critical,
                    title = "Oops, there were errors during startup!",
                    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
   local in_error = false
   awesome.connect_signal("debug::error", function (err)
                             -- Make sure we don't go into an endless error loop
                             if in_error then return end
                             in_error = true

                             naughty.notify({ preset = naughty.config.presets.critical,
                                              title = "Oops, an error happened!",
                                              text = tostring(err) })
                             in_error = false
   end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/usr/share/awesome/themes/myzen/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "termite"
file_manager = "ranger"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
file_manager_cmd = terminal .. " -e " .. file_manager

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
   awful.layout.suit.tile,
   awful.layout.suit.tile.left,
   awful.layout.suit.tile.bottom,
   awful.layout.suit.tile.top,
   awful.layout.suit.fair,
   awful.layout.suit.fair.horizontal,
   awful.layout.suit.spiral,
   awful.layout.suit.spiral.dwindle,
   awful.layout.suit.floating,
   awful.layout.suit.max.fullscreen,
   awful.layout.suit.magnifier,
   awful.layout.suit.corner.sw,
   awful.layout.suit.corner.se,
   awful.layout.suit.corner.ne,
   awful.layout.suit.max,
   awful.layout.suit.corner.nw,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
   local instance = nil

   return function ()
      if instance and instance.wibox.visible then
         instance:hide()
         instance = nil
      else
         instance = awful.menu.clients({ theme = { width = 250 } })
      end
   end
end
-- }}}

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
   awful.button({ }, 1, function(t) t:view_only() end),
   awful.button({ modkey }, 1, function(t)
         if client.focus then
            client.focus:move_to_tag(t)
         end
   end),
   awful.button({ }, 3, awful.tag.viewtoggle),
   awful.button({ modkey }, 3, function(t)
         if client.focus then
            client.focus:toggle_tag(t)
         end
   end),
   awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
   awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)


-- {{{ awesompd
local awesompd = require("awesompd/awesompd")
musicwidget = awesompd:create() -- Create awesompd widget
--  musicwidget.font = "Liberation Mono" -- Set widget font 
musicwidget.scrolling = false -- If true, the text in the widget will be scrolled
--  musicwidget.output_size = 30 -- Set the size of widget in symbols
musicwidget.update_interval = 10 -- Set the update interval in seconds
-- Set the folder where icons are located (change username to your login name)
musicwidget.path_to_icons = "/home/postskript/.config/awesome/awesompd/icons" 
musicwidget.show_album_cover = true
-- Specify how big in pixels should an album cover be. Maximum value
-- is 100.
musicwidget.album_cover_size = 50
-- This option is necessary if you want the album covers to be shown
-- for your local tracks.
musicwidget.mpd_config = "/etc/mpd.conf"
-- Specify the browser you use so awesompd can open links from
-- Jamendo in it.
musicwidget.browser = "firefox"
-- Specify decorators on the left and the right side of the
-- widget. Or just leave empty strings if you decorate the widget
-- from outside.
musicwidget.ldecorator = " "
musicwidget.rdecorator = ""
-- Set all the servers to work with (here can be any servers you use)
musicwidget.servers = {
   { server = "localhost",
     port = 6600 },
   { server = "192.168.0.72",
     port = 6600 } }
-- Set the buttons of the widget
musicwidget:register_buttons({ { "", awesompd.MOUSE_LEFT, musicwidget:command_toggle() },
      { "Control", awesompd.MOUSE_SCROLL_UP, musicwidget:command_prev_track() },
      { "Control", awesompd.MOUSE_SCROLL_DOWN, musicwidget:command_next_track() },
      { "", awesompd.MOUSE_RIGHT, musicwidget:command_show_menu() },
      { "", "XF86AudioLowerVolume", musicwidget:command_volume_down() },
      { "", "XF86AudioRaiseVolume", musicwidget:command_volume_up() } })
musicwidget:run() -- After all configuration is done, run the widget

function music(action)
   awful.spawn("mpc " .. action , false)
   musicwidget:update_track()
end
-- }}}

mytextclock = wibox.widget.textbox()
vicious.register(mytextclock, vicious.widgets.date, " %a %b %d, %R:%S ", 1)

memicon = wibox.widget.imagebox(beautiful.widget_mem)
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, "$2MB $1% ", 5)

cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
cpuwidget = wibox.widget.textbox()    
vicious.register(cpuwidget, vicious.widgets.cpu, "$1%", 2)

tempwidget = wibox.widget.textbox()
vicious.register(tempwidget, vicious.widgets.thermal,
                 function (widget, args)
                    if args[1] >= 70 then
                       naughty.notify({
                             text = "Huston, we have a problem",
                             title = "CPU burning: " .. args[1] .. "°C",
                             timeout = 5, hover_timeout = 0.5,
                             position = "top_right",
                             bg = "#F06060",
                             fg = "#EEE9EF",
                             width = 200,
                       })    
                    end
                    return " " .. args[1] .. "°C "
                 end, 2, "thermal_zone0")   -- , " $1°C "

function brightness(state)
   if     state == "up" then
      awful.spawn("light -A 2", false)
   elseif state == "down" then
      awful.spawn("light -U 2", false)
   end
end

baticon = wibox.widget.imagebox(beautiful.widget_battery)
batterywidget = wibox.widget.textbox()
batterywidget:buttons(awful.util.table.join(
                         awful.button({ }, 4, function () brightness("up") end),
                         awful.button({ }, 5, function () brightness("down") end)
))

vicious.register(batterywidget, vicious.widgets.bat,
                 function (widget, args)
                    if args[2] <= 20 and string.byte(args[1]) == 226 then
                       naughty.notify({
                             text = "Huston, we have a problem",
                             title = "Battery dying: " .. args[2] .. "%",
                             timeout = 5, hover_timeout = 0.5,
                             position = "top_right",
                             bg = "#F06060",
                             fg = "#EEE9EF",
                             width = 200,
                       })
                    end
                    return args[1] .. args[2] .."% "
                 end, 5, "BAT0")

volumewidget = wibox.widget.textbox()

function vol(state)
   if     state == "up" then
      awful.spawn("amixer set Master 1%+", false)
   elseif state == "down" then
      awful.spawn("amixer set Master 1%-", false)
   elseif state == "toggle" then
      awful.spawn("amixer set Master toggle", false)
   end
   vicious.force({volumewidget,})
end

volumewidget:buttons(awful.util.table.join(
                        awful.button({ }, 4, function () vol("up") end),
                        awful.button({ }, 5, function () vol("down") end),
                        awful.button({ }, 1, function () vol("toggle") end)
))
vicious.register(volumewidget, vicious.widgets.volume, " $2 $1 ",1, "Master")

-- {{{ orglendar
local orglendar = require('orglendar')
orglendar.files = { "/home/postskript/tasks.org" }
orglendar.register(mytextclock)
--- }}}

-- Separators
spr = wibox.widget.textbox(' ')
separators = lain.util.separators
arrl_dl = separators.arrow_left(beautiful.arrow_color, "alpha")
arrl_ld = separators.arrow_left("alpha", beautiful.arrow_color)

local tasklist_buttons = awful.util.table.join(
   awful.button({ }, 1, function (c)
         if c == client.focus then
            c.minimized = true
         else
            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
               c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
         end
   end),
   awful.button({ }, 3, client_menu_toggle_fn()),
   awful.button({ }, 4, function ()
         awful.client.focus.byidx(1)
   end),
   awful.button({ }, 5, function ()
         awful.client.focus.byidx(-1)
end))

local function set_wallpaper(s)
   -- Wallpaper
   if beautiful.wallpaper then
      local wallpaper = beautiful.wallpaper
      -- If wallpaper is a function, call it with the screen
      if type(wallpaper) == "function" then
         wallpaper = wallpaper(s)
      end
      gears.wallpaper.maximized(wallpaper, s, true)
   end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
      -- Wallpaper
      set_wallpaper(s)

      -- Each screen has its own tag table.
      awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

      -- Create a promptbox for each screen
      s.mypromptbox = awful.widget.prompt()
      -- Create an imagebox widget which will contains an icon indicating which layout we're using.
      -- We need one layoutbox per screen.
      s.mylayoutbox = awful.widget.layoutbox(s)
      s.mylayoutbox:buttons(awful.util.table.join(
                               awful.button({ }, 1, function () awful.layout.inc( 1) end),
                               awful.button({ }, 3, function () awful.layout.inc(-1) end),
                               awful.button({ }, 4, function () awful.layout.inc( 1) end),
                               awful.button({ }, 5, function () awful.layout.inc(-1) end)))
      -- Create a taglist widget
      s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

      -- Create a tasklist widget
      s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

      -- Create the wibox
      s.mywibox = awful.wibar({ position = "top", screen = s })

      -- Add widgets to the wibox
      -- s.mywibox:setup {
      --    layout = wibox.layout.align.horizontal,
      --    { -- Left widgets
      --       layout = wibox.layout.fixed.horizontal,
      --       -- mylauncher,
      --       s.mytaglist,
      --       spr,
      --       s.mypromptbox,
      --       spr,
      --    },
      --    s.mytasklist, -- Middle widget
      --    { -- Right widgets
      --       layout = wibox.layout.fixed.horizontal,
      --       wibox.widget.systray(),
      --       spr,
      --       arrl_dl,
      --       mykeyboardlayout,
      --       arrl_dl,
      --       baticon,
      --       batterywidget,
      --       arrl_dl,
      --       cpuicon,
      --       cpuwidget,
      --       tempwidget,
      --       arrl_dl,
      --       memicon,
      --       memwidget,
      --       arrl_dl,
      --       volumewidget,
      --       arrl_dl,
      --       mytextclock,
      --       arrl_dl,
      --       s.mylayoutbox,
      --    },
      -- }


      -- {{{ PORTED
      -- Widgets that are aligned to the left
      local left_layout = wibox.layout.fixed.horizontal()
      -- left_layout:add(mylauncher)
      left_layout:add(s.mytaglist)
      left_layout:add(spr)
      left_layout:add(s.mypromptbox)
      left_layout:add(spr)

      -- Widgets that are aligned to the right
      local right_layout = wibox.layout.fixed.horizontal()

      local right_layout_toggle = true
      local function right_layout_add (...)
         local arg = {...}
         if right_layout_toggle then
            right_layout:add(arrl_ld)
            for i, n in pairs(arg) do
               right_layout:add(wibox.container.background(n, beautiful.arrow_color))
            end
         else
            right_layout:add(arrl_dl)
            for i, n in pairs(arg) do
               right_layout:add(n)
            end
         end
         right_layout_toggle = not right_layout_toggle
      end
      right_layout:add(wibox.widget.systray())
      right_layout:add(spr)
      right_layout:add(mykeyboardlayout)
      right_layout_add(baticon, batterywidget)
      right_layout_add(cpuicon, cpuwidget, tempwidget)
      right_layout_add(memicon, memwidget)
      right_layout_add(musicwidget.widget, volumewidget)
      right_layout_add(mytextclock)    
      right_layout_add(s.mylayoutbox)
      
      -- Now bring it all together (with the tasklist in the middle)
      local layout = wibox.layout.align.horizontal()
      layout:set_left(left_layout)
      layout:set_middle(s.mytasklist)
      layout:set_right(right_layout)

      s.mywibox:set_widget(layout)

      --- }}} END OF PORTED
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
                awful.button({ }, 4, awful.tag.viewnext),
                awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
   awful.key({           }, "XF86AudioRaiseVolume", function () vol("up") end,
      {description="volume +", group="awesome"}),
   awful.key({           }, "XF86AudioLowerVolume", function () vol("down") end,
      {description="volume -", group="awesome"}),
   awful.key({           }, "XF86AudioMute", function () vol("toggle") end,
      {description="volume mute", group="awesome"}),
   awful.key({           }, "XF86MonBrightnessUp", function () brightness("up") end,
      {description="brightness +", group="awesome"}),
   awful.key({           }, "XF86MonBrightnessDown", function () brightness("down") end,
      {description="brightness -", group="awesome"}),
   awful.key({           }, "XF86TouchpadToggle", function () awful.spawn("bash -c \"synclient TouchpadOff=\\$(synclient -l | grep -c 'TouchpadOff.*=.*0')\"", false) end,
      {description="toggle touchpad", group="awesome"}),
   awful.key({           }, "XF86AudioStop", function () music("stop") end,
      {description="music stop", group="awesome"}),
   awful.key({           }, "XF86AudioPlay", function () music("toggle") end,
      {description="music play", group="awesome"}),
   awful.key({           }, "XF86AudioNext", function () music("next") end,
      {description="music next", group="awesome"}),
   awful.key({           }, "XF86AudioPrev", function () music("prev") end,
      {description="music prev", group="awesome"}),
   awful.key({           }, "Print", function() awful.spawn("scrot '/home/postskript/Pictures/screenshots/%Y-%m-%d-%H-%M-%S.png'") end ,
      {description="screenshot", group="awesome"}),
   awful.key({ "Shift"   }, "Print", function() awful.spawn("scrot -u '/home/postskript/Pictures/screenshots/%Y-%m-%d-%H-%M-%S.png'") end ,
      {description="screenshot current window", group="awesome"}),
   awful.key({ modkey,   }, "Print", function() awful.spawn("scrot -s '/home/postskript/Pictures/screenshots/%Y-%m-%d-%H-%M-%S.png'") end ,
      {description="screenshot like snipping tool", group="awesome"}),
   awful.key({ modkey,   }, "o", orglendar.toggle,
      {description="orglendar", group="awesome"}),
   awful.key({ modkey,           }, "a",   awful.tag.viewprev,
      {description = "view previous", group = "tag"}),
   awful.key({ modkey,           }, "d",  awful.tag.viewnext,
      {description = "view next", group = "tag"}),
   awful.key({ modkey, "Shift"   }, "f",  function () awful.spawn(file_manager_cmd) end,
      {description = "open file manager", group = "launcher"}),
   awful.key({ modkey,           }, "e",  function () awful.spawn("emacsclient -c") end,
      {description = "open emacsclient", group = "launcher"}),
   
   awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
      {description="show help", group="awesome"}),
   awful.key({ modkey,}, "Escape", awful.tag.history.restore,
      {description = "go back", group = "tag"}),

   awful.key({ modkey,           }, "j",
      function ()
         awful.client.focus.byidx( 1)
      end,
      {description = "focus next by index", group = "client"}
   ),
   awful.key({ modkey,           }, "k",
      function ()
         awful.client.focus.byidx(-1)
      end,
      {description = "focus previous by index", group = "client"}
   ),

   -- Layout manipulation
   awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
      {description = "swap with next client by index", group = "client"}),
   awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
      {description = "swap with previous client by index", group = "client"}),
   awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
      {description = "focus the next screen", group = "screen"}),
   awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
      {description = "focus the previous screen", group = "screen"}),
   awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
      {description = "jump to urgent client", group = "client"}),
   awful.key({ modkey,           }, "Tab",
      function ()
         awful.client.focus.history.previous()
         if client.focus then
            client.focus:raise()
         end
      end,
      {description = "go back", group = "client"}),

   -- Standard program
   awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
      {description = "open a terminal", group = "launcher"}),
   awful.key({ modkey, "Control" }, "r", awesome.restart,
      {description = "reload awesome", group = "awesome"}),
   awful.key({ modkey, "Shift"   }, "q", awesome.quit,
      {description = "quit awesome", group = "awesome"}),

   awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
      {description = "increase master width factor", group = "layout"}),
   awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
      {description = "decrease master width factor", group = "layout"}),
   awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
      {description = "increase the number of master clients", group = "layout"}),
   awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
      {description = "decrease the number of master clients", group = "layout"}),
   awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
      {description = "increase the number of columns", group = "layout"}),
   awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
      {description = "decrease the number of columns", group = "layout"}),
   awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
      {description = "select next", group = "layout"}),
   awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
      {description = "select previous", group = "layout"}),

   awful.key({ modkey, "Control" }, "n",
      function ()
         local c = awful.client.restore()
         -- Focus restored client
         if c then
            client.focus = c
            c:raise()
         end
      end,
      {description = "restore minimized", group = "client"}),

   -- Prompt
   awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
      {description = "run prompt", group = "launcher"}),

   awful.key({ modkey }, "x",
      function ()
         awful.prompt.run {
            prompt       = "Run Lua code: ",
            textbox      = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval"
         }
      end,
      {description = "lua execute prompt", group = "awesome"}),

   awful.key({ modkey }, "c",
      function ()
         awful.prompt.run {
            prompt       = "Calculate: ",
            textbox      = awful.screen.focused().mypromptbox.widget,
            exe_callback = function (text)
               awful.spawn.easy_async(
                  "python -c \"from math import * ; print(" .. text .. ")\"",
                  function(stdout, stderr, exitreason, exitcode)
                     naughty.notify({
                           text = 'Result: ' .. stdout:sub(1, -2),
                           position = "top_left",
                           timeout = 5
                     })
               end)
            end
         }
      end,
      {description = "inline calculator", group = "awesome"}),
   
   -- Menubar
   awful.key({ modkey }, "p", function() menubar.show() end,
      {description = "show the menubar", group = "launcher"})
)

clientkeys = awful.util.table.join(
   awful.key({ modkey,           }, "f",
      function (c)
         c.fullscreen = not c.fullscreen
         c:raise()
      end,
      {description = "toggle fullscreen", group = "client"}),
   awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
      {description = "close", group = "client"}),
   awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
      {description = "toggle floating", group = "client"}),
   awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
      {description = "move to master", group = "client"}),
   awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
      {description = "move to screen", group = "client"}),
   awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
      {description = "toggle keep on top", group = "client"}),
   awful.key({ modkey,           }, "n",
      function (c)
         -- The client currently has the input focus, so it cannot be
         -- minimized, since minimized clients can't have the focus.
         c.minimized = true
      end ,
      {description = "minimize", group = "client"}),
   awful.key({ modkey,           }, "m",
      function (c)
         c.maximized = not c.maximized
         c:raise()
      end ,
      {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
   globalkeys = awful.util.table.join(globalkeys,
                                      -- View tag only.
                                      awful.key({ modkey }, "#" .. i + 9,
                                         function ()
                                            local screen = awful.screen.focused()
                                            local tag = screen.tags[i]
                                            if tag then
                                               tag:view_only()
                                            end
                                         end,
                                         {description = "view tag #"..i, group = "tag"}),
                                      -- Toggle tag display.
                                      awful.key({ modkey, "Control" }, "#" .. i + 9,
                                         function ()
                                            local screen = awful.screen.focused()
                                            local tag = screen.tags[i]
                                            if tag then
                                               awful.tag.viewtoggle(tag)
                                            end
                                         end,
                                         {description = "toggle tag #" .. i, group = "tag"}),
                                      -- Move client to tag.
                                      awful.key({ modkey, "Shift" }, "#" .. i + 9,
                                         function ()
                                            if client.focus then
                                               local tag = client.focus.screen.tags[i]
                                               if tag then
                                                  client.focus:move_to_tag(tag)
                                               end
                                            end
                                         end,
                                         {description = "move focused client to tag #"..i, group = "tag"}),
                                      -- Toggle tag on focused client.
                                      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                                         function ()
                                            if client.focus then
                                               local tag = client.focus.screen.tags[i]
                                               if tag then
                                                  client.focus:toggle_tag(tag)
                                               end
                                            end
                                         end,
                                         {description = "toggle focused client on tag #" .. i, group = "tag"})
   )
end

clientbuttons = awful.util.table.join(
   awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
   awful.button({ modkey }, 1, awful.mouse.client.move),
   awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
   -- All clients will match this rule.
   { rule = { },
     properties = { border_width = beautiful.border_width,
                    border_color = beautiful.border_normal,
                    focus = awful.client.focus.filter,
                    raise = true,
                    keys = clientkeys,
                    buttons = clientbuttons,
                    screen = awful.screen.preferred,
                    placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
   },

   -- Floating clients.
   { rule_any = {
        instance = {
           "DTA",  -- Firefox addon DownThemAll.
           "copyq",  -- Includes session name in class.
        },
        class = {
           "Arandr",
           "Gpick",
           "Kruler",
           "MessageWin",  -- kalarm.
           "Sxiv",
           "Wpa_gui",
           "pinentry",
           "veromix",
           "xtightvncviewer"},

        name = {
           "Event Tester",  -- xev.
        },
        role = {
           "AlarmWindow",  -- Thunderbird's calendar.
           "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
   }, properties = { floating = true }},

   -- Add titlebars to normal clients and dialogs
   { rule_any = {type = { "dialog" }
                }, properties = { titlebars_enabled = true }
   },
   
   { rule = { class = "Emacs" },
     properties = { size_hints_honor = false } },

   -- Set Firefox to always map on the tag named "2" on screen 1.
   -- { rule = { class = "Firefox" },
   --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
                         -- Set the windows at the slave,
                         -- i.e. put it at the end of others instead of setting it master.
                         -- if not awesome.startup then awful.client.setslave(c) end

                         if awesome.startup and
                            not c.size_hints.user_position
                         and not c.size_hints.program_position then
                            -- Prevent clients from being unreachable after screen count changes.
                            awful.placement.no_offscreen(c)
                         end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
                         -- buttons for the titlebar
                         local buttons = awful.util.table.join(
                            awful.button({ }, 1, function()
                                  client.focus = c
                                  c:raise()
                                  awful.mouse.client.move(c)
                            end),
                            awful.button({ }, 3, function()
                                  client.focus = c
                                  c:raise()
                                  awful.mouse.client.resize(c)
                            end)
                         )

                         awful.titlebar(c) : setup {
                            { -- Left
                               awful.titlebar.widget.iconwidget(c),
                               buttons = buttons,
                               layout  = wibox.layout.fixed.horizontal
                            },
                            { -- Middle
                               { -- Title
                                  align  = "center",
                                  widget = awful.titlebar.widget.titlewidget(c)
                               },
                               buttons = buttons,
                               layout  = wibox.layout.flex.horizontal
                            },
                            { -- Right
                               awful.titlebar.widget.floatingbutton (c),
                               awful.titlebar.widget.maximizedbutton(c),
                               awful.titlebar.widget.stickybutton   (c),
                               awful.titlebar.widget.ontopbutton    (c),
                               awful.titlebar.widget.closebutton    (c),
                               layout = wibox.layout.fixed.horizontal()
                            },
                            layout = wibox.layout.align.horizontal
                                                   }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
                         if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                         and awful.client.focus.filter(c) then
                            client.focus = c
                         end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
