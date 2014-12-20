local text
local frame
local function CreateMsgBox(msg, caption)
	frame = loveframes.Create("frame")
	frame:SetName(caption or "")
	frame:Center()
	frame:SetDockable(true)
	frame:ShowCloseButton(false)
		:SetSize(400, 200)
	         
	text = loveframes.Create("text", frame)
	text:SetText(msg or 'default')
	text.Update = function(object, dt)
	    object:CenterX()
	    object:SetY(40)
	end
end
-------------------------------------------------
local pre = {}
local lastKeyPressed

function pre:load()
end
function pre:draw()
	pre.lastState:draw()
end
function pre:enter(lastState, message, title, ...)
	CreateMsgBox("message")
	pre.lastState = lastState
	pre.extra = {...}
	Lume.trace(lastState)
	text:SetText(message, title)
	frame:SetModal(true)
end
function pre:leave(dt)
	frame:SetModal(false)
	frame:Remove()
end
function pre:keypressed(key)
	GameState.switch(pre.lastState, key, unpack(pre.extra))
end
function pre:resize(w, h)
	if frame then 
		frame:SetModal(false)
		frame:SetModal(true)
		frame:Center() 
	end
end

return {msgbox = pre}
