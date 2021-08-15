extends Node2D

var is_level_completed = false

onready var door = get_node("StaticBody2D/Door")

var waves = Main.waves_types[Main.now_level]

var rng = RandomNumberGenerator.new()

func step(enemies_count):
	if enemies_count == 0 and waves[0] + waves[1] != 0:
		return spawn_wave()
	elif not is_level_completed and enemies_count == 0 and waves[0] + waves[1] == 0:
		level_completed()
		
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
	door.disabled = true
	is_level_completed = true
	print("Completed")
