--Modules
local Fusion = require(script.Parent.Parent.Parent.Packages.fusion)

local Plugin: Plugin = script:FindFirstAncestorWhichIsA("Plugin")

return function(scope: Fusion.Scope<any>)
    return function(props: {
        StartingPosition: CFrame,
        Adornee: Instance,
        CurrentPosition: Fusion.UsedAs<CFrame>
    })
        local scope = scope:innerScope {
            New = Fusion.New
        }

        local gridSnap = scope:Value(math.round(Plugin.GridSize * 10000) / 10000)
        table.insert(scope, Plugin:GetPropertyChangedSignal("GridSize"):Connect(function()
            print(Plugin.GridSize)
            gridSnap:set(math.round(Plugin.GridSize * 10000) / 10000)
        end))

        local LastPos = props.StartingPosition

        local handles = scope:New "Handles" {
            Parent = game.CoreGui,
            Adornee = props.Adornee,
            Style = Enum.HandlesStyle.Movement,

            [Fusion.OnEvent "MouseDrag"] = function(face, distance)
                local grid = Fusion.peek(gridSnap)

                local moveVector = Vector3.fromNormalId(face) * distance

                -- Snap moveVector to the grid.
                local snappedMove = Vector3.new(
                    math.round(moveVector.X / grid) * grid,
                    math.round(moveVector.Y / grid) * grid,
                    math.round(moveVector.Z / grid) * grid
                )

                props.CurrentPosition:set(LastPos * CFrame.new(snappedMove))
            end,

            [Fusion.OnEvent "MouseButton1Up"] = function(face)
                LastPos = Fusion.peek(props.CurrentPosition)
            end
        }

        return scope
    end
end