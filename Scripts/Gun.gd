extends Node2D

onready var sprites = get_node("shoot_sprite")
onready var objects = get_parent().get_parent().get_node("Objects")
onready var audio = get_node("AudioStreamPlayer")

var angle = transform.get_rotation()
var anim_speed
var frames_count
var now_frame = 0
var frame_size
var anim_step_time
var gun_accuracy
var fire_rate
var bullets_count
var last_shoot = 0
var anim_last_step = OS.get_ticks_msec()
var shooted = false
var rng = RandomNumberGenerator.new()

var bullet_preset
var bullet_anim_preset


#bullet count, bullet speed, bullet range, accuracy, fire speed, damage, frames count, frame size
func load_preset(name):
	sprites.texture = load("res://Sprites/guns/"+name+".png")
	var preset = Main.get_preset(name+"_preset")
	bullet_preset = Main.get_preset(name+"_bullet_preset")
	bullet_anim_preset = Main.get_preset("bullet_anim_pos")
	bullets_count = preset[0]
	gun_accuracy = preset[1]
	fire_rate = preset[2]
	anim_step_time = preset[3] / preset[4]
	frames_count = preset[4]
	
func step():
	angle = transform.get_rotation()
	anim_step()
	
func anim_step():
	if not shooted and now_frame == 0:
		return
	if OS.get_ticks_msec() - anim_last_step > anim_step_time:
		if now_frame == frames_count - 1:
			shooted = false
		now_frame = (now_frame + 1) % frames_count
		sprites.frame = now_frame
		anim_last_step = OS.get_ticks_msec()
		
func shoot():
	if now_frame == 0 and not shooted and OS.get_ticks_msec() - last_shoot > fire_rate and OS.get_ticks_msec() - anim_last_step > anim_step_time:
		shooted = true
		last_shoot = OS.get_ticks_msec()
		for _i in range(0, bullets_count):
			rng.randomize()
			var ang = angle + rng.randf_range(-gun_accuracy, gun_accuracy)
			var bul_pos = global_position
			bul_pos.x += sprites.texture.get_size().x / 5 * cos(ang) + 5 * cos(ang) #ЭТО ТАКОЙ КАСТЫЛЬ(ПРОСТО НЕЧТО)
			bul_pos.y += 5 * sin(ang) + sprites.texture.get_size().x / 5 * sin(ang) #БЛ***
			#audio.play()
			objects.spawn_bullet(bul_pos, Vector2(cos(ang), sin(ang)), ang, bullet_anim_preset, bullet_preset, "bullet", true)
	

