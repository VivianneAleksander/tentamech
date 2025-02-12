@icon("res://assets/icons/mouse_follow_behavior.svg")
extends Node
class_name MouseFollowControl

@onready var viewport := get_viewport()

@export var enabled : bool = true
@export var target : AreaCharacter3D
@export var acceleration : float = 10
@export var movement_deadzone : float = 0.015

## Direction is -1 for left, 1 for right, 0 while still.
var direction : int = 0

func _physics_process(delta):
	if not enabled: return
	var camera := viewport.get_camera_3d()
	var mouse_position := viewport.get_mouse_position()
	var world_position := camera.project_position(mouse_position, camera.global_position.z)

	var distance = world_position.x - target.global_position.x
	if abs(distance) <= movement_deadzone:
		direction = 0
	else:
		direction = sign(distance)
	
	target.velocity = (world_position - target.global_position) * acceleration * delta

func set_enabled(value : bool) -> void:
	enabled = value
	target.velocity = Vector3.ZERO
