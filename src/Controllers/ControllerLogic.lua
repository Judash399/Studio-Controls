--Modules
local Fusion = require(script.Parent.Parent.Packages.fusion)
local UnpackControlTree = require(script.Parent.UnpackControlTree)

--Refrences
local ControllerTypeFolder = script.Parent.Types
local module = {}

local peek = Fusion.peek


local function controlLogic(ControlId: number, controlData: {[string | number]: Fusion.Value<Fusion.Scope<any>, any>})
    
end

function module.StartController(props: {
    scope: Fusion.Scope<any>,
    controlTree: Instance,
    selection: Instance
})
    local scope = props.scope:innerScope({
        ForPairs = Fusion.ForPairs,
        Observer = Fusion.Observer
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
		local component = peek(ControllerTypes)[peek(control.Type)]
        
        if component == nil then
            warn("Type '" .. peek(control.Type) .. "' in Control " .. ControlID .. " in the '" .. props.controlTree.Name .. "' Controller is not a valid control type!")
            continue
        end

        local function GetValueFromKey(key: string, defaultvalue: any): any
            local keyInfo = InfluenceManager.DissectKey(key)

            if keyInfo.ObjectType == "Attribute" then
				local value = props.selection:GetAttribute(keyInfo.propertyName)
				
				if value == nil then
					props.selection:SetAttribute(keyInfo.propertyName, defaultvalue)
					return defaultvalue
				end
				
				return value
            else
                error("Influence ObjectType of '" .. keyInfo.ObjectType .. "' is not currently supported!")
            end
        end


        for i: string, influenceOutput in InfluenceManager:GetAllFromObject("Control", tostring(ControlID)) do
            local InputkeyInfo = InfluenceManager.DissectKey(i)

            local value = GetValueFromKey(peek(influenceOutput), peek(control[InputkeyInfo.propertyName]))
			
			if value then
				control[InputkeyInfo.propertyName]:set(value)
			end
        end

        component {
            data = control,
            instance = props.selection,
            instanceCFrame = selectionCFrame,
            InfluenceManager = InfluenceManager,
            ControlID = ControlID,
        }


        for i: string, influenceOutput in InfluenceManager:GetAllFromObject("Control", tostring(ControlID)) do
            local InputkeyInfo = InfluenceManager.DissectKey(i)
            local OutputkeyInfo = InfluenceManager.DissectKey(peek(influenceOutput))

            local value = control[InputkeyInfo.propertyName]
            local observer = scope:Observer(value)

            if OutputkeyInfo.ObjectType == "Attribute" then
                observer:onBind(function()
                    props.selection:SetAttribute(OutputkeyInfo.propertyName, peek(value))
                end)
            end
        end 
    end
end

return module