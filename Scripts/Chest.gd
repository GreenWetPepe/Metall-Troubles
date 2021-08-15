extends Node2D

onready var sprite = get_node("Animated sprite")
onready var rays = get_node("Rays")

var is_chest_opened = false
var is_loot_generated = false


func _ready():
	sprite.load_anim_preset([["open", 0, 4, 150]])
	

func step():
	if sprite.get_anim() != null:
		sprite.step()
	if not is_chest_opened:
		for ray in rays.get_children():
			if ray.is_colliding() and ray.get_collider().name == "Player" and ray.get_collider().need_open_chest:
				sprite.change_anim("open")
				is_chest_opened = true
				break
	else:
		if not is_loot_generated and sprite.is_anim_ended:
			generate_loot()
	
	
func generate_loot():
	is_loot_generated = true
	pass
