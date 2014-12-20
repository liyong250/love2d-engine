local function LightMergeTable(out_tab, tab)
	if type(tab) == "table" then
		for k, v in pairs(tab) do
			if out_tab[k] == nil and k ~= "__index"  then
				out_tab[k] = v
			end
		end
	end
end
local function new( self, ...)
	local obj = {}
	LightMergeTable(obj, self)
	setmetatable(obj, self)
	if self.init then
		self.init( obj, ...);
	end
	return obj
end
function Class(param1, param2)
	-- parameters check
	if param1 == nil then
		return false
	end
	-- decide which is members, which is fathers
	local cls, fathers
	if param2 == nil then
		cls = param1
	else
		cls = param2
		fathers = param1
	end
	-- Setup class object 
	cls.new = new
	if fathers and type(fathers) == 'table' then
		for _,father in pairs(fathers) do
			LightMergeTable(cls, father)
		end
	end
	cls.__index = cls
	cls.__call = new
	return cls;
end

return Class
-- Ê¹ÓÃÊ¾Àý
--[[
Class = require('class')
person = Class({
		init = function( self, _name, _age)
				self.name = _name or "Person"
				self.age = _age or 3
			end,
		__eq = function( p1, p2)
				if p1.age == p2.age then
					return true
				else
					return false
				end
			end,
	}
)
worker = Class({
		init = function( self, name)
				person.init( self, name, 18)
			end
	},
	{
		person
	}
)
p1 = worker:new("Billy")
p2 = worker:new()
print(p1.name, p1.age)
print(p2.name, p2.age)


cls = Class(
{
	a = {"liyong"},
	b = {},
	c = nil,
})
obj = cls:new()
table.insert(obj.a, " is a dou bi!")
for _, v in ipairs(obj.a) do
	print(v)
end
for _, v in ipairs(cls.a) do
	print(v)
end
]]
--[[
-- another example
person = Class
{
	init = function(self, init_name)
			self.name = init_name
		end,
	job = "no job",
}

xm = person:new("Xiao Ming")
print(xm.name)
print(xm.job)
police = Class({person},
{
	init = function(self)
			person.init(self, "I'm polie")
		end,
	job = "Police",
})
po = police:new()
print(po.name)
print(po.job)
namesetter = Class
{
	setname = function(self)
			self.name = "NewOfficer"
		end,
}
officer = Class({police, namesetter}, {})
of = officer:new()
print(of.name)
print(of.job)
of:setname()
print(of.name)
print(of.job)
]]
