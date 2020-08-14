extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(PackedScene) var bullet
export var heat_threshold = 100.0
export var heat_per_shot = 11.0
export var heat_drain_rate = 11.0
export var overheat_drain_rate = 33.0

onready var bullet_spawn = $bulletSpawn
onready var _shoot_timer = $ShootTimer

var heat_bar : ProgressBar

var _shots_left_in_burst = 3
var _heat = 0.0

var is_overheated = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fire():
	if not is_overheated:
		_shoot_timer.start()


func _shoot():
	var b = bullet.instance()
	b.global_position = bullet_spawn.global_position
	b.velocity = 16.0*20 * Vector2.RIGHT
	get_tree().root.add_child(b)

	_heat += heat_per_shot

	if _heat > heat_threshold:
		overheat()

func _physics_process(delta):
	heat_bar.value = _heat
	if not is_overheated and _heat > 0:
		_heat -= heat_drain_rate * delta

	if is_overheated:
		_heat -= overheat_drain_rate * delta
		if _heat < 0:
			is_overheated = false
			heat_bar.modulate = Color.white

func overheat():
	print("overheated!")
	is_overheated = true
	_shoot_timer.stop()
	heat_bar.modulate = Color.red


func _on_ShootTimer_timeout():
	if _shots_left_in_burst > 0:
		_shoot()
		_shots_left_in_burst -= 1
	else:
		_shoot_timer.stop()
		_shots_left_in_burst = 3
