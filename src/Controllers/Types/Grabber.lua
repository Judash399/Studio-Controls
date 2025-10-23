local Fusion = require(script.Parent.Parent.Parent.Packages.fusion)
local Settings = require(script.Parent.Parent.Parent.Utils.Settings)
local MoveHandles = require(script.Parent.Parent.ControllerUtils.MoveHandles)

local peek = Fusion.peek

return function(scope: Fusion.Scope<any>)
    return function(props: {
        data: any,
        instance: Instance,
        instanceCFrame: CFrame,
        InfluenceManager: any,
        ControlID: number,
    })
        -- Create a derived Fusion scope to manage cleanup
        local scope = scope:innerScope({
            New = Fusion.New,
            Computed = Fusion.Computed,
            Hydrate = Fusion.Hydrate
        })

        local data = props.data

        -- Create the mesh (Part or MeshPart)
        local shape = peek(data.Shape)
        
        local meshpart
        if shape == "Block" then
            meshpart = scope:New("Part")({
                --Special adjustments for this shape would go here.
            })
        else
            meshpart = scope:New("MeshPart")({
                --Special adjustments for this shape would go here.
            })
        end

        scope:Hydrate(meshpart) {
            Material = Enum.Material.Neon,
            Transparency = Settings.ControlTrans,
            Size = peek(data.Size),
            Archivable = true,
            Locked = true,
            CastShadow = false,
            Parent = workspace.CurrentCamera,
            CFrame = scope:Computed(function(use, scope)
                return use(data.Position) * props.instanceCFrame
            end),
        }

        -- Add the movement handle
        local moveHandle = MoveHandles(scope) {
            Adornee = meshpart,
            CurrentPosition = data.Position,
        }

        return scope
    end
end
