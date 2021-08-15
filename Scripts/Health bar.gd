extends Node2D

var max_hp = Main.player_preset[0]

var last_heal = OS.get_ticks_msec()
var heal_delt = 20

var last_hit = OS.get_ticks_msec()
var hit_delt = 20

var end_frame

var now_frame

var list_of_actions = []
var list_of_time = []

func _ready():
	for i in range(0, Main.player_preset[0]):
		list_of_actions.append("ok")
		list_of_time.append(0)
		var sprite = Sprite.new()
		sprite.texture = load("res://Sprites/UI/hp/hp.png")
		end_frame = Main.hp_preset[0] - 1
		sprite.vframes = Main.hp_preset[0]
		sprite.scale = Vector2(Main.hp_preset[1], Main.hp_preset[1])
		sprite.frame = 0
		sprite.transform.origin = Vector2(i * Main.hp_preset[4] * Main.hp_preset[1], 0)
		add_child(sprite)

func get_hit(hp, dmg):
	var st_hp = clamp(hp - dmg, 0, max_hp)
	print(st_hp)
	for i in range(st_hp, hp):
		list_of_actions[i] = "broke"
		get_child(i).frame = 0
		list_of_time[i] = OS.get_ticks_msec()
	return st_hp

func heal(hp, heal):
	var end_hp = clamp(hp + heal, 0, max_hp)
	for i in range(hp, end_hp):
		list_of_actions[i] = "heal"
		get_child(i).frame = end_frame
	return end_hp
	
func step():
	for i in range(0, max_hp):
		if list_of_actions[i] == "broke":
			if get_child(i).frame == end_frame:
				list_of_actions[i] == "ok"
			elif OS.get_ticks_msec() - list_of_time[i] > hit_delt:
				get_child(i).frame += 1
				list_of_time[i] = OS.get_ticks_msec()
		elif list_of_actions[i] == "heal":
			if get_child(i).frame == 0:
				list_of_actions[i] == "ok"
			elif OS.get_ticks_msec() - list_of_time[i] > hit_delt:
				get_child(i).frame -= 1
				list_of_time[i] = OS.get_ticks_msec()
