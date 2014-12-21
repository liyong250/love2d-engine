-- love2d的arc函数画出来的实际上是一个饼图
love.graphics.pie = love.graphics.arc

-- 真正的arc！
function love.graphics.arc(x, y, r, a1, a2, segment)
     -- 根据半径和角度大小默认分段数
     segment = segment or (0.2 * r + 10) * (math.abs(a1 - a2) / (math.pi * 2))

     local aps = (a2 - a1) / segment -- aps = angle per segment
     local coords = {}
     for a = a1, a2, aps do
          local cx, cy = x + r * math.cos(a), y + r * math.sin(a) -- ncx = next cx
          table.insert(coords, cx)
          table.insert(coords, cy)
     end
     local cx, cy = x + r * math.cos(a2), y + r * math.sin(a2) -- ncx = next cx
     table.insert(coords, cx + .00001)
     table.insert(coords, cy + .00001)

     love.graphics.line(coords)
end