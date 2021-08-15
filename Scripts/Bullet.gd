extends KinematicBody2D

onready var shape = get_node("CollisionShape2D")
onready var sprite = get_node("Animated sprite")

var direction
var collide_info
var collided_obj = null
var max_dist
var pos
var speed
var damage
var power

var texture
var frames_count
var frame_size
var anim_preset

var need_del = false
var is_hit = false

func _ready():
	sprite.load_preset(anim_preset, frames_count, texture)
	sprite.scale = Vector2(frame_size, frame_size)
	sprite.change_anim("prepare")
	transform.x *= -1

func step():
	sprite.step()
	play_anim()
	if sprite.get_anim() == "hit":
		return
	collide_info = move_and_collide(direction * speed)
	if collide_info:
		is_hit = true
		collided_obj = collide_info.collider
		
	if collided_obj != null and (collided_obj.get_parent() != null and collided_obj.get_parent().name == "Enemy list" or collided_obj.name == "Player"):
		collided_obj.get_hit(damage)
			
	var dist_delt = global_position - pos
	if dist_delt.length() > max_dist:
		need_del = true
		
func play_anim():
	if sprite.get_anim() == "fly" and is_hit:
		sprite.change_anim("hit")
			
	if sprite.is_anim_ended:
		if sprite.get_anim() == "prepare":
			sprite.change_anim("fly")
		if sprite.get_anim() == "hit":
			need_del = true
	

func set_parameters(dir, anim_preset, preset, type):
	self.anim_preset = anim_preset
	texture = load("res://Sprites/bullets/"+type+".png")
	pos = transform.origin
	direction = dir
	speed = preset[0]
	max_dist = preset[1]
	damage = preset[2]
	power = preset[3]
	frames_count = preset[4]
	frame_size = preset[5]

func set_shape(size):
	shape.shape.extents = size
	pass

