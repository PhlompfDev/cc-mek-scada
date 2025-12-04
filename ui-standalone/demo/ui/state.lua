local state = {
    toggles = {},
    watchers = {},
    messages = {}
}

function state.register_toggle(name, element)
    state.watchers[name] = state.watchers[name] or {}
    table.insert(state.watchers[name], element)

    if state.toggles[name] ~= nil then
        element.set_value(state.toggles[name])
    end
end

function state.set_toggle(name, value, source)
    state.toggles[name] = value

    local sinks = state.watchers[name]
    if sinks then
        for _, element in ipairs(sinks) do
            if element ~= source then element.set_value(value) end
        end
    end

    state.push_message(('%s set to %s'):format(name, value and 'on' or 'off'))
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
