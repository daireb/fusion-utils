local BindToProperty = require(script.Parent.BindToProperty)

--- Returns a Fusion Value that tracks a property of an instance.
return function(scope, instance: Instance, propertyName: string)
	local value = scope:Value(instance[propertyName])
	BindToProperty(scope, value, instance, propertyName)
	return value
end
