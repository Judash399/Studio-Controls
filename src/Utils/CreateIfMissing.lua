return function(Parent: Instance, InstanceName: string, ClassName: string)
    local instances = Parent:GetChildren()

    local instance = nil
    for _, loopInstance: Instance in instances do
        if loopInstance.Name == InstanceName and loopInstance:IsA(ClassName) then
            instance = loopInstance
            break
        end
    end

    if instance then
        if instance:IsA(ClassName) then
            return instance
        else
            warn("Found '" .. InstanceName .. "' but an incorrect type! Creating new instance with correct type! This may break your scripts!")

            instance = Instance.new(ClassName, Parent)
            instance.Name = InstanceName

            return instance
        end
    else
        instance = Instance.new(ClassName, Parent)
        instance.Name = InstanceName

        return instance
    end
end