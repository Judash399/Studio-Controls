local Fusion = require(script.Parent.Parent.Packages.fusion)
local Value, Computed = Fusion.Value, Fusion.Computed

local settings = {}

local defaultSettings = {
    
}
table.freeze(defaultSettings)

-- Only meant to be run by Main.server.lua
function settings.ReadSettings(plugin: Plugin, scope: Fusion.Scope<any>)
    local savedSettings = plugin:GetSetting("StudioControlsSettings") or {}

    -- Merge defaults
    for key, value in pairs(defaultSettings) do
        if savedSettings[key] == nil then
            savedSettings[key] = value
        end
    end

    -- Create a single reactive state for all saved settings
    local savedState = Value(savedSettings)

    -- Create Computed values for each setting key
    for key, _ in pairs(defaultSettings) do
        settings[key] = Computed(scope, function(use)
            local current = use(savedState)
            return current[key]
        end)
    end

    -- Store the root state so settings can be changed later
    settings._state = savedState
    settings._plugin = plugin

    
    --Remove the ReadSettings function to prevent being ran twice.
    settings.ReadSettings = nil
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