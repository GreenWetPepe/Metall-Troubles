extends Node

var directions = ["_right", "_left"]

						#///////GAME\\\\\\\#

var cursor = load("Sprites/Arr.png")
var cursor_size = Vector2(64, 64)

var now_level = 0
var room_size = [100, 100, 2700, 1600]

var list_of_looped_anims = ["walk", "fly", "stay", "fire"]

# heavy, normal, light, healer, mage
# var normal_waves = [[0, 3, 0, 0, 0], [0, 2, 2, 0, 0], [0, 3, 0, 0, 1], [1, 2, 0, 0, 0]]
var normal_waves = [[0, 1, 1, 0, 2]]
var hard_waves = [[1, 3, 0, 0, 1], [2, 0, 3, 1, 0], [0, 5, 3, 2, 0], [0, 2, 0, 2, 5]]
# normal waves, hard waves
var waves_types = [[0, 0], [2, 1], [3, 1], [2, 2], [2, 3], [4, 2], [4, 3], [0, 5]]

						#///////PLAYER\\\\\\\#

# hp, speed, frames count
var player_preset = [8, 400, 7]

# frames count, scale, animation step delt, size, indent
var hp_preset = [5, 1.4, 400, 128, 20]

# animation's name, start frame, end frame, animation step delt
var player_anim_pos = [["walk", 0, 1, 140], ["stay", 2, 2, 1000], ["ultimate", 3, 6, 100 ]]

						#///////ENEMY\\\\\\\#

var normal_enemy_attack_cooldown = 600

# hp, speed, damage, attack speed, ray scale, body scale, texture scale, frames count
var heavy_enemy_preset = [15, 70, 2, 1000, 2, 2, 1.8, 12]
var normal_enemy_preset = [4, 140, 1, 750, 1, 1, 1.8, 12]
var light_enemy_preset = [1, 320, 0, 500, 0.4, 0.6, 1.6, 7]
var healer_enemy_preset = [6, 100, 2, 1000, 1, 1, 1.8, 12]
var mage_enemy_preset = [5, 200, 2, 3000, 4, 1, 1.8, 11]

# animation's name, start frame, end frame, animation step delt
var heavy_enemy_anim_pos = []
var normal_enemy_anim_pos = [["attack", 0, 6, 80], ["walk", 7, 8, 160], ["dead", 9, 11, 140]]
var light_enemy_anim_pos = [["walk", 0, 1, 100], ["dead", 6, 6, 1000]]
var healer_enemy_anim_pos = []
var mage_enemy_anim_pos = [["walk", 0, 1, 160], ["attack", 2, 6, 100], ["dead", 7, 10, 140]]

# scale, power, damage
var light_enemy_explosion = [3.5, 100, 2]

						#///////WEAPON\\\\\\\#

# bullet count, accuracy, fire speed, anim_speed, frames count
var pistol_preset = [1, 0, 700, 100, 3]
var rifle_preset = [1, PI / 36, 100, 100, 3]
var shotgun_preset = [6, PI / 8, 400, 400, 4]
var weapon_list = ["pistol", "rifle", "shotgun"]

						#///////BULLET\\\\\\\#

# bullet speed, bullet range, damage, power, frames count, frame scale, body scale
var pistol_bullet_preset = [30, 1000, 1, 50, 5, 1.6, Vector2(1, 1)]
var rifle_bullet_preset = [30, 500, 1, 70, 5, 1.6, Vector2(1, 1)]
var shotgun_bullet_preset = [20, 300, 1, 200, 5, 1.6, Vector2(1, 1)]
var fireball_preset = [15, 1000, 1, 100, 13, 1.15, Vector2(1, 6)]

var bullet_anim_pos = [["prepare", 0, 0, 0], ["fly", 0, 2, 60], ["hit", 3, 4, 100]]
var fireball_anim_pos = [["prepare", 0, 3, 25], ["fly", 4, 6, 60], ["hit", 7, 12, 20]]

						#///////SKILLS\\\\\\\#

# bullet count, angle, accuracy, fire speed, path len
var ultimate_preset = [20, -PI / 4, Vector2(100, 100), 30, 500]
#speed, damage, power, attack delay, fire time, frames count, scale
var ultimate_bullet_preset = [20, 1, 0, 500, 8000, 10, 4]

var ultimate_anim_pos = [["fly", 0, 2, 60], ["hit", 3, 5, 60], ["fire", 6, 9, 60]]

						#///////OBJECTS\\\\\\\#

# frames count, scale, animation step delt
var torch_preset = [6, 2, 100]
var explosion_anim_preset = [0, 4, 40]

func _ready():
	Input.set_custom_mouse_cursor(cursor)
	
func get_preset(name): 
	return get(name)
