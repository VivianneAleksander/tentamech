extends Node
class_name SpeedCap

@export var primary : AreaCharacter3D
@export var max_speed : float = 5.0

func _ready():
	process_physics_priority = 2

func _physics_process(delta):
	if not primary: return

	if primary.velocity.length() > max_speed:
		primary.velocity = primary.velocity.normalized() * max_speed

