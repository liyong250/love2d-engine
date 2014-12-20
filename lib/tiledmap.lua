local tm = {}
local tiles =  
function tm:load(tiledmap)
	-- load images
	local lasttile = {endIndex = 0}
	for _, tileset in ipairs(tiledmap.tilesets) do
		tileset.image = love.graphics.newImage(tileset.image)
		tileset.endIndex = (tileset.imagewidth / tileset.tilewidth)
			* (tileset.imageheight / tileset.tileheight)
			+ lasttile.endIndex
		lasttile = tileset
	end

	for _, layer in ipairs(tiledmap.layers) do
		layer.batchsprites = {}
		for _, tileset in ipairs(tiledmap.tilesets) do
			-- layer.batchsprites[]
		end
	end
end

function tm:draw(x, y)
	-- 
end

function tm:update(x, y)
	-- nothing now
end

return tm