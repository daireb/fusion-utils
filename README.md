# fusion-utils

A collection of useful [Fusion](https://elttob.uk/Fusion/) scope-method constructors for Roblox.

## Installation

```bash
pesde add daireb/fusion_utils
```

## Usage

Spread `FusionUtils` into `Fusion.scoped()` to add the constructors to your scope:

```lua
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local FusionUtils = require(ReplicatedStorage.Packages.fusion_utils)

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

Returns a Fusion `Value` that updates with `os.time()` every frame via `RunService.Heartbeat`. Returns whole seconds since the Unix epoch.

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

## Recommended: Globals Module for Singleton Clock/Time

If you want a single shared `Clock` or `Time` value across your entire codebase (one Heartbeat connection, shared by all consumers), create a small globals module:

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
local Globals = require(ReplicatedStorage.shared.Globals)
local clock = Globals.Clock
```

This works because `require()` executes the module on first call and caches the result. Every subsequent `require()` returns the same table with the same `Value` objects -- no load order issues, no separate init step.

## License

MIT
