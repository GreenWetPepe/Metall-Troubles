extends Node2D

onready var sprite = get_node("Animated sprite")

var target = null
var effect_ended = false

var anim_preset
var preset
var texture

func _ready():
	sprite.load_preset(anim_preset, preset[1], texture)
	sprite.set_scale(preset[2])
	sprite.set_repeat_count(3)
	sprite.change_anim("heal")

func set_target(targ):
	target = targ
	target.is_healing = true

func step():
	sprite.step()
	transform.origin = target.get_global_position()
	if sprite.is_anim_ended:
		effect_ended = true
		
func load_preset(anim_pres, pres, tex):
	anim_preset = anim_pres
	preset = pres
	texture = tex
