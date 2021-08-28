extends Node

var object

var hp
var max_hp
var speed
var const_speed
var damage
var attack_speed

var last_frame = -1
var last_anim = "walk"

var need_attack
var need_rest = false

var is_expoded = false

func step(rays, now_anim, now_frame, site):
	need_attack = need_attack(rays)
			
	if (need_attack and not is_expoded) or (hp <= 0 and not is_expoded):
		object.spawn_explosion(rays.get_global_position(), Main.light_enemy_explosion)
		is_expoded = true
		
		
	last_anim = now_anim
	last_frame = now_frame
	
#func spawn_bullet(pos, dir, ang, anim_preset, preset, type, is_friendly)
func need_attack(rays):
	var player_contact = false
	for i in rays.get_children():
		if i.is_colliding() and i.get_collider().name == "Player" and not need_rest:
			player_contact = true
			speed = 0
	if player_contact:
		return true
	if speed == 0:
		speed = const_speed
	return false
	

func load_characteristics(speed, hp, damage, attack_speed):
	self.speed = speed
	self.hp = hp
	max_hp = hp
	self.damage = damage
	self.attack_speed = attack_speed
	const_speed = speed

func set_object_list(object):
	self.object = object
