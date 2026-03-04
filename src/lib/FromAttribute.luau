local BindToAttribute = require(script.Parent.BindToAttribute)

--- Returns a Fusion Value that tracks an attribute of an instance.
return function(scope, instance: Instance, attributeId: string)
	local value = scope:Value(instance:GetAttribute(attributeId))
	BindToAttribute(scope, value, instance, attributeId)
	return value
end
