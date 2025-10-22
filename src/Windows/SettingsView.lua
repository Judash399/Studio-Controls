--Modules
local RootFolder = script.Parent.Parent

local Fusion = require(RootFolder.Packages.fusion)
local PluginEssentials = require(RootFolder.Packages.pluginessentials)
local CustomComponents = require(RootFolder.Components.CustomComponents)

local Settings = require(RootFolder.Utils.Settings)

--Refrences
local scoped, peek, OnChange, OnEvent, Children = Fusion.scoped, Fusion.peek, Fusion.OnChange, Fusion.OnEvent, Fusion.Children

local module = {}

function  module.Init(props: {
    scope: Fusion.Scope<any>
})
    local scope = props.scope:innerScope()
    --Componenets
    local Widget = require(PluginEssentials.PluginComponents.Widget)(scope)
    local SideBarMenu = CustomComponents.SideBarMenu(scope)
    local SideTab = CustomComponents.SideTab(scope)

    local widgetEnabled = scope:Value(false)

    local SettingsWidget = Widget {
        Name = "Studio Controls Settings",
        Id = "SC_Settings",
        InitialDockTo = Enum.InitialDockState.Float,
        InitialEnabled = false,
        ForceInitialEnabled = false,
        FloatingSize = Vector2.new(720, 710),
        MinimumSize = Vector2.new(720, 710),
        
        Enabled = widgetEnabled,
        
        [OnChange "Enabled"] = function(isEnabled)
            widgetEnabled:set(isEnabled)
        end,

        [Children] = {
        }
    }

    SideBarMenu {
        Parent = SettingsWidget,
        SideMenuContent = {
            SideTab {
                Text = "Test Tab!",
                IconID = "rbxassetid://86927978311039",
            },
        },
    }

    function module.ToggleVisibility()
        widgetEnabled:set(not peek(widgetEnabled))
    end
end

return module