--- Binds an existing Fusion Value to track an attribute of an instance.
return function(scope, value, instance: Instance, attributeId: string)
	value:set(instance:GetAttribute(attributeId))

	local connection = instance:GetAttributeChangedSignal(attributeId):Connect(function()
		value:set(instance:GetAttribute(attributeId))
	end)

	table.insert(scope, function()
		connection:Disconnect()
	end)
end
