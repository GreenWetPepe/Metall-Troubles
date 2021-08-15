extends Node2D

onready var sprite = get_node("Animated sprite")
onready var arena = get_node("Area2D")

var speed
var damage
var power
var attack_delay
var fire_time
var ang

var last_attack = 0
var fire_start_time = 0

var y_explosion

var frames_count
var anim_preset

var firing = false
var need_del = false

func _ready():
	sprite.vframes = frames_count
	sprite.load_anim_preset(anim_preset)
	sprite.change_anim("fly")
	
func step():
	if OS.get_ticks_msec() - last_attack > attack_delay:
		for body in arena.get_overlapping_bodies():
			if "Enemy" in body.name:
				body.get_hit(damage)
		last_attack = OS.get_ticks_msec()
	sprite.step()
	if sprite.get_anim() == "fly":
		position = Vector2(position.x - speed * cos(ang), position.y - speed * sin(ang))
	if firing and OS.get_ticks_msec() - fire_start_time > fire_time:
		need_del = true
	
	if sprite.get_anim() == "fly" and get_global_position().y >= y_explosion:
		sprite.change_anim("hit")
	
	if sprite.get_anim() == "hit" and sprite.is_anim_ended:
		sprite.change_anim("fire")
		rotation_degrees = 0
		firing = true
		fire_start_time = OS.get_ticks_msec()
	

func load_preset(preset, anim_pres, pos, ang, path_len):
	speed = preset[0]
	damage = preset[1]
	power = preset[2]
	attack_delay = preset[3]
	fire_time = preset[4]
	frames_count = preset[5]
	y_explosion = pos.y
	self.ang = ang
	scale = Vector2(preset[6], preset[6])
	position = Vector2(pos.x + cos(ang) * path_len, pos.y + sin(ang) * path_len)
	anim_preset = anim_pres
