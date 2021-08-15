extends Node2D

onready var camera = get_node("Camera")
onready var player = get_node("Player")
onready var objects = get_node("Objects")
onready var room = get_node("Room")
onready var gun = get_node("Player/Gun")

onready var hp = get_node("Camera/UI/Health bar")

func _ready():
	pass

func _physics_process(_delta):
	hp.step()
	player.step()
	camera.set_pos(player.position)
	objects.step(player.position)
	var enemies_to_spawn = room.step(objects.get_enemyies_count())
	if enemies_to_spawn != null:
		objects.spawn_enemies(enemies_to_spawn)
	
func _input(event):
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_ESCAPE):
			get_tree().quit()
			
		if Input.is_key_pressed(KEY_N):
			player.hp = hp.get_hit(player.hp, 1)
		elif Input.is_key_pressed(KEY_M):
			player.hp = hp.heal(player.hp, 1)
			

