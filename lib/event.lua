-- event center
local eventcenter = Class
{
	init =
		function(self)
			self._ = {}
		end,
	--[[
	返回一个Handler。使用这个handler可以remove这个绑定。
	]]
	bind = 
		function(self, event_name, handler_func)
			self._[event_name] = self._[event_name] or {}
			self._[event_name][handler_func] = true
			return {event_name, handler_func}
		end,
	trigger = 
		function(self, event_name, ...)
			local returnValue
			if not self._[event_name] then return end
			for func in pairs(self._[event_name]) do
				returnValue = func(...)
			end
			return returnValue
		end,
	remove = 
		function(self, handler)
			if self._[handler[1]] then
				self._[handler[1]][handler[2]] = nil
			end
		end,
	clear = 
		function(self)
			self._ = {}
		end,
}

return eventcenter

