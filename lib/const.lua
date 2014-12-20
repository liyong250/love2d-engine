-- ���ڻ�ȡֻ���������ֻ��ָ��ʹ��rawϵ�к������������ֻ���ģ�
local const = {}
function const.MakeConstRecursively( tab) -- ʹtab�е��������ݱ�����Ƕ�׵ı���������tab�������ֻ����
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
function const.MakeConst(tab) -- �ӿں��������ڽ�tab������ֻ����
	local fakeTab= {}
	const.MakeConstRecursively( tab)
	tab.__index = tab
	tab.__newindex = const.forbideWrite
	setmetatable(fakeTab, tab)
	return fakeTab
end

return const.MakeConst
--[[
-- ��������
tab = {
	FULLSCREEN = true,
	VERSION = 5.1,
	APPNAME = "Yammy",
	SUFFIX = { "txt", "exe", OFFICE_SUFFIX={"doc","xls","ppt"}}
}
tab = const.MakeConst( tab) -- �õ�tab���const��
-- ���Ա���������ܣ�������
print(tab.VERSION)
print( tab.SUFFIX[1])
print( tab.SUFFIX.OFFICE_SUFFIX[1])
-- ���Խ����
	-- ����ͨ�������������ݡ�
	-- �����޷�����������ֻ��ǿ�ƽ���metatable�������ܿ������е����ݡ���ʵƽʱʹ�ñ�Ҳ����Ҫ�����Ĺ��ܡ�
	-- ����ͨ����
-- һ����д����
print(tab.VERSION)
tab.VERSION = 5.2
-- ���Խ���� ����ͨ��
-- ������д����
print( tab.SUFFIX[1])
tab.SUFFIX[1] = "xsl"
-- ���Խ���� ����ͨ��
-- ������д����
print( tab.SUFFIX.OFFICE_SUFFIX[1])
tab.SUFFIX.OFFICE_SUFFIX[1] = "docx"
print( tab.SUFFIX.OFFICE_SUFFIX[1])
-- ���Խ���� ����ͨ��
]]
