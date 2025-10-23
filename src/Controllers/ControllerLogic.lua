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
    local scope = props.scope:deriveScope({
        ForPairs = Fusion.ForPairs
    })

    --Read from the control tree
    local success, data = UnpackControlTree(props.controlTree, scope)

    if not success then
        warn("Attempt to load courupt controller data! Error: " .. data)
        return
    end

    --Reads all the components and puts it into a table.
    local ControllerTypes = scope:ForPairs(ControllerTypeFolder:GetChildren(), function(use, InnerScope, _, instance)
        local component = require(instance)(scope)
        return instance.Name, component
    end)

    --Helper value for Controls. Value is the objects CFrame.
    local selectionCFrame = nil
	if props.selection:IsA("Model") then
		selectionCFrame = props.selection.WorldPivot
	elseif props.selection:IsA("BasePart") then
		selectionCFrame = props.selection.CFrame
	else
		selectionCFrame = CFrame.new(0, 0, 0)
	end

    local InfluenceManager = require(script.Parent.ControllerUtils.InfluenceManager)(scope, data.Influences)


    for ControlID, control in data.Controllers do
		local component = Fusion.peek(ControllerTypes)[control.Type]
        
        if not component then
            warn("Type '" .. control.Type .. "' in Control " .. ControlID .. " in the '" .. props.controlTree.Name .. "' Controller is not a valid control type!")
            continue
        end

        for i, influenceOutput in InfluenceManager:GetAllFromObject(control.Type, ControlID) do
            local keyInfo = InfluenceManager.DesectKey(influenceOutput)

            
        end

        component {
            data = control,
            instance = props.selection,
            instanceCFrame = selectionCFrame,
            InfluenceManager = InfluenceManager,
            ControlID = ControlID,
        }
    end
end

return module