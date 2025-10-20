local RootFolder = script.Parent.Parent

--Modules
local Fusion = require(RootFolder.Packages.fusion)
local PluginEssentials = require(RootFolder.Packages.pluginessentials)

local scoped, peek, OnChange, OnEvent, Children = Fusion.scoped, Fusion.peek, Fusion.OnChange, Fusion.OnEvent, Fusion.Children

local components = {}

function components.ControllerListItem(scope: Fusion.Scope<any>)
    return function (props: {

    })
        
    end
end

--Creates a new menu. It creates an empty Topbar, and a content frame.
function components.Menu(scope: Fusion.Scope<any>)
    return  function (
        props: {
            Parent: Instance,
            TopbarContent: any,
            Content: any,
        })
        
        local newScope = scope:deriveScope({
            New = Fusion.New
        })
        
        newScope:New "UIListLayout" {
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = props.Parent,
		}

        --Topbar
        newScope:New "Frame" {
            BackgroundTransparency = 1,
			Name = "Topbar",
			Size = UDim2.new(1, 0, 0, 35),
			LayoutOrder = 1,
            Parent = props.Parent,

            [Children] = {
                newScope:New "UIListLayout" {
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, 5)
				},
				newScope:New "UIPadding" {
                    PaddingBottom = UDim.new(0, 5),
                    PaddingTop = UDim.new(0, 5),
                    PaddingLeft = UDim.new(0, 5),
                    PaddingRight = UDim.new(0, 5)
				},
                props.TopbarContent
            }
        }

        --Content
        newScope:New "Frame" {
            BackgroundTransparency = 1,
			Name = "Content",
			Size = UDim2.new(1, 0, 1, 0),
			LayoutOrder = 2,

            [Children] = {
                props.Content,
                newScope:New "UIFlexItem" {
					FlexMode = Enum.UIFlexMode.Fill
				}
            }
        }
    end
end

return components