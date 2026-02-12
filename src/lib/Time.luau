local RunService = game:GetService("RunService")

--- Returns a Fusion Value that tracks os.time() every frame.
--- os.time() returns whole seconds since the Unix epoch.
return function(scope)
	local value = scope:Value(os.time())

	local connection = RunService.Heartbeat:Connect(function()
		value:set(os.time())
	end)

	table.insert(scope, function()
		connection:Disconnect()
	end)

	return value
end
