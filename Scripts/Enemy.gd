extends KinematicBody2D

onready var sprite = get_node("Animated sprite")
onready var astar = get_parent().get_parent().get_parent().get_node("AStar")
onready var rays = get_node("Rays")
onready var body = get_node("Body")
onready var objects = get_parent().get_parent()

var rng = RandomNumberGenerator.new()

var AI_script
var angle
var velocity = Vector2()
var distance
var type
var site = "right"
var point

var ray_scale
var body_scale
var texture_scale

var anim_preset
var texture
var frames_count

var need_hit = false

var player_ang

var enemy_to_heal = null

var delete = false
var need_spawn = true
var is_dead = false

var is_shooted = false
var is_healing = false

var ang = 1.0

func _ready():
	if type == "mage" or type == "light" or type == "healer":
		AI_script.set_object_list(objects)
	
	rays.get_child(0).scale = Vector2(ray_scale, ray_scale)
	for ray in rays.get_children():
		ray.add_exception(self)
	body.scale = Vector2(body_scale, body_scale)
	sprite.load_preset(anim_preset, frames_count, texture)
	sprite.scale = Vector2(texture_scale, texture_scale)
	sprite.change_anim("walk")

func track(pos):
	distance = (pos - position)
	angle = distance.angle()
	
func step(pos):
	sprite.step()
	if type == "healer":
		print(sprite.now_frame)
	player_ang = (pos - position)
	player_ang.angle()
	if is_dead:
		play_anim()
		return
		
	if type == "healer":
		pos = AI_script.healer_logic(pos, self)
		
	astar.set_cellv(astar.world_to_map(get_global_position()), -1) #marking tiles fot AStar
	astar.add_walkable_exceptions(get_global_position(), false)
	if pos != null:
		point = astar.step(self.get_global_position(), pos)
		rays.look_at(pos)
	if type == "healer":
		AI_script.step(rays, sprite.get_anim(), sprite.now_frame, site, self)
	else:
		AI_script.step(rays, sprite.get_anim(), sprite.now_frame, site)
	if type != "healer": #Need attack?
		if AI_script.need_attack and sprite.get_anim() != "attack":
			sprite.change_anim("attack")
	else:
		if AI_script.need_heal and sprite.get_anim() != "heal":
			sprite.change_anim("heal")
	
		#if now_anim == "attack" and now_frame == end_frame and type == "mage":
		#	need_hit = true
	
	if point != null and len(point) > 1: #Next control point in path
		track(point[1])
		
	play_anim() #play anim
	if angle == null:
		velocity = move_and_slide(Vector2(0, 0))
	else:
		velocity = move_and_slide(Vector2(cos(angle), sin(angle)).normalized() * AI_script.speed)
	astar.set_cellv(astar.world_to_map(get_global_position()), 0) #Unmarking tiles
	astar.add_walkable_exceptions(get_global_position(), true)
	
func push_to_dir(dir):
	velocity = move_and_slide(dir * Main.bullet_power)
	
func play_anim():
	if not is_dead and distance != null:
		if site == "right" and distance.x < 0:
			transform.x *= -1
			site = "left"
		elif site == "left" and distance.x >= 0:
			transform.x *= -1
			site = "right"
		
	if (sprite.get_anim() == "attack" or sprite.get_anim() == "heal") and sprite.is_anim_ended:
		sprite.change_anim("walk")
		

#hp, speed, damage, attack speed
func load_preset(preset, anim_pres, type, AI_script):
	anim_preset = anim_pres
	var hp = preset[0]
	var speed = preset[1]
	var damage = preset[2]
	var attack_speed = preset[3]
	texture = load("res://Sprites/enemies/"+type+".png")
	ray_scale = preset[4]
	body_scale = preset[5]
	texture_scale = preset[6]
	frames_count = preset[7]
	self.type = type
	self.AI_script = AI_script
	AI_script.load_characteristics(speed, hp, damage, attack_speed)
	
func set_pos():
	rng.randomize()
	var x = rng.randi() % (Main.room_size[2] - Main.room_size[0]) + Main.room_size[0]
	var y = rng.randi() % (Main.room_size[3] - Main.room_size[1]) + Main.room_size[1]
	transform.origin = Vector2(x, y)
	
func get_hit(dmg):
	AI_script.hp -= dmg
	

#func _draw():
	#for ray in rays.get_children():
		#var start_pos = get_global_position()
		#var end_pos = Vector2(0, 0)
		#end_pos.x = start_pos.x + cos() * 60
		#end_pos.y = start_pos.y + sin(ray.transform.get_rotation()) * 60
		#draw_line(start_pos, end_pos, Color.red, 2.0, true)
		#print(ray.transform.get_rotation())
