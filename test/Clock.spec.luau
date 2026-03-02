local RunService = game:GetService("RunService")

return function(T, Fusion, _FusionUtils, makeScopeWithUtils)
	T.suite("Clock", function()
		T.case("returns a Value object", function()
			local scope = makeScopeWithUtils()
			local clock = scope:Clock()

			T.assertNotNil(clock, "Clock should return a value")
			T.assertNotNil(Fusion.peek(clock), "Clock value should be peekable")

			Fusion.doCleanup(scope)
		end)

		T.case("initial value is a number from os.clock()", function()
			local before = os.clock()
			local scope = makeScopeWithUtils()
			local clock = scope:Clock()
			local after = os.clock()

			local value = Fusion.peek(clock)
			T.assertType(value, "number", "Clock value should be a number")
			T.assertTrue(value >= before, "Clock value should be >= os.clock() before creation")
			T.assertTrue(value <= after, "Clock value should be <= os.clock() after creation")

			Fusion.doCleanup(scope)
		end)

		T.case("value updates after a frame", function()
			local scope = makeScopeWithUtils()
			local clock = scope:Clock()

			local initial = Fusion.peek(clock)
			task.wait() -- Ensure we're in the next frame
			task.wait() -- Ensure that we didn't fire before the update

			local updated = Fusion.peek(clock)

			T.assertType(updated, "number")
			T.assertTrue(updated > initial, "Clock value should increase after a frame")

			Fusion.doCleanup(scope)
		end)

		T.case("cleanup disconnects the Heartbeat connection", function()
			local scope = makeScopeWithUtils()
			local clock = scope:Clock()

			Fusion.doCleanup(scope)

			local valueAfterCleanup = Fusion.peek(clock)
			RunService.Stepped:Wait()
			local valueAfterWait = Fusion.peek(clock)

			T.assertEqual(valueAfterCleanup, valueAfterWait, "Clock should stop updating after cleanup")
		end)
	end)
end
