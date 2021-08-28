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

var need_heal
var enemy_to_heal = null


func step(rays, now_anim, now_frame, site, healer):
	if now_anim != "heal" and enemy_to_heal != null:
		healer.sprite.change_anim("heal")
		object.spawn_enemy_heal(Main.heal_anim_pos, Main.heal_effect_preset, enemy_to_heal)
	need_heal = need_heal(rays, healer)
			
	last_anim = now_anim
	last_frame = now_frame
	
func healer_logic(pos, healer):
	if healer.sprite.get_anim() == "heal":
		return null
	enemy_to_heal = null
	var min_dist = 1000000000
	var target_pos = pos
	for enemy in healer.objects.enemy_list.get_children():
		if enemy == healer:
			continue
		if enemy.AI_script.hp < enemy.AI_script.max_hp and not enemy.is_healing:
			enemy_to_heal = enemy
			healer.track(enemy.get_global_position())
			if min_dist > healer.distance.length():
				target_pos = enemy.get_global_position()
	return target_pos

func need_heal(rays, healer):
	var enemy_contact = false
	for i in rays.get_children():
		if i.is_colliding() and i.get_collider() == healer.enemy_to_heal:
			enemy_contact = true
			speed = 0
	if enemy_contact:
		return true
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

