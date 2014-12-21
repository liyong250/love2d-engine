love2d-engine
=============

基于love2d的游戏功能集成
anim
"动画支持。详见Anim8"
{
	shine()
	{
		drawable 一个有draw函数的table
		colors 颜色列表，例如{{r1,g1,b1,a1}, {r2,g2,b2,a2}, ...}
		finalFunc(nil) 闪烁结束后会被调用的函数
		duration(0.1): 每个这么多秒回改变一次颜色
		totalSeconds(1): 总共经历这么多秒后动画结束
		finalFuncParam(nil): 会被传递给finalFunc的参数
	}
	loadAnims()
	{
		path 例如'path/to/png/files'
		pngInfo 参考data/pnginfo.lua中的注释
	}
}

anim.animGroup
"动画的集合，例如人物的所有动作"
{
	new()
	{
		curAnimName 初始动画名称，必须在动画集合中存在
		allAnims 动画集合，格式为 {'name1' = AnimObject, 'name2' = AnimObject2, ...}
	}
	setCurrent()
	{
		animName 动画名称
	}
	draw()
	{
		x x坐标
		y y坐标
		... 其他参数，同love.graphics.draw
	}
	update()
	{
		dt
	}
	getWidth()
	{

	}
	getHeight()
	{

	}
}


anim.trans
"转场动画的实现"

anim.trans.dots
"点动画"
{
	new(callback, showScene, speed, color)
	{
		callback(nil) will be called when the transition is over
		showScene(true) determines whether the transition should show the scene or hide it
		speed(200) determines how fast the transition is
		color({0,0,0,255}) is the color to mask the scene
	}
	revert()
	{
		"遮盖场景动画/显示场景动画之间的转换，同时启动动画"
	}
}

b

camera
"相机的实现"
{
	new(x, y, zoom, rotation)
	{
		xy(screen_center)
		zoom(1)
		rotation(0)
	}
	lookAt(x, y)
	{
		"将屏幕中心移动到世界坐标(x,y)处"
	}
	pos()
	beginScene()
	{

	}
	endScene()
	{

	}
	worldCoords(x, y)
	{
		"Convert screen coords to world coords"
	}
	cameraCoords(x, y)
	{
		"Convert world coords to screen coords"
	}
}

d

entity
"Entity framework"
{
	MakeEntity()
	{
		"从一个组件列表和初始化函数来创建一个实体"
		coms(nil) 组件列表，列出所需组件名称。可视组件将按照表中的顺序进行绘制。
		init(nil) 初始化函数，将在组件添加完成后调用。参数是已经生成的实体entity
		{
			// 包含如下函数
			com
			rmcom
			rmcoms
			draw
			update
			bindattr
			listen
			attr
			emit
			togglePause
			// 包含如下成员（仅内部使用）
			_com
			_vcom
			_attr
			_event
			// init的返回值被忽略，所以不需要返回值
			return nil
		}
		getcoms()
		{
			"获取当前实体的所有组件的列表。组件存储形式为 组件名 => 组件。"
		}
	}
}

f
g
h

i

j
k

level
"a place to manage your game level"
{
	cur()
	{
		"return current level index"
	}
	cur( newLevel )
	{
		"set the parameter as new level value"
	}
	next()
	{
		"goto next index. return false if no avaliable index"
	}
	hasNext()
	{
		"return true if current level is not the last one"
	}
}

math
"在lua原有数学库的基础上进行了扩展"
{
	vector/pos
	{
		"向量运算的支持。详见hump.vector"
	}
}

n
o
p
q
r

signal
"callback design pattern support."
{
	new()
	{

	}
	trigger(eventName, ...)
	{

	}
	bind(eventName, func)
	{
		"返回一个Handler"
		return 传递给remove函数，以便解除绑定的func
	}
	remove(handler)
	{

	}
	clear()
	{
		"清除绑定的所有signal"
	}
}


state
"game state manager"
"refer to GameState lib's wiki for more details"

static
"static visual"
{
	new(drawable, scale, rotation)
	{
		drawable 图片文件路径，或者可以被传递draw函数的图片对象
		scale(1)
		rotation(0)
	}
	draw(x, y)
	{

	}
	loadImage(result_table, file_full_name, file_short_name)
	{
		载入图片的函数。如果图片存在同名的lua文件，则认为该文件为信息文件，并进行解析。该文件的格式为：
			return 
			{
				abandon_origin = true,	// 如果为true，则 result[ file_short_name ] = nil。否则，其中存放完整图片。
				n_row = 4,	// 如果大图由多个小图组成，则定义这些小图的行列数。存放在 result[ file_short_name .. "_part" ]表中，按照行列号命名，例如2行3列的小图为 r2c3
				n_col = 4,
				rects = // 如果大图由多个不规则小图组成，则分别进行定义
				{
					a = {x, y, w, h},	// 该小图存放到 result[ file_short_name .. "_part" ][ a ] 中
					b = {x, y, w, h},	
				}
			}
	}
}


storage
"读取和存储"
{
	serialize( table )
	{
		"serialize a table into a string"
	}
	save( key, table )
	{
		"save the table into a file"
	}
	load( key )
	{
		"load the table that function 'save' saved"
		return save之前按照key保存在硬盘上的table
	}
}


tmap
"Tiled map handler
Refer to ATL lib for more details..."
{	
	path 
	{
		"the folder for love.tmap to load maps from"
	}
	load(filename) 
	{
		"load 'filename.tmx' from the specified path"
		return Map对象
		{		
			draw()
			update(dt)
		}
	}
}

timer
"时间相关功能的实现。参考hump.timer"
{

}


ui
"advanced GUI.
refer to Loveframes lib's wiki for more detailss"
{
	CreateForState( stateName, ...)
	{
		"create an ui object into a certain state. other parameters are the same the those of loveframes' create function"
	}
	Create(...)
	{
		"创建一个当前状态可见的UI控件"
	}
}

util
"some useful utility functions for game programming.
refer to Lume's wiki for more information"
{
	makeConst( table )
	{
		"make the table cannot be modified anymore"
	}
	loadDirectoryFiles()
	{
		"载入指定文件夹下指定类型的所有文件"
		path
		file_types 例如 {'txt', 'wav', 'lua'}
		loader 函数，参数为(filename, short_name, extension)，用来处理需要发现的某个文件。返回载入的结果。
		return 返回一个table，记录下loader对所有文件的载入结构。
		{
			short_name1 = loader(filename1, short_name1, extension1),
			short_name2 = loader(filename2, short_name2, extension2),
			...
		}
	}
	requirePath()
	{
		"将参数字符串中的/转换成."
	}
	libPath()
	{
		"将参数字符串中的.转换成/"
	}
}

v
w

x
y
z


