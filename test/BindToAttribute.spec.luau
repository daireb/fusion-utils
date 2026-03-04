return function(T, Fusion, _FusionUtils, makeScopeWithUtils)
	T.suite("BindToAttribute", function()
		T.case("hydrates initial value on bind", function()
			local scope = makeScopeWithUtils()
			local part = Instance.new("Part")
			part:SetAttribute("Health", 100)

			local health = scope:Value(0)
			scope:BindToAttribute(health, part, "Health")

			T.assertEqual(Fusion.peek(health), 100, "Value should be hydrated with current attribute")

			part:Destroy()
			Fusion.doCleanup(scope)
		end)

		T.case("value updates when attribute changes", function()
			local scope = makeScopeWithUtils()
			local part = Instance.new("Part")
			part:SetAttribute("Score", 0)

			local score = scope:Value(-1)
			scope:BindToAttribute(score, part, "Score")
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

			local label = scope:Value("")
			scope:BindToAttribute(label, part, "Label")
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

			local missing = scope:Value("default")
			scope:BindToAttribute(missing, part, "NonExistent")
			T.assertEqual(Fusion.peek(missing), nil, "Should hydrate nil attribute gracefully")

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

			local tracked = scope:Value(0)
			scope:BindToAttribute(tracked, part, "Value")
			Fusion.doCleanup(scope)

			part:SetAttribute("Value", 999)
			task.wait()

			T.assertEqual(Fusion.peek(tracked), 1, "Value should stop updating after cleanup")

			part:Destroy()
		end)
	end)
end
