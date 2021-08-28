extends Node

var object

var hp
var max_hp
var speed
var const_speed
var damage
var attack_speed

var attack_cooldown = Main.normal_enemy_attack_cooldown
var last_attack = 0

var last_frame = -1
var last_anim = "walk"

var need_attack
var need_rest = false

func step(rays, now_anim, now_frame, site):
	if now_anim != "attack" and last_anim == "attack":
		var ang = rays.transform.get_rotation()
		if site == "left":
			if ang >= 0:
				ang += (PI / 2 - ang) * 2
			else:
				ang -= (-PI / 2 + ang) * 2
		object.spawn_bullet(rays.get_global_position(), Vector2(cos(ang), sin(ang)), ang, Main.fireball_anim_pos, Main.fireball_preset, "fireball", false)
	need_attack = need_attack(rays)
			
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
