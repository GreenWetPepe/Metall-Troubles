extends Node2D

onready var sprite = get_node("Sprite")
onready var rays = get_node("Rays")

var now_frame = 0
var end_frame
var last_anim_step
var anim_step_delt
var power
var damage

var need_del = false

var list_of_obj = []

func _ready():
	sprite.frame = now_frame
	

func load_preset(pos, explosion_pres):
	transform.origin = pos
	last_anim_step = OS.get_ticks_msec()
	end_frame = Main.explosion_anim_preset[1]
	anim_step_delt = Main.explosion_anim_preset[2]
	scale = Vector2(explosion_pres[0], explosion_pres[0])
	power = explosion_pres[1]
	damage = explosion_pres[2]
	
	
func step():
	play_anim()
	for ray in rays.get_children():
		if ray.is_colliding():
			if "Player" in ray.get_collider().name or "Enemy" in ray.get_collider().name:
				if ray.get_collider().name in list_of_obj:
					continue
				ray.get_collider().get_hit(damage)
				list_of_obj.append(ray.get_collider().name)
				for rayy in rays.get_children():
					rayy.add_exception(ray.get_collider())
	
	
func play_anim():
	if OS.get_ticks_msec() - last_anim_step > anim_step_delt:
		if now_frame == end_frame:
			need_del = true
			return
		now_frame += 1
		sprite.frame = now_frame
		last_anim_step = OS.get_ticks_msec()
