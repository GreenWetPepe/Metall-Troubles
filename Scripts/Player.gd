extends KinematicBody2D

onready var gun = get_node("Gun")
onready var rays = get_node("Rays")
onready var sprite = get_node("Animated sprite")
onready var health_bar = get_parent().get_node("Camera/UI/Health bar")

onready var objects = get_parent().get_node("Objects")

var rng = RandomNumberGenerator.new()

var hp
var speed

var last_time_walk = 0
var delt_to_stay = 100
var want_to_stay = false

var last_ulti_bull_spawn = 0
var delt_ulti_bull_spawn
var is_ulti = false
var spawned_ulti_bull_count = 0

var now_weapon_id = 1

var last_time_undamage = OS.get_ticks_msec()
var undamage_delt = 700

var velocity = Vector2()
var angle = 0.0

var is_pressed = 0

var gun_pose = "right"

func _ready():
	hp = Main.player_preset[0]
	speed = Main.player_preset[1]
	delt_ulti_bull_spawn = Main.ultimate_preset[3]
	gun.load_preset(Main.weapon_list[now_weapon_id])
	sprite.load_preset(Main.player_anim_pos, Main.player_preset[2], load("res://Sprites/Hero.png"))
	sprite.change_anim("stay")

func _input(event):
	if event is InputEventKey:
		velocity = Vector2(0, 0)
		if Input.is_key_pressed(KEY_D):
			velocity.x += 1
		if Input.is_key_pressed(KEY_A):
			velocity.x -= 1
		if Input.is_key_pressed(KEY_S):
			velocity.y += 1
		if Input.is_key_pressed(KEY_W):
			velocity.y -= 1
		if Input.is_key_pressed(KEY_SPACE):
			sprite.change_anim("ultimate")
			gun.visible = false
		if sprite.get_anim() == "ultimate":
			velocity = Vector2(0, 0)
		velocity = velocity.normalized() * speed
	
	if event is InputEventMouseMotion:
		set_gun_angle()
		
	if event is InputEventKey:
		if velocity != Vector2(0, 0):
			sprite.change_anim("walk")
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			is_pressed = (is_pressed + 1) % 2
		elif event.button_index == BUTTON_WHEEL_DOWN:
			now_weapon_id = (now_weapon_id - 1) % len(Main.weapon_list)
			gun.load_preset(Main.weapon_list[now_weapon_id])
		elif event.button_index == BUTTON_WHEEL_UP:
			now_weapon_id = (now_weapon_id + 1) % len(Main.weapon_list)
			gun.load_preset(Main.weapon_list[now_weapon_id])
			
func play_anim():
	if gun_pose == "left" and abs(angle) <= PI / 2 - PI / 6:
		gun_pose = "right"
		gun.position.x *= -1
		gun.transform.x *= -1
		sprite.transform.x *= -1
		set_gun_angle()
	if gun_pose == "right" and abs(angle) > PI / 2 + PI / 6:
		gun_pose = "left"
		gun.position.x *= -1
		gun.transform.x *= -1
		sprite.transform.x *= -1
		set_gun_angle()
		
	if velocity == Vector2(0, 0) and !want_to_stay:
		want_to_stay = true
		last_time_walk = OS.get_ticks_msec()
	if velocity != Vector2(0, 0):
		want_to_stay = false
	if want_to_stay and sprite.get_anim() != "ultimate":
		if OS.get_ticks_msec() - last_time_walk >= delt_to_stay:
			sprite.change_anim("stay")
	
	
	if sprite.get_anim() == "ultimate" and sprite.is_anim_ended:
		sprite.change_anim("stay")
		is_ulti = true
		spawned_ulti_bull_count = 0
		gun.visible = true
	
	
func step():
	sprite.step()
	if is_pressed and sprite.get_anim() != "ultimate":
		gun.shoot()
	if is_ulti:
		ultimate()
	gun.step()
	move()
	play_anim()
	
func get_hit(dmg):
	if OS.get_ticks_msec() - last_time_undamage > undamage_delt:
		last_time_undamage = OS.get_ticks_msec()
		hp = health_bar.get_hit(hp, dmg)
			
func set_gun_angle():
	gun.look_at(get_global_mouse_position() + Main.cursor_size / 2)
	angle = gun.transform.get_rotation()


func move():
	velocity = move_and_slide(velocity)
	
func ultimate():
	if OS.get_ticks_msec() - last_ulti_bull_spawn < delt_ulti_bull_spawn:
		return
	spawned_ulti_bull_count += 1
	if Main.ultimate_preset[0] == spawned_ulti_bull_count:
		is_ulti = false
	rng.randomize()
	var pos = Main.ultimate_preset[2]
	var x = rng.randi_range(position.x - pos.x, position.x + pos.x)
	rng.randomize()
	var y = rng.randi_range(position.y - pos.y, position.y + pos.y)
	objects.spawn_ulti_bul(Main.ultimate_bullet_preset, Main.ultimate_anim_pos, Vector2(x, y), Main.ultimate_preset[1], Main.ultimate_preset[4])
	last_ulti_bull_spawn = OS.get_ticks_msec()
	
func dash():
	pass
