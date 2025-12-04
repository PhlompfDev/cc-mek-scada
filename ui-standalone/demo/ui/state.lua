local state = {
    values = {},
    watchers = {},
    actions = {},
    messages = {}
}

local function default_setter(target, val)
    if target.set_value then target.set_value(val, true) end
end

---@param name string
---@param element table
---@param setter fun(element:table, value:any, mirrored:boolean)|nil
function state.register_value(name, element, setter)
    state.watchers[name] = state.watchers[name] or {}
    table.insert(state.watchers[name], { element = element, setter = setter or default_setter })

    if state.values[name] ~= nil then
        (setter or default_setter)(element, state.values[name], true)
    end
end

---@param name string
---@param value any
---@param source table|nil
function state.set_value(name, value, source)
    state.values[name] = value

    local sinks = state.watchers[name]
    if sinks then
        for _, watcher in ipairs(sinks) do
            if watcher.element ~= source then watcher.setter(watcher.element, value, true) end
        end
    end
end

function state.register_toggle(name, element)
    state.register_value(name, element)
end

function state.set_toggle(name, value, source)
    state.set_value(name, value, source)
    state.push_message(('%s set to %s'):format(name, value and 'on' or 'off'))
end

---@param name string
---@param element table
---@param setter fun(element:table, value:any)|nil
function state.register_action(name, element, setter)
    state.actions[name] = state.actions[name] or {}
    table.insert(state.actions[name], { element = element, setter = setter or default_setter })
end

---@param name string
---@param value any
---@param source table|nil
function state.signal_action(name, value, source)
    local sinks = state.actions[name]
    if sinks then
        for _, watcher in ipairs(sinks) do
            if watcher.element ~= source then watcher.setter(watcher.element, value) end
        end
    end
end

function state.register_message(element)
    table.insert(state.messages, element)
end

function state.push_message(message)
    for _, element in ipairs(state.messages) do
        element.set_value(message)
    end
end

return state
