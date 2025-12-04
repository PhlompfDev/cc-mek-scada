local core = require("graphics.core")

local Div        = require("graphics.elements.Div")
local MultiPane  = require("graphics.elements.MultiPane")
local Tiling     = require("graphics.elements.Tiling")
local TextBox    = require("graphics.elements.TextBox")
local App        = require("graphics.elements.controls.App")
local Hazard     = require("graphics.elements.controls.HazardButton")
local PushButton = require("graphics.elements.controls.PushButton")
local Switch     = require("graphics.elements.controls.SwitchButton")
local Checkbox   = require("graphics.elements.controls.Checkbox")
local Radio      = require("graphics.elements.controls.RadioButton")
local TabBar     = require("graphics.elements.controls.TabBar")

local ALIGN = core.ALIGN

---@param parent graphics_element
---@param style table
---@param shared table
---@return MultiPane
local function _build_content(parent, style, shared)
    local w, h = parent.window().getSize()

    local desc = TextBox{parent=parent,x=1,y=1,width=w,height=1,alignment=ALIGN.CENTER,text="UI toolkit feature tour"}
    desc.recolor(style.label.fgd)

    local status = TextBox{parent=parent,x=1,y=h,width=w,text="Ready",alignment=ALIGN.LEFT}
    shared.register_message(status)

    local panes = {}

    -- Buttons and callbacks
    do
        local page = Div{parent=parent,x=1,y=3,width=w,height=h-3,hidden=true}
        TextBox{parent=page,x=1,y=1,width=w,text="Buttons with callbacks and active states",alignment=ALIGN.LEFT}

        local ok_btn = PushButton{
            parent=page,x=2,y=3,text="Confirm",fg_bg=style.button,active_fg_bg=style.button_active,
            callback=function()
                shared.signal_action("ok_button", true, ok_btn)
                shared.push_message("Confirm tapped")
            end
        }
        shared.register_action("ok_button", ok_btn, function(target)
            if target.preview_press then target.preview_press() end
        end)

        local cancel_btn = PushButton{
            parent=page,x=15,y=3,text="Cancel",fg_bg=style.button,active_fg_bg=style.button_active,
            callback=function()
                shared.signal_action("cancel_button", true, cancel_btn)
                shared.push_message("Cancel tapped")
            end
        }
        shared.register_action("cancel_button", cancel_btn, function(target)
            if target.preview_press then target.preview_press() end
        end)

        local hazard = Hazard{
            parent=page,x=2,y=6,width=14,text="Hazard",fg_bg=style.hazard,
            accent=style.hazard_accent,dis_fg_bg=style.hazard_dim,
            callback=function() shared.push_message("Hazard acknowledged") end
        }

        App{
            parent=page,x=w-8,y=3,text="★",title="App",app_fg_bg=style.button,
            active_fg_bg=style.button_active,callback=function() shared.push_message("App icon opened") end
        }

        TextBox{parent=page,x=1,y=h-5,width=w,text="Use keyboard Tab to move focus between controls.",alignment=ALIGN.LEFT}

        table.insert(panes, page)
    end

    -- Toggles and checkboxes
    do
        local page = Div{parent=parent,x=1,y=3,width=w,height=h-3,hidden=true}
        TextBox{parent=page,x=1,y=1,width=w,text="Toggle controls synchronize across displays",alignment=ALIGN.LEFT}

        local reactor_toggle
        reactor_toggle = Switch{
            parent=page,x=2,y=3,text="Reactor",fg_bg=style.switch_off,active_fg_bg=style.switch_on,
            callback=function(val) shared.set_toggle("reactor", val, reactor_toggle) end
        }
        shared.register_toggle("reactor", reactor_toggle)

        local alerts_toggle
        alerts_toggle = Switch{
            parent=page,x=2,y=5,text="Audible Alerts",fg_bg=style.switch_off,active_fg_bg=style.switch_on,
            callback=function(val) shared.set_toggle("alerts", val, alerts_toggle) end
        }
        shared.register_toggle("alerts", alerts_toggle)

        local maintenance
        maintenance = Checkbox{
            parent=page,x=2,y=7,text="Maintenance Mode",fg_bg=style.switch_off,active_fg_bg=style.switch_on,
            callback=function(val) shared.set_toggle("maintenance", val, maintenance) end
        }
        shared.register_toggle("maintenance", maintenance)

        local modes
        modes = Radio{
            parent=page,x=w-12,y=3,width=10,options={"Auto","Manual","Off"},
            callback=function(idx) shared.set_value("control_mode", idx, modes) end
        }
        shared.register_value("control_mode", modes)

        table.insert(panes, page)
    end

    -- Layout and navigation demo
    do
        local page = Div{parent=parent,x=1,y=3,width=w,height=h-3,hidden=true}
        TextBox{parent=page,x=1,y=1,width=w,text="Nested layouts, tiles, and nav dots",alignment=ALIGN.LEFT}

        local inner_panes = {}
        local tile_w = math.max(6, w - 3)
        local tile_h = math.max(5, h - 8)
        for i = 1, 3 do
            local tile = Div{parent=page,x=2,y=3,width=w-2,height=h-7,hidden=true}
            local tile_color = (i % 2 == 0) and style.panel or style.button
            Tiling{parent=tile,x=1,y=1,width=tile_w,height=tile_h,fill_c=tile_color,border_c=colors.gray}
            TextBox{parent=tile,x=3,y=3,width=math.max(6, w-6),text=("Layout %d with themed tiling"):format(i),alignment=ALIGN.LEFT}
            table.insert(inner_panes, tile)
        end

        local inner_nav = MultiPane{parent=page,x=2,y=3,width=w-2,height=h-7,panes=inner_panes}
        shared.register_value("layouts_inner", inner_nav)

        local dot_nav = require("graphics.elements.AppMultiPane"){
            parent=page,x=2,y=h-3,width=w-2,height=3,panes=inner_panes,
            nav_colors=style.nav,scroll_nav=true,callback=function(idx)
                shared.set_value("layouts_inner", idx, dot_nav)
                shared.push_message(("Switched to layout %d"):format(idx))
            end
        }
        shared.register_value("layouts_inner", dot_nav)

        shared.set_value("layouts_inner", 1)

        table.insert(panes, page)
    end

    local content = MultiPane{parent=parent,x=1,y=3,width=w,height=h-3,panes=panes}
    shared.register_value("main_tabs", content)

    local tabs = {
        { name = "Buttons", color = style.header },
        { name = "Toggles", color = style.header },
        { name = "Layouts", color = style.header }
    }

    local tabbar = TabBar{parent=parent,x=1,y=2,width=w,tabs=tabs,callback=function(idx)
        shared.set_value("main_tabs", idx, tabbar)
    end}
    shared.register_value("main_tabs", tabbar)

    shared.set_value("main_tabs", 1)

    return content
end

---@param display graphics_element
---@param style table
---@param shared table
return function (display, style, shared)
    _build_content(display, style, shared)
end
