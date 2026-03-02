# FusionUtils

A collection of useful [Fusion](https://elttob.uk/Fusion/) scope-method constructors for Roblox.

## Installation

```bash
pesde add gh#daireb/FusionUtils#v0.1.0
```

## Usage

Spread `FusionUtils` into `Fusion.scoped()` to add the constructors to your scope:

```lua
local Fusion = require(Path.To.Fusion)
local FusionUtils = require(Path.To.FusionUtils)

local scope = Fusion.scoped(Fusion, FusionUtils)
```

Then use them like any other Fusion scope method:

```lua
local clock = scope:Clock()
local time = scope:Time()
local hp = scope:FromProperty(humanoid, "Health")
local money = scope:FromAttribute(player, "Money")
```

All connections are cleaned up automatically when the scope is destroyed.

## Constructors

### Clock

Returns a Fusion `Value` that updates with `os.clock()` every frame via `RunService.Heartbeat`. Useful for high-resolution time-based animations and effects.

```lua
local clock = scope:Clock()
```

### Time

Returns a Fusion `Value` that updates with `os.time()` once per second on `RunService.Heartbeat`. Returns whole seconds since the Unix epoch.

```lua
local time = scope:Time()
```

### FromProperty

Returns a Fusion `Value` that tracks an instance property, updating whenever the property changes.

```lua
local hp = scope:FromProperty(humanoid, "Health")
local name = scope:FromProperty(player, "DisplayName")
```

### FromAttribute

Returns a Fusion `Value` that tracks an instance attribute, updating whenever the attribute changes.

```lua
local money = scope:FromAttribute(player, "Money")
local level = scope:FromAttribute(player, "Level")
```

> ⚠️ Note: Values from both `scope:FromProperty` and `scope:FromAttribute` will stop updating but keep their value if the instance is destroyed.

## Recommended: Globals Module for Singletons

If you want a single shared `Clock` or `Time` value across your entire codebase, create a small globals module:

```lua
-- shared/Globals.luau
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local FusionUtils = require(ReplicatedStorage.Packages.fusion_utils)

local scope = Fusion.scoped(Fusion, FusionUtils)

return {
    Clock = scope:Clock(),
    Time = scope:Time(),
}
```

Then require it from anywhere:

```lua
local FusionGlobals = require(Path.To.FusionGlobals)
local clock = FusionGlobals.Clock
```

This means that there's only one heartbeat connection and is more optimised than doing it inline in several places.

## License

MIT
