extends Node

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

var player

func step(rays, now_anim, now_frame, site):
	need_attack = need_attack(rays)
	if now_anim == "attack" and last_frame != now_frame:
		speed += speed / 8
	elif now_anim != "attack" and last_anim == "attack":
		if need_attack:
			player.get_hit(damage)
		last_attack = OS.get_ticks_msec()
	
	if OS.get_ticks_msec() - last_attack < attack_cooldown:
		need_rest = true
		speed = 0
	else:
		if speed == 0:
			need_rest = false
			speed = const_speed
		
			
	last_anim = now_anim
	last_frame = now_frame
	
	
func need_attack(rays):
	var player_contact = false
	for i in rays.get_children():
		if i.is_colliding() and i.get_collider().name == "Player" and not need_rest:
			player_contact = true
			player = i.get_collider()
	if player_contact:
		return true
	return false
	

func load_characteristics(speed, hp, damage, attack_speed):
	self.speed = speed
	self.hp = hp
	max_hp = hp
	self.damage = damage
	self.attack_speed = attack_speed
	const_speed = speed
	
