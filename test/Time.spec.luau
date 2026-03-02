local RunService = game:GetService("RunService")

return function(T, Fusion, _FusionUtils, makeScopeWithUtils)
	T.suite("Time", function()
		T.case("returns a Value object", function()
			local scope = makeScopeWithUtils()
			local time = scope:Time()

			T.assertNotNil(time, "Time should return a value")
			T.assertNotNil(Fusion.peek(time), "Time value should be peekable")

			Fusion.doCleanup(scope)
		end)

		T.case("initial value is a number from os.time()", function()
			local before = os.time()
			local scope = makeScopeWithUtils()
			local time = scope:Time()
			local after = os.time()

			local value = Fusion.peek(time)
			T.assertType(value, "number", "Time value should be a number")
			T.assertTrue(value >= before, "Time value should be >= os.time() before creation")
			T.assertTrue(value <= after, "Time value should be <= os.time() after creation")

			Fusion.doCleanup(scope)
		end)

		T.case("value updates after a frame", function()
			local scope = makeScopeWithUtils()
			local time = scope:Time()

			local initial = Fusion.peek(time)

			RunService.Stepped:Wait() -- Ensure we're in the next frame

			local updated = Fusion.peek(time)

			T.assertType(updated, "number")
			T.assertTrue(updated >= initial, "Time value should not decrease after a frame")

			Fusion.doCleanup(scope)
		end)

		T.case("cleanup disconnects the Heartbeat connection", function()
			local scope = makeScopeWithUtils()
			local time = scope:Time()

			Fusion.doCleanup(scope)

			local valueAfterCleanup = Fusion.peek(time)
			RunService.Stepped:Wait()
			local valueAfterWait = Fusion.peek(time)

			T.assertEqual(valueAfterCleanup, valueAfterWait, "Time should stop updating after cleanup")
		end)
	end)
end
