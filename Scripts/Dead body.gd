extends Node2D

var sprite
var frame

var texture
var frames_count
var now_frame
var end_frame
var anim_step_delt
var last_anim_step

func _ready():
	sprite = get_node("Sprite")
	sprite.texture = texture
	sprite.vframes = frames_count
	sprite.frame = now_frame

func load_preset(pos, texture, frames_count, anim_pres):
	transform.origin = pos
	self.texture = texture
	self.frames_count = frames_count
	now_frame = anim_pres[0]
	self.end_frame = anim_pres[1]
	anim_step_delt = anim_pres[2]
	last_anim_step = OS.get_ticks_msec()
	
func step():
	if now_frame != end_frame and OS.get_ticks_msec() - last_anim_step > anim_step_delt:
		now_frame += 1
		sprite.frame = now_frame
		last_anim_step = OS.get_ticks_msec()
