------------------------------------
--      "Myzen" awesome theme     --
--    By Alexander P. (alex-pat)  --
------------------------------------

-- Alternative icon sets and widget icons:
--  * http://awesome.naquadah.org/wiki/Nice_Icons

green = "#7fb219"
cyan  = "#7f4de6"
red   = "#e04613"
lblue = "#6c9eab"
dblue = "#00ccff"
black = "#3f3f3f"
lgrey = "#d2d2d2"
dgrey = "#333333"
white = "#ffffff"

-- {{{ Main
theme = {}
theme.wallpaper = "/usr/share/awesome/themes/myzen/myzen-background.png"
-- }}}

-- {{{ Styles
theme.font      = "Terminus 8"

-- {{{ Colors
theme.fg_normal  = "#DDDDFF"
theme.fg_focus   = "#F0DFAF"
theme.fg_urgent  = "#CC9393"
theme.bg_normal  = "#1A1A1A"
theme.bg_focus   = theme.bg_normal
theme.bg_urgent  = "#1A1A1A"
theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
theme.border_width  = 1
theme.border_normal = "#3F3F3F"
theme.border_focus  = "#7F7F7F"
theme.border_marked = "#CC9393"
-- }}}


-- {{{

theme.arrow_color                           = "#555555"
theme.taglist_fg_focus                      = theme.fg_focus
theme.tasklist_bg_focus                     = theme.bg_normal 
theme.tasklist_fg_focus                     = theme.fg_focus
theme.textbox_widget_as_label_font_color    = white 
theme.textbox_widget_margin_top             = 1
theme.text_font_color_1                     = green
theme.text_font_color_2                     = dblue
theme.text_font_color_3                     = white
theme.notify_font_color_1                   = green
theme.notify_font_color_2                   = dblue
theme.notify_font_color_3                   = black
theme.notify_font_color_4                   = white
theme.notify_font                           = "sans 7"
theme.notify_fg                             = theme.fg_normal
theme.notify_bg                             = theme.bg_normal
theme.notify_border                         = theme.border_focus
theme.awful_widget_bckgrd_color             = dgrey
theme.awful_widget_border_color             = dgrey
theme.awful_widget_color                    = dblue
theme.awful_widget_gradien_color_1          = orange
theme.awful_widget_gradien_color_2          = orange
theme.awful_widget_gradien_color_3          = orange
theme.awful_widget_height                   = 14
theme.awful_widget_margin_top               = 2

-- }}}
-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = 16
theme.menu_width  = 140
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = "/usr/share/awesome/themes/myzen/taglist/squarefz.png"
theme.taglist_squares_unsel = "/usr/share/awesome/themes/myzen/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = "/usr/share/awesome/themes/myzen/awesome-icon.png"
theme.menu_submenu_icon      = "/usr/share/awesome/themes/icons/submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = "/usr/share/awesome/themes/myzen/layouts/tile.png"
theme.layout_tileleft   = "/usr/share/awesome/themes/myzen/layouts/tileleft.png"
theme.layout_tilebottom = "/usr/share/awesome/themes/myzen/layouts/tilebottom.png"
theme.layout_tiletop    = "/usr/share/awesome/themes/myzen/layouts/tiletop.png"
theme.layout_fairv      = "/usr/share/awesome/themes/myzen/layouts/fairv.png"
theme.layout_fairh      = "/usr/share/awesome/themes/myzen/layouts/fairh.png"
theme.layout_spiral     = "/usr/share/awesome/themes/myzen/layouts/spiral.png"
theme.layout_dwindle    = "/usr/share/awesome/themes/myzen/layouts/dwindle.png"
theme.layout_max        = "/usr/share/awesome/themes/myzen/layouts/max.png"
theme.layout_fullscreen = "/usr/share/awesome/themes/myzen/layouts/fullscreen.png"
theme.layout_magnifier  = "/usr/share/awesome/themes/myzen/layouts/magnifier.png"
theme.layout_floating   = "/usr/share/awesome/themes/myzen/layouts/floating.png"
theme.layout_cornerne   = "/usr/share/awesome/themes/myzen/layouts/cornerne.png"
theme.layout_cornernw   = "/usr/share/awesome/themes/myzen/layouts/cornernw.png"
theme.layout_cornerse   = "/usr/share/awesome/themes/myzen/layouts/cornerse.png"
theme.layout_cornersw   = "/usr/share/awesome/themes/myzen/layouts/cornersw.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = "/usr/share/awesome/themes/myzen/titlebar/close_focus.png"
theme.titlebar_close_button_normal = "/usr/share/awesome/themes/myzen/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = "/usr/share/awesome/themes/myzen/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = "/usr/share/awesome/themes/myzen/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = "/usr/share/awesome/themes/myzen/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = "/usr/share/awesome/themes/myzen/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = "/usr/share/awesome/themes/myzen/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = "/usr/share/awesome/themes/myzen/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = "/usr/share/awesome/themes/myzen/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = "/usr/share/awesome/themes/myzen/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = "/usr/share/awesome/themes/myzen/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = "/usr/share/awesome/themes/myzen/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = "/usr/share/awesome/themes/myzen/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = "/usr/share/awesome/themes/myzen/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = "/usr/share/awesome/themes/myzen/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = "/usr/share/awesome/themes/myzen/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = "/usr/share/awesome/themes/myzen/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/myzen/titlebar/maximized_normal_inactive.png"
-- }}}
theme.widget_mem = "/usr/share/awesome/themes/myzen/icons/mem.png"
theme.widget_cpu = "/usr/share/awesome/themes/myzen/icons/cpu.png"
theme.widget_battery = "/usr/share/awesome/themes/myzen/icons/battery_empty.png"
   
return theme
