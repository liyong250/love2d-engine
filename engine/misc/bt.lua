
local BT = {}
local obj

-- 1、调用前保证BT中的函数全部都在obj表中
-- 2、假设输入合法
function BT.run(bt, object)
	obj = object
	local first_children = bt.nodes[1].children[1]
	BT[first_children.type](first_children)
end

-- Composite Node
-- Selector
function BT.Selector(node)
	local return_value = false
	for _, child in ipairs(node.children) do
		if BT[child.type](child) == true then
			return_value = true
			break
		end
	end
	return return_value
end
-- Sequence
function BT.Sequence(node)
	local return_value = true
	for _, child in ipairs(node.children) do
		if BT[child.type](child) == false then
			return_value = false
			break
		end
	end
	return return_value
end

-- Behaviour Node
-- Action
function BT.Action(node)
	obj[node.func]()
	return true
end
-- Condition Action
function BT.Condition(node)
	if obj[node.name]() then
		obj[node.func]()
		return true
	else
		return false
	end
end

-- Decorator Node
-- Yet nothing ...

-- Condition Node
-- Filter
function BT.Filter(node)
	if obj[node.func]() then
		local first_children = node.children[1]
		BT[first_children.type](first_children)
		return true
	else
		return false
	end
end

return BT