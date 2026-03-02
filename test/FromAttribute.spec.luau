return function(T, Fusion, _FusionUtils, makeScopeWithUtils)
	T.suite("FromAttribute", function()
		T.case("returns a Value tracking an attribute", function()
			local scope = makeScopeWithUtils()
			local part = Instance.new("Part")
			part:SetAttribute("Health", 100)

			local health = scope:FromAttribute(part, "Health")

			T.assertNotNil(health, "FromAttribute should return a value")
			T.assertEqual(Fusion.peek(health), 100, "Initial value should match attribute")

			part:Destroy()
			Fusion.doCleanup(scope)
		end)

		T.case("value updates when attribute changes", function()
			local scope = makeScopeWithUtils()
			local part = Instance.new("Part")
			part:SetAttribute("Score", 0)

			local score = scope:FromAttribute(part, "Score")
			T.assertEqual(Fusion.peek(score), 0)

			part:SetAttribute("Score", 42)
			task.wait()
			T.assertEqual(Fusion.peek(score), 42, "Value should reflect attribute change")

			part:Destroy()
			Fusion.doCleanup(scope)
		end)

		T.case("tracks string attributes", function()
			local scope = makeScopeWithUtils()
			local part = Instance.new("Part")
			part:SetAttribute("Label", "hello")

			local label = scope:FromAttribute(part, "Label")
			T.assertEqual(Fusion.peek(label), "hello")

			part:SetAttribute("Label", "world")
			task.wait()
			T.assertEqual(Fusion.peek(label), "world", "Should track string attribute changes")

			part:Destroy()
			Fusion.doCleanup(scope)
		end)

		T.case("handles nil initial attribute", function()
			local scope = makeScopeWithUtils()
			local part = Instance.new("Part")

			local missing = scope:FromAttribute(part, "NonExistent")
			T.assertEqual(Fusion.peek(missing), nil, "Should handle nil attribute gracefully")

			part:SetAttribute("NonExistent", "now exists")
			task.wait()
			T.assertEqual(Fusion.peek(missing), "now exists", "Should update when attribute is first set")

			part:Destroy()
			Fusion.doCleanup(scope)
		end)

		T.case("cleanup disconnects the signal", function()
			local scope = makeScopeWithUtils()
			local part = Instance.new("Part")
			part:SetAttribute("Value", 1)

			local tracked = scope:FromAttribute(part, "Value")
			Fusion.doCleanup(scope)

			part:SetAttribute("Value", 999)
			task.wait()

			T.assertEqual(Fusion.peek(tracked), 1, "Value should stop updating after cleanup")

			part:Destroy()
		end)
	end)
end
