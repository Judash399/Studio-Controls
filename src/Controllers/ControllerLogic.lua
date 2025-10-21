--Modules
local Fusion = require(script.Parent.Parent.Packages.fusion)
local UnpackControlTree = require(script.Parent.UnpackControlTree)

--Refrences
local ControllerTypeFolder = script.Parent.Types
local module = {}

function module.StartController(props: {
    scope: Fusion.Scope<any>,
    controlTree: Instance,
    selection: Instance
})
    local scope = props.scope:deriveScope()

    --Read from the control tree
    local success, data = UnpackControlTree(props.controlTree)

    if not success then
        warn("Attempt to load courupt controller data! Error: " .. data)
        return
    end

    local ControllerTypes = scope:ForPairs(function(use, InnerScope, _, instance)
        local component = require(instance)(scope)
        return instance.Name, component
    end)


    for i, controller in data.Controllers do
        local component = ControllerTypes[controller.Type]
        
        if not component then
            warn("Type '" .. controller.Type .. "' in Control " .. i .. " in the '" .. props.controlTree.Name .. "' Controller is not a valid control type!")
            continue
        end

        component {
            data = controller,
            instance = props.selection,
        }
    end
end

return module