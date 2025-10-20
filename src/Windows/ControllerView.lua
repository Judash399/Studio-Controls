--Modules
local RootFolder = script.Parent.Parent

local Fusion = require(RootFolder.Packages.fusion)
local PluginEssentials = require(RootFolder.Packages.pluginessentials)
local CustomComponents = require(RootFolder.Components.CustomComponents)

--Refrences
local scoped, peek, OnChange, OnEvent, Children = Fusion.scoped, Fusion.peek, Fusion.OnChange, Fusion.OnEvent, Fusion.Children

local module = {}


function module.Init(props: {
    scope: Fusion.Scope<any>,
    toolbar: PluginToolbar
})
    local scope = props.scope:deriveScope()

    --Commponents
    local Widget = require(PluginEssentials.PluginComponents.Widget)(scope)
	local ToolbarButton = require(PluginEssentials.PluginComponents.ToolbarButton)(scope)
	local Button = require(PluginEssentials.StudioComponents.Button)(scope)
	local IconButton = require(PluginEssentials.StudioComponents.IconButton)(scope)
	local TextInput = require(PluginEssentials.StudioComponents.TextInput)(scope)
	local ControllerListItem = CustomComponents.ControllerListItem(scope)

    local widgetEnabled = scope:Value(false)


    --Create the button.
    local ControllersButton = ToolbarButton {
		Toolbar = props.toolbar,

		ClickableWhenViewportHidden = false,

		Name = "Controllers",
		ToolTip = "Opens a List of all created controllers in this place",
		Image = "rbxassetid://86927978311039",
		
		[OnEvent "Click"] = function()
			widgetEnabled:set(not peek(widgetEnabled))
		end
	}

    --Create the widget (or menu).
    local controllersWidget = Widget {
		Name = "Controllers",
		Id = "Controllers",
		InitialDockTo = Enum.InitialDockState.Float,
		InitialEnabled = false,
		ForceInitialEnabled = false,
		FloatingSize = Vector2.new(720, 710),
		MinimumSize = Vector2.new(720, 710),
		
		Enabled = widgetEnabled,
		
		[OnChange "Enabled"] = function(isEnabled)
			widgetEnabled:set(isEnabled)
		end,
	}



    return scope
end

return module