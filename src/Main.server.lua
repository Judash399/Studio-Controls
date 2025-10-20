--Services
local RunService = game:GetService("RunService")

if RunService:IsRunning() then
    return --In a running game, do nothing.
end

--Modules
local Packages = script.Parent.Packages

--@type Fusion
local Fusion = require(Packages.Fusion)

--@type PluginEssentials
local PluginEssentials = require(Packages.PluginEssentials)