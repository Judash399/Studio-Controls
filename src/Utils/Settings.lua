local Fusion = require(script.Parent.Parent.Packages.fusion)
local Value, Computed = Fusion.Value, Fusion.Computed

local settings = {}

local defaultSettings = {
    ControllerTheme = "Default"
}
table.freeze(defaultSettings)

-- Only meant to be run by Main.server.lua
function settings.ReadSettings(plugin: Plugin, scope: Fusion.Scope<any>)
    local savedSettings = plugin:GetSetting("StudioControlsSettings") or {}

    -- Merge new defaults into settings.
    for key, value in pairs(defaultSettings) do
        if savedSettings[key] == nil then
            savedSettings[key] = value
        end
    end

    -- Create a value for settings.
    local savedState = Value(scope, savedSettings)

    -- Create Computed values for each setting key, so anything that uses it dynamically updates to changes in the settings.
    for key, _ in pairs(defaultSettings) do
        settings[key] = Computed(scope, function(use)
            local current = use(savedState)
            return current[key]
        end)
    end

    settings._state = savedState
    settings._plugin = plugin

    settings.ReadSettings = nil --Remove the ReadSettings function to prevent being ran twice.
end

-- Updates a setting and persists it
function settings.SetSetting(key: string, value: any)
    local rootState = settings._state
    if not rootState then
        warn("[StudioControls] Settings not initialized before calling SetSetting")
        return
    end

    local plugin = settings._plugin
    local current = rootState:get()
    current[key] = value
    rootState:set(current)

    if plugin then
        plugin:SetSetting("StudioControlsSettings", current)
    end
end

return settings