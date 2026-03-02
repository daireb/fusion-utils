local ReplicatedStorage = game:GetService("ReplicatedStorage")

local T = require(script.Parent.TestHelper)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local FusionUtils = require(ReplicatedStorage.fusion_utils)

local function makeScopeWithUtils()
	return Fusion.scoped(Fusion, FusionUtils)
end

require(script.Parent["Clock.spec"])(T, Fusion, FusionUtils, makeScopeWithUtils)
require(script.Parent["Time.spec"])(T, Fusion, FusionUtils, makeScopeWithUtils)
require(script.Parent["FromProperty.spec"])(T, Fusion, FusionUtils, makeScopeWithUtils)
require(script.Parent["FromAttribute.spec"])(T, Fusion, FusionUtils, makeScopeWithUtils)

local allPassed = T.report()

if not allPassed then
	error("Some tests failed - see output above")
end
