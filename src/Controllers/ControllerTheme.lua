local Fusion = require(script.Parent.Parent.Packages.fusion)
local Settings = require(script.Parent.Parent.Utils.Settings)
local scoped = Fusion.scoped

local Theme = {}

Theme.colors = {
    red = {
        Default = Color3.fromHex("f23a30"),
        Cyberpunk = Color3.fromHex("ff1b0a"),
        Earthy = Color3.fromHex("611e13"),
        Mono = Color3.fromHex("2e2726"),
        Bright = Color3.fromHex("ff0000"),
        Dark = Color3.fromHex("450a02"),
        Pastel = Color3.fromHex("e66a6a")
    },
    orange = {
        Default = Color3.fromHex("f58320"),
        Cyberpunk = Color3.fromHex("ff7029"),
        Earthy = Color3.fromHex("693007"),
        Mono = Color3.fromHex("574d42"),
        Bright = Color3.fromHex("ff8800"),
        Dark = Color3.fromHex("5c2900"),
        Pastel = Color3.fromHex("f2975a")
    },
    yellow = {
        Default = Color3.fromHex("f7cc20"),
        Cyberpunk = Color3.fromHex("f0b81f"),
        Earthy = Color3.fromHex("524114"),
        Mono = Color3.fromHex("706442"),
        Bright = Color3.fromHex("ffe600"),
        Dark = Color3.fromHex("3b2f04"),
        Pastel = Color3.fromHex("e6cf5c")
    },
    green = {
        Default = Color3.fromHex("41e82e"),
        Cyberpunk = Color3.fromHex("59d10f"),
        Earthy = Color3.fromHex("10570e"),
        Mono = Color3.fromHex("77996d"),
        Bright = Color3.fromHex("04ff00"),
        Dark = Color3.fromHex("0e4203"),
        Pastel = Color3.fromHex("63db6b"),
    },
    blue = {
        
    },
    purple = {

    },
    pink = {

    },
    white = {

    },
    black = {

    },
}

local scope = scoped(Fusion)

Theme.current = scope:Value(Settings.ControllerTheme)
Theme.dynamic = {}
for color, variants in Theme.colors do
    Theme.dynamic[color] = scope:Computed(function(use)
        return variants[use(Theme.current)]
    end)
end
