--Services
local RunService = game:GetService("RunService")

if RunService:IsRunning() then
    return --In a running game, do nothing.
end

--Modules
local Packages = script.Parent.Packages
local Fusion = require(Packages.fusion)
local PluginEssentials = require(Packages.pluginessentials)

PluginEssentials.setFusion(Fusion)

local RootScope = Fusion.scoped({
	doCleanup = Fusion.doCleanup,
	Hydrate = Fusion.Hydrate,
	deriveScope = Fusion.deriveScope,
    Value = Fusion.Value,
    Computed = Fusion.Computed,
})

--Components
local ToolbarComponent = require(PluginEssentials.PluginComponents.Toolbar)(RootScope)

--Refrences
local RootFolder = script.Parent

local newToolbar = ToolbarComponent {
    Name = "Studio Controls",
}

--Windows
local ControllerView = require(RootFolder.Windows.ControllerView)
local SettingsView = require(RootFolder.Windows.SettingsView)

SettingsView.Init {
    scope = RootScope
}

ControllerView.Init {
    scope = RootScope,
    toolbar = newToolbar
}

plugin.Unloading:Once(function()
    Fusion.doCleanup(RootScope)
end)