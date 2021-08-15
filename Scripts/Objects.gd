extends Node2D

onready var enemy_list = get_node("Enemy list")
onready var bullet_list = get_node("Bullet list")
onready var corpse_list = get_node("Corpse list")
onready var enviroment_list = get_node("Enviroment list")
onready var decorate_enviroment_list = get_node("Decorate enviroment list")
onready var ulti_list = get_node("Decorate enviroment list/Ultimate bullet list")
onready var explosion_list = get_node("Explosion list")
onready var player = get_parent().get_node("Player")
onready var tilemap = get_parent().get_node("AStar")

onready var NORMAL_ENEMY = preload("res://Scripts/Normal enemy.gd")
onready var LIGHT_ENEMY = preload("res://Scripts/Light enemy.gd")
onready var MAGE_ENEMY = preload("res://Scripts/Mage enemy.gd")

onready var BULLET = preload("res://Scenes/Bullet.tscn")
onready var ENEMY = preload("res://Scenes/Enemy.tscn")
onready var CORPSE = preload("res://Scenes/Dead body.tscn")
onready var EXPLOSION = preload("res://Scenes/Explosion.tscn")
onready var ULTI_BUL = preload("res://Scenes/Ultimate bullet.tscn")

onready var TORCH_TEX = load("res://Sprites/torch.png")


func _ready():
	for enemy in enemy_list.get_children():
		player.add_collision_exception_with(enemy)
	mark_object()
	
	for list in decorate_enviroment_list.get_children():
		if list.name == "Torches list":
			for torch in list.get_children():
				torch.load_preset(TORCH_TEX, Main.torch_preset)
	

func mark_object():
	for enviroment in enviroment_list.get_children():
		tilemap.set_cellv(tilemap.world_to_map(enviroment.get_global_position()), 0)
		tilemap.add_walkable_exceptions(enviroment.get_global_position(), true)
	#for enemy in enemy_list:
	#	tilemap.set_cellv(tilemap.world_to_map(enemy.get_global_position()), 0)
	#	tilemap.add_walkable_exceptions(enemy.get_global_position(), true)
	
func step(player_pos):
	for enemy in enemy_list.get_children(): #Work with enemy_list
		enemy.step(player_pos)
		if enemy.need_hit:
			player.get_hit() 
			enemy.need_hit = false
		if enemy.AI_script.hp <= 0 and not enemy.is_dead: # Add corpse if enemy dead
			enemy.sprite.change_anim("dead")
			enemy.is_dead = true
			spawn_corpse(enemy)
	for bullet in bullet_list.get_children(): #Work with bullet_list
		bullet.step()
		if bullet.need_del:
			bullet_list.remove_child(bullet)
	for explosion in explosion_list.get_children(): #Work with explosion_list
		explosion.step()
		if explosion.need_del:
			explosion_list.remove_child(explosion)
	for env_list in decorate_enviroment_list.get_children():
		for decoration in env_list.get_children():
			decoration.step()
			if decoration.need_del:
				env_list.remove_child(decoration)
	for corpse in corpse_list.get_children():
		corpse.step()

func spawn_bullet(pos, dir, ang, anim_preset, preset, type, is_friendly):
	var bullet = BULLET.instance()
	bullet.transform.origin = pos
	bullet.rotate(ang)
	bullet.set_parameters(dir, anim_preset, preset, type)
	bullet_list.add_child(bullet)
	if not is_friendly:
		for enemy in enemy_list.get_children():
			bullet.add_collision_exception_with(enemy)
	else:
		bullet.add_collision_exception_with(player)
	for bul in bullet_list.get_children():
		bullet.add_collision_exception_with(bul)


func spawn_enemies(enemies_types):
	for i in enemies_types[0]: #heavy
		var enemy = ENEMY.instance()
		enemy.set_pos()
		enemy.load_preset(Main.heavy_enemy_preset, Main.heavy_enemy_anim_pos, "heavy", NORMAL_ENEMY.new())
		enemy_list.add_child(enemy)
	for i in enemies_types[1]: #normal
		var enemy = ENEMY.instance()
		enemy.set_pos()
		enemy.load_preset(Main.normal_enemy_preset, Main.normal_enemy_anim_pos, "normal", NORMAL_ENEMY.new())
		enemy_list.add_child(enemy)
	for i in enemies_types[2]: #light
		var enemy = ENEMY.instance()
		enemy.set_pos()
		enemy.load_preset(Main.light_enemy_preset, Main.light_enemy_anim_pos, "light", LIGHT_ENEMY.new())
		enemy_list.add_child(enemy)
	for i in enemies_types[3]: #healer
		var enemy = ENEMY.instance()
		enemy.set_pos()
		enemy.load_preset(Main.healer_enemy_preset, Main.healer_enemy_anim_pos, "healer", NORMAL_ENEMY.new())
		enemy_list.add_child(enemy)
	for i in enemies_types[4]: #gunslinger
		var enemy = ENEMY.instance()
		enemy.set_pos()
		enemy.load_preset(Main.mage_enemy_preset, Main.mage_enemy_anim_pos, "mage", MAGE_ENEMY.new())
		enemy_list.add_child(enemy)
	pass
	
func spawn_corpse(enemy):
	var corpse = CORPSE.instance()
	corpse.load_preset(enemy.get_global_position(), enemy.texture, enemy.frames_count, enemy.sprite.get_anim_preset())
	corpse_list.add_child(corpse)
	enemy_list.remove_child(enemy)

func spawn_explosion(pos, exp_pres):
	var explosion = EXPLOSION.instance()
	explosion.load_preset(pos, exp_pres)
	explosion_list.add_child(explosion)
	
func spawn_ulti_bul(preset, anim_pres, pos, ang, path_len):
	var ulti_bul = ULTI_BUL.instance()
	ulti_bul.load_preset(preset, anim_pres, pos, ang, path_len)
	ulti_bul.rotate(ulti_bul.ang)
	ulti_list.add_child(ulti_bul)
	
func collision_exceptions(enemy):
	for i in enemy_list.get_children():
		enemy.add_collision
		
func get_enemy(id):
	return enemy_list.get_child(id)
	
func get_enemyies_count():
	return enemy_list.get_child_count()
