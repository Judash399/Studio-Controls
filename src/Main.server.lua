--Services
local RunService = game:GetService("RunService")
local SelectionService = game:GetService("Selection")

if RunService:IsRunning() then
    return --In a running game, do nothing.
end

--Modules
local Packages = script.Parent.Packages
local Fusion = require(Packages.fusion)
local PluginEssentials = require(Packages.pluginessentials)
local Settings = require(script.Parent.Utils.Settings)
local ControllerLogic = require(script.Parent.Controllers.ControllerLogic)
local CreateIfMissing = require(script.Parent.Utils.CreateIfMissing)

PluginEssentials.setFusion(Fusion)

local RootScope = Fusion.scoped(Fusion)

--Components
local ToolbarComponent = require(PluginEssentials.PluginComponents.Toolbar)(RootScope)

--Refrences
local RootFolder = script.Parent

local StudioControlsFolder = CreateIfMissing(game.ServerStorage, "StudioControls", "Folder")
local ObjectControllerFolder = CreateIfMissing(StudioControlsFolder, "ObjectControllers", "Folder")

local newToolbar = ToolbarComponent {
    Name = "Studio Controls",
}

Settings.ReadSettings(plugin, RootScope)

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

local currentlySelected = nil

table.insert(RootScope, SelectionService.SelectionChanged:Connect(function()
	if currentlySelected then
		currentlySelected:doCleanup()
	end
	currentlySelected = RootScope:deriveScope()

    local selected = SelectionService:Get()
    if #selected ~= 1 then return end
    local selection = selected[1]

    local ControllerFolder = nil
    for _, tagName in selection:GetTags() do
        local tagLoopFind = ObjectControllerFolder:FindFirstChild(tagName)
        if tagLoopFind then
           ControllerFolder =  tagLoopFind
           break
        end
    end

    if not ControllerFolder then
        return
    end

    ControllerLogic.StartController {
        scope =  currentlySelected,
        controlTree = ControllerFolder,
        selection = selection
    }
end))

plugin.Unloading:Once(function()
    Fusion.doCleanup(RootScope)
end)