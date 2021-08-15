extends Node2D

onready var sprite = get_node("Sprite")


var now_frame = 0
var end_frame
var last_anim_step
var anim_step_delt

var need_del = false
	

func load_preset(texture, preset):
	sprite.texture = texture
	sprite.vframes = preset[0]
	anim_step_delt = preset[2]
	scale = Vector2(preset[1], preset[1])
	end_frame = sprite.vframes - 1
	last_anim_step = OS.get_ticks_msec()
	sprite.frame = 0
	
func step():
	if OS.get_ticks_msec() - last_anim_step > anim_step_delt:
		now_frame += 1
		now_frame %= (end_frame + 1)
		sprite.frame = now_frame
		last_anim_step = OS.get_ticks_msec()
