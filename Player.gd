extends KinematicBody2D

const BLOCK_SIZE = 16

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var move_speed = 5 * BLOCK_SIZE

onready var _gun = $LaserGun

var _velocity : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("go_right") - Input.get_action_strength("go_left")
	direction.y = Input.get_action_strength("go_down") - Input.get_action_strength("go_up")

	_velocity = direction.normalized() * move_speed

	move_and_slide(_velocity)

	if Input.is_action_just_pressed("fire"):
		_gun.fire()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
