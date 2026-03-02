return function(T, Fusion, _FusionUtils, makeScopeWithUtils)
	T.suite("FromProperty", function()
		T.case("returns a Value tracking a property", function()
			local scope = makeScopeWithUtils()
			local part = Instance.new("Part")
			part.Name = "TestPart"

			local nameValue = scope:FromProperty(part, "Name")

			T.assertNotNil(nameValue, "FromProperty should return a value")
			T.assertEqual(Fusion.peek(nameValue), "TestPart", "Initial value should match property")

			part:Destroy()
			Fusion.doCleanup(scope)
		end)

		T.case("value updates when property changes", function()
			local scope = makeScopeWithUtils()
			local part = Instance.new("Part")
			part.Name = "Before"

			local nameValue = scope:FromProperty(part, "Name")
			T.assertEqual(Fusion.peek(nameValue), "Before")

			part.Name = "After"
			task.wait()
			T.assertEqual(Fusion.peek(nameValue), "After", "Value should reflect property change")

			part:Destroy()
			Fusion.doCleanup(scope)
		end)

		T.case("tracks numeric properties", function()
			local scope = makeScopeWithUtils()
			local part = Instance.new("Part")
			part.Transparency = 0

			local transparency = scope:FromProperty(part, "Transparency")
			T.assertEqual(Fusion.peek(transparency), 0)

			part.Transparency = 0.5
			task.wait()
			T.assertEqual(Fusion.peek(transparency), 0.5, "Should track numeric property changes")

			part:Destroy()
			Fusion.doCleanup(scope)
		end)

		T.case("cleanup disconnects the signal", function()
			local scope = makeScopeWithUtils()
			local part = Instance.new("Part")
			part.Name = "Initial"

			local nameValue = scope:FromProperty(part, "Name")
			Fusion.doCleanup(scope)

			part.Name = "Changed"
			task.wait()

			T.assertEqual(Fusion.peek(nameValue), "Initial", "Value should stop updating after cleanup")

			part:Destroy()
		end)
	end)
end
