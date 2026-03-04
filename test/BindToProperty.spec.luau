return function(T, Fusion, _FusionUtils, makeScopeWithUtils)
	T.suite("BindToProperty", function()
		T.case("hydrates initial value on bind", function()
			local scope = makeScopeWithUtils()
			local part = Instance.new("Part")
			part.Name = "InitialName"

			local name = scope:Value("placeholder")
			scope:BindToProperty(name, part, "Name")

			T.assertEqual(Fusion.peek(name), "InitialName", "Value should be hydrated with current property")

			part:Destroy()
			Fusion.doCleanup(scope)
		end)

		T.case("value updates when property changes", function()
			local scope = makeScopeWithUtils()
			local part = Instance.new("Part")
			part.Name = "Before"

			local name = scope:Value("placeholder")
			scope:BindToProperty(name, part, "Name")
			T.assertEqual(Fusion.peek(name), "Before")

			part.Name = "After"
			task.wait()
			T.assertEqual(Fusion.peek(name), "After", "Value should reflect property change")

			part:Destroy()
			Fusion.doCleanup(scope)
		end)

		T.case("tracks numeric properties", function()
			local scope = makeScopeWithUtils()
			local part = Instance.new("Part")
			part.Transparency = 0

			local transparency = scope:Value(1)
			scope:BindToProperty(transparency, part, "Transparency")
			T.assertEqual(Fusion.peek(transparency), 0)

			part.Transparency = 0.75
			task.wait()
			T.assertEqual(Fusion.peek(transparency), 0.75, "Should track numeric property changes")

			part:Destroy()
			Fusion.doCleanup(scope)
		end)

		T.case("cleanup disconnects the signal", function()
			local scope = makeScopeWithUtils()
			local part = Instance.new("Part")
			part.Name = "Initial"

			local name = scope:Value("placeholder")
			scope:BindToProperty(name, part, "Name")
			Fusion.doCleanup(scope)

			part.Name = "Changed"
			task.wait()

			T.assertEqual(Fusion.peek(name), "Initial", "Value should stop updating after cleanup")

			part:Destroy()
		end)
	end)
end
