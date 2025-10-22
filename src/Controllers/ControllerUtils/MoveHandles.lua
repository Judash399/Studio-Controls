local Fusion = require(script.Parent.Parent.Parent.Packages.fusion)

return function(scope: Fusion.Scope<any>)
    return function(props: {
        StartingPosition: CFrame,
        Adornee: Instance,
        CurrentPosition: Fusion.UsedAs<CFrame>
    })
        local scope = scope:deriveScope {
            New = Fusion.New
        }

        local LastPos = props.StartingPosition

        local handles = scope:New "Handles" {
            Parent = game.CoreGui,
            Adornee = props.Adornee,
            Style = Enum.HandlesStyle.Movement,

            [Fusion.OnEvent "MouseDrag"] = function(face, distance)
                local moveVector = Vector3.fromNormalId(face) * distance

                props.CurrentPosition:set(LastPos * CFrame.new(moveVector))
            end,

            [Fusion.OnEvent "MouseButton1Up"] = function(face)
                LastPos = Fusion.peek(props.CurrentPosition)
            end
        }

        return scope
    end
end