local Fusion = require(script.Parent.Parent.Parent.Packages.fusion)
local Settings = require(script.Parent.Parent.Parent.Utils.Settings)
local MoveHandles = require(script.Parent.Parent.ControllerUtils.MoveHandles)

return function(scope: Fusion.Scope<any>)
    return function(props: {
        data: any,
        instance: Instance,
        instanceCFrame: CFrame
    })
        -- Create a derived Fusion scope to manage cleanup
        local scope = scope:innerScope({
            New = Fusion.New,
            Computed = Fusion.Computed
        })

        -- Initial offset
        local Position = scope:Value(props.instanceCFrame)

        -- Create the mesh (Part or MeshPart)
        local meshpart
        if props.data.VisualInfo.Shape == "Block" then
            meshpart = scope:New("Part")({
                Material = Enum.Material.Neon,
                Transparency = Settings.ControlTrans,
                Size = props.data.VisualInfo.Size,
                Archivable = true,
                Locked = true,
                CastShadow = false,
                Parent = workspace.CurrentCamera,
                CFrame = Position,
            })
        else
            meshpart = scope:New("MeshPart")({
                Material = Enum.Material.Neon,
                Transparency = Settings.ControlTrans,
                Size = props.data.VisualInfo.Size,
                Archivable = true,
                Locked = true,
                CastShadow = false,
                Parent = workspace.CurrentCamera,
                CFrame = Position,
            })
        end

        -- Add the movement handle
        local moveHandle = MoveHandles(scope) {
            StartingPosition = props.instanceCFrame,
            Adornee = meshpart,
            CurrentPosition = Position
        }
        return scope
    end
end
