local core   = require("graphics.core")
local style  = require("demo.ui.style")
local shared = require("demo.ui.state")
local layout = require("demo.ui.layouts")

local DisplayBox = require("graphics.elements.DisplayBox")

local events = core.events

---@param monitor Monitor|nil
---@return graphics_element
local function build_display(target)
    style.apply_to_display(target)
    local display = DisplayBox{window=target,fg_bg=style.root}
    layout(display, style, shared)
    return display
end

local terminal_display = build_display(term.current())

local monitor = peripheral.find("monitor")
local monitor_display = nil
if monitor then
    monitor.setTextScale(0.5)
    monitor_display = build_display(monitor)
end

local running = true

local function handle_mouse(event, display)
    if display and event then display.handle_mouse(event) end
end

local function handle_key(event, display)
    if display and event then display.handle_key(event) end
end

while running do
    local event, p1, p2, p3, p4 = os.pullEvent()

    if event == "terminate" then
        running = false
    elseif event == "mouse_click" or event == "mouse_up" or event == "mouse_drag" or event == "mouse_scroll" then
        local ev = events.new_mouse_event(event, p1, p2, p3)
        handle_mouse(ev, terminal_display)
    elseif event == "monitor_touch" and monitor_display then
        local ev = events.new_mouse_event(event, p1, p2, p3)
        handle_mouse(ev, monitor_display)
    elseif event == "double_click" then
        local ev = events.new_mouse_event("mouse_up", 1, p1, p2)
        handle_mouse(ev, terminal_display)
    elseif event == "char" or event == "key" or event == "key_up" then
        local ev = events.new_key_event(event, p1, p2)
        handle_key(ev, terminal_display)
    elseif event == "paste" then
        terminal_display.handle_paste(p1)
    end
end
