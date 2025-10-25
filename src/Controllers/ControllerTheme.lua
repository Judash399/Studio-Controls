local Fusion = require(script.Parent.Parent.Packages.fusion)
local Settings = require(script.Parent.Parent.Utils.Settings)
local scoped = Fusion.scoped

local Theme = {}

Theme.colors = {
    Default = {
        red = Color3.fromHex("f23a30"),
        orange = Color3.fromHex("f58320"),
        yellow = Color3.fromHex("f7cc20"),
        green = Color3.fromHex("41e82e"),
        blue = Color3.fromHex("#1869db"),
        purple = Color3.fromHex("#9f26eb"),
        pink = Color3.fromHex("#f235e3"),
        white = Color3.fromHex("#edfaff"),
        black = Color3.fromHex("#00031a"),
    },

    Cyberpunk = {
        red = Color3.fromHex("ff1b0a"),
        orange = Color3.fromHex("ff7029"),
        yellow = Color3.fromHex("f0b81f"),
        green = Color3.fromHex("59d10f"),
        blue = nil,
        purple = nil,
        pink = nil,
        white = nil,
        black = nil,
    },

    Earthy = {
        red = Color3.fromHex("611e13"),
        orange = Color3.fromHex("693007"),
        yellow = Color3.fromHex("524114"),
        green = Color3.fromHex("10570e"),
        blue = nil,
        purple = nil,
        pink = nil,
        white = nil,
        black = nil,
    },

    Mono = {
        red = Color3.fromHex("2e2726"),
        orange = Color3.fromHex("574d42"),
        yellow = Color3.fromHex("706442"),
        green = Color3.fromHex("77996d"),
        blue = nil,
        purple = nil,
        pink = nil,
        white = nil,
        black = nil,
    },

    Bright = {
        red = Color3.fromHex("ff0000"),
        orange = Color3.fromHex("ff8800"),
        yellow = Color3.fromHex("ffe600"),
        green = Color3.fromHex("04ff00"),
        blue = Color3.fromHex("#0000ff"),
        purple = Color3.fromHex("#9000ff"),
        pink = Color3.fromHex("#ff00e1"),
        white = Color3.fromHex("#ffffff"),
        black = Color3.fromHex("#000000"),
    },

    Dark = {
        red = Color3.fromHex("450a02"),
        orange = Color3.fromHex("5c2900"),
        yellow = Color3.fromHex("3b2f04"),
        green = Color3.fromHex("0e4203"),
        blue = nil,
        purple = nil,
        pink = nil,
        white = nil,
        black = nil,
    },

    Pastel = {
        red = Color3.fromHex("e66a6a"),
        orange = Color3.fromHex("f2975a"),
        yellow = Color3.fromHex("e6cf5c"),
        green = Color3.fromHex("63db6b"),
        blue = Color3.fromHex("#58aaed"),
        purple = Color3.fromHex("#7b58ed"),
        pink = Color3.fromHex("#f592fc"),
        white = Color3.fromHex("#cce8ed"),
        black = Color3.fromHex("#010512"),
    },
}

local scope = scoped({
    Computed = Fusion.Computed
})

Theme.current = Settings.ControllerTheme

Theme.contextual = Fusion.Contextual(scope:Computed(function(use, scope)
    return Theme.colors[use(Theme.current)]
end)
)

return Theme