-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local lain = require("lain")
local vicious = require("vicious")


-- require("volume")

-- require("blingbling")

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
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/usr/share/awesome/themes/myzen/theme.lua")
--beautiful.init("/home/postskript/.config/awesome/themes/powerline-darker/theme.lua")
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
local layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.floating,
    awful.layout.suit.magnifier,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.max
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
   for s = 1, screen.count() do
	gears.wallpaper.maximized("/home/postskript/Pictures/wallpapers/1358379858681.jpg", s, false)
        -- gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
-- myawesomemenu = {
--    { "manual", terminal .. " -e man awesome" },
--    { "edit config", editor_cmd .. " " .. awesome.conffile },
--    { "restart", awesome.restart },
--    { "quit", awesome.quit }
-- }

-- mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
--                                     { "open terminal", terminal }
--                                   }
--                         })

-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                      menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and changer
-- kbdcfg = {}
-- kbdcfg.cmd = "setxkbmap"
-- kbdcfg.layout = { { "us", "" , "us" }, { "ru", "" , "ru" } } 
-- kbdcfg.current = 1  -- us is our default layout
-- kbdcfg.widget = wibox.widget.textbox()
-- kbdcfg.widget:set_text(" " .. kbdcfg.layout[kbdcfg.current][3] .. " ")
-- kbdcfg.switch = function ()
--   kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
--   local t = kbdcfg.layout[kbdcfg.current]
--   kbdcfg.widget:set_text(" " .. t[3] .. " ")
--   os.execute( kbdcfg.cmd .. " " .. t[1] .. " " .. t[2] )
-- end

 -- Mouse bindings
-- kbdcfg.widget:buttons(
--  awful.util.table.join(awful.button({ }, 1, function () kbdcfg.switch() end))
-- )

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
   awful.util.spawn("mpc " .. action , false)
   musicwidget:update_track()
end
-- }}}

memicon = wibox.widget.imagebox(beautiful.widget_mem)
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, "$2MB $1% ", 5)

cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
cpuwidget = wibox.widget.textbox()    
vicious.register(cpuwidget, vicious.widgets.cpu, "$1%", 2)

tempwidget = wibox.widget.textbox()
vicious.register(tempwidget, vicious.widgets.thermal, " $1°C ", 5, "thermal_zone0")

function brightness(state)
   if     state == "up" then
      awful.util.spawn("light -A 2", false)
   elseif state == "down" then
      awful.util.spawn("light -U 2", false)
   end
end

baticon = wibox.widget.imagebox(beautiful.widget_battery)
batterywidget = wibox.widget.textbox()
batterywidget:buttons(awful.util.table.join(
			 awful.button({ }, 4, function () brightness("up") end),
			 awful.button({ }, 5, function () brightness("down") end)
))
-- vicious.register(batterywidget, vicious.widgets.bat, " | bat $1$2%", 5, "BAT0")
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
      awful.util.spawn("amixer set Master 1%+", false)
   elseif state == "down" then
      awful.util.spawn("amixer set Master 1%-", false)
   elseif state == "toggle" then
      awful.util.spawn("amixer set Master toggle", false)
   end
   vicious.force({volumewidget,})
end

volumewidget:buttons(awful.util.table.join(
			awful.button({ }, 4, function () vol("up") end),
			awful.button({ }, 5, function () vol("down") end),
			awful.button({ }, 1, function () vol("toggle") end)
))
vicious.register(volumewidget, vicious.widgets.volume, " $2 $1 ",1, "Master")



-- Separators
spr = wibox.widget.textbox(' ')
separators = lain.util.separators
arrl_dl = separators.arrow_left(beautiful.arrow_color, "alpha")
arrl_ld = separators.arrow_left("alpha", beautiful.arrow_color)



-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    -- left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(spr)
    left_layout:add(mypromptbox[s])
    left_layout:add(spr)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()

    local right_layout_toggle = true
    local function right_layout_add (...)
        local arg = {...}
        if right_layout_toggle then
            right_layout:add(arrl_ld)
            for i, n in pairs(arg) do
                right_layout:add(wibox.widget.background(n, beautiful.arrow_color))
            end
        else
            right_layout:add(arrl_dl)
            for i, n in pairs(arg) do
                right_layout:add(n)
            end
        end
        right_layout_toggle = not right_layout_toggle
    end

    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(spr)
    right_layout_add(baticon, batterywidget)
    right_layout_add(cpuicon, cpuwidget, tempwidget)
    right_layout_add(memicon, memwidget)
    right_layout_add(musicwidget.widget, volumewidget)
    right_layout_add(mytextclock)    
    right_layout_add(mylayoutbox[s])
    
    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    -- awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(

   awful.key({       }, "XF86AudioRaiseVolume", function () vol("up") end),
   awful.key({       }, "XF86AudioLowerVolume", function () vol("down") end ),
   awful.key({       }, "XF86AudioMute", function () vol("toggle") end),
   awful.key({       }, "XF86MonBrightnessUp", function () brightness("up") end),
   awful.key({       }, "XF86MonBrightnessDown", function () brightness("down") end),
   awful.key({       }, "XF86TouchpadToggle", function () awful.util.spawn("bash -c \"synclient TouchpadOff=\\$(synclient -l | grep -c 'TouchpadOff.*=.*0')\"", false) end),
   awful.key({       }, "XF86AudioStop", function () music("stop") end),
   awful.key({       }, "XF86AudioPlay", function () music("toggle") end),
   awful.key({       }, "XF86AudioNext", function () music("next") end),
   awful.key({       }, "XF86AudioPrev", function () music("prev") end),
   awful.key({       }, "Print", function() awful.util.spawn("scrot '/home/postskript/Pictures/screenshots/%Y-%m-%d-%H-%M-%S.png'") end ),
   awful.key({"Shift"}, "Print", function() awful.util.spawn("scrot -u '/home/postskript/Pictures/screenshots/%Y-%m-%d-%H-%M-%S.png'") end ),
   
   -- awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
   -- awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
   awful.key({ modkey,           }, "a",      awful.tag.viewprev       ),
   awful.key({ modkey,           }, "d",      awful.tag.viewnext       ),
   awful.key({ modkey, "Shift"   }, "f", function () awful.util.spawn(file_manager_cmd) end),
   awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
   awful.key({ modkey,           }, "e", function () awful.util.spawn("emacsclient -c") end),
   
   awful.key({ modkey,           }, "j",
      function ()
	 awful.client.focus.byidx( 1)
	 if client.focus then client.focus:raise() end
   end),
   awful.key({ modkey,           }, "k",
      function ()
	 awful.client.focus.byidx(-1)
	 if client.focus then client.focus:raise() end
   end),
   -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

   -- Layout manipulation
   awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
   awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
   awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
   awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
   awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
   awful.key({ modkey,           }, "Tab",
      function ()
	 awful.client.focus.history.previous()
	 if client.focus then
	    client.focus:raise()
	 end
   end),

   -- Standard program
   awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
   awful.key({ modkey, "Control" }, "r", awesome.restart),
   awful.key({ modkey, "Shift"   }, "q", awesome.quit),

   awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
   awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
   awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
   awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
   awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
   awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
   awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
   awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

   awful.key({ modkey, "Control" }, "n", awful.client.restore),

   -- Prompt
   awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

   awful.key({ modkey }, "x",
      function ()
	 awful.prompt.run({ prompt = "Run Lua code: " },
	    mypromptbox[mouse.screen].widget,
	    awful.util.eval, nil,
	    awful.util.getdir("cache") .. "/history_eval")
   end),
   
   awful.key({ modkey }, "c",
      function ()
	 awful.prompt.run({ prompt = "Calculate: " },
	    mypromptbox[mouse.screen].widget,
	    function (text)
	       naughty.notify({
		     text = 'Result: ' .. awful.util.pread("python -c \"from math import * ; print(" .. text .. ",end='')\""),
		     position = "top_left",
		     timeout = 5
	       })
	 end)
   end),
   -- Menubar
   awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
   awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
   awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
   awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
   awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
   awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
   awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
   awful.key({ modkey,           }, "n",
      function (c)
	 -- The client currently has the input focus, so it cannot be
	 -- minimized, since minimized clients can't have the focus.
	 c.minimized = true
   end),
   awful.key({ modkey,           }, "m",
      function (c)
	 c.maximized_horizontal = not c.maximized_horizontal
	 c.maximized_vertical   = not c.maximized_vertical
   end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
   globalkeys = awful.util.table.join(globalkeys,
				      -- View tag only.
				      awful.key({ modkey }, "#" .. i + 9,
					 function ()
					    local screen = mouse.screen
					    local tag = awful.tag.gettags(screen)[i]
					    if tag then
					       awful.tag.viewonly(tag)
					    end
				      end),
				      -- Toggle tag.
				      awful.key({ modkey, "Control" }, "#" .. i + 9,
					 function ()
					    local screen = mouse.screen
					    local tag = awful.tag.gettags(screen)[i]
					    if tag then
					       awful.tag.viewtoggle(tag)
					    end
				      end),
				      -- Move client to tag.
				      awful.key({ modkey, "Shift" }, "#" .. i + 9,
					 function ()
					    if client.focus then
					       local tag = awful.tag.gettags(client.focus.screen)[i]
					       if tag then
						  awful.client.movetotag(tag)
					       end
					    end
				      end),
				      -- Toggle tag.
				      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
					 function ()
					    if client.focus then
					       local tag = awful.tag.gettags(client.focus.screen)[i]
					       if tag then
						  awful.client.toggletag(tag)
					       end
					    end
   end))
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
		    buttons = clientbuttons } },
   { rule = { class = "MPlayer" },
     properties = { floating = true } },
   { rule = { class = "pinentry" },
     properties = { floating = true } },
   { rule = { class = "gimp" },
     properties = { floating = true } },
   -- Set Firefox to always map on tags number 2 of screen 1.
   -- { rule = { class = "Firefox" },
   --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
			 -- Enable sloppy focus
			 c:connect_signal("mouse::enter", function(c)
					     if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
					     and awful.client.focus.filter(c) then
						client.focus = c
					     end
			 end)

			 if not startup then
			    -- Set the windows at the slave,
			    -- i.e. put it at the end of others instead of setting it master.
			    -- awful.client.setslave(c)

			    -- Put windows in a smart way, only if they does not set an initial position.
			    if not c.size_hints.user_position and not c.size_hints.program_position then
			       awful.placement.no_overlap(c)
			       awful.placement.no_offscreen(c)
			    end
			 end

			 local titlebars_enabled = false
			 if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
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

			    -- Widgets that are aligned to the left
			    local left_layout = wibox.layout.fixed.horizontal()
			    left_layout:add(awful.titlebar.widget.iconwidget(c))
			    left_layout:buttons(buttons)

			    -- Widgets that are aligned to the right
			    local right_layout = wibox.layout.fixed.horizontal()
			    right_layout:add(awful.titlebar.widget.floatingbutton(c))
			    right_layout:add(awful.titlebar.widget.maximizedbutton(c))
			    right_layout:add(awful.titlebar.widget.stickybutton(c))
			    right_layout:add(awful.titlebar.widget.ontopbutton(c))
			    right_layout:add(awful.titlebar.widget.closebutton(c))

			    -- The title goes in the middle
			    local middle_layout = wibox.layout.flex.horizontal()
			    local title = awful.titlebar.widget.titlewidget(c)
			    title:set_align("center")
			    middle_layout:add(title)
			    middle_layout:buttons(buttons)

			    -- Now bring it all together
			    local layout = wibox.layout.align.horizontal()
			    layout:set_left(left_layout)
			    layout:set_right(right_layout)
			    layout:set_middle(middle_layout)

			    awful.titlebar(c):set_widget(layout)
			 end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

