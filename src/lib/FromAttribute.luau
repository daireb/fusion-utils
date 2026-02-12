--- Returns a Fusion Value that tracks an attribute of an instance.
return function(scope, instance: Instance, attributeId: string)
	local value = scope:Value(instance:GetAttribute(attributeId))

	local connection = instance:GetAttributeChangedSignal(attributeId):Connect(function()
		value:set(instance:GetAttribute(attributeId))
	end)

	table.insert(scope, function()
		connection:Disconnect()
	end)

	return value
end
