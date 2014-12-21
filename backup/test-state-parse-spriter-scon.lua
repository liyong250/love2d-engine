local Json = require("json")

local s = {}

local o = {}
function o:image(folder_id, file_id)
	local file = self.data.folder[folder_id + 1].file[file_id + 1]
	if type(file.name) == 'string' then
		file.name = love.graphics.newImage(self.dir .. file.name)
	end
	return file.name
end
function p(obj)
	print('-----------------------')
	for k,v in pairs(obj) do print(k,v) end
end
function o:drawCoord()
	local ww, wh = love.window.getDimensions()
	love.graphics.line(self.x, 0, self.x, wh)
	love.graphics.line(0, self.y, ww, self.y)
end

local tx, ty, ta = 0, 0, 0
function o:drawKey(index)
	self:drawCoord()

	local entity = self.data.entity[1]
	local anim = entity.animation[self.animIdx]
	local key = anim.mainline.key[index]
	for _, obj_ref in pairs(key.object_ref) do

		local bx, by, ox, oy = 0, 0, 0, 0 -- bone, object
		
		-- 获取Obj的信息
		local timeline_idx = tonumber(obj_ref.timeline) + 1
		local timeline_key_idx = tonumber(obj_ref.key) + 1
		local timeline = assert(anim.timeline[ timeline_idx ])
		local obj_key = timeline.key[ timeline_key_idx ].object

		-- 获取图片
		local img = self:image( obj_key.folder, obj_key.file )

		-- 计算obj的信息
		obj_key_angle = -math.rad(obj_key.angle or 0)
		ox = obj_key.x or 0
		oy = -(obj_key.y or 0)
		local ocx, ocy = img:getWidth() * (obj_key.pivot_x or 0), img:getHeight() * (obj_key.pivot_y or 0)

		-- 获取骨头的信息
		if obj_ref.parent then
			local bone_ref = key.bone_ref[ obj_ref.parent + 1 ]
			local bone_info = anim.timeline[ bone_ref.timeline + 1 ]
			local bone_key = bone_info.key[ bone_ref.key + 1]
			bone = bone_key.bone
			bone_angle = -math.rad(bone.angle or 0)
			bx = (bone.x or 0) + self.y
			by = -(bone.y or 0) + self.y
		else
			ox = ox + self.x
			oy = oy + self.y
		end


		-- 绘制

		canvas = canvas or love.graphics.newCanvas()
		canvas:clear()

		
		love.graphics.setCanvas(canvas)
		love.graphics.draw( img, 
			bx + ox, by + oy, obj_key_angle, 
			obj_key.scale_x or 1, obj_key.scale_y or 1,
			ocx, ocy
			)
		local ww, wh = love.window.getDimensions()
		love.graphics.rectangle('line', 2, 2, ww - 2, wh - 2)
		love.graphics.line(100, 100, bx + ox, bx + oy)
		love.graphics.line(0, 0, bx + ox + ocx, bx + oy + ocy)
		love.graphics.setCanvas()

		love.graphics.draw(canvas, 
			bx or 0, bx or 0, bone_angle or 0,
			bone and (bone.scale_x or 1), bone and (bone.scale_y or 1),
			by or 0, by or 0)
		love.graphics.line(0, 0, bx, by)
		love.graphics.print('!' .. bx .. ' ' .. by, 10, 10)

		love.graphics.setPointSize(10)
		love.graphics.point(100, 100, 100, 100)
	end
end
function s:enter()
	local contents, size = love.filesystem.read( 'player2/player.scon' )
	local data, pos, err = json.decode (contents, 1, nil)
	spr = {data = data}
	spr.dir = "player2/"
	spr.animIdx = 1
	spr.x = 200
	spr.y = 200
	setmetatable(spr, {__index = o})
end

dxc = .01
dx = dxc
function s:update(dt)
	ta = ta + dx
end

function s:mousepressed(x, y, k)
	if k == 'wd' then
		dx = dxc
	else
		dx = -dxc
	end
end

function s:draw()
	spr:drawKey(1)
end

return {test = s}
