-- 图片信息。添加png动画文件需要修改这里。
return {
	hero = {
		rows = 4,
		cols = 4,
		time = .1,
		anims = {
			down = {
				tiles = {'1-4', 1},-- 文件内部又分为多个动画。第一个动画的变量名是hero_down。
			},
			left = {
				tiles = {'1-4', 2},-- 第二个动画的变量名是"hero_left"，即“文件名_动画名”
			},
			up = {
				tiles = {'1-4', 3},
			},
			right = {
				tiles = {'1-4', 4}
			},
		},
	},
	light = {rows = 1, cols = 4, time = .02, tiles = {'1-3', 1}},
}
