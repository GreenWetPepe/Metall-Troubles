extends Node2D

var is_level_completed = false

onready var door = get_node("StaticBody2D/Door")
onready var vorota = get_node("Door")

var waves = Main.waves_types[Main.now_level]

var rng = RandomNumberGenerator.new()

func _ready():
	vorota.load_anim_preset([["open", 0, 10, 200]])

func step(enemies_count):
	if vorota.get_anim() != null:
		vorota.step()
	if enemies_count == 0 and waves[0] + waves[1] != 0:
		return spawn_wave()
	elif not is_level_completed and enemies_count == 0 and waves[0] + waves[1] == 0 and not is_level_completed:
		level_completed()
	elif is_level_completed and vorota.is_anim_ended:
		door.disabled = true
		
func spawn_wave():
	print("Spawn wave")
	rng.randomize()
	var wave_type = rng.randi() % (waves[0] + waves[1])
	rng.randomize()
	var wave
	if wave_type < waves[0]:
		wave = Main.normal_waves[rng.randi() % len(Main.normal_waves)]
		waves[0] -= 1
	else:
		wave = Main.hard_waves[rng.randi() % len(Main.hard_waves)]
		waves[1] -= 1
	return wave

func level_completed():
	vorota.change_anim("open")
	is_level_completed = true
	print("Completed")
