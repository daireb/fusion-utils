--- Returns a Fusion Value that tracks a property of an instance.
return function(scope, instance: Instance, propertyName: string)
	local value = scope:Value(instance[propertyName])

	local connection = instance:GetPropertyChangedSignal(propertyName):Connect(function()
		value:set(instance[propertyName])
	end)

	table.insert(scope, function()
		connection:Disconnect()
	end)

	return value
end
