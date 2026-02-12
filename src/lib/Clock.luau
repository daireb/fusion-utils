local RunService = game:GetService("RunService")

--- Returns a Fusion Value that tracks os.clock() every frame.
--- os.clock() returns high-resolution time in seconds.
return function(scope)
	local value = scope:Value(os.clock())

	local connection = RunService.Heartbeat:Connect(function()
		value:set(os.clock())
	end)

	table.insert(scope, function()
		connection:Disconnect()
	end)

	return value
end
