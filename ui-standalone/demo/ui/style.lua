local core   = require("graphics.core")
local themes = require("graphics.themes")

local cpair = core.cpair

local style = {}

style.palette = themes.smooth_stone
style.color_mode = themes.COLOR_MODE.STANDARD

style.root = cpair(colors.white, colors.black)
style.header = cpair(colors.black, colors.lightGray)
style.label = cpair(colors.lightGray, colors._INHERIT)
style.text = cpair(colors.white, colors._INHERIT)
style.divider = cpair(colors.gray, colors._INHERIT)

style.button = cpair(colors.black, colors.lightGray)
style.button_active = cpair(colors.white, colors.green)
style.hazard = cpair(colors.white, colors.red)
style.hazard_accent = colors.orange
style.hazard_dim = cpair(colors.white, colors.gray)
style.switch_on = cpair(colors.black, colors.lime)
style.switch_off = cpair(colors.white, colors.gray)
style.nav = cpair(colors.white, colors.gray)
style.nav_dim = cpair(colors.lightGray, colors.gray)
style.panel = cpair(colors.gray, colors.brown)

---@param target Terminal|Monitor
---@param palette ui_palette
---@param color_mode COLOR_MODE
local function _apply_palette(target, palette, color_mode)
    for i = 1, #palette.colors do
        target.setPaletteColor(palette.colors[i].c, palette.colors[i].hex)
    end

    local remap = palette.color_modes[color_mode] or {}
    for i = 1, #remap do
        target.setPaletteColor(remap[i].c, remap[i].hex)
    end
end

function style.apply_to_display(target)
    target.setTextColor(colors.white)
    target.setBackgroundColor(colors.black)
    target.clear()
    target.setCursorPos(1, 1)
    _apply_palette(target, style.palette, style.color_mode)
end

return style
