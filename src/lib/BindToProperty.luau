--- Binds an existing Fusion Value to track a property of an instance.
return function(scope, value, instance: Instance, propertyName: string)
	value:set(instance[propertyName])

	local connection = instance:GetPropertyChangedSignal(propertyName):Connect(function()
		value:set(instance[propertyName])
	end)

	table.insert(scope, function()
		connection:Disconnect()
	end)
end
