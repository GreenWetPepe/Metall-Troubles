extends Sprite

var anim_preset
var now_anim = null
var start_frame
var end_frame
var anim_step_delay
var last_anim_step = OS.get_ticks_msec()
var now_frame

var is_anim_ended = false
var is_anim_looped

var repeat_count = null
var now_repeat = 0

func step():
	if OS.get_ticks_msec() - last_anim_step > anim_step_delay:
		if now_frame == end_frame and (not is_anim_looped or repeat_count != null and repeat_count == now_repeat):
			is_anim_ended = true
			return
		if is_anim_looped and now_frame == end_frame:
			now_repeat += 1
		now_frame += 1
		now_frame = (now_frame - start_frame) % (end_frame - start_frame + 1) + start_frame
		frame = now_frame
		last_anim_step = OS.get_ticks_msec()


func change_anim(name):
	if now_anim == name:
		return
	for anim in anim_preset:
		if name in anim:
			now_anim = anim[0]
			start_frame = anim[1]
			end_frame = anim[2]
			now_frame = start_frame
			anim_step_delay = anim[3]
			if name in Main.list_of_looped_anims:
				is_anim_looped = true
			else:
				is_anim_looped = false
			frame = now_frame
			is_anim_ended = false
			last_anim_step = OS.get_ticks_msec()

func load_preset(preset, frames, img):
	anim_preset = preset
	texture = img
	vframes = frames

func set_scale(scl):
	scale = Vector2(scl, scl)

func load_anim_preset(preset):
	anim_preset = preset
	
func set_repeat_count(count):
	repeat_count = count

func get_anim():
	return now_anim
	
func get_anim_preset():
	return [start_frame, end_frame, anim_step_delay]
