local RootFolder = script.Parent.Parent

--Modules
local Fusion = require(RootFolder.Packages.fusion)
local PluginEssentials = require(RootFolder.Packages.pluginessentials)

local scoped, peek, OnChange, OnEvent, Children, unwrap, out = Fusion.scoped, Fusion.peek, Fusion.OnChange, Fusion.OnEvent, Fusion.Children, Fusion.unwrap, Fusion.out

local components = {}

function components.ControllerListItem(scope: Fusion.Scope<any>)
    return function (props: {
        Text: Fusion.UsedAs<string>,
        Icon: Fusion.UsedAs<string>,
        OnClicked: () -> ()
    })
        local scope = scope:innerScope({})

        local ButtonComponent = require(PluginEssentials.StudioComponents.Button)(scope)
        local LabelComponent = require(PluginEssentials.StudioComponents.Label)(scope)

        return ButtonComponent {
            Text = "",
            Size = UDim2.new(1, 0, 0, 23),

            [OnEvent "Activated"] = props.OnClicked,

            [Children] = {
                scope:New "UIPadding" {
                    PaddingBottom = UDim.new(0, 2),
                    PaddingTop = UDim.new(0, 2),
                    PaddingLeft = UDim.new(0, 5),
                    PaddingRight = UDim.new(0, 5)
				},
                scope:New "UIListLayout" {
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 5),
                },
                LabelComponent {
                    Text = props.Text,
                    Size = UDim2.new(1, 0, 1, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 1,

                    [Children] = {
                         scope:New "UIFlexItem" {
					        FlexMode = Enum.UIFlexMode.Fill
				        },
                    }
                }
            }
        }
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
        
        local newScope = scope:innerScope({
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

        local themeProvider = require(PluginEssentials.StudioComponents.Util.themeProvider)(scope)

        local BarColor = themeProvider:GetColor(Enum.StudioStyleGuideColor.ScrollBar) or nil

        return newScope:New "ScrollingFrame" {
            BackgroundTransparency = 1,
			Name = "Content",
			Size = UDim2.new(1, 0, 1, 0),
			LayoutOrder = 2,
            Parent = props.Parent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 5,
            ScrollBarImageColor3 = BarColor,

            [Children] = {
                props.Content,
                newScope:New "UIFlexItem" {
					FlexMode = Enum.UIFlexMode.Fill
				},
                scope:New "UIPadding" {
                    PaddingLeft = UDim.new(0, 5),
                    PaddingRight = UDim.new(0, 7),
                }
            }
        }
    end
end

--Recomended for use with a `SideBarMenu()` creates something that looks similar to a tab with an icon on the left, and the tab name using the remaing space.
function components.SideTab(scope: Fusion.Scope<any>)
    return function(props: {
        IconID: string,
        Text: string,
    })
        local scope = scope:innerScope({
            New = Fusion.New
        })
        
        --Components
        local ButtonComponent = require(PluginEssentials.StudioComponents.Button)(scope)
        local LabelComponent = require(PluginEssentials.StudioComponents.Label)(scope)



        local button = ButtonComponent {
            Text = "",
            Size = UDim2.new(1, 0, 0, 30),
            [Children] = {
                scope:New "UIListLayout" {
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 5),
                },
                scope:New "ImageLabel" {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Image = props.IconID,
                    [Children] = {
                        scope:New "UIAspectRatioConstraint" {

                        },
                    }
                },
                LabelComponent {
                    Text = props.Text,
                    Size = UDim2.new(1, 0, 1, 0),
                    [Children] = {
                        scope:New "UIFlexItem" {
                            FlexMode = Enum.UIFlexMode.Fill
                        }
                    },
                    TextXAlignment = Enum.TextXAlignment.Left
                }
            }
        }

        button.UICorner.CornerRadius = UDim.new(0, 7)

        return button
    end
end

--Similar to the menu components, but the topbar is replaced with a sidebar, recomended for you to make as if its a tab view.
function components.SideBarMenu(scope: Fusion.Scope<any>)
    return function (props: {
        SideMenuContent: any,
        Content: any,
        Parent: Instance,
    })
        local scope = scope:innerScope({
            New = Fusion.New
        })

        --Component
        local ScrollFrameComponent = require(PluginEssentials.StudioComponents.ScrollFrame)(scope)

        scope:New "UIListLayout" {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = props.Parent,
		}

        scope:New "UIPadding" {
            PaddingBottom = UDim.new(0, 5),
            PaddingTop = UDim.new(0, 5),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            Parent = props.Parent,
        }

        local themeProvider = require(PluginEssentials.StudioComponents.Util.themeProvider)(scope)

        local borderColor = themeProvider:GetColor(Enum.StudioStyleGuideColor.Border) or nil

        local SideMenu =  scope:New "ScrollingFrame" {
            Size = UDim2.new(0, 200, 1, 0),
            Parent = props.Parent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 5,
            BackgroundColor3 = borderColor,

            [Children] = {
                table.unpack(props.SideMenuContent or {}),
                scope:New "UIListLayout" {},
                scope:New "UIPadding" {
                    PaddingBottom = UDim.new(0, 5),
                    PaddingTop = UDim.new(0, 5),
                    PaddingLeft = UDim.new(0, 5),
                    PaddingRight = UDim.new(0, 5)
                },
                scope:New "UICorner" {
                    CornerRadius = UDim.new(0, 10)
                },
            },
        }

        local Content = scope:New "Frame" {
         BackgroundTransparency = 1,
			Name = "Content",
			Size = UDim2.new(1, 0, 1, 0),
			LayoutOrder = 2,
            Parent = props.Parent,

            [Children] = {
                props.Content,
                scope:New "UIFlexItem" {
					FlexMode = Enum.UIFlexMode.Fill
				}
            }   
        }
    end
end

return components