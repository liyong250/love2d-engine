-- 用于获取只读表（这里的只读指不使用raw系列函数的情况下是只读的）
local const = {}
function const.MakeConstRecursively( tab) -- 使tab中的所有数据表（包括嵌套的表），而不是tab本身，变成只读表
	for k,v in pairs(tab) do
		if type(v) == "table" then
			tab[k] = const.MakeConst( v)
		end
	end
end
function const.forbideWrite(tab,key,value) -- used as tagged method: __newindex
	local quote = ''
	if type(value) == "string" then
		quote = '"'
	end
	error(string.format("const[%s]=%s%s%s : cannot modify constant table!", key, quote, tostring( value), quote))
end
function const.MakeConst(tab) -- 接口函数，用于将tab本身变成只读表
	local fakeTab= {}
	const.MakeConstRecursively( tab)
	tab.__index = tab
	tab.__newindex = const.forbideWrite
	setmetatable(fakeTab, tab)
	return fakeTab
end

return const.MakeConst
--[[
-- 测试用例
tab = {
	FULLSCREEN = true,
	VERSION = 5.1,
	APPNAME = "Yammy",
	SUFFIX = { "txt", "exe", OFFICE_SUFFIX={"doc","xls","ppt"}}
}
tab = const.MakeConst( tab) -- 得到tab表的const表
-- 测试表的正常功能（遍历表）
print(tab.VERSION)
print( tab.SUFFIX[1])
print( tab.SUFFIX.OFFICE_SUFFIX[1])
-- 测试结果：
	-- 可以通过索引访问数据。
	-- 但是无法正常遍历，只能强制进行metatable遍历才能看到其中的内容。其实平时使用表也不需要遍历的功能。
	-- 测试通过。
-- 一级读写测试
print(tab.VERSION)
tab.VERSION = 5.2
-- 测试结果： 测试通过
-- 二级读写测试
print( tab.SUFFIX[1])
tab.SUFFIX[1] = "xsl"
-- 测试结果： 测试通过
-- 三级读写测试
print( tab.SUFFIX.OFFICE_SUFFIX[1])
tab.SUFFIX.OFFICE_SUFFIX[1] = "docx"
print( tab.SUFFIX.OFFICE_SUFFIX[1])
-- 测试结果： 测试通过
]]
